// Định dạng màn Nhật ký audit (Figma ADM-15a/15b; UC-30). Hàm thuần.
import type { AuditActorType, AuditLogItem, AuditModule } from "./audit-api";

export const MODULE_LABELS: Record<AuditModule, string> = {
  AUTH: "Đăng nhập & phiên",
  ACCOUNT: "Tài khoản",
  OPERATOR_KYC: "Nhà xe & KYC",
  CATALOG: "Danh mục",
  STOP_POINT: "Điểm dừng",
  VEHICLE: "Phương tiện",
  TRIP: "Chuyến xe",
  FARE: "Bảng giá",
  AUDIT: "Nhật ký audit",
  OTHER: "Khác"
};
/** Thứ tự ô lọc "Phân hệ". */
export const MODULE_ORDER: AuditModule[] = [
  "OPERATOR_KYC",
  "ACCOUNT",
  "AUTH",
  "CATALOG",
  "STOP_POINT",
  "VEHICLE",
  "TRIP",
  "FARE",
  "AUDIT"
];

export const ACTOR_TYPE_LABELS: Record<Exclude<AuditActorType, "UNKNOWN">, string> = {
  PLATFORM: "Nền tảng",
  OPERATOR: "Chủ nhà xe",
  EMPLOYEE: "Nhân viên nhà xe",
  PASSENGER: "Hành khách",
  SYSTEM: "Hệ thống"
};

const ROLE_LABELS: Record<string, string> = {
  PLATFORM_ADMIN: "Quản trị viên",
  PLATFORM_SUPPORT: "Hỗ trợ nền tảng",
  PLATFORM: "Tài khoản nền tảng",
  OPERATOR_OWNER: "Chủ nhà xe",
  OPERATOR: "Chủ nhà xe",
  DRIVER: "Tài xế",
  TICKET_STAFF: "Nhân viên bán vé",
  SUPPORT_STAFF: "Nhân viên hỗ trợ",
  EMPLOYEE: "Nhân viên nhà xe",
  PASSENGER: "Hành khách"
};

/** Khoảng thời gian (Figma "Khoảng thời gian"), mặc định 7 ngày gần nhất. */
export const PERIODS = [
  { value: "1", label: "24 giờ qua" },
  { value: "7", label: "7 ngày gần nhất" },
  { value: "30", label: "30 ngày gần nhất" },
  { value: "90", label: "90 ngày gần nhất" }
] as const;

/** Mốc đầu `now − days` (ISO) cho `from`; không gửi `to` để bản ghi mới phát sinh vẫn hiện khi tải lại. */
export function periodStart(days: number, now: number = Date.now()): string {
  return new Date(now - days * 86_400_000).toISOString();
}

const ACTIONS: Record<string, string> = {
  "auth.login.success": "Đăng nhập",
  "auth.login.failure": "Đăng nhập thất bại",
  "auth.login.rate_limited": "Đăng nhập bị chặn vì thử quá nhiều",
  "auth.logout": "Đăng xuất",
  "auth.reauth.success": "Xác nhận lại danh tính",
  "auth.reauth.failure": "Xác nhận lại danh tính thất bại",
  "auth.reauth.rate_limited": "Xác nhận lại danh tính bị chặn",
  "auth.refresh.rate_limited": "Làm mới phiên bị chặn",
  "auth.session.issued": "Mở phiên đăng nhập",
  "auth.session.rotated": "Làm mới phiên đăng nhập",
  "auth.session.revoked": "Thu hồi phiên đăng nhập",
  "auth.session.cleanup": "Dọn phiên hết hạn",
  "auth.token.reuse_detected": "Phát hiện dùng lại mã làm mới phiên",
  "auth.password_change.intent": "Bắt đầu đổi mật khẩu",
  "auth.password_changed": "Đổi mật khẩu",
  "auth.mfa.enrolled": "Bật xác thực hai lớp",
  "auth.mfa.challenge_issued": "Yêu cầu mã xác thực hai lớp",
  "auth.mfa.verified": "Xác thực hai lớp",
  "auth.mfa.verification_failed": "Mã xác thực hai lớp sai",
  "auth.mfa.backup_code_used": "Dùng mã dự phòng",
  "auth.mfa.locked": "Khóa tạm xác thực hai lớp",
  "auth.mfa.rate_limited": "Xác thực hai lớp bị chặn",
  "iam.operator.provision.intent": "Bắt đầu cấp tài khoản chủ nhà xe",
  "iam.operator.provision.success": "Cấp tài khoản chủ nhà xe",
  "iam.operator.provision.delivery_failed": "Gửi mật khẩu tạm cho chủ nhà xe thất bại",
  "iam.operator.provision_retry.intent": "Bắt đầu gửi lại mật khẩu tạm",
  "iam.operator.provision_retry.success": "Gửi lại mật khẩu tạm cho chủ nhà xe",
  "iam.operator.provision_retry.delivery_failed": "Gửi lại mật khẩu tạm thất bại",
  "iam.employee.create.intent": "Bắt đầu tạo tài khoản nhân viên",
  "iam.employee.create.success": "Tạo tài khoản nhân viên",
  "iam.employee.create.delivery_failed": "Gửi mật khẩu tạm cho nhân viên thất bại",
  "iam.employee.update.intent": "Bắt đầu sửa tài khoản nhân viên",
  "iam.employee.update.success": "Sửa tài khoản nhân viên",
  "iam.employee.password_reset.intent": "Bắt đầu cấp lại mật khẩu nhân viên",
  "iam.employee.password_reset.success": "Cấp lại mật khẩu tạm cho nhân viên",
  "iam.employee.password_reset.delivery_failed": "Gửi mật khẩu tạm cho nhân viên thất bại",
  "operator_application.submit": "Gửi hồ sơ đăng ký nhà xe",
  "operator_application.document.view": "Mở tệp giấy tờ KYC",
  "operator_application.approve": "Duyệt hồ sơ, cấp tài khoản chủ nhà xe",
  "operator_application.request_info": "Yêu cầu bổ sung hồ sơ",
  "operator_application.reject": "Từ chối hồ sơ",
  "stop_point_catalog.create": "Thêm điểm dừng dùng chung",
  "stop_point_catalog.update": "Sửa điểm dừng dùng chung",
  "stop_point_proposal.approve": "Duyệt đề xuất điểm dừng",
  "stop_point_proposal.reject": "Từ chối đề xuất điểm dừng",
  "stop_point.suspend": "Khóa điểm dừng của nhà xe",
  "stop_point.unsuspend": "Mở khóa điểm dừng của nhà xe",
  "vehicle_image.remove": "Gỡ ảnh phương tiện",
  "trip.status.change": "Đổi trạng thái chuyến",
  "trip.seats.block": "Khóa chỗ thủ công",
  "trip.seats.unblock": "Mở khóa chỗ",
  "fare.create": "Tạo bảng giá",
  "fare.update": "Sửa bảng giá",
  "audit.event.view": "Xem chi tiết nhật ký"
};

const CATALOG_NOUNS: Record<string, string> = {
  province: "tỉnh / thành",
  ward: "phường / xã",
  vehicle_type: "loại xe",
  amenity: "tiện ích"
};
const CATALOG_VERBS: Record<string, string> = {
  create: "Thêm",
  update: "Sửa",
  activate: "Dùng lại",
  deactivate: "Ngừng dùng"
};

/** Nhãn tiếng Việt của hành động; chưa biết thì hiện nguyên mã hành động. */
export function actionLabel(action: string): string {
  const known = ACTIONS[action];
  if (known) {
    return known;
  }
  const catalog = /^catalog\.([a-z_]+)\.([a-z]+)$/.exec(action);
  if (catalog && CATALOG_NOUNS[catalog[1]!] && CATALOG_VERBS[catalog[2]!]) {
    return `${CATALOG_VERBS[catalog[2]!]} ${CATALOG_NOUNS[catalog[1]!]}`;
  }
  return action;
}

const TARGETS: Record<string, string> = {
  auth_account: "Tài khoản",
  auth_session: "Phiên đăng nhập",
  mfa_credential: "Xác thực hai lớp",
  operator_account: "Tài khoản chủ nhà xe",
  employee_account: "Tài khoản nhân viên",
  operator_application: "Hồ sơ đăng ký",
  province: "Tỉnh / thành",
  ward: "Phường / xã",
  vehicle_type: "Loại xe",
  amenity: "Tiện ích",
  stop_point_catalog: "Điểm dừng dùng chung",
  stop_point_proposal: "Đề xuất điểm dừng",
  stop_point: "Điểm dừng của nhà xe",
  vehicle_image: "Ảnh phương tiện",
  trip: "Chuyến",
  fare: "Bảng giá",
  audit_event: "Bản ghi nhật ký"
};

export function targetLabel(targetType: string): string {
  return TARGETS[targetType] ?? targetType;
}

/** Người thực hiện (dòng chính + dòng phụ vai trò) như cột Figma ADM-15a. */
export function actorLines(item: Pick<AuditLogItem, "actorType" | "actorName" | "actorRole" | "actorId">): {
  name: string;
  role: string;
} {
  if (item.actorType === "SYSTEM") {
    return { name: "Hệ thống", role: "Tác vụ nền" };
  }
  const role = (item.actorRole && ROLE_LABELS[item.actorRole]) ?? item.actorRole ?? "Không rõ vai trò";
  if (item.actorName) {
    return { name: item.actorName, role };
  }
  return { name: item.actorId ? "Tài khoản không còn" : "Không xác định", role };
}

const VN_OFFSET_MS = 7 * 3_600_000;

function vnParts(iso: string) {
  const shifted = new Date(new Date(iso).getTime() + VN_OFFSET_MS);
  const pad = (value: number) => String(value).padStart(2, "0");
  return {
    date: `${pad(shifted.getUTCDate())}/${pad(shifted.getUTCMonth() + 1)}`,
    year: shifted.getUTCFullYear(),
    time: `${pad(shifted.getUTCHours())}:${pad(shifted.getUTCMinutes())}:${pad(shifted.getUTCSeconds())}`
  };
}

/** `13/10 · 09:43:12` — cột Thời điểm (giờ Việt Nam). */
export function formatAuditTime(iso: string): string {
  const { date, time } = vnParts(iso);
  return `${date} · ${time}`;
}

/** `13/10/2026 · 09:43:12` — dòng phụ trang chi tiết. */
export function formatAuditDateTime(iso: string): string {
  const { date, year, time } = vnParts(iso);
  return `${date}/${year} · ${time}`;
}

/** Giá trị một trường trước / sau → chữ hiển thị. */
export function formatSnapshotValue(value: unknown): string {
  if (value === null || value === undefined || value === "") {
    return "—";
  }
  if (typeof value === "boolean") {
    return value ? "Có" : "Không";
  }
  if (typeof value === "object") {
    return JSON.stringify(value);
  }
  return String(value);
}

/** Bảng "Trước và sau": mọi trường xuất hiện ở một trong hai phía, giữ thứ tự xuất hiện. */
export function diffRows(
  before: Record<string, unknown> | null,
  after: Record<string, unknown> | null
): { field: string; before: string; after: string; changed: boolean }[] {
  const fields = [...new Set([...Object.keys(before ?? {}), ...Object.keys(after ?? {})])];
  return fields.map((field) => {
    const left = formatSnapshotValue(before?.[field]);
    const right = formatSnapshotValue(after?.[field]);
    return { field, before: left, after: right, changed: left !== right };
  });
}
