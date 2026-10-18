import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { PaymentProvider, PaymentStatus, RefundStatus, TicketStatus } from "../../database/prisma.types";

// Hoàn tiền phía Admin (TASK-ADM-002, FR-ADM-10, UC-27 A4, UC-32 bước 8, Security §8 "Refund thủ công"; Figma ADM-07c–d).
// Xem: `payment:monitor`. Thao tác (gửi lại cổng / ghi nhận đã hoàn / hoàn thanh toán cần đối soát): `finance:configure`
// + xác nhận lại danh tính + lý do + audit.

/**
 * Nguồn yêu cầu: khách hủy vé (hành khách / khách vãng lai), nhà xe hủy chuyến (TRN-008) hoặc Vé Xe Nhanh (Admin hoàn thanh toán
 * cần đối soát).
 */
export const REFUND_SOURCES = ["CUSTOMER", "OPERATOR", "PLATFORM"] as const;

export const AdminRefundSummarySchema = z.object({
  refundId: z.uuid(),
  refundCode: z.string(),
  bookingId: z.uuid(),
  bookingCode: z.string(),
  paymentId: z.uuid(),
  paymentCode: z.string(),
  provider: z.enum(PaymentProvider),
  operatorId: z.uuid(),
  operatorName: z.string(),
  source: z.enum(REFUND_SOURCES),
  /** VND. */
  amount: z.int(),
  refundPercent: z.int(),
  status: z.enum(RefundStatus),
  failureCode: z.string().nullable(),
  reason: z.string(),
  createdAt: z.iso.datetime(),
  updatedAt: z.iso.datetime(),
});
export type AdminRefundSummary = z.infer<typeof AdminRefundSummarySchema>;

export const AdminRefundPageSchema = z.object({ items: z.array(AdminRefundSummarySchema), nextCursor: z.uuid().nullable(), total: z.int() });
export type AdminRefundPage = z.infer<typeof AdminRefundPageSchema>;
/** Một trang yêu cầu hoàn tiền, mới trước. */
export class AdminRefundPageDto extends createZodDto(AdminRefundPageSchema) {}

export const AdminRefundDetailSchema = AdminRefundSummarySchema.extend({
  /** VND khách đã trả qua cổng. */
  paidAmount: z.int(),
  /** Thanh toán gốc đang cần đối soát (hoàn khoản trả muộn / trùng — không có vé). */
  paymentStatus: z.enum(PaymentStatus),
  attempt: z.int(),
  providerRefundId: z.string().nullable(),
  bankReference: z.string().nullable(),
  processedAt: z.iso.datetime().nullable(),
  tickets: z.array(z.object({ ticketCode: z.string(), seatCode: z.string(), status: z.enum(TicketStatus) })),
  /** Cũ trước. `actor`: `platform/{tên đăng nhập}` / `Khách hàng` / `null` = hệ thống. */
  histories: z.array(
    z.object({ fromStatus: z.enum(RefundStatus).nullable(), toStatus: z.enum(RefundStatus), reason: z.string().nullable(), actor: z.string().nullable(), createdAt: z.iso.datetime() }),
  ),
  /** Thao tác Admin làm được lúc này (chỉ refund `FAILED`). */
  canRetry: z.boolean(),
  canResolve: z.boolean(),
});
export type AdminRefundDetail = z.infer<typeof AdminRefundDetailSchema>;
/** Chi tiết một yêu cầu hoàn tiền. */
export class AdminRefundDetailDto extends createZodDto(AdminRefundDetailSchema) {}

export const AdminRefundListQuerySchema = z
  .object({
    from: z.iso.date().optional(),
    to: z.iso.date().optional(),
    operatorId: z.uuid().optional(),
    source: z.enum(REFUND_SOURCES).optional(),
    status: z.enum(RefundStatus).optional(),
    /** Mã hoàn tiền hoặc mã đặt vé. */
    q: z.string().trim().min(1).max(100).optional(),
    cursor: z.uuid().optional(),
    limit: z.coerce.number().int().min(1).max(100).default(20),
  })
  .refine((query) => !query.from || !query.to || query.from <= query.to, { message: "Khoảng ngày không hợp lệ.", path: ["to"] });
export class AdminRefundListQueryDto extends createZodDto(AdminRefundListQuerySchema) {}

const ReasonSchema = z.string().trim().min(3).max(500);
export const RefundReasonInputSchema = z.object({ reason: ReasonSchema });
export type RefundReasonInput = z.infer<typeof RefundReasonInputSchema>;
/** Lý do của thao tác (lưu lịch sử + audit). */
export class RefundReasonInputDto extends createZodDto(RefundReasonInputSchema) {}

export const RefundResolveInputSchema = z.object({
  /** Mã giao dịch ngân hàng (chuyển khoản tay) hoặc mã hoàn trên trang quản trị cổng. */
  reference: z.string().trim().min(3).max(64),
  reason: ReasonSchema,
});
export type RefundResolveInput = z.infer<typeof RefundResolveInputSchema>;
/** Ghi nhận đã hoàn ngoài luồng tự động. */
export class RefundResolveInputDto extends createZodDto(RefundResolveInputSchema) {}
