import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { OPERATOR_MANAGER_PERMISSIONS } from "../../role/permissions";
import { EMPLOYEE_USERNAME_PREFIX } from "../account.types";

// API §7.3 — tài khoản quản lý dùng Operator OS do chủ nhà xe cấp (TASK-IAM-007, tự thiết kế — chờ duyệt).
// Quyền `manager:manage` (chỉ Owner); thao tác thay đổi cần xác nhận lại danh tính.

/** Quyền tick được của tài khoản quản lý (không gồm hồ sơ / tài khoản nhận tiền / tài khoản quản lý — chỉ Owner). */
const ManagerPermissionsSchema = z.array(z.enum(OPERATOR_MANAGER_PERMISSIONS)).max(OPERATOR_MANAGER_PERMISSIONS.length);
const ReasonSchema = z.string().trim().min(3).max(500);

/** Phần sau `{slug nhà xe}/`: 3–40 ký tự chữ thường, số, `.`, `_`, `-`; không dùng tiền tố `nv.` của nhân viên. */
const UsernameSchema = z
  .string()
  .trim()
  .toLowerCase()
  .regex(/^[a-z0-9][a-z0-9._-]{2,39}$/, "Tên đăng nhập gồm 3–40 ký tự chữ thường, số, dấu chấm, gạch dưới, gạch ngang.")
  .refine((username) => !username.startsWith(EMPLOYEE_USERNAME_PREFIX), "Tiền tố `nv.` dành cho tài khoản nhân viên.");

export const ManagerCreateSchema = z.object({
  username: UsernameSchema,
  contactEmail: z.email().trim().toLowerCase().max(254),
  permissions: ManagerPermissionsSchema,
  reason: ReasonSchema,
});
export type ManagerCreate = z.infer<typeof ManagerCreateSchema>;
export class ManagerCreateDto extends createZodDto(ManagerCreateSchema) {}

export const ManagerUpdateSchema = z
  .object({
    permissions: ManagerPermissionsSchema.optional(),
    /** Khóa / mở khóa — khóa thì không đăng nhập được, mọi phiên bị thu hồi. */
    status: z.enum(["ACTIVE", "LOCKED"]).optional(),
    reason: ReasonSchema,
  })
  .refine(({ permissions, status }) => permissions !== undefined || status !== undefined, {
    message: "Cần ít nhất một trường cập nhật.",
  });
export type ManagerUpdate = z.infer<typeof ManagerUpdateSchema>;
export class ManagerUpdateDto extends createZodDto(ManagerUpdateSchema) {}

export const ManagerReasonSchema = z.object({ reason: ReasonSchema });
export class ManagerReasonDto extends createZodDto(ManagerReasonSchema) {}

export const ManagerIdParamSchema = z.object({ managerId: z.uuid() });
export class ManagerIdParamDto extends createZodDto(ManagerIdParamSchema) {}

export const ManagerAccountSchema = z.object({
  id: z.uuid(),
  /** `{slug nhà xe}/{tên đăng nhập}` — tên đăng nhập Operator OS. */
  username: z.string(),
  contactEmail: z.email().nullable(),
  permissions: ManagerPermissionsSchema,
  status: z.enum(["ACTIVE", "LOCKED", "DISABLED"]),
  mfaEnabled: z.boolean(),
  /** Chưa đổi mật khẩu tạm ở lần đăng nhập đầu. */
  passwordChangeRequired: z.boolean(),
  /** Mật khẩu tạm chưa gửi được — "Cấp lại mật khẩu" để gửi lại. */
  credentialDeliveryPending: z.boolean(),
  temporaryPasswordExpiresAt: z.iso.datetime().nullable(),
  lastLoginAt: z.iso.datetime().nullable(),
  createdAt: z.iso.datetime(),
});
export type ManagerAccount = z.infer<typeof ManagerAccountSchema>;
export class ManagerAccountDto extends createZodDto(ManagerAccountSchema) {}

export const ManagerListSchema = z.object({ items: z.array(ManagerAccountSchema) });
export type ManagerList = z.infer<typeof ManagerListSchema>;
export class ManagerListDto extends createZodDto(ManagerListSchema) {}
