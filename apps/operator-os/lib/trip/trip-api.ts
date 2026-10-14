// Gọi API Chuyến xe cho Operator OS (05 API §7.3). Kiểu lấy từ client sinh tự OpenAPI nên DTO backend đổi
// mà chưa sửa ở đây thì typecheck đỏ.
import type { components } from "@vexenhanh/api-client";

import { apiRequest } from "../auth/api-client";

type Schemas = components["schemas"];

export type Trip = Schemas["TripResponseDto_Output"];
export type TripStop = Trip["stops"][number];
export type TripSeat = Trip["seats"][number];
export type TripSeatStatus = TripSeat["status"];
export type TripPage = Schemas["TripListResponseDto_Output"];
export type TripSummary = TripPage["items"][number];
export type TripInput = Schemas["TripInputDto"];
export type TripStatus = Trip["status"];
export type TripStatusInput = Schemas["TripStatusInputDto"];
export type TripSeatStatusInput = Schemas["TripSeatStatusInputDto"];

/** Số dòng mỗi lần tải danh sách chuyến (mặc định của API). */
export const TRIP_PAGE_SIZE = 20;

export type TripListParams = {
  routeId?: string;
  vehicleId?: string;
  status?: TripStatus;
  /** Mốc giờ ISO 8601 có múi giờ; `departureTo` là mốc KHÔNG bao gồm. */
  departureFrom?: string;
  departureTo?: string;
  cursor?: string;
};

/** Một trang chuyến của nhà xe, sắp theo giờ khởi hành; `cursor` là `nextCursor` của trang trước. */
export function listTrips(params: TripListParams): Promise<TripPage> {
  const query = new URLSearchParams({ limit: String(TRIP_PAGE_SIZE) });
  for (const [key, value] of Object.entries(params)) {
    if (value) {
      query.set(key, value);
    }
  }
  return apiRequest<TripPage>(`/operator/trips?${query}`);
}

/** Chi tiết một chuyến kèm điểm dừng (giờ dự kiến) và ghế theo chuyến. */
export function getTrip(tripId: string): Promise<Trip> {
  return apiRequest<Trip>(`/operator/trips/${tripId}`);
}

/** Tạo chuyến mới ở trạng thái Nháp. */
export function createTrip(input: TripInput): Promise<Trip> {
  return apiRequest<Trip>("/operator/trips", { method: "POST", body: input });
}

/** Thay toàn bộ một chuyến còn Nháp (PUT gửi đủ mọi trường). */
export function updateTrip(tripId: string, input: TripInput): Promise<Trip> {
  return apiRequest<Trip>(`/operator/trips/${tripId}`, { method: "PUT", body: input });
}

/**
 * Đổi trạng thái bán của chuyến chưa có vé: mở bán / tạm dừng bán / mở bán lại / thu hồi về nháp / hủy. Mở bán
 * chưa đủ điều kiện → 422 `TRIP_NOT_READY_FOR_SALE`, `ApiError.reasons` liệt kê mọi điều kiện chưa đạt (BR-39).
 */
export function changeTripStatus(tripId: string, input: TripStatusInput): Promise<Trip> {
  return apiRequest<Trip>(`/operator/trips/${tripId}/status`, { method: "PUT", body: input });
}

/** Khóa / mở khóa một lô chỗ của chuyến (bán ngoài hệ thống — BR-42): được cả lô hoặc không. */
export function setTripSeatStatus(tripId: string, input: TripSeatStatusInput): Promise<Trip> {
  return apiRequest<Trip>(`/operator/trips/${tripId}/seats/status`, { method: "PUT", body: input });
}
