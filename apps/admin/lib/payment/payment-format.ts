// Logic thuần của màn Thanh toán & hoàn tiền (Figma ADM-07a–d; TASK-ADM-002): nhãn trạng thái, ghi chú dòng, dòng thời gian
// giao dịch, phân bổ số tiền, câu lỗi.
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { describeReauthError } from "@vexenhanh/ui/lib/auth/reauth";

import type { PaymentDetail, PaymentProvider, PaymentStatus, PaymentSummary, RefundSource, RefundStatus, RefundSummary } from "./payment-api";

export type Tone = "success" | "warning" | "danger" | "neutral";

export const PAYMENT_STATUS: Record<PaymentStatus, { label: string; tone: Tone }> = {
  INITIATED: { label: "Khởi tạo", tone: "neutral" },
  PROCESSING: { label: "Đang xử lý", tone: "warning" },
  SUCCESS: { label: "Thành công", tone: "success" },
  FAILED: { label: "Thất bại", tone: "neutral" },
  EXPIRED: { label: "Hết hạn", tone: "neutral" },
  CANCELLED: { label: "Đã hủy", tone: "neutral" },
  RECONCILING: { label: "Cần đối soát", tone: "danger" }
};
export const PAYMENT_STATUS_ORDER: PaymentStatus[] = ["SUCCESS", "PROCESSING", "RECONCILING", "INITIATED", "FAILED", "EXPIRED", "CANCELLED"];

export const REFUND_STATUS: Record<RefundStatus, { label: string; tone: Tone }> = {
  REQUESTED: { label: "Đã yêu cầu", tone: "warning" },
  APPROVED: { label: "Chờ gửi cổng", tone: "warning" },
  PROCESSING: { label: "Đang hoàn", tone: "neutral" },
  SUCCESS: { label: "Thành công", tone: "success" },
  FAILED: { label: "Thất bại", tone: "danger" },
  REJECTED: { label: "Bị từ chối", tone: "neutral" }
};
export const REFUND_STATUS_ORDER: RefundStatus[] = ["FAILED", "REQUESTED", "APPROVED", "PROCESSING", "SUCCESS", "REJECTED"];

export const PROVIDER_LABEL: Record<PaymentProvider, string> = { VNPAY: "VNPay", MOMO: "MoMo" };

export const REFUND_SOURCE: Record<RefundSource, string> = { CUSTOMER: "Khách hủy vé", OPERATOR: "Nhà xe hủy chuyến", PLATFORM: "Vé Xe Nhanh (đối soát)" };

/** Lý do cần đối soát (máy chủ ghi lúc nhận callback). */
const RECONCILE_REASON: Record<string, string> = {
  BOOKING_EXPIRED: "Đơn đã hết hạn giữ chỗ",
  BOOKING_CANCELLED: "Đơn đã hủy",
  SEATS_RELEASED: "Ghế đã nhả",
  DUPLICATE_PAYMENT: "Trả trùng cho cùng đơn",
  AMOUNT_MISMATCH: "Lệch số tiền"
};

export function reconcileReasonLabel(reason: string | null): string {
  return reason ? (RECONCILE_REASON[reason] ?? reason) : "Cần đối soát";
}

/** Ghi chú dưới nhãn trạng thái của dòng thanh toán (Figma ADM-07a "Callback đến trễ"). */
export function paymentNote(item: Pick<PaymentSummary, "status" | "reconcileReason" | "reconcileResolved" | "failureCode">): string | null {
  if (item.status === "RECONCILING") {
    return item.reconcileResolved ? "Đã tạo hoàn tiền" : reconcileReasonLabel(item.reconcileReason);
  }
  return item.status === "FAILED" && item.failureCode ? `Mã lỗi cổng ${item.failureCode}` : null;
}

/** Ghi chú dưới nhãn trạng thái của dòng hoàn tiền (Figma ADM-07c). */
export function refundNote(item: Pick<RefundSummary, "status" | "provider" | "failureCode">): string | null {
  const provider = PROVIDER_LABEL[item.provider];
  switch (item.status) {
    case "FAILED":
      return item.failureCode ? `Cổng ${provider} trả lỗi ${item.failureCode}` : `Cổng ${provider} trả lỗi`;
    case "PROCESSING":
      return `Đã gửi cổng ${provider}`;
    case "APPROVED":
      return "Đủ điều kiện, chờ gửi cổng";
    default:
      return null;
  }
}

/** Liên kết cuối dòng hoàn tiền: refund thất bại cần Admin xử lý. */
export function refundAction(status: RefundStatus): string {
  return status === "FAILED" ? "Xử lý" : "Xem";
}

/** `2026-10-08T07:12:00Z` → `08/10 · 14:12` (giờ VN). */
export function moment(iso: string): string {
  const [date, time] = new Date(new Date(iso).getTime() + 7 * 3_600_000).toISOString().split("T");
  return `${date!.slice(8, 10)}/${date!.slice(5, 7)} · ${time!.slice(0, 5)}`;
}

/** `2026-10-16T15:30:00Z` → `22:30 ngày 16/10/2026` (giờ VN). */
export function tripMoment(iso: string): string {
  const [date, time] = new Date(new Date(iso).getTime() + 7 * 3_600_000).toISOString().split("T");
  return `${time!.slice(0, 5)} ngày ${date!.slice(8, 10)}/${date!.slice(5, 7)}/${date!.slice(0, 4)}`;
}

const VND = new Intl.NumberFormat("vi-VN");
export const formatVnd = (amount: number) => `${VND.format(amount)} ₫`;

export type TimelineEvent = { at: string; title: string; detail: string | null; tone: "primary" | "success" | "muted"; future: boolean };

const PAYMENT_STEP: Partial<Record<PaymentStatus, string>> = {
  PROCESSING: "Chuyển khách sang cổng",
  FAILED: "Cổng báo thất bại",
  EXPIRED: "Hết hạn thanh toán",
  CANCELLED: "Hủy thanh toán"
};

/**
 * Dòng thời gian giao dịch (Figma ADM-07b), mới trước: tạo đơn → tạo thanh toán → các bước của cổng → ghi sổ giữ hộ → phát
 * hành vé → hoàn tiền → đủ điều kiện chi trả cho nhà xe (mốc tương lai thì đánh dấu dự kiến).
 */
export function paymentTimeline(detail: PaymentDetail, now: Date = new Date()): TimelineEvent[] {
  const provider = PROVIDER_LABEL[detail.provider];
  const events: TimelineEvent[] = [
    { at: detail.booking.createdAt, title: "Tạo đơn đặt vé", detail: `Giữ chỗ ${detail.booking.seatCodes.join(", ")}`, tone: "muted", future: false }
  ];
  for (const history of detail.histories) {
    if (history.fromStatus === null) {
      events.push({ at: history.createdAt, title: "Tạo thanh toán", detail: `Thanh toán qua ${provider}`, tone: "primary", future: false });
    } else if (history.toStatus === "RECONCILING") {
      events.push({ at: history.createdAt, title: "Chuyển cần đối soát", detail: reconcileReasonLabel(detail.reconcileReason), tone: "primary", future: false });
    } else if (history.toStatus === "SUCCESS") {
      events.push({ at: history.createdAt, title: `Cổng ${provider} xác nhận thành công`, detail: "Chữ ký hợp lệ · số tiền khớp đơn", tone: "primary", future: false });
    } else {
      events.push({ at: history.createdAt, title: PAYMENT_STEP[history.toStatus] ?? PAYMENT_STATUS[history.toStatus].label, detail: history.reason, tone: "primary", future: false });
    }
  }
  const capture = detail.ledger.find((entry) => entry.entryType === "PAYMENT_CAPTURED");
  if (capture && detail.allocation) {
    events.push({
      at: capture.createdAt,
      title: "Ghi sổ giữ hộ",
      detail: `Khách trả ${formatVnd(capture.amount)}; hoa hồng ${formatVnd(detail.allocation.commissionAmount)}`,
      tone: "primary",
      future: false
    });
  }
  if (detail.tickets.length > 0) {
    events.push({
      at: detail.tickets[0]!.issuedAt,
      title: `Phát hành ${detail.tickets.length} vé`,
      detail: detail.tickets.map((ticket) => ticket.ticketCode).join(", "),
      tone: "success",
      future: false
    });
  }
  for (const refund of detail.refunds) {
    events.push({ at: refund.createdAt, title: `Hoàn tiền ${refund.refundCode}`, detail: `${formatVnd(refund.amount)} · ${REFUND_STATUS[refund.status].label}`, tone: "primary", future: false });
  }
  if (capture) {
    events.push({
      at: capture.eligibleAt,
      title: "Đủ điều kiện chi trả cho nhà xe",
      detail: "Sau khi chuyến đến nơi và đủ chu kỳ chi trả",
      tone: "muted",
      future: Date.parse(capture.eligibleAt) > now.getTime()
    });
  }
  // Mới trước; cùng thời điểm thì bước sau (thêm sau) đứng trước.
  return events
    .map((event, index) => ({ event, index }))
    .sort((a, b) => Date.parse(b.event.at) - Date.parse(a.event.at) || b.index - a.index)
    .map(({ event }) => event);
}

/** Bảng "Phân bổ số tiền" (Figma ADM-07b). */
export function allocationRows(detail: PaymentDetail): { label: string; amount: number; strong?: boolean }[] {
  const rows: { label: string; amount: number; strong?: boolean }[] = [
    { label: `Giá vé (${detail.booking.seatCodes.length} chỗ)`, amount: detail.booking.subtotal, strong: true }
  ];
  if (detail.booking.serviceFee > 0) rows.push({ label: "Phí dịch vụ", amount: detail.booking.serviceFee });
  if (detail.booking.discount > 0) rows.push({ label: "Giảm giá", amount: detail.booking.discount });
  rows.push({ label: "Khách thanh toán qua cổng", amount: detail.amount });
  if (detail.allocation) {
    const rate = detail.allocation.commissionRateBps === null ? "" : ` ${(detail.allocation.commissionRateBps / 100).toLocaleString("vi-VN", { maximumFractionDigits: 2 })}%`;
    rows.push({ label: `Hoa hồng${rate} trên giá vé`, amount: detail.allocation.commissionAmount });
    rows.push({ label: "Nhà xe nhận khi chi trả", amount: detail.allocation.operatorNet, strong: true });
  }
  return rows;
}

export type RefundError = { message: string; field?: "identity"; refresh?: boolean };

/** Lỗi thao tác hoàn tiền → câu báo + ô cần đánh dấu. */
export function describeRefundError(error: unknown): RefundError {
  const identity = describeReauthError(error);
  if (identity) {
    return { message: identity, field: "identity" };
  }
  if (error instanceof ApiError) {
    switch (error.code) {
      case "REFUND_STATUS_INVALID":
        return { message: `${error.message} Tải lại để xem trạng thái mới.`, refresh: true };
      case "REFUND_NOT_FOUND":
      case "PAYMENT_NOT_FOUND":
        return { message: "Không tìm thấy giao dịch. Tải lại trang.", refresh: true };
    }
    if (error.status === 400) {
      return { message: "Kiểm tra lại lý do (3–500 ký tự) và mã tham chiếu (3–64 ký tự)." };
    }
    if (error.status === 503) {
      return { message: "Chưa ghi được nhật ký nên chưa thực hiện. Vui lòng thử lại." };
    }
  }
  return { message: "Chưa thực hiện được. Vui lòng kiểm tra kết nối và thử lại." };
}
