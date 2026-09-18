import { randomUUID } from "node:crypto";
import { afterEach, beforeAll, describe, expect, it, vi } from "vitest";
import type { AppConfig } from "../../config/env.config";
import { TokenService } from "./token.service";

const config = {
  NODE_ENV: "test",
  JWT_ACCESS_TTL_SECONDS: 900,
  JWT_ISSUER: "vexenhanh-test",
} as AppConfig;

describe("TokenService", () => {
  let service: TokenService;

  beforeAll(async () => {
    service = new TokenService(config);
    await service.onModuleInit();
  });

  it("mints an RS256 access token carrying the expected claims", async () => {
    const sid = randomUUID();
    const issued = await service.mintAccessToken({
      sub: "acc-1",
      sid,
      scope: "operator",
      role: "OPERATOR_OWNER",
      operatorId: "op-1",
      operatorSlug: "phuongtrang",
    });

    expect(issued.tokenType).toBe("Bearer");
    expect(issued.expiresInSeconds).toBe(900);

    const { decodeJwt, decodeProtectedHeader } = await import("jose");
    expect(decodeProtectedHeader(issued.accessToken).alg).toBe("RS256");

    const payload = decodeJwt(issued.accessToken);
    expect(payload.sub).toBe("acc-1");
    expect(payload.sid).toBe(sid);
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
    const { generateKeyPair, exportPKCS8, exportSPKI, importSPKI, jwtVerify } =
      await import("jose");
    const pair = await generateKeyPair("RS256", { extractable: true });
    const keyed = new TokenService({
      ...config,
      JWT_ACCESS_PRIVATE_KEY: await exportPKCS8(pair.privateKey),
    } as AppConfig);
    await keyed.onModuleInit();

    const issued = await keyed.mintAccessToken({
      sub: "acc-9",
      sid: randomUUID(),
      scope: "platform",
      role: "PLATFORM_ADMIN",
    });
    const publicKey = await importSPKI(
      await exportSPKI(pair.publicKey),
      "RS256",
    );

    const { payload } = await jwtVerify(issued.accessToken, publicKey, {
      issuer: "vexenhanh-test",
      algorithms: ["RS256"],
    });
    expect(payload.sub).toBe("acc-9");

    // Token bị sửa ở phần chữ ký phải bị từ chối.
    const tampered =
      issued.accessToken.slice(0, -2) +
      (issued.accessToken.endsWith("A") ? "B" : "A");
    await expect(jwtVerify(tampered, publicKey)).rejects.toThrow();
  });

  it("thiếu private key ở production thì fail-fast, không im lặng dùng key ephemeral", async () => {
    const prod = new TokenService({
      ...config,
      NODE_ENV: "production",
      JWT_ACCESS_PRIVATE_KEY: undefined,
    } as AppConfig);
    await expect(prod.onModuleInit()).rejects.toThrow(/JWT_ACCESS_PRIVATE_KEY/);
  });

  it("omits operator claims for a passenger token", async () => {
    const issued = await service.mintAccessToken({
      sub: "user-1",
      sid: randomUUID(),
      scope: "passenger",
      role: "PASSENGER",
    });
    const { decodeJwt } = await import("jose");
    const payload = decodeJwt(issued.accessToken);
    expect(payload.scope).toBe("passenger");
    expect(payload.operatorId).toBeUndefined();
    expect(payload.operatorSlug).toBeUndefined();
  });
});

describe("TokenService.verifyAccessToken", () => {
  const claims = {
    sub: "acc-1",
    sid: randomUUID(),
    scope: "operator" as const,
    role: "OPERATOR_OWNER",
    operatorId: "op-1",
  };
  let service: TokenService;

  beforeAll(async () => {
    service = new TokenService(config);
    await service.onModuleInit();
  });
  afterEach(() => vi.useRealTimers());

  it("token hợp lệ → trả claim, có sid", async () => {
    const { accessToken } = await service.mintAccessToken(claims);
    expect(await service.verifyAccessToken(accessToken)).toMatchObject(claims);
  });

  it("key nạp từ env: verify bằng public key suy từ private key", async () => {
    const { generateKeyPair, exportPKCS8 } = await import("jose");
    const pair = await generateKeyPair("RS256", { extractable: true });
    const keyed = new TokenService({
      ...config,
      JWT_ACCESS_PRIVATE_KEY: await exportPKCS8(pair.privateKey),
    } as AppConfig);
    await keyed.onModuleInit();
    const { accessToken } = await keyed.mintAccessToken(claims);
    expect(await keyed.verifyAccessToken(accessToken)).not.toBeNull();
  });

  it("token không có sid (kiểu IAM-001) → null", async () => {
    // Kiểu đã bắt buộc `sid` từ IAM-002.6; ép kiểu để dựng lại đúng token IAM-001 còn lưu hành.
    const { accessToken } = await service.mintAccessToken({
      ...claims,
      sid: undefined as unknown as string,
    });
    expect(await service.verifyAccessToken(accessToken)).toBeNull();
  });

  it("sửa chữ ký → null", async () => {
    const { accessToken } = await service.mintAccessToken(claims);
    const tampered =
      accessToken.slice(0, -2) + (accessToken.endsWith("A") ? "B" : "A");
    expect(await service.verifyAccessToken(tampered)).toBeNull();
  });

  it("ký bởi key khác → null", async () => {
    const other = new TokenService(config);
    await other.onModuleInit();
    const { accessToken } = await other.mintAccessToken(claims);
    expect(await service.verifyAccessToken(accessToken)).toBeNull();
  });

  it("sai issuer → null", async () => {
    const { generateKeyPair, exportPKCS8 } = await import("jose");
    const pem = await exportPKCS8(
      (await generateKeyPair("RS256", { extractable: true })).privateKey,
    );
    const ours = new TokenService({
      ...config,
      JWT_ACCESS_PRIVATE_KEY: pem,
    } as AppConfig);
    await ours.onModuleInit();
    const foreign = new TokenService({
      ...config,
      JWT_ACCESS_PRIVATE_KEY: pem,
      JWT_ISSUER: "ke-khac",
    } as AppConfig);
    await foreign.onModuleInit();
    const { accessToken } = await foreign.mintAccessToken(claims);
    // Cùng một key, chỉ khác issuer — để chắc chắn test này đỏ vì issuer chứ không vì chữ ký.
    expect(await foreign.verifyAccessToken(accessToken)).not.toBeNull();
    expect(await ours.verifyAccessToken(accessToken)).toBeNull();
  });

  it("hết hạn → null", async () => {
    const { accessToken } = await service.mintAccessToken(claims);
    vi.useFakeTimers({ toFake: ["Date"] });
    vi.setSystemTime(Date.now() + 901_000);
    expect(await service.verifyAccessToken(accessToken)).toBeNull();
  });

  it("ký hợp lệ nhưng thiếu exp → null (không được sống vĩnh viễn)", async () => {
    const { generateKeyPair, exportPKCS8, SignJWT } = await import("jose");
    const pair = await generateKeyPair("RS256", { extractable: true });
    const keyed = new TokenService({
      ...config,
      JWT_ACCESS_PRIVATE_KEY: await exportPKCS8(pair.privateKey),
    } as AppConfig);
    await keyed.onModuleInit();
    const noExp = await new SignJWT({ ...claims })
      .setProtectedHeader({ alg: "RS256" })
      .setIssuer("vexenhanh-test")
      .setIssuedAt()
      .sign(pair.privateKey);
    expect(await keyed.verifyAccessToken(noExp)).toBeNull();
  });

  it("alg none → null", async () => {
    const b64 = (o: object) =>
      Buffer.from(JSON.stringify(o)).toString("base64url");
    const now = Math.floor(Date.now() / 1000);
    const unsigned = `${b64({ alg: "none", typ: "JWT" })}.${b64({ ...claims, iss: "vexenhanh-test", iat: now, exp: now + 900 })}.`;
    expect(await service.verifyAccessToken(unsigned)).toBeNull();
  });
});
