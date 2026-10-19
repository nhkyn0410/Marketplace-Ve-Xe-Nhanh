import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { AdminDisputeController, CustomerDisputeController, OperatorDisputeController } from "../dispute/dispute.controller";
import { DisputeService } from "../dispute/dispute.service";
import { type AccessTokenClaims, TokenService } from "../iam/auth/token.service";
import { SessionService } from "../iam/session/session.service";
import { configureApiRoutes } from "../openapi/openapi";
import { AdminReviewController, CustomerReviewController, OperatorReviewController } from "../review/review.controller";
import { ReviewService } from "../review/review.service";
import { AdminSupportController } from "./admin-support.controller";
import { CustomerSupportController } from "./customer-support.controller";
import { OperatorSupportController } from "./operator-support.controller";
import { SupportService } from "./support.service";

/** Chuỗi guard thật của khiếu nại / tranh chấp / đánh giá (TASK-TRUST-001): khách, nhà xe, Admin + Hỗ trợ, quyết định chỉ Admin. */
describe("Khiếu nại, tranh chấp, đánh giá — HTTP", () => {
  const operatorId = randomUUID();
  const bookingId = randomUUID();
  const id = randomUUID();
  const page = { items: [], nextCursor: null, total: 0, unclassified: 0, open: 0, average: null, validCount: 0 };
  const support = {
    customerList: vi.fn(async () => ({ items: [] })),
    customerCreate: vi.fn(),
    operatorList: vi.fn(async () => page),
    adminList: vi.fn(async () => page),
    classify: vi.fn(),
  };
  const disputes = { decide: vi.fn(), requestEvidence: vi.fn(), adminList: vi.fn(async () => page) };
  const reviews = { customerGet: vi.fn(async () => ({ review: null, canReview: false })), moderate: vi.fn(), adminList: vi.fn(async () => page) };
  const reauth = { value: false };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  @Module({
    controllers: [
      CustomerSupportController,
      OperatorSupportController,
      AdminSupportController,
      AdminDisputeController,
      OperatorDisputeController,
      CustomerDisputeController,
      CustomerReviewController,
      OperatorReviewController,
      AdminReviewController,
    ],
    providers: [
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      { provide: SupportService, useValue: support },
      { provide: DisputeService, useValue: disputes },
      { provide: ReviewService, useValue: reviews },
      { provide: SessionService, useValue: { assertActive: async () => undefined, assertOperatorAccountCurrent: async () => undefined, hasRecentReauth: async () => reauth.value } },
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
    reauth.value = false;
  });

  async function token(role: AccessTokenClaims["role"]): Promise<string> {
    const platform = role.startsWith("PLATFORM");
    const passenger = role === "PASSENGER";
    return (
      await tokens.mintAccessToken({
        sub: passenger ? `user${randomUUID().slice(0, 8)}` : randomUUID(),
        sid: randomUUID(),
        scope: platform ? "platform" : passenger ? "passenger" : "operator",
        role,
        ...(platform || passenger ? {} : { operatorId, operatorSlug: "nhaxe" }),
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

  it("khách: khách vãng lai + hành khách gửi / xem khiếu nại của đơn; chủ nhà xe 403; đánh giá chỉ hành khách; body sai 400", async () => {
    expect((await call("GET", `/bookings/${bookingId}/support-tickets`, null)).status).toBe(200);
    expect((await call("GET", `/bookings/${bookingId}/support-tickets`, await token("PASSENGER"))).status).toBe(200);
    expect((await call("GET", `/bookings/${bookingId}/support-tickets`, await token("OPERATOR_OWNER"))).status).toBe(403);
    expect((await call("POST", `/bookings/${bookingId}/support-tickets`, null, { category: "OTHER", subject: "ab", body: "x" })).status).toBe(400);
    expect((await call("POST", `/bookings/${bookingId}/support-tickets`, null, { category: "OTHER", subject: "Xe trễ", body: "x", attachments: Array.from({ length: 6 }, () => ({ objectKey: "k", fileName: "f" })) })).status).toBe(400);
    expect(support.customerCreate).not.toHaveBeenCalled();

    expect((await call("GET", `/bookings/${bookingId}/review`, null)).status).toBe(401);
    expect((await call("GET", `/bookings/${bookingId}/review`, await token("PASSENGER"))).status).toBe(200);
    expect((await call("GET", `/bookings/${bookingId}/review`, await token("OPERATOR_OWNER"))).status).toBe(403);
    expect((await call("POST", `/bookings/${bookingId}/review`, await token("PASSENGER"), { rating: 6 })).status).toBe(400);
  });

  it("nhà xe: chủ nhà xe xem / phản hồi (tenant từ token); nhân viên 403; Admin hỗ trợ không gọi được route nhà xe phản hồi", async () => {
    expect((await call("GET", "/operator/support-tickets", await token("OPERATOR_OWNER"))).status).toBe(200);
    expect((support.operatorList.mock.calls[0] as unknown as [{ db: { operatorId: string } }])[0].db.operatorId).toBe(operatorId);
    for (const role of ["DRIVER", "TICKET_STAFF", "PLATFORM_SUPPORT"] as const) {
      expect((await call("GET", "/operator/support-tickets", await token(role))).status).toBe(403);
    }
    expect((await call("GET", "/operator/disputes", null)).status).toBe(401);
  });

  it("Admin: Quản trị viên + Hỗ trợ xử lý khiếu nại / tranh chấp; chủ nhà xe 403; quyết định chỉ Quản trị viên + xác nhận lại danh tính; kiểm duyệt đánh giá chỉ Quản trị viên", async () => {
    for (const role of ["PLATFORM_ADMIN", "PLATFORM_SUPPORT"] as const) {
      expect((await call("GET", "/admin/support-tickets?status=NEW", await token(role))).status).toBe(200);
      expect((await call("GET", "/admin/disputes?status=open&due=overdue", await token(role))).status).toBe(200);
    }
    expect((await call("GET", "/admin/support-tickets", await token("OPERATOR_OWNER"))).status).toBe(403);
    expect((await call("PATCH", `/admin/support-tickets/${id}`, await token("PLATFORM_SUPPORT"), { category: "OTHER", priority: "LOW", handler: "BOTH", assigneeId: null })).status).toBe(400);
    expect((await call("POST", `/admin/disputes/${id}/evidence-requests`, await token("PLATFORM_SUPPORT"), { party: "GUEST", message: "Gửi minh chứng", dueAt: new Date().toISOString() })).status).toBe(400);

    const decision = { decision: "REFUND", amount: 270_000, reason: "Xe trễ không thông báo" };
    expect((await call("POST", `/admin/disputes/${id}/decision`, await token("PLATFORM_SUPPORT"), decision)).status).toBe(403);
    // Chưa xác nhận lại danh tính gần đây → 401 (REAUTH_REQUIRED) để client hỏi lại mật khẩu / TOTP.
    expect((await call("POST", `/admin/disputes/${id}/decision`, await token("PLATFORM_ADMIN"), decision)).status).toBe(401);
    reauth.value = true;
    expect((await call("POST", `/admin/disputes/${id}/decision`, await token("PLATFORM_ADMIN"), { decision: "REFUND", amount: null, reason: "Thiếu số tiền" })).status).toBe(400);
    expect((await call("POST", `/admin/disputes/${id}/decision`, await token("PLATFORM_ADMIN"), { decision: "NO_REFUND", amount: 1000, reason: "Có số tiền" })).status).toBe(400);
    await call("POST", `/admin/disputes/${id}/decision`, await token("PLATFORM_ADMIN"), decision);
    expect((disputes.decide.mock.calls[0] as unknown as unknown[])[3]).toEqual(decision);

    expect((await call("GET", "/admin/reviews?status=attention", await token("PLATFORM_SUPPORT"))).status).toBe(403);
    expect((await call("GET", "/admin/reviews?status=attention", await token("PLATFORM_ADMIN"))).status).toBe(200);
    expect((await call("POST", `/admin/reviews/${id}/moderation`, await token("PLATFORM_ADMIN"), { action: "HIDE" })).status).toBe(400);
    expect(reviews.moderate).not.toHaveBeenCalled();
  });
});
