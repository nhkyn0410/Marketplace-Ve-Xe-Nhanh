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
  AdminEmployeeController,
  AdminPassengerController,
  AdminPlatformAccountController,
} from "../iam/user/admin-user.controller";
import { AdminAccountService } from "../iam/user/admin-account.service";
import { AdminOperatorController } from "./admin-operator.controller";
import { AdminOperatorService } from "./admin-operator.service";

/**
 * Chuỗi guard thật của `/admin/operators`, `/admin/passengers`, `/admin/employees`, `/admin/platform-accounts`
 * (quản lý nhà xe + người dùng); nghiệp vụ test ở `.int.spec.ts`.
 */
describe("Admin nhà xe + người dùng — HTTP", () => {
  const id = randomUUID();
  const service = {
    list: vi.fn(async () => ({ items: [], nextCursor: null, total: 0 })),
    suspend: vi.fn(async () => undefined),
    unsuspend: vi.fn(async () => undefined),
    getBankChange: vi.fn(async () => ({
      changeId: id,
      operatorName: "Sao Việt",
      legalName: null,
      taxCode: null,
      current: null,
      requested: {
        bankName: "Techcombank",
        accountNumber: "190366880011",
        accountHolder: "CTY SAO VIET",
        reason: "Đổi tài khoản",
        requestedAt: new Date().toISOString(),
        requestedBy: null,
      },
    })),
    approveBankChange: vi.fn(async () => undefined),
    rejectBankChange: vi.fn(async () => undefined),
  };
  const account = { username: "platform/a", email: null, role: "PLATFORM_SUPPORT", status: "ACTIVE", mfaEnabled: false };
  const accounts = {
    listPassengers: vi.fn(async () => ({ items: [], nextCursor: null, total: 0 })),
    lockPassenger: vi.fn(async () => undefined),
    unlockPassenger: vi.fn(async () => undefined),
    listEmployees: vi.fn(async () => ({ items: [], nextCursor: null, total: 0, operators: [] })),
    listPlatformAccounts: vi.fn(async () => ({ items: [] })),
    createPlatformAccount: vi.fn(async () => ({
      ...account,
      id,
      passwordChangeRequired: true,
      credentialDeliveryPending: false,
      lockedReason: null,
      lockedAt: null,
      lastLoginAt: null,
      isSelf: false,
    })),
    resetPlatformPassword: vi.fn(async () => ({})),
    resetPlatformMfa: vi.fn(async () => ({})),
    lockPlatformAccount: vi.fn(async () => undefined),
    unlockPlatformAccount: vi.fn(async () => undefined),
  };
  const reauth = { granted: false };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;
  const config = { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig;

  @Module({
    controllers: [AdminOperatorController, AdminPassengerController, AdminEmployeeController, AdminPlatformAccountController],
    providers: [
      { provide: APP_CONFIG, useValue: config },
      TokenService,
      { provide: AdminOperatorService, useValue: service },
      { provide: AdminAccountService, useValue: accounts },
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
    [...Object.values(service), ...Object.values(accounts)].forEach((fn) => fn.mockClear());
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
    return { status: response.status, body: response.status === 204 ? {} : ((await response.json()) as Record<string, unknown>) };
  }

  const calls = () => [...Object.values(service), ...Object.values(accounts)].filter((fn) => fn.mock.calls.length > 0);
  const lock = { reason: "Vi phạm quy định" };
  const routes: [string, string, object | undefined, number, boolean][] = [
    ["GET", "/operators", undefined, 200, false],
    ["POST", `/operators/${id}/suspend`, lock, 204, true],
    ["POST", `/operators/${id}/unsuspend`, undefined, 204, true],
    ["GET", `/operators/${id}/bank-account-change`, undefined, 200, false],
    ["POST", `/operators/${id}/bank-account-change/approve`, { changeId: id }, 204, true],
    ["POST", `/operators/${id}/bank-account-change/reject`, { changeId: id, reason: "Sai chủ tài khoản" }, 204, true],
    ["GET", "/passengers", undefined, 200, false],
    ["POST", "/passengers/user-abc/lock", lock, 204, true],
    ["POST", "/passengers/user-abc/unlock", undefined, 204, true],
    ["GET", "/employees", undefined, 200, false],
    ["GET", "/platform-accounts", undefined, 200, false],
    ["POST", "/platform-accounts", { username: "ngoc.finance", email: "ngoc@vexenhanh.vn", role: "PLATFORM_SUPPORT" }, 201, true],
    ["POST", `/platform-accounts/${id}/reset-password`, undefined, 200, true],
    ["POST", `/platform-accounts/${id}/reset-mfa`, undefined, 200, true],
    ["POST", `/platform-accounts/${id}/lock`, lock, 204, true],
    ["POST", `/platform-accounts/${id}/unlock`, undefined, 204, true],
  ];

  it.each(routes)(
    "%s %s: không token → 401; chủ nhà xe / hỗ trợ nền tảng → 403; thao tác thay đổi cần xác nhận lại danh tính",
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

  it("validate: lý do ngắn, id sai dạng, tên đăng nhập / email / vai trò sai → 400; tên đăng nhập viết thường", async () => {
    reauth.granted = true;
    const admin = await token("platform", "PLATFORM_ADMIN");
    for (const [method, path, body] of [
      ["POST", `/operators/${id}/suspend`, { reason: "ab" }],
      ["POST", "/operators/not-uuid/suspend", lock],
      ["POST", `/operators/${id}/bank-account-change/approve`, {}],
      ["POST", `/operators/${id}/bank-account-change/reject`, { changeId: id, reason: "ab" }],
      ["POST", `/operators/${id}/bank-account-change/reject`, { changeId: "x", reason: "Sai chủ tài khoản" }],
      ["POST", "/platform-accounts", { username: "a", email: "ngoc@vexenhanh.vn", role: "PLATFORM_SUPPORT" }],
      ["POST", "/platform-accounts", { username: "ngoc", email: "khong-phai-email", role: "PLATFORM_SUPPORT" }],
      ["POST", "/platform-accounts", { username: "ngoc", email: "ngoc@vexenhanh.vn", role: "OPERATOR_OWNER" }],
      ["POST", "/platform-accounts/not-uuid/lock", lock],
    ] as const) {
      expect((await call(method, path, admin, body)).status, path).toBe(400);
    }
    expect(calls()).toHaveLength(0);
    expect((await call("POST", "/platform-accounts", admin, { username: " Ngoc.Finance ", email: "NGOC@vexenhanh.vn", role: "PLATFORM_ADMIN" })).status).toBe(201);
    expect(accounts.createPlatformAccount).toHaveBeenCalledWith(
      expect.anything(),
      expect.anything(),
      { username: "ngoc.finance", email: "ngoc@vexenhanh.vn", role: "PLATFORM_ADMIN" },
    );
  });
});
