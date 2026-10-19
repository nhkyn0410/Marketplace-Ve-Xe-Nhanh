import { HttpException, HttpStatus } from "@nestjs/common";

const TITLE = "Booking error";

function problem(status: HttpStatus, code: string, detail: string, reasons?: string[]): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title, reasons }` → RFC 7807 (ADR-012, API §6.2).
  return new HttpException({ code, detail, title: TITLE, ...(reasons ? { reasons } : {}) }, status);
}

/** Booking không tồn tại HOẶC người gọi không có quyền xem (không lộ việc mã booking có thật). */
export function bookingNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "BOOKING_NOT_FOUND", "Không tìm thấy booking.");
}

/** Hành khách khai không khớp các chỗ đã giữ. */
export function passengersMismatch(): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "BOOKING_PASSENGERS_MISMATCH", "Mỗi chỗ đã giữ cần đúng một hành khách.");
}

/** Chuyến không còn mở bán / đã quá giờ bán online / nhà xe tạm khóa. */
export function tripNotOnSale(): HttpException {
  return problem(HttpStatus.CONFLICT, "TRIP_NOT_ON_SALE", "Chuyến không còn mở bán online.");
}

/** Tổng tiền tính lại khác số khách đã thấy (LLD §7 `BOOKING_SNAPSHOT_CHANGED`) — `reasons[0]` = tổng mới. */
export function snapshotChanged(newTotal: number): HttpException {
  return problem(HttpStatus.CONFLICT, "BOOKING_SNAPSHOT_CHANGED", "Giá vé vừa thay đổi. Xem lại tổng tiền rồi xác nhận.", [String(newTotal)]);
}

/** Phiên giữ chỗ đã được dùng tạo booking (gửi lặp). */
export function holdAlreadyUsed(): HttpException {
  return problem(HttpStatus.CONFLICT, "BOOKING_ALREADY_CREATED", "Phiên giữ chỗ này đã được dùng để tạo booking.");
}
