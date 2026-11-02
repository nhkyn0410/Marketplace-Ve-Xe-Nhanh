import { describe, expect, it } from "vitest";

import { ApiError } from "../auth/api-client";
import type { StopPointType } from "../stop-point/stop-point-api";
import type { Route } from "./route-api";
import {
  addStop,
  busStationWarning,
  countFlags,
  describeSaveError,
  EMPTY_ROUTE_INFO,
  legMinutesOf,
  legOf,
  lockedFlags,
  MAX_ROUTE_STOPS,
  moveStop,
  normalizeStops,
  removeStop,
  routeInfoSchema,
  savedLegMinutes,
  savedLegs,
  setLegMinutes,
  setStopFlag,
  setStopNote,
  stopKey,
  toDraftStops,
  toRouteInfoValues,
  toRouteInput,
  totalsOf,
  validateLegMinutes,
  validateStops,
  type DraftStop,
  type StopCandidate
} from "./route-form";

const shared = (id: string, type: StopPointType = "BUS_STATION"): StopCandidate => ({
  catalogStopPointId: id,
  stopPointId: null,
  name: `Điểm ${id}`,
  address: "x",
  type,
  latitude: 10,
  longitude: 106
});
const own = (id: string, type: StopPointType = "OFFICE"): StopCandidate => ({
  catalogStopPointId: null,
  stopPointId: id,
  name: `Điểm ${id}`,
  address: "x",
  type,
  latitude: 10,
  longitude: 106
});
const build = (...candidates: StopCandidate[]) => candidates.reduce<DraftStop[]>(addStop, []);
const flags = (stops: DraftStop[]) => stops.map((stop) => [stop.allowPickup, stop.allowDropoff]);

describe("quyền đón / trả theo vị trí và loại điểm (BR-79)", () => {
  it("điểm đầu chỉ đón, điểm cuối chỉ trả, trạm dừng nghỉ không đón không trả, điểm giữa tự chọn", () => {
    expect(lockedFlags(0, 3, "BUS_STATION")).toEqual({ allowPickup: true, allowDropoff: false });
    expect(lockedFlags(2, 3, "OFFICE")).toEqual({ allowPickup: false, allowDropoff: true });
    expect(lockedFlags(1, 3, "REST_STOP")).toEqual({ allowPickup: false, allowDropoff: false });
    expect(lockedFlags(1, 3, "PICKUP_POINT")).toBeNull();
  });

  it("thêm lần lượt: điểm mới xếp cuối và chỉ trả; điểm cuối cũ lùi vào giữa vẫn giữ quyền trả", () => {
    const stops = build(shared("a"), shared("b", "PICKUP_POINT"), own("r", "REST_STOP"), shared("c"));
    expect(stops.map(stopKey)).toEqual(["catalog:a", "catalog:b", "own:r", "catalog:c"]);
    expect(flags(stops)).toEqual([
      [true, false],
      [false, true],
      [false, false],
      [false, true]
    ]);
  });

  it("không thêm trùng điểm và không vượt số điểm tối đa", () => {
    const stops = build(shared("a"), shared("b"));
    expect(addStop(stops, shared("a"))).toBe(stops);
    const full = Array.from({ length: MAX_ROUTE_STOPS }, (_, index) => shared(`p${index}`)).reduce<DraftStop[]>(addStop, []);
    expect(full).toHaveLength(MAX_ROUTE_STOPS);
    expect(addStop(full, shared("extra"))).toBe(full);
  });

  it("đổi thứ tự: công tắc của hai đầu đặt lại theo vị trí mới, ra ngoài danh sách thì giữ nguyên", () => {
    const stops = build(shared("a"), shared("b"), shared("c"));
    const moved = moveStop(stops, 0, 1);
    expect(moved.map(stopKey)).toEqual(["catalog:b", "catalog:a", "catalog:c"]);
    // b lên đầu → chỉ đón; a vào giữa giữ lựa chọn cũ (đang chỉ đón).
    expect(flags(moved)).toEqual([
      [true, false],
      [true, false],
      [false, true]
    ]);
    expect(moveStop(stops, 0, -1)).toBe(stops);
    expect(moveStop(stops, 2, 1)).toBe(stops);
  });

  it("bỏ điểm cuối: điểm đứng trước thành điểm cuối và chỉ trả", () => {
    const stops = setStopFlag(build(shared("a"), shared("b"), shared("c")), 1, "allowPickup", true);
    expect(flags(stops)[1]).toEqual([true, true]);
    expect(flags(removeStop(stops, 2))).toEqual([
      [true, false],
      [false, true]
    ]);
  });

  it("chỉ điểm ở giữa mới bật / tắt được; điểm bị khóa không đổi", () => {
    const stops = build(shared("a"), shared("b"), own("r", "REST_STOP"), shared("c"));
    expect(setStopFlag(stops, 0, "allowDropoff", true)).toBe(stops);
    expect(setStopFlag(stops, 2, "allowPickup", true)).toBe(stops);
    expect(setStopFlag(stops, 3, "allowPickup", true)).toBe(stops);
    expect(flags(setStopFlag(stops, 1, "allowPickup", true))[1]).toEqual([true, true]);
  });

  it("normalizeStops sửa dữ liệu lệch quy tắc (vd tuyến cũ) về đúng theo vị trí", () => {
    const stops = build(shared("a"), shared("b")).map((stop) => ({ ...stop, allowPickup: true, allowDropoff: true }));
    expect(flags(normalizeStops(stops))).toEqual([
      [true, false],
      [false, true]
    ]);
  });
});

describe("validateStops", () => {
  it("dưới hai điểm thì chưa lưu được", () => {
    expect(validateStops([])).toBe("Tuyến cần ít nhất 2 điểm dừng.");
    expect(validateStops(build(shared("a")))).toBe("Tuyến cần ít nhất 2 điểm dừng.");
  });

  it("trạm dừng nghỉ đứng đầu hoặc cuối bị chặn", () => {
    const message = "Trạm dừng nghỉ không được đứng đầu hoặc cuối tuyến. Hãy đổi thứ tự hoặc thêm điểm khác.";
    expect(validateStops(build(own("r", "REST_STOP"), shared("a"), shared("b")))).toBe(message);
    expect(validateStops(build(shared("a"), shared("b"), own("r", "REST_STOP")))).toBe(message);
  });

  it("điểm ở giữa tắt cả hai quyền thì báo đích danh điểm đó", () => {
    const stops = setStopFlag(build(shared("a"), shared("b"), shared("c")), 1, "allowDropoff", false);
    expect(validateStops(stops)).toBe("Điểm “Điểm b” phải cho đón hoặc cho trả khách.");
  });

  it("tuyến hợp lệ: bến xe hai đầu, trạm dừng nghỉ ở giữa", () => {
    expect(validateStops(build(shared("a"), own("r", "REST_STOP"), shared("b")))).toBeNull();
  });
});

describe("busStationWarning (OQ-24) — cảnh báo, không chặn lưu", () => {
  it.each([
    [[shared("a"), shared("b")], null],
    [[own("o"), shared("b")], /^Điểm đầu không phải bến xe/],
    [[shared("a"), shared("p", "PICKUP_POINT")], /^Điểm cuối không phải bến xe/],
    [[own("o"), own("o2")], /^Điểm đầu và điểm cuối không phải bến xe/],
    [[own("o")], null]
  ])("trường hợp %#", (candidates, expected) => {
    const warning = busStationWarning(build(...(candidates as StopCandidate[])));
    if (expected === null) {
      expect(warning).toBeNull();
    } else {
      expect(warning).toMatch(expected as RegExp);
      expect(warning).toMatch(/vẫn lưu được/);
    }
  });
});

describe("thông tin tuyến và đổi sang DTO", () => {
  it("tuyến mới mặc định tự đặt tên + 'Hoạt động'; tắt tự đặt tên mà bỏ trống tên → báo tại ô tên", () => {
    expect(EMPTY_ROUTE_INFO).toMatchObject({ nameSource: "AUTO", status: "ACTIVE" });
    expect(routeInfoSchema.safeParse(EMPTY_ROUTE_INFO).success).toBe(true);
    const result = routeInfoSchema.safeParse({ ...EMPTY_ROUTE_INFO, nameSource: "MANUAL" });
    expect(result.success ? [] : result.error.issues.map((issue) => issue.message)).toEqual(["Nhập tên tuyến hoặc bật Tự đặt tên."]);
    expect(routeInfoSchema.safeParse({ ...EMPTY_ROUTE_INFO, name: "x".repeat(151) }).success).toBe(false);
    expect(routeInfoSchema.safeParse({ ...EMPTY_ROUTE_INFO, name: "x", note: "x".repeat(501) }).success).toBe(false);
  });

  // Tọa độ trong form chỉ để vẽ bản đồ: `toEqual` bên dưới đỏ nếu chúng lọt vào body.
  it("body gửi đủ mọi trường, cắt khoảng trắng, ghi chú trống gửi null, giữ đúng thứ tự điểm", () => {
    const stops = setStopNote(build(shared("a"), own("r", "REST_STOP"), own("o")), 1, "  Nghỉ 20 phút ");
    expect(toRouteInput({ name: " Sài Gòn – Đà Lạt ", nameSource: "MANUAL", status: "INACTIVE", note: "  " }, stops)).toEqual({
      name: "Sài Gòn – Đà Lạt",
      nameSource: "MANUAL",
      status: "INACTIVE",
      note: null,
      stops: [
        { catalogStopPointId: "a", stopPointId: null, note: null, allowPickup: true, allowDropoff: false, durationMinutesFromPrevious: null },
        { catalogStopPointId: null, stopPointId: "r", note: "Nghỉ 20 phút", allowPickup: false, allowDropoff: false, durationMinutesFromPrevious: null },
        { catalogStopPointId: null, stopPointId: "o", note: null, allowPickup: false, allowDropoff: true, durationMinutesFromPrevious: null }
      ]
    });
    expect(countFlags(stops)).toEqual({ pickup: 1, dropoff: 1 });
  });
});

describe("tuyến đã lưu → form", () => {
  const stop = (sequence: number, id: string, extra: Partial<Route["stops"][number]> = {}): Route["stops"][number] => ({
    sequence,
    role: "INTERMEDIATE",
    catalogStopPointId: id,
    stopPointId: null,
    name: `Điểm ${id}`,
    type: "BUS_STATION",
    address: "x",
    latitude: 10,
    longitude: 106,
    note: null,
    allowPickup: true,
    allowDropoff: true,
    distanceMetersFromPrevious: null,
    durationSecondsFromPrevious: null,
    measuredDurationSecondsFromPrevious: null,
    ...extra
  });
  const route: Route = {
    id: "route-1",
    name: "Sài Gòn – Đà Lạt",
    nameSource: "MANUAL",
    suggestedName: null,
    status: "ACTIVE",
    note: null,
    totalDistanceMeters: 140_000,
    totalDurationSeconds: 11_700,
    metricsSource: "GOONG",
    parentRouteId: null,
    parentRouteName: null,
    needsReview: false,
    subRoutes: [],
    createdAt: "2026-10-05T07:20:00.000Z",
    updatedAt: "2026-10-05T07:20:00.000Z",
    // Cố ý đảo thứ tự mảng: form phải xếp theo `sequence`.
    stops: [
      stop(3, "c", { allowPickup: false, distanceMetersFromPrevious: 78_000, durationSecondsFromPrevious: 6_600, measuredDurationSecondsFromPrevious: 6_600, note: "Cổng B" }),
      stop(1, "a", { allowDropoff: false, latitude: 10.75, longitude: 106.68 }),
      stop(2, "b", { distanceMetersFromPrevious: 62_000, durationSecondsFromPrevious: 5_100, measuredDurationSecondsFromPrevious: 5_100 })
    ]
  };

  it("điểm dừng theo đúng thứ tự hành trình, ghi chú null thành rỗng, giữ tọa độ để vẽ bản đồ", () => {
    const stops = toDraftStops(route);
    expect(stops.map((item) => item.name)).toEqual(["Điểm a", "Điểm b", "Điểm c"]);
    expect(stops.map((item) => item.note)).toEqual(["", "", "Cổng B"]);
    expect(stops.map((item) => [item.latitude, item.longitude])).toEqual([
      [10.75, 106.68],
      [10, 106],
      [10, 106]
    ]);
    expect(toRouteInfoValues(route)).toEqual({ name: "Sài Gòn – Đà Lạt", nameSource: "MANUAL", status: "ACTIVE", note: "" });
    expect(validateStops(stops)).toBeNull();
  });

  it("số liệu chặng: giữ khi cặp điểm còn liền nhau, đổi thứ tự thì chặng mới chờ tính khi lưu", () => {
    const legs = savedLegs(route);
    const stops = toDraftStops(route);
    expect(legOf(legs, stops, 1)).toEqual({ distanceMeters: 62_000, durationSeconds: 5_100 });
    expect(totalsOf(legs, stops)).toEqual({ distanceMeters: 140_000, durationSeconds: 11_700 });

    const swapped = moveStop(stops, 1, 1);
    expect(legOf(legs, swapped, 1)).toBeNull();
    expect(totalsOf(legs, swapped)).toBeNull();
    // Bỏ điểm cuối: chặng a → b còn nguyên nên tổng vẫn tính được.
    expect(totalsOf(legs, removeStop(stops, 2))).toEqual({ distanceMeters: 62_000, durationSeconds: 5_100 });
    expect(totalsOf(savedLegs(undefined), stops)).toBeNull();
    expect(totalsOf(legs, stops.slice(0, 1))).toBeNull();
  });

  it("thời gian chạy thực tế nhà xe chỉnh: đọc từ tuyến đã lưu, tổng theo số chỉnh, gửi số phút; xóa trắng = số hệ thống", () => {
    // Chặng b → c nhà xe đã chỉnh 2 giờ 15 phút (hệ thống tính 1 giờ 50 phút).
    const edited: Route = {
      ...route,
      totalDurationSeconds: 5_100 + 8_100,
      stops: route.stops.map((item) => (item.sequence === 3 ? { ...item, durationSecondsFromPrevious: 8_100 } : item))
    };
    const stops = toDraftStops(edited);
    const minutes = savedLegMinutes(edited);
    expect(legOf(savedLegs(edited), stops, 2)).toEqual({ distanceMeters: 78_000, durationSeconds: 6_600 });
    expect([legMinutesOf(minutes, stops, 1), legMinutesOf(minutes, stops, 2)]).toEqual(["", "135"]);
    expect(totalsOf(savedLegs(edited), stops, minutes)).toEqual({ distanceMeters: 140_000, durationSeconds: 13_200 });
    expect(toRouteInput(toRouteInfoValues(edited), stops, minutes).stops.map((item) => item.durationMinutesFromPrevious)).toEqual([null, null, 135]);

    const cleared = setLegMinutes(minutes, stops, 2, " ");
    expect(cleared).toEqual({});
    expect(totalsOf(savedLegs(edited), stops, cleared)).toEqual({ distanceMeters: 140_000, durationSeconds: 11_700 });
    // Đổi thứ tự: chặng mới không mang số chỉnh của chặng cũ.
    expect(legMinutesOf(minutes, moveStop(stops, 1, 1), 2)).toBe("");
    expect(savedLegMinutes(route)).toEqual({});
  });

  it("ô số phút: số nguyên 1–1440, ô trống hợp lệ", () => {
    const stops = toDraftStops(route);
    for (const value of ["0", "1441", "1,5", "abc", "-5"]) {
      expect(validateLegMinutes(setLegMinutes({}, stops, 2, value), stops), value).toMatch(/Điểm c/);
      expect(toRouteInput(EMPTY_ROUTE_INFO, stops, setLegMinutes({}, stops, 2, value)).stops[2]!.durationMinutesFromPrevious).toBeNull();
    }
    for (const value of ["", "1", " 95 ", "1440"]) {
      expect(validateLegMinutes(setLegMinutes({}, stops, 2, value), stops), value).toBeNull();
    }
  });
});

describe("describeSaveError", () => {
  it.each([
    ["ROUTE_NAME_CONFLICT", 409, "name"],
    ["STOP_POINT_UNAVAILABLE", 422, "stops"],
    ["ROUTE_STOP_PICKUP_DROPOFF_INVALID", 422, "stops"],
    ["ROUTE_DURATION_INVALID", 422, "stops"],
    ["ROUTING_PROVIDER_UNAVAILABLE", 503, null],
    ["ROUTE_NOT_FOUND", 404, null]
  ])("%s → chỗ %j, có thông báo riêng", (code, status, field) => {
    const described = describeSaveError(new ApiError(status, code, "x"));
    expect(described.field).toBe(field);
    expect(described.message).not.toMatch(/kiểm tra kết nối/);
  });

  it("dịch vụ bản đồ lỗi: nói rõ tuyến chưa được lưu; lỗi mạng → thông báo chung", () => {
    expect(describeSaveError(new ApiError(503, "ROUTING_PROVIDER_UNAVAILABLE", "x")).message).toMatch(/chưa được lưu/);
    expect(describeSaveError(new ApiError(400, "VALIDATION_FAILED", "x")).message).toMatch(/chưa hợp lệ/);
    expect(describeSaveError(new TypeError("Failed to fetch")).message).toMatch(/Chưa lưu được tuyến/);
  });
});
