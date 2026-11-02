import type { components } from "@vexenhanh/api-client";

import { apiRequest } from "../auth/api-client";

type Schemas = components["schemas"];

export type SalesOffice = Schemas["SalesOfficeDto_Output"];
export type SalesOfficeInput = Schemas["SalesOfficeInputDto"];
export type SalesOfficeUpdate = Schemas["SalesOfficeUpdateDto"];
export type OfficeAssignment = Schemas["SalesOfficeAssignmentsDto_Output"]["items"][number];

/** Tải các văn phòng bán vé trong phạm vi tài khoản đang đăng nhập. */
export async function listSalesOffices(): Promise<SalesOffice[]> {
  return (await apiRequest<Schemas["SalesOfficeListDto_Output"]>("/operator/offices")).items;
}

/** Tải phiên bản hiện tại của một văn phòng bán vé. */
export function getSalesOffice(officeId: string): Promise<SalesOffice> {
  return apiRequest<SalesOffice>(`/operator/offices/${officeId}`);
}

/** Tạo văn phòng bán vé thuộc nhà xe đang đăng nhập. */
export function createSalesOffice(input: SalesOfficeInput): Promise<SalesOffice> {
  return apiRequest<SalesOffice>("/operator/offices", { method: "POST", body: input });
}

/** Cập nhật thông tin hoặc trạng thái văn phòng theo phiên bản đang xem. */
export function updateSalesOffice(officeId: string, input: SalesOfficeUpdate): Promise<SalesOffice> {
  return apiRequest<SalesOffice>(`/operator/offices/${officeId}`, { method: "PATCH", body: input });
}

/** Tải nhân viên bán vé được phân công tại một văn phòng. */
export async function listOfficeAssignments(officeId: string): Promise<OfficeAssignment[]> {
  return (await apiRequest<Schemas["SalesOfficeAssignmentsDto_Output"]>(`/operator/offices/${officeId}/assignments`)).items;
}

/** Thay danh sách nhân viên bán vé được làm việc tại một văn phòng. */
export function updateOfficeAssignments(officeId: string, employeeIds: string[], version: number): Promise<SalesOffice> {
  return apiRequest<SalesOffice>(`/operator/offices/${officeId}/assignments`, { method: "PUT", body: { employeeIds, version } });
}
