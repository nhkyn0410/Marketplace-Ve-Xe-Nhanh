import { describe, expect, it } from "vitest";
import {
  daysBetween,
  daysToMask,
  departureOf,
  maskToDays,
  minuteOfDay,
  scheduleDates,
  timeOfDay,
  todayInVietnam,
} from "./trip-schedule-dates";

describe("lịch chuyến lặp lại — ngày / giờ (TRN-007)", () => {
  it("bitmask thứ trong tuần: thứ Hai = bit 0, Chủ nhật = bit 6; đổi qua lại không mất", () => {
    expect(daysToMask([1])).toBe(1);
    expect(daysToMask([7])).toBe(64);
    expect(daysToMask([1, 3, 5])).toBe(0b10101);
    expect(maskToDays(daysToMask([7, 2, 6]))).toEqual([2, 6, 7]);
    expect(maskToDays(127)).toEqual([1, 2, 3, 4, 5, 6, 7]);
  });

  it("chỉ lấy ngày đúng thứ, gồm cả ngày đầu và ngày cuối", () => {
    // 19/10/2026 là thứ Hai.
    const rule = { startDate: new Date("2026-10-19T00:00:00Z"), endDate: new Date("2026-11-01T00:00:00Z") };
    expect(scheduleDates({ ...rule, daysOfWeek: daysToMask([1, 7]) })).toEqual([
      "2026-10-19",
      "2026-10-25",
      "2026-10-26",
      "2026-11-01",
    ]);
    expect(scheduleDates({ ...rule, daysOfWeek: 127 })).toHaveLength(14);
    expect(scheduleDates({ startDate: rule.startDate, endDate: rule.startDate, daysOfWeek: daysToMask([2]) })).toEqual([]);
  });

  it("giờ khởi hành theo giờ Việt Nam → UTC; chuyến 22:30 vẫn thuộc ngày chạy đã chọn", () => {
    expect(departureOf("2026-10-19", minuteOfDay("06:00")).toISOString()).toBe("2026-10-18T23:00:00.000Z");
    expect(departureOf("2026-10-19", minuteOfDay("22:30")).toISOString()).toBe("2026-10-19T15:30:00.000Z");
    expect(timeOfDay(minuteOfDay("07:05"))).toBe("07:05");
    expect(timeOfDay(0)).toBe("00:00");
  });

  it("hôm nay theo giờ Việt Nam: 17:30 UTC đã sang ngày hôm sau", () => {
    expect(todayInVietnam(new Date("2026-10-17T16:59:00Z"))).toBe("2026-10-17");
    expect(todayInVietnam(new Date("2026-10-17T17:00:00Z"))).toBe("2026-10-18");
    expect(daysBetween("2026-10-19", "2027-01-19")).toBe(92);
  });
});
