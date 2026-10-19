import { describe, expect, it, vi } from "vitest";
import {
  getMyTickets,
  getTicketDetail,
  cancelTickets,
  requestTicketLookupOtp,
  verifyTicketLookupOtp,
  getTicketLookupResult
} from "./tickets";

describe("tickets data service", () => {
  it("getMyTickets trả về unavailable và ghi log console.warn", async () => {
    const warnSpy = vi.spyOn(console, "warn").mockImplementation(() => {});

    const result = await getMyTickets();

    expect(result.status).toBe("unavailable");
    if (result.status === "unavailable") {
      expect(result.endpoint).toBe("GET /me/tickets");
    }
    expect(warnSpy).toHaveBeenCalledWith("[marketplace] chưa có API: GET /me/tickets");

    warnSpy.mockRestore();
  });

  it("getTicketDetail trả về unavailable với id được truyền vào", async () => {
    const warnSpy = vi.spyOn(console, "warn").mockImplementation(() => {});

    const result = await getTicketDetail("ticket-vxn-8f3k2q");

    expect(result.status).toBe("unavailable");
    if (result.status === "unavailable") {
      expect(result.endpoint).toBe("GET /tickets/ticket-vxn-8f3k2q");
    }
    expect(warnSpy).toHaveBeenCalledWith("[marketplace] chưa có API: GET /tickets/ticket-vxn-8f3k2q");

    warnSpy.mockRestore();
  });

  it("cancelTickets trả về unavailable cho POST /bookings/{code}/cancel", async () => {
    const warnSpy = vi.spyOn(console, "warn").mockImplementation(() => {});

    const result = await cancelTickets("VXN-8F3K2Q", ["t-01"], "Đổi kế hoạch");

    expect(result.status).toBe("unavailable");
    if (result.status === "unavailable") {
      expect(result.endpoint).toBe("POST /bookings/VXN-8F3K2Q/cancel");
    }
    expect(warnSpy).toHaveBeenCalledWith("[marketplace] chưa có API: POST /bookings/VXN-8F3K2Q/cancel");

    warnSpy.mockRestore();
  });

  it("requestTicketLookupOtp trả về unavailable cho POST /guest/ticket-lookup", async () => {
    const warnSpy = vi.spyOn(console, "warn").mockImplementation(() => {});

    const result = await requestTicketLookupOtp({
      bookingCodeOrTicketCode: "VXN-4H9P6C",
      email: "hoa.le@gmail.com"
    });

    expect(result.status).toBe("unavailable");
    if (result.status === "unavailable") {
      expect(result.endpoint).toBe("POST /guest/ticket-lookup");
    }
    expect(warnSpy).toHaveBeenCalledWith("[marketplace] chưa có API: POST /guest/ticket-lookup");

    warnSpy.mockRestore();
  });

  it("verifyTicketLookupOtp trả về unavailable cho POST /guest/ticket-lookup/verify", async () => {
    const warnSpy = vi.spyOn(console, "warn").mockImplementation(() => {});

    const result = await verifyTicketLookupOtp({
      bookingCodeOrTicketCode: "VXN-4H9P6C",
      email: "hoa.le@gmail.com",
      otp: "482917"
    });

    expect(result.status).toBe("unavailable");
    if (result.status === "unavailable") {
      expect(result.endpoint).toBe("POST /guest/ticket-lookup/verify");
    }
    expect(warnSpy).toHaveBeenCalledWith("[marketplace] chưa có API: POST /guest/ticket-lookup/verify");

    warnSpy.mockRestore();
  });

  it("getTicketLookupResult trả về unavailable cho GET /guest/ticket-lookup/{token}", async () => {
    const warnSpy = vi.spyOn(console, "warn").mockImplementation(() => {});

    const result = await getTicketLookupResult("guest-tok-123");

    expect(result.status).toBe("unavailable");
    if (result.status === "unavailable") {
      expect(result.endpoint).toBe("GET /guest/ticket-lookup/guest-tok-123");
    }
    expect(warnSpy).toHaveBeenCalledWith("[marketplace] chưa có API: GET /guest/ticket-lookup/guest-tok-123");

    warnSpy.mockRestore();
  });
});


