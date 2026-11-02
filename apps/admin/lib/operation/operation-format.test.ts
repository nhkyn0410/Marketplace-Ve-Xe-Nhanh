import { describe, expect, it } from "vitest";

import { dayLabel, distanceLabel, durationLabel, fillLabel, provincePair, ratingLabel, shortProvince, tripTime } from "./operation-format";

describe("operation-format (giám sát tuyến / chuyến của Admin)", () => {
  it("giờ chuyến theo giờ Việt Nam, ngày dd/mm/yyyy", () => {
    expect(tripTime("2026-10-27T23:30:00.000Z")).toBe("06:30 · 28/10/2026");
    expect(dayLabel("2026-10-05")).toBe("05/10/2026");
  });

  it("quãng đường, thời gian chạy", () => {
    expect(distanceLabel(850)).toBe("850 m");
    expect(distanceLabel(312_400)).toBe("312 km");
    expect(durationLabel(45 * 60)).toBe("45 phút");
    expect(durationLabel(7 * 3600)).toBe("7 giờ");
    expect(durationLabel(7.5 * 3600)).toBe("7 giờ 30 phút");
  });

  it("lấp đầy, điểm đánh giá, cặp tỉnh", () => {
    expect(fillLabel(12, 40)).toBe("30,0%");
    expect(fillLabel(0, 0)).toBe("—");
    expect(ratingLabel(null, 0)).toBe("Chưa có");
    expect(ratingLabel(4.6, 1200)).toBe("4,6 (1.200)");
    expect(shortProvince("Thành phố Hồ Chí Minh")).toBe("TP. Hồ Chí Minh");
    expect(provincePair({ name: "Thành phố Hồ Chí Minh" }, { name: "Tỉnh Lâm Đồng" })).toBe("TP. Hồ Chí Minh → Lâm Đồng");
    expect(provincePair(null, { name: "Tỉnh Lâm Đồng" })).toBe("—");
  });
});
