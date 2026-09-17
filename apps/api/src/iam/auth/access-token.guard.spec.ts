import { randomUUID } from "node:crypto";
import type { ExecutionContext, HttpException } from "@nestjs/common";
import type Redis from "ioredis";
import { beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import type { AppConfig } from "../../config/env.config";
import { SessionRevocationStore } from "../session/session-revocation.store";
import {
  AccessTokenGuard,
  type AuthenticatedRequest,
} from "./access-token.guard";
import { TokenService } from "./token.service";

const config = {
  NODE_ENV: "test",
  JWT_ACCESS_TTL_SECONDS: 900,
  JWT_ISSUER: "vexenhanh-test",
} as AppConfig;

async function problemOf(
  promise: Promise<unknown>,
): Promise<{ status: number; code?: string }> {
  try {
    await promise;
    return { status: 0 };
  } catch (error) {
    const exception = error as HttpException;
    return {
      status: exception.getStatus(),
      code: (exception.getResponse() as { code?: string }).code,
    };
  }
}

function contextWith(authorization?: string) {
  const request = { headers: { authorization } } as AuthenticatedRequest;
  const context = {
    switchToHttp: () => ({ getRequest: () => request }),
  } as unknown as ExecutionContext;
  return { request, context };
}

describe("AccessTokenGuard", () => {
  const exists = vi.fn();
  const set = vi.fn();
  const redis = { exists, set } as unknown as Redis;
  const sid = randomUUID();
  let guard: AccessTokenGuard;
  let valid: string;

  beforeAll(async () => {
    const tokens = new TokenService(config);
    await tokens.onModuleInit();
    guard = new AccessTokenGuard(
      tokens,
      new SessionRevocationStore(redis, config),
    );
    valid = (
      await tokens.mintAccessToken({
        sub: "u-1",
        sid,
        scope: "passenger",
        role: "PASSENGER",
      })
    ).accessToken;
  });

  beforeEach(() => {
    vi.clearAllMocks();
    exists.mockResolvedValue(0);
    set.mockResolvedValue("OK");
  });

  it("token hợp lệ, chưa revoke → cho qua và gắn claim vào request", async () => {
    const { request, context } = contextWith(`Bearer ${valid}`);
    expect(await guard.canActivate(context)).toBe(true);
    expect(request.user?.sid).toBe(sid);
    expect(exists).toHaveBeenCalledWith(`session:revoked:${sid}`);
  });

  it("scheme không phân biệt hoa thường (RFC 7235)", async () => {
    expect(
      await guard.canActivate(contextWith(`bearer ${valid}`).context),
    ).toBe(true);
  });

  it.each([[undefined], ["Basic abc"], ["Bearer"], ["Bearer khong-phai-jwt"]])(
    "header %s → 401, không chạm Redis",
    async (header) => {
      expect(
        await problemOf(guard.canActivate(contextWith(header).context)),
      ).toEqual({
        status: 401,
        code: "AUTH_SESSION_EXPIRED",
      });
      expect(exists).not.toHaveBeenCalled();
    },
  );

  it("token hợp lệ nhưng sid đã revoke → 401", async () => {
    exists.mockResolvedValue(1);
    expect(
      await problemOf(
        guard.canActivate(contextWith(`Bearer ${valid}`).context),
      ),
    ).toEqual({
      status: 401,
      code: "AUTH_SESSION_EXPIRED",
    });
  });

  it("Redis lỗi → 503, KHÔNG cho qua", async () => {
    exists.mockRejectedValue(new Error("Command timed out"));
    expect(
      await problemOf(
        guard.canActivate(contextWith(`Bearer ${valid}`).context),
      ),
    ).toEqual({
      status: 503,
      code: "SERVICE_UNAVAILABLE",
    });
  });

  it("markRevoked ghi đúng khoá guard đọc, TTL = TTL access token", async () => {
    await new SessionRevocationStore(redis, config).markRevoked(sid);
    expect(set).toHaveBeenCalledWith(`session:revoked:${sid}`, "1", "EX", 900);
  });
});
