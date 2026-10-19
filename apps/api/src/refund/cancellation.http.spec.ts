import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { APP_INTERCEPTOR, NestFactory } from "@nestjs/core";
import { ZodSerializerInterceptor, ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { type AccessTokenClaims, TokenService } from "../iam/auth/token.service";
import { GuestOrPassengerGuard } from "../iam/role/guest-or-passenger";
import { SessionService } from "../iam/session/session.service";
import { configureApiRoutes } from "../openapi/openapi";
import { CancellationController } from "./cancellation.controller";
import { CancellationService } from "./cancellation.service";

/** Guard thật "khách vãng lai hoặc hành khách" (`refund:request`) + kiểm query / body trên route hủy vé (TASK-BTP-005). */
describe("Hủy vé — HTTP", () => {
  const bookingId = randomUUID();
  const ticketA = randomUUID();
  const ticketB = randomUUID();
  const quote = { tickets: [], tier: null, refundPercent: 0, selectedTotal: 0, refundAmount: 0, nonRefundable: 0 };
  const service = { quote: vi.fn(async () => quote), cancel: vi.fn() };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  @Module({
    controllers: [CancellationController],
    providers: [
      { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      GuestOrPassengerGuard,
      { provide: CancellationService, useValue: service },
      { provide: SessionService, useValue: { assertActive: async () => undefined, assertOperatorAccountCurrent: async () => undefined } },
    ],
  })
  class HttpTestModule {}

  beforeAll(async () => {
    app = await NestFactory.create(HttpTestModule, { logger: false, abortOnError: false });
    app.useGlobalPipes(new ZodValidationPipe());
    app.useGlobalFilters(new ProblemDetailsExceptionFilter());
    configureApiRoutes(app);
    await app.listen(0, "127.0.0.1");
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1/bookings/${bookingId}`;
    tokens = app.get(TokenService);
  }, 15_000);

  afterAll(async () => {
    await app?.close();
  });

  beforeEach(() => {
    vi.clearAllMocks();
  });

  async function token(role: AccessTokenClaims["role"]): Promise<string> {
    const scope = role === "PASSENGER" ? "passenger" : role.startsWith("PLATFORM") ? "platform" : "operator";
    return (
      await tokens.mintAccessToken({
        sub: `user-${role}`,
        sid: randomUUID(),
        scope,
        role,
        ...(scope === "operator" ? { operatorId: randomUUID(), operatorSlug: "nhaxe" } : {}),
        ...(scope === "passenger" ? {} : { mfa: true }),
      })
    ).accessToken;
  }

  it("xem điều kiện: danh sách vé phân tách dấu phẩy + mã truy cập tới service; hành khách được; chủ nhà xe 403; vé không phải uuid / rỗng → 400", async () => {
    const response = await fetch(`${base}/cancellation-quote?ticketIds=${ticketA},%20${ticketB}`, { headers: { "X-Booking-Token": "ma" } });
    expect(response.status).toBe(200);
    expect(service.quote.mock.calls[0]).toEqual([null, bookingId, "ma", [ticketA, ticketB]]);
    const passenger = await token("PASSENGER");
    expect((await fetch(`${base}/cancellation-quote?ticketIds=${ticketA}`, { headers: { authorization: `Bearer ${passenger}` } })).status).toBe(200);
    expect((await fetch(`${base}/cancellation-quote?ticketIds=${ticketA}`, { headers: { authorization: `Bearer ${await token("OPERATOR_OWNER")}` } })).status).toBe(403);
    expect((await fetch(`${base}/cancellation-quote?ticketIds=khong`)).status).toBe(400);
    expect((await fetch(`${base}/cancellation-quote?ticketIds=`)).status).toBe(400);
    expect(service.quote).toHaveBeenCalledTimes(2);
  });

  it.each([
    [{ ticketIds: [], expectedRefund: 0, reason: null }],
    [{ ticketIds: ["khong"], expectedRefund: 0, reason: null }],
    [{ ticketIds: [ticketA, ticketA], expectedRefund: 0, reason: null }],
    [{ ticketIds: [ticketA], expectedRefund: -1, reason: null }],
    [{ ticketIds: [ticketA], expectedRefund: 1.5, reason: null }],
  ])("xác nhận hủy: body sai → 400, service không bị gọi", async (body) => {
    const response = await fetch(`${base}/cancellations`, { method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify(body) });
    expect(response.status).toBe(400);
    expect(service.cancel).not.toHaveBeenCalled();
  });
});
