import { describe, expect, it } from "vitest";

import { capLabel, discountLabel, fromLocalInput, minOrderLabel, toLocalInput, usageLabel, windowLabel } from "./promotion-format";

describe("promotion-format (PROM-001)", () => {
  it("mức giảm, điều kiện đơn, lượt dùng, giới hạn", () => {
    expect(discountLabel({ discountType: "PERCENT", discountValue: 10, maxDiscount: 50_000 })).toBe("10%, tối đa 50.000 ₫");
    expect(discountLabel({ discountType: "AMOUNT", discountValue: 30_000, maxDiscount: null })).toBe("30.000 ₫");
    expect(minOrderLabel(0)).toBe("Không yêu cầu");
    expect(minOrderLabel(300_000)).toBe("Đơn từ 300.000 ₫");
    expect(usageLabel(2840, 10_000)).toBe("2.840 / 10.000");
    expect(capLabel(20, 100_000)).toBe("20% hoặc 100.000 ₫");
    expect(capLabel(null, null)).toBe("—");
  });

  it("hiệu lực theo giờ VN; khác năm thì ghi năm ở đầu", () => {
    expect(windowLabel("2026-09-30T17:00:00Z", "2026-12-31T16:59:00Z")).toBe("01/10 – 31/12/2026");
    expect(windowLabel("2026-12-31T17:00:00Z", "2027-02-05T10:00:00Z")).toBe("01/01 – 05/02/2027");
    expect(windowLabel("2026-12-20T03:00:00Z", "2027-01-05T03:00:00Z")).toBe("20/12/2026 – 05/01/2027");
    expect(toLocalInput("2026-09-30T17:00:00Z")).toBe("2026-10-01T00:00");
    expect(fromLocalInput("2026-10-01T00:00")).toBe("2026-10-01T00:00:00+07:00");
  });
});
