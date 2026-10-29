// Gọi API Tuyến đường cho Operator OS (05 API §7.3). Kiểu lấy từ client sinh tự OpenAPI nên DTO backend đổi
// mà chưa sửa ở đây thì typecheck đỏ.
import type { components } from "@vexenhanh/api-client";

import { apiRequest } from "../auth/api-client";

type Schemas = components["schemas"];

export type Route = Schemas["RouteResponseDto_Output"];
export type RouteStop = Route["stops"][number];
export type RoutePage = Schemas["RouteListResponseDto_Output"];
export type RouteSummary = RoutePage["items"][number];
export type RouteInput = Schemas["RouteInputDto"];
export type RouteStatus = Route["status"];
export type SubRoute = Route["subRoutes"][number];
export type SubRouteInput = Schemas["SubRouteInputDto"];
export type SubRouteSuggestion = Schemas["SubRouteSuggestionListDto_Output"]["items"][number];

/** Số dòng mỗi lần tải danh sách tuyến (mặc định của API). */
export const ROUTE_PAGE_SIZE = 20;

/** Một trang tuyến của nhà xe; `cursor` là `nextCursor` của trang trước. */
export function listRoutes(params: { status?: RouteStatus; cursor?: string }): Promise<RoutePage> {
  const query = new URLSearchParams({ limit: String(ROUTE_PAGE_SIZE) });
  if (params.status) {
    query.set("status", params.status);
  }
  if (params.cursor) {
    query.set("cursor", params.cursor);
  }
  return apiRequest<RoutePage>(`/operator/routes?${query}`);
}

/**
 * Mọi tuyến của nhà xe; đi hết các trang vì ô chọn tuyến của màn Chuyến xe cần đủ danh sách. Mặc định chỉ tuyến chính
 * (chuyến chỉ chạy trên tuyến chính); `includeSubRoutes` cho ô chọn tuyến của Bảng giá (tuyến con có giá riêng).
 */
export async function listAllRoutes(status?: RouteStatus, options: { includeSubRoutes?: boolean } = {}): Promise<RouteSummary[]> {
  const items: RouteSummary[] = [];
  let cursor: string | null = null;
  do {
    const query = new URLSearchParams({ limit: "100" });
    if (status) {
      query.set("status", status);
    }
    if (options.includeSubRoutes) {
      query.set("includeSubRoutes", "true");
    }
    if (cursor) {
      query.set("cursor", cursor);
    }
    const page: RoutePage = await apiRequest<RoutePage>(`/operator/routes?${query}`);
    items.push(...page.items);
    cursor = page.nextCursor;
  } while (cursor);
  return items;
}

/** Chi tiết một tuyến kèm điểm dừng theo thứ tự và số liệu từng chặng. */
export function getRoute(routeId: string): Promise<Route> {
  return apiRequest<Route>(`/operator/routes/${routeId}`);
}

/**
 * Tên tuyến tự động cho điểm dừng đang sửa (3.1, chờ duyệt) — "TP.HCM → Buôn Ma Thuột (qua Gia Nghĩa)", đã tránh trùng tuyến
 * khác của nhà xe. `routeId` = tuyến đang sửa (không tính trùng với chính nó).
 */
export async function previewRouteName(stops: RouteInput["stops"], routeId?: string): Promise<string> {
  const result = await apiRequest<Schemas["RouteNamePreviewDto_Output"]>("/operator/routes/name-suggestion", {
    method: "POST",
    body: { stops, routeId: routeId ?? null }
  });
  return result.name;
}

/** Tạo tuyến mới; máy chủ tự tính quãng đường và thời gian từng chặng. */
export function createRoute(input: RouteInput): Promise<Route> {
  return apiRequest<Route>("/operator/routes", { method: "POST", body: input });
}

/** Thay toàn bộ một tuyến (PUT gửi đủ mọi trường và toàn bộ danh sách điểm dừng). */
export function updateRoute(routeId: string, input: RouteInput): Promise<Route> {
  return apiRequest<Route>(`/operator/routes/${routeId}`, { method: "PUT", body: input });
}

/** Đoạn gợi ý thành tuyến con (3.2) — theo nhóm nơi, kèm bảng giá gợi ý theo tỉ lệ quãng đường. */
export async function listSubRouteSuggestions(routeId: string): Promise<SubRouteSuggestion[]> {
  const result = await apiRequest<Schemas["SubRouteSuggestionListDto_Output"]>(`/operator/routes/${routeId}/sub-route-suggestions`);
  return result.items;
}

/** Tạo tuyến con của tuyến chính; điểm dừng chép theo đoạn của tuyến chính. */
export function createSubRoute(parentId: string, input: SubRouteInput): Promise<Route> {
  return apiRequest<Route>(`/operator/routes/${parentId}/sub-routes`, { method: "POST", body: input });
}

/** Thay toàn bộ một tuyến con (đổi hai đầu thì chép lại đoạn). */
export function updateSubRoute(parentId: string, subRouteId: string, input: SubRouteInput): Promise<Route> {
  return apiRequest<Route>(`/operator/routes/${parentId}/sub-routes/${subRouteId}`, { method: "PUT", body: input });
}
