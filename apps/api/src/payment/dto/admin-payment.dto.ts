import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { BookingStatus, EscrowEntryType, PaymentProvider, PaymentStatus, RefundStatus, TicketStatus } from "../../database/prisma.types";

// Giám sát thanh toán toàn hệ thống (TASK-ADM-002, FR-ADM-10, FR-BTP-17, UC-32; Figma ADM-07a–b "Thanh toán & hoàn tiền").
// Admin + hỗ trợ nền tảng xem (`payment:monitor`); thao tác hoàn tiền ở `refund/`.

export const AdminPaymentSummarySchema = z.object({
  paymentId: z.uuid(),
  paymentCode: z.string(),
  bookingId: z.uuid(),
  bookingCode: z.string(),
  operatorId: z.uuid(),
  operatorName: z.string(),
  provider: z.enum(PaymentProvider),
  /** VND — tổng booking lúc tạo payment. */
  amount: z.int(),
  status: z.enum(PaymentStatus),
  /** Lý do cần đối soát (`BOOKING_EXPIRED`, `SEATS_RELEASED`, `DUPLICATE_PAYMENT`, `AMOUNT_MISMATCH`…). */
  reconcileReason: z.string().nullable(),
  failureCode: z.string().nullable(),
  /** Thanh toán cần đối soát đã có hướng xử lý (đã tạo hoàn tiền chưa thất bại). */
  reconcileResolved: z.boolean(),
  createdAt: z.iso.datetime(),
  paidAt: z.iso.datetime().nullable(),
});
export type AdminPaymentSummary = z.infer<typeof AdminPaymentSummarySchema>;

export const AdminPaymentPageSchema = z.object({
  items: z.array(AdminPaymentSummarySchema),
  nextCursor: z.uuid().nullable(),
  /** Tổng số giao dịch khớp bộ lọc ("Đã tải 6 / 12.480"). */
  total: z.int(),
  /** Số thanh toán cần đối soát chưa xử lý (nhãn tab, không theo bộ lọc). */
  reconcileOpen: z.int(),
});
export type AdminPaymentPage = z.infer<typeof AdminPaymentPageSchema>;
/** Một trang giao dịch thanh toán, mới trước. */
export class AdminPaymentPageDto extends createZodDto(AdminPaymentPageSchema) {}

export const AdminPaymentDetailSchema = AdminPaymentSummarySchema.extend({
  providerTxnId: z.string().nullable(),
  expiresAt: z.iso.datetime(),
  /** Callback đã xác thực gần nhất của cổng. */
  lastCallbackAt: z.iso.datetime().nullable(),
  /** Số tiền cổng báo khớp đơn — `null` khi cổng chưa báo thành công. */
  amountMatches: z.boolean().nullable(),
  booking: z.object({
    status: z.enum(BookingStatus),
    routeName: z.string(),
    departureAt: z.iso.datetime(),
    /** Tên người liên hệ đã che (`Nguyễn Văn K***`). */
    contactName: z.string(),
    seatCodes: z.array(z.string()),
    /** VND: giá vé, phí dịch vụ, giảm giá, tổng khách trả. */
    subtotal: z.int(),
    serviceFee: z.int(),
    discount: z.int(),
    total: z.int(),
    createdAt: z.iso.datetime(),
  }),
  /** Phân bổ theo sổ giữ hộ (BTP-006); `null` khi tiền chưa vào sổ (chưa thành công / cần đối soát). */
  allocation: z.object({ commissionAmount: z.int(), commissionRateBps: z.int().nullable(), operatorNet: z.int() }).nullable(),
  histories: z.array(
    z.object({ fromStatus: z.enum(PaymentStatus).nullable(), toStatus: z.enum(PaymentStatus), reason: z.string().nullable(), actor: z.string().nullable(), createdAt: z.iso.datetime() }),
  ),
  /** Vé phát hành từ thanh toán này. */
  tickets: z.array(z.object({ ticketCode: z.string(), seatCode: z.string(), status: z.enum(TicketStatus), issuedAt: z.iso.datetime() })),
  /** Bút toán sổ giữ hộ ghi theo thanh toán này. */
  ledger: z.array(z.object({ entryType: z.enum(EscrowEntryType), amount: z.int(), eligibleAt: z.iso.datetime(), createdAt: z.iso.datetime() })),
  refunds: z.array(z.object({ refundId: z.uuid(), refundCode: z.string(), status: z.enum(RefundStatus), amount: z.int(), createdAt: z.iso.datetime() })),
  /** Admin hoàn toàn bộ được (thanh toán cần đối soát chưa xử lý, không lệch số tiền). */
  canRefund: z.boolean(),
});
export type AdminPaymentDetail = z.infer<typeof AdminPaymentDetailSchema>;
/** Chi tiết một giao dịch thanh toán. */
export class AdminPaymentDetailDto extends createZodDto(AdminPaymentDetailSchema) {}

export const AdminPaymentListQuerySchema = z
  .object({
    /** Ngày tạo theo giờ VN (`YYYY-MM-DD`), gồm cả hai đầu. */
    from: z.iso.date().optional(),
    to: z.iso.date().optional(),
    operatorId: z.uuid().optional(),
    provider: z.enum(PaymentProvider).optional(),
    status: z.enum(PaymentStatus).optional(),
    /** `open` = chỉ thanh toán cần đối soát chưa xử lý (tab "Cần đối soát"). */
    reconcile: z.enum(["open"]).optional(),
    /** Mã thanh toán, mã đặt vé hoặc mã giao dịch cổng. */
    q: z.string().trim().min(1).max(100).optional(),
    cursor: z.uuid().optional(),
    limit: z.coerce.number().int().min(1).max(100).default(20),
  })
  .refine((query) => !query.from || !query.to || query.from <= query.to, { message: "Khoảng ngày không hợp lệ.", path: ["to"] });
export class AdminPaymentListQueryDto extends createZodDto(AdminPaymentListQuerySchema) {}
