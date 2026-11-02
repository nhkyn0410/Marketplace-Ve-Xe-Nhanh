import { z } from "zod";

const Vnd = z.string().regex(/^(0|[1-9]\d{0,18})$/).refine((value) => /^\d+$/.test(value) && BigInt(value) <= 9_223_372_036_854_775_807n, "Số tiền vượt giới hạn lưu trữ.");

export const CounterCommissionQuerySchema = z.object({
  operatorId: z.uuid(),
  from: z.iso.datetime({ offset: true }).optional(),
  to: z.iso.datetime({ offset: true }).optional(),
}).refine((query) => !query.from || !query.to || new Date(query.from) < new Date(query.to), "Khoảng ngày không hợp lệ.");
export type CounterCommissionQuery = z.infer<typeof CounterCommissionQuerySchema>;

export const CounterCommissionSettlementInputSchema = z.object({
  operatorId: z.uuid(),
  idempotencyKey: z.uuid(),
  amount: Vnd.refine((value) => /^\d+$/.test(value) && BigInt(value) > 0n, "Số tiền thu phải lớn hơn 0."),
  reference: z.string().trim().min(3).max(100).transform((value) => value.toUpperCase()),
  reason: z.string().trim().min(3).max(500),
});
export type CounterCommissionSettlementInput = z.infer<typeof CounterCommissionSettlementInputSchema>;

export const CounterCommissionSettlementSchema = z.object({
  id: z.uuid(), operatorId: z.uuid(), amount: Vnd, reference: z.string(), reason: z.string(), createdBy: z.string(), createdAt: z.iso.datetime(),
});
export type CounterCommissionSettlement = z.infer<typeof CounterCommissionSettlementSchema>;

export const CounterCommissionOverviewSchema = z.object({
  operatorId: z.uuid(),
  /** Tổng toàn bộ lịch sử, không bị giới hạn bởi khoảng ngày của danh sách. */
  accrued: Vnd, settled: Vnd, outstanding: Vnd,
  items: z.array(z.object({ id: z.uuid(), bookingId: z.uuid(), receiptId: z.uuid(), commissionRuleId: z.uuid().nullable(), rateBps: z.int().min(0).max(10000), basis: Vnd, amount: Vnd, createdAt: z.iso.datetime() })),
  settlements: z.array(CounterCommissionSettlementSchema),
});
export type CounterCommissionOverview = z.infer<typeof CounterCommissionOverviewSchema>;
