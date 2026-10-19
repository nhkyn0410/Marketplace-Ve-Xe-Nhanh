import { Role } from "./role";

/**
 * Danh mục quyền — chép từ Security §7 (permission matrix) + API §7.3 + FR-IAM-05/08. Chỉ ô RÕ
 * NGHĨA của ma trận; ô có điều kiện ("có thể hỗ trợ nếu được phép", "log tenant nếu được cấp") để
 * task sở hữu quyết (TASK-IAM-003 todo). Tên = `resource:action`.
 */
export const PERMISSIONS = [
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
  "vehicle:read": "assigned",
  "checkin:perform": "assigned",
};

/** Tài xế còn cập nhật trạng thái chuyến được phân công (FR-EMP-09). */
const DRIVER: Grants = { ...EMPLOYEE, "trip:operate": "assigned" };

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
    "trip:search": "any",
    "booking:create": "own",
    "payment:create": "own",
    "refund:request": "own",
    "support:create": "own",
    "review:create": "own",
  },
  [Role.OPERATOR_OWNER]: {
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
  },
  [Role.DRIVER]: DRIVER,
  [Role.TICKET_STAFF]: EMPLOYEE,
  [Role.SUPPORT_STAFF]: EMPLOYEE,
  [Role.PLATFORM_ADMIN]: {
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
  },
  // GIẢ ĐỊNH (Security §7 chỉ có một cột "Admin"): tối thiểu quyền — chỉ đọc/giám sát, không duyệt,
  // cấu hình hay hoàn tiền. Khanh đổi thì chỉ sửa dòng này.
  [Role.PLATFORM_SUPPORT]: {
    "trip:search": "any",
    "payment:monitor": "any",
    "vehicle:read": "any",
    "checkin:read": "any",
    "finance:read": "any",
    "support:manage": "any",
  },
};
