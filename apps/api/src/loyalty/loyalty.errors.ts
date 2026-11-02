import { HttpException, HttpStatus } from "@nestjs/common";

const TITLE = "Loyalty error";

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title }` → RFC 7807 (ADR-012, API §6.2).
  return new HttpException({ code, detail, title: TITLE }, status);
}

export function loyaltyMemberNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "LOYALTY_MEMBER_NOT_FOUND", "Không tìm thấy hành khách có tài khoản với email này.");
}

/** Trừ điểm quá số dư — số dư không được âm (BR-69, Figma ADM-12c). */
export function loyaltyInsufficientPoints(available: number): HttpException {
  return problem(HttpStatus.CONFLICT, "LOYALTY_INSUFFICIENT_POINTS", `Số điểm trừ vượt điểm khả dụng (${available.toLocaleString("vi-VN")}).`);
}

/** `Idempotency-Key` đã dùng cho một thao tác khác. */
export function loyaltyRequestConflict(): HttpException {
  return problem(HttpStatus.CONFLICT, "LOYALTY_REQUEST_CONFLICT", "Yêu cầu điều chỉnh đã được dùng cho thành viên khác.");
}

export function idempotencyKeyInvalid(): HttpException {
  return problem(HttpStatus.BAD_REQUEST, "VALIDATION_FAILED", "Thiếu header Idempotency-Key hợp lệ (8–128 ký tự chữ, số, dấu gạch ngang, gạch dưới).");
}

export function loyaltyUnavailable(): HttpException {
  return problem(HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE", "Chưa ghi được nhật ký. Vui lòng thử lại.");
}
