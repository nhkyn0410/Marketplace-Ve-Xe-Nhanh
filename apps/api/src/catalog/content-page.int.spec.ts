import { randomUUID } from "node:crypto";
import { mkdtemp, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { AuditWriteError, type AuditEventInput, type AuditService } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { platformScope, tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import { LocalStorageProvider } from "../external/storage/local-storage-provider";
import type { Authorization } from "../iam/role/authorization";
import { contentImageKey } from "./content-page-image-format";
import { ContentPageService } from "./content-page.service";
import { ContentPageInputSchema } from "./dto/content-page.dto";

/**
 * TASK-ADM-003 phần nội dung công khai — banner / câu hỏi thường gặp / trang tĩnh trên Postgres THẬT bằng role APP + kho
 * ổ đĩa thật (FR-ADM-13, UC-28). Audit là mock.
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

describe.skipIf(!url && !requireDb)("Nội dung công khai — Postgres thật, role app, kho ổ đĩa (ADM-003)", () => {
  let prisma: PrismaService;
  let rootDir: string;
  let storage: LocalStorageProvider;
  let pages: ContentPageService;
  const tag = randomUUID().slice(0, 8);
  const editorId = randomUUID();
  const actor = { sub: editorId, role: "PLATFORM_ADMIN" };
  const authz: Authorization = { permission: "content:moderate", scope: "any", db: platformScope() };
  const recordAuditEvent = vi.fn(async (_event: AuditEventInput, _options?: unknown) => undefined);

  const input = (overrides: Record<string, unknown> = {}) =>
    ContentPageInputSchema.parse({
      type: "FAQ",
      placement: "BOOKING",
      title: `Tôi có cần tài khoản để đặt vé không? ${tag}`,
      slug: null,
      bodyMarkdown: "Không. Bạn đặt vé được **không cần tài khoản**.",
      imageKey: null,
      linkUrl: null,
      displayOrder: 1,
      ...overrides,
    });

  async function uploadedBannerKey(): Promise<string> {
    const key = contentImageKey(randomUUID(), "image/png");
    await storage.write(key, "image/png", PNG);
    return key;
  }

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    const [role] = await prisma.$queryRaw<{ rolsuper: boolean; rolbypassrls: boolean }[]>`
      SELECT rolsuper, rolbypassrls FROM pg_roles WHERE rolname = current_user`;
    if (!role || role.rolsuper || role.rolbypassrls) {
      throw new Error("DATABASE_URL đang là superuser/BYPASSRLS — dùng role app.");
    }
    rootDir = await mkdtemp(join(tmpdir(), "vxn-content-"));
    storage = new LocalStorageProvider({ rootDir, apiBaseUrl: "http://storage.test" });
    pages = new ContentPageService(prisma, { recordAuditEvent } as unknown as AuditService, storage);
    await prisma.withSystem((tx) =>
      tx.platformAccount.create({ data: { id: editorId, username: `cpg-${tag}`, passwordHash: "x", role: "PLATFORM_ADMIN" } }),
    );
  }, 30_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      await tx.contentPage.deleteMany({ where: { title: { contains: tag } } });
      await tx.platformAccount.deleteMany({ where: { id: editorId } });
    });
    await prisma.$disconnect();
    await rm(rootDir, { recursive: true, force: true });
  });

  beforeEach(() => {
    recordAuditEvent.mockReset();
    recordAuditEvent.mockResolvedValue(undefined);
  });

  it("validate theo loại: vị trí sai loại, trang tĩnh thiếu đường dẫn, banner thiếu ảnh, liên kết ngoài banner / sang miền khác, nội dung rỗng → 400", () => {
    for (const overrides of [
      { placement: "HOME" },
      { type: "PAGE", placement: "FOOTER", slug: null },
      { type: "PAGE", placement: "FOOTER", slug: "Dieu Khoan" },
      { slug: "faq-co-slug" },
      { type: "BANNER", placement: "HOME", imageKey: null },
      { linkUrl: "/tim-chuyen" },
      { type: "BANNER", placement: "HOME", imageKey: "content-pages/x.png", linkUrl: "//evil.example" },
      { type: "BANNER", placement: "HOME", imageKey: "content-pages/x.png", linkUrl: "javascript:alert(1)" },
      { bodyMarkdown: "   " },
    ]) {
      expect(ContentPageInputSchema.safeParse({ ...input(), ...overrides }).success, JSON.stringify(overrides)).toBe(false);
    }
    expect(
      ContentPageInputSchema.safeParse({ ...input(), type: "BANNER", placement: "HOME", imageKey: "content-pages/x.png", bodyMarkdown: "", linkUrl: "https://vexenhanh.vn/khuyen-mai" })
        .success,
    ).toBe(true);
  });

  it("tạo (nháp) + sửa ghi audit trong transaction; đường dẫn trùng 409; không đổi loại 422; ảnh banner lạ / chưa tải 422", async () => {
    const faq = await pages.create(authz, actor, input());
    expect(faq).toMatchObject({ type: "FAQ", placement: "BOOKING", status: "DRAFT", publishedAt: null, updatedByName: `platform/cpg-${tag}` });
    expect(recordAuditEvent).toHaveBeenCalledWith(
      expect.objectContaining({ action: "content_page.create", targetType: "content_page", targetId: faq.id, after: expect.objectContaining({ bodyLength: expect.any(Number) }) }),
      expect.objectContaining({ deadline: expect.any(Number) }),
    );
    const updated = await pages.update(authz, actor, faq.id, input({ title: `Có cần tài khoản không? ${tag}`, displayOrder: 2 }));
    expect(updated).toMatchObject({ displayOrder: 2 });
    expect(recordAuditEvent).toHaveBeenLastCalledWith(
      expect.objectContaining({ action: "content_page.update", before: expect.objectContaining({ displayOrder: 1 }) }),
      expect.anything(),
    );
    expect(await rejectionOf(pages.update(authz, actor, faq.id, input({ type: "PAGE", placement: "FOOTER", slug: `trang-${tag}` })))).toMatchObject({
      status: 422,
      code: "CONTENT_PAGE_TYPE_IMMUTABLE",
    });

    const page = input({ type: "PAGE", placement: "FOOTER", slug: `dieu-khoan-${tag}`, title: `Điều khoản sử dụng ${tag}` });
    await pages.create(authz, actor, page);
    expect(await rejectionOf(pages.create(authz, actor, page))).toMatchObject({ status: 409, code: "CONTENT_PAGE_SLUG_CONFLICT" });

    const banner = (imageKey: string) =>
      input({ type: "BANNER", placement: "HOME", title: `Banner trang chủ ${tag}`, bodyMarkdown: "", imageKey, linkUrl: "/tim-chuyen" });
    expect(await rejectionOf(pages.create(authz, actor, banner("articles/x.png")))).toMatchObject({ status: 422, code: "CONTENT_IMAGE_INVALID" });
    expect(await rejectionOf(pages.create(authz, actor, banner(contentImageKey(randomUUID(), "image/png"))))).toMatchObject({
      code: "CONTENT_IMAGE_INVALID",
    });
    const created = await pages.create(authz, actor, banner(await uploadedBannerKey()));
    expect(created.imageUrl).toContain(created.imageKey!);
  });

  it("hiển thị / ẩn: khoá trạng thái (lặp → 409); API công khai chỉ trả mục đang hiển thị, theo thứ tự; trang tĩnh nháp → 404", async () => {
    const first = await pages.create(authz, actor, input({ placement: "TICKET", title: `Đổi vé thế nào? ${tag}`, displayOrder: 5 }));
    const second = await pages.create(authz, actor, input({ placement: "TICKET", title: `Hủy vé được hoàn bao nhiêu? ${tag}`, displayOrder: 1 }));
    const draft = await pages.create(authz, actor, input({ placement: "TICKET", title: `Bản nháp ${tag}` }));
    const published = await pages.setStatus(authz, actor, first.id, "PUBLISHED");
    expect(published.publishedAt).not.toBeNull();
    expect(recordAuditEvent).toHaveBeenLastCalledWith(expect.objectContaining({ action: "content_page.publish" }), expect.anything());
    await pages.setStatus(authz, actor, second.id, "PUBLISHED");
    expect(await rejectionOf(pages.setStatus(authz, actor, first.id, "PUBLISHED"))).toMatchObject({ status: 409, code: "CONTENT_PAGE_STATE_INVALID" });

    const visible = (await pages.listPublished("FAQ", "TICKET")).items.filter((item) => item.title.includes(tag));
    expect(visible.map((item) => item.id)).toEqual([second.id, first.id]);
    expect(visible.some((item) => item.id === draft.id)).toBe(false);

    await pages.setStatus(authz, actor, first.id, "DRAFT");
    expect((await pages.listPublished("FAQ", "TICKET")).items.some((item) => item.id === first.id)).toBe(false);

    const page = await pages.create(authz, actor, input({ type: "PAGE", placement: "FOOTER", slug: `hoan-tien-${tag}`, title: `Chính sách hoàn tiền ${tag}` }));
    expect(await rejectionOf(pages.getPublishedPage(`hoan-tien-${tag}`))).toMatchObject({ status: 404, code: "CONTENT_PAGE_NOT_FOUND" });
    await pages.setStatus(authz, actor, page.id, "PUBLISHED");
    expect((await pages.getPublishedPage(`hoan-tien-${tag}`)).title).toBe(`Chính sách hoàn tiền ${tag}`);
  });

  it("danh sách Admin: lọc loại / trạng thái / tiêu đề, tổng số, phân trang; con trỏ hỏng → trang rỗng", async () => {
    const all = await pages.list(authz, { q: tag, limit: 100 });
    expect(all.total).toBe(all.items.length);
    expect(all.items.length).toBeGreaterThanOrEqual(6);
    const faqs = await pages.list(authz, { q: tag, type: "FAQ", status: "PUBLISHED", limit: 100 });
    expect(faqs.items.every((item) => item.type === "FAQ" && item.status === "PUBLISHED")).toBe(true);
    const firstPage = await pages.list(authz, { q: tag, limit: 2 });
    expect(firstPage.items).toHaveLength(2);
    const nextPage = await pages.list(authz, { q: tag, limit: 2, cursor: firstPage.nextCursor! });
    expect(nextPage.items.map((item) => item.id)).not.toContain(firstPage.items[0]!.id);
    expect((await pages.list(authz, { q: tag, limit: 2, cursor: "hong_x" })).items).toEqual([]);
  });

  it("audit lỗi → 503 không lưu; RLS: tenant không thêm / sửa được, đọc không cần ngữ cảnh; DB CHECK vị trí theo loại", async () => {
    recordAuditEvent.mockRejectedValueOnce(new AuditWriteError("mongo down"));
    expect(await rejectionOf(pages.create(authz, actor, input({ title: `Không lưu ${tag}` })))).toMatchObject({ status: 503, code: "SERVICE_UNAVAILABLE" });
    expect(await prisma.contentPage.count({ where: { title: `Không lưu ${tag}` } })).toBe(0);

    const tenant = tenantScope(randomUUID());
    const row = { ...input({ title: `Tenant ${tag}` }), createdBy: editorId, updatedBy: editorId };
    await expect(prisma.withScope(tenant, (tx) => tx.contentPage.create({ data: row }))).rejects.toThrow();
    const created = await pages.create(authz, actor, input({ title: `RLS ${tag}` }));
    const changed = await prisma.withScope(tenant, (tx) => tx.contentPage.updateMany({ where: { id: created.id }, data: { title: "bị sửa" } }));
    expect(changed.count).toBe(0);
    expect(await prisma.rlsProblems()).toEqual([]);
    await expect(
      prisma.withScope(platformScope(), (tx) => tx.contentPage.create({ data: { ...row, title: `Sai vị trí ${tag}`, placement: "HOME" } })),
    ).rejects.toThrow(/content_pages_placement_by_type/);
  });
});
