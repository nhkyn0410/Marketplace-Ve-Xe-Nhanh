import { createParamDecorator, type ExecutionContext } from "@nestjs/common";
import type { AuthenticatedRequest } from "./access-token.guard";
import type { VerifiedAccessToken } from "./token.service";

export const CurrentUser = createParamDecorator(
  (_data: unknown, context: ExecutionContext): VerifiedAccessToken => {
    const user = context.switchToHttp().getRequest<AuthenticatedRequest>().user;
    if (!user) {
      // Lỗi lập trình (quên guard) → 500 to rõ, không phải 401.
      throw new Error(
        "@CurrentUser() dùng trên route thiếu @UseGuards(AccessTokenGuard).",
      );
    }
    return user;
  },
);
