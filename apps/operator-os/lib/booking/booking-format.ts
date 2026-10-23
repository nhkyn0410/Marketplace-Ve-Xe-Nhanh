// Logic thuần của màn Đặt vé (Figma "Nhà xe · Đặt vé" 01–03; TASK-OPR-003): nhãn trạng thái, mã hiển thị, dòng vé, lịch sử,
// mốc hủy / hoàn theo giờ khởi hành.
import { ApiError } from "../auth/api-client";
import { formatDay, formatTime } from "../trip/trip-format";
import type { BookingStatus, OperatorBooking, OperatorBookingDetail, PaymentStatus, TicketStatus } from "./booking-api";

export type Tone = "success" | "warning" | "danger" | "neutral";

export const BOOKING_STATUS: Record<BookingStatus, { label: string; tone: Tone }> = {
  PENDING_PAYMENT: { label: "Chờ thanh toán", tone: "warning" },
  PENDING_CONFIRMATION: { label: "Chờ xác nhận", tone: "warning" },
  PAID: { label: "Đã thanh toán", tone: "success" },
  CONFIRMED: { label: "Đã xác nhận", tone: "success" },
  PARTIALLY_CANCELLED: { label: "Hủy một phần", tone: "neutral" },
  CANCELLED: { label: "Đã hủy", tone: "danger" },
  EXPIRED: { label: "Hết hạn", tone: "neutral" },
  REFUND_PENDING: { label: "Chờ hoàn tiền", tone: "warning" },
  REFUNDED: { label: "Đã hoàn tiền", tone: "neutral" },
  REFUND_FAILED: { label: "Hoàn tiền lỗi", tone: "danger" }
};

/** Thứ tự trong ô lọc "Trạng thái đơn". */
export const BOOKING_STATUS_ORDER: BookingStatus[] = [
  "PENDING_PAYMENT",
  "CONFIRMED",
  "PARTIALLY_CANCELLED",
  "CANCELLED",
  "EXPIRED",
  "REFUND_PENDING",
  "REFUNDED",
  "REFUND_FAILED"
];

const PAYMENT_STATUS: Record<PaymentStatus, { label: string; tone: Tone }> = {
  INITIATED: { label: "Đang xử lý", tone: "warning" },
  PROCESSING: { label: "Đang xử lý", tone: "warning" },
  SUCCESS: { label: "Thành công", tone: "success" },
  FAILED: { label: "Thất bại", tone: "danger" },
  EXPIRED: { label: "Hết hạn", tone: "neutral" },
  CANCELLED: { label: "Đã hủy", tone: "neutral" },
  RECONCILING: { label: "Đang đối soát", tone: "warning" }
};

/** Cột "Thanh toán": chưa có lần thanh toán nào thì "Chưa thanh toán". */
export function paymentState(payment: OperatorBooking["payment"]): { label: string; tone: Tone } {
  return payment ? PAYMENT_STATUS[payment.status] : { label: "Chưa thanh toán", tone: "neutral" };
}

export const TICKET_STATUS: Record<TicketStatus, { label: string; tone: Tone }> = {
  VALID: { label: "Hợp lệ", tone: "success" },
  CANCELLED: { label: "Đã hủy", tone: "danger" },
  CHECKED_IN: { label: "Đã lên xe", tone: "success" },
  NO_SHOW: { label: "Vắng mặt", tone: "warning" },
  USED: { label: "Đã đi", tone: "neutral" },
  REFUNDED: { label: "Đã hoàn", tone: "neutral" }
};

export const TICKET_STATUS_ORDER: TicketStatus[] = ["VALID", "CHECKED_IN", "NO_SHOW", "USED", "CANCELLED", "REFUNDED"];

export const PROVIDER_LABEL: Record<NonNullable<OperatorBooking["payment"]>["provider"], string> = { VNPAY: "VNPay", MOMO: "MoMo" };

/** Mã đặt vé / mã vé dễ đọc: `VXN8F3K2Q` → `VXN-8F3K2Q`, `VXN8F3K2Q-01` → `VXN-8F3K2Q-01`. */
export function displayCode(code: string): string {
  return code.replace(/^VXN(?!-)/, "VXN-");
}

/** Cột "Vé": `2 vé` + dòng phụ (mã chỗ / số vé đã hủy / đã nhả chỗ). */
export function ticketSummary(booking: Pick<OperatorBooking, "seatCodes" | "cancelledTicketCount" | "status">): { title: string; note: string } {
  const title = `${booking.seatCodes.length} vé`;
  if (booking.status === "EXPIRED" || booking.status === "CANCELLED") {
    return { title, note: "Đã nhả chỗ" };
  }
  if (booking.cancelledTicketCount > 0) {
    return { title, note: `${booking.cancelledTicketCount} vé đã hủy` };
  }
  return { title, note: booking.seatCodes.join(", ") };
}

/** `22:30 · 16/10` (giờ VN). */
export function shortMoment(iso: string): string {
  return `${formatTime(iso)} · ${formatDay(iso).slice(0, 5)}`;
}

const ACTOR_LABEL: Record<string, string> = {
  PASSENGER: "Hành khách",
  GUEST: "Khách vãng lai",
  SYSTEM: "Hệ thống",
  PROVIDER: "Cổng thanh toán",
  PLATFORM: "Vé Xe Nhanh"
};

/** Một dòng "Lịch sử trạng thái": tiêu đề theo bước + dòng phụ người làm / lý do. */
export function historyLine(history: OperatorBookingDetail["histories"][number], booking: Pick<OperatorBookingDetail, "seats">): { title: string; note: string } {
  const actor = ACTOR_LABEL[history.actor] ?? history.actor;
  switch (history.toStatus) {
    case "PENDING_PAYMENT":
      return { title: "Tạo đơn", note: `${actor} · giữ chỗ ${booking.seats.map((seat) => seat.seatCode).join(", ")}` };
    case "PAID":
      return { title: "Thanh toán thành công", note: history.reason ?? actor };
    case "CONFIRMED":
      return { title: `Phát hành ${booking.seats.length} vé`, note: "Đơn chuyển sang Đã xác nhận" };
    case "EXPIRED":
      return { title: "Hết hạn thanh toán", note: "Đã nhả chỗ" };
    default:
      return { title: BOOKING_STATUS[history.toStatus].label, note: history.reason ?? actor };
  }
}

/**
 * Mốc hủy / hoàn theo giờ khởi hành (chính sách lưu lúc đặt — BR-07): mỗi mốc "Trước {giờ · ngày}" → phần trăm hoàn,
 * dòng cuối "Sau {mốc gần nhất}" → không hoàn (nếu mốc gần nhất vẫn còn hoàn tiền thì thôi).
 */
export function cancellationRows(departureAt: string, tiers: OperatorBookingDetail["cancellationPolicy"]["tiers"]): { when: string; refund: string }[] {
  const sorted = [...tiers].sort((a, b) => b.minHoursBefore - a.minHoursBefore);
  const moment = (hours: number) => shortMoment(new Date(new Date(departureAt).getTime() - hours * 3_600_000).toISOString());
  const rows = sorted.map((tier) => ({
    when: `Trước ${moment(tier.minHoursBefore)}`,
    refund: tier.refundPercent > 0 ? `Hoàn ${tier.refundPercent}%` : "Không hoàn"
  }));
  const last = sorted[sorted.length - 1];
  if (last && last.refundPercent > 0) {
    rows.push({ when: `Sau ${moment(last.minHoursBefore)}`, refund: "Không hoàn" });
  }
  return rows;
}

/** Lỗi khi xem đầy đủ liên hệ / xuất danh sách → câu báo. */
export function describePrivacyError(error: unknown): string {
  if (error instanceof ApiError && error.status === 503) {
    return "Chưa ghi được nhật ký truy cập nên chưa hiện dữ liệu. Vui lòng thử lại.";
  }
  if (error instanceof ApiError && error.status === 404) {
    return "Không tìm thấy dữ liệu. Tải lại trang.";
  }
  return "Chưa thực hiện được. Vui lòng kiểm tra kết nối và thử lại.";
}
