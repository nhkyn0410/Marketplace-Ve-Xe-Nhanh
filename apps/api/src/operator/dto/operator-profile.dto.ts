import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { OperatorApplicationDocumentType, OperatorStatus } from "../../database/prisma.types";
import { DOCUMENT_CONTENT_TYPES, MAX_DOCUMENT_BYTES } from "../../operator-kyc/operator-application-format";
import { normalizeAccountHolder } from "../kyc-document-format";

// API §7.3 `/operator/profile` — hồ sơ, giấy tờ KYC và tài khoản nhận tiền của nhà xe đã duyệt (TASK-OPR-001b, UC-11,
// FR-OPR-02..05; Figma 1667:27240, 1667:27586).

const requiredText = (max: number) => z.string().trim().min(1).max(max);
/** Bỏ khoảng trắng, dấu chấm, gạch trước khi kiểm: `1900.6868`, `1900 6868`. */
const digits = (pattern: RegExp, message: string) =>
  z
    .string()
    .max(30)
    .transform((value) => value.replace(/[\s.-]/g, ""))
    .pipe(z.string().regex(pattern, message));

export const ProfileUpdateInputSchema = z.object({
  displayName: requiredText(100),
  hotline: digits(/^\+?\d{8,15}$/, "Hotline gồm 8–15 chữ số."),
  publicEmail: z
    .string()
    .trim()
    .max(254)
    .transform((value) => value.toLowerCase())
    .pipe(z.email("Email không hợp lệ.")),
  address: requiredText(255),
  description: z
    .string()
    .trim()
    .max(1000)
    .nullable()
    .transform((value) => value || null),
});
export type ProfileUpdateInput = z.infer<typeof ProfileUpdateInputSchema>;
/** Body sửa thông tin công khai (tên hiển thị, hotline, email, địa chỉ, mô tả). Tên pháp lý / MST không sửa ở đây. */
export class OperatorProfileUpdateDto extends createZodDto(ProfileUpdateInputSchema) {}

const DocumentTypeSchema = z.enum(OperatorApplicationDocumentType);

const KycDocumentSchema = z.object({
  type: DocumentTypeSchema,
  fileName: z.string(),
  contentType: z.string(),
  sizeBytes: z.int(),
  uploadedAt: z.iso.datetime(),
});

const BankAccountSchema = z.object({
  bankName: z.string(),
  /** Chỉ 4 số cuối (`•••• 4521`) — số đầy đủ không trả ra Operator OS. */
  accountNumberMasked: z.string(),
  accountHolder: z.string(),
  verifiedAt: z.iso.datetime().nullable(),
});

const BankChangeSchema = z.object({
  status: z.enum(["PENDING", "REJECTED"]),
  bankName: z.string(),
  accountNumberMasked: z.string(),
  accountHolder: z.string(),
  reason: z.string().nullable(),
  /** Lý do Admin từ chối (chỉ khi `REJECTED`). */
  reviewNote: z.string().nullable(),
  requestedAt: z.iso.datetime(),
  reviewedAt: z.iso.datetime().nullable(),
});

export const OperatorProfileResponseSchema = z.object({
  id: z.uuid(),
  slug: z.string(),
  displayName: z.string(),
  /** Tên pháp lý / mã số thuế / ngày duyệt: `null` với nhà xe tạo trước khi có luồng đăng ký (seed). */
  legalName: z.string().nullable(),
  taxCode: z.string().nullable(),
  hotline: z.string().nullable(),
  publicEmail: z.string().nullable(),
  address: z.string().nullable(),
  description: z.string().nullable(),
  status: z.enum(OperatorStatus),
  suspendedReason: z.string().nullable(),
  approvedAt: z.iso.datetime().nullable(),
  documents: z.array(KycDocumentSchema),
  /** Tài khoản đang dùng để chi trả (đã xác minh). */
  bankAccount: BankAccountSchema.nullable(),
  /** Yêu cầu đổi gần nhất còn chờ, hoặc vừa bị từ chối (chưa gửi yêu cầu mới). */
  bankChange: BankChangeSchema.nullable(),
});
export type OperatorProfileResponse = z.infer<typeof OperatorProfileResponseSchema>;
export class OperatorProfileResponseDto extends createZodDto(OperatorProfileResponseSchema) {}

export const KycUploadInputSchema = z.object({
  contentType: z.enum(DOCUMENT_CONTENT_TYPES),
  sizeBytes: z.int().min(1).max(MAX_DOCUMENT_BYTES),
});
export type KycUploadInput = z.infer<typeof KycUploadInputSchema>;
/** Body xin URL tải một giấy tờ lên kho riêng tư. */
export class KycUploadInputDto extends createZodDto(KycUploadInputSchema) {}

export const KycUploadResponseSchema = z.object({
  /** URL để trình duyệt `PUT` thẳng file lên kho, kèm đúng header `Content-Type` đã khai. */
  uploadUrl: z.url(),
  /** Khóa object do server sinh — gửi lại ở `PUT /operator/profile/documents/{type}`. */
  objectKey: z.string(),
  expiresAt: z.iso.datetime(),
});
export type KycUploadResponse = z.infer<typeof KycUploadResponseSchema>;
export class KycUploadResponseDto extends createZodDto(KycUploadResponseSchema) {}

export const KycReplaceInputSchema = z.object({
  objectKey: z.string().min(1).max(200),
  /** Tên file gốc — chỉ để hiển thị. */
  fileName: requiredText(255),
});
export type KycReplaceInput = z.infer<typeof KycReplaceInputSchema>;
/** Body thay một giấy tờ bằng bản mới vừa tải lên. */
export class KycReplaceInputDto extends createZodDto(KycReplaceInputSchema) {}

export const KycDownloadResponseSchema = z.object({
  /** URL đọc giấy tờ, hạn 5 phút (ADR-018). */
  url: z.url(),
  expiresAt: z.iso.datetime(),
});
export type KycDownloadResponse = z.infer<typeof KycDownloadResponseSchema>;
export class KycDownloadResponseDto extends createZodDto(KycDownloadResponseSchema) {}

export class KycDocumentTypeParamDto extends createZodDto(z.object({ type: DocumentTypeSchema })) {}

export const BankChangeInputSchema = z.object({
  bankName: requiredText(100),
  accountNumber: digits(/^\d{6,20}$/, "Số tài khoản gồm 6–20 chữ số."),
  accountHolder: z
    .string()
    .max(100)
    .transform(normalizeAccountHolder)
    .pipe(z.string().regex(/^[A-Z0-9 .,&()-]{2,100}$/, "Tên chủ tài khoản viết hoa, không dấu.")),
  /** Lý do đổi: 3–500 ký tự (Figma 1667:27586), lưu vào audit. */
  reason: z.string().trim().min(3).max(500),
});
export type BankChangeInput = z.infer<typeof BankChangeInputSchema>;
/** Body gửi yêu cầu đổi tài khoản nhận tiền — chờ Admin xác minh. */
export class BankChangeInputDto extends createZodDto(BankChangeInputSchema) {}
