import { describe, expect, it } from "vitest";

import {
  amenitySummary,
  formatPlateNumber,
  seatMapSummaryLine,
  sortVehicleTypes,
  VEHICLE_STATUS,
  vehicleTypeLabel
} from "./vehicle-format";

describe("formatPlateNumber", () => {
  it.each([
    ["51B28912", "51B-289.12"],
    ["29B1234", "29B-1234"],
    ["51LD12345", "51LD-123.45"]
  ])("%s → %s", (stored, shown) => {
    expect(formatPlateNumber(stored)).toBe(shown);
  });

  it("chuỗi không đúng dạng đã chuẩn hoá thì giữ nguyên, không đoán", () => {
    expect(formatPlateNumber("ABC")).toBe("ABC");
    expect(formatPlateNumber("51B-289.12")).toBe("51B-289.12");
  });
});

describe("loại xe (BR-77)", () => {
  it("nhãn ghép dạng chỗ · hạng xe", () => {
    expect(vehicleTypeLabel({ form: "SLEEPER", class: "LIMOUSINE" })).toBe("Giường nằm · Limousine");
    expect(vehicleTypeLabel({ form: "SEATER", class: "STANDARD" })).toBe("Ghế ngồi · Thường");
    expect(vehicleTypeLabel({ form: "CABIN", class: "STANDARD" })).toBe("Cabin · Thường");
  });

  it("sắp hạng thường trước, mỗi hạng theo ghế ngồi → giường nằm → cabin; không đổi mảng gốc", () => {
    // Thứ tự API trả (theo mã): CABIN, CABIN_LIMOUSINE, SEATER, SEATER_LIMOUSINE, SLEEPER, SLEEPER_LIMOUSINE.
    const fromApi = [
      { form: "CABIN", class: "STANDARD" },
      { form: "CABIN", class: "LIMOUSINE" },
      { form: "SEATER", class: "STANDARD" },
      { form: "SEATER", class: "LIMOUSINE" },
      { form: "SLEEPER", class: "STANDARD" },
      { form: "SLEEPER", class: "LIMOUSINE" }
    ] as const;
    const copy = [...fromApi];
    expect(sortVehicleTypes(copy).map(vehicleTypeLabel)).toEqual([
      "Ghế ngồi · Thường",
      "Giường nằm · Thường",
      "Cabin · Thường",
      "Ghế ngồi · Limousine",
      "Giường nằm · Limousine",
      "Cabin · Limousine"
    ]);
    expect(copy).toEqual(fromApi);
  });
});

describe("trạng thái xe", () => {
  it("INACTIVE hiện là 'Ngừng dùng' (TRN-001 Q2), không phải 'Tạm ngưng'", () => {
    expect(VEHICLE_STATUS.INACTIVE.label).toBe("Ngừng dùng");
    expect(VEHICLE_STATUS.ACTIVE).toEqual({ label: "Hoạt động", tone: "success" });
    expect(VEHICLE_STATUS.MAINTENANCE).toEqual({ label: "Bảo dưỡng", tone: "warning" });
  });
});

describe("seatMapSummaryLine (BR-78)", () => {
  it("số chỗ và sức chứa là hai số riêng", () => {
    expect(seatMapSummaryLine({ seatCount: 22, passengerCapacity: 44, deckCount: 2 })).toBe(
      "22 chỗ · 44 người · 2 tầng"
    );
  });
});

describe("amenitySummary — hai dòng của cột Tiện ích", () => {
  it.each([
    [[], "Chưa có tiện ích", "", 0],
    [["Điều hòa"], "Điều hòa", "Chưa có tiện ích khác", 0],
    [["Điều hòa", "Nước uống"], "Điều hòa", "Nước uống", 0],
    [["Điều hòa", "Wi-Fi", "Nước uống"], "Điều hòa · Wi-Fi", "Nước uống", 0],
    [["Điều hòa", "Wi-Fi", "Nước uống", "Cổng sạc"], "Điều hòa · Wi-Fi", "Nước uống · Cổng sạc", 0],
    // Từ 5 tiện ích: dòng hai chỉ còn tên thứ ba, phần còn lại thành con số.
    [["Điều hòa", "Wi-Fi", "Nước uống", "Cổng sạc", "Chăn đắp"], "Điều hòa · Wi-Fi", "Nước uống", 2],
    [["Điều hòa", "Wi-Fi", "Cổng sạc", "Nước uống", "Chăn đắp", "Nhà vệ sinh"], "Điều hòa · Wi-Fi", "Cổng sạc", 3]
  ])("%j → %s / %s / +%i", (names, first, second, more) => {
    expect(amenitySummary(names)).toEqual({ first, second, more });
  });
});
