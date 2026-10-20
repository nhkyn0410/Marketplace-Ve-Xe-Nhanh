import { DataResult, failed, ok } from "./result";
import { ProvinceItem, StopPointItem } from "./types";

const API_BASE_URL = process.env.API_BASE_URL ?? "http://localhost:3000/v1";

/**
 * Lấy danh sách tỉnh/thành phố phục vụ tìm kiếm chuyến xe từ server API.
 * Endpoint: GET /catalog/provinces (đã có trong hợp đồng API).
 */
export async function getProvinces(): Promise<DataResult<readonly ProvinceItem[]>> {
  try {
    const res = await fetch(`${API_BASE_URL}/catalog/provinces`, {
      next: { revalidate: 3600 }
    });

    if (!res.ok) {
      return failed(
        "GET /catalog/provinces",
        `Lỗi tải danh mục tỉnh thành: ${res.status} ${res.statusText}`
      );
    }

    const data = (await res.json()) as readonly ProvinceItem[];
    return ok(data);
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    return failed("GET /catalog/provinces", message);
  }
}

/**
 * Tìm kiếm điểm đón/trả theo từ khóa từ server API.
 * Endpoint: GET /catalog/stop-points?q= (đã có trong hợp đồng API).
 */
export async function getStopPoints(query?: string): Promise<DataResult<readonly StopPointItem[]>> {
  try {
    const params = new URLSearchParams();
    if (query && query.trim().length > 0) {
      params.set("q", query.trim());
    }

    const res = await fetch(`${API_BASE_URL}/catalog/stop-points?${params.toString()}`, {
      next: { revalidate: 300 }
    });

    if (!res.ok) {
      return failed(
        "GET /catalog/stop-points",
        `Lỗi tải điểm dừng: ${res.status} ${res.statusText}`
      );
    }

    const data = (await res.json()) as readonly StopPointItem[];
    return ok(data);
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    return failed("GET /catalog/stop-points", message);
  }
}
