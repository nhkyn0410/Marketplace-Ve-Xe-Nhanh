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
import { AdminVehicleImageController } from "./admin-vehicle-image.controller";
import { AdminVehicleImageService } from "./admin-vehicle-image.service";

/** Chuỗi guard thật của `/admin/vehicle-images` (TASK-ADM-003 phần ảnh xe); nghiệp vụ test ở `.int.spec.ts`. */
describe("Admin ảnh phương tiện — HTTP", () => {
  const id = randomUUID();
  const service = {
    list: vi.fn(async () => ({ items: [], nextCursor: null, total: 0, operators: [] })),
    remove: vi.fn(async () => undefined),
  };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;
  const config = { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig;

  @Module({
    controllers: [AdminVehicleImageController],
    providers: [
      { provide: APP_CONFIG, useValue: config },
      TokenService,
      { provide: AdminVehicleImageService, useValue: service },
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
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1/admin/vehicle-images`;
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

  const routes: [string, string, object | undefined, number][] = [
    ["GET", "", undefined, 200],
    ["POST", `/${id}/remove`, { reason: "Ảnh có giấy tờ" }, 204],
  ];

  it.each(routes)("%s %s: không token → 401; chủ nhà xe / hỗ trợ nền tảng → 403; quản trị viên → thành công", async (method, path, body, ok) => {
    expect((await call(method, path, null, body)).status).toBe(401);
    expect(await call(method, path, await token("operator", "OPERATOR_OWNER"), body)).toMatchObject({
      status: 403,
      body: { code: "PERMISSION_DENIED" },
    });
    expect(await call(method, path, await token("platform", "PLATFORM_SUPPORT"), body)).toMatchObject({
      status: 403,
      body: { code: "PERMISSION_DENIED" },
    });
    expect(Object.values(service).some((fn) => fn.mock.calls.length > 0)).toBe(false);
    expect((await call(method, path, await token("platform", "PLATFORM_ADMIN"), body)).status).toBe(ok);
    const called = Object.values(service).find((fn) => fn.mock.calls.length > 0)!;
    expect((called.mock.calls[0] as unknown[])[0] as Authorization).toMatchObject({ db: { kind: "platform" } });
  });

  it("validate: id không phải uuid, lý do ngắn, lọc sai → 400; lý do được cắt khoảng trắng rồi chuyển xuống service", async () => {
    const admin = await token("platform", "PLATFORM_ADMIN");
    expect((await call("POST", "/not-a-uuid/remove", admin, { reason: "Ảnh có giấy tờ" })).status).toBe(400);
    expect((await call("POST", `/${id}/remove`, admin, { reason: "ab" })).status).toBe(400);
    expect((await call("POST", `/${id}/remove`, admin, {})).status).toBe(400);
    expect((await call("GET", "?operatorId=abc", admin)).status).toBe(400);
    expect((await call("GET", "?uploadedSince=hôm-qua", admin)).status).toBe(400);
    expect((await call("GET", "?limit=500", admin)).status).toBe(400);
    expect(Object.values(service).some((fn) => fn.mock.calls.length > 0)).toBe(false);

    expect((await call("POST", `/${id}/remove`, admin, { reason: "  Ảnh có biển số cá nhân  " })).status).toBe(204);
    expect(service.remove).toHaveBeenCalledWith(expect.anything(), expect.anything(), id, "Ảnh có biển số cá nhân");
  });
});
