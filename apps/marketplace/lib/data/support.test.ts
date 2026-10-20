import { describe, expect, it, vi } from "vitest";
import {
  getMyComplaints,
  getComplaintDetail,
  submitComplaint,
  replyComplaint,
  getGuestComplaints,
  submitGuestComplaint
} from "./support";

describe("support data service", () => {
  it("getMyComplaints trả về unavailable và ghi log cảnh báo", async () => {
    const warnSpy = vi.spyOn(console, "warn").mockImplementation(() => {});

    const result = await getMyComplaints();

    expect(result.status).toBe("unavailable");
    if (result.status === "unavailable") {
      expect(result.endpoint).toBe("GET /me/complaints");
    }
    expect(warnSpy).toHaveBeenCalledWith("[marketplace] chưa có API: GET /me/complaints");

    warnSpy.mockRestore();
  });

  it("getComplaintDetail trả về unavailable với id được truyền vào", async () => {
    const warnSpy = vi.spyOn(console, "warn").mockImplementation(() => {});

    const result = await getComplaintDetail("kn-01");

    expect(result.status).toBe("unavailable");
    if (result.status === "unavailable") {
      expect(result.endpoint).toBe("GET /me/complaints/kn-01");
    }
    expect(warnSpy).toHaveBeenCalledWith("[marketplace] chưa có API: GET /me/complaints/kn-01");

    warnSpy.mockRestore();
  });

  it("submitComplaint trả về unavailable cho POST /me/complaints", async () => {
    const warnSpy = vi.spyOn(console, "warn").mockImplementation(() => {});

    const result = await submitComplaint({
      bookingCode: "VXN-8F3K2Q",
      category: "Thanh toán",
      title: "Trừ tiền thừa",
      content: "Nhờ kiểm tra hoàn tiền"
    });

    expect(result.status).toBe("unavailable");
    if (result.status === "unavailable") {
      expect(result.endpoint).toBe("POST /me/complaints");
    }
    expect(warnSpy).toHaveBeenCalledWith("[marketplace] chưa có API: POST /me/complaints");

    warnSpy.mockRestore();
  });

  it("replyComplaint trả về unavailable cho POST /me/complaints/{id}/messages", async () => {
    const warnSpy = vi.spyOn(console, "warn").mockImplementation(() => {});

    const result = await replyComplaint("kn-01", "Tôi gửi thêm thông tin");

    expect(result.status).toBe("unavailable");
    if (result.status === "unavailable") {
      expect(result.endpoint).toBe("POST /me/complaints/kn-01/messages");
    }
    expect(warnSpy).toHaveBeenCalledWith("[marketplace] chưa có API: POST /me/complaints/kn-01/messages");

    warnSpy.mockRestore();
  });

  it("getGuestComplaints trả về unavailable cho GET /guest/complaints", async () => {
    const warnSpy = vi.spyOn(console, "warn").mockImplementation(() => {});

    const result = await getGuestComplaints("token-123");

    expect(result.status).toBe("unavailable");
    if (result.status === "unavailable") {
      expect(result.endpoint).toBe("GET /guest/complaints");
    }
    expect(warnSpy).toHaveBeenCalledWith("[marketplace] chưa có API: GET /guest/complaints");

    warnSpy.mockRestore();
  });

  it("submitGuestComplaint trả về unavailable cho POST /guest/complaints", async () => {
    const warnSpy = vi.spyOn(console, "warn").mockImplementation(() => {});

    const result = await submitGuestComplaint({
      bookingCode: "VXN-4H9P6C",
      email: "hoa.le@gmail.com",
      category: "Dịch vụ",
      title: "Xe trễ",
      content: "Xe đến muộn"
    });

    expect(result.status).toBe("unavailable");
    if (result.status === "unavailable") {
      expect(result.endpoint).toBe("POST /guest/complaints");
    }
    expect(warnSpy).toHaveBeenCalledWith("[marketplace] chưa có API: POST /guest/complaints");

    warnSpy.mockRestore();
  });
});
