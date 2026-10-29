"use server";

import type { components } from "@vexenhanh/api-client";
import { apiRequest } from "./api";
import { ok, type DataResult } from "./result";
import { apiMoney, vnToday } from "./trip-mappers";

/** Điều kiện hành trình mặc định của trang Khám phá. */
export interface ExploreJourney {
  readonly origin: string;
  readonly originLabel: string;
  readonly destination: string;
  readonly destinationLabel: string;
  readonly date: string;
}

/**
 * Hành trình mặc định khi chưa có lần tìm nào (như app): tuyến phổ biến đầu tiên, ngày có chuyến sớm nhất của tuyến.
 * Chưa có tuyến phổ biến → `null` (trang nhắc chọn tuyến).
 */
export async function getDefaultExploreJourney(): Promise<DataResult<ExploreJourney | null>> {
  const result = await apiRequest<components["schemas"]["PopularRouteListResponseDto_Output"]>("/catalog/popular-routes?limit=1");
  if (result.status !== "ok") return result;
  const route = result.data.items[0];
  if (!route) return ok(null);
  return ok({
    origin: route.originProvinceId,
    originLabel: route.originName,
    destination: route.destinationProvinceId,
    destinationLabel: route.destinationName,
    date: route.nextDepartureAt ? vnToday(new Date(route.nextDepartureAt)) : vnToday()
  });
}

/**
 * Giá vé thấp nhất (VND, chuỗi) của nhà xe trên một tuyến (cặp tỉnh) vào ngày đi — ô "Giá vé từ" của thẻ nhà xe, như app.
 * Ngày đó không có chuyến hoặc gọi lỗi → `null` (thẻ ghi "Chưa có chuyến ngày này").
 */
export async function getOperatorMinFare(operatorId: string, originProvinceId: string, destinationProvinceId: string, date: string): Promise<string | null> {
  const query = new URLSearchParams({
    fromProvinceId: originProvinceId, toProvinceId: destinationProvinceId, date, passengers: "1", operatorId, sort: "price", limit: "1"
  });
  const result = await apiRequest<components["schemas"]["TripSearchResponseDto_Output"]>(`/trips/search?${query}`);
  const item = result.status === "ok" ? result.data.items[0] : undefined;
  try {
    return item ? apiMoney(item.minPrice) : null;
  } catch {
    return null;
  }
}
