// Chữ hiển thị và lọc cho màn Nhân viên (Figma "Nhà xe · Nhân viên"; UC-16). Hàm thuần để test được.
import { formatDay, formatTime } from "../trip/trip-format";
import type { Employee, EmployeeRole, EmployeeStatus } from "./employee-api";

/** Tiền tố cố định của tên đăng nhập nhân viên (TASK-IAM-006): `nv.` + phần do chủ nhà xe đặt. */
export const EMPLOYEE_USERNAME_PREFIX = "nv.";

/** Vai trò của nhân viên: nhãn và một dòng mô tả để chủ nhà xe chọn đúng. */
export const EMPLOYEE_ROLE: Record<EmployeeRole, { label: string; description: string }> = {
  DRIVER: { label: "Tài xế", description: "Lái xe của các chuyến được phân công." },
  TICKET_STAFF: { label: "Nhân viên soát vé", description: "Soát vé và đón khách lên xe." },
  SALES_STAFF: { label: "Nhân viên bán vé", description: "Bán và xác nhận thu vé tại văn phòng được phân công." },
  SUPPORT_STAFF: { label: "Nhân viên hỗ trợ", description: "Tiếp nhận và xử lý yêu cầu hỗ trợ của hành khách." }
};

/** Thứ tự vai trò trong ô chọn và ô lọc. */
export const EMPLOYEE_ROLE_ORDER: EmployeeRole[] = ["DRIVER", "TICKET_STAFF", "SALES_STAFF", "SUPPORT_STAFF"];

/** Nhãn + màu trạng thái tài khoản. */
export const EMPLOYEE_STATUS: Record<EmployeeStatus, { label: string; tone: "success" | "danger" | "neutral" }> = {
  ACTIVE: { label: "Hoạt động", tone: "success" },
  LOCKED: { label: "Bị khóa", tone: "danger" },
  DISABLED: { label: "Vô hiệu hóa", tone: "neutral" }
};

export const EMPLOYEE_STATUS_ORDER: EmployeeStatus[] = ["ACTIVE", "LOCKED", "DISABLED"];

/** Tên đăng nhập đầy đủ nhân viên gõ ở ứng dụng Nhân viên: `saoviet/nv.tai.minh`. */
export function loginName(operatorSlug: string, username: string): string {
  return `${operatorSlug}/${username}`;
}

/** Phần sau `nv.` của tên đăng nhập — phần duy nhất chủ nhà xe được đặt. */
export function usernameSuffix(username: string): string {
  return username.startsWith(EMPLOYEE_USERNAME_PREFIX) ? username.slice(EMPLOYEE_USERNAME_PREFIX.length) : username;
}

export type PasswordState = { tone: "ok" | "warning" | "danger" | "muted"; label: string; detail: string };

/**
 * Cột "Mật khẩu": tài khoản đã kích hoạt chưa và chủ nhà xe có phải cấp lại mật khẩu tạm không. Mật khẩu tạm
 * chỉ gửi một lần qua email và hết hạn sau 24 giờ (TASK-IAM-005 Q3).
 */
export function passwordState(
  employee: Pick<
    Employee,
    "status" | "credentialDeliveryPending" | "passwordChangeRequired" | "temporaryPasswordExpiresAt" | "updatedAt"
  >,
  nowMs: number
): PasswordState {
  if (employee.status !== "ACTIVE") {
    return {
      tone: "muted",
      label: "—",
      detail: employee.status === "LOCKED" ? "Tài khoản đang bị khóa" : "Tài khoản đã vô hiệu hóa"
    };
  }
  if (employee.credentialDeliveryPending) {
    return { tone: "danger", label: "Chưa gửi được mật khẩu tạm", detail: "Bấm cấp lại mật khẩu để gửi lại" };
  }
  if (employee.passwordChangeRequired) {
    const expiresAt = employee.temporaryPasswordExpiresAt;
    if (!expiresAt || new Date(expiresAt).getTime() <= nowMs) {
      return { tone: "danger", label: "Mật khẩu tạm đã hết hạn", detail: "Bấm cấp lại mật khẩu để gửi mật khẩu mới" };
    }
    return {
      tone: "warning",
      label: "Chờ đổi mật khẩu tạm",
      detail: `Mật khẩu tạm hết hạn ${formatDay(expiresAt)} · ${formatTime(expiresAt)}`
    };
  }
  return { tone: "ok", label: "Đã đổi mật khẩu", detail: `Cập nhật ${formatDay(employee.updatedAt)}` };
}

export type EmployeeFilter = { search: string; role: EmployeeRole | null; status: EmployeeStatus | null };

/** Lọc ở phía giao diện theo tên đăng nhập / email (không phân biệt hoa thường), vai trò và trạng thái. */
export function filterEmployees<T extends Pick<Employee, "username" | "contactEmail" | "role" | "status">>(
  employees: readonly T[],
  filter: EmployeeFilter
): T[] {
  const needle = filter.search.trim().toLowerCase();
  return employees.filter(
    (employee) =>
      (needle === "" ||
        employee.username.toLowerCase().includes(needle) ||
        (employee.contactEmail ?? "").toLowerCase().includes(needle)) &&
      (filter.role === null || employee.role === filter.role) &&
      (filter.status === null || employee.status === filter.status)
  );
}

/** Thứ tự danh sách: theo tên đăng nhập, để một nhân viên luôn nằm cùng chỗ sau mỗi lần tải lại. */
export function sortEmployees<T extends Pick<Employee, "username">>(employees: readonly T[]): T[] {
  return [...employees].sort((a, b) => a.username.localeCompare(b.username));
}
