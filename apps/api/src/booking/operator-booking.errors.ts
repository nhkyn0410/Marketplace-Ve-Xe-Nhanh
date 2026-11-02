import { HttpException, HttpStatus } from "@nestjs/common";

const TITLE = "Booking error";

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title }` → RFC 7807 (ADR-012, API §6.2).
  return new HttpException({ code, detail, title: TITLE }, status);
}

/** Chuyến không có / thuộc nhà xe khác (không phân biệt). */
export function tripNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "TRIP_NOT_FOUND", "Không tìm thấy chuyến.");
}

/** Chưa ghi được nhật ký xem / xuất dữ liệu cá nhân → không trả dữ liệu. */
export function auditUnavailable(): HttpException {
  return problem(HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE", "Chưa ghi được nhật ký truy cập dữ liệu khách. Vui lòng thử lại.");
}
