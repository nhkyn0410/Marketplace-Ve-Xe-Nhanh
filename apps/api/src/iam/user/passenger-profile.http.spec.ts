import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { APP_INTERCEPTOR, NestFactory } from "@nestjs/core";
import { ZodSerializerInterceptor, ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { ProblemDetailsExceptionFilter } from "../../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../../config/env.config";
import { configureApiRoutes } from "../../openapi/openapi";
import { PublicOperatorProfileController } from "../../operator/public-operator-profile.controller";
import { PublicOperatorProfileService } from "../../operator/public-operator-profile.service";
import { type AccessTokenClaims, TokenService } from "../auth/token.service";
import { SessionService } from "../session/session.service";
import { PassengerProfileController } from "./passenger-profile.controller";
import { PassengerProfileService } from "./passenger-profile.service";

describe("Hồ sơ và danh sách riêng của hành khách — HTTP", () => {
  const userId = randomUUID();
  const passengerId = randomUUID();
  const operatorId = randomUUID();
  const profile = { userId, name: "Khách", email: "khach@example.com", emailVerified: true, phone: null, dateOfBirth: null, image: null };
  const saved = { passengerId, fullName: "Nguyễn Văn An", phone: null };
  const page = { items: [], nextCursor: null };
  const service = {
    get: vi.fn(async () => profile), update: vi.fn(async () => profile),
    saved: vi.fn(async () => ({ items: [saved] })), createSaved: vi.fn(async () => saved),
    updateSaved: vi.fn(async () => saved), deleteSaved: vi.fn(async () => undefined),
    bookings: vi.fn(async () => page), tickets: vi.fn(async () => page),
    supportTickets: vi.fn(async () => page), disputes: vi.fn(async () => page),
  };
  const publicProfiles = { get: vi.fn(async () => ({
    operatorId, operatorSlug: "nhaxe", displayName: "Nhà xe", logoUrl: null, description: null,
    hotline: null, publicEmail: null, address: null, serviceTerms: null,
    scorecard: { averageRating: null, reviewCount: 0, operatorCancellationRate: null, refundBookingRate: null, disputeBookingRate: null, checkInRate: null, noShowRate: null },
    routes: [], reviews: [], nextReviewCursor: null,
    taxCode: "private-tax-code", bankAccount: { accountNumber: "private-bank-number" },
  })) };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  @Module({
    controllers: [PassengerProfileController, PublicOperatorProfileController],
    providers: [
      { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      { provide: PassengerProfileService, useValue: service },
      { provide: PublicOperatorProfileService, useValue: publicProfiles },
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

  afterAll(async () => { await app?.close(); });
  beforeEach(() => { vi.clearAllMocks(); });

  async function token(role: AccessTokenClaims["role"]) {
    const scope = role === "PASSENGER" ? "passenger" : role.startsWith("PLATFORM") ? "platform" : "operator";
    return (await tokens.mintAccessToken({ sub: userId, sid: randomUUID(), role, scope,
      ...(scope === "operator" ? { operatorId, operatorSlug: "nhaxe" } : {}),
      ...(scope === "passenger" ? {} : { mfa: true }),
    })).accessToken;
  }

  async function call(method: string, path: string, accessToken: string | null, body?: object) {
    const response = await fetch(`${base}${path}`, { method,
      headers: { ...(accessToken ? { authorization: `Bearer ${accessToken}` } : {}), ...(body ? { "content-type": "application/json" } : {}) },
      ...(body ? { body: JSON.stringify(body) } : {}),
    });
    return { status: response.status, body: await response.json().catch(() => ({})) as Record<string, unknown> };
  }

  it("mọi route riêng chỉ nhận tài khoản hành khách; thiếu token 401, tài khoản nhà xe / nền tảng 403", async () => {
    const routes: [string, string, object | undefined, number][] = [
      ["GET", "/me/profile", undefined, 200], ["PUT", "/me/profile", { name: "Khách" }, 200],
      ["GET", "/me/saved-passengers", undefined, 200], ["POST", "/me/saved-passengers", { fullName: "Khách" }, 201],
      ["PUT", `/me/saved-passengers/${passengerId}`, { fullName: "Khách" }, 200],
      ["DELETE", `/me/saved-passengers/${passengerId}`, undefined, 204],
      ...["bookings", "tickets", "support-tickets", "disputes"].map((path): [string, string, undefined, number] => ["GET", `/me/${path}`, undefined, 200]),
    ];
    const passenger = await token("PASSENGER");
    const owner = await token("OPERATOR_OWNER");
    const admin = await token("PLATFORM_ADMIN");
    for (const [method, path, body, status] of routes) {
      expect((await call(method, path, passenger, body)).status, `${method} ${path}`).toBe(status);
      expect((await call(method, path, null, body)).status).toBe(401);
      for (const denied of [owner, admin]) expect((await call(method, path, denied, body)).status).toBe(403);
    }
  });

  it("chủ sở hữu lấy từ JWT; phân trang chuẩn hóa, không nhận userId hay email trong dữ liệu cập nhật", async () => {
    const passenger = await token("PASSENGER");
    const cursor = randomUUID();
    expect((await call("PUT", "/me/profile", passenger, { name: "  Khách mới  ", phone: "0901234567" })).status).toBe(200);
    expect(service.update).toHaveBeenCalledWith(expect.objectContaining({ sub: userId, scope: "passenger", role: "PASSENGER" }), { name: "Khách mới", phone: "0901234567" });
    expect((await call("POST", "/me/saved-passengers", passenger, { fullName: "  Nguyễn Văn An  " })).status).toBe(201);
    expect(service.createSaved).toHaveBeenCalledWith(expect.objectContaining({ sub: userId }), { fullName: "Nguyễn Văn An", phone: null });
    await call("GET", `/me/bookings?limit=7&cursor=${cursor}&userId=another-account`, passenger);
    expect(service.bookings).toHaveBeenCalledWith(expect.objectContaining({ sub: userId }), { limit: 7, cursor });
    for (const body of [{ name: "Khách", userId: "another-account" }, { email: "another@example.com" }]) {
      expect((await call("PUT", "/me/profile", passenger, body)).status).toBe(400);
    }
  });

  it("dữ liệu không hợp lệ bị chặn trước service: hồ sơ, UUID hành khách và phân trang danh sách", async () => {
    const passenger = await token("PASSENGER");
    for (const body of [{}, { name: " " }, { phone: "123" }, { dateOfBirth: "2026-02-30" }]) {
      expect((await call("PUT", "/me/profile", passenger, body)).status).toBe(400);
    }
    expect((await call("POST", "/me/saved-passengers", passenger, { fullName: "Khách", userId: "another-account" })).status).toBe(400);
    expect((await call("PUT", "/me/saved-passengers/not-a-uuid", passenger, { fullName: "Khách" })).status).toBe(400);
    expect((await call("DELETE", "/me/saved-passengers/not-a-uuid", passenger)).status).toBe(400);
    for (const path of ["bookings", "tickets", "support-tickets", "disputes"]) {
      for (const query of ["limit=0", "limit=101", "limit=1.5", "cursor=not-a-uuid"]) {
        expect((await call("GET", `/me/${path}?${query}`, passenger)).status).toBe(400);
      }
    }
    for (const method of Object.values(service)) expect(method).not.toHaveBeenCalled();
  });

  it("hồ sơ nhà xe cho khách vãng lai: validate UUID / phân trang và loại trường riêng khỏi response", async () => {
    const response = await call("GET", `/operators/${operatorId}/public-profile?limit=3`, null);
    expect(response.status).toBe(200);
    expect(response.body).toMatchObject({ operatorId, scorecard: { reviewCount: 0 } });
    expect(response.body).not.toHaveProperty("taxCode");
    expect(response.body).not.toHaveProperty("bankAccount");
    expect(publicProfiles.get).toHaveBeenCalledWith(operatorId, { limit: 3 });
    for (const path of ["/operators/not-a-uuid/public-profile", `/operators/${operatorId}/public-profile?limit=101`, `/operators/${operatorId}/public-profile?cursor=invalid`]) {
      expect((await call("GET", path, null)).status).toBe(400);
    }
    expect(publicProfiles.get).toHaveBeenCalledTimes(1);
  });
});
