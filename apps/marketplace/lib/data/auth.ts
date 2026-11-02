"use server";

import { cookies } from "next/headers";
import { z } from "zod";
import type { components } from "@vexenhanh/api-client";
import { apiRequest, ACCESS_COOKIE } from "./api";
import { clearSession, refreshSessionIfNeeded, saveSession, type TokenPair } from "./session";
import { mapPreferences, mapProfile, mapSessions, type PreferencesResponse, type ProfileResponse, type SavedPassengersResponse, type SessionsResponse } from "./auth-mapping";
import { failed, ok, unavailable, type DataResult } from "./result";
import type { NotificationSettingsData, UserNotificationItem, UserProfileData, UserReviewsData, UserSessionItem } from "./types";

export interface RequestOtpPayload { readonly email: string }
export interface RegisterPayload { readonly email: string }
export interface VerifyOtpPayload { readonly email: string; readonly otp: string }
type Schemas = components["schemas"];
const registrationSchema = z.object({ email: z.email() });

async function authenticatedRequest<T>(path: string, init: RequestInit): Promise<DataResult<T>> {
  const refresh = await refreshSessionIfNeeded();
  return refresh.status === "ok" ? apiRequest<T>(path, init) : refresh;
}

/** Gửi OTP bằng endpoint thực tế; API chỉ xác nhận đã nhận yêu cầu. */
export async function requestLoginOtp(payload: RequestOtpPayload): Promise<DataResult<{ sent: boolean }>> {
  const email = z.email().safeParse(payload.email);
  if (!email.success) return failed("POST /auth/otp/request", "Địa chỉ email không hợp lệ.");
  const result = await apiRequest("/auth/otp/request", { method: "POST", body: JSON.stringify({ email: email.data }) });
  return result.status === "ok" ? ok({ sent: true }) : result;
}

/** Đăng ký bằng email theo hợp đồng; hồ sơ được cập nhật riêng sau xác minh. */
export async function registerAccount(payload: RegisterPayload): Promise<DataResult<{ email: string }>> {
  const parsed = registrationSchema.safeParse(payload);
  if (!parsed.success) return failed("POST /auth/register", "Địa chỉ email không hợp lệ.");
  const result = await apiRequest("/auth/register", { method: "POST", body: JSON.stringify({ email: parsed.data.email }) });
  if (result.status !== "ok") return result;
  return ok({ email: parsed.data.email });
}

/** Xác minh OTP, lưu token vào cookie httpOnly rồi trả metadata không chứa credential. */
export async function verifyOtp(payload: VerifyOtpPayload): Promise<DataResult<{ authenticated: boolean }>> {
  const parsed = z.object({ email: z.email(), otp: z.string().regex(/^\d{6}$/) }).safeParse(payload);
  if (!parsed.success) return failed("POST /auth/otp/verify", "Vui lòng nhập email hợp lệ và mã OTP gồm 6 chữ số.");
  const result = await apiRequest<TokenPair>("/auth/otp/verify", { method: "POST", body: JSON.stringify(parsed.data) });
  if (result.status !== "ok") return result;
  if (result.data.scope !== "passenger") return failed("POST /auth/otp/verify", "Tài khoản không thuộc cổng hành khách.");
  await saveSession(result.data);
  return ok({ authenticated: true });
}

/** Bootstrap phiên và xoay token hết hạn trong Server Action; RSC tải lại sau khi xoay. */
export async function ensureMarketplaceSession(): Promise<DataResult<{ rotated: boolean; user: { fullName: string; email: string } | null }>> {
  const refreshed = await refreshSessionIfNeeded();
  if (refreshed.status !== "ok") return refreshed;
  if (!(await cookies()).get(ACCESS_COOKIE)?.value) return ok({ rotated: refreshed.data.rotated, user: null });
  const profile = await apiRequest<ProfileResponse>("/me/profile");
  if (profile.status !== "ok") return profile;
  return ok({ rotated: refreshed.data.rotated, user: { fullName: profile.data.name ?? profile.data.email, email: profile.data.email } });
}

/** Thu hồi phiên hiện tại ở backend trước khi xóa cookie web. */
export async function logoutAccount(): Promise<DataResult<{ loggedOut: boolean }>> {
  const refreshed = await refreshSessionIfNeeded();
  if (refreshed.status !== "ok") return refreshed;
  if ((await cookies()).get(ACCESS_COOKIE)?.value) {
    const result = await apiRequest("/auth/logout", { method: "POST" });
    if (result.status !== "ok") return result;
  }
  await clearSession();
  return ok({ loggedOut: true });
}

/** Lấy hồ sơ thật cùng danh sách hành khách đã lưu. */
export async function getAccountProfile(): Promise<DataResult<UserProfileData>> {
  const profile = await apiRequest<ProfileResponse>("/me/profile");
  if (profile.status !== "ok") return profile;
  const saved = await apiRequest<SavedPassengersResponse>("/me/saved-passengers");
  return ok(mapProfile(profile.data, saved.status === "ok" ? saved.data : undefined));
}

/** Cập nhật tên, số điện thoại và ngày sinh theo hợp đồng hồ sơ hành khách. */
export async function updateAccountProfile(payload: { name?: string; phone?: string | null; dateOfBirth?: string | null }): Promise<DataResult<ProfileResponse>> {
  const parsed = z.object({ name: z.string().trim().min(1).max(100).optional(), phone: z.string().regex(/^(0|\+84)\d{9}$/).nullable().optional(), dateOfBirth: z.iso.date().nullable().optional() }).strict().refine((value) => Object.keys(value).length > 0).safeParse(payload);
  if (!parsed.success) return failed("PUT /me/profile", "Thông tin hồ sơ không hợp lệ; điện thoại cần 10 số hoặc đầu +84.");
  return authenticatedRequest("/me/profile", { method: "PUT", body: JSON.stringify(parsed.data) });
}

/** Tạo hoặc sửa một hành khách đã lưu của tài khoản đang đăng nhập. */
export async function saveAccountPassenger(payload: { fullName: string; phone: string | null }, passengerId?: string): Promise<DataResult<{ saved: boolean }>> {
  const parsed = z.object({ fullName: z.string().trim().min(1).max(100), phone: z.string().regex(/^(0|\+84)\d{9}$/).nullable() }).safeParse(payload);
  if (!parsed.success) return failed("POST /me/saved-passengers", "Họ tên hoặc số điện thoại hành khách không hợp lệ.");
  if (passengerId && !z.uuid().safeParse(passengerId).success) return failed("PUT /me/saved-passengers", "Mã hành khách không hợp lệ.");
  const result = await authenticatedRequest(`/me/saved-passengers${passengerId ? `/${passengerId}` : ""}`, { method: passengerId ? "PUT" : "POST", body: JSON.stringify(parsed.data) });
  return result.status === "ok" ? ok({ saved: true }) : result;
}

/** Xóa hành khách đã lưu bằng id do backend cấp. */
export async function deleteAccountPassenger(passengerId: string): Promise<DataResult<{ deleted: boolean }>> {
  if (!z.uuid().safeParse(passengerId).success) return failed("DELETE /me/saved-passengers", "Mã hành khách không hợp lệ.");
  const result = await authenticatedRequest(`/me/saved-passengers/${passengerId}`, { method: "DELETE" });
  return result.status === "ok" ? ok({ deleted: true }) : result;
}

/** Lấy các tùy chọn thông báo thật theo từng loại. */
export async function getNotificationSettings(): Promise<DataResult<NotificationSettingsData>> {
  const result = await apiRequest<PreferencesResponse>("/me/notification-preferences");
  return result.status === "ok" ? ok(mapPreferences(result.data)) : result;
}

/** Lưu từng tùy chọn đã đổi theo API cập nhật một loại thông báo. */
export async function updateNotificationSettings(data: NotificationSettingsData): Promise<DataResult<{ updated: boolean }>> {
  const refresh = await refreshSessionIfNeeded();
  if (refresh.status !== "ok") return refresh;
  const current = await apiRequest<PreferencesResponse>("/me/notification-preferences");
  if (current.status !== "ok") return current;
  for (const item of data.optionalItems) {
    const existing = current.data.items.find((entry) => entry.kind === item.id && !entry.mandatory);
    if (!existing) return failed("PUT /me/notification-preferences", "Loại thông báo không hợp lệ. Vui lòng tải lại trang.");
    if (existing.email === item.emailEnabled && existing.push === item.pushEnabled) continue;
    const result = await apiRequest("/me/notification-preferences", { method: "PUT", body: JSON.stringify({ kind: existing.kind, email: item.emailEnabled, push: item.pushEnabled }) });
    if (result.status !== "ok") return result;
  }
  return ok({ updated: true });
}

/** Backend trả nhật ký gửi, chưa có hợp đồng hộp thư với nội dung và trạng thái đã đọc. */
export async function getAccountNotifications(): Promise<DataResult<readonly UserNotificationItem[]>> {
  return unavailable("GET /me/notifications (thiếu hợp đồng hộp thư)");
}

/** Lấy tất cả session family đang hoạt động qua cursor của API. */
export async function getAccountSessions(): Promise<DataResult<readonly UserSessionItem[]>> {
  const items: UserSessionItem[] = [];
  let cursor: string | null = null;
  do {
    const result: DataResult<SessionsResponse> = await apiRequest(`/auth/sessions?limit=100${cursor ? `&cursor=${encodeURIComponent(cursor)}` : ""}`);
    if (result.status !== "ok") return result;
    items.push(...mapSessions(result.data));
    cursor = result.data.nextCursor;
  } while (cursor);
  return ok(items);
}

/** Thu hồi đúng session family của hành khách, API trả 204 khi hoàn thành. */
export async function revokeSession(sessionId: string): Promise<DataResult<{ revoked: boolean }>> {
  if (!z.uuid().safeParse(sessionId).success) return failed("DELETE /auth/sessions", "Mã phiên không hợp lệ.");
  const result = await authenticatedRequest(`/auth/sessions/${sessionId}`, { method: "DELETE" });
  return result.status === "ok" ? ok({ revoked: true }) : result;
}

/** Thu hồi từng phiên khác bằng API hiện có; không giả định có endpoint revoke-others. */
export async function revokeAllOtherSessions(): Promise<DataResult<{ revokedCount: number }>> {
  const refresh = await refreshSessionIfNeeded();
  if (refresh.status !== "ok") return refresh;
  const sessions = await getAccountSessions();
  if (sessions.status !== "ok") return sessions;
  let revokedCount = 0;
  for (const session of sessions.data.filter((item) => !item.isCurrent)) {
    const result = await revokeSession(session.id);
    if (result.status !== "ok") return result;
    revokedCount++;
  }
  return ok({ revokedCount });
}

/** Tổng hợp đánh giá từ các đơn sở hữu và endpoint đánh giá của từng đơn. */
export async function getAccountReviews(): Promise<DataResult<UserReviewsData>> {
  const bookings: Schemas["PassengerBookingPageDto_Output"]["items"] = [];
  let cursor: string | null = null;
  do {
    const result: DataResult<Schemas["PassengerBookingPageDto_Output"]> = await apiRequest(`/me/bookings?limit=100${cursor ? `&cursor=${cursor}` : ""}`);
    if (result.status !== "ok") return result;
    bookings.push(...result.data.items);
    cursor = result.data.nextCursor;
  } while (cursor);
  const pendingTrips: UserReviewsData["pendingTrips"][number][] = [];
  const completedReviews: UserReviewsData["completedReviews"][number][] = [];
  for (const booking of bookings) {
    const response = await apiRequest<Schemas["CustomerReviewDto_Output"]>(`/bookings/${booking.bookingId}/review`);
    if (response.status !== "ok") return response;
    const review = response.data.review;
    if (review) completedReviews.push({ id: review.reviewId, operatorName: review.operatorName, routeName: review.routeName, reviewedDateText: new Date(review.createdAt).toLocaleDateString("vi-VN", { timeZone: "Asia/Ho_Chi_Minh" }), rating: review.rating, content: review.comment ?? "", statusLabel: review.status === "VISIBLE" ? "Đang hiển thị" : review.status === "HIDDEN" ? "Đã ẩn" : "Đang kiểm duyệt" });
    else if (response.data.canReview) pendingTrips.push({ bookingId: booking.bookingId, tripId: booking.tripId, operatorName: booking.operatorName, routeName: booking.routeName, completedDateText: new Date(booking.departureAt).toLocaleDateString("vi-VN", { timeZone: "Asia/Ho_Chi_Minh" }), bookingCode: booking.bookingCode });
  }
  return ok({ pendingTrips, completedReviews });
}

/** Gửi đánh giá đúng đơn đặt vé; API dùng bookingId thay vì tripId. */
export async function submitTripReview(payload: { bookingId?: string; tripId: string; rating: number; content: string }): Promise<DataResult<{ reviewId: string; status: string }>> {
  const parsed = z.object({ bookingId: z.uuid(), rating: z.int().min(1).max(5), comment: z.string().trim().max(1000) }).safeParse({ bookingId: payload.bookingId, rating: payload.rating, comment: payload.content });
  if (!parsed.success) return failed("POST /bookings/{bookingId}/review", "Đánh giá cần đơn hợp lệ, từ 1–5 sao và nhận xét tối đa 1.000 ký tự.");
  const result = await authenticatedRequest<Schemas["ReviewDto_Output"]>(`/bookings/${parsed.data.bookingId}/review`, { method: "POST", body: JSON.stringify({ rating: parsed.data.rating, comment: parsed.data.comment || null }) });
  return result.status === "ok" ? ok({ reviewId: result.data.reviewId, status: result.data.status }) : result;
}
