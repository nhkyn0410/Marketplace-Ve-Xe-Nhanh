// Gọi API Thanh toán & hoàn tiền cho Admin (05 API §7.5 `/admin/payments*`, `/admin/refunds*`; TASK-ADM-002). Kiểu lấy từ
// client sinh.
import type { components } from "@vexenhanh/api-client";

import { apiRequest } from "@vexenhanh/ui/lib/auth/api-client";

type Schemas = components["schemas"];

export type PaymentPage = Schemas["AdminPaymentPageDto_Output"];
export type PaymentSummary = PaymentPage["items"][number];
export type PaymentDetail = Schemas["AdminPaymentDetailDto_Output"];
export type PaymentStatus = PaymentSummary["status"];
export type PaymentProvider = PaymentSummary["provider"];
export type RefundPage = Schemas["AdminRefundPageDto_Output"];
export type RefundSummary = RefundPage["items"][number];
export type RefundDetail = Schemas["AdminRefundDetailDto_Output"];
export type RefundStatus = RefundSummary["status"];
export type RefundSource = RefundSummary["source"];

/** Số dòng mỗi lần tải (Figma "Tải thêm"). */
export const PAGE_SIZE = 20;

function query(params: Record<string, string | undefined>): string {
  const search = new URLSearchParams({ limit: String(PAGE_SIZE) });
  for (const [key, value] of Object.entries(params)) {
    if (value) {
      search.set(key, value);
    }
  }
  return search.toString();
}

export type PaymentListParams = {
  from?: string;
  to?: string;
  provider?: PaymentProvider;
  status?: PaymentStatus;
  reconcile?: "open";
  q?: string;
  cursor?: string;
};

export function listPayments(params: PaymentListParams): Promise<PaymentPage> {
  return apiRequest<PaymentPage>(`/admin/payments?${query(params)}`);
}

export function getPayment(paymentId: string): Promise<PaymentDetail> {
  return apiRequest<PaymentDetail>(`/admin/payments/${paymentId}`);
}

export type RefundListParams = { from?: string; to?: string; source?: RefundSource; status?: RefundStatus; q?: string; cursor?: string };

export function listRefunds(params: RefundListParams): Promise<RefundPage> {
  return apiRequest<RefundPage>(`/admin/refunds?${query(params)}`);
}

export function getRefund(refundId: string): Promise<RefundDetail> {
  return apiRequest<RefundDetail>(`/admin/refunds/${refundId}`);
}

/** Gửi lại cổng một yêu cầu hoàn thất bại — cần xác nhận lại danh tính (gọi trong `withReauth`). */
export function retryRefund(refundId: string, reason: string): Promise<RefundDetail> {
  return apiRequest<RefundDetail>(`/admin/refunds/${refundId}/retry`, { method: "POST", body: { reason } });
}

/** Ghi nhận đã hoàn ngoài luồng tự động kèm mã tham chiếu — cần xác nhận lại danh tính. */
export function resolveRefund(refundId: string, input: { reference: string; reason: string }): Promise<RefundDetail> {
  return apiRequest<RefundDetail>(`/admin/refunds/${refundId}/resolve`, { method: "POST", body: input });
}

/** Hoàn toàn bộ cho thanh toán cần đối soát — cần xác nhận lại danh tính. */
export function refundPayment(paymentId: string, reason: string): Promise<RefundDetail> {
  return apiRequest<RefundDetail>(`/admin/payments/${paymentId}/refunds`, { method: "POST", body: { reason } });
}
