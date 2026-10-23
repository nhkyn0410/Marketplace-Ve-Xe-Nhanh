"use server";

import type { components } from "@vexenhanh/api-client";
import { z } from "zod";
import { apiRequest } from "./api";
import { bookingHeaders } from "./booking-access";
import { failed, ok, type DataResult } from "./result";
import { refreshSessionIfNeeded } from "./session";
import { mapSupportDetail, mapSupportList, type SupportAttachment, type SupportData, type SupportDetailData } from "./support-mappers";
import type { GuestComplaintFormData, NewComplaintPayload } from "./types";

type Schemas = components["schemas"];
const uuid = z.uuid();

async function listMySupport(): Promise<DataResult<Schemas["PassengerSupportPageDto_Output"]["items"]>> {
  const items: Schemas["PassengerSupportPageDto_Output"]["items"] = [];
  let cursor: string | null = null;
  do {
    const params: URLSearchParams = new URLSearchParams({ limit: "100", ...(cursor ? { cursor } : {}) });
    const result: DataResult<Schemas["PassengerSupportPageDto_Output"]> = await apiRequest<Schemas["PassengerSupportPageDto_Output"]>(`/me/support-tickets?${params}`);
    if (result.status !== "ok") return result;
    items.push(...result.data.items);
    const next: string | null = result.data.nextCursor;
    if (cursor === next) break;
    cursor = next;
  } while (cursor);
  return ok(items);
}

async function bookingIdForCode(code: string): Promise<DataResult<string>> {
  let cursor: string | null = null;
  do {
    const params: URLSearchParams = new URLSearchParams({ limit: "100", ...(cursor ? { cursor } : {}) });
    const result: DataResult<Schemas["PassengerBookingPageDto_Output"]> = await apiRequest<Schemas["PassengerBookingPageDto_Output"]>(`/me/bookings?${params}`);
    if (result.status !== "ok") return result;
    const booking = result.data.items.find((item) => item.bookingCode === code.trim());
    if (booking) return ok(booking.bookingId);
    const next: string | null = result.data.nextCursor;
    if (cursor === next) break;
    cursor = next;
  } while (cursor);
  return failed("GET /me/bookings", "Không tìm thấy mã đơn trong tài khoản của bạn.");
}

async function supportBookingId(complaintId: string, guestBookingId?: string): Promise<DataResult<string>> {
  if (!uuid.safeParse(complaintId).success) return failed("GET /me/support-tickets", "Mã yêu cầu không hợp lệ.");
  if (guestBookingId) {
    if (!uuid.safeParse(guestBookingId).success) return failed("GET /bookings", "Mã đơn không hợp lệ.");
    const headers = await bookingHeaders(guestBookingId);
    return headers["X-Booking-Token"] ? ok(guestBookingId) : failed("GET /bookings", "Không còn quyền truy cập đơn vé trên trình duyệt này.");
  }
  const list = await listMySupport();
  if (list.status !== "ok") return list;
  const item = list.data.find((entry) => entry.ticketId === complaintId);
  return item ? ok(item.bookingId) : failed("GET /me/support-tickets", "Không tìm thấy yêu cầu trong tài khoản của bạn.");
}

/** Lấy danh sách hỗ trợ của hành khách và chi tiết đầu tiên nếu có. */
export async function getMyComplaints(): Promise<DataResult<SupportData>> {
  const result = await listMySupport();
  if (result.status !== "ok") return result;
  const items = result.data.map(mapSupportList);
  const first = result.data[0];
  const detail = first ? await apiRequest<Schemas["TicketDetailDto_Output"]>(`/bookings/${first.bookingId}/support-tickets/${first.ticketId}`) : null;
  if (detail && detail.status !== "ok") return detail;
  return ok({ activeComplaints: items.filter((item) => item.status !== "closed" && item.status !== "resolved"),
    closedComplaints: items.filter((item) => item.status === "closed" || item.status === "resolved"),
    selectedComplaint: detail?.status === "ok" ? mapSupportDetail(detail.data) : null });
}

/** Đọc chi tiết bằng bookingId thuộc tài khoản hoặc quyền truy cập khách vãng lai. */
export async function getComplaintDetail(complaintId: string, guestBookingId?: string): Promise<DataResult<SupportDetailData>> {
  const booking = await supportBookingId(complaintId, guestBookingId);
  if (booking.status !== "ok") return booking;
  const result = await apiRequest<Schemas["TicketDetailDto_Output"]>(`/bookings/${booking.data}/support-tickets/${complaintId}`, { headers: await bookingHeaders(booking.data) });
  return result.status === "ok" ? ok(mapSupportDetail(result.data)) : result;
}

/** Gửi yêu cầu mới với danh mục, mức độ và các tệp đã tải lên kho riêng tư. */
export async function submitComplaint(payload: NewComplaintPayload, attachments: readonly SupportAttachment[] = [], guestBookingId?: string): Promise<DataResult<{ readonly complaintId: string; readonly code: string }>> {
  const session = await refreshSessionIfNeeded();
  if (session.status !== "ok") return session;
  const categories: Record<string, Schemas["CustomerTicketInputDto"]["category"]> = { "Thanh toán / hoàn tiền": "PAYMENT_REFUND", "Lịch trình": "SCHEDULE", "Chất lượng dịch vụ": "SERVICE_QUALITY", "Đổi vé": "TICKET_CHANGE", "Khác": "OTHER" };
  const priorities: Record<string, Schemas["CustomerTicketInputDto"]["priority"]> = { "Thấp": "LOW", "Trung bình": "MEDIUM", "Cao": "HIGH", "Khẩn cấp": "URGENT" };
  const input = z.object({ subject: z.string().trim().min(3).max(200), body: z.string().trim().min(1).max(2000), category: z.string() }).safeParse({ subject: payload.title, body: payload.content, category: payload.category });
  if (!input.success || !categories[payload.category]) return failed("POST /bookings/support-tickets", "Vui lòng kiểm tra tiêu đề, nội dung và danh mục.");
  if (payload.attachmentFileNames?.length && !attachments.length) return failed("POST /bookings/support-tickets", "Tệp đính kèm cần được tải lên trước khi gửi.");
  const booking = guestBookingId ? await guestBooking(guestBookingId) : await bookingIdForCode(payload.bookingCode);
  if (booking.status !== "ok") return booking;
  const body: Schemas["CustomerTicketInputDto"] = { category: categories[payload.category]!, priority: priorities[payload.suggestedSeverity ?? ""] ?? "MEDIUM", subject: input.data.subject, body: input.data.body, attachments: [...attachments] };
  const result = await apiRequest<Schemas["TicketDetailDto_Output"]>(`/bookings/${booking.data}/support-tickets`, { method: "POST", headers: await bookingHeaders(booking.data), body: JSON.stringify(body) });
  return result.status === "ok" ? ok({ complaintId: result.data.ticketId, code: result.data.ticketCode }) : result;
}

/** Gửi phản hồi và trả lại chi tiết mới nhất để cập nhật lịch sử trao đổi. */
export async function replyComplaint(complaintId: string, content: string, attachments: readonly SupportAttachment[] = [], guestBookingId?: string): Promise<DataResult<SupportDetailData>> {
  const session = await refreshSessionIfNeeded();
  if (session.status !== "ok") return session;
  if (!content.trim() || content.trim().length > 2000) return failed("POST /bookings/support-tickets/messages", "Nội dung cần từ 1 đến 2.000 ký tự.");
  const booking = await supportBookingId(complaintId, guestBookingId);
  if (booking.status !== "ok") return booking;
  const body: Schemas["MessageInputDto"] = { body: content.trim(), attachments: [...attachments] };
  const result = await apiRequest<Schemas["TicketDetailDto_Output"]>(`/bookings/${booking.data}/support-tickets/${complaintId}/messages`, { method: "POST", headers: await bookingHeaders(booking.data), body: JSON.stringify(body) });
  return result.status === "ok" ? ok(mapSupportDetail(result.data)) : result;
}

async function guestBooking(bookingId: string): Promise<DataResult<string>> {
  if (!uuid.safeParse(bookingId).success) return failed("GET /bookings", "Cần mã đơn hợp lệ để mở hỗ trợ.");
  return (await bookingHeaders(bookingId))["X-Booking-Token"] ? ok(bookingId) : failed("GET /bookings", "Cần quyền truy cập đơn vé đã lưu trên trình duyệt này; email không đủ để xác minh.");
}

/** Lấy hỗ trợ khách vãng lai bằng cookie X-Booking-Token của đúng đơn. */
export async function getGuestComplaints(bookingId?: string): Promise<DataResult<SupportData>> {
  const booking = await guestBooking(bookingId ?? "");
  if (booking.status !== "ok") return booking;
  const headers = await bookingHeaders(booking.data);
  const result = await apiRequest<Schemas["CustomerTicketListDto_Output"]>(`/bookings/${booking.data}/support-tickets`, { headers });
  if (result.status !== "ok") return result;
  const items = result.data.items.map((item) => mapSupportList({ ...item, updatedAt: item.lastMessageAt }));
  const first = result.data.items[0];
  const detail = first ? await apiRequest<Schemas["TicketDetailDto_Output"]>(`/bookings/${booking.data}/support-tickets/${first.ticketId}`, { headers }) : null;
  if (detail && detail.status !== "ok") return detail;
  return ok({ activeComplaints: items.filter((item) => item.status !== "closed" && item.status !== "resolved"),
    closedComplaints: items.filter((item) => item.status === "closed" || item.status === "resolved"), selectedComplaint: detail?.status === "ok" ? mapSupportDetail(detail.data) : null });
}

/** Khách vãng lai gửi hỗ trợ với quyền truy cập của đơn, không xác minh chỉ bằng email. */
export async function submitGuestComplaint(payload: GuestComplaintFormData, bookingId?: string, attachments: readonly SupportAttachment[] = []): Promise<DataResult<{ readonly complaintId: string; readonly code: string }>> {
  if (!bookingId) return failed("POST /bookings/support-tickets", "Cần quyền truy cập đơn vé để gửi hỗ trợ.");
  return submitComplaint(payload, attachments, bookingId);
}

/** Xin URL tải tệp cho đúng đơn; trình duyệt PUT tệp trực tiếp lên kho riêng tư. */
export async function getSupportUploadUrl(bookingCode: string, contentType: string, sizeBytes: number, guestBookingId?: string): Promise<DataResult<Schemas["AttachmentUploadResponseDto_Output"]>> {
  const session = await refreshSessionIfNeeded();
  if (session.status !== "ok") return session;
  if (!["image/jpeg", "image/png", "application/pdf"].includes(contentType) || sizeBytes < 1 || sizeBytes > 10 * 1024 * 1024) return failed("POST /bookings/support-attachments/upload-url", "Chỉ hỗ trợ JPEG, PNG, PDF tối đa 10 MB.");
  const booking = guestBookingId ? await guestBooking(guestBookingId) : await bookingIdForCode(bookingCode);
  if (booking.status !== "ok") return booking;
  return apiRequest<Schemas["AttachmentUploadResponseDto_Output"]>(`/bookings/${booking.data}/support-attachments/upload-url`, { method: "POST", headers: await bookingHeaders(booking.data), body: JSON.stringify({ contentType, sizeBytes }) });
}

/** Xin URL xem tệp có kiểm tra quyền đơn ở máy chủ API. */
export async function getSupportDownloadUrl(complaintId: string, attachmentId: string, guestBookingId?: string): Promise<DataResult<Schemas["DownloadUrlResponseDto_Output"]>> {
  const session = await refreshSessionIfNeeded();
  if (session.status !== "ok") return session;
  if (!uuid.safeParse(attachmentId).success) return failed("POST /bookings/support-attachments/download-url", "Mã tệp không hợp lệ.");
  const booking = await supportBookingId(complaintId, guestBookingId);
  if (booking.status !== "ok") return booking;
  return apiRequest<Schemas["DownloadUrlResponseDto_Output"]>(`/bookings/${booking.data}/support-attachments/${attachmentId}/download-url`, { method: "POST", headers: await bookingHeaders(booking.data) });
}
