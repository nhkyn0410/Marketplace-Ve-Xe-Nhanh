// Gọi API Chi trả nhà xe cho Admin (05 API §7.5 `/admin/payouts*`, TASK-BTP-006 / ADM-002). Kiểu lấy từ client sinh.
import type { components } from "@vexenhanh/api-client";

import { apiRequest } from "@vexenhanh/ui/lib/auth/api-client";

type Schemas = components["schemas"];

export type PayoutPage = Schemas["PayoutPageDto_Output"];
export type PayoutSummary = PayoutPage["items"][number];
export type PayoutDetail = Schemas["PayoutDetailDto_Output"];
export type PayoutStats = Schemas["AdminPayoutStatsDto_Output"];
export type PayoutBankAccount = Schemas["PayoutBankAccountDto_Output"];
export type PayoutStatus = PayoutSummary["status"];

/** Số kỳ mỗi lần tải (Figma "Tải thêm"). */
export const PAYOUT_PAGE_SIZE = 20;

export type PayoutListParams = { period?: string; status?: PayoutStatus; q?: string; cursor?: string };

export function listPayouts(params: PayoutListParams): Promise<PayoutPage> {
  const query = new URLSearchParams({ limit: String(PAYOUT_PAGE_SIZE) });
  for (const [key, value] of Object.entries(params)) {
    if (value) {
      query.set(key, value);
    }
  }
  return apiRequest<PayoutPage>(`/admin/payouts?${query}`);
}

export function getPayoutStats(): Promise<PayoutStats> {
  return apiRequest<PayoutStats>("/admin/payouts/stats");
}

export function getPayout(payoutId: string): Promise<PayoutDetail> {
  return apiRequest<PayoutDetail>(`/admin/payouts/${payoutId}`);
}

export function reviewPayout(payoutId: string): Promise<PayoutDetail> {
  return apiRequest<PayoutDetail>(`/admin/payouts/${payoutId}/review`, { method: "POST" });
}

export function holdPayout(payoutId: string, reason: string): Promise<PayoutDetail> {
  return apiRequest<PayoutDetail>(`/admin/payouts/${payoutId}/hold`, { method: "POST", body: { reason } });
}

export function releasePayout(payoutId: string): Promise<PayoutDetail> {
  return apiRequest<PayoutDetail>(`/admin/payouts/${payoutId}/release`, { method: "POST" });
}

export function cancelPayout(payoutId: string, reason: string): Promise<PayoutDetail> {
  return apiRequest<PayoutDetail>(`/admin/payouts/${payoutId}/cancel`, { method: "POST", body: { reason } });
}

export type PayoutConfirmInput = { bankReference: string; transferredAt: string; note: string };

/** Đã chuyển khoản — cần xác nhận lại danh tính (gọi trong `withReauth`). */
export function confirmPayout(payoutId: string, input: PayoutConfirmInput): Promise<PayoutDetail> {
  return apiRequest<PayoutDetail>(`/admin/payouts/${payoutId}/confirm`, { method: "POST", body: input });
}

/** Số tài khoản đầy đủ — cần xác nhận lại danh tính, máy chủ ghi nhật ký mỗi lần. */
export function revealPayoutBank(payoutId: string): Promise<PayoutBankAccount> {
  return apiRequest<PayoutBankAccount>(`/admin/payouts/${payoutId}/bank-reveal`, { method: "POST" });
}
