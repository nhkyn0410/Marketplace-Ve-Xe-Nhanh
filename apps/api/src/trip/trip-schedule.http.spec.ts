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
import { TripScheduleController } from "./trip-schedule.controller";
import { todayInVietnam } from "./trip-schedule-dates";
import { TripScheduleService } from "./trip-schedule.service";

/** Route thật + chuỗi guard `@Authorize("trip:manage")` thật cho lịch chuyến lặp lại (TRN-007); nghiệp vụ kiểm ở test DB. */
describe("Trip schedule routes — HTTP", () => {
  const operatorId = randomUUID();
  const id = randomUUID();
  const now = new Date().toISOString();
  const today = todayInVietnam(new Date());
  const schedule = {
    id,
    routeId: randomUUID(),
    routeName: "SG - ĐL",
    vehicleId: null,
    vehiclePlateNumber: null,
    departureTime: "06:00",
    durationMinutes: 330,
    daysOfWeek: [1, 3, 5],
    startDate: today,
    endDate: today,
    onlineSaleCutoffMinutes: 60,
    note: null,
    tripCount: 0,
    lastGeneratedAt: null,
    createdAt: now,
    updatedAt: now,
  };
  const service = {
    list: vi.fn(async () => ({ items: [schedule] })),
    get: vi.fn(async () => schedule),
    create: vi.fn(async () => schedule),
    update: vi.fn(async () => schedule),
    generate: vi.fn(async () => ({ created: [], skipped: [{ serviceDate: today, reason: "PAST" }] })),
  };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  @Module({
    controllers: [TripScheduleController],
    providers: [
      { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      { provide: TripScheduleService, useValue: service },
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

  const scheduleBody = {
    routeId: randomUUID(),
    vehicleId: null,
    departureTime: "06:00",
    durationMinutes: 330,
    daysOfWeek: [5, 1, 3],
    startDate: today,
    endDate: today,
    onlineSaleCutoffMinutes: 60,
    note: " Chạy cố định ",
  };

  it.each([
    ["GET", "/trip-schedules", undefined, 200],
    ["GET", `/trip-schedules/${id}`, undefined, 200],
    ["POST", "/trip-schedules", scheduleBody, 201],
    ["PUT", `/trip-schedules/${id}`, scheduleBody, 200],
    ["POST", `/trip-schedules/${id}/generate`, { openForSale: false }, 200],
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

  it("tenant + người thực hiện lấy từ JWT; không nhận operatorId từ body; ghi chú được cắt khoảng trắng", async () => {
    await call("POST", "/trip-schedules", await token("OPERATOR_OWNER"), { ...scheduleBody, operatorId: randomUUID() });
    const [actor, authz, input] = service.create.mock.calls[0] as unknown as [
      { role: string },
      { db: { operatorId: string } },
      Record<string, unknown>,
    ];
    expect(actor.role).toBe("OPERATOR_OWNER");
    expect(authz.db.operatorId).toBe(operatorId);
    expect(input).not.toHaveProperty("operatorId");
    expect(input.note).toBe("Chạy cố định");
  });

  it.each([
    ["POST", "/trip-schedules", { ...scheduleBody, departureTime: "6:00" }],
    ["POST", "/trip-schedules", { ...scheduleBody, durationMinutes: 0 }],
    ["POST", "/trip-schedules", { ...scheduleBody, daysOfWeek: [] }],
    ["POST", "/trip-schedules", { ...scheduleBody, daysOfWeek: [0] }],
    ["POST", "/trip-schedules", { ...scheduleBody, endDate: "2020-01-01" }],
    ["POST", "/trip-schedules", { ...scheduleBody, startDate: "17/10/2026" }],
    ["PUT", `/trip-schedules/${id}`, { routeId: scheduleBody.routeId }],
    ["POST", `/trip-schedules/${id}/generate`, {}],
  ])("%s %s dữ liệu sai → 400, service không bị gọi", async (method, path, body) => {
    const response = await call(method, path, await token("OPERATOR_OWNER"), body);
    expect(response.status).toBe(400);
    for (const fn of Object.values(service)) {
      expect(fn).not.toHaveBeenCalled();
    }
  });
});
