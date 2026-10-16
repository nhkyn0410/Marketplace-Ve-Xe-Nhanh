import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { TimeCursorField } from "../../common/time-cursor";

// API §7.2 — trang Khám phá công khai (TASK-CNT-001; FR-MKT-14, BR-74): chỉ bài `PUBLISHED` đã tới giờ xuất bản.

export const PublicArticleListQuerySchema = z.object({
  /** Slug chuyên mục. */
  category: z.string().trim().max(60).optional(),
  /** Tìm trong tiêu đề / tóm tắt. */
  q: z
    .string()
    .trim()
    .max(100)
    .transform((value) => value || undefined)
    .optional(),
  /** `true` = chỉ bài nổi bật. */
  featured: z
    .enum(["true", "false"])
    .transform((value) => value === "true")
    .optional(),
  /** `{publishedAt}_{id}` của bài cuối trang trước — mới xuất bản trước. */
  cursor: TimeCursorField,
  limit: z.coerce.number().int().min(1).max(24).default(12),
});
export type PublicArticleListQuery = z.infer<typeof PublicArticleListQuerySchema>;
export class ArticleListQueryDto extends createZodDto(PublicArticleListQuerySchema) {}

const CategoryRef = z.object({ name: z.string(), slug: z.string() });

const PublicArticleCardSchema = z.object({
  title: z.string(),
  slug: z.string(),
  summary: z.string(),
  coverImageUrl: z.string().nullable(),
  featured: z.boolean(),
  category: CategoryRef,
  publishedAt: z.iso.datetime(),
});

export const PublicArticlePageSchema = z.object({
  items: z.array(PublicArticleCardSchema),
  nextCursor: z.string().nullable(),
});
export type PublicArticlePage = z.infer<typeof PublicArticlePageSchema>;
export class ArticlePageDto extends createZodDto(PublicArticlePageSchema) {}

export const PublicArticleSchema = PublicArticleCardSchema.extend({
  /** Markdown — client chỉ render tập thẻ cho phép, KHÔNG render HTML thô (LLD §6.10 bước 2). */
  contentMarkdown: z.string(),
  updatedAt: z.iso.datetime(),
});
export type PublicArticle = z.infer<typeof PublicArticleSchema>;
export class ArticleDto extends createZodDto(PublicArticleSchema) {}

export const PublicCategoryListSchema = z.object({
  items: z.array(CategoryRef.extend({ articleCount: z.int() })),
});
export type PublicCategoryList = z.infer<typeof PublicCategoryListSchema>;
export class ArticleCategoryListDto extends createZodDto(PublicCategoryListSchema) {}

export class ArticleSlugParamDto extends createZodDto(
  z.object({ slug: z.string().trim().max(120).regex(/^[a-z0-9]+(-[a-z0-9]+)*$/) }),
) {}
