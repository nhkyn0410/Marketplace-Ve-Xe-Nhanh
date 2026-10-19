import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { PolicyRuleStatus } from "../../database/prisma.types";
import { InstantSchema } from "../../trip/dto/trip.dto";

// API §7.5 `/admin/commission-rules` — hoa hồng mặc định + mức riêng theo nhà xe có ngày hiệu lực (FR-ADM-07, BR-31,
// OQ-18; Figma ADM-06c).

/** Tỷ lệ theo phần vạn: 450 = 4,5%. Số nguyên — không float (DB-PRIN-06). */
const RateBpsSchema = z.int().min(0).max(10_000);
const ReasonSchema = z.string().trim().min(3).max(500);

export const CommissionRuleInputSchema = z
  .object({
    rateBps: RateBpsSchema,
    effectiveFrom: InstantSchema,
    /** Không gồm; `null` = không thời hạn. */
    effectiveTo: InstantSchema.nullable(),
    reason: ReasonSchema,
  })
  .refine((input) => input.effectiveTo === null || input.effectiveTo > input.effectiveFrom, {
    path: ["effectiveTo"],
    message: "Ngày kết thúc phải sau ngày bắt đầu.",
  });
export type CommissionRuleInput = z.infer<typeof CommissionRuleInputSchema>;
export class CommissionRuleUpdateDto extends createZodDto(CommissionRuleInputSchema) {}

export const CommissionRuleCreateSchema = z
  .object({
    operatorId: z.uuid(),
    rateBps: RateBpsSchema,
    effectiveFrom: InstantSchema,
    effectiveTo: InstantSchema.nullable(),
    reason: ReasonSchema,
  })
  .refine((input) => input.effectiveTo === null || input.effectiveTo > input.effectiveFrom, {
    path: ["effectiveTo"],
    message: "Ngày kết thúc phải sau ngày bắt đầu.",
  });
export type CommissionRuleCreateInput = z.infer<typeof CommissionRuleCreateSchema>;
export class CommissionRuleCreateDto extends createZodDto(CommissionRuleCreateSchema) {}

export class CommissionRuleCancelDto extends createZodDto(z.object({ reason: ReasonSchema })) {}
export class CommissionRuleIdParamDto extends createZodDto(z.object({ id: z.uuid() })) {}

const CommissionRuleSchema = z.object({
  id: z.uuid(),
  operatorId: z.uuid(),
  operatorName: z.string(),
  operatorSlug: z.string(),
  rateBps: z.int(),
  effectiveFrom: z.iso.datetime(),
  effectiveTo: z.iso.datetime().nullable(),
  status: z.enum(PolicyRuleStatus),
  state: z.enum(["SCHEDULED", "ACTIVE", "EXPIRED", "CANCELLED"]),
  reason: z.string(),
  cancelReason: z.string().nullable(),
  createdBy: z.string().nullable(),
  createdAt: z.iso.datetime(),
});
export type CommissionRuleResponse = z.infer<typeof CommissionRuleSchema>;
export class CommissionRuleDto extends createZodDto(CommissionRuleSchema) {}

export const CommissionOverviewSchema = z.object({
  /** Mức mặc định đang áp dụng; `null` nếu chưa cấu hình. */
  default: z.object({ rateBps: z.int(), effectiveFrom: z.iso.datetime() }).nullable(),
  /** Mức riêng, mới bắt đầu trước. */
  overrides: z.array(CommissionRuleSchema),
});
export type CommissionOverview = z.infer<typeof CommissionOverviewSchema>;
export class CommissionOverviewDto extends createZodDto(CommissionOverviewSchema) {}
