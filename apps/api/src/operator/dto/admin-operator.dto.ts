import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { TimeCursorField } from "../../common/time-cursor";
import { OperatorStatus } from "../../database/prisma.types";

// API §7.5 `/admin/operators` — Admin xem / tạm khóa / mở lại nhà xe (FR-ADM-02/03, UC-23 A6; Figma ADM-02e/f).

export const OperatorListQuerySchema = z.object({
  /** Tên nhà xe, mã nhà xe (slug) hoặc tên đăng nhập / email chủ nhà xe. */
  q: z
    .string()
    .trim()
    .max(100)
    .transform((value) => value || undefined)
    .optional(),
  status: z.enum(OperatorStatus).optional(),
  /** Chỉ nhà xe có yêu cầu đổi tài khoản nhận tiền đang chờ xác minh (TASK-OPR-001b). */
  bankChange: z.literal("PENDING").optional(),
  /** `{createdAt}_{id}` của dòng cuối trang trước — nhà xe mới tạo trước. */
  cursor: TimeCursorField,
  limit: z.coerce.number().int().min(1).max(50).default(20),
});
export type OperatorListQuery = z.infer<typeof OperatorListQuerySchema>;
export class AdminOperatorListQueryDto extends createZodDto(OperatorListQuerySchema) {}

const AdminOperatorSchema = z.object({
  id: z.uuid(),
  name: z.string(),
  slug: z.string(),
  status: z.enum(OperatorStatus),
  suspendedReason: z.string().nullable(),
  suspendedAt: z.iso.datetime().nullable(),
  /** Ngày duyệt hồ sơ (nhà xe tạo qua hồ sơ đăng ký); nhà xe seed lấy ngày tạo. */
  approvedAt: z.iso.datetime(),
  /** Hồ sơ đăng ký đã tạo ra nhà xe — dùng để gửi lại mật khẩu tạm cho chủ nhà xe. */
  applicationId: z.uuid().nullable(),
  owner: z
    .object({
      id: z.uuid(),
      username: z.string(),
      email: z.string().nullable(),
      /** Mật khẩu tạm chưa gửi được (UC-23 A4) — hiện nút "Gửi lại". */
      credentialDeliveryPending: z.boolean(),
    })
    .nullable(),
  /** Tuyến đang dùng. */
  routeCount: z.int(),
  /** Chuyến đang mở bán / hết chỗ chưa khởi hành. */
  openTripCount: z.int(),
  /** Có yêu cầu đổi tài khoản nhận tiền đang chờ Admin xác minh (BR-37). */
  bankChangePending: z.boolean(),
});
export type AdminOperator = z.infer<typeof AdminOperatorSchema>;
export class AdminOperatorDto extends createZodDto(AdminOperatorSchema) {}

export const AdminOperatorPageSchema = z.object({
  items: z.array(AdminOperatorSchema),
  nextCursor: z.string().nullable(),
  total: z.int(),
});
export type AdminOperatorPage = z.infer<typeof AdminOperatorPageSchema>;
export class AdminOperatorPageDto extends createZodDto(AdminOperatorPageSchema) {}

/** Lý do tạm khóa: 3–500 ký tự (Figma ADM-02f), lưu vào audit và gửi chủ nhà xe. */
export const SuspendInputSchema = z.object({ reason: z.string().trim().min(3).max(500) });
export class AdminOperatorSuspendDto extends createZodDto(SuspendInputSchema) {}

export class AdminOperatorIdParamDto extends createZodDto(z.object({ id: z.uuid() })) {}

// ── Xác minh yêu cầu đổi tài khoản nhận tiền (TASK-OPR-001b, UC-11 bước 4, BR-37) ──

const AdminBankAccountSchema = z.object({
  bankName: z.string(),
  /** Số đầy đủ — Admin cần để đối chiếu với ngân hàng; mỗi lần xem ghi audit. */
  accountNumber: z.string(),
  accountHolder: z.string(),
});

export const AdminBankChangeSchema = z.object({
  changeId: z.uuid(),
  operatorName: z.string(),
  /** Tên pháp lý / mã số thuế để đối chiếu chủ tài khoản. */
  legalName: z.string().nullable(),
  taxCode: z.string().nullable(),
  current: AdminBankAccountSchema.extend({ verifiedAt: z.iso.datetime().nullable() }).nullable(),
  requested: AdminBankAccountSchema.extend({
    reason: z.string().nullable(),
    requestedAt: z.iso.datetime(),
    /** Tên đăng nhập người gửi (`slug/username`), `null` nếu tài khoản đã bị xóa. */
    requestedBy: z.string().nullable(),
  }),
});
export type AdminBankChange = z.infer<typeof AdminBankChangeSchema>;
export class AdminBankChangeDto extends createZodDto(AdminBankChangeSchema) {}

export const BankChangeDecisionInputSchema = z.object({
  /** Đúng yêu cầu Admin vừa xem — yêu cầu đã đổi thì 404, không duyệt nhầm. */
  changeId: z.uuid(),
});
export class AdminBankChangeApproveDto extends createZodDto(BankChangeDecisionInputSchema) {}

export const BankChangeRejectInputSchema = BankChangeDecisionInputSchema.extend({
  /** Lý do từ chối: 3–500 ký tự, gửi chủ nhà xe và lưu audit. */
  reason: z.string().trim().min(3).max(500),
});
export class AdminBankChangeRejectDto extends createZodDto(BankChangeRejectInputSchema) {}
