import { cookies } from "next/headers";

const COOKIE_OPTIONS = { httpOnly: true, secure: process.env.NODE_ENV === "production", sameSite: "lax" as const, path: "/", maxAge: 60 * 60 * 24 * 30 };

/** Lấy quyền truy cập booking từ cookie chỉ máy chủ đọc được. */
export async function bookingHeaders(bookingId: string): Promise<Record<string, string>> {
  const token = (await cookies()).get(`vxn_booking_${bookingId}`)?.value;
  return token ? { "X-Booking-Token": token } : {};
}

/** Lưu quyền truy cập khách vãng lai và booking đã tạo từ phiên giữ chỗ. */
export async function rememberBooking(holdId: string, bookingId: string, accessToken: string): Promise<void> {
  const jar = await cookies();
  jar.set(`vxn_booking_${bookingId}`, accessToken, COOKIE_OPTIONS);
  jar.set(`vxn_hold_booking_${holdId}`, bookingId, COOKIE_OPTIONS);
}

/**
 * Lưu mã truy cập phụ cấp sau OTP tra cứu vé, sống đúng tới hết phiên tra cứu. Trình duyệt đã có mã gốc lúc đặt thì giữ mã
 * gốc (dài hạn), không ghi đè.
 */
export async function rememberLookupBookingAccess(bookingId: string, accessToken: string, maxAgeSeconds: number): Promise<void> {
  const jar = await cookies();
  if (jar.get(`vxn_booking_${bookingId}`)?.value) return;
  jar.set(`vxn_booking_${bookingId}`, accessToken, { ...COOKIE_OPTIONS, maxAge: maxAgeSeconds });
}

/** Đọc booking đã tạo thành công từ phiên giữ chỗ để xử lý thao tác gửi lặp. */
export async function rememberedBooking(holdId: string): Promise<string | undefined> {
  return (await cookies()).get(`vxn_hold_booking_${holdId}`)?.value;
}
