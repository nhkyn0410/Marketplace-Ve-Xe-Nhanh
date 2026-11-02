import { describe, expect, it } from "vitest";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { canAccessBooking, hashBookingToken } from "./booking-access";

const now = new Date("2026-10-27T10:00:00Z");
const guest = (grants: { token: string; expiresAt: Date }[] = []) => ({
  userId: null,
  accessTokenHash: hashBookingToken("ma-goc"),
  accessGrants: grants.map((grant) => ({ tokenHash: hashBookingToken(grant.token), expiresAt: grant.expiresAt })),
});

describe("canAccessBooking", () => {
  it("khách vãng lai: mã gốc lúc đặt hoặc mã phụ còn hạn (cấp sau OTP tra cứu vé); mã phụ hết hạn / sai mã / thiếu mã → không", () => {
    const row = guest([
      { token: "ma-phu", expiresAt: new Date(now.getTime() + 60_000) },
      { token: "ma-het-han", expiresAt: new Date(now.getTime() - 1) },
    ]);
    expect(canAccessBooking(row, null, "ma-goc", now)).toBe(true);
    expect(canAccessBooking(row, null, "ma-phu", now)).toBe(true);
    expect(canAccessBooking(row, null, "ma-het-han", now)).toBe(false);
    expect(canAccessBooking(row, null, "sai", now)).toBe(false);
    expect(canAccessBooking(row, null, undefined, now)).toBe(false);
  });

  it("nơi không chọn mã phụ (thanh toán, tranh chấp) chỉ nhận mã gốc", () => {
    const { accessGrants: _grants, ...row } = guest([{ token: "ma-phu", expiresAt: new Date(now.getTime() + 60_000) }]);
    expect(canAccessBooking(row, null, "ma-phu", now)).toBe(false);
    expect(canAccessBooking(row, null, "ma-goc", now)).toBe(true);
  });

  it("đơn đặt bằng tài khoản: chỉ chính tài khoản đó, mã nào cũng không thay được", () => {
    const row = { ...guest([{ token: "ma-phu", expiresAt: new Date(now.getTime() + 60_000) }]), userId: "u1" };
    expect(canAccessBooking(row, { sub: "u1" } as VerifiedAccessToken, undefined, now)).toBe(true);
    expect(canAccessBooking(row, { sub: "u2" } as VerifiedAccessToken, "ma-goc", now)).toBe(false);
    expect(canAccessBooking(row, null, "ma-phu", now)).toBe(false);
  });
});
