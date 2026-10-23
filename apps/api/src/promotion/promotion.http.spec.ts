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
import { AdminPromotionController, OperatorPromotionController, PublicPromotionController } from "./promotion.controller";
import { PromotionService } from "./promotion.service";

/** Chuỗi guard thật của khuyến mãi (TASK-PROM-001): Admin nền tảng, chủ nhà xe trong tenant, khách kiểm mã. */
describe("Khuyến mãi — HTTP", () => {
  const operatorId = randomUUID();
  const page = { items: [], nextCursor: null, total: 0, stats: { running: 0, scheduled: 0, drafts: 0, paused: 0, redemptions: 0, discount: 0, revenue: 0 } };
  const service = {
    adminList: vi.fn(async () => page),
    operatorList: vi.fn(async () => page),
    create: vi.fn(),
    check: vi.fn(async () => ({ code: "THU10", name: "Giảm", discount: 30_000, total: 270_000 })),
  };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  @Module({
    controllers: [AdminPromotionController, OperatorPromotionController, PublicPromotionController],
    providers: [
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      { provide: PromotionService, useValue: service },
      { provide: SessionService, useValue: { assertActive: async () => undefined, assertOperatorAccountCurrent: async () => undefined, hasRecentReauth: async () => false } },
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
  });

  async function token(role: AccessTokenClaims["role"]): Promise<string> {
    const platform = role.startsWith("PLATFORM");
    return (
      await tokens.mintAccessToken({ sub: randomUUID(), sid: randomUUID(), scope: platform ? "platform" : "operator", role, ...(platform ? {} : { operatorId, operatorSlug: "nhaxe" }), mfa: true })
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

  const valid = { code: "thu10", name: "Giảm 10%", discountType: "PERCENT", discountValue: 10, maxDiscount: 50_000, startsAt: "2031-01-01T00:00:00+07:00", endsAt: "2031-01-31T23:59:00+07:00", usageLimit: 500 };

  it("Admin: chỉ Quản trị viên; Hỗ trợ + chủ nhà xe 403; phạm vi mặc định nền tảng; body sai 400; mã chuẩn hóa chữ hoa", async () => {
    expect((await call("GET", "/admin/promotions?scope=OPERATOR&display=RUNNING", await token("PLATFORM_ADMIN"))).status).toBe(200);
    expect((service.adminList.mock.calls[0] as unknown as unknown[])[1]).toBe("OPERATOR");
    await call("GET", "/admin/promotions", await token("PLATFORM_ADMIN"));
    expect((service.adminList.mock.calls[1] as unknown as unknown[])[1]).toBe("PLATFORM");
    for (const role of ["PLATFORM_SUPPORT", "OPERATOR_OWNER"] as const) {
      expect((await call("GET", "/admin/promotions", await token(role))).status).toBe(403);
    }
    const admin = await token("PLATFORM_ADMIN");
    expect((await call("POST", "/admin/promotions", admin, { ...valid, discountValue: 120 })).status).toBe(400);
    expect((await call("POST", "/admin/promotions", admin, { ...valid, endsAt: "2030-12-31T00:00:00+07:00" })).status).toBe(400);
    expect((await call("POST", "/admin/promotions", admin, { ...valid, discountType: "AMOUNT", discountValue: 30_000 })).status).toBe(400);
    expect((await call("POST", "/admin/promotions", admin, { ...valid, code: "có dấu" })).status).toBe(400);
    expect((await call("PUT", `/admin/promotion-permissions/${randomUUID()}`, admin, { enabled: true })).status).toBe(400);
    expect(service.create).not.toHaveBeenCalled();
    await call("POST", "/admin/promotions", admin, valid);
    expect((service.create.mock.calls[0] as unknown as unknown[])[2]).toMatchObject({ code: "THU10", minOrder: 0, routeId: null });
  });

  it("nhà xe: chủ nhà xe (tenant từ token); nhân viên 403; khách kiểm mã không cần đăng nhập, chủ nhà xe 403", async () => {
    expect((await call("GET", "/operator/promotions?scope=PLATFORM", await token("OPERATOR_OWNER"))).status).toBe(200);
    const [authz, scope] = service.operatorList.mock.calls[0] as unknown as [{ db: { operatorId: string } }, string];
    expect([authz.db.operatorId, scope]).toEqual([operatorId, "PLATFORM"]);
    expect((await call("GET", "/operator/promotions", await token("DRIVER"))).status).toBe(403);
    expect((await call("PUT", `/operator/promotions/${randomUUID()}/participation`, await token("OPERATOR_OWNER"), {})).status).toBe(400);

    expect((await call("POST", "/promotions/check", null, { tripId: randomUUID(), code: "THU10", subtotal: 300_000 })).status).toBe(200);
    expect((await call("POST", "/promotions/check", await token("OPERATOR_OWNER"), { tripId: randomUUID(), code: "THU10", subtotal: 300_000 })).status).toBe(403);
    expect((await call("POST", "/promotions/check", null, { tripId: randomUUID(), code: "THU10", subtotal: 0 })).status).toBe(400);
  });
});
