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
import { OperatorProfileController } from "./operator-profile.controller";
import { OperatorProfileService } from "./operator-profile.service";

/** Route thật + chuỗi guard `@Authorize` thật của `/operator/profile` (TASK-OPR-001b); nghiệp vụ ở `.int.spec.ts`. */
describe("Hồ sơ nhà xe — HTTP", () => {
  const operatorId = randomUUID();
  const now = new Date().toISOString();
  const profile = {
    id: operatorId,
    slug: "saoviet",
    displayName: "Sao Việt",
    legalName: null,
    taxCode: null,
    hotline: null,
    publicEmail: null,
    address: null,
    description: null,
    status: "ACTIVE",
    suspendedReason: null,
    approvedAt: null,
    documents: [],
    bankAccount: null,
    bankChange: null,
  };
  const objectKey = `operator-kyc/${operatorId}/${randomUUID()}.pdf`;
  const service = {
    get: vi.fn(async () => profile),
    update: vi.fn(async () => profile),
    createDocumentUpload: vi.fn(async () => ({ uploadUrl: "https://upload.test/put", objectKey, expiresAt: now })),
    replaceDocument: vi.fn(async () => profile),
    createDocumentDownload: vi.fn(async () => ({ url: "https://download.test/get", expiresAt: now })),
    requestBankChange: vi.fn(async () => profile),
  };
  const reauth = { granted: false };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;
  const config = { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig;

  @Module({
    controllers: [OperatorProfileController],
    providers: [
      { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
      { provide: APP_CONFIG, useValue: config },
      TokenService,
      { provide: OperatorProfileService, useValue: service },
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
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1/operator/profile`;
    tokens = app.get(TokenService);
  }, 15_000);

  afterAll(async () => {
    await app?.close();
  });

  beforeEach(() => {
    vi.clearAllMocks();
    reauth.granted = false;
  });

  async function token(role: AccessTokenClaims["role"]): Promise<string> {
    const platform = role === "PLATFORM_ADMIN" || role === "PLATFORM_SUPPORT";
    return (
      await tokens.mintAccessToken({
        sub: randomUUID(),
        sid: randomUUID(),
        scope: platform ? "platform" : "operator",
        role,
        ...(platform ? {} : { operatorId, operatorSlug: "saoviet" }),
        ...(role === "OPERATOR_OWNER" || platform ? { mfa: true } : {}),
      })
    ).accessToken;
  }

  async function call(method: string, path: string, accessToken?: string, body?: object) {
    const response = await fetch(`${base}${path}`, {
      method,
      headers: {
        ...(accessToken ? { authorization: `Bearer ${accessToken}` } : {}),
        "content-type": "application/json",
      },
      ...(body ? { body: JSON.stringify(body) } : {}),
    });
    return { status: response.status, body: (await response.json()) as Record<string, unknown> };
  }

  const update = { displayName: "Sao Việt", hotline: "1900 6868", publicEmail: "LH@saoviet.vn", address: "266 Đồng Đen", description: "" };
  const bank = { bankName: "Techcombank", accountNumber: "1903-6688-0011", accountHolder: "Công ty Sao Việt", reason: "Đổi tài khoản" };
  const routes: [string, string, object | undefined, number, boolean][] = [
    ["GET", "", undefined, 200, false],
    ["PUT", "", update, 200, false],
    ["POST", "/documents/upload-url", { contentType: "application/pdf", sizeBytes: 2048 }, 200, false],
    ["PUT", "/documents/TRANSPORT_LICENSE", { objectKey, fileName: "gpkd.pdf" }, 200, false],
    ["POST", "/documents/TRANSPORT_LICENSE/download-url", undefined, 200, false],
    ["POST", "/bank-account-change", bank, 201, true],
  ];

  it.each(routes)(
    "%s %s: chủ nhà xe được (đổi tài khoản cần xác nhận lại danh tính); không token 401; nhân viên / Admin 403",
    async (method, path, body, ok, needsReauth) => {
      const owner = await token("OPERATOR_OWNER");
      if (needsReauth) {
        expect(await call(method, path, owner, body)).toMatchObject({ status: 401, body: { code: "AUTH_REAUTH_REQUIRED" } });
        expect(service.requestBankChange).not.toHaveBeenCalled();
        reauth.granted = true;
      }
      expect((await call(method, path, owner, body)).status).toBe(ok);
      expect((await call(method, path, undefined, body)).status).toBe(401);
      for (const role of ["DRIVER", "TICKET_STAFF", "SUPPORT_STAFF", "PLATFORM_ADMIN"] as const) {
        const denied = await call(method, path, await token(role), body);
        expect(denied.status, role).toBe(403);
        expect(denied.body.code, role).toBe("PERMISSION_DENIED");
      }
    },
  );

  it("service nhận scope tenant từ JWT + dữ liệu đã chuẩn hoá (hotline / email / mô tả rỗng, số tài khoản, chủ tài khoản không dấu)", async () => {
    reauth.granted = true;
    const owner = await token("OPERATOR_OWNER");
    await call("PUT", "", owner, { ...update, status: "SUSPENDED", legalName: "Đổi tên" });
    expect(service.update).toHaveBeenCalledWith(
      expect.objectContaining({ db: expect.objectContaining({ kind: "tenant", operatorId }) }),
      expect.objectContaining({ sub: expect.any(String) }),
      { displayName: "Sao Việt", hotline: "19006868", publicEmail: "lh@saoviet.vn", address: "266 Đồng Đen", description: null },
    );
    await call("POST", "/bank-account-change", owner, bank);
    expect(service.requestBankChange).toHaveBeenCalledWith(expect.anything(), expect.anything(), {
      bankName: "Techcombank",
      accountNumber: "190366880011",
      accountHolder: "CONG TY SAO VIET",
      reason: "Đổi tài khoản",
    });
  });

  it("validate → 400: hotline / email sai, loại giấy tờ lạ, file không phải PDF / ảnh hoặc quá 10 MB, số tài khoản / lý do sai", async () => {
    reauth.granted = true;
    const owner = await token("OPERATOR_OWNER");
    for (const [method, path, body] of [
      ["PUT", "", { ...update, hotline: "123" }],
      ["PUT", "", { ...update, publicEmail: "khong-phai-email" }],
      ["PUT", "", { ...update, displayName: "  " }],
      ["PUT", "/documents/PASSPORT", { objectKey, fileName: "a.pdf" }],
      ["POST", "/documents/upload-url", { contentType: "text/html", sizeBytes: 10 }],
      ["POST", "/documents/upload-url", { contentType: "application/pdf", sizeBytes: 10 * 1024 * 1024 + 1 }],
      ["POST", "/documents/OTHER/download-url", undefined],
      ["POST", "/bank-account-change", { ...bank, accountNumber: "12AB" }],
      ["POST", "/bank-account-change", { ...bank, reason: "ab" }],
      ["POST", "/bank-account-change", { ...bank, accountHolder: "Ω" }],
    ] as const) {
      expect((await call(method, path, owner, body)).status, `${method} ${path}`).toBe(400);
    }
    expect(Object.values(service).filter((fn) => fn.mock.calls.length > 0)).toHaveLength(0);
  });
});
