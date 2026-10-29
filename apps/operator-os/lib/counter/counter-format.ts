import { ApiError } from "../auth/api-client";

/** Hiển thị tiền VND từ chuỗi số nguyên, giữ chính xác cả giá trị lớn. */
/** Chỗ đôi (giường đôi / cabin đôi) — được khai người đi cùng, chung vé (BR-78 bổ sung 28/10/2026, chờ duyệt). */
export function isDoubleSeat(type: string): boolean {
  return type === "BED_DOUBLE" || type === "CABIN_DOUBLE";
}

export function counterMoney(value: string | bigint): string {
  return `${BigInt(value).toLocaleString("vi-VN")} ₫`;
}

/** Ngày hiện tại ở Việt Nam dùng làm bộ lọc chuyến, độc lập múi giờ máy bán vé. */
export function counterToday(now = new Date()): string {
  const values = Object.fromEntries(new Intl.DateTimeFormat("en-CA", { timeZone: "Asia/Ho_Chi_Minh", year: "numeric", month: "2-digit", day: "2-digit" }).formatToParts(now).map((part) => [part.type, part.value]));
  return `${values.year}-${values.month}-${values.day}`;
}

/** Cộng tổng giá những chỗ đang chọn bằng số nguyên VND. */
export function selectedCounterTotal(seats: readonly { code: string; price: string | null }[], selected: readonly string[]): string {
  return seats.filter((seat) => selected.includes(seat.code)).reduce((sum, seat) => sum + BigInt(seat.price ?? "0"), 0n).toString();
}

/** Kiểm tra khoản tiền thực nhận và tham chiếu trước khi gửi xác nhận. */
export function receiptInputError(method: "CASH" | "BANK_TRANSFER", amount: string, reference: string): string | null {
  if (!/^[1-9][0-9]*$/.test(amount)) return "Nhập số tiền thực nhận bằng đồng, lớn hơn 0 và không dùng dấu phân cách.";
  if (method === "BANK_TRANSFER" && (reference.trim().length < 3 || reference.trim().length > 100)) return "Nhập mã giao dịch chuyển khoản đã đối chiếu trên tài khoản nhà xe (3–100 ký tự).";
  return null;
}

/** Giải thích nguyên nhân khoản thu chưa phát được vé bằng ngôn ngữ dành cho người bán. */
export function counterExceptionLabel(reason: string | null): string {
  const labels: Record<string, string> = {
    AMOUNT_MISMATCH: "Số tiền thực nhận khác số phải thu. Nhà xe cần đối chiếu và xử lý khoản chênh lệch.",
    TRIP_CLOSED: "Chuyến đã khởi hành hoặc đã dừng bán. Khoản tiền được giữ để nhà xe xử lý.",
    BOOKING_EXPIRED: "Đơn đã hết hạn giữ chỗ trước khi xác nhận khoản thu.",
    BOOKING_NOT_PENDING: "Đơn không còn chờ thu tiền. Kiểm tra khoản thu trước đó trước khi xử lý.",
    SEATS_UNAVAILABLE: "Ghế không còn được giữ cho đơn này. Nhà xe cần sắp xếp lại với khách.",
    COMMISSION_CONFIG_INVALID: "Chưa thể phát vé do cấu hình hoa hồng. Liên hệ người phụ trách để kiểm tra.",
    ISSUANCE_FAILED: "Đã ghi nhận tiền nhưng chưa phát được vé. Nhà xe cần kiểm tra đơn và xử lý khoản thu.",
  };
  return labels[reason ?? ""] ?? "Khoản thu chưa đủ điều kiện phát vé. Liên hệ chủ nhà xe để kiểm tra.";
}

/** Nhãn trạng thái đơn quầy, kể cả đơn hết hạn hoặc đang hoàn tiền. */
export function counterBookingLabel(status: string): string {
  const labels: Record<string, string> = {
    PENDING_PAYMENT: "Chờ thu tiền", PENDING_CONFIRMATION: "Chờ xác nhận", PAID: "Đã thanh toán", CONFIRMED: "Đã xác nhận",
    PARTIALLY_CANCELLED: "Đã hủy một phần", CANCELLED: "Đã hủy", EXPIRED: "Hết hạn giữ chỗ",
    REFUND_PENDING: "Chờ hoàn tiền", REFUNDED: "Đã hoàn tiền", REFUND_FAILED: "Hoàn tiền chưa thành công",
  };
  return labels[status] ?? "Cần kiểm tra đơn";
}

/** Nhãn tình trạng vé khi kiểm tra hoặc in lại tại văn phòng. */
export function counterTicketLabel(status: string): string {
  const labels: Record<string, string> = { VALID: "Vé hợp lệ", CHECKED_IN: "Đã lên xe", USED: "Đã đi", CANCELLED: "Đã hủy", REFUNDED: "Đã hoàn tiền", NO_SHOW: "Vắng mặt" };
  return labels[status] ?? "Cần kiểm tra vé";
}

/** Chuyển lỗi máy chủ thành thông báo cho người bán. */
export function counterError(error: unknown): string {
  if (error instanceof ApiError) {
    if (error.status === 403) return "Bạn không có quyền thực hiện tại văn phòng này. Liên hệ chủ nhà xe để kiểm tra phân công.";
    if (error.status === 404) return "Phiên giữ chỗ, đơn hoặc văn phòng không còn khả dụng. Tải lại thông tin trước khi tiếp tục.";
    return error.message;
  }
  return "Chưa kết nối được máy chủ. Kiểm tra kết nối và thử lại.";
}
