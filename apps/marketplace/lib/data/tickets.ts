"use server";

import type { components } from "@vexenhanh/api-client";
import { cookies } from "next/headers";
import QRCode from "qrcode";
import { apiRequest } from "./api";
import { refreshSessionIfNeeded } from "./session";
import { bookingHeaders, rememberLookupBookingAccess } from "./booking-access";
import { apiMoney, mapLookupBookings, mapLookupResult, mapMyTicket, mapTicketDetail, moneyString, remainingSeconds, type ApiBooking } from "./booking-mappers";
import { type DataResult, failed, ok } from "./result";
import type { MyTicketsData, TicketDetailData, TicketLookupBookingsData, TicketLookupOtpSent, TicketLookupResultData } from "./types";

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

/** Email bắt buộc; mã đặt vé / mã vé không bắt buộc — để trống thì tra mọi đơn của email trong 12 tháng. */
function lookupIdentity(params: { readonly bookingCodeOrTicketCode?: string; readonly email: string }) {
  const bookingCode = params.bookingCodeOrTicketCode?.trim().toUpperCase();
  return { email: params.email.trim().toLowerCase(), ...(bookingCode ? { bookingCode } : {}) };
}

/** B1 tra cứu vé: gửi mã 6 số về email (API chỉ gửi khi email có đơn, hoặc đúng mã đặt vé + email). */
export async function requestTicketLookupOtp(params: { readonly bookingCodeOrTicketCode?: string; readonly email: string }): Promise<DataResult<TicketLookupOtpSent>> {
  const session = await refreshSessionIfNeeded();
  if (session.status !== "ok") return session;
  const input = lookupIdentity(params) satisfies components["schemas"]["TicketLookupOtpInputDto"];
  return apiRequest<components["schemas"]["TicketLookupOtpResponseDto_Output"]>("/guest/ticket-lookup/otp", { method: "POST", body: JSON.stringify(input) });
}

/** B2: xác minh mã; phiên tra cứu 15 phút chỉ nằm trong cookie httpOnly (không đưa ra trình duyệt hay URL). */
export async function verifyTicketLookupOtp(params: { readonly bookingCodeOrTicketCode?: string; readonly email: string; readonly otp: string }): Promise<DataResult<{ readonly expiresAt: string }>> {
  const session = await refreshSessionIfNeeded();
  if (session.status !== "ok") return session;
  const input = { ...lookupIdentity(params), otp: params.otp } satisfies components["schemas"]["TicketLookupVerifyInputDto"];
  const result = await apiRequest<components["schemas"]["TicketLookupSessionDto_Output"]>("/guest/ticket-lookup/verify", { method: "POST", body: JSON.stringify(input) });
  if (result.status !== "ok") return result;
  const maxAge = remainingSeconds(result.data.expiresAt);
  (await cookies()).set(LOOKUP_COOKIE, JSON.stringify({ lookupToken: result.data.lookupToken, expiresAt: result.data.expiresAt }), { httpOnly: true, secure: process.env.NODE_ENV === "production", sameSite: "lax", path: "/", maxAge });
  return ok({ expiresAt: result.data.expiresAt });
}

/** Phiên tra cứu đang lưu trong cookie máy chủ; hết hạn / không có → `null`. */
async function lookupSession(): Promise<{ readonly lookupToken: string; readonly expiresInSeconds: number } | null> {
  const saved = (await cookies()).get(LOOKUP_COOKIE)?.value;
  if (!saved) return null;
  const credentials = JSON.parse(saved) as { lookupToken?: string; expiresAt?: string };
  const expiresInSeconds = credentials.expiresAt ? remainingSeconds(credentials.expiresAt) : 0;
  return credentials.lookupToken && expiresInSeconds > 0 ? { lookupToken: credentials.lookupToken, expiresInSeconds } : null;
}

const EXPIRED_MESSAGE = "Phiên tra cứu đã hết hạn. Vui lòng tra cứu lại.";

/** Các đơn của phiên tra cứu (một đơn khi đã nhập mã đặt vé) + gợi ý đăng nhập. */
export async function getTicketLookupBookings(): Promise<DataResult<TicketLookupBookingsData>> {
  try {
    const session = await lookupSession();
    if (!session) return failed("POST /guest/ticket-lookup/bookings", EXPIRED_MESSAGE);
    const list = await apiRequest<components["schemas"]["TicketLookupBookingListDto_Output"]>("/guest/ticket-lookup/bookings", { method: "POST", body: JSON.stringify({ lookupToken: session.lookupToken } satisfies components["schemas"]["TicketLookupSessionInputDto"]) });
    return list.status === "ok" ? ok(mapLookupBookings(list.data, session.expiresInSeconds)) : list;
  } catch { return failed("POST /guest/ticket-lookup/bookings", "Không thể đọc danh sách đơn. Vui lòng tra cứu lại."); }
}

/** Đọc một đơn của phiên bằng cookie máy chủ (`bookingId` bắt buộc khi phiên theo email), không nhận bí mật qua URL. */
export async function getTicketLookupResult(bookingId?: string): Promise<DataResult<TicketLookupResultData>> {
  try {
    const session = await lookupSession();
    if (!session) return failed("POST /guest/ticket-lookup", EXPIRED_MESSAGE);
    const input = { lookupToken: session.lookupToken, ...(bookingId ? { bookingId } : {}) } satisfies components["schemas"]["TicketLookupInputDto"];
    const booking = await apiRequest<ApiBooking>("/guest/ticket-lookup", { method: "POST", body: JSON.stringify(input) });
    if (booking.status !== "ok") return booking;
    const mapped = mapLookupResult(booking.data, session.expiresInSeconds);
    const tickets = await Promise.all(mapped.tickets.map(async (ticket) => ({ ...ticket, qrCodeDataUrl: await QRCode.toDataURL(booking.data.tickets.find((source) => source.ticketId === ticket.ticketId)!.qrToken) })));
    const canManageBooking = Boolean((await bookingHeaders(booking.data.bookingId))["X-Booking-Token"]);
    return ok({ ...mapped, bookingId: booking.data.bookingId, canManageBooking, tickets });
  } catch { return failed("POST /guest/ticket-lookup", "Không thể đọc kết quả. Vui lòng tra cứu lại."); }
}

/**
 * Mở quyền hủy vé / gửi khiếu nại cho một đơn khách vãng lai của phiên tra cứu đã xác minh OTP: API cấp mã truy cập phụ
 * (hết hạn cùng phiên), lưu vào cookie httpOnly của đơn để các trang quản lý vé / hỗ trợ dùng như mã lúc đặt.
 */
export async function unlockTicketLookupBooking(bookingId: string): Promise<DataResult<{ readonly bookingId: string }>> {
  try {
    const session = await lookupSession();
    if (!session) return failed("POST /guest/ticket-lookup/booking-access", EXPIRED_MESSAGE);
    if ((await bookingHeaders(bookingId))["X-Booking-Token"]) return ok({ bookingId });
    const refreshed = await refreshSessionIfNeeded();
    if (refreshed.status !== "ok") return refreshed;
    const input = { lookupToken: session.lookupToken, bookingId } satisfies components["schemas"]["TicketLookupInputDto"];
    const result = await apiRequest<components["schemas"]["TicketLookupAccessDto_Output"]>("/guest/ticket-lookup/booking-access", { method: "POST", body: JSON.stringify(input) });
    if (result.status !== "ok") return result;
    await rememberLookupBookingAccess(result.data.bookingId, result.data.accessToken, remainingSeconds(result.data.expiresAt));
    return ok({ bookingId: result.data.bookingId });
  } catch { return failed("POST /guest/ticket-lookup/booking-access", "Chưa mở được quyền quản lý đơn. Vui lòng thử lại."); }
}

/** Xóa thông tin xác thực tra cứu khỏi trình duyệt khi khách kết thúc phiên. */
export async function endTicketLookup(): Promise<void> {
  (await cookies()).delete(LOOKUP_COOKIE);
}
