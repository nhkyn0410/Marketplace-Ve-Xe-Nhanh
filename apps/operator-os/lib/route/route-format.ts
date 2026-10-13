// Chữ hiển thị cho màn Tuyến đường (Figma "Nhà xe · Tuyến đường · TRN-013"). Hàm thuần để test được.
import type { RouteStatus } from "./route-api";

/** Nhãn + màu trạng thái tuyến. */
export const ROUTE_STATUS: Record<RouteStatus, { label: string; tone: "success" | "neutral" }> = {
  ACTIVE: { label: "Hoạt động", tone: "success" },
  INACTIVE: { label: "Ngừng dùng", tone: "neutral" }
};

/** Thứ tự trạng thái trong ô lọc và ô chọn. */
export const ROUTE_STATUS_ORDER: RouteStatus[] = ["ACTIVE", "INACTIVE"];

/** Chữ thay cho số liệu chưa có: quãng đường / thời gian chỉ được tính khi lưu (ADR-027). */
export const COMPUTED_ON_SAVE = "Tính khi lưu";

/** Quãng đường theo km: từ 10 km làm tròn số nguyên, ngắn hơn giữ một chữ số thập phân (`2,6 km`). */
export function formatDistance(meters: number): string {
  const km = meters / 1000;
  if (km >= 10 || km === 0) {
    return `${Math.round(km)} km`;
  }
  return `${(Math.round(km * 10) / 10).toString().replace(".", ",")} km`;
}

/** Thời gian chạy: `7 giờ 10 phút`, `4 giờ 05 phút`, `3 giờ`, `25 phút`. */
export function formatDuration(seconds: number): string {
  const totalMinutes = Math.round(seconds / 60);
  const hours = Math.floor(totalMinutes / 60);
  const minutes = totalMinutes % 60;
  if (hours === 0) {
    return `${minutes} phút`;
  }
  return minutes === 0 ? `${hours} giờ` : `${hours} giờ ${String(minutes).padStart(2, "0")} phút`;
}

/** Dòng số liệu của một chặng giữa hai điểm dừng: `62 km · 1 giờ 25 phút`. */
export function legLabel(distanceMeters: number, durationSeconds: number): string {
  return `${formatDistance(distanceMeters)} · ${formatDuration(durationSeconds)}`;
}

/** Cột "Số điểm dừng". */
export function stopCountLabel(count: number): string {
  return `${count} điểm`;
}

const DATE_TIME_FORMAT = new Intl.DateTimeFormat("vi-VN", {
  timeZone: "Asia/Ho_Chi_Minh",
  day: "2-digit",
  month: "2-digit",
  year: "numeric",
  hour: "2-digit",
  minute: "2-digit",
  hourCycle: "h23"
});

/** Ngày giờ theo giờ Việt Nam, dạng `05/10/2026 14:20`. */
export function formatDateTime(iso: string): string {
  const parts = Object.fromEntries(DATE_TIME_FORMAT.formatToParts(new Date(iso)).map((part) => [part.type, part.value]));
  return `${parts.day}/${parts.month}/${parts.year} ${parts.hour}:${parts.minute}`;
}
