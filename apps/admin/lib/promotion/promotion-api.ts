// Gọi API Khuyến mãi cho Admin (`/admin/promotions*`, `/admin/promotion-permissions*`; TASK-PROM-001). Kiểu lấy từ client sinh.
import type { components } from "@vexenhanh/api-client";
import type { PromotionFormValues } from "@vexenhanh/ui/components/promotion-form";
import { ApiError, apiRequest } from "@vexenhanh/ui/lib/auth/api-client";

type Schemas = components["schemas"];

export type PromotionPage = Schemas["PromotionPageDto_Output"];
export type Promotion = PromotionPage["items"][number];
export type PromotionStats = PromotionPage["stats"];
export type PromotionDisplay = Promotion["display"];
export type PermissionPage = Schemas["PermissionPageDto_Output"];
export type Permission = PermissionPage["items"][number];
export type PermissionInput = { enabled: boolean; maxPercent: number | null; maxAmount: number | null; routeIds: string[]; maxDurationDays: number; monthlyBudget: number | null };

export const PAGE_SIZE = 20;

function query(params: Record<string, string | undefined>): string {
  const search = new URLSearchParams({ limit: String(PAGE_SIZE) });
  for (const [key, value] of Object.entries(params)) {
    if (value) search.set(key, value);
  }
  return search.toString();
}

export function listPromotions(params: { scope: "PLATFORM" | "OPERATOR"; display?: PromotionDisplay; q?: string; operatorId?: string; cursor?: string }): Promise<PromotionPage> {
  return apiRequest<PromotionPage>(`/admin/promotions?${query(params)}`);
}

export function getPromotion(promotionId: string): Promise<Promotion> {
  return apiRequest<Promotion>(`/admin/promotions/${promotionId}`);
}

export function createPromotion(input: PromotionFormValues): Promise<Promotion> {
  return apiRequest<Promotion>("/admin/promotions", { method: "POST", body: { ...input, routeId: null, tripId: null } });
}

export function updatePromotion(promotionId: string, input: PromotionFormValues): Promise<Promotion> {
  return apiRequest<Promotion>(`/admin/promotions/${promotionId}`, { method: "PUT", body: { ...input, routeId: null, tripId: null } });
}

export function setPromotionStatus(promotionId: string, status: "ACTIVE" | "PAUSED" | "ENDED"): Promise<Promotion> {
  return apiRequest<Promotion>(`/admin/promotions/${promotionId}/status`, { method: "POST", body: { status } });
}

export function listPermissions(params: { q?: string; enabled?: "yes" | "no"; cursor?: string }): Promise<PermissionPage> {
  return apiRequest<PermissionPage>(`/admin/promotion-permissions?${query(params)}`);
}

export function savePermission(operatorId: string, input: PermissionInput): Promise<Permission> {
  return apiRequest<Permission>(`/admin/promotion-permissions/${operatorId}`, { method: "PUT", body: input });
}

/** Câu lỗi cho thao tác khuyến mãi. */
export function describePromotionError(error: unknown): string {
  if (error instanceof ApiError) {
    if (["PROMOTION_CODE_TAKEN", "PROMOTION_STATE_INVALID", "PROMOTION_GUARDRAIL"].includes(error.code)) return error.message;
    if (error.status === 400) return "Kiểm tra lại các ô đã nhập.";
    if (error.status === 404) return "Không tìm thấy khuyến mãi. Tải lại trang.";
    if (error.status === 503) return "Chưa ghi được nhật ký nên chưa lưu. Vui lòng thử lại.";
  }
  return "Chưa lưu được. Vui lòng kiểm tra kết nối và thử lại.";
}
