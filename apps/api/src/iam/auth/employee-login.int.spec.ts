import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import type { INestApplication } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import type Redis from "ioredis";
import { ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, beforeEach, describe, expect, it } from "vitest";
import { AppModule } from "../../app.module";
import { ProblemDetailsExceptionFilter } from "../../common/errors/problem-details.filter";
import { PrismaService } from "../../database/prisma.service";
import { configureApiRoutes } from "../../openapi/openapi";
import { REDIS_CLIENT } from "../../redis/redis.config";
import { CredentialService } from "./credential.service";

/**
 * TASK-IAM-006 — tách cổng login Owner/Employee (ADR-017 amend 28/09/2026, TC-SEC-009/010) qua HTTP
 * thật: Postgres (role app) + Redis + Mongo thật. Unit test chỉ chứng minh mỗi cổng tra đúng bảng;
 * ở đây kiểm cái unit test không thấy được: account đúng mật khẩu ở sai cổng không để lại phiên nào.
 */
const ready = Boolean(process.env.DATABASE_URL && process.env.REDIS_URL && process.env.MONGODB_AUDIT_URI);

type Json = Record<string, unknown>;

describe.skipIf(!ready && process.env.REQUIRE_DB_TESTS !== "1")("Tách cổng login Owner/Employee — HTTP thật (IAM-006)", () => {
  const tag = randomUUID().slice(0, 8);
  const password = `Portal!${randomUUID()}`;
  const operatorId = randomUUID();
  const operatorSlug = `portal-${tag}`;
  const ownerIdentifier = `${operatorSlug}/owner-${tag}`;
  const employeeIdentifier = `${operatorSlug}/nv.driver-${tag}`;
  let ownerId = "";
  let employeeId = "";
  let app: INestApplication;
  let base: string;
  let prisma: PrismaService;
  let redis: Redis;

  async function request(
    method: "GET" | "POST",
    path: string,
    options: { body?: unknown; headers?: Record<string, string> } = {},
  ): Promise<{ status: number; json: Json; setCookie: string | null }> {
    const response = await fetch(`${base}${path}`, {
      method,
      headers: { "content-type": "application/json", ...options.headers },
      body: options.body === undefined ? undefined : JSON.stringify(options.body),
    });
    const text = await response.text();
    return {
      status: response.status,
      json: text ? (JSON.parse(text) as Json) : {},
      setCookie: response.headers.get("set-cookie"),
    };
  }

  const login = (path: string, identifier: string, headers?: Record<string, string>) =>
    request("POST", path, { body: { identifier, password }, headers });

  async function sessionCount(subjectId: string): Promise<number> {
    return prisma.withSystem((tx) => tx.authSession.count({ where: { subjectId } }));
  }

  /** Phần response mà client nhìn thấy để phân biệt — `instance`/`requestId` luôn khác nhau. */
  function visible(json: Json) {
    return { code: json.code, detail: json.detail, title: json.title };
  }

  beforeAll(async () => {
    app = await NestFactory.create(AppModule, { logger: false, abortOnError: false });
    app.useGlobalPipes(new ZodValidationPipe());
    app.useGlobalFilters(new ProblemDetailsExceptionFilter());
    configureApiRoutes(app);
    await app.listen(0, "127.0.0.1");
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1`;
    prisma = app.get(PrismaService);
    redis = app.get<Redis>(REDIS_CLIENT);

    const [role] = await prisma.$queryRaw<{ rolsuper: boolean; rolbypassrls: boolean }[]>`
      SELECT rolsuper, rolbypassrls FROM pg_roles WHERE rolname = current_user`;
    // Chống xanh giả: superuser/BYPASSRLS thì phép tra "chỉ trong tenant" bên dưới vô nghĩa.
    if (!role || role.rolsuper || role.rolbypassrls) {
      throw new Error("DATABASE_URL phải là role app (IAM-003-guide §1), không phải superuser/BYPASSRLS.");
    }
    const passwordHash = await new CredentialService().hash(password);

    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.create({
        data: { id: operatorId, operatorSlug, displayName: "Portal split test", status: "ACTIVE" },
      });
      ownerId = (
        await tx.operatorAccount.create({
          data: { operatorId, operatorSlug, username: `owner-${tag}`, passwordHash, role: "OPERATOR_OWNER" },
        })
      ).id;
      employeeId = (
        await tx.employeeAccount.create({
          data: { operatorId, username: `nv.driver-${tag}`, passwordHash, role: "DRIVER" },
        })
      ).id;
    });
  }, 60_000);

  beforeEach(async () => {
    // Mọi request đi từ loopback: bucket IP tích luỹ qua các test → 429 giả.
    await redis.del("login:ip:127.0.0.1");
  });

  afterAll(async () => {
    if (prisma) {
      await prisma.withSystem(async (tx) => {
        await tx.authSession.deleteMany({ where: { subjectId: { in: [ownerId, employeeId] } } });
        await tx.employeeAccount.deleteMany({ where: { operatorId } });
        await tx.operatorAccount.deleteMany({ where: { operatorId } });
        await tx.operatorProfile.deleteMany({ where: { id: operatorId } });
      });
    }
    if (redis) {
      const keys = await redis.keys(`login:id:*${tag}*`);
      if (keys.length) {
        await redis.del(...keys);
      }
      await redis.del("login:ip:127.0.0.1");
    }
    await app?.close();
  });

  it("Employee đúng mật khẩu ở cổng Owner → 401 y hệt account không tồn tại, không tạo phiên", async () => {
    const wrongPortal = await login("/auth/operator/login", employeeIdentifier);
    const unknown = await login("/auth/operator/login", `${operatorSlug}/nv.ghost-${tag}`);

    expect(wrongPortal).toMatchObject({ status: 401, json: { code: "AUTH_INVALID_CREDENTIALS" } });
    expect(visible(wrongPortal.json)).toEqual(visible(unknown.json));
    expect(wrongPortal.json).not.toHaveProperty("accessToken");
    expect(wrongPortal.json).not.toHaveProperty("passwordChangeToken");
    expect(await sessionCount(employeeId)).toBe(0);
  });

  it("Owner đúng mật khẩu ở cổng Employee → 401, không MFA challenge, không phiên", async () => {
    // Đối chứng: cùng mật khẩu ở đúng cổng Owner thì ra challenge MFA (Owner bắt buộc TOTP).
    expect(await login("/auth/operator/login", ownerIdentifier)).toMatchObject({
      status: 200,
      json: { mfaRequired: true },
    });

    const wrongPortal = await login("/auth/employee/login", ownerIdentifier);
    const unknown = await login("/auth/employee/login", `${operatorSlug}/owner-ghost-${tag}`);

    expect(wrongPortal).toMatchObject({ status: 401, json: { code: "AUTH_INVALID_CREDENTIALS" } });
    expect(visible(wrongPortal.json)).toEqual(visible(unknown.json));
    expect(wrongPortal.json).not.toHaveProperty("challengeToken");
    expect(await sessionCount(ownerId)).toBe(0);
  });

  it("cổng Employee trả token JSON, không Set-Cookie; token dùng được và phiên ghi subject EMPLOYEE", async () => {
    const before = await sessionCount(employeeId);
    const ok = await login("/auth/employee/login", employeeIdentifier);

    expect(ok.status).toBe(200);
    expect(ok.json).toMatchObject({ mfaRequired: false, tokenType: "Bearer", scope: "operator", role: "DRIVER" });
    expect(typeof ok.json.refreshToken).toBe("string");
    expect(ok.setCookie).toBeNull();

    const sessions = await request("GET", "/auth/sessions", {
      headers: { authorization: `Bearer ${String(ok.json.accessToken)}` },
    });
    expect(sessions.status).toBe(200);
    expect(await sessionCount(employeeId)).toBe(before + 1);
    const created = await prisma.withSystem((tx) =>
      tx.authSession.findMany({ where: { subjectId: employeeId }, select: { subjectType: true } }),
    );
    expect(created.every((row) => row.subjectType === "EMPLOYEE")).toBe(true);
  });

  it("X-Auth-Transport: cookie ở cổng Employee → 400 AUTH_TRANSPORT_INVALID, không phiên, không cookie", async () => {
    const before = await sessionCount(employeeId);
    const rejected = await login("/auth/employee/login", employeeIdentifier, { "x-auth-transport": "cookie" });

    expect(rejected).toMatchObject({ status: 400, json: { code: "AUTH_TRANSPORT_INVALID" } });
    expect(rejected.setCookie).toBeNull();
    expect(await sessionCount(employeeId)).toBe(before);
  });
});
