import { describe, expect, it, vi } from "vitest";
import type { PrismaService } from "./prisma.service";
import { groupPopularRoutes, type HighlightRouteRow, loadOperatorRatings, shortProvinceName } from "./public-highlights";

const names = new Map([
  ["hcm", "Thành phố Hồ Chí Minh"],
  ["ld", "Tỉnh Lâm Đồng"],
  ["kh", "Tỉnh Khánh Hòa"],
  ["hn", "Thành phố Hà Nội"],
]);

function row(overrides: Partial<HighlightRouteRow>): HighlightRouteRow {
  return {
    routeId: "r",
    operatorId: "op-a",
    originProvinceId: "hcm",
    destinationProvinceId: "ld",
    distanceMeters: 310_000,
    durationSeconds: 27_000,
    prices: [],
    upcomingTrips: 1,
    nextDepartureAt: null,
    vehicleTypeNames: [],
    paidBookings: 0,
    ratings: [],
    ...overrides,
  };
}

describe("shortProvinceName", () => {
  it.each([
    ["Thành phố Hồ Chí Minh", "TP. Hồ Chí Minh"],
    ["Tỉnh Lâm Đồng", "Lâm Đồng"],
    ["Huế", "Huế"],
  ])("%s → %s", (name, expected) => {
    expect(shortProvinceName(name)).toBe(expected);
  });
});

describe("groupPopularRoutes", () => {
  it("gộp tuyến nhiều nhà xe cùng cặp tỉnh: giá thấp nhất (BigInt), quãng ngắn nhất, chuyến sớm nhất, điểm trung bình", () => {
    const [route] = groupPopularRoutes(
      [
        row({ routeId: "a", operatorId: "op-a", prices: [350_000n, 300_000n], nextDepartureAt: new Date("2026-10-28T01:00:00Z"), vehicleTypeNames: ["Limousine"], ratings: [5, 4] }),
        row({ routeId: "b", operatorId: "op-b", distanceMeters: 300_000, durationSeconds: 25_200, prices: [280_000n], nextDepartureAt: new Date("2026-10-27T15:00:00Z"), vehicleTypeNames: ["Giường nằm", "Limousine"], ratings: [5] }),
      ],
      names,
      7,
    );
    expect(route).toEqual({
      originProvinceId: "hcm",
      originName: "TP. Hồ Chí Minh",
      destinationProvinceId: "ld",
      destinationName: "Lâm Đồng",
      distanceMeters: 300_000,
      durationSeconds: 25_200,
      minPrice: 280_000n,
      vehicleTypeNames: ["Giường nằm", "Limousine"],
      nextDepartureAt: new Date("2026-10-27T15:00:00Z"),
      operatorCount: 2,
      averageRating: 4.7,
      reviewCount: 3,
    });
  });

  it("chiều ngược lại là tuyến khác; chưa có bảng giá / đánh giá thì null", () => {
    const routes = groupPopularRoutes([row({}), row({ originProvinceId: "ld", destinationProvinceId: "hcm" })], names, 7);
    expect(routes.map((route) => `${route.originName}>${route.destinationName}`)).toEqual(["Lâm Đồng>TP. Hồ Chí Minh", "TP. Hồ Chí Minh>Lâm Đồng"]);
    expect(routes[0]).toMatchObject({ minPrice: null, averageRating: null, reviewCount: 0 });
  });

  it("bỏ tuyến thiếu tỉnh, đi và đến cùng tỉnh, hoặc tỉnh không còn tên", () => {
    const routes = groupPopularRoutes(
      [row({ originProvinceId: null }), row({ destinationProvinceId: "hcm" }), row({ destinationProvinceId: "unknown" })],
      names,
      7,
    );
    expect(routes).toEqual([]);
  });

  it("xếp theo vé đã bán, rồi số chuyến sắp chạy, rồi tên; cắt theo limit", () => {
    const routes = groupPopularRoutes(
      [
        row({ destinationProvinceId: "ld", paidBookings: 1, upcomingTrips: 1 }),
        row({ destinationProvinceId: "kh", paidBookings: 5, upcomingTrips: 1 }),
        row({ originProvinceId: "hn", destinationProvinceId: "ld", paidBookings: 1, upcomingTrips: 9 }),
        row({ originProvinceId: "hn", destinationProvinceId: "kh", paidBookings: 0, upcomingTrips: 1 }),
      ],
      names,
      3,
    );
    expect(routes.map((route) => `${route.originName}>${route.destinationName}`)).toEqual(["TP. Hồ Chí Minh>Khánh Hòa", "TP. Hà Nội>Lâm Đồng", "TP. Hồ Chí Minh>Lâm Đồng"]);
  });
});

describe("loadOperatorRatings", () => {
  it("chỉ tính đánh giá đang hiển thị, làm tròn 1 chữ số; nhà xe chưa có đánh giá không có trong map; danh sách rỗng không hỏi DB", async () => {
    const groupBy = vi.fn().mockResolvedValue([{ operatorId: "op-a", _avg: { rating: 4.666 }, _count: { id: 3 } }]);
    const prisma = { withSystem: (run: (tx: unknown) => unknown) => run({ review: { groupBy } }) } as unknown as Pick<PrismaService, "withSystem">;

    const ratings = await loadOperatorRatings(prisma, ["op-a", "op-b"]);

    expect(ratings.get("op-a")).toEqual({ averageRating: 4.7, reviewCount: 3 });
    expect(ratings.has("op-b")).toBe(false);
    expect(groupBy).toHaveBeenCalledWith(expect.objectContaining({ where: { status: "VISIBLE", operatorId: { in: ["op-a", "op-b"] } } }));
    expect(await loadOperatorRatings(prisma, [])).toEqual(new Map());
    expect(groupBy).toHaveBeenCalledTimes(1);
  });
});
