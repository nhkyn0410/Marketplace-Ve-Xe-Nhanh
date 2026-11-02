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
import { EmployeeAssignmentController } from "./employee-assignment.controller";
import { driverScheduleConflict } from "./employee-assignment.errors";
import { EmployeeAssignmentService } from "./employee-assignment.service";

/** Route thật + chuỗi guard `@Authorize("employee:manage")` thật (EMP-001); nghiệp vụ kiểm ở test DB. */
describe("Trip assignment routes — HTTP", () => {
  const operatorId = randomUUID();
  const tripId = randomUUID();
  const now = new Date().toISOString();
  const item = {
    tripId,
    departureAt: now,
    arrivalAt: now,
    status: "DRAFT",
    routeName: "SG - ĐL",
    vehiclePlateNumber: null,
    driver: null,
    conflict: null,
    reasonRequired: false,
    editable: true,
  };
  const service = {
    list: vi.fn(async () => ({ items: [item], nextCursor: null })),
    assignDriver: vi.fn(async () => item),
  };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  @Module({
    controllers: [EmployeeAssignmentController],
    providers: [
      { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      { provide: EmployeeAssignmentService, useValue: service },
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

  it.each([
    ["GET", "/trip-assignments?date=2031-03-10", undefined, 200],
    ["PUT", `/trips/${tripId}/driver`, { employeeId: randomUUID(), reason: null }, 200],
  ] as [string, string, object | undefined, number][])(
    "%s %s: Owner được, không token 401, nhân viên / Platform 403",
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

  it("người thực hiện + tenant lấy từ JWT; lý do cắt khoảng trắng, rỗng → null; limit mặc định 20", async () => {
    const owner = await token("OPERATOR_OWNER");
    await call("PUT", `/trips/${tripId}/driver`, owner, { employeeId: null, reason: "  ", operatorId: randomUUID() });
    const [actor, authz, path, input] = service.assignDriver.mock.calls[0] as unknown as [
      { role: string },
      { db: { operatorId: string } },
      string,
      Record<string, unknown>,
    ];
    expect(actor.role).toBe("OPERATOR_OWNER");
    expect(authz.db.operatorId).toBe(operatorId);
    expect(path).toBe(tripId);
    expect(input).toEqual({ employeeId: null, reason: null });
    await call("GET", "/trip-assignments?date=2031-03-10&state=UNASSIGNED", owner);
    const [, query] = service.list.mock.calls[0] as unknown as [unknown, { limit: number; state: string }];
    expect(query).toMatchObject({ limit: 20, state: "UNASSIGNED" });
  });

  it("409 DRIVER_SCHEDULE_CONFLICT theo RFC 7807 kèm câu nêu giờ chuyến kia", async () => {
    service.assignDriver.mockRejectedValueOnce(driverScheduleConflict("Tài xế đã chạy chuyến 06:00 16/10 – 11:30 16/10 trùng giờ với chuyến này."));
    const response = await call("PUT", `/trips/${tripId}/driver`, await token("OPERATOR_OWNER"), { employeeId: randomUUID(), reason: null });
    expect(response.status).toBe(409);
    expect(response.body).toMatchObject({ code: "DRIVER_SCHEDULE_CONFLICT", detail: expect.stringContaining("06:00 16/10") });
  });

  it.each([
    ["GET", "/trip-assignments", undefined],
    ["GET", "/trip-assignments?date=16/10/2026", undefined],
    ["GET", "/trip-assignments?date=2031-03-10&state=TRUNG", undefined],
    ["GET", "/trip-assignments?date=2031-03-10&limit=101", undefined],
    ["PUT", `/trips/${tripId}/driver`, { employeeId: "nv.tai", reason: null }],
    ["PUT", `/trips/${tripId}/driver`, { reason: null }],
  ])("%s %s dữ liệu sai → 400, service không bị gọi", async (method, path, body) => {
    const response = await call(method, path, await token("OPERATOR_OWNER"), body);
    expect(response.status).toBe(400);
    expect(service.list).not.toHaveBeenCalled();
    expect(service.assignDriver).not.toHaveBeenCalled();
  });
});
