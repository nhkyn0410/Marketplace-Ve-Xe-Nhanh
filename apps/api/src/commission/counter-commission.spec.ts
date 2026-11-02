import { describe, expect, it, vi } from "vitest";
import { recordCounterCommission, resolveCounterCommission } from "./counter-commission";
import type { DbTransaction } from "../database/prisma.service";

function setup(rule: { id: string; rateBps: number } | null, online = 500) {
  const findFirst = vi.fn(async () => rule);
  const findMany = vi.fn(async () => [{ operatorId: "op", rateBps: online }]);
  const create = vi.fn(async () => ({}));
  const tx = { $queryRaw: vi.fn(async () => [{ id: "op" }]), commissionRule: { findFirst, findMany }, counterCommissionReceivable: { create }, escrowLedger: { create: vi.fn() } };
  return { tx: tx as unknown as DbTransaction, ...tx, findFirst, findMany, create };
}

describe("Counter commission snapshot", () => {
  it("thiếu cấu hình quầy dùng0%, không dùng mức online", async () => {
    const ctx = setup(null);
    expect(await resolveCounterCommission(ctx.tx, "op", 600000n, new Date())).toEqual({ commissionRuleId: null, rateBps: 0, basis: 600000n, amount: 0n });
    expect(ctx.findMany).not.toHaveBeenCalled();
    expect(ctx.findFirst).toHaveBeenCalledWith(expect.objectContaining({ where: expect.objectContaining({ operatorId: "op", channel: "COUNTER" }) }));
  });
  it("snapshot gồm rule,rate,basis, tiền đúng tới đồng trên ngưỡng number", async () => {
    const ctx = setup({ id: "rule", rateBps: 200 });
    expect(await recordCounterCommission(ctx.tx, { operatorId: "op", bookingId: "booking", receiptId: "receipt", basis: 9007199254740993n, at: new Date("2030-01-01") })).toEqual({ commissionRuleId: "rule", rateBps: 200, basis: 9007199254740993n, amount: 180143985094819n });
    expect(ctx.create).toHaveBeenCalledOnce();
    expect(ctx.escrowLedger.create).not.toHaveBeenCalled();
    expect(ctx.findMany).toHaveBeenCalledWith(expect.objectContaining({ where: expect.objectContaining({ channel: "ONLINE" }) }));
  });
  it("không cho cấu hình quầy không còn thấp hơn online, không ghi phải thu", async () => {
    const ctx = setup({ id: "rule", rateBps: 200 }, 100);
    await expect(recordCounterCommission(ctx.tx, { operatorId: "op", bookingId: "booking", receiptId: "receipt", basis: 333333n, at: new Date() })).rejects.toThrow();
    expect(ctx.create).not.toHaveBeenCalled();
  });
  it("không tính trên số tiền âm", async () => {
    const ctx = setup(null);
    await expect(resolveCounterCommission(ctx.tx, "op", -1n, new Date())).rejects.toThrow();
  });
  it("dùng snapshot đã chốt trong cùng transaction mà không phân giải lần nữa", async () => {
    const ctx = setup(null);
    const snapshot = { commissionRuleId: "rule", rateBps: 200, basis: 600000n, amount: 12000n };
    expect(await recordCounterCommission(ctx.tx, { operatorId: "op", bookingId: "booking", receiptId: "receipt", basis: 600000n, at: new Date(), snapshot })).toEqual(snapshot);
    expect(ctx.findFirst).not.toHaveBeenCalled();
    await expect(recordCounterCommission(ctx.tx, { operatorId: "op", bookingId: "booking", receiptId: "other", basis: 600000n, at: new Date(), snapshot: { ...snapshot, amount: 11999n } })).rejects.toThrow();
  });
});
