// Gọi API Tài chính cho Operator OS (05 API §7.3 `/operator/finance/*`, `/operator/payouts*`, TASK-OPR-002). Kiểu lấy từ client sinh.
import type { components } from "@vexenhanh/api-client";

import { apiRequest } from "../auth/api-client";

type Schemas = components["schemas"];

export type FinanceSummary = Schemas["FinanceSummaryDto_Output"];
export type FinanceBookingPage = Schemas["FinanceBookingPageDto_Output"];
export type FinanceBooking = FinanceBookingPage["items"][number];
export type FinanceState = FinanceBooking["state"];
export type PayoutPage = Schemas["PayoutPageDto_Output"];
export type PayoutSummary = PayoutPage["items"][number];
export type PayoutDetail = Schemas["PayoutDetailDto_Output"];
export type PayoutStatus = PayoutSummary["status"];

/** Số dòng mỗi lần tải (Figma "Tải thêm"). */
export const FINANCE_PAGE_SIZE = 20;

export function getFinanceSummary(): Promise<FinanceSummary> {
  return apiRequest<FinanceSummary>("/operator/finance/summary");
}

export type FinanceBookingParams = { from: string; to: string; routeId?: string; state?: FinanceState; q?: string; cursor?: string };

/** Giao dịch theo đơn của các chuyến khởi hành trong khoảng ngày (giờ VN), chuyến mới trước. */
export function listFinanceBookings(params: FinanceBookingParams): Promise<FinanceBookingPage> {
  return apiRequest<FinanceBookingPage>(`/operator/finance/bookings?${query(params)}`);
}

export type PayoutListParams = { month?: string; status?: PayoutStatus; cursor?: string };

export function listPayouts(params: PayoutListParams): Promise<PayoutPage> {
  return apiRequest<PayoutPage>(`/operator/payouts?${query(params)}`);
}

export function getPayout(payoutId: string): Promise<PayoutDetail> {
  return apiRequest<PayoutDetail>(`/operator/payouts/${payoutId}`);
}

function query(params: Record<string, string | undefined>): URLSearchParams {
  const search = new URLSearchParams({ limit: String(FINANCE_PAGE_SIZE) });
  for (const [key, value] of Object.entries(params)) {
    if (value) {
      search.set(key, value);
    }
  }
  return search;
}
