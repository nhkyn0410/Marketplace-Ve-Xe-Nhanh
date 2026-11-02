import { describe, expect, it } from "vitest";
import { applicableTier, refundOf } from "./refund-policy";

/** TASK-BTP-005 — tiền hoàn theo mốc chụp lúc đặt (test money bắt buộc, ADR-025). */
describe("refund-policy", () => {
  const departure = new Date("2031-08-01T15:30:00Z");
  const tiers = [
    { minHoursBefore: 0, refundPercent: 0 },
    { minHoursBefore: 4, refundPercent: 50 },
    { minHoursBefore: 24, refundPercent: 90 },
  ];
  const before = (hours: number) => new Date(departure.getTime() - hours * 3_600_000);

  it("chọn mốc xa nhất mà số giờ còn lại vẫn đạt; đúng biên = được mốc đó", () => {
    expect(applicableTier(tiers, departure, before(48))).toEqual({ minHoursBefore: 24, refundPercent: 90 });
    expect(applicableTier(tiers, departure, before(24))).toEqual({ minHoursBefore: 24, refundPercent: 90 });
    expect(applicableTier(tiers, departure, new Date(before(24).getTime() + 1))).toEqual({ minHoursBefore: 4, refundPercent: 50 });
    expect(applicableTier(tiers, departure, before(1))).toEqual({ minHoursBefore: 0, refundPercent: 0 });
  });

  it("đã qua giờ khởi hành / không có mốc → không có mốc (hoàn 0%)", () => {
    expect(applicableTier(tiers, departure, new Date(departure.getTime() + 1))).toBeNull();
    expect(applicableTier([], departure, before(48))).toBeNull();
  });

  it("tiền hoàn BIGINT làm tròn xuống tới đồng, không vượt giá vé; phần trăm sai → lỗi", () => {
    expect(refundOf(320_000n, 90)).toBe(288_000n);
    expect(refundOf(333_333n, 50)).toBe(166_666n);
    expect(refundOf(999_999_999_999n, 33)).toBe(329_999_999_999n);
    expect(refundOf(320_000n, 100)).toBe(320_000n);
    expect(refundOf(320_000n, 0)).toBe(0n);
    expect(() => refundOf(320_000n, 101)).toThrow();
    expect(() => refundOf(320_000n, 12.5)).toThrow();
  });
});
