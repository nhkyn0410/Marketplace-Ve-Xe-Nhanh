import { HttpStatus } from "@nestjs/common";
import { AuthException } from "../auth/auth.errors";

/**
 * Refresh không hợp lệ — MỘT response cho mọi lý do (không tồn tại, hết hạn,
 * đã revoke, đã dùng). Phân biệt lý do là cho kẻ tấn công một kênh dò xem token
 * nào từng tồn tại. Mã có sẵn ở LLD §7.
 */

export function sessionExpired(): AuthException {
  return new AuthException(
    HttpStatus.UNAUTHORIZED,
    "AUTH_SESSION_EXPIRED",
    "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.",
  );
}
