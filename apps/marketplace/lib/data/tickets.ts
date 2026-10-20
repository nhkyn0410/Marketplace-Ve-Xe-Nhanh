// Tạm — chưa có hợp đồng API (05 API §7.2)
import { DataResult, unavailable } from "./result";
import { MyTicketsData, TicketDetailData } from "./types";

/**
 * Lấy danh sách vé đã đặt của hành khách (SCR-PSG-24).
 * Theo Bảng A2, backend 05 API chưa có endpoint danh sách vé.
 */
export async function getMyTickets(): Promise<DataResult<MyTicketsData>> {
  return unavailable("GET /me/tickets");
}

/**
 * Lấy chi tiết vé điện tử của một đơn đặt vé (SCR-PSG-25).
 */
export async function getTicketDetail(
  ticketId: string
): Promise<DataResult<TicketDetailData>> {
  return unavailable(`GET /tickets/${ticketId}`);
}

/**
 * Hủy vé / hủy chỗ đã đặt (SCR-PSG-26).
 */
export async function cancelTickets(
  bookingCode: string,
  ticketIds: readonly string[],
  reason?: string
): Promise<DataResult<{ readonly refundAmountVnd: string }>> {
  void bookingCode;
  void ticketIds;
  void reason;
  return unavailable(`POST /bookings/${bookingCode}/cancel`);
}

/**
 * Yêu cầu gửi mã OTP để tra cứu vé (SCR-PSG-27).
 * Endpoint 05 API: POST /guest/ticket-lookup
 */
export async function requestTicketLookupOtp(params: {
  readonly bookingCodeOrTicketCode: string;
  readonly email: string;
}): Promise<DataResult<{ readonly maskedEmail: string }>> {
  void params;
  return unavailable("POST /guest/ticket-lookup");
}

/**
 * Xác thực mã OTP tra cứu vé (SCR-PSG-28).
 * Endpoint 05 API: POST /guest/ticket-lookup/verify
 */
export async function verifyTicketLookupOtp(params: {
  readonly bookingCodeOrTicketCode: string;
  readonly email: string;
  readonly otp: string;
}): Promise<DataResult<{ readonly lookupToken: string }>> {
  void params;
  return unavailable("POST /guest/ticket-lookup/verify");
}

/**
 * Lấy chi tiết đơn đặt vé từ kết quả tra cứu khách vãng lai (SCR-PSG-29).
 * Endpoint 05 API: GET /guest/ticket-lookup/{token}
 */
export async function getTicketLookupResult(
  lookupToken: string
): Promise<DataResult<import("./types").TicketLookupResultData>> {
  return unavailable(`GET /guest/ticket-lookup/${lookupToken}`);
}


