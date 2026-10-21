import type { NotificationLogSchema } from "@vexenhanh/types";
import type { z } from "zod";
import { apiRequest } from "@vexenhanh/ui/lib/auth/api-client";

export type NotificationLog = z.infer<typeof NotificationLogSchema>;
/** Khóa tải nhật ký gửi thông báo trong màn Hệ thống. */
export const NOTIFICATION_LOG_KEY = ["admin-system", "notifications"] as const;
/** Tra cứu từng trang bản gửi thông báo đã che địa chỉ người nhận. */
export function getNotificationLog(offset = 0, limit = 25): Promise<NotificationLog> {
  return apiRequest(`/admin/system/notifications?${new URLSearchParams({ offset: String(offset), limit: String(limit) })}`);
}
