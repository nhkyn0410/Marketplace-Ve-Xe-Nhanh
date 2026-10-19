// Gọi API Khiếu nại / Tranh chấp / Đánh giá cho Admin (`/admin/support-tickets*`, `/admin/disputes*`, `/admin/reviews*`; TASK-TRUST-001).
// Kiểu lấy từ client sinh.
import type { components } from "@vexenhanh/api-client";
import { apiRequest } from "@vexenhanh/ui/lib/auth/api-client";

type Schemas = components["schemas"];

export type TicketPage = Schemas["TicketPageDto_Output"];
export type TicketSummary = TicketPage["items"][number];
export type TicketDetail = Schemas["TicketDetailDto_Output"];
export type TicketMessage = TicketDetail["messages"][number];
export type Attachment = TicketMessage["attachments"][number];
export type SupportStatus = TicketSummary["status"];
export type SupportCategory = TicketSummary["category"];
export type SupportPriority = TicketSummary["priority"];
export type SupportHandler = TicketSummary["handler"];
export type CaseParty = TicketSummary["reporterParty"];
export type Assignee = Schemas["AssigneeListDto_Output"]["items"][number];
export type DisputePage = Schemas["DisputePageDto_Output"];
export type DisputeSummary = DisputePage["items"][number];
export type DisputeDetail = Schemas["DisputeDetailDto_Output"];
export type DisputeEvent = DisputeDetail["events"][number];
export type DisputeStatus = DisputeSummary["status"];
export type DisputeDecision = NonNullable<DisputeDetail["decision"]>["decision"];
export type ReviewPage = Schemas["ReviewPageDto_Output"];
export type Review = ReviewPage["items"][number];
export type ReviewStatus = Review["status"];
export type ReviewSignal = Review["signals"][number];
export type AttachmentInput = { objectKey: string; fileName: string };

/** Số dòng mỗi lần tải (Figma "Tải thêm"). */
export const PAGE_SIZE = 20;

function query(params: Record<string, string | number | undefined | null>): string {
  const search = new URLSearchParams({ limit: String(PAGE_SIZE) });
  for (const [key, value] of Object.entries(params)) {
    if (value !== undefined && value !== null && value !== "") {
      search.set(key, String(value));
    }
  }
  return search.toString();
}

// ---------- Khiếu nại ----------

export type TicketListParams = { status?: SupportStatus; category?: SupportCategory; operatorId?: string; assigneeId?: string; q?: string; cursor?: string };

export function listTickets(params: TicketListParams): Promise<TicketPage> {
  return apiRequest<TicketPage>(`/admin/support-tickets?${query(params)}`);
}

export function getTicket(ticketId: string): Promise<TicketDetail> {
  return apiRequest<TicketDetail>(`/admin/support-tickets/${ticketId}`);
}

export function listAssignees(): Promise<Assignee[]> {
  return apiRequest<{ items: Assignee[] }>("/admin/support-assignees").then((result) => result.items);
}

export function classifyTicket(ticketId: string, input: { category: SupportCategory; priority: SupportPriority; handler: SupportHandler; assigneeId: string | null }): Promise<TicketDetail> {
  return apiRequest<TicketDetail>(`/admin/support-tickets/${ticketId}`, { method: "PATCH", body: input });
}

export function replyTicket(ticketId: string, input: { body: string; attachments: AttachmentInput[]; requestInfo: boolean }): Promise<TicketDetail> {
  return apiRequest<TicketDetail>(`/admin/support-tickets/${ticketId}/messages`, { method: "POST", body: input });
}

export function setTicketStatus(ticketId: string, input: { status: "RESOLVED" | "CLOSED"; note: string | null }): Promise<TicketDetail> {
  return apiRequest<TicketDetail>(`/admin/support-tickets/${ticketId}/status`, { method: "POST", body: input });
}

export function escalateTicket(ticketId: string, input: { title: string | null; customerRequest: string | null; reason: string }): Promise<DisputeDetail> {
  return apiRequest<DisputeDetail>(`/admin/support-tickets/${ticketId}/escalate`, { method: "POST", body: input });
}

// ---------- Tranh chấp ----------

export type DisputeListParams = { status?: DisputeStatus | "open"; operatorId?: string; due?: "overdue" | "upcoming"; assigneeId?: string; q?: string; cursor?: string };

/** Mở tranh chấp trực tiếp từ đơn của giao dịch thanh toán. */
export function openBookingDispute(input: { bookingId: string; title: string; customerRequest: string | null; reason: string }): Promise<DisputeDetail> {
  return apiRequest<DisputeDetail>("/admin/disputes", { method: "POST", body: input });
}

export function listDisputes(params: DisputeListParams): Promise<DisputePage> {
  return apiRequest<DisputePage>(`/admin/disputes?${query(params)}`);
}

export function getDispute(disputeId: string): Promise<DisputeDetail> {
  return apiRequest<DisputeDetail>(`/admin/disputes/${disputeId}`);
}

export function requestEvidence(disputeId: string, input: { party: "PASSENGER" | "OPERATOR"; message: string; dueAt: string }): Promise<DisputeDetail> {
  return apiRequest<DisputeDetail>(`/admin/disputes/${disputeId}/evidence-requests`, { method: "POST", body: input });
}

export function setDisputeStatus(disputeId: string, input: { status: "UNDER_REVIEW" | "ESCALATED" | "CLOSED"; reason: string }): Promise<DisputeDetail> {
  return apiRequest<DisputeDetail>(`/admin/disputes/${disputeId}/status`, { method: "POST", body: input });
}

export function decideDispute(disputeId: string, input: { decision: DisputeDecision; amount: number | null; reason: string }): Promise<DisputeDetail> {
  return apiRequest<DisputeDetail>(`/admin/disputes/${disputeId}/decision`, { method: "POST", body: input });
}

// ---------- Tệp minh chứng ----------

/** Tải một tệp minh chứng cho khiếu nại / tranh chấp: xin URL, `PUT` thẳng lên kho riêng tư, trả khóa để gửi kèm. */
export async function uploadAttachment(target: { ticketId: string } | { disputeId: string }, file: File): Promise<AttachmentInput> {
  const path = "ticketId" in target ? `/admin/support-tickets/${target.ticketId}` : `/admin/disputes/${target.disputeId}`;
  const grant = await apiRequest<{ uploadUrl: string; objectKey: string }>(`${path}/attachments/upload-url`, { method: "POST", body: { contentType: file.type, sizeBytes: file.size } });
  const response = await fetch(grant.uploadUrl, { method: "PUT", headers: { "Content-Type": file.type }, body: file, credentials: "omit" });
  if (!response.ok) {
    throw new Error(`Tải tệp lên kho thất bại (${response.status}).`);
  }
  return { objectKey: grant.objectKey, fileName: file.name };
}

/** URL xem tệp (hạn 5 phút; mỗi lần mở được ghi nhật ký). */
export async function attachmentUrl(attachmentId: string): Promise<string> {
  return (await apiRequest<{ url: string }>(`/admin/support-attachments/${attachmentId}/download-url`, { method: "POST" })).url;
}

// ---------- Đánh giá ----------

export type ReviewListParams = { status?: ReviewStatus | "attention"; operatorId?: string; rating?: number; q?: string; cursor?: string };

export function listReviews(params: ReviewListParams): Promise<ReviewPage> {
  return apiRequest<ReviewPage>(`/admin/reviews?${query(params)}`);
}

export function moderateReview(reviewId: string, input: { action: "HOLD" | "HIDE" | "SHOW"; reason: string | null }): Promise<Review> {
  return apiRequest<Review>(`/admin/reviews/${reviewId}/moderation`, { method: "POST", body: input });
}
