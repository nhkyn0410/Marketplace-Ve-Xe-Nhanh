import { describe, expect, it } from "vitest";
import { coveringOffer, type SegmentOffer, segmentSeatPrice } from "./segment-pricing";

const rule = (price: bigint, seatType: "SEAT" | "BED" | null = null) => ({ vehicleTypeId: null, seatType, validFrom: null, validTo: null, price });
const offer = (routeId: string, fromSequence: number, toSequence: number, distanceMeters: number, rules = [rule(100_000n)]): SegmentOffer => ({
  routeId,
  fromSequence,
  toSequence,
  distanceMeters,
  rules,
});
const departure = new Date("2026-11-01T01:00:00Z");

describe("giá theo chặng (3.3, tiền bigint)", () => {
  // Chuyến 1 (TP.HCM) → 2 (Bảo Lộc) → 3 (Gia Nghĩa) → 4 (Buôn Ma Thuột).
  const offers = [offer("hcm-gn", 1, 3, 230_000), offer("bl-bmt", 2, 4, 250_000), offer("hcm-bl", 1, 2, 180_000)];

  it("chọn tuyến con ngắn nhất bao trọn chặng khách đi", () => {
    expect(coveringOffer(offers, 1, 2)?.routeId).toBe("hcm-bl");
    expect(coveringOffer(offers, 2, 3)?.routeId).toBe("hcm-gn");
    expect(coveringOffer(offers, 3, 4)?.routeId).toBe("bl-bmt");
  });

  it("không tuyến con nào bao trọn (cả tuyến) → null = giá tuyến chính", () => {
    expect(coveringOffer(offers, 1, 4)).toBeNull();
    expect(coveringOffer([], 1, 2)).toBeNull();
  });

  it("hai tuyến con dài bằng nhau → theo mã tuyến, luôn xác định", () => {
    expect(coveringOffer([offer("b", 1, 3, 100), offer("a", 1, 3, 100)], 1, 2)?.routeId).toBe("a");
  });

  it("giá ghế: theo bảng giá tuyến con; tuyến con không có giá cho loại chỗ đó → giá tuyến chính", () => {
    const parent = [rule(300_000n)];
    const sub = offer("s", 1, 2, 10, [rule(120_000n, "SEAT")]);
    expect(segmentSeatPrice(sub, parent, "vt", "SEAT", departure)).toBe(120_000n);
    expect(segmentSeatPrice(sub, parent, "vt", "BED", departure)).toBe(300_000n);
    expect(segmentSeatPrice(null, parent, "vt", "BED", departure)).toBe(300_000n);
    expect(segmentSeatPrice(null, [], "vt", "BED", departure)).toBeNull();
  });
});
