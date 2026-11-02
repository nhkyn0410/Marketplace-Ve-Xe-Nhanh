import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { APP_INTERCEPTOR, NestFactory } from "@nestjs/core";
import { ZodSerializerInterceptor, ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { TokenService } from "../iam/auth/token.service";
import { SessionService } from "../iam/session/session.service";
import { configureApiRoutes } from "../openapi/openapi";
import { OperatorDepartureController } from "./operator-departure.controller";
import { OperatorDepartureService } from "./operator-departure.service";

describe("Xác nhận khởi hành của điều phối — HTTP và guard thật", () => {
  const operatorId = randomUUID();
  const tripId = randomUUID();
  const departedAt = new Date().toISOString();
  const depart = vi.fn(async () => ({ tripId, departedAt }));
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  @Module({
    controllers: [OperatorDepartureController],
    providers: [
      { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      { provide: OperatorDepartureService, useValue: { depart } },
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
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1/operator/trips`;
    tokens = app.get(TokenService);
  }, 15_000);

  afterAll(async () => { await app?.close(); });

  async function token(role: string, perms?: string[]) {
    return (await tokens.mintAccessToken({ sub: randomUUID(), sid: randomUUID(), scope: "operator", role, operatorId, operatorSlug: "test-operator", ...(role === "OPERATOR_OWNER" || role === "OPERATOR_MANAGER" ? { mfa: true } : {}), ...(perms ? { perms } : {}) })).accessToken;
  }

  async function post(accessToken?: string, body: object = {}, id: string = tripId) {
    const response = await fetch(`${base}/${id}/departure`, { method: "POST", headers: { "content-type": "application/json", ...(accessToken ? { authorization: `Bearer ${accessToken}` } : {}) }, body: JSON.stringify(body) });
    return { status: response.status, body: await response.json() as Record<string, unknown> };
  }

  it("owner và quản lý có quyền riêng được xác nhận; tenant/actor lấy từ token", async () => {
    depart.mockClear();
    expect((await post(await token("OPERATOR_OWNER"), { note: " Xe rời bến ", operatorId: randomUUID(), departedAt: "2000-01-01T00:00:00Z" })).body).toEqual({ tripId, departedAt });
    expect(depart).toHaveBeenCalledWith(expect.objectContaining({ role: "OPERATOR_OWNER" }), expect.objectContaining({ permission: "trip:dispatch", db: { kind: "tenant", operatorId } }), tripId, { note: "Xe rời bến" });
    expect((await post(await token("OPERATOR_MANAGER", ["trip:dispatch"]))).status).toBe(200);
  });

  it("nhân viên bán vé, tài xế và quản lý thiếu quyền không xác nhận qua cổng điều phối", async () => {
    depart.mockClear();
    expect((await post()).status).toBe(401);
    for (const role of ["SALES_STAFF", "DRIVER", "TICKET_STAFF"] as const) expect((await post(await token(role))).status, role).toBe(403);
    expect((await post(await token("OPERATOR_MANAGER", []))).status).toBe(403);
    expect(depart).not.toHaveBeenCalled();
  });

  it("UUID hoặc ghi chú sai bị từ chối trước nghiệp vụ", async () => {
    depart.mockClear();
    const owner = await token("OPERATOR_OWNER");
    expect((await post(owner, {}, "not-a-uuid")).status).toBe(400);
    expect((await post(owner, { note: "x".repeat(501) })).status).toBe(400);
    expect(depart).not.toHaveBeenCalled();
  });
});
