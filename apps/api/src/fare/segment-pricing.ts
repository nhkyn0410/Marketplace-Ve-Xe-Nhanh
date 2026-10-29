import type { SeatType } from "../database/prisma.types";
import { type PriceRule, resolveSeatPrice } from "./fare-pricing";

/**
 * Chặng mở bán của một chuyến (giai đoạn 3.3, tự thiết kế 29/10/2026, chờ duyệt): tuyến con đang bật, có bảng giá đang áp
 * dụng, hai đầu đã đổi sang số thứ tự điểm dừng của chuyến.
 */
export type SegmentOffer = {
  routeId: string;
  distanceMeters: number;
  fromSequence: number;
  toSequence: number;
  rules: PriceRule[];
};

/**
 * Chặng bao trọn đoạn khách đi (đón ở `pickupSequence`, trả ở `dropoffSequence`) và ngắn nhất (quãng đường nhỏ nhất, hoà thì
 * theo `routeId` để luôn xác định); không có → `null` = giá của tuyến chính.
 */
export function coveringOffer(offers: readonly SegmentOffer[], pickupSequence: number, dropoffSequence: number): SegmentOffer | null {
  let best: SegmentOffer | null = null;
  for (const offer of offers) {
    if (offer.fromSequence > pickupSequence || offer.toSequence < dropoffSequence) continue;
    if (!best || offer.distanceMeters < best.distanceMeters || (offer.distanceMeters === best.distanceMeters && offer.routeId < best.routeId)) {
      best = offer;
    }
  }
  return best;
}

/**
 * Giá một ghế cho đoạn khách đi: theo bảng giá của chặng bao trọn ngắn nhất; chặng đó không có quy tắc khớp loại xe / loại
 * chỗ / giờ → giá tuyến chính. Không có chặng → giá tuyến chính (như trước 3.3).
 */
export function segmentSeatPrice(
  offer: SegmentOffer | null,
  routeRules: readonly PriceRule[],
  vehicleTypeId: string,
  seatType: SeatType,
  departureAt: Date,
): bigint | null {
  return (offer ? resolveSeatPrice(offer.rules, vehicleTypeId, seatType, departureAt) : null) ?? resolveSeatPrice(routeRules, vehicleTypeId, seatType, departureAt);
}
