import { describe, expect, it } from "vitest";

import { ApiError } from "../auth/api-client";
import type { Trip } from "./trip-api";
import {
  autoSplitTimes,
  departureIso,
  describeTripSaveError,
  EMPTY_TRIP_VALUES,
  prefillTripValues,
  hasCompleteTimes,
  NO_VEHICLE,
  parseCutoffMinutes,
  resolveManualTimes,
  routeArrivalMs,
  toTripFormValues,
  toTripInput,
  tripInfoSchema,
  tripTimeIssues,
  usesAutoSplit,
  type TripFormValues
} from "./trip-form";

const ROUTE_ID = "11111111-1111-4111-8111-111111111111";
const VEHICLE_ID = "22222222-2222-4222-8222-222222222222";
const ms = (iso: string) => new Date(iso).getTime();
const NOW = ms("2026-10-07T10:00:00+07:00");

const values: TripFormValues = {
  routeId: ROUTE_ID,
  departureDate: "2026-10-08",
  departureTime: "06:00",
  vehicleId: VEHICLE_ID,
  onlineSaleCutoffMinutes: "60",
  note: " Ghé trạm 20 phút. "
};

describe("tripTimeIssues", () => {
  it("giờ hợp lệ thì không có lỗi", () => {
    expect(tripTimeIssues(values, NOW)).toEqual([]);
  });

  it.each([
    ["khởi hành đã qua", { departureDate: "2026-10-07", departureTime: "09:00" }, "departureDate", /tương lai/],
    ["khởi hành đúng lúc này", { departureDate: "2026-10-07", departureTime: "10:00" }, "departureDate", /tương lai/]
  ] as const)("%s", (_case, override, path, message) => {
    const issues = tripTimeIssues({ ...values, ...override }, NOW);
    expect(issues.find((issue) => issue.path === path)?.message).toMatch(message);
  });

  it("thiếu ngày giờ thì để từng ô tự báo", () => {
    expect(tripTimeIssues({ ...values, departureTime: "" }, NOW)).toEqual([]);
    expect(tripTimeIssues({ ...values, departureDate: "08/10/2026" }, NOW)).toEqual([]);
  });
});

describe("tripInfoSchema", () => {
  const future: TripFormValues = { ...values, departureDate: "2999-01-01" };

  it("nhận form hợp lệ; xe để trống được khi còn nháp", () => {
    expect(tripInfoSchema.safeParse(future).success).toBe(true);
    expect(tripInfoSchema.safeParse({ ...future, vehicleId: NO_VEHICLE }).success).toBe(true);
  });

  it("form trống: báo thiếu tuyến và hai ô ngày giờ khởi hành (giờ đến không nhập)", () => {
    const result = tripInfoSchema.safeParse(EMPTY_TRIP_VALUES);
    expect(result.success).toBe(false);
    const paths = result.error!.issues.map((issue) => issue.path[0]);
    expect(paths).toEqual(
      expect.arrayContaining(["routeId", "departureDate", "departureTime"])
    );
    expect(paths).not.toContain("arrivalDate");
  });

  it.each([
    ["giờ sai dạng", { departureTime: "25:00" }, "departureTime"],
    ["khởi hành trong quá khứ", { departureDate: "2020-01-01" }, "departureDate"],
    ["ghi chú quá dài", { note: "x".repeat(501) }, "note"],
    ["số phút ngừng bán để trống", { onlineSaleCutoffMinutes: "" }, "onlineSaleCutoffMinutes"],
    ["số phút ngừng bán vượt một ngày", { onlineSaleCutoffMinutes: "1441" }, "onlineSaleCutoffMinutes"]
  ])("từ chối %s", (_case, override, path) => {
    const result = tripInfoSchema.safeParse({ ...future, ...override });
    expect(result.success).toBe(false);
    expect(result.error!.issues.map((issue) => issue.path[0])).toContain(path);
  });
});

describe("parseCutoffMinutes", () => {
  it.each([
    ["0", 0],
    ["60", 60],
    [" 90 ", 90],
    ["1440", 1440]
  ])("nhận %j", (input, minutes) => {
    expect(parseCutoffMinutes(input)).toBe(minutes);
  });

  // Số lẻ hay có đơn vị đều bị từ chối: không đoán "1.5" là 15 phút hay 1 phút rưỡi.
  it.each(["", "abc", "-1", "30.5", "1,5", "60 phút", "1441", "99999", "1e2"])("từ chối %j", (input) => {
    expect(parseCutoffMinutes(input)).toBeNull();
  });
});

describe("giờ đến theo tuyến — đúng công thức của máy chủ", () => {
  const departure = ms("2026-10-08T06:00:00+07:00");

  it("cộng thời gian chạy của tuyến, làm tròn phút, tự sang ngày", () => {
    expect(routeArrivalMs(departure, 19_800)).toBe(ms("2026-10-08T11:30:00+07:00"));
    expect(routeArrivalMs(ms("2026-10-08T22:00:00+07:00"), 27_000)).toBe(ms("2026-10-09T05:30:00+07:00"));
    expect(routeArrivalMs(departure, 19_829)).toBe(ms("2026-10-08T11:30:00+07:00"));
    expect(routeArrivalMs(departure, 19_830)).toBe(ms("2026-10-08T11:31:00+07:00"));
  });

  it("tuyến chưa có thời gian chạy vẫn đến sau giờ đi ít nhất 1 phút", () => {
    expect(routeArrivalMs(departure, 0)).toBe(departure + 60_000);
  });
});

describe("autoSplitTimes — đúng công thức của máy chủ", () => {
  const departure = ms("2026-10-08T06:00:00+07:00");

  it("chia theo tỉ lệ thời gian từng chặng; điểm đầu / cuối là giờ đi / đến", () => {
    // Chặng 60 s + 120 s trong 3 giờ → điểm giữa ở 1/3 quãng.
    const times = autoSplitTimes(departure, departure + 3 * 3_600_000, [null, 60, 120]);
    expect(times.map((time) => new Date(time).toISOString())).toEqual([
      "2026-10-07T23:00:00.000Z",
      "2026-10-08T00:00:00.000Z",
      "2026-10-08T02:00:00.000Z"
    ]);
  });

  it("làm tròn XUỐNG theo phút tính từ giờ đi, không vượt giờ đến", () => {
    // 100 phút chia 1 : 2 → 33,33 phút → 33 phút.
    const times = autoSplitTimes(departure, departure + 100 * 60_000, [null, 1, 2]);
    expect((times[1]! - departure) / 60_000).toBe(33);
    expect(times[2]).toBe(departure + 100 * 60_000);
  });

  it("tuyến chưa có số liệu chặng: các điểm giữa bằng giờ đi, điểm cuối vẫn là giờ đến", () => {
    const arrival = departure + 3_600_000;
    expect(autoSplitTimes(departure, arrival, [null, 0, 0])).toEqual([departure, departure, arrival]);
    expect(autoSplitTimes(departure, arrival, [null, null])).toEqual([departure, arrival]);
  });
});

describe("resolveManualTimes", () => {
  const departure = ms("2026-10-08T22:00:00+07:00");
  const arrival = ms("2026-10-09T05:30:00+07:00");

  it("suy ra ngày: giờ nhỏ hơn điểm trước nghĩa là đã sang hôm sau", () => {
    const { times, error } = resolveManualTimes(departure, arrival, ["", "23:30", "01:15", ""]);
    expect(error).toBeNull();
    expect(times.map((time) => new Date(time).toISOString())).toEqual([
      "2026-10-08T15:00:00.000Z",
      "2026-10-08T16:30:00.000Z",
      "2026-10-08T18:15:00.000Z",
      "2026-10-08T22:30:00.000Z"
    ]);
  });

  it("hai điểm liền nhau được trùng giờ; tuyến hai điểm không cần nhập gì", () => {
    expect(resolveManualTimes(departure, arrival, ["", "23:00", "23:00", ""]).error).toBeNull();
    expect(resolveManualTimes(departure, arrival, ["", ""])).toEqual({ times: [departure, arrival], error: null });
  });

  it("thiếu giờ ở điểm giữa → báo nhập đủ, vẫn giữ các điểm đã tính được phía trên", () => {
    const { times, error } = resolveManualTimes(departure, arrival, ["", "23:30", "", ""]);
    expect(error).toMatch(/mọi điểm dừng ở giữa/);
    expect(times).toEqual([departure, ms("2026-10-08T23:30:00+07:00")]);
  });

  it("giờ vượt quá giờ đến → nêu điểm dừng sai", () => {
    // 06:00 hôm sau là sau giờ đến 05:30.
    expect(resolveManualTimes(departure, arrival, ["", "23:30", "06:00", ""]).error).toMatch(/thứ 3/);
    // 21:00 nhỏ hơn giờ đi 22:00 nên bị hiểu là 21:00 hôm sau — cũng vượt giờ đến.
    expect(resolveManualTimes(departure, arrival, ["", "21:00", ""]).error).toMatch(/thứ 2/);
  });
});

describe("đổi qua lại với chuyến đã lưu", () => {
  const trip = {
    id: "33333333-3333-4333-8333-333333333333",
    routeId: ROUTE_ID,
    vehicleId: null,
    departureAt: "2026-10-07T23:00:00.000Z",
    arrivalAt: "2026-10-08T02:00:00.000Z",
    onlineSaleCutoffMinutes: 45,
    note: null,
    stops: [
      { plannedAt: "2026-10-07T23:00:00.000Z" },
      { plannedAt: "2026-10-08T00:00:00.000Z" },
      { plannedAt: "2026-10-08T02:00:00.000Z" }
    ]
  } as unknown as Trip;

  it("giá trị form: giờ Việt Nam, chưa gắn xe, ghi chú trống", () => {
    expect(toTripFormValues(trip)).toEqual({
      routeId: ROUTE_ID,
      departureDate: "2026-10-08",
      departureTime: "06:00",
      vehicleId: NO_VEHICLE,
      onlineSaleCutoffMinutes: "45",
      note: ""
    });
  });

  it("nhận ra chuyến đang dùng giờ tự chia hay giờ tự nhập", () => {
    expect(usesAutoSplit(trip, [null, 60, 120])).toBe(true);
    // Tuyến đổi số liệu chặng (1 : 1) thì giờ đang lưu không còn khớp → coi là tự nhập.
    expect(usesAutoSplit(trip, [null, 60, 60])).toBe(false);
    // Tuyến đổi số điểm: giờ cũ không dùng lại được → quay về tự chia.
    expect(usesAutoSplit(trip, [null, 60])).toBe(true);
  });
});

describe("toTripInput", () => {
  it("giờ có múi giờ +07:00; ghi chú cắt khoảng trắng; tự chia thì stopTimes = null", () => {
    expect(toTripInput(values, null)).toEqual({
      routeId: ROUTE_ID,
      vehicleId: VEHICLE_ID,
      departureAt: "2026-10-08T06:00:00+07:00",
      stopTimes: null,
      onlineSaleCutoffMinutes: 60,
      note: "Ghé trạm 20 phút."
    });
    expect(toTripInput({ ...values, onlineSaleCutoffMinutes: " 0 " }, null).onlineSaleCutoffMinutes).toBe(0);
  });

  it("chưa gắn xe → null; ghi chú toàn khoảng trắng → null; giờ tự nhập gửi dạng ISO", () => {
    const departure = ms(departureIso(values));
    const arrival = routeArrivalMs(departure, 19_800);
    const input = toTripInput({ ...values, vehicleId: NO_VEHICLE, note: "   " }, [departure, arrival]);
    expect(input.vehicleId).toBeNull();
    expect(input.note).toBeNull();
    expect(input.stopTimes).toEqual(["2026-10-07T23:00:00.000Z", "2026-10-08T04:30:00.000Z"]);
  });

  it("hasCompleteTimes chỉ đúng khi đủ ngày giờ khởi hành", () => {
    expect(hasCompleteTimes(values)).toBe(true);
    expect(hasCompleteTimes({ ...values, departureDate: "" })).toBe(false);
    expect(hasCompleteTimes(EMPTY_TRIP_VALUES)).toBe(false);
  });
});

describe("describeTripSaveError", () => {
  it.each([
    ["VEHICLE_SCHEDULE_CONFLICT", 409, "vehicleId", /trùng khoảng giờ/],
    ["VEHICLE_UNAVAILABLE", 422, "vehicleId", /sơ đồ ghế/],
    ["ROUTE_UNAVAILABLE", 422, "routeId", /không còn hoạt động/],
    ["TRIP_STOP_TIMES_INVALID", 422, "stops", /điểm dừng hoặc thời gian chạy/],
    ["TRIP_SEAT_NOT_AVAILABLE", 409, "vehicleId", /đang được giữ hoặc đã bán/],
    ["TRIP_NOT_EDITABLE", 409, null, /Nháp/],
    ["TRIP_NOT_FOUND", 404, null, /không còn tồn tại/],
    ["VALIDATION_ERROR", 400, null, /chưa hợp lệ/]
  ] as const)("%s → ô %s", (code, status, field, message) => {
    const described = describeTripSaveError(new ApiError(status, code, "x"));
    expect(described.field).toBe(field);
    expect(described.message).toMatch(message);
  });

  it("xe mới thiếu chỗ đang khóa: báo tại ô Xe bằng câu của máy chủ (có mã chỗ)", () => {
    const detail = "Sơ đồ ghế sau khi đổi không còn ghế đang khóa: A1, B2. Mở khóa các ghế này trước rồi thử lại.";
    expect(describeTripSaveError(new ApiError(409, "TRIP_BLOCKED_SEATS_MISSING", detail))).toEqual({
      field: "vehicleId",
      message: detail
    });
  });

  it("lỗi mạng hoặc lỗi lạ → câu chung, không gắn vào ô nào", () => {
    expect(describeTripSaveError(new TypeError("Failed to fetch"))).toEqual({
      field: null,
      message: "Chưa lưu được chuyến. Vui lòng kiểm tra kết nối và thử lại."
    });
    expect(describeTripSaveError(new ApiError(500, "INTERNAL", "x")).field).toBeNull();
  });
});

describe("điền sẵn từ Lịch xe (TASK-TRN-015)", () => {
  it("lấy xe / ngày / giờ hợp lệ, bỏ qua tham số sai dạng", () => {
    const params = (entries: Record<string, string>) => new URLSearchParams(entries);
    const vehicleId = "6f6ec808-1f91-4689-aff7-b4c6b5ea12b3";
    expect(prefillTripValues(params({ vehicleId, date: "2026-10-10", time: "20:00" }))).toMatchObject({
      vehicleId,
      departureDate: "2026-10-10",
      departureTime: "20:00",
      routeId: ""
    });
    expect(prefillTripValues(params({ vehicleId: "x", date: "10/10/2026", time: "25:00" }))).toEqual(EMPTY_TRIP_VALUES);
  });
});
