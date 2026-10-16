import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { type AccessTokenClaims, TokenService } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { SessionService } from "../iam/session/session.service";
import { configureApiRoutes } from "../openapi/openapi";
import { AdminAuditLogController } from "./admin-audit-log.controller";
import { AdminAuditLogService } from "./admin-audit-log.service";

/** Chuỗi guard thật của `/admin/audit-logs` (UC-30); nghiệp vụ test ở `.int.spec.ts`. */
describe("Admin nhật ký audit — HTTP", () => {
  const id = "0123456789abcdef01234567";
  const service = {
    list: vi.fn(async () => ({ items: [], nextCursor: null, total: 0 })),
    get: vi.fn(async () => ({
      id,
      createdAt: new Date().toISOString(),
      actorId: null,
      actorName: null,
      actorRole: null,
      actorType: "SYSTEM",
      action: "trip.status.change",
      module: "TRIP",
      result: "SUCCESS",
      targetType: "trip",
      targetId: "t",
      operator: null,
      reason: null,
      before: null,
      after: null,
      ip: null,
      device: null,
      requestId: null,
      related: [],
    })),
  };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;
  const config = { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig;

  @Module({
    controllers: [AdminAuditLogController],
    providers: [
      { provide: APP_CONFIG, useValue: config },
      TokenService,
      { provide: AdminAuditLogService, useValue: service },
      {
        provide: SessionService,
        useValue: {
          assertActive: async () => undefined,
          assertOperatorAccountCurrent: async () => undefined,
          hasRecentReauth: async () => false,
        },
      },
    ],
  })
  class HttpTestModule {}

  beforeAll(async () => {
    app = await NestFactory.create(HttpTestModule, { logger: false, abortOnError: false });
    app.useGlobalPipes(new ZodValidationPipe());
    app.useGlobalFilters(new ProblemDetailsExceptionFilter());
    configureApiRoutes(app);
    await app.listen(0, "127.0.0.1");
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1/admin/audit-logs`;
    tokens = app.get(TokenService);
  }, 15_000);

  afterAll(async () => {
    await app?.close();
  });

  beforeEach(() => {
    Object.values(service).forEach((fn) => fn.mockClear());
  });

  async function token(scope: AccessTokenClaims["scope"], role: AccessTokenClaims["role"]): Promise<string> {
    return (
      await tokens.mintAccessToken({
        sub: randomUUID(),
        sid: randomUUID(),
        scope,
        role,
        ...(scope === "operator" ? { operatorId: randomUUID(), operatorSlug: "nhaxe" } : {}),
        mfa: true,
      })
    ).accessToken;
  }

  async function call(method: string, path: string, accessToken: string | null, body?: object) {
    const response = await fetch(`${base}${path}`, {
      method,
      headers: {
        ...(accessToken ? { authorization: `Bearer ${accessToken}` } : {}),
        ...(body ? { "content-type": "application/json" } : {}),
      },
      body: body ? JSON.stringify(body) : undefined,
    });
    return { status: response.status, body: response.status === 204 ? {} : ((await response.json()) as Record<string, unknown>) };
  }

  const routes: [string, string][] = [
    ["GET", ""],
    ["GET", `/${id}`],
  ];

  it.each(routes)("%s %s: không token → 401; chủ nhà xe / hỗ trợ nền tảng → 403; quản trị viên → 200", async (method, path) => {
    expect((await call(method, path, null)).status).toBe(401);
    expect(await call(method, path, await token("operator", "OPERATOR_OWNER"))).toMatchObject({
      status: 403,
      body: { code: "PERMISSION_DENIED" },
    });
    expect(await call(method, path, await token("platform", "PLATFORM_SUPPORT"))).toMatchObject({
      status: 403,
      body: { code: "PERMISSION_DENIED" },
    });
    expect(Object.values(service).some((fn) => fn.mock.calls.length > 0)).toBe(false);
    expect((await call(method, path, await token("platform", "PLATFORM_ADMIN"))).status).toBe(200);
    const called = Object.values(service).find((fn) => fn.mock.calls.length > 0)!;
    expect((called.mock.calls[0] as unknown[])[0] as Authorization).toMatchObject({ db: { kind: "platform" } });
  });

  it("validate: id không phải ObjectId, cursor / loại / phân hệ / kết quả lạ, tìm quá dài → 400", async () => {
    const admin = await token("platform", "PLATFORM_ADMIN");
    for (const path of [
      "/not-an-id",
      "?cursor=abc",
      "?actorType=ROBOT",
      "?module=PAYMENT",
      "?result=DENIED",
      "?from=hom-qua",
      `?q=${"x".repeat(101)}`,
      "?limit=500",
    ]) {
      expect((await call("GET", path, admin)).status, path).toBe(400);
    }
    expect(Object.values(service).some((fn) => fn.mock.calls.length > 0)).toBe(false);
    expect((await call("GET", "?module=AUTH&actorType=SYSTEM&result=FAILURE&q=%20platform%2Fkhanh%20", admin)).status).toBe(200);
    expect(service.list).toHaveBeenCalledWith(
      expect.anything(),
      expect.objectContaining({ module: "AUTH", actorType: "SYSTEM", result: "FAILURE", q: "platform/khanh", limit: 20 }),
    );
  });
});
