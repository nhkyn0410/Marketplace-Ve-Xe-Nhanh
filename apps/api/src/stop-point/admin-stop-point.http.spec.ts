import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { type AccessTokenClaims, TokenService } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { SessionService } from "../iam/session/session.service";
import { configureApiRoutes } from "../openapi/openapi";
import {
  AdminOperatorStopPointController,
  AdminSharedStopPointController,
  AdminStopPointProposalController,
} from "./admin-stop-point.controller";
import { AdminStopPointService } from "./admin-stop-point.service";

/** Chuỗi guard thật của các route Admin điểm dừng (TASK-ADM-004); nghiệp vụ test ở `.int.spec.ts`. */
describe("Admin điểm dừng — HTTP", () => {
  const id = randomUUID();
  const service = {
    listShared: vi.fn(async () => ({ items: [], nextCursor: null, total: 0 })),
    getShared: vi.fn(async () => ({})),
    createShared: vi.fn(async () => ({})),
    updateShared: vi.fn(async () => ({})),
    listProposals: vi.fn(async () => ({ items: [], nextCursor: null, total: 0 })),
    getProposal: vi.fn(async () => ({})),
    approveProposal: vi.fn(async () => ({})),
    rejectProposal: vi.fn(async () => ({})),
    listOperatorPoints: vi.fn(async () => ({ items: [], nextCursor: null, total: 0 })),
    suspend: vi.fn(async () => ({})),
    unsuspend: vi.fn(async () => ({})),
  };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;
  const config = { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig;

  @Module({
    controllers: [AdminSharedStopPointController, AdminStopPointProposalController, AdminOperatorStopPointController],
    providers: [
      { provide: APP_CONFIG, useValue: config },
      TokenService,
      { provide: AdminStopPointService, useValue: service },
      {
        provide: SessionService,
        useValue: {
          assertActive: async () => undefined,
          assertOperatorAccountCurrent: async () => undefined,
          hasRecentReauth: async () => false,
        },
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
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1/admin`;
    tokens = app.get(TokenService);
  }, 15_000);

  afterAll(async () => {
    await app?.close();
  });

  beforeEach(() => {
    Object.values(service).forEach((fn) => fn.mockClear());
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

  async function call(method: string, path: string, accessToken: string | null, body?: object) {
    const response = await fetch(`${base}${path}`, {
      method,
      headers: {
        ...(accessToken ? { authorization: `Bearer ${accessToken}` } : {}),
        ...(body ? { "content-type": "application/json" } : {}),
      },
      body: body ? JSON.stringify(body) : undefined,
    });
    return { status: response.status, body: (await response.json()) as Record<string, unknown> };
  }

  const shared = {
    name: "Bến xe Miền Đông",
    type: "BUS_STATION",
    address: "501 Hoàng Hữu Nam",
    provinceId: randomUUID(),
    wardId: randomUUID(),
    latitude: 10.87,
    longitude: 106.81,
    description: null,
    legalBasis: "QĐ 2816/QĐ-SGTVT",
    status: "ACTIVE",
  };
  const { status: _status, ...approval } = { ...shared, type: "PICKUP_POINT" };

  const routes: [string, string, object | undefined][] = [
    ["GET", "/stop-points", undefined],
    ["GET", `/stop-points/${id}`, undefined],
    ["POST", "/stop-points", shared],
    ["PUT", `/stop-points/${id}`, shared],
    ["GET", "/stop-point-proposals", undefined],
    ["GET", `/stop-point-proposals/${id}`, undefined],
    ["POST", `/stop-point-proposals/${id}/approve`, approval],
    ["POST", `/stop-point-proposals/${id}/reject`, { reason: "Thiếu căn cứ" }],
    ["GET", "/operator-stop-points", undefined],
    ["POST", `/operator-stop-points/${id}/suspend`, { reason: "Sai tọa độ" }],
    ["POST", `/operator-stop-points/${id}/unsuspend`, undefined],
  ];

  it.each(routes)("%s %s: không token → 401; chủ nhà xe / hỗ trợ nền tảng → 403; quản trị viên → 2xx, scope platform", async (method, path, body) => {
    expect((await call(method, path, null, body)).status).toBe(401);
    expect(await call(method, path, await token("operator", "OPERATOR_OWNER"), body)).toMatchObject({
      status: 403,
      body: { code: "PERMISSION_DENIED" },
    });
    expect(await call(method, path, await token("platform", "PLATFORM_SUPPORT"), body)).toMatchObject({
      status: 403,
      body: { code: "PERMISSION_DENIED" },
    });
    expect(Object.values(service).some((fn) => fn.mock.calls.length > 0)).toBe(false);

    const ok = await call(method, path, await token("platform", "PLATFORM_ADMIN"), body);
    expect(ok.status).toBe(method === "POST" && path === "/stop-points" ? 201 : 200);
    const called = Object.values(service).find((fn) => fn.mock.calls.length > 0)!;
    expect((called.mock.calls[0] as unknown[])[0] as Authorization).toMatchObject({ db: { kind: "platform" } });
  });

  it("validate: bến xe thiếu căn cứ, loại văn phòng, lý do rỗng, id lạ, cursor lạ → 400", async () => {
    const admin = await token("platform", "PLATFORM_ADMIN");
    expect((await call("POST", "/stop-points", admin, { ...shared, legalBasis: null })).status).toBe(400);
    expect((await call("POST", "/stop-points", admin, { ...shared, type: "OFFICE" })).status).toBe(400);
    expect((await call("POST", `/stop-point-proposals/${id}/reject`, admin, { reason: "  " })).status).toBe(400);
    expect((await call("POST", `/operator-stop-points/${id}/suspend`, admin, {})).status).toBe(400);
    expect((await call("POST", `/stop-point-proposals/${id}/approve`, admin, { ...approval, type: "REST_STOP" })).status).toBe(400);
    expect((await call("GET", "/stop-points/khong-phai-uuid", admin)).status).toBe(400);
    expect((await call("GET", "/operator-stop-points?cursor=abc", admin)).status).toBe(400);
    expect(Object.values(service).some((fn) => fn.mock.calls.length > 0)).toBe(false);
    // Trạm dừng nghỉ không cần căn cứ.
    expect((await call("POST", "/stop-points", admin, { ...shared, type: "REST_STOP", legalBasis: null })).status).toBe(201);
  });
});
