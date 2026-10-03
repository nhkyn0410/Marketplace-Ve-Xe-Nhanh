import { type CanActivate, type ExecutionContext, Injectable, Logger } from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { can } from "./access-policy";
import { permissionDenied } from "./authorization.errors";
import { type AuthorizedRequest, REQUIRED_PERMISSION } from "./authorization";
import type { Permission } from "./permissions";

/** Bước 2 của `@Authorize()`: role của token có quyền này không. Chạy SAU `AccessTokenGuard`. */
@Injectable()
export class PermissionGuard implements CanActivate {
  private readonly logger = new Logger(PermissionGuard.name);

  constructor(private readonly reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const permission = this.reflector.get<Permission | undefined>(
      REQUIRED_PERMISSION,
      context.getHandler(),
    );
    if (!permission) {
      throw new Error("PermissionGuard dùng trên route thiếu @Authorize(permission).");
    }
    const request = context.switchToHttp().getRequest<AuthorizedRequest>();
    const user = request.user;
    if (!user) {
      throw new Error("PermissionGuard phải chạy sau AccessTokenGuard.");
    }

    const decision = can(user, permission);
    if (!decision.allowed) {
      if (decision.reason === "unknown_role") {
        // Token ký hợp lệ mà role lạ = bảng quyền và nơi phát token lệch nhau — cần người xem.
        this.logger.warn({ event: "authz.unknown_role", role: user.role, permission });
      }
      throw permissionDenied();
    }
    request.authz = { permission, scope: decision.scope, db: null };
    return true;
  }
}
