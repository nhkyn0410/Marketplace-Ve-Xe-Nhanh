import { describe, expect, it } from "vitest";

import { ApiError } from "../auth/api-client";
import {
  describeScheduleSaveError,
  emptyScheduleValues,
  matchingDates,
  notOpenedLabel,
  scheduleSchema,
  scheduleState,
  shortDayLabel,
  toScheduleFormValues,
  toScheduleInput,
  weekdaysLabel,
  type ScheduleFormValues
} from "./trip-schedule-form";

const today = "2026-10-17";
const valid: ScheduleFormValues = {
  ...emptyScheduleValues(today),
  routeId: "route-1",
  departureTime: "22:30",
  daysOfWeek: [5, 1, 3],
  startDate: "2026-10-19",
  endDate: "2026-11-01",
  note: "  Chạy cố định  "
};

describe("form lịch chạy lặp lại (TRN-007)", () => {
  it("mặc định: hằng ngày, từ hôm nay 30 ngày, ngừng bán 60 phút, chưa gắn xe", () => {
    expect(emptyScheduleValues(today)).toMatchObject({
      daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
      startDate: "2026-10-17",
      endDate: "2026-11-15",
      onlineSaleCutoffMinutes: "60",
      vehicleId: "NONE"
    });
  });

  it("body API: không gửi thời gian chạy (máy chủ lấy theo tuyến), thứ sắp tăng dần, chưa gắn xe → null, ghi chú cắt khoảng trắng", () => {
    expect(toScheduleInput(valid)).toEqual({
      routeId: "route-1",
      vehicleId: null,
      departureTime: "22:30",
      daysOfWeek: [1, 3, 5],
      startDate: "2026-10-19",
      endDate: "2026-11-01",
      onlineSaleCutoffMinutes: 60,
      note: "Chạy cố định"
    });
  });

  it("đọc lại lịch đã lưu ra giá trị form", () => {
    const values = toScheduleFormValues({
      id: "s",
      routeId: "r",
      routeName: "SG - ĐL",
      vehicleId: "v",
      vehiclePlateNumber: "51B37760",
      departureTime: "06:00",
      durationMinutes: 330,
      daysOfWeek: [6, 7],
      startDate: "2026-10-19",
      endDate: "2026-11-30",
      onlineSaleCutoffMinutes: 30,
      note: null,
      tripCount: 4,
      lastGeneratedAt: null,
      createdAt: "2026-10-17T00:00:00.000Z",
      updatedAt: "2026-10-17T00:00:00.000Z"
    });
    expect(values).toMatchObject({ vehicleId: "v", onlineSaleCutoffMinutes: "30", note: "" });
  });

  it("validate: thiếu thứ, kết thúc trước bắt đầu, quá 93 ngày, đã qua, số phút ngừng bán sai", () => {
    const schema = scheduleSchema(today);
    expect(schema.safeParse(valid).success).toBe(true);
    const issueOf = (overrides: Partial<ScheduleFormValues>) => {
      const result = schema.safeParse({ ...valid, ...overrides });
      return result.success ? null : result.error.issues[0]!.path[0];
    };
    expect(issueOf({ daysOfWeek: [] })).toBe("daysOfWeek");
    expect(issueOf({ endDate: "2026-10-18" })).toBe("endDate");
    expect(issueOf({ endDate: "2027-01-21" })).toBe("endDate");
    expect(issueOf({ startDate: "2026-10-01", endDate: "2026-10-10" })).toBe("endDate");
    expect(issueOf({ onlineSaleCutoffMinutes: "1441" })).toBe("onlineSaleCutoffMinutes");
    expect(issueOf({ routeId: "" })).toBe("routeId");
  });

  it("ngày sẽ sinh: đúng thứ, gồm hai đầu; khoảng sai → không ngày nào", () => {
    // 19/10/2026 là thứ Hai.
    expect(matchingDates(valid)).toEqual(["2026-10-19", "2026-10-21", "2026-10-23", "2026-10-26", "2026-10-28", "2026-10-30"]);
    expect(matchingDates({ ...valid, endDate: "2026-10-18" })).toEqual([]);
    expect(shortDayLabel("2026-10-25")).toBe("CN, 25/10");
  });

  it("nhãn thứ, trạng thái lịch, lý do chưa mở bán, lỗi lưu", () => {
    expect(weekdaysLabel([1, 2, 3, 4, 5, 6, 7])).toBe("Hằng ngày");
    expect(weekdaysLabel([5, 4, 3, 2, 1])).toBe("T2 – T6");
    expect(weekdaysLabel([7, 6])).toBe("T7, CN");
    expect(scheduleState({ startDate: "2026-10-01", endDate: "2026-10-16" }, today).label).toBe("Đã hết hạn");
    expect(scheduleState({ startDate: "2026-10-18", endDate: "2026-11-16" }, today).label).toBe("Sắp áp dụng");
    expect(scheduleState({ startDate: "2026-10-17", endDate: "2026-10-17" }, today).label).toBe("Đang áp dụng");
    expect(notOpenedLabel(["VEHICLE_MISSING", "FARE_MISSING"])).toBe("chưa gắn xe, tuyến chưa có bảng giá đang áp dụng");
    expect(describeScheduleSaveError(new ApiError(422, "ROUTE_UNAVAILABLE", "x")).field).toBe("routeId");
    expect(describeScheduleSaveError(new Error("mạng")).field).toBeNull();
  });
});
