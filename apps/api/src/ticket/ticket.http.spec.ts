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

/** Guard + kiểm body trên `/tickets/{id}` và `/guest/ticket-lookup*` (TASK-BTP-004); nghiệp vụ ở `ticket-lookup.int.spec.ts`, `payment.int.spec.ts`. */
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
    tripChanges: [],
    createdAt: now,
  };
  const otpResponse = { maskedEmail: "a***@example.com", expiresInSeconds: 300, resendAfterSeconds: 60, maxAttempts: 5 };
  const session = { lookupToken: "t".repeat(43), expiresAt: now };
  const bookingList = {
    maskedEmail: "a***@example.com",
    scope: "EMAIL",
    hasAccount: true,
    items: [
      {
        bookingId: booking.bookingId,
        bookingCode: booking.bookingCode,
        status: "CONFIRMED",
        routeName: "Tuyến",
        operatorName: "Nhà xe",
        departureAt: now,
        ticketCount: 1,
        total: 320000,
        bookedWithAccount: true,
        createdAt: now,
        // Field nội bộ mô phỏng service lỡ trả thêm: serializer phải cắt.
        contactEmail: "a@example.com",
      },
    ],
  };
  const service = {
    get: vi.fn(async () => ticket),
    requestOtp: vi.fn(async () => otpResponse),
    verifyOtp: vi.fn(async () => session),
    listBookings: vi.fn(async () => bookingList),
    lookup: vi.fn(async () => booking),
  };
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

  const post = (path: string, body: object) =>
    fetch(`${base}/guest/ticket-lookup${path}`, { method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify(body) });

  it("xem vé: mã truy cập tới service; hành khách được; chủ nhà xe 403; id không phải uuid 400", async () => {
    const response = await fetch(`${base}/tickets/${ticketId}`, { headers: { "X-Booking-Token": "ma" } });
    expect(response.status).toBe(200);
    expect(service.get.mock.calls[0]).toEqual([null, ticketId, "ma"]);
    expect((await fetch(`${base}/tickets/${ticketId}`, { headers: { authorization: `Bearer ${await token("PASSENGER")}` } })).status).toBe(200);
    expect((await fetch(`${base}/tickets/${ticketId}`, { headers: { authorization: `Bearer ${await token("OPERATOR_OWNER")}` } })).status).toBe(403);
    expect((await fetch(`${base}/tickets/khong-phai`)).status).toBe(400);
  });

  it("gửi mã: mã đặt vé không bắt buộc, chuẩn hoá (chữ thường, gạch, mã vé -NN), 202 phản hồi trung tính; thiếu email / có SĐT / mã sai dạng → 400", async () => {
    const response = await post("/otp", { bookingCode: "vxn-ab2cd3", email: "a@example.com" });
    expect(response.status).toBe(202);
    expect(await response.json()).toEqual(otpResponse);
    expect((service.requestOtp.mock.calls[0] as unknown as [unknown, object])[1]).toEqual({ bookingCode: "VXNAB2CD3", email: "a@example.com" });
    await post("/otp", { bookingCode: "VXNAB2CD3-02", email: "a@example.com" });
    expect((service.requestOtp.mock.calls[1] as unknown as [unknown, object])[1]).toEqual({ bookingCode: "VXNAB2CD3", email: "a@example.com" });
    expect((await post("/otp", { email: "a@example.com" })).status).toBe(202);
    expect((service.requestOtp.mock.calls[2] as unknown as [unknown, object])[1]).toEqual({ email: "a@example.com" });
    for (const body of [{ bookingCode: "VXNAB2CD3" }, { bookingCode: "VXNAB2CD3", phone: "0901234567" }, { bookingCode: "ABC", email: "a@example.com" }]) {
      expect((await post("/otp", body)).status, JSON.stringify(body)).toBe(400);
    }
    expect(service.requestOtp).toHaveBeenCalledTimes(3);
  });

  it("xác minh: 200 trả phiên tra cứu; mã không đủ 6 số → 400", async () => {
    const response = await post("/verify", { bookingCode: "VXNAB2CD3", email: "a@example.com", otp: "123456" });
    expect(response.status).toBe(200);
    expect(await response.json()).toEqual(session);
    for (const otp of ["12345", "12345a", "1234567"]) {
      expect((await post("/verify", { bookingCode: "VXNAB2CD3", email: "a@example.com", otp })).status, otp).toBe(400);
    }
    expect(service.verifyOtp).toHaveBeenCalledTimes(1);
  });

  it("danh sách đơn của phiên: 200, chỉ giữ field công khai; thiếu / sai phiên → 400", async () => {
    const response = await post("/bookings", { lookupToken: session.lookupToken });
    expect(response.status).toBe(200);
    const body = (await response.json()) as typeof bookingList;
    expect(body).toMatchObject({ scope: "EMAIL", hasAccount: true });
    expect(body.items[0]).not.toHaveProperty("contactEmail");
    expect(service.listBookings).toHaveBeenCalledWith({ lookupToken: session.lookupToken });
    for (const body of [{}, { lookupToken: "ngan" }]) {
      expect((await post("/bookings", body)).status, JSON.stringify(body)).toBe(400);
    }
    expect(service.listBookings).toHaveBeenCalledTimes(1);
  });

  it("tra cứu: chỉ nhận phiên tra cứu (+ id đơn khi phiên theo email), 200 trả booking + vé", async () => {
    const response = await post("", { lookupToken: session.lookupToken });
    expect(response.status).toBe(200);
    expect(((await response.json()) as { tickets: unknown[] }).tickets).toHaveLength(1);
    expect(service.lookup).toHaveBeenCalledWith({ lookupToken: session.lookupToken });
    await post("", { lookupToken: session.lookupToken, bookingId: booking.bookingId });
    expect(service.lookup).toHaveBeenLastCalledWith({ lookupToken: session.lookupToken, bookingId: booking.bookingId });
    for (const body of [{ bookingCode: "VXNAB2CD3", email: "a@example.com" }, { lookupToken: "ngan" }, { lookupToken: session.lookupToken, bookingId: "khong-phai-uuid" }]) {
      expect((await post("", body)).status, JSON.stringify(body)).toBe(400);
    }
    expect(service.lookup).toHaveBeenCalledTimes(2);
  });
});
