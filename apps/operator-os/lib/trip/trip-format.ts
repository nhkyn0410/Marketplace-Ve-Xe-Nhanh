// Chữ hiển thị cho màn Chuyến xe (Figma "Nhà xe · Chuyến xe · TRN-003"). Hàm thuần để test được.
// Mọi giờ hiển thị và nhập theo giờ Việt Nam (UTC+7, không đổi giờ mùa); API nhận / trả ISO 8601.
import { formatDuration } from "../route/route-format";
import { STOP_POINT_TYPE_LABELS } from "../stop-point/stop-point-format";
import type { TripSeatStatus, TripStatus } from "./trip-api";

type Tone = "success" | "warning" | "neutral" | "danger";

/** Nhãn + màu trạng thái chuyến (Figma "Design handoff" — nhãn tiếng Việt). */
export const TRIP_STATUS: Record<TripStatus, { label: string; tone: Tone }> = {
  DRAFT: { label: "Nháp", tone: "neutral" },
  OPEN_FOR_SALE: { label: "Đang mở bán", tone: "success" },
  LOCKED: { label: "Tạm dừng bán", tone: "warning" },
  SOLD_OUT: { label: "Hết chỗ", tone: "neutral" },
  BOARDING: { label: "Đang đón khách", tone: "success" },
  DEPARTED: { label: "Đã khởi hành", tone: "neutral" },
  IN_PROGRESS: { label: "Đang chạy", tone: "success" },
  COMPLETED: { label: "Hoàn thành", tone: "neutral" },
  CANCELLED: { label: "Đã hủy", tone: "danger" },
  INCIDENT: { label: "Có sự cố", tone: "danger" }
};

/** Thứ tự trạng thái trong ô lọc: theo vòng đời của chuyến. */
export const TRIP_STATUS_ORDER: TripStatus[] = [
  "DRAFT",
  "OPEN_FOR_SALE",
  "LOCKED",
  "SOLD_OUT",
  "BOARDING",
  "DEPARTED",
  "IN_PROGRESS",
  "COMPLETED",
  "CANCELLED",
  "INCIDENT"
];

/** Nhãn trạng thái của một chỗ trên sơ đồ ghế theo chuyến. */
export const TRIP_SEAT_STATUS: Record<TripSeatStatus, string> = {
  AVAILABLE: "Còn trống",
  HOLDING: "Đang giữ",
  BOOKED: "Đã bán",
  CHECKED_IN: "Đã lên xe",
  BLOCKED: "Đã khóa"
};

/** Thứ tự trạng thái chỗ trong phần chú giải. */
export const TRIP_SEAT_STATUS_ORDER: TripSeatStatus[] = ["AVAILABLE", "HOLDING", "BOOKED", "CHECKED_IN", "BLOCKED"];

const VN_OFFSET = "+07:00";
const VN_OFFSET_MS = 7 * 3_600_000;
const DAY_MS = 24 * 3_600_000;
const WEEKDAYS = ["Chủ Nhật", "Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy"];

const pad = (value: number) => String(value).padStart(2, "0");

/** Ngày + giờ trên đồng hồ Việt Nam của một mốc thời gian: `{ date: "2026-10-08", time: "06:00" }`. */
export function toLocalParts(iso: string): { date: string; time: string } {
  const shifted = new Date(new Date(iso).getTime() + VN_OFFSET_MS);
  return {
    date: `${shifted.getUTCFullYear()}-${pad(shifted.getUTCMonth() + 1)}-${pad(shifted.getUTCDate())}`,
    time: `${pad(shifted.getUTCHours())}:${pad(shifted.getUTCMinutes())}`
  };
}

/** Ghép ngày (`2026-10-08`) và giờ (`06:00`) theo giờ Việt Nam thành ISO 8601 có múi giờ để gửi API. */
export function fromLocalParts(date: string, time: string): string {
  return `${date}T${time}:00${VN_OFFSET}`;
}

/** Ngày hôm nay theo giờ Việt Nam, dạng `2026-10-08` (giá trị của ô chọn ngày). */
export function todayLocalDate(now: Date = new Date()): string {
  return toLocalParts(now.toISOString()).date;
}

/** Ngày liền sau của một ngày `2026-10-08` → `2026-10-09`. */
export function nextLocalDate(date: string): string {
  return toLocalParts(new Date(new Date(fromLocalParts(date, "00:00")).getTime() + DAY_MS).toISOString()).date;
}

/** Giờ theo giờ Việt Nam: `06:00`. */
export function formatTime(iso: string): string {
  return toLocalParts(iso).time;
}

/** Ngày theo giờ Việt Nam: `08/10/2026`. */
export function formatDay(iso: string): string {
  const [year, month, day] = toLocalParts(iso).date.split("-");
  return `${day}/${month}/${year}`;
}

/** Thứ + ngày theo giờ Việt Nam: `Thứ Năm, 08/10/2026`. */
export function formatWeekdayDate(iso: string): string {
  const weekday = new Date(new Date(iso).getTime() + VN_OFFSET_MS).getUTCDay();
  return `${WEEKDAYS[weekday]}, ${formatDay(iso)}`;
}

/** Dòng dưới giờ đến: `Cùng ngày` hoặc thứ + ngày nếu đến vào hôm khác ngày khởi hành. */
export function arrivalDayNote(departureAt: string, arrivalAt: string): string {
  return toLocalParts(departureAt).date === toLocalParts(arrivalAt).date ? "Cùng ngày" : formatWeekdayDate(arrivalAt);
}

/** Thời lượng chuyến: `5 giờ 30 phút`. */
export function tripDurationLabel(departureAt: string, arrivalAt: string): string {
  return formatDuration((new Date(arrivalAt).getTime() - new Date(departureAt).getTime()) / 1000);
}

/** Cột "Xe" của danh sách, dòng dưới: số chỗ của chuyến. */
export function seatCountLabel(count: number): string {
  return `${count} chỗ`;
}

/** Dòng tiêu đề phụ của trang chi tiết: `Khởi hành 08:30 Thứ Năm, 08/10/2026 · đến 14:00 cùng ngày · xe 51B-377.60`. */
export function tripHeadline(trip: { departureAt: string; arrivalAt: string }, plate: string | null): string {
  const arrival = arrivalDayNote(trip.departureAt, trip.arrivalAt);
  return [
    `Khởi hành ${formatTime(trip.departureAt)} ${formatWeekdayDate(trip.departureAt)}`,
    `đến ${formatTime(trip.arrivalAt)} ${arrival === "Cùng ngày" ? "cùng ngày" : arrival}`,
    plate ? `xe ${plate}` : "chưa gắn xe"
  ].join(" · ");
}

type StopMetaInput = {
  type: keyof typeof STOP_POINT_TYPE_LABELS;
  role: "ORIGIN" | "INTERMEDIATE" | "DESTINATION";
  allowPickup: boolean;
  allowDropoff: boolean;
};

/** Dòng mô tả một điểm dừng: `Bến xe · Điểm đầu · Cho đón`, `Trạm dừng nghỉ · Không đón trả khách` (BR-79). */
export function stopMetaLabel(stop: StopMetaInput): string {
  const parts = [STOP_POINT_TYPE_LABELS[stop.type]];
  if (stop.role === "ORIGIN") {
    parts.push("Điểm đầu");
  } else if (stop.role === "DESTINATION") {
    parts.push("Điểm cuối");
  }
  if (stop.allowPickup && stop.allowDropoff) {
    parts.push("Cho đón và trả");
  } else if (stop.allowPickup) {
    parts.push("Cho đón");
  } else if (stop.allowDropoff) {
    parts.push("Cho trả");
  } else {
    parts.push("Không đón trả khách");
  }
  return parts.join(" · ");
}
