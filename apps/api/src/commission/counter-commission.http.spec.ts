import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { TokenService } from "../iam/auth/token.service";
import { SessionService } from "../iam/session/session.service";
import { configureApiRoutes } from "../openapi/openapi";
import { CounterCommissionController } from "./counter-commission.controller";
import { CounterCommissionService } from "./counter-commission.service";

describe("Counter commission routes — HTTP", () => {
  const operatorId = randomUUID();
  const input = { operatorId, idempotencyKey: randomUUID(), amount: "12000", reference: " bank-01 ", reason: "Thu tháng 10" };
  const service = { overview: vi.fn(async () => ({})), settle: vi.fn(async () => ({})) };
  const recent = { value: false };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;
  @Module({ controllers: [CounterCommissionController], providers: [
    { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "counter-test" } as AppConfig },
    TokenService,
    { provide: CounterCommissionService, useValue: service },
    { provide: SessionService, useValue: { assertActive: async () => undefined, assertOperatorAccountCurrent: async () => undefined, hasRecentReauth: async () => recent.value } },
  ] })
  class HttpTestModule {}
  beforeAll(async () => {
    app = await NestFactory.create(HttpTestModule, { logger: false, abortOnError: false });
    app.useGlobalPipes(new ZodValidationPipe()); app.useGlobalFilters(new ProblemDetailsExceptionFilter()); configureApiRoutes(app);
    await app.listen(0, "127.0.0.1"); base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1/admin/counter-commissions`; tokens = app.get(TokenService);
  }, 15000);
  afterAll(async () => { await app?.close(); });
  beforeEach(() => { vi.clearAllMocks(); recent.value = false; });
  async function token(role: string) {
    return (await tokens.mintAccessToken({ sub: randomUUID(), sid: randomUUID(), role, scope: role.startsWith("PLATFORM_") ? "platform" : "operator", mfa: true, ...(role.startsWith("PLATFORM_") ? {} : { operatorId, operatorSlug: "counter-test" }) })).accessToken;
  }
  async function call(method: string, accessToken?: string, body?: object) {
    return fetch(method === "GET" ? `${base}?operatorId=${operatorId}` : `${base}/settlements`, { method, headers: { ...(accessToken ? { authorization: `Bearer ${accessToken}` } : {}), "content-type": "application/json" }, ...(body ? { body: JSON.stringify(body) } : {}) });
  }
  it("không đăng nhập401, nhà xe/nhân viên không xem được phí toàn hệ thống", async () => {
    expect((await call("GET")).status).toBe(401);
    for (const role of ["OPERATOR_OWNER", "SALES_STAFF", "DRIVER"]) expect((await call("GET", await token(role))).status).toBe(403);
    expect(service.overview).not.toHaveBeenCalled();
  });
  it("PlatformSupport được xem báo cáo nhưng không được ghi nhận khoản thu", async () => {
    const support = await token("PLATFORM_SUPPORT");
    expect((await call("GET", support)).status).toBe(200);
    expect((await call("POST", support, input)).status).toBe(403);
    expect(service.settle).not.toHaveBeenCalled();
  });
  it("Admin xác nhận lại danh tính trước khi thu, DTO giữ tiền chuỗi và chuẩn hóa tham chiếu", async () => {
    const admin = await token("PLATFORM_ADMIN");
    expect((await call("POST", admin, input)).status).toBe(401);
    recent.value = true;
    expect((await call("POST", admin, input)).status).toBe(200);
    expect(service.settle).toHaveBeenCalledWith(expect.objectContaining({ db: { kind: "platform" } }), expect.objectContaining({ role: "PLATFORM_ADMIN" }), expect.objectContaining({ amount: "12000", reference: "BANK-01" }));
  });
  it("từ chối tiền number hoặc khóa chống lặp không hợp lệ trước service", async () => {
    recent.value = true;
    const admin = await token("PLATFORM_ADMIN");
    expect((await call("POST", admin, { ...input, amount: 12000 })).status).toBe(400);
    expect((await call("POST", admin, { ...input, idempotencyKey: "bad" })).status).toBe(400);
    expect(service.settle).not.toHaveBeenCalled();
  });
});
