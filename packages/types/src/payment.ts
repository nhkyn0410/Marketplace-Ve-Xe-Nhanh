import { z } from "zod";

/** Thông tin VietQR do cổng thanh toán trả về sau khi đã kiểm chữ ký. */
export const PaymentTransferSchema = z.object({
  qrCode: z.string().min(1),
  bin: z.string().min(1),
  accountNumber: z.string().min(1),
  accountName: z.string().min(1),
  amount: z.string().regex(/^[1-9]\d*$/),
  description: z.string().min(1),
  paymentLinkId: z.string().min(1),
});

/** Phương thức khách chọn để thanh toán đơn đặt vé. */
export const PaymentInputSchema = z.object({ provider: z.enum(["VNPAY", "MOMO", "PAYOS", "DEMO"]) });

/** Link thanh toán và thông tin chuyển khoản dành cho web và ứng dụng hành khách. */
export const PaymentResponseSchema = z.object({
  paymentId: z.uuid(),
  paymentCode: z.string(),
  provider: PaymentInputSchema.shape.provider,
  status: z.enum(["INITIATED", "PROCESSING", "SUCCESS", "FAILED", "EXPIRED", "CANCELLED", "RECONCILING"]),
  amount: z.int(),
  paymentUrl: z.string(),
  expiresAt: z.iso.datetime(),
  transfer: PaymentTransferSchema.optional(),
});

export type PaymentTransfer = z.infer<typeof PaymentTransferSchema>;
export type PaymentInput = z.infer<typeof PaymentInputSchema>;
export type PaymentResponse = z.infer<typeof PaymentResponseSchema>;
