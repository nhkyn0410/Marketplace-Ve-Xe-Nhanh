import { HttpException, HttpStatus } from "@nestjs/common";

const TITLE = "Employee operation error";

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title }` → RFC 7807 (ADR-012, API §6.2).
  return new HttpException({ code, detail, title: TITLE }, status);
}

/** Chuyến không có / không được phân công cho nhân viên này — cùng một lỗi để không dò được chuyến khác. */
export function assignmentNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "ASSIGNMENT_NOT_FOUND", "Không tìm thấy chuyến được phân công cho bạn.");
}

/** Mã QR / mã vé không khớp vé nào của nhà xe (UC-20 A1). */
export function ticketNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "TICKET_NOT_FOUND", "Không tìm thấy vé. Kiểm tra lại mã QR hoặc mã vé.");
}

/** Vé không soát được: sai chuyến / đã hủy / đã hoàn / đã check-in (UC-20 A2, A3). */
export function checkInRejected(detail: string): HttpException {
  return problem(HttpStatus.CONFLICT, "CHECK_IN_REJECTED", detail);
}

/** Chuyến chưa / không còn ở giai đoạn soát vé (nháp, đã hủy, đã hoàn thành). */
export function checkInClosed(): HttpException {
  return problem(HttpStatus.CONFLICT, "CHECK_IN_CLOSED", "Chuyến không ở giai đoạn soát vé (nháp, đã hủy hoặc đã hoàn thành).");
}

/** Chuyển trạng thái vận hành sai thứ tự / chuyến đã hủy hoặc đã hoàn thành (UC-21 A1, A2). */
export function tripOperationInvalid(detail: string): HttpException {
  return problem(HttpStatus.CONFLICT, "TRIP_OPERATION_INVALID", detail);
}
