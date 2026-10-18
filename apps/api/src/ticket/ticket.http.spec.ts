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
import { TicketController } from "./ticket.controller";
import { TicketService } from "./ticket.service";

/** Guard + kiểm body trên `/tickets/{id}` và `/guest/ticket-lookup` (TASK-BTP-004); nghiệp vụ ở `payment.int.spec.ts`. */
describe("Vé — HTTP", () => {
  const ticketId = randomUUID();
  const now = new Date().toISOString();
  const stop = { sequence: 1, name: "Bến", address: "Địa chỉ", plannedAt: now };
  const ticket = {
    ticketId,
    ticketCode: "VXNAB2CD3-01",
    status: "VALID",
    seatCode: "A1",
    seatType: "BED",
    passengerName: "A",
    bookingId: randomUUID(),
    bookingCode: "VXNAB2CD3",
    bookingStatus: "CONFIRMED",
    trip: { routeName: "Tuyến", operatorName: "Nhà xe", operatorHotline: null, vehicleTypeName: "Giường", departureAt: now, arrivalAt: now },
    pickup: stop,
    dropoff: { ...stop, sequence: 3 },
    qrToken: "qr",
    issuedAt: now,
    checkedInAt: null,
  };
  const booking = {
    bookingId: ticket.bookingId,
    bookingCode: "VXNAB2CD3",
    status: "CONFIRMED",
    tripId: randomUUID(),
    trip: ticket.trip,
    pickup: stop,
    dropoff: ticket.dropoff,
    contact: { fullName: "A", phone: "0901234567", email: "a@example.com" },
    passengers: [{ seatCode: "A1", seatType: "BED", fullName: "A", phone: null, price: 320000 }],
    note: null,
    subtotal: 320000,
    serviceFee: 0,
    discount: 0,
    total: 320000,
    cancellationPolicy: { tiers: [] },
    expiresAt: now,
    payment: null,
    tickets: [{ ticketId, ticketCode: "VXNAB2CD3-01", seatCode: "A1", passengerName: "A", status: "VALID", qrToken: "qr" }],
    refunds: [],
    createdAt: now,
  };
  const service = { get: vi.fn(async () => ticket), lookup: vi.fn(async () => booking) };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  @Module({
    controllers: [TicketController],
    providers: [
      { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      GuestOrPassengerGuard,
      { provide: TicketService, useValue: service },
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

  const lookup = (body: object) =>
    fetch(`${base}/guest/ticket-lookup`, { method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify(body) });

  it("xem vé: mã truy cập tới service; hành khách được; chủ nhà xe 403; id không phải uuid 400", async () => {
    const response = await fetch(`${base}/tickets/${ticketId}`, { headers: { "X-Booking-Token": "ma" } });
    expect(response.status).toBe(200);
    expect(service.get.mock.calls[0]).toEqual([null, ticketId, "ma"]);
    expect((await fetch(`${base}/tickets/${ticketId}`, { headers: { authorization: `Bearer ${await token("PASSENGER")}` } })).status).toBe(200);
    expect((await fetch(`${base}/tickets/${ticketId}`, { headers: { authorization: `Bearer ${await token("OPERATOR_OWNER")}` } })).status).toBe(403);
    expect((await fetch(`${base}/tickets/khong-phai`)).status).toBe(400);
  });

  it("tra cứu: mã booking chuẩn hoá (chữ thường, gạch), 200 trả booking + vé; thiếu / thừa liên hệ hoặc mã sai dạng → 400", async () => {
    const response = await lookup({ bookingCode: "vxn-ab2cd3", phone: "0901 234 567" });
    expect(response.status).toBe(200);
    expect(((await response.json()) as { tickets: unknown[] }).tickets).toHaveLength(1);
    expect((service.lookup.mock.calls[0] as unknown as [unknown, { bookingCode: string; phone: string }])[1]).toMatchObject({ bookingCode: "VXNAB2CD3", phone: "0901234567" });
    for (const body of [
      { bookingCode: "VXNAB2CD3" },
      { bookingCode: "VXNAB2CD3", phone: "0901234567", email: "a@example.com" },
      { bookingCode: "ABC", phone: "0901234567" },
    ]) {
      expect((await lookup(body)).status, JSON.stringify(body)).toBe(400);
    }
    expect(service.lookup).toHaveBeenCalledTimes(1);
  });
});
