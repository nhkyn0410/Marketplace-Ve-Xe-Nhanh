import { HttpException, HttpStatus } from "@nestjs/common";

const TITLE = "Policy error";

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title }` → RFC 7807 (ADR-012).
  return new HttpException({ code, detail, title: TITLE }, status);
}

export function policyVersionNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "POLICY_VERSION_NOT_FOUND", "Không tìm thấy phiên bản chính sách.");
}

/** Phiên bản đã kích hoạt (hoặc đã hủy) không sửa được; bản đã có hiệu lực không hủy được (AS-23). */
export function policyVersionLocked(): HttpException {
  return problem(
    HttpStatus.CONFLICT,
    "POLICY_VERSION_LOCKED",
    "Phiên bản này đã kích hoạt hoặc đã hủy nên không đổi được. Tạo phiên bản mới thay thế.",
  );
}

/** Nội dung chính sách không đúng loại, hoặc phạm vi không hợp lệ (giữ chỗ / chi trả chỉ cấp nền tảng). */
export function policyRulesInvalid(detail: string): HttpException {
  return problem(HttpStatus.BAD_REQUEST, "POLICY_RULES_INVALID", detail);
}

/** Thiếu thời điểm hiệu lực, hoặc thời điểm không ở tương lai (không áp ngược — UC-25 A5). */
export function policyEffectiveInvalid(): HttpException {
  return problem(
    HttpStatus.UNPROCESSABLE_ENTITY,
    "POLICY_EFFECTIVE_INVALID",
    "Chọn thời điểm hiệu lực ở tương lai — chính sách mới không áp ngược cho giao dịch đã có.",
  );
}

/** Đã có phiên bản lên lịch cùng phạm vi (UC-25 A2): hủy lịch đó trước. */
export function policyScheduleConflict(): HttpException {
  return problem(
    HttpStatus.CONFLICT,
    "POLICY_SCHEDULE_CONFLICT",
    "Đã có phiên bản khác đang chờ hiệu lực cho phạm vi này. Hủy phiên bản đó trước khi kích hoạt phiên bản mới.",
  );
}

export function commissionRuleNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "COMMISSION_RULE_NOT_FOUND", "Không tìm thấy mức hoa hồng.");
}

/** Hai mức riêng của cùng một nhà xe chồng thời gian. */
export function commissionRuleOverlap(): HttpException {
  return problem(
    HttpStatus.CONFLICT,
    "COMMISSION_RULE_OVERLAP",
    "Nhà xe đã có mức hoa hồng riêng trong khoảng thời gian này.",
  );
}

/** Mức đã bắt đầu áp dụng: chỉ được rút ngắn ngày kết thúc, không đổi tỷ lệ / ngày bắt đầu (không áp ngược). */
export function commissionRuleLocked(): HttpException {
  return problem(
    HttpStatus.UNPROCESSABLE_ENTITY,
    "COMMISSION_RULE_LOCKED",
    "Mức này đã bắt đầu áp dụng: chỉ đổi được ngày kết thúc (từ bây giờ trở đi). Tạo mức mới nếu cần tỷ lệ khác.",
  );
}

/** Ngày bắt đầu / kết thúc không hợp lệ (bắt đầu ở quá khứ, kết thúc trước hiện tại). */
export function commissionPeriodInvalid(): HttpException {
  return problem(
    HttpStatus.UNPROCESSABLE_ENTITY,
    "COMMISSION_PERIOD_INVALID",
    "Ngày bắt đầu phải ở tương lai và ngày kết thúc phải sau ngày bắt đầu.",
  );
}

export function fareBandNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "FARE_BAND_NOT_FOUND", "Không tìm thấy khung giá.");
}

/** Khung giá đã kết thúc / đã hủy. */
export function fareBandClosed(): HttpException {
  return problem(HttpStatus.CONFLICT, "FARE_BAND_CLOSED", "Khung giá đã kết thúc hoặc đã hủy.");
}

export function policyServiceUnavailable(): HttpException {
  return problem(
    HttpStatus.SERVICE_UNAVAILABLE,
    "SERVICE_UNAVAILABLE",
    "Chưa ghi được nhật ký nên chưa đổi gì. Vui lòng thử lại sau.",
  );
}

/** Hai Admin tạo nháp cùng lúc cho một phạm vi → trùng số phiên bản. */
export function policyVersionConflict(): HttpException {
  return problem(
    HttpStatus.CONFLICT,
    "POLICY_VERSION_CONFLICT",
    "Vừa có phiên bản khác được tạo cho phạm vi này. Tải lại rồi thử lại.",
  );
}
