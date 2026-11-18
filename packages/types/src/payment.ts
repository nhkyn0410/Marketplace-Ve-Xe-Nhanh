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

/**
 * Phương thức khách chọn để thanh toán đơn đặt vé. `client` = nơi khách thanh toán (PASSENGER-PARITY P4): `APP` nhận
 * địa chỉ quay về App Link để cổng mở lại ứng dụng; bỏ trống = `WEB` (trang kết quả của Marketplace).
 */
export const PaymentInputSchema = z.object({
  provider: z.enum(["VNPAY", "MOMO", "PAYOS", "DEMO"]),
  client: z.enum(["WEB", "APP"]).optional(),
});

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

/**
 * Các cổng thanh toán theo thứ tự hiển thị (SCR-PSG-20: payOS, MoMo, VNPay, DEMO) và cổng nào máy chủ đang bật.
 * Web và ứng dụng hành khách dựng danh sách phương thức từ đây thay vì ghi cứng.
 */
export const PaymentProviderListSchema = z.object({
  items: z.array(z.object({ provider: PaymentInputSchema.shape.provider, enabled: z.boolean() })),
});

export type PaymentTransfer = z.infer<typeof PaymentTransferSchema>;
export type PaymentProviderList = z.infer<typeof PaymentProviderListSchema>;
export type PaymentInput = z.infer<typeof PaymentInputSchema>;
export type PaymentResponse = z.infer<typeof PaymentResponseSchema>;
