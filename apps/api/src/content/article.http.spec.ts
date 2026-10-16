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
import { AdminArticleCategoryController, AdminArticleController } from "./admin-article.controller";
import { AdminArticleService } from "./admin-article.service";
import { ArticleController } from "./article.controller";
import { ArticleService } from "./article.service";

/** Chuỗi guard thật của `/admin/articles*`, `/admin/article-categories` và route công khai (TASK-CNT-001). */
describe("Bài viết — HTTP", () => {
  const id = randomUUID();
  const service = {
    list: vi.fn(async () => ({ items: [], nextCursor: null, total: 0 })),
    get: vi.fn(async () => ({})),
    create: vi.fn(async () => ({})),
    update: vi.fn(async () => ({})),
    publish: vi.fn(async () => ({})),
    archive: vi.fn(async () => ({})),
    createImageUploadUrl: vi.fn(async () => ({})),
    listCategories: vi.fn(async () => ({ items: [] })),
    createCategory: vi.fn(async () => ({})),
    updateCategory: vi.fn(async () => ({})),
  };
  const site = {
    listCategories: vi.fn(async () => ({ items: [] })),
    list: vi.fn(async () => ({ items: [], nextCursor: null })),
    get: vi.fn(async () => ({})),
    recordView: vi.fn(async () => undefined),
  };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;
  const config = { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig;

  @Module({
    controllers: [AdminArticleController, AdminArticleCategoryController, ArticleController],
    providers: [
      { provide: APP_CONFIG, useValue: config },
      TokenService,
      { provide: AdminArticleService, useValue: service },
      { provide: ArticleService, useValue: site },
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
    [...Object.values(service), ...Object.values(site)].forEach((fn) => fn.mockClear());
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

  const body = {
    title: "Bài",
    slug: "bai-moi",
    summary: "Tóm tắt",
    contentMarkdown: "Nội dung",
    categoryId: id,
    coverImageKey: null,
    featured: false,
  };
  const category = { name: "Tin tức", slug: "tin-tuc-2", displayOrder: 1, status: "ACTIVE" };
  const routes: [string, string, object | undefined, number][] = [
    ["GET", "/admin/articles", undefined, 200],
    ["GET", `/admin/articles/${id}`, undefined, 200],
    ["POST", "/admin/articles", body, 201],
    ["PUT", `/admin/articles/${id}`, body, 200],
    ["POST", `/admin/articles/${id}/publish`, {}, 200],
    ["POST", `/admin/articles/${id}/archive`, undefined, 200],
    ["POST", "/admin/articles/images", { contentType: "image/png", sizeBytes: 100 }, 200],
    ["GET", "/admin/article-categories", undefined, 200],
    ["POST", "/admin/article-categories", category, 201],
    ["PUT", `/admin/article-categories/${id}`, category, 200],
  ];

  it.each(routes)("%s %s: không token → 401; chủ nhà xe / hỗ trợ nền tảng → 403; quản trị viên → thành công", async (method, path, payload, ok) => {
    expect((await call(method, path, null, payload)).status).toBe(401);
    expect(await call(method, path, await token("operator", "OPERATOR_OWNER"), payload)).toMatchObject({
      status: 403,
      body: { code: "PERMISSION_DENIED" },
    });
    expect(await call(method, path, await token("platform", "PLATFORM_SUPPORT"), payload)).toMatchObject({
      status: 403,
      body: { code: "PERMISSION_DENIED" },
    });
    expect(Object.values(service).some((fn) => fn.mock.calls.length > 0)).toBe(false);
    expect((await call(method, path, await token("platform", "PLATFORM_ADMIN"), payload)).status).toBe(ok);
    const called = Object.values(service).find((fn) => fn.mock.calls.length > 0)!;
    const authz = (called.mock.calls[0] as unknown[]).find((arg) => (arg as Authorization | undefined)?.db) as Authorization | undefined;
    if (path !== "/admin/articles/images") {
      expect(authz).toMatchObject({ db: { kind: "platform" } });
    }
  });

  it("validate: slug có dấu / hoa, tiêu đề trống, ảnh SVG, thời điểm sai → 400; slug được viết thường", async () => {
    const admin = await token("platform", "PLATFORM_ADMIN");
    expect((await call("POST", "/admin/articles", admin, { ...body, slug: "bài viết" })).status).toBe(400);
    expect((await call("POST", "/admin/articles", admin, { ...body, title: "  " })).status).toBe(400);
    expect((await call("POST", "/admin/articles/images", admin, { contentType: "image/svg+xml", sizeBytes: 10 })).status).toBe(400);
    expect((await call("POST", "/admin/articles/images", admin, { contentType: "image/png", sizeBytes: 6 * 1024 * 1024 })).status).toBe(400);
    expect((await call("POST", `/admin/articles/${id}/publish`, admin, { publishedAt: "mai" })).status).toBe(400);
    expect((await call("PUT", `/admin/article-categories/${id}`, admin, { ...category, displayOrder: -1 })).status).toBe(400);
    expect(Object.values(service).some((fn) => fn.mock.calls.length > 0)).toBe(false);

    expect((await call("POST", "/admin/articles", admin, { ...body, slug: "Bai-Moi" })).status).toBe(201);
    expect(service.create).toHaveBeenCalledWith(expect.anything(), expect.anything(), expect.objectContaining({ slug: "bai-moi" }));
  });

  it("route công khai: không cần token; slug sai dạng → 400; lượt xem 204", async () => {
    expect((await call("GET", "/article-categories", null)).status).toBe(200);
    expect((await call("GET", "/articles?category=tin-tuc&featured=true", null)).status).toBe(200);
    expect(site.list).toHaveBeenCalledWith(expect.objectContaining({ category: "tin-tuc", featured: true, limit: 12 }));
    expect((await call("GET", "/articles/bai-moi", null)).status).toBe(200);
    expect((await call("GET", "/articles/Bài%20mới", null)).status).toBe(400);
    expect((await call("POST", "/articles/bai-moi/views", null)).status).toBe(204);
    expect(site.recordView).toHaveBeenCalledWith("bai-moi", expect.anything());
  });
});
