import { HttpException, HttpStatus } from "@nestjs/common";

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  return new HttpException({ code, detail, title: "Audit log error" }, status);
}

/** Không có bản ghi audit với id này (UC-30). */
export function auditLogNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "AUDIT_LOG_NOT_FOUND", "Không tìm thấy bản ghi nhật ký.");
}

/** Kho audit (Mongo) không phản hồi khi đọc. */
export function auditLogUnavailable(): HttpException {
  return problem(
    HttpStatus.SERVICE_UNAVAILABLE,
    "SERVICE_UNAVAILABLE",
    "Chưa đọc được nhật ký audit. Vui lòng thử lại sau.",
  );
}
