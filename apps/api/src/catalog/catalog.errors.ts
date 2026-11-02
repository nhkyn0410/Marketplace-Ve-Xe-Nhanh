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

// ── Nội dung công khai (TASK-ADM-003) ────────────────────────────────────────────────────────────────────────

/** Nội dung không tồn tại (Admin) hoặc chưa hiển thị (API công khai). */
export function contentPageNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "CONTENT_PAGE_NOT_FOUND", "Không tìm thấy nội dung.");
}

/** Đường dẫn trang tĩnh đã có trang khác dùng. */
export function contentPageSlugConflict(): HttpException {
  return problem(HttpStatus.CONFLICT, "CONTENT_PAGE_SLUG_CONFLICT", "Đường dẫn này đã có trang khác dùng.");
}

/** Sửa nội dung mà đổi loại (FAQ / banner / trang tĩnh) — tạo nội dung mới thay vì đổi loại. */
export function contentPageTypeImmutable(): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "CONTENT_PAGE_TYPE_IMMUTABLE", "Không đổi được loại nội dung sau khi tạo.");
}

/** Hiển thị nội dung đang hiển thị / ẩn nội dung đang nháp (trạng thái vừa đổi ở nơi khác). */
export function contentPageStateInvalid(): HttpException {
  return problem(HttpStatus.CONFLICT, "CONTENT_PAGE_STATE_INVALID", "Trạng thái nội dung đã thay đổi. Tải lại rồi thử lại.");
}

/** Ảnh banner không phải object do máy chủ cấp khóa / chưa tải lên / sai loại / quá dung lượng. */
export function contentImageInvalid(): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "CONTENT_IMAGE_INVALID", "Ảnh chưa tải lên xong hoặc không hợp lệ.");
}

/** Kho ảnh công khai lỗi — chưa cấp được URL tải / chưa kiểm được ảnh. */
export function contentStorageUnavailable(): HttpException {
  return problem(HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE", "Kho ảnh tạm thời không truy cập được. Vui lòng thử lại sau.");
}
