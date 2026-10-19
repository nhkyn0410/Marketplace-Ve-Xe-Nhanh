import { HttpException, HttpStatus } from "@nestjs/common";

const TITLE = "Support error";

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title }` → RFC 7807 (ADR-012, API §6.2).
  return new HttpException({ code, detail, title: TITLE }, status);
}

/** Khiếu nại không có / không thuộc người gọi (không phân biệt). */
export function supportTicketNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "SUPPORT_TICKET_NOT_FOUND", "Không tìm thấy khiếu nại.");
}

/** Thao tác không hợp với trạng thái hiện tại (đã đóng, đã chuyển tranh chấp…). */
export function supportStateInvalid(detail: string): HttpException {
  return problem(HttpStatus.CONFLICT, "SUPPORT_STATE_INVALID", detail);
}

/** Người phụ trách không phải tài khoản nền tảng đang hoạt động. */
export function supportAssigneeInvalid(): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "SUPPORT_ASSIGNEE_INVALID", "Người phụ trách không hợp lệ.");
}

export function attachmentInvalid(): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "SUPPORT_ATTACHMENT_INVALID", "Tệp đính kèm không hợp lệ hoặc đã hết hạn — tải lại tệp (PDF, JPEG, PNG, tối đa 10 MB).");
}

export function attachmentNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "SUPPORT_ATTACHMENT_NOT_FOUND", "Không tìm thấy tệp đính kèm.");
}

/** Kho tệp riêng tư / nhật ký audit chưa sẵn sàng. */
export function supportUnavailable(): HttpException {
  return problem(HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE", "Chưa xử lý được tệp đính kèm hoặc nhật ký. Vui lòng thử lại.");
}

/** Tranh chấp không có / không thuộc người gọi. */
export function disputeNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "DISPUTE_NOT_FOUND", "Không tìm thấy tranh chấp.");
}

/** Chuyển trạng thái tranh chấp sai thứ tự / đã có quyết định (FR-DSP-02). */
export function disputeStateInvalid(detail: string): HttpException {
  return problem(HttpStatus.CONFLICT, "DISPUTE_STATE_INVALID", detail);
}

/** Số tiền hoàn vượt phần khách đã trả còn lại / đơn chưa có thanh toán thành công. */
export function disputeRefundInvalid(detail: string): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "DISPUTE_REFUND_INVALID", detail);
}

export function reviewNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "REVIEW_NOT_FOUND", "Không tìm thấy đánh giá.");
}

/** BR-18: chỉ đơn của hành khách có vé hợp lệ trên chuyến đã hoàn thành; mỗi đơn một đánh giá. */
export function reviewNotAllowed(detail: string): HttpException {
  return problem(HttpStatus.CONFLICT, "REVIEW_NOT_ALLOWED", detail);
}

/** Lỗi ghi audit cho thao tác bắt buộc có nhật ký → không thực hiện. */
export function trustAuditUnavailable(): HttpException {
  return problem(HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE", "Chưa ghi được nhật ký. Vui lòng thử lại.");
}
