import { HttpException, HttpStatus } from "@nestjs/common";
import type { MissingItem } from "./operator-application-format";

const TITLE = "Operator application error";

function problem(status: HttpStatus, code: string, detail: string, reasons?: string[]): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title, reasons }` → RFC 7807 (ADR-012, API §6.2).
  return new HttpException({ code, detail, title: TITLE, ...(reasons ? { reasons } : {}) }, status);
}

/** Hồ sơ đã gửi duyệt (hoặc đã có kết quả) thì không sửa / gửi lại được (LLD §7). */
export function applicationInvalidState(): HttpException {
  return problem(
    HttpStatus.CONFLICT,
    "OPERATOR_APPLICATION_INVALID_STATE",
    "Hồ sơ đang chờ duyệt hoặc đã có kết quả nên không sửa được.",
  );
}

/** Còn thiếu thông tin / giấy tờ — `reasons` liệt kê MỌI mục còn thiếu để sửa một lần (UC-10 A1). */
export function applicationIncomplete(missing: MissingItem[]): HttpException {
  return problem(
    HttpStatus.UNPROCESSABLE_ENTITY,
    "OPERATOR_APPLICATION_INCOMPLETE",
    "Hồ sơ còn thiếu thông tin hoặc giấy tờ bắt buộc.",
    missing,
  );
}

/** Tạo hồ sơ / xin lại link / xin URL tải giấy tờ quá nhiều lần (UC-10 A6, Security §11). */
export function applicationRateLimited(): HttpException {
  return problem(
    HttpStatus.TOO_MANY_REQUESTS,
    "OPERATOR_APPLICATION_RATE_LIMITED",
    "Bạn thao tác quá nhanh. Vui lòng thử lại sau ít phút.",
  );
}

/** Giấy tờ gửi lên không gắn được vào hồ sơ — một thông báo chung, không lộ lý do. */
export function applicationDocumentInvalid(): HttpException {
  return problem(
    HttpStatus.UNPROCESSABLE_ENTITY,
    "OPERATOR_APPLICATION_DOCUMENT_INVALID",
    "Có giấy tờ không hợp lệ hoặc chưa tải lên xong. Hãy tải lại giấy tờ đó.",
  );
}

/** Hồ sơ chưa có giấy tờ loại này. */
export function applicationDocumentNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "OPERATOR_APPLICATION_DOCUMENT_NOT_FOUND", "Hồ sơ chưa có giấy tờ này.");
}

/** Kho giấy tờ chưa cấu hình (production chờ OQ-21), không phản hồi, hoặc bộ đếm / audit lỗi — client thử lại sau. */
export function applicationServiceUnavailable(): HttpException {
  return problem(
    HttpStatus.SERVICE_UNAVAILABLE,
    "SERVICE_UNAVAILABLE",
    "Hệ thống tạm thời không phản hồi hoặc chức năng giấy tờ chưa mở. Vui lòng thử lại sau.",
  );
}
