import { describe, expect, it } from "vitest";
import type { TripSearchItem } from "./dto/public-trip.dto";
import { compareBy } from "./trip-search.service";

function item(id: string, minPrice: number, averageRating: number | null, reviewCount: number, plannedAt: string): TripSearchItem {
  return {
    tripId: id,
    minPrice,
    durationMinutes: 300,
    pickup: { plannedAt },
    operator: { averageRating, reviewCount },
  } as unknown as TripSearchItem;
}

const trips = [
  item("a", 300_000, 4.2, 10, "2031-05-10T01:00:00.000Z"),
  item("b", 250_000, null, 0, "2031-05-10T02:00:00.000Z"),
  item("c", 350_000, 4.8, 3, "2031-05-10T03:00:00.000Z"),
  item("d", 350_000, 4.2, 25, "2031-05-10T04:00:00.000Z"),
];
const order = (sort: Parameters<typeof compareBy>[0]) => [...trips].sort(compareBy(sort)).map((trip) => trip.tripId);

describe("thứ tự kết quả tìm chuyến", () => {
  it("giá cao trước; bằng giá thì giờ đi sớm trước", () => {
    expect(order("price_desc")).toEqual(["c", "d", "a", "b"]);
  });

  it("đánh giá cao trước, bằng điểm thì nhiều lượt đánh giá trước, chưa có đánh giá xếp cuối", () => {
    expect(order("rating")).toEqual(["c", "d", "a", "b"]);
  });
});
