"use server";

import type { components } from "@vexenhanh/api-client";
import { cookies } from "next/headers";
import QRCode from "qrcode";
import { apiRequest } from "./api";
import { refreshSessionIfNeeded } from "./session";
import { bookingHeaders } from "./booking-access";
import { apiMoney, mapLookupResult, mapMyTicket, mapTicketDetail, moneyString, remainingSeconds, type ApiBooking } from "./booking-mappers";
import { type DataResult, failed, ok, unavailable } from "./result";
import type { MyTicketsData, TicketDetailData, TicketLookupResultData } from "./types";

const LOOKUP_COOKIE = "vxn_ticket_lookup";

/** Lấy toàn bộ trang booking của hành khách và đọc chi tiết để hiển thị đúng tiền, chỗ. */
export async function getMyTickets(): Promise<DataResult<MyTicketsData>> {
  const items: components["schemas"]["PassengerBookingPageDto_Output"]["items"] = [];
  let cursor: string | null = null;
  const seen = new Set<string>();
  do {
    const query: URLSearchParams = new URLSearchParams({ limit: "100", ...(cursor ? { cursor } : {}) });
    const page: DataResult<components["schemas"]["PassengerBookingPageDto_Output"]> = await apiRequest(`/me/bookings?${query}`);
    if (page.status !== "ok") return page;
    items.push(...page.data.items);
    cursor = page.data.nextCursor;
    if (cursor && seen.has(cursor)) return failed("GET /me/bookings", "Phân trang booking không hợp lệ.");
    if (cursor) seen.add(cursor);
  } while (cursor);
  const results = await Promise.all(items.map((item) => apiRequest<ApiBooking>(`/bookings/${item.bookingId}`)));
  const error = results.find((result) => result.status !== "ok");
  if (error) return error;
  try {
    const tickets = results.flatMap((result) => result.status === "ok" ? [mapMyTicket(result.data)] : []);
    return ok({ tickets, counts: { upcoming: tickets.filter((ticket) => ticket.status === "valid" || ticket.status === "pending_payment").length, completed: tickets.filter((ticket) => ticket.status === "completed").length, cancelled: tickets.filter((ticket) => ticket.status === "cancelled").length, all: tickets.length } });
  } catch { return failed("GET /me/bookings", "Dữ liệu giá booking không hợp lệ."); }
}

/** Đọc vé với quyền tài khoản hoặc token booking đã lưu trong cookie máy chủ. */
export async function getTicketDetail(ticketId: string, bookingId?: string): Promise<DataResult<TicketDetailData>> {
  const ticket = await apiRequest<components["schemas"]["TicketResponseDto_Output"]>(`/tickets/${encodeURIComponent(ticketId)}`, { headers: bookingId ? await bookingHeaders(bookingId) : {} });
  if (ticket.status !== "ok") return ticket;
  const booking = await apiRequest<ApiBooking>(`/bookings/${ticket.data.bookingId}`, { headers: await bookingHeaders(ticket.data.bookingId) });
  if (booking.status !== "ok") return booking;
  try {
    const detail = mapTicketDetail(booking.data);
    const tickets = await Promise.all(detail.tickets.map(async (item) => ({ ...item, qrCodeDataUrl: await QRCode.toDataURL(booking.data.tickets.find((source) => source.ticketId === item.ticketId)!.qrToken) })));
    const hasGuestAccess = Boolean((await bookingHeaders(booking.data.bookingId))["X-Booking-Token"]);
    const supportHref = hasGuestAccess ? `/support/guest?bookingId=${encodeURIComponent(booking.data.bookingId)}` : `/support?bookingCode=${encodeURIComponent(booking.data.bookingCode)}`;
    return ok({ ...detail, bookingId: booking.data.bookingId, supportHref, tickets });
  } catch { return failed("GET /tickets/{ticketId}", "Không thể đọc thông tin vé."); }
}

/** Báo giá hoàn tiền do API tính cho các vé đang chọn, trước khi người dùng xác nhận. */
export async function getCancellationQuote(bookingId: string, ticketIds: readonly string[]): Promise<DataResult<{ readonly refundAmountVnd: string; readonly feeVnd: string; readonly totalPaidVnd: string; readonly refundPercent: number; readonly cancellable: boolean; readonly reason: string }>> {
  const session = await refreshSessionIfNeeded();
  if (session.status !== "ok") return session;
  if (!bookingId || ticketIds.length === 0) return failed("GET /bookings/{bookingId}/cancellation-quote", "Vui lòng chọn vé cần hủy.");
  const query = new URLSearchParams({ ticketIds: ticketIds.join(",") });
  const quote = await apiRequest<components["schemas"]["CancellationQuoteDto_Output"]>(`/bookings/${encodeURIComponent(bookingId)}/cancellation-quote?${query}`, { headers: await bookingHeaders(bookingId) });
  if (quote.status !== "ok") return quote;
  try { return ok({ refundAmountVnd: moneyString(quote.data.refundAmount), feeVnd: moneyString(quote.data.nonRefundable), totalPaidVnd: moneyString(quote.data.selectedTotal), refundPercent: quote.data.refundPercent, cancellable: quote.data.tickets.every((ticket) => ticket.cancellable), reason: quote.data.tickets.filter((ticket) => !ticket.cancellable).map((ticket) => ticket.reason).filter(Boolean).join("; ") }); }
  catch { return failed("GET /bookings/{bookingId}/cancellation-quote", "Dữ liệu hoàn tiền không hợp lệ."); }
}

/** Hủy đúng các vé và mức hoàn tiền người dùng vừa xác nhận; API kiểm tra lại báo giá. */
export async function cancelTickets(bookingId: string, ticketIds: readonly string[], reason: string | undefined, expectedRefundVnd: string): Promise<DataResult<{ readonly refundAmountVnd: string }>> {
  const session = await refreshSessionIfNeeded();
  if (session.status !== "ok") return session;
  try {
    const input: components["schemas"]["CancellationInputDto"] = { ticketIds: [...ticketIds], expectedRefund: apiMoney(expectedRefundVnd), reason: reason?.trim() || null };
    const result = await apiRequest<components["schemas"]["CancellationResultDto_Output"]>(`/bookings/${encodeURIComponent(bookingId)}/cancellations`, { method: "POST", headers: await bookingHeaders(bookingId), body: JSON.stringify(input) });
    return result.status === "ok" ? ok({ refundAmountVnd: result.data.refund ? moneyString(result.data.refund.amount) : "0" }) : result;
  } catch { return failed("POST /bookings/{bookingId}/cancellations", "Số tiền hoàn không hợp lệ. Vui lòng lấy báo giá lại."); }
}

/** Tra cứu trực tiếp theo mã booking và email, lưu thông tin xác thực trong cookie httpOnly 15 phút. */
export async function lookupTickets(params: { readonly bookingCodeOrTicketCode: string; readonly email: string }): Promise<DataResult<{ readonly bookingId: string }>> {
  const session = await refreshSessionIfNeeded();
  if (session.status !== "ok") return session;
  const input = { bookingCode: params.bookingCodeOrTicketCode.trim().toUpperCase(), email: params.email.trim().toLowerCase() } satisfies components["schemas"]["TicketLookupInputDto"];
  const result = await apiRequest<ApiBooking>("/guest/ticket-lookup", { method: "POST", body: JSON.stringify(input) });
  if (result.status !== "ok") return result;
  (await cookies()).set(LOOKUP_COOKIE, JSON.stringify({ ...input, expiresAt: new Date(Date.now() + 900_000).toISOString() }), { httpOnly: true, secure: process.env.NODE_ENV === "production", sameSite: "lax", path: "/", maxAge: 900 });
  return ok({ bookingId: result.data.bookingId });
}

/** API hiện chưa cung cấp bước gửi OTP tra cứu vé; giữ trạng thái rõ ràng cho màn xem trước. */
export async function requestTicketLookupOtp(_params: { readonly bookingCodeOrTicketCode: string; readonly email: string }): Promise<DataResult<{ readonly maskedEmail: string }>> {
  return unavailable("POST /guest/ticket-lookup/otp");
}

/** API hiện chưa cung cấp bước xác minh OTP tra cứu vé. */
export async function verifyTicketLookupOtp(_params: { readonly bookingCodeOrTicketCode: string; readonly email: string; readonly otp: string }): Promise<DataResult<{ readonly lookupToken: string }>> {
  return unavailable("POST /guest/ticket-lookup/verify");
}

/** Đọc lại kết quả bằng cookie máy chủ, không nhận bí mật qua URL. */
export async function getTicketLookupResult(): Promise<DataResult<TicketLookupResultData>> {
  const saved = (await cookies()).get(LOOKUP_COOKIE)?.value;
  if (!saved) return failed("POST /guest/ticket-lookup", "Phiên tra cứu đã hết hạn. Vui lòng tra cứu lại.");
  try {
    const credentials = JSON.parse(saved) as { bookingCode: string; email: string; expiresAt: string };
    const expiresInSeconds = remainingSeconds(credentials.expiresAt);
    if (expiresInSeconds === 0) return failed("POST /guest/ticket-lookup", "Phiên tra cứu đã hết hạn.");
    const booking = await apiRequest<ApiBooking>("/guest/ticket-lookup", { method: "POST", body: JSON.stringify({ bookingCode: credentials.bookingCode, email: credentials.email }) });
    if (booking.status !== "ok") return booking;
    const mapped = mapLookupResult(booking.data, expiresInSeconds);
    const tickets = await Promise.all(mapped.tickets.map(async (ticket) => ({ ...ticket, qrCodeDataUrl: await QRCode.toDataURL(booking.data.tickets.find((source) => source.ticketId === ticket.ticketId)!.qrToken) })));
    const canManageBooking = Boolean((await bookingHeaders(booking.data.bookingId))["X-Booking-Token"]);
    return ok({ ...mapped, bookingId: booking.data.bookingId, canManageBooking, tickets });
  } catch { return failed("POST /guest/ticket-lookup", "Không thể đọc kết quả. Vui lòng tra cứu lại."); }
}

/** Xóa thông tin xác thực tra cứu khỏi trình duyệt khi khách kết thúc phiên. */
export async function endTicketLookup(): Promise<void> {
  (await cookies()).delete(LOOKUP_COOKIE);
}
