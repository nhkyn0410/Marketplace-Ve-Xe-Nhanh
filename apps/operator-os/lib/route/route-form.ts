// Dữ liệu form Thêm / Chỉnh sửa tuyến: danh sách điểm dừng theo thứ tự với quyền đón / trả (BR-79), kiểm
// tại chỗ (HLD §6.3) và đổi qua lại với DTO của API. Hàm thuần để test được.
import { z } from "zod";

import { ApiError } from "../auth/api-client";
import type { StopPointType } from "../stop-point/stop-point-api";
import type { Route, RouteInput } from "./route-api";

/** Giới hạn của API (`route.dto.ts`). */
export const MIN_ROUTE_STOPS = 2;
export const MAX_ROUTE_STOPS = 25;
export const ROUTE_NAME_MAX_LENGTH = 150;
export const ROUTE_NOTE_MAX_LENGTH = 500;
export const STOP_NOTE_MAX_LENGTH = 300;
/** Thời gian một chặng nhà xe nhập tay tối đa (phút, `MAX_LEG_MINUTES` của API). */
export const MAX_LEG_MINUTES = 1440;

/** Một điểm dừng đang nằm trong form tuyến. Đúng một trong hai id có giá trị (điểm dùng chung hoặc điểm riêng). */
export type DraftStop = {
  catalogStopPointId: string | null;
  stopPointId: string | null;
  name: string;
  address: string;
  type: StopPointType;
  /** Tọa độ chỉ để vẽ bản đồ lộ trình; không gửi lên API (API tự lấy theo id điểm dừng). */
  latitude: number;
  longitude: number;
  allowPickup: boolean;
  allowDropoff: boolean;
  note: string;
};

/** Điểm chọn từ bảng chọn để thêm vào tuyến. */
export type StopCandidate = Pick<
  DraftStop,
  "catalogStopPointId" | "stopPointId" | "name" | "address" | "type" | "latitude" | "longitude"
>;

/** Khóa nhận diện một điểm trong tuyến; một điểm không xuất hiện hai lần (UC-13). */
export function stopKey(stop: Pick<DraftStop, "catalogStopPointId" | "stopPointId">): string {
  return stop.catalogStopPointId ? `catalog:${stop.catalogStopPointId}` : `own:${stop.stopPointId}`;
}

/**
 * Quyền đón / trả bị ấn định theo vị trí và loại điểm (BR-79): trạm dừng nghỉ không đón không trả, điểm đầu
 * chỉ đón, điểm cuối chỉ trả. `null` = điểm ở giữa, nhà xe tự chọn.
 */
export function lockedFlags(
  index: number,
  total: number,
  type: StopPointType
): { allowPickup: boolean; allowDropoff: boolean } | null {
  if (type === "REST_STOP") {
    return { allowPickup: false, allowDropoff: false };
  }
  if (index === 0) {
    return { allowPickup: true, allowDropoff: false };
  }
  if (index === total - 1) {
    return { allowPickup: false, allowDropoff: true };
  }
  return null;
}

/** Đặt lại công tắc của các điểm bị khóa theo vị trí hiện tại; điểm ở giữa giữ lựa chọn của nhà xe. */
export function normalizeStops(stops: DraftStop[]): DraftStop[] {
  return stops.map((stop, index) => ({ ...stop, ...lockedFlags(index, stops.length, stop.type) }));
}

/** Thêm điểm vào cuối tuyến. Điểm đã có hoặc tuyến đã đủ số điểm tối đa thì giữ nguyên. */
export function addStop(stops: DraftStop[], candidate: StopCandidate): DraftStop[] {
  if (stops.length >= MAX_ROUTE_STOPS || stops.some((stop) => stopKey(stop) === stopKey(candidate))) {
    return stops;
  }
  // Điểm cuối cũ lùi vào giữa: đang chỉ cho trả — vẫn hợp lệ, nhà xe bật thêm cho đón nếu muốn.
  return normalizeStops([...stops, { ...candidate, allowPickup: true, allowDropoff: true, note: "" }]);
}

/** Bỏ một điểm khỏi tuyến. */
export function removeStop(stops: DraftStop[], index: number): DraftStop[] {
  return normalizeStops(stops.filter((_, position) => position !== index));
}

/** Đổi chỗ một điểm với điểm đứng trước (`-1`) hoặc sau (`1`). Ra ngoài danh sách thì giữ nguyên. */
export function moveStop(stops: DraftStop[], index: number, direction: -1 | 1): DraftStop[] {
  const target = index + direction;
  if (target < 0 || target >= stops.length) {
    return stops;
  }
  const next = [...stops];
  [next[index], next[target]] = [next[target]!, next[index]!];
  return normalizeStops(next);
}

/** Bật / tắt cho đón hoặc cho trả ở một điểm giữa tuyến; điểm bị khóa thì không đổi. */
export function setStopFlag(
  stops: DraftStop[],
  index: number,
  flag: "allowPickup" | "allowDropoff",
  value: boolean
): DraftStop[] {
  if (lockedFlags(index, stops.length, stops[index]!.type)) {
    return stops;
  }
  return stops.map((stop, position) => (position === index ? { ...stop, [flag]: value } : stop));
}

/** Sửa ghi chú của một điểm. */
export function setStopNote(stops: DraftStop[], index: number, note: string): DraftStop[] {
  return stops.map((stop, position) => (position === index ? { ...stop, note } : stop));
}

/** Lỗi của danh sách điểm dừng trước khi gửi (cùng luật với API, BR-79); `null` = hợp lệ. */
export function validateStops(stops: DraftStop[]): string | null {
  if (stops.length < MIN_ROUTE_STOPS) {
    return `Tuyến cần ít nhất ${MIN_ROUTE_STOPS} điểm dừng.`;
  }
  if (stops[0]!.type === "REST_STOP" || stops[stops.length - 1]!.type === "REST_STOP") {
    return "Trạm dừng nghỉ không được đứng đầu hoặc cuối tuyến. Hãy đổi thứ tự hoặc thêm điểm khác.";
  }
  const closed = stops.find((stop) => stop.type !== "REST_STOP" && !stop.allowPickup && !stop.allowDropoff);
  if (closed) {
    return `Điểm “${closed.name}” phải cho đón hoặc cho trả khách.`;
  }
  return null;
}

/** Cảnh báo (không chặn lưu) khi hai đầu tuyến không phải bến xe — quy định về tuyến cố định, OQ-24. */
export function busStationWarning(stops: DraftStop[]): string | null {
  if (stops.length < MIN_ROUTE_STOPS) {
    return null;
  }
  const first = stops[0]!.type !== "BUS_STATION";
  const last = stops[stops.length - 1]!.type !== "BUS_STATION";
  if (!first && !last) {
    return null;
  }
  const which = first && last ? "Điểm đầu và điểm cuối" : first ? "Điểm đầu" : "Điểm cuối";
  return `${which} không phải bến xe. Tuyến cố định cần xuất phát và kết thúc tại bến xe theo quy định; bạn vẫn lưu được tuyến này.`;
}

/** Số điểm cho đón và cho trả, cho thẻ Tổng quan. */
export function countFlags(stops: DraftStop[]): { pickup: number; dropoff: number } {
  return {
    pickup: stops.filter((stop) => stop.allowPickup).length,
    dropoff: stops.filter((stop) => stop.allowDropoff).length
  };
}

/** Luật kiểm phần thông tin tuyến; thông báo hiện ngay dưới từng ô (06 UI §10). */
export const routeInfoSchema = z.object({
  name: z
    .string()
    .trim()
    .min(1, "Nhập tên tuyến.")
    .max(ROUTE_NAME_MAX_LENGTH, `Tên tuyến tối đa ${ROUTE_NAME_MAX_LENGTH} ký tự.`),
  status: z.enum(["ACTIVE", "INACTIVE"]),
  note: z.string().max(ROUTE_NOTE_MAX_LENGTH, `Ghi chú tối đa ${ROUTE_NOTE_MAX_LENGTH} ký tự.`)
});
export type RouteInfoValues = z.infer<typeof routeInfoSchema>;

/** Giá trị ban đầu của form "Thêm tuyến". */
export const EMPTY_ROUTE_INFO: RouteInfoValues = { name: "", status: "ACTIVE", note: "" };

/** Đưa tuyến đã lưu vào phần thông tin của form. */
export function toRouteInfoValues(route: Route): RouteInfoValues {
  return { name: route.name, status: route.status, note: route.note ?? "" };
}

/** Đưa điểm dừng của tuyến đã lưu vào form, theo thứ tự hành trình. */
export function toDraftStops(route: Route): DraftStop[] {
  return [...route.stops]
    .sort((a, b) => a.sequence - b.sequence)
    .map((stop) => ({
      catalogStopPointId: stop.catalogStopPointId,
      stopPointId: stop.stopPointId,
      name: stop.name,
      address: stop.address,
      type: stop.type,
      latitude: stop.latitude,
      longitude: stop.longitude,
      allowPickup: stop.allowPickup,
      allowDropoff: stop.allowDropoff,
      note: stop.note ?? ""
    }));
}

/**
 * Số phút nhà xe chỉnh tay cho từng chặng, tra theo cặp điểm liền nhau như `savedLegs` (chờ duyệt 27/10/2026): đổi thứ tự
 * điểm thì chặng mới không mang số chỉnh của chặng cũ. Không có khóa = dùng số hệ thống tính.
 */
export type LegMinutes = Readonly<Record<string, string>>;

function legKey(stops: Pick<DraftStop, "catalogStopPointId" | "stopPointId">[], index: number): string {
  return `${stopKey(stops[index - 1]!)}>${stopKey(stops[index]!)}`;
}

/** Ô số phút của chặng từ điểm `index - 1` tới điểm `index`; `""` = dùng số hệ thống. */
export function legMinutesOf(minutes: LegMinutes, stops: DraftStop[], index: number): string {
  return minutes[legKey(stops, index)] ?? "";
}

/** Sửa ô số phút của một chặng; xóa trắng = quay về số hệ thống. */
export function setLegMinutes(minutes: LegMinutes, stops: DraftStop[], index: number, value: string): LegMinutes {
  const { [legKey(stops, index)]: _previous, ...rest } = minutes;
  return value.trim() === "" ? rest : { ...rest, [legKey(stops, index)]: value };
}

/** Số phút hợp lệ (số nguyên 1–1440); ô trống hoặc sai thì `null`. */
export function parseLegMinutes(text: string): number | null {
  const trimmed = text.trim();
  if (!/^\d+$/.test(trimmed)) {
    return null;
  }
  const value = Number(trimmed);
  return value >= 1 && value <= MAX_LEG_MINUTES ? value : null;
}

/** Lỗi của các ô số phút trước khi gửi; `null` = hợp lệ. */
export function validateLegMinutes(minutes: LegMinutes, stops: DraftStop[]): string | null {
  for (let index = 1; index < stops.length; index++) {
    const text = legMinutesOf(minutes, stops, index);
    if (text.trim() !== "" && parseLegMinutes(text) === null) {
      return `Thời gian chạy tới “${stops[index]!.name}” phải là số phút nguyên từ 1 đến ${MAX_LEG_MINUTES}.`;
    }
  }
  return null;
}

/** Số phút nhà xe đã chỉnh trên tuyến đã lưu: chặng có thời gian đang dùng khác số hệ thống tính. */
export function savedLegMinutes(route: Route | undefined): LegMinutes {
  if (!route) {
    return {};
  }
  const stops = [...route.stops].sort((a, b) => a.sequence - b.sequence);
  const minutes: Record<string, string> = {};
  stops.forEach((stop, index) => {
    const seconds = stop.durationSecondsFromPrevious;
    if (index > 0 && seconds !== null && seconds !== stop.measuredDurationSecondsFromPrevious) {
      minutes[legKey(stops, index)] = String(Math.round(seconds / 60));
    }
  });
  return minutes;
}

/** Body gửi API: PUT thay toàn bộ nên luôn gửi đủ mọi trường; ghi chú trống gửi `null`, chặng không chỉnh gửi `null`. */
export function toRouteInput(info: RouteInfoValues, stops: DraftStop[], minutes: LegMinutes = {}): RouteInput {
  const note = info.note.trim();
  return {
    name: info.name.trim(),
    status: info.status,
    note: note === "" ? null : note,
    stops: stops.map((stop, index) => {
      const stopNote = stop.note.trim();
      return {
        catalogStopPointId: stop.catalogStopPointId,
        stopPointId: stop.stopPointId,
        note: stopNote === "" ? null : stopNote,
        allowPickup: stop.allowPickup,
        allowDropoff: stop.allowDropoff,
        durationMinutesFromPrevious: index === 0 ? null : parseLegMinutes(legMinutesOf(minutes, stops, index))
      };
    })
  };
}

/**
 * Số liệu HỆ THỐNG tính của từng chặng trên tuyến đã lưu (không gồm số nhà xe chỉnh — xem `savedLegMinutes`), tra theo
 * cặp điểm liền nhau. Người dùng đổi thứ tự thì chặng nào còn nguyên cặp vẫn hiện số cũ, chặng mới hiện "Tính khi lưu".
 */
export function savedLegs(route: Route | undefined): Map<string, { distanceMeters: number; durationSeconds: number }> {
  const legs = new Map<string, { distanceMeters: number; durationSeconds: number }>();
  if (!route) {
    return legs;
  }
  const stops = [...route.stops].sort((a, b) => a.sequence - b.sequence);
  stops.forEach((stop, index) => {
    if (index > 0 && stop.distanceMetersFromPrevious !== null && stop.measuredDurationSecondsFromPrevious !== null) {
      legs.set(legKey(stops, index), {
        distanceMeters: stop.distanceMetersFromPrevious,
        durationSeconds: stop.measuredDurationSecondsFromPrevious
      });
    }
  });
  return legs;
}

/** Số liệu của chặng từ điểm `index - 1` tới điểm `index`; `null` = chưa có, sẽ tính khi lưu. */
export function legOf(
  legs: ReadonlyMap<string, { distanceMeters: number; durationSeconds: number }>,
  stops: DraftStop[],
  index: number
): { distanceMeters: number; durationSeconds: number } | null {
  return legs.get(legKey(stops, index)) ?? null;
}

/**
 * Tổng quãng đường và thời gian nếu mọi chặng đều đã có số; còn chặng chưa tính thì `null`. Thời gian lấy số nhà xe
 * chỉnh nếu có, không thì số hệ thống — đúng tổng máy chủ lưu và dùng tính giờ đến của chuyến.
 */
export function totalsOf(
  legs: ReadonlyMap<string, { distanceMeters: number; durationSeconds: number }>,
  stops: DraftStop[],
  minutes: LegMinutes = {}
): { distanceMeters: number; durationSeconds: number } | null {
  if (stops.length < MIN_ROUTE_STOPS) {
    return null;
  }
  let distanceMeters = 0;
  let durationSeconds = 0;
  for (let index = 1; index < stops.length; index++) {
    const leg = legOf(legs, stops, index);
    if (!leg) {
      return null;
    }
    distanceMeters += leg.distanceMeters;
    const edited = parseLegMinutes(legMinutesOf(minutes, stops, index));
    durationSeconds += edited === null ? leg.durationSeconds : edited * 60;
  }
  return { distanceMeters, durationSeconds };
}

/** Chỗ của form mà lỗi lưu thuộc về; `null` = lỗi chung của cả form. */
export type SaveErrorField = "name" | "stops" | null;

/** Đổi lỗi API khi lưu tuyến thành thông báo cho người dùng và chỗ cần sửa (mã lỗi theo 05 API §7.3). */
export function describeSaveError(error: unknown): { field: SaveErrorField; message: string } {
  if (error instanceof ApiError) {
    switch (error.code) {
      case "ROUTE_NAME_CONFLICT":
        return { field: "name", message: "Tên tuyến đã tồn tại trong nhà xe." };
      case "STOP_POINT_UNAVAILABLE":
        return {
          field: "stops",
          message: "Có điểm dừng không còn dùng được (đã ngừng dùng hoặc bị khóa). Hãy bỏ điểm đó khỏi tuyến."
        };
      case "ROUTE_STOP_PICKUP_DROPOFF_INVALID":
        return { field: "stops", message: "Cho đón / cho trả chưa đúng quy tắc. Vui lòng kiểm tra lại các điểm dừng." };
      case "ROUTE_DURATION_INVALID":
        return { field: "stops", message: "Tổng thời gian chạy của tuyến không được quá 7 ngày. Hãy kiểm tra thời gian từng chặng." };
      case "ROUTING_PROVIDER_UNAVAILABLE":
        return {
          field: null,
          message: "Chưa tính được quãng đường vì dịch vụ bản đồ đang lỗi. Tuyến chưa được lưu, vui lòng thử lại sau."
        };
      case "ROUTE_NOT_FOUND":
        return { field: null, message: "Tuyến không còn tồn tại. Vui lòng quay lại danh sách." };
    }
    if (error.status === 400) {
      return { field: null, message: "Thông tin chưa hợp lệ. Vui lòng kiểm tra lại các ô đã nhập." };
    }
  }
  return { field: null, message: "Chưa lưu được tuyến. Vui lòng kiểm tra kết nối và thử lại." };
}
