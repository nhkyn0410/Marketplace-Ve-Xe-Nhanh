// Gọi API tài khoản nhân viên cho Operator OS (05 API §7.3; TASK-IAM-005). Kiểu lấy từ client sinh tự OpenAPI
// nên DTO backend đổi mà chưa sửa ở đây thì typecheck đỏ. Tạo / sửa / cấp lại mật khẩu đều cần xác nhận lại
// danh tính trong 5 phút gần nhất (`lib/auth/reauth.ts`).
import type { components } from "@vexenhanh/api-client";

import { apiRequest } from "../auth/api-client";

type Schemas = components["schemas"];

export type Employee = Schemas["EmployeeAccountResponseDto_Output"];
export type EmployeeRole = Employee["role"];
export type EmployeeStatus = Employee["status"];
export type EmployeeCreateInput = Schemas["EmployeeCreateDto"];
export type EmployeeUpdateInput = Schemas["EmployeeUpdateDto"];
type EmployeePage = Schemas["EmployeeListResponseDto_Output"];

/**
 * Mọi tài khoản nhân viên của nhà xe. API chưa có tìm / lọc nên màn Nhân viên tải hết rồi lọc ở giao diện;
 * số nhân viên của một nhà xe nhỏ nên đi hết các trang là đủ.
 */
export async function listAllEmployees(): Promise<Employee[]> {
  const items: Employee[] = [];
  let cursor: string | null = null;
  do {
    const query = new URLSearchParams({ limit: "100" });
    if (cursor) {
      query.set("cursor", cursor);
    }
    const page: EmployeePage = await apiRequest<EmployeePage>(`/operator/employees?${query}`);
    items.push(...page.items);
    cursor = page.nextCursor;
  } while (cursor);
  return items;
}

/** Tạo tài khoản nhân viên; mật khẩu tạm được gửi một lần tới email liên hệ. */
export function createEmployee(input: EmployeeCreateInput): Promise<Employee> {
  return apiRequest<Employee>("/operator/employees", { method: "POST", body: input });
}

/** Đổi tên đăng nhập / email / vai trò / trạng thái; chỉ gửi trường thay đổi, luôn kèm lý do. */
export function updateEmployee(employeeId: string, input: EmployeeUpdateInput): Promise<Employee> {
  return apiRequest<Employee>(`/operator/employees/${employeeId}`, { method: "PATCH", body: input });
}

/** Cấp mật khẩu tạm mới, gửi tới email liên hệ và đăng xuất nhân viên khỏi mọi thiết bị. */
export function resetEmployeePassword(employeeId: string, reason: string): Promise<void> {
  return apiRequest<void>(`/operator/employees/${employeeId}/password-reset`, { method: "POST", body: { reason } });
}
