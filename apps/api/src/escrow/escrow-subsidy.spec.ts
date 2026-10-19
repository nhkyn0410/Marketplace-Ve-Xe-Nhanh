import { describe, expect, it } from "vitest";
import { commissionOf, subsidyReversal } from "./escrow-entries";

describe("VXN Plus — trợ giá và hoàn theo tỷ lệ (BR-73)", () => {
  it("giữ nguyên cơ sở hoa hồng trước giảm loyalty và đảo tiền trợ giá theo tỷ lệ khách được hoàn", () => {
    expect(commissionOf(300_000n, 500)).toBe(15_000n);
    expect(subsidyReversal(100_000n, 200_000n, 100_000n, 0n)).toBe(50_000n);
    expect(commissionOf(100_000n + 50_000n, 500)).toBe(7_500n);
  });

  it("hoàn nhiều lần thu đủ đồng lẻ ở lần cuối và không đảo quá khoản đã bù", () => {
    const first = subsidyReversal(3n, 10n, 3n, 0n);
    const second = subsidyReversal(3n, 10n, 6n, first);
    const last = subsidyReversal(3n, 10n, 10n, first + second);
    expect([first, second, last]).toEqual([0n, 1n, 2n]);
    expect(subsidyReversal(3n, 10n, 20n, 3n)).toBe(0n);
    expect(subsidyReversal(100n, 0n, 100n, 0n)).toBe(0n);
  });

  it("BIGINT vượt giới hạn số nguyên JavaScript vẫn giữ chính xác tỷ lệ", () => {
    const amount = 9_007_199_254_740_993n;
    expect(subsidyReversal(amount, amount * 3n, amount, 0n)).toBe(amount / 3n);
  });
});
