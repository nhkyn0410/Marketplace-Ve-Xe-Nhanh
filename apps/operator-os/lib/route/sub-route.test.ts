import { describe, expect, it } from "vitest";

import type { RouteStop, SubRouteSuggestion } from "./route-api";
import {
  EMPTY_SUB_ROUTE,
  fromOptions,
  generalPrice,
  sliceOf,
  sliceTotals,
  suggestedFareRules,
  suggestionInput,
  toOptions,
  toSubRouteInput
} from "./sub-route";

function stop(id: string, pickup: boolean, dropoff: boolean, km: number | null): RouteStop {
  return {
    sequence: 0,
    role: "INTERMEDIATE",
    catalogStopPointId: null,
    stopPointId: id,
    name: id,
    type: "OFFICE",
    address: "",
    latitude: 10,
    longitude: 106,
    note: null,
    allowPickup: pickup,
    allowDropoff: dropoff,
    distanceMetersFromPrevious: km === null ? null : km * 1000,
    durationSecondsFromPrevious: km === null ? null : km * 60,
    measuredDurationSecondsFromPrevious: km === null ? null : km * 60
  };
}

// HCM (chỉ đón) → Q1 (chỉ đón) → Gia Nghĩa (đón + trả) → BMT (chỉ trả).
const stops = [stop("hcm", true, false, null), stop("q1", true, false, 10), stop("gn", true, true, 200), stop("bmt", false, true, 120)];
const key = (id: string) => `private:${id}`;

describe("tuyến con — chọn hai đầu trên tuyến chính", () => {
  it("điểm đầu: cho đón, không phải điểm cuối", () => {
    expect(fromOptions(stops).map((item) => item.stopPointId)).toEqual(["hcm", "q1", "gn"]);
  });

  it("điểm cuối: sau điểm đầu, cho trả, không trùng cả tuyến chính", () => {
    expect(toOptions(stops, key("hcm")).map((item) => item.stopPointId)).toEqual(["gn"]);
    expect(toOptions(stops, key("q1")).map((item) => item.stopPointId)).toEqual(["gn", "bmt"]);
    expect(toOptions(stops, "x")).toEqual([]);
  });

  it("đoạn + quãng đường theo chặng của tuyến chính", () => {
    const slice = sliceOf(stops, key("q1"), key("bmt"));
    expect(slice.map((item) => item.stopPointId)).toEqual(["q1", "gn", "bmt"]);
    expect(sliceTotals(slice)).toEqual({ distanceMeters: 320_000, durationSeconds: 320 * 60 });
    expect(sliceOf(stops, key("bmt"), key("q1"))).toEqual([]);
  });

  it("body: chưa chọn đủ hai đầu → null; tự đặt tên thì gửi tên rỗng; ghi chú trống → null", () => {
    expect(toSubRouteInput(EMPTY_SUB_ROUTE, stops)).toBeNull();
    expect(toSubRouteInput({ ...EMPTY_SUB_ROUTE, fromKey: key("hcm"), toKey: key("gn"), name: "bỏ qua" }, stops)).toEqual({
      from: { catalogStopPointId: null, stopPointId: "hcm" },
      to: { catalogStopPointId: null, stopPointId: "gn" },
      nameSource: "AUTO",
      name: "",
      status: "DRAFT",
      note: null
    });
    expect(
      toSubRouteInput({ ...EMPTY_SUB_ROUTE, fromKey: key("q1"), toKey: key("gn"), nameSource: "MANUAL", name: "  Q1 – GN ", note: " x " }, stops)
    ).toMatchObject({ nameSource: "MANUAL", name: "Q1 – GN", note: "x" });
  });
});

describe("tuyến con — giá gợi ý nhà xe sửa được", () => {
  const general = { vehicleTypeId: null, seatType: null, validFrom: null, validTo: null, price: 100_000 };
  const double = { vehicleTypeId: null, seatType: "BED_DOUBLE" as const, validFrom: null, validTo: null, price: 180_000 };

  it("giá chung lấy từ quy tắc mọi loại, không khung giờ", () => {
    expect(generalPrice([double, general])).toBe(100_000);
    expect(generalPrice([double])).toBeNull();
    expect(generalPrice(null)).toBeNull();
  });

  it("nhập giá → thay giá chung, giữ quy tắc khác theo gợi ý; không nhập → giữ nguyên gợi ý", () => {
    expect(suggestedFareRules([general, double], 120_000)).toEqual([{ ...general, price: 120_000 }, double]);
    expect(suggestedFareRules([general, double], null)).toEqual([general, double]);
    expect(suggestedFareRules([double], 90_000)).toEqual([{ ...general, price: 90_000 }, double]);
  });

  it("tuyến chính chưa có bảng giá: giá nhập thành giá chung; không nhập thì không tạo bảng giá", () => {
    expect(suggestedFareRules(null, 50_000)).toEqual([{ ...general, price: 50_000 }]);
    expect(suggestedFareRules(null, null)).toBeNull();
  });

  it("tạo từ gợi ý: tự đặt tên, Nháp, hai đầu theo mã điểm", () => {
    const suggestion = {
      from: { catalogStopPointId: "c1", stopPointId: null, name: "A" },
      to: { catalogStopPointId: null, stopPointId: "p2", name: "B" },
      name: "A → B",
      totalDistanceMeters: 1,
      totalDurationSeconds: 1,
      suggestedRules: null
    } satisfies SubRouteSuggestion;
    expect(suggestionInput(suggestion)).toEqual({
      from: { catalogStopPointId: "c1", stopPointId: null },
      to: { catalogStopPointId: null, stopPointId: "p2" },
      nameSource: "AUTO",
      name: "",
      status: "DRAFT",
      note: null
    });
  });
});
