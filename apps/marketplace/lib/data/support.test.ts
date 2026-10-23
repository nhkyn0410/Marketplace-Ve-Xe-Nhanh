import { beforeEach, describe, expect, it, vi } from "vitest";
import { getComplaintDetail, getGuestComplaints, getMyComplaints, replyComplaint, submitComplaint, submitGuestComplaint, getSupportUploadUrl } from "./support";

const { request, bookingHeaders, refresh } = vi.hoisted(() => ({ request: vi.fn(), bookingHeaders: vi.fn(), refresh: vi.fn() }));
vi.mock("./api", () => ({ apiRequest: request }));
vi.mock("./booking-access", () => ({ bookingHeaders }));
vi.mock("./session", () => ({ refreshSessionIfNeeded: refresh }));
const bookingId = "00000000-0000-4000-8000-000000000001";
const ticketId = "00000000-0000-4000-8000-000000000002";
const summary = { ticketId, ticketCode: "SUP-1", bookingId, bookingCode: "BOOK-1", subject: "Hoàn tiền", status: "WAITING_CUSTOMER", updatedAt: "2026-10-20T00:00:00Z" };
const detail = { ...summary, createdAt: summary.updatedAt, trip: { routeName: "HCM → Đà Lạt" }, category: "PAYMENT_REFUND", messages: [{ messageId: "m1", party: "PASSENGER", authorName: "Khách", createdAt: summary.updatedAt, body: "Kiểm tra giúp tôi", attachments: [] }] };

describe("support API integration", () => {
  beforeEach(() => { vi.clearAllMocks(); bookingHeaders.mockResolvedValue({}); refresh.mockResolvedValue({ status: "ok", data: { rotated: false } }); });

  it("handles a genuinely empty list without a fabricated selected complaint", async () => {
    request.mockResolvedValueOnce({ status: "ok", data: { items: [], nextCursor: null } });
    expect(await getMyComplaints()).toEqual({ status: "ok", data: { activeComplaints: [], closedComplaints: [], selectedComplaint: null } });
    expect(request).toHaveBeenCalledWith("/me/support-tickets?limit=100");
  });

  it("looks up bookingId through paginated account support before loading detail", async () => {
    request.mockResolvedValueOnce({ status: "ok", data: { items: [], nextCursor: bookingId } })
      .mockResolvedValueOnce({ status: "ok", data: { items: [summary], nextCursor: null } })
      .mockResolvedValueOnce({ status: "ok", data: detail });
    const result = await getComplaintDetail(ticketId);
    expect(result.status).toBe("ok");
    expect(request).toHaveBeenLastCalledWith(`/bookings/${bookingId}/support-tickets/${ticketId}`, { headers: {} });
    if (result.status === "ok") expect(result.data.statusLabel).toBe("Chờ bạn bổ sung");
  });

  it("creates with real category/priority/attachment contract", async () => {
    request.mockResolvedValueOnce({ status: "ok", data: { items: [{ bookingId, bookingCode: "BOOK-1" }], nextCursor: null } })
      .mockResolvedValueOnce({ status: "ok", data: detail });
    const result = await submitComplaint({ bookingCode: "BOOK-1", category: "Thanh toán / hoàn tiền", suggestedSeverity: "Cao", title: "Hoàn tiền", content: "Kiểm tra giúp tôi" });
    expect(result.status).toBe("ok");
    expect(request).toHaveBeenLastCalledWith(`/bookings/${bookingId}/support-tickets`, { method: "POST", headers: {}, body: JSON.stringify({ category: "PAYMENT_REFUND", priority: "HIGH", subject: "Hoàn tiền", body: "Kiểm tra giúp tôi", attachments: [] }) });
    expect(refresh).toHaveBeenCalled();
  });

  it("requires cookie capability for guests, never treats email as authorization", async () => {
    expect((await getGuestComplaints(bookingId)).status).toBe("error");
    expect((await submitGuestComplaint({ bookingCode: "BOOK-1", email: "a@example.com", category: "Khác", title: "Hỗ trợ", content: "Giúp tôi" })).status).toBe("error");
    expect(request).not.toHaveBeenCalled();
  });

  it("replies using body/attachments with guest booking capability", async () => {
    bookingHeaders.mockResolvedValue({ "X-Booking-Token": "private-token" });
    request.mockResolvedValueOnce({ status: "ok", data: detail });
    const attachments = [{ objectKey: "private/proof", fileName: "proof.pdf" }];
    expect((await replyComplaint(ticketId, " Bổ sung ", attachments, bookingId)).status).toBe("ok");
    expect(request).toHaveBeenCalledWith(`/bookings/${bookingId}/support-tickets/${ticketId}/messages`, { method: "POST", headers: { "X-Booking-Token": "private-token" }, body: JSON.stringify({ body: "Bổ sung", attachments }) });
  });

  it("does not send invalid attachments or mutate after refresh failure", async () => {
    expect((await getSupportUploadUrl("BOOK-1", "application/msword", 100)).status).toBe("error");
    refresh.mockResolvedValueOnce({ status: "error", endpoint: "POST /auth/refresh", message: "Login required" });
    expect((await replyComplaint(ticketId, "Bổ sung")).status).toBe("error");
    expect(request).not.toHaveBeenCalled();
  });
});
