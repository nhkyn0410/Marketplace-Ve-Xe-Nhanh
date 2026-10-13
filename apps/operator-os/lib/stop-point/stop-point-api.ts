// Gọi API Điểm dừng cho Operator OS (05 API §7.3, §7.6): điểm riêng của nhà xe, danh mục dùng chung của
// Platform và đề xuất bổ sung danh mục. Kiểu lấy từ client sinh tự OpenAPI nên DTO backend đổi mà chưa
// sửa ở đây thì typecheck đỏ.
import type { components } from "@vexenhanh/api-client";

import { apiRequest } from "../auth/api-client";

type Schemas = components["schemas"];

export type StopPoint = Schemas["OperatorStopPointResponseDto_Output"];
export type StopPointPage = Schemas["OperatorStopPointListResponseDto_Output"];
export type StopPointInput = Schemas["OperatorStopPointInputDto"];
export type StopPointStatus = StopPoint["status"];
export type StopPointType = StopPoint["type"];
export type SharedStopPointPage = Schemas["StopPointListResponseDto_Output"];
export type SharedStopPoint = SharedStopPointPage["items"][number];
export type StopPointProposal = Schemas["StopPointProposalResponseDto_Output"];
export type StopPointProposalPage = Schemas["StopPointProposalListResponseDto_Output"];
export type StopPointProposalInput = Schemas["StopPointProposalInputDto"];
export type StopPointProposalStatus = StopPointProposal["status"];
export type Province = Schemas["ProvinceListResponseDto_Output"]["items"][number];
export type Ward = Schemas["WardListResponseDto_Output"]["items"][number];

/** Số dòng mỗi lần tải danh sách điểm dừng / đề xuất (mặc định của API). */
export const STOP_POINT_PAGE_SIZE = 20;

/** Bộ lọc chung của hai danh sách điểm dừng; ô tìm `q` khớp tên hoặc địa chỉ, không phân biệt dấu. */
export type StopPointFilters = { q?: string; type?: StopPointType; provinceId?: string };

function listQuery(params: Record<string, string | undefined>): URLSearchParams {
  const query = new URLSearchParams({ limit: String(STOP_POINT_PAGE_SIZE) });
  for (const [key, value] of Object.entries(params)) {
    if (value) {
      query.set(key, value);
    }
  }
  return query;
}

/** Một trang điểm dừng riêng của nhà xe; `cursor` là `nextCursor` của trang trước. */
export function listStopPoints(
  params: StopPointFilters & { status?: StopPointStatus; cursor?: string }
): Promise<StopPointPage> {
  return apiRequest<StopPointPage>(`/operator/stop-points?${listQuery(params)}`);
}

/** Tạo điểm dừng riêng (văn phòng trung chuyển hoặc trạm dừng nghỉ). */
export function createStopPoint(input: StopPointInput): Promise<StopPoint> {
  return apiRequest<StopPoint>("/operator/stop-points", { method: "POST", body: input });
}

/** Thay toàn bộ thông tin một điểm dừng riêng (PUT gửi đủ mọi trường). */
export function updateStopPoint(stopPointId: string, input: StopPointInput): Promise<StopPoint> {
  return apiRequest<StopPoint>(`/operator/stop-points/${stopPointId}`, { method: "PUT", body: input });
}

/** Một trang điểm dừng dùng chung đang hoạt động trong danh mục Platform (công khai). */
export function listSharedStopPoints(params: StopPointFilters & { cursor?: string }): Promise<SharedStopPointPage> {
  return apiRequest<SharedStopPointPage>(`/catalog/stop-points?${listQuery(params)}`);
}

/** Một trang đề xuất của nhà xe gửi Platform. */
export function listStopPointProposals(params: {
  status?: StopPointProposalStatus;
  cursor?: string;
}): Promise<StopPointProposalPage> {
  return apiRequest<StopPointProposalPage>(`/operator/stop-point-proposals?${listQuery(params)}`);
}

/** Gửi đề xuất mới (chờ Platform duyệt). */
export function createStopPointProposal(input: StopPointProposalInput): Promise<StopPointProposal> {
  return apiRequest<StopPointProposal>("/operator/stop-point-proposals", { method: "POST", body: input });
}

/** Sửa và gửi lại một đề xuất đã bị từ chối. */
export function resubmitStopPointProposal(
  proposalId: string,
  input: StopPointProposalInput
): Promise<StopPointProposal> {
  return apiRequest<StopPointProposal>(`/operator/stop-point-proposals/${proposalId}`, { method: "PUT", body: input });
}

/** Tỉnh / thành đang dùng được trong danh mục Platform (công khai). */
export async function listProvinces(): Promise<Province[]> {
  return (await apiRequest<{ items: Province[] }>("/catalog/provinces")).items;
}

/** Phường / xã đang dùng được của một tỉnh / thành (công khai). */
export async function listWards(provinceId: string): Promise<Ward[]> {
  return (await apiRequest<{ items: Ward[] }>(`/catalog/wards?provinceId=${provinceId}`)).items;
}
