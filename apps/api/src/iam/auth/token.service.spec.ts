import { beforeAll, describe, expect, it } from "vitest";
import type { AppConfig } from "../../config/env.config";
import { TokenService } from "./token.service";

const config = {
  NODE_ENV: "test",
  JWT_ACCESS_TTL_SECONDS: 900,
  JWT_ISSUER: "vexenhanh-test"
} as AppConfig;

describe("TokenService", () => {
  let service: TokenService;

  beforeAll(async () => {
    service = new TokenService(config);
    await service.onModuleInit();
  });

  it("mints an RS256 access token carrying the expected claims", async () => {
    const issued = await service.mintAccessToken({
      sub: "acc-1",
      scope: "operator",
      role: "OPERATOR_OWNER",
      operatorId: "op-1",
      operatorSlug: "phuongtrang"
    });

    expect(issued.tokenType).toBe("Bearer");
    expect(issued.expiresInSeconds).toBe(900);

    const { decodeJwt, decodeProtectedHeader } = await import("jose");
    expect(decodeProtectedHeader(issued.accessToken).alg).toBe("RS256");

    const payload = decodeJwt(issued.accessToken);
    expect(payload.sub).toBe("acc-1");
    expect(payload.scope).toBe("operator");
    expect(payload.role).toBe("OPERATOR_OWNER");
    expect(payload.operatorId).toBe("op-1");
    expect(payload.operatorSlug).toBe("phuongtrang");
    expect(payload.iss).toBe("vexenhanh-test");
    expect(payload.exp).toBeGreaterThan(payload.iat ?? 0);
  });

  it("omits operator claims for a passenger token", async () => {
    const issued = await service.mintAccessToken({
      sub: "user-1",
      scope: "passenger",
      role: "PASSENGER"
    });
    const { decodeJwt } = await import("jose");
    const payload = decodeJwt(issued.accessToken);
    expect(payload.scope).toBe("passenger");
    expect(payload.operatorId).toBeUndefined();
    expect(payload.operatorSlug).toBeUndefined();
  });
});
