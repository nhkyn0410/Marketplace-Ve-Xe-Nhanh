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
});
