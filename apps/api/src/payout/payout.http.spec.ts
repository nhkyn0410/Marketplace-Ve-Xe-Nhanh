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
import { AdminPayoutController } from "./admin-payout.controller";
import { AdminPayoutService } from "./admin-payout.service";
import { OperatorFinanceController } from "./operator-finance.controller";
import { OperatorFinanceService } from "./operator-finance.service";

/** Chuỗi guard thật của `/admin/payouts*` (finance:read / finance:configure + xác nhận lại) và `/operator/finance*`, `/operator/payouts*`. */
describe("Chi trả + tài chính nhà xe — HTTP", () => {
  const payoutId = randomUUID();
  const admin = {
    list: vi.fn(async () => ({ items: [], nextCursor: null })),
    stats: vi.fn(),
    get: vi.fn(),
    review: vi.fn(),
    hold: vi.fn(),
    release: vi.fn(),
    confirm: vi.fn(),
    cancel: vi.fn(),
    revealBank: vi.fn(async () => ({ bankName: "VCB", accountNumber: "0071000124521", accountHolder: "CTY" })),
  };
  const finance = {
    summary: vi.fn(async () => ({ heldBalance: 0, eligibleAmount: 0, pendingAmount: 0, lastPayout: null, payoutDelayDays: 3 })),
    bookings: vi.fn(async () => ({ items: [], nextCursor: null })),
    payouts: vi.fn(async () => ({ items: [], nextCursor: null })),
    payout: vi.fn(),
  };
  const reauth = { granted: false };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  @Module({
    controllers: [AdminPayoutController, OperatorFinanceController],
    providers: [
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      { provide: AdminPayoutService, useValue: admin },
      { provide: OperatorFinanceService, useValue: finance },
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

  it("xem kỳ chi trả: Admin + hỗ trợ nền tảng được (payment:monitor); chủ nhà xe 403; không token 401", async () => {
    expect((await call("GET", "/admin/payouts", await token("PLATFORM_ADMIN"))).status).toBe(200);
    expect((await call("GET", "/admin/payouts", await token("PLATFORM_SUPPORT"))).status).toBe(200);
    expect((await call("GET", "/admin/payouts", await token("OPERATOR_OWNER"))).status).toBe(403);
    expect((await call("GET", "/admin/payouts", null)).status).toBe(401);
    expect((await call("GET", "/admin/payouts?status=LA", await token("PLATFORM_ADMIN"))).status).toBe(400);
  });

  it("thao tác: hỗ trợ nền tảng 403 (chỉ finance:configure); xác nhận đã chi / xem số tài khoản cần xác nhận lại danh tính; body sai 400", async () => {
    const support = await token("PLATFORM_SUPPORT");
    const adminToken = await token("PLATFORM_ADMIN");
    expect((await call("POST", `/admin/payouts/${payoutId}/hold`, support, { reason: "x" })).status).toBe(403);
    const confirm = { bankReference: "FT26286104552", transferredAt: new Date().toISOString(), note: "Đã chuyển" };
    expect(await call("POST", `/admin/payouts/${payoutId}/confirm`, adminToken, confirm)).toMatchObject({ status: 401, body: { code: "AUTH_REAUTH_REQUIRED" } });
    expect((await call("POST", `/admin/payouts/${payoutId}/bank-reveal`, adminToken)).status).toBe(401);
    reauth.granted = true;
    expect((await call("POST", `/admin/payouts/${payoutId}/bank-reveal`, adminToken)).status).toBe(200);
    expect((await call("POST", `/admin/payouts/${payoutId}/confirm`, adminToken, { ...confirm, bankReference: "x" })).status).toBe(400);
    expect((await call("POST", `/admin/payouts/${payoutId}/hold`, adminToken, { reason: "" })).status).toBe(400);
    expect(admin.confirm).not.toHaveBeenCalled();
    expect(admin.hold).not.toHaveBeenCalled();
  });

  it("tài chính nhà xe: chủ nhà xe được; nhân viên 403 (Admin bị chặn ở service — requireTenant); khoảng ngày thiếu / tháng sai 400", async () => {
    const owner = await token("OPERATOR_OWNER");
    expect((await call("GET", "/operator/finance/summary", owner)).status).toBe(200);
    expect((await call("GET", "/operator/finance/bookings?from=2031-01-01&to=2031-01-31", owner)).status).toBe(200);
    expect((await call("GET", "/operator/payouts?month=2031-01", owner)).status).toBe(200);
    expect((await call("GET", "/operator/finance/summary", await token("DRIVER"))).status).toBe(403);
    expect((await call("GET", "/operator/finance/bookings?from=2031-01-01", owner)).status).toBe(400);
    expect((await call("GET", "/operator/payouts?month=2031-13", owner)).status).toBe(400);
  });
});
