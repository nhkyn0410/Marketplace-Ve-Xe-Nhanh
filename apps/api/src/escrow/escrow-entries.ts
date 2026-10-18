import type { DbTransaction } from "../database/prisma.service";
import { EscrowEntryType, PolicyRuleStatus } from "../database/prisma.types";

// Ghi sổ escrow (TASK-BTP-006, FR-BTP-15/16, BR-30/31, ADR-005, LLD §6.3 bước 3): gọi TRONG transaction ghi nhận thanh toán
// thành công / hoàn tiền thành công. Sổ chỉ ghi thêm; mỗi payment / refund một bút toán mỗi loại (partial unique) nên chạy
// lặp không ghi trùng. Tiền BIGINT; hoa hồng làm tròn XUỐNG tới đồng.

/** Mức hoa hồng mặc định khi Admin chưa cấu hình (BR-31: 5%). */
export const DEFAULT_COMMISSION_BPS = 500;
/** Chu kỳ chi trả mặc định khi chưa có chính sách chi trả (ADR-022: T+3). */
export const DEFAULT_PAYOUT_DELAY_DAYS = 3;
const DAY_MS = 86_400_000;

/** Hoa hồng (đồng) của một số tiền theo mức ‱, làm tròn xuống. */
export function commissionOf(amount: bigint, rateBps: number): bigint {
  if (!Number.isInteger(rateBps) || rateBps < 0 || rateBps > 10_000) {
    throw new Error(`Mức hoa hồng không hợp lệ: ${rateBps}`);
  }
  return (amount * BigInt(rateBps)) / 10_000n;
}

/** Mức hoa hồng áp dụng cho nhà xe lúc `at`: mức riêng đang hiệu lực, không có thì mặc định nền tảng, không có nữa thì 5%. */
export async function commissionRateAt(tx: DbTransaction, operatorId: string, at: Date): Promise<number> {
  const rules = await tx.commissionRule.findMany({
    where: {
      OR: [{ operatorId }, { operatorId: null }],
      status: PolicyRuleStatus.ACTIVE,
      effectiveFrom: { lte: at },
      AND: [{ OR: [{ effectiveTo: null }, { effectiveTo: { gt: at } }] }],
    },
    orderBy: { effectiveFrom: "desc" },
    select: { operatorId: true, rateBps: true },
  });
  return (rules.find((rule) => rule.operatorId === operatorId) ?? rules.find((rule) => rule.operatorId === null))?.rateBps ?? DEFAULT_COMMISSION_BPS;
}

/** Số ngày từ lúc chuyến đến nơi tới lúc tiền đủ điều kiện chi trả, theo chính sách chi trả đang áp dụng. */
export async function payoutDelayDays(tx: DbTransaction, at: Date): Promise<number> {
  const policy = await tx.policyVersion.findFirst({
    where: { type: "PAYOUT", operatorId: null, status: "PUBLISHED", effectiveFrom: { lte: at } },
    orderBy: { effectiveFrom: "desc" },
    select: { rules: true },
  });
  const days = (policy?.rules as { delayDays?: unknown } | undefined)?.delayDays;
  return typeof days === "number" && Number.isInteger(days) && days > 0 ? days : DEFAULT_PAYOUT_DELAY_DAYS;
}

/**
 * Thanh toán thành công: `PAYMENT_CAPTURED` (+ tổng khách trả) và `COMMISSION` (− hoa hồng trên giá vé). Đủ điều kiện chi trả
 * từ giờ đến dự kiến của chuyến + T ngày (ADR-022, SRS §17.10 "T+3 từ lúc chuyến hoàn thành").
 */
export async function recordCapture(
  tx: DbTransaction,
  operatorId: string,
  capture: { bookingId: string; tripId: string; paymentId: string; total: bigint; ticketRevenue: bigint; arrivalAt: Date },
  now: Date,
): Promise<void> {
  // Tuần tự: một transaction là một kết nối, không chạy truy vấn song song.
  const rateBps = await commissionRateAt(tx, operatorId, now);
  const delayDays = await payoutDelayDays(tx, now);
  const eligibleAt = new Date(capture.arrivalAt.getTime() + delayDays * DAY_MS);
  const base = { operatorId, bookingId: capture.bookingId, tripId: capture.tripId, paymentId: capture.paymentId, eligibleAt, createdBy: "system", createdAt: now };
  await tx.escrowLedger.create({ data: { ...base, entryType: EscrowEntryType.PAYMENT_CAPTURED, amount: capture.total } });
  const commission = commissionOf(capture.ticketRevenue, rateBps);
  if (commission > 0n) {
    await tx.escrowLedger.create({ data: { ...base, entryType: EscrowEntryType.COMMISSION, amount: -commission, commissionRateBps: rateBps } });
  }
}

/**
 * Hoàn tiền thành công: `REFUND` (− tiền đã hoàn) và `COMMISSION_REVERSAL` (+ hoa hồng trên phần đã hoàn, cùng mức lúc thu).
 * Cùng mốc đủ điều kiện với bút toán thu tiền — vé đã chi ở kỳ trước thì phần âm vào kỳ kế tiếp.
 */
export async function recordRefund(
  tx: DbTransaction,
  operatorId: string,
  refund: { refundId: string; bookingId: string; amount: bigint },
  now: Date,
): Promise<void> {
  const captured = await tx.escrowLedger.findMany({
    where: { operatorId, bookingId: refund.bookingId, entryType: { in: [EscrowEntryType.PAYMENT_CAPTURED, EscrowEntryType.COMMISSION] } },
    select: { entryType: true, tripId: true, eligibleAt: true, commissionRateBps: true },
  });
  const capture = captured.find((entry) => entry.entryType === EscrowEntryType.PAYMENT_CAPTURED);
  const rateBps = captured.find((entry) => entry.entryType === EscrowEntryType.COMMISSION)?.commissionRateBps ?? 0;
  const base = { operatorId, bookingId: refund.bookingId, tripId: capture?.tripId ?? null, refundId: refund.refundId, eligibleAt: capture?.eligibleAt ?? now, createdBy: "system", createdAt: now };
  await tx.escrowLedger.create({ data: { ...base, entryType: EscrowEntryType.REFUND, amount: -refund.amount } });
  const reversal = commissionOf(refund.amount, rateBps);
  if (reversal > 0n) {
    await tx.escrowLedger.create({ data: { ...base, entryType: EscrowEntryType.COMMISSION_REVERSAL, amount: reversal, commissionRateBps: rateBps } });
  }
}
