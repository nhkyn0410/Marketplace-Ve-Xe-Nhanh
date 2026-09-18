import { type GrantScope, type Permission, ROLE_GRANTS } from "./permissions";
import { isRole, Role } from "./role";

/** `null` = không token (ANONYMOUS). */
export type Actor = { role: string } | null;

export type AccessDecision =
  | { allowed: true; scope: GrantScope }
  | { allowed: false; reason: "unknown_role" | "not_granted" };

/**
 * Điểm quyết định RBAC duy nhất (ADR-017). Hàm thuần, không DI — gọi được từ guard, service, test.
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
  return scope ? { allowed: true, scope } : { allowed: false, reason: "not_granted" };
}
