import { describe, expect, it } from "vitest";

import {
  arrivalDayNote,
  formatDay,
  formatTime,
  formatWeekdayDate,
  fromLocalParts,
  nextLocalDate,
  seatCountLabel,
  stopMetaLabel,
  todayLocalDate,
  toLocalParts,
  TRIP_SEAT_STATUS,
  TRIP_SEAT_STATUS_ORDER,
  TRIP_STATUS,
  TRIP_STATUS_ORDER,
  tripDurationLabel,
  tripHeadline
} from "./trip-format";

describe("giờ Việt Nam ↔ ISO", () => {
  it("đổi mốc UTC sang ngày + giờ trên đồng hồ Việt Nam, kể cả khi sang ngày", () => {
    expect(toLocalParts("2026-10-07T23:00:00.000Z")).toEqual({ date: "2026-10-08", time: "06:00" });
    expect(toLocalParts("2026-10-08T04:30:00.000Z")).toEqual({ date: "2026-10-08", time: "11:30" });
    // 17:00 UTC là 00:00 hôm sau ở Việt Nam; cuối năm thì sang cả năm.
    expect(toLocalParts("2026-12-31T17:00:00.000Z")).toEqual({ date: "2027-01-01", time: "00:00" });
  });

  it("ghép ngày + giờ thành ISO có múi giờ +07:00 và đổi ngược lại ra đúng giá trị cũ", () => {
    const iso = fromLocalParts("2026-10-08", "06:00");
    expect(iso).toBe("2026-10-08T06:00:00+07:00");
    expect(new Date(iso).toISOString()).toBe("2026-10-07T23:00:00.000Z");
    expect(toLocalParts(iso)).toEqual({ date: "2026-10-08", time: "06:00" });
  });

  it("ngày hôm nay và ngày liền sau tính theo giờ Việt Nam", () => {
    // 18:30 UTC ngày 07 đã là 01:30 ngày 08 ở Việt Nam.
    expect(todayLocalDate(new Date("2026-10-07T18:30:00.000Z"))).toBe("2026-10-08");
    expect(nextLocalDate("2026-10-08")).toBe("2026-10-09");
    expect(nextLocalDate("2026-12-31")).toBe("2027-01-01");
    expect(nextLocalDate("2028-02-28")).toBe("2028-02-29");
  });
});

describe("chữ hiển thị ngày giờ", () => {
  const departure = "2026-10-08T06:00:00+07:00";

  it("giờ, ngày, thứ + ngày", () => {
    expect(formatTime(departure)).toBe("06:00");
    expect(formatDay(departure)).toBe("08/10/2026");
    expect(formatWeekdayDate(departure)).toBe("Thứ Năm, 08/10/2026");
    expect(formatWeekdayDate("2026-10-11T00:00:00+07:00")).toBe("Chủ Nhật, 11/10/2026");
  });

  it("dòng dưới giờ đến: cùng ngày hoặc ghi ngày đến", () => {
    expect(arrivalDayNote(departure, "2026-10-08T11:30:00+07:00")).toBe("Cùng ngày");
    expect(arrivalDayNote("2026-10-08T22:00:00+07:00", "2026-10-09T05:30:00+07:00")).toBe("Thứ Sáu, 09/10/2026");
  });

  it("thời lượng và số chỗ", () => {
    expect(tripDurationLabel(departure, "2026-10-08T11:30:00+07:00")).toBe("5 giờ 30 phút");
    expect(tripDurationLabel("2026-10-08T22:00:00+07:00", "2026-10-09T05:30:00+07:00")).toBe("7 giờ 30 phút");
    expect(seatCountLabel(34)).toBe("34 chỗ");
  });

  it("dòng tiêu đề phụ của trang chi tiết", () => {
    const trip = { departureAt: "2026-10-08T08:30:00+07:00", arrivalAt: "2026-10-08T14:00:00+07:00" };
    expect(tripHeadline(trip, "51B-377.60")).toBe(
      "Khởi hành 08:30 Thứ Năm, 08/10/2026 · đến 14:00 cùng ngày · xe 51B-377.60"
    );
    expect(tripHeadline({ ...trip, arrivalAt: "2026-10-09T01:00:00+07:00" }, null)).toBe(
      "Khởi hành 08:30 Thứ Năm, 08/10/2026 · đến 01:00 Thứ Sáu, 09/10/2026 · chưa gắn xe"
    );
  });
});

describe("stopMetaLabel (BR-79)", () => {
  it.each([
    [{ type: "BUS_STATION", role: "ORIGIN", allowPickup: true, allowDropoff: false }, "Bến xe · Điểm đầu · Cho đón"],
    [{ type: "BUS_STATION", role: "DESTINATION", allowPickup: false, allowDropoff: true }, "Bến xe · Điểm cuối · Cho trả"],
    [
      { type: "REST_STOP", role: "INTERMEDIATE", allowPickup: false, allowDropoff: false },
      "Trạm dừng nghỉ · Không đón trả khách"
    ],
    [
      { type: "OFFICE", role: "INTERMEDIATE", allowPickup: true, allowDropoff: true },
      "Văn phòng trung chuyển · Cho đón và trả"
    ],
    [
      { type: "PICKUP_POINT", role: "INTERMEDIATE", allowPickup: false, allowDropoff: true },
      "Điểm dừng đón trả khách · Cho trả"
    ]
  ] as const)("%j → %s", (stop, expected) => {
    expect(stopMetaLabel(stop)).toBe(expected);
  });
});

describe("nhãn trạng thái", () => {
  it("đủ nhãn cho mọi trạng thái chuyến và chỗ, thứ tự lọc không sót không lặp", () => {
    expect([...TRIP_STATUS_ORDER].sort()).toEqual(Object.keys(TRIP_STATUS).sort());
    expect([...TRIP_SEAT_STATUS_ORDER].sort()).toEqual(Object.keys(TRIP_SEAT_STATUS).sort());
    expect(TRIP_STATUS.DRAFT).toEqual({ label: "Nháp", tone: "neutral" });
    expect(TRIP_STATUS.OPEN_FOR_SALE.label).toBe("Đang mở bán");
    expect(TRIP_STATUS.LOCKED).toEqual({ label: "Tạm dừng bán", tone: "warning" });
    expect(TRIP_STATUS.CANCELLED).toEqual({ label: "Đã hủy", tone: "danger" });
  });
});
