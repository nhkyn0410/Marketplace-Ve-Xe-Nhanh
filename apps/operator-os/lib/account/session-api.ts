// Gọi API phiên đăng nhập của chính tài khoản đang dùng (05 API §7.1; FR-IAM-15, TASK-IAM-005 Q1 / Q7).
import type { components } from "@vexenhanh/api-client";

import { apiRequest } from "../auth/api-client";

type SessionPage = components["schemas"]["SessionListResponseDto_Output"];

/** Một phiên = một thiết bị / trình duyệt đang đăng nhập. IP đã được máy chủ che bớt. */
export type Session = SessionPage["items"][number];

/** Mọi phiên đang hoạt động của tài khoản; đi hết các trang vì nút "Đăng xuất các phiên khác" cần đủ danh sách. */
export async function listAllSessions(): Promise<Session[]> {
  const items: Session[] = [];
  let cursor: string | null = null;
  do {
    const query = new URLSearchParams({ limit: "100" });
    if (cursor) {
      query.set("cursor", cursor);
    }
    const page: SessionPage = await apiRequest<SessionPage>(`/auth/sessions?${query}`);
    items.push(...page.items);
    cursor = page.nextCursor;
  } while (cursor);
  return items;
}

/** Thu hồi một phiên: thiết bị đó bị đăng xuất. Gọi lại với phiên đã thu hồi vẫn thành công. */
export function revokeSession(sessionId: string): Promise<void> {
  return apiRequest<void>(`/auth/sessions/${sessionId}`, { method: "DELETE" });
}
