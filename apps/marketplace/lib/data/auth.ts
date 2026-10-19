import { unavailable, type DataResult } from "./result";

/**
 * Payload yêu cầu gửi mã OTP đăng nhập hoặc xác thực email
 */
export interface RequestOtpPayload {
  readonly email: string;
}

/**
 * Payload đăng ký tài khoản mới (SCR-PSG-08)
 */
export interface RegisterPayload {
  readonly fullName: string;
  readonly email: string;
  readonly phone?: string;
}

/**
 * Payload xác minh mã OTP (SCR-PSG-09)
 */
export interface VerifyOtpPayload {
  readonly email: string;
  readonly otp: string;
}

/**
 * Gửi mã OTP đăng nhập qua email (SCR-PSG-07).
 * Endpoint 06 API: POST /auth/otp/send
 */
export async function requestLoginOtp(
  _payload: RequestOtpPayload
): Promise<DataResult<{ readonly sent: boolean; readonly expiresInSeconds: number }>> {
  return unavailable("POST /auth/otp/send");
}

/**
 * Đăng ký tài khoản hành khách mới (SCR-PSG-08).
 * Endpoint 06 API: POST /auth/register
 */
export async function registerAccount(
  _payload: RegisterPayload
): Promise<DataResult<{ readonly userId: string; readonly email: string }>> {
  return unavailable("POST /auth/register");
}

/**
 * Xác minh mã OTP 6 số để hoàn tất đăng nhập / tạo tài khoản (SCR-PSG-09).
 * Endpoint 06 API: POST /auth/otp/verify
 */
export async function verifyOtp(
  _payload: VerifyOtpPayload
): Promise<DataResult<{ readonly token: string; readonly user: import("./types").UserProfileData }>> {
  return unavailable("POST /auth/otp/verify");
}

/**
 * Lấy thông tin tài khoản cá nhân của người dùng (SCR-PSG-11).
 * Endpoint 06 API: GET /me/profile
 */
export async function getAccountProfile(): Promise<
  DataResult<import("./types").UserProfileData>
> {
  return unavailable("GET /me/profile");
}

/**
 * Lấy danh sách thông báo của người dùng (SCR-PSG-12).
 * Endpoint 06 API: GET /me/notifications
/**
 * Lấy cài đặt kênh nhận thông báo của người dùng (SCR-PSG-12).
 * Endpoint 06 API: GET /me/notification-preferences
 */
export async function getNotificationSettings(): Promise<
  DataResult<import("./types").NotificationSettingsData>
> {
  return unavailable("GET /me/notification-preferences");
}

/**
 * Cập nhật cài đặt kênh nhận thông báo của người dùng (SCR-PSG-12).
 * Endpoint 06 API: PUT /me/notification-preferences
 */
export async function updateNotificationSettings(
  _data: import("./types").NotificationSettingsData
): Promise<DataResult<{ readonly updated: boolean }>> {
  return unavailable("PUT /me/notification-preferences");
}

/**
 * Lấy danh sách thông báo của người dùng (SCR-PSG-12).
 * Endpoint 06 API: GET /me/notifications
 */
export async function getAccountNotifications(): Promise<
  DataResult<readonly import("./types").UserNotificationItem[]>
> {
  return unavailable("GET /me/notifications");
}

/**
 * Lấy danh sách phiên đăng nhập của tài khoản (SCR-PSG-13).
 * Endpoint 06 API: GET /me/sessions
 */
export async function getAccountSessions(): Promise<
  DataResult<readonly import("./types").UserSessionItem[]>
> {
  return unavailable("GET /me/sessions");
}

/**
 * Thu hồi một phiên đăng nhập cụ thể (SCR-PSG-13).
 * Endpoint 06 API: DELETE /me/sessions/{sessionId}
 */
export async function revokeSession(
  _sessionId: string
): Promise<DataResult<{ readonly revoked: boolean }>> {
  return unavailable("DELETE /me/sessions/{sessionId}");
}

/**
 * Đăng xuất tất cả các phiên đăng nhập khác (SCR-PSG-13).
 * Endpoint 06 API: POST /me/sessions/revoke-others
 */
export async function revokeAllOtherSessions(): Promise<
  DataResult<{ readonly revokedCount: number }>
> {
  return unavailable("POST /me/sessions/revoke-others");
}

/**
 * Lấy danh sách đánh giá chuyến xe của tôi (SCR-PSG-14).
 * Endpoint 06 API: GET /me/reviews
 */
export async function getAccountReviews(): Promise<
  DataResult<import("./types").UserReviewsData>
> {
  return unavailable("GET /me/reviews");
}

/**
 * Gửi đánh giá cho chuyến xe đã hoàn thành (SCR-PSG-14).
 * Endpoint 06 API: POST /me/reviews
 */
export async function submitTripReview(
  _payload: {
    readonly tripId: string;
    readonly rating: number;
    readonly content: string;
  }
): Promise<DataResult<{ readonly reviewId: string; readonly status: string }>> {
  return unavailable("POST /me/reviews");
}
