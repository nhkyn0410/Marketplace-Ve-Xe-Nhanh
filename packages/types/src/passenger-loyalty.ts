import { z } from "zod";

/** Truy vấn sổ điểm của chính hành khách, có lọc loại và thời gian. */
export const PassengerLoyaltyTransactionsQuerySchema = z.object({
  offset: z.coerce.number().int().min(0).default(0),
  limit: z.coerce.number().int().min(1).max(50).default(20),
  type: z.enum(["EARN", "REDEEM", "EXPIRE", "ADJUST", "REVERSAL"]).optional(),
  from: z.iso.datetime({ offset: true }).optional(),
  to: z.iso.datetime({ offset: true }).optional(),
}).refine((input) => !input.from || !input.to || Date.parse(input.from) <= Date.parse(input.to), { message: "Thời gian kết thúc phải sau thời gian bắt đầu.", path: ["to"] });

/** Đổi một số điểm nguyên lấy voucher theo chính sách hiện hành. */
export const LoyaltyRedemptionInputSchema = z.object({ points: z.int().min(1).max(1_000_000) });

/** Lưu một mã khuyến mãi công khai vào ví. */
export const SaveVoucherInputSchema = z.object({ promotionCode: z.string().trim().toUpperCase().regex(/^[A-Z0-9]{3,20}$/) });

/** Truy vấn ví voucher của chính hành khách. */
export const VoucherListQuerySchema = z.object({
  status: z.enum(["AVAILABLE", "RESERVED", "USED", "EXPIRED"]).optional(),
  offset: z.coerce.number().int().min(0).default(0),
  limit: z.coerce.number().int().min(1).max(50).default(20),
});

/** Voucher và điều kiện hiện tại để hành khách chọn khi đặt vé. */
export const UserVoucherSchema = z.object({
  userVoucherId: z.uuid(),
  source: z.enum(["LOYALTY_REDEMPTION", "SAVED_PROMOTION"]),
  status: z.enum(["AVAILABLE", "RESERVED", "USED", "EXPIRED"]),
  promotionCode: z.string().nullable(),
  name: z.string(),
  discountAmount: z.string().nullable(),
  discountType: z.enum(["PERCENT", "AMOUNT"]),
  discountValue: z.string(),
  maxDiscount: z.string().nullable(),
  minOrder: z.string(),
  expiresAt: z.iso.datetime(),
  createdAt: z.iso.datetime(),
});
export type UserVoucher = z.infer<typeof UserVoucherSchema>;

/** Trang ví voucher, mới nhất trước. */
export const UserVoucherPageSchema = z.object({ items: z.array(UserVoucherSchema), total: z.int() });
