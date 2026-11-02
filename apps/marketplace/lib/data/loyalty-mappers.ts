import type { components } from "@vexenhanh/api-client";
import { formatDateVi, formatVnd } from "../format";
import type { LoyaltyProfile, LoyaltyTierCode, UserVoucherItem, UserVoucherStatus } from "./types";

type Member = components["schemas"]["PassengerLoyaltyDto_Output"];
export type LoyaltyProfileData = LoyaltyProfile & {
  readonly rules?: Member["rules"];
  readonly nextTier?: Member["nextTier"];
  readonly memberStatus?: Member["status"];
};
const tierNames = { BRONZE: "Đồng", SILVER: "Bạc", GOLD: "Vàng", PLATINUM: "Bạch kim" };

/** Quy đổi điểm bằng số nguyên lớn; chỉ chấp nhận giá trị VND nguyên an toàn từ API. */
export function loyaltyVoucherValue(points: number, pointValue: number): string {
  if (!Number.isSafeInteger(points) || points < 0 || !Number.isSafeInteger(pointValue) || pointValue < 0) throw new Error("Giá trị quy đổi điểm không hợp lệ.");
  return (BigInt(points) * BigInt(String(pointValue))).toString();
}

/** Ánh xạ chính sách thực tế, giữ rules=null để giao diện khóa đổi điểm khi chưa có chính sách. */
export function mapLoyaltyProfile(member: Member): LoyaltyProfileData {
  const current = member.rules?.tiers.find((tier) => tier.tier === member.tier);
  const next = member.rules?.tiers.find((tier) => tier.tier === member.nextTier?.tier);
  const multiplier = (percent?: number) => percent === undefined ? "Chưa có chính sách" : `×${percent / 100}`;
  return { currentTier: member.tier.toLowerCase() as LoyaltyTierCode, currentTierName: tierNames[member.tier],
    multiplierText: multiplier(current?.multiplierPercent), pointsIn12Months: member.earned12m,
    targetPointsForNextTier: member.nextTier?.minPoints ?? member.earned12m,
    pointsRequiredForNextTier: member.nextTier?.remaining ?? 0, nextTierName: member.nextTier ? tierNames[member.nextTier.tier] : "Hạng cao nhất",
    nextTierMultiplierText: multiplier(next?.multiplierPercent), availablePoints: member.availablePoints,
    estimatedVoucherVnd: member.rules ? loyaltyVoucherValue(member.availablePoints, member.rules.pointValue) : "0",
    tiers: (member.rules?.tiers ?? []).map((tier) => ({ code: tier.tier.toLowerCase() as LoyaltyTierCode,
      name: tierNames[tier.tier], minPoints12mText: tier.minPoints.toLocaleString("vi-VN"),
      multiplierText: multiplier(tier.multiplierPercent), isCurrent: tier.tier === member.tier })),
    rules: member.rules, nextTier: member.nextTier, memberStatus: member.status };
}

/** Ánh xạ voucher; voucher đổi điểm không có mã sẽ giữ chuỗi rỗng, không tự tạo mã. */
export function mapVoucher(voucher: components["schemas"]["UserVoucherDto_Output"]): UserVoucherItem {
  const statuses: Record<string, UserVoucherStatus> = { AVAILABLE: "available", RESERVED: "holding", USED: "used", EXPIRED: "expired" };
  const labels = { AVAILABLE: "Khả dụng", RESERVED: "Đang giữ", USED: "Đã dùng", EXPIRED: "Hết hạn" } as const;
  return { id: voucher.userVoucherId, code: voucher.promotionCode ?? "", title: voucher.name,
    type: voucher.source === "LOYALTY_REDEMPTION" ? "loyalty_redemption" : "public_code",
    typeLabel: voucher.source === "LOYALTY_REDEMPTION" ? "Đổi điểm" : "Mã đã lưu", status: statuses[voucher.status]!,
    statusLabel: labels[voucher.status], scopeText: `Đơn tối thiểu ${formatVnd(voucher.minOrder)}${voucher.maxDiscount ? ` · Giảm tối đa ${formatVnd(voucher.maxDiscount)}` : ""}`,
    expiryDateText: formatDateVi(voucher.expiresAt),
    discountLabel: voucher.discountType === "PERCENT" ? `Giảm ${voucher.discountValue}%` : `Giảm ${formatVnd(voucher.discountAmount ?? voucher.discountValue)}`,
    ...(voucher.discountAmount ? { discountValueVnd: voucher.discountAmount } : {}) };
}
