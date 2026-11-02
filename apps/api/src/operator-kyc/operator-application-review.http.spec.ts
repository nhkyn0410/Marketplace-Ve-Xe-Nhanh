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
import { OperatorApplicationReviewController } from "./operator-application-review.controller";
import { OperatorApplicationReviewService } from "./operator-application-review.service";

/** Chuỗi guard thật của các route Admin duyệt hồ sơ (TASK-ADM-001); nghiệp vụ test ở `.int.spec.ts`. */
describe("Admin duyệt hồ sơ đăng ký nhà xe — HTTP", () => {
  const applicationId = randomUUID();
  const approval = {
    applicationCode: "OA-2026-043152",
    status: "APPROVED",
    operatorId: randomUUID(),
    operatorSlug: "saoviet",
    ownerUsername: "owner01",
    credentialDeliveryPending: false,
  };
  const decision = { applicationCode: "OA-2026-043152", status: "NEEDS_INFO", emailDelivered: true };
  const service = {
    list: vi.fn(async () => ({ items: [], nextCursor: null })),
    get: vi.fn(async () => ({})),
    createDocumentDownload: vi.fn(async () => ({ url: "http://storage.test/x", expiresAt: new Date().toISOString() })),
    approve: vi.fn(async () => approval),
    requestInfo: vi.fn(async () => decision),
    reject: vi.fn(async () => ({ ...decision, status: "REJECTED" })),
    resendOwnerCredentials: vi.fn(async () => approval),
  };
  let recentReauth = true;
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  const config = { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig;

  @Module({
    controllers: [OperatorApplicationReviewController],
    providers: [
      { provide: APP_CONFIG, useValue: config },
      TokenService,
      { provide: OperatorApplicationReviewService, useValue: service },
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

  beforeAll(async () => {
    app = await NestFactory.create(HttpTestModule, { logger: false, abortOnError: false });
    app.useGlobalPipes(new ZodValidationPipe());
    app.useGlobalFilters(new ProblemDetailsExceptionFilter());
    configureApiRoutes(app);
    await app.listen(0, "127.0.0.1");
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1/admin/operator-applications`;
    tokens = app.get(TokenService);
  }, 15_000);

  afterAll(async () => {
    await app?.close();
  });

  beforeEach(() => {
    recentReauth = true;
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

  async function call(
    method: string,
    path: string,
    accessToken: string | null,
    options: { body?: object; headers?: Record<string, string> } = {},
  ) {
    const response = await fetch(`${base}${path}`, {
      method,
      headers: {
        ...(accessToken ? { authorization: `Bearer ${accessToken}` } : {}),
        ...(options.body ? { "content-type": "application/json" } : {}),
        ...options.headers,
      },
      body: options.body ? JSON.stringify(options.body) : undefined,
    });
    return { status: response.status, body: (await response.json()) as Record<string, unknown> };
  }

  const routes: [string, string, { body?: object; headers?: Record<string, string> }][] = [
    ["GET", "", {}],
    ["GET", `/${applicationId}`, {}],
    ["POST", `/${applicationId}/documents/TRANSPORT_LICENSE/download-url`, {}],
    [
      "POST",
      `/${applicationId}/approve`,
      { body: { operatorSlug: "saoviet", ownerUsername: "owner01" }, headers: { "idempotency-key": "key-12345678" } },
    ],
    ["POST", `/${applicationId}/request-info`, { body: { reason: "Bổ sung giấy phép" } }],
    ["POST", `/${applicationId}/reject`, { body: { reason: "Không đủ điều kiện" } }],
    ["POST", `/${applicationId}/resend-owner-credentials`, {}],
  ];

  it.each(routes)("%s %s: không token → 401; chủ nhà xe / hỗ trợ nền tảng → 403; quản trị viên → 200", async (method, path, options) => {
    expect((await call(method, path, null, options)).status).toBe(401);
    const owner = await call(method, path, await token("operator", "OPERATOR_OWNER"), options);
    expect(owner).toMatchObject({ status: 403, body: { code: "PERMISSION_DENIED" } });
    const support = await call(method, path, await token("platform", "PLATFORM_SUPPORT"), options);
    expect(support).toMatchObject({ status: 403, body: { code: "PERMISSION_DENIED" } });
    expect(Object.values(service).some((fn) => fn.mock.calls.length > 0)).toBe(false);

    expect((await call(method, path, await token("platform", "PLATFORM_ADMIN"), options)).status).toBe(200);
    const called = Object.values(service).find((fn) => fn.mock.calls.length > 0)!;
    expect((called.mock.calls[0] as unknown[])[0] as Authorization).toMatchObject({ db: { kind: "platform" } });
  });

  it("duyệt, từ chối, gửi lại mật khẩu tạm cần xác thực lại; yêu cầu bổ sung thì không", async () => {
    const admin = await token("platform", "PLATFORM_ADMIN");
    recentReauth = false;
    for (const [method, path, options] of routes.filter(([, path]) => /approve|reject|resend/.test(path))) {
      expect(await call(method, path, admin, options), path).toMatchObject({
        status: 401,
        body: { code: "AUTH_REAUTH_REQUIRED" },
      });
    }
    expect(service.approve).not.toHaveBeenCalled();
    expect(service.reject).not.toHaveBeenCalled();
    expect(service.resendOwnerCredentials).not.toHaveBeenCalled();
    const [method, path, options] = routes.find(([, path]) => path.endsWith("/request-info"))!;
    expect((await call(method, path, admin, options)).status).toBe(200);
  });

  it("duyệt: thiếu / sai Idempotency-Key → 400; slug / tên đăng nhập sai luật → 400; khóa hợp lệ chuyển xuống service", async () => {
    const admin = await token("platform", "PLATFORM_ADMIN");
    const body = { operatorSlug: "SaoViet", ownerUsername: "owner01" };
    for (const headers of [{} as Record<string, string>, { "idempotency-key": "short" }, { "idempotency-key": "key/with.dots" }]) {
      expect(await call("POST", `/${applicationId}/approve`, admin, { body, headers })).toMatchObject({
        status: 400,
        body: { code: "VALIDATION_FAILED" },
      });
    }
    const headers = { "idempotency-key": "key-12345678" };
    for (const invalid of [
      { operatorSlug: "platform", ownerUsername: "owner01" },
      { operatorSlug: "-sao", ownerUsername: "owner01" },
      { operatorSlug: "saoviet", ownerUsername: "nv.owner" },
    ]) {
      expect((await call("POST", `/${applicationId}/approve`, admin, { body: invalid, headers })).status).toBe(400);
    }
    expect(service.approve).not.toHaveBeenCalled();

    expect((await call("POST", `/${applicationId}/approve`, admin, { body, headers })).status).toBe(200);
    expect(service.approve).toHaveBeenCalledWith(
      expect.anything(),
      expect.objectContaining({ scope: "platform", role: "PLATFORM_ADMIN" }),
      applicationId,
      { operatorSlug: "saoviet", ownerUsername: "owner01" },
      "key-12345678",
      expect.objectContaining({}),
    );
  });

  it("id không phải uuid / lý do quá ngắn / loại giấy tờ lạ → 400", async () => {
    const admin = await token("platform", "PLATFORM_ADMIN");
    expect((await call("GET", "/khong-phai-uuid", admin)).status).toBe(400);
    expect((await call("POST", `/${applicationId}/reject`, admin, { body: { reason: "x" } })).status).toBe(400);
    expect((await call("POST", `/${applicationId}/documents/CCCD/download-url`, admin)).status).toBe(400);
    expect((await call("GET", "?cursor=abc", admin)).status).toBe(400);
  });
});
