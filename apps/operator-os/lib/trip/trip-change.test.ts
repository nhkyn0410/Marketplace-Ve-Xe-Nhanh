import { describe, expect, it } from "vitest";

import { ApiError } from "../auth/api-client";
import { cancelSummary, changeKindLabel, changeLines, describeTripChangeError, impactLabel, toChangeInput } from "./trip-change";

const SCHEDULE = {
  departureAt: "2026-10-16T15:30:00.000Z",
  arrivalAt: "2026-10-16T22:30:00.000Z",
  vehiclePlateNumber: "51B12345",
  stops: [
    { sequence: 1, name: "Bến xe Miền Đông" },
    { sequence: 2, name: "Bến xe Đà Lạt" }
  ]
};

describe("trip-change (TRN-008)", () => {
  it("body đổi chuyến: điểm thay theo thứ tự, điểm khác giữ nguyên, lý do bỏ khoảng trắng", () => {
    const trip = {
      stops: [
        { sequence: 1, catalogStopPointId: "c1", stopPointId: null },
        { sequence: 2, catalogStopPointId: "c2", stopPointId: null }
      ]
    } as Parameters<typeof toChangeInput>[0];
    const input = toChangeInput(
      trip,
      { departureAt: "2026-10-16T23:00:00+07:00", vehicleId: "v2", reason: "  Xe cũ hỏng  " },
      new Map([[2, { catalogStopPointId: null, stopPointId: "own-1", name: "Văn phòng Đà Lạt" }]])
    );
    expect(input).toEqual({
      departureAt: "2026-10-16T23:00:00+07:00",
      stopTimes: null,
      vehicleId: "v2",
      stops: [
        { sequence: 1, catalogStopPointId: "c1", stopPointId: null },
        { sequence: 2, catalogStopPointId: null, stopPointId: "own-1" }
      ],
      reason: "Xe cũ hỏng"
    });
  });

  it("lịch sử: nhãn loại, dòng trước → sau chỉ phần đổi; hủy chuyến một dòng", () => {
    expect(changeKindLabel(["SCHEDULE", "VEHICLE"])).toBe("Đổi giờ · Đổi xe");
    expect(
      changeLines({
        kinds: ["SCHEDULE", "STOP"],
        before: SCHEDULE,
        after: { ...SCHEDULE, departureAt: "2026-10-16T16:00:00.000Z", stops: [SCHEDULE.stops[0]!, { sequence: 2, name: "Văn phòng Đà Lạt" }] }
      })
    ).toEqual(["Khởi hành: 22:30 16/10/2026 → 23:00 16/10/2026", "Điểm 2: Bến xe Đà Lạt → Văn phòng Đà Lạt"]);
    expect(changeLines({ kinds: ["CANCEL"], before: SCHEDULE, after: SCHEDULE })).toEqual(["Chuyến 22:30 16/10/2026 đã hủy."]);
  });

  it("ảnh hưởng + tóm tắt hủy: số đơn / vé, hoàn 100%, đơn chờ thanh toán không bị trừ tiền; chưa bán → null", () => {
    expect(impactLabel({ activeBookings: 0, soldSeats: 0 })).toContain("chưa có vé");
    expect(impactLabel({ activeBookings: 2, soldSeats: 3 })).toBe("2 đơn (3 vé) sẽ nhận thông báo thay đổi qua email.");
    expect(cancelSummary({ activeBookings: 0, soldSeats: 0, pendingBookings: 0, refundOnCancel: 0 })).toBeNull();
    expect(cancelSummary({ activeBookings: 2, soldSeats: 3, pendingBookings: 1, refundOnCancel: 900_000 })).toBe(
      "3 vé của 2 đơn sẽ bị hủy và hoàn toàn bộ 900.000 ₫ cho khách; 1 đơn đang chờ thanh toán sẽ bị hủy (khách không bị trừ tiền). Mọi khách bị ảnh hưởng nhận thông báo kèm lý do."
    );
  });

  it("câu lỗi: xe thiếu chỗ đã bán nêu mã chỗ; không đổi gì; xe trùng lịch; dữ liệu sai", () => {
    expect(describeTripChangeError(new ApiError(409, "TRIP_SEATS_UNMAPPABLE", "x", ["A1", "A2"]))).toBe("Xe mới không có đúng chỗ (cùng mã, cùng loại) cho A1, A2. Chọn xe khác.");
    expect(describeTripChangeError(new ApiError(422, "TRIP_CHANGE_EMPTY", "x"))).toContain("Chưa có thay đổi");
    expect(describeTripChangeError(new ApiError(409, "VEHICLE_SCHEDULE_CONFLICT", "x"))).toContain("chồng giờ");
    expect(describeTripChangeError(new ApiError(400, "BAD_REQUEST", "x"))).toContain("lý do 3–500 ký tự");
    expect(describeTripChangeError(new Error("offline"))).toContain("kết nối");
  });
});
