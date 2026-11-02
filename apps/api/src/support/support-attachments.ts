import { randomUUID } from "node:crypto";
import { HttpException, Inject, Injectable, Logger } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import type { DbTransaction } from "../database/prisma.service";
import { PRIVATE_STORAGE, type StorageProvider } from "../external/storage/storage-provider";
import {
  DOCUMENT_SIGNATURE_BYTES,
  detectDocumentType,
  MAX_DOCUMENT_BYTES,
  type DocumentContentType,
} from "../operator-kyc/operator-application-format";
import type { AttachmentInput, AttachmentUploadInput, AttachmentUploadResponse, DownloadUrlResponse } from "./dto/support.dto";
import { attachmentInvalid, attachmentNotFound, supportUnavailable } from "./support.errors";

/** Tiền tố của mọi tệp minh chứng khiếu nại / tranh chấp (kho riêng tư, ADR-018). */
export const SUPPORT_ATTACHMENT_ROOT = "support/";
const URL_TTL_SECONDS = 5 * 60;
const AUDIT_TIMEOUT_MS = 2_000;
/** Chỉ gắn tệp vừa tải lên (chống dùng lại object cũ). */
const ATTACHABLE_MAX_AGE_MS = 23 * 3_600_000;
const EXTENSIONS: Record<DocumentContentType, string> = { "application/pdf": "pdf", "image/jpeg": "jpg", "image/png": "png" };
const UUID = "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}";

/**
 * Nơi tải tệp lên: khách của một đơn, nhà xe, hay Vé Xe Nhanh. Khóa object chứa nhà xe + nơi tải → bên này không gắn được tệp
 * bên khác vừa tải (kể cả biết khóa).
 */
export type AttachmentOwner = { operatorId: string; kind: "booking"; bookingId: string } | { operatorId: string; kind: "operator" } | { operatorId: string; kind: "platform" } | { operatorId: string; kind: "employee"; employeeId: string };

export type SavedAttachment = { attachmentId: string; fileName: string; contentType: string; sizeBytes: number };

function scopeSegment(owner: AttachmentOwner): string {
  return owner.kind === "booking" ? `b-${owner.bookingId}` : owner.kind === "employee" ? `e-${owner.employeeId}` : owner.kind;
}

/** Khóa object mới — do server sinh, không chứa tên file gốc. */
export function supportAttachmentKey(owner: AttachmentOwner, id: string, contentType: DocumentContentType): string {
  return `${SUPPORT_ATTACHMENT_ROOT}${owner.operatorId}/${scopeSegment(owner)}/${id}.${EXTENSIONS[contentType]}`;
}

/** Loại file suy từ khóa nếu khóa đúng dạng server sinh cho đúng nơi tải này; khóa lạ → `null`. */
export function contentTypeOfSupportKey(owner: AttachmentOwner, objectKey: string): DocumentContentType | null {
  const prefix = `${SUPPORT_ATTACHMENT_ROOT}${owner.operatorId}/${scopeSegment(owner)}/`;
  if (!objectKey.startsWith(prefix)) {
    return null;
  }
  const match = new RegExp(`^${UUID}\\.(pdf|jpg|png)$`).exec(objectKey.slice(prefix.length));
  const entry = match && Object.entries(EXTENSIONS).find(([, extension]) => extension === match[1]);
  return (entry?.[0] as DocumentContentType | undefined) ?? null;
}

/**
 * Tệp minh chứng của khiếu nại / tranh chấp (FR-NSR-09, FR-DSP-04): trình duyệt tải thẳng lên kho riêng tư bằng URL có hạn, rồi
 * gửi khóa kèm lượt trao đổi; server kiểm tồn tại / dung lượng / loại / chữ ký định dạng trước khi ghi. Xem tệp = URL 5 phút, mỗi
 * lần cấp ghi audit (ADR-018). Production chưa có kho riêng tư (OQ-21) → 503 cho phần tệp; trao đổi chữ vẫn chạy.
 */
@Injectable()
export class SupportAttachmentService {
  private readonly logger = new Logger(SupportAttachmentService.name);

  constructor(
    @Inject(PRIVATE_STORAGE) private readonly storage: StorageProvider | null,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  async createUpload(owner: AttachmentOwner, input: AttachmentUploadInput): Promise<AttachmentUploadResponse> {
    const storage = this.requireStorage();
    const objectKey = supportAttachmentKey(owner, randomUUID(), input.contentType);
    const target = await this.call(() => storage.createUploadUrl({ key: objectKey, contentType: input.contentType, sizeBytes: input.sizeBytes, expiresInSeconds: URL_TTL_SECONDS }));
    return { uploadUrl: target.uploadUrl, objectKey, expiresAt: target.expiresAt.toISOString() };
  }

  /** Kiểm các tệp vừa tải (gọi kho = gọi mạng → làm TRƯỚC transaction). */
  async inspectAll(owner: AttachmentOwner, inputs: AttachmentInput[]): Promise<(AttachmentInput & { contentType: DocumentContentType; sizeBytes: number })[]> {
    if (inputs.length === 0) {
      return [];
    }
    if (new Set(inputs.map((input) => input.objectKey)).size !== inputs.length) {
      throw attachmentInvalid();
    }
    const storage = this.requireStorage();
    const result = [];
    for (const input of inputs) {
      const expected = contentTypeOfSupportKey(owner, input.objectKey);
      if (!expected) {
        throw this.invalid("foreign_key", input.objectKey);
      }
      const object = await this.call(() => storage.head(input.objectKey));
      if (!object) {
        throw this.invalid("missing", input.objectKey);
      }
      if (Date.now() - object.lastModified.getTime() > ATTACHABLE_MAX_AGE_MS) {
        throw this.invalid("stale", input.objectKey);
      }
      if (object.sizeBytes < 1 || object.sizeBytes > MAX_DOCUMENT_BYTES || object.contentType !== expected) {
        throw this.invalid("size_or_type", input.objectKey);
      }
      const start = await this.call(() => storage.readStart(input.objectKey, DOCUMENT_SIGNATURE_BYTES));
      if (detectDocumentType(start) !== expected) {
        throw this.invalid("signature", input.objectKey);
      }
      result.push({ ...input, contentType: expected, sizeBytes: object.sizeBytes });
    }
    return result;
  }

  /** Ghi các tệp đã kiểm cho một lượt trao đổi / sự kiện tranh chấp (trong transaction nghiệp vụ). */
  async save(
    tx: DbTransaction,
    operatorId: string,
    parent: { messageId: string } | { disputeEventId: string },
    files: { objectKey: string; fileName: string; contentType: string; sizeBytes: number }[],
  ): Promise<void> {
    if (files.length > 0) {
      await tx.supportAttachment.createMany({ data: files.map((file) => ({ operatorId, ...parent, ...file })) });
    }
  }

  /** URL xem một tệp, hạn 5 phút; mỗi lần cấp ghi audit — ghi không được thì không cấp. */
  async createDownload(
    attachment: { id: string; objectKey: string; fileName: string; operatorId: string } | null,
    actor: { id: string | null; role: string },
  ): Promise<DownloadUrlResponse> {
    if (!attachment) {
      throw attachmentNotFound();
    }
    const storage = this.requireStorage();
    await this.audit
      .recordAuditEvent(
        {
          ...(actor.id ? { actorId: actor.id } : {}),
          actorRole: actor.role,
          action: "support.attachment.view",
          targetType: "support_attachment",
          targetId: attachment.id,
          operatorId: attachment.operatorId,
          after: { fileName: attachment.fileName },
        },
        { timeoutMs: AUDIT_TIMEOUT_MS },
      )
      .catch((error: unknown) => {
        throw error instanceof AuditWriteError ? supportUnavailable() : error;
      });
    const target = await this.call(() => storage.createDownloadUrl({ key: attachment.objectKey, expiresInSeconds: URL_TTL_SECONDS, fileName: attachment.fileName }));
    return { url: target.url, expiresAt: target.expiresAt.toISOString() };
  }

  private requireStorage(): StorageProvider {
    if (!this.storage) {
      throw supportUnavailable();
    }
    return this.storage;
  }

  private async call<T>(work: () => Promise<T>): Promise<T> {
    try {
      return await work();
    } catch (error) {
      if (error instanceof HttpException) {
        throw error;
      }
      this.logger.error({ event: "support.attachment.storage_failed", error });
      throw supportUnavailable();
    }
  }

  /** Lý do cụ thể chỉ ghi log; người dùng nhận một thông báo chung. */
  private invalid(reason: string, objectKey: string): HttpException {
    this.logger.warn({ event: "support.attachment.invalid", reason, objectKey });
    return attachmentInvalid();
  }
}
