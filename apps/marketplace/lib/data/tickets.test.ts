import { beforeEach, describe, expect, it, vi } from "vitest";
import { bookingFixture } from "./booking-test-fixture";
const { request, jar, values } = vi.hoisted(() => {
  const values = new Map<string, string>();
  return { request: vi.fn(), values, jar: { get: vi.fn((name: string) => values.has(name) ? { value: values.get(name) } : undefined), set: vi.fn((name: string, value: string) => { values.set(name, value); }), delete: vi.fn((name: string) => { values.delete(name); }) } };
});
vi.mock("./api", () => ({ apiRequest: request }));
vi.mock("./session", () => ({ refreshSessionIfNeeded: vi.fn(async () => ({ status: "ok", data: { rotated: false } })) }));
vi.mock("next/headers", () => ({ cookies: vi.fn(async () => jar) }));
import { cancelTickets, endTicketLookup, getCancellationQuote, getMyTickets, getTicketDetail, getTicketLookupResult, requestTicketLookupOtp, verifyTicketLookupOtp } from "./tickets";

describe("ticket API integration", () => {
  beforeEach(() => { vi.clearAllMocks(); values.clear(); request.mockReset(); });

  it("đọc đủ các trang booking và dùng tiền thật từ snapshot", async () => {
    const booking = bookingFixture();
    request.mockResolvedValueOnce({ status: "ok", data: { items: [{ bookingId: booking.bookingId }], nextCursor: "next-page" } }).mockResolvedValueOnce({ status: "ok", data: { items: [], nextCursor: null } }).mockResolvedValueOnce({ status: "ok", data: booking });
    const result = await getMyTickets();
    expect(request.mock.calls[1]![0]).toBe("/me/bookings?limit=100&cursor=next-page");
    expect(result.status === "ok" && result.data.tickets[0]).toMatchObject({ id: booking.tickets[0]!.ticketId, totalAmountVnd: "100000", seatCodesText: "A1" });
  });

  it("đọc chi tiết với token máy chủ và tạo mã QR từ nội dung có chữ ký của API", async () => {
    const booking = bookingFixture();
    values.set(`vxn_booking_${booking.bookingId}`, "private-token");
    request.mockResolvedValueOnce({ status: "ok", data: { bookingId: booking.bookingId } }).mockResolvedValueOnce({ status: "ok", data: booking });
    const result = await getTicketDetail(booking.tickets[0]!.ticketId, booking.bookingId);
    expect(request.mock.calls[0]![1].headers).toEqual({ "X-Booking-Token": "private-token" });
    expect(result.status === "ok" && result.data.tickets[0]?.qrCodeDataUrl).toMatch(/^data:image\/png;base64,/);
    expect(JSON.stringify(result)).not.toContain("private-token");
    expect(result.status === "ok" && result.data.supportHref).toBe(`/support/guest?bookingId=${booking.bookingId}`);
  });

  it("lấy báo giá thật và gửi nguyên mức hoàn đã được người dùng xác nhận", async () => {
    request.mockResolvedValueOnce({ status: "ok", data: { tickets: [{ cancellable: true, reason: null }], refundAmount: 80000, nonRefundable: 20001, selectedTotal: 100001, refundPercent: 80 } });
    const quote = await getCancellationQuote("booking-id", ["ticket-id"]);
    expect(quote).toEqual({ status: "ok", data: { refundAmountVnd: "80000", feeVnd: "20001", totalPaidVnd: "100001", refundPercent: 80, cancellable: true, reason: "" } });
    request.mockResolvedValueOnce({ status: "ok", data: { refund: { amount: 80000 } } });
    expect(await cancelTickets("booking-id", ["ticket-id"], "Đổi kế hoạch", "80000")).toEqual({ status: "ok", data: { refundAmountVnd: "80000" } });
    expect(JSON.parse(request.mock.calls[1]![1].body)).toEqual({ ticketIds: ["ticket-id"], expectedRefund: 80000, reason: "Đổi kế hoạch" });
  });

  it("tra cứu bắt buộc mã xác minh: gửi mã, xác minh rồi chỉ giữ phiên tra cứu trong cookie httpOnly; kết thúc phiên xóa cookie", async () => {
    const booking = bookingFixture();
    const sent = { maskedEmail: "g***@example.test", expiresInSeconds: 300, resendAfterSeconds: 60, maxAttempts: 5 };
    request.mockResolvedValueOnce({ status: "ok", data: sent });
    expect(await requestTicketLookupOtp({ bookingCodeOrTicketCode: " vxn-test ", email: "GUEST@example.test" })).toEqual({ status: "ok", data: sent });
    expect(request.mock.calls[0]![0]).toBe("/guest/ticket-lookup/otp");
    expect(JSON.parse(request.mock.calls[0]![1].body)).toEqual({ bookingCode: "VXN-TEST", email: "guest@example.test" });
    expect(jar.set).not.toHaveBeenCalled();

    const expiresAt = new Date(Date.now() + 900_000).toISOString();
    request.mockResolvedValueOnce({ status: "ok", data: { lookupToken: "secret-lookup-token", expiresAt } });
    expect(await verifyTicketLookupOtp({ bookingCodeOrTicketCode: "VXN-TEST", email: "guest@example.test", otp: "123456" })).toEqual({ status: "ok", data: { expiresAt } });
    expect(request.mock.calls[1]![0]).toBe("/guest/ticket-lookup/verify");
    expect(JSON.parse(request.mock.calls[1]![1].body)).toEqual({ bookingCode: "VXN-TEST", email: "guest@example.test", otp: "123456" });
    expect(jar.set).toHaveBeenCalledWith("vxn_ticket_lookup", expect.any(String), expect.objectContaining({ httpOnly: true, maxAge: expect.any(Number) }));
    expect(values.get("vxn_ticket_lookup")).not.toContain("guest@example.test");

    request.mockResolvedValue({ status: "ok", data: booking });
    const result = await getTicketLookupResult();
    expect(request.mock.calls[2]![0]).toBe("/guest/ticket-lookup");
    expect(JSON.parse(request.mock.calls[2]![1].body)).toEqual({ lookupToken: "secret-lookup-token" });
    expect(result.status === "ok" && result.data.tickets[0]?.qrCodeDataUrl).toMatch(/^data:image\/png;base64,/);
    expect(result.status === "ok" && result.data.canManageBooking).toBe(false);
    expect(JSON.stringify(result)).not.toContain("secret-lookup-token");
    values.set(`vxn_booking_${booking.bookingId}`, "original-booking-capability");
    const originalBrowser = await getTicketLookupResult();
    expect(originalBrowser.status === "ok" && originalBrowser.data.canManageBooking).toBe(true);
    await endTicketLookup();
    expect((await getTicketLookupResult()).status).toBe("error");
  });

  it("sai mã xác minh không tạo phiên tra cứu", async () => {
    request.mockResolvedValueOnce({ status: "error", endpoint: "POST /guest/ticket-lookup/verify", message: "Mã xác minh không đúng. Còn 4 lần thử.", httpStatus: 422 });
    expect(await verifyTicketLookupOtp({ bookingCodeOrTicketCode: "VXN-TEST", email: "guest@example.test", otp: "000000" })).toMatchObject({ status: "error", httpStatus: 422 });
    expect(jar.set).not.toHaveBeenCalled();
  });
});
