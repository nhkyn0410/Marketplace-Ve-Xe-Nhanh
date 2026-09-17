import {
  type CanActivate,
  type ExecutionContext,
  Injectable,
} from "@nestjs/common";
import type { Request } from "express";
import { SessionRevocationStore } from "../session/session-revocation.store";
import { sessionExpired } from "../session/session.errors";
import { TokenService, type VerifiedAccessToken } from "./token.service";

export type AuthenticatedRequest = Request & { user?: VerifiedAccessToken };

/**
 * CHỈ xác thực "đã đăng nhập, phiên chưa bị revoke". KHÔNG phân quyền, KHÔNG kiểm tenant —
 * RBAC 8 role + `TenantGuard` khớp `:operatorSlug` là IAM-003, đừng nhét vào đây.
 */
@Injectable()
export class AccessTokenGuard implements CanActivate {
  constructor(
    private readonly tokens: TokenService,
    private readonly revocations: SessionRevocationStore,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<AuthenticatedRequest>();
    const token = bearerToken(request.headers.authorization);
    // Verify chữ ký TRƯỚC khi hỏi Redis: token rác không tốn lệnh Redis nào.
    const claims = token ? await this.tokens.verifyAccessToken(token) : null;
    if (!claims) {
      throw sessionExpired();
    }
    if (await this.revocations.isRevoked(claims.sid)) {
      throw sessionExpired();
    }
    request.user = claims;
    return true;
  }
}

/** Scheme không phân biệt hoa thường (RFC 7235) — client Dart từng gửi `bearer`. */
function bearerToken(header: string | undefined): string | undefined {
  return /^Bearer\s+(\S+)$/i.exec(header ?? "")?.[1];
}
