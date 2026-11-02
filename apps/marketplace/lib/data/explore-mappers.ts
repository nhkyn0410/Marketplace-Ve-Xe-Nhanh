import { addDays, placeType, type PlaceType } from "./trip-mappers";
import type { FeaturedOperatorItem } from "./types";

type OperatorRoute = NonNullable<FeaturedOperatorItem["routes"]>[number];

const ISO_DATE = /^\d{4}-\d{2}-\d{2}$/;

/** Hành trình đang xem ở tab "Chuyến xe" của trang Khám phá. */
export interface ExploreTripsJourney {
  readonly origin: string;
  readonly originType: PlaceType;
  readonly originLabel: string;
  readonly destination: string;
  readonly destinationType: PlaceType;
  readonly destinationLabel: string;
  readonly date: string;
  readonly passengers: number;
}

type Read = (key: string) => string | null | undefined;

/**
 * Chọn hành trình cho tab "Chuyến xe" theo thứ tự như app: điều kiện trên URL → lần tìm gần nhất (cookie) → tuyến phổ
 * biến. Ngày đã qua / sai định dạng thì lấy nguồn kế tiếp, cuối cùng là ngày mai.
 */
export function resolveExploreJourney(sources: readonly (Read | null)[], today: string): ExploreTripsJourney | null {
  const usable = sources.filter((read): read is Read => read !== null);
  const place = usable.find((read) => read("origin") && read("destination"));
  if (!place) return null;
  const date = usable.map((read) => read("date") ?? "").find((value) => ISO_DATE.test(value) && value >= today) ?? addDays(today, 1);
  const passengers = Math.trunc(Number(place("passengers")));
  return {
    origin: place("origin")!,
    originType: placeType(place("originType") ?? undefined),
    originLabel: place("originLabel") ?? "",
    destination: place("destination")!,
    destinationType: placeType(place("destinationType") ?? undefined),
    destinationLabel: place("destinationLabel") ?? "",
    date,
    passengers: passengers >= 1 && passengers <= 10 ? passengers : 1
  };
}

/** Nhà xe đánh giá cao trước; cùng điểm thì nhiều lượt đánh giá trước (như app). */
export function rankOperators(operators: readonly FeaturedOperatorItem[]): FeaturedOperatorItem[] {
  return [...operators].sort((a, b) => (b.rating ?? -1) - (a.rating ?? -1) || (b.reviewCount ?? 0) - (a.reviewCount ?? 0));
}

/** Tuyến có đi qua khu vực (tỉnh) không. */
function touches(route: OperatorRoute, area: string): boolean {
  return route.originProvinceId === area || route.destinationProvinceId === area;
}

/** Khóa tuyến trên URL: `tỉnhĐi>tỉnhĐến`. */
export function routeKey(route: OperatorRoute): string {
  return `${route.originProvinceId}>${route.destinationProvinceId}`;
}

/**
 * Tuyến đầu tiên của nhà xe khớp khu vực + tuyến đang lọc; không lọc gì = tuyến đầu tiên; không khớp → `null`. Tuyến
 * đang lọc không đi qua khu vực đang lọc thì bỏ lọc tuyến (như app).
 */
export function servedRoute(operator: FeaturedOperatorItem, area?: string, route?: string): OperatorRoute | null {
  const routes = operator.routes ?? [];
  const routeFilter = route && (!area || routes.some((item) => routeKey(item) === route && touches(item, area))) ? route : undefined;
  return routes.find((item) => (!area || touches(item, area)) && (!routeFilter || routeKey(item) === routeFilter)) ?? null;
}

/** Khu vực (tỉnh) có tuyến của các nhà xe, theo tên. */
export function exploreAreas(operators: readonly FeaturedOperatorItem[]): { readonly id: string; readonly name: string }[] {
  const areas = new Map<string, string>();
  for (const route of operators.flatMap((operator) => operator.routes ?? [])) {
    areas.set(route.originProvinceId, route.originName ?? route.originProvinceId);
    areas.set(route.destinationProvinceId, route.destinationName ?? route.destinationProvinceId);
  }
  return [...areas].map(([id, name]) => ({ id, name })).sort((a, b) => a.name.localeCompare(b.name, "vi"));
}

/** Tuyến phục vụ (gộp theo cặp tỉnh), chỉ tuyến đi qua khu vực đang lọc. */
export function exploreRoutes(operators: readonly FeaturedOperatorItem[], area?: string): { readonly key: string; readonly label: string }[] {
  const routes = new Map<string, string>();
  for (const route of operators.flatMap((operator) => operator.routes ?? [])) {
    if (!area || touches(route, area)) routes.set(routeKey(route), route.label);
  }
  return [...routes].map(([key, label]) => ({ key, label })).sort((a, b) => a.label.localeCompare(b.label, "vi"));
}
