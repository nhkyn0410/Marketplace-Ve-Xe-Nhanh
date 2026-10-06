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
import { StopPointProposalController } from "../stop-point/stop-point-proposal.controller";
import { StopPointProposalService } from "../stop-point/stop-point-proposal.service";
import { StopPointController } from "../stop-point/stop-point.controller";
import { StopPointService } from "../stop-point/stop-point.service";
import { RouteController } from "./route.controller";
import { RouteService } from "./route.service";

/** Route thật + chuỗi guard `@Authorize("route:manage")` thật; nghiệp vụ kiểm ở test DB. */
describe("Route / StopPoint / Proposal routes — HTTP", () => {
  const operatorId = randomUUID();
  const id = randomUUID();
  const now = new Date().toISOString();
  const location = {
    name: "Văn phòng Q5",
    type: "OFFICE",
    address: "1 Trần Hưng Đạo",
    provinceId: randomUUID(),
    wardId: randomUUID(),
    latitude: 10.75,
    longitude: 106.66,
    description: null,
  };
  // BR-38: đề xuất chỉ nhận bến xe / điểm dừng đón trả và phải kèm căn cứ công bố.
  const proposalBody = { ...location, type: "BUS_STATION", legalBasis: "QĐ 1234/QĐ-SGTVT" };
  const stopPoint = { ...location, id, status: "ACTIVE", suspensionReason: null, routeCount: 0, createdAt: now, updatedAt: now };
  const proposal = { ...proposalBody, id, status: "PENDING", rejectionReason: null, catalogStopPointId: null, createdAt: now, updatedAt: now };
  const route = {
    id,
    name: "SG - ĐL",
    status: "ACTIVE",
    note: null,
    totalDistanceMeters: 1000,
    totalDurationSeconds: 60,
    metricsSource: "GOONG",
    stops: [],
    createdAt: now,
    updatedAt: now,
  };
  const services = {
    routes: { list: vi.fn(async () => ({ items: [], nextCursor: null })), get: vi.fn(async () => route), create: vi.fn(async () => route), update: vi.fn(async () => route) },
    stopPoints: { list: vi.fn(async () => ({ items: [], nextCursor: null })), get: vi.fn(async () => stopPoint), create: vi.fn(async () => stopPoint), update: vi.fn(async () => stopPoint) },
    proposals: { list: vi.fn(async () => ({ items: [], nextCursor: null })), create: vi.fn(async () => proposal), resubmit: vi.fn(async () => proposal) },
  };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  @Module({
    controllers: [RouteController, StopPointController, StopPointProposalController],
    providers: [
      { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      { provide: RouteService, useValue: services.routes },
      { provide: StopPointService, useValue: services.stopPoints },
      { provide: StopPointProposalService, useValue: services.proposals },
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

  const routeBody = {
    name: "SG - ĐL",
    status: "ACTIVE",
    note: null,
    stops: [
      { catalogStopPointId: randomUUID(), stopPointId: null, note: null, allowPickup: true, allowDropoff: false },
      { catalogStopPointId: null, stopPointId: randomUUID(), note: null, allowPickup: false, allowDropoff: true },
    ],
  };
  const routes: [string, string, object | undefined, number][] = [
    ["GET", "/routes", undefined, 200],
    ["GET", `/routes/${id}`, undefined, 200],
    ["POST", "/routes", routeBody, 201],
    ["PUT", `/routes/${id}`, routeBody, 200],
    ["GET", "/stop-points", undefined, 200],
    ["GET", `/stop-points/${id}`, undefined, 200],
    ["POST", "/stop-points", { ...location, status: "ACTIVE" }, 201],
    ["PUT", `/stop-points/${id}`, { ...location, status: "ACTIVE" }, 200],
    ["GET", "/stop-point-proposals", undefined, 200],
    ["POST", "/stop-point-proposals", proposalBody, 201],
    ["PUT", `/stop-point-proposals/${id}`, proposalBody, 200],
  ];

  it.each(routes)("%s %s: Owner được, không token 401, Employee/Platform 403", async (method, path, body, ok) => {
    expect((await call(method, path, await token("OPERATOR_OWNER"), body)).status).toBe(ok);
    expect((await call(method, path, undefined, body)).status).toBe(401);
    for (const role of ["DRIVER", "TICKET_STAFF", "SUPPORT_STAFF", "PLATFORM_ADMIN", "PLATFORM_SUPPORT"] as const) {
      const denied = await call(method, path, await token(role), body);
      expect(denied.status, role).toBe(403);
      expect(denied.body.code, role).toBe("PERMISSION_DENIED");
    }
  });

  it("mass assignment: tenant lấy từ JWT; đề xuất không nhận status/catalogStopPointId từ body", async () => {
    await call("POST", "/stop-point-proposals", await token("OPERATOR_OWNER"), {
      ...proposalBody,
      operatorId: randomUUID(),
      status: "APPROVED",
      catalogStopPointId: randomUUID(),
    });
    const [authz, input] = services.proposals.create.mock.calls[0] as unknown as [
      { db: { operatorId: string } },
      Record<string, unknown>,
    ];
    expect(authz.db.operatorId).toBe(operatorId);
    for (const field of ["operatorId", "status", "catalogStopPointId", "rejectionReason"]) {
      expect(input).not.toHaveProperty(field);
    }
    expect(input).toMatchObject({ type: "BUS_STATION", legalBasis: "QĐ 1234/QĐ-SGTVT" });
  });

  it("GET /stop-points chuyển bộ lọc trạng thái / loại / tỉnh / từ khoá xuống service; response có lý do tạm ngưng và số tuyến", async () => {
    const owner = await token("OPERATOR_OWNER");
    services.stopPoints.list.mockResolvedValueOnce({
      items: [{ ...stopPoint, status: "SUSPENDED", suspensionReason: "Sai vị trí", routeCount: 2 }],
      nextCursor: null,
    } as never);
    const provinceId = randomUUID();
    const query = `status=SUSPENDED&type=REST_STOP&provinceId=${provinceId}&q=${encodeURIComponent("  tram dung ")}`;
    const response = await call("GET", `/stop-points?${query}`, owner);
    expect(response.status).toBe(200);
    expect((response.body.items as Record<string, unknown>[])[0]).toMatchObject({
      status: "SUSPENDED",
      suspensionReason: "Sai vị trí",
      routeCount: 2,
    });
    const [, listQuery] = services.stopPoints.list.mock.calls[0] as unknown as [unknown, Record<string, unknown>];
    expect(listQuery).toEqual({ status: "SUSPENDED", type: "REST_STOP", provinceId, q: "tram dung", limit: 20 });
  });

  it("response tuyến trả loại điểm và hai cờ cho đón / cho trả của từng điểm", async () => {
    const stop = {
      sequence: 1,
      role: "ORIGIN",
      catalogStopPointId: randomUUID(),
      stopPointId: null,
      name: "Bến xe Miền Đông",
      type: "BUS_STATION",
      address: "292 Đinh Bộ Lĩnh",
      latitude: 10.81,
      longitude: 106.71,
      note: null,
      allowPickup: true,
      allowDropoff: false,
      distanceMetersFromPrevious: null,
      durationSecondsFromPrevious: null,
    };
    services.routes.get.mockResolvedValueOnce({ ...route, stops: [stop] } as never);
    const response = await call("GET", `/routes/${id}`, await token("OPERATOR_OWNER"));
    expect(response.status).toBe(200);
    expect((response.body.stops as Record<string, unknown>[])[0]).toMatchObject({
      type: "BUS_STATION",
      allowPickup: true,
      allowDropoff: false,
    });
  });

  it.each([
    ["POST", "/routes", { ...routeBody, stops: routeBody.stops.slice(0, 1) }],
    ["POST", "/routes", { ...routeBody, stops: [routeBody.stops[0], routeBody.stops[0]] }],
    ["PUT", `/routes/${id}`, { name: "x", stops: routeBody.stops }],
    // BR-79: thiếu cờ cho đón / cho trả là 400, không ngầm hiểu.
    ["POST", "/routes", { ...routeBody, stops: routeBody.stops.map(({ allowPickup: _allowPickup, ...stop }) => stop) }],
    ["POST", "/stop-points", { ...location, status: "ACTIVE", latitude: 95 }],
    // Tạm ngưng là quyền của Admin Platform: nhà xe không tự đặt được.
    ["PUT", `/stop-points/${id}`, { ...location, status: "SUSPENDED" }],
    ["POST", "/stop-point-proposals", { ...proposalBody, wardId: "khong-phai-uuid" }],
    ["POST", "/stop-point-proposals", { ...proposalBody, type: "OFFICE" }],
    ["POST", "/stop-point-proposals", location],
    ["PUT", `/stop-point-proposals/${id}`, { ...proposalBody, legalBasis: "  " }],
    ["GET", "/routes?status=DRAFT", undefined],
    ["GET", "/stop-points?type=AIRPORT", undefined],
    ["GET", `/stop-points?q=${"x".repeat(101)}`, undefined],
    ["GET", "/stop-point-proposals?status=UNKNOWN", undefined],
  ])("%s %s dữ liệu sai → 400, service không bị gọi", async (method, path, body) => {
    const response = await call(method, path, await token("OPERATOR_OWNER"), body);
    expect(response.status).toBe(400);
    for (const service of Object.values(services)) {
      for (const method of Object.values(service)) {
        expect(method).not.toHaveBeenCalled();
      }
    }
  });
});
