import { describe, expect, it } from "vitest";

import { addStop, type DraftStop, type StopCandidate } from "../route/route-form";
import type { StopPointType } from "../stop-point/stop-point-api";
import {
  formatCoordinate,
  markerKind,
  OWN_MAP_LEGEND,
  pointFromInputs,
  roundPoint,
  routeMapCandidates,
  routeMapStops,
  samePoint,
  SHARED_MAP_LEGEND
} from "./stop-map";
import { mapOpenFrom } from "./use-map-open";

describe("màu ghim theo loại điểm và trạng thái", () => {
  it("mỗi loại điểm một màu khi đang hoạt động", () => {
    expect(markerKind("BUS_STATION")).toBe("busStation");
    expect(markerKind("PICKUP_POINT")).toBe("pickup");
    expect(markerKind("OFFICE", "ACTIVE")).toBe("office");
    expect(markerKind("REST_STOP", "ACTIVE")).toBe("restStop");
  });

  it("điểm ngừng dùng hoặc bị khóa thì xám, bất kể loại", () => {
    expect(markerKind("OFFICE", "INACTIVE")).toBe("muted");
    expect(markerKind("REST_STOP", "SUSPENDED")).toBe("muted");
  });

  it("chú giải của mỗi tab chỉ gồm màu có thể xuất hiện ở tab đó", () => {
    expect(OWN_MAP_LEGEND.map((item) => item.kind)).toEqual(["office", "restStop", "muted"]);
    expect(SHARED_MAP_LEGEND.map((item) => item.kind)).toEqual(["busStation", "pickup", "restStop"]);
  });
});

describe("tọa độ giữa bản đồ và ô nhập", () => {
  it("làm tròn 6 chữ số thập phân khi lấy từ bản đồ", () => {
    expect(roundPoint({ latitude: 11.940412345678, longitude: 108.458349999 })).toEqual({
      latitude: 11.940412,
      longitude: 108.45835
    });
    expect(formatCoordinate(11.9404)).toBe("11.9404");
    expect(formatCoordinate(108.4583000001)).toBe("108.4583");
    expect(formatCoordinate(-0.0000004)).toBe("0");
  });

  it("đọc hai ô nhập thành vị trí, nhận dấu phẩy thập phân", () => {
    expect(pointFromInputs("11,9404", " 108.4583 ")).toEqual({ latitude: 11.9404, longitude: 108.4583 });
  });

  it("ô trống, không phải số hoặc ngoài khoảng thì chưa có vị trí", () => {
    expect(pointFromInputs("", "108.4583")).toBeNull();
    expect(pointFromInputs("11.9404", "")).toBeNull();
    expect(pointFromInputs("abc", "108")).toBeNull();
    expect(pointFromInputs("91", "108")).toBeNull();
    expect(pointFromInputs("11", "181")).toBeNull();
  });

  it("so hai vị trí", () => {
    const a = { latitude: 11.9404, longitude: 108.4583 };
    expect(samePoint(a, { ...a })).toBe(true);
    expect(samePoint(a, { ...a, longitude: 108.4584 })).toBe(false);
    expect(samePoint(a, null)).toBe(false);
    expect(samePoint(null, null)).toBe(true);
  });
});

describe("bản đồ lộ trình", () => {
  const candidate = (id: string, type: StopPointType, latitude: number, longitude: number): StopCandidate => ({
    catalogStopPointId: type === "OFFICE" ? null : id,
    stopPointId: type === "OFFICE" ? id : null,
    name: `Điểm ${id}`,
    address: "x",
    type,
    latitude,
    longitude
  });
  const origin = candidate("a", "BUS_STATION", 10.75, 106.68);
  const rest = candidate("r", "REST_STOP", 11.38, 107.54);
  const destination = candidate("c", "BUS_STATION", 11.94, 108.45);
  const stops = [origin, rest, destination].reduce<DraftStop[]>(addStop, []);

  it("ghim đánh số theo thứ tự hành trình, trạm dừng nghỉ màu vàng", () => {
    expect(routeMapStops(stops)).toEqual([
      { key: "catalog:a", order: 1, name: "Điểm a", tone: "primary", point: { latitude: 10.75, longitude: 106.68 } },
      { key: "catalog:r", order: 2, name: "Điểm r", tone: "amber", point: { latitude: 11.38, longitude: 107.54 } },
      { key: "catalog:c", order: 3, name: "Điểm c", tone: "primary", point: { latitude: 11.94, longitude: 108.45 } }
    ]);
    expect(routeMapStops([])).toEqual([]);
  });

  it("chấm xám bỏ điểm đã có trong tuyến và làm nổi điểm đang được rê tới", () => {
    const office = candidate("o", "OFFICE", 12.25, 109.19);
    const pickup = candidate("p", "PICKUP_POINT", 10.94, 107.24);
    const dots = routeMapCandidates(stops, [origin, office, pickup, destination], "own:o");
    expect(dots).toEqual([
      { key: "own:o", name: "Điểm o", point: { latitude: 12.25, longitude: 109.19 }, highlighted: true },
      { key: "catalog:p", name: "Điểm p", point: { latitude: 10.94, longitude: 107.24 }, highlighted: false }
    ]);
    expect(routeMapCandidates(stops, [origin, destination], null)).toEqual([]);
  });
});

describe("nhớ bản đồ mở hay thu gọn", () => {
  it("chưa từng chọn hoặc giá trị lạ thì theo mặc định", () => {
    expect(mapOpenFrom(null, false)).toBe(false);
    expect(mapOpenFrom(null, true)).toBe(true);
    expect(mapOpenFrom("yes", true)).toBe(true);
  });

  it("đã chọn thì theo lựa chọn, bất kể mặc định", () => {
    expect(mapOpenFrom("1", false)).toBe(true);
    expect(mapOpenFrom("0", true)).toBe(false);
  });
});
