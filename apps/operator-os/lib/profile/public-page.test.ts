import { afterEach, describe, expect, it, vi } from "vitest";

import { operatorPageUrl, previewMetrics, rateText } from "./public-page";

const OPERATOR_ID = "8f0b6f3e-2c1d-4f7a-9b8e-1a2b3c4d5e6f";

describe("trang công khai của nhà xe", () => {
  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it("link tới /operators/{id} của web khách hàng theo NEXT_PUBLIC_MARKETPLACE_URL (bỏ `/` cuối)", () => {
    vi.stubEnv("NEXT_PUBLIC_MARKETPLACE_URL", " https://vexenhanh.example/ ");
    expect(operatorPageUrl(OPERATOR_ID)).toBe(`https://vexenhanh.example/operators/${OPERATOR_ID}`);
  });

  it("thiếu biến: dev dùng web khách hàng ở cổng 3001; bản build production → null (nút tắt)", () => {
    vi.stubEnv("NEXT_PUBLIC_MARKETPLACE_URL", "");
    vi.stubEnv("NODE_ENV", "development");
    expect(operatorPageUrl(OPERATOR_ID)).toBe(`http://localhost:3001/operators/${OPERATOR_ID}`);
    vi.stubEnv("NODE_ENV", "production");
    expect(operatorPageUrl(OPERATOR_ID)).toBeNull();
  });

  it("chỉ số như trang nhà xe: tỉ lệ một chữ số thập phân, thiếu dữ liệu ghi rõ", () => {
    expect(rateText(0.0123)).toBe("1.2%");
    expect(rateText(null)).toBe("Chưa có dữ liệu");
    expect(
      previewMetrics({
        averageRating: 4.567,
        reviewCount: 12,
        operatorCancellationRate: 0,
        refundBookingRate: 0.05,
        disputeBookingRate: null,
        checkInRate: null,
        noShowRate: null
      })
    ).toEqual([
      { label: "Đánh giá trung bình", value: "4.6", note: "12 đánh giá" },
      { label: "Hủy chuyến do nhà xe", value: "0.0%" },
      { label: "Đơn có hoàn tiền / tranh chấp", value: "5.0% / Chưa có dữ liệu" },
      { label: "Tỷ lệ check-in", value: "Chưa có dữ liệu" }
    ]);
    const empty = {
      averageRating: null,
      reviewCount: 0,
      operatorCancellationRate: null,
      refundBookingRate: null,
      disputeBookingRate: null,
      checkInRate: null,
      noShowRate: null
    };
    expect(previewMetrics(empty)[0]).toEqual({ label: "Đánh giá trung bình", value: "—", note: "0 đánh giá" });
  });
});
