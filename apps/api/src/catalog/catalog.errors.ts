import { HttpException, HttpStatus } from "@nestjs/common";

/**
 * Item catalog (loại xe, tiện ích, tỉnh/phường) không tồn tại, đã ngừng dùng hoặc không khớp nhau
 * (phường khác tỉnh). Dùng chung cho mọi module Operator tham chiếu catalog (TRN-001, TRN-002).
 */
export function catalogItemUnavailable(): HttpException {
  return new HttpException(
    {
      code: "CATALOG_ITEM_UNAVAILABLE",
      detail: "Dữ liệu danh mục (loại xe, tiện ích, tỉnh/phường) không tồn tại hoặc đã ngừng sử dụng.",
      title: "Catalog error",
    },
    HttpStatus.UNPROCESSABLE_ENTITY,
  );
}

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  return new HttpException({ code, detail, title: "Catalog error" }, status);
}

/** Admin thêm mục danh mục trùng mã (mã là khóa nghiệp vụ, unique). */
export function catalogCodeConflict(): HttpException {
  return problem(HttpStatus.CONFLICT, "CATALOG_CODE_CONFLICT", "Mã này đã có trong danh mục.");
}

/** Admin thao tác mục danh mục không tồn tại. */
export function catalogItemNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "CATALOG_ITEM_NOT_FOUND", "Không tìm thấy mục danh mục.");
}

/** Ngừng dùng mục đã ngừng / dùng lại mục đang dùng (trạng thái vừa đổi ở nơi khác). */
export function catalogStateInvalid(): HttpException {
  return problem(HttpStatus.CONFLICT, "CATALOG_STATE_INVALID", "Trạng thái mục danh mục đã thay đổi.");
}

/** Ghi audit lỗi trong transaction: thay đổi không được lưu. */
export function catalogAuditUnavailable(): HttpException {
  return problem(
    HttpStatus.SERVICE_UNAVAILABLE,
    "SERVICE_UNAVAILABLE",
    "Chưa ghi được nhật ký nên thay đổi chưa được lưu. Vui lòng thử lại sau.",
  );
}
