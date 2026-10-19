import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { OperatorApplicationDocumentType, OperatorApplicationStatus } from "../../database/prisma.types";
import { EMPLOYEE_USERNAME_PREFIX } from "../../iam/user/account.types";
import { REVIEWABLE_STATUSES } from "../operator-application-format";

/** Trang danh sách: `submittedAt` + `id` của dòng cuối trang trước (`2026-10-13T03:40:00.000Z_<uuid>`). */
const CURSOR_PATTERN = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z_[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/;

export const AdminApplicationListQuerySchema = z.object({
  /** Bỏ trống = mọi hồ sơ đã gửi duyệt ít nhất một lần; hồ sơ nháp chưa gửi không hiện với Admin. */
  status: z.enum(REVIEWABLE_STATUSES).optional(),
  /** Tìm theo mã hồ sơ, tên nhà xe / pháp nhân, email liên hệ hoặc mã số thuế. */
  q: z.string().trim().min(1).max(100).optional(),
  /** Chỉ hồ sơ gửi duyệt từ thời điểm này trở đi (ô "Thời điểm gửi"). */
  submittedSince: z.iso.datetime().optional(),
  /** `true` = chỉ hồ sơ có email / mã số thuế / tài khoản nhận tiền trùng hồ sơ khác. */
  duplicatesOnly: z
    .enum(["true", "false"])
    .optional()
    .transform((value) => value === "true"),
  cursor: z.string().regex(CURSOR_PATTERN).optional(),
  limit: z.coerce.number().int().min(1).max(50).default(20),
});
export type AdminApplicationListQuery = z.infer<typeof AdminApplicationListQuerySchema>;
/** Query hàng đợi hồ sơ đăng ký: lọc trạng thái, tìm kiếm, mới gửi trước. */
export class AdminApplicationListQueryDto extends createZodDto(AdminApplicationListQuerySchema) {}

/** Thông tin định danh trùng với hồ sơ khác (UC-10 A2) — chỉ để Admin kiểm tra, không chặn duyệt. */
const DuplicateFieldSchema = z.enum(["CONTACT_EMAIL", "TAX_CODE", "BANK_ACCOUNT"]);
export type DuplicateField = z.infer<typeof DuplicateFieldSchema>;

export const AdminApplicationListResponseSchema = z.object({
  items: z.array(
    z.object({
      id: z.uuid(),
      applicationCode: z.string(),
      status: z.enum(OperatorApplicationStatus),
      operatorName: z.string(),
      legalName: z.string().nullable(),
      taxCode: z.string().nullable(),
      contactName: z.string(),
      contactEmail: z.string(),
      submittedAt: z.iso.datetime(),
      reviewedAt: z.iso.datetime().nullable(),
      /** Trường trùng với ít nhất một hồ sơ khác; rỗng = không trùng. */
      duplicates: z.array(DuplicateFieldSchema),
    }),
  ),
  nextCursor: z.string().nullable(),
});
export type AdminApplicationListResponse = z.infer<typeof AdminApplicationListResponseSchema>;
/** Một trang hàng đợi hồ sơ đăng ký. */
export class AdminApplicationListResponseDto extends createZodDto(AdminApplicationListResponseSchema) {}

export const AdminApplicationParamSchema = z.object({ applicationId: z.uuid() });
export class AdminApplicationParamDto extends createZodDto(AdminApplicationParamSchema) {}

export const AdminApplicationDocumentParamSchema = z.object({
  applicationId: z.uuid(),
  type: z.enum(OperatorApplicationDocumentType),
});
export class AdminApplicationDocumentParamDto extends createZodDto(AdminApplicationDocumentParamSchema) {}

const DuplicateApplicationSchema = z.object({
  id: z.uuid(),
  applicationCode: z.string(),
  operatorName: z.string(),
  status: z.enum(OperatorApplicationStatus),
});

/** Mốc trong lịch sử hồ sơ, mới nhất trước. */
const HistoryEventSchema = z.object({
  event: z.enum(["CREATED", "EMAIL_VERIFIED", "SUBMITTED", "NEEDS_INFO", "REJECTED", "APPROVED"]),
  at: z.iso.datetime(),
  /** Nội dung yêu cầu bổ sung / lý do từ chối. */
  note: z.string().nullable(),
});

export const AdminApplicationDetailSchema = z.object({
  id: z.uuid(),
  applicationCode: z.string(),
  status: z.enum(OperatorApplicationStatus),
  operatorName: z.string(),
  contactName: z.string(),
  contactEmail: z.string(),
  contactEmailVerifiedAt: z.iso.datetime().nullable(),
  legalName: z.string().nullable(),
  taxCode: z.string().nullable(),
  hotline: z.string().nullable(),
  address: z.string().nullable(),
  displayName: z.string().nullable(),
  description: z.string().nullable(),
  bankName: z.string().nullable(),
  /** Chỉ 4 số cuối (`•••• 4521`) — Security §9. */
  bankAccountNumberMasked: z.string().nullable(),
  bankAccountHolder: z.string().nullable(),
  documents: z.array(
    z.object({
      type: z.enum(OperatorApplicationDocumentType),
      fileName: z.string(),
      contentType: z.string(),
      sizeBytes: z.int(),
      uploadedAt: z.iso.datetime(),
    }),
  ),
  /** Lần yêu cầu bổ sung / từ chối gần nhất. */
  reviewNote: z.string().nullable(),
  createdAt: z.iso.datetime(),
  submittedAt: z.iso.datetime().nullable(),
  reviewedAt: z.iso.datetime().nullable(),
  /** Hồ sơ khác trùng thông tin định danh (tối đa 10 mỗi loại). */
  duplicates: z.object({
    contactEmail: z.array(DuplicateApplicationSchema),
    taxCode: z.array(DuplicateApplicationSchema),
    bankAccount: z.array(DuplicateApplicationSchema),
  }),
  /** Nhà xe và tài khoản chủ nhà xe đã tạo — chỉ khi `APPROVED`. */
  operator: z
    .object({
      operatorId: z.uuid(),
      operatorSlug: z.string(),
      ownerUsername: z.string(),
      /** Mật khẩu tạm chưa gửi được — Admin gửi lại. */
      credentialDeliveryPending: z.boolean(),
    })
    .nullable(),
  /** `null` = nhật ký audit tạm thời không đọc được. */
  history: z.array(HistoryEventSchema).nullable(),
});
export type AdminApplicationDetail = z.infer<typeof AdminApplicationDetailSchema>;
/** Hồ sơ đăng ký nhà xe, nhìn từ phía Admin. */
export class AdminApplicationDetailDto extends createZodDto(AdminApplicationDetailSchema) {}

export const ApprovalInputSchema = z.object({
  /** Slug của nhà xe — phần đầu tên đăng nhập `{slug}/{username}`, không đổi được về sau. */
  operatorSlug: z
    .string()
    .trim()
    .toLowerCase()
    .min(3)
    .max(64)
    .regex(/^[a-z0-9][a-z0-9-]*$/, "Slug gồm chữ thường, số, gạch ngang; bắt đầu bằng chữ hoặc số.")
    .refine((slug) => slug !== "platform", "Slug này đã được dành riêng."),
  /** Tên đăng nhập chủ nhà xe (không có tiền tố `nv.` của nhân viên). */
  ownerUsername: z
    .string()
    .trim()
    .min(3)
    .max(64)
    .regex(/^[A-Za-z0-9._-]+$/, "Tên đăng nhập gồm chữ, số, dấu chấm, gạch dưới, gạch ngang.")
    .refine((username) => !username.toLowerCase().startsWith(EMPLOYEE_USERNAME_PREFIX), "Không bắt đầu bằng \"nv.\"."),
});
export type ApprovalInput = z.infer<typeof ApprovalInputSchema>;
/** Body duyệt hồ sơ: slug nhà xe + tên đăng nhập chủ nhà xe. */
export class ApprovalInputDto extends createZodDto(ApprovalInputSchema) {}

export const ApprovalResponseSchema = z.object({
  applicationCode: z.string(),
  status: z.literal(OperatorApplicationStatus.APPROVED),
  operatorId: z.uuid(),
  operatorSlug: z.string(),
  ownerUsername: z.string(),
  /** `true` = email mật khẩu tạm chưa gửi được; Admin gửi lại bằng `…/resend-owner-credentials`. */
  credentialDeliveryPending: z.boolean(),
});
export type ApprovalResponse = z.infer<typeof ApprovalResponseSchema>;
export class ApprovalResponseDto extends createZodDto(ApprovalResponseSchema) {}

export const DecisionInputSchema = z.object({
  /** Nội dung cần bổ sung / lý do từ chối — gửi tới email liên hệ. */
  reason: z.string().trim().min(3).max(500),
});
export type DecisionInput = z.infer<typeof DecisionInputSchema>;
/** Body yêu cầu bổ sung / từ chối. */
export class DecisionInputDto extends createZodDto(DecisionInputSchema) {}

export const DecisionResponseSchema = z.object({
  applicationCode: z.string(),
  status: z.enum([OperatorApplicationStatus.NEEDS_INFO, OperatorApplicationStatus.REJECTED]),
  /** `false` = email báo người nộp chưa gửi được (hồ sơ vẫn đã đổi trạng thái). */
  emailDelivered: z.boolean(),
});
export type DecisionResponse = z.infer<typeof DecisionResponseSchema>;
export class DecisionResponseDto extends createZodDto(DecisionResponseSchema) {}
