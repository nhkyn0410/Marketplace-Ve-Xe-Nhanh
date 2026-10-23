import { beforeEach, describe, expect, it, vi } from "vitest";
import { getLoyaltyHistory, getLoyaltyProfile, getUserVouchers, redeemLoyaltyPoints, saveVoucherCode } from "./loyalty";
import { loyaltyVoucherValue, mapLoyaltyProfile, mapVoucher } from "./loyalty-mappers";
import type { components } from "@vexenhanh/api-client";

const { request, refresh } = vi.hoisted(() => ({ request: vi.fn(), refresh: vi.fn() }));
vi.mock("./api", () => ({ apiRequest: request }));
vi.mock("./session", () => ({ refreshSessionIfNeeded: refresh }));
const member: components["schemas"]["PassengerLoyaltyDto_Output"] = { userId: "u1", name: "Khách", email: "a@example.com", status: "ACTIVE", memberSince: "2026-01-01T00:00:00Z", availablePoints: 150, earned12m: 250, tier: "SILVER", nextTier: { tier: "GOLD", minPoints: 1000, remaining: 750 }, policyVersion: 2, rules: { earnUnit: 10000, pointValue: 500, minRedeemPoints: 50, pointExpiryMonths: 12, voucherValidityDays: 45, tiers: [{ tier: "SILVER", minPoints: 200, multiplierPercent: 125 }, { tier: "GOLD", minPoints: 1000, multiplierPercent: 150 }] } };
const voucher: components["schemas"]["UserVoucherDto_Output"] = { userVoucherId: "v1", source: "LOYALTY_REDEMPTION", status: "RESERVED", promotionCode: null, name: "Voucher đổi điểm", discountAmount: "25000", discountType: "AMOUNT", discountValue: "25000", maxDiscount: null, minOrder: "0", expiresAt: "2026-12-01T00:00:00Z", createdAt: "2026-10-20T00:00:00Z" };

describe("loyalty integration", () => {
  beforeEach(() => { vi.clearAllMocks(); refresh.mockResolvedValue({ status: "ok", data: { rotated: false } }); });

  it("keeps money exact even when the multiplication exceeds safe-number range", () => {
    expect(loyaltyVoucherValue(1_000_000, 9_000_000_001)).toBe("9000000001000000");
    expect(() => loyaltyVoucherValue(1.5, 1000)).toThrow();
    expect(() => loyaltyVoucherValue(1, Number.MAX_SAFE_INTEGER + 1)).toThrow();
  });

  it("uses policy multipliers and does not invent a missing policy", () => {
    expect(mapLoyaltyProfile(member)).toMatchObject({ multiplierText: "×1.25", estimatedVoucherVnd: "75000", pointsRequiredForNextTier: 750 });
    expect(mapLoyaltyProfile({ ...member, rules: null })).toMatchObject({ rules: null, tiers: [], estimatedVoucherVnd: "0" });
    expect(mapVoucher(voucher)).toMatchObject({ code: "", status: "holding", statusLabel: "Đang giữ" });
  });

  it("sends a stable caller-supplied idempotency key and reads profile after redemption", async () => {
    const key = "00000000-0000-4000-8000-000000000001";
    request.mockResolvedValueOnce({ status: "ok", data: voucher }).mockResolvedValueOnce({ status: "ok", data: { ...member, availablePoints: 100 } });
    expect(await redeemLoyaltyPoints(50, key)).toMatchObject({ status: "ok", data: { remainingPoints: 100, voucherValueVnd: "25000" } });
    expect(request).toHaveBeenNthCalledWith(1, "/me/loyalty/redemptions", { method: "POST", headers: { "Idempotency-Key": key }, body: JSON.stringify({ points: 50 }) });
    expect(request).toHaveBeenNthCalledWith(2, "/me/loyalty");
  });

  it("uses offset/limit and REVERSAL for the revoke filter", async () => {
    request.mockImplementation(async (path: string) => path === "/me/loyalty" ? { status: "ok", data: member } : { status: "ok", data: { items: [{ id: "t1", type: "REVERSAL", points: -5, sourceLabel: "Hoàn vé", createdAt: "2026-10-20T00:00:00Z" }], total: 21, totals: { earned: 100, redeemed: 50, expired: 5 } } });
    expect(await getLoyaltyHistory(2, "revoke")).toMatchObject({ status: "ok", data: { pageIndex: 2, transactions: [{ type: "revoke", pointsChange: -5 }] } });
    expect(request).toHaveBeenCalledWith("/me/loyalty/transactions?offset=20&limit=20&type=REVERSAL");
  });

  it("saves with promotionCode and retrieves all voucher pages", async () => {
    request.mockResolvedValueOnce({ status: "ok", data: voucher });
    await saveVoucherCode(" thu10 ");
    expect(request).toHaveBeenLastCalledWith("/me/vouchers", { method: "POST", body: JSON.stringify({ promotionCode: "THU10" }) });
    request.mockResolvedValueOnce({ status: "ok", data: { items: [voucher], total: 2 } }).mockResolvedValueOnce({ status: "ok", data: { items: [{ ...voucher, userVoucherId: "v2", status: "USED" }], total: 2 } });
    expect(await getUserVouchers()).toMatchObject({ status: "ok", data: { availableCount: 0, holdingCount: 1, usedCount: 1 } });
    expect(request).toHaveBeenLastCalledWith("/me/vouchers?offset=1&limit=50");
  });

  it("propagates an API error without fake loyalty data", async () => {
    request.mockResolvedValueOnce({ status: "error", endpoint: "GET /me/loyalty", message: "Login required" });
    expect(await getLoyaltyProfile()).toMatchObject({ status: "error", message: "Login required" });
  });

  it("keeps the highest tier and missing policy distinct for the membership UI", () => {
    expect(mapLoyaltyProfile({ ...member, tier: "PLATINUM", nextTier: null })).toMatchObject({ nextTier: null, currentTier: "platinum", memberStatus: "ACTIVE" });
    expect(mapLoyaltyProfile({ ...member, rules: null, nextTier: null })).toMatchObject({ rules: null, tiers: [] });
  });

  it("shows percentage discounts as percentages and retains the code and cap", () => {
    expect(mapVoucher({ ...voucher, source: "SAVED_PROMOTION", status: "AVAILABLE", promotionCode: "THU10", discountAmount: null, discountType: "PERCENT", discountValue: "10", maxDiscount: "50000", minOrder: "300000" })).toMatchObject({ code: "THU10", discountLabel: "Giảm 10%", status: "available", scopeText: "Đơn tối thiểu 300.000đ · Giảm tối đa 50.000đ" });
    expect(mapVoucher(voucher)).toMatchObject({ discountLabel: "Giảm 25.000đ", code: "" });
  });
});
