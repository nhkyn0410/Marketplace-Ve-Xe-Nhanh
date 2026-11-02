import { describe, expect, it } from "vitest";

import { formatVnd } from "../fare/fare-format";
import { periodLabel, periodNote, rateLabel, refundAdjustment, signedVnd, tripProgress } from "./finance-format";

describe("finance-format (OPR-002)", () => {
  it("dòng chuyến: chưa khởi hành / đang chạy / đến nơi ngày (giờ VN)", () => {
    const trip = { tripId: "t", routeName: "R", departureAt: "2031-08-01T15:30:00Z", arrivalAt: "2031-08-01T22:30:00Z" };
    expect(tripProgress(trip, new Date("2031-08-01T10:00:00Z"))).toBe("Chưa khởi hành");
    expect(tripProgress(trip, new Date("2031-08-01T20:00:00Z"))).toBe("Đang chạy");
    expect(tripProgress(trip, new Date("2031-08-03T00:00:00Z"))).toBe("Đến nơi 02/08");
  });

  it("kỳ: nhãn ngày, dòng phụ chuyến đến nơi trước ngày kỳ − T", () => {
    expect(periodLabel("2026-10-13")).toBe("13/10/2026");
    expect(periodNote("2026-10-13", 3)).toBe("Chuyến đến nơi trước 10/10");
  });

  it("hoa hồng theo ‱; tiền âm có dấu trừ; hoàn / điều chỉnh = −hoàn + điều chỉnh", () => {
    expect(rateLabel(500)).toBe("5%");
    expect(rateLabel(450)).toBe("4,5%");
    expect(rateLabel(null)).toBe("");
    expect(signedVnd(-28_000, formatVnd)).toBe(`-${formatVnd(28_000)}`);
    expect(signedVnd(0, formatVnd)).toBe(formatVnd(0));
    expect(refundAdjustment({ refundAmount: 160_000, adjustmentAmount: 0 })).toBe(-160_000);
  });
});
