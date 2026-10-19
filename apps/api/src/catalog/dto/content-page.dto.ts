import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { ContentPageStatus, ContentPageType, ContentPlacement } from "../../database/prisma.types";
import { VEHICLE_IMAGE_CONTENT_TYPES } from "../../vehicle/vehicle-image-format";

// API §7.5 `/admin/content-pages*` + §7.6 `/content-pages*` — banner, câu hỏi thường gặp, trang tĩnh (TASK-ADM-003 phần
// nội dung công khai; FR-ADM-13, UC-28; Figma ADM-10d — thiết kế chờ Khanh duyệt).

/** Vị trí hiển thị hợp lệ theo loại (khớp CHECK `content_pages_placement_by_type`). */
export const PLACEMENTS_BY_TYPE: Record<ContentPageType, readonly ContentPlacement[]> = {
  [ContentPageType.BANNER]: [ContentPlacement.HOME],
  [ContentPageType.PAGE]: [ContentPlacement.FOOTER],
  [ContentPageType.FAQ]: [ContentPlacement.BOOKING, ContentPlacement.TICKET, ContentPlacement.ACCOUNT],
};

export const CONTENT_TITLE_MAX = 160;
export const CONTENT_BODY_MAX = 20_000;
const SLUG = /^[a-z0-9]+(?:-[a-z0-9]+)*$/;
// Liên kết banner: đường dẫn nội bộ (`/…`, không `//` — chặn sang miền khác) hoặc `https://…`.
const LINK = /^(\/(?!\/)\S*|https:\/\/\S+)$/;

const nullableText = (max: number) =>
  z
    .string()
    .trim()
    .max(max)
    .nullable()
    .transform((value) => value || null);

export const ContentPageInputSchema = z
  .object({
    type: z.enum(ContentPageType),
    placement: z.enum(ContentPlacement),
    title: z.string().trim().min(1).max(CONTENT_TITLE_MAX),
    /** Chỉ trang tĩnh (bắt buộc): chữ thường không dấu, số, gạch nối. */
    slug: nullableText(80),
    bodyMarkdown: z.string().max(CONTENT_BODY_MAX),
    /** Chỉ banner (bắt buộc): khóa ảnh do `/admin/content-pages/image-upload-url` cấp. */
    imageKey: nullableText(200),
    /** Chỉ banner (tuỳ chọn). */
    linkUrl: nullableText(300),
    displayOrder: z.int().min(0).max(999),
  })
  .superRefine((input, ctx) => {
    if (!PLACEMENTS_BY_TYPE[input.type]?.includes(input.placement)) {
      ctx.addIssue({ code: "custom", path: ["placement"], message: "Vị trí không hợp với loại nội dung." });
    }
    if (input.type === ContentPageType.PAGE ? !input.slug || !SLUG.test(input.slug) : input.slug !== null) {
      ctx.addIssue({ code: "custom", path: ["slug"], message: "Trang tĩnh cần đường dẫn (chữ thường, số, gạch nối); loại khác không có." });
    }
    if ((input.type === ContentPageType.BANNER) !== (input.imageKey !== null)) {
      ctx.addIssue({ code: "custom", path: ["imageKey"], message: "Banner cần ảnh; loại khác không có ảnh." });
    }
    if (input.linkUrl !== null && (input.type !== ContentPageType.BANNER || !LINK.test(input.linkUrl))) {
      ctx.addIssue({ code: "custom", path: ["linkUrl"], message: "Liên kết chỉ cho banner: đường dẫn bắt đầu bằng / hoặc https://." });
    }
    if (input.type !== ContentPageType.BANNER && input.bodyMarkdown.trim() === "") {
      ctx.addIssue({ code: "custom", path: ["bodyMarkdown"], message: "Nhập nội dung." });
    }
  });
export type ContentPageInput = z.infer<typeof ContentPageInputSchema>;
/** Body tạo / thay toàn bộ một nội dung (loại không đổi được sau khi tạo). */
export class ContentPageInputDto extends createZodDto(ContentPageInputSchema) {}

export const ContentPageStatusInputSchema = z.object({ status: z.enum(ContentPageStatus) });
/** Hiển thị (`PUBLISHED`) / ẩn về bản nháp (`DRAFT`). */
export class ContentPageStatusInputDto extends createZodDto(ContentPageStatusInputSchema) {}

export class ContentPageListQueryDto extends createZodDto(
  z.object({
    type: z.enum(ContentPageType).optional(),
    status: z.enum(ContentPageStatus).optional(),
    /** Tìm trong tiêu đề. */
    q: z.string().trim().max(100).optional(),
    cursor: z.string().max(200).optional(),
    limit: z.coerce.number().int().min(1).max(100).default(20),
  }),
) {}
export type ContentPageListQuery = ContentPageListQueryDto;

const SummaryFields = {
  id: z.uuid(),
  type: z.enum(ContentPageType),
  placement: z.enum(ContentPlacement),
  title: z.string(),
  slug: z.string().nullable(),
  status: z.enum(ContentPageStatus),
  displayOrder: z.int(),
  imageUrl: z.string().nullable(),
  updatedAt: z.iso.datetime(),
};

export const ContentPageSummarySchema = z.object(SummaryFields);
export type ContentPageSummary = z.infer<typeof ContentPageSummarySchema>;

export const ContentPagePageSchema = z.object({
  items: z.array(ContentPageSummarySchema),
  nextCursor: z.string().nullable(),
  /** Tổng số nội dung khớp bộ lọc ("Đã tải 5 / 41 nội dung"). */
  total: z.int(),
});
export type ContentPagePage = z.infer<typeof ContentPagePageSchema>;
export class ContentPagePageDto extends createZodDto(ContentPagePageSchema) {}

export const ContentPageDetailSchema = z.object({
  ...SummaryFields,
  bodyMarkdown: z.string(),
  imageKey: z.string().nullable(),
  linkUrl: z.string().nullable(),
  publishedAt: z.iso.datetime().nullable(),
  createdAt: z.iso.datetime(),
  /** `platform/{username}` của người sửa lần cuối. */
  updatedByName: z.string().nullable(),
});
export type ContentPageDetail = z.infer<typeof ContentPageDetailSchema>;
export class ContentPageDetailDto extends createZodDto(ContentPageDetailSchema) {}

export const ContentImageUploadInputSchema = z.object({
  contentType: z.enum(VEHICLE_IMAGE_CONTENT_TYPES),
  sizeBytes: z.int().min(1).max(5 * 1024 * 1024),
});
export type ContentImageUploadInput = z.infer<typeof ContentImageUploadInputSchema>;
export class ContentImageUploadInputDto extends createZodDto(ContentImageUploadInputSchema) {}

export const ContentImageUploadResponseSchema = z.object({
  uploadUrl: z.string(),
  objectKey: z.string(),
  publicUrl: z.string(),
  expiresAt: z.iso.datetime(),
});
export type ContentImageUploadResponse = z.infer<typeof ContentImageUploadResponseSchema>;
export class ContentImageUploadResponseDto extends createZodDto(ContentImageUploadResponseSchema) {}

// ── API công khai ─────────────────────────────────────────────────────────────────────────────────────────

export class PublicContentListQueryDto extends createZodDto(
  z.object({ type: z.enum(ContentPageType), placement: z.enum(ContentPlacement).optional() }),
) {}

export const PublicContentItemSchema = z.object({
  id: z.uuid(),
  type: z.enum(ContentPageType),
  placement: z.enum(ContentPlacement),
  title: z.string(),
  slug: z.string().nullable(),
  bodyMarkdown: z.string(),
  imageUrl: z.string().nullable(),
  linkUrl: z.string().nullable(),
  displayOrder: z.int(),
  updatedAt: z.iso.datetime(),
});
export type PublicContentItem = z.infer<typeof PublicContentItemSchema>;
export class PublicContentItemDto extends createZodDto(PublicContentItemSchema) {}

export const PublicContentListSchema = z.object({ items: z.array(PublicContentItemSchema) });
export type PublicContentList = z.infer<typeof PublicContentListSchema>;
export class PublicContentListDto extends createZodDto(PublicContentListSchema) {}
