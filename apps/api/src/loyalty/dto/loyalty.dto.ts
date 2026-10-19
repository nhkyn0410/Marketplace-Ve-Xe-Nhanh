import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { AccountStatus, LoyaltyPointType, LoyaltyTier } from "../../database/prisma.types";

// API §7.5 `/admin/loyalty/*` — VXN Plus phía Admin (TASK-LOY-001; FR-LOY-11/12, UC-39; Figma ADM-12b/c/d). Tham số chương trình dùng
// endpoint chính sách chung `/admin/policies/LOYALTY` (FR-LOY-10) thay cho `/admin/loyalty/policy`. Hình dạng AI tự đề xuất — chờ Khanh duyệt.

export const MemberLookupQuerySchema = z.object({ email: z.string().trim().toLowerCase().pipe(z.email()) });
export class MemberLookupQueryDto extends createZodDto(MemberLookupQuerySchema) {}

const NextTierSchema = z.object({ tier: z.enum(LoyaltyTier), minPoints: z.int(), remaining: z.int() });

export const LoyaltyMemberSchema = z.object({
  userId: z.string(),
  name: z.string().nullable(),
  email: z.string(),
  status: z.enum(AccountStatus),
  /** Thành viên từ ngày đăng ký tài khoản (FR-LOY-01 — sổ điểm tạo khi có giao dịch đầu tiên). */
  memberSince: z.iso.datetime(),
  availablePoints: z.int(),
  /** Điểm tích trong 12 tháng (tích − thu hồi) — căn cứ xếp hạng (BR-68). */
  earned12m: z.int(),
  tier: z.enum(LoyaltyTier),
  nextTier: NextTierSchema.nullable(),
  /** Phiên bản chính sách đang áp dụng; `null` = chương trình chưa chạy. */
  policyVersion: z.int().nullable(),
});
export type LoyaltyMember = z.infer<typeof LoyaltyMemberSchema>;
export class LoyaltyMemberDto extends createZodDto(LoyaltyMemberSchema) {}

export const TransactionListQuerySchema = z.object({
  offset: z.coerce.number().int().min(0).default(0),
  limit: z.coerce.number().int().min(1).max(50).default(20),
});
export class TransactionListQueryDto extends createZodDto(TransactionListQuerySchema) {}

export const LoyaltyTransactionSchema = z.object({
  id: z.uuid(),
  type: z.enum(LoyaltyPointType),
  /** Có dấu. */
  points: z.int(),
  tier: z.enum(LoyaltyTier),
  sourceLabel: z.string(),
  reason: z.string().nullable(),
  policyVersion: z.int().nullable(),
  expiresAt: z.iso.datetime().nullable(),
  createdAt: z.iso.datetime(),
});
export type LoyaltyTransaction = z.infer<typeof LoyaltyTransactionSchema>;

export const LoyaltyTransactionPageSchema = z.object({ items: z.array(LoyaltyTransactionSchema), total: z.int() });
export type LoyaltyTransactionPage = z.infer<typeof LoyaltyTransactionPageSchema>;
export class LoyaltyTransactionPageDto extends createZodDto(LoyaltyTransactionPageSchema) {}

export const ADJUST_DIRECTIONS = ["CREDIT", "DEBIT"] as const;

export const PointAdjustInputSchema = z.object({
  direction: z.enum(ADJUST_DIRECTIONS),
  points: z.int().min(1).max(1_000_000),
  reason: z.string().trim().min(3).max(500),
});
export type PointAdjustInput = z.infer<typeof PointAdjustInputSchema>;
export class PointAdjustInputDto extends createZodDto(PointAdjustInputSchema) {}

export const LoyaltyReportQuerySchema = z.object({
  year: z.coerce.number().int().min(2024).max(2100),
  quarter: z.coerce.number().int().min(1).max(4),
  tier: z.enum(LoyaltyTier).optional(),
});
export type LoyaltyReportQuery = z.infer<typeof LoyaltyReportQuerySchema>;
export class LoyaltyReportQueryDto extends createZodDto(LoyaltyReportQuerySchema) {}

const ReportFiguresSchema = z.object({
  /** Điểm phát hành = tích + điều chỉnh cộng. */
  issued: z.int(),
  redeemed: z.int(),
  expired: z.int(),
  /** Voucher đổi điểm đã dùng + phần giảm Vé Xe Nhanh chịu (VND) — 0 tới khi có ví voucher (TASK-PROM-002). */
  vouchersRedeemed: z.int(),
  vouchersUsed: z.int(),
  platformDiscount: z.int(),
});

export const LoyaltyReportSchema = z.object({
  year: z.int(),
  quarter: z.int(),
  tier: z.enum(LoyaltyTier).nullable(),
  /** Tháng trong quý (giờ VN), mới trước; tháng chưa tới không có. */
  months: z.array(ReportFiguresSchema.extend({ month: z.string().regex(/^\d{4}-\d{2}$/) })),
  totals: ReportFiguresSchema,
});
export type LoyaltyReport = z.infer<typeof LoyaltyReportSchema>;
export class LoyaltyReportDto extends createZodDto(LoyaltyReportSchema) {}
