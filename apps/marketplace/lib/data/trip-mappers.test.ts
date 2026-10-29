import { describe, expect, it } from "vitest";
import type { components } from "@vexenhanh/api-client";
import {
  addDays, apiMoney, initialPlace, mapTripDetail, mapTripSearchItem, placeSearchParams, placeType, priceRange, readTripLeg, samePlace,
  searchQuery, stripDates, tripLegQuery, vnToday
} from "./trip-mappers";

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

  it("khung giờ không chồng nhau ở mốc tròn giờ: 06-12 kết thúc 11:59, 00-06 kết thúc 05:59", () => {
    expect(Object.fromEntries(searchQuery({ origin: "a", destination: "b", timeRange: "06-12" }))).toMatchObject({ departureFrom: "06:00", departureTo: "11:59" });
    expect(Object.fromEntries(searchQuery({ origin: "a", destination: "b", timeRange: "00-06" }))).toMatchObject({ departureFrom: "00:00", departureTo: "05:59" });
  });

  it("khoảng giá: giữ số nguyên VND; giá từ lớn hơn giá đến hoặc không phải số thì bỏ cả hai và báo sai", () => {
    expect(priceRange("100000", "300000")).toEqual({ min: "100000", max: "300000", invalid: false });
    expect(priceRange(" 200000 ", undefined)).toEqual({ min: "200000", max: undefined, invalid: false });
    expect(priceRange("", "")).toEqual({ min: undefined, max: undefined, invalid: false });
    expect(priceRange("500000", "100000")).toEqual({ invalid: true });
    expect(priceRange("1.000", undefined)).toEqual({ invalid: true });
    // So sánh BigInt, không qua number: số lớn hơn Number.MAX_SAFE_INTEGER vẫn đúng thứ tự.
    expect(priceRange("900000000000", "900000000001").invalid).toBe(false);
  });

  it("dải 5 ngày: lùi 2 ngày quanh ngày đi nhưng không trước hôm nay (giờ VN)", () => {
    expect(vnToday(new Date("2026-10-29T18:30:00Z"))).toBe("2026-10-30");
    expect(addDays("2026-12-31", 1)).toBe("2027-01-01");
    expect(stripDates("2026-11-05", "2026-10-30")).toEqual(["2026-11-03", "2026-11-04", "2026-11-05", "2026-11-06", "2026-11-07"]);
    expect(stripDates("2026-10-31", "2026-10-30")).toEqual(["2026-10-30", "2026-10-31", "2026-11-01", "2026-11-02", "2026-11-03"]);
    expect(stripDates("2026-10-01", "2026-10-30")[0]).toBe("2026-10-30");
    expect(stripDates("sai", "2026-10-30")[0]).toBe("2026-10-30");
  });

  it("chặng trên URL: chỉ nhận số hợp lệ; số khách 1–10; query bỏ phần thiếu", () => {
    expect(readTripLeg({ pickup: "2", dropoff: "3", passengers: "4" })).toEqual({ pickup: 2, dropoff: 3, passengers: 4 });
    expect(readTripLeg(new URLSearchParams("pickup=x&dropoff=0&passengers=11"))).toEqual({ pickup: undefined, dropoff: undefined, passengers: undefined });
    expect(readTripLeg(undefined)).toEqual({ pickup: undefined, dropoff: undefined, passengers: undefined });
    expect(tripLegQuery({ pickup: 2, dropoff: 3, passengers: 2 })).toBe("pickup=2&dropoff=3&passengers=2");
    expect(tripLegQuery({ passengers: undefined })).toBe("");
  });

  it("thẻ kết quả lấy điểm đánh giá nhà xe từ API", () => {
    const item = (averageRating: number | null, reviewCount: number) => mapTripSearchItem({
      tripId: "trip", operator: { id: "op", name: "Nhà xe A", slug: "a", averageRating, reviewCount }, routeName: "A → B",
      vehicleType: { name: "Giường nằm", form: "SLEEPER", class: "STANDARD" },
      departureAt: "2026-10-30T01:00:00Z", arrivalAt: "2026-10-30T07:00:00Z",
      pickup: { sequence: 1, name: "Bến A", address: "x", plannedAt: "2026-10-30T01:00:00Z" },
      dropoff: { sequence: 3, name: "Bến B", address: "y", plannedAt: "2026-10-30T07:00:00Z" },
      durationMinutes: 360, availableSeats: 4, minPrice: 300000, vehicleCoverImageUrl: null, amenities: [],
      onlineSaleClosesAt: "2026-10-30T00:00:00Z"
    });
    expect(item(4.6, 12)).toMatchObject({ operatorRating: 4.6, operatorRatingCountText: "12 đánh giá" });
    expect(item(null, 0)).toMatchObject({ operatorRating: 0, operatorRatingCountText: "Chưa có đánh giá" });
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

  it("khu vực (đơn vị hành chính cũ) → fromAreaId / toAreaId; cùng tỉnh vẫn tìm được, chỉ chặn hai điểm trùng hẳn", () => {
    const query = searchQuery({ origin: "79", destination: "77-thanh-pho-vung-tau", destinationType: "area", date: "2026-10-30" });
    expect(query.get("fromProvinceId")).toBe("79");
    expect(query.get("toAreaId")).toBe("77-thanh-pho-vung-tau");
    expect(placeType("area")).toBe("area");
    expect(samePlace({ type: "province", id: "79" }, { type: "area", id: "79" })).toBe(false);
    expect(samePlace({ type: "area", id: "77" }, { type: "area", id: "77" })).toBe(true);
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
