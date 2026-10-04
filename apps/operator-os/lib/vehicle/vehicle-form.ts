// Dữ liệu form Thêm / Sửa phương tiện: kiểm tại chỗ bằng Zod (HLD §6.3) và đổi qua lại với DTO của API.
import { z } from "zod";

import { ApiError } from "../auth/api-client";
import type { Vehicle, VehicleInput } from "./vehicle-api";

const PLATE_PATTERN = /^[0-9]{2}[A-Z]{1,2}[0-9]{4,5}$/;
/** Giới hạn mô tả của API (`VehicleInputDto.description`). */
export const DESCRIPTION_MAX_LENGTH = 500;

/** Chuẩn hoá biển số giống API: chữ hoa, bỏ khoảng trắng / `.` / `-` (`51b-289.12` → `51B28912`). */
export function normalizePlateNumber(value: string): string {
  return value.toUpperCase().replace(/[\s.-]/g, "");
}

/** Luật kiểm form xe; thông báo hiện ngay dưới từng ô (06 UI §10). */
export const vehicleFormSchema = z.object({
  plateNumber: z
    .string()
    .trim()
    .min(1, "Nhập biển số xe.")
    .refine(
      (value) => value === "" || PLATE_PATTERN.test(normalizePlateNumber(value)),
      "Biển số không đúng định dạng. Ví dụ: 51B-289.12."
    ),
  vehicleTypeId: z.string().min(1, "Chọn dạng chỗ và hạng xe."),
  status: z.enum(["ACTIVE", "MAINTENANCE", "INACTIVE"]),
  amenityIds: z.array(z.string()),
  seatMapId: z.string().nullable(),
  description: z.string().max(DESCRIPTION_MAX_LENGTH, `Mô tả tối đa ${DESCRIPTION_MAX_LENGTH} ký tự.`)
});
export type VehicleFormValues = z.infer<typeof vehicleFormSchema>;

/** Giá trị ban đầu của form "Thêm phương tiện". */
export const EMPTY_VEHICLE_FORM: VehicleFormValues = {
  plateNumber: "",
  vehicleTypeId: "",
  status: "ACTIVE",
  amenityIds: [],
  seatMapId: null,
  description: ""
};

/** Đưa xe đã lưu vào form sửa. */
export function toFormValues(vehicle: Vehicle, formatPlate: (plateNumber: string) => string): VehicleFormValues {
  return {
    plateNumber: formatPlate(vehicle.plateNumber),
    vehicleTypeId: vehicle.vehicleTypeId,
    status: vehicle.status,
    amenityIds: vehicle.amenityIds,
    seatMapId: vehicle.seatMapId,
    description: vehicle.description ?? ""
  };
}

/** Body gửi API: PUT thay toàn bộ nên luôn gửi đủ mọi trường; mô tả trống gửi `null`. */
export function toVehicleInput(values: VehicleFormValues): VehicleInput {
  const description = values.description.trim();
  return {
    plateNumber: normalizePlateNumber(values.plateNumber.trim()),
    vehicleTypeId: values.vehicleTypeId,
    seatMapId: values.seatMapId,
    amenityIds: values.amenityIds,
    status: values.status,
    description: description === "" ? null : description
  };
}

/** Ô của form mà lỗi lưu thuộc về; `null` = lỗi chung của cả form. */
export type SaveErrorField = "plateNumber" | "vehicleTypeId" | "seatMapId" | null;

/** Đổi lỗi API khi lưu xe thành thông báo cho người dùng và ô cần sửa (mã lỗi theo GLOSSARY). */
export function describeSaveError(error: unknown): { field: SaveErrorField; message: string } {
  if (error instanceof ApiError) {
    switch (error.code) {
      case "VEHICLE_PLATE_CONFLICT":
        return { field: "plateNumber", message: "Biển số đã tồn tại trong nhà xe." };
      case "CATALOG_ITEM_UNAVAILABLE":
        return {
          field: "vehicleTypeId",
          message: "Loại xe hoặc tiện ích đã ngừng sử dụng. Vui lòng chọn lại."
        };
      case "SEAT_MAP_NOT_FOUND":
        return { field: "seatMapId", message: "Sơ đồ ghế không còn tồn tại. Vui lòng chọn sơ đồ khác." };
      case "VEHICLE_NOT_FOUND":
        return { field: null, message: "Phương tiện không còn tồn tại. Vui lòng quay lại danh sách." };
    }
    if (error.status === 400) {
      return { field: null, message: "Thông tin chưa hợp lệ. Vui lòng kiểm tra lại các ô đã nhập." };
    }
  }
  return { field: null, message: "Chưa lưu được phương tiện. Vui lòng kiểm tra kết nối và thử lại." };
}
