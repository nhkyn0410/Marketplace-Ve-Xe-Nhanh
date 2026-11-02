// Gọi API chính sách nền tảng, hoa hồng và khung giá (05 API §7.5; TASK-ADM-001 phần chính sách). Kiểu lấy từ client
// sinh tự OpenAPI. Kích hoạt / hủy / thay đổi hoa hồng / khung giá cần xác nhận lại danh tính (`withReauth`).
import type { components } from "@vexenhanh/api-client";
import { apiRequest } from "@vexenhanh/ui/lib/auth/api-client";
import type { CounterCommissionOverview, CounterCommissionSettlement, CounterCommissionSettlementInput } from "@vexenhanh/types";

type Schemas = components["schemas"];

export type PolicyOverview = Schemas["PolicyOverviewDto_Output"];
export type PolicyVersion = Schemas["PolicyVersionDto_Output"];
export type PolicyType = PolicyVersion["type"];
export type PolicyState = PolicyVersion["state"];
export type PolicyDraftCreate = Schemas["PolicyDraftCreateDto"];
export type PolicyDraftUpdate = Schemas["PolicyDraftUpdateDto"];
export type FareBand = Schemas["FareBandDto_Output"];
export type FareBandInput = Schemas["FareBandCreateDto"];
export type CommissionOverview = Schemas["CommissionOverviewDto_Output"];
export type CommissionRule = Schemas["CommissionRuleDto_Output"];
export type CommissionRuleCreate = Schemas["CommissionRuleCreateDto"];
export type CommissionRuleUpdate = Schemas["CommissionRuleUpdateDto"];

export function getPolicyOverview(type: PolicyType, operatorId: string | null): Promise<PolicyOverview> {
  return apiRequest<PolicyOverview>(`/admin/policies/${type}${operatorId ? `?operatorId=${operatorId}` : ""}`);
}

export function createPolicyDraft(type: PolicyType, input: PolicyDraftCreate): Promise<PolicyVersion> {
  return apiRequest<PolicyVersion>(`/admin/policies/${type}/versions`, { method: "POST", body: input });
}

export function getPolicyVersion(id: string): Promise<PolicyVersion> {
  return apiRequest<PolicyVersion>(`/admin/policy-versions/${id}`);
}

export function updatePolicyDraft(id: string, input: PolicyDraftUpdate): Promise<PolicyVersion> {
  return apiRequest<PolicyVersion>(`/admin/policy-versions/${id}`, { method: "PUT", body: input });
}

export function publishPolicyVersion(id: string, changeReason: string): Promise<PolicyVersion> {
  return apiRequest<PolicyVersion>(`/admin/policy-versions/${id}/publish`, { method: "POST", body: { changeReason } });
}

export function cancelPolicyVersion(id: string, reason: string): Promise<PolicyVersion> {
  return apiRequest<PolicyVersion>(`/admin/policy-versions/${id}/cancel`, { method: "POST", body: { reason } });
}

export async function listFareBands(): Promise<FareBand[]> {
  return (await apiRequest<{ items: FareBand[] }>("/admin/fare-bands")).items;
}

export function createFareBand(input: FareBandInput): Promise<FareBand> {
  return apiRequest<FareBand>("/admin/fare-bands", { method: "POST", body: input });
}

export function cancelFareBand(id: string, reason: string): Promise<FareBand> {
  return apiRequest<FareBand>(`/admin/fare-bands/${id}/cancel`, { method: "POST", body: { reason } });
}

export function getCommission(): Promise<CommissionOverview> {
  return apiRequest<CommissionOverview>("/admin/commission-rules");
}

export function createCommissionRule(input: CommissionRuleCreate): Promise<CommissionRule> {
  return apiRequest<CommissionRule>("/admin/commission-rules", { method: "POST", body: input });
}

export function updateCommissionRule(id: string, input: CommissionRuleUpdate): Promise<CommissionRule> {
  return apiRequest<CommissionRule>(`/admin/commission-rules/${id}`, { method: "PUT", body: input });
}

export function cancelCommissionRule(id: string, reason: string): Promise<CommissionRule> {
  return apiRequest<CommissionRule>(`/admin/commission-rules/${id}/cancel`, { method: "POST", body: { reason } });
}

/** Số phí quầy phải thu và các khoản thu đã ghi nhận của một nhà xe. */
export function getCounterCommission(operatorId: string): Promise<CounterCommissionOverview> {
  return apiRequest<CounterCommissionOverview>(`/admin/counter-commissions?${new URLSearchParams({ operatorId })}`);
}

/** Xác nhận Platform đã thu phí quầy thủ công, giữ khóa chống lặp khi thử lại. */
export function settleCounterCommission(input: CounterCommissionSettlementInput): Promise<CounterCommissionSettlement> {
  return apiRequest<CounterCommissionSettlement>("/admin/counter-commissions/settlements", { method: "POST", body: input });
}

export type OperatorOption = { id: string; name: string; slug: string };

/** Nhà xe cho ô chọn phạm vi / mức riêng (tối đa 50, mới duyệt trước; tìm theo tên hoặc mã). */
export async function listOperatorOptions(q: string): Promise<OperatorOption[]> {
  const query = new URLSearchParams({ limit: "50" });
  if (q.trim()) {
    query.set("q", q.trim());
  }
  const page = await apiRequest<Schemas["AdminOperatorPageDto_Output"]>(`/admin/operators?${query}`);
  return page.items.map((item) => ({ id: item.id, name: item.name, slug: item.slug }));
}
