import type { DbScope } from "../../database/db-scope";
import type { Authorization } from "./authorization";
import { tenantScopeViolation } from "./authorization.errors";

/**
 * Lấy ngữ cảnh tenant do `TenantGuard` trao cho module Operator-owned (vehicle, route, stop-point).
 * Guard đã chặn, nhưng service kiểm lại (defense-in-depth): mọi truy vấn phải chạy trong scope tenant
 * và lọc đúng `operatorId` đó.
 */
export function requireTenant(authz: Authorization): { db: DbScope; operatorId: string } {
  // Chỉ grant phạm vi `tenant`: TenantGuard đổi grant `assigned` (Employee) thành scope cả tenant, mà
  // các module này chưa lọc theo phân công (EMP-001) → lỡ cho Employee vào sẽ lộ dữ liệu cả nhà xe.
  if (authz.scope !== "tenant" || authz.db?.kind !== "tenant") {
    throw tenantScopeViolation();
  }
  return { db: authz.db, operatorId: authz.db.operatorId };
}

/**
 * Ngữ cảnh tenant cho thao tác của Employee (grant `assigned` — TASK-EMP-002): TenantGuard trao scope cả tenant, nên service
 * dùng hàm này PHẢI tự lọc theo phân công của chính nhân viên trước khi đọc / ghi dữ liệu chuyến.
 */
export function requireAssignedTenant(authz: Authorization): { db: DbScope; operatorId: string } {
  if (authz.scope !== "assigned" || authz.db?.kind !== "tenant") {
    throw tenantScopeViolation();
  }
  return { db: authz.db, operatorId: authz.db.operatorId };
}
