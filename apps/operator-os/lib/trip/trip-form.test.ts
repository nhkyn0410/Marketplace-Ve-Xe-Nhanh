import { describe, expect, it } from "vitest";

import { ApiError } from "../auth/api-client";
import type { Trip } from "./trip-api";
import {
  arrivalIso,
  autoSplitTimes,
  departureIso,
  describeTripSaveError,
  EMPTY_TRIP_VALUES,
  hasCompleteTimes,
  NO_VEHICLE,
  resolveManualTimes,
  suggestArrival,
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
  arrivalDate: "2026-10-08",
  arrivalTime: "11:30",
  vehicleId: VEHICLE_ID,
  note: " Ghé trạm 20 phút. "
};

describe("tripTimeIssues", () => {
  it("giờ hợp lệ thì không có lỗi", () => {
    expect(tripTimeIssues(values, NOW)).toEqual([]);
  });

  it.each([
    ["khởi hành đã qua", { departureDate: "2026-10-07", departureTime: "09:00" }, "departureDate", /tương lai/],
    ["khởi hành đúng lúc này", { departureDate: "2026-10-07", departureTime: "10:00" }, "departureDate", /tương lai/],
    ["đến trước khi đi", { arrivalTime: "05:00" }, "arrivalTime", /sau giờ khởi hành/],
    ["đến bằng giờ đi", { arrivalTime: "06:00" }, "arrivalTime", /sau giờ khởi hành/],
    ["dài quá 7 ngày", { arrivalDate: "2026-10-15", arrivalTime: "06:01" }, "arrivalDate", /7 ngày/]
  ] as const)("%s", (_case, override, path, message) => {
    const issues = tripTimeIssues({ ...values, ...override }, NOW);
    expect(issues.find((issue) => issue.path === path)?.message).toMatch(message);
  });

  it("đúng 7 ngày vẫn được; thiếu ngày giờ thì để từng ô tự báo", () => {
    expect(tripTimeIssues({ ...values, arrivalDate: "2026-10-15", arrivalTime: "06:00" }, NOW)).toEqual([]);
    expect(tripTimeIssues({ ...values, arrivalTime: "" }, NOW)).toEqual([]);
    expect(tripTimeIssues({ ...values, departureDate: "08/10/2026" }, NOW)).toEqual([]);
  });
});

describe("tripInfoSchema", () => {
  const future: TripFormValues = { ...values, departureDate: "2999-01-01", arrivalDate: "2999-01-01" };

  it("nhận form hợp lệ; xe để trống được khi còn nháp", () => {
    expect(tripInfoSchema.safeParse(future).success).toBe(true);
    expect(tripInfoSchema.safeParse({ ...future, vehicleId: NO_VEHICLE }).success).toBe(true);
  });

  it("form trống: báo thiếu tuyến và đủ bốn ô ngày giờ", () => {
    const result = tripInfoSchema.safeParse(EMPTY_TRIP_VALUES);
    expect(result.success).toBe(false);
    const paths = result.error!.issues.map((issue) => issue.path[0]);
    expect(paths).toEqual(
      expect.arrayContaining(["routeId", "departureDate", "departureTime", "arrivalDate", "arrivalTime"])
    );
  });

  it.each([
    ["giờ sai dạng", { departureTime: "25:00" }, "departureTime"],
    ["khởi hành trong quá khứ", { departureDate: "2020-01-01", arrivalDate: "2020-01-01" }, "departureDate"],
    ["ghi chú quá dài", { note: "x".repeat(501) }, "note"]
  ])("từ chối %s", (_case, override, path) => {
    const result = tripInfoSchema.safeParse({ ...future, ...override });
    expect(result.success).toBe(false);
    expect(result.error!.issues.map((issue) => issue.path[0])).toContain(path);
  });
});

describe("giờ đến gợi ý", () => {
  it("cộng thời gian chạy của tuyến, làm tròn phút, tự sang ngày", () => {
    expect(suggestArrival("2026-10-08", "06:00", 19_800)).toEqual({ date: "2026-10-08", time: "11:30" });
    expect(suggestArrival("2026-10-08", "22:00", 27_000)).toEqual({ date: "2026-10-09", time: "05:30" });
    expect(suggestArrival("2026-10-08", "06:00", 19_829)).toEqual({ date: "2026-10-08", time: "11:30" });
    expect(suggestArrival("2026-10-08", "06:00", 19_830)).toEqual({ date: "2026-10-08", time: "11:31" });
  });

  it("tuyến chưa có thời gian chạy vẫn gợi ý sau giờ đi ít nhất 1 phút; chưa nhập giờ đi thì không gợi ý", () => {
    expect(suggestArrival("2026-10-08", "06:00", 0)).toEqual({ date: "2026-10-08", time: "06:01" });
    expect(suggestArrival("2026-10-08", "", 19_800)).toBeNull();
    expect(suggestArrival("", "06:00", 19_800)).toBeNull();
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
      arrivalDate: "2026-10-08",
      arrivalTime: "09:00",
      vehicleId: NO_VEHICLE,
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
      arrivalAt: "2026-10-08T11:30:00+07:00",
      stopTimes: null,
      note: "Ghé trạm 20 phút."
    });
  });

  it("chưa gắn xe → null; ghi chú toàn khoảng trắng → null; giờ tự nhập gửi dạng ISO", () => {
    const departure = ms(departureIso(values));
    const arrival = ms(arrivalIso(values));
    const input = toTripInput({ ...values, vehicleId: NO_VEHICLE, note: "   " }, [departure, arrival]);
    expect(input.vehicleId).toBeNull();
    expect(input.note).toBeNull();
    expect(input.stopTimes).toEqual(["2026-10-07T23:00:00.000Z", "2026-10-08T04:30:00.000Z"]);
  });

  it("hasCompleteTimes chỉ đúng khi đủ bốn ô ngày giờ", () => {
    expect(hasCompleteTimes(values)).toBe(true);
    expect(hasCompleteTimes({ ...values, arrivalDate: "" })).toBe(false);
    expect(hasCompleteTimes(EMPTY_TRIP_VALUES)).toBe(false);
  });
});

describe("describeTripSaveError", () => {
  it.each([
    ["VEHICLE_SCHEDULE_CONFLICT", 409, "vehicleId", /trùng khoảng giờ/],
    ["VEHICLE_UNAVAILABLE", 422, "vehicleId", /sơ đồ ghế/],
    ["ROUTE_UNAVAILABLE", 422, "routeId", /không còn hoạt động/],
    ["TRIP_STOP_TIMES_INVALID", 422, "stops", /số điểm dừng/],
    ["TRIP_NOT_EDITABLE", 409, null, /Nháp/],
    ["TRIP_NOT_FOUND", 404, null, /không còn tồn tại/],
    ["VALIDATION_ERROR", 400, null, /chưa hợp lệ/]
  ] as const)("%s → ô %s", (code, status, field, message) => {
    const described = describeTripSaveError(new ApiError(status, code, "x"));
    expect(described.field).toBe(field);
    expect(described.message).toMatch(message);
  });

  it("lỗi mạng hoặc lỗi lạ → câu chung, không gắn vào ô nào", () => {
    expect(describeTripSaveError(new TypeError("Failed to fetch"))).toEqual({
      field: null,
      message: "Chưa lưu được chuyến. Vui lòng kiểm tra kết nối và thử lại."
    });
    expect(describeTripSaveError(new ApiError(500, "INTERNAL", "x")).field).toBeNull();
  });
});
