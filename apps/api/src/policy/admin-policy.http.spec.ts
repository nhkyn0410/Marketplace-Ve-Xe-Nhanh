import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { AdminCommissionController } from "../commission/admin-commission.controller";
import { AdminCommissionService } from "../commission/admin-commission.service";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { type AccessTokenClaims, TokenService } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { SessionService } from "../iam/session/session.service";
import { configureApiRoutes } from "../openapi/openapi";
import { AdminPolicyController } from "./admin-policy.controller";
import { AdminPolicyService } from "./admin-policy.service";

/** Chuỗi guard thật của `/admin/policies*`, `/admin/policy-versions/*`, `/admin/fare-bands*`, `/admin/commission-rules*`. */
describe("Chính sách + hoa hồng — HTTP", () => {
  const id = randomUUID();
  const policies = {
    overview: vi.fn(async () => ({})),
    createDraft: vi.fn(async () => ({})),
    get: vi.fn(async () => ({})),
    updateDraft: vi.fn(async () => ({})),
    publish: vi.fn(async () => ({})),
    cancel: vi.fn(async () => ({})),
    listFareBands: vi.fn(async () => ({ items: [] })),
    createFareBand: vi.fn(async () => ({})),
    cancelFareBand: vi.fn(async () => ({})),
  };
  const commission = {
    overview: vi.fn(async () => ({ default: null, overrides: [] })),
    create: vi.fn(async () => ({})),
    update: vi.fn(async () => ({})),
    cancel: vi.fn(async () => ({})),
  };
  const reauth = { granted: false };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;
  const config = { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig;

  @Module({
    controllers: [AdminPolicyController, AdminCommissionController],
    providers: [
      { provide: APP_CONFIG, useValue: config },
      TokenService,
      { provide: AdminPolicyService, useValue: policies },
      { provide: AdminCommissionService, useValue: commission },
      {
        provide: SessionService,
        useValue: {
          assertActive: async () => undefined,
          assertOperatorAccountCurrent: async () => undefined,
          hasRecentReauth: async () => reauth.granted,
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
    [...Object.values(policies), ...Object.values(commission)].forEach((fn) => fn.mockClear());
    reauth.granted = false;
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

  const calls = () => [...Object.values(policies), ...Object.values(commission)].filter((fn) => fn.mock.calls.length > 0);
  const future = (days: number) => new Date(Date.now() + days * 86_400_000).toISOString();
  const tiers = { tiers: [{ minHoursBefore: 24, refundPercent: 90 }, { minHoursBefore: 0, refundPercent: 0 }] };
  const draft = { operatorId: null, rules: tiers, description: null, effectiveFrom: future(10) };
  const band = {
    name: "Tết 2027",
    minPrice: null,
    maxPrice: 900_000,
    effectiveFrom: future(100),
    effectiveTo: future(110),
    message: "Giá vượt trần dịp Tết.",
    reason: "Theo văn bản",
  };
  const rule = { rateBps: 450, effectiveFrom: future(10), effectiveTo: null, reason: "Thỏa thuận quý 4" };
  const reason = { reason: "Đổi kế hoạch" };
  const routes: [string, string, object | undefined, number, boolean][] = [
    ["GET", "/policies/CANCELLATION", undefined, 200, false],
    ["POST", "/policies/CANCELLATION/versions", draft, 201, false],
    ["GET", `/policy-versions/${id}`, undefined, 200, false],
    ["PUT", `/policy-versions/${id}`, { rules: tiers, description: "x", effectiveFrom: null }, 200, false],
    ["POST", `/policy-versions/${id}/publish`, { changeReason: "Áp dụng dịp lễ" }, 200, true],
    ["POST", `/policy-versions/${id}/cancel`, reason, 200, true],
    ["GET", "/fare-bands", undefined, 200, false],
    ["POST", "/fare-bands", band, 201, true],
    ["POST", `/fare-bands/${id}/cancel`, reason, 200, true],
    ["GET", "/commission-rules", undefined, 200, false],
    ["POST", "/commission-rules", { ...rule, operatorId: id }, 201, true],
    ["PUT", `/commission-rules/${id}`, rule, 200, true],
    ["POST", `/commission-rules/${id}/cancel`, reason, 200, true],
  ];

  it.each(routes)(
    "%s %s: không token → 401; chủ nhà xe / hỗ trợ nền tảng → 403; thay đổi nhạy cảm cần xác nhận lại danh tính",
    async (method, path, body, ok, needsReauth) => {
      expect((await call(method, path, null, body)).status).toBe(401);
      for (const [scope, role] of [
        ["operator", "OPERATOR_OWNER"],
        ["platform", "PLATFORM_SUPPORT"],
      ] as const) {
        expect(await call(method, path, await token(scope, role), body)).toMatchObject({ status: 403, body: { code: "PERMISSION_DENIED" } });
      }
      const admin = await token("platform", "PLATFORM_ADMIN");
      if (needsReauth) {
        expect(await call(method, path, admin, body)).toMatchObject({ status: 401, body: { code: "AUTH_REAUTH_REQUIRED" } });
        expect(calls()).toHaveLength(0);
        reauth.granted = true;
      }
      expect((await call(method, path, admin, body)).status).toBe(ok);
      const [called] = calls();
      expect((called!.mock.calls[0] as unknown[])[0] as Authorization).toMatchObject({ db: { kind: "platform" } });
    },
  );

  it("validate → 400: loại chính sách lạ, mốc hoàn > 100%, thiếu lý do, khung giá sàn > trần / không có giá, tỷ lệ > 100%, kết thúc trước bắt đầu", async () => {
    reauth.granted = true;
    const admin = await token("platform", "PLATFORM_ADMIN");
    for (const [method, path, body] of [
      ["GET", "/policies/VOUCHER", undefined],
      ["POST", "/policies/CANCELLATION/versions", { ...draft, rules: { tiers: [{ minHoursBefore: 0, refundPercent: 120 }] } }],
      ["POST", "/policies/CANCELLATION/versions", { ...draft, effectiveFrom: "01/11/2026" }],
      ["POST", `/policy-versions/${id}/publish`, { changeReason: "ab" }],
      ["POST", "/fare-bands", { ...band, minPrice: 1_000_000 }],
      ["POST", "/fare-bands", { ...band, maxPrice: null }],
      ["POST", "/fare-bands", { ...band, effectiveTo: band.effectiveFrom }],
      ["POST", "/commission-rules", { ...rule, operatorId: id, rateBps: 10_001 }],
      ["POST", "/commission-rules", { ...rule, operatorId: id, rateBps: 4.5 }],
      ["PUT", `/commission-rules/${id}`, { ...rule, effectiveTo: future(5) }],
      ["POST", `/commission-rules/not-uuid/cancel`, reason],
    ] as const) {
      expect((await call(method, path, admin, body)).status, `${method} ${path}`).toBe(400);
    }
    expect(calls()).toHaveLength(0);
    await call("POST", "/policies/CANCELLATION/versions", admin, draft);
    // Body hợp lệ đi tới service (mốc hoàn tiền được kiểm + sắp ở service theo đúng loại).
    expect(policies.createDraft).toHaveBeenCalledWith(expect.anything(), expect.anything(), "CANCELLATION", expect.objectContaining({ operatorId: null }));
  });
});
