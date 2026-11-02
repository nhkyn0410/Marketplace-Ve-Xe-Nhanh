// Logic thuần của màn Lịch chạy lặp lại (TASK-TRN-007 — chưa có khung Figma, dựng theo bộ kit màn Chuyến xe). Tách khỏi
// component để test được: đọc / dựng body API, đếm ngày sẽ sinh, nhãn thứ, nhãn kết quả sinh chuyến, đọc lỗi lưu.
import { z } from "zod";

import { ApiError } from "../auth/api-client";
import { formatDuration } from "../route/route-format";
import { MAX_ONLINE_SALE_CUTOFF_MINUTES, NO_VEHICLE, parseCutoffMinutes, TRIP_NOTE_MAX_LENGTH } from "./trip-form";
import type { SkippedDay, TripSchedule, TripScheduleInput } from "./trip-schedule-api";

const DAY_MS = 24 * 3_600_000;
const DATE = /^\d{4}-\d{2}-\d{2}$/;
const TIME = /^([01]\d|2[0-3]):[0-5]\d$/;
/** Một lịch áp dụng tối đa 93 ngày (giống máy chủ). */
export const MAX_SCHEDULE_SPAN_DAYS = 92;

/** Thứ theo ISO: 1 = thứ Hai … 7 = Chủ nhật — nhãn ngắn cho nút chọn. */
export const WEEKDAY_OPTIONS = [
  { day: 1, short: "T2", long: "Thứ Hai" },
  { day: 2, short: "T3", long: "Thứ Ba" },
  { day: 3, short: "T4", long: "Thứ Tư" },
  { day: 4, short: "T5", long: "Thứ Năm" },
  { day: 5, short: "T6", long: "Thứ Sáu" },
  { day: 6, short: "T7", long: "Thứ Bảy" },
  { day: 7, short: "CN", long: "Chủ nhật" }
] as const;

export type ScheduleFormValues = {
  routeId: string;
  vehicleId: string;
  departureTime: string;
  daysOfWeek: number[];
  startDate: string;
  endDate: string;
  onlineSaleCutoffMinutes: string;
  note: string;
  /** Chặng mở bán (3.3) chép sang từng chuyến lịch sinh ra. */
  subRouteIds: string[];
};

export function emptyScheduleValues(today: string): ScheduleFormValues {
  return {
    routeId: "",
    vehicleId: NO_VEHICLE,
    departureTime: "",
    daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
    startDate: today,
    endDate: addDays(today, 29),
    onlineSaleCutoffMinutes: "60",
    note: "",
    subRouteIds: []
  };
}

export function toScheduleFormValues(schedule: TripSchedule): ScheduleFormValues {
  return {
    routeId: schedule.routeId,
    vehicleId: schedule.vehicleId ?? NO_VEHICLE,
    departureTime: schedule.departureTime,
    daysOfWeek: schedule.daysOfWeek,
    startDate: schedule.startDate,
    endDate: schedule.endDate,
    onlineSaleCutoffMinutes: String(schedule.onlineSaleCutoffMinutes),
    note: schedule.note ?? "",
    subRouteIds: schedule.subRouteIds
  };
}

export function scheduleSchema(today: string) {
  return z
    .object({
      routeId: z.string().min(1, "Chọn tuyến."),
      vehicleId: z.string(),
      departureTime: z.string().regex(TIME, "Nhập giờ khởi hành."),
      daysOfWeek: z.array(z.number()).min(1, "Chọn ít nhất một thứ trong tuần."),
      startDate: z.string().regex(DATE, "Chọn ngày bắt đầu."),
      endDate: z.string().regex(DATE, "Chọn ngày kết thúc."),
      onlineSaleCutoffMinutes: z.string(),
      note: z.string().max(TRIP_NOTE_MAX_LENGTH),
      subRouteIds: z.array(z.string())
    })
    .superRefine((values, ctx) => {
      if (parseCutoffMinutes(values.onlineSaleCutoffMinutes) === null) {
        ctx.addIssue({
          code: "custom",
          path: ["onlineSaleCutoffMinutes"],
          message: `Nhập số phút từ 0 đến ${MAX_ONLINE_SALE_CUTOFF_MINUTES}.`
        });
      }
      if (DATE.test(values.startDate) && DATE.test(values.endDate)) {
        const span = daysBetween(values.startDate, values.endDate);
        if (span < 0) {
          ctx.addIssue({ code: "custom", path: ["endDate"], message: "Ngày kết thúc phải từ ngày bắt đầu trở đi." });
        } else if (span > MAX_SCHEDULE_SPAN_DAYS) {
          ctx.addIssue({ code: "custom", path: ["endDate"], message: "Một lịch áp dụng tối đa 93 ngày. Hết hạn thì tạo lịch tiếp theo." });
        } else if (values.endDate < today) {
          ctx.addIssue({ code: "custom", path: ["endDate"], message: "Ngày kết thúc đã qua." });
        }
      }
    });
}

export function toScheduleInput(values: ScheduleFormValues): TripScheduleInput {
  return {
    routeId: values.routeId,
    vehicleId: values.vehicleId === NO_VEHICLE ? null : values.vehicleId,
    departureTime: values.departureTime,
    daysOfWeek: [...values.daysOfWeek].sort((a, b) => a - b),
    startDate: values.startDate,
    endDate: values.endDate,
    onlineSaleCutoffMinutes: parseCutoffMinutes(values.onlineSaleCutoffMinutes)!,
    note: values.note.trim() || null,
    subRouteIds: values.subRouteIds
  };
}

function dateMs(date: string): number {
  return Date.parse(`${date}T00:00:00Z`);
}

export function daysBetween(from: string, to: string): number {
  return Math.round((dateMs(to) - dateMs(from)) / DAY_MS);
}

export function addDays(date: string, days: number): string {
  return new Date(dateMs(date) + days * DAY_MS).toISOString().slice(0, 10);
}

/** Các ngày trong khoảng rơi vào thứ đã chọn (giống máy chủ). */
export function matchingDates(values: Pick<ScheduleFormValues, "startDate" | "endDate" | "daysOfWeek">): string[] {
  if (!DATE.test(values.startDate) || !DATE.test(values.endDate)) {
    return [];
  }
  const span = daysBetween(values.startDate, values.endDate);
  if (span < 0 || span > MAX_SCHEDULE_SPAN_DAYS) {
    return [];
  }
  const dates: string[] = [];
  for (let offset = 0; offset <= span; offset++) {
    const date = addDays(values.startDate, offset);
    const isoDay = ((new Date(dateMs(date)).getUTCDay() + 6) % 7) + 1;
    if (values.daysOfWeek.includes(isoDay)) {
      dates.push(date);
    }
  }
  return dates;
}

/** Nhãn thứ chạy: `Hằng ngày`, `T2 – T6`, `T2, T4, T6`, `T7, CN`. */
export function weekdaysLabel(days: readonly number[]): string {
  const sorted = [...days].sort((a, b) => a - b);
  if (sorted.length === 7) {
    return "Hằng ngày";
  }
  if (sorted.join() === "1,2,3,4,5") {
    return "T2 – T6";
  }
  return sorted.map((day) => WEEKDAY_OPTIONS[day - 1]!.short).join(", ");
}

/** `2026-10-19` → `19/10/2026`. */
export function formatDateOnly(date: string): string {
  const [year, month, day] = date.split("-");
  return `${day}/${month}/${year}`;
}

/** `T2, 19/10` — ngày ngắn kèm thứ cho danh sách kết quả. */
export function shortDayLabel(date: string): string {
  const isoDay = ((new Date(dateMs(date)).getUTCDay() + 6) % 7) + 1;
  const [, month, day] = date.split("-");
  return `${WEEKDAY_OPTIONS[isoDay - 1]!.short}, ${day}/${month}`;
}

export function scheduleDurationLabel(minutes: number): string {
  return formatDuration(minutes * 60);
}

/** Trạng thái hiển thị của lịch theo ngày hôm nay (giờ VN). */
export function scheduleState(schedule: Pick<TripSchedule, "startDate" | "endDate">, today: string): {
  label: string;
  tone: "success" | "warning" | "neutral";
} {
  if (schedule.endDate < today) {
    return { label: "Đã hết hạn", tone: "neutral" };
  }
  return schedule.startDate > today ? { label: "Sắp áp dụng", tone: "warning" } : { label: "Đang áp dụng", tone: "success" };
}

export const SKIP_REASON_LABEL: Record<SkippedDay["reason"], string> = {
  EXISTS: "Đã có chuyến của lịch",
  PAST: "Giờ khởi hành đã qua",
  VEHICLE_CONFLICT: "Xe trùng giờ chuyến khác"
};

/** Lý do chưa mở bán được (mã BR-39 của máy chủ hoặc mã lỗi) → câu ngắn. */
const NOT_OPENED_LABEL: Record<string, string> = {
  OPERATOR_INACTIVE: "nhà xe đang bị tạm khóa",
  ROUTE_INACTIVE: "tuyến đã ngừng dùng",
  STOP_POINT_INACTIVE: "có điểm dừng đã ngừng dùng",
  VEHICLE_MISSING: "chưa gắn xe",
  VEHICLE_INACTIVE: "xe không hoạt động",
  SEATS_MISSING: "chuyến chưa có chỗ",
  FARE_MISSING: "tuyến chưa có bảng giá đang áp dụng",
  SEAT_PRICE_MISSING: "có chỗ chưa có giá",
  SEAT_PRICE_ZERO: "có chỗ giá 0 đ",
  SALE_WINDOW_CLOSED: "đã qua giờ ngừng bán online",
  SERVICE_UNAVAILABLE: "máy chủ đang bận, mở bán lại sau"
};

export function notOpenedLabel(reasons: readonly string[]): string {
  return reasons.map((reason) => NOT_OPENED_LABEL[reason] ?? reason).join(", ");
}

/** Lỗi khi lưu lịch → ô cần báo + câu. */
export function describeScheduleSaveError(error: unknown): { field: "routeId" | "vehicleId" | null; message: string } {
  if (error instanceof ApiError) {
    switch (error.code) {
      case "ROUTE_UNAVAILABLE":
        return { field: "routeId", message: "Tuyến không còn hoạt động. Vui lòng chọn tuyến khác." };
      case "VEHICLE_UNAVAILABLE":
        return { field: "vehicleId", message: "Xe không còn hoạt động hoặc chưa có sơ đồ ghế. Vui lòng chọn xe khác." };
      case "TRIP_SCHEDULE_NOT_FOUND":
        return { field: null, message: "Lịch không còn tồn tại. Tải lại trang." };
    }
    if (error.status === 400) {
      return { field: null, message: "Thông tin chưa hợp lệ. Kiểm tra lại các ô rồi lưu." };
    }
  }
  return { field: null, message: "Chưa lưu được lịch. Vui lòng kiểm tra kết nối và thử lại." };
}
