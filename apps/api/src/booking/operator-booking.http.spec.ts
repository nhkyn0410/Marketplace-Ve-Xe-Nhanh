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
import { OperatorBookingController } from "./operator-booking.controller";
import { OperatorBookingService } from "./operator-booking.service";

/** Route thật + chuỗi guard `@Authorize("booking:read")` thật (OPR-003); nghiệp vụ kiểm ở test DB. */
describe("Đặt vé của nhà xe — HTTP", () => {
  const operatorId = randomUUID();
  const bookingId = randomUUID();
  const tripId = randomUUID();
  const service = {
    list: vi.fn(async () => ({ items: [], nextCursor: null })),
    get: vi.fn(),
    revealContact: vi.fn(async () => ({ fullName: "A", phone: "0901234567", email: "a@example.com", passengers: [] })),
    passengers: vi.fn(),
    exportPassengers: vi.fn(async () => ({ filename: "hanh-khach-2031-11-05-22h30.csv", csv: "﻿\"Chỗ\"\r\n" })),
  };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  @Module({
    controllers: [OperatorBookingController],
    providers: [
      { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      { provide: OperatorBookingService, useValue: service },
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
        scope: platform ? "platform" : role === "PASSENGER" ? "passenger" : "operator",
        role,
        ...(platform || role === "PASSENGER" ? {} : { operatorId, operatorSlug: "test-operator" }),
        ...(role === "OPERATOR_OWNER" || platform ? { mfa: true } : {}),
      })
    ).accessToken;
  }

  const call = (method: string, path: string, accessToken?: string) =>
    fetch(`${base}${path}`, { method, headers: accessToken ? { authorization: `Bearer ${accessToken}` } : {} });

  it.each([
    ["GET", "/bookings?date=2031-11-05"],
    ["POST", `/bookings/${bookingId}/contact-reveal`],
    ["GET", `/trips/${tripId}/passengers/export`],
  ])("%s %s: Owner được, không token 401, nhân viên / hành khách / Platform 403", async (method, path) => {
    expect((await call(method, path, await token("OPERATOR_OWNER"))).status).toBe(200);
    expect((await call(method, path)).status).toBe(401);
    for (const role of ["DRIVER", "TICKET_STAFF", "SUPPORT_STAFF", "PASSENGER", "PLATFORM_ADMIN"] as const) {
      expect((await call(method, path, await token(role))).status, role).toBe(403);
    }
  });

  it("danh sách: thiếu ngày / trạng thái lạ → 400; xuất CSV đúng header tải về, không cache", async () => {
    const owner = await token("OPERATOR_OWNER");
    expect((await call("GET", "/bookings", owner)).status).toBe(400);
    expect((await call("GET", "/bookings?date=2031-11-05&status=LA", owner)).status).toBe(400);
    expect((await call("GET", "/bookings/khong-phai", owner)).status).toBe(400);
    const response = await call("GET", `/trips/${tripId}/passengers/export`, owner);
    expect(response.headers.get("content-type")).toContain("text/csv");
    expect(response.headers.get("content-disposition")).toBe('attachment; filename="hanh-khach-2031-11-05-22h30.csv"');
    expect(response.headers.get("cache-control")).toBe("no-store");
    expect(await response.text()).toContain("Chỗ");
  });
});
