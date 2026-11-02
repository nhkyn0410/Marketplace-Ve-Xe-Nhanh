import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { ProblemDetailsExceptionFilter } from "../../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../../config/env.config";
import { configureApiRoutes } from "../../openapi/openapi";
import { type AccessTokenClaims, TokenService } from "../auth/token.service";
import { SessionService } from "../session/session.service";
import { OperatorManagerController } from "./operator-manager.controller";
import { OperatorManagerService } from "./operator-manager.service";

/** Tài khoản quản lý nhà xe (TASK-IAM-007): chạy đúng chuỗi guard + validate thật; hành vi service ở int spec. */
describe("Tài khoản quản lý nhà xe — HTTP", () => {
  const operatorId = randomUUID();
  const managerId = randomUUID();
  const service = {
    list: vi.fn(async () => ({ items: [] })),
    create: vi.fn(async () => account()),
    update: vi.fn(async () => account()),
    resetPassword: vi.fn(async () => account()),
    resetMfa: vi.fn(async () => account()),
  };
  let recentReauth = false;
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  const config = { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig;

  @Module({
    controllers: [OperatorManagerController],
    providers: [
      { provide: APP_CONFIG, useValue: config },
      TokenService,
      { provide: OperatorManagerService, useValue: service },
      {
        provide: SessionService,
        useValue: {
          assertActive: async () => undefined,
          assertOperatorAccountCurrent: async () => undefined,
          hasRecentReauth: async () => recentReauth,
        },
      },
    ],
  })
  class HttpTestModule {}

  function account() {
    return {
      id: managerId,
      username: "test-operator/ke-toan",
      contactEmail: "ketoan@example.com",
      permissions: ["finance:read"],
      status: "ACTIVE",
      mfaEnabled: false,
      passwordChangeRequired: true,
      credentialDeliveryPending: false,
      temporaryPasswordExpiresAt: null,
      lastLoginAt: null,
      createdAt: new Date().toISOString(),
    };
  }

  beforeAll(async () => {
    app = await NestFactory.create(HttpTestModule, { logger: false, abortOnError: false });
    app.useGlobalPipes(new ZodValidationPipe());
    app.useGlobalFilters(new ProblemDetailsExceptionFilter());
    configureApiRoutes(app);
    await app.listen(0, "127.0.0.1");
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1/operator/managers`;
    tokens = app.get(TokenService);
  }, 15_000);

  afterAll(async () => {
    await app?.close();
  });

  async function token(role: AccessTokenClaims["role"], perms?: string[]): Promise<string> {
    const platform = role.startsWith("PLATFORM_");
    return (
      await tokens.mintAccessToken({
        sub: randomUUID(),
        sid: randomUUID(),
        scope: platform ? "platform" : "operator",
        role,
        ...(platform ? {} : { operatorId, operatorSlug: "test-operator" }),
        ...(["OPERATOR_OWNER", "OPERATOR_MANAGER", "PLATFORM_ADMIN"].includes(role) ? { mfa: true as const } : {}),
        ...(perms ? { perms } : {}),
      })
    ).accessToken;
  }

  async function request(method: string, path: string, accessToken: string | null, body?: object) {
    const response = await fetch(`${base}${path}`, {
      method,
      headers: { ...(accessToken ? { authorization: `Bearer ${accessToken}` } : {}), "content-type": "application/json" },
      ...(body ? { body: JSON.stringify(body) } : {}),
    });
    return { status: response.status, body: (await response.json()) as Record<string, unknown> };
  }

  const create = { username: "ke-toan", contactEmail: "ketoan@example.com", permissions: ["finance:read"], reason: "Kế toán mới" };
  const routes: [string, string, object | undefined][] = [
    ["GET", "", undefined],
    ["POST", "", create],
    ["PATCH", `/${managerId}`, { permissions: ["finance:read", "booking:read"], reason: "Thêm quyền" }],
    ["POST", `/${managerId}/password-reset`, { reason: "Quên mật khẩu" }],
    ["POST", `/${managerId}/mfa-reset`, { reason: "Mất điện thoại" }],
  ];

  it.each(routes)("%s %s: không token → 401; tài khoản quản lý (kể cả đủ quyền tick) / nhân viên / Admin → 403", async (method, path, body) => {
    recentReauth = true;
    expect((await request(method, path, null, body)).status).toBe(401);
    const allManagerPerms = ["vehicle:manage", "route:manage", "trip:manage", "booking:read", "finance:read", "employee:manage", "support:respond", "promotion:manage"];
    for (const accessToken of [
      await token("OPERATOR_MANAGER", allManagerPerms),
      await token("DRIVER"),
      await token("PLATFORM_ADMIN"),
    ]) {
      const denied = await request(method, path, accessToken, body);
      expect(denied.status, `${method} ${path}`).toBe(403);
    }
  });

  it.each(routes.filter(([method]) => method !== "GET"))("%s %s: chủ nhà xe cần xác nhận lại danh tính", async (method, path, body) => {
    recentReauth = false;
    const denied = await request(method, path, await token("OPERATOR_OWNER"), body);
    expect(denied).toMatchObject({ status: 401, body: { code: "AUTH_REAUTH_REQUIRED" } });
    recentReauth = true;
    expect((await request(method, path, await token("OPERATOR_OWNER"), body)).status).toBe(method === "POST" && path === "" ? 201 : 200);
  });

  it.each([
    ["tiền tố nhân viên", { ...create, username: "nv.ketoan" }],
    ["tên quá ngắn", { ...create, username: "ab" }],
    ["quyền chỉ của Owner (tài khoản nhận tiền)", { ...create, permissions: ["kyc:submit"] }],
    ["quyền tạo tài khoản quản lý", { ...create, permissions: ["manager:manage"] }],
    ["quyền phía Admin", { ...create, permissions: ["payout:manage"] }],
    ["thiếu lý do", { ...create, reason: "" }],
  ])("POST từ chối %s → 400, không gọi service", async (_label, body) => {
    recentReauth = true;
    service.create.mockClear();
    expect((await request("POST", "", await token("OPERATOR_OWNER"), body)).status).toBe(400);
    expect(service.create).not.toHaveBeenCalled();
  });

  it("PATCH không có gì để đổi / trạng thái lạ → 400", async () => {
    recentReauth = true;
    const owner = await token("OPERATOR_OWNER");
    expect((await request("PATCH", `/${managerId}`, owner, { reason: "không đổi" })).status).toBe(400);
    expect((await request("PATCH", `/${managerId}`, owner, { status: "DISABLED", reason: "vô hiệu" })).status).toBe(400);
    expect((await request("PATCH", "/khong-phai-uuid", owner, { status: "LOCKED", reason: "khóa" })).status).toBe(400);
  });
});
