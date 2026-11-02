import { describe, expect, it } from "vitest";
import { commissionOf } from "./escrow-entries";

/** TASK-BTP-006 — hoa hồng BIGINT làm tròn xuống (test money bắt buộc, ADR-025). */
describe("commissionOf", () => {
  it("‱ trên số tiền, làm tròn xuống tới đồng; 0 ‱ → 0; số lớn không mất chính xác", () => {
    expect(commissionOf(600_000n, 500)).toBe(30_000n);
    expect(commissionOf(333_333n, 500)).toBe(16_666n);
    expect(commissionOf(270_000n, 400)).toBe(10_800n);
    expect(commissionOf(1n, 9_999)).toBe(0n);
    expect(commissionOf(600_000n, 0)).toBe(0n);
    expect(commissionOf(9_007_199_254_740_993n, 500)).toBe(450_359_962_737_049n);
  });

  it("mức ngoài 0–10.000 ‱ hoặc lẻ → lỗi", () => {
    expect(() => commissionOf(100n, -1)).toThrow();
    expect(() => commissionOf(100n, 10_001)).toThrow();
    expect(() => commissionOf(100n, 1.5)).toThrow();
  });
});
