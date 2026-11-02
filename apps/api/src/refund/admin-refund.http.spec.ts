import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { type AccessTokenClaims, TokenService } from "../iam/auth/token.service";
import { SessionService } from "../iam/session/session.service";
import { configureApiRoutes } from "../openapi/openapi";
import { AdminPaymentController } from "../payment/admin-payment.controller";
import { AdminPaymentService } from "../payment/admin-payment.service";
import { AdminRefundController } from "./admin-refund.controller";
import { AdminRefundService } from "./admin-refund.service";

/** Chuỗi guard thật của `/admin/payments*` + `/admin/refunds*` (payment:monitor / finance:configure + xác nhận lại danh tính). */
describe("Thanh toán & hoàn tiền phía Admin — HTTP", () => {
  const id = randomUUID();
  const payments = { list: vi.fn(async () => ({ items: [], nextCursor: null, total: 0, reconcileOpen: 0 })), get: vi.fn() };
  const refunds = {
    list: vi.fn(async () => ({ items: [], nextCursor: null, total: 0 })),
    get: vi.fn(),
    retry: vi.fn(),
    resolve: vi.fn(),
    refundPayment: vi.fn(),
  };
  const reauth = { granted: false };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  @Module({
    controllers: [AdminPaymentController, AdminRefundController],
    providers: [
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      { provide: AdminPaymentService, useValue: payments },
      { provide: AdminRefundService, useValue: refunds },
      {
        provide: SessionService,
        useValue: { assertActive: async () => undefined, assertOperatorAccountCurrent: async () => undefined, hasRecentReauth: async () => reauth.granted },
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
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1`;
    tokens = app.get(TokenService);
  }, 15_000);

  afterAll(async () => {
    await app?.close();
  });

  beforeEach(() => {
    vi.clearAllMocks();
    reauth.granted = false;
  });

  async function token(role: AccessTokenClaims["role"]): Promise<string> {
    const scope = role.startsWith("PLATFORM") ? "platform" : "operator";
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
      headers: { ...(accessToken ? { authorization: `Bearer ${accessToken}` } : {}), ...(body ? { "content-type": "application/json" } : {}) },
      body: body ? JSON.stringify(body) : undefined,
    });
    return { status: response.status, body: (await response.json().catch(() => ({}))) as Record<string, unknown> };
  }

  it("xem: Admin + hỗ trợ nền tảng được (payment:monitor); chủ nhà xe 403; không token 401; bộ lọc sai 400", async () => {
    for (const path of ["/admin/payments", "/admin/refunds"]) {
      expect((await call("GET", path, await token("PLATFORM_ADMIN"))).status).toBe(200);
      expect((await call("GET", path, await token("PLATFORM_SUPPORT"))).status).toBe(200);
      expect((await call("GET", path, await token("OPERATOR_OWNER"))).status).toBe(403);
      expect((await call("GET", path, null)).status).toBe(401);
    }
    const admin = await token("PLATFORM_ADMIN");
    expect((await call("GET", "/admin/payments?reconcile=open&provider=MOMO&from=2031-01-01&to=2031-01-31", admin)).status).toBe(200);
    expect((await call("GET", "/admin/payments?from=2031-02-01&to=2031-01-01", admin)).status).toBe(400);
    expect((await call("GET", "/admin/payments?provider=STRIPE", admin)).status).toBe(400);
    expect((await call("GET", "/admin/refunds?source=EMPLOYEE", admin)).status).toBe(400);
    expect((await call("GET", "/admin/refunds?source=OPERATOR", admin)).status).toBe(200);
    expect((await call("GET", "/admin/refunds/khong-phai-uuid", admin)).status).toBe(400);
  });

  it("thao tác: hỗ trợ nền tảng + chủ nhà xe 403 (chỉ finance:configure); cần xác nhận lại danh tính; lý do / mã tham chiếu sai 400", async () => {
    const admin = await token("PLATFORM_ADMIN");
    const routes: [string, object][] = [
      [`/admin/refunds/${id}/retry`, { reason: "Cổng đã chạy lại" }],
      [`/admin/refunds/${id}/resolve`, { reference: "FT26291000001", reason: "Đã chuyển khoản tay" }],
      [`/admin/payments/${id}/refunds`, { reason: "Khách trả hai lần" }],
    ];
    for (const [path, body] of routes) {
      expect((await call("POST", path, await token("PLATFORM_SUPPORT"), body)).status).toBe(403);
      expect((await call("POST", path, await token("OPERATOR_OWNER"), body)).status).toBe(403);
      expect(await call("POST", path, admin, body)).toMatchObject({ status: 401, body: { code: "AUTH_REAUTH_REQUIRED" } });
    }
    reauth.granted = true;
    expect((await call("POST", `/admin/refunds/${id}/retry`, admin, { reason: "ab" })).status).toBe(400);
    expect((await call("POST", `/admin/refunds/${id}/resolve`, admin, { reference: "x", reason: "Đã chuyển khoản tay" })).status).toBe(400);
    expect((await call("POST", `/admin/payments/${id}/refunds`, admin, {})).status).toBe(400);
    expect(refunds.retry).not.toHaveBeenCalled();
    expect(refunds.resolve).not.toHaveBeenCalled();
    expect(refunds.refundPayment).not.toHaveBeenCalled();
  });
});
