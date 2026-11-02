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
import { EmployeeOperationsController } from "./employee-operations.controller";
import { EmployeeOperationsService } from "./employee-operations.service";

/** Chuỗi guard thật của `/employee/*` (TASK-EMP-002): mọi role Employee soát vé; chỉ tài xế đổi trạng thái chuyến. */
describe("Thao tác của nhân viên — HTTP", () => {
  const tripId = randomUUID();
  const operatorId = randomUUID();
  const service = {
    assignments: vi.fn(async () => ({ items: [] })),
    manifest: vi.fn(),
    verify: vi.fn(),
    checkIn: vi.fn(),
    operate: vi.fn(async () => ({
      tripId,
      role: "DRIVER",
      routeName: "SG – ĐL",
      departureAt: new Date().toISOString(),
      arrivalAt: new Date().toISOString(),
      status: "BOARDING",
      vehiclePlateNumber: null,
      origin: "A",
      destination: "B",
      ticketCount: 0,
      checkedInCount: 0,
    })),
  };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  @Module({
    controllers: [EmployeeOperationsController],
    providers: [
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      { provide: EmployeeOperationsService, useValue: service },
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
      await tokens.mintAccessToken({
        sub: randomUUID(),
        sid: randomUUID(),
        scope: platform ? "platform" : "operator",
        role,
        ...(platform ? {} : { operatorId, operatorSlug: "nhaxe" }),
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

  it("soát vé: tài xế / nhân viên vé / hỗ trợ được (phạm vi phân công); chủ nhà xe + Admin 403; không token 401; body sai 400", async () => {
    for (const role of ["DRIVER", "TICKET_STAFF", "SUPPORT_STAFF"] as const) {
      expect((await call("GET", "/employee/assignments", await token(role))).status).toBe(200);
    }
    expect((await call("GET", "/employee/assignments", await token("OPERATOR_OWNER"))).status).toBe(403);
    expect((await call("GET", "/employee/assignments", await token("PLATFORM_ADMIN"))).status).toBe(403);
    expect((await call("GET", "/employee/assignments", null)).status).toBe(401);
    const staff = await token("TICKET_STAFF");
    expect((await call("GET", "/employee/assignments?from=2031-02-01&to=2031-01-01", staff)).status).toBe(400);
    expect((await call("POST", "/employee/tickets/verify", staff, { tripId, code: "abc" })).status).toBe(400);
    expect((await call("POST", "/employee/check-ins", staff, { tripId, code: "VXNABC123-01", status: "USED" })).status).toBe(400);
    expect((await call("GET", "/employee/trips/khong-phai-uuid/passengers", staff)).status).toBe(400);
    expect(service.verify).not.toHaveBeenCalled();
    expect(service.checkIn).not.toHaveBeenCalled();
    // Tenant + người thao tác lấy từ token, không từ body.
    await call("POST", "/employee/check-ins", staff, { tripId, code: " VXNABC123-01 ", status: "CHECKED_IN", operatorId: randomUUID() });
    const [authz, actor, input] = service.checkIn.mock.calls[0] as unknown as [{ scope: string; db: { operatorId: string } }, { role: string }, Record<string, unknown>];
    expect([authz.scope, authz.db.operatorId, actor.role]).toEqual(["assigned", operatorId, "TICKET_STAFF"]);
    expect(input).toEqual({ tripId, code: "VXNABC123-01", status: "CHECKED_IN" });
  });

  it("trạng thái chuyến: chỉ tài xế (trip:operate); nhân viên vé / hỗ trợ / chủ nhà xe 403; trạng thái ngoài luồng vận hành 400", async () => {
    expect((await call("POST", `/employee/trips/${tripId}/status`, await token("DRIVER"), { status: "BOARDING", note: "" })).status).toBe(200);
    expect((service.operate.mock.calls[0] as unknown as unknown[])[3]).toEqual({ status: "BOARDING", note: null });
    for (const role of ["TICKET_STAFF", "SUPPORT_STAFF", "OPERATOR_OWNER"] as const) {
      expect((await call("POST", `/employee/trips/${tripId}/status`, await token(role), { status: "BOARDING", note: null })).status).toBe(403);
    }
    expect((await call("POST", `/employee/trips/${tripId}/status`, await token("DRIVER"), { status: "CANCELLED", note: null })).status).toBe(400);
    expect(service.operate).toHaveBeenCalledTimes(1);
  });
});
