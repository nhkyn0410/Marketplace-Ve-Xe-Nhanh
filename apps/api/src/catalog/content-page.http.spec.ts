import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { APP_INTERCEPTOR, NestFactory } from "@nestjs/core";
import { ZodSerializerInterceptor, ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { type AccessTokenClaims, TokenService } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { SessionService } from "../iam/session/session.service";
import { configureApiRoutes } from "../openapi/openapi";
import { AdminContentPageController, ContentPageController } from "./content-page.controller";
import { ContentPageService } from "./content-page.service";

/** Chuỗi guard thật của `/admin/content-pages` + API công khai `/content-pages` (TASK-ADM-003); nghiệp vụ ở `.int.spec.ts`. */
describe("Nội dung công khai — HTTP", () => {
  const id = randomUUID();
  const now = new Date().toISOString();
  const detail = {
    id,
    type: "FAQ",
    placement: "BOOKING",
    title: "Có cần tài khoản?",
    slug: null,
    status: "DRAFT",
    displayOrder: 1,
    imageUrl: null,
    updatedAt: now,
    bodyMarkdown: "Không.",
    imageKey: null,
    linkUrl: null,
    publishedAt: null,
    createdAt: now,
    updatedByName: null,
  };
  const service = {
    list: vi.fn(async () => ({ items: [], nextCursor: null, total: 0 })),
    get: vi.fn(async () => detail),
    create: vi.fn(async () => detail),
    update: vi.fn(async () => detail),
    setStatus: vi.fn(async () => detail),
    createImageUploadUrl: vi.fn(async () => ({ uploadUrl: "http://x", objectKey: "content-pages/x.png", publicUrl: "http://x", expiresAt: now })),
    listPublished: vi.fn(async () => ({ items: [] })),
    getPublishedPage: vi.fn(async () => ({ ...detail, type: "PAGE", placement: "FOOTER", slug: "dieu-khoan" })),
  };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;
  const config = { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig;

  @Module({
    controllers: [AdminContentPageController, ContentPageController],
    providers: [
      { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
      { provide: APP_CONFIG, useValue: config },
      TokenService,
      { provide: ContentPageService, useValue: service },
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
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1`;
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

  const faq = {
    type: "FAQ",
    placement: "BOOKING",
    title: "  Có cần tài khoản?  ",
    slug: null,
    bodyMarkdown: "Không.",
    imageKey: null,
    linkUrl: null,
    displayOrder: 1,
  };

  it.each([
    ["GET", "/admin/content-pages", undefined, 200],
    ["GET", `/admin/content-pages/${id}`, undefined, 200],
    ["POST", "/admin/content-pages", faq, 201],
    ["PUT", `/admin/content-pages/${id}`, faq, 200],
    ["PUT", `/admin/content-pages/${id}/status`, { status: "PUBLISHED" }, 200],
    ["POST", "/admin/content-pages/image-upload-url", { contentType: "image/png", sizeBytes: 1000 }, 200],
  ] as [string, string, object | undefined, number][])(
    "%s %s: không token → 401; chủ nhà xe / hỗ trợ nền tảng → 403; quản trị viên → thành công",
    async (method, path, body, ok) => {
      expect((await call(method, path, null, body)).status).toBe(401);
      for (const [scope, role] of [["operator", "OPERATOR_OWNER"], ["platform", "PLATFORM_SUPPORT"]] as const) {
        expect(await call(method, path, await token(scope, role), body)).toMatchObject({ status: 403, body: { code: "PERMISSION_DENIED" } });
      }
      expect(Object.values(service).some((fn) => fn.mock.calls.length > 0)).toBe(false);
      expect((await call(method, path, await token("platform", "PLATFORM_ADMIN"), body)).status).toBe(ok);
    },
  );

  it("người thực hiện + ngữ cảnh platform; tiêu đề cắt khoảng trắng", async () => {
    await call("POST", "/admin/content-pages", await token("platform", "PLATFORM_ADMIN"), faq);
    const [authz, actor, input] = service.create.mock.calls[0] as unknown as [Authorization, { role: string }, Record<string, unknown>];
    expect(authz).toMatchObject({ db: { kind: "platform" } });
    expect(actor.role).toBe("PLATFORM_ADMIN");
    expect(input.title).toBe("Có cần tài khoản?");
  });

  it("API công khai không cần đăng nhập; thiếu / sai loại → 400", async () => {
    expect((await call("GET", "/content-pages?type=FAQ&placement=BOOKING", null)).status).toBe(200);
    expect(service.listPublished).toHaveBeenCalledWith("FAQ", "BOOKING");
    expect((await call("GET", "/content-pages/dieu-khoan", null)).status).toBe(200);
    expect((await call("GET", "/content-pages", null)).status).toBe(400);
    expect((await call("GET", "/content-pages?type=NEWS", null)).status).toBe(400);
  });

  it.each([
    ["POST", "/admin/content-pages", { ...faq, placement: "HOME" }],
    ["POST", "/admin/content-pages", { ...faq, type: "PAGE", placement: "FOOTER" }],
    ["POST", "/admin/content-pages", { ...faq, linkUrl: "https://x.vn" }],
    ["PUT", `/admin/content-pages/${id}/status`, { status: "ARCHIVED" }],
    ["POST", "/admin/content-pages/image-upload-url", { contentType: "image/svg+xml", sizeBytes: 10 }],
    ["GET", "/admin/content-pages?type=NEWS", undefined],
  ])("%s %s dữ liệu sai → 400, service không bị gọi", async (method, path, body) => {
    expect((await call(method, path, await token("platform", "PLATFORM_ADMIN"), body)).status).toBe(400);
    expect(Object.values(service).some((fn) => fn.mock.calls.length > 0)).toBe(false);
  });
});
