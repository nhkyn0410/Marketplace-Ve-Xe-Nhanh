// Chữ hiển thị + luật kiểm form của màn Danh mục chuẩn (Figma ADM-04a…04c; TASK-ADM-001 phần catalog). Hàm thuần.
// Luật mã khớp DTO của API (`admin-catalog.dto.ts`).
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";

import type { CatalogItem, CatalogKind, CatalogStatus, VehicleClass, VehicleForm } from "./catalog-api";

type Tone = "success" | "warning" | "neutral" | "danger";

export const CATALOG_STATUS: Record<CatalogStatus, { label: string; tone: Tone }> = {
  ACTIVE: { label: "Đang dùng", tone: "success" },
  INACTIVE: { label: "Ngừng dùng", tone: "neutral" }
};

export const VEHICLE_FORM_LABELS: Record<VehicleForm, string> = {
  SEATER: "Ghế ngồi",
  SLEEPER: "Giường nằm",
  CABIN: "Cabin"
};

export const VEHICLE_CLASS: Record<VehicleClass, { label: string; tone: Tone }> = {
  STANDARD: { label: "Tiêu chuẩn", tone: "neutral" },
  LIMOUSINE: { label: "Limousine", tone: "warning" }
};

/** Tên tab, chữ nút "Thêm …" và danh từ trong câu báo của từng danh mục. */
export const KIND_COPY: Record<CatalogKind, { tab: string; add: string; noun: string }> = {
  provinces: { tab: "Tỉnh / thành", add: "Thêm tỉnh / thành", noun: "tỉnh / thành" },
  wards: { tab: "Phường / xã", add: "Thêm phường / xã", noun: "phường / xã" },
  "vehicle-types": { tab: "Loại xe", add: "Thêm loại xe", noun: "loại xe" },
  amenities: { tab: "Tiện ích", add: "Thêm tiện ích", noun: "tiện ích" }
};

export const CATALOG_KINDS = ["provinces", "wards", "vehicle-types", "amenities"] as const satisfies readonly CatalogKind[];

export const NAME_MAX_LENGTH = 100;
export const DESCRIPTION_MAX_LENGTH = 300;
export const REASON_MAX_LENGTH = 500;

/** Mã mới hợp lệ theo loại danh mục; `null` = hợp lệ. Mã loại xe / tiện ích tự viết hoa. */
export function codeError(kind: CatalogKind, code: string): string | null {
  const value = code.trim();
  switch (kind) {
    case "provinces":
      return /^\d{2}$/.test(value) ? null : "Mã tỉnh / thành gồm 2 chữ số theo danh mục hành chính.";
    case "wards":
      return /^\d{5}$/.test(value) ? null : "Mã phường / xã gồm 5 chữ số theo danh mục hành chính.";
    default:
      return /^[A-Z0-9_]{2,40}$/.test(value.toUpperCase()) ? null : "Mã gồm 2–40 ký tự chữ không dấu, số, gạch dưới.";
  }
}

export function nameError(name: string): string | null {
  const length = name.trim().length;
  if (length === 0) {
    return "Nhập tên.";
  }
  return length > NAME_MAX_LENGTH ? `Tên tối đa ${NAME_MAX_LENGTH} ký tự.` : null;
}

export function reasonError(reason: string): string | null {
  const length = reason.trim().length;
  if (length < 3) {
    return "Nhập lý do (ít nhất 3 ký tự).";
  }
  return length > REASON_MAX_LENGTH ? `Lý do tối đa ${REASON_MAX_LENGTH} ký tự.` : null;
}

/** Các dòng "Mức ảnh hưởng" của hộp thoại ngừng dùng (Figma ADM-04c), theo loại danh mục. */
export function impactRows(kind: CatalogKind, item: CatalogItem): { label: string; value: string }[] {
  if (kind === "provinces" && "wardCount" in item) {
    return [
      { label: "Phường / xã thuộc tỉnh", value: `${item.wardCount} phường / xã` },
      { label: "Điểm dừng dùng chung trong tỉnh", value: `${item.stopPointCount} điểm` }
    ];
  }
  if (kind === "wards" && "provinceName" in item) {
    return [{ label: "Điểm dừng dùng chung trong phường / xã", value: `${item.stopPointCount} điểm` }];
  }
  if (kind === "vehicle-types" && "fareRuleCount" in item) {
    return [
      { label: "Xe đang dùng loại này", value: `${item.vehicleCount} xe của ${item.operatorCount} nhà xe` },
      { label: "Quy tắc giá tham chiếu", value: `${item.fareRuleCount} quy tắc` }
    ];
  }
  if ("vehicleCount" in item) {
    return [{ label: "Xe đang khai tiện ích này", value: `${item.vehicleCount} xe` }];
  }
  return [];
}

/** Câu giải thích hậu quả ngừng dùng (UC-24 bước 6): không chọn được cho dữ liệu mới, dữ liệu cũ giữ nguyên. */
export const DEACTIVATE_NOTE: Record<CatalogKind, string> = {
  provinces:
    "Sau khi ngừng dùng, tỉnh / thành này cùng phường / xã và điểm dừng dùng chung thuộc tỉnh không chọn được cho dữ liệu mới và ẩn khỏi danh mục công khai. Tuyến, chuyến hiện có không thay đổi.",
  wards:
    "Sau khi ngừng dùng, phường / xã này và điểm dừng dùng chung thuộc phường không chọn được cho dữ liệu mới. Tuyến, chuyến hiện có không thay đổi.",
  "vehicle-types":
    "Sau khi ngừng dùng, nhà xe không chọn được loại xe này cho xe mới. Xe, bảng giá và vé hiện có không thay đổi.",
  amenities: "Sau khi ngừng dùng, nhà xe không khai được tiện ích này cho xe. Xe đang khai tiện ích vẫn giữ nguyên."
};

/** Lỗi API → ô báo lỗi (`code`) hay báo chung; `refresh` = danh sách có thể đã cũ. */
export function describeCatalogError(error: unknown): { field: "code" | "form"; message: string; refresh?: boolean } {
  if (!(error instanceof ApiError)) {
    return { field: "form", message: "Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại." };
  }
  switch (error.code) {
    case "CATALOG_CODE_CONFLICT":
      return { field: "code", message: "Mã này đã có trong danh mục." };
    case "CATALOG_STATE_INVALID":
      return { field: "form", message: "Trạng thái mục này vừa thay đổi. Đã tải lại danh sách.", refresh: true };
    case "CATALOG_ITEM_NOT_FOUND":
      return { field: "form", message: "Không còn tìm thấy mục này. Đã tải lại danh sách.", refresh: true };
    case "VALIDATION_FAILED":
      return { field: "form", message: "Thông tin chưa hợp lệ. Kiểm tra lại các ô rồi thử lại." };
    default:
      return error.status === 503
        ? { field: "form", message: "Hệ thống tạm thời không phản hồi nên chưa lưu được. Vui lòng thử lại sau." }
        : { field: "form", message: error.message || "Không thực hiện được thao tác. Vui lòng thử lại." };
  }
}
