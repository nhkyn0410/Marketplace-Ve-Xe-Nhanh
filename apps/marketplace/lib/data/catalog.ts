"use server";

import type { components } from "@vexenhanh/api-client";
import { apiRequest } from "./api";
import { ok, type DataResult } from "./result";
import type { ProvinceItem, StopPointItem } from "./types";

/** Lấy tỉnh thành từ trường items trong phản hồi danh mục. */
export async function getProvinces(): Promise<DataResult<readonly ProvinceItem[]>> {
  const result = await apiRequest<components["schemas"]["ProvinceListResponseDto_Output"]>("/catalog/provinces");
  return result.status === "ok" ? ok(result.data.items) : result;
}

/** Tìm điểm đón trả công khai theo tên hoặc địa chỉ. */
export async function getStopPoints(query?: string): Promise<DataResult<readonly StopPointItem[]>> {
  const params = new URLSearchParams({ limit: "100" });
  if (query?.trim()) params.set("q", query.trim());
  const result = await apiRequest<components["schemas"]["StopPointListResponseDto_Output"]>(`/catalog/stop-points?${params}`);
  return result.status === "ok" ? ok(result.data.items) : result;
}
