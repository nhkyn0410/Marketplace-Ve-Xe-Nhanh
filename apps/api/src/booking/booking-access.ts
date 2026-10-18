import { createHash, timingSafeEqual } from "node:crypto";
import type { VerifiedAccessToken } from "../iam/auth/token.service";

// Quyền xem / thao tác một booking (TASK-BTP-002/003): booking của hành khách chỉ chính họ; của khách vãng lai cần mã
// truy cập trả lúc đặt (header `X-Booking-Token`). Không quyền → nơi gọi trả 404 như không tồn tại.

export const BOOKING_TOKEN_HEADER = "x-booking-token";

export function canAccessBooking(
  row: { userId: string | null; accessTokenHash: string },
  user: VerifiedAccessToken | null,
  accessToken: string | undefined,
): boolean {
  if (row.userId !== null) {
    return row.userId === user?.sub;
  }
  if (!accessToken) {
    return false;
  }
  const given = Buffer.from(hashBookingToken(accessToken), "hex");
  const stored = Buffer.from(row.accessTokenHash, "hex");
  return given.length === stored.length && timingSafeEqual(given, stored);
}

export function hashBookingToken(token: string): string {
  return createHash("sha256").update(token).digest("hex");
}
