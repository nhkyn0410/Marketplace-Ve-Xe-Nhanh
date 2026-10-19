import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { APP_INTERCEPTOR, NestFactory } from "@nestjs/core";
import { ZodSerializerInterceptor, ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { type AccessTokenClaims, TokenService } from "../iam/auth/token.service";
import { SessionService } from "../iam/session/session.service";
import { configureApiRoutes } from "../openapi/openapi";
import { TripController } from "./trip.controller";
import { tripNotReadyForSale } from "./trip.errors";
import { TripChangeService } from "./trip-change.service";
import { TripService } from "./trip.service";

/** Route thật + chuỗi guard `@Authorize("trip:manage")` thật; nghiệp vụ kiểm ở test DB. */
describe("Trip routes — HTTP", () => {
  const operatorId = randomUUID();
  const id = randomUUID();
  const now = new Date().toISOString();
  const trip = {
    id,
    routeId: randomUUID(),
    routeName: "SG - ĐL",
    vehicleId: null,
    vehiclePlateNumber: null,
    departureAt: now,
    arrivalAt: now,
    status: "DRAFT",
    seatCount: 0,
    onlineSaleCutoffMinutes: 60,
    statusReason: null,
    departedAt: null,
    completedAt: null,
    note: null,
    stops: [],
    seats: [],
    createdAt: now,
    updatedAt: now,
  };
  const service = {
    list: vi.fn(async () => ({ items: [], nextCursor: null })),
    get: vi.fn(async () => trip),
    create: vi.fn(async () => trip),
    update: vi.fn(async () => trip),
    changeStatus: vi.fn(async () => trip),
    setSeatStatus: vi.fn(async () => trip),
  };
  const changes = {
    sales: vi.fn(async () => ({ soldSeats: 0, holdingSeats: 0, activeBookings: 0, pendingBookings: 0, refundOnCancel: 0, changes: [] })),
    change: vi.fn(async () => trip),
    cancel: vi.fn(async () => trip),
  };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  @Module({
    controllers: [TripController],
    providers: [
      { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      { provide: TripService, useValue: service },
      { provide: TripChangeService, useValue: changes },
      {
        provide: SessionService,
        useValue: { assertActive: async () => undefined, assertOperatorAccountCurrent: async () => undefined },
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
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1/operator`;
    tokens = app.get(TokenService);
  }, 15_000);

  afterAll(async () => {
    await app?.close();
  });

  beforeEach(() => {
    vi.clearAllMocks();
  });

  async function token(role: AccessTokenClaims["role"]): Promise<string> {
    const platform = role === "PLATFORM_ADMIN" || role === "PLATFORM_SUPPORT";
    return (
      await tokens.mintAccessToken({
        sub: randomUUID(),
        sid: randomUUID(),
        scope: platform ? "platform" : "operator",
        role,
        ...(platform ? {} : { operatorId, operatorSlug: "test-operator" }),
        ...(role === "OPERATOR_OWNER" || platform ? { mfa: true } : {}),
      })
    ).accessToken;
  }

  async function call(method: string, path: string, accessToken?: string, body?: object) {
    const response = await fetch(`${base}${path}`, {
      method,
      headers: { ...(accessToken ? { authorization: `Bearer ${accessToken}` } : {}), "content-type": "application/json" },
      ...(body ? { body: JSON.stringify(body) } : {}),
    });
    return { status: response.status, body: (await response.json()) as Record<string, unknown> };
  }

  const tripBody = {
    routeId: randomUUID(),
    vehicleId: randomUUID(),
    departureAt: "2031-01-01T07:00:00+07:00",
    arrivalAt: "2031-01-01T15:00:00+07:00",
    stopTimes: null,
    onlineSaleCutoffMinutes: 60,
    note: null,
  };

  it.each([
    ["GET", "/trips", undefined, 200],
    ["GET", `/trips/${id}`, undefined, 200],
    ["POST", "/trips", tripBody, 201],
    ["PUT", `/trips/${id}`, tripBody, 200],
    ["PUT", `/trips/${id}/status`, { status: "OPEN_FOR_SALE", reason: null }, 200],
    ["PUT", `/trips/${id}/seats/status`, { seatCodes: ["A1"], status: "BLOCKED", note: null }, 200],
  ] as [string, string, object | undefined, number][])(
    "%s %s: Owner được, không token 401, Employee/Platform 403",
    async (method, path, body, ok) => {
      expect((await call(method, path, await token("OPERATOR_OWNER"), body)).status).toBe(ok);
      expect((await call(method, path, undefined, body)).status).toBe(401);
      for (const role of ["DRIVER", "TICKET_STAFF", "SUPPORT_STAFF", "PLATFORM_ADMIN", "PLATFORM_SUPPORT"] as const) {
        const denied = await call(method, path, await token(role), body);
        expect(denied.status, role).toBe(403);
        expect(denied.body.code, role).toBe("PERMISSION_DENIED");
      }
    },
  );

  it("mass assignment: tenant lấy từ JWT; không nhận status/operatorId từ body", async () => {
    await call("POST", "/trips", await token("OPERATOR_OWNER"), {
      ...tripBody,
      operatorId: randomUUID(),
      status: "OPEN_FOR_SALE",
    });
    const [authz, input] = service.create.mock.calls[0] as unknown as [
      { db: { operatorId: string } },
      Record<string, unknown>,
    ];
    expect(authz.db.operatorId).toBe(operatorId);
    expect(input).not.toHaveProperty("operatorId");
    expect(input).not.toHaveProperty("status");
  });

  it("đổi trạng thái / khóa ghế: người thực hiện lấy từ token, tenant từ JWT, mã ghế chuẩn hoá", async () => {
    const owner = await token("OPERATOR_OWNER");
    await call("PUT", `/trips/${id}/status`, owner, { status: "LOCKED", reason: " Tạm dừng ", operatorId: randomUUID() });
    const [actor, authz, tripId, input] = service.changeStatus.mock.calls[0] as unknown as [
      { sub: string; role: string },
      { db: { operatorId: string } },
      string,
      Record<string, unknown>,
    ];
    expect(actor.role).toBe("OPERATOR_OWNER");
    expect(authz.db.operatorId).toBe(operatorId);
    expect(tripId).toBe(id);
    expect(input).toEqual({ status: "LOCKED", reason: "Tạm dừng" });
    // Hủy chuyến (có hoặc chưa có vé) đi luồng TRN-008: hủy đơn chờ thanh toán, hủy vé + hoàn tiền, báo khách.
    await call("PUT", `/trips/${id}/status`, owner, { status: "CANCELLED", reason: " Xe hỏng " });
    expect(service.changeStatus).toHaveBeenCalledTimes(1);
    const [, cancelAuthz, cancelTrip, reason] = changes.cancel.mock.calls[0] as unknown as [unknown, { db: { operatorId: string } }, string, string];
    expect(cancelAuthz.db.operatorId).toBe(operatorId);
    expect([cancelTrip, reason]).toEqual([id, "Xe hỏng"]);
    await call("PUT", `/trips/${id}/seats/status`, owner, { seatCodes: ["a1"], status: "AVAILABLE", note: "" });
    const [, , , seatInput] = service.setSeatStatus.mock.calls[0] as unknown as [unknown, unknown, string, object];
    expect(seatInput).toEqual({ seatCodes: ["A1"], status: "AVAILABLE", note: null });
  });

  it("đổi chuyến đã bán (TRN-008): chỉ chủ nhà xe; body chuẩn hoá; thiếu lý do / điểm sai → 400; xem tình hình bán", async () => {
    const owner = await token("OPERATOR_OWNER");
    const body = {
      departureAt: "2031-01-01T23:00:00+07:00",
      arrivalAt: "2031-01-02T06:00:00+07:00",
      stopTimes: null,
      vehicleId: randomUUID(),
      stops: [
        { sequence: 1, catalogStopPointId: randomUUID(), stopPointId: null },
        { sequence: 2, catalogStopPointId: null, stopPointId: randomUUID() },
      ],
      reason: " Đổi giờ do tắc đường ",
    };
    expect((await call("POST", `/trips/${id}/changes`, owner, body)).status).toBe(200);
    const [, , changedTrip, input] = changes.change.mock.calls[0] as unknown as [unknown, unknown, string, { reason: string; departureAt: Date }];
    expect(changedTrip).toBe(id);
    expect(input.reason).toBe("Đổi giờ do tắc đường");
    expect(input.departureAt.toISOString()).toBe("2031-01-01T16:00:00.000Z");
    expect((await call("POST", `/trips/${id}/changes`, owner, { ...body, reason: "" })).status).toBe(400);
    expect((await call("POST", `/trips/${id}/changes`, owner, { ...body, stops: [{ sequence: 1, catalogStopPointId: randomUUID(), stopPointId: randomUUID() }, body.stops[1]] })).status).toBe(400);
    expect((await call("POST", `/trips/${id}/changes`, await token("DRIVER"), body)).status).toBe(403);
    expect(changes.change).toHaveBeenCalledTimes(1);
    expect((await call("GET", `/trips/${id}/sales`, owner)).status).toBe(200);
    expect((await call("GET", `/trips/${id}/sales`, await token("DRIVER"))).status).toBe(403);
  });

  it("422 TRIP_NOT_READY_FOR_SALE trả `reasons` theo RFC 7807 (API §6.2)", async () => {
    service.changeStatus.mockRejectedValueOnce(tripNotReadyForSale(["VEHICLE_MISSING", "FARE_MISSING"]));
    const response = await call("PUT", `/trips/${id}/status`, await token("OPERATOR_OWNER"), {
      status: "OPEN_FOR_SALE",
      reason: null,
    });
    expect(response.status).toBe(422);
    expect(response.body).toMatchObject({ code: "TRIP_NOT_READY_FOR_SALE", reasons: ["VEHICLE_MISSING", "FARE_MISSING"] });
  });

  it("query list: giờ có múi giờ đổi về Date, limit mặc định 20", async () => {
    const from = "2031-01-01T00:00:00+07:00";
    expect((await call("GET", `/trips?departureFrom=${encodeURIComponent(from)}`, await token("OPERATOR_OWNER"))).status).toBe(200);
    const [, query] = service.list.mock.calls[0] as unknown as [unknown, { departureFrom: Date; limit: number }];
    expect(query.departureFrom.toISOString()).toBe("2030-12-31T17:00:00.000Z");
    expect(query.limit).toBe(20);
  });

  it.each([
    ["POST", "/trips", { ...tripBody, arrivalAt: "2031-01-01T06:00:00+07:00" }],
    ["POST", "/trips", { ...tripBody, routeId: "khong-phai-uuid" }],
    ["PUT", `/trips/${id}`, { routeId: tripBody.routeId, departureAt: tripBody.departureAt }],
    ["GET", "/trips?status=UNKNOWN", undefined],
    ["GET", "/trips?limit=101", undefined],
    ["GET", "/trips?departureFrom=hom-nay", undefined],
    ["GET", `/trips?departureFrom=${encodeURIComponent("0202-10-13T00:00:00+07:00")}`, undefined],
    ["POST", "/trips", { ...tripBody, onlineSaleCutoffMinutes: 1441 }],
    ["PUT", `/trips/${id}/status`, { status: "CANCELLED", reason: null }],
    ["PUT", `/trips/${id}/status`, { status: "SOLD_OUT", reason: null }],
    ["PUT", `/trips/${id}/seats/status`, { seatCodes: [], status: "BLOCKED", note: null }],
    ["PUT", `/trips/${id}/seats/status`, { seatCodes: ["A1"], status: "BOOKED", note: null }],
  ])("%s %s dữ liệu sai → 400, service không bị gọi", async (method, path, body) => {
    const response = await call(method, path, await token("OPERATOR_OWNER"), body);
    expect(response.status).toBe(400);
    for (const fn of [...Object.values(service), ...Object.values(changes)]) {
      expect(fn).not.toHaveBeenCalled();
    }
  });
});
