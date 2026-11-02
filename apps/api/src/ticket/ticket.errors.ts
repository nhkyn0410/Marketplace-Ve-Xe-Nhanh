import { HttpException, HttpStatus } from "@nestjs/common";

const TITLE = "Ticket error";

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title }` → RFC 7807 (ADR-012, API §6.2).
  return new HttpException({ code, detail, title: TITLE }, status);
}

/** Vé không tồn tại HOẶC người gọi không có quyền xem (không lộ việc mã vé có thật). */
export function ticketNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "TICKET_NOT_FOUND", "Không tìm thấy vé.");
}

/** Phiên tra cứu không có / hết hạn (15 phút) — khách quay lại bước nhập mã đặt vé. */
export function lookupExpired(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "TICKET_LOOKUP_EXPIRED", "Phiên tra cứu đã hết hạn. Vui lòng tra cứu lại.");
}

/** Phiên còn hạn nhưng đơn không thuộc phạm vi phiên (khác email, quá 12 tháng, khác đơn đã nhập mã). */
export function lookupBookingNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "BOOKING_NOT_FOUND", "Không tìm thấy đơn trong phiên tra cứu này.");
}

/** Đơn đặt khi đã đăng nhập: tra cứu chỉ cho xem — hủy vé / khiếu nại qua tài khoản. */
export function lookupBookingRequiresLogin(): HttpException {
  return problem(HttpStatus.FORBIDDEN, "BOOKING_REQUIRES_LOGIN", "Đơn này được đặt bằng tài khoản. Vui lòng đăng nhập tài khoản đó để hủy vé hoặc gửi khiếu nại.");
}

/** Sai mã xác minh; hết lượt thử hoặc mã hết hạn thì phải gửi lại mã. */
export function lookupOtpInvalid(remainingAttempts: number): HttpException {
  return problem(
    HttpStatus.UNPROCESSABLE_ENTITY,
    "TICKET_LOOKUP_OTP_INVALID",
    remainingAttempts > 0
      ? `Mã xác minh không đúng. Còn ${remainingAttempts} lần thử.`
      : "Mã xác minh không đúng hoặc đã hết hạn. Vui lòng gửi lại mã.",
  );
}

/** Chống dò mã / gửi mã dồn dập: quá số lần cho phép theo IP hoặc theo email. */
export function lookupRateLimited(detail = "Bạn tra cứu quá nhiều lần. Vui lòng thử lại sau ít phút."): HttpException {
  return problem(HttpStatus.TOO_MANY_REQUESTS, "TICKET_LOOKUP_RATE_LIMITED", detail);
}

export function lookupUnavailable(): HttpException {
  return problem(HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE", "Tra cứu vé tạm thời gián đoạn. Vui lòng thử lại.");
}
