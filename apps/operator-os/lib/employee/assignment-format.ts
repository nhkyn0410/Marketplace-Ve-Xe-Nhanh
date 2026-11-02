// Logic thuần của màn Phân công chuyến (Figma "05 · Nhân viên / Phân công chuyến"; TASK-EMP-001): tình trạng từng dòng,
// danh sách tài xế chọn được, câu lỗi khi phân công.
import { ApiError } from "../auth/api-client";
import { formatTime } from "../trip/trip-format";
import type { Employee } from "./employee-api";
import type { TripAssignment } from "./assignment-api";

export type AssignmentTone = "success" | "warning" | "danger";

/** Tình trạng một dòng: trùng lịch (do lỗi vừa phân công hoặc giờ chuyến bị sửa sau) > đã phân công > chưa phân công. */
export function assignmentState(item: Pick<TripAssignment, "driver" | "conflict">, hasError: boolean): { label: string; tone: AssignmentTone } {
  if (hasError || item.conflict) {
    return { label: "Trùng lịch", tone: "danger" };
  }
  return item.driver ? { label: "Đã phân công", tone: "success" } : { label: "Chưa phân công", tone: "warning" };
}

/** Dòng báo dưới ô tài xế khi chuyến bị chồng giờ với chuyến khác của cùng tài xế. */
export function conflictNote(conflict: NonNullable<TripAssignment["conflict"]>): string {
  return `Trùng giờ chạy với chuyến ${formatTime(conflict.departureAt)} – ${formatTime(conflict.arrivalAt)}`;
}

/** Tài xế chọn được: vai trò Tài xế, đang hoạt động, sắp theo tên đăng nhập. */
export function driverOptions(employees: readonly Employee[]): Employee[] {
  return employees
    .filter((employee) => employee.role === "DRIVER" && employee.status === "ACTIVE")
    .sort((a, b) => a.username.localeCompare(b.username));
}

/** Lỗi khi phân công → câu hiện dưới ô tài xế của dòng đó. */
export function describeAssignError(error: unknown): string {
  if (error instanceof ApiError) {
    switch (error.code) {
      case "DRIVER_SCHEDULE_CONFLICT":
        // Câu của máy chủ nêu giờ chuyến kia: "Tài xế đã chạy chuyến 06:00 16/10 – 11:30 16/10 trùng giờ với chuyến này."
        return error.message;
      case "EMPLOYEE_NOT_ASSIGNABLE":
        return "Nhân viên không còn là tài xế đang hoạt động. Tải lại trang rồi chọn người khác.";
      case "TRIP_NOT_ASSIGNABLE":
        return "Chuyến đã hủy hoặc đã hoàn thành nên không đổi phân công được.";
      case "ASSIGNMENT_REASON_REQUIRED":
        return "Chuyến sắp khởi hành hoặc đang chạy — cần nhập lý do đổi phân công.";
      case "TRIP_NOT_FOUND":
        return "Không tìm thấy chuyến. Tải lại trang.";
    }
    if (error.status === 503) {
      return "Chưa ghi được lịch sử thay đổi nên phân công chưa đổi. Vui lòng thử lại.";
    }
  }
  return "Chưa lưu được phân công. Vui lòng kiểm tra kết nối và thử lại.";
}
