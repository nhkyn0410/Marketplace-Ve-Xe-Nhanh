// Gọi API Khuyến mãi cho Operator OS (`/operator/promotions*`, `/operator/promotion-permission`; TASK-PROM-001). Kiểu lấy từ client sinh.
import type { components } from "@vexenhanh/api-client";
import type { PromotionFormValues } from "@vexenhanh/ui/components/promotion-form";

import { ApiError, apiRequest } from "../auth/api-client";

type Schemas = components["schemas"];

export type PromotionPage = Schemas["PromotionPageDto_Output"];
export type Promotion = PromotionPage["items"][number];
export type PromotionDisplay = Promotion["display"];
export type Permission = Schemas["PermissionDto_Output"];

export const PAGE_SIZE = 20;

function query(params: Record<string, string | undefined>): string {
  const search = new URLSearchParams({ limit: String(PAGE_SIZE) });
  for (const [key, value] of Object.entries(params)) {
    if (value) search.set(key, value);
  }
  return search.toString();
}

export function listPromotions(params: { scope: "OPERATOR" | "PLATFORM"; display?: PromotionDisplay; q?: string; routeId?: string; cursor?: string }): Promise<PromotionPage> {
  return apiRequest<PromotionPage>(`/operator/promotions?${query(params)}`);
}

export function getPromotion(promotionId: string): Promise<Promotion> {
  return apiRequest<Promotion>(`/operator/promotions/${promotionId}`);
}

export function getPermission(): Promise<Permission> {
  return apiRequest<Permission>("/operator/promotion-permission");
}

export function createPromotion(input: PromotionFormValues): Promise<Promotion> {
  return apiRequest<Promotion>("/operator/promotions", { method: "POST", body: input });
}

export function updatePromotion(promotionId: string, input: PromotionFormValues): Promise<Promotion> {
  return apiRequest<Promotion>(`/operator/promotions/${promotionId}`, { method: "PUT", body: input });
}

export function setPromotionStatus(promotionId: string, status: "ACTIVE" | "PAUSED" | "ENDED"): Promise<Promotion> {
  return apiRequest<Promotion>(`/operator/promotions/${promotionId}/status`, { method: "POST", body: { status } });
}

export function setParticipation(promotionId: string, joined: boolean): Promise<Promotion> {
  return apiRequest<Promotion>(`/operator/promotions/${promotionId}/participation`, { method: "PUT", body: { joined } });
}

export function describePromotionError(error: unknown): string {
  if (error instanceof ApiError) {
    if (["PROMOTION_CODE_TAKEN", "PROMOTION_STATE_INVALID", "PROMOTION_GUARDRAIL"].includes(error.code)) return error.message;
    if (error.status === 400) return "Kiểm tra lại các ô đã nhập.";
    if (error.status === 404) return "Không tìm thấy khuyến mãi. Tải lại trang.";
    if (error.status === 503) return "Chưa ghi được nhật ký nên chưa lưu. Vui lòng thử lại.";
  }
  return "Chưa lưu được. Vui lòng kiểm tra kết nối và thử lại.";
}
