import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { ReviewStatus } from "../../database/prisma.types";

// Đánh giá chuyến đi (TASK-TRUST-001, FR-NSR-10/11, BR-18/55, UC-09/28; Figma "Nhà xe · Hỗ trợ / Đánh giá", ADM-10a). Shape AI tự
// đề xuất, chờ Khanh duyệt (`doc/task-propreties/TRUST-001-todo.md`).

const reason = z.string().trim().min(3).max(500);

export const ReviewInputSchema = z.object({ rating: z.int().min(1).max(5), comment: z.string().trim().max(1000).nullable().default(null) });
export type ReviewInput = z.infer<typeof ReviewInputSchema>;
/** Hành khách đánh giá chuyến của đơn (1–5 sao, nhận xét tùy chọn). */
export class ReviewInputDto extends createZodDto(ReviewInputSchema) {}

export const ReplyInputSchema = z.object({ reply: z.string().trim().min(1).max(1000) });
export type ReplyInput = z.infer<typeof ReplyInputSchema>;
/** Nhà xe phản hồi đánh giá (viết mới / sửa). */
export class ReplyInputDto extends createZodDto(ReplyInputSchema) {}

export const ReportInputSchema = z.object({ reason });
export type ReportInput = z.infer<typeof ReportInputSchema>;
/** Nhà xe báo đánh giá vi phạm — Admin xem xét (nhà xe không sửa / xóa được đánh giá). */
export class ReportInputDto extends createZodDto(ReportInputSchema) {}

export const ModerationInputSchema = z
  .object({ action: z.enum(["HOLD", "HIDE", "SHOW"]), reason: reason.nullable().default(null) })
  .refine((input) => input.action !== "HIDE" || input.reason !== null, { message: "Ẩn đánh giá cần lý do.", path: ["reason"] });
export type ModerationInput = z.infer<typeof ModerationInputSchema>;
/** Giữ chờ / ẩn (bắt buộc lý do) / hiển thị lại một đánh giá (BR-55). */
export class ModerationInputDto extends createZodDto(ModerationInputSchema) {}

export class OperatorReviewQueryDto extends createZodDto(
  z.object({
    routeId: z.uuid().optional(),
    rating: z.coerce.number().int().min(1).max(5).optional(),
    replied: z.enum(["yes", "no"]).optional(),
    cursor: z.uuid().optional(),
    limit: z.coerce.number().int().min(1).max(100).default(20),
  }),
) {}

export class AdminReviewQueryDto extends createZodDto(
  z.object({
    /** `attention` = cần xem xét (đang giữ chờ, nhà xe báo cáo, nghi spam / nội dung lặp, đơn đang tranh chấp — chưa xử lý). */
    status: z.union([z.enum(ReviewStatus), z.literal("attention")]).optional(),
    operatorId: z.uuid().optional(),
    rating: z.coerce.number().int().min(1).max(5).optional(),
    q: z.string().trim().min(1).max(100).optional(),
    cursor: z.uuid().optional(),
    limit: z.coerce.number().int().min(1).max(100).default(20),
  }),
) {}

export const REVIEW_SIGNALS = ["SPAM", "OPERATOR_REPORTED", "DISPUTED", "REPEATED"] as const;

export const ReviewSchema = z.object({
  reviewId: z.uuid(),
  bookingId: z.uuid(),
  bookingCode: z.string(),
  operatorId: z.uuid(),
  operatorName: z.string(),
  /** Tên đã che. */
  authorName: z.string(),
  rating: z.int(),
  comment: z.string().nullable(),
  routeName: z.string(),
  departureAt: z.iso.datetime(),
  status: z.enum(ReviewStatus),
  operatorReply: z.string().nullable(),
  operatorRepliedAt: z.iso.datetime().nullable(),
  operatorReportedAt: z.iso.datetime().nullable(),
  /** Lý do nhà xe báo cáo / lý do kiểm duyệt — chỉ Admin. */
  operatorReportReason: z.string().nullable(),
  moderationReason: z.string().nullable(),
  /** Tín hiệu cần xem xét (Figma ADM-10a "Tín hiệu") — chỉ Admin. */
  signals: z.array(z.enum(REVIEW_SIGNALS)),
  createdAt: z.iso.datetime(),
});
export type Review = z.infer<typeof ReviewSchema>;
export class ReviewDto extends createZodDto(ReviewSchema) {}

export const ReviewPageSchema = z.object({
  items: z.array(ReviewSchema),
  nextCursor: z.uuid().nullable(),
  total: z.int(),
  /** Điểm trung bình + số đánh giá hợp lệ (đang hiển thị) trong phạm vi lọc nhà xe. */
  average: z.number().nullable(),
  validCount: z.int(),
});
export type ReviewPage = z.infer<typeof ReviewPageSchema>;
export class ReviewPageDto extends createZodDto(ReviewPageSchema) {}

export const CustomerReviewSchema = z.object({ review: ReviewSchema.nullable(), canReview: z.boolean() });
export type CustomerReview = z.infer<typeof CustomerReviewSchema>;
/** Đánh giá của đơn (nếu có) và đơn có đủ điều kiện đánh giá không (BR-18). */
export class CustomerReviewDto extends createZodDto(CustomerReviewSchema) {}
