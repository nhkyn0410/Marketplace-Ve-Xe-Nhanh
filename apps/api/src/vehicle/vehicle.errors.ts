import { HttpException, HttpStatus } from "@nestjs/common";

const TITLE = "Vehicle error";

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title }` → RFC 7807 (ADR-012).
  return new HttpException({ code, detail, title: TITLE }, status);
}

/** Xe không tồn tại HOẶC thuộc tenant khác — cùng một lỗi để chống dò id (IDOR). */
export function vehicleNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "VEHICLE_NOT_FOUND", "Không tìm thấy phương tiện.");
}

/** Biển số (đã chuẩn hoá) đã có trong nhà xe. */
export function vehiclePlateConflict(): HttpException {
  return problem(HttpStatus.CONFLICT, "VEHICLE_PLATE_CONFLICT", "Biển số đã tồn tại trong nhà xe.");
}

/** SeatMap không tồn tại HOẶC thuộc tenant khác — cùng một lỗi để chống dò id. */
export function seatMapNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "SEAT_MAP_NOT_FOUND", "Không tìm thấy sơ đồ ghế.");
}

/** UC-12 A3: sơ đồ ghế đang được chuyến chưa kết thúc dùng — không sửa bố cục / đổi sơ đồ của xe. */
export function seatMapInUse(): HttpException {
  return problem(
    HttpStatus.CONFLICT,
    "SEAT_MAP_IN_USE",
    "Sơ đồ ghế đang được chuyến chưa kết thúc sử dụng, không thay đổi được.",
  );
}

/** Tên SeatMap đã dùng trong nhà xe. */
export function seatMapNameConflict(): HttpException {
  return problem(HttpStatus.CONFLICT, "SEAT_MAP_NAME_CONFLICT", "Tên sơ đồ ghế đã tồn tại trong nhà xe.");
}

/**
 * Ảnh gửi lên không gắn được vào xe (BR-76): khóa không thuộc xe này, object chưa tải lên, sai loại, quá dung
 * lượng hoặc không phải file ảnh thật. Bộ ảnh đang có giữ nguyên.
 */
export function vehicleImageInvalid(): HttpException {
  return problem(
    HttpStatus.UNPROCESSABLE_ENTITY,
    "VEHICLE_IMAGE_INVALID",
    "Có ảnh không hợp lệ hoặc không còn trên kho. Tải lại trang, xóa ảnh đó rồi tải lên lại.",
  );
}

/** Quá số ảnh tối đa của một xe (BR-76). */
export function vehicleImageLimitExceeded(max: number): HttpException {
  return problem(
    HttpStatus.UNPROCESSABLE_ENTITY,
    "VEHICLE_IMAGE_LIMIT_EXCEEDED",
    `Mỗi phương tiện có tối đa ${max} ảnh.`,
  );
}

/** Xin URL tải ảnh quá nhiều lần trong thời gian ngắn (LLD §6.12 bước 2). */
export function vehicleImageUploadRateLimited(): HttpException {
  return problem(
    HttpStatus.TOO_MANY_REQUESTS,
    "VEHICLE_IMAGE_UPLOAD_RATE_LIMITED",
    "Bạn tải ảnh quá nhanh. Vui lòng thử lại sau ít phút.",
  );
}

/** Kho lưu ảnh hoặc bộ đếm tần suất không phản hồi — chưa có gì thay đổi, client thử lại. */
export function vehicleImageStorageUnavailable(): HttpException {
  return problem(
    HttpStatus.SERVICE_UNAVAILABLE,
    "SERVICE_UNAVAILABLE",
    "Kho lưu ảnh tạm thời không phản hồi. Vui lòng thử lại sau.",
  );
}
