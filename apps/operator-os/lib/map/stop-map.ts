// Dữ liệu cho ba bản đồ của màn Điểm dừng và màn Tuyến đường (TASK-TRN-014; Figma "VXN / Map marker",
// "VXN / Map stop marker"). Hàm thuần để test được.
import { isValidPoint, type MapPoint } from "@vexenhanh/ui/lib/map";

import { stopKey, type DraftStop, type StopCandidate } from "../route/route-form";
import type { StopPointStatus, StopPointType } from "../stop-point/stop-point-api";
import { parseCoordinate } from "../stop-point/stop-point-form";

/** Kiểu ghim trên bản đồ: một màu cho mỗi loại điểm, xám cho điểm không dùng được. */
export type MarkerKind = "busStation" | "pickup" | "office" | "restStop" | "muted";

/** Màu nền của từng kiểu ghim. */
export const MARKER_KIND_CLASS: Record<MarkerKind, string> = {
  busStation: "bg-primary",
  pickup: "bg-vxn-teal-500",
  office: "bg-success-600",
  restStop: "bg-vxn-saffron-500",
  muted: "bg-vxn-fg-5"
};

const KIND_BY_TYPE: Record<StopPointType, MarkerKind> = {
  BUS_STATION: "busStation",
  PICKUP_POINT: "pickup",
  OFFICE: "office",
  REST_STOP: "restStop"
};

/** Kiểu ghim của một điểm dừng; điểm riêng đang ngừng dùng hoặc bị khóa thì xám. */
export function markerKind(type: StopPointType, status: StopPointStatus = "ACTIVE"): MarkerKind {
  return status === "ACTIVE" ? KIND_BY_TYPE[type] : "muted";
}

/** Một dòng chú giải màu ghim. */
export type MapLegendItem = { kind: MarkerKind; label: string };

/** Chú giải của bản đồ tổng quan ở tab "Của nhà xe". */
export const OWN_MAP_LEGEND: MapLegendItem[] = [
  { kind: "office", label: "Văn phòng trung chuyển" },
  { kind: "restStop", label: "Trạm dừng nghỉ" },
  { kind: "muted", label: "Ngừng dùng / bị khóa" }
];

/** Chú giải của bản đồ tổng quan ở tab "Dùng chung". */
export const SHARED_MAP_LEGEND: MapLegendItem[] = [
  { kind: "busStation", label: "Bến xe" },
  { kind: "pickup", label: "Điểm dừng đón trả khách" },
  { kind: "restStop", label: "Trạm dừng nghỉ" }
];

/**
 * Điểm đang được chọn trên bản đồ tổng quan. `token` đổi mỗi lần chọn để chọn lại đúng điểm cũ vẫn đưa bản đồ
 * về đó; `zoomIn` = chọn từ bảng nên phóng tới gần, còn bấm ghim thì giữ mức phóng đang xem.
 */
export type OverviewSelection = { id: string; token: number; zoomIn: boolean };

/** Lựa chọn mới của bản đồ tổng quan: chọn điểm `id`, hoặc bỏ chọn khi `id` là `null`. */
export function nextSelection(
  current: OverviewSelection | null,
  id: string | null,
  zoomIn: boolean
): OverviewSelection | null {
  return id === null ? null : { id, zoomIn, token: (current?.token ?? 0) + 1 };
}

/** Số chữ số thập phân giữ lại khi lấy tọa độ từ bản đồ (khoảng 0,1 m). */
export const COORDINATE_DECIMALS = 6;

function roundCoordinate(value: number): number {
  const factor = 10 ** COORDINATE_DECIMALS;
  return Math.round(value * factor) / factor;
}

/** Tọa độ lấy từ bản đồ, làm tròn trước khi đưa vào ô nhập. */
export function roundPoint(point: MapPoint): MapPoint {
  return { latitude: roundCoordinate(point.latitude), longitude: roundCoordinate(point.longitude) };
}

/** Chữ của một tọa độ trong ô nhập, vd `11.9404`. */
export function formatCoordinate(value: number): string {
  return String(roundCoordinate(value));
}

/** Vị trí ứng với hai ô vĩ độ / kinh độ; `null` khi còn trống hoặc ngoài khoảng cho phép. */
export function pointFromInputs(latitudeText: string, longitudeText: string): MapPoint | null {
  const latitude = parseCoordinate(latitudeText);
  const longitude = parseCoordinate(longitudeText);
  if (latitude === null || longitude === null) {
    return null;
  }
  const point = { latitude, longitude };
  return isValidPoint(point) ? point : null;
}

/** Hai vị trí có trùng nhau không. */
export function samePoint(a: MapPoint | null, b: MapPoint | null): boolean {
  return a === b || (a !== null && b !== null && a.latitude === b.latitude && a.longitude === b.longitude);
}

/** Một ghim đánh số của tuyến trên bản đồ lộ trình. */
export type RouteMapStop = { key: string; order: number; name: string; tone: "primary" | "amber"; point: MapPoint };

/** Ghim đánh số theo thứ tự hành trình; trạm dừng nghỉ màu vàng vì không đón trả khách (BR-79). */
export function routeMapStops(stops: DraftStop[]): RouteMapStop[] {
  return stops.map((stop, index) => ({
    key: stopKey(stop),
    order: index + 1,
    name: stop.name,
    tone: stop.type === "REST_STOP" ? "amber" : "primary",
    point: { latitude: stop.latitude, longitude: stop.longitude }
  }));
}

/** Một chấm xám: điểm đang có trong bảng chọn nhưng chưa nằm trong tuyến. */
export type RouteMapCandidate = { key: string; name: string; point: MapPoint; highlighted: boolean };

/** Chấm xám của bảng chọn điểm dừng; điểm đã có trong tuyến không lặp lại, điểm đang được rê tới thì nổi lên. */
export function routeMapCandidates(
  stops: DraftStop[],
  candidates: readonly StopCandidate[],
  highlightedKey: string | null
): RouteMapCandidate[] {
  const inRoute = new Set(stops.map(stopKey));
  return candidates
    .filter((candidate) => !inRoute.has(stopKey(candidate)))
    .map((candidate) => ({
      key: stopKey(candidate),
      name: candidate.name,
      point: { latitude: candidate.latitude, longitude: candidate.longitude },
      highlighted: stopKey(candidate) === highlightedKey
    }));
}
