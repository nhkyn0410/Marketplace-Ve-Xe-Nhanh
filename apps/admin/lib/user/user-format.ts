// Định dạng màn Nhà xe (tab Nhà xe) + Người dùng (Figma ADM-02e/f, ADM-03a…03d). Hàm thuần.
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { describeReauthError } from "@vexenhanh/ui/lib/auth/reauth";

import type { AccountStatus, EmployeeRole, OperatorStatus, PlatformRole } from "./user-api";

type Tone = "success" | "danger" | "neutral" | "warning";

export const OPERATOR_STATUS: Record<OperatorStatus, { label: string; tone: Tone }> = {
  ACTIVE: { label: "Đang hoạt động", tone: "success" },
  SUSPENDED: { label: "Tạm khóa", tone: "danger" }
};

export const ACCOUNT_STATUS: Record<AccountStatus, { label: string; tone: Tone }> = {
  ACTIVE: { label: "Hoạt động", tone: "success" },
  LOCKED: { label: "Bị khóa", tone: "danger" },
  DISABLED: { label: "Vô hiệu hóa", tone: "neutral" }
};

export const EMPLOYEE_ROLE: Record<EmployeeRole, string> = {
  DRIVER: "Tài xế",
  TICKET_STAFF: "Nhân viên bán vé",
  SUPPORT_STAFF: "Nhân viên hỗ trợ"
};

export const PLATFORM_ROLE: Record<PlatformRole, { label: string; description: string }> = {
  PLATFORM_ADMIN: { label: "Quản trị viên nền tảng", description: "Thao tác quản trị theo phân quyền của nền tảng." },
  PLATFORM_SUPPORT: { label: "Hỗ trợ nền tảng", description: "Xem, giám sát và hỗ trợ xử lý theo phân quyền của nền tảng." }
};

export const PROVIDER_LABELS: Record<string, string> = {
  "email-otp": "Email OTP",
  google: "Google",
  facebook: "Facebook",
  apple: "Apple"
};

export const LOCK_REASON_MAX = 500;

/** Lý do khóa / tạm khóa: 3–500 ký tự; `null` = hợp lệ. */
export function lockReasonError(value: string): string | null {
  const length = value.trim().length;
  if (length < 3) {
    return "Nhập lý do (ít nhất 3 ký tự).";
  }
  return length > LOCK_REASON_MAX ? `Lý do tối đa ${LOCK_REASON_MAX} ký tự.` : null;
}

/** Tên đăng nhập sau `platform/`: 3–40 ký tự chữ thường, số, `.`, `_`, `-`; `null` = hợp lệ. */
export function platformUsernameError(value: string): string | null {
  return /^[a-z0-9][a-z0-9._-]{2,39}$/.test(value.trim().toLowerCase())
    ? null
    : "Tên đăng nhập gồm 3–40 ký tự chữ thường, số, dấu chấm, gạch dưới, gạch ngang.";
}

export function emailError(value: string): string | null {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value.trim()) ? null : "Nhập email hợp lệ.";
}

/** `dd/mm/yyyy` giờ Việt Nam. */
export function formatDate(iso: string | null): string {
  if (!iso) {
    return "—";
  }
  const shifted = new Date(new Date(iso).getTime() + 7 * 3_600_000);
  const pad = (value: number) => String(value).padStart(2, "0");
  return `${pad(shifted.getUTCDate())}/${pad(shifted.getUTCMonth() + 1)}/${shifted.getUTCFullYear()}`;
}

/** `13/10/2026 · 07:58` giờ Việt Nam; không có → "—". */
export function formatDateTime(iso: string | null): string {
  if (!iso) {
    return "—";
  }
  const shifted = new Date(new Date(iso).getTime() + 7 * 3_600_000);
  const pad = (value: number) => String(value).padStart(2, "0");
  return `${pad(shifted.getUTCDate())}/${pad(shifted.getUTCMonth() + 1)}/${shifted.getUTCFullYear()} · ${pad(
    shifted.getUTCHours()
  )}:${pad(shifted.getUTCMinutes())}`;
}

/** "3 tuyến · 32 chuyến" / "Chưa có chuyến" / "Không mở bán" (nhà xe bị khóa) — cột Đang mở bán (ADM-02e). */
export function openSaleLabel(operator: { status: OperatorStatus; routeCount: number; openTripCount: number }): string {
  if (operator.status === "SUSPENDED") {
    return "Không mở bán";
  }
  if (operator.routeCount === 0 && operator.openTripCount === 0) {
    return "Chưa có chuyến";
  }
  return `${operator.routeCount} tuyến · ${operator.openTripCount} chuyến`;
}

/** Lỗi của thao tác khóa / cấp tài khoản → ô xác nhận danh tính, ô cụ thể hay báo chung; `refresh` = danh sách cũ. */
export function describeAccountError(error: unknown): {
  field: "identity" | "username" | "form";
  message: string;
  refresh?: boolean;
} {
  const identity = describeReauthError(error);
  if (identity) {
    return { field: "identity", message: identity };
  }
  if (!(error instanceof ApiError)) {
    return { field: "form", message: "Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại." };
  }
  switch (error.code) {
    case "PLATFORM_ACCOUNT_CONFLICT":
      return { field: "username", message: "Tên đăng nhập hoặc email đã được dùng." };
    case "PLATFORM_ACCOUNT_SELF_ACTION":
      return { field: "form", message: "Không tự khóa hoặc đặt lại tài khoản đang đăng nhập." };
    case "PLATFORM_ACCOUNT_LAST_ADMIN":
      return { field: "form", message: "Phải còn ít nhất một quản trị viên nền tảng đang hoạt động." };
    case "OPERATOR_STATE_INVALID":
    case "ACCOUNT_STATE_CONFLICT":
      return { field: "form", message: "Trạng thái vừa thay đổi. Đã tải lại danh sách.", refresh: true };
    case "BANK_ACCOUNT_CHANGE_NOT_FOUND":
      return { field: "form", message: "Yêu cầu đã được xử lý hoặc không còn chờ. Đã tải lại danh sách.", refresh: true };
    case "OPERATOR_NOT_FOUND":
    case "ACCOUNT_NOT_FOUND":
      return { field: "form", message: "Không còn tìm thấy mục này. Đã tải lại danh sách.", refresh: true };
    case "ACCOUNT_TEMP_EMAIL_RATE_LIMITED":
      return { field: "form", message: "Đã gửi quá nhiều mật khẩu tạm. Vui lòng thử lại sau." };
    default:
      return error.status === 503
        ? { field: "form", message: "Hệ thống tạm thời không phản hồi nên chưa đổi gì. Vui lòng thử lại sau." }
        : { field: "form", message: error.message || "Không thực hiện được thao tác. Vui lòng thử lại." };
  }
}
