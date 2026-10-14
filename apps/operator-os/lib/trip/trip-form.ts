// Logic thuần của form Tạo / Sửa chuyến (Figma "02 · Chuyến xe / Tạo chuyến"; FR-OPS-06, UC-14). Tách khỏi
// component để test được: đổi giờ nhập ↔ ISO, chia giờ từng điểm dừng, dựng body API, đọc lỗi lưu.
import { z } from "zod";

import { ApiError } from "../auth/api-client";
import type { Trip, TripInput } from "./trip-api";
import { fromLocalParts, toLocalParts } from "./trip-format";

export const TRIP_NOTE_MAX_LENGTH = 500;
/** Giá trị của ô chọn xe khi chưa gắn xe (ô chọn không nhận chuỗi rỗng). */
export const NO_VEHICLE = "NONE";

const MINUTE_MS = 60_000;
const DAY_MS = 24 * 3_600_000;
const VN_OFFSET_MS = 7 * 3_600_000;
/** Một chuyến dài tối đa 7 ngày (giống máy chủ). */
const MAX_TRIP_DURATION_MS = 7 * DAY_MS;
const DATE = /^\d{4}-\d{2}-\d{2}$/;
const TIME = /^([01]\d|2[0-3]):[0-5]\d$/;
/** Ngừng bán online sớm nhất một ngày trước giờ khởi hành (giống máy chủ — AS-20). */
export const MAX_ONLINE_SALE_CUTOFF_MINUTES = 1440;
/** Số phút ngừng bán online gợi ý cho chuyến mới. */
export const DEFAULT_ONLINE_SALE_CUTOFF_MINUTES = 60;

export type TripFormValues = {
  routeId: string;
  departureDate: string;
  departureTime: string;
  arrivalDate: string;
  arrivalTime: string;
  vehicleId: string;
  /** Số phút ngừng bán online trước giờ khởi hành, đang gõ dạng chữ. */
  onlineSaleCutoffMinutes: string;
  note: string;
};

type TimeIssue = { path: keyof TripFormValues; message: string };

/**
 * Quy tắc về giờ của chuyến (giống máy chủ): khởi hành ở tương lai, đến sau khởi hành, dài không quá 7 ngày.
 * Bỏ qua khi ngày / giờ còn thiếu — lỗi thiếu đã được báo ở từng ô.
 */
export function tripTimeIssues(values: TripFormValues, nowMs: number): TimeIssue[] {
  if (
    !DATE.test(values.departureDate) ||
    !TIME.test(values.departureTime) ||
    !DATE.test(values.arrivalDate) ||
    !TIME.test(values.arrivalTime)
  ) {
    return [];
  }
  const issues: TimeIssue[] = [];
  const departure = new Date(departureIso(values)).getTime();
  const arrival = new Date(arrivalIso(values)).getTime();
  if (departure <= nowMs) {
    issues.push({ path: "departureDate", message: "Giờ khởi hành phải ở tương lai." });
  }
  if (arrival <= departure) {
    issues.push({ path: "arrivalTime", message: "Giờ đến phải sau giờ khởi hành." });
  } else if (arrival - departure > MAX_TRIP_DURATION_MS) {
    issues.push({ path: "arrivalDate", message: "Chuyến dài không quá 7 ngày." });
  }
  return issues;
}

export const tripInfoSchema = z
  .object({
    routeId: z.string().min(1, "Chọn tuyến của chuyến."),
    departureDate: z.string().regex(DATE, "Chọn ngày khởi hành."),
    departureTime: z.string().regex(TIME, "Nhập giờ khởi hành."),
    arrivalDate: z.string().regex(DATE, "Chọn ngày đến."),
    arrivalTime: z.string().regex(TIME, "Nhập giờ đến."),
    vehicleId: z.string(),
    onlineSaleCutoffMinutes: z
      .string()
      .refine((value) => parseCutoffMinutes(value) !== null, `Nhập số phút nguyên từ 0 đến ${MAX_ONLINE_SALE_CUTOFF_MINUTES}.`),
    note: z.string().max(TRIP_NOTE_MAX_LENGTH, `Ghi chú tối đa ${TRIP_NOTE_MAX_LENGTH} ký tự.`)
  })
  .superRefine((values, ctx) => {
    for (const issue of tripTimeIssues(values, Date.now())) {
      ctx.addIssue({ code: "custom", path: [issue.path], message: issue.message });
    }
  });

/** Form trống của màn Tạo chuyến. */
export const EMPTY_TRIP_VALUES: TripFormValues = {
  routeId: "",
  departureDate: "",
  departureTime: "",
  arrivalDate: "",
  arrivalTime: "",
  vehicleId: NO_VEHICLE,
  onlineSaleCutoffMinutes: String(DEFAULT_ONLINE_SALE_CUTOFF_MINUTES),
  note: ""
};

/** Số phút ngừng bán online đang gõ → số nguyên 0–1440; chữ, số lẻ, số âm hay vượt khoảng → `null`. */
export function parseCutoffMinutes(value: string): number | null {
  const text = value.trim();
  if (!/^\d{1,4}$/.test(text)) {
    return null;
  }
  const minutes = Number(text);
  return minutes <= MAX_ONLINE_SALE_CUTOFF_MINUTES ? minutes : null;
}

/** Giá trị form của một chuyến đã lưu. */
export function toTripFormValues(trip: Trip): TripFormValues {
  const departure = toLocalParts(trip.departureAt);
  const arrival = toLocalParts(trip.arrivalAt);
  return {
    routeId: trip.routeId,
    departureDate: departure.date,
    departureTime: departure.time,
    arrivalDate: arrival.date,
    arrivalTime: arrival.time,
    vehicleId: trip.vehicleId ?? NO_VEHICLE,
    onlineSaleCutoffMinutes: String(trip.onlineSaleCutoffMinutes),
    note: trip.note ?? ""
  };
}

/** Giờ khởi hành đang nhập, dạng ISO có múi giờ. */
export function departureIso(values: Pick<TripFormValues, "departureDate" | "departureTime">): string {
  return fromLocalParts(values.departureDate, values.departureTime);
}

/** Giờ đến đang nhập, dạng ISO có múi giờ. */
export function arrivalIso(values: Pick<TripFormValues, "arrivalDate" | "arrivalTime">): string {
  return fromLocalParts(values.arrivalDate, values.arrivalTime);
}

/** Đã nhập đủ ngày giờ đi và đến đúng định dạng chưa — đủ thì mới tính được giờ từng điểm. */
export function hasCompleteTimes(values: TripFormValues): boolean {
  return (
    DATE.test(values.departureDate) &&
    TIME.test(values.departureTime) &&
    DATE.test(values.arrivalDate) &&
    TIME.test(values.arrivalTime)
  );
}

/** Giờ đến gợi ý = giờ khởi hành + thời gian chạy của tuyến (làm tròn phút); `null` khi chưa nhập đủ giờ đi. */
export function suggestArrival(
  departureDate: string,
  departureTime: string,
  routeDurationSeconds: number
): { date: string; time: string } | null {
  if (!DATE.test(departureDate) || !TIME.test(departureTime)) {
    return null;
  }
  const departure = new Date(fromLocalParts(departureDate, departureTime)).getTime();
  const minutes = Math.max(1, Math.round(routeDurationSeconds / 60));
  return toLocalParts(new Date(departure + minutes * MINUTE_MS).toISOString());
}

/**
 * Giờ dự kiến tại từng điểm khi "Tự chia": chia khoảng [giờ đi, giờ đến] theo tỉ lệ thời gian chạy từng chặng
 * của tuyến, làm tròn xuống theo phút tính từ giờ đi — đúng công thức của máy chủ, để giờ xem trước trùng giờ
 * được lưu. `legSeconds[i]` = thời gian chặng tới điểm `i` (điểm đầu là `null`).
 */
export function autoSplitTimes(departureMs: number, arrivalMs: number, legSeconds: (number | null)[]): number[] {
  const span = arrivalMs - departureMs;
  let elapsed = 0;
  const cumulative = legSeconds.map((seconds) => (elapsed += seconds ?? 0));
  const total = cumulative[cumulative.length - 1] ?? 0;
  const last = legSeconds.length - 1;
  return cumulative.map((seconds, index) =>
    index === last
      ? arrivalMs
      : departureMs + (total === 0 ? 0 : Math.floor(((seconds / total) * span) / MINUTE_MS) * MINUTE_MS)
  );
}

/**
 * Giờ tại từng điểm khi nhà xe tự nhập. Ô nhập chỉ có giờ trên đồng hồ; ngày được suy ra: mỗi điểm lấy mốc sớm
 * nhất không trước điểm liền trước (giờ nhỏ hơn giờ điểm trước nghĩa là đã sang hôm sau). Điểm đầu / cuối luôn
 * bằng giờ đi / giờ đến. `clockTimes[i]` là giờ `HH:mm` của điểm `i`; phần tử đầu và cuối bị bỏ qua. Khi có
 * lỗi, `times` giữ các điểm đã tính được tới trước điểm lỗi — đủ để giao diện ghi ngày cho các ô phía trên.
 */
export function resolveManualTimes(
  departureMs: number,
  arrivalMs: number,
  clockTimes: string[]
): { times: number[]; error: string | null } {
  const times = [departureMs];
  let previous = departureMs;
  for (let index = 1; index < clockTimes.length - 1; index++) {
    const clock = clockTimes[index] ?? "";
    if (!TIME.test(clock)) {
      return { times, error: "Nhập giờ dự kiến cho mọi điểm dừng ở giữa." };
    }
    const [hours, minutes] = clock.split(":").map(Number) as [number, number];
    const dayStart = Math.floor((previous + VN_OFFSET_MS) / DAY_MS) * DAY_MS - VN_OFFSET_MS;
    let candidate = dayStart + (hours * 60 + minutes) * MINUTE_MS;
    if (candidate < previous) {
      candidate += DAY_MS;
    }
    if (candidate > arrivalMs) {
      return { times, error: `Giờ tại điểm dừng thứ ${index + 1} vượt quá giờ đến của chuyến.` };
    }
    times.push(candidate);
    previous = candidate;
  }
  times.push(arrivalMs);
  return { times, error: null };
}

/** Chuyến đã lưu có đang dùng đúng giờ "Tự chia" theo số liệu chặng hiện tại của tuyến không. */
export function usesAutoSplit(trip: Trip, legSeconds: (number | null)[]): boolean {
  if (trip.stops.length !== legSeconds.length) {
    return true;
  }
  const expected = autoSplitTimes(
    new Date(trip.departureAt).getTime(),
    new Date(trip.arrivalAt).getTime(),
    legSeconds
  );
  return trip.stops.every((stop, index) => new Date(stop.plannedAt).getTime() === expected[index]);
}

/** Body gửi API. `stopTimesMs = null` nghĩa là để máy chủ tự chia giờ theo chặng. */
export function toTripInput(values: TripFormValues, stopTimesMs: number[] | null): TripInput {
  return {
    routeId: values.routeId,
    vehicleId: values.vehicleId === NO_VEHICLE ? null : values.vehicleId,
    departureAt: departureIso(values),
    arrivalAt: arrivalIso(values),
    stopTimes: stopTimesMs && stopTimesMs.map((ms) => new Date(ms).toISOString()),
    // Form đã kiểm trước khi gọi; giá trị sai lọt tới đây thì gửi mức gợi ý thay vì NaN.
    onlineSaleCutoffMinutes: parseCutoffMinutes(values.onlineSaleCutoffMinutes) ?? DEFAULT_ONLINE_SALE_CUTOFF_MINUTES,
    note: values.note.trim() || null
  };
}

export type TripSaveErrorField = "routeId" | "vehicleId" | "stops" | null;

/** Đổi lỗi lưu chuyến thành câu báo và ô cần gắn lỗi (BR-14 báo ngay tại ô Xe). */
export function describeTripSaveError(error: unknown): { field: TripSaveErrorField; message: string } {
  if (error instanceof ApiError) {
    switch (error.code) {
      case "VEHICLE_SCHEDULE_CONFLICT":
        return {
          field: "vehicleId",
          message: "Xe đã có chuyến khác trùng khoảng giờ này. Chọn xe khác hoặc đổi giờ của chuyến."
        };
      case "VEHICLE_UNAVAILABLE":
        return { field: "vehicleId", message: "Xe không còn hoạt động hoặc chưa có sơ đồ ghế. Vui lòng chọn xe khác." };
      case "ROUTE_UNAVAILABLE":
        return { field: "routeId", message: "Tuyến không còn hoạt động. Vui lòng chọn tuyến khác." };
      case "TRIP_STOP_TIMES_INVALID":
        return {
          field: "stops",
          message: "Tuyến vừa thay đổi số điểm dừng. Tải lại trang rồi nhập lại giờ tại từng điểm."
        };
      case "TRIP_BLOCKED_SEATS_MISSING":
        // Câu của máy chủ nêu đúng mã các chỗ đang khóa mà xe mới không có (BR-42).
        return { field: "vehicleId", message: error.message };
      case "TRIP_SEAT_NOT_AVAILABLE":
        return { field: "vehicleId", message: "Chuyến có chỗ đang được giữ hoặc đã bán nên không đổi xe được." };
      case "TRIP_NOT_EDITABLE":
        return { field: null, message: "Chuyến không còn ở trạng thái Nháp nên không sửa được." };
      case "TRIP_NOT_FOUND":
        return { field: null, message: "Chuyến không còn tồn tại. Vui lòng quay lại danh sách." };
    }
    if (error.status === 400) {
      return { field: null, message: "Thông tin chưa hợp lệ. Vui lòng kiểm tra lại ngày giờ đã nhập." };
    }
  }
  return { field: null, message: "Chưa lưu được chuyến. Vui lòng kiểm tra kết nối và thử lại." };
}
