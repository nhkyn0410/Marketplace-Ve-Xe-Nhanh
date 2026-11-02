// Lịch xe (TASK-TRN-015; Figma "07 · Chuyến xe / Lịch xe", "08 · Tạo chuyến · Chọn xe", thẻ "Lịch xe trong ngày" ở
// khung 02): dòng thời gian theo xe trong một ngày giờ Việt Nam, xe rảnh / trùng giờ cho một khoảng giờ chuyến.
// Hàm thuần để test được. Xe bận trong [giờ khởi hành, giờ đến) của mọi chuyến chưa hủy (BR-14 — giống ràng buộc
// EXCLUDE ở DB bỏ qua chuyến `CANCELLED`); giờ đến là dự kiến.
import { apiRequest } from "../auth/api-client";
import type { TripPage, TripSummary } from "./trip-api";
import { formatDay, formatTime, fromLocalParts, toLocalParts } from "./trip-format";

const DAY_MS = 24 * 3_600_000;
/** Chuyến sau khởi hành trong vòng chừng này sau khi chuyến trước đến → đánh dấu "nối chuyến sát giờ". */
export const TIGHT_TURNAROUND_MS = 30 * 60_000;

type ScheduleTrip = Pick<TripSummary, "id" | "routeId" | "routeName" | "vehicleId" | "departureAt" | "arrivalAt" | "status">;

/** Nơi xe dừng sau chuyến (điểm cuối của tuyến) — chỉ để hiển thị. */
export type DestinationOf = (routeId: string) => string | undefined;

const ms = (iso: string) => new Date(iso).getTime();
const busy = (trip: ScheduleTrip) => trip.status !== "CANCELLED";

/** Mốc đầu / cuối (không gồm) của một ngày giờ Việt Nam `2026-10-10`. */
export function dayWindow(date: string): { startMs: number; endMs: number } {
  const startMs = ms(fromLocalParts(date, "00:00"));
  return { startMs, endMs: startMs + DAY_MS };
}

/** Ngày liền trước `2026-10-10` → `2026-10-09`. */
export function previousLocalDate(date: string): string {
  return toLocalParts(new Date(ms(fromLocalParts(date, "00:00")) - DAY_MS).toISOString()).date;
}

/**
 * Mọi chuyến khởi hành trong `[fromIso, toIso)` (đi hết các trang). API lọc theo giờ khởi hành, nên muốn thấy chuyến
 * qua đêm từ hôm trước thì `fromIso` phải lùi một ngày.
 */
export async function listTripsBetween(fromIso: string, toIso: string): Promise<TripSummary[]> {
  const items: TripSummary[] = [];
  let cursor: string | null = null;
  do {
    const query = new URLSearchParams({ limit: "100", departureFrom: fromIso, departureTo: toIso });
    if (cursor) {
      query.set("cursor", cursor);
    }
    const page: TripPage = await apiRequest<TripPage>(`/operator/trips?${query}`);
    items.push(...page.items);
    cursor = page.nextCursor;
  } while (cursor);
  return items;
}

export type ScheduleBar = {
  trip: ScheduleTrip;
  /** Vị trí trên trục 24 giờ, phần trăm. */
  leftPct: number;
  widthPct: number;
  /** Chuyến bắt đầu từ hôm trước / kết thúc sang hôm sau. */
  startsBefore: boolean;
  endsAfter: boolean;
  /** Khởi hành ngay sau chuyến trước của cùng xe (≤ 30 phút). */
  tight: boolean;
};

export type ScheduleRow<V> = {
  vehicle: V;
  bars: ScheduleBar[];
  /** Xe rảnh từ (dự kiến): giờ đến của chuyến chưa hủy cuối cùng chạm ngày này; `null` = không có chuyến. */
  freeFrom: { at: string; place: string | undefined } | null;
};

function toBars(trips: ScheduleTrip[], startMs: number, endMs: number): ScheduleBar[] {
  const sorted = [...trips].sort((a, b) => ms(a.departureAt) - ms(b.departureAt));
  return sorted.map((trip, index) => {
    const from = Math.max(ms(trip.departureAt), startMs);
    const to = Math.min(ms(trip.arrivalAt), endMs);
    const previous = sorted.slice(0, index).filter(busy).at(-1);
    const gap = previous ? ms(trip.departureAt) - ms(previous.arrivalAt) : Number.POSITIVE_INFINITY;
    return {
      trip,
      leftPct: ((from - startMs) / DAY_MS) * 100,
      widthPct: (Math.max(to - from, 0) / DAY_MS) * 100,
      startsBefore: ms(trip.departureAt) < startMs,
      endsAfter: ms(trip.arrivalAt) > endMs,
      tight: busy(trip) && gap >= 0 && gap <= TIGHT_TURNAROUND_MS
    };
  });
}

/**
 * Dòng thời gian của một ngày: mỗi xe một hàng (chuyến chạm ngày đó), hàng "Chưa gắn xe", và số liệu tóm tắt.
 * `trips` nên gồm chuyến khởi hành từ ngày hôm trước để thấy chuyến qua đêm.
 */
export function buildSchedule<V extends { id: string }>(
  vehicles: readonly V[],
  trips: readonly ScheduleTrip[],
  date: string,
  destinationOf: DestinationOf
): {
  rows: ScheduleRow<V>[];
  unassigned: ScheduleBar[];
  summary: { vehicleCount: number; departures: number; unassigned: number; idleVehicles: number };
} {
  const { startMs, endMs } = dayWindow(date);
  const inDay = trips.filter((trip) => ms(trip.departureAt) < endMs && ms(trip.arrivalAt) > startMs);
  const rows = vehicles.map((vehicle) => {
    const own = inDay.filter((trip) => trip.vehicleId === vehicle.id);
    const last = own.filter(busy).sort((a, b) => ms(b.arrivalAt) - ms(a.arrivalAt))[0];
    return {
      vehicle,
      bars: toBars(own, startMs, endMs),
      freeFrom: last ? { at: last.arrivalAt, place: destinationOf(last.routeId) } : null
    };
  });
  const unassigned = toBars(
    inDay.filter((trip) => trip.vehicleId === null),
    startMs,
    endMs
  );
  return {
    rows,
    unassigned,
    summary: {
      vehicleCount: vehicles.length,
      departures: inDay.filter((trip) => ms(trip.departureAt) >= startMs).length,
      unassigned: unassigned.filter((bar) => busy(bar.trip)).length,
      idleVehicles: rows.filter((row) => row.bars.every((bar) => !busy(bar.trip))).length
    }
  };
}

/** Cột "Rảnh từ (dự kiến)": `18:30` cùng ngày, `03:30 · 11/10` nếu sang ngày khác. */
export function freeFromLabel(at: string, date: string): string {
  return toLocalParts(at).date === date ? formatTime(at) : `${formatTime(at)} · ${formatDay(at).slice(0, 5)}`;
}

/** Ô "Giờ" của dải chuyến: `06:00 – 11:30`, thêm `+1` nếu đến hôm sau, `đến 04:30` nếu khởi hành từ hôm trước. */
export function barTimeLabel(bar: Pick<ScheduleBar, "trip" | "startsBefore" | "endsAfter">): string {
  if (bar.startsBefore) {
    return `đến ${formatTime(bar.trip.arrivalAt)}`;
  }
  return `${formatTime(bar.trip.departureAt)} – ${formatTime(bar.trip.arrivalAt)}${bar.endsAfter ? " +1" : ""}`;
}

export type VehicleChoice<V> = {
  vehicle: V;
  /** Chuyến chưa hủy của xe chồng giờ với khoảng đang chọn (trừ chính chuyến đang sửa). */
  conflict: ScheduleTrip | undefined;
  /** Chuyến chưa hủy gần nhất kết thúc trước giờ khởi hành. */
  previous: ScheduleTrip | undefined;
};

/** Tình trạng từng xe trong khoảng `[departureMs, arrivalMs)` của chuyến đang tạo / sửa (Figma 08). */
export function vehicleChoices<V extends { id: string }>(
  vehicles: readonly V[],
  trips: readonly ScheduleTrip[],
  departureMs: number,
  arrivalMs: number,
  exceptTripId?: string
): { free: VehicleChoice<V>[]; busy: VehicleChoice<V>[] } {
  const relevant = trips.filter((trip) => busy(trip) && trip.id !== exceptTripId && trip.vehicleId !== null);
  const choices = vehicles.map((vehicle) => {
    const own = relevant.filter((trip) => trip.vehicleId === vehicle.id);
    return {
      vehicle,
      conflict: own.find((trip) => ms(trip.departureAt) < arrivalMs && ms(trip.arrivalAt) > departureMs),
      previous: own.filter((trip) => ms(trip.arrivalAt) <= departureMs).sort((a, b) => ms(b.arrivalAt) - ms(a.arrivalAt))[0]
    };
  });
  return { free: choices.filter((choice) => !choice.conflict), busy: choices.filter((choice) => choice.conflict) };
}

/** Dòng phụ của một xe trong ô chọn: "Rảnh từ 18:30 · chuyến trước đến Sài Gòn" / "Bận tới 21:15 · Sài Gòn → …". */
export function choiceNote(choice: VehicleChoice<unknown>, departureDate: string, destinationOf: DestinationOf): string {
  if (choice.conflict) {
    const trip = choice.conflict;
    const nextDay = toLocalParts(trip.arrivalAt).date !== toLocalParts(trip.departureAt).date ? " hôm sau" : "";
    return `Bận tới ${formatTime(trip.arrivalAt)} · ${trip.routeName} (${formatTime(trip.departureAt)} – ${formatTime(trip.arrivalAt)}${nextDay})`;
  }
  const previous = choice.previous;
  if (!previous || toLocalParts(previous.arrivalAt).date < departureDate) {
    return "Rảnh cả ngày · chưa có chuyến trong ngày";
  }
  const place = destinationOf(previous.routeId);
  return `Rảnh từ ${formatTime(previous.arrivalAt)}${place ? ` · chuyến trước đến ${place}` : ""}`;
}

/** Ngày giờ Việt Nam tương ứng một vị trí trên trục (bấm vào khoảng trống của xe → tạo chuyến), làm tròn 30 phút. */
export function slotAt(date: string, fraction: number): { date: string; time: string } {
  const minutes = Math.min(Math.max(Math.round((fraction * 24 * 60) / 30) * 30, 0), 23 * 60 + 30);
  return { date, time: `${String(Math.floor(minutes / 60)).padStart(2, "0")}:${String(minutes % 60).padStart(2, "0")}` };
}

export type { ScheduleTrip };
