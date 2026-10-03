import { type CanActivate, type ExecutionContext, Injectable } from "@nestjs/common";
import { type DbScope, platformScope, tenantScope } from "../../database/db-scope";
import { tenantScopeViolation } from "./authorization.errors";
import type { AuthorizedRequest } from "./authorization";

/**
 * Bước 3 của `@Authorize()` — ranh giới tenant ở lớp ứng dụng (ADR-017, BR-08). Lớp thứ hai là RLS
 * Postgres, dùng chính `DbScope` guard này đưa ra.
 *
 * Tenant lấy từ JWT (API §7.3 `/operator/*` không mang slug — quyết định Q2). Route nào CÓ
 * `:operatorSlug`/`:operatorId` thì tham số đó phải khớp claim, lệch → 403.
 */
@Injectable()
export class TenantGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest<AuthorizedRequest>();
    const { user, authz } = request;
    if (!user || !authz) {
      throw new Error("TenantGuard phải chạy sau AccessTokenGuard + PermissionGuard.");
    }

    authz.db = this.resolveScope(request);
    return true;
  }

  private resolveScope(request: AuthorizedRequest): DbScope | null {
    const user = request.user!;
    const { scope } = request.authz!;

    if (scope === "tenant" || scope === "assigned") {
      // Grant phạm vi tenant chỉ có nghĩa với token phía Operator mang đủ claim tenant.
      if (user.scope !== "operator" || !user.operatorId) {
        throw tenantScopeViolation();
      }
      const params = request.params as Record<string, string | undefined>;
      if (
        params.operatorSlug !== undefined &&
        params.operatorSlug.toLowerCase() !== user.operatorSlug?.toLowerCase()
      ) {
        throw tenantScopeViolation();
      }
      if (params.operatorId !== undefined && params.operatorId !== user.operatorId) {
        throw tenantScopeViolation();
      }
      return tenantScope(user.operatorId);
    }

    if (scope === "any" && user.scope === "platform") {
      return platformScope();
    }
    return null;
  }
}
