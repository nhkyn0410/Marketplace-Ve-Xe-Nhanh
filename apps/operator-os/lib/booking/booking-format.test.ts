import { describe, expect, it } from "vitest";

import { ApiError } from "../auth/api-client";
import { cancellationRows, describePrivacyError, displayCode, historyLine, paymentState, ticketSummary } from "./booking-format";

describe("booking-format (OPR-003)", () => {
  it("mã hiển thị có gạch sau VXN, không gạch lặp", () => {
    expect(displayCode("VXN8F3K2Q")).toBe("VXN-8F3K2Q");
    expect(displayCode("VXN8F3K2Q-01")).toBe("VXN-8F3K2Q-01");
    expect(displayCode("VXN-8F3K2Q")).toBe("VXN-8F3K2Q");
  });

  it("cột Vé: mã chỗ, số vé đã hủy, hoặc đã nhả chỗ khi đơn hết hạn / hủy", () => {
    expect(ticketSummary({ seatCodes: ["A03", "A04"], cancelledTicketCount: 0, status: "CONFIRMED" })).toEqual({ title: "2 vé", note: "A03, A04" });
    expect(ticketSummary({ seatCodes: ["A1", "A2", "A3"], cancelledTicketCount: 1, status: "PARTIALLY_CANCELLED" })).toEqual({ title: "3 vé", note: "1 vé đã hủy" });
    expect(ticketSummary({ seatCodes: ["A1"], cancelledTicketCount: 0, status: "EXPIRED" }).note).toBe("Đã nhả chỗ");
  });

  it("thanh toán: chưa có → Chưa thanh toán; đang xử lý / thành công", () => {
    expect(paymentState(null)).toEqual({ label: "Chưa thanh toán", tone: "neutral" });
    expect(paymentState({ provider: "VNPAY", status: "PROCESSING", paidAt: null })).toEqual({ label: "Đang xử lý", tone: "warning" });
    expect(paymentState({ provider: "MOMO", status: "SUCCESS", paidAt: "2031-01-01T00:00:00Z" }).label).toBe("Thành công");
  });

  it("lịch sử: tạo đơn kèm chỗ, phát hành N vé", () => {
    const seats = [{ seatCode: "A03" }, { seatCode: "A04" }] as Parameters<typeof historyLine>[1]["seats"];
    const base = { fromStatus: null, reason: null, createdAt: "2031-01-01T00:00:00Z" };
    expect(historyLine({ ...base, toStatus: "PENDING_PAYMENT", actor: "GUEST" }, { seats })).toEqual({ title: "Tạo đơn", note: "Khách vãng lai · giữ chỗ A03, A04" });
    expect(historyLine({ ...base, toStatus: "CONFIRMED", actor: "SYSTEM" }, { seats }).title).toBe("Phát hành 2 vé");
  });

  it("mốc hủy theo giờ khởi hành (giờ VN), thêm dòng không hoàn sau mốc cuối", () => {
    // 22:30 16/10 giờ VN.
    expect(
      cancellationRows("2026-10-16T15:30:00Z", [
        { minHoursBefore: 4, refundPercent: 50 },
        { minHoursBefore: 24, refundPercent: 90 }
      ])
    ).toEqual([
      { when: "Trước 22:30 · 15/10", refund: "Hoàn 90%" },
      { when: "Trước 18:30 · 16/10", refund: "Hoàn 50%" },
      { when: "Sau 18:30 · 16/10", refund: "Không hoàn" }
    ]);
    expect(cancellationRows("2026-10-16T15:30:00Z", [{ minHoursBefore: 2, refundPercent: 0 }])).toEqual([{ when: "Trước 20:30 · 16/10", refund: "Không hoàn" }]);
  });

  it("lỗi xem / xuất dữ liệu khách: 503 = chưa ghi được nhật ký", () => {
    expect(describePrivacyError(new ApiError(503, "SERVICE_UNAVAILABLE", "x"))).toContain("nhật ký");
    expect(describePrivacyError(new TypeError("fetch failed"))).toContain("kết nối");
  });
});
