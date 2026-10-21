import type { components } from "@vexenhanh/api-client";
import type { NotificationSettingItem, NotificationSettingsData, UserProfileData, UserSessionItem } from "./types";

type Schemas = components["schemas"];
export type ProfileResponse = Schemas["PassengerProfileDto_Output"];
export type SavedPassengersResponse = Schemas["SavedPassengerListDto_Output"];
export type SessionsResponse = Schemas["SessionListResponseDto_Output"];
export type PreferencesResponse = Schemas["PreferencesDto_Output"];

const notificationLabels: Record<PreferencesResponse["items"][number]["kind"], string> = {
  BOOKING_CONFIRMED: "Xác nhận đặt vé", TICKETS_CANCELLED: "Hủy vé", REFUND_SUCCEEDED: "Hoàn tiền thành công",
  TRIP_CHANGED: "Thay đổi chuyến", TRIP_CANCELLED: "Hủy chuyến", MANUAL_REFUND: "Hoàn tiền thủ công",
  CASE_UPDATED: "Cập nhật yêu cầu hỗ trợ", OPERATIONS_ALERT: "Thông báo vận hành", LOYALTY_UPDATED: "Điểm và hạng VXN Plus", PROMOTION: "Khuyến mãi và voucher"
};

/** Chuyển hồ sơ thật sang dữ liệu hiển thị; các chỉ số chưa tải được giữ trống. */
export function mapProfile(profile: ProfileResponse, saved?: SavedPassengersResponse): UserProfileData {
  return {
    id: profile.userId, fullName: profile.name ?? "", email: profile.email, emailVerified: profile.emailVerified, phone: profile.phone ?? "",
    ...(profile.dateOfBirth ? { dateOfBirth: profile.dateOfBirth } : {}),
    ...(profile.image ? { avatarUrl: profile.image } : {}),
    ...(saved ? { savedPassengers: saved.items.map((item) => ({ id: item.passengerId, name: item.fullName, phone: item.phone ?? "", idNumber: "", isSelf: false })) } : {})
  };
}

/** Chuyển danh sách session family, không suy đoán vị trí từ địa chỉ IP. */
export function mapSessions(response: SessionsResponse): UserSessionItem[] {
  return response.items.map((item) => ({
    id: item.sessionId, deviceName: item.deviceLabel, ipAddress: item.ipAddress ?? "Không có dữ liệu",
    locationText: "Không có dữ liệu vị trí", loginDateText: new Date(item.createdAt).toLocaleString("vi-VN", { timeZone: "Asia/Ho_Chi_Minh" }),
    lastActiveText: new Date(item.lastUsedAt).toLocaleString("vi-VN", { timeZone: "Asia/Ho_Chi_Minh" }), isCurrent: item.current
  }));
}

/** Chuyển đúng từng loại thông báo từ hợp đồng API sang công tắc Email/Push. */
export function mapPreferences(response: PreferencesResponse): NotificationSettingsData {
  const items: NotificationSettingItem[] = response.items.map((item) => ({
    id: item.kind, title: notificationLabels[item.kind], description: item.mandatory ? "Thông báo bắt buộc theo chính sách dịch vụ." : "Tùy chọn kênh nhận thông báo.",
    isMandatory: item.mandatory, emailEnabled: item.email, pushEnabled: item.push
  }));
  return { mandatoryItems: items.filter((item) => item.isMandatory), optionalItems: items.filter((item) => !item.isMandatory) };
}
