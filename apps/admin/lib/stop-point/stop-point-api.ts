// Gọi API quản lý điểm dừng cho cổng Admin (05 API §7.5; TASK-ADM-004). Kiểu lấy từ client sinh tự OpenAPI.
import type { components } from "@vexenhanh/api-client";
import { apiRequest } from "@vexenhanh/ui/lib/auth/api-client";

type Schemas = components["schemas"];

export type SharedStopPoint = Schemas["AdminSharedStopPointDto_Output"];
export type SharedStopPointPage = Schemas["AdminSharedStopPointListDto_Output"];
export type SharedStopPointInput = Schemas["AdminSharedStopPointInputDto"];
export type Proposal = Schemas["AdminStopPointProposalDto_Output"];
export type ProposalPage = Schemas["AdminStopPointProposalListDto_Output"];
export type ProposalApprovalInput = Schemas["AdminStopPointProposalApprovalDto"];
export type OperatorStopPoint = Schemas["AdminOperatorStopPointDto_Output"];
export type OperatorStopPointPage = Schemas["AdminOperatorStopPointListDto_Output"];
export type StopPointType = OperatorStopPoint["type"];
export type SharedStatus = SharedStopPoint["status"];
export type OperatorStopPointStatus = OperatorStopPoint["status"];
export type ProposalStatus = Proposal["status"];
export type Province = Schemas["ProvinceListResponseDto_Output"]["items"][number];
export type Ward = Schemas["WardListResponseDto_Output"]["items"][number];

export const PAGE_SIZE = 20;

function query(params: Record<string, string | undefined | null>): string {
  const search = new URLSearchParams({ limit: String(PAGE_SIZE) });
  for (const [key, value] of Object.entries(params)) {
    if (value) {
      search.set(key, value);
    }
  }
  return search.toString();
}

export type SharedFilters = { q?: string; type?: string; provinceId?: string; status?: string };

export function listSharedStopPoints(filters: SharedFilters, cursor: string | null): Promise<SharedStopPointPage> {
  return apiRequest<SharedStopPointPage>(`/admin/stop-points?${query({ ...filters, cursor })}`);
}

export function createSharedStopPoint(input: SharedStopPointInput): Promise<SharedStopPoint> {
  return apiRequest<SharedStopPoint>("/admin/stop-points", { method: "POST", body: input });
}

export function updateSharedStopPoint(id: string, input: SharedStopPointInput): Promise<SharedStopPoint> {
  return apiRequest<SharedStopPoint>(`/admin/stop-points/${id}`, { method: "PUT", body: input });
}

export type ProposalFilters = { status?: string; type?: string };

export function listProposals(filters: ProposalFilters, cursor: string | null): Promise<ProposalPage> {
  return apiRequest<ProposalPage>(`/admin/stop-point-proposals?${query({ ...filters, cursor })}`);
}

export function getProposal(id: string): Promise<Proposal> {
  return apiRequest<Proposal>(`/admin/stop-point-proposals/${id}`);
}

export function approveProposal(id: string, input: ProposalApprovalInput): Promise<Proposal> {
  return apiRequest<Proposal>(`/admin/stop-point-proposals/${id}/approve`, { method: "POST", body: input });
}

export function rejectProposal(id: string, reason: string): Promise<Proposal> {
  return apiRequest<Proposal>(`/admin/stop-point-proposals/${id}/reject`, { method: "POST", body: { reason } });
}

export type OperatorPointFilters = { q?: string; type?: string; provinceId?: string; status?: string };

export function listOperatorStopPoints(
  filters: OperatorPointFilters,
  cursor: string | null
): Promise<OperatorStopPointPage> {
  return apiRequest<OperatorStopPointPage>(`/admin/operator-stop-points?${query({ ...filters, cursor })}`);
}

export function suspendStopPoint(id: string, reason: string): Promise<OperatorStopPoint> {
  return apiRequest<OperatorStopPoint>(`/admin/operator-stop-points/${id}/suspend`, { method: "POST", body: { reason } });
}

export function unsuspendStopPoint(id: string): Promise<OperatorStopPoint> {
  return apiRequest<OperatorStopPoint>(`/admin/operator-stop-points/${id}/unsuspend`, { method: "POST" });
}

export async function listProvinces(): Promise<Province[]> {
  return (await apiRequest<{ items: Province[] }>("/catalog/provinces")).items;
}

export async function listWards(provinceId: string): Promise<Ward[]> {
  return (await apiRequest<{ items: Ward[] }>(`/catalog/wards?provinceId=${provinceId}`)).items;
}
