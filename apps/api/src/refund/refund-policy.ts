// Tính tiền hoàn khi hủy vé (TASK-BTP-005, BR-07, UC-08 bước 4–6): theo mốc hủy CHỤP lúc đặt (`snapshot.cancellationPolicy`),
// không theo chính sách hiện hành. Mốc `{ minHoursBefore, refundPercent }` = hủy khi còn ≥ `minHoursBefore` giờ trước giờ khởi
// hành thì hoàn `refundPercent`% giá vé. Tiền BIGINT, làm tròn XUỐNG tới đồng cho từng vé.

export type CancellationTier = { minHoursBefore: number; refundPercent: number };

/** Mốc áp dụng khi hủy lúc `now`: mốc có `minHoursBefore` lớn nhất mà vẫn ≤ số giờ còn lại; không có → `null` (hoàn 0%). */
export function applicableTier(tiers: readonly CancellationTier[], departureAt: Date, now: Date): CancellationTier | null {
  const hoursLeft = (departureAt.getTime() - now.getTime()) / 3_600_000;
  let best: CancellationTier | null = null;
  for (const tier of tiers) {
    if (hoursLeft >= tier.minHoursBefore && (!best || tier.minHoursBefore > best.minHoursBefore)) {
      best = tier;
    }
  }
  return best;
}

/** Tiền hoàn của một vé: `price × percent / 100`, làm tròn xuống (không bao giờ hoàn quá giá vé). */
export function refundOf(price: bigint, percent: number): bigint {
  if (!Number.isInteger(percent) || percent < 0 || percent > 100) {
    throw new Error(`Phần trăm hoàn không hợp lệ: ${percent}`);
  }
  return (price * BigInt(percent)) / 100n;
}
