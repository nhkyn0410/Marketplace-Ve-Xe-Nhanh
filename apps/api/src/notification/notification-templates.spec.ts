import { describe, expect, it } from "vitest";
import { describeTripChange, renderNotification, vnMoment, type TripScheduleSnapshot } from "./notification-templates";

const BEFORE: TripScheduleSnapshot = {
  departureAt: "2026-10-16T15:30:00.000Z",
  arrivalAt: "2026-10-16T22:30:00.000Z",
  vehiclePlateNumber: "51B12345",
  stops: [
    { sequence: 1, name: "Bến xe Miền Đông" },
    { sequence: 2, name: "Bến xe Đà Lạt" },
  ],
};

describe("notification-templates (TASK-NSR-001)", () => {
  it("giờ VN; mô tả thay đổi lịch chạy chỉ liệt kê phần đổi", () => {
    expect(vnMoment("2026-10-16T15:30:00.000Z")).toBe("22:30 ngày 16/10/2026");
    expect(describeTripChange(BEFORE, BEFORE)).toEqual([]);
    expect(
      describeTripChange(BEFORE, {
        ...BEFORE,
        departureAt: "2026-10-16T16:00:00.000Z",
        vehiclePlateNumber: "51B67890",
        stops: [BEFORE.stops[0]!, { sequence: 2, name: "Văn phòng Đà Lạt" }],
      }),
    ).toEqual([
      "Giờ khởi hành: 22:30 ngày 16/10/2026 → 23:00 ngày 16/10/2026.",
      "Xe: 51B12345 → 51B67890. Số ghế của bạn giữ nguyên.",
      "Điểm dừng số 2: Bến xe Đà Lạt → Văn phòng Đà Lạt.",
    ]);
  });

  it("vé điện tử / hủy vé / hoàn tiền: mã đơn, tiền VND, không chứa thông tin liên hệ", () => {
    const confirmed = renderNotification({
      kind: "BOOKING_CONFIRMED",
      bookingCode: "VXN8F3K2Q",
      routeName: "Sài Gòn – Đà Lạt",
      departureAt: BEFORE.departureAt,
      pickupName: "Bến xe Miền Đông",
      dropoffName: "Bến xe Đà Lạt",
      tickets: [{ ticketCode: "VXN8F3K2Q-01", seatCode: "A1" }],
      total: 560_000,
    });
    expect(confirmed.subject).toBe("Vé xe VXN8F3K2Q — Sài Gòn – Đà Lạt");
    expect(confirmed.lines.join(" ")).toContain("560.000 ₫");
    expect(confirmed.lines.join(" ")).toContain("VXN8F3K2Q-01 (chỗ A1)");
    expect(renderNotification({ kind: "TICKETS_CANCELLED", bookingCode: "VXN1", ticketCodes: ["VXN1-01"], refundAmount: 0 }).lines[1]).toContain("không được hoàn tiền");
    expect(renderNotification({ kind: "REFUND_SUCCEEDED", bookingCode: "VXN1", refundCode: "RFD1", amount: 270_000, provider: "VNPay" }).lines[0]).toBe(
      "Đã hoàn 270.000 ₫ cho đơn VXN1 (mã hoàn RFD1) qua VNPay.",
    );
  });

  it("đổi / hủy chuyến: lý do của nhà xe; đơn chưa thanh toán bị hủy không trừ tiền; hoàn tay báo chủ nhà xe", () => {
    const changed = renderNotification({ kind: "TRIP_CHANGED", bookingCode: "VXN1", routeName: "SG – ĐL", before: BEFORE, after: { ...BEFORE, arrivalAt: "2026-10-16T23:00:00.000Z" }, reason: "Tắc đường" });
    expect(changed.lines).toContain("Giờ đến dự kiến: 05:30 ngày 17/10/2026 → 06:00 ngày 17/10/2026.");
    expect(changed.lines).toContain("Lý do của nhà xe: Tắc đường");
    const cancelledPending = renderNotification({ kind: "TRIP_CANCELLED", bookingCode: "VXN1", routeName: "SG – ĐL", departureAt: BEFORE.departureAt, reason: "Xe hỏng", refundAmount: null });
    expect(cancelledPending.lines[2]).toContain("không bị trừ tiền");
    const cancelledPaid = renderNotification({ kind: "TRIP_CANCELLED", bookingCode: "VXN1", routeName: "SG – ĐL", departureAt: BEFORE.departureAt, reason: "Xe hỏng", refundAmount: 600_000 });
    expect(cancelledPaid.lines[2]).toContain("hoàn toàn bộ 600.000 ₫");
    expect(renderNotification({ kind: "MANUAL_REFUND", operatorName: "Sao Việt", bookingCode: "VXN1", refundCode: "RFD1", amount: 100_000, reference: "FT1", reason: "Chuyển tay" }).lines[1]).toBe(
      "Mã tham chiếu: FT1. Lý do: Chuyển tay",
    );
  });
});
