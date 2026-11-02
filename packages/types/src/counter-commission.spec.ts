import { describe, expect, it } from "vitest";
import { CounterCommissionQuerySchema, CounterCommissionSettlementInputSchema } from "./counter-commission";

const input = { operatorId: "00000000-0000-4000-8000-000000000001", idempotencyKey: "00000000-0000-4000-8000-000000000002", amount: "9007199254740993", reference: " bank-001 ", reason: "Thu kỳ tháng 10" };
describe("Counter commission boundary", () => {
  it("tiền dùng chuỗi chính xác trên ngưỡng an toàn number và tham chiếu chuẩn hóa", () => {
    expect(CounterCommissionSettlementInputSchema.parse(input)).toMatchObject({ amount: "9007199254740993", reference: "BANK-001" });
  });
  it.each(["0", "-1", "1.1", "9223372036854775808", "01"])("từ chối số tiền không hợp lệ %s", (amount) => {
    expect(CounterCommissionSettlementInputSchema.safeParse({ ...input, amount }).success).toBe(false);
  });
  it("không nhận số thực hoặc thiếu khóa chống lặp", () => {
    expect(CounterCommissionSettlementInputSchema.safeParse({ ...input, amount: 123 }).success).toBe(false);
    expect(CounterCommissionSettlementInputSchema.safeParse({ ...input, idempotencyKey: "" }).success).toBe(false);
  });
  it("ngày kết thúc phải sau ngày bắt đầu", () => {
    expect(CounterCommissionQuerySchema.safeParse({ operatorId: input.operatorId, from: "2030-02-01T00:00:00Z", to: "2030-01-01T00:00:00Z" }).success).toBe(false);
  });
});
