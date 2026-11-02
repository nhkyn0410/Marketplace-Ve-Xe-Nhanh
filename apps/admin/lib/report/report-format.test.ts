import { describe, expect, it } from "vitest";

import { compareLabel, dailyBars, lastDays, percentLabel, rangeDays, validRange } from "./report-format";

describe("report-format Admin (RPT-002)", () => {
  it("7 ngày gần nhất tính cả hôm nay theo giờ VN", () => {
    expect(lastDays(7, new Date("2026-10-13T03:00:00Z"))).toEqual({ from: "2026-10-07", to: "2026-10-13" });
    expect(lastDays(7, new Date("2026-10-12T18:00:00Z"))).toEqual({ from: "2026-10-07", to: "2026-10-13" });
    expect(rangeDays("2026-10-07", "2026-10-13")).toBe(7);
  });

  it("khoảng ngày, phần trăm, so sánh kỳ trước", () => {
    expect(validRange("2026-10-07", "2026-10-13")).toBe(true);
    expect(validRange("2026-10-14", "2026-10-13")).toBe(false);
    expect(percentLabel(742, 1000)).toBe("74,2%");
    expect(percentLabel(1, 0)).toBe("—");
    expect(compareLabel(1082, 1000, 7)).toBe("Tăng 8,2% so với 7 ngày trước đó");
    expect(compareLabel(900, 1000, 7)).toBe("Giảm 10,0% so với 7 ngày trước đó");
    expect(compareLabel(5, 0, 7)).toBe("Chưa có giao dịch 7 ngày trước đó");
  });

  it("cột GMV theo ngày: nhãn dd/MM, triệu đồng, chiều cao theo ngày lớn nhất", () => {
    expect(
      dailyBars([
        { date: "2026-10-07", gmv: 612_000_000 },
        { date: "2026-10-08", gmv: 0 },
        { date: "2026-10-09", gmv: 1_224_000_000 },
        { date: "2026-10-10", gmv: 500_000 }
      ])
    ).toEqual([
      { date: "2026-10-07", label: "07/10", value: "612", height: 50 },
      { date: "2026-10-08", label: "08/10", value: "0", height: 0 },
      { date: "2026-10-09", label: "09/10", value: "1.224", height: 100 },
      { date: "2026-10-10", label: "10/10", value: "0,5", height: 2 }
    ]);
  });
});
