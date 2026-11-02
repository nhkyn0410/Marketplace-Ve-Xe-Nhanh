import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { type AccessTokenClaims, TokenService } from "../iam/auth/token.service";
import { SessionService } from "../iam/session/session.service";
import { configureApiRoutes } from "../openapi/openapi";
import { SystemStatusController } from "./system-status.controller";
import { SystemStatusService } from "./system-status.service";

/** Chuỗi guard thật của `/admin/system/*` (trang Tích hợp & hệ thống, chỉ đọc). */
describe("Tích hợp & hệ thống — HTTP", () => {
  const status = {
    integrations: vi.fn(async () => ({ checkedAt: new Date().toISOString(), environment: "test", items: [] })),
    backgroundJobs: vi.fn(async () => ({ checkedAt: new Date().toISOString(), available: true, jobs: [], queues: [] })),
  };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;
  const config = { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig;

  @Module({
    controllers: [SystemStatusController],
    providers: [
      { provide: APP_CONFIG, useValue: config },
      TokenService,
      { provide: SystemStatusService, useValue: status },
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
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1/admin/system`;
    tokens = app.get(TokenService);
  }, 15_000);

  afterAll(async () => {
    await app?.close();
  });

  async function token(scope: AccessTokenClaims["scope"], role: AccessTokenClaims["role"]): Promise<string> {
    return (
      await tokens.mintAccessToken({
        sub: randomUUID(),
        sid: randomUUID(),
        scope,
        role,
        ...(scope === "operator" ? { operatorId: randomUUID(), operatorSlug: "nhaxe" } : {}),
        mfa: true,
      })
    ).accessToken;
  }

  const call = async (path: string, accessToken: string | null) =>
    (await fetch(`${base}${path}`, { headers: accessToken ? { authorization: `Bearer ${accessToken}` } : {} })).status;

  it.each(["/integrations", "/jobs"])("GET %s: không token 401; chủ nhà xe / hỗ trợ nền tảng 403; quản trị viên 200", async (path) => {
    expect(await call(path, null)).toBe(401);
    expect(await call(path, await token("operator", "OPERATOR_OWNER"))).toBe(403);
    expect(await call(path, await token("platform", "PLATFORM_SUPPORT"))).toBe(403);
    expect(await call(path, await token("platform", "PLATFORM_ADMIN"))).toBe(200);
  });
});
