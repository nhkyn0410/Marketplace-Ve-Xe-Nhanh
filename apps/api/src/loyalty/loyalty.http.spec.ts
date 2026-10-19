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
import { AdminLoyaltyController } from "./admin-loyalty.controller";
import { AdminLoyaltyService } from "./admin-loyalty.service";
import { PassengerLoyaltyController } from "./passenger-loyalty.controller";
import { PassengerLoyaltyService } from "./passenger-loyalty.service";

/** Chuỗi guard thật của VXN Plus phía Admin (TASK-LOY-001): chỉ Quản trị viên nền tảng; điều chỉnh điểm cần xác nhận lại danh tính. */
describe("VXN Plus — HTTP", () => {
  const member = {
    userId: "u1",
    name: "Khách",
    email: "khach@example.com",
    status: "ACTIVE",
    memberSince: "2026-03-02T00:00:00.000Z",
    availablePoints: 1_250,
    earned12m: 2_450,
    tier: "SILVER",
    nextTier: { tier: "GOLD", minPoints: 5_000, remaining: 2_550 },
    policyVersion: 1,
  };
  const figures = { issued: 0, redeemed: 0, expired: 0, vouchersRedeemed: 0, vouchersUsed: 0, platformDiscount: 0 };
  const service = {
    member: vi.fn(async () => member),
    transactions: vi.fn(async () => ({ items: [], total: 0 })),
    adjust: vi.fn(async () => member),
    report: vi.fn(async () => ({ year: 2026, quarter: 4, tier: null, months: [{ month: "2026-10", ...figures }], totals: figures })),
  };
  const voucher = { userVoucherId: randomUUID(), source: "LOYALTY_REDEMPTION", status: "AVAILABLE", promotionCode: null, name: "Voucher VXN Plus", discountAmount: "100000", discountType: "AMOUNT", discountValue: "100000", maxDiscount: null, minOrder: "0", expiresAt: "2026-11-19T00:00:00.000Z", createdAt: "2026-10-19T00:00:00.000Z" };
  const passenger = {
    member: vi.fn(async () => ({ ...member, rules: null })),
    transactions: vi.fn(async () => ({ items: [], total: 0, totals: { earned: 0, redeemed: 0, expired: 0 } })),
    vouchers: vi.fn(async () => ({ items: [voucher], total: 1 })),
    redeem: vi.fn(async () => voucher),
    save: vi.fn(async () => voucher),
  };
  let reauthed = false;
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  @Module({
    controllers: [AdminLoyaltyController, PassengerLoyaltyController],
    providers: [
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      { provide: AdminLoyaltyService, useValue: service },
      { provide: PassengerLoyaltyService, useValue: passenger },
      { provide: SessionService, useValue: { assertActive: async () => undefined, assertOperatorAccountCurrent: async () => undefined, hasRecentReauth: async () => reauthed } },
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
    reauthed = false;
  });

  async function token(role: AccessTokenClaims["role"]): Promise<string> {
    const platform = role.startsWith("PLATFORM");
    const scope = role === "PASSENGER" ? "passenger" : platform ? "platform" : "operator";
    return (
      await tokens.mintAccessToken({ sub: "actor-from-token", sid: randomUUID(), scope, role, ...(scope === "operator" ? { operatorId: randomUUID(), operatorSlug: "nhaxe" } : {}), ...(scope === "passenger" ? {} : { mfa: true }) })
    ).accessToken;
  }

  async function call(method: string, path: string, accessToken: string | null, body?: object, idempotencyKey?: string) {
    const response = await fetch(`${base}${path}`, {
      method,
      headers: {
        ...(accessToken ? { authorization: `Bearer ${accessToken}` } : {}),
        ...(body ? { "content-type": "application/json" } : {}),
        ...(idempotencyKey ? { "idempotency-key": idempotencyKey } : {}),
      },
      body: body ? JSON.stringify(body) : undefined,
    });
    return { status: response.status, body: (await response.json().catch(() => ({}))) as Record<string, unknown> };
  }

  it("chỉ Quản trị viên: Hỗ trợ / chủ nhà xe / chưa đăng nhập bị chặn; email chuẩn hóa chữ thường; truy vấn sai 400", async () => {
    const admin = await token("PLATFORM_ADMIN");
    expect((await call("GET", "/admin/loyalty/accounts?email=Khach@Example.com", admin)).status).toBe(200);
    expect((service.member.mock.calls[0] as unknown as unknown[])[1]).toBe("khach@example.com");
    for (const role of ["PLATFORM_SUPPORT", "OPERATOR_OWNER"] as const) {
      expect((await call("GET", "/admin/loyalty/accounts?email=khach@example.com", await token(role))).status).toBe(403);
      expect((await call("GET", "/admin/loyalty/reports?year=2026&quarter=4", await token(role))).status).toBe(403);
    }
    expect((await call("GET", "/admin/loyalty/reports?year=2026&quarter=4", null)).status).toBe(401);
    expect((await call("GET", "/admin/loyalty/accounts?email=khong-phai-email", admin)).status).toBe(400);
    expect((await call("GET", "/admin/loyalty/reports?year=2026&quarter=5", admin)).status).toBe(400);
    expect((await call("GET", "/admin/loyalty/reports?year=2026&quarter=4&tier=DIAMOND", admin)).status).toBe(400);
    expect((await call("GET", "/admin/loyalty/reports?year=2026&quarter=4&tier=GOLD", admin)).status).toBe(200);
    expect((service.report.mock.calls[0] as unknown as unknown[])[1]).toEqual({ year: 2026, quarter: 4, tier: "GOLD" });
    expect((await call("GET", "/admin/loyalty/accounts/u1/transactions?limit=51", admin)).status).toBe(400);
    expect((await call("GET", "/admin/loyalty/accounts/u1/transactions", admin)).status).toBe(200);
    expect((service.transactions.mock.calls[0] as unknown as unknown[]).slice(1)).toEqual(["u1", { offset: 0, limit: 20 }]);
  });

  it("điều chỉnh điểm: chưa xác nhận lại danh tính → 401 AUTH_REAUTH_REQUIRED; body / Idempotency-Key sai 400; hợp lệ → 201", async () => {
    const admin = await token("PLATFORM_ADMIN");
    const key = randomUUID();
    const valid = { direction: "CREDIT", points: 50, reason: "Bù do sự cố chuyến" };
    const denied = await call("POST", "/admin/loyalty/accounts/u1/adjustments", admin, valid, key);
    expect(denied.status).toBe(401);
    expect(denied.body.code).toBe("AUTH_REAUTH_REQUIRED");
    reauthed = true;
    for (const body of [{ ...valid, points: 0 }, { ...valid, reason: "ok" }, { ...valid, direction: "SET" }]) {
      expect((await call("POST", "/admin/loyalty/accounts/u1/adjustments", admin, body, key)).status).toBe(400);
    }
    for (const badKey of [undefined, "short", "has space here!"]) {
      expect((await call("POST", "/admin/loyalty/accounts/u1/adjustments", admin, valid, badKey)).status).toBe(400);
    }
    expect(service.adjust).not.toHaveBeenCalled();
    expect((await call("POST", "/admin/loyalty/accounts/u1/adjustments", admin, valid, key)).status).toBe(201);
    expect((service.adjust.mock.calls[0] as unknown as unknown[]).slice(2)).toEqual(["u1", valid, key]);
    expect((await call("POST", "/admin/loyalty/accounts/u1/adjustments", await token("OPERATOR_OWNER"), valid, key)).status).toBe(403);
  });

  it("hành khách chỉ thao tác ví / điểm của token; Admin, nhà xe, khách chưa đăng nhập bị chặn", async () => {
    const user = await token("PASSENGER");
    expect((await call("GET", "/me/loyalty", user)).status).toBe(200);
    expect(passenger.member.mock.calls[0]).toEqual(["actor-from-token"]);
    expect((await call("GET", "/me/vouchers?status=AVAILABLE", user)).status).toBe(200);
    expect(passenger.vouchers.mock.calls[0]).toEqual(["actor-from-token", { status: "AVAILABLE", offset: 0, limit: 20 }]);
    for (const role of ["PLATFORM_ADMIN", "OPERATOR_OWNER"] as const) expect((await call("GET", "/me/vouchers", await token(role))).status).toBe(403);
    expect((await call("GET", "/me/loyalty", null)).status).toBe(401);
    expect((await call("POST", "/me/loyalty/redemptions", user, { points: 100 })).status).toBe(400);
    expect((await call("POST", "/me/loyalty/redemptions", user, { points: 0 }, randomUUID())).status).toBe(400);
    const key = randomUUID();
    expect((await call("POST", "/me/loyalty/redemptions", user, { points: 100, userId: "someone-else" }, key)).status).toBe(201);
    expect(passenger.redeem.mock.calls[0]).toEqual(["actor-from-token", 100, key]);
    expect((await call("POST", "/me/vouchers", user, { promotionCode: "  saved20  " })).status).toBe(201);
    expect(passenger.save.mock.calls[0]).toEqual(["actor-from-token", "SAVED20"]);
    expect((await call("GET", "/me/loyalty/transactions?from=2026-12-01T00:00:00Z&to=2026-10-01T00:00:00Z", user)).status).toBe(400);
  });
});
