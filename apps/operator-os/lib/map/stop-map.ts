// Bản đồ lộ trình của màn Tuyến đường (TASK-TRN-014). Phần dùng chung với Admin (ghim, chú giải, tọa độ) nằm ở
// `@vexenhanh/ui/lib/stop-map`.
import type { MapPoint } from "@vexenhanh/ui/lib/map";

import { stopKey, type DraftStop, type StopCandidate } from "../route/route-form";

export * from "@vexenhanh/ui/lib/stop-map";

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
