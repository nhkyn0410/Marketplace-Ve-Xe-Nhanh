import { can, grantedPermissions } from "../role/access-policy";
import { assignablePermissions, normalizePermissions, type Permission, storedPermissions } from "../role/permissions";
import { permissionGrantForbidden, permissionNotAssignable } from "./account.errors";

/**
 * Phân quyền theo từng tài khoản (FR-IAM-07, TASK-IAM-007) — phần dùng chung của tài khoản quản trị (Admin cấp) và tài
 * khoản quản lý nhà xe (Owner cấp). Cột `permissions` (JSONB): `NULL` = đủ quyền tick được của role.
 */
type AccountRow = { role: string; permissions: unknown };

/** Actor như `can()` thấy: danh sách lưu DB, `NULL` → theo role. */
export function accountActor(row: AccountRow): { role: string; perms?: Permission[] } {
  const perms = storedPermissions(row.permissions);
  return perms ? { role: row.role, perms } : { role: row.role };
}

/** Quyền tick được tài khoản đang có (trong trần của role, theo thứ tự danh mục). */
export function effectiveAssignable(row: AccountRow): Permission[] {
  const ceiling = assignablePermissions(row.role);
  return normalizePermissions((storedPermissions(row.permissions) ?? ceiling).filter((permission) => ceiling.includes(permission)));
}

/** Mọi quyền hiệu lực của tài khoản — dùng để biết người thao tác được cấp / gỡ quyền nào. */
export function accountGrants(row: AccountRow): ReadonlySet<Permission> {
  return new Set(grantedPermissions(accountActor(row)));
}

export function holds(row: AccountRow, permission: Permission): boolean {
  return can(accountActor(row), permission).allowed;
}

/**
 * Danh sách mới cho tài khoản vai trò `role` (TASK-IAM-007): ⊆ quyền tick được của role (P4, 400) và mọi quyền thêm /
 * bớt so với `current` đều là quyền người thao tác đang có (P5, 403). Trả danh sách đã chuẩn hoá.
 */
export function checkPermissionChange(
  role: string,
  requested: readonly string[],
  current: readonly Permission[],
  actorGrants: ReadonlySet<Permission>,
): Permission[] {
  const next = normalizePermissions(requested);
  const ceiling = assignablePermissions(role);
  if (next.length !== new Set(requested).size || next.some((permission) => !ceiling.includes(permission))) {
    throw permissionNotAssignable();
  }
  const changed = [
    ...next.filter((permission) => !current.includes(permission)),
    ...current.filter((permission) => !next.includes(permission)),
  ];
  if (changed.some((permission) => !actorGrants.has(permission))) {
    throw permissionGrantForbidden();
  }
  return next;
}

/** Quyền người thao tác được tick cho từng vai trò — web khóa ô không đổi được. */
export function grantableFor(role: string, actorGrants: ReadonlySet<Permission>): Permission[] {
  return assignablePermissions(role).filter((permission) => actorGrants.has(permission));
}
