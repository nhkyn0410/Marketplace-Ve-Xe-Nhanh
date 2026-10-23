import { describe, expect, it } from "vitest";

import { cancelRate, countLabel, monthToDate, percentLabel, validRange } from "./report-format";

describe("report-format (RPT-001)", () => {
  it("phần trăm một chữ số thập phân kiểu Việt; mẫu số 0 → —", () => {
    expect(percentLabel(1648, 2100)).toBe("78,5%");
    expect(percentLabel(0, 0)).toBe("—");
    expect(countLabel(1648)).toBe("1.648");
    expect(cancelRate({ ticketsSold: 97, cancelledTickets: 3 })).toBe("3,0%");
  });

  it("đầu tháng tới hôm nay theo giờ VN (23:30 UTC ngày 31 = ngày 1 tháng sau)", () => {
    expect(monthToDate(new Date("2026-10-13T03:00:00Z"))).toEqual({ from: "2026-10-01", to: "2026-10-13" });
    expect(monthToDate(new Date("2026-10-31T23:30:00Z"))).toEqual({ from: "2026-11-01", to: "2026-11-01" });
  });

  it("khoảng ngày: đầu ≤ cuối, tối đa 366 ngày", () => {
    expect(validRange("2026-10-01", "2026-10-13")).toBe(true);
    expect(validRange("2026-10-14", "2026-10-13")).toBe(false);
    expect(validRange("2025-01-01", "2026-10-13")).toBe(false);
    expect(validRange("2026-10-01", "")).toBe(false);
  });
});
