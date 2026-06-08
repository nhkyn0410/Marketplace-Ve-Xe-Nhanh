import { HttpException, HttpStatus } from "@nestjs/common";

/**
 * Lỗi auth → RFC 7807 (ADR-012) với `code` GLOSSARY. ProblemDetailsExceptionFilter
 * đọc `{ code, detail, title }` từ response. KHÔNG tiết lộ account tồn tại hay không (LLD §7).
 */
export class AuthException extends HttpException {
  constructor(status: HttpStatus, code: string, detail: string, title = "Authentication error") {
    super({ code, detail, title }, status);
  }
}

/** Sai credential HOẶC account không tồn tại — cùng 1 response (chống account enumeration). */
export function invalidCredentials(): AuthException {
  return new AuthException(
    HttpStatus.UNAUTHORIZED,
    "AUTH_INVALID_CREDENTIALS",
    "Thông tin đăng nhập không hợp lệ."
  );
}

/** Account bị khóa/vô hiệu — chỉ trả khi credential ĐÚNG (không leak). */
export function accountLocked(): AuthException {
  return new AuthException(
    HttpStatus.FORBIDDEN,
    "AUTH_ACCOUNT_LOCKED",
    "Tài khoản đã bị khóa hoặc vô hiệu hóa."
  );
}

/** OTP/đăng nhập vượt giới hạn tần suất (SEC-OQ-07). */
export function otpRateLimited(): AuthException {
  return new AuthException(
    HttpStatus.TOO_MANY_REQUESTS,
    "AUTH_OTP_RATE_LIMITED",
    "Yêu cầu OTP quá nhiều. Vui lòng thử lại sau."
  );
}

/** Sai cổng đăng nhập cho namespace (FR-IAM-02b/02c). */
export function wrongLoginChannel(): AuthException {
  return new AuthException(
    HttpStatus.UNAUTHORIZED,
    "AUTH_INVALID_CREDENTIALS",
    "Thông tin đăng nhập không hợp lệ."
  );
}
