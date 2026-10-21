import { randomUUID } from "node:crypto";
import { HttpException, Inject, Injectable, Logger } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { APP_CONFIG, type AppConfig, LOCAL_OPERATOR_WEB_ORIGIN } from "../config/env.config";
import type { DbScope } from "../database/db-scope";
import { PrismaService, type DbTransaction } from "../database/prisma.service";
import { type OperatorApplicationDocumentType, OperatorApplicationStatus } from "../database/prisma.types";
import { EMAIL_NOTIFIER, type EmailNotifier, maskEmail } from "../external/notification/email-notifier";
import { PRIVATE_STORAGE, type StorageProvider } from "../external/storage/storage-provider";
import { newApplicationToken, type Applicant } from "../iam/role/application-access";
import type { Authorization } from "../iam/role/authorization";
import { isPrismaUniqueConflict } from "../iam/user/account.errors";
import type {
  ApplicationAccessLinkInput,
  ApplicationCreateInput,
  ApplicationResponse,
  ApplicationUpdateInput,
  DocumentDownloadResponse,
  DocumentUploadInput,
  DocumentUploadResponse,
} from "./dto/operator-application.dto";
import {
  contentTypeOfDocumentKey,
  detectDocumentType,
  DOCUMENT_SIGNATURE_BYTES,
  documentKey,
  EDITABLE_STATUSES,
  maskAccountNumber,
  MAX_DOCUMENT_BYTES,
  missingItems,
  newApplicationCode,
  OPEN_STATUSES,
  type DocumentContentType,
} from "./operator-application-format";
import { OperatorApplicationRateLimiter } from "./operator-application-rate-limiter";
import {
  applicationDocumentInvalid,
  applicationDocumentNotFound,
  applicationIncomplete,
  applicationInvalidState,
  applicationServiceUnavailable,
} from "./operator-application.errors";

/** URL tải lên / xem giấy tờ có hạn 5 phút (ADR-018). */
export const DOCUMENT_URL_TTL_SECONDS = 300;
/** Giấy tờ tải lên quá lâu mà chưa gắn thì không gắn được nữa — phải nhỏ hơn tuổi tối thiểu của job dọn. */
export const ATTACHABLE_MAX_AGE_MS = 23 * 3_600_000;
const AUDIT_TIMEOUT_MS = 2_000;
const AUDIT_TARGET = "operator_application";

const APPLICATION_SELECT = {
  applicationCode: true,
  status: true,
  operatorName: true,
  contactName: true,
  contactEmail: true,
  contactEmailVerifiedAt: true,
  legalName: true,
  taxCode: true,
  hotline: true,
  address: true,
  displayName: true,
  description: true,
  bankName: true,
  bankAccountNumber: true,
  bankAccountHolder: true,
  reviewNote: true,
  submittedAt: true,
  createdAt: true,
  updatedAt: true,
  documents: {
    select: { type: true, objectKey: true, fileName: true, contentType: true, sizeBytes: true, uploadedAt: true },
    orderBy: { type: "asc" },
  },
} as const;

type ApplicationRow = {
  applicationCode: string;
  status: OperatorApplicationStatus;
  operatorName: string;
  contactName: string;
  contactEmail: string;
  contactEmailVerifiedAt: Date | null;
  legalName: string | null;
  taxCode: string | null;
  hotline: string | null;
  address: string | null;
  displayName: string | null;
  description: string | null;
  bankName: string | null;
  bankAccountNumber: string | null;
  bankAccountHolder: string | null;
  reviewNote: string | null;
  submittedAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
  documents: {
    type: OperatorApplicationDocumentType;
    objectKey: string;
    fileName: string;
    contentType: string;
    sizeBytes: number;
    uploadedAt: Date;
  }[];
};

type Inspected = { sizeBytes: number; contentType: DocumentContentType };

/**
 * Hồ sơ đăng ký nhà xe phía người nộp (TASK-OPR-001, UC-10, BR-75, LLD §6.11). Người nộp chưa có tài khoản: mọi
 * thao tác đi qua link bảo mật, hồ sơ xác định bằng token (`Applicant`), không bao giờ bằng id trong body / URL.
 * Scope DB do guard của `iam/role` trao (`authz.db`).
 */
@Injectable()
export class OperatorApplicationService {
  private readonly logger = new Logger(OperatorApplicationService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(PRIVATE_STORAGE) private readonly storage: StorageProvider | null,
    @Inject(EMAIL_NOTIFIER) private readonly email: EmailNotifier,
    @Inject(OperatorApplicationRateLimiter) private readonly limiter: OperatorApplicationRateLimiter,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
  ) {}

  /**
   * Tạo hồ sơ nháp + link bảo mật rồi gửi link tới email liên hệ (UC-10 bước 1–2). Luôn tạo hồ sơ mới, không tra
   * email đã có hồ sơ khác hay chưa → phản hồi giống nhau, không lộ gì (Security §11).
   */
  async create(authz: Authorization, input: ApplicationCreateInput, clientIp: string | undefined): Promise<void> {
    await this.limiter.assertPublicRequest("create", input.contactEmail, clientIp);
    const now = new Date();
    const { token, tokenHash } = newApplicationToken();
    const expiresAt = this.linkExpiry(now);
    const code = await this.withUniqueCode(now, (applicationCode) =>
      this.prisma.withScope(dbOf(authz), async (tx) => {
        const application = await tx.operatorApplication.create({
          data: {
            applicationCode,
            operatorName: input.operatorName,
            contactName: input.contactName,
            contactEmail: input.contactEmail,
            termsAcceptedAt: now,
            // Tên hiển thị gợi ý sẵn bằng tên nhà xe; người nộp sửa ở bước hoàn thiện hồ sơ.
            displayName: input.operatorName,
          },
          select: { id: true },
        });
        await tx.operatorApplicationAccessToken.create({
          data: { applicationId: application.id, tokenHash, expiresAt },
        });
        return applicationCode;
      }),
    );
    this.sendLink(input.contactEmail, code, input.operatorName, token, expiresAt);
  }

  /**
   * Gửi lại link cho đúng cặp email + mã hồ sơ chưa có kết quả; link cũ hết hiệu lực (FR-OPR-12). Không khớp thì
   * không làm gì nhưng vẫn trả như khớp — không lộ email / mã có tồn tại không.
   */
  async requestAccessLink(
    authz: Authorization,
    input: ApplicationAccessLinkInput,
    clientIp: string | undefined,
  ): Promise<void> {
    await this.limiter.assertPublicRequest("access-link", input.contactEmail, clientIp);
    const now = new Date();
    const { token, tokenHash } = newApplicationToken();
    const expiresAt = this.linkExpiry(now);
    const application = await this.prisma.withScope(dbOf(authz), async (tx) => {
      const found = await tx.operatorApplication.findFirst({
        where: {
          applicationCode: input.applicationCode,
          contactEmail: input.contactEmail,
          status: { in: [...OPEN_STATUSES] },
        },
        select: { id: true, operatorName: true },
      });
      if (!found) {
        return null;
      }
      await tx.operatorApplicationAccessToken.updateMany({
        where: { applicationId: found.id, revokedAt: null },
        data: { revokedAt: now },
      });
      await tx.operatorApplicationAccessToken.create({ data: { applicationId: found.id, tokenHash, expiresAt } });
      return found;
    });
    if (application) {
      this.sendLink(input.contactEmail, input.applicationCode, application.operatorName, token, expiresAt);
    }
  }

  /** Hồ sơ của link đang mở (UC-10 bước 3, 8). */
  async get(authz: Authorization, applicant: Applicant): Promise<ApplicationResponse> {
    const row = await this.prisma.withScope(dbOf(authz), (tx) => findApplication(tx, applicant.applicationId));
    return toResponse(row, applicant);
  }

  /**
   * Lưu nháp (UC-10 bước 4–5): thông tin doanh nghiệp, thông tin công khai, tài khoản nhận tiền và bộ giấy tờ (thay
   * toàn bộ). Chỉ khi `DRAFT` / `NEEDS_INFO`. Giấy tờ mới phải là object đã tải lên hợp lệ dưới tiền tố của chính hồ
   * sơ này; giấy tờ bị thay / bỏ được xóa khỏi kho sau commit.
   */
  async update(authz: Authorization, applicant: Applicant, input: ApplicationUpdateInput): Promise<ApplicationResponse> {
    const { applicationId } = applicant;
    const types = new Map<string, DocumentContentType>();
    for (const document of input.documents) {
      const type = contentTypeOfDocumentKey(applicationId, document.objectKey);
      if (!type) {
        throw this.invalidDocument("foreign_key", document.objectKey);
      }
      types.set(document.objectKey, type);
    }
    const before = await this.prisma.withScope(dbOf(authz), (tx) => findApplication(tx, applicationId));
    assertEditable(before.status);
    const known = new Set(before.documents.map((document) => document.objectKey));
    const fresh = input.documents.filter((document) => !known.has(document.objectKey));
    if (fresh.length > 0 && !this.storage) {
      throw applicationServiceUnavailable();
    }
    // Kiểm object mới TRƯỚC transaction: gọi kho là gọi mạng, không giữ khóa dòng hồ sơ trong lúc đó.
    const inspected = new Map<string, Inspected>();
    await Promise.all(
      fresh.map(async (document) => {
        inspected.set(document.objectKey, await this.inspect(document.objectKey, types.get(document.objectKey)!));
      }),
    );

    const { row, removed } = await this.prisma.withScope(dbOf(authz), async (tx) => {
      const current = await lockApplication(tx, applicationId);
      assertEditable(current.status);
      const currentDocuments = await tx.operatorApplicationDocument.findMany({
        where: { applicationId },
        select: { id: true, type: true, objectKey: true },
      });
      const byKey = new Map(currentDocuments.map((document) => [document.objectKey, document]));
      for (const document of input.documents) {
        if (!byKey.has(document.objectKey) && !inspected.has(document.objectKey)) {
          // Giấy tờ "đang có" lúc đọc trước đã bị lần lưu khác thay mất.
          throw this.invalidDocument("removed_concurrently", document.objectKey);
        }
      }
      const keep = new Set(input.documents.map((document) => document.objectKey));
      const gone = currentDocuments.filter((document) => !keep.has(document.objectKey));
      await tx.operatorApplicationDocument.deleteMany({ where: { id: { in: gone.map((document) => document.id) } } });
      for (const document of input.documents) {
        const kept = byKey.get(document.objectKey);
        if (kept) {
          // Giữ file; chỉ đổi được tên hiển thị. Loại giấy tờ gắn với object — đổi loại là tải lại.
          if (kept.type !== document.type) {
            throw this.invalidDocument("type_changed", document.objectKey);
          }
          await tx.operatorApplicationDocument.update({
            where: { id: kept.id },
            data: { fileName: document.fileName },
          });
        } else {
          const file = inspected.get(document.objectKey)!;
          await tx.operatorApplicationDocument.create({
            data: {
              applicationId,
              type: document.type,
              objectKey: document.objectKey,
              fileName: document.fileName,
              contentType: file.contentType,
              sizeBytes: file.sizeBytes,
            },
          });
        }
      }
      await tx.operatorApplication.update({
        where: { id: applicationId },
        data: {
          legalName: input.legalName,
          taxCode: input.taxCode,
          hotline: input.hotline,
          address: input.address,
          displayName: input.displayName,
          description: input.description,
          bankName: input.bankName,
          // `undefined` = giữ số đã lưu (Prisma bỏ qua trường undefined).
          bankAccountNumber: input.bankAccountNumber,
          bankAccountHolder: input.bankAccountHolder,
        },
      });
      return { row: await findApplication(tx, applicationId), removed: gone.map((document) => document.objectKey) };
    });

    await this.deleteObjects(removed);
    return toResponse(row, applicant);
  }

  /** Cấp URL để trình duyệt tải thẳng một giấy tờ lên kho riêng tư (LLD §6.11 bước 3). */
  async createDocumentUpload(
    authz: Authorization,
    applicant: Applicant,
    input: DocumentUploadInput,
  ): Promise<DocumentUploadResponse> {
    const storage = this.requireStorage();
    const status = await this.prisma.withScope(dbOf(authz), async (tx) => {
      const application = await tx.operatorApplication.findUniqueOrThrow({
        where: { id: applicant.applicationId },
        select: { status: true },
      });
      return application.status;
    });
    assertEditable(status);
    await this.limiter.assertDocumentUpload(applicant.applicationId);
    const objectKey = documentKey(applicant.applicationId, randomUUID(), input.contentType);
    const target = await this.callStorage(() =>
      storage.createUploadUrl({
        key: objectKey,
        contentType: input.contentType,
        sizeBytes: input.sizeBytes,
        expiresInSeconds: DOCUMENT_URL_TTL_SECONDS,
      }),
    );
    return { uploadUrl: target.uploadUrl, objectKey, expiresAt: target.expiresAt.toISOString() };
  }

  /** URL xem một giấy tờ của hồ sơ, hạn 5 phút; mỗi lần cấp ghi audit (ADR-018, Security §9). */
  async createDocumentDownload(
    authz: Authorization,
    applicant: Applicant,
    type: OperatorApplicationDocumentType,
  ): Promise<DocumentDownloadResponse> {
    const storage = this.requireStorage();
    const document = await this.prisma.withScope(dbOf(authz), (tx) =>
      tx.operatorApplicationDocument.findUnique({
        where: { applicationId_type: { applicationId: applicant.applicationId, type } },
        select: { id: true, objectKey: true, fileName: true },
      }),
    );
    if (!document) {
      throw applicationDocumentNotFound();
    }
    await this.recordAudit({
      action: "operator_application.document.view",
      targetId: applicant.applicationId,
      after: { documentId: document.id, type, viewer: "applicant" },
    });
    const target = await this.callStorage(() =>
      storage.createDownloadUrl({
        key: document.objectKey,
        expiresInSeconds: DOCUMENT_URL_TTL_SECONDS,
        fileName: document.fileName,
      }),
    );
    return { url: target.url, expiresAt: target.expiresAt.toISOString() };
  }

  /**
   * Gửi duyệt (UC-10 bước 6–7): đủ thông tin + giấy tờ + tài khoản nhận tiền, email đã xác minh → `SUBMITTED`.
   * Thiếu → 422 kèm MỌI mục còn thiếu. Chuyển trạng thái và audit trong cùng transaction.
   */
  async submit(authz: Authorization, applicant: Applicant): Promise<ApplicationResponse> {
    const { applicationId } = applicant;
    const row = await this.prisma.withScope(dbOf(authz), async (tx) => {
      const current = await lockApplication(tx, applicationId);
      assertEditable(current.status);
      const application = await findApplication(tx, applicationId);
      const missing = missingItems(application);
      if (missing.length > 0) {
        throw applicationIncomplete(missing);
      }
      if (!application.contactEmailVerifiedAt) {
        // Không xảy ra qua link (guard xác minh ở lần mở đầu); chặn phòng ghi thẳng DB.
        throw applicationInvalidState();
      }
      const submittedAt = new Date();
      await tx.operatorApplication.update({
        where: { id: applicationId },
        data: { status: OperatorApplicationStatus.SUBMITTED, submittedAt },
      });
      await this.recordAudit({
        action: "operator_application.submit",
        targetId: applicationId,
        before: { status: current.status },
        after: { status: OperatorApplicationStatus.SUBMITTED, submittedAt: submittedAt.toISOString() },
      });
      return findApplication(tx, applicationId);
    });
    return toResponse(row, applicant);
  }

  private linkExpiry(now: Date): Date {
    return applicationLinkExpiry(this.config, now);
  }

  /** Mã hồ sơ ngẫu nhiên; trùng (rất hiếm) thì sinh lại. */
  private async withUniqueCode<T>(now: Date, work: (code: string) => Promise<T>): Promise<T> {
    for (let attempt = 1; ; attempt += 1) {
      try {
        return await work(newApplicationCode(now));
      } catch (error) {
        if (attempt >= 5 || !isPrismaUniqueConflict(error)) {
          throw error;
        }
      }
    }
  }

  /**
   * Gửi email SAU commit và không chờ: phản hồi của API giống nhau dù gửi được hay không, không lộ gì qua thời gian
   * phản hồi. Gửi lỗi thì người nộp dùng "Gửi lại link".
   */
  private sendLink(email: string, applicationCode: string, operatorName: string, token: string, expiresAt: Date): void {
    const link = applicationLink(this.config, token);
    const send = this.email.sendOperatorApplicationLink?.({ email, applicationCode, operatorName, link, expiresAt });
    void (send ?? Promise.reject(new Error("Email adapter does not support application links."))).catch(
      (error: unknown) => {
        this.logger.warn({ event: "operator_application.link.delivery_failed", email: maskEmail(email), error });
      },
    );
  }

  /** Kiểm một giấy tờ vừa tải lên: tồn tại, đủ mới, đúng dung lượng, đúng loại và đúng chữ ký định dạng. */
  private async inspect(objectKey: string, expected: DocumentContentType): Promise<Inspected> {
    const storage = this.requireStorage();
    const object = await this.callStorage(() => storage.head(objectKey));
    if (!object) {
      throw this.invalidDocument("missing", objectKey);
    }
    if (Date.now() - object.lastModified.getTime() > ATTACHABLE_MAX_AGE_MS) {
      throw this.invalidDocument("stale", objectKey);
    }
    if (object.sizeBytes < 1 || object.sizeBytes > MAX_DOCUMENT_BYTES) {
      throw this.invalidDocument("size", objectKey);
    }
    if (object.contentType !== expected) {
      throw this.invalidDocument("content_type", objectKey);
    }
    const start = await this.callStorage(() => storage.readStart(objectKey, DOCUMENT_SIGNATURE_BYTES));
    if (detectDocumentType(start) !== expected) {
      throw this.invalidDocument("signature", objectKey);
    }
    return { sizeBytes: object.sizeBytes, contentType: expected };
  }

  /** Lý do cụ thể chỉ ghi log; người dùng nhận một thông báo chung (LLD §7). */
  private invalidDocument(reason: string, objectKey: string): HttpException {
    this.logger.warn({ event: "operator_application.document.invalid", reason, objectKey });
    return applicationDocumentInvalid();
  }

  private requireStorage(): StorageProvider {
    if (!this.storage) {
      throw applicationServiceUnavailable();
    }
    return this.storage;
  }

  private async callStorage<T>(work: () => Promise<T>): Promise<T> {
    try {
      return await work();
    } catch (error) {
      if (error instanceof HttpException) {
        throw error;
      }
      this.logger.error({ event: "operator_application.storage_failed", error });
      throw applicationServiceUnavailable();
    }
  }

  private async deleteObjects(keys: string[]): Promise<void> {
    const storage = this.storage;
    if (!storage) {
      return;
    }
    await Promise.all(
      keys.map((key) =>
        storage.delete(key).catch((error: unknown) => {
          this.logger.warn({ event: "operator_application.document.delete_failed", key, error });
        }),
      ),
    );
  }

  private recordAudit(input: {
    action: string;
    targetId: string;
    before?: Record<string, unknown>;
    after: Record<string, unknown>;
  }): Promise<void> {
    // Người nộp hồ sơ chưa có tài khoản: không có `actorId`, vai trò ghi `APPLICANT`.
    return this.audit.recordAuditEvent(
      { actorRole: "APPLICANT", targetType: AUDIT_TARGET, before: null, ...input },
      { timeoutMs: AUDIT_TIMEOUT_MS },
    ).catch((error: unknown) => {
      throw error instanceof AuditWriteError ? applicationServiceUnavailable() : error;
    });
  }
}

/** Hạn của link bảo mật mới cấp. */
export function applicationLinkExpiry(config: AppConfig, now: Date): Date {
  return new Date(now.getTime() + config.OPERATOR_APPLICATION_LINK_TTL_HOURS * 3_600_000);
}

/** Link mở hồ sơ ở Operator OS. */
export function applicationLink(config: AppConfig, token: string): string {
  const origin = (config.OPERATOR_WEB_ORIGINS ?? [LOCAL_OPERATOR_WEB_ORIGIN])[0]!;
  // Token đặt sau `#`: trình duyệt không gửi phần này lên máy chủ web, không lọt vào log / Referer.
  return `${origin}/register/application#token=${token}`;
}

function dbOf(authz: Authorization): DbScope {
  if (!authz.db) {
    // Lỗi lập trình: route thiếu guard của luồng đăng ký.
    throw new Error("Route hồ sơ đăng ký thiếu ngữ cảnh DB từ guard.");
  }
  return authz.db;
}

function assertEditable(status: OperatorApplicationStatus): void {
  if (!EDITABLE_STATUSES.has(status)) {
    throw applicationInvalidState();
  }
}

/** Khóa dòng hồ sơ: hai lần lưu / gửi duyệt đồng thời xếp hàng, không trộn hai bộ giấy tờ. */
async function lockApplication(tx: DbTransaction, applicationId: string): Promise<{ status: OperatorApplicationStatus }> {
  const rows = await tx.$queryRaw<{ status: OperatorApplicationStatus }[]>`
    SELECT status FROM operator_applications WHERE id = ${applicationId} FOR NO KEY UPDATE`;
  if (rows.length === 0) {
    throw new Error("Hồ sơ của link không còn tồn tại.");
  }
  return rows[0]!;
}

function findApplication(tx: DbTransaction, applicationId: string): Promise<ApplicationRow> {
  return tx.operatorApplication.findUniqueOrThrow({ where: { id: applicationId }, select: APPLICATION_SELECT });
}

function toResponse(row: ApplicationRow, applicant: Applicant): ApplicationResponse {
  const { bankAccountNumber, documents, ...rest } = row;
  return {
    ...rest,
    bankAccountNumberMasked: maskAccountNumber(bankAccountNumber),
    contactEmailVerifiedAt: row.contactEmailVerifiedAt?.toISOString() ?? null,
    documents: documents.map((document) => ({ ...document, uploadedAt: document.uploadedAt.toISOString() })),
    missing: missingItems(row),
    submittedAt: row.submittedAt?.toISOString() ?? null,
    createdAt: row.createdAt.toISOString(),
    updatedAt: row.updatedAt.toISOString(),
    linkExpiresAt: applicant.linkExpiresAt.toISOString(),
  };
}
