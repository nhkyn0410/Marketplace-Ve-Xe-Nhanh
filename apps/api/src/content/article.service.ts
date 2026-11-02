import { Inject, Injectable, Logger } from "@nestjs/common";
import type Redis from "ioredis";
import { decodeTimeCursor, encodeTimeCursor } from "../common/time-cursor";
import { incrementArticleViews } from "../database/article-views";
import { PrismaService } from "../database/prisma.service";
import { ArticleStatus, CatalogStatus } from "../database/prisma.types";
import { PUBLIC_STORAGE, type StorageProvider } from "../external/storage/storage-provider";
import { REDIS_CLIENT } from "../redis/redis.config";
import { articleNotFound } from "./content.errors";
import type { PublicArticle, PublicArticleListQuery, PublicArticlePage, PublicCategoryList } from "./dto/article.dto";

/** Một người xem (theo IP) chỉ được tính một lượt / bài trong 30 phút. */
const VIEW_DEDUPE_SECONDS = 1_800;

const CARD_SELECT = {
  id: true,
  title: true,
  slug: true,
  summary: true,
  coverImageKey: true,
  featured: true,
  publishedAt: true,
  category: { select: { name: true, slug: true } },
} as const;

/**
 * Trang Khám phá công khai (TASK-CNT-001; FR-MKT-14, BR-74): chỉ bài `PUBLISHED` đã tới giờ xuất bản. Đọc không
 * cần ngữ cảnh RLS (policy `public_read`); bộ lọc trạng thái nằm ở đây.
 */
@Injectable()
export class ArticleService {
  private readonly logger = new Logger(ArticleService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(PUBLIC_STORAGE) private readonly storage: StorageProvider,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
  ) {}

  /** Chuyên mục đang dùng theo thứ tự hiển thị, kèm số bài đang hiện. */
  async listCategories(): Promise<PublicCategoryList> {
    const rows = await this.prisma.articleCategory.findMany({
      where: { status: CatalogStatus.ACTIVE },
      orderBy: [{ displayOrder: "asc" }, { name: "asc" }],
      select: {
        name: true,
        slug: true,
        _count: { select: { articles: { where: visibleNow() } } },
      },
    });
    return { items: rows.map((row) => ({ name: row.name, slug: row.slug, articleCount: row._count.articles })) };
  }

  async list(query: PublicArticleListQuery): Promise<PublicArticlePage> {
    const literal = query.q?.replace(/[\%_]/g, "\$&");
    const after = query.cursor ? decodeTimeCursor(query.cursor) : null;
    const rows = await this.prisma.article.findMany({
      where: {
        AND: [
          visibleNow(),
          query.category ? { category: { slug: query.category } } : {},
          query.featured === undefined ? {} : { featured: query.featured },
          literal
            ? {
                OR: [
                  { title: { contains: literal, mode: "insensitive" as const } },
                  { summary: { contains: literal, mode: "insensitive" as const } },
                ],
              }
            : {},
          after ? { OR: [{ publishedAt: { lt: after.at } }, { publishedAt: after.at, id: { lt: after.id } }] } : {},
        ],
      },
      orderBy: [{ publishedAt: "desc" }, { id: "desc" }],
      take: query.limit + 1,
      select: CARD_SELECT,
    });
    const kept = rows.slice(0, query.limit);
    const last = kept.at(-1);
    return {
      items: kept.map((row) => this.toCard(row)),
      nextCursor: rows.length > query.limit && last?.publishedAt ? encodeTimeCursor(last.publishedAt, last.id) : null,
    };
  }

  async get(slug: string): Promise<PublicArticle> {
    const row = await this.prisma.article.findFirst({
      where: { slug, ...visibleNow() },
      select: { ...CARD_SELECT, contentMarkdown: true, updatedAt: true },
    });
    if (!row) {
      throw articleNotFound();
    }
    return { ...this.toCard(row), contentMarkdown: row.contentMarkdown, updatedAt: row.updatedAt.toISOString() };
  }

  /** Lượt xem best-effort (LLD §6.10 bước 4): Redis / DB lỗi chỉ ghi log, không làm hỏng trang. */
  async recordView(slug: string, ip: string | undefined): Promise<void> {
    const row = await this.prisma.article.findFirst({ where: { slug, ...visibleNow() }, select: { id: true } });
    if (!row) {
      throw articleNotFound();
    }
    try {
      const fresh = await this.redis.set(`article-view:${row.id}:${ip ?? "unknown"}`, "1", "EX", VIEW_DEDUPE_SECONDS, "NX");
      if (fresh === "OK") {
        await incrementArticleViews(this.prisma, row.id);
      }
    } catch (error) {
      this.logger.warn({ event: "article.view.record_failed", error });
    }
  }

  private toCard(row: {
    id: string;
    title: string;
    slug: string;
    summary: string;
    coverImageKey: string | null;
    featured: boolean;
    publishedAt: Date | null;
    category: { name: string; slug: string };
  }) {
    return {
      title: row.title,
      slug: row.slug,
      summary: row.summary,
      coverImageUrl: row.coverImageKey ? this.storage.publicUrl(row.coverImageKey) : null,
      featured: row.featured,
      category: row.category,
      publishedAt: row.publishedAt!.toISOString(),
    };
  }
}

/** Bài đang hiện công khai: đã xuất bản và đã tới giờ xuất bản. */
function visibleNow() {
  return { status: ArticleStatus.PUBLISHED, publishedAt: { lte: new Date() } };
}
