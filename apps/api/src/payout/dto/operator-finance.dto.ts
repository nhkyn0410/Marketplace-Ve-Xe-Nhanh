import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { PayoutStatus } from "../../database/prisma.types";

// API §7.3 `/operator/finance/*`, `/operator/payouts*` — màn Tài chính của nhà xe (TASK-OPR-002, FR-OPR-07/08; Figma
// "Nhà xe · Tài chính" 01–03): tiền vé Vé Xe Nhanh giữ hộ, hoa hồng, hoàn tiền và các kỳ chi trả của chính nhà xe.

export const FinanceSummarySchema = z.object({
  /** VND — tổng sổ giữ hộ (đã thu, chưa chi). */
  heldBalance: z.int(),
  /** Đã qua T+N kể từ chuyến đến nơi, chưa vào kỳ chi trả (không gồm booking còn hoàn tiền treo). */
  eligibleAmount: z.int(),
  /** Chuyến chưa tới hoặc chưa đủ T+N. */
  pendingAmount: z.int(),
  /** Kỳ đã chi gần nhất. */
  lastPayout: z.object({ payoutId: z.uuid(), amount: z.int(), paidAt: z.iso.datetime() }).nullable(),
  /** Số ngày chờ sau khi chuyến đến nơi (chính sách chi trả đang áp dụng). */
  payoutDelayDays: z.int(),
});
export type FinanceSummary = z.infer<typeof FinanceSummarySchema>;
/** Số liệu đầu màn Tài chính. */
export class FinanceSummaryDto extends createZodDto(FinanceSummarySchema) {}

/** Tình trạng tiền của một đơn: chờ chuyến / đang giữ (hoàn tiền treo) / đủ điều kiện / trong kỳ chưa chi / đã chi / đã hoàn hết. */
export const FINANCE_STATES = ["WAITING_TRIP", "ON_HOLD", "ELIGIBLE", "IN_PAYOUT", "PAID", "REFUNDED"] as const;

export class FinanceBookingQueryDto extends createZodDto(
  z.object({
    /** Ngày khởi hành từ / tới (giờ VN, gồm cả hai đầu). */
    from: z.iso.date(),
    to: z.iso.date(),
    routeId: z.uuid().optional(),
    state: z.enum(FINANCE_STATES).optional(),
    /** Mã đặt vé. */
    q: z.string().trim().min(1).max(20).optional(),
    cursor: z.uuid().optional(),
    limit: z.coerce.number().int().min(1).max(100).default(20),
  }),
) {}

export const FinanceBookingSchema = z.object({
  bookingId: z.uuid(),
  bookingCode: z.string(),
  trip: z.object({ tripId: z.uuid(), departureAt: z.iso.datetime(), arrivalAt: z.iso.datetime(), routeName: z.string() }),
  /** VND: tiền khách trả, hoa hồng ròng, hoàn / điều chỉnh (âm), nhà xe nhận. */
  grossAmount: z.int(),
  commissionAmount: z.int(),
  refundAdjustmentAmount: z.int(),
  netAmount: z.int(),
  state: z.enum(FINANCE_STATES),
  /** Lúc tiền đủ điều kiện chi trả. */
  eligibleAt: z.iso.datetime(),
});
export type FinanceBooking = z.infer<typeof FinanceBookingSchema>;

export const FinanceBookingPageSchema = z.object({ items: z.array(FinanceBookingSchema), nextCursor: z.uuid().nullable() });
export type FinanceBookingPage = z.infer<typeof FinanceBookingPageSchema>;
/** Một trang giao dịch theo đơn, chuyến mới trước. */
export class FinanceBookingPageDto extends createZodDto(FinanceBookingPageSchema) {}

export class OperatorPayoutQueryDto extends createZodDto(
  z.object({
    /** Tháng của kỳ chi trả `YYYY-MM` (giờ VN). */
    month: z.string().regex(/^\d{4}-(0[1-9]|1[0-2])$/).optional(),
    status: z.enum(PayoutStatus).optional(),
    cursor: z.uuid().optional(),
    limit: z.coerce.number().int().min(1).max(100).default(20),
  }),
) {}
