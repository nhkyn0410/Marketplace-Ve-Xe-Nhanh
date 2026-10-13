import { describe, expect, it } from "vitest";

import {
  formatDateTime,
  formatDistance,
  formatDuration,
  legLabel,
  ROUTE_STATUS,
  stopCountLabel
} from "./route-format";

describe("formatDistance", () => {
  it.each([
    [308_000, "308 km"],
    [61_600, "62 km"],
    [10_000, "10 km"],
    [9_940, "9,9 km"],
    [2_640, "2,6 km"],
    [400, "0,4 km"],
    [0, "0 km"]
  ])("%i m → %j", (meters, expected) => {
    expect(formatDistance(meters)).toBe(expected);
  });
});

describe("formatDuration", () => {
  it.each([
    [25_800, "7 giờ 10 phút"],
    [14_700, "4 giờ 05 phút"],
    [10_800, "3 giờ"],
    [1_500, "25 phút"],
    [3_590, "1 giờ"],
    [0, "0 phút"]
  ])("%i giây → %j", (seconds, expected) => {
    expect(formatDuration(seconds)).toBe(expected);
  });
});

describe("nhãn tuyến", () => {
  it("dòng số liệu chặng và số điểm dừng", () => {
    expect(legLabel(62_000, 5_100)).toBe("62 km · 1 giờ 25 phút");
    expect(stopCountLabel(5)).toBe("5 điểm");
  });

  it("trạng thái luôn kèm chữ", () => {
    expect(ROUTE_STATUS.ACTIVE).toEqual({ label: "Hoạt động", tone: "success" });
    expect(ROUTE_STATUS.INACTIVE).toEqual({ label: "Ngừng dùng", tone: "neutral" });
  });

  it("ngày giờ theo giờ Việt Nam", () => {
    expect(formatDateTime("2026-10-05T07:20:00.000Z")).toBe("05/10/2026 14:20");
    expect(formatDateTime("2026-10-05T17:05:00.000Z")).toBe("06/10/2026 00:05");
  });
});
