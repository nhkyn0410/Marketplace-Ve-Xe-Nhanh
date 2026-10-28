import { describe, expect, it } from "vitest";
import type { components } from "@vexenhanh/api-client";
import { apiMoney, initialPlace, mapTripDetail, placeSearchParams, placeType, searchQuery } from "./trip-mappers";

describe("API trip boundary", () => {
  it("rejects lossy/fractional amounts and converts safe VND integers without float arithmetic", () => {
    expect(apiMoney(9007199254740991)).toBe("9007199254740991");
    for (const amount of [9007199254740992, 1.2, -1, NaN]) expect(() => apiMoney(amount)).toThrow();
  });

  it("maps search names, price strings and supported enum values to the API query", () => {
    expect(Object.fromEntries(searchQuery({ origin: "from", destination: "to", date: "2026-10-22", passengers: 2,
      minPriceVnd: "100000", maxPriceVnd: "9007199254740991", seatType: "sleeper", vehicleType: "limousine",
      timeRange: "18-24", sortBy: "price_asc" }))).toMatchObject({
      fromProvinceId: "from", toProvinceId: "to", date: "2026-10-22", passengers: "2", priceMin: "100000",
      priceMax: "9007199254740991", vehicleForm: "SLEEPER", vehicleClass: "LIMOUSINE", sort: "price",
      departureFrom: "18:00", departureTo: "23:59"
    });
  });

  it("điểm đi / đến theo loại: phường → fromWardId / toWardId, địa danh → StopPointId; thiếu hoặc lạ → tỉnh", () => {
    const query = searchQuery({ origin: "w1", originType: "ward", destination: "s1", destinationType: "stopPoint", date: "2026-10-22" });
    expect(query.get("fromWardId")).toBe("w1");
    expect(query.get("toStopPointId")).toBe("s1");
    expect(query.has("fromProvinceId")).toBe(false);
    expect(placeType("ward")).toBe("ward");
    expect(placeType("district")).toBe("province");
    expect(placeType(undefined)).toBe("province");
  });

  it("URL của điểm: tỉnh không ghi loại; phường / địa danh ghi loại + tên; link cũ chỉ có id tỉnh lấy tên từ danh sách", () => {
    expect(placeSearchParams("origin", { type: "province", id: "p1", label: "Lâm Đồng" })).toEqual({ origin: "p1", originLabel: "Lâm Đồng" });
    expect(placeSearchParams("destination", { type: "ward", id: "w1", label: "Phường Thắng Tam" })).toEqual({
      destination: "w1", destinationType: "ward", destinationLabel: "Phường Thắng Tam"
    });
    expect(initialPlace("p1", undefined, undefined, [{ id: "p1", name: "Lâm Đồng" }])).toEqual({ type: "province", id: "p1", label: "Lâm Đồng" });
    expect(initialPlace("w1", "ward", "Phường A", [])).toEqual({ type: "ward", id: "w1", label: "Phường A" });
    expect(initialPlace(undefined, "ward", "x", [])).toBeNull();
  });

  it("keeps unavailable seats ambiguous, picks the lowest server price with BigInt, and keeps absent prices empty", () => {
    const trip: components["schemas"]["PublicTripDto_Output"] = {
      tripId: "trip", operator: { id: "operator", name: "Nhà xe", slug: "nha-xe", hotline: null, averageRating: null, reviewCount: 0 }, routeName: "A → B",
      departureAt: "2026-10-21T18:00:00Z", arrivalAt: "2026-10-21T22:00:00Z", onlineSaleClosesAt: "2026-10-21T17:00:00Z",
      note: null, vehicleType: { name: "Giường nằm", form: "SLEEPER", class: "STANDARD" }, amenities: [], vehicleImages: [],
      stops: [{ sequence: 1, role: "ORIGIN", name: "Bến xe", address: "Địa chỉ", type: "BUS_STATION", latitude: 10.8, longitude: 106.7,
        plannedAt: "2026-10-21T18:00:00Z", pickupWindowStart: null, pickupWindowEnd: null, allowPickup: true, allowDropoff: false, note: null }],
      seats: [ { code: "A1", deck: 1, row: 1, column: 1, type: "BED", status: "AVAILABLE", price: 300000 },
        { code: "A2", deck: 1, row: 1, column: 2, type: "BED", status: "UNAVAILABLE", price: 200000 } ],
      cancellationPolicy: { tiers: [{ minHoursBefore: 24, refundPercent: 80 }] }
    };
    const mapped = mapTripDetail(trip);
    expect(mapped.priceSingleVnd).toBe("300000");
    expect(mapped.priceDoubleVnd).toBe("");
    expect(mapped.seatMap[1]?.status).toBe("unavailable");
    expect(mapped.cancellationPolicies[0]?.refundPercentText).toBe("80%");
    expect(mapped.departureTime).toBe("01:00");
    expect(mapped.timeline[0]).toMatchObject({ lat: 10.8, lng: 106.7, isRestStop: false, badges: ["Đón khách"] });
    expect(mapTripDetail({ ...trip, seats: [] }).priceSingleVnd).toBe("");
  });
});
