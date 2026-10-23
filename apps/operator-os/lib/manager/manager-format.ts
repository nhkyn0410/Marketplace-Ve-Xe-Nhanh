// Tài khoản quản lý của nhà xe (TASK-IAM-007): nhãn quyền theo nhóm thanh bên, mẫu điền sẵn, câu lỗi. Hàm thuần.
import type { PermissionGroup, PermissionTemplate } from "@vexenhanh/ui/lib/permission-matrix";

import { ApiError } from "../auth/api-client";
import { describeReauthError } from "../auth/reauth";
import type { ManagerPermission } from "./manager-api";

/**
 * Quyền chủ nhà xe tick được. Hồ sơ & KYC, tài khoản nhận tiền và tài khoản quản lý luôn chỉ chủ nhà xe dùng. Xem xe /
 * tuyến / chuyến / bảng giá thì mọi tài khoản quản lý đều có sẵn (để các màn đọc được dữ liệu cấu hình).
 */
export const MANAGER_PERMISSION_GROUPS: PermissionGroup<ManagerPermission>[] = [
  {
    label: "Vận tải",
    items: [
      { permission: "vehicle:manage", label: "Phương tiện & sơ đồ ghế", description: "Thêm, sửa xe, ảnh xe và sơ đồ ghế." },
      { permission: "route:manage", label: "Tuyến & điểm dừng", description: "Tuyến đường, điểm dừng riêng, đề xuất điểm dừng." },
      { permission: "trip:manage", label: "Chuyến xe & bảng giá", description: "Tạo, mở bán, khóa, hủy chuyến; lịch chạy; bảng giá." }
    ]
  },
  {
    label: "Kinh doanh",
    items: [
      { permission: "booking:read", label: "Đặt vé & hành khách", description: "Xem đơn, vé và danh sách hành khách theo chuyến." },
      { permission: "promotion:manage", label: "Khuyến mãi", description: "Khuyến mãi của nhà xe, tham gia khuyến mãi nền tảng." },
      { permission: "finance:read", label: "Tài chính & báo cáo", description: "Doanh thu, chi trả, đối soát, báo cáo của nhà xe." }
    ]
  },
  {
    label: "Nhà xe",
    items: [
      { permission: "employee:manage", label: "Nhân viên & phân công", description: "Cấp, khóa tài khoản nhân viên; phân công tài xế." },
      { permission: "support:respond", label: "Hỗ trợ khách hàng", description: "Phản hồi khiếu nại, tranh chấp, đánh giá, sự cố." }
    ]
  }
];

export const MANAGER_TEMPLATES: PermissionTemplate<ManagerPermission>[] = [
  { id: "all", label: "Đủ quyền quản lý", permissions: "all" },
  { id: "operations", label: "Điều hành", permissions: ["vehicle:manage", "route:manage", "trip:manage", "employee:manage", "booking:read"] },
  { id: "sales", label: "Bán vé & CSKH", permissions: ["booking:read", "support:respond", "promotion:manage"] },
  { id: "finance", label: "Kế toán", permissions: ["finance:read", "booking:read"] }
];

export const ALL_MANAGER_PERMISSIONS: ManagerPermission[] = MANAGER_PERMISSION_GROUPS.flatMap((group) => group.items.map((item) => item.permission));

/** Cột "Quyền": đủ cả danh mục → "Đủ quyền quản lý", ngược lại "N quyền". */
export function managerPermissionSummary(permissions: readonly string[]): string {
  if (permissions.length === 0) {
    return "Chưa có quyền";
  }
  return permissions.length >= ALL_MANAGER_PERMISSIONS.length ? "Đủ quyền quản lý" : `${permissions.length} quyền`;
}

export const MANAGER_REASON_MAX = 500;

/** Lý do 3–500 ký tự; `null` = hợp lệ. */
export function managerReasonError(value: string): string | null {
  const length = value.trim().length;
  if (length < 3) {
    return "Nhập lý do (ít nhất 3 ký tự).";
  }
  return length > MANAGER_REASON_MAX ? `Lý do tối đa ${MANAGER_REASON_MAX} ký tự.` : null;
}

/** Phần sau `{mã nhà xe}/`: 3–40 ký tự chữ thường, số, `.`, `_`, `-`, không dùng tiền tố `nv.` của nhân viên. */
export function managerUsernameError(value: string): string | null {
  const username = value.trim().toLowerCase();
  if (username.startsWith("nv.")) {
    return "Tiền tố `nv.` dành cho tài khoản nhân viên.";
  }
  return /^[a-z0-9][a-z0-9._-]{2,39}$/.test(username) ? null : "Tên đăng nhập gồm 3–40 ký tự chữ thường, số, dấu chấm, gạch dưới, gạch ngang.";
}

export function managerEmailError(value: string): string | null {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value.trim()) ? null : "Nhập email hợp lệ.";
}

/** Lỗi thao tác → ô xác nhận danh tính, ô tên đăng nhập hay báo chung; `refresh` = danh sách đã cũ. */
export function describeManagerError(error: unknown): { field: "identity" | "username" | null; message: string; refresh: boolean } {
  const identity = describeReauthError(error);
  if (identity) {
    return { field: "identity", message: identity, refresh: false };
  }
  if (!(error instanceof ApiError)) {
    return { field: null, message: "Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại.", refresh: false };
  }
  switch (error.code) {
    case "ACCOUNT_USERNAME_CONFLICT":
      return { field: "username", message: "Tên đăng nhập này đã có trong nhà xe. Chọn tên khác.", refresh: false };
    case "ACCOUNT_NOT_FOUND":
      return { field: null, message: "Tài khoản không còn tồn tại. Danh sách đã được tải lại.", refresh: true };
    case "ACCOUNT_STATE_CONFLICT":
      return { field: null, message: "Tài khoản vừa thay đổi ở nơi khác hoặc đang bị khóa. Danh sách đã được tải lại.", refresh: true };
    case "ACCOUNT_TEMP_EMAIL_RATE_LIMITED":
      return { field: null, message: "Đã vượt giới hạn gửi mật khẩu tạm. Vui lòng thử lại sau.", refresh: false };
    case "PERMISSION_DENIED":
      return { field: null, message: "Chỉ chủ nhà xe được quản lý tài khoản quản lý.", refresh: false };
    default:
      return error.status === 503
        ? { field: null, message: "Hệ thống tạm thời không phản hồi nên chưa đổi gì. Vui lòng thử lại sau.", refresh: false }
        : { field: null, message: error.message || "Không thực hiện được thao tác. Vui lòng thử lại.", refresh: false };
  }
}
