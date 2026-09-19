import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import type { INestApplication } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import type Redis from "ioredis";
import { ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { AppModule } from "../../app.module";
import { ProblemDetailsExceptionFilter } from "../../common/errors/problem-details.filter";
import { type DbTransaction, PrismaService } from "../../database/prisma.service";
import { configureApiRoutes } from "../../openapi/openapi";
import { REDIS_CLIENT } from "../../redis/redis.config";
import { CredentialService } from "./credential.service";
import { generateTotp } from "./totp";

/**
 * E2E IAM-002 qua HTTP thật (app đầy đủ, Postgres + Redis + Mongo thật). Cùng lối
 * `proxy-auth.integration.spec.ts`: `listen(0)` + `fetch`, không thêm Supertest.
 * Thiếu hạ tầng thì tự bỏ qua; CI job `db-integration` đặt REQUIRE_DB_TESTS=1 để bắt buộc chạy.
 */
const ready = Boolean(
  process.env.DATABASE_URL && process.env.REDIS_URL && process.env.MONGODB_AUDIT_URI,
);

/**
 * `auth_sessions` có RLS (TASK-IAM-003): test đọc/ghi thẳng bảng thì phải qua ngữ cảnh system,
 * giống code thật. Proxy giữ nguyên cú pháp `sessionsTable.findMany(...)`.
 */
function systemSessions(prisma: PrismaService): DbTransaction["authSession"] {
  return new Proxy({} as DbTransaction["authSession"], {
    // `then` phải là undefined — nếu không Proxy bị coi là Promise khi lỡ `await`.
    get: (_target, operation: string) =>
      operation === "then"
        ? undefined
        : (args: unknown) =>
      prisma.withSystem((tx) =>
        (
          tx.authSession as unknown as Record<
            string,
            (args: unknown) => Promise<unknown>
          >
        )[operation]!(args),
      ),
  });
}

type TokenPair = {
  accessToken: string;
  refreshToken: string;
  refreshExpiresIn: number;
  expiresIn: number;
  scope: string;
};

function sidOf(accessToken: string): string {
  const payload = JSON.parse(
    Buffer.from(accessToken.split(".")[1] ?? "", "base64url").toString("utf8"),
  ) as { sid: string };
  return payload.sid;
}

// CI job `db-integration` đặt REQUIRE_DB_TESTS=1: thiếu hạ tầng thì ĐỎ thay vì lặng lẽ bỏ qua.
describe.skipIf(!ready && process.env.REQUIRE_DB_TESTS !== "1")("Auth session — HTTP thật (IAM-002)", () => {
  const username = `e2e_${randomUUID().slice(0, 8)}`;
  const password = `E2e!${randomUUID()}`;
  let app: INestApplication;
  let base: string;
  let prisma: PrismaService;
  let sessionsTable: DbTransaction["authSession"];
  let redis: Redis;
  let accountId: string;
  /** PLATFORM_ADMIN bắt buộc MFA (IAM-004): login đầu enrollment bằng TOTP, các lần sau dùng backup code. */
  let backupCodes: string[] = [];

  async function post(
    path: string,
    body?: unknown,
    accessToken?: string,
  ): Promise<{ status: number; json: Record<string, unknown>; headers: Headers }> {
    const response = await fetch(`${base}${path}`, {
      method: "POST",
      headers: {
        "content-type": "application/json",
        ...(accessToken ? { authorization: `Bearer ${accessToken}` } : {}),
      },
      body: body === undefined ? undefined : JSON.stringify(body),
    });
    const text = await response.text();
    return { status: response.status, json: text ? JSON.parse(text) : {}, headers: response.headers };
  }

  async function login(): Promise<TokenPair> {
    const { status, json } = await post("/auth/platform/login", {
      identifier: `platform/${username}`,
      password,
    });
    expect(status).toBe(200);
    expect(json).toMatchObject({ mfaRequired: true });
    expect(json).not.toHaveProperty("accessToken");
    // Mỗi backup code chỉ dùng một lần; TOTP cùng time-step cũng vậy → mỗi login tiêu một backup code.
    const code = json.enrollmentRequired
      ? generateTotp(new URL(String(json.otpAuthUri)).searchParams.get("secret")!)
      : backupCodes.shift();
    const verified = await post("/auth/mfa/verify", { challengeToken: json.challengeToken, code });
    expect(verified.status).toBe(200);
    if (verified.json.backupCodes) {
      backupCodes = verified.json.backupCodes as string[];
    }
    return verified.json as unknown as TokenPair;
  }

  /** Bucket rate limit của loopback tích luỹ qua các lần chạy test → 429 giả. */
  async function clearLoopbackBuckets(): Promise<void> {
    await redis.del("login:ip:127.0.0.1", "refresh:ip:127.0.0.1");
  }

  beforeAll(async () => {
    app = await NestFactory.create(AppModule, { logger: false, abortOnError: false });
    app.useGlobalPipes(new ZodValidationPipe());
    app.useGlobalFilters(new ProblemDetailsExceptionFilter());
    configureApiRoutes(app);
    await app.listen(0, "127.0.0.1");
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1`;

    prisma = app.get(PrismaService);
    sessionsTable = systemSessions(prisma);
    redis = app.get<Redis>(REDIS_CLIENT);
    await clearLoopbackBuckets();

    const account = await prisma.platformAccount.create({
      data: {
        username,
        passwordHash: await new CredentialService().hash(password),
        role: "PLATFORM_ADMIN",
      },
    });
    accountId = account.id;
  }, 60_000);

  afterAll(async () => {
    if (prisma && accountId) {
      await sessionsTable.deleteMany({ where: { subjectId: accountId } });
      await prisma.withSystem((tx) => tx.mfaCredential.deleteMany({ where: { subjectId: accountId } }));
      await prisma.platformAccount.delete({ where: { id: accountId } });
    }
    if (redis) {
      await clearLoopbackBuckets();
      await redis.del(`login:id:platform/${username}`, `login:id:platform:${accountId}`);
    }
    await app?.close();
  });

  it("login trả CẶP token; JWT mang sid trỏ đúng một row auth_sessions", async () => {
    const pair = await login();

    expect(pair).toMatchObject({ expiresIn: 900, scope: "platform" });
    expect(pair.refreshToken).toEqual(expect.any(String));
    expect(pair.refreshExpiresIn).toBe(30 * 24 * 60 * 60);

    const row = await sessionsTable.findUniqueOrThrow({
      where: { id: sidOf(pair.accessToken) },
    });
    expect(row.subjectType).toBe("PLATFORM");
    expect(row.mfaVerifiedAt).toBeInstanceOf(Date);
    // Chỉ hash nằm trong DB.
    expect(JSON.stringify(row)).not.toContain(pair.refreshToken);
  });

  it("⭐ TC-SEC-002: refresh xoay vòng; dùng lại token cũ → 401 VÀ token mới cũng chết", async () => {
    const first = await login();
    const rotated = await post("/auth/refresh", { refreshToken: first.refreshToken });
    expect(rotated.status).toBe(200);
    // Response mang token không được lưu ở proxy/CDN (RFC 6749 §5.1).
    expect(rotated.headers.get("cache-control")).toBe("no-store");
    const second = rotated.json as unknown as TokenPair;
    expect(second.refreshToken).not.toBe(first.refreshToken);
    expect(sidOf(second.accessToken)).not.toBe(sidOf(first.accessToken));

    const reuse = await post("/auth/refresh", { refreshToken: first.refreshToken });
    expect(reuse).toMatchObject({ status: 401, json: { code: "AUTH_SESSION_EXPIRED" } });

    const afterFamilyRevoke = await post("/auth/refresh", { refreshToken: second.refreshToken });
    expect(afterFamilyRevoke.status).toBe(401);

    // Access token của phiên mới cũng bị chặn ngay, không đợi hết 15 phút.
    const guarded = await post("/auth/re-auth", { password }, second.accessToken);
    expect(guarded.status).toBe(401);
  });

  it("hai refresh song song cùng một token → đúng một 200", async () => {
    const pair = await login();
    const results = await Promise.all([
      post("/auth/refresh", { refreshToken: pair.refreshToken }),
      post("/auth/refresh", { refreshToken: pair.refreshToken }),
    ]);
    expect(results.map((r) => r.status).sort()).toEqual([200, 401]);
  });

  it("refresh không tồn tại → cùng 401 AUTH_SESSION_EXPIRED; body sai → 400", async () => {
    expect(await post("/auth/refresh", { refreshToken: "khong-ton-tai" })).toMatchObject({
      status: 401,
      json: { code: "AUTH_SESSION_EXPIRED" },
    });
    expect((await post("/auth/refresh", {})).status).toBe(400);
  });

  it("logout: 200 hai lần; refresh cũ chết; access token còn hạn bị chặn; khoá Redis TTL ~900s", async () => {
    const pair = await login();
    const sid = sidOf(pair.accessToken);

    expect((await post("/auth/logout", undefined, pair.accessToken)).status).toBe(200);
    expect((await post("/auth/logout", undefined, pair.accessToken)).status).toBe(200);

    expect((await post("/auth/refresh", { refreshToken: pair.refreshToken })).status).toBe(401);
    expect((await post("/auth/re-auth", { password }, pair.accessToken)).status).toBe(401);

    const ttl = await redis.ttl(`session:revoked:${sid}`);
    expect(ttl).toBeGreaterThan(800);
    expect(ttl).toBeLessThanOrEqual(900);
  });

  it("logout không có Bearer / Bearer giả → 401", async () => {
    expect((await post("/auth/logout")).status).toBe(401);
    expect((await post("/auth/logout", undefined, "gia.mao.token")).status).toBe(401);
  });

  it("re-auth: sai mật khẩu 401, đúng mật khẩu 200 + bằng chứng reauth:{sid} TTL ≤ 300s", async () => {
    const pair = await login();
    const sid = sidOf(pair.accessToken);

    expect(await post("/auth/re-auth", { password: "SAI" }, pair.accessToken)).toMatchObject({
      status: 401,
      json: { code: "AUTH_INVALID_CREDENTIALS" },
    });
    expect(await redis.exists(`reauth:${sid}`)).toBe(0);

    expect((await post("/auth/re-auth", { password }, pair.accessToken)).status).toBe(200);
    const ttl = await redis.ttl(`reauth:${sid}`);
    expect(ttl).toBeGreaterThan(0);
    expect(ttl).toBeLessThanOrEqual(300);

    // Gửi cả hai hoặc không gửi gì → 400 (Zod refine).
    expect((await post("/auth/re-auth", {}, pair.accessToken)).status).toBe(400);
  });
});
