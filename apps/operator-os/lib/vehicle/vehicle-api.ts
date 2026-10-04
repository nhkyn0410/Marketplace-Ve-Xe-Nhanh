// Gọi API Vehicle / SeatMap / catalog cho Operator OS (05 API §7.3, §7.6). Kiểu lấy từ client sinh tự
// OpenAPI nên DTO backend đổi mà chưa sửa ở đây thì typecheck đỏ.
import type { components } from "@vexenhanh/api-client";

import { apiRequest } from "../auth/api-client";

type Schemas = components["schemas"];

export type Vehicle = Schemas["VehicleResponseDto_Output"];
export type VehicleStatus = Vehicle["status"];
export type VehiclePage = Schemas["VehicleListResponseDto_Output"];
export type VehicleInput = Schemas["VehicleInputDto"];
export type VehicleType = Schemas["VehicleTypeListResponseDto_Output"]["items"][number];
export type Amenity = Schemas["AmenityListResponseDto_Output"]["items"][number];
export type SeatMapSummary = Schemas["SeatMapListResponseDto_Output"]["items"][number];
export type SeatMapPage = Schemas["SeatMapListResponseDto_Output"];
export type SeatMap = Schemas["SeatMapResponseDto_Output"];
export type SeatMapInput = Schemas["SeatMapInputDto"];
export type Seat = SeatMap["seats"][number];
export type SeatType = Seat["type"];

/** Số dòng mỗi lần tải danh sách xe (mặc định của API). */
export const VEHICLE_PAGE_SIZE = 20;

/** Một trang xe của nhà xe; `cursor` là `nextCursor` của trang trước. */
export function listVehicles(params: { status?: VehicleStatus; cursor?: string }): Promise<VehiclePage> {
  const query = new URLSearchParams({ limit: String(VEHICLE_PAGE_SIZE) });
  if (params.status) {
    query.set("status", params.status);
  }
  if (params.cursor) {
    query.set("cursor", params.cursor);
  }
  return apiRequest<VehiclePage>(`/operator/vehicles?${query}`);
}

/** Chi tiết một xe của nhà xe. */
export function getVehicle(vehicleId: string): Promise<Vehicle> {
  return apiRequest<Vehicle>(`/operator/vehicles/${vehicleId}`);
}

/** Tạo xe mới. */
export function createVehicle(input: VehicleInput): Promise<Vehicle> {
  return apiRequest<Vehicle>("/operator/vehicles", { method: "POST", body: input });
}

/** Thay toàn bộ thông tin một xe (PUT gửi đủ mọi trường). */
export function updateVehicle(vehicleId: string, input: VehicleInput): Promise<Vehicle> {
  return apiRequest<Vehicle>(`/operator/vehicles/${vehicleId}`, { method: "PUT", body: input });
}

/** Loại xe đang dùng được trong catalog Platform (công khai). */
export async function listVehicleTypes(): Promise<VehicleType[]> {
  return (await apiRequest<{ items: VehicleType[] }>("/catalog/vehicle-types")).items;
}

/** Tiện ích đang dùng được trong catalog Platform (công khai). */
export async function listAmenities(): Promise<Amenity[]> {
  return (await apiRequest<{ items: Amenity[] }>("/catalog/amenities")).items;
}

/** Mọi sơ đồ ghế của nhà xe (không kèm ghế); đi hết các trang vì ô chọn sơ đồ cần đủ danh sách. */
export async function listAllSeatMaps(): Promise<SeatMapSummary[]> {
  const items: SeatMapSummary[] = [];
  let cursor: string | null = null;
  do {
    const query = new URLSearchParams({ limit: "100" });
    if (cursor) {
      query.set("cursor", cursor);
    }
    const page: SeatMapPage = await apiRequest<SeatMapPage>(`/operator/seat-maps?${query}`);
    items.push(...page.items);
    cursor = page.nextCursor;
  } while (cursor);
  return items;
}

/** Chi tiết một sơ đồ ghế kèm bố cục và danh sách chỗ. */
export function getSeatMap(seatMapId: string): Promise<SeatMap> {
  return apiRequest<SeatMap>(`/operator/seat-maps/${seatMapId}`);
}

/** Một trang sơ đồ ghế của nhà xe (không kèm ghế); `cursor` là `nextCursor` của trang trước. */
export function listSeatMaps(params: { cursor?: string }): Promise<SeatMapPage> {
  const query = new URLSearchParams({ limit: String(VEHICLE_PAGE_SIZE) });
  if (params.cursor) {
    query.set("cursor", params.cursor);
  }
  return apiRequest<SeatMapPage>(`/operator/seat-maps?${query}`);
}

/** Tạo sơ đồ ghế mới (cũng dùng khi lưu một bản sao). */
export function createSeatMap(input: SeatMapInput): Promise<SeatMap> {
  return apiRequest<SeatMap>("/operator/seat-maps", { method: "POST", body: input });
}

/** Thay toàn bộ tên, bố cục và danh sách chỗ của một sơ đồ. */
export function updateSeatMap(seatMapId: string, input: SeatMapInput): Promise<SeatMap> {
  return apiRequest<SeatMap>(`/operator/seat-maps/${seatMapId}`, { method: "PUT", body: input });
}
