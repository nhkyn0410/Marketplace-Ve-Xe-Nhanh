// Dữ liệu cho các bản đồ điểm dừng của Operator OS và Admin (TASK-TRN-014, TASK-ADM-004; Figma "VXN / Map
// marker"). Hàm thuần để test được.
import { isValidPoint, type MapPoint } from "./map";

/** Loại / trạng thái điểm dừng như API (client sinh của từng app có kiểu riêng, cùng giá trị). */
type StopPointType = "BUS_STATION" | "PICKUP_POINT" | "OFFICE" | "REST_STOP";
type StopPointStatus = "ACTIVE" | "INACTIVE" | "SUSPENDED";

/** Đổi chữ người dùng gõ thành số; nhận cả dấu phẩy thập phân (`10,75`). Không phải số → `null`. */
export function parseCoordinate(value: string): number | null {
  const text = value.trim().replace(",", ".");
  if (!/^-?\d+(\.\d+)?$/.test(text)) {
    return null;
  }
  return Number(text);
}

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
