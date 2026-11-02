import { HttpStatus } from "@nestjs/common";
import type { DbTransaction } from "../database/prisma.service";
import { DiscountFunding, DiscountType } from "../database/prisma.types";
import { voucherProblem } from "../loyalty/passenger-loyalty.service";
import { claimPromotion, discountFor, evaluatePromotion, type AppliedPromotion } from "./promotion-apply";

type VoucherOffer = { id: string; source: string; status: string; promotion_id: string | null; discount_amount: bigint | null; expires_at: Date };

/**
 * Kiểm voucher của đúng hành khách; mã lưu trong ví vẫn kiểm toàn bộ điều kiện của mã gốc.
 * `claim` (mặc định, khi tạo booking) giữ lượt promotion; `claim: false` chỉ báo giá (POST /promotions/check), không giữ gì.
 */
export async function evaluateVoucher(tx: DbTransaction, userId: string | null, id: string, context: { operatorId: string; routeId: string; tripId: string; subtotal: bigint; now: Date }, options: { readonly claim: boolean } = { claim: true }): Promise<AppliedPromotion> {
  if (!userId) throw voucherProblem("VOUCHER_NOT_AVAILABLE", "Cần đăng nhập để dùng voucher của mình.", HttpStatus.UNPROCESSABLE_ENTITY);
  const [voucher] = await tx.$queryRaw<VoucherOffer[]>`SELECT * FROM voucher_offer(${id}, ${userId})`;
  if (!voucher || voucher.status !== "AVAILABLE") throw voucherProblem("VOUCHER_NOT_AVAILABLE", "Voucher không khả dụng hoặc đang dùng cho đơn khác.");
  if (voucher.expires_at <= context.now) throw voucherProblem("VOUCHER_EXPIRED", "Voucher đã hết hạn.", HttpStatus.UNPROCESSABLE_ENTITY);
  if (voucher.promotion_id) {
    const promotion = await tx.promotion.findUnique({ where: { id: voucher.promotion_id }, select: { code: true } });
    if (!promotion) throw voucherProblem("VOUCHER_NOT_APPLICABLE", "Khuyến mãi gốc không còn khả dụng.", HttpStatus.UNPROCESSABLE_ENTITY);
    const applied = options.claim ? await claimPromotion(tx, { ...context, code: promotion.code }) : await evaluatePromotion(tx, { ...context, code: promotion.code });
    return { promotionId: applied.promotionId, code: applied.code, name: applied.name, discount: applied.discount, fundedBy: applied.fundedBy, userVoucherId: id };
  }
  const discount = discountFor({ discountType: DiscountType.AMOUNT, discountValue: voucher.discount_amount!, maxDiscount: null, minOrder: 0n }, context.subtotal);
  if (discount <= 0n) throw voucherProblem("VOUCHER_NOT_APPLICABLE", "Voucher không giảm được cho đơn này.", HttpStatus.UNPROCESSABLE_ENTITY);
  return { promotionId: null, userVoucherId: id, code: "VXNPLUS", name: "Voucher VXN Plus", discount, fundedBy: DiscountFunding.PLATFORM };
}

/** Giữ voucher nguyên tử sau khi tạo booking trong cùng transaction. */
export async function reserveVoucher(tx: DbTransaction, id: string, userId: string, bookingId: string, operatorId: string, now: Date): Promise<void> {
  const [row] = await tx.$queryRaw<{ reserved: boolean }[]>`SELECT voucher_reserve(${id}, ${userId}, ${bookingId}, ${operatorId}, ${now}::timestamp) AS reserved`;
  if (!row?.reserved) throw voucherProblem("VOUCHER_NOT_AVAILABLE", "Voucher vừa được dùng cho đơn khác.");
}

/** Dùng / trả voucher theo vòng đời booking; nhà xe hủy chuyến được trả cả voucher đã dùng. */
export async function transitionVoucher(tx: DbTransaction, operatorId: string, bookingId: string, action: "USE" | "RELEASE" | "TRIP_CANCELLED", now: Date = new Date()): Promise<void> {
  await tx.$executeRaw`SELECT voucher_transition(${bookingId}, ${operatorId}, ${action}, ${now}::timestamp)`;
}
