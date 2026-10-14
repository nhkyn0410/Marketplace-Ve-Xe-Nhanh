import { describe, expect, it } from "vitest";

import { ApiError } from "../auth/api-client";
import type { Fare, FareRule } from "./fare-api";
import {
  ANY,
  describeFareSaveError,
  EMPTY_RULE_FORM,
  findConflict,
  parsePrice,
  parseRuleForm,
  rulesConflict,
  sortRules,
  toFareCreateInput,
  toFareInfo,
  toFareUpdateInput,
  toRuleForm
} from "./fare-form";

const SLEEPER = "11111111-1111-4111-8111-111111111111";
const CABIN = "22222222-2222-4222-8222-222222222222";
const rule = (overrides: Partial<FareRule> = {}): FareRule => ({
  vehicleTypeId: null,
  seatType: null,
  validFrom: null,
  validTo: null,
  price: 250_000,
  ...overrides
});
const window = (fromDay: number, toDay: number) => ({
  validFrom: new Date(Date.UTC(2031, 0, fromDay)).toISOString(),
  validTo: new Date(Date.UTC(2031, 0, toDay)).toISOString()
});

// Test money (ADR-025): giá gõ vào phải thành đúng số nguyên đồng, không làm tròn, không nhận số thực.
describe("parsePrice", () => {
  it.each([
    ["300000", 300_000],
    ["300.000", 300_000],
    [" 1 250 000 ", 1_250_000],
    ["0", 0],
    ["100.000.000", 100_000_000]
  ])("%j → %i", (input, expected) => {
    expect(parsePrice(input)).toBe(expected);
  });

  it.each(["", "abc", "-1", "300,5", "300.000,50", "1e5", "100000001", "1000000000", "300000đ"])("từ chối %j", (input) => {
    expect(parsePrice(input)).toBeNull();
  });

  // Dấu chấm lệch nhóm ba số có thể là số thập phân gõ nhầm: không được đoán thành 15 đồng hay 3.005 đồng.
  it.each(["1.5", "300.5", "1.000.00", "1000.000", "12.34.567", ".500", "300.", "1.000.000.000", "3 00 000"])(
    "từ chối dấu ngăn sai nhóm %j",
    (input) => {
      expect(parsePrice(input)).toBeNull();
    }
  );
});

describe("parseRuleForm", () => {
  it("quy tắc giá thường: mọi loại xe, mọi loại chỗ, không khung giờ", () => {
    expect(parseRuleForm({ ...EMPTY_RULE_FORM, price: "250.000" })).toEqual({ rule: rule(), errors: {} });
  });

  it("khung giờ nhập theo giờ Việt Nam được đổi sang mốc UTC", () => {
    const { rule: parsed } = parseRuleForm({
      vehicleTypeId: SLEEPER,
      seatType: "BED_DOUBLE",
      from: "2031-01-20T00:00",
      to: "2031-01-27T00:00",
      price: "600000"
    });
    expect(parsed).toEqual({
      vehicleTypeId: SLEEPER,
      seatType: "BED_DOUBLE",
      validFrom: "2031-01-19T17:00:00.000Z",
      validTo: "2031-01-26T17:00:00.000Z",
      price: 600_000
    });
  });

  it.each([
    ["thiếu giá", { price: "" }, "price"],
    ["giá vượt trần", { price: "100000001" }, "price"],
    ["chỉ có mốc bắt đầu", { from: "2031-01-20T00:00", price: "1" }, "to"],
    ["chỉ có mốc kết thúc", { to: "2031-01-20T00:00", price: "1" }, "from"],
    ["kết thúc trước bắt đầu", { from: "2031-01-20T00:00", to: "2031-01-19T00:00", price: "1" }, "to"],
    ["kết thúc bằng bắt đầu", { from: "2031-01-20T00:00", to: "2031-01-20T00:00", price: "1" }, "to"],
    ["năm ngoài giới hạn", { from: "1969-12-31T00:00", to: "2031-01-20T00:00", price: "1" }, "from"]
  ] as const)("từ chối %s", (_case, override, field) => {
    const { rule: parsed, errors } = parseRuleForm({ ...EMPTY_RULE_FORM, ...override });
    expect(parsed).toBeNull();
    expect(errors[field]).toBeTruthy();
  });

  it("sai nhiều ô thì báo đủ từng ô", () => {
    const { errors } = parseRuleForm({ ...EMPTY_RULE_FORM, from: "2031-01-20T00:00", price: "abc" });
    expect(Object.keys(errors).sort()).toEqual(["price", "to"]);
  });

  it("đổi quy tắc đang có sang ô nhập rồi đọc lại ra đúng quy tắc cũ", () => {
    const original = rule({ vehicleTypeId: CABIN, seatType: "CABIN", ...window(20, 27), price: 550_000 });
    const form = toRuleForm(original);
    expect(form).toMatchObject({ vehicleTypeId: CABIN, seatType: "CABIN", from: "2031-01-20T07:00", price: "550000" });
    expect(parseRuleForm(form).rule).toEqual(original);
    expect(toRuleForm(rule())).toEqual({ vehicleTypeId: ANY, seatType: ANY, from: "", to: "", price: "250000" });
  });
});

describe("trùng phạm vi giữa các quy tắc (giống máy chủ)", () => {
  it("cùng loại xe × loại chỗ: hai giá thường đụng nhau; khung giờ chồng nhau đụng nhau; nối tiếp thì không", () => {
    expect(rulesConflict(rule(), rule({ price: 1 }))).toBe(true);
    expect(rulesConflict(rule(window(1, 5)), rule(window(4, 6)))).toBe(true);
    expect(rulesConflict(rule(window(1, 5)), rule(window(5, 6)))).toBe(false);
    // Giá thường và giá theo khung giờ cùng tồn tại được: khung giờ cụ thể hơn sẽ thắng.
    expect(rulesConflict(rule(), rule(window(1, 5)))).toBe(false);
  });

  it("khác loại xe hoặc khác loại chỗ thì không đụng, kể cả 'mọi loại' so với một loại cụ thể", () => {
    expect(rulesConflict(rule(), rule({ vehicleTypeId: SLEEPER }))).toBe(false);
    expect(rulesConflict(rule({ seatType: "BED" }), rule({ seatType: "BED_DOUBLE" }))).toBe(false);
    expect(rulesConflict(rule({ seatType: "CABIN" }), rule({ seatType: "CABIN_DOUBLE" }))).toBe(false);
    expect(rulesConflict(rule({ vehicleTypeId: SLEEPER, seatType: "BED" }), rule({ vehicleTypeId: CABIN, seatType: "BED" }))).toBe(false);
  });

  it("findConflict bỏ qua chính dòng đang sửa", () => {
    const rules = [rule(), rule({ seatType: "BED" })];
    expect(findConflict(rules, rule({ price: 999 }), null)).toBe(0);
    expect(findConflict(rules, rule({ price: 999 }), 0)).toBe(-1);
    expect(findConflict(rules, rule({ seatType: "BED", price: 1 }), 0)).toBe(1);
    expect(findConflict(rules, rule({ seatType: "CABIN" }), null)).toBe(-1);
  });
});

describe("sortRules", () => {
  it("giá thường trước, rồi theo khung giờ; mọi loại xe / mọi loại chỗ đứng đầu nhóm", () => {
    const tet = rule({ ...window(20, 27), price: 600_000 });
    const sleeperBed = rule({ vehicleTypeId: SLEEPER, seatType: "BED" });
    const sleeper = rule({ vehicleTypeId: SLEEPER });
    expect(sortRules([tet, sleeperBed, sleeper, rule()])).toEqual([rule(), sleeper, sleeperBed, tet]);
  });

  it("loại chỗ theo thứ tự ghế → giường → cabin (như máy chủ), không theo bảng chữ cái", () => {
    const of = (seatType: FareRule["seatType"]) => rule({ seatType });
    const shuffled = [of("CABIN_DOUBLE"), of("BED"), of("SEAT"), of(null), of("CABIN"), of("BED_DOUBLE")];
    expect(sortRules(shuffled).map((item) => item.seatType)).toEqual([null, "SEAT", "BED", "BED_DOUBLE", "CABIN", "CABIN_DOUBLE"]);
  });
});

describe("body API", () => {
  const info = { routeId: "33333333-3333-4333-8333-333333333333", status: "INACTIVE" as const, note: "  Giá Tết  " };

  it("sửa: không gửi tuyến; ghi chú cắt khoảng trắng, rỗng thành null", () => {
    expect(toFareUpdateInput(info, [rule()])).toEqual({ status: "INACTIVE", note: "Giá Tết", rules: [rule()] });
    expect(toFareUpdateInput({ ...info, note: "   " }, []).note).toBeNull();
  });

  it("tạo: kèm tuyến đã chọn", () => {
    expect(toFareCreateInput(info, [])).toEqual({ routeId: info.routeId, status: "INACTIVE", note: "Giá Tết", rules: [] });
  });

  it("thông tin của bảng giá đã lưu", () => {
    const fare = { routeId: info.routeId, status: "ACTIVE", note: null } as Fare;
    expect(toFareInfo(fare)).toEqual({ routeId: info.routeId, status: "ACTIVE", note: "" });
  });
});

describe("describeFareSaveError", () => {
  it.each([
    ["FARE_ROUTE_CONFLICT", 409, "routeId", /đã có bảng giá/],
    ["ROUTE_UNAVAILABLE", 422, "routeId", /không còn hoạt động/],
    ["FARE_RULES_OVERLAP", 400, "rules", /bị trùng/],
    ["CATALOG_ITEM_UNAVAILABLE", 422, "rules", /danh mục/],
    ["FARE_NOT_FOUND", 404, null, /không còn tồn tại/],
    ["SERVICE_UNAVAILABLE", 503, null, /chưa thay đổi/],
    ["VALIDATION_ERROR", 400, null, /chưa hợp lệ/]
  ] as const)("%s → %s", (code, status, field, message) => {
    const described = describeFareSaveError(new ApiError(status, code, "x"));
    expect(described.field).toBe(field);
    expect(described.message).toMatch(message);
  });

  it("lỗi mạng → câu chung", () => {
    expect(describeFareSaveError(new TypeError("Failed to fetch")).message).toMatch(/kiểm tra kết nối/);
  });
});
