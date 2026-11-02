import { describe, expect, it } from "vitest";
import { LoyaltyRulesSchema, type LoyaltyRules } from "../policy/dto/policy.dto";
import { addMonths, earnPoints, expiringPoints, nextTierFor, reversalPoints, tierFor } from "./loyalty-rules";

// Giá trị nền v1 (LLD-OQ-06, Khanh 18/10/2026): số liệu Figma + tích 1 điểm / 10.000 ₫.
const RULES: LoyaltyRules = {
  earnUnit: 10_000,
  pointValue: 1_000,
  minRedeemPoints: 100,
  pointExpiryMonths: 12,
  voucherValidityDays: 30,
  tiers: [
    { tier: "BRONZE", minPoints: 0, multiplierPercent: 100 },
    { tier: "SILVER", minPoints: 2_000, multiplierPercent: 120 },
    { tier: "GOLD", minPoints: 5_000, multiplierPercent: 150 },
    { tier: "PLATINUM", minPoints: 10_000, multiplierPercent: 200 },
  ],
};

describe("VXN Plus — phép tính điểm (BR-66..70)", () => {
  it("tích điểm làm tròn xuống theo đơn vị và hệ số hạng, tính BIGINT không sai số", () => {
    expect(earnPoints(350_000n, 10_000, 100)).toBe(35);
    expect(earnPoints(350_000n, 10_000, 120)).toBe(42);
    expect(earnPoints(9_999n, 10_000, 200)).toBe(1);
    expect(earnPoints(4_999n, 10_000, 200)).toBe(0);
    expect(earnPoints(0n, 10_000, 150)).toBe(0);
    // Số tiền lớn vẫn chính xác (không qua số thực).
    expect(earnPoints(9_007_199_254_740_993n, 10_000, 150)).toBe(1_351_079_888_211);
  });

  it("hạng theo điểm tích 12 tháng: mốc cao nhất đã đạt + số điểm còn thiếu tới hạng kế", () => {
    expect(tierFor(RULES, 0).tier).toBe("BRONZE");
    expect(tierFor(RULES, 1_999).tier).toBe("BRONZE");
    expect(tierFor(RULES, 2_000).tier).toBe("SILVER");
    expect(tierFor(RULES, 2_450).multiplierPercent).toBe(120);
    expect(tierFor(RULES, 12_000).tier).toBe("PLATINUM");
    expect(nextTierFor(RULES, 2_450)).toEqual({ tier: "GOLD", minPoints: 5_000, remaining: 2_550 });
    expect(nextTierFor(RULES, 10_000)).toBeNull();
  });

  it("thu hồi theo tỷ lệ số tiền hoàn, làm tròn xuống, không vượt phần còn lại của lần tích", () => {
    expect(reversalPoints(60, 600_000n, 300_000n, 0)).toBe(30);
    expect(reversalPoints(61, 600_000n, 300_000n, 0)).toBe(30);
    expect(reversalPoints(60, 600_000n, 650_000n, 30)).toBe(30);
    expect(reversalPoints(60, 600_000n, 300_000n, 60)).toBe(0);
    expect(reversalPoints(60, 0n, 300_000n, 0)).toBe(0);
  });

  it("hết hạn: lô tới hạn − tổng đã trừ, không âm, không vượt số dư; chạy lại → 0", () => {
    // Tích 100 (tới hạn) + 50 (chưa), đã đổi 30 → hết hạn 70.
    expect(expiringPoints(100, 30, 120)).toBe(70);
    // Sau khi ghi hết hạn 70: tổng trừ = 100 → 0.
    expect(expiringPoints(100, 100, 50)).toBe(0);
    expect(expiringPoints(100, 150, 0)).toBe(0);
    expect(expiringPoints(100, 0, 40)).toBe(40);
  });

  it("cộng tháng theo lịch: 31/01 + 1 tháng → 28/02; 29/02 + 12 tháng → 28/02 năm sau", () => {
    expect(addMonths(new Date("2026-01-31T05:00:00Z"), 1).toISOString()).toBe("2026-02-28T05:00:00.000Z");
    expect(addMonths(new Date("2028-02-29T00:00:00Z"), 12).toISOString()).toBe("2029-02-28T00:00:00.000Z");
    expect(addMonths(new Date("2026-10-19T00:00:00Z"), -12).toISOString()).toBe("2025-10-19T00:00:00.000Z");
  });

  it("chính sách: đủ 4 hạng theo thứ tự, hạng Đồng từ 0, mốc tăng dần, hệ số không giảm", () => {
    expect(LoyaltyRulesSchema.safeParse(RULES).success).toBe(true);
    const tiers = (patch: Partial<LoyaltyRules["tiers"][number]>, index: number) => ({ ...RULES, tiers: RULES.tiers.map((tier, i) => (i === index ? { ...tier, ...patch } : tier)) });
    const message = (rules: unknown) => {
      const parsed = LoyaltyRulesSchema.safeParse(rules);
      return parsed.success ? null : parsed.error.issues[0]?.message;
    };
    expect(message(tiers({ minPoints: 10 }, 0))).toBe("Hạng Đồng bắt đầu từ 0 điểm.");
    expect(message(tiers({ minPoints: 6_000 }, 1))).toBe("Mốc điểm của hạng cao hơn phải lớn hơn hạng dưới.");
    expect(message(tiers({ multiplierPercent: 110 }, 2))).toBe("Hệ số của hạng cao hơn không được thấp hơn hạng dưới.");
    expect(message(tiers({ tier: "GOLD" }, 1))).toBe("Các hạng phải theo thứ tự Đồng, Bạc, Vàng, Bạch kim.");
    expect(message({ ...RULES, tiers: RULES.tiers.slice(0, 3) })).not.toBeNull();
    expect(message({ ...RULES, earnUnit: 500 })).not.toBeNull();
  });
});
