import { randomUUID } from "node:crypto";
import { mkdtemp, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import type Redis from "ioredis";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { AuditWriteError, type AuditEventInput, type AuditService } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { platformScope, tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import { LocalStorageProvider } from "../external/storage/local-storage-provider";
import type { Authorization } from "../iam/role/authorization";
import { AdminArticleService } from "./admin-article.service";
import { articleImageKey } from "./article-image-format";
import { ArticleService } from "./article.service";
import { ArticleInputSchema, CategoryInputSchema } from "./dto/admin-article.dto";
import { PublicArticleListQuerySchema } from "./dto/article.dto";

/**
 * TASK-CNT-001 — bài viết trên Postgres THẬT bằng role APP + kho ổ đĩa thật (FR-ADM-18..19, FR-MKT-14, BR-74).
 */
const url = process.env.DATABASE_URL;
const requireDb = process.env.REQUIRE_DB_TESTS === "1";

const PNG = Uint8Array.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0, 0, 0, 0x0d, 9]);

async function rejectionOf(promise: Promise<unknown>): Promise<{ status?: number; code?: string }> {
  try {
    await promise;
    return {};
  } catch (error) {
    const response = (error as { getResponse?: () => { code?: string } }).getResponse?.();
    return { status: (error as { getStatus?: () => number }).getStatus?.(), code: response?.code };
  }
}

describe.skipIf(!url && !requireDb)("Bài viết — Postgres thật, role app, kho ổ đĩa", () => {
  let prisma: PrismaService;
  let rootDir: string;
  let storage: LocalStorageProvider;
  let admin: AdminArticleService;
  let site: ArticleService;
  const tag = randomUUID().slice(0, 8);
  const editorId = randomUUID();
  const actor = { sub: editorId, role: "PLATFORM_ADMIN" };
  const authz: Authorization = { permission: "content:manage", scope: "any", db: platformScope() };
  const recordAuditEvent = vi.fn(async (_event: AuditEventInput, _options?: unknown) => undefined);
  const viewKeys = new Set<string>();
  const redis = {
    set: vi.fn(async (key: string) => {
      if (viewKeys.has(key)) {
        return null;
      }
      viewKeys.add(key);
      return "OK";
    }),
  };
  const categoryIds: string[] = [];
  const articleIds: string[] = [];

  const article = (overrides: Record<string, unknown> = {}) =>
    ArticleInputSchema.parse({
      title: `Bài thử ${tag}`,
      slug: `bai-thu-${tag}-${randomUUID().slice(0, 4)}`,
      summary: "Tóm tắt bài thử",
      contentMarkdown: "## Mở đầu\n\nNội dung **bài thử**.",
      categoryId: categoryIds[0],
      coverImageKey: null,
      featured: false,
      ...overrides,
    });

  async function newArticle(overrides: Record<string, unknown> = {}) {
    const created = await admin.create(authz, actor, article(overrides));
    articleIds.push(created.id);
    return created;
  }

  const publicList = (query: Record<string, unknown> = {}) =>
    site.list(PublicArticleListQuerySchema.parse({ q: tag, ...query }));

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    const [role] = await prisma.$queryRaw<{ rolsuper: boolean; rolbypassrls: boolean }[]>`
      SELECT rolsuper, rolbypassrls FROM pg_roles WHERE rolname = current_user`;
    if (!role || role.rolsuper || role.rolbypassrls) {
      throw new Error("DATABASE_URL đang là superuser/BYPASSRLS — dùng role app (TRN-001-guide.md §0).");
    }
    rootDir = await mkdtemp(join(tmpdir(), "vxn-article-"));
    storage = new LocalStorageProvider({ rootDir, apiBaseUrl: "http://storage.test" });
    admin = new AdminArticleService(prisma, { recordAuditEvent } as unknown as AuditService, storage);
    site = new ArticleService(prisma, storage, redis as unknown as Redis);
    await prisma.withSystem((tx) =>
      tx.platformAccount.create({ data: { id: editorId, username: `cnt-${tag}`, passwordHash: "x", role: "PLATFORM_ADMIN" } }),
    );
    for (const [index, status] of (["ACTIVE", "INACTIVE"] as const).entries()) {
      const category = await admin.createCategory(
        authz,
        actor,
        CategoryInputSchema.parse({ name: `Chuyên mục ${index} ${tag}`, slug: `cm-${index}-${tag}`, displayOrder: 900, status }),
      );
      categoryIds.push(category.id);
    }
  }, 30_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      await tx.article.deleteMany({ where: { id: { in: articleIds } } });
      await tx.articleCategory.deleteMany({ where: { id: { in: categoryIds } } });
      await tx.platformAccount.deleteMany({ where: { id: editorId } });
    });
    await prisma.$disconnect();
    await rm(rootDir, { recursive: true, force: true });
  });

  beforeEach(() => {
    recordAuditEvent.mockReset();
    recordAuditEvent.mockResolvedValue(undefined);
  });

  it("RLS: ngữ cảnh tenant không thêm / sửa được bài; đọc không cần ngữ cảnh", async () => {
    const created = await newArticle();
    const tenant = tenantScope(randomUUID());
    // WITH CHECK của policy `platform_insert` chặn chèn ngoài platform / system.
    await expect(
      prisma.withScope(tenant, (tx) => tx.article.create({ data: { ...article(), createdBy: editorId, updatedBy: editorId } })),
    ).rejects.toThrow();
    const changed = await prisma.withScope(tenant, (tx) =>
      tx.article.updateMany({ where: { id: created.id }, data: { title: "bị sửa" } }),
    );
    expect(changed.count).toBe(0);
    expect(await prisma.article.count({ where: { id: created.id } })).toBe(1);
    expect(await prisma.rlsProblems()).toEqual([]);
  });

  it("chuyên mục: trùng slug → 409; ngừng dùng không chọn cho bài mới (422) nhưng bài cũ vẫn sửa được; trang công khai ẩn chuyên mục ngừng", async () => {
    expect(
      await rejectionOf(
        admin.createCategory(authz, actor, CategoryInputSchema.parse({ name: "Trùng", slug: `cm-0-${tag}`, displayOrder: 1, status: "ACTIVE" })),
      ),
    ).toEqual({ status: 409, code: "ARTICLE_CATEGORY_SLUG_CONFLICT" });
    expect(await rejectionOf(newArticle({ categoryId: categoryIds[1] }))).toEqual({
      status: 422,
      code: "ARTICLE_CATEGORY_UNAVAILABLE",
    });

    const draft = await newArticle();
    const updated = await admin.updateCategory(
      authz,
      actor,
      categoryIds[0]!,
      CategoryInputSchema.parse({ name: `Chuyên mục 0 ${tag}`, slug: `cm-0-${tag}`, displayOrder: 900, status: "INACTIVE" }),
    );
    expect(updated).toMatchObject({ status: "INACTIVE" });
    expect(await admin.update(authz, actor, draft.id, article({ slug: draft.slug, title: "Sửa trong chuyên mục ngừng" }))).toMatchObject({
      title: "Sửa trong chuyên mục ngừng",
    });
    const publicSlugs = (await site.listCategories()).items.map((item) => item.slug);
    expect(publicSlugs).not.toContain(`cm-0-${tag}`);
    expect(publicSlugs).toContain("tin-tuc");
    await admin.updateCategory(
      authz,
      actor,
      categoryIds[0]!,
      CategoryInputSchema.parse({ name: `Chuyên mục 0 ${tag}`, slug: `cm-0-${tag}`, displayOrder: 900, status: "ACTIVE" }),
    );
  });

  it("vòng đời: nháp ẩn; xuất bản (audit) → hiện; hẹn giờ chưa tới thì ẩn; gỡ → ẩn; xuất bản lại; sai trạng thái → 409; trống nội dung → 422", async () => {
    const draft = await newArticle({ featured: true });
    expect(draft).toMatchObject({ status: "DRAFT", publishedAt: null, updatedByName: `platform/cnt-${tag}` });
    expect(await rejectionOf(site.get(draft.slug))).toEqual({ status: 404, code: "ARTICLE_NOT_FOUND" });
    expect(await rejectionOf(admin.archive(authz, actor, draft.id))).toEqual({ status: 409, code: "ARTICLE_STATE_INVALID" });

    const published = await admin.publish(authz, actor, draft.id, undefined);
    expect(published.status).toBe("PUBLISHED");
    expect(recordAuditEvent).toHaveBeenLastCalledWith(
      expect.objectContaining({ action: "article.publish", targetId: draft.id, after: expect.objectContaining({ status: "PUBLISHED" }) }),
      expect.objectContaining({ timeoutMs: 2_000 }),
    );
    expect(await site.get(draft.slug)).toMatchObject({ title: draft.title, contentMarkdown: draft.contentMarkdown });
    expect((await publicList({ featured: "true" })).items.map((item) => item.slug)).toContain(draft.slug);
    expect(await rejectionOf(admin.publish(authz, actor, draft.id, undefined))).toEqual({
      status: 409,
      code: "ARTICLE_STATE_INVALID",
    });

    await admin.update(authz, actor, draft.id, article({ slug: draft.slug, title: `Đã sửa ${tag}`, featured: true }));
    expect(recordAuditEvent).toHaveBeenLastCalledWith(
      expect.objectContaining({ action: "article.update", after: expect.objectContaining({ title: `Đã sửa ${tag}` }) }),
      expect.anything(),
    );
    expect((await site.get(draft.slug)).title).toBe(`Đã sửa ${tag}`);

    await admin.archive(authz, actor, draft.id);
    expect(await rejectionOf(site.get(draft.slug))).toEqual({ status: 404, code: "ARTICLE_NOT_FOUND" });
    await admin.publish(authz, actor, draft.id, undefined);
    expect((await site.get(draft.slug)).slug).toBe(draft.slug);

    const scheduled = await newArticle();
    await admin.publish(authz, actor, scheduled.id, new Date(Date.now() + 3_600_000).toISOString());
    expect(await rejectionOf(site.get(scheduled.slug))).toEqual({ status: 404, code: "ARTICLE_NOT_FOUND" });
    expect((await publicList()).items.map((item) => item.slug)).not.toContain(scheduled.slug);

    const empty = await newArticle({ contentMarkdown: "   " });
    expect(await rejectionOf(admin.publish(authz, actor, empty.id, undefined))).toEqual({
      status: 422,
      code: "ARTICLE_INCOMPLETE",
    });
    expect(await rejectionOf(newArticle({ slug: draft.slug }))).toEqual({ status: 409, code: "ARTICLE_SLUG_CONFLICT" });
  });

  it("hai lần xuất bản cùng lúc: đúng một lần thành công, lần còn lại 409", async () => {
    const draft = await newArticle();
    const results = await Promise.allSettled([
      admin.publish(authz, actor, draft.id, undefined),
      admin.publish(authz, actor, draft.id, undefined),
    ]);
    expect(results.filter((result) => result.status === "fulfilled")).toHaveLength(1);
    const failed = results.find((result) => result.status === "rejected") as PromiseRejectedResult;
    expect(await rejectionOf(Promise.reject(failed.reason))).toEqual({ status: 409, code: "ARTICLE_STATE_INVALID" });
  });

  it("ảnh bìa: khóa lạ / chưa tải → 422; ảnh đã tải đúng định dạng → có địa chỉ công khai", async () => {
    expect(await rejectionOf(newArticle({ coverImageKey: "vehicles/x/y/z.png" }))).toEqual({
      status: 422,
      code: "ARTICLE_IMAGE_INVALID",
    });
    const missing = articleImageKey(randomUUID(), "image/png");
    expect(await rejectionOf(newArticle({ coverImageKey: missing }))).toEqual({ status: 422, code: "ARTICLE_IMAGE_INVALID" });

    const granted = await admin.createImageUploadUrl({ contentType: "image/png", sizeBytes: PNG.length });
    expect(granted.objectKey).toMatch(/^articles\/[0-9a-f-]{36}\.png$/);
    await storage.write(granted.objectKey, "image/png", PNG);
    const withCover = await newArticle({ coverImageKey: granted.objectKey });
    expect(withCover.coverImageUrl).toBe(storage.publicUrl(granted.objectKey));
  });

  it("lượt xem: mỗi IP một lượt / bài trong cửa sổ; bài chưa xuất bản → 404", async () => {
    const draft = await newArticle();
    expect(await rejectionOf(site.recordView(draft.slug, "10.0.0.1"))).toEqual({ status: 404, code: "ARTICLE_NOT_FOUND" });
    await admin.publish(authz, actor, draft.id, undefined);
    await site.recordView(draft.slug, "10.0.0.1");
    await site.recordView(draft.slug, "10.0.0.1");
    await site.recordView(draft.slug, "10.0.0.2");
    expect((await admin.get(authz, draft.id)).viewCount).toBe(2);
  });

  it("audit lỗi → 503, không tạo / không đổi trạng thái", async () => {
    recordAuditEvent.mockRejectedValueOnce(new AuditWriteError(new Error("mongo down")));
    const slug = `audit-loi-${tag}`;
    expect(await rejectionOf(admin.create(authz, actor, article({ slug })))).toEqual({ status: 503, code: "SERVICE_UNAVAILABLE" });
    expect(await prisma.article.count({ where: { slug } })).toBe(0);

    const draft = await newArticle();
    recordAuditEvent.mockRejectedValueOnce(new AuditWriteError(new Error("mongo down")));
    expect(await rejectionOf(admin.publish(authz, actor, draft.id, undefined))).toEqual({ status: 503, code: "SERVICE_UNAVAILABLE" });
    expect((await admin.get(authz, draft.id)).status).toBe("DRAFT");
  });
});
