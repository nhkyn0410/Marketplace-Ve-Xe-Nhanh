import { HttpException, HttpStatus } from "@nestjs/common";

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  return new HttpException({ title: "Sales office error", code, detail }, status);
}

/** Văn phòng không thuộc phạm vi tài khoản đang đăng nhập. */
export function officeNotFound(): HttpException {
  return problem(HttpStatus.NOT_FOUND, "OFFICE_NOT_FOUND", "Không tìm thấy văn phòng.");
}

/** Văn phòng đã được cập nhật bởi thao tác khác. */
export function officeVersionConflict(): HttpException {
  return problem(HttpStatus.CONFLICT, "OFFICE_VERSION_CONFLICT", "Văn phòng đã thay đổi. Hãy tải lại trước khi lưu.");
}

/** Mã văn phòng đã được dùng trong nhà xe. */
export function officeCodeConflict(): HttpException {
  return problem(HttpStatus.CONFLICT, "OFFICE_CODE_CONFLICT", "Nhà xe đã có văn phòng dùng mã này.");
}

/** Phân công chỉ nhận nhân viên bán vé đang hoạt động của cùng nhà xe. */
export function officeAssignmentInvalid(): HttpException {
  return problem(HttpStatus.UNPROCESSABLE_ENTITY, "OFFICE_ASSIGNMENT_INVALID", "Chỉ phân công nhân viên bán vé đang hoạt động của nhà xe.");
}

/** Chưa ghi được nhật ký thay đổi văn phòng nên thao tác bị hủy. */
export function officeAuditUnavailable(): HttpException {
  return problem(HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE", "Chưa ghi được nhật ký. Văn phòng chưa thay đổi, vui lòng thử lại.");
}
