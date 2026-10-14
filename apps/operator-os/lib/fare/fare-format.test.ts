import { describe, expect, it } from "vitest";

import type { FareRevision, FareRule } from "./fare-api";
import {
  describeRevision,
  FARE_STATUS,
  FARE_STATUS_ORDER,
  formatMoment,
  formatVnd,
  priceRangeLabel,
  ruleCountLabel,
  ruleSeatTypeLabel,
  ruleVehicleTypeLabel,
  ruleWindowLabel
} from "./fare-format";

const SLEEPER = "11111111-1111-4111-8111-111111111111";
const names = new Map([[SLEEPER, "Giường nằm · Limousine"]]);
const rule = (overrides: Partial<FareRule> = {}): FareRule => ({
  vehicleTypeId: null,
  seatType: null,
  validFrom: null,
  validTo: null,
  price: 250_000,
  ...overrides
});
const TET = { validFrom: "2031-01-19T17:00:00.000Z", validTo: "2031-01-26T17:00:00.000Z" };

describe("định dạng tiền", () => {
  it("số nguyên đồng có dấu chấm ngăn hàng nghìn và ký hiệu ₫", () => {
    expect(formatVnd(250_000)).toBe("250.000 ₫");
    expect(formatVnd(0)).toBe("0 ₫");
    expect(formatVnd(100_000_000)).toBe("100.000.000 ₫");
  });

  it("khoảng giá: hai đầu, một giá khi bằng nhau, gạch khi chưa có quy tắc", () => {
    expect(priceRangeLabel(250_000, 760_000)).toBe("250.000 ₫ – 760.000 ₫");
    expect(priceRangeLabel(320_000, 320_000)).toBe("320.000 ₫");
    expect(priceRangeLabel(null, null)).toBe("—");
    // Giá 0 là giá hợp lệ, không bị coi là "chưa có".
    expect(priceRangeLabel(0, 0)).toBe("0 ₫");
  });

  it("số quy tắc", () => {
    expect(ruleCountLabel(6)).toBe("6 quy tắc");
    expect(ruleCountLabel(0)).toBe("Chưa có quy tắc");
  });
});

describe("nhãn của một quy tắc", () => {
  it("loại chỗ và loại xe: null là mọi loại; loại xe không còn trong danh mục có nhãn riêng", () => {
    expect(ruleSeatTypeLabel(null)).toBe("Mọi loại chỗ");
    expect(ruleSeatTypeLabel("BED_DOUBLE")).toBe("Giường đôi");
    expect(ruleSeatTypeLabel("CABIN")).toBe("Cabin đơn");
    expect(ruleVehicleTypeLabel(names, null)).toBe("Mọi loại xe");
    expect(ruleVehicleTypeLabel(names, SLEEPER)).toBe("Giường nằm · Limousine");
    expect(ruleVehicleTypeLabel(names, "khong-co")).toBe("Loại xe đã ngừng dùng");
  });

  it("khung giờ khởi hành theo giờ Việt Nam; không có khung giờ là giá mọi ngày", () => {
    expect(ruleWindowLabel(rule())).toBe("Mọi ngày");
    expect(ruleWindowLabel(rule(TET))).toBe("20/01/2031 00:00 – 27/01/2031 00:00");
    expect(formatMoment("2026-10-08T07:20:00.000Z")).toBe("08/10/2026 14:20");
  });

  it("đủ nhãn cho mọi trạng thái", () => {
    expect([...FARE_STATUS_ORDER].sort()).toEqual(Object.keys(FARE_STATUS).sort());
    expect(FARE_STATUS.ACTIVE).toEqual({ label: "Đang áp dụng", tone: "success" });
    expect(FARE_STATUS.INACTIVE.label).toBe("Ngừng áp dụng");
  });
});

describe("describeRevision", () => {
  const snapshot = (rules: FareRule[], overrides: Partial<NonNullable<FareRevision["before"]>> = {}) => ({
    routeId: "22222222-2222-4222-8222-222222222222",
    status: "ACTIVE" as const,
    note: null,
    rules,
    ...overrides
  });
  const update = (before: FareRule[], after: FareRule[], afterOverrides = {}) =>
    describeRevision({ action: "fare.update", before: snapshot(before), after: snapshot(after, afterOverrides) }, names);
  const bed = rule({ vehicleTypeId: SLEEPER, seatType: "BED", price: 290_000 });

  it("tạo bảng giá: nêu số quy tắc", () => {
    expect(describeRevision({ action: "fare.create", before: null, after: snapshot([rule(), bed]) }, names)).toEqual({
      title: "Tạo bảng giá",
      detail: "2 quy tắc"
    });
  });

  it("đổi giá đúng một quy tắc: nêu quy tắc và giá cũ → giá mới", () => {
    expect(update([rule(), bed], [rule(), { ...bed, price: 300_000 }])).toEqual({
      title: "Sửa giá giường đơn · Giường nằm · Limousine",
      detail: "290.000 ₫ → 300.000 ₫"
    });
  });

  it("thêm / xóa đúng một quy tắc: nêu quy tắc và giá của nó", () => {
    const cabinDouble = rule({ seatType: "CABIN_DOUBLE", price: 760_000 });
    expect(update([rule()], [rule(), cabinDouble])).toEqual({ title: "Thêm quy tắc cabin đôi", detail: "760.000 ₫" });
    expect(update([rule(), cabinDouble], [rule()])).toEqual({ title: "Xóa quy tắc cabin đôi", detail: "760.000 ₫" });
    const tet = rule({ ...TET, price: 600_000 });
    expect(update([rule()], [rule(), tet]).title).toBe("Thêm quy tắc mọi loại chỗ, 20/01/2031 00:00 – 27/01/2031 00:00");
  });

  it("nhiều thay đổi: đếm thêm / xóa / đổi giá; đổi khung giờ tính là xóa một + thêm một", () => {
    const tet = rule({ ...TET, price: 600_000 });
    const moved = rule({ validFrom: "2031-01-20T17:00:00.000Z", validTo: TET.validTo, price: 600_000 });
    expect(update([rule(), bed, tet], [rule({ price: 260_000 }), bed, moved])).toEqual({
      title: "Sửa quy tắc giá",
      detail: "thêm 1 · xóa 1 · đổi giá 1 quy tắc"
    });
  });

  it("chỉ đổi trạng thái / ghi chú; đổi quy tắc kèm đổi trạng thái thì ghi cả hai", () => {
    expect(update([rule()], [rule()], { status: "INACTIVE" })).toEqual({
      title: "Đổi trạng thái",
      detail: "Đang áp dụng → Ngừng áp dụng"
    });
    expect(update([rule()], [rule()], { note: "Giá Tết" })).toEqual({ title: "Sửa ghi chú", detail: "" });
    expect(update([rule()], [rule({ price: 300_000 })], { status: "INACTIVE" }).detail).toBe(
      "250.000 ₫ → 300.000 ₫ · Đang áp dụng → Ngừng áp dụng"
    );
  });
});
