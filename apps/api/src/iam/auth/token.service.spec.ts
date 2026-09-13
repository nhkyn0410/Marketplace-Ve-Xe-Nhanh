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

  it("chữ ký RS256 verify được thật bằng public key tương ứng", async () => {
    // `decodeJwt` KHÔNG kiểm chữ ký — đường ký hỏng (sai key, sai alg) mà test vẫn xanh thì
    // guard này vô nghĩa. Dùng keypair tự cấp qua config để verify thật, đồng thời phủ luôn
    // nhánh nạp key từ env (nhánh chạy ở production) chứ không phải nhánh ephemeral của dev.
    const { generateKeyPair, exportPKCS8, exportSPKI, importSPKI, jwtVerify } = await import("jose");
    const pair = await generateKeyPair("RS256", { extractable: true });
    const keyed = new TokenService({
      ...config,
      JWT_ACCESS_PRIVATE_KEY: await exportPKCS8(pair.privateKey)
    } as AppConfig);
    await keyed.onModuleInit();

    const issued = await keyed.mintAccessToken({
      sub: "acc-9",
      scope: "platform",
      role: "PLATFORM_ADMIN"
    });
    const publicKey = await importSPKI(await exportSPKI(pair.publicKey), "RS256");

    const { payload } = await jwtVerify(issued.accessToken, publicKey, {
      issuer: "vexenhanh-test",
      algorithms: ["RS256"]
    });
    expect(payload.sub).toBe("acc-9");

    // Token bị sửa ở phần chữ ký phải bị từ chối.
    const tampered = issued.accessToken.slice(0, -2) + (issued.accessToken.endsWith("A") ? "B" : "A");
    await expect(jwtVerify(tampered, publicKey)).rejects.toThrow();
  });

  it("thiếu private key ở production thì fail-fast, không im lặng dùng key ephemeral", async () => {
    const prod = new TokenService({
      ...config,
      NODE_ENV: "production",
      JWT_ACCESS_PRIVATE_KEY: undefined
    } as AppConfig);
    await expect(prod.onModuleInit()).rejects.toThrow(/JWT_ACCESS_PRIVATE_KEY/);
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
