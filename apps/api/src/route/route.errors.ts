import { HttpException, HttpStatus } from "@nestjs/common";

const TITLE = "Route error";

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  // ProblemDetailsExceptionFilter đọc `{ code, detail, title }` → RFC 7807 (ADR-012).
  return new HttpException({ code, detail, title: TITLE }, status);
}

/** Tổng thời gian chạy của tuyến (sau khi chỉnh chặng) vượt 7 ngày — chuyến dài nhất cho phép. */
export function routeDurationTooLong(): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "ROUTE_DURATION_INVALID", "Tổng thời gian chạy của tuyến không được quá 7 ngày.");
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

/** Tuyến con lấy điểm dừng từ tuyến chính: không sửa điểm trực tiếp, không tạo tuyến con từ tuyến con (3.2). */
export function routeIsSubRoute(): HttpException {
  return problem(
    HttpStatus.CONFLICT,
    "ROUTE_IS_SUB_ROUTE",
    "Đây là tuyến con: điểm dừng lấy theo tuyến chính, sửa tại mục Tuyến con của tuyến chính.",
  );
}

/** Hai đầu tuyến con phải nằm trên tuyến chính đúng chiều: đầu cho đón, cuối cho trả, không trùng cả tuyến chính. */
export function subRouteBoundsInvalid(): HttpException {
  return problem(
    HttpStatus.UNPROCESSABLE_ENTITY,
    "SUB_ROUTE_BOUNDS_INVALID",
    "Điểm đầu và điểm cuối của tuyến con phải nằm trên tuyến chính theo đúng chiều: điểm đầu cho đón, điểm cuối cho trả, và không trùng cả tuyến chính.",
  );
}

/** Tuyến chính đã có tuyến con cùng điểm đầu và điểm cuối. */
export function subRouteConflict(): HttpException {
  return problem(HttpStatus.CONFLICT, "SUB_ROUTE_CONFLICT", "Tuyến chính đã có tuyến con cùng điểm đầu và điểm cuối.");
}

/** Bật tuyến con cần bảng giá đang áp dụng (có ít nhất một giá) và hai đầu còn trên tuyến chính. */
export function subRouteNotReady(): HttpException {
  return problem(
    HttpStatus.UNPROCESSABLE_ENTITY,
    "SUB_ROUTE_NOT_READY",
    "Tuyến con cần có bảng giá đang áp dụng và hai đầu còn trên tuyến chính trước khi bật.",
  );
}
