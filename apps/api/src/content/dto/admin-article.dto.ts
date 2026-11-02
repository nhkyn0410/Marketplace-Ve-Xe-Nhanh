import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { TimeCursorField } from "../../common/time-cursor";
import { ArticleStatus, CatalogStatus } from "../../database/prisma.types";
import { MAX_VEHICLE_IMAGE_BYTES } from "../../vehicle/vehicle-image-format";
import { ARTICLE_IMAGE_CONTENT_TYPES } from "../article-image-format";

// API §7.5 — Admin quản lý bài viết + chuyên mục (TASK-CNT-001; FR-ADM-18..19, UC-40, BR-74; Figma ADM-13a…13c).

/** Slug: chữ thường không dấu, số, nối bằng gạch ngang (giống CHECK ở DB). */
const slug = (max: number) =>
  z
    .string()
    .trim()
    .toLowerCase()
    .max(max)
    .regex(/^[a-z0-9]+(-[a-z0-9]+)*$/, "Slug gồm chữ thường không dấu, số và gạch ngang.");

export const ArticleInputSchema = z.object({
  title: z.string().trim().min(1).max(200),
  slug: slug(120),
  summary: z.string().trim().min(1).max(300),
  /** Markdown; bài nháp được để trống, xuất bản thì bắt buộc có nội dung. */
  contentMarkdown: z.string().max(50_000),
  categoryId: z.uuid(),
  /** Khóa object ảnh bìa đã tải lên qua `POST /admin/articles/images`; `null` = không có ảnh bìa. */
  coverImageKey: z.string().max(200).nullable(),
  featured: z.boolean(),
});
export type ArticleInput = z.infer<typeof ArticleInputSchema>;
export class AdminArticleInputDto extends createZodDto(ArticleInputSchema) {}

export const PublishInputSchema = z.object({
  /** Thời điểm xuất bản; bỏ trống = ngay lúc bấm. Ở tương lai = hẹn giờ (API công khai chỉ trả bài đã tới giờ). */
  publishedAt: z.iso.datetime().nullable().optional(),
});
export type PublishInput = z.infer<typeof PublishInputSchema>;
export class AdminArticlePublishDto extends createZodDto(PublishInputSchema) {}

export const ArticleListQuerySchema = z.object({
  /** Tiêu đề (chứa, không phân biệt hoa thường) hoặc slug (bắt đầu bằng). */
  q: z
    .string()
    .trim()
    .max(100)
    .transform((value) => value || undefined)
    .optional(),
  status: z.enum(ArticleStatus).optional(),
  categoryId: z.uuid().optional(),
  /** `{updatedAt}_{id}` của dòng cuối trang trước — danh sách xếp sửa gần nhất trước. */
  cursor: TimeCursorField,
  limit: z.coerce.number().int().min(1).max(50).default(20),
});
export type ArticleListQuery = z.infer<typeof ArticleListQuerySchema>;
export class AdminArticleListQueryDto extends createZodDto(ArticleListQuerySchema) {}

const ArticleSummarySchema = z.object({
  id: z.uuid(),
  title: z.string(),
  slug: z.string(),
  summary: z.string(),
  categoryId: z.uuid(),
  categoryName: z.string(),
  coverImageKey: z.string().nullable(),
  coverImageUrl: z.string().nullable(),
  featured: z.boolean(),
  status: z.enum(ArticleStatus),
  publishedAt: z.iso.datetime().nullable(),
  viewCount: z.int(),
  updatedAt: z.iso.datetime(),
});
export type ArticleSummary = z.infer<typeof ArticleSummarySchema>;

export const ArticlePageSchema = z.object({
  items: z.array(ArticleSummarySchema),
  nextCursor: z.string().nullable(),
  total: z.int(),
});
export type ArticlePage = z.infer<typeof ArticlePageSchema>;
export class AdminArticlePageDto extends createZodDto(ArticlePageSchema) {}

export const ArticleDetailSchema = ArticleSummarySchema.extend({
  contentMarkdown: z.string(),
  createdAt: z.iso.datetime(),
  /** Tên đăng nhập người sửa lần cuối (`platform/…`); `null` nếu tài khoản không còn. */
  updatedByName: z.string().nullable(),
});
export type ArticleDetail = z.infer<typeof ArticleDetailSchema>;
export class AdminArticleDto extends createZodDto(ArticleDetailSchema) {}

export const ImageUploadInputSchema = z.object({
  contentType: z.enum(ARTICLE_IMAGE_CONTENT_TYPES),
  sizeBytes: z.int().min(1).max(MAX_VEHICLE_IMAGE_BYTES),
});
export type ImageUploadInput = z.infer<typeof ImageUploadInputSchema>;
export class AdminArticleImageUploadInputDto extends createZodDto(ImageUploadInputSchema) {}

export const ImageUploadResponseSchema = z.object({
  uploadUrl: z.url(),
  objectKey: z.string(),
  /** Địa chỉ công khai của ảnh sau khi tải xong — chèn vào Markdown hoặc xem trước ảnh bìa. */
  publicUrl: z.string(),
  expiresAt: z.iso.datetime(),
});
export type ImageUploadResponse = z.infer<typeof ImageUploadResponseSchema>;
export class AdminArticleImageUploadResponseDto extends createZodDto(ImageUploadResponseSchema) {}

// ── Chuyên mục ──────────────────────────────────────────────────────────────────────────────────────────

export const CategoryInputSchema = z.object({
  name: z.string().trim().min(1).max(60),
  slug: slug(60),
  /** Thứ tự trên trang Khám phá, nhỏ trước. */
  displayOrder: z.int().min(0).max(999),
  status: z.enum(CatalogStatus),
});
export type CategoryInput = z.infer<typeof CategoryInputSchema>;
export class AdminArticleCategoryInputDto extends createZodDto(CategoryInputSchema) {}

const CategorySchema = z.object({
  id: z.uuid(),
  name: z.string(),
  slug: z.string(),
  displayOrder: z.int(),
  status: z.enum(CatalogStatus),
  /** Số bài thuộc chuyên mục, mọi trạng thái. */
  articleCount: z.int(),
});
export type Category = z.infer<typeof CategorySchema>;
export class AdminArticleCategoryDto extends createZodDto(CategorySchema) {}

export const CategoryListSchema = z.object({ items: z.array(CategorySchema) });
export type CategoryList = z.infer<typeof CategoryListSchema>;
export class AdminArticleCategoryListDto extends createZodDto(CategoryListSchema) {}

export class AdminArticleIdParamDto extends createZodDto(z.object({ id: z.uuid() })) {}
