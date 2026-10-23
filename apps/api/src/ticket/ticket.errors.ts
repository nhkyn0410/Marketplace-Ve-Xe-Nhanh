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

/** Tra cứu sai mã / liên hệ — cùng một câu cho mọi trường hợp (chống dò mã booking). */
export function lookupNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "BOOKING_NOT_FOUND", "Không tìm thấy booking với mã và thông tin liên hệ này.");
}

/** Chống dò mã: quá số lần tra cứu cho phép của một địa chỉ IP. */
export function lookupRateLimited(): HttpException {
  return problem(HttpStatus.TOO_MANY_REQUESTS, "TICKET_LOOKUP_RATE_LIMITED", "Bạn tra cứu quá nhiều lần. Vui lòng thử lại sau ít phút.");
}

export function lookupUnavailable(): HttpException {
  return problem(HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE", "Tra cứu vé tạm thời gián đoạn. Vui lòng thử lại.");
}
