// Gọi API Phân công chuyến cho Operator OS (05 API §7.3, TASK-EMP-001). Kiểu lấy từ client sinh tự OpenAPI.
import type { components } from "@vexenhanh/api-client";

import { apiRequest } from "../auth/api-client";

type Schemas = components["schemas"];

export type TripAssignment = Schemas["TripAssignmentDto_Output"];
export type TripAssignmentPage = Schemas["TripAssignmentPageDto_Output"];
export type AssignmentState = "ASSIGNED" | "UNASSIGNED";

/** Số chuyến mỗi lần tải (Figma "Tải thêm"). */
export const ASSIGNMENT_PAGE_SIZE = 20;

export type AssignmentListParams = { date: string; routeId?: string; state?: AssignmentState; cursor?: string };

/** Một trang chuyến chưa hủy khởi hành trong ngày `date` (giờ VN) kèm tài xế đang phân công. */
export function listTripAssignments(params: AssignmentListParams): Promise<TripAssignmentPage> {
  const query = new URLSearchParams({ limit: String(ASSIGNMENT_PAGE_SIZE) });
  for (const [key, value] of Object.entries(params)) {
    if (value) {
      query.set(key, value);
    }
  }
  return apiRequest<TripAssignmentPage>(`/operator/trip-assignments?${query}`);
}

/** Phân công / đổi / bỏ (`employeeId = null`) tài xế của một chuyến; `reason` bắt buộc khi chuyến sắp chạy / đang chạy. */
export function assignDriver(tripId: string, employeeId: string | null, reason: string | null): Promise<TripAssignment> {
  return apiRequest<TripAssignment>(`/operator/trips/${tripId}/driver`, { method: "PUT", body: { employeeId, reason } });
}
