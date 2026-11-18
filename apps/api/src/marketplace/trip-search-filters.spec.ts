import { describe, expect, it } from "vitest";
import { TripSearchQuerySchema, type TripSearchItem } from "./dto/public-trip.dto";
import { matchesFilters, pointFacet } from "./trip-search.service";

// FR-MKT-03 (PASSENGER-PARITY giai đoạn 4): lọc theo điểm đón / trả và điểm đánh giá nhà xe.
function item(pickup: string, dropoff: string, averageRating: number | null): TripSearchItem {
  return {
    operator: { id: "11111111-1111-4111-8111-111111111111", name: "Nhà xe", slug: "nha-xe", averageRating, reviewCount: averageRating === null ? 0 : 5 },
    vehicleType: { name: "Giường", form: "SLEEPER", class: "STANDARD" },
    pickup: { sequence: 1, name: pickup, address: "", plannedAt: "2026-11-20T01:00:00.000Z" },
    dropoff: { sequence: 3, name: dropoff, address: "", plannedAt: "2026-11-20T06:00:00.000Z" },
    minPrice: 300_000,
    amenities: [],
  } as unknown as TripSearchItem;
}

describe("lọc kết quả tìm chuyến", () => {
  it("theo tên điểm đón / trả và điểm đánh giá tối thiểu; nhà xe chưa có đánh giá bị loại khi lọc đánh giá", () => {
    const query = TripSearchQuerySchema.parse({ pickupPoint: "Bến xe Miền Đông", dropoffPoint: "Bến xe Đà Lạt", minRating: "4" });
    expect(matchesFilters(item("Bến xe Miền Đông", "Bến xe Đà Lạt", 4.5), query)).toBe(true);
    expect(matchesFilters(item("Bến xe Miền Tây", "Bến xe Đà Lạt", 4.5), query)).toBe(false);
    expect(matchesFilters(item("Bến xe Miền Đông", "Bến xe Bảo Lộc", 4.5), query)).toBe(false);
    expect(matchesFilters(item("Bến xe Miền Đông", "Bến xe Đà Lạt", 3.9), query)).toBe(false);
    expect(matchesFilters(item("Bến xe Miền Đông", "Bến xe Đà Lạt", null), query)).toBe(false);
    expect(matchesFilters(item("Bến xe Miền Tây", "Bến xe Bảo Lộc", null), TripSearchQuerySchema.parse({}))).toBe(true);
  });

  it("điểm đánh giá ngoài 1–5 bị từ chối", () => {
    expect(TripSearchQuerySchema.safeParse({ minRating: "6" }).success).toBe(false);
    expect(TripSearchQuerySchema.safeParse({ minRating: "0" }).success).toBe(false);
  });

  it("facet điểm đón / trả: gộp theo tên, nhiều chuyến trước", () => {
    expect(pointFacet(["B", "A", "B", "C", "A", "B"])).toEqual([
      { name: "B", count: 3 },
      { name: "A", count: 2 },
      { name: "C", count: 1 },
    ]);
  });
});
