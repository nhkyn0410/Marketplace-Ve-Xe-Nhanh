import { createZodDto } from "nestjs-zod";
import { PaymentInputSchema, PaymentResponseSchema } from "@vexenhanh/types";
export { PaymentInputSchema, PaymentResponseSchema } from "@vexenhanh/types";
export type { PaymentInput, PaymentResponse } from "@vexenhanh/types";

// API §7.2 `POST /bookings/{bookingId}/payments` — tạo payment qua cổng (TASK-BTP-003, FR-BTP-07, ADR-019).

/** Chọn cổng thanh toán. */
export class PaymentInputDto extends createZodDto(PaymentInputSchema) {}

/** Payment đang chờ khách thanh toán ở cổng. */
export class PaymentResponseDto extends createZodDto(PaymentResponseSchema) {}
