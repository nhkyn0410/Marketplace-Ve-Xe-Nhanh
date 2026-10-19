import { HttpException, HttpStatus } from "@nestjs/common";

const TITLE = "Seat hold error";

function problem(status: HttpStatus, code: string, detail: string, reasons?: string[]): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title, reasons }` → RFC 7807 (ADR-012, API §6.2).
  return new HttpException({ code, detail, title: TITLE, ...(reasons ? { reasons } : {}) }, status);
}

/** Chuyến không tồn tại / không còn mở bán / quá giờ bán online — cùng một lỗi với chi tiết chuyến công khai. */
export function tripNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "TRIP_NOT_FOUND", "Không tìm thấy chuyến hoặc chuyến không còn mở bán.");
}

/** Mã chỗ không thuộc chuyến. */
export function seatUnknown(): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "TRIP_SEAT_UNKNOWN", "Có mã chỗ không thuộc chuyến.");
}

/** Chỗ đã bán / đã khóa / chưa có giá — `reasons` = mã chỗ. */
export function seatNotAvailable(seatCodes: string[]): HttpException {
  return problem(HttpStatus.CONFLICT, "SEAT_NOT_AVAILABLE", `Chỗ ${seatCodes.join(", ")} không còn đặt được.`, seatCodes);
}

/** Chỗ đang được người khác giữ (LLD §6.1) — `reasons` = mã chỗ. */
export function seatHoldConflict(seatCode: string): HttpException {
  return problem(HttpStatus.CONFLICT, "SEAT_HOLD_CONFLICT", `Chỗ ${seatCode} vừa được người khác giữ. Chọn chỗ khác.`, [seatCode]);
}

/** Giữ chỗ hết hạn / không tồn tại / không phải của người gọi. */
export function seatHoldExpired(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "SEAT_HOLD_EXPIRED", "Phiên giữ chỗ đã hết hạn. Chọn lại chỗ.");
}

/** Điểm đón / trả không hợp lệ (BR-23): không cho đón / trả, hoặc điểm đón không đứng trước điểm trả. */
export function stopsInvalid(): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "SEAT_HOLD_STOPS_INVALID", "Điểm đón phải cho đón, điểm trả phải cho trả và điểm đón đứng trước điểm trả.");
}

/** Giữ chỗ quá nhiều lần từ một địa chỉ trong 10 phút (chống giữ chỗ hàng loạt). */
export function holdRateLimited(): HttpException {
  return problem(HttpStatus.TOO_MANY_REQUESTS, "SEAT_HOLD_RATE_LIMITED", "Bạn giữ chỗ quá nhiều lần. Vui lòng thử lại sau ít phút.");
}

/** Redis không truy cập được — không giữ chỗ trong bộ nhớ thay thế (ADR-015: tránh bán trùng). */
export function holdUnavailable(): HttpException {
  return problem(HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE", "Hệ thống giữ chỗ tạm thời gián đoạn. Vui lòng thử lại.");
}
