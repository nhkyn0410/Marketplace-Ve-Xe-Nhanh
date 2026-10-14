// Chữ hiển thị cho thẻ "Phiên đăng nhập" của màn Tài khoản (Figma "01 · Tài khoản / Bảo mật"). Hàm thuần để test được.
import type { Session } from "./session-api";

const MINUTE_MS = 60_000;
const HOUR_MS = 60 * MINUTE_MS;
const DAY_MS = 24 * HOUR_MS;

/** Cột "Hoạt động": lần cuối phiên được dùng, tính lùi từ bây giờ — `Vừa xong`, `5 phút trước`, `2 ngày trước`. */
export function lastUsedLabel(lastUsedAt: string, nowMs: number): string {
  const elapsed = nowMs - new Date(lastUsedAt).getTime();
  if (elapsed < MINUTE_MS) {
    return "Vừa xong";
  }
  if (elapsed < HOUR_MS) {
    return `${Math.floor(elapsed / MINUTE_MS)} phút trước`;
  }
  if (elapsed < DAY_MS) {
    return `${Math.floor(elapsed / HOUR_MS)} giờ trước`;
  }
  return `${Math.floor(elapsed / DAY_MS)} ngày trước`;
}

/** Phiên đang dùng đứng đầu, còn lại theo lần dùng gần nhất. */
export function sortSessions(sessions: readonly Session[]): Session[] {
  return [...sessions].sort(
    (a, b) =>
      Number(b.current) - Number(a.current) || new Date(b.lastUsedAt).getTime() - new Date(a.lastUsedAt).getTime()
  );
}

/** Các phiên sẽ bị thu hồi khi bấm "Đăng xuất các phiên khác". */
export function otherSessions(sessions: readonly Session[]): Session[] {
  return sessions.filter((session) => !session.current);
}
