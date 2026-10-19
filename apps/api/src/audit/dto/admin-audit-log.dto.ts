import { createZodDto } from "nestjs-zod";
import { z } from "zod";

// API §7.5 `/admin/audit-logs` — Admin tra cứu audit (UC-30, FR-ADM-16, BR-58; Figma ADM-15a/15b). Quyền `audit:read`.

/** Phân hệ = nhóm tiền tố `action`. Thêm nhóm mới ở đây khi module mới ghi audit. */
export const AUDIT_MODULES = {
  AUTH: ["auth."],
  ACCOUNT: ["iam."],
  OPERATOR_KYC: ["operator_application."],
  CATALOG: ["catalog."],
  STOP_POINT: ["stop_point_catalog.", "stop_point_proposal.", "stop_point."],
  VEHICLE: ["vehicle_image.", "vehicle."],
  TRIP: ["trip."],
  FARE: ["fare."],
  AUDIT: ["audit."],
} as const satisfies Record<string, readonly string[]>;
export type AuditModule = keyof typeof AUDIT_MODULES | "OTHER";
const MODULE_CODES = [...(Object.keys(AUDIT_MODULES) as (keyof typeof AUDIT_MODULES)[]), "OTHER"] as const;

/** Loại người thực hiện = nhóm `actorRole` (sự kiện đăng nhập ghi `SubjectType`, thao tác nghiệp vụ ghi `Role`). */
export const AUDIT_ACTOR_ROLES = {
  PLATFORM: ["PLATFORM_ADMIN", "PLATFORM_SUPPORT", "PLATFORM"],
  OPERATOR: ["OPERATOR_OWNER", "OPERATOR"],
  EMPLOYEE: ["DRIVER", "TICKET_STAFF", "SUPPORT_STAFF", "EMPLOYEE"],
  PASSENGER: ["PASSENGER"],
} as const satisfies Record<string, readonly string[]>;
const ACTOR_TYPES = ["PLATFORM", "OPERATOR", "EMPLOYEE", "PASSENGER", "SYSTEM"] as const;
export type AuditActorType = (typeof ACTOR_TYPES)[number] | "UNKNOWN";

/** Cursor `{createdAt ISO}_{ObjectId hex}` của bản ghi cuối trang trước. */
const AUDIT_CURSOR = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z_[0-9a-f]{24}$/;

export const AuditLogListQuerySchema = z.object({
  from: z.iso.datetime().optional(),
  /** Mốc cuối, không gồm. */
  to: z.iso.datetime().optional(),
  actorType: z.enum(ACTOR_TYPES).optional(),
  module: z.enum(MODULE_CODES).optional(),
  result: z.enum(["SUCCESS", "FAILURE"]).optional(),
  /** Tên đăng nhập (vd `platform/khanh`, `saoviet/owner01`, một phần tên) hoặc đúng mã đối tượng. */
  q: z
    .string()
    .trim()
    .max(100)
    .transform((value) => value || undefined)
    .optional(),
  cursor: z.string().regex(AUDIT_CURSOR).optional(),
  limit: z.coerce.number().int().min(1).max(100).default(20),
});
export type AuditLogListQuery = z.infer<typeof AuditLogListQuerySchema>;
export class AdminAuditLogListQueryDto extends createZodDto(AuditLogListQuerySchema) {}

const AuditLogItemSchema = z.object({
  id: z.string(),
  createdAt: z.iso.datetime(),
  actorId: z.string().nullable(),
  /** Tên đăng nhập của người thực hiện (hành khách: email đã che); `null` = tác vụ nền / tài khoản không còn. */
  actorName: z.string().nullable(),
  actorRole: z.string().nullable(),
  actorType: z.enum([...ACTOR_TYPES, "UNKNOWN"]),
  action: z.string(),
  module: z.enum(MODULE_CODES),
  result: z.enum(["SUCCESS", "FAILURE"]),
  targetType: z.string(),
  targetId: z.string(),
  operator: z.object({ id: z.string(), name: z.string() }).nullable(),
  reason: z.string().nullable(),
});
export type AuditLogItem = z.infer<typeof AuditLogItemSchema>;

export const AuditLogListSchema = z.object({
  items: z.array(AuditLogItemSchema),
  nextCursor: z.string().nullable(),
  total: z.int(),
});
export type AuditLogList = z.infer<typeof AuditLogListSchema>;
export class AdminAuditLogListDto extends createZodDto(AuditLogListSchema) {}

const Snapshot = z.record(z.string(), z.unknown()).nullable();

export const AuditLogDetailSchema = AuditLogItemSchema.extend({
  /** Dữ liệu trước / sau, trường nhạy cảm đã che ở server (email, số điện thoại, số tài khoản, IP, bí mật). */
  before: Snapshot,
  after: Snapshot,
  /** IP đã che và thiết bị suy từ user-agent, nếu sự kiện có ghi. */
  ip: z.string().nullable(),
  device: z.string().nullable(),
  requestId: z.string().nullable(),
  /** Chuỗi bản ghi cùng đối tượng (tối đa 20, mới nhất trước), gồm cả bản ghi đang xem. */
  related: z.array(AuditLogItemSchema),
});
export type AuditLogDetail = z.infer<typeof AuditLogDetailSchema>;
export class AdminAuditLogDetailDto extends createZodDto(AuditLogDetailSchema) {}

export class AdminAuditLogIdParamDto extends createZodDto(z.object({ id: z.string().regex(/^[0-9a-f]{24}$/) })) {}
