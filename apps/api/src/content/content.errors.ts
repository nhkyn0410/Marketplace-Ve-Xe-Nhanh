import { HttpException, HttpStatus } from "@nestjs/common";

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  return new HttpException({ code, detail, title: "Content error" }, status);
}

/** Bài không tồn tại — hoặc, ở API công khai, chưa xuất bản / chưa tới giờ / đã gỡ (BR-74). */
export function articleNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "ARTICLE_NOT_FOUND", "Không tìm thấy bài viết.");
}

export function articleSlugConflict(): HttpException {
  return problem(HttpStatus.CONFLICT, "ARTICLE_SLUG_CONFLICT", "Slug này đã được dùng.");
}

/** Xuất bản bài đang xuất bản, gỡ bài chưa xuất bản… */
export function articleStateInvalid(): HttpException {
  return problem(HttpStatus.CONFLICT, "ARTICLE_STATE_INVALID", "Trạng thái bài viết vừa thay đổi.");
}

/** Xuất bản bài chưa có nội dung. */
export function articleIncomplete(): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "ARTICLE_INCOMPLETE", "Bài viết chưa có nội dung.");
}

/** Chuyên mục không tồn tại hoặc đã ngừng dùng (không chọn được cho bài mới — FR-ADM-19). */
export function articleCategoryUnavailable(): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "ARTICLE_CATEGORY_UNAVAILABLE", "Chuyên mục không còn dùng được.");
}

export function articleCategoryNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "ARTICLE_CATEGORY_NOT_FOUND", "Không tìm thấy chuyên mục.");
}

export function articleCategorySlugConflict(): HttpException {
  return problem(HttpStatus.CONFLICT, "ARTICLE_CATEGORY_SLUG_CONFLICT", "Slug chuyên mục đã được dùng.");
}

/** Ảnh bìa không phải object hợp lệ đã tải lên kho (khóa lạ, thiếu, sai loại / dung lượng / chữ ký). */
export function articleImageInvalid(): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "ARTICLE_IMAGE_INVALID", "Ảnh không hợp lệ. Vui lòng tải lại ảnh.");
}

/** Ghi audit / kho ảnh không phản hồi — chưa có gì thay đổi. */
export function contentServiceUnavailable(): HttpException {
  return problem(
    HttpStatus.SERVICE_UNAVAILABLE,
    "SERVICE_UNAVAILABLE",
    "Hệ thống tạm thời không phản hồi nên thay đổi chưa được lưu. Vui lòng thử lại sau.",
  );
}
