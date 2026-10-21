import {
  applyDecorators,
  type CanActivate,
  createParamDecorator,
  type ExecutionContext,
  Inject,
  Injectable,
  SetMetadata,
  UseGuards,
} from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { ApiResponse, getSchemaPath } from "@nestjs/swagger";
import type { AuthenticatedRequest } from "../auth/access-token.guard";
import { TokenService, type VerifiedAccessToken } from "../auth/token.service";
import { accessCredential } from "../auth/web/auth-transport";
import { sessionExpired } from "../session/session.errors";
import { SessionService } from "../session/session.service";
import { ProblemDetailsDto } from "../../openapi/openapi.dto";
import { can } from "./access-policy";
import { permissionDenied } from "./authorization.errors";
import type { Permission } from "./permissions";

const GUEST_PERMISSION = "iam:guest-or-passenger-permission";

/**
 * Route mở cho cả khách vãng lai lẫn hành khách đã đăng nhập (giữ chỗ, đặt vé, thanh toán, hủy vé — FR-BTP "Guest, User").
 * Không token → khách (`ANONYMOUS`); có token → phải hợp lệ + phiên còn sống (sai / hết hạn → 401 để client làm mới), và
 * role phải có `permission` ở phạm vi `own` — role có quyền đó ở phạm vi khác (vd chủ nhà xe `refund:request` theo tenant,
 * Admin) → 403: thao tác thay hành khách là luồng riêng. Quyết định qua `can()`, không so tên role.
 */
@Injectable()
export class GuestOrPassengerGuard implements CanActivate {
  constructor(
    @Inject(TokenService) private readonly tokens: TokenService,
    @Inject(SessionService) private readonly sessions: SessionService,
    @Inject(Reflector) private readonly reflector: Reflector,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const permission = this.reflector.get<Permission>(GUEST_PERMISSION, context.getHandler());
    const request = context.switchToHttp().getRequest<AuthenticatedRequest>();
    const credential = accessCredential(request);
    if (!credential) {
      if (!can(null, permission).allowed) {
        throw permissionDenied();
      }
      return true;
    }
    const claims = await this.tokens.verifyAccessToken(credential.token);
    if (!claims) {
      throw sessionExpired();
    }
    await this.sessions.assertActive(claims.sid);
    const decision = can(claims, permission);
    if (!decision.allowed || decision.scope !== "own") {
      throw permissionDenied();
    }
    request.user = claims;
    request.authCredentialSource = credential.source;
    return true;
  }
}

export function GuestOrPassenger(permission: Permission): MethodDecorator {
  return applyDecorators(
    SetMetadata(GUEST_PERMISSION, permission),
    UseGuards(GuestOrPassengerGuard),
    ApiResponse({
      status: 401,
      description: "Gửi token nhưng token sai / hết hạn (không gửi token = khách vãng lai).",
      content: { "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } } },
    }),
  );
}

/** Hành khách đã đăng nhập, hoặc `null` khi là khách vãng lai. Chỉ dùng trên route có `@GuestOrPassenger`. */
export const OptionalPassenger = createParamDecorator(
  (_data: unknown, context: ExecutionContext): VerifiedAccessToken | null =>
    context.switchToHttp().getRequest<AuthenticatedRequest>().user ?? null,
);
