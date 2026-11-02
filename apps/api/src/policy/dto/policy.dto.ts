import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { PolicyRuleStatus, PolicyType, PolicyVersionStatus } from "../../database/prisma.types";
import { InstantSchema } from "../../trip/dto/trip.dto";

// API §7.5 `/admin/policies*`, `/admin/policy-versions/*`, `/admin/fare-bands*` — chính sách nền tảng có phiên bản
// (FR-ADM-06/08/09, UC-25, AS-23; Figma ADM-06a…06d).

/** Một mốc hủy: hủy khi còn ≥ `minHoursBefore` giờ trước giờ khởi hành thì hoàn `refundPercent`% (BR-07, OQ-13). */
const CancellationTierSchema = z.strictObject({
  minHoursBefore: z.int().min(0).max(720),
  refundPercent: z.int().min(0).max(100),
});

/**
 * Hủy / hoàn tiền: các mốc sắp theo giờ giảm dần, phải có mốc 0 giờ (phủ mọi thời điểm), không trùng mốc; càng sát giờ
 * khởi hành mức hoàn không được cao hơn mốc xa hơn.
 */
export const CancellationRulesSchema = z
  .strictObject({ tiers: z.array(CancellationTierSchema).min(1).max(10) })
  .transform((rules) => ({ tiers: [...rules.tiers].sort((a, b) => b.minHoursBefore - a.minHoursBefore) }))
  .superRefine((rules, ctx) => {
    const hours = rules.tiers.map((tier) => tier.minHoursBefore);
    if (new Set(hours).size !== hours.length) {
      ctx.addIssue({ code: "custom", path: ["tiers"], message: "Hai mốc trùng số giờ." });
    }
    if (!hours.includes(0)) {
      ctx.addIssue({ code: "custom", path: ["tiers"], message: "Cần một mốc 0 giờ (hủy sát giờ khởi hành)." });
    }
    rules.tiers.forEach((tier, index) => {
      const farther = rules.tiers[index - 1];
      if (farther && tier.refundPercent > farther.refundPercent) {
        ctx.addIssue({ code: "custom", path: ["tiers", index, "refundPercent"], message: "Hủy càng sát giờ thì mức hoàn không được cao hơn." });
      }
    });
  });

/** Giữ chỗ: v1 chỉ cấp nền tảng (BR-02), mặc định 10 phút (OQ-06). */
export const SeatHoldRulesSchema = z.strictObject({ holdMinutes: z.int().min(5).max(30) });

/** Chi trả: chu kỳ T+n sau khi chuyến hoàn thành; kênh chuyển khoản + Admin xác nhận thủ công là bắt buộc (UC-25 A6, BR-32). */
export const PayoutRulesSchema = z.strictObject({
  delayDays: z.int().min(1).max(30),
  channel: z.literal("BANK_TRANSFER"),
  manualConfirmation: z.literal(true),
  /**
   * v1 không đặt ngưỡng tối thiểu (BR-32) nên luôn `null`. Khai kiểu số nguyên VND có thể `null` thay vì `z.null()`:
   * schema chỉ-`null` làm Dart client sinh lớp `ModelNull` không build được.
   */
  minimumAmount: z
    .int()
    .min(0)
    .nullable()
    .refine((amount) => amount === null, { message: "v1 không đặt ngưỡng tối thiểu chi trả." }),
});

/** Mã hạng VXN Plus theo thứ tự (FR-LOY-03); mốc + hệ số do Admin cấu hình. */
export const LOYALTY_TIERS = ["BRONZE", "SILVER", "GOLD", "PLATINUM"] as const;

/** Một hạng: từ `minPoints` điểm tích trong 12 tháng, hệ số tích `multiplierPercent`% (BR-66, BR-68). */
const LoyaltyTierRuleSchema = z.strictObject({
  tier: z.enum(LOYALTY_TIERS),
  minPoints: z.int().min(0).max(10_000_000),
  multiplierPercent: z.int().min(100).max(500),
});

/**
 * VXN Plus (FR-LOY-10, Figma ADM-12a): đơn vị tích (₫ cho 1 điểm), giá trị quy đổi (₫ mỗi điểm khi đổi voucher), số điểm đổi
 * tối thiểu, hạn điểm (tháng từ ngày tích), hạn voucher (ngày); đủ 4 hạng theo thứ tự, hạng đầu từ 0 điểm, mốc tăng dần và hệ
 * số không giảm.
 */
const LoyaltyRulesObjectSchema = z.strictObject({
  earnUnit: z.int().min(1_000).max(1_000_000),
  pointValue: z.int().min(1).max(100_000),
  minRedeemPoints: z.int().min(1).max(1_000_000),
  pointExpiryMonths: z.int().min(1).max(60),
  voucherValidityDays: z.int().min(1).max(365),
  tiers: z.array(LoyaltyTierRuleSchema).length(LOYALTY_TIERS.length),
});
export const LoyaltyRulesSchema = LoyaltyRulesObjectSchema.superRefine((rules, ctx) => {
  rules.tiers.forEach((tier, index) => {
    if (tier.tier !== LOYALTY_TIERS[index]) {
      ctx.addIssue({ code: "custom", path: ["tiers", index, "tier"], message: "Các hạng phải theo thứ tự Đồng, Bạc, Vàng, Bạch kim." });
      return;
    }
    const lower = rules.tiers[index - 1];
    if (!lower && tier.minPoints !== 0) {
      ctx.addIssue({ code: "custom", path: ["tiers", index, "minPoints"], message: "Hạng Đồng bắt đầu từ 0 điểm." });
    }
    if (lower && tier.minPoints <= lower.minPoints) {
      ctx.addIssue({ code: "custom", path: ["tiers", index, "minPoints"], message: "Mốc điểm của hạng cao hơn phải lớn hơn hạng dưới." });
    }
    if (lower && tier.multiplierPercent < lower.multiplierPercent) {
      ctx.addIssue({ code: "custom", path: ["tiers", index, "multiplierPercent"], message: "Hệ số của hạng cao hơn không được thấp hơn hạng dưới." });
    }
  });
});
export type LoyaltyRules = z.infer<typeof LoyaltyRulesSchema>;

export const RULE_SCHEMAS = {
  [PolicyType.CANCELLATION]: CancellationRulesSchema,
  [PolicyType.SEAT_HOLD]: SeatHoldRulesSchema,
  [PolicyType.PAYOUT]: PayoutRulesSchema,
  [PolicyType.LOYALTY]: LoyaltyRulesSchema,
} as const;

export type CancellationRules = z.infer<typeof CancellationRulesSchema>;

const PolicyRulesSchema = z.union([
  z.strictObject({ tiers: z.array(CancellationTierSchema) }),
  SeatHoldRulesSchema,
  PayoutRulesSchema,
  LoyaltyRulesObjectSchema,
]);

export class PolicyTypeParamDto extends createZodDto(z.object({ type: z.enum(PolicyType) })) {}
export class PolicyIdParamDto extends createZodDto(z.object({ id: z.uuid() })) {}

export const PolicyOverviewQuerySchema = z.object({
  /** Phạm vi riêng của một nhà xe (chỉ hủy / hoàn tiền); bỏ trống = mặc định nền tảng. */
  operatorId: z.uuid().optional(),
});
export class PolicyOverviewQueryDto extends createZodDto(PolicyOverviewQuerySchema) {}

export const PolicyDraftInputSchema = z.object({
  rules: PolicyRulesSchema,
  description: z
    .string()
    .trim()
    .max(1000)
    .nullable()
    .transform((value) => value || null),
  /** Có thể để trống khi lưu nháp; bắt buộc và phải ở tương lai khi kích hoạt. */
  effectiveFrom: InstantSchema.nullable(),
});
export type PolicyDraftInput = z.infer<typeof PolicyDraftInputSchema>;
export class PolicyDraftUpdateDto extends createZodDto(PolicyDraftInputSchema) {}

export const PolicyDraftCreateSchema = PolicyDraftInputSchema.extend({
  /** Chỉ hủy / hoàn tiền có chính sách riêng theo nhà xe (OQ-13); `null` = mặc định nền tảng. */
  operatorId: z.uuid().nullable(),
});
export type PolicyDraftCreateInput = z.infer<typeof PolicyDraftCreateSchema>;
export class PolicyDraftCreateDto extends createZodDto(PolicyDraftCreateSchema) {}

const ReasonSchema = z.string().trim().min(3).max(500);
export const PolicyPublishInputSchema = z.object({ changeReason: ReasonSchema });
export class PolicyPublishDto extends createZodDto(PolicyPublishInputSchema) {}
export const PolicyCancelInputSchema = z.object({ reason: ReasonSchema });
export class PolicyCancelDto extends createZodDto(PolicyCancelInputSchema) {}

/** Trạng thái hiển thị: suy từ `status` + thời điểm hiệu lực so với các phiên bản khác cùng phạm vi. */
export const POLICY_STATES = ["DRAFT", "SCHEDULED", "ACTIVE", "EXPIRED", "CANCELLED"] as const;
export type PolicyState = (typeof POLICY_STATES)[number];

export const PolicyVersionSchema = z.object({
  id: z.uuid(),
  type: z.enum(PolicyType),
  operatorId: z.uuid().nullable(),
  operatorName: z.string().nullable(),
  version: z.int(),
  status: z.enum(PolicyVersionStatus),
  state: z.enum(POLICY_STATES),
  rules: PolicyRulesSchema,
  description: z.string().nullable(),
  changeReason: z.string().nullable(),
  effectiveFrom: z.iso.datetime().nullable(),
  /** Tên đăng nhập người tạo (`platform/khanh`); `null` = dữ liệu nền do hệ thống tạo. */
  createdBy: z.string().nullable(),
  publishedAt: z.iso.datetime().nullable(),
  createdAt: z.iso.datetime(),
  updatedAt: z.iso.datetime(),
});
export type PolicyVersionResponse = z.infer<typeof PolicyVersionSchema>;
export class PolicyVersionDto extends createZodDto(PolicyVersionSchema) {}

export const PolicyOverviewSchema = z.object({
  type: z.enum(PolicyType),
  operatorId: z.uuid().nullable(),
  operatorName: z.string().nullable(),
  /** Mới nhất trước. */
  versions: z.array(PolicyVersionSchema),
  /** Nhà xe đang hoạt động (để tính "nhà xe áp dụng mặc định"). */
  activeOperatorCount: z.int(),
  /** Nhà xe có chính sách hủy / hoàn tiền riêng đang áp dụng hoặc đã lên lịch (chỉ loại hủy / hoàn tiền). */
  overrides: z.array(
    z.object({ operatorId: z.uuid(), operatorName: z.string(), operatorSlug: z.string(), state: z.enum(POLICY_STATES) }),
  ),
});
export type PolicyOverview = z.infer<typeof PolicyOverviewSchema>;
export class PolicyOverviewDto extends createZodDto(PolicyOverviewSchema) {}

// ── Khung giá trần / sàn theo dịp (FR-ADM-09, OQ-17) ──

const PriceSchema = z.int().min(0).max(100_000_000);

export const FareBandInputSchema = z
  .object({
    name: z.string().trim().min(3).max(100),
    minPrice: PriceSchema.nullable(),
    maxPrice: PriceSchema.nullable(),
    effectiveFrom: InstantSchema,
    effectiveTo: InstantSchema,
    /** Nội dung cảnh báo hiện cho nhà xe. */
    message: z.string().trim().min(3).max(500),
    reason: ReasonSchema,
  })
  .superRefine((input, ctx) => {
    if (input.minPrice === null && input.maxPrice === null) {
      ctx.addIssue({ code: "custom", path: ["maxPrice"], message: "Nhập giá sàn hoặc giá trần." });
    }
    if (input.minPrice !== null && input.maxPrice !== null && input.minPrice > input.maxPrice) {
      ctx.addIssue({ code: "custom", path: ["maxPrice"], message: "Giá trần phải lớn hơn hoặc bằng giá sàn." });
    }
    if (input.effectiveTo.getTime() <= input.effectiveFrom.getTime()) {
      ctx.addIssue({ code: "custom", path: ["effectiveTo"], message: "Ngày kết thúc phải sau ngày bắt đầu." });
    }
  });
export type FareBandInput = z.infer<typeof FareBandInputSchema>;
export class FareBandCreateDto extends createZodDto(FareBandInputSchema) {}

export const RULE_STATES = ["SCHEDULED", "ACTIVE", "EXPIRED", "CANCELLED"] as const;

export const FareBandSchema = z.object({
  id: z.uuid(),
  name: z.string(),
  minPrice: z.int().nullable(),
  maxPrice: z.int().nullable(),
  effectiveFrom: z.iso.datetime(),
  effectiveTo: z.iso.datetime(),
  message: z.string(),
  reason: z.string(),
  status: z.enum(PolicyRuleStatus),
  state: z.enum(RULE_STATES),
  cancelReason: z.string().nullable(),
  createdBy: z.string().nullable(),
  createdAt: z.iso.datetime(),
});
export type FareBandResponse = z.infer<typeof FareBandSchema>;
export class FareBandDto extends createZodDto(FareBandSchema) {}

export const FareBandListSchema = z.object({ items: z.array(FareBandSchema) });
export type FareBandList = z.infer<typeof FareBandListSchema>;
export class FareBandListDto extends createZodDto(FareBandListSchema) {}
