import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { PaymentProvider, PaymentStatus } from "../../database/prisma.types";

// API §7.2 `POST /bookings/{bookingId}/payments` — tạo payment qua cổng (TASK-BTP-003, FR-BTP-07, ADR-019).

export const PaymentInputSchema = z.object({ provider: z.enum(PaymentProvider) });
export type PaymentInput = z.infer<typeof PaymentInputSchema>;
/** Chọn cổng thanh toán. */
export class PaymentInputDto extends createZodDto(PaymentInputSchema) {}

export const PaymentResponseSchema = z.object({
  paymentId: z.uuid(),
  paymentCode: z.string(),
  provider: z.enum(PaymentProvider),
  status: z.enum(PaymentStatus),
  /** VND. */
  amount: z.int(),
  /** Mở link này (trình duyệt / app) để thanh toán ở cổng; kết quả lấy ở `GET /bookings/{bookingId}` (`payment`). */
  paymentUrl: z.string(),
  expiresAt: z.iso.datetime(),
});
export type PaymentResponse = z.infer<typeof PaymentResponseSchema>;
/** Payment đang chờ khách thanh toán ở cổng. */
export class PaymentResponseDto extends createZodDto(PaymentResponseSchema) {}
