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
import { SeatHoldController } from "./seat-hold.controller";
import { SeatHoldService } from "./seat-hold.service";

/** Guard thật "khách vãng lai hoặc hành khách" trên `/seat-holds` (TASK-BTP-001); nghiệp vụ ở `.int.spec.ts`. */
describe("Giữ chỗ — HTTP", () => {
  const holdId = randomUUID();
  const hold = {
    holdId,
    tripId: randomUUID(),
    pickup: { sequence: 1, name: "Bến đi", plannedAt: new Date().toISOString() },
    dropoff: { sequence: 3, name: "Bến đến", plannedAt: new Date().toISOString() },
    seats: [{ code: "A1", type: "BED", price: 320000 }],
    subtotal: 320000,
    expiresAt: new Date().toISOString(),
  };
  const service = {
    create: vi.fn(async () => hold),
    get: vi.fn(async () => hold),
    release: vi.fn(async () => undefined),
  };
  const assertActive = vi.fn(async () => undefined);
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  @Module({
    controllers: [SeatHoldController],
    providers: [
      { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      GuestOrPassengerGuard,
      { provide: SeatHoldService, useValue: service },
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
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1/seat-holds`;
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

  async function call(method: string, path: string, accessToken: string | null, body?: object) {
    const response = await fetch(`${base}${path}`, {
      method,
      headers: { ...(accessToken ? { authorization: `Bearer ${accessToken}` } : {}), "content-type": "application/json" },
      ...(body ? { body: JSON.stringify(body) } : {}),
    });
    return { status: response.status, body: response.status === 204 ? {} : ((await response.json()) as Record<string, unknown>) };
  }

  const body = { tripId: randomUUID(), seatCodes: ["a1"], pickupSequence: 1, dropoffSequence: 3 };

  it("khách vãng lai giữ được (không token → user null); mã chỗ chuẩn hoá", async () => {
    expect((await call("POST", "", null, body)).status).toBe(201);
    const [user, , input] = service.create.mock.calls[0] as unknown as [unknown, unknown, { seatCodes: string[] }];
    expect(user).toBeNull();
    expect(input.seatCodes).toEqual(["A1"]);
    expect(assertActive).not.toHaveBeenCalled();
  });

  it("hành khách đăng nhập: người dùng từ token, phiên được kiểm; token rác → 401; chủ nhà xe / Admin → 403", async () => {
    expect((await call("POST", "", await token("PASSENGER"), body)).status).toBe(201);
    expect((service.create.mock.calls[0] as unknown as [{ sub: string }])[0].sub).toBe("user-PASSENGER");
    expect(assertActive).toHaveBeenCalledTimes(1);
    expect((await call("POST", "", "rac.rac.rac", body)).status).toBe(401);
    for (const role of ["OPERATOR_OWNER", "DRIVER", "PLATFORM_ADMIN"] as const) {
      expect(await call("POST", "", await token(role), body), role).toMatchObject({ status: 403, body: { code: "PERMISSION_DENIED" } });
    }
  });

  it("xem / bỏ giữ chỗ cho khách vãng lai; holdId không phải uuid → 400", async () => {
    expect((await call("GET", `/${holdId}`, null)).status).toBe(200);
    expect((await call("DELETE", `/${holdId}`, null)).status).toBe(204);
    expect((await call("GET", "/khong-phai", null)).status).toBe(400);
  });

  it.each([
    [{ ...body, seatCodes: [] }],
    [{ ...body, seatCodes: ["A1", "A1"] }],
    [{ ...body, seatCodes: Array.from({ length: 11 }, (_, index) => `A${index + 1}`) }],
    [{ ...body, tripId: "khong" }],
    [{ ...body, pickupSequence: 0 }],
  ])("body sai → 400, service không bị gọi", async (input) => {
    expect((await call("POST", "", null, input)).status).toBe(400);
    expect(service.create).not.toHaveBeenCalled();
  });
});
