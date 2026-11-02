// Logic thuần của màn Tài chính (Figma "Nhà xe · Tài chính" 01–03; TASK-OPR-002): nhãn tình trạng tiền / kỳ chi trả, dòng mô
// tả chuyến, kỳ, phần trăm hoa hồng.
import { formatDay, toLocalParts } from "../trip/trip-format";
import type { FinanceBooking, FinanceState, PayoutStatus, PayoutSummary } from "./finance-api";

export type Tone = "success" | "warning" | "danger" | "neutral";

export const FINANCE_STATE: Record<FinanceState, { label: string; tone: Tone }> = {
  WAITING_TRIP: { label: "Chờ chuyến hoàn thành", tone: "neutral" },
  ON_HOLD: { label: "Đang hoàn tiền", tone: "warning" },
  ELIGIBLE: { label: "Đủ điều kiện", tone: "success" },
  IN_PAYOUT: { label: "Trong kỳ chi trả", tone: "neutral" },
  PAID: { label: "Đã chi trả", tone: "success" },
  REFUNDED: { label: "Đã hoàn tiền", tone: "neutral" }
};

export const FINANCE_STATE_ORDER: FinanceState[] = ["WAITING_TRIP", "ELIGIBLE", "IN_PAYOUT", "PAID", "ON_HOLD", "REFUNDED"];

export const PAYOUT_STATUS: Record<PayoutStatus, { label: string; tone: Tone }> = {
  PENDING_REVIEW: { label: "Chờ rà soát", tone: "warning" },
  ON_HOLD: { label: "Đang giữ lại", tone: "danger" },
  READY_TO_TRANSFER: { label: "Sẵn sàng chuyển khoản", tone: "success" },
  TRANSFERRING: { label: "Đang chuyển khoản", tone: "neutral" },
  PAID: { label: "Đã chi trả", tone: "success" },
  FAILED: { label: "Thất bại", tone: "danger" },
  CANCELLED: { label: "Đã hủy", tone: "neutral" }
};

export const PAYOUT_STATUS_ORDER: PayoutStatus[] = ["PENDING_REVIEW", "ON_HOLD", "READY_TO_TRANSFER", "TRANSFERRING", "PAID", "FAILED", "CANCELLED"];

/** Dòng phụ dưới chuyến: chưa khởi hành / đang chạy / đến nơi ngày … (giờ VN). */
export function tripProgress(trip: FinanceBooking["trip"], now: Date = new Date()): string {
  if (new Date(trip.departureAt) > now) {
    return "Chưa khởi hành";
  }
  if (new Date(trip.arrivalAt) > now) {
    return "Đang chạy";
  }
  return `Đến nơi ${formatDay(trip.arrivalAt).slice(0, 5)}`;
}

/** `2026-10-13` → `13/10/2026`. */
export function periodLabel(period: string): string {
  const [year, month, day] = period.split("-");
  return `${day}/${month}/${year}`;
}

/** Dòng phụ dưới kỳ: chuyến đến nơi trước ngày kỳ − T ngày. */
export function periodNote(period: string, delayDays: number): string {
  const cutoff = new Date(Date.parse(`${period}T00:00:00+07:00`) - delayDays * 86_400_000);
  const { date } = toLocalParts(cutoff.toISOString());
  return `Chuyến đến nơi trước ${periodLabel(date).slice(0, 5)}`;
}

/** `400` ‱ → `4%`, `450` → `4,5%`. */
export function rateLabel(rateBps: number | null): string {
  if (rateBps === null) {
    return "";
  }
  return `${(rateBps / 100).toLocaleString("vi-VN", { maximumFractionDigits: 2 })}%`;
}

/** Tiền âm hiện dấu trừ (hoa hồng, hoàn): `-28.000 ₫`; 0 thì `0 ₫`. */
export function signedVnd(amount: number, format: (value: number) => string): string {
  return amount === 0 ? format(0) : `${amount < 0 ? "-" : ""}${format(Math.abs(amount))}`;
}

/** "Hoàn / điều chỉnh" của kỳ = − hoàn tiền + điều chỉnh. */
export function refundAdjustment(payout: Pick<PayoutSummary, "refundAmount" | "adjustmentAmount">): number {
  return -payout.refundAmount + payout.adjustmentAmount;
}
