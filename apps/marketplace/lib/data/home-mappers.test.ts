import { describe, expect, it } from "vitest";
import { formatDurationVi, mapFeaturedOperator, mapPopularRoute, operatorInitials } from "./home-mappers";

const route = {
  originProvinceId: "11111111-1111-4111-8111-111111111111",
  originName: "TP. Hồ Chí Minh",
  destinationProvinceId: "22222222-2222-4222-8222-222222222222",
  destinationName: "Lâm Đồng",
  distanceMeters: 308_400,
  durationSeconds: 25_200,
  minPrice: 280_000,
  vehicleTypeNames: ["Giường nằm", "Limousine"],
  // 23:30 ngày 27/10 giờ UTC = 06:30 ngày 28/10 giờ Việt Nam.
  nextDepartureAt: "2026-10-27T23:30:00.000Z",
  operatorCount: 2,
  averageRating: 4.8,
  reviewCount: 12
};

describe("formatDurationVi", () => {
  it.each([
    [25_200, "7 tiếng"],
    [27_000, "7 tiếng 30 phút"],
    [2_700, "45 phút"]
  ])("%i giây → %s", (seconds, expected) => {
    expect(formatDurationVi(seconds)).toBe(expected);
  });
});

describe("operatorInitials", () => {
  it.each([
    ["Phương Trang", "PT"],
    ["Nhà xe Hà Linh Express", "HL"],
    ["Futa", "FU"]
  ])("%s → %s", (name, expected) => {
    expect(operatorInitials(name)).toBe(expected);
  });
});

describe("mapPopularRoute", () => {
  it("thẻ đầu nổi bật, ảnh theo tỉnh đến, link tìm chuyến đúng ngày (giờ Việt Nam) có chuyến sớm nhất", () => {
    expect(mapPopularRoute(route, 0)).toEqual({
      id: `${route.originProvinceId}>${route.destinationProvinceId}`,
      fromCity: "TP. Hồ Chí Minh",
      toCity: "Lâm Đồng",
      distanceKm: 308,
      durationText: "7 tiếng",
      vehicleTypeText: "Giường nằm & Limousine",
      minPriceVnd: "280000",
      rating: 4.8,
      isFeatured: true,
      imageUrl: "/images/route-sg-dalat.jpg",
      href: `/trips?origin=${route.originProvinceId}&destination=${route.destinationProvinceId}&date=2026-10-28&passengers=1`
    });
  });

  it("chưa có giá / đánh giá / chuyến thì null và dùng ngày hôm nay; tỉnh chưa có ảnh dùng ảnh theo thứ tự", () => {
    const item = mapPopularRoute(
      { ...route, destinationName: "Đắk Lắk", minPrice: null, averageRating: null, nextDepartureAt: null },
      1,
      new Date("2026-10-26T18:00:00Z")
    );
    expect(item).toMatchObject({ isFeatured: false, minPriceVnd: null, rating: null, imageUrl: "/images/route-hn-sapa.jpg" });
    expect(item.href).toContain("date=2026-10-27");
  });
});

describe("mapFeaturedOperator", () => {
  it("viết tắt, logo, số đánh giá, tuyến cho tab Theo nhà xe", () => {
    const item = mapFeaturedOperator(
      { operatorId: "op-1", displayName: "Phương Trang", logoUrl: null, averageRating: null, reviewCount: 0, routes: [route] },
      1
    );
    expect(item).toEqual({
      id: "op-1",
      name: "Phương Trang",
      shortCode: "PT",
      logoUrl: null,
      rating: null,
      ratingCountText: "Chưa có đánh giá",
      reviewCount: 0,
      popularRoutesText: "TP. Hồ Chí Minh → Lâm Đồng",
      accentColor: "#00506A",
      routes: [{
        originProvinceId: route.originProvinceId, destinationProvinceId: route.destinationProvinceId,
        originName: "TP. Hồ Chí Minh", destinationName: "Lâm Đồng", label: "TP. Hồ Chí Minh → Lâm Đồng"
      }]
    });
    const withLogo = mapFeaturedOperator(
      { operatorId: "op-2", displayName: "A B", logoUrl: "https://cdn.test/operator-logos/op-2/logo.png", averageRating: 4.5, reviewCount: 12_840, routes: [] },
      0
    );
    expect(withLogo.ratingCountText).toBe("12.840 đánh giá");
    expect(withLogo.logoUrl).toBe("https://cdn.test/operator-logos/op-2/logo.png");
  });
});
