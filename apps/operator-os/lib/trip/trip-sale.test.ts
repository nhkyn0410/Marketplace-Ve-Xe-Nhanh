import { describe, expect, it } from "vitest";

import { ApiError } from "../auth/api-client";
import type { Trip, TripSeat, TripSeatStatus } from "./trip-api";
import {
  canEditSeats,
  cutoffLabel,
  describeSeatChangeError,
  describeStatusChangeError,
  onlineSaleCloseLabel,
  onlineSaleCloseMs,
  readinessItems,
  readinessSummary,
  seatChangeNotice,
  seatSelectionMode,
  seatStatusCounts,
  soldSeatCount,
  statusChangeNotice,
  toggleSeat,
  tripActions,
  validSelection,
  type ReadinessItem
} from "./trip-sale";
import { TRIP_STATUS_ORDER } from "./trip-format";

const ms = (iso: string) => new Date(iso).getTime();
const DEPARTURE = "2026-10-08T06:00:00+07:00";
const BEFORE_CLOSE = ms("2026-10-08T04:59:00+07:00");
const AFTER_CLOSE = ms("2026-10-08T05:00:00+07:00");
const PLATE = "51B-289.12";

const seat = (code: string, status: TripSeatStatus = "AVAILABLE", price: number | null = 320_000) =>
  ({ code, status, price, deck: 1, row: 1, column: 1, type: "BED" }) as TripSeat;

function trip(overrides: Partial<Trip> = {}): Trip {
  return {
    status: "DRAFT",
    routeName: "Sài Gòn – Đà Lạt",
    vehicleId: "22222222-2222-4222-8222-222222222222",
    departureAt: DEPARTURE,
    onlineSaleCutoffMinutes: 60,
    stops: [{}, {}, {}],
    seats: [seat("A01"), seat("A02")],
    ...overrides
  } as Trip;
}

const states = (items: ReadinessItem[]) => Object.fromEntries(items.map((item) => [item.key, item.state]));
const detailOf = (items: ReadinessItem[], key: ReadinessItem["key"]) => items.find((item) => item.key === key)!.detail;

describe("mốc ngừng bán online (AS-20)", () => {
  it("giờ khởi hành trừ số phút đã đặt, hiển thị theo giờ Việt Nam", () => {
    expect(onlineSaleCloseMs(DEPARTURE, 60)).toBe(AFTER_CLOSE);
    expect(onlineSaleCloseLabel(DEPARTURE, 60)).toBe("05:00 · 08/10/2026");
    // Khởi hành 00:30, ngừng bán trước 60 phút → 23:30 hôm trước.
    expect(onlineSaleCloseLabel("2026-10-08T00:30:00+07:00", 60)).toBe("23:30 · 07/10/2026");
    expect(onlineSaleCloseLabel(DEPARTURE, 0)).toBe("06:00 · 08/10/2026");
  });

  it("nhãn cài đặt", () => {
    expect(cutoffLabel(60)).toBe("60 phút trước giờ khởi hành");
    expect(cutoffLabel(0)).toBe("Bán tới giờ khởi hành");
  });
});

describe("tripActions", () => {
  const names = (status: Trip["status"], hasTickets = false) =>
    tripActions(status, hasTickets).map(({ action, disabled }) => `${action}${disabled ? " (mờ)" : ""}`);

  it("nút theo trạng thái khi chuyến chưa có vé", () => {
    expect(names("DRAFT")).toEqual(["cancel", "edit", "open"]);
    expect(names("OPEN_FOR_SALE")).toEqual(["cancel", "withdraw", "change", "lock"]);
    expect(names("LOCKED")).toEqual(["cancel", "withdraw", "change", "reopen"]);
    expect(names("SOLD_OUT")).toEqual(["cancel", "change"]);
  });

  it("đã có vé: chỉ thu hồi về nháp mờ đi; đổi lịch chạy / hủy (hoàn 100%) / tạm dừng vẫn dùng được (TRN-008)", () => {
    expect(names("OPEN_FOR_SALE", true)).toEqual(["cancel", "withdraw (mờ)", "change", "lock"]);
    expect(names("LOCKED", true)).toEqual(["cancel", "withdraw (mờ)", "change", "reopen"]);
  });

  it("trạng thái do nhân viên trên xe tạo ra và chuyến đã hủy: không có nút", () => {
    for (const status of TRIP_STATUS_ORDER.filter((value) => !["DRAFT", "OPEN_FOR_SALE", "LOCKED", "SOLD_OUT"].includes(value))) {
      expect(tripActions(status, false), status).toEqual([]);
    }
  });
});

describe("statusChangeNotice", () => {
  it("mở bán nêu mốc ngừng bán online; mở lại từ Tạm dừng bán có chữ riêng", () => {
    const opened = trip({ status: "OPEN_FOR_SALE" });
    expect(statusChangeNotice("DRAFT", opened)).toEqual({
      title: "Đã mở bán",
      detail: "Chuyến bán online tới 05:00 · 08/10/2026."
    });
    expect(statusChangeNotice("LOCKED", opened).title).toBe("Đã mở bán lại");
  });

  it("tạm dừng bán, thu hồi về nháp, hủy", () => {
    expect(statusChangeNotice("OPEN_FOR_SALE", trip({ status: "LOCKED" })).title).toBe("Đã tạm dừng bán");
    expect(statusChangeNotice("LOCKED", trip({ status: "DRAFT" })).title).toBe("Đã thu hồi về nháp");
    expect(statusChangeNotice("DRAFT", trip({ status: "CANCELLED" })).title).toBe("Đã hủy chuyến");
  });
});

describe("readinessItems — trước khi bấm Mở bán", () => {
  it("chuyến đủ xe, chỗ, giá, còn giờ: mục giao diện tự biết là đạt, còn lại chờ kiểm", () => {
    const items = readinessItems(trip(), null, BEFORE_CLOSE, PLATE);
    expect(items.map((item) => item.key)).toEqual([
      "operator",
      "route",
      "stops",
      "vehicle",
      "seats",
      "fare",
      "prices",
      "window"
    ]);
    expect(states(items)).toEqual({
      operator: "unknown",
      route: "unknown",
      stops: "unknown",
      vehicle: "unknown",
      seats: "ok",
      fare: "ok",
      prices: "ok",
      window: "ok"
    });
    expect(detailOf(items, "operator")).toBe("Kiểm khi bấm Mở bán");
    expect(detailOf(items, "seats")).toBe("2 chỗ");
    expect(detailOf(items, "window")).toBe("Ngừng bán lúc 05:00 · 08/10/2026");
    expect(readinessSummary(items, false)).toBe("Chưa bấm Mở bán: 4 mục đạt, 0 mục chưa đạt, 4 mục chờ kiểm.");
  });

  it("chưa gắn xe: mục xe chưa đạt, chỗ và giá chưa kiểm được", () => {
    const items = readinessItems(trip({ vehicleId: null, seats: [] }), null, BEFORE_CLOSE, null);
    expect(states(items)).toMatchObject({ vehicle: "fail", seats: "unknown", fare: "unknown", prices: "unknown" });
    expect(detailOf(items, "vehicle")).toBe("Chuyến chưa gắn xe. Bấm Sửa chuyến để gắn xe.");
  });

  it("thiếu giá một loại chỗ: bảng giá đang áp dụng nhưng mục giá chưa đạt", () => {
    const items = readinessItems(trip({ seats: [seat("A01"), seat("A02", "AVAILABLE", null)] }), null, BEFORE_CLOSE, PLATE);
    expect(states(items)).toMatchObject({ fare: "ok", prices: "fail" });
    expect(detailOf(items, "prices")).toMatch(/chưa có giá cho loại xe hoặc loại chỗ/);
  });

  it("mọi chỗ đều chưa có giá: mục giá chưa đạt, bảng giá để máy chủ kết luận", () => {
    const seats = [seat("A01", "AVAILABLE", null), seat("A02", "BLOCKED", null)];
    const items = readinessItems(trip({ seats }), null, BEFORE_CLOSE, PLATE);
    expect(states(items)).toMatchObject({ fare: "unknown", prices: "fail" });
  });

  it("chỗ giá 0 đồng không được coi là có giá", () => {
    const items = readinessItems(trip({ seats: [seat("A01", "AVAILABLE", 0), seat("A02")] }), null, BEFORE_CLOSE, PLATE);
    expect(states(items)).toMatchObject({ fare: "ok", prices: "fail" });
    expect(detailOf(items, "prices")).toMatch(/giá 0 ₫/);
  });

  it("đúng mốc ngừng bán là đã hết giờ bán", () => {
    expect(states(readinessItems(trip(), null, AFTER_CLOSE, PLATE)).window).toBe("fail");
    expect(states(readinessItems(trip(), null, BEFORE_CLOSE, PLATE)).window).toBe("ok");
  });
});

describe("readinessItems — kết quả lần bấm Mở bán gần nhất", () => {
  it("máy chủ không nêu lý do nào cho một mục thì mục đó đạt", () => {
    const items = readinessItems(trip(), ["STOP_POINT_INACTIVE", "SEAT_PRICE_MISSING"], BEFORE_CLOSE, PLATE);
    expect(states(items)).toEqual({
      operator: "ok",
      route: "ok",
      stops: "fail",
      vehicle: "ok",
      seats: "ok",
      fare: "ok",
      prices: "fail",
      window: "ok"
    });
    expect(detailOf(items, "vehicle")).toBe(PLATE);
    expect(detailOf(items, "stops")).toMatch(/Kiểm tra ở mục Điểm dừng/);
    expect(readinessSummary(items, true)).toBe("Kết quả lần bấm Mở bán gần nhất: 6 mục đạt, 2 mục chưa đạt.");
  });

  it("chưa gắn xe: máy chủ chưa xét được chỗ và giá nên hai mục đó không được coi là đạt", () => {
    const items = readinessItems(
      trip({ vehicleId: null, seats: [] }),
      ["VEHICLE_MISSING", "FARE_MISSING", "SALE_WINDOW_CLOSED"],
      BEFORE_CLOSE,
      null
    );
    expect(states(items)).toEqual({
      operator: "ok",
      route: "ok",
      stops: "ok",
      vehicle: "fail",
      seats: "unknown",
      fare: "fail",
      prices: "unknown",
      window: "fail"
    });
    expect(readinessSummary(items, true)).toBe(
      "Kết quả lần bấm Mở bán gần nhất: 3 mục đạt, 3 mục chưa đạt, 2 mục chưa kiểm được."
    );
  });

  it("kết quả của máy chủ thắng suy đoán từ dữ liệu đang hiển thị (giờ, giá)", () => {
    // Màn hình mở từ trước giờ ngừng bán nhưng lúc bấm đã quá giờ: tin máy chủ.
    expect(states(readinessItems(trip(), ["SALE_WINDOW_CLOSED"], BEFORE_CLOSE, PLATE)).window).toBe("fail");
    // Dữ liệu cũ còn chỗ thiếu giá nhưng máy chủ đã thấy đủ giá.
    const stale = trip({ seats: [seat("A01", "AVAILABLE", null), seat("A02")] });
    expect(states(readinessItems(stale, ["ROUTE_INACTIVE"], BEFORE_CLOSE, PLATE))).toMatchObject({
      route: "fail",
      prices: "ok"
    });
  });

  it.each([
    ["OPERATOR_INACTIVE", "operator", /Liên hệ Vé Xe Nhanh/],
    ["ROUTE_INACTIVE", "route", /Tuyến Sài Gòn – Đà Lạt đã ngừng dùng/],
    ["VEHICLE_INACTIVE", "vehicle", /Xe 51B-289.12 đang bảo dưỡng hoặc ngừng dùng/],
    ["SEATS_MISSING", "seats", /chưa có chỗ nào/],
    ["FARE_MISSING", "fare", /chưa có bảng giá đang áp dụng/],
    ["SEAT_PRICE_ZERO", "prices", /giá 0 ₫/],
    ["SALE_WINDOW_CLOSED", "window", /Đã qua mốc ngừng bán online \(05:00 · 08\/10\/2026\)/]
  ] as const)("%s → mục %s chưa đạt, có hướng dẫn sửa", (reason, key, detail) => {
    const items = readinessItems(trip(), [reason], BEFORE_CLOSE, PLATE);
    expect(states(items)[key]).toBe("fail");
    expect(detailOf(items, key)).toMatch(detail);
  });

  it("chuyến đang Tạm dừng bán: hướng dẫn thu hồi về nháp trước khi sửa", () => {
    const items = readinessItems(trip({ status: "LOCKED" }), ["SALE_WINDOW_CLOSED"], BEFORE_CLOSE, PLATE);
    expect(detailOf(items, "window")).toMatch(/Thu hồi về nháp rồi sửa chuyến/);
  });
});

describe("chỗ của chuyến", () => {
  const seats = [
    seat("A01", "BOOKED"),
    seat("A02", "BOOKED"),
    seat("A03", "CHECKED_IN"),
    seat("A04", "HOLDING"),
    seat("A05"),
    seat("B01", "BLOCKED")
  ];

  it("đếm theo tình trạng; vé đã bán = đã bán + đã lên xe", () => {
    expect(seatStatusCounts(seats)).toEqual({ AVAILABLE: 1, HOLDING: 1, BOOKED: 2, CHECKED_IN: 1, BLOCKED: 1 });
    expect(soldSeatCount(seats)).toBe(3);
    expect(soldSeatCount([seat("A05"), seat("A04", "HOLDING")])).toBe(0);
  });

  it("chỉ khóa / mở khóa chỗ khi chuyến đang Nháp, Đang mở bán hoặc Tạm dừng bán", () => {
    expect(TRIP_STATUS_ORDER.filter(canEditSeats)).toEqual(["DRAFT", "OPEN_FOR_SALE", "LOCKED"]);
  });

  it("chỗ còn trống chọn để khóa, chỗ đã khóa chọn để mở; chỗ đang giữ / đã bán / đã lên xe không chọn được", () => {
    expect(seatSelectionMode("AVAILABLE")).toBe("lock");
    expect(seatSelectionMode("BLOCKED")).toBe("unlock");
    for (const status of ["HOLDING", "BOOKED", "CHECKED_IN"] as const) {
      expect(seatSelectionMode(status)).toBeNull();
      expect(toggleSeat(null, seat("A01", status))).toBeNull();
    }
  });

  it("bấm để thêm, bấm lại để bỏ; bỏ chỗ cuối thì hết lô", () => {
    const one = toggleSeat(null, seat("A05"));
    expect(one).toEqual({ mode: "lock", codes: ["A05"] });
    const two = toggleSeat(one, seat("A06"));
    expect(two).toEqual({ mode: "lock", codes: ["A05", "A06"] });
    expect(toggleSeat(two, seat("A05"))).toEqual({ mode: "lock", codes: ["A06"] });
    expect(toggleSeat(one, seat("A05"))).toBeNull();
  });

  it("một lô chỉ gồm một loại: đang chọn chỗ để khóa thì bấm chỗ đã khóa không đổi gì", () => {
    const locking = toggleSeat(null, seat("A05"));
    expect(toggleSeat(locking, seat("B01", "BLOCKED"))).toBe(locking);
    const unlocking = toggleSeat(null, seat("B01", "BLOCKED"));
    expect(unlocking).toEqual({ mode: "unlock", codes: ["B01"] });
    expect(toggleSeat(unlocking, seat("A05"))).toBe(unlocking);
  });

  it("sơ đồ tải lại: bỏ chỗ vừa bị giữ khỏi lô, xếp theo thứ tự trên sơ đồ", () => {
    const selection = { mode: "lock" as const, codes: ["A05", "A04", "A02"] };
    const fresh = [seat("A02"), seat("A04", "HOLDING"), seat("A05")];
    expect(validSelection(selection, fresh)).toEqual({ mode: "lock", codes: ["A02", "A05"] });
    expect(validSelection(selection, [seat("A02", "BOOKED")])).toBeNull();
    expect(validSelection(null, fresh)).toBeNull();
  });

  it("câu báo sau khi khóa / mở khóa", () => {
    expect(seatChangeNotice("lock", ["A05", "A06"])).toBe("Đã khóa 2 chỗ: A05, A06");
    expect(seatChangeNotice("unlock", ["B01"])).toBe("Đã mở khóa 1 chỗ: B01");
  });
});

describe("đọc lỗi của máy chủ", () => {
  it.each([
    ["TRIP_STATUS_TRANSITION_INVALID", 409, /đã có vé/],
    ["TRIP_NOT_FOUND", 404, /không còn tồn tại/],
    ["SERVICE_UNAVAILABLE", 503, /chưa đổi trạng thái/],
    ["VALIDATION_ERROR", 400, /lý do/]
  ] as const)("đổi trạng thái: %s", (code, status, message) => {
    expect(describeStatusChangeError(new ApiError(status, code, "x"))).toMatch(message);
  });

  it.each([
    ["TRIP_SEAT_NOT_AVAILABLE", 409, /vừa được giữ hoặc đã bán/],
    ["TRIP_SEAT_UNKNOWN", 422, /vừa thay đổi/],
    ["TRIP_NOT_EDITABLE", 409, /đã hủy hoặc đã khởi hành/],
    ["TRIP_NOT_FOUND", 404, /không còn tồn tại/],
    ["SERVICE_UNAVAILABLE", 503, /thao tác khác/],
    ["VALIDATION_ERROR", 400, /ghi chú/]
  ] as const)("khóa / mở khóa chỗ: %s", (code, status, message) => {
    expect(describeSeatChangeError(new ApiError(status, code, "x"))).toMatch(message);
  });

  it("lỗi mạng → câu chung", () => {
    expect(describeStatusChangeError(new TypeError("Failed to fetch"))).toMatch(/kiểm tra kết nối/);
    expect(describeSeatChangeError(new TypeError("Failed to fetch"))).toMatch(/kiểm tra kết nối/);
  });
});
