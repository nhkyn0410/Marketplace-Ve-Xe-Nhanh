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
import { BookingController } from "./booking.controller";
import { BookingService } from "./booking.service";

/** Guard thật "khách vãng lai hoặc hành khách" + kiểm body trên `/bookings` (TASK-BTP-002); nghiệp vụ ở `.int.spec.ts`. */
describe("Đặt vé — HTTP", () => {
  const bookingId = randomUUID();
  const now = new Date().toISOString();
  const stop = { sequence: 1, name: "Bến", address: "Địa chỉ", plannedAt: now };
  const booking = {
    bookingId,
    bookingCode: "VXNAB2CD3",
    status: "PENDING_PAYMENT",
    tripId: randomUUID(),
    trip: { routeName: "Tuyến", operatorName: "Nhà xe", operatorHotline: null, vehicleTypeName: "Giường", departureAt: now, arrivalAt: now },
    pickup: stop,
    dropoff: { ...stop, sequence: 3 },
    contact: { fullName: "A", phone: "0901234567", email: "a@example.com" },
    passengers: [{ seatCode: "A1", seatType: "BED", fullName: "A", phone: null, companionName: null, price: 320000 }],
    note: null,
    subtotal: 320000,
    serviceFee: 0,
    discount: 0,
    discountFunding: null,
    total: 320000,
    cancellationPolicy: { tiers: [] },
    expiresAt: now,
    payment: null,
    tickets: [],
    refunds: [],
    tripChanges: [],
    createdAt: now,
  };
  const service = {
    create: vi.fn(async () => ({ ...booking, accessToken: "ma-truy-cap" })),
    get: vi.fn(async () => booking),
  };
  const assertActive = vi.fn(async () => undefined);
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  @Module({
    controllers: [BookingController],
    providers: [
      { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      GuestOrPassengerGuard,
      { provide: BookingService, useValue: service },
      { provide: SessionService, useValue: { assertActive, assertOperatorAccountCurrent: async () => undefined } },
    ],
  })
  class HttpTestModule {}

  beforeAll(async () => {
    app = await NestFactory.create(HttpTestModule, { logger: false, abortOnError: false });
    app.useGlobalPipes(new ZodValidationPipe());
    app.useGlobalFilters(new ProblemDetailsExceptionFilter());
    configureApiRoutes(app);
    await app.listen(0, "127.0.0.1");
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1/bookings`;
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

  async function call(method: string, path: string, accessToken: string | null, body?: object, headers: Record<string, string> = {}) {
    const response = await fetch(`${base}${path}`, {
      method,
      headers: { ...(accessToken ? { authorization: `Bearer ${accessToken}` } : {}), "content-type": "application/json", ...headers },
      ...(body ? { body: JSON.stringify(body) } : {}),
    });
    return { status: response.status, body: (await response.json()) as Record<string, unknown> };
  }

  const body = {
    holdId: randomUUID(),
    contact: { fullName: " Nguyễn Văn A ", phone: "+84 901 234 567", email: "a@example.com" },
    passengers: [{ seatCode: "a1", fullName: "Nguyễn Văn A", phone: null }],
    note: "",
    expectedTotal: 320000,
  };

  it("khách vãng lai tạo booking: 201 kèm mã truy cập; body chuẩn hoá (tên, số điện thoại, mã chỗ, ghi chú rỗng → null)", async () => {
    const response = await call("POST", "", null, body);
    expect(response).toMatchObject({ status: 201, body: { bookingId, accessToken: "ma-truy-cap", total: 320000 } });
    const [user, input] = service.create.mock.calls[0] as unknown as [unknown, typeof body];
    expect(user).toBeNull();
    expect(input).toMatchObject({
      contact: { fullName: "Nguyễn Văn A", phone: "+84901234567" },
      passengers: [{ seatCode: "A1" }],
      note: null,
    });
    expect(assertActive).not.toHaveBeenCalled();
  });

  it("hành khách đăng nhập: người dùng từ token; token rác → 401; chủ nhà xe / tài xế / Admin → 403", async () => {
    expect((await call("POST", "", await token("PASSENGER"), body)).status).toBe(201);
    expect((service.create.mock.calls[0] as unknown as [{ sub: string }])[0].sub).toBe("user-PASSENGER");
    expect((await call("POST", "", "rac.rac.rac", body)).status).toBe(401);
    for (const role of ["OPERATOR_OWNER", "DRIVER", "PLATFORM_ADMIN"] as const) {
      expect(await call("POST", "", await token(role), body), role).toMatchObject({ status: 403, body: { code: "PERMISSION_DENIED" } });
    }
    expect(service.create).toHaveBeenCalledTimes(1);
  });

  it("xem booking: mã truy cập ở header X-Booking-Token tới service; bookingId không phải uuid → 400", async () => {
    expect((await call("GET", `/${bookingId}`, null, undefined, { "X-Booking-Token": "ma-truy-cap" })).status).toBe(200);
    expect(service.get.mock.calls[0]).toEqual([null, bookingId, "ma-truy-cap"]);
    expect((await call("GET", "/khong-phai", null)).status).toBe(400);
  });

  it.each([
    [{ ...body, holdId: "khong" }],
    [{ ...body, passengers: [] }],
    [{ ...body, passengers: [body.passengers[0], body.passengers[0]] }],
    [{ ...body, contact: { ...body.contact, phone: "12345" } }],
    [{ ...body, contact: { ...body.contact, email: "khong-phai-email" } }],
    [{ ...body, expectedTotal: -1 }],
    [{ ...body, expectedTotal: 320000.5 }],
  ])("body sai → 400, service không bị gọi", async (input) => {
    expect((await call("POST", "", null, input)).status).toBe(400);
    expect(service.create).not.toHaveBeenCalled();
  });
});
