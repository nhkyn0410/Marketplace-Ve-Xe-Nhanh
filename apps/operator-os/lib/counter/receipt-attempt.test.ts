import { describe, expect, it } from "vitest";

import { clearReceiptAttempt, readReceiptAttempt, saveReceiptAttempt } from "./receipt-attempt";

describe("khôi phục xác nhận thu sau timeout", () => {
  it("giữ nguyên mã và nội dung theo từng đơn, chỉ xóa khi đã biết kết quả", () => {
    const values = new Map<string, string>();
    const storage = { getItem: (key: string) => values.get(key) ?? null, setItem: (key: string, value: string) => void values.set(key, value), removeItem: (key: string) => void values.delete(key) };
    const input = { idempotencyKey: "11111111-1111-4111-8111-111111111111", method: "BANK_TRANSFER" as const, amount: "300000", reference: "BANK-001" };
    expect(saveReceiptAttempt("booking-a", input, storage)).toBe(true);
    expect(readReceiptAttempt("booking-a", storage)).toEqual(input);
    expect(readReceiptAttempt("booking-b", storage)).toBeNull();
    clearReceiptAttempt("booking-a", storage);
    expect(readReceiptAttempt("booking-a", storage)).toBeNull();
  });

  it("bỏ dữ liệu hỏng và không làm hỏng giao diện khi browser chặn bộ nhớ", () => {
    const invalid = { getItem: () => "{broken", setItem: () => undefined, removeItem: () => undefined };
    expect(readReceiptAttempt("booking", invalid)).toBeNull();
    const denied = { getItem: () => { throw new Error("denied"); }, setItem: () => { throw new Error("denied"); }, removeItem: () => { throw new Error("denied"); } };
    expect(readReceiptAttempt("booking", denied)).toBeNull();
    expect(saveReceiptAttempt("booking", { idempotencyKey: "11111111-1111-4111-8111-111111111111", method: "CASH", amount: "300000", reference: null }, denied)).toBe(false);
    expect(() => clearReceiptAttempt("booking", denied)).not.toThrow();
  });
});
