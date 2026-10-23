import { HttpException, HttpStatus } from "@nestjs/common";

const TITLE = "Refund error";

function problem(status: HttpStatus, code: string, detail: string, reasons?: string[]): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title, reasons }` → RFC 7807 (ADR-012, API §6.2).
  return new HttpException({ code, detail, title: TITLE, ...(reasons ? { reasons } : {}) }, status);
}

/** Không hủy được (UC-08 A2): `reasons` = từng vé không hủy được kèm lý do (`{mã vé}: {lý do}`) hoặc lý do chung. */
export function cancellationNotAllowed(reasons: string[]): HttpException {
  return problem(HttpStatus.CONFLICT, "CANCELLATION_NOT_ALLOWED", "Không hủy được vé đã chọn.", reasons);
}

/** Số tiền hoàn đổi so với lúc khách xem (vừa qua một mốc hủy) — `reasons[0]` = số mới (VND). */
export function refundAmountChanged(amount: bigint): HttpException {
  return problem(HttpStatus.CONFLICT, "REFUND_AMOUNT_CHANGED", "Số tiền hoàn vừa thay đổi. Xem lại điều kiện hủy rồi xác nhận.", [amount.toString()]);
}

/** Vé không thuộc booking (không lộ vé của booking khác). */
export function ticketsNotInBooking(): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "CANCELLATION_TICKETS_INVALID", "Có vé không thuộc booking này.");
}

/** Refund không có (màn Admin). */
export function refundNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "REFUND_NOT_FOUND", "Không tìm thấy yêu cầu hoàn tiền.");
}

/** Trạng thái refund / thanh toán hiện tại không cho thao tác này (SRS §17.9). */
export function refundStatusInvalid(detail: string): HttpException {
  return problem(HttpStatus.CONFLICT, "REFUND_STATUS_INVALID", detail);
}

/** Chưa ghi được audit / transaction hết hạn → không đổi gì; thử lại. */
export function refundServiceUnavailable(): HttpException {
  return problem(HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE", "Chưa ghi được nhật ký thao tác. Vui lòng thử lại.");
}
