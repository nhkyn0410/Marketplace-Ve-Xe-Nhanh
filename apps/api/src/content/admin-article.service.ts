import { randomUUID } from "node:crypto";
import { HttpException, Inject, Injectable, Logger } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { decodeTimeCursor, encodeTimeCursor } from "../common/time-cursor";
import type { DbScope } from "../database/db-scope";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import { ArticleStatus, CatalogStatus } from "../database/prisma.types";
import { PUBLIC_STORAGE, type StorageProvider } from "../external/storage/storage-provider";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { isPrismaUniqueConflict } from "../iam/user/account.errors";
import { detectImageType, IMAGE_SIGNATURE_BYTES, MAX_VEHICLE_IMAGE_BYTES } from "../vehicle/vehicle-image-format";
import { articleImageKey, contentTypeOfArticleKey } from "./article-image-format";
import {
  articleCategoryNotFound,
  articleCategorySlugConflict,
  articleCategoryUnavailable,
  articleImageInvalid,
  articleIncomplete,
  articleNotFound,
  articleSlugConflict,
  articleStateInvalid,
  contentServiceUnavailable,
} from "./content.errors";
import type {
  ArticleDetail,
  ArticleInput,
  ArticleListQuery,
  ArticlePage,
  ArticleSummary,
  Category,
  CategoryInput,
  CategoryList,
  ImageUploadInput,
  ImageUploadResponse,
} from "./dto/admin-article.dto";

type Actor = Pick<VerifiedAccessToken, "sub" | "role">;

const AUDIT_TIMEOUT_MS = 2_000;
/** URL tải ảnh có hiệu lực 5 phút (như ảnh xe, ADR-018). */
const UPLOAD_URL_TTL_SECONDS = 300;

const SUMMARY_SELECT = {
  id: true,
  title: true,
  slug: true,
  summary: true,
  categoryId: true,
  coverImageKey: true,
  featured: true,
  status: true,
  publishedAt: true,
  viewCount: true,
  updatedAt: true,
  category: { select: { name: true } },
} as const;
const DETAIL_SELECT = { ...SUMMARY_SELECT, contentMarkdown: true, createdAt: true, updatedBy: true } as const;

type SummaryRow = {
  id: string;
  title: string;
  slug: string;
  summary: string;
  categoryId: string;
  coverImageKey: string | null;
  featured: boolean;
  status: ArticleStatus;
  publishedAt: Date | null;
  viewCount: number;
  updatedAt: Date;
  category: { name: string };
};

/**
 * Admin soạn / xuất bản / gỡ bài viết và quản lý chuyên mục (TASK-CNT-001; FR-ADM-18..19, UC-40, BR-74, LLD §6.10).
 * Scope DB `platform`; mọi thay đổi ghi audit TRONG transaction (lỗi → 503, không lưu gì). Nội dung lưu Markdown
 * nguyên văn — nơi hiển thị chỉ render tập thẻ cho phép, không render HTML thô.
 */
@Injectable()
export class AdminArticleService {
  private readonly logger = new Logger(AdminArticleService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(PUBLIC_STORAGE) private readonly storage: StorageProvider,
  ) {}

  async list(authz: Authorization, query: ArticleListQuery): Promise<ArticlePage> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const literal = query.q?.replace(/[\\%_]/g, "\\$&");
      const where = {
        status: query.status,
        categoryId: query.categoryId,
        ...(literal
          ? { OR: [{ title: { contains: literal, mode: "insensitive" as const } }, { slug: { startsWith: literal.toLowerCase() } }] }
          : {}),
      };
      const after = query.cursor ? decodeTimeCursor(query.cursor) : null;
      const rows = await tx.article.findMany({
        where: {
          AND: [
            where,
            after ? { OR: [{ updatedAt: { lt: after.at } }, { updatedAt: after.at, id: { lt: after.id } }] } : {},
          ],
        },
        orderBy: [{ updatedAt: "desc" }, { id: "desc" }],
        take: query.limit + 1,
        select: SUMMARY_SELECT,
      });
      const kept = rows.slice(0, query.limit);
      const last = kept.at(-1);
      return {
        items: kept.map((row) => this.toSummary(row)),
        nextCursor: rows.length > query.limit && last ? encodeTimeCursor(last.updatedAt, last.id) : null,
        total: await tx.article.count({ where }),
      };
    });
  }

  async get(authz: Authorization, id: string): Promise<ArticleDetail> {
    return this.prisma.withScope(platformDb(authz), (tx) => this.detail(tx, id));
  }

  async create(authz: Authorization, actor: Actor, input: ArticleInput): Promise<ArticleDetail> {
    if (input.coverImageKey) {
      await this.inspectImage(input.coverImageKey);
    }
    return this.write(authz, async (tx, deadline) => {
      await requireActiveCategory(tx, input.categoryId);
      const row = await tx.article.create({
        data: { ...input, createdBy: actor.sub, updatedBy: actor.sub },
        select: { id: true },
      });
      await this.recordAudit(deadline, actor, "article.create", "article", row.id, null, snapshot(input), undefined);
      return this.detail(tx, row.id);
    });
  }

  /** Sửa mọi trạng thái; bài đang xuất bản đổi ngay trên trang công khai (UC-40 A4) và được ghi audit. */
  async update(authz: Authorization, actor: Actor, id: string, input: ArticleInput): Promise<ArticleDetail> {
    const current = await this.prisma.withScope(platformDb(authz), (tx) =>
      tx.article.findUnique({ where: { id }, select: { coverImageKey: true } }),
    );
    if (!current) {
      throw articleNotFound();
    }
    if (input.coverImageKey && input.coverImageKey !== current.coverImageKey) {
      await this.inspectImage(input.coverImageKey);
    }
    return this.write(authz, async (tx, deadline) => {
      const before = await tx.article.findUnique({ where: { id }, select: AUDITED_FIELDS });
      if (!before) {
        throw articleNotFound();
      }
      // Chuyên mục ngừng dùng không chọn MỚI được; bài đang thuộc chuyên mục đó vẫn sửa được.
      if (input.categoryId !== before.categoryId) {
        await requireActiveCategory(tx, input.categoryId);
      }
      await tx.article.update({ where: { id }, data: { ...input, updatedBy: actor.sub } });
      await this.recordAudit(deadline, actor, "article.update", "article", id, snapshot(before), snapshot(input), undefined);
      return this.detail(tx, id);
    });
  }

  /** `DRAFT` / `ARCHIVED` → `PUBLISHED`; thời điểm bỏ trống = ngay lúc gọi. */
  async publish(authz: Authorization, actor: Actor, id: string, publishedAt: string | null | undefined): Promise<ArticleDetail> {
    return this.write(authz, async (tx, deadline) => {
      const before = await lockArticle(tx, id);
      if (before.status === ArticleStatus.PUBLISHED) {
        throw articleStateInvalid();
      }
      if (before.contentMarkdown.trim() === "") {
        throw articleIncomplete();
      }
      const at = publishedAt ? new Date(publishedAt) : new Date();
      await tx.article.update({
        where: { id },
        data: { status: ArticleStatus.PUBLISHED, publishedAt: at, updatedBy: actor.sub },
      });
      await this.recordAudit(
        deadline,
        actor,
        "article.publish",
        "article",
        id,
        { status: before.status, slug: before.slug },
        { status: ArticleStatus.PUBLISHED, slug: before.slug, publishedAt: at.toISOString() },
        undefined,
      );
      return this.detail(tx, id);
    });
  }

  /** `PUBLISHED` → `ARCHIVED`: ẩn khỏi trang công khai, giữ để truy vết, xuất bản lại được (UC-40 A2). */
  async archive(authz: Authorization, actor: Actor, id: string): Promise<ArticleDetail> {
    return this.write(authz, async (tx, deadline) => {
      const before = await lockArticle(tx, id);
      if (before.status !== ArticleStatus.PUBLISHED) {
        throw articleStateInvalid();
      }
      await tx.article.update({ where: { id }, data: { status: ArticleStatus.ARCHIVED, updatedBy: actor.sub } });
      await this.recordAudit(
        deadline,
        actor,
        "article.archive",
        "article",
        id,
        { status: before.status, slug: before.slug },
        { status: ArticleStatus.ARCHIVED, slug: before.slug },
        undefined,
      );
      return this.detail(tx, id);
    });
  }

  /** Cấp URL tải MỘT ảnh (ảnh bìa hoặc ảnh chèn vào nội dung) lên kho công khai; khóa do server sinh. */
  async createImageUploadUrl(input: ImageUploadInput): Promise<ImageUploadResponse> {
    const objectKey = articleImageKey(randomUUID(), input.contentType);
    const target = await this.callStorage(() =>
      this.storage.createUploadUrl({
        key: objectKey,
        contentType: input.contentType,
        sizeBytes: input.sizeBytes,
        expiresInSeconds: UPLOAD_URL_TTL_SECONDS,
      }),
    );
    return {
      uploadUrl: target.uploadUrl,
      objectKey,
      publicUrl: this.storage.publicUrl(objectKey),
      expiresAt: target.expiresAt.toISOString(),
    };
  }

  // ── Chuyên mục ────────────────────────────────────────────────────────────────────────────────────────

  async listCategories(authz: Authorization): Promise<CategoryList> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const rows = await tx.articleCategory.findMany({
        orderBy: [{ displayOrder: "asc" }, { name: "asc" }],
        select: { id: true, name: true, slug: true, displayOrder: true, status: true, _count: { select: { articles: true } } },
      });
      return { items: rows.map(toCategory) };
    });
  }

  async createCategory(authz: Authorization, actor: Actor, input: CategoryInput): Promise<Category> {
    return this.write(
      authz,
      async (tx, deadline) => {
        const row = await tx.articleCategory.create({ data: input, select: CATEGORY_SELECT });
        await this.recordAudit(deadline, actor, "article_category.create", "article_category", row.id, null, input, undefined);
        return toCategory(row);
      },
      articleCategorySlugConflict,
    );
  }

  async updateCategory(authz: Authorization, actor: Actor, id: string, input: CategoryInput): Promise<Category> {
    return this.write(
      authz,
      async (tx, deadline) => {
        const before = await tx.articleCategory.findUnique({
          where: { id },
          select: { name: true, slug: true, displayOrder: true, status: true },
        });
        if (!before) {
          throw articleCategoryNotFound();
        }
        const row = await tx.articleCategory.update({ where: { id }, data: input, select: CATEGORY_SELECT });
        await this.recordAudit(deadline, actor, "article_category.update", "article_category", id, before, input, undefined);
        return toCategory(row);
      },
      articleCategorySlugConflict,
    );
  }

  // ── Nội bộ ────────────────────────────────────────────────────────────────────────────────────────────

  private async detail(tx: DbTransaction, id: string): Promise<ArticleDetail> {
    const row = await tx.article.findUnique({ where: { id }, select: DETAIL_SELECT });
    if (!row) {
      throw articleNotFound();
    }
    const editor = await tx.platformAccount.findUnique({ where: { id: row.updatedBy }, select: { username: true } });
    return {
      ...this.toSummary(row),
      contentMarkdown: row.contentMarkdown,
      createdAt: row.createdAt.toISOString(),
      updatedByName: editor ? `platform/${editor.username}` : null,
    };
  }

  private toSummary(row: SummaryRow): ArticleSummary {
    return {
      id: row.id,
      title: row.title,
      slug: row.slug,
      summary: row.summary,
      categoryId: row.categoryId,
      categoryName: row.category.name,
      coverImageKey: row.coverImageKey,
      coverImageUrl: row.coverImageKey ? this.storage.publicUrl(row.coverImageKey) : null,
      featured: row.featured,
      status: row.status,
      publishedAt: row.publishedAt?.toISOString() ?? null,
      viewCount: row.viewCount,
      updatedAt: row.updatedAt.toISOString(),
    };
  }

  /** Ảnh bìa phải là object do server cấp khóa, đã tải lên, đúng loại, ≤ 5 MB và đúng chữ ký định dạng. */
  private async inspectImage(objectKey: string): Promise<void> {
    const expected = contentTypeOfArticleKey(objectKey);
    if (!expected) {
      throw articleImageInvalid();
    }
    const object = await this.callStorage(() => this.storage.head(objectKey));
    if (!object || object.sizeBytes < 1 || object.sizeBytes > MAX_VEHICLE_IMAGE_BYTES || object.contentType !== expected) {
      throw articleImageInvalid();
    }
    const start = await this.callStorage(() => this.storage.readStart(objectKey, IMAGE_SIGNATURE_BYTES));
    if (detectImageType(start) !== expected) {
      throw articleImageInvalid();
    }
  }

  private async callStorage<T>(work: () => Promise<T>): Promise<T> {
    try {
      return await work();
    } catch (error) {
      if (error instanceof HttpException) {
        throw error;
      }
      this.logger.error({ event: "article.image.storage_failed", error });
      throw contentServiceUnavailable();
    }
  }

  /** Transaction scope platform; trùng slug → 409; audit lỗi / hết hạn transaction → 503, không lưu gì. */
  private async write<T>(
    authz: Authorization,
    work: (tx: DbTransaction, deadline: number) => Promise<T>,
    slugConflict: () => HttpException = articleSlugConflict,
  ): Promise<T> {
    try {
      return await this.prisma.withScope(platformDb(authz), (tx) => work(tx, transactionDeadline(Date.now())));
    } catch (error) {
      if (isPrismaUniqueConflict(error)) {
        throw slugConflict();
      }
      if (error instanceof AuditWriteError || (error as { code?: unknown } | null)?.code === "P2028") {
        throw contentServiceUnavailable();
      }
      throw error;
    }
  }

  private recordAudit(
    deadline: number,
    actor: Actor,
    action: string,
    targetType: string,
    targetId: string,
    before: Record<string, unknown> | null,
    after: Record<string, unknown>,
    reason: string | undefined,
  ): Promise<void> {
    return this.audit.recordAuditEvent(
      { actorId: actor.sub, actorRole: actor.role, action, targetType, targetId, before, after, ...(reason ? { reason } : {}) },
      { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
    );
  }
}

/** Trường ghi vào audit trước / sau — không chép nguyên nội dung dài, chỉ độ dài. */
const AUDITED_FIELDS = {
  title: true,
  slug: true,
  summary: true,
  categoryId: true,
  coverImageKey: true,
  featured: true,
  contentMarkdown: true,
} as const;

function snapshot(input: {
  title: string;
  slug: string;
  summary: string;
  categoryId: string;
  coverImageKey: string | null;
  featured: boolean;
  contentMarkdown: string;
}): Record<string, unknown> {
  const { contentMarkdown, ...rest } = input;
  return { ...rest, contentLength: contentMarkdown.length };
}

const CATEGORY_SELECT = {
  id: true,
  name: true,
  slug: true,
  displayOrder: true,
  status: true,
  _count: { select: { articles: true } },
} as const;

function toCategory(row: {
  id: string;
  name: string;
  slug: string;
  displayOrder: number;
  status: CatalogStatus;
  _count: { articles: number };
}): Category {
  return {
    id: row.id,
    name: row.name,
    slug: row.slug,
    displayOrder: row.displayOrder,
    status: row.status,
    articleCount: row._count.articles,
  };
}

async function requireActiveCategory(tx: DbTransaction, categoryId: string): Promise<void> {
  const category = await tx.articleCategory.findUnique({ where: { id: categoryId }, select: { status: true } });
  if (category?.status !== CatalogStatus.ACTIVE) {
    throw articleCategoryUnavailable();
  }
}

/** Khóa dòng bài để hai lần xuất bản / gỡ cùng lúc xếp hàng — chỉ một lần đổi trạng thái thành công. */
async function lockArticle(
  tx: DbTransaction,
  id: string,
): Promise<{ status: ArticleStatus; slug: string; contentMarkdown: string }> {
  const [row] = await tx.$queryRaw<{ status: ArticleStatus; slug: string; content_markdown: string }[]>`
    SELECT status, slug, content_markdown FROM articles WHERE id = ${id} FOR NO KEY UPDATE`;
  if (!row) {
    throw articleNotFound();
  }
  return { status: row.status, slug: row.slug, contentMarkdown: row.content_markdown };
}

function platformDb(authz: Authorization): DbScope {
  if (authz.db?.kind !== "platform") {
    // Lỗi lập trình: route Admin thiếu `@Authorize` với quyền phạm vi `any`.
    throw new Error("Route Admin bài viết cần ngữ cảnh DB platform.");
  }
  return authz.db;
}
