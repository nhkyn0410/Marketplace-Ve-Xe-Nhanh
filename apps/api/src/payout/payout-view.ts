import type { DbTransaction } from "../database/prisma.service";
import { BankAccountStatus, PaymentStatus } from "../database/prisma.types";
import { vndToJson } from "../fare/fare-pricing";
import type { PayoutDetail, PayoutSummary } from "./dto/payout.dto";

// Dựng dữ liệu kỳ chi trả cho màn Admin (ADM-002) và màn Tài chính của nhà xe (OPR-002) — cùng một cách tính, khác cách hiển
// thị người thao tác. Chạy trong transaction có scope sẵn (platform / tenant); RLS lo phạm vi.

/** Hoàn tiền còn treo của booking trong kỳ → chưa được chi (SRS §17.10). */
const OPEN_REFUND = ["REQUESTED", "APPROVED", "PROCESSING", "FAILED"] as const;

export const PAYOUT_SELECT = {
  id: true,
  payoutCode: true,
  operatorId: true,
  period: true,
  status: true,
  grossAmount: true,
  commissionAmount: true,
  refundAmount: true,
  adjustmentAmount: true,
  amount: true,
  commissionRateBps: true,
  holdReason: true,
  bankName: true,
  bankAccountNumber: true,
  bankAccountHolder: true,
  paidAt: true,
  createdAt: true,
  operator: { select: { displayName: true } },
} as const;

type PayoutRow = {
  id: string;
  payoutCode: string;
  operatorId: string;
  period: Date;
  status: PayoutSummary["status"];
  grossAmount: bigint;
  commissionAmount: bigint;
  refundAmount: bigint;
  adjustmentAmount: bigint;
  amount: bigint;
  commissionRateBps: number | null;
  holdReason: string | null;
  bankName: string | null;
  bankAccountNumber: string | null;
  bankAccountHolder: string | null;
  paidAt: Date | null;
  createdAt: Date;
  operator: { displayName: string };
};

/** `0071000124521` → `•••• 4521`. */
export function maskAccountNumber(value: string): string {
  return `•••• ${value.slice(-4)}`;
}

/** Tiền có dấu (hoa hồng ròng / điều chỉnh có thể âm) ra số nguyên JSON. */
function signedJson(value: bigint): number {
  return value < 0n ? -vndToJson(-value) : vndToJson(value);
}

export function toPayoutSummary(row: PayoutRow): PayoutSummary {
  return {
    payoutId: row.id,
    payoutCode: row.payoutCode,
    operatorId: row.operatorId,
    operatorName: row.operator.displayName,
    period: row.period.toISOString().slice(0, 10),
    status: row.status,
    grossAmount: vndToJson(row.grossAmount),
    commissionAmount: signedJson(row.commissionAmount),
    refundAmount: vndToJson(row.refundAmount),
    adjustmentAmount: signedJson(row.adjustmentAmount),
    amount: vndToJson(row.amount),
    commissionRateBps: row.commissionRateBps,
    holdReason: row.holdReason,
    bank:
      row.bankName && row.bankAccountNumber && row.bankAccountHolder
        ? { bankName: row.bankName, accountNumberMasked: maskAccountNumber(row.bankAccountNumber), accountHolder: row.bankAccountHolder }
        : null,
    paidAt: row.paidAt?.toISOString() ?? null,
    createdAt: row.createdAt.toISOString(),
  };
}

/** Kiểm tra trước khi chi (Figma ADM-08b): sổ khớp, không còn hoàn tiền treo, tài khoản nhận tiền vẫn đã xác minh. */
export async function payoutChecks(tx: DbTransaction, payoutId: string): Promise<PayoutDetail["checks"]> {
  const payout = await tx.payout.findUniqueOrThrow({
    where: { id: payoutId },
    select: { operatorId: true, amount: true, bankAccountNumber: true, items: { select: { amount: true, bookingId: true } } },
  });
  const itemTotal = payout.items.reduce((sum, item) => sum + item.amount, 0n);
  const bookingIds = [...new Set(payout.items.map((item) => item.bookingId).filter((id): id is string => id !== null))];
  const pending =
    bookingIds.length === 0
      ? 0
      : await tx.refund.count({ where: { bookingId: { in: bookingIds }, status: { in: [...OPEN_REFUND] }, payment: { status: { not: PaymentStatus.RECONCILING } } } });
  const bank = payout.bankAccountNumber
    ? await tx.bankAccount.count({ where: { operatorId: payout.operatorId, accountNumber: payout.bankAccountNumber, status: BankAccountStatus.VERIFIED } })
    : 0;
  return { ledgerMatches: payout.items.length > 0 && itemTotal === payout.amount, noPendingRefunds: pending === 0, bankVerified: bank > 0 };
}

/** Chi tiết kỳ: tổng theo chuyến + kiểm tra + tiến trình; `actorName` đổi `actor` lưu trong lịch sử thành chữ hiển thị. */
export async function loadPayoutDetail(
  tx: DbTransaction,
  payoutId: string,
  actorName: (actor: string | null) => Promise<string | null> | string | null,
): Promise<PayoutDetail | null> {
  const row = await tx.payout.findUnique({
    where: { id: payoutId },
    select: {
      ...PAYOUT_SELECT,
      bankReference: true,
      transferredAt: true,
      confirmationNote: true,
      cancelReason: true,
      items: { select: { entryType: true, amount: true, bookingId: true, tripId: true } },
      histories: { orderBy: { createdAt: "asc" }, select: { fromStatus: true, toStatus: true, reason: true, actor: true, createdAt: true } },
    },
  });
  if (!row) {
    return null;
  }
  const tripIds = [...new Set(row.items.map((item) => item.tripId).filter((id): id is string => id !== null))];
  const trips = tripIds.length
    ? await tx.trip.findMany({ where: { id: { in: tripIds } }, select: { id: true, departureAt: true, route: { select: { name: true } }, vehicle: { select: { plateNumber: true } } } })
    : [];
  const groups = new Map<string | null, { bookings: Set<string>; gross: bigint; commission: bigint; other: bigint }>();
  for (const item of row.items) {
    const group = groups.get(item.tripId) ?? { bookings: new Set<string>(), gross: 0n, commission: 0n, other: 0n };
    if (item.bookingId) group.bookings.add(item.bookingId);
    if (item.entryType === "PAYMENT_CAPTURED" || item.entryType === "PLATFORM_FUNDED_DISCOUNT") group.gross += item.amount;
    else if (item.entryType === "COMMISSION" || item.entryType === "COMMISSION_REVERSAL") group.commission -= item.amount;
    else group.other += item.amount;
    groups.set(item.tripId, group);
  }
  const tripRows = [...groups.entries()]
    .map(([tripId, group]) => {
      const trip = trips.find((candidate) => candidate.id === tripId);
      return {
        tripId,
        departureAt: trip?.departureAt.toISOString() ?? null,
        routeName: trip?.route.name ?? null,
        vehiclePlateNumber: trip?.vehicle?.plateNumber ?? null,
        bookingCount: group.bookings.size,
        grossAmount: vndToJson(group.gross),
        commissionAmount: signedJson(group.commission),
        refundAdjustmentAmount: signedJson(group.other),
        amount: signedJson(group.gross - group.commission + group.other),
      };
    })
    .sort((a, b) => (a.departureAt ?? "9").localeCompare(b.departureAt ?? "9"));
  const histories = [];
  for (const history of row.histories) {
    histories.push({ ...history, actor: await actorName(history.actor), createdAt: history.createdAt.toISOString() });
  }
  return {
    ...toPayoutSummary(row),
    trips: tripRows,
    checks: await payoutChecks(tx, payoutId),
    bankReference: row.bankReference,
    transferredAt: row.transferredAt?.toISOString() ?? null,
    confirmationNote: row.confirmationNote,
    cancelReason: row.cancelReason,
    histories,
  };
}
