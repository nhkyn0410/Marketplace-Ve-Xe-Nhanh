import { ApiError } from "../auth/api-client";
import type { Employee } from "../employee/employee-api";
import type { OfficeAssignment } from "./office-api";

/** Gộp tài khoản hiện tại và phân công cũ để không bỏ sót người đã bị khóa. */
export function officeAssignmentOptions(employees: Pick<Employee, "id" | "username" | "status" | "role">[], assigned: OfficeAssignment[]) {
  const options = new Map(assigned.map((item) => [item.employeeId, { ...item, assigned: true }]));
  for (const employee of employees) {
    if ((employee.role === "SALES_STAFF" && employee.status === "ACTIVE") || options.has(employee.id)) {
      options.set(employee.id, {
        employeeId: employee.id,
        username: employee.username,
        status: employee.role === "SALES_STAFF" ? employee.status : "DISABLED",
        assigned: options.has(employee.id)
      });
    }
  }
  return [...options.values()].sort((a, b) => a.username.localeCompare(b.username, "vi"));
}

/** Chuyển lỗi văn phòng thành thông báo và yêu cầu tải lại khi dữ liệu đã đổi. */
export function describeOfficeError(error: unknown): { message: string; stale: boolean } {
  if (error instanceof ApiError) {
    switch (error.code) {
      case "OFFICE_CODE_CONFLICT":
        return { message: "Mã văn phòng đã được sử dụng. Chọn mã khác.", stale: false };
      case "OFFICE_VERSION_CONFLICT":
        return { message: "Văn phòng đã thay đổi ở nơi khác. Đóng hộp thoại rồi mở lại để tải thông tin mới.", stale: true };
      case "OFFICE_NOT_FOUND":
        return { message: "Văn phòng không còn trong phạm vi truy cập. Đóng hộp thoại để tải lại danh sách.", stale: true };
      case "OFFICE_ASSIGNMENT_INVALID":
        return { message: "Có tài khoản không còn đủ điều kiện phân công. Đóng hộp thoại rồi mở lại để cập nhật danh sách.", stale: true };
      default:
        if (error.status === 403) {
          return { message: "Bạn không có quyền thực hiện thao tác này.", stale: true };
        }
    }
  }
  return { message: "Chưa lưu được thay đổi. Kiểm tra kết nối rồi thử lại.", stale: false };
}
