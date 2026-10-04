import { describe, expect, it } from "vitest";

import { ApiError } from "../auth/api-client";
import type { Vehicle } from "./vehicle-api";
import { formatPlateNumber } from "./vehicle-format";
import {
  describeSaveError,
  EMPTY_VEHICLE_FORM,
  normalizePlateNumber,
  toFormValues,
  toVehicleInput,
  vehicleFormSchema
} from "./vehicle-form";

const TYPE_ID = "11111111-1111-4111-8111-111111111111";
const valid = { ...EMPTY_VEHICLE_FORM, plateNumber: "51b-289.12", vehicleTypeId: TYPE_ID };

function messages(values: unknown): Record<string, string> {
  const result = vehicleFormSchema.safeParse(values);
  return result.success
    ? {}
    : Object.fromEntries(result.error.issues.map((issue) => [issue.path.join("."), issue.message]));
}

describe("vehicleFormSchema", () => {
  it("form hợp lệ không có lỗi; xe mới mặc định 'Hoạt động', chưa gán sơ đồ", () => {
    expect(messages(valid)).toEqual({});
    expect(EMPTY_VEHICLE_FORM).toMatchObject({ status: "ACTIVE", seatMapId: null, amenityIds: [] });
  });

  it("bỏ trống biển số và loại xe → mỗi ô một thông báo riêng", () => {
    expect(messages(EMPTY_VEHICLE_FORM)).toEqual({
      plateNumber: "Nhập biển số xe.",
      vehicleTypeId: "Chọn dạng chỗ và hạng xe."
    });
  });

  it.each(["ABC-12345", "5B-12345", "51B-123", "51B-1234567", "51ABC-12345", "51B_12345"])(
    "biển số sai dạng %j → báo định dạng (cùng luật với API)",
    (plateNumber) => {
      expect(messages({ ...valid, plateNumber })).toEqual({
        plateNumber: "Biển số không đúng định dạng. Ví dụ: 51B-289.12."
      });
    }
  );

  it.each(["51B-289.12", " 51b 289.12 ", "29B-1234", "51LD-123.45"])("chấp nhận cách gõ %j", (plateNumber) => {
    expect(messages({ ...valid, plateNumber })).toEqual({});
  });

  it("mô tả quá 500 ký tự → báo lỗi; đúng 500 thì qua", () => {
    expect(messages({ ...valid, description: "a".repeat(501) })).toEqual({
      description: "Mô tả tối đa 500 ký tự."
    });
    expect(messages({ ...valid, description: "a".repeat(500) })).toEqual({});
  });
});

describe("toVehicleInput / toFormValues", () => {
  it("gửi đủ mọi trường của PUT: biển số đã chuẩn hoá, mô tả trống → null", () => {
    expect(toVehicleInput({ ...valid, plateNumber: " 51b-289.12 ", description: "   " })).toEqual({
      plateNumber: "51B28912",
      vehicleTypeId: TYPE_ID,
      seatMapId: null,
      amenityIds: [],
      status: "ACTIVE",
      description: null
    });
    expect(normalizePlateNumber("51ld 123.45")).toBe("51LD12345");
  });

  it("xe đã lưu → form → body gửi lại không đổi dữ liệu (giữ cả tiện ích / loại xe đã ngừng)", () => {
    const vehicle = {
      id: "v",
      plateNumber: "51B28912",
      vehicleTypeId: TYPE_ID,
      seatMapId: "22222222-2222-4222-8222-222222222222",
      seatMap: null,
      seatMapLocked: false,
      amenityIds: ["a1", "a2"],
      status: "MAINTENANCE",
      description: null,
      createdAt: "",
      updatedAt: ""
    } as unknown as Vehicle;
    const values = toFormValues(vehicle, formatPlateNumber);
    expect(values).toMatchObject({ plateNumber: "51B-289.12", description: "" });
    expect(toVehicleInput(values)).toEqual({
      plateNumber: "51B28912",
      vehicleTypeId: TYPE_ID,
      seatMapId: vehicle.seatMapId,
      amenityIds: ["a1", "a2"],
      status: "MAINTENANCE",
      description: null
    });
  });
});

describe("describeSaveError — lỗi API thành thông báo tại đúng ô", () => {
  it.each([
    ["VEHICLE_PLATE_CONFLICT", 409, "plateNumber", "Biển số đã tồn tại trong nhà xe."],
    ["CATALOG_ITEM_UNAVAILABLE", 422, "vehicleTypeId", "Loại xe hoặc tiện ích đã ngừng sử dụng. Vui lòng chọn lại."],
    ["SEAT_MAP_NOT_FOUND", 404, "seatMapId", "Sơ đồ ghế không còn tồn tại. Vui lòng chọn sơ đồ khác."],
    ["VEHICLE_NOT_FOUND", 404, null, "Phương tiện không còn tồn tại. Vui lòng quay lại danh sách."],
    ["VALIDATION_ERROR", 400, null, "Thông tin chưa hợp lệ. Vui lòng kiểm tra lại các ô đã nhập."]
  ])("%s → ô %s", (code, status, field, message) => {
    expect(describeSaveError(new ApiError(status, code, "chi tiết từ máy chủ"))).toEqual({ field, message });
  });

  it("lỗi mạng / máy chủ → thông báo chung, không lộ chi tiết kỹ thuật", () => {
    const generic = { field: null, message: "Chưa lưu được phương tiện. Vui lòng kiểm tra kết nối và thử lại." };
    expect(describeSaveError(new TypeError("Failed to fetch"))).toEqual(generic);
    expect(describeSaveError(new ApiError(503, "SERVICE_UNAVAILABLE", "x"))).toEqual(generic);
  });
});
