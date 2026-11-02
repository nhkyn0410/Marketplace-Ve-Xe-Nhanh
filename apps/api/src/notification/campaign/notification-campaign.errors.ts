import { HttpException, HttpStatus } from "@nestjs/common";

const TITLE = "Notification campaign error";

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title }` → RFC 7807 (ADR-012, API §6.2).
  return new HttpException({ code, detail, title: TITLE }, status);
}

export function campaignNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "CAMPAIGN_NOT_FOUND", "Không tìm thấy chiến dịch thông báo.");
}

/** Thao tác không hợp với trạng thái hiện tại (vd sửa chiến dịch đã gửi). */
export function campaignStateInvalid(detail: string): HttpException {
  return problem(HttpStatus.CONFLICT, "CAMPAIGN_STATE_INVALID", detail);
}

/** Nội dung gắn kèm không còn hiệu lực hoặc giờ hẹn ngoài khoảng cho phép. */
export function campaignInvalid(detail: string): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "CAMPAIGN_INVALID", detail);
}

export function campaignQuietHours(): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "CAMPAIGN_QUIET_HOURS", "Khuyến mãi và tin tức không gửi từ 21 giờ đến 8 giờ. Hãy hẹn giờ khác.");
}

export function campaignTestRecipientNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "CAMPAIGN_TEST_RECIPIENT_NOT_FOUND", "Không có tài khoản hành khách đang hoạt động với email này.");
}

/** Không ghi được audit hoặc transaction hết hạn: thao tác chưa có hiệu lực. */
export function campaignUnavailable(): HttpException {
  return problem(HttpStatus.SERVICE_UNAVAILABLE, "CAMPAIGN_UNAVAILABLE", "Chưa lưu được thao tác. Vui lòng thử lại.");
}
