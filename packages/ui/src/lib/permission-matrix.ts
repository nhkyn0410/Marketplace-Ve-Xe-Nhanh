// Ma trận tick quyền theo từng tài khoản (TASK-IAM-007) — dùng chung cho Admin (tài khoản quản trị) và Operator OS (tài
// khoản quản lý nhà xe). Hàm thuần; quyền nào tick được do API quyết (`grantable`).

export type PermissionItem<P extends string = string> = { permission: P; label: string; description: string };
export type PermissionGroup<P extends string = string> = { label: string; items: PermissionItem<P>[] };
export type PermissionTemplate<P extends string = string> = { id: string; label: string; permissions: P[] | "all" };

/** Áp mẫu: ô được tick lấy theo mẫu, ô không được tick giữ nguyên (API chặn đổi quyền mình không có). */
export function applyTemplate<P extends string>(template: PermissionTemplate<P>, current: readonly P[], grantable: readonly P[]): P[] {
  const wanted: readonly P[] = template.permissions === "all" ? grantable : template.permissions;
  return [
    ...current.filter((permission) => !grantable.includes(permission)),
    ...grantable.filter((permission) => wanted.includes(permission))
  ];
}

/** Bật / tắt một ô. */
export function togglePermission<P extends string>(current: readonly P[], permission: P): P[] {
  return current.includes(permission) ? current.filter((item) => item !== permission) : [...current, permission];
}

export function samePermissions(a: readonly string[], b: readonly string[]): boolean {
  return a.length === b.length && a.every((permission) => b.includes(permission));
}

/** Nhãn của mã quyền theo danh mục; mã lạ giữ nguyên. */
export function permissionLabel(groups: readonly PermissionGroup[], permission: string): string {
  return groups.flatMap((group) => group.items).find((item) => item.permission === permission)?.label ?? permission;
}
