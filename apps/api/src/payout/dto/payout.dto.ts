import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { PayoutStatus } from "../../database/prisma.types";

// Kỳ chi trả cho nhà xe (TASK-BTP-006, ADR-022, SRS §17.10) — dùng chung cho màn Admin "Chi trả nhà xe" (Figma ADM-08a–c,
// TASK-ADM-002) và màn Tài chính của nhà xe (Figma "Nhà xe · Tài chính" 02–03, TASK-OPR-002).

const ActorSchema = z.string().nullable();

export const PayoutSummarySchema = z.object({
  payoutId: z.uuid(),
  payoutCode: z.string(),
  operatorId: z.uuid(),
  operatorName: z.string(),
  /** Ngày tạo kỳ (giờ VN, `YYYY-MM-DD`). */
  period: z.iso.date(),
  status: z.enum(PayoutStatus),
  /** VND: đủ điều kiện (tiền khách trả), hoa hồng ròng, hoàn tiền, điều chỉnh, thực chi. */
  grossAmount: z.int(),
  commissionAmount: z.int(),
  refundAmount: z.int(),
  adjustmentAmount: z.int(),
  amount: z.int(),
  commissionRateBps: z.int().nullable(),
  holdReason: z.string().nullable(),
  /** Tài khoản nhận tiền chụp lúc tạo kỳ — số tài khoản đã che (`•••• 4521`). `null` = chưa có tài khoản đã xác minh. */
  bank: z.object({ bankName: z.string(), accountNumberMasked: z.string(), accountHolder: z.string() }).nullable(),
  paidAt: z.iso.datetime().nullable(),
  createdAt: z.iso.datetime(),
});
export type PayoutSummary = z.infer<typeof PayoutSummarySchema>;
/** Một kỳ chi trả trong danh sách. */
export class PayoutSummaryDto extends createZodDto(PayoutSummarySchema) {}

export const PayoutPageSchema = z.object({ items: z.array(PayoutSummarySchema), nextCursor: z.uuid().nullable() });
export type PayoutPage = z.infer<typeof PayoutPageSchema>;
/** Một trang kỳ chi trả, mới trước. */
export class PayoutPageDto extends createZodDto(PayoutPageSchema) {}

export const PayoutDetailSchema = PayoutSummarySchema.extend({
  /** Theo chuyến (Figma "Chuyến trong kỳ"): bút toán không gắn chuyến (điều chỉnh) gom dòng `tripId = null`. */
  trips: z.array(
    z.object({
      tripId: z.uuid().nullable(),
      departureAt: z.iso.datetime().nullable(),
      routeName: z.string().nullable(),
      vehiclePlateNumber: z.string().nullable(),
      bookingCount: z.int(),
      grossAmount: z.int(),
      commissionAmount: z.int(),
      refundAdjustmentAmount: z.int(),
      amount: z.int(),
    }),
  ),
  /** Kiểm tra trước khi chi (Figma ADM-08b). */
  checks: z.object({ ledgerMatches: z.boolean(), noPendingRefunds: z.boolean(), bankVerified: z.boolean() }),
  bankReference: z.string().nullable(),
  transferredAt: z.iso.datetime().nullable(),
  confirmationNote: z.string().nullable(),
  cancelReason: z.string().nullable(),
  /** Tiến trình, cũ trước. `actor`: tên đăng nhập Admin (màn Admin) / `Vé Xe Nhanh` (màn nhà xe) / `null` = hệ thống. */
  histories: z.array(z.object({ fromStatus: z.enum(PayoutStatus).nullable(), toStatus: z.enum(PayoutStatus), reason: z.string().nullable(), actor: ActorSchema, createdAt: z.iso.datetime() })),
});
export type PayoutDetail = z.infer<typeof PayoutDetailSchema>;
/** Chi tiết kỳ chi trả. */
export class PayoutDetailDto extends createZodDto(PayoutDetailSchema) {}

export class AdminPayoutListQueryDto extends createZodDto(
  z.object({
    period: z.iso.date().optional(),
    operatorId: z.uuid().optional(),
    status: z.enum(PayoutStatus).optional(),
    /** Mã chi trả hoặc tên nhà xe. */
    q: z.string().trim().min(1).max(100).optional(),
    cursor: z.uuid().optional(),
    limit: z.coerce.number().int().min(1).max(100).default(20),
  }),
) {}

export const AdminPayoutStatsSchema = z.object({
  pendingReview: z.object({ count: z.int(), amount: z.int() }),
  readyToTransfer: z.object({ count: z.int(), amount: z.int() }),
  onHold: z.object({ count: z.int(), amount: z.int() }),
  /** Đã chi trong tháng hiện tại (giờ VN). */
  paidThisMonth: z.object({ count: z.int(), amount: z.int() }),
});
export type AdminPayoutStats = z.infer<typeof AdminPayoutStatsSchema>;
/** Số liệu đầu màn Chi trả nhà xe. */
export class AdminPayoutStatsDto extends createZodDto(AdminPayoutStatsSchema) {}

const ReasonSchema = z.string().trim().min(1).max(500);
export class PayoutReasonInputDto extends createZodDto(z.object({ reason: ReasonSchema })) {}

export const PayoutConfirmInputSchema = z.object({
  /** Mã giao dịch ngân hàng (sao kê). */
  bankReference: z.string().trim().min(3).max(64),
  /** Thời điểm chuyển khoản theo sao kê — không ở tương lai. */
  transferredAt: z.iso.datetime({ offset: true }).transform((value) => new Date(value)),
  note: ReasonSchema,
});
export type PayoutConfirmInput = z.infer<typeof PayoutConfirmInputSchema>;
/** Xác nhận đã chuyển khoản (Figma ADM-08c). */
export class PayoutConfirmInputDto extends createZodDto(PayoutConfirmInputSchema) {}

export const PayoutBankAccountSchema = z.object({ bankName: z.string(), accountNumber: z.string(), accountHolder: z.string() });
export type PayoutBankAccount = z.infer<typeof PayoutBankAccountSchema>;
/** Số tài khoản đầy đủ (mỗi lần xem ghi audit). */
export class PayoutBankAccountDto extends createZodDto(PayoutBankAccountSchema) {}
