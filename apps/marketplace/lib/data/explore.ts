"use server";

import type { components } from "@vexenhanh/api-client";
import { apiRequest } from "./api";
import { apiMoney } from "./trip-mappers";

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
