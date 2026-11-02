// Logic thuần của các hộp thoại ở màn Nhân viên (Figma "02"–"04 · Nhân viên"; TASK-IAM-005): kiểm tra ô nhập,
// dựng body API, đọc lỗi của máy chủ. Tách khỏi component để test được.
import { ApiError } from "../auth/api-client";
import { describeReauthError } from "../auth/reauth";
import type { Employee, EmployeeCreateInput, EmployeeRole, EmployeeUpdateInput } from "./employee-api";
import { EMPLOYEE_USERNAME_PREFIX, usernameSuffix } from "./employee-format";

export const REASON_MIN_LENGTH = 3;
export const REASON_MAX_LENGTH = 500;
/** Lý do ghi vào nhật ký khi tạo tài khoản — tạo mới không cần chủ nhà xe tự gõ lý do. */
export const CREATE_REASON = "Thêm nhân viên mới từ trang quản lý nhà xe";

// Phần sau `nv.`: 2–61 ký tự chữ thường, số, dấu chấm, gạch dưới, gạch ngang (giống máy chủ).
const SUFFIX = /^[a-z0-9._-]{2,61}$/;
// Kiểm sơ bộ để báo lỗi sớm; máy chủ mới là nơi kiểm địa chỉ email chặt.
const EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;

export type EmployeeFormValues = { suffix: string; contactEmail: string; role: EmployeeRole | ""; reason: string };
export type EmployeeFormErrors = Partial<Record<keyof EmployeeFormValues, string>>;

export const EMPTY_EMPLOYEE_FORM: EmployeeFormValues = { suffix: "", contactEmail: "", role: "", reason: "" };

/** Giá trị form của một nhân viên đang sửa. */
export function toEmployeeForm(employee: Pick<Employee, "username" | "contactEmail" | "role">): EmployeeFormValues {
  return {
    suffix: usernameSuffix(employee.username),
    contactEmail: employee.contactEmail ?? "",
    role: employee.role,
    reason: ""
  };
}

/** Lỗi của ô lý do; `null` nếu hợp lệ. Lý do bắt buộc cho sửa, khóa, mở khóa và cấp lại mật khẩu. */
export function reasonError(reason: string): string | null {
  const length = reason.trim().length;
  if (length < REASON_MIN_LENGTH) {
    return `Nhập lý do, ít nhất ${REASON_MIN_LENGTH} ký tự.`;
  }
  return length > REASON_MAX_LENGTH ? `Lý do tối đa ${REASON_MAX_LENGTH} ký tự.` : null;
}

/** Kiểm tra form thêm / sửa nhân viên. Thêm mới không có ô lý do. */
export function validateEmployeeForm(values: EmployeeFormValues, mode: "create" | "edit"): EmployeeFormErrors {
  const errors: EmployeeFormErrors = {};
  if (!SUFFIX.test(values.suffix.trim())) {
    errors.suffix =
      "Tên đăng nhập chưa hợp lệ: phần sau “nv.” dài 2–61 ký tự, chỉ gồm chữ thường a–z, số, dấu chấm, gạch dưới hoặc gạch ngang.";
  }
  if (!EMAIL.test(values.contactEmail.trim())) {
    errors.contactEmail = "Nhập email liên hệ hợp lệ.";
  }
  if (values.role === "") {
    errors.role = "Chọn vai trò của nhân viên.";
  }
  if (mode === "edit") {
    const reason = reasonError(values.reason);
    if (reason) {
      errors.reason = reason;
    }
  }
  return errors;
}

const toUsername = (suffix: string) => `${EMPLOYEE_USERNAME_PREFIX}${suffix.trim()}`;

/** Body tạo nhân viên. Gọi sau khi `validateEmployeeForm` không còn lỗi. */
export function toCreateInput(values: EmployeeFormValues): EmployeeCreateInput {
  return {
    username: toUsername(values.suffix),
    contactEmail: values.contactEmail.trim().toLowerCase(),
    role: values.role as EmployeeRole,
    reason: CREATE_REASON
  };
}

/**
 * Body sửa nhân viên: chỉ gửi trường thật sự đổi (đổi tên đăng nhập / email làm nhân viên bị đăng xuất nên
 * không gửi thừa). `null` khi không có gì thay đổi.
 */
export function toUpdateInput(
  employee: Pick<Employee, "username" | "contactEmail" | "role">,
  values: EmployeeFormValues
): EmployeeUpdateInput | null {
  const username = toUsername(values.suffix);
  const contactEmail = values.contactEmail.trim().toLowerCase();
  const input: EmployeeUpdateInput = { reason: values.reason.trim() };
  if (username !== employee.username) {
    input.username = username;
  }
  if (contactEmail !== (employee.contactEmail ?? "").toLowerCase()) {
    input.contactEmail = contactEmail;
  }
  if (values.role !== employee.role) {
    input.role = values.role as EmployeeRole;
  }
  return Object.keys(input).length === 1 ? null : input;
}

export type EmployeeErrorField = "suffix" | "identity" | null;

/**
 * Đổi lỗi của máy chủ thành câu báo và ô cần gắn lỗi. `refresh` = danh sách có thể đã khác (tài khoản vừa
 * được tạo dù gửi email lỗi, hoặc ai đó vừa sửa) nên màn hình cần tải lại.
 */
export function describeEmployeeError(
  error: unknown,
  action: "create" | "update" | "reset"
): { field: EmployeeErrorField; message: string; refresh: boolean } {
  const identity = describeReauthError(error);
  if (identity) {
    return { field: "identity", message: identity, refresh: false };
  }
  if (error instanceof ApiError) {
    switch (error.code) {
      case "ACCOUNT_USERNAME_CONFLICT":
        return { field: "suffix", message: "Tên đăng nhập này đã có trong nhà xe. Chọn tên khác.", refresh: false };
      case "ACCOUNT_NOT_FOUND":
        return { field: null, message: "Nhân viên không còn tồn tại. Danh sách đã được tải lại.", refresh: true };
      case "ACCOUNT_STATE_CONFLICT":
        return {
          field: null,
          message: "Tài khoản vừa thay đổi ở nơi khác nên thao tác chưa thực hiện. Danh sách đã được tải lại.",
          refresh: true
        };
      case "ACCOUNT_TEMP_EMAIL_RATE_LIMITED":
        return {
          field: null,
          message:
            action === "reset"
              ? "Đã vượt giới hạn gửi mật khẩu tạm: mỗi nhân viên cấp lại tối đa một lần mỗi giờ và số lần gửi trong ngày có hạn. Vui lòng thử lại sau."
              : "Đã vượt giới hạn gửi mật khẩu tạm trong ngày. Vui lòng thử lại sau.",
          refresh: false
        };
      case "AUTH_ACCOUNT_LOCKED":
        return { field: null, message: "Tài khoản của bạn đã bị khóa nên không thực hiện được thao tác này.", refresh: false };
      case "SERVICE_UNAVAILABLE":
        // Tạo tài khoản xong nhưng gửi email lỗi thì tài khoản VẪN được tạo — không tạo lại, chỉ cấp lại mật khẩu.
        if (action === "create") {
          return {
            field: null,
            message:
              "Chưa gửi được mật khẩu tạm. Nếu nhân viên đã có trong danh sách, bấm cấp lại mật khẩu để gửi lại — không tạo lại tài khoản.",
            refresh: true
          };
        }
        // Cấp lại mà gửi email lỗi: máy chủ đã thay mật khẩu cũ và đã tính lượt cấp lại của giờ này.
        if (action === "reset") {
          return {
            field: null,
            message:
              "Chưa gửi được mật khẩu tạm mới. Nếu dòng của nhân viên ghi “Chưa gửi được mật khẩu tạm” thì mật khẩu cũ đã hết hiệu lực — cấp lại lần nữa sau ít nhất một giờ.",
            refresh: true
          };
        }
        return { field: null, message: "Máy chủ đang bận nên thao tác chưa thực hiện. Vui lòng thử lại sau.", refresh: true };
    }
    if (error.status === 400) {
      return { field: null, message: "Thông tin chưa hợp lệ. Vui lòng kiểm tra lại các ô đã nhập.", refresh: false };
    }
  }
  return { field: null, message: "Chưa thực hiện được. Vui lòng kiểm tra kết nối và thử lại.", refresh: false };
}
