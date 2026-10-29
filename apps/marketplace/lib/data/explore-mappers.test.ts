import { describe, expect, it } from "vitest";
import { exploreAreas, exploreRoutes, rankOperators, resolveExploreJourney, routeKey, servedRoute } from "./explore-mappers";
import type { FeaturedOperatorItem } from "./types";

const route = (from: string, to: string) => ({
  originProvinceId: from, destinationProvinceId: to, originName: from.toUpperCase(), destinationName: to.toUpperCase(), label: `${from} → ${to}`
});
const operator = (id: string, rating: number | null, reviewCount: number, routes: ReturnType<typeof route>[]): FeaturedOperatorItem => ({
  id, name: id, shortCode: id.slice(0, 2), rating, ratingCountText: "", reviewCount, popularRoutesText: "", routes
});

describe("trang Khám phá", () => {
  it("hành trình: URL → lần tìm gần nhất → tuyến phổ biến; ngày đã qua thì lấy nguồn sau, cuối cùng là ngày mai", () => {
    const read = (values: Record<string, string>) => (key: string) => values[key];
    const today = "2026-10-30";
    const saved = read({ origin: "w1", originType: "ward", originLabel: "Phường A", destination: "p2", date: "2026-11-02", passengers: "3" });
    const popular = read({ origin: "p1", destination: "p3", date: "2026-10-31" });
    expect(resolveExploreJourney([null, saved, popular], today)).toMatchObject({
      origin: "w1", originType: "ward", destination: "p2", destinationType: "province", date: "2026-11-02", passengers: 3
    });
    // Ngày trong cookie đã qua → ngày của nguồn sau (tuyến phổ biến), điểm vẫn của lần tìm gần nhất.
    expect(resolveExploreJourney([read({ origin: "a", destination: "b", date: "2026-10-01" }), popular], today)).toMatchObject({
      origin: "a", date: "2026-10-31", passengers: 1
    });
    expect(resolveExploreJourney([read({ origin: "a", destination: "b" })], today)?.date).toBe("2026-10-31");
    expect(resolveExploreJourney([null, read({ origin: "a" })], today)).toBeNull();
  });

  it("nhà xe: đánh giá cao trước, cùng điểm thì nhiều đánh giá trước, chưa có đánh giá xuống cuối", () => {
    const ranked = rankOperators([operator("none", null, 0, []), operator("few", 4.8, 3, []), operator("many", 4.8, 90, []), operator("top", 4.9, 1, [])]);
    expect(ranked.map((item) => item.id)).toEqual(["top", "many", "few", "none"]);
  });

  it("tuyến phục vụ khớp khu vực + tuyến; tuyến không qua khu vực thì bỏ lọc tuyến", () => {
    const op = operator("x", null, 0, [route("hcm", "lam"), route("hcm", "kh")]);
    expect(servedRoute(op)?.label).toBe("hcm → lam");
    expect(servedRoute(op, "kh")?.label).toBe("hcm → kh");
    expect(servedRoute(op, undefined, "hcm>kh")?.label).toBe("hcm → kh");
    expect(servedRoute(op, "lam", "hcm>kh")?.label).toBe("hcm → lam");
    expect(servedRoute(op, "hn")).toBeNull();
    expect(servedRoute(operator("empty", null, 0, []))).toBeNull();
    expect(routeKey(route("a", "b"))).toBe("a>b");
  });

  it("khu vực và tuyến để lọc: gộp trùng, sắp theo tên; tuyến chỉ lấy tuyến qua khu vực", () => {
    const operators = [operator("a", null, 0, [route("hcm", "lam"), route("hcm", "kh")]), operator("b", null, 0, [route("hcm", "lam")])];
    expect(exploreAreas(operators).map((area) => area.id)).toEqual(["hcm", "kh", "lam"]);
    expect(exploreRoutes(operators).map((item) => item.key)).toEqual(["hcm>kh", "hcm>lam"]);
    expect(exploreRoutes(operators, "lam").map((item) => item.key)).toEqual(["hcm>lam"]);
  });
});
