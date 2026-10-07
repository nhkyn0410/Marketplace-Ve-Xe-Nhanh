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

/** Chi tiết một tuyến kèm điểm dừng theo thứ tự và số liệu từng chặng. */
export function getRoute(routeId: string): Promise<Route> {
  return apiRequest<Route>(`/operator/routes/${routeId}`);
}

/** Tạo tuyến mới; máy chủ tự tính quãng đường và thời gian từng chặng. */
export function createRoute(input: RouteInput): Promise<Route> {
  return apiRequest<Route>("/operator/routes", { method: "POST", body: input });
}

/** Thay toàn bộ một tuyến (PUT gửi đủ mọi trường và toàn bộ danh sách điểm dừng). */
export function updateRoute(routeId: string, input: RouteInput): Promise<Route> {
  return apiRequest<Route>(`/operator/routes/${routeId}`, { method: "PUT", body: input });
}
