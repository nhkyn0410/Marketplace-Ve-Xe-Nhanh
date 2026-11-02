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
import { AdminCatalogController } from "./admin-catalog.controller";
import { AdminCatalogService } from "./admin-catalog.service";

/** Chuỗi guard thật của `/admin/catalog/*` (TASK-ADM-001 phần catalog); nghiệp vụ test ở `.int.spec.ts`. */
describe("Admin danh mục — HTTP", () => {
  const id = randomUUID();
  const page = { items: [], nextCursor: null, total: 0 };
  const service = {
    listProvinces: vi.fn(async () => page),
    createProvince: vi.fn(async () => ({})),
    renameProvince: vi.fn(async () => ({})),
    listWards: vi.fn(async () => page),
    createWard: vi.fn(async () => ({})),
    renameWard: vi.fn(async () => ({})),
    listVehicleTypes: vi.fn(async () => ({ items: [] })),
    createVehicleType: vi.fn(async () => ({})),
    updateVehicleType: vi.fn(async () => ({})),
    listAmenities: vi.fn(async () => ({ items: [] })),
    createAmenity: vi.fn(async () => ({})),
    renameAmenity: vi.fn(async () => ({})),
    setStatus: vi.fn(async () => undefined),
  };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;
  const config = { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig;

  @Module({
    controllers: [AdminCatalogController],
    providers: [
      { provide: APP_CONFIG, useValue: config },
      TokenService,
      { provide: AdminCatalogService, useValue: service },
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
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1/admin/catalog`;
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
    ["GET", "/provinces", undefined, 200],
    ["POST", "/provinces", { code: "99", name: "Tỉnh" }, 201],
    ["PUT", `/provinces/${id}`, { name: "Tỉnh" }, 200],
    ["GET", "/wards", undefined, 200],
    ["POST", "/wards", { provinceId: id, code: "12345", name: "Phường" }, 201],
    ["PUT", `/wards/${id}`, { name: "Phường" }, 200],
    ["GET", "/vehicle-types", undefined, 200],
    ["POST", "/vehicle-types", { code: "SEATER_X", name: "Ghế", description: null, form: "SEATER", class: "STANDARD" }, 201],
    ["PUT", `/vehicle-types/${id}`, { name: "Ghế", description: null }, 200],
    ["GET", "/amenities", undefined, 200],
    ["POST", "/amenities", { code: "WIFI_X", name: "Wi-Fi" }, 201],
    ["PUT", `/amenities/${id}`, { name: "Wi-Fi" }, 200],
    ["POST", `/vehicle-types/${id}/deactivate`, { reason: "Gộp loại" }, 204],
    ["POST", `/amenities/${id}/activate`, undefined, 204],
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

  it("validate: mã sai dạng, lý do ngắn, loại danh mục lạ → 400; ngừng dùng chuyển đúng loại + lý do xuống service", async () => {
    const admin = await token("platform", "PLATFORM_ADMIN");
    expect((await call("POST", "/provinces", admin, { code: "7", name: "Tỉnh" })).status).toBe(400);
    expect((await call("POST", "/wards", admin, { provinceId: id, code: "1234", name: "P" })).status).toBe(400);
    expect((await call("POST", "/vehicle-types", admin, { code: "có dấu", name: "x", description: null, form: "SEATER", class: "STANDARD" })).status).toBe(400);
    expect((await call("POST", `/provinces/${id}/deactivate`, admin, { reason: "ab" })).status).toBe(400);
    expect((await call("POST", `/routes/${id}/deactivate`, admin, { reason: "Gộp loại" })).status).toBe(400);
    expect(Object.values(service).some((fn) => fn.mock.calls.length > 0)).toBe(false);

    expect((await call("POST", `/wards/${id}/deactivate`, admin, { reason: " Sáp nhập " })).status).toBe(204);
    expect(service.setStatus).toHaveBeenCalledWith(expect.anything(), expect.anything(), "wards", id, "INACTIVE", "Sáp nhập");
  });
});
