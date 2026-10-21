import { HttpException, HttpStatus } from "@nestjs/common";

const TITLE = "Payment error";

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title }` → RFC 7807 (ADR-012, API §6.2).
  return new HttpException({ code, detail, title: TITLE }, status);
}

/** Booking quá hạn thanh toán (API §6.2 ví dụ `BOOKING_EXPIRED`). */
export function bookingExpired(): HttpException {
  return problem(HttpStatus.CONFLICT, "BOOKING_EXPIRED", "Booking đã hết hạn thanh toán. Vui lòng đặt lại.");
}

/** Booking đã thanh toán / đã hủy — không tạo payment mới (BR-27). */
export function bookingInvalidState(status: string): HttpException {
  return problem(HttpStatus.CONFLICT, "BOOKING_INVALID_STATE", `Booking đang ở trạng thái ${status}, không thanh toán được.`);
}

/** Đang tạo link thanh toán cho booking này qua cùng cổng (bấm lặp). */
export function paymentInProgress(): HttpException {
  return problem(HttpStatus.CONFLICT, "PAYMENT_IN_PROGRESS", "Đang tạo link thanh toán. Vui lòng thử lại sau vài giây.");
}

/** Số tiền ngoài giới hạn một giao dịch của cổng. */
export function amountOutOfRange(): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "PAYMENT_AMOUNT_OUT_OF_RANGE", "Số tiền ngoài giới hạn của cổng thanh toán này.");
}

/** Cổng chưa cấu hình (production chưa có khóa — OQ-22). */
export function providerUnavailable(): HttpException {
  return problem(HttpStatus.SERVICE_UNAVAILABLE, "PAYMENT_PROVIDER_UNAVAILABLE", "Cổng thanh toán này tạm thời chưa dùng được.");
}

/** Cổng lỗi / từ chối tạo giao dịch. */
export function providerError(): HttpException {
  return problem(HttpStatus.BAD_GATEWAY, "PAYMENT_PROVIDER_ERROR", "Cổng thanh toán đang lỗi. Vui lòng thử lại hoặc chọn cổng khác.");
}

/** Hàng đợi xử lý callback không nhận được — cổng sẽ gửi lại. */
export function callbackUnavailable(): HttpException {
  return problem(HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE", "Tạm thời chưa nhận được callback.");
}

/** Giao dịch thanh toán không có (màn Admin). */
export function paymentNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "PAYMENT_NOT_FOUND", "Không tìm thấy giao dịch thanh toán.");
}
