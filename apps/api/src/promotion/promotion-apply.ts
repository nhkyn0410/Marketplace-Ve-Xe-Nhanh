import type { DbTransaction } from "../database/prisma.service";
import { DiscountFunding, DiscountType, PromotionScope, PromotionStatus, RedemptionStatus } from "../database/prisma.types";
import { promotionExhausted, promotionInvalid } from "./promotion.errors";
import { transitionVoucher } from "./voucher-apply";

/** Số tiền tối thiểu khách phải trả sau giảm (BR-72 "không thấp hơn mức tối thiểu của cổng" — VNPay / MoMo nhận từ vài nghìn đồng). */
export const MIN_PAYABLE = 10_000n;
const VN_OFFSET_MS = 7 * 3_600_000;

export type PromotionRule = { discountType: DiscountType; discountValue: bigint; maxDiscount: bigint | null; minOrder: bigint };

/** Số tiền giảm cho một đơn (BIGINT VND): phần trăm làm tròn xuống + trần; số tiền cố định không vượt tiền vé; đơn chưa đạt tối thiểu → 0. */
export function discountFor(rule: PromotionRule, subtotal: bigint): bigint {
  if (subtotal < rule.minOrder || subtotal <= 0n) {
    return 0n;
  }
  const raw = rule.discountType === DiscountType.PERCENT ? (subtotal * rule.discountValue) / 100n : rule.discountValue;
  const capped = rule.maxDiscount !== null && raw > rule.maxDiscount ? rule.maxDiscount : raw;
  // Không giảm tới mức khách trả dưới mức tối thiểu của cổng.
  const ceiling = subtotal > MIN_PAYABLE ? subtotal - MIN_PAYABLE : 0n;
  return capped > ceiling ? ceiling : capped;
}

/** Đầu tháng (giờ VN) của một mốc — tính ngân sách tháng của nhà xe. */
export function vnMonthStart(at: Date): Date {
  const local = new Date(at.getTime() + VN_OFFSET_MS);
  return new Date(Date.UTC(local.getUTCFullYear(), local.getUTCMonth(), 1) - VN_OFFSET_MS);
}

export type AppliedPromotion = { promotionId: string | null; userVoucherId?: string; code: string; name: string; discount: bigint; fundedBy: DiscountFunding };

type Context = { operatorId: string; routeId: string; tripId: string; subtotal: bigint; code: string; now: Date };

/** Kiểm mã cho một đơn (FR-PROM-05) — không giữ lượt dùng. Dùng cho bước báo trước số tiền giảm và trong transaction tạo đơn. */
export async function evaluatePromotion(tx: DbTransaction, context: Context): Promise<AppliedPromotion & { promotionScope: PromotionScope }> {
  const code = context.code.trim().toUpperCase();
  // Tenant đọc được khuyến mãi nền tảng + của chính mình (RLS); mã của nhà xe khác coi như không có.
  const promotion = await tx.promotion.findFirst({
    where: { code, OR: [{ operatorId: null }, { operatorId: context.operatorId }] },
    select: {
      id: true,
      code: true,
      name: true,
      scope: true,
      status: true,
      discountType: true,
      discountValue: true,
      maxDiscount: true,
      minOrder: true,
      routeId: true,
      routeIds: true,
      tripId: true,
      startsAt: true,
      endsAt: true,
      usedCount: true,
      usageLimit: true,
    },
  });
  if (!promotion || promotion.status !== PromotionStatus.ACTIVE || context.now < promotion.startsAt || context.now >= promotion.endsAt) {
    throw promotionInvalid("Mã khuyến mãi không tồn tại hoặc chưa / hết hiệu lực.");
  }
  if (promotion.scope === PromotionScope.PLATFORM) {
    if (promotion.routeIds.length > 0 && !promotion.routeIds.includes(context.routeId)) throw promotionInvalid("Mã khuyến mãi không áp dụng cho tuyến này.");
    // Khanh 18/10/2026: khuyến mãi nền tảng chỉ áp cho chuyến của nhà xe đã tham gia (nhà xe chịu phần giảm).
    const joined = await tx.promotionParticipation.findUnique({
      where: { promotionId_operatorId: { promotionId: promotion.id, operatorId: context.operatorId } },
      select: { operatorId: true },
    });
    if (!joined) {
      throw promotionInvalid("Mã khuyến mãi không áp dụng cho nhà xe của chuyến này.");
    }
  } else if ((promotion.routeId && promotion.routeId !== context.routeId) || (promotion.tripId && promotion.tripId !== context.tripId)) {
    throw promotionInvalid("Mã khuyến mãi không áp dụng cho tuyến / chuyến này.");
  }
  if (context.subtotal < promotion.minOrder) {
    throw promotionInvalid(`Đơn chưa đạt giá trị tối thiểu ${new Intl.NumberFormat("vi-VN").format(promotion.minOrder)} ₫ của mã.`);
  }
  if (promotion.usedCount >= promotion.usageLimit) {
    throw promotionExhausted();
  }
  const discount = discountFor(promotion, context.subtotal);
  if (discount <= 0n) {
    throw promotionInvalid("Mã khuyến mãi không giảm được cho đơn này.");
  }
  return { promotionId: promotion.id, code: promotion.code, name: promotion.name, discount, fundedBy: DiscountFunding.OPERATOR, promotionScope: promotion.scope };
}

/**
 * Áp mã khi tạo đơn (trong transaction của đơn, tenant của nhà xe): kiểm điều kiện, ngân sách tháng của khuyến mãi nhà xe, rồi giữ
 * một lượt dùng NGUYÊN TỬ qua `promotion_claim` (hết lượt → 409). Đơn không tạo được thì transaction rollback trả luôn lượt.
 */
export async function claimPromotion(tx: DbTransaction, context: Context): Promise<AppliedPromotion> {
  const applied = await evaluatePromotion(tx, context);
  if (applied.promotionScope === PromotionScope.OPERATOR) {
    const permission = await tx.promotionPermission.findUnique({ where: { operatorId: context.operatorId }, select: { monthlyBudget: true } });
    if (permission?.monthlyBudget) {
      const spent = await tx.promotionRedemption.aggregate({
        where: { operatorId: context.operatorId, status: { not: RedemptionStatus.RELEASED }, createdAt: { gte: vnMonthStart(context.now) }, promotion: { scope: PromotionScope.OPERATOR } },
        _sum: { discount: true },
      });
      if ((spent._sum.discount ?? 0n) + applied.discount > permission.monthlyBudget) {
        throw promotionExhausted("Khuyến mãi của nhà xe đã hết ngân sách tháng này.");
      }
    }
  }
  const [row] = await tx.$queryRaw<{ claimed: boolean }[]>`SELECT promotion_claim(${applied.promotionId}) AS claimed`;
  if (!row?.claimed) {
    throw promotionExhausted();
  }
  return { promotionId: applied.promotionId, code: applied.code, name: applied.name, discount: applied.discount, fundedBy: applied.fundedBy };
}

/** Đơn thanh toán thành công → lượt áp dụng "đã dùng" (FR-PROM-06). */
export async function useRedemption(tx: DbTransaction, operatorId: string, bookingId: string): Promise<void> {
  await tx.promotionRedemption.updateMany({ where: { bookingId, operatorId, status: RedemptionStatus.RESERVED }, data: { status: RedemptionStatus.USED } });
  await transitionVoucher(tx, operatorId, bookingId, "USE");
}

/** Đơn hết hạn / hủy trước khi thanh toán → trả lượt dùng của mã (BR-72). Gọi lặp an toàn. */
export async function releaseRedemption(tx: DbTransaction, operatorId: string, bookingId: string): Promise<void> {
  await transitionVoucher(tx, operatorId, bookingId, "RELEASE");
  const redemption = await tx.promotionRedemption.findFirst({ where: { bookingId, operatorId, status: RedemptionStatus.RESERVED }, select: { id: true, promotionId: true } });
  if (!redemption) {
    return;
  }
  const updated = await tx.promotionRedemption.updateMany({ where: { id: redemption.id, status: RedemptionStatus.RESERVED }, data: { status: RedemptionStatus.RELEASED } });
  if (updated.count > 0 && redemption.promotionId) {
    await tx.$executeRaw`SELECT promotion_release(${redemption.promotionId})`;
  }
}
