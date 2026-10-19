import { describe, expect, it } from "vitest";
import { paidPrice } from "../refund/refund-policy";
import { discountFor, MIN_PAYABLE, vnMonthStart } from "./promotion-apply";

describe("Khuyến mãi — tính tiền (TASK-PROM-001, BIGINT VND)", () => {
  const percent = { discountType: "PERCENT" as const, discountValue: 10n, maxDiscount: 50_000n, minOrder: 300_000n };

  it("phần trăm làm tròn xuống + trần; chưa đạt giá trị tối thiểu → 0", () => {
    expect(discountFor(percent, 300_000n)).toBe(30_000n);
    expect(discountFor(percent, 333_333n)).toBe(33_333n);
    expect(discountFor(percent, 900_000n)).toBe(50_000n);
    expect(discountFor(percent, 299_999n)).toBe(0n);
  });

  it("số tiền cố định; không giảm để khách trả dưới mức tối thiểu của cổng", () => {
    const amount = { discountType: "AMOUNT" as const, discountValue: 30_000n, maxDiscount: null, minOrder: 0n };
    expect(discountFor(amount, 200_000n)).toBe(30_000n);
    expect(discountFor(amount, 35_000n)).toBe(35_000n - MIN_PAYABLE);
    expect(discountFor(amount, MIN_PAYABLE)).toBe(0n);
  });

  it("phần khách thực trả từng vé khi đơn có giảm: tổng không vượt số đã trả, không giảm → đúng giá", () => {
    const prices = [300_000n, 300_000n, 250_000n];
    const subtotal = prices.reduce((sum, price) => sum + price, 0n);
    const discount = 85_001n;
    const shares = prices.map((price) => paidPrice(price, subtotal, discount));
    expect(shares.reduce((sum, value) => sum + value, 0n) <= subtotal - discount).toBe(true);
    expect(subtotal - discount - shares.reduce((sum, value) => sum + value, 0n) < 3n).toBe(true);
    expect(paidPrice(300_000n, 600_000n, 0n)).toBe(300_000n);
  });

  it("đầu tháng theo giờ VN (23:30 UTC ngày 31 = ngày 1 tháng sau)", () => {
    expect(vnMonthStart(new Date("2026-10-31T23:30:00Z")).toISOString()).toBe("2026-10-31T17:00:00.000Z");
    expect(vnMonthStart(new Date("2026-10-19T03:00:00Z")).toISOString()).toBe("2026-09-30T17:00:00.000Z");
  });
});
