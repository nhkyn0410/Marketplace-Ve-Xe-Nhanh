import { HttpStatus } from "@nestjs/common";
import { AuthException } from "../auth/auth.errors";

const TITLE = "Authorization error";

/** Có đăng nhập nhưng role không có quyền này (LLD §7). Không nói thiếu quyền GÌ — khỏi dò bảng quyền. */
export function permissionDenied(): AuthException {
  return new AuthException(
    HttpStatus.FORBIDDEN,
    "PERMISSION_DENIED",
    "Bạn không có quyền thực hiện thao tác này.",
    TITLE,
  );
}

/** Có quyền nhưng ngoài phạm vi Operator của mình (LLD §7, BR-08). */
export function tenantScopeViolation(): AuthException {
  return new AuthException(
    HttpStatus.FORBIDDEN,
    "TENANT_SCOPE_VIOLATION",
    "Không được truy cập dữ liệu ngoài phạm vi nhà xe của bạn.",
    TITLE,
  );
}
