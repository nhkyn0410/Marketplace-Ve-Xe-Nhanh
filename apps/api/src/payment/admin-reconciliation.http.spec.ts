import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { TokenService } from "../iam/auth/token.service";
import { SessionService } from "../iam/session/session.service";
import { configureApiRoutes } from "../openapi/openapi";
import { AdminReconciliationController } from "./admin-reconciliation.controller";
import { AdminReconciliationService } from "./admin-reconciliation.service";

describe("Chạy lại đối soát — HTTP, RBAC và xác nhận danh tính", () => {
  const service = { list: vi.fn(async () => ({ items: [] })), run: vi.fn(async () => ({})) };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;
  let recent = false;
  @Module({ controllers: [AdminReconciliationController], providers: [
    { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "test" } as AppConfig }, TokenService,
    { provide: AdminReconciliationService, useValue: service },
    { provide: SessionService, useValue: { assertActive: async () => undefined, assertOperatorAccountCurrent: async () => undefined, hasRecentReauth: async () => recent } },
  ] }) class TestModule {}
  beforeAll(async () => {
    app = await NestFactory.create(TestModule, { logger: false, abortOnError: false });
    app.useGlobalPipes(new ZodValidationPipe()); app.useGlobalFilters(new ProblemDetailsExceptionFilter()); configureApiRoutes(app);
    await app.listen(0, "127.0.0.1"); base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1/admin/system/reconciliation`;
    tokens = app.get(TokenService);
  }, 15000);
  afterAll(async () => { await app?.close(); });
  async function call(role: string | null) {
    const token = role ? (await tokens.mintAccessToken({ sub: randomUUID(), sid: randomUUID(), scope: "platform", role, mfa: true })).accessToken : null;
    return fetch(base, { method: "POST", headers: { "content-type": "application/json", ...(token ? { authorization: `Bearer ${token}` } : {}) }, body: JSON.stringify({ requestId: randomUUID(), reason: "Kiểm tra thủ công" }) });
  }
  it("chỉ PlatformAdmin đã xác nhận lại danh tính được xếp hàng", async () => {
    expect((await call(null)).status).toBe(401);
    expect((await call("PLATFORM_SUPPORT")).status).toBe(403);
    expect((await call("PLATFORM_ADMIN")).status).toBe(401);
    expect(service.run).not.toHaveBeenCalled();
    recent = true;
    expect((await call("PLATFORM_ADMIN")).status).toBe(202);
    expect(service.run).toHaveBeenCalledTimes(1);
  });
});
