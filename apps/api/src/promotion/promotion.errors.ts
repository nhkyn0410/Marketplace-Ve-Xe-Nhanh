import { HttpException, HttpStatus } from "@nestjs/common";

const TITLE = "Promotion error";

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title }` → RFC 7807 (ADR-012, API §6.2).
  return new HttpException({ code, detail, title: TITLE }, status);
}

/** Mã không áp dụng được cho đơn (không có, chưa / hết hiệu lực, sai nhà xe / tuyến / chuyến, chưa đạt tối thiểu). */
export function promotionInvalid(detail: string): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "PROMOTION_INVALID", detail);
}

/** Hết lượt dùng / hết ngân sách. */
export function promotionExhausted(detail = "Mã khuyến mãi đã hết lượt dùng."): HttpException {
  return problem(HttpStatus.CONFLICT, "PROMOTION_EXHAUSTED", detail);
}

export function promotionNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "PROMOTION_NOT_FOUND", "Không tìm thấy khuyến mãi.");
}

/** Trùng mã với chương trình khác. */
export function promotionCodeTaken(): HttpException {
  return problem(HttpStatus.CONFLICT, "PROMOTION_CODE_TAKEN", "Mã khuyến mãi đã được dùng cho chương trình khác.");
}

/** Vượt giới hạn Vé Xe Nhanh cấp / nhà xe chưa được cấp quyền (BR-46). */
export function promotionGuardrail(detail: string): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "PROMOTION_GUARDRAIL", detail);
}

/** Đổi trạng thái sai / sửa điều kiện khi đã có đơn dùng mã (BR-47). */
export function promotionStateInvalid(detail: string): HttpException {
  return problem(HttpStatus.CONFLICT, "PROMOTION_STATE_INVALID", detail);
}

export function promotionUnavailable(): HttpException {
  return problem(HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE", "Chưa ghi được nhật ký. Vui lòng thử lại.");
}
