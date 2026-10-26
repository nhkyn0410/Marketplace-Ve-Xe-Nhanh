import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { DiscountType, PromotionScope, PromotionStatus } from "../../database/prisma.types";

// Khuyến mãi (TASK-PROM-001, FR-PROM-01..07, BR-46/47; Figma ADM-11a/b, "Nhà xe · Khuyến mãi" 01–03). Shape AI tự đề xuất, chờ
// Khanh duyệt (`doc/task-propreties/PROM-001-todo.md`). Tiền VND là số nguyên.

const MAX_VND = 100_000_000;
const money = z.int().min(1).max(MAX_VND);

export const PromotionInputSchema = z
  .object({
    /** Khách nhập khi đặt vé; chữ hoa + số, 3–20 ký tự, duy nhất toàn hệ thống. */
    code: z
      .string()
      .trim()
      .toUpperCase()
      .regex(/^[A-Z0-9]{3,20}$/, "Mã gồm 3–20 chữ / số, không dấu, không khoảng trắng."),
    name: z.string().trim().min(3).max(120),
    discountType: z.enum(DiscountType),
    /** `PERCENT`: 1–100; `AMOUNT`: số tiền VND giảm mỗi đơn. */
    discountValue: z.int().min(1).max(MAX_VND),
    /** Trần số tiền giảm của loại phần trăm. */
    maxDiscount: money.nullable().default(null),
    minOrder: z.int().min(0).max(MAX_VND).default(0),
    /** Chỉ khuyến mãi của nhà xe: tuyến / chuyến của chính nhà xe; `null` = mọi tuyến / mọi chuyến. */
    routeId: z.uuid().nullable().default(null),
    /** Nền tảng chọn nhiều tuyến của các nhà xe; rỗng = mọi tuyến của nhà xe tham gia. */
    routeIds: z.array(z.uuid()).max(200).default([]),
    tripId: z.uuid().nullable().default(null),
    startsAt: z.iso.datetime({ offset: true }),
    endsAt: z.iso.datetime({ offset: true }),
    usageLimit: z.int().min(1).max(1_000_000),
  })
  .refine((input) => input.discountType === DiscountType.AMOUNT || input.discountValue <= 100, { message: "Phần trăm giảm từ 1 tới 100.", path: ["discountValue"] })
  .refine((input) => input.discountType === DiscountType.PERCENT || input.maxDiscount === null, { message: "Giảm số tiền cố định không có mức trần.", path: ["maxDiscount"] })
  .refine((input) => Date.parse(input.endsAt) > Date.parse(input.startsAt), { message: "Thời điểm kết thúc phải sau thời điểm bắt đầu.", path: ["endsAt"] });
export type PromotionInput = z.infer<typeof PromotionInputSchema>;
/** Tạo / sửa khuyến mãi (luôn lưu ở trạng thái nháp khi tạo; kích hoạt bằng đổi trạng thái). */
export class PromotionInputDto extends createZodDto(PromotionInputSchema) {}

export const PromotionStatusInputSchema = z.object({ status: z.enum([PromotionStatus.ACTIVE, PromotionStatus.PAUSED, PromotionStatus.ENDED]) });
export type PromotionStatusInput = z.infer<typeof PromotionStatusInputSchema>;
/** Kích hoạt / tạm dừng / kết thúc. */
export class PromotionStatusInputDto extends createZodDto(PromotionStatusInputSchema) {}

/** Trạng thái hiển thị (Figma "Đang chạy / Nháp / Tạm dừng / Đã kết thúc", "đã lên lịch"). */
export const PROMOTION_DISPLAY = ["DRAFT", "SCHEDULED", "RUNNING", "PAUSED", "ENDED"] as const;

export const PromotionSchema = z.object({
  promotionId: z.uuid(),
  code: z.string(),
  name: z.string(),
  scope: z.enum(PromotionScope),
  operatorId: z.uuid().nullable(),
  operatorName: z.string().nullable(),
  discountType: z.enum(DiscountType),
  discountValue: z.int(),
  maxDiscount: z.int().nullable(),
  minOrder: z.int(),
  routeId: z.uuid().nullable(),
  routeIds: z.array(z.uuid()),
  routeNames: z.array(z.string()),
  routeName: z.string().nullable(),
  tripId: z.uuid().nullable(),
  startsAt: z.iso.datetime(),
  endsAt: z.iso.datetime(),
  usageLimit: z.int(),
  usedCount: z.int(),
  status: z.enum(PromotionStatus),
  display: z.enum(PROMOTION_DISPLAY),
  /** Chưa có đơn nào dùng mã + chưa kết thúc → sửa được điều kiện (BR-47). */
  editable: z.boolean(),
  /** Khuyến mãi nền tảng: nhà xe đang xem đã tham gia chưa (chỉ phía nhà xe). */
  joined: z.boolean().nullable(),
  /** Khuyến mãi nền tảng: số nhà xe tham gia (chỉ Admin). */
  participants: z.int().nullable(),
  createdAt: z.iso.datetime(),
});
export type Promotion = z.infer<typeof PromotionSchema>;
export class PromotionDto extends createZodDto(PromotionSchema) {}

/** Tuyến để Admin chọn phạm vi khuyến mãi nền tảng. */
export class PromotionRouteOptionsDto extends createZodDto(z.object({ items: z.array(z.object({ routeId: z.uuid(), routeName: z.string(), operatorName: z.string() })) })) {}

export const PromotionStatsSchema = z.object({
  running: z.int(),
  scheduled: z.int(),
  drafts: z.int(),
  paused: z.int(),
  /** 30 ngày gần nhất, đơn đã thanh toán. */
  redemptions: z.int(),
  discount: z.int(),
  revenue: z.int(),
});
export type PromotionStats = z.infer<typeof PromotionStatsSchema>;

export const PromotionPageSchema = z.object({ items: z.array(PromotionSchema), nextCursor: z.uuid().nullable(), total: z.int(), stats: PromotionStatsSchema });
export type PromotionPage = z.infer<typeof PromotionPageSchema>;
export class PromotionPageDto extends createZodDto(PromotionPageSchema) {}

export class PromotionListQueryDto extends createZodDto(
  z.object({
    display: z.enum(PROMOTION_DISPLAY).optional(),
    q: z.string().trim().min(1).max(50).optional(),
    routeId: z.uuid().optional(),
    /** Admin: lọc khuyến mãi của một nhà xe. */
    operatorId: z.uuid().optional(),
    cursor: z.uuid().optional(),
    limit: z.coerce.number().int().min(1).max(100).default(20),
  }),
) {}

export const PermissionInputSchema = z
  .object({
    enabled: z.boolean(),
    maxPercent: z.int().min(1).max(100).nullable().default(null),
    maxAmount: money.nullable().default(null),
    /** Rỗng = mọi tuyến của nhà xe. */
    routeIds: z.array(z.uuid()).max(200).default([]),
    maxDurationDays: z.int().min(1).max(366).default(30),
    monthlyBudget: money.nullable().default(null),
  })
  .refine((input) => !input.enabled || input.maxPercent !== null || input.maxAmount !== null, { message: "Bật quyền cần ít nhất một mức giảm tối đa.", path: ["maxPercent"] });
export type PermissionInput = z.infer<typeof PermissionInputSchema>;
/** Quyền tự tạo khuyến mãi + giới hạn của một nhà xe (FR-PROM-03). */
export class PermissionInputDto extends createZodDto(PermissionInputSchema) {}

export const PermissionSchema = z.object({
  operatorId: z.uuid(),
  operatorName: z.string(),
  operatorSlug: z.string(),
  enabled: z.boolean(),
  maxPercent: z.int().nullable(),
  maxAmount: z.int().nullable(),
  routeIds: z.array(z.uuid()),
  routeNames: z.array(z.string()),
  maxDurationDays: z.int(),
  monthlyBudget: z.int().nullable(),
});
export type Permission = z.infer<typeof PermissionSchema>;
export class PermissionDto extends createZodDto(PermissionSchema) {}

export const PermissionPageSchema = z.object({ items: z.array(PermissionSchema), nextCursor: z.uuid().nullable(), total: z.int() });
export type PermissionPage = z.infer<typeof PermissionPageSchema>;
export class PermissionPageDto extends createZodDto(PermissionPageSchema) {}

export class PermissionListQueryDto extends createZodDto(
  z.object({
    q: z.string().trim().min(1).max(100).optional(),
    enabled: z.enum(["yes", "no"]).optional(),
    cursor: z.uuid().optional(),
    limit: z.coerce.number().int().min(1).max(100).default(20),
  }),
) {}

/**
 * Báo trước số tiền giảm: gửi ĐÚNG MỘT trong `code` (mã khuyến mãi) hoặc `userVoucherId` (voucher trong ví — cần đăng nhập).
 * Không giữ lượt dùng / không giữ voucher; việc giữ diễn ra khi tạo booking.
 */
export const PromotionCheckInputSchema = z
  .object({
    tripId: z.uuid(),
    code: z.string().trim().min(1).max(20).optional(),
    userVoucherId: z.uuid().optional(),
    subtotal: z.int().min(1).max(MAX_VND),
  })
  .refine((input) => Boolean(input.code) !== Boolean(input.userVoucherId), { path: ["code"], message: "Gửi đúng một trong mã khuyến mãi hoặc voucher trong ví." });
export type PromotionCheckInput = z.infer<typeof PromotionCheckInputSchema>;
/** Báo trước số tiền giảm của một mã cho chuyến + tiền vé (không giữ lượt dùng). */
export class PromotionCheckInputDto extends createZodDto(PromotionCheckInputSchema) {}

export const PromotionCheckSchema = z.object({ code: z.string(), name: z.string(), discount: z.int(), total: z.int() });
export type PromotionCheck = z.infer<typeof PromotionCheckSchema>;
export class PromotionCheckDto extends createZodDto(PromotionCheckSchema) {}
