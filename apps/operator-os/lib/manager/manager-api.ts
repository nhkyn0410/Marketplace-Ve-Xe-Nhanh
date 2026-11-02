// Gọi API tài khoản quản lý của nhà xe (05 API §7.3 `/operator/managers`; TASK-IAM-007 — tự thiết kế, chờ duyệt). Kiểu lấy
// từ client sinh tự OpenAPI. Mọi thao tác thay đổi cần xác nhận lại danh tính trong 5 phút gần nhất (`lib/auth/reauth.ts`).
import type { components } from "@vexenhanh/api-client";

import { apiRequest } from "../auth/api-client";

type Schemas = components["schemas"];

export type Manager = Schemas["ManagerAccountDto_Output"];
export type ManagerPermission = Manager["permissions"][number];
export type ManagerCreateInput = Schemas["ManagerCreateDto"];
export type ManagerUpdateInput = Schemas["ManagerUpdateDto"];

export async function listManagers(): Promise<Manager[]> {
  return (await apiRequest<Schemas["ManagerListDto_Output"]>("/operator/managers")).items;
}

/** Cấp tài khoản: mật khẩu tạm gửi email; lần đầu đăng nhập phải đổi mật khẩu + bật xác thực hai lớp. */
export function createManager(input: ManagerCreateInput): Promise<Manager> {
  return apiRequest<Manager>("/operator/managers", { method: "POST", body: input });
}

/** Đổi quyền / khóa / mở khóa — tài khoản bị đăng xuất khỏi mọi thiết bị để thay đổi có hiệu lực ngay. */
export function updateManager(managerId: string, input: ManagerUpdateInput): Promise<Manager> {
  return apiRequest<Manager>(`/operator/managers/${managerId}`, { method: "PATCH", body: input });
}

export function resetManagerPassword(managerId: string, reason: string): Promise<Manager> {
  return apiRequest<Manager>(`/operator/managers/${managerId}/password-reset`, { method: "POST", body: { reason } });
}

/** Xóa xác thực hai lớp + cấp mật khẩu tạm mới qua email của tài khoản. */
export function resetManagerMfa(managerId: string, reason: string): Promise<Manager> {
  return apiRequest<Manager>(`/operator/managers/${managerId}/mfa-reset`, { method: "POST", body: { reason } });
}
