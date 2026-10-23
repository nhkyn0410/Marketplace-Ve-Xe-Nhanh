// Logic thuần của màn Chi trả nhà xe (Figma ADM-08a–c; TASK-ADM-002): nhãn trạng thái, thao tác chính của từng dòng, kiểm
// tra trước khi chi, câu lỗi.
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { describeReauthError } from "@vexenhanh/ui/lib/auth/reauth";

import type { PayoutDetail, PayoutStatus, PayoutSummary } from "./payout-api";

export type Tone = "success" | "warning" | "danger" | "neutral";

export const PAYOUT_STATUS: Record<PayoutStatus, { label: string; tone: Tone }> = {
  PENDING_REVIEW: { label: "Chờ rà soát", tone: "warning" },
  ON_HOLD: { label: "Đang giữ lại", tone: "danger" },
  READY_TO_TRANSFER: { label: "Sẵn sàng chuyển khoản", tone: "success" },
  TRANSFERRING: { label: "Đang chuyển khoản", tone: "neutral" },
  PAID: { label: "Đã chi trả", tone: "success" },
  FAILED: { label: "Thất bại", tone: "danger" },
  CANCELLED: { label: "Đã hủy", tone: "neutral" }
};

export const PAYOUT_STATUS_ORDER: PayoutStatus[] = ["PENDING_REVIEW", "READY_TO_TRANSFER", "ON_HOLD", "TRANSFERRING", "PAID", "FAILED", "CANCELLED"];

/** Chữ của liên kết cuối dòng (Figma ADM-08a): việc cần làm tiếp, không thì "Xem". */
export function rowAction(status: PayoutStatus): string {
  switch (status) {
    case "PENDING_REVIEW":
      return "Rà soát";
    case "READY_TO_TRANSFER":
    case "TRANSFERRING":
      return "Xác nhận";
    case "FAILED":
      return "Xử lý";
    default:
      return "Xem";
  }
}

/** `2026-10-13` → `13/10/2026`. */
export function periodLabel(period: string): string {
  const [year, month, day] = period.split("-");
  return `${day}/${month}/${year}`;
}

/** Cột "Tài khoản nhận": `Vietcombank •• 4521` hoặc chưa có. */
export function bankLabel(bank: PayoutSummary["bank"]): string {
  return bank ? `${bank.bankName} •• ${bank.accountNumberMasked.slice(-4)}` : "Chưa có tài khoản xác minh";
}

/** `400` ‱ → `4%`; `null` (nhiều mức) → rỗng. */
export function rateLabel(rateBps: number | null): string {
  return rateBps === null ? "" : `${(rateBps / 100).toLocaleString("vi-VN", { maximumFractionDigits: 2 })}%`;
}

/** Tiền âm có dấu trừ: `-28.000 ₫`. */
export function signedVnd(amount: number, format: (value: number) => string): string {
  return amount === 0 ? format(0) : `${amount < 0 ? "-" : ""}${format(Math.abs(amount))}`;
}

/** Danh sách "Kiểm tra trước khi chi" (Figma ADM-08b). */
export function checkItems(checks: PayoutDetail["checks"]): { label: string; ok: boolean }[] {
  return [
    { label: "Số liệu khớp sổ giữ hộ", ok: checks.ledgerMatches },
    { label: "Không có hoàn tiền đang treo", ok: checks.noPendingRefunds },
    { label: "Tài khoản nhận tiền đã xác minh", ok: checks.bankVerified }
  ];
}

const CHECK_REASON: Record<string, string> = {
  LEDGER_MISMATCH: "số liệu lệch sổ giữ hộ",
  PENDING_REFUNDS: "còn hoàn tiền đang treo",
  BANK_NOT_VERIFIED: "tài khoản nhận tiền chưa xác minh"
};

export type PayoutError = { message: string; field?: "identity" | "transferredAt"; refresh?: boolean };

/** Lỗi thao tác trên kỳ chi trả → câu báo + ô cần đánh dấu. */
export function describePayoutError(error: unknown): PayoutError {
  const identity = describeReauthError(error);
  if (identity) {
    return { message: identity, field: "identity" };
  }
  if (error instanceof ApiError) {
    switch (error.code) {
      case "PAYOUT_CHECKS_FAILED":
        return { message: `Chưa chi được: ${error.reasons.map((reason) => CHECK_REASON[reason] ?? reason).join(", ")}.`, refresh: true };
      case "PAYOUT_STATUS_INVALID":
        return { message: "Kỳ chi trả vừa đổi trạng thái. Tải lại trang để xem trạng thái mới.", refresh: true };
      case "PAYOUT_TRANSFER_TIME_INVALID":
        return { message: "Thời điểm chuyển khoản không được ở tương lai.", field: "transferredAt" };
      case "PAYOUT_NOT_FOUND":
        return { message: "Không tìm thấy kỳ chi trả. Tải lại trang.", refresh: true };
    }
    if (error.status === 503) {
      return { message: "Chưa ghi được nhật ký nên chưa thực hiện. Vui lòng thử lại." };
    }
  }
  return { message: "Chưa thực hiện được. Vui lòng kiểm tra kết nối và thử lại." };
}
