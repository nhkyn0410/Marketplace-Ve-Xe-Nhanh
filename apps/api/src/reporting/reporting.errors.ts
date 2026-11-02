import { HttpException, HttpStatus } from "@nestjs/common";

const TITLE = "Report error";

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title }` → RFC 7807 (ADR-012, API §6.2).
  return new HttpException({ code, detail, title: TITLE }, status);
}

/** Chưa ghi được nhật ký xuất báo cáo (BR-56) → không xuất. */
export function auditUnavailable(): HttpException {
  return problem(HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE", "Chưa ghi được nhật ký xuất báo cáo. Vui lòng thử lại.");
}
