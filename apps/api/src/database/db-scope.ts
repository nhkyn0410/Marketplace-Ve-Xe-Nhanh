/**
 * Ngữ cảnh RLS của một transaction (TASK-IAM-003, ADR-011/017). Policy `app_rls_allows()` đọc
 * GUC `app.scope` + `app.operator_id`:
 * - `tenant`   → chỉ row của đúng Operator đó.
 * - `platform` → toàn hệ thống (PLATFORM_* theo RBAC).
 * - `system`   → toàn hệ thống cho auth/session/cron.
 * Không có ngữ cảnh → 0 row (fail-closed).
 *
 * Kiểu có BRAND: module nghiệp vụ KHÔNG tự viết được `{ kind: "platform" }` (TypeScript từ chối), chỉ
 * dùng được scope mà `TenantGuard` trao qua `@Authz()`. Hàm dựng bên dưới bị ESLint
 * `vexenhanh-boundaries/system-db-context` giới hạn trong `iam/auth`, `iam/session`, `iam/role`,
 * `database`.
 */
declare const brand: unique symbol;

type Scope =
  | { kind: "tenant"; operatorId: string }
  | { kind: "platform" }
  | { kind: "system" };

export type DbScope = Scope & { readonly [brand]: true };

export function tenantScope(operatorId: string): DbScope {
  if (!operatorId) {
    // Chuỗi rỗng sẽ thành "không khớp tenant nào" — an toàn nhưng che mất lỗi gọi sai.
    throw new Error("tenantScope cần operatorId.");
  }
  return { kind: "tenant", operatorId } as DbScope;
}

export function platformScope(): DbScope {
  return { kind: "platform" } as DbScope;
}

export function systemScope(): DbScope {
  return { kind: "system" } as DbScope;
}
