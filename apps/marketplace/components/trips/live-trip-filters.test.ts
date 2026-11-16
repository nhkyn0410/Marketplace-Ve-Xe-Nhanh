import { createElement } from "react";
import { renderToStaticMarkup } from "react-dom/server";
import { describe, expect, it } from "vitest";
import { LiveTripFilters } from "./live-trip-filters";

const hiddenInputs = (html: string) =>
  Object.fromEntries([...html.matchAll(/<input type="hidden" name="([^"]+)" value="([^"]*)"/g)].map((match) => [match[1], match[2]]));

describe("bộ lọc chuyến (form GET)", () => {
  const query = new URLSearchParams({
    origin: "w1", originType: "ward", originLabel: "Phường Bình Thạnh", destination: "s1", destinationType: "stopPoint",
    destinationLabel: "Bến xe Đà Lạt", date: "2026-10-30", passengers: "2", sortBy: "price_asc", timeRange: "06-12", page: "2"
  }).toString();

  it("Áp dụng giữ nguyên điểm đi / đến kèm loại + tên, bỏ trang và các lọc cũ", () => {
    const html = renderToStaticMarkup(createElement(LiveTripFilters, { query }));
    expect(hiddenInputs(html)).toEqual({
      origin: "w1", originType: "ward", originLabel: "Phường Bình Thạnh", destination: "s1", destinationType: "stopPoint",
      destinationLabel: "Bến xe Đà Lạt", date: "2026-10-30", passengers: "2", sortBy: "price_asc"
    });
  });

  it("Xóa lọc cũng giữ loại + tên điểm", () => {
    const html = renderToStaticMarkup(createElement(LiveTripFilters, { query }));
    const reset = new URLSearchParams(/href="\/trips\?([^"]*)"/.exec(html)?.[1]?.replaceAll("&amp;", "&"));
    expect(reset.get("originType")).toBe("ward");
    expect(reset.get("destinationLabel")).toBe("Bến xe Đà Lạt");
    expect(reset.has("timeRange")).toBe(false);
  });

  it("khung giờ có lựa chọn Tất cả, mặc định chọn khi chưa lọc giờ", () => {
    const html = renderToStaticMarkup(createElement(LiveTripFilters, { query: "origin=a&destination=b" }));
    expect(html).toMatch(/name="timeRange" checked="" value=""/);
  });

  // PASSENGER-PARITY W14 / Q18: lọc Nhà xe + Tiện ích như app.
  describe("nhà xe và tiện ích", () => {
    const operators = [{ id: "op-1", name: "Sao Mai", count: 3 }, { id: "op-2", name: "Thành Bưởi", count: 1 }];
    const amenities = [{ id: "wifi", name: "Wi-Fi" }, { id: "usb", name: "Cổng sạc USB" }, { id: "water", name: "Nước uống" }];
    const filtered = `${query}&operatorId=op-2&amenityIds=wifi,water`;

    it("có danh sách nhà xe: chọn sẵn nhà xe đang lọc, không gửi trùng qua ô ẩn, Xóa lọc bỏ nhà xe + tiện ích", () => {
      const html = renderToStaticMarkup(createElement(LiveTripFilters, { query: filtered, operators, amenities }));
      expect(html).toContain("Tất cả nhà xe");
      expect(html).toMatch(/<option value="op-2" selected="">Thành Bưởi \(1\)<\/option>/);
      expect(hiddenInputs(html)).not.toHaveProperty("operatorId");
      const reset = new URLSearchParams(/href="\/trips\?([^"]*)"/.exec(html)?.[1]?.replaceAll("&amp;", "&"));
      expect(reset.has("operatorId")).toBe(false);
      expect(reset.has("amenityIds")).toBe(false);
      expect(html).toMatch(/name="amenityIds" checked="" value="wifi"/);
      expect(html).toMatch(/name="amenityIds" checked="" value="water"/);
      expect(html).toMatch(/name="amenityIds" value="usb"/);
    });

    it("nhà xe đang lọc không còn chuyến khớp vẫn giữ trong danh sách", () => {
      const html = renderToStaticMarkup(createElement(LiveTripFilters, { query: `${query}&operatorId=op-9`, operators }));
      expect(html).toMatch(/<option value="op-9" selected="">Nhà xe đang chọn \(0\)<\/option>/);
    });

    it("chưa có danh sách nhà xe (tìm lỗi): không hiện nhóm Nhà xe, giữ nhà xe đang lọc qua ô ẩn", () => {
      const html = renderToStaticMarkup(createElement(LiveTripFilters, { query: `${query}&operatorId=op-2` }));
      expect(html).not.toContain("Tất cả nhà xe");
      expect(html).not.toContain("Tiện ích");
      expect(hiddenInputs(html)).toMatchObject({ operatorId: "op-2" });
    });
  });
});
