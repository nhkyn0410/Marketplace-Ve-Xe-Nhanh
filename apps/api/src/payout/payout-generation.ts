import { listOperatorsWithEligibleEntries, withOperatorTenant } from "../database/finance-scope";
import type { DbTransaction, PrismaService } from "../database/prisma.service";
import { EscrowEntryType, PayoutStatus } from "../database/prisma.types";

// Tạo kỳ chi trả T+3 (TASK-BTP-006, ADR-022, LLD §6.6 bước 1–3): job BullMQ hằng ngày 00:00 giờ VN, concurrency 1. Mỗi nhà
// xe: gom bút toán escrow đã đủ điều kiện (giờ đến dự kiến + T ngày), chưa thuộc kỳ nào, bỏ qua booking còn hoàn tiền treo
// (SRS §17.10 ON_HOLD — không chi phần sắp phải hoàn). Thực chi > 0 mới tạo kỳ; ≤ 0 để dồn kỳ sau. Idempotent theo
// (nhà xe, ngày) + khóa advisory theo nhà xe.

export const PAYOUT_JOB = "payout-generation";
/** 00:00 giờ VN mỗi ngày (LLD §6.6). */
export const PAYOUT_SCHEDULE = { pattern: "0 0 * * *", tz: "Asia/Ho_Chi_Minh" } as const;
const VN_OFFSET_MS = 7 * 3_600_000;
/** Hoàn tiền còn treo → giữ bút toán của booking đó lại. */
const OPEN_REFUND = ["REQUESTED", "APPROVED", "PROCESSING", "FAILED"];

export type PayoutRun = { created: number; existing: number; empty: number };

type EligibleRow = { id: string; entryType: EscrowEntryType; amount: bigint; bookingId: string | null; tripId: string | null; rate: number | null };

/** Ngày theo giờ VN dạng `2026-10-18`. */
export function vnDate(at: Date): string {
  return new Date(at.getTime() + VN_OFFSET_MS).toISOString().slice(0, 10);
}

export async function generatePayouts(prisma: Pick<PrismaService, "withSystem" | "withTenant">, now: Date = new Date()): Promise<PayoutRun> {
  const run: PayoutRun = { created: 0, existing: 0, empty: 0 };
  const period = vnDate(now);
  for (const operatorId of await listOperatorsWithEligibleEntries(prisma, now)) {
    const outcome = await withOperatorTenant(prisma, operatorId, (tx) => generateFor(tx, operatorId, period, now));
    run[outcome] += 1;
  }
  return run;
}

async function generateFor(tx: DbTransaction, operatorId: string, period: string, now: Date): Promise<keyof PayoutRun> {
  await tx.$executeRaw`SELECT pg_advisory_xact_lock(hashtext(${`payout:${operatorId}`}))`;
  if (await tx.payout.findFirst({ where: { operatorId, period: new Date(period) }, select: { id: true } })) {
    return "existing";
  }
  const entries = await tx.$queryRaw<EligibleRow[]>`
    SELECT e.id, e.entry_type::text AS "entryType", e.amount, e.booking_id AS "bookingId", e.trip_id AS "tripId",
      e.commission_rate_bps AS "rate"
    FROM escrow_ledgers e
    -- BR-32: chuyến đã hoàn thành thực tế (TASK-EMP-002) → mốc = giờ hoàn thành + chu kỳ; chưa có → mốc trên sổ.
    LEFT JOIN trips t ON t.id = e.trip_id AND t.operator_id = e.operator_id
    WHERE e.operator_id = ${operatorId} AND COALESCE(t.payout_eligible_at, e.eligible_at) <= ${now} AND e.entry_type <> 'PAYOUT'
      AND NOT EXISTS (SELECT 1 FROM payout_items i WHERE i.ledger_entry_id = e.id)
      AND NOT EXISTS (
        SELECT 1 FROM refunds r JOIN payments pm ON pm.id = r.payment_id AND pm.operator_id = r.operator_id
        WHERE r.booking_id = e.booking_id AND r.operator_id = e.operator_id AND r.status::text = ANY(${OPEN_REFUND})
          AND pm.status <> 'RECONCILING'
      )
    ORDER BY e.created_at, e.id`;
  const sum = (types: EscrowEntryType[]) => entries.filter((entry) => types.includes(entry.entryType)).reduce((total, entry) => total + entry.amount, 0n);
  const gross = sum([EscrowEntryType.PAYMENT_CAPTURED]);
  const commission = -sum([EscrowEntryType.COMMISSION, EscrowEntryType.COMMISSION_REVERSAL]);
  const refund = -sum([EscrowEntryType.REFUND]);
  const adjustment = sum([EscrowEntryType.ADJUSTMENT]);
  const amount = gross - commission - refund + adjustment;
  if (amount <= 0n) {
    return "empty";
  }
  const rates = new Set(entries.filter((entry) => entry.entryType === EscrowEntryType.COMMISSION).map((entry) => entry.rate));
  const bank = await tx.bankAccount.findFirst({
    where: { operatorId, status: "VERIFIED" },
    orderBy: [{ reviewedAt: "desc" }, { createdAt: "desc" }],
    select: { bankName: true, accountNumber: true, accountHolder: true },
  });
  const [{ seq }] = await tx.$queryRaw<{ seq: bigint }[]>`SELECT nextval('payout_code_seq') AS seq`;
  // Giờ thật của lúc tạo kỳ (`now` là mốc xét đủ điều kiện + ngày kỳ — trùng giờ thật khi job chạy theo lịch).
  const createdAt = new Date();
  const status = bank ? PayoutStatus.PENDING_REVIEW : PayoutStatus.ON_HOLD;
  const holdReason = bank ? null : "Chưa có tài khoản nhận tiền đã xác minh.";
  await tx.payout.create({
    data: {
      payoutCode: `PO-${period.replace(/-/g, "")}-${String(seq).padStart(3, "0")}`,
      operatorId,
      period: new Date(period),
      status,
      grossAmount: gross,
      commissionAmount: commission,
      refundAmount: refund,
      adjustmentAmount: adjustment,
      amount,
      commissionRateBps: rates.size === 1 ? [...rates][0]! : null,
      holdReason,
      bankName: bank?.bankName ?? null,
      bankAccountNumber: bank?.accountNumber ?? null,
      bankAccountHolder: bank?.accountHolder ?? null,
      createdAt,
      items: {
        create: entries.map((entry) => ({ ledgerEntryId: entry.id, entryType: entry.entryType, amount: entry.amount, bookingId: entry.bookingId, tripId: entry.tripId })),
      },
      histories: {
        create: [
          { toStatus: PayoutStatus.PENDING_REVIEW, reason: "Tạo kỳ chi trả.", actor: "system", createdAt },
          ...(bank ? [] : [{ fromStatus: PayoutStatus.PENDING_REVIEW, toStatus: PayoutStatus.ON_HOLD, reason: holdReason, actor: "system", createdAt: new Date(createdAt.getTime() + 1) }]),
        ],
      },
    },
  });
  return "created";
}
