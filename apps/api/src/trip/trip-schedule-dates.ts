// Tính ngày / giờ cho lịch chuyến lặp lại (TASK-TRN-007). Giờ Việt Nam = UTC+7 cố định (không đổi giờ theo mùa), nên
// "06:00 ngày D giờ VN" = D 06:00 UTC − 7 giờ. Ngày (DATE Postgres) đi qua Prisma dưới dạng `Date` lúc 00:00 UTC.

const MINUTE = 60_000;
const DAY = 24 * 60 * MINUTE;
const VIETNAM_OFFSET_MS = 7 * 60 * MINUTE;

/** Số ngày tối đa giữa ngày đầu và ngày cuối của một lịch (CHECK `trip_schedules_date_range`) — 93 ngày tính cả hai đầu. */
export const MAX_SCHEDULE_SPAN_DAYS = 92;

/** `YYYY-MM-DD` → `Date` 00:00 UTC (kiểu Prisma trả cho cột DATE). */
export function dateOnly(value: string): Date {
  return new Date(`${value}T00:00:00.000Z`);
}

/** `Date` 00:00 UTC → `YYYY-MM-DD`. */
export function formatDateOnly(date: Date): string {
  return date.toISOString().slice(0, 10);
}

/** Ngày hôm nay theo giờ Việt Nam. */
export function todayInVietnam(now: Date): string {
  return formatDateOnly(new Date(now.getTime() + VIETNAM_OFFSET_MS));
}

/** Số ngày từ `from` tới `to` (cả hai `YYYY-MM-DD`). */
export function daysBetween(from: string, to: string): number {
  return Math.round((dateOnly(to).getTime() - dateOnly(from).getTime()) / DAY);
}

/** `HH:mm` ↔ phút trong ngày. */
export function minuteOfDay(time: string): number {
  const [hours, minutes] = time.split(":").map(Number);
  return hours! * 60 + minutes!;
}

export function timeOfDay(minute: number): string {
  return `${String(Math.floor(minute / 60)).padStart(2, "0")}:${String(minute % 60).padStart(2, "0")}`;
}

/** Thứ trong tuần theo ISO (1 = thứ Hai … 7 = Chủ nhật) ↔ bitmask (bit 0 = thứ Hai). */
export function daysToMask(days: readonly number[]): number {
  return days.reduce((mask, day) => mask | (1 << (day - 1)), 0);
}

export function maskToDays(mask: number): number[] {
  return [1, 2, 3, 4, 5, 6, 7].filter((day) => (mask & (1 << (day - 1))) !== 0);
}

function isoWeekday(date: Date): number {
  return ((date.getUTCDay() + 6) % 7) + 1;
}

/** Các ngày (`YYYY-MM-DD`) trong `[startDate, endDate]` rơi vào thứ có trong `mask`, tăng dần. */
export function scheduleDates(rule: { startDate: Date; endDate: Date; daysOfWeek: number }): string[] {
  const dates: string[] = [];
  for (let time = rule.startDate.getTime(); time <= rule.endDate.getTime(); time += DAY) {
    const date = new Date(time);
    if ((rule.daysOfWeek & (1 << (isoWeekday(date) - 1))) !== 0) {
      dates.push(formatDateOnly(date));
    }
  }
  return dates;
}

/** Giờ khởi hành (UTC) của ngày chạy `serviceDate` (giờ VN) lúc `departureMinute` phút giờ VN. */
export function departureOf(serviceDate: string, departureMinute: number): Date {
  return new Date(dateOnly(serviceDate).getTime() + departureMinute * MINUTE - VIETNAM_OFFSET_MS);
}
