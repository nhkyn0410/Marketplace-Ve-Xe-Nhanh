import { HttpException, HttpStatus } from "@nestjs/common";

const TITLE = "Operator profile error";

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title }` → RFC 7807 (ADR-012).
  return new HttpException({ code, detail, title: TITLE }, status);
}

/** Nhà xe chưa có giấy tờ loại này. */
export function kycDocumentNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "KYC_DOCUMENT_NOT_FOUND", "Nhà xe chưa có giấy tờ này.");
}

/**
 * Giấy tờ gửi lên không gắn được: khóa không thuộc nhà xe, object chưa tải lên / quá cũ, sai loại, sai dung lượng
 * hoặc chữ ký file không khớp. Lý do cụ thể chỉ ghi log.
 */
export function kycDocumentInvalid(): HttpException {
  return problem(
    HttpStatus.UNPROCESSABLE_ENTITY,
    "KYC_DOCUMENT_INVALID",
    "Giấy tờ không hợp lệ hoặc chưa tải lên xong. Hãy tải lại.",
  );
}

/** Đã có một yêu cầu đổi tài khoản nhận tiền đang chờ Admin xác minh. */
export function bankChangePending(): HttpException {
  return problem(
    HttpStatus.CONFLICT,
    "BANK_ACCOUNT_CHANGE_PENDING",
    "Đã có yêu cầu đổi tài khoản nhận tiền đang chờ xác minh.",
  );
}

/** Tài khoản gửi lên trùng tài khoản đang dùng. */
export function bankChangeUnchanged(): HttpException {
  return problem(
    HttpStatus.UNPROCESSABLE_ENTITY,
    "BANK_ACCOUNT_UNCHANGED",
    "Tài khoản này đang là tài khoản nhận tiền của nhà xe.",
  );
}

/** Không có yêu cầu đổi tài khoản đang chờ (hoặc yêu cầu đã được xử lý / thay bằng yêu cầu khác). */
export function bankChangeNotFound(): HttpException {
  return problem(
    HttpStatus.NOT_FOUND,
    "BANK_ACCOUNT_CHANGE_NOT_FOUND",
    "Không có yêu cầu đổi tài khoản nhận tiền đang chờ. Tải lại danh sách.",
  );
}

/** Kho riêng tư chưa cấu hình (OQ-21) / không phản hồi, hoặc chưa ghi được nhật ký. */
export function operatorProfileUnavailable(): HttpException {
  return problem(
    HttpStatus.SERVICE_UNAVAILABLE,
    "SERVICE_UNAVAILABLE",
    "Hệ thống tạm thời không phản hồi nên chưa đổi gì. Vui lòng thử lại sau.",
  );
}
