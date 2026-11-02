import { ACCOUNT_PERMISSIONS, type GrantScope, type Permission, PERMISSIONS, ROLE_GRANTS } from "./permissions";
import { isRole, Role } from "./role";

/**
 * `null` = không token (ANONYMOUS). `perms` = danh sách quyền riêng của tài khoản (claim JWT, TASK-IAM-007) — chỉ có
 * khi tài khoản được phân quyền theo từng tài khoản.
 */
export type Actor = { role: string; perms?: readonly string[] } | null;

export type AccessDecision =
  | { allowed: true; scope: GrantScope }
  | { allowed: false; reason: "unknown_role" | "not_granted" };

/**
 * Điểm quyết định RBAC duy nhất (ADR-017). Hàm thuần, không DI — gọi được từ guard, service, test.
 *
 * Role cho grant + phạm vi; với quyền tick được (`ACCOUNT_PERMISSIONS`) thì danh sách của tài khoản còn phải có quyền
 * đó. Role bắt buộc mang danh sách mà token thiếu → coi như danh sách rỗng (fail-closed).
 *
 * Nâng lên ABAC (ADR-017 "thêm context field vào permission check"): thêm tham số `context` TUỲ CHỌN
 * (resource, assignment...) và luật theo resource ở đây — lời gọi cũ không phải đổi.
 */
export function can(actor: Actor, permission: Permission): AccessDecision {
  const role = actor === null ? Role.ANONYMOUS : actor.role;
  if (!isRole(role)) {
    return { allowed: false, reason: "unknown_role" };
  }
  const scope = ROLE_GRANTS[role][permission];
  if (!scope) {
    return { allowed: false, reason: "not_granted" };
  }
  const account = ACCOUNT_PERMISSIONS[role];
  if (account?.assignable.includes(permission)) {
    const perms = actor?.perms ?? (account.required ? [] : undefined);
    if (perms && !perms.includes(permission)) {
      return { allowed: false, reason: "not_granted" };
    }
  }
  return { allowed: true, scope };
}

/** Mọi quyền actor đang có — `/auth/me` trả cho web ẩn menu / nút (server vẫn chặn qua `can()`). */
export function grantedPermissions(actor: Actor): Permission[] {
  return PERMISSIONS.filter((permission) => can(actor, permission).allowed);
}
