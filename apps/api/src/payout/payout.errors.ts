import { HttpException, HttpStatus } from "@nestjs/common";

const TITLE = "Payout error";

function problem(status: HttpStatus, code: string, detail: string, reasons?: string[]): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title, reasons }` → RFC 7807 (ADR-012, API §6.2).
  return new HttpException({ code, detail, title: TITLE, ...(reasons ? { reasons } : {}) }, status);
}

/** Kỳ chi trả không có (hoặc của nhà xe khác — màn nhà xe). */
export function payoutNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "PAYOUT_NOT_FOUND", "Không tìm thấy kỳ chi trả.");
}

/** Trạng thái hiện tại không cho thao tác này (SRS §17.10). */
export function payoutStatusInvalid(detail: string): HttpException {
  return problem(HttpStatus.CONFLICT, "PAYOUT_STATUS_INVALID", detail);
}

/** Chưa qua kiểm tra trước khi chi — `reasons`: `LEDGER_MISMATCH` / `PENDING_REFUNDS` / `BANK_NOT_VERIFIED`. */
export function payoutChecksFailed(reasons: string[]): HttpException {
  return problem(HttpStatus.CONFLICT, "PAYOUT_CHECKS_FAILED", "Kỳ chi trả chưa đủ điều kiện để chi.", reasons);
}

/** Thời điểm chuyển khoản ở tương lai. */
export function transferTimeInvalid(): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "PAYOUT_TRANSFER_TIME_INVALID", "Thời điểm chuyển khoản không hợp lệ.");
}

/** Chưa ghi được audit → không đổi gì / không trả dữ liệu. */
export function payoutServiceUnavailable(): HttpException {
  return problem(HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE", "Chưa ghi được nhật ký nên chưa thực hiện. Vui lòng thử lại sau.");
}
