import { HttpException, HttpStatus } from "@nestjs/common";

const TITLE = "Employee assignment error";

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title }` → RFC 7807 (ADR-012, API §6.2).
  return new HttpException({ code, detail, title: TITLE }, status);
}

/** Chuyến không tồn tại HOẶC thuộc tenant khác — cùng một lỗi để chống dò id. */
export function tripNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "TRIP_NOT_FOUND", "Không tìm thấy chuyến.");
}

/** Chuyến đã hủy / hoàn thành — không đổi phân công. */
export function tripNotAssignable(): HttpException {
  return problem(HttpStatus.CONFLICT, "TRIP_NOT_ASSIGNABLE", "Chuyến đã hủy hoặc đã hoàn thành nên không đổi phân công được.");
}

/** Nhân viên không tồn tại / khác tenant / không phải tài xế / đang bị khóa (UC-16 A1, A2). */
export function employeeNotAssignable(): HttpException {
  return problem(
    HttpStatus.UNPROCESSABLE_ENTITY,
    "EMPLOYEE_NOT_ASSIGNABLE",
    "Nhân viên không phải tài xế đang hoạt động của nhà xe.",
  );
}

/** Tài xế đã có chuyến khác chồng giờ (UC-16 A3). `detail` nêu giờ chuyến kia (giờ Việt Nam). */
export function driverScheduleConflict(detail: string): HttpException {
  return problem(HttpStatus.CONFLICT, "DRIVER_SCHEDULE_CONFLICT", detail);
}

/** Đổi phân công khi chuyến đang chạy / sắp khởi hành mà thiếu lý do (UC-16 A4). */
export function assignmentReasonRequired(): HttpException {
  return problem(
    HttpStatus.UNPROCESSABLE_ENTITY,
    "ASSIGNMENT_REASON_REQUIRED",
    "Chuyến đang chạy hoặc sắp khởi hành — nhập lý do đổi phân công.",
  );
}

/** Không ghi được nhật ký (audit) — phân công KHÔNG đổi, client thử lại. */
export function assignmentHistoryUnavailable(): HttpException {
  return problem(
    HttpStatus.SERVICE_UNAVAILABLE,
    "SERVICE_UNAVAILABLE",
    "Chưa ghi được lịch sử thay đổi nên phân công chưa đổi. Vui lòng thử lại sau.",
  );
}
