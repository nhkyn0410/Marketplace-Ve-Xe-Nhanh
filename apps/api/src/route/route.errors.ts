import { HttpException, HttpStatus } from "@nestjs/common";

const TITLE = "Route error";

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title }` → RFC 7807 (ADR-012).
  return new HttpException({ code, detail, title: TITLE }, status);
}

/** Route không tồn tại HOẶC thuộc tenant khác — cùng một lỗi để chống dò id (IDOR). */
export function routeNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "ROUTE_NOT_FOUND", "Không tìm thấy tuyến.");
}

/** Tên route đã dùng trong nhà xe. */
export function routeNameConflict(): HttpException {
  return problem(HttpStatus.CONFLICT, "ROUTE_NAME_CONFLICT", "Tên tuyến đã tồn tại trong nhà xe.");
}

/**
 * Cho đón / cho trả không đúng quy tắc (BR-79): điểm đầu chỉ đón, điểm cuối chỉ trả, điểm giữa có ít nhất
 * một quyền; trạm dừng nghỉ không đón, không trả và không đứng đầu / cuối.
 */
export function routeStopPickupDropoffInvalid(): HttpException {
  return problem(
    HttpStatus.UNPROCESSABLE_ENTITY,
    "ROUTE_STOP_PICKUP_DROPOFF_INVALID",
    "Cho đón / cho trả chưa đúng quy tắc: điểm đầu chỉ đón, điểm cuối chỉ trả, điểm giữa có ít nhất một quyền; trạm dừng nghỉ không đón, không trả và không đứng đầu hoặc cuối tuyến.",
  );
}

/** Goong (hoặc provider routing) không trả được số liệu hợp lệ — route không được lưu (Q5). */
export function routingProviderUnavailable(): HttpException {
  return problem(
    HttpStatus.SERVICE_UNAVAILABLE,
    "ROUTING_PROVIDER_UNAVAILABLE",
    "Chưa tính được khoảng cách/thời gian tuyến. Vui lòng thử lại sau.",
  );
}
