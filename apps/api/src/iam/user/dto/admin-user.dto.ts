import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { TimeCursorField } from "../../../common/time-cursor";
import { AccountStatus, EmployeeRole, PlatformRole } from "../../../database/prisma.types";
import { PERMISSIONS } from "../../role/permissions";

// API §7.5 — Admin quản lý người dùng (FR-ADM-02/03, FR-IAM-08; Figma ADM-03a…03d). Quyền `user:manage`; tài khoản quản
// trị + phân quyền: `access:manage` (FR-IAM-07, TASK-IAM-007).

const search = z
  .string()
  .trim()
  .max(100)
  .transform((value) => value || undefined)
  .optional();
const page = { cursor: TimeCursorField, limit: z.coerce.number().int().min(1).max(50).default(20) };

/** Lý do khóa: 3–500 ký tự, lưu vào audit. */
export const LockInputSchema = z.object({ reason: z.string().trim().min(3).max(500) });
export class AdminAccountLockDto extends createZodDto(LockInputSchema) {}

// ── Hành khách ──────────────────────────────────────────────────────────────────────────────────────────

/** Id hành khách do Better Auth sinh (không phải uuid) → cursor `{createdAt}_{id}` riêng. */
const PASSENGER_CURSOR = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z_[A-Za-z0-9_-]{1,64}$/;

export const PassengerListQuerySchema = z.object({
  q: search,
  status: z.enum(AccountStatus).optional(),
  cursor: z.string().regex(PASSENGER_CURSOR).optional(),
  limit: page.limit,
});
export type PassengerListQuery = z.infer<typeof PassengerListQuerySchema>;
export class AdminPassengerListQueryDto extends createZodDto(PassengerListQuerySchema) {}

const PassengerSchema = z.object({
  id: z.string(),
  name: z.string().nullable(),
  email: z.string(),
  /** Cách đăng nhập đã liên kết: `email-otp`, `google`, `facebook`, `apple`. */
  providers: z.array(z.string()),
  status: z.enum(AccountStatus),
  lockedReason: z.string().nullable(),
  lockedAt: z.iso.datetime().nullable(),
  createdAt: z.iso.datetime(),
  lastLoginAt: z.iso.datetime().nullable(),
});
export type AdminPassenger = z.infer<typeof PassengerSchema>;

export const PassengerPageSchema = z.object({ items: z.array(PassengerSchema), nextCursor: z.string().nullable(), total: z.int() });
export type PassengerPage = z.infer<typeof PassengerPageSchema>;
export class AdminPassengerPageDto extends createZodDto(PassengerPageSchema) {}

// Chi tiết hành khách (FR-ADM-02 "giám sát"; Security §239 — xem dữ liệu cá nhân có audit; tự thiết kế 28/10/2026, chờ duyệt).
// Chỉ TÀI KHOẢN hành khách: khách vãng lai không có tài khoản, Admin tra theo đơn / vé (Giao dịch, chi tiết chuyến).

/** Số tiền chỉ trả cho tài khoản có quyền xem thanh toán (`payment:monitor`); thiếu quyền → `null`. */
const MoneyOrHidden = z.int().nonnegative().nullable();

export const PassengerDetailSchema = PassengerSchema.extend({
  emailVerified: z.boolean(),
  /** Số điện thoại trong hồ sơ, đã che (`0*** *** 567`). */
  phone: z.string().nullable(),
  /** Điểm VXN Plus khả dụng; chưa có tài khoản thành viên → `null`. Hạng + sổ điểm xem ở VXN Plus (`loyalty:manage`). */
  loyaltyPoints: z.int().nullable(),
  savedPassengerCount: z.int(),
  bookingCount: z.int(),
  /** Vé còn đi chuyến (đã bán, chưa hủy / hoàn) trên mọi đơn của tài khoản. */
  ticketCount: z.int(),
  supportTicketCount: z.int(),
  /** Tổng thanh toán thành công. */
  totalPaid: MoneyOrHidden,
});
export type AdminPassengerDetail = z.infer<typeof PassengerDetailSchema>;
export class AdminPassengerDetailDto extends createZodDto(PassengerDetailSchema) {}

export const PassengerBookingQuerySchema = z.object({ cursor: TimeCursorField, limit: page.limit });
export type PassengerBookingQuery = z.infer<typeof PassengerBookingQuerySchema>;
export class AdminPassengerBookingQueryDto extends createZodDto(PassengerBookingQuerySchema) {}

const PassengerBookingSchema = z.object({
  id: z.uuid(),
  bookingCode: z.string(),
  status: z.string(),
  createdAt: z.iso.datetime(),
  total: MoneyOrHidden,
  operatorId: z.uuid(),
  operatorName: z.string(),
  tripId: z.uuid(),
  routeName: z.string(),
  departureAt: z.iso.datetime(),
  /** Người đi trên từng vé (một chỗ = một vé). Chỗ đôi chở tối đa hai người nhưng chỉ ghi một tên (BR-78). */
  passengers: z.array(z.object({ fullName: z.string(), seatCode: z.string(), ticketStatus: z.string().nullable() })),
  /** Thanh toán gần nhất của đơn — mở chi tiết ở mục Giao dịch. */
  paymentId: z.uuid().nullable(),
});
export const PassengerBookingPageSchema = z.object({ items: z.array(PassengerBookingSchema), nextCursor: z.string().nullable(), total: z.int() });
export type AdminPassengerBookingPage = z.infer<typeof PassengerBookingPageSchema>;
export class AdminPassengerBookingPageDto extends createZodDto(PassengerBookingPageSchema) {}

// ── Nhân viên nhà xe (chỉ xem) ──────────────────────────────────────────────────────────────────────────

export const EmployeeListQuerySchema = z.object({
  q: search,
  operatorId: z.uuid().optional(),
  role: z.enum(EmployeeRole).optional(),
  status: z.enum(AccountStatus).optional(),
  ...page,
});
export type EmployeeListQuery = z.infer<typeof EmployeeListQuerySchema>;
export class AdminEmployeeListQueryDto extends createZodDto(EmployeeListQuerySchema) {}

const EmployeeSchema = z.object({
  id: z.uuid(),
  /** `{slug nhà xe}/{tên đăng nhập}`. */
  username: z.string(),
  email: z.string().nullable(),
  operatorId: z.uuid(),
  operatorName: z.string(),
  role: z.enum(EmployeeRole),
  status: z.enum(AccountStatus),
  lastLoginAt: z.iso.datetime().nullable(),
});
export type AdminEmployee = z.infer<typeof EmployeeSchema>;

export const EmployeePageSchema = z.object({
  items: z.array(EmployeeSchema),
  nextCursor: z.string().nullable(),
  total: z.int(),
  /** Nhà xe đang có nhân viên — lựa chọn của ô lọc "Nhà xe". */
  operators: z.array(z.object({ id: z.uuid(), name: z.string() })),
});
export type EmployeePage = z.infer<typeof EmployeePageSchema>;
export class AdminEmployeePageDto extends createZodDto(EmployeePageSchema) {}

// ── Tài khoản quản trị ──────────────────────────────────────────────────────────────────────────────────

/** Mã quyền `resource:action` (TASK-IAM-007). Quyền tick được theo vai trò: `grantable` của danh sách. */
export const PermissionListSchema = z.array(z.enum(PERMISSIONS)).max(PERMISSIONS.length);

export const PlatformAccountListQuerySchema = z.object({
  q: search,
  role: z.enum(PlatformRole).optional(),
  status: z.enum(AccountStatus).optional(),
});
export type PlatformAccountListQuery = z.infer<typeof PlatformAccountListQuerySchema>;
export class AdminPlatformAccountListQueryDto extends createZodDto(PlatformAccountListQuerySchema) {}

const PlatformAccountSchema = z.object({
  id: z.uuid(),
  /** `platform/{username}`. */
  username: z.string(),
  email: z.string().nullable(),
  role: z.enum(PlatformRole),
  /** Quyền tick được đang có; tài khoản chưa phân quyền riêng (seed) = đủ quyền tick được của vai trò. */
  permissions: PermissionListSchema,
  status: z.enum(AccountStatus),
  mfaEnabled: z.boolean(),
  passwordChangeRequired: z.boolean(),
  /** Mật khẩu tạm chưa gửi được — "Cấp lại mật khẩu" để gửi lại. */
  credentialDeliveryPending: z.boolean(),
  lockedReason: z.string().nullable(),
  lockedAt: z.iso.datetime().nullable(),
  lastLoginAt: z.iso.datetime().nullable(),
  /** Tài khoản đang đăng nhập — không tự khóa / đặt lại chính mình. */
  isSelf: z.boolean(),
});
export type AdminPlatformAccount = z.infer<typeof PlatformAccountSchema>;
export class AdminPlatformAccountDto extends createZodDto(PlatformAccountSchema) {}

export const PlatformAccountListSchema = z.object({
  items: z.array(PlatformAccountSchema),
  /** Quyền người xem được tick / bỏ tick, theo vai trò của tài khoản đích (chỉ cấp / gỡ quyền mình đang có). */
  grantable: z.object({ PLATFORM_ADMIN: PermissionListSchema, PLATFORM_SUPPORT: PermissionListSchema }),
});
export type PlatformAccountList = z.infer<typeof PlatformAccountListSchema>;
export class AdminPlatformAccountListDto extends createZodDto(PlatformAccountListSchema) {}

export const PlatformAccountCreateSchema = z.object({
  /** Phần sau `platform/`: chữ thường, số, `.`, `_`, `-`, 3–40 ký tự. */
  username: z
    .string()
    .trim()
    .toLowerCase()
    .regex(/^[a-z0-9][a-z0-9._-]{2,39}$/, "Tên đăng nhập gồm 3–40 ký tự chữ thường, số, dấu chấm, gạch dưới, gạch ngang."),
  email: z.email().trim().toLowerCase().max(254),
  role: z.enum(PlatformRole),
  /** Quyền tick được của vai trò; chỉ gồm quyền người cấp đang có (TASK-IAM-007). */
  permissions: PermissionListSchema,
});
export type PlatformAccountCreate = z.infer<typeof PlatformAccountCreateSchema>;
export class AdminPlatformAccountCreateDto extends createZodDto(PlatformAccountCreateSchema) {}

export const PlatformPermissionsUpdateSchema = z.object({
  permissions: PermissionListSchema,
  /** Lý do: 3–500 ký tự, lưu vào audit. */
  reason: z.string().trim().min(3).max(500),
});
export type PlatformPermissionsUpdate = z.infer<typeof PlatformPermissionsUpdateSchema>;
export class AdminPlatformPermissionsUpdateDto extends createZodDto(PlatformPermissionsUpdateSchema) {}

export class AdminUserIdParamDto extends createZodDto(z.object({ id: z.string().trim().min(1).max(64) })) {}
export class AdminAccountIdParamDto extends createZodDto(z.object({ id: z.uuid() })) {}
