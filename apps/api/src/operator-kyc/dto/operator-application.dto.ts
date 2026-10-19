import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { OperatorApplicationDocumentType, OperatorApplicationStatus } from "../../database/prisma.types";
import {
  APPLICATION_CODE_PATTERN,
  DOCUMENT_CONTENT_TYPES,
  MAX_DOCUMENT_BYTES,
} from "../operator-application-format";

const requiredText = (max: number) => z.string().trim().min(1).max(max);

/** Trường nháp: bỏ trống được (`null` / chuỗi rỗng = chưa nhập); đủ hay chưa xét lúc gửi duyệt. */
const draftText = (max: number) =>
  z
    .string()
    .trim()
    .max(max)
    .nullable()
    .transform((value) => value || null);

/** Bỏ khoảng trắng, dấu chấm, gạch trước khi kiểm: người dùng hay gõ `0312 345 678`, `1900.6868`. */
const draftDigits = (pattern: RegExp, message: string) =>
  z
    .string()
    .max(30)
    .nullable()
    .transform((value) => (value ? value.replace(/[\s.-]/g, "") : null) || null)
    .refine((value) => value === null || pattern.test(value), message);

const ContactEmailSchema = z
  .string()
  .trim()
  .max(254)
  .transform((value) => value.toLowerCase())
  .pipe(z.email("Email liên hệ không hợp lệ."));

export const ApplicationCreateInputSchema = z.object({
  operatorName: requiredText(100),
  contactName: requiredText(100),
  contactEmail: ContactEmailSchema,
  /** Đồng ý Điều khoản đối tác và Chính sách bảo mật (Figma đăng ký bước 1). */
  acceptTerms: z.literal(true),
});
export type ApplicationCreateInput = z.infer<typeof ApplicationCreateInputSchema>;
/** Body tạo hồ sơ đăng ký nhà xe. */
export class ApplicationCreateInputDto extends createZodDto(ApplicationCreateInputSchema) {}

export const ApplicationAccessLinkInputSchema = z.object({
  contactEmail: ContactEmailSchema,
  applicationCode: z
    .string()
    .trim()
    .max(20)
    .transform((value) => value.toUpperCase())
    .pipe(z.string().regex(APPLICATION_CODE_PATTERN, "Mã hồ sơ có dạng OA-2026-043152.")),
});
export type ApplicationAccessLinkInput = z.infer<typeof ApplicationAccessLinkInputSchema>;
/** Body xin lại link bảo mật: email liên hệ + mã hồ sơ. */
export class ApplicationAccessLinkInputDto extends createZodDto(ApplicationAccessLinkInputSchema) {}

const DocumentTypeSchema = z.enum(OperatorApplicationDocumentType);

export const ApplicationUpdateInputSchema = z.object({
  legalName: draftText(200),
  /** Mã số thuế 10 số, hoặc 13 số của chi nhánh (`0312345678-001`). */
  taxCode: draftDigits(/^(\d{10}|\d{13})$/, "Mã số thuế gồm 10 hoặc 13 chữ số."),
  hotline: draftDigits(/^\+?\d{8,15}$/, "Hotline gồm 8–15 chữ số."),
  address: draftText(255),
  displayName: draftText(100),
  description: draftText(1000),
  bankName: draftText(100),
  /**
   * Bỏ trường này = giữ số tài khoản đã lưu: `GET` chỉ trả số đã che, client không có số đầy đủ để gửi lại.
   * `null` = xóa.
   */
  bankAccountNumber: draftDigits(/^\d{6,20}$/, "Số tài khoản gồm 6–20 chữ số.").optional(),
  bankAccountHolder: draftText(100),
  /** Bộ giấy tờ mới — thay toàn bộ; mỗi loại tối đa một bản. Giấy tờ giữ lại gửi lại đúng `objectKey` cũ. */
  documents: z
    .array(
      z.object({
        type: DocumentTypeSchema,
        objectKey: z.string().min(1).max(200),
        fileName: requiredText(255),
      }),
    )
    .max(10)
    .refine((documents) => new Set(documents.map((document) => document.type)).size === documents.length, "Giấy tờ bị lặp loại."),
});
export type ApplicationUpdateInput = z.infer<typeof ApplicationUpdateInputSchema>;
/** Body lưu nháp hồ sơ (thông tin doanh nghiệp, thông tin công khai, giấy tờ, tài khoản nhận tiền). */
export class ApplicationUpdateInputDto extends createZodDto(ApplicationUpdateInputSchema) {}

export const DocumentUploadInputSchema = z.object({
  type: DocumentTypeSchema,
  contentType: z.enum(DOCUMENT_CONTENT_TYPES),
  sizeBytes: z.int().min(1).max(MAX_DOCUMENT_BYTES),
  /** Tên file gốc — chỉ để hiển thị, không dùng làm khóa object. */
  fileName: requiredText(255),
});
export type DocumentUploadInput = z.infer<typeof DocumentUploadInputSchema>;
/** Body xin URL tải một giấy tờ lên kho riêng tư. */
export class DocumentUploadInputDto extends createZodDto(DocumentUploadInputSchema) {}

export const DocumentUploadResponseSchema = z.object({
  /** URL để trình duyệt `PUT` thẳng file lên kho, kèm đúng header `Content-Type` đã khai. */
  uploadUrl: z.url(),
  /** Khóa object do server sinh — gửi lại trong `documents` của `PUT …/current` để gắn vào hồ sơ. */
  objectKey: z.string(),
  expiresAt: z.iso.datetime(),
});
export type DocumentUploadResponse = z.infer<typeof DocumentUploadResponseSchema>;
export class DocumentUploadResponseDto extends createZodDto(DocumentUploadResponseSchema) {}

export const DocumentDownloadResponseSchema = z.object({
  /** URL đọc giấy tờ, hạn 5 phút (ADR-018). */
  url: z.url(),
  expiresAt: z.iso.datetime(),
});
export type DocumentDownloadResponse = z.infer<typeof DocumentDownloadResponseSchema>;
export class DocumentDownloadResponseDto extends createZodDto(DocumentDownloadResponseSchema) {}

export const DocumentTypeParamSchema = z.object({ type: DocumentTypeSchema });
export class DocumentTypeParamDto extends createZodDto(DocumentTypeParamSchema) {}

export const ApplicationResponseSchema = z.object({
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
  /** Chỉ 4 số cuối (`•••• 4521`) — số đầy đủ không bao giờ trả lại. */
  bankAccountNumberMasked: z.string().nullable(),
  bankAccountHolder: z.string().nullable(),
  documents: z.array(
    z.object({
      type: DocumentTypeSchema,
      objectKey: z.string(),
      fileName: z.string(),
      contentType: z.string(),
      sizeBytes: z.int(),
      uploadedAt: z.iso.datetime(),
    }),
  ),
  /** Mục còn thiếu để gửi duyệt (mã như `taxCode`, `document:TRANSPORT_LICENSE`); rỗng = đủ. */
  missing: z.array(z.string()),
  /** Nội dung Platform yêu cầu bổ sung (khi `NEEDS_INFO`). */
  reviewNote: z.string().nullable(),
  createdAt: z.iso.datetime(),
  submittedAt: z.iso.datetime().nullable(),
  updatedAt: z.iso.datetime(),
  /** Link đang dùng hết hạn lúc này. */
  linkExpiresAt: z.iso.datetime(),
});
export type ApplicationResponse = z.infer<typeof ApplicationResponseSchema>;
/** Hồ sơ đăng ký nhà xe, nhìn từ phía người nộp. */
export class ApplicationResponseDto extends createZodDto(ApplicationResponseSchema) {}
