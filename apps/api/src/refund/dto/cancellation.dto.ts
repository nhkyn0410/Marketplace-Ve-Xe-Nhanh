import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { RefundStatus, TicketStatus } from "../../database/prisma.types";
import { MAX_PASSENGERS } from "../../marketplace/dto/public-trip.dto";
import { BookingResponseSchema } from "../../booking/dto/booking.dto";

// API §7.2 hủy vé / yêu cầu hoàn tiền của hành khách / khách vãng lai (TASK-BTP-005, UC-08, FR-BTP-12/13).

const TicketIdsSchema = z.array(z.uuid()).min(1).max(MAX_PASSENGERS);

export class CancellationQuoteQueryDto extends createZodDto(
  z.object({
    /** Mã vé muốn hủy, phân tách bằng dấu phẩy. */
    ticketIds: z
      .string()
      .transform((value) => value.split(",").map((id) => id.trim()).filter(Boolean))
      .pipe(TicketIdsSchema),
  }),
) {}

export const CancellationQuoteSchema = z.object({
  /** Mọi vé của booking, kèm có hủy được không + lý do. */
  tickets: z.array(
    z.object({
      ticketId: z.uuid(),
      ticketCode: z.string(),
      seatCode: z.string(),
      passengerName: z.string(),
      companionName: z.string().nullable(),
      status: z.enum(TicketStatus),
      /** VND — giá vé lúc đặt. */
      price: z.int(),
      cancellable: z.boolean(),
      reason: z.string().nullable(),
    }),
  ),
  /** Mốc hủy đang áp dụng (chính sách lưu lúc đặt); `null` = đã qua mọi mốc → hoàn 0%. */
  tier: z.object({ minHoursBefore: z.int(), refundPercent: z.int() }).nullable(),
  refundPercent: z.int(),
  /** VND — tổng giá các vé đã chọn / số được hoàn / phần không hoàn. */
  selectedTotal: z.int(),
  refundAmount: z.int(),
  nonRefundable: z.int(),
});
export type CancellationQuote = z.infer<typeof CancellationQuoteSchema>;
/** Điều kiện hủy + số tiền dự kiến hoàn cho các vé đã chọn. */
export class CancellationQuoteDto extends createZodDto(CancellationQuoteSchema) {}

export const CancellationInputSchema = z.object({
  ticketIds: TicketIdsSchema.refine((ids) => new Set(ids).size === ids.length, { message: "Trùng vé." }),
  /**
   * Số tiền hoàn khách đã thấy ở bước xem điều kiện (VND). Qua mốc hủy giữa chừng làm số tiền đổi → 409
   * `REFUND_AMOUNT_CHANGED` kèm số mới; khách xem lại rồi xác nhận.
   */
  expectedRefund: z.int().min(0),
  reason: z
    .string()
    .trim()
    .max(500)
    .nullable()
    .transform((value) => value || null),
});
export type CancellationInput = z.infer<typeof CancellationInputSchema>;
/** Xác nhận hủy các vé đã chọn. */
export class CancellationInputDto extends createZodDto(CancellationInputSchema) {}

export const CancellationResultSchema = z.object({
  booking: BookingResponseSchema,
  /** Lần hoàn tiền vừa tạo; `null` khi số tiền hoàn = 0 (vẫn hủy vé — UC-08 A4). */
  refund: z.object({ refundCode: z.string(), amount: z.int(), status: z.enum(RefundStatus) }).nullable(),
});
export type CancellationResult = z.infer<typeof CancellationResultSchema>;
/** Kết quả hủy vé. */
export class CancellationResultDto extends createZodDto(CancellationResultSchema) {}
