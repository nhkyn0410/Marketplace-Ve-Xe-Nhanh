// Gọi API Lịch chuyến lặp lại cho Operator OS (05 API §7.3, TASK-TRN-007). Kiểu lấy từ client sinh tự OpenAPI.
import type { components } from "@vexenhanh/api-client";

import { apiRequest } from "../auth/api-client";

type Schemas = components["schemas"];

export type TripSchedule = Schemas["TripScheduleResponseDto_Output"];
export type TripScheduleInput = Schemas["TripScheduleInputDto"];
export type TripScheduleGenerateResult = Schemas["TripScheduleGenerateResponseDto_Output"];
export type GeneratedTrip = TripScheduleGenerateResult["created"][number];
export type SkippedDay = TripScheduleGenerateResult["skipped"][number];

/** Các lịch của nhà xe — lịch còn hiệu lực trước. */
export async function listTripSchedules(): Promise<TripSchedule[]> {
  return (await apiRequest<Schemas["TripScheduleListResponseDto_Output"]>("/operator/trip-schedules")).items;
}

export function getTripSchedule(scheduleId: string): Promise<TripSchedule> {
  return apiRequest<TripSchedule>(`/operator/trip-schedules/${scheduleId}`);
}

export function createTripSchedule(input: TripScheduleInput): Promise<TripSchedule> {
  return apiRequest<TripSchedule>("/operator/trip-schedules", { method: "POST", body: input });
}

/** Thay toàn bộ quy tắc của lịch; chuyến đã sinh giữ nguyên. */
export function updateTripSchedule(scheduleId: string, input: TripScheduleInput): Promise<TripSchedule> {
  return apiRequest<TripSchedule>(`/operator/trip-schedules/${scheduleId}`, { method: "PUT", body: input });
}

/** Sinh chuyến nháp cho các ngày khớp lịch còn ở tương lai; `openForSale` = mở bán ngay chuyến đủ điều kiện. */
export function generateTripSchedule(scheduleId: string, openForSale: boolean): Promise<TripScheduleGenerateResult> {
  return apiRequest<TripScheduleGenerateResult>(`/operator/trip-schedules/${scheduleId}/generate`, {
    method: "POST",
    body: { openForSale }
  });
}
