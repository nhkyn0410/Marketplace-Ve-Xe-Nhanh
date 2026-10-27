import { createHash, timingSafeEqual } from "node:crypto";
import type { VerifiedAccessToken } from "../iam/auth/token.service";

// Quyền xem / thao tác một booking (TASK-BTP-002/003): booking của hành khách chỉ chính họ; của khách vãng lai cần mã
// truy cập trả lúc đặt (header `X-Booking-Token`), hoặc mã phụ còn hạn cấp sau khi xác minh OTP tra cứu vé (`accessGrants` —
// chỉ nơi xem đơn / vé, hủy vé, khiếu nại chọn cột này). Không quyền → nơi gọi trả 404 như không tồn tại.

export const BOOKING_TOKEN_HEADER = "x-booking-token";

export function canAccessBooking(
  row: { userId: string | null; accessTokenHash: string; accessGrants?: readonly { tokenHash: string; expiresAt: Date }[] },
  user: VerifiedAccessToken | null,
  accessToken: string | undefined,
  now = new Date(),
): boolean {
  if (row.userId !== null) {
    return row.userId === user?.sub;
  }
  if (!accessToken) {
    return false;
  }
  const given = Buffer.from(hashBookingToken(accessToken), "hex");
  const grants = (row.accessGrants ?? []).filter((grant) => grant.expiresAt > now).map((grant) => grant.tokenHash);
  return [row.accessTokenHash, ...grants].some((hash) => {
    const stored = Buffer.from(hash, "hex");
    return given.length === stored.length && timingSafeEqual(given, stored);
  });
}

/** Cột mã phụ cần chọn kèm `userId` / `accessTokenHash` ở nơi cho phép dùng mã cấp sau OTP tra cứu vé. */
export const ACCESS_GRANT_SELECT = { select: { tokenHash: true, expiresAt: true } } as const;

export function hashBookingToken(token: string): string {
  return createHash("sha256").update(token).digest("hex");
}
