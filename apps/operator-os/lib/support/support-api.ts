// Gọi API Hỗ trợ cho Operator OS (`/operator/support-tickets*`, `/operator/disputes*`, `/operator/reviews*`; TASK-TRUST-001). Kiểu
// lấy từ client sinh.
import type { components } from "@vexenhanh/api-client";

import { apiRequest } from "../auth/api-client";

type Schemas = components["schemas"];

export type TicketPage = Schemas["TicketPageDto_Output"];
export type TicketSummary = TicketPage["items"][number];
export type TicketDetail = Schemas["TicketDetailDto_Output"];
export type Attachment = TicketDetail["messages"][number]["attachments"][number];
export type SupportStatus = TicketSummary["status"];
export type SupportCategory = TicketSummary["category"];
export type CaseParty = TicketSummary["reporterParty"];
export type DisputePage = Schemas["DisputePageDto_Output"];
export type DisputeSummary = DisputePage["items"][number];
export type DisputeDetail = Schemas["DisputeDetailDto_Output"];
export type DisputeEvent = DisputeDetail["events"][number];
export type DisputeStatus = DisputeSummary["status"];
export type ReviewPage = Schemas["ReviewPageDto_Output"];
export type Review = ReviewPage["items"][number];
export type AttachmentInput = { objectKey: string; fileName: string };

export const PAGE_SIZE = 20;

function query(params: Record<string, string | number | undefined>): string {
  const search = new URLSearchParams({ limit: String(PAGE_SIZE) });
  for (const [key, value] of Object.entries(params)) {
    if (value !== undefined && value !== "") {
      search.set(key, String(value));
    }
  }
  return search.toString();
}

export function listTickets(cursor?: string): Promise<TicketPage> {
  return apiRequest<TicketPage>(`/operator/support-tickets?${query({ cursor })}`);
}

export function getTicket(ticketId: string): Promise<TicketDetail> {
  return apiRequest<TicketDetail>(`/operator/support-tickets/${ticketId}`);
}

export function replyTicket(ticketId: string, input: { body: string; attachments: AttachmentInput[] }): Promise<TicketDetail> {
  return apiRequest<TicketDetail>(`/operator/support-tickets/${ticketId}/messages`, { method: "POST", body: input });
}

export function listDisputes(cursor?: string): Promise<DisputePage> {
  return apiRequest<DisputePage>(`/operator/disputes?${query({ cursor })}`);
}

export function getDispute(disputeId: string): Promise<DisputeDetail> {
  return apiRequest<DisputeDetail>(`/operator/disputes/${disputeId}`);
}

export function respondDispute(disputeId: string, input: { body: string; attachments: AttachmentInput[] }): Promise<DisputeDetail> {
  return apiRequest<DisputeDetail>(`/operator/disputes/${disputeId}/responses`, { method: "POST", body: input });
}

export type ReviewParams = { routeId?: string; rating?: number; replied?: "yes" | "no"; cursor?: string };

export function listReviews(params: ReviewParams): Promise<ReviewPage> {
  return apiRequest<ReviewPage>(`/operator/reviews?${query(params)}`);
}

export function replyReview(reviewId: string, reply: string): Promise<Review> {
  return apiRequest<Review>(`/operator/reviews/${reviewId}/reply`, { method: "PUT", body: { reply } });
}

export function reportReview(reviewId: string, reason: string): Promise<Review> {
  return apiRequest<Review>(`/operator/reviews/${reviewId}/report`, { method: "POST", body: { reason } });
}

/** Tải một tệp minh chứng: xin URL, `PUT` thẳng lên kho riêng tư, trả khóa để gửi kèm phản hồi. */
export async function uploadAttachment(file: File): Promise<AttachmentInput> {
  const grant = await apiRequest<{ uploadUrl: string; objectKey: string }>("/operator/support-attachments/upload-url", { method: "POST", body: { contentType: file.type, sizeBytes: file.size } });
  const response = await fetch(grant.uploadUrl, { method: "PUT", headers: { "Content-Type": file.type }, body: file, credentials: "omit" });
  if (!response.ok) {
    throw new Error(`Tải tệp lên kho thất bại (${response.status}).`);
  }
  return { objectKey: grant.objectKey, fileName: file.name };
}

/** URL xem tệp (hạn 5 phút; mỗi lần mở được ghi nhật ký). */
export async function attachmentUrl(attachmentId: string): Promise<string> {
  return (await apiRequest<{ url: string }>(`/operator/support-attachments/${attachmentId}/download-url`, { method: "POST" })).url;
}
