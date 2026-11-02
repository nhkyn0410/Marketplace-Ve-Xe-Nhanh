import { describe, expect, it } from "vitest";

import type { LoyaltyReport } from "./loyalty-api";
import { formatPoints, monthLabel, multiplierLabel, parseMultiplier, parseRulesForm, recentQuarters, reportCsv, rulesToForm, type LoyaltyRules } from "./loyalty-format";

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
    { tier: "PLATINUM", minPoints: 10_000, multiplierPercent: 200 }
  ]
};

describe("VXN Plus — định dạng", () => {
  it("điểm có dấu + hệ số", () => {
    expect(formatPoints(1250)).toBe("1.250");
    expect(formatPoints(384, true)).toBe("+384");
    expect(formatPoints(-100, true)).toBe("-100");
    expect(formatPoints(-100)).toBe("-100");
    expect(formatPoints(0, true)).toBe("0");
    expect(multiplierLabel(120)).toBe("1,2");
    expect(multiplierLabel(100)).toBe("1");
    expect(parseMultiplier("1,2")).toBe(120);
    expect(parseMultiplier("1.25")).toBe(125);
    expect(parseMultiplier("2")).toBe(200);
    expect(parseMultiplier("1,234")).toBeNull();
    expect(parseMultiplier("abc")).toBeNull();
  });

  it("form tham số: khứ hồi giá trị Figma; mốc không tăng / hệ số giảm / thiếu ô → lỗi đúng ô", () => {
    const form = rulesToForm(RULES);
    expect(form.earnUnit).toBe("10.000");
    expect(form.tiers[1]).toEqual({ minPoints: "2000", multiplier: "1,2" });
    expect(parseRulesForm(form)).toEqual({ rules: RULES, errors: {} });

    const empty = parseRulesForm(rulesToForm(null));
    expect(empty.rules).toBeNull();
    expect(empty.errors.earnUnit).toBe("Từ 1.000 đến 1.000.000 ₫.");
    expect(empty.errors.tiers?.[0]).toEqual({ multiplier: "Từ 1 đến 5, tối đa 2 chữ số thập phân." });

    const broken = parseRulesForm({ ...form, tiers: form.tiers.map((row, index) => (index === 2 ? { minPoints: "1500", multiplier: "1,1" } : row)) });
    expect(broken.errors.tiers?.[2]).toEqual({ minPoints: "Phải lớn hơn mốc của hạng dưới.", multiplier: "Không thấp hơn hệ số hạng dưới." });
  });

  it("quý gần đây qua năm; nhãn tháng; CSV có BOM + dòng tổng quý", () => {
    expect(recentQuarters(new Date("2026-01-10T00:00:00Z"), 3)).toEqual([
      { year: 2026, quarter: 1 },
      { year: 2025, quarter: 4 },
      { year: 2025, quarter: 3 }
    ]);
    // 31/03 18:00 UTC = 01/04 giờ VN → quý 2.
    expect(recentQuarters(new Date("2026-03-31T18:00:00Z"), 1)).toEqual([{ year: 2026, quarter: 2 }]);
    expect(monthLabel("2026-09")).toBe("Tháng 9/2026");
    const figures = { issued: 10, redeemed: 2, expired: 1, vouchersRedeemed: 1, vouchersUsed: 0, platformDiscount: 0 };
    const report: LoyaltyReport = { year: 2026, quarter: 4, tier: null, months: [{ month: "2026-10", ...figures }], totals: figures };
    expect(reportCsv(report)).toBe("﻿Kỳ,Điểm phát hành,Điểm đã đổi,Điểm hết hạn,Voucher đã dùng,Giảm do Vé Xe Nhanh chịu (VND)\r\nTháng 10/2026,10,2,1,0,0\r\nQuý 4/2026,10,2,1,0,0\r\n");
  });
});
