import { Role } from "./role";

/**
 * Danh mục quyền — chép từ Security §7 (permission matrix) + API §7.3 + FR-IAM-05/08. Chỉ ô RÕ
 * NGHĨA của ma trận; ô có điều kiện ("có thể hỗ trợ nếu được phép", "log tenant nếu được cấp") để
 * task sở hữu quyết (TASK-IAM-003 todo). Tên = `resource:action`.
 */
export const PERMISSIONS = [
  "profile:manage",
  "loyalty:use",
  "notification:manage",
  "incident:create",
  "journey-log:create",
  "system:run",
  "trip:search", // §7 Search trip
  "booking:create", // §7 Create booking
  "booking:read", // API §7.3 /operator/bookings, FR-OPS-14/15 (TASK-OPR-003) — booking / vé / hành khách của nhà xe
  "payment:create", // §7 Payment
  "payment:monitor", // §7 Payment — "giám sát/đối soát"
  "refund:request", // §7 Cancel/refund request
  "vehicle:manage", // §7 Vehicle/SeatMap
  "vehicle:read", // §7 Vehicle/SeatMap — "xem nếu được phân công"
  "route:manage", // §7 Route/StopPoint (TASK-TRN-002, SRS permission matrix) — route, điểm riêng, đề xuất
  "trip:manage", // §7 Trip/fare/inventory (TASK-TRN-003) — tạo/sửa chuyến của nhà xe
  "checkin:perform", // §7 Check-in
  "checkin:read", // §7 Check-in — "xem kết quả" / "giám sát"
  "trip:operate", // §7 Trip cột Employee — "cập nhật trạng thái chuyến được phân công" (FR-EMP-09, TASK-EMP-002), chỉ tài xế
  "kyc:submit", // §7 KYC — "hồ sơ của mình"
  "kyc:review", // §7 KYC — "duyệt/quản lý"
  "catalog:manage", // §7 Route/StopPoint cột Admin (TASK-ADM-004) — điểm dùng chung, duyệt đề xuất, khóa điểm riêng
  "content:moderate", // §7 Ảnh phương tiện cột Admin (TASK-ADM-003 phần ảnh xe) — rà soát, gỡ ảnh vi phạm
  "content:manage", // §7 Bài viết cột Admin (TASK-CNT-001) — soạn, xuất bản, gỡ bài, chuyên mục
  "user:manage", // FR-ADM-02/03, FR-IAM-08 — Admin xem / khóa nhà xe, hành khách, nhân viên, tài khoản quản trị
  "system:read", // Trang Tích hợp & hệ thống của Admin (Figma ADM-16) — chỉ đọc trạng thái dịch vụ, tác vụ nền
  "finance:read", // §7 Policy/commission/payout — "xem phần liên quan"
  "finance:configure", // §7 Policy/commission/payout — "cấu hình"
  "audit:read", // §7 Audit log
  "employee:manage", // API §7.3 /operator/employees, FR-IAM-05
  "account:lock", // FR-IAM-08 (Admin, Nhà xe)
  "support:create", // FR-NSR-06, FR-DSP-04 — khách gửi / theo dõi khiếu nại + phản hồi tranh chấp của đơn mình (TASK-TRUST-001)
  "review:create", // FR-NSR-10, BR-18 — hành khách đánh giá chuyến đã hoàn thành (Guest không, v1)
  "support:respond", // FR-NSR-07, FR-DSP-04 — nhà xe phản hồi khiếu nại / tranh chấp / đánh giá của tenant
  "support:manage", // FR-NSR-08, FR-DSP-03 — Admin phân loại, phân công, trả lời, yêu cầu minh chứng, chuyển tranh chấp
  "dispute:decide", // FR-DSP-06, FR-ADM-11, BR-51 — ra quyết định tranh chấp (gồm hoàn tiền), chỉ PlatformAdmin
  "promotion:manage", // FR-PROM-04, BR-46 — Owner: khuyến mãi của nhà xe trong giới hạn, tham gia khuyến mãi nền tảng (TASK-PROM-001)
  "promotion:configure", // FR-PROM-01..03, FR-ADM-12 — PlatformAdmin: khuyến mãi nền tảng, quyền / giới hạn của nhà xe, tạm dừng khuyến mãi nhà xe
  "loyalty:manage", // FR-LOY-11/12, UC-39 — PlatformAdmin: tra cứu tài khoản VXN Plus, điều chỉnh điểm, báo cáo (TASK-LOY-001)
  "access:manage", // FR-IAM-07 (TASK-IAM-007) — PlatformAdmin: tài khoản quản trị + phân quyền (tách khỏi `user:manage`)
  "transport:read", // TASK-IAM-007 — xem xe / sơ đồ ghế / tuyến / điểm dừng / chuyến / lịch / bảng giá của tenant (GET). Tách khỏi `*:manage` để màn đặt vé, chuyến, phân công... của tài khoản quản lý đọc được dữ liệu cấu hình mà không phải được cấp quyền sửa
  "manager:manage", // TASK-IAM-007 — Owner: tài khoản quản lý dùng Operator OS + phân quyền. Tên riêng, KHÔNG dùng chung `access:manage`: route Admin chỉ khai quyền, grant `tenant` của Owner sẽ lọt qua
  "payout:manage", // TASK-IAM-007 tách từ `finance:configure` — Admin lập / xác nhận chi trả nhà xe (FR-ADM-09)
  "refund:manage", // TASK-IAM-007 tách từ `finance:configure` — Admin thử lại / ghi nhận hoàn tiền thủ công (FR-ADM-10)
] as const;

export type Permission = (typeof PERMISSIONS)[number];

/**
 * Phạm vi một grant — cho service biết phải lọc gì:
 * - `any`: toàn hệ thống (chỉ PLATFORM_*, hoặc dữ liệu công khai như tìm chuyến).
 * - `tenant`: trong Operator của chính actor → DbScope tenant + RLS.
 * - `assigned`: trong tenant VÀ theo phân công — lọc phân công là ABAC, task EMP làm.
 * - `own`: của chính actor (booking của mình, guest session) — service kiểm ownership.
 */
export type GrantScope = "any" | "tenant" | "assigned" | "own";

type Grants = Readonly<Partial<Record<Permission, GrantScope>>>;

/** Quyền chung của 3 role Employee (BR-43): xem xe, soát vé chuyến được phân công. */
const EMPLOYEE: Grants = {
  "notification:manage": "own",
  "vehicle:read": "assigned",
  "checkin:perform": "assigned",
};

/** Tài xế còn cập nhật trạng thái chuyến được phân công (FR-EMP-09). */
const DRIVER: Grants = { ...EMPLOYEE, "trip:operate": "assigned", "incident:create": "assigned", "journey-log:create": "assigned" };

/**
 * Bảng role → quyền. `Record<Role, …>`: thêm role mà quên dòng ở đây thì TypeScript báo lỗi.
 * Test bất biến (`permissions.spec.ts`) chặn thêm: role phía Operator không được grant `any`, enum
 * Postgres có role mà bảng này không có, quyền không ai được cấp.
 */
export const ROLE_GRANTS: Readonly<Record<Role, Grants>> = {
  [Role.ANONYMOUS]: {
    "trip:search": "any",
    "booking:create": "own", // guest session
    "payment:create": "own",
    "refund:request": "own", // sau khi xác minh mã booking + contact (Security §8)
    "support:create": "own", // đơn đã xác minh bằng mã truy cập (UC-35)
  },
  [Role.PASSENGER]: {
    "profile:manage": "own",
    "loyalty:use": "own",
    "notification:manage": "own",
    "trip:search": "any",
    "booking:create": "own",
    "payment:create": "own",
    "refund:request": "own",
    "support:create": "own",
    "review:create": "own",
  },
  [Role.OPERATOR_OWNER]: {
    "notification:manage": "own",
    "trip:search": "tenant",
    "refund:request": "tenant",
    "vehicle:manage": "tenant",
    "vehicle:read": "tenant",
    "route:manage": "tenant",
    "trip:manage": "tenant",
    "checkin:read": "tenant",
    "kyc:submit": "tenant",
    "finance:read": "tenant",
    "employee:manage": "tenant",
    "booking:read": "tenant",
    "account:lock": "tenant",
    "support:respond": "tenant",
    "promotion:manage": "tenant",
    "manager:manage": "tenant",
    "transport:read": "tenant",
  },
  // Trần của tài khoản quản lý = quyền Owner trừ hồ sơ / giấy tờ / tài khoản nhận tiền (`kyc:submit`) và quản lý tài
  // khoản quản lý (`manager:manage`) — chỉ Owner (TASK-IAM-007 P2). Quyền thật do Owner tick (`ACCOUNT_PERMISSIONS`).
  [Role.OPERATOR_MANAGER]: {
    "notification:manage": "own",
    "trip:search": "tenant",
    "vehicle:manage": "tenant",
    "vehicle:read": "tenant",
    "route:manage": "tenant",
    "trip:manage": "tenant",
    "checkin:read": "tenant",
    "finance:read": "tenant",
    "employee:manage": "tenant",
    "booking:read": "tenant",
    "support:respond": "tenant",
    "promotion:manage": "tenant",
    // Không tick — luôn có: đọc cấu hình vận tải là nền của mọi màn Operator OS.
    "transport:read": "tenant",
  },
  [Role.DRIVER]: DRIVER,
  [Role.TICKET_STAFF]: EMPLOYEE,
  [Role.SUPPORT_STAFF]: { ...EMPLOYEE, "incident:create": "assigned" },
  [Role.PLATFORM_ADMIN]: {
    "notification:manage": "own",
    "system:run": "any",
    "trip:search": "any",
    "payment:monitor": "any",
    "refund:request": "any",
    "vehicle:read": "any",
    "checkin:read": "any",
    "kyc:review": "any",
    "catalog:manage": "any",
    "content:moderate": "any",
    "content:manage": "any",
    "user:manage": "any",
    "system:read": "any",
    "finance:read": "any",
    "finance:configure": "any",
    "audit:read": "any",
    "account:lock": "any",
    "support:manage": "any",
    "dispute:decide": "any",
    "promotion:configure": "any",
    "loyalty:manage": "any",
    "access:manage": "any",
    "payout:manage": "any",
    "refund:manage": "any",
  },
  // GIẢ ĐỊNH (Security §7 chỉ có một cột "Admin"): tối thiểu quyền — chỉ đọc/giám sát, không duyệt,
  // cấu hình hay hoàn tiền. Khanh đổi thì chỉ sửa dòng này.
  [Role.PLATFORM_SUPPORT]: {
    "notification:manage": "own",
    "trip:search": "any",
    "payment:monitor": "any",
    "vehicle:read": "any",
    "checkin:read": "any",
    "finance:read": "any",
    "support:manage": "any",
  },
};

/** Quyền chủ nhà xe tick được cho tài khoản quản lý (TASK-IAM-007 P2) — tách hằng để DTO dựng enum đúng kiểu. */
export const OPERATOR_MANAGER_PERMISSIONS = [
  "vehicle:manage",
  "route:manage",
  "trip:manage",
  "booking:read",
  "finance:read",
  "employee:manage",
  "support:respond",
  "promotion:manage",
] as const satisfies readonly Permission[];

/**
 * Phân quyền theo từng tài khoản (FR-IAM-07, TASK-IAM-007): quyền **tick được** của role — tài khoản mang danh sách
 * `permissions` chỉ có những quyền tick được nằm trong danh sách; quyền khác của role luôn đi theo role. Role không có ở
 * đây không tick được (Owner, Employee, hành khách). `required`: tài khoản luôn mang danh sách riêng (thiếu = không có
 * quyền tick được nào); không bắt buộc thì tài khoản chưa có danh sách (`NULL`, vd seed) có đủ bộ tick được.
 */
export const ACCOUNT_PERMISSIONS: Readonly<
  Partial<Record<Role, { readonly assignable: readonly Permission[]; readonly required: boolean }>>
> = {
  [Role.PLATFORM_ADMIN]: {
    assignable: [
      "kyc:review",
      "user:manage",
      "access:manage",
      "catalog:manage",
      "finance:configure",
      "payout:manage",
      "refund:manage",
      "payment:monitor",
      "system:run",
      "system:read",
      "audit:read",
      "promotion:configure",
      "loyalty:manage",
      "content:manage",
      "content:moderate",
      "support:manage",
      "dispute:decide",
    ],
    required: false,
  },
  [Role.PLATFORM_SUPPORT]: { assignable: ["payment:monitor", "support:manage"], required: false },
  [Role.OPERATOR_MANAGER]: { assignable: OPERATOR_MANAGER_PERMISSIONS, required: true },
};

/** Quyền tick được của role (rỗng = role không phân quyền theo tài khoản). */
export function assignablePermissions(role: string): readonly Permission[] {
  return (ACCOUNT_PERMISSIONS as Partial<Record<string, { assignable: readonly Permission[] }>>)[role]?.assignable ?? [];
}

/** Danh sách lưu DB / gửi lên: bỏ trùng, xếp theo thứ tự danh mục — so sánh và audit ổn định. */
export function normalizePermissions(permissions: readonly string[]): Permission[] {
  const wanted = new Set(permissions);
  return PERMISSIONS.filter((permission) => wanted.has(permission));
}

/**
 * Đọc cột `permissions` (JSONB) của tài khoản: `NULL` → `null` (theo role); mảng → danh sách đã chuẩn hoá. Mã lạ / sai
 * kiểu bị bỏ — chỉ có thể làm mất quyền, không thể thêm quyền (fail-closed).
 */
export function storedPermissions(value: unknown): Permission[] | null {
  if (value === null || value === undefined) {
    return null;
  }
  return Array.isArray(value) ? normalizePermissions(value.filter((item): item is string => typeof item === "string")) : [];
}
