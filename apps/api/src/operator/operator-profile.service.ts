import { randomUUID } from "node:crypto";
import { HttpException, Inject, Injectable, Logger } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import { BankAccountStatus, type OperatorApplicationDocumentType } from "../database/prisma.types";
import { PRIVATE_STORAGE, type StorageProvider } from "../external/storage/storage-provider";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { requireTenant } from "../iam/role/require-tenant";
import { isPrismaUniqueConflict } from "../iam/user/account.errors";
import {
  detectDocumentType,
  DOCUMENT_SIGNATURE_BYTES,
  type DocumentContentType,
  maskAccountNumber,
  MAX_DOCUMENT_BYTES,
} from "../operator-kyc/operator-application-format";
import type {
  BankChangeInput,
  KycDownloadResponse,
  KycReplaceInput,
  KycUploadInput,
  KycUploadResponse,
  OperatorProfileResponse,
  ProfileUpdateInput,
} from "./dto/operator-profile.dto";
import { contentTypeOfKycKey, KYC_DOCUMENT_ROOT, kycDocumentKey } from "./kyc-document-format";
import {
  bankChangePending,
  bankChangeUnchanged,
  kycDocumentInvalid,
  kycDocumentNotFound,
  operatorProfileUnavailable,
} from "./operator-profile.errors";

type Actor = Pick<VerifiedAccessToken, "sub" | "role">;

/** URL tải lên / xem giấy tờ hạn 5 phút (ADR-018). */
export const KYC_URL_TTL_SECONDS = 300;
/** Giấy tờ tải lên quá lâu mà chưa gắn thì không gắn được — nhỏ hơn tuổi tối thiểu (24 giờ) của job dọn. */
export const KYC_ATTACHABLE_MAX_AGE_MS = 23 * 3_600_000;
const AUDIT_TIMEOUT_MS = 2_000;

/**
 * Hồ sơ nhà xe phía Operator OS (TASK-OPR-001b, UC-11 bước 1–4, FR-OPR-02..05; Figma 1667:27240): xem / sửa thông
 * tin công khai, xem / thay giấy tờ KYC (kho private, URL 5 phút, audit mỗi lần xem), gửi yêu cầu đổi tài khoản nhận
 * tiền chờ Admin xác minh (BR-37). Chỉ chủ nhà xe (`kyc:submit` phạm vi tenant); mọi truy vấn lọc `operatorId` và chạy
 * trong scope tenant (RLS).
 */
@Injectable()
export class OperatorProfileService {
  private readonly logger = new Logger(OperatorProfileService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(PRIVATE_STORAGE) private readonly storage: StorageProvider | null,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  async get(authz: Authorization): Promise<OperatorProfileResponse> {
    const { db, operatorId } = requireTenant(authz);
    return this.prisma.withScope(db, (tx) => loadProfile(tx, operatorId));
  }

  /** Sửa thông tin công khai; audit ghi trường đổi (trước / sau) trong cùng transaction. */
  async update(authz: Authorization, actor: Actor, input: ProfileUpdateInput): Promise<OperatorProfileResponse> {
    const { db, operatorId } = requireTenant(authz);
    return this.write(db, async (tx, deadline) => {
      const before = await tx.operatorProfile.findUniqueOrThrow({
        where: { id: operatorId },
        select: { displayName: true, hotline: true, publicEmail: true, address: true, description: true },
      });
      const changed = (Object.keys(input) as (keyof ProfileUpdateInput)[]).filter((key) => before[key] !== input[key]);
      if (changed.length > 0) {
        await tx.operatorProfile.update({ where: { id: operatorId }, data: input });
        await this.audit.recordAuditEvent(
          {
            actorId: actor.sub,
            actorRole: actor.role,
            action: "operator.profile.update",
            targetType: "operator",
            targetId: operatorId,
            operatorId,
            before: Object.fromEntries(changed.map((key) => [key, before[key]])),
            after: Object.fromEntries(changed.map((key) => [key, input[key]])),
          },
          { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
        );
      }
      return loadProfile(tx, operatorId);
    });
  }

  /** Cấp URL để trình duyệt tải thẳng một giấy tờ lên kho riêng tư; khóa do server sinh dưới tiền tố nhà xe. */
  async createDocumentUpload(authz: Authorization, input: KycUploadInput): Promise<KycUploadResponse> {
    const { operatorId } = requireTenant(authz);
    const storage = this.requireStorage();
    const objectKey = kycDocumentKey(operatorId, randomUUID(), input.contentType);
    const target = await this.callStorage(() =>
      storage.createUploadUrl({
        key: objectKey,
        contentType: input.contentType,
        sizeBytes: input.sizeBytes,
        expiresInSeconds: KYC_URL_TTL_SECONDS,
      }),
    );
    return { uploadUrl: target.uploadUrl, objectKey, expiresAt: target.expiresAt.toISOString() };
  }

  /**
   * Thay một giấy tờ bằng bản vừa tải lên (FR-OPR-03). Kiểm object trước transaction (gọi kho là gọi mạng); bản cũ
   * do nhà xe tự tải lên bị xóa sau commit — bản chép từ hồ sơ đăng ký vẫn thuộc hồ sơ đó nên giữ nguyên.
   */
  async replaceDocument(
    authz: Authorization,
    actor: Actor,
    type: OperatorApplicationDocumentType,
    input: KycReplaceInput,
  ): Promise<OperatorProfileResponse> {
    const { db, operatorId } = requireTenant(authz);
    const contentType = contentTypeOfKycKey(operatorId, input.objectKey);
    if (!contentType) {
      throw this.invalidDocument("foreign_key", input.objectKey);
    }
    const file = await this.inspect(input.objectKey, contentType);
    const { profile, previousKey } = await this.write(db, async (tx, deadline) => {
      const previous = await tx.kycDocument.findUnique({
        where: { operatorId_type: { operatorId, type } },
        select: { objectKey: true, fileName: true, uploadedAt: true },
      });
      if (previous?.objectKey === input.objectKey) {
        throw this.invalidDocument("same_key", input.objectKey);
      }
      const data = { objectKey: input.objectKey, fileName: input.fileName, ...file, uploadedAt: new Date(), uploadedBy: actor.sub };
      await tx.kycDocument.upsert({
        where: { operatorId_type: { operatorId, type } },
        create: { operatorId, type, ...data },
        update: data,
      });
      await this.audit.recordAuditEvent(
        {
          actorId: actor.sub,
          actorRole: actor.role,
          action: "operator.kyc_document.replace",
          targetType: "operator",
          targetId: operatorId,
          operatorId,
          before: previous ? { type, fileName: previous.fileName, uploadedAt: previous.uploadedAt.toISOString() } : null,
          after: { type, fileName: input.fileName, sizeBytes: file.sizeBytes },
        },
        { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
      );
      return { profile: await loadProfile(tx, operatorId), previousKey: previous?.objectKey ?? null };
    }).catch((error: unknown) => {
      // Cùng một object gắn cho hai loại giấy tờ → vi phạm unique `object_key`.
      throw isPrismaUniqueConflict(error) ? this.invalidDocument("reused_key", input.objectKey) : error;
    });
    if (previousKey?.startsWith(KYC_DOCUMENT_ROOT)) {
      await this.storage?.delete(previousKey).catch((error: unknown) => {
        this.logger.warn({ event: "operator.kyc_document.delete_failed", key: previousKey, error });
      });
    }
    return profile;
  }

  /** URL xem một giấy tờ, hạn 5 phút; mỗi lần cấp ghi audit (ADR-018, Security §9). */
  async createDocumentDownload(
    authz: Authorization,
    actor: Actor,
    type: OperatorApplicationDocumentType,
  ): Promise<KycDownloadResponse> {
    const { db, operatorId } = requireTenant(authz);
    const storage = this.requireStorage();
    const document = await this.prisma.withScope(db, (tx) =>
      tx.kycDocument.findFirst({ where: { operatorId, type }, select: { id: true, objectKey: true, fileName: true } }),
    );
    if (!document) {
      throw kycDocumentNotFound();
    }
    await this.audit
      .recordAuditEvent(
        {
          actorId: actor.sub,
          actorRole: actor.role,
          action: "operator.kyc_document.view",
          targetType: "operator",
          targetId: operatorId,
          operatorId,
          before: null,
          after: { documentId: document.id, type },
        },
        { timeoutMs: AUDIT_TIMEOUT_MS },
      )
      .catch((error: unknown) => {
        throw error instanceof AuditWriteError ? operatorProfileUnavailable() : error;
      });
    const target = await this.callStorage(() =>
      storage.createDownloadUrl({ key: document.objectKey, expiresInSeconds: KYC_URL_TTL_SECONDS, fileName: document.fileName }),
    );
    return { url: target.url, expiresAt: target.expiresAt.toISOString() };
  }

  /**
   * Gửi yêu cầu đổi tài khoản nhận tiền (UC-11 bước 3–4, BR-37): đã xác nhận lại danh tính (guard), tạo bản `PENDING`
   * chờ Admin xác minh; tài khoản cũ vẫn dùng để chi trả tới khi được duyệt. Mỗi nhà xe tối đa một yêu cầu đang chờ
   * (unique index một phần) → 409.
   */
  async requestBankChange(authz: Authorization, actor: Actor, input: BankChangeInput): Promise<OperatorProfileResponse> {
    const { db, operatorId } = requireTenant(authz);
    return this.write(db, async (tx, deadline) => {
      const current = await tx.bankAccount.findFirst({
        where: { operatorId, status: BankAccountStatus.VERIFIED },
        select: { bankName: true, accountNumber: true },
      });
      if (current && current.bankName === input.bankName && current.accountNumber === input.accountNumber) {
        throw bankChangeUnchanged();
      }
      if (await tx.bankAccount.count({ where: { operatorId, status: BankAccountStatus.PENDING } })) {
        throw bankChangePending();
      }
      const created = await tx.bankAccount.create({
        data: {
          operatorId,
          bankName: input.bankName,
          accountNumber: input.accountNumber,
          accountHolder: input.accountHolder,
          status: BankAccountStatus.PENDING,
          changeReason: input.reason,
          requestedBy: actor.sub,
        },
        select: { id: true },
      });
      await this.audit.recordAuditEvent(
        {
          actorId: actor.sub,
          actorRole: actor.role,
          action: "operator.bank_account.request",
          targetType: "operator",
          targetId: operatorId,
          operatorId,
          before: current ? { bankName: current.bankName, accountNumber: maskAccountNumber(current.accountNumber) } : null,
          after: {
            changeId: created.id,
            bankName: input.bankName,
            accountNumber: maskAccountNumber(input.accountNumber),
            accountHolder: input.accountHolder,
          },
          reason: input.reason,
        },
        { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
      );
      return loadProfile(tx, operatorId);
    }).catch((error: unknown) => {
      // Hai lần gửi đồng thời: lần sau đụng unique index "một yêu cầu đang chờ".
      throw isPrismaUniqueConflict(error) ? bankChangePending() : error;
    });
  }

  /** Kiểm một giấy tờ vừa tải lên: tồn tại, đủ mới, đúng dung lượng, đúng loại và đúng chữ ký định dạng. */
  private async inspect(objectKey: string, expected: DocumentContentType): Promise<{ sizeBytes: number; contentType: DocumentContentType }> {
    const storage = this.requireStorage();
    const object = await this.callStorage(() => storage.head(objectKey));
    if (!object) {
      throw this.invalidDocument("missing", objectKey);
    }
    if (Date.now() - object.lastModified.getTime() > KYC_ATTACHABLE_MAX_AGE_MS) {
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

  /** Lý do cụ thể chỉ ghi log; người dùng nhận một thông báo chung. */
  private invalidDocument(reason: string, objectKey: string): HttpException {
    this.logger.warn({ event: "operator.kyc_document.invalid", reason, objectKey });
    return kycDocumentInvalid();
  }

  private requireStorage(): StorageProvider {
    // Production chưa có kho riêng tư cho KYC (OQ-21) → 503.
    if (!this.storage) {
      throw operatorProfileUnavailable();
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
      this.logger.error({ event: "operator.kyc_document.storage_failed", error });
      throw operatorProfileUnavailable();
    }
  }

  private async write<T>(
    db: Parameters<PrismaService["withScope"]>[0],
    work: (tx: DbTransaction, deadline: number) => Promise<T>,
  ): Promise<T> {
    try {
      return await this.prisma.withScope(db, (tx) => work(tx, transactionDeadline(Date.now())));
    } catch (error) {
      if (error instanceof AuditWriteError || (error as { code?: unknown } | null)?.code === "P2028") {
        throw operatorProfileUnavailable();
      }
      throw error;
    }
  }
}

async function loadProfile(tx: DbTransaction, operatorId: string): Promise<OperatorProfileResponse> {
  const row = await tx.operatorProfile.findUniqueOrThrow({
    where: { id: operatorId },
    select: {
      id: true,
      operatorSlug: true,
      displayName: true,
      legalName: true,
      taxCode: true,
      hotline: true,
      publicEmail: true,
      address: true,
      description: true,
      status: true,
      suspendedReason: true,
      approvedAt: true,
      kycDocuments: {
        select: { type: true, fileName: true, contentType: true, sizeBytes: true, uploadedAt: true },
        orderBy: { type: "asc" },
      },
      bankAccounts: {
        where: { status: { not: BankAccountStatus.REPLACED } },
        orderBy: [{ createdAt: "desc" }, { id: "desc" }],
        select: {
          status: true,
          bankName: true,
          accountNumber: true,
          accountHolder: true,
          changeReason: true,
          reviewNote: true,
          reviewedAt: true,
          createdAt: true,
        },
      },
    },
  });
  const verified = row.bankAccounts.find((account) => account.status === BankAccountStatus.VERIFIED);
  // Yêu cầu gần nhất (mới tạo trước): còn chờ, hoặc bị từ chối mà chưa có yêu cầu / tài khoản nào mới hơn.
  const latest = row.bankAccounts[0];
  const change = latest && latest.status !== BankAccountStatus.VERIFIED ? latest : null;
  return {
    id: row.id,
    slug: row.operatorSlug,
    displayName: row.displayName,
    legalName: row.legalName,
    taxCode: row.taxCode,
    hotline: row.hotline,
    publicEmail: row.publicEmail,
    address: row.address,
    description: row.description,
    status: row.status,
    suspendedReason: row.suspendedReason,
    approvedAt: row.approvedAt?.toISOString() ?? null,
    documents: row.kycDocuments.map((document) => ({ ...document, uploadedAt: document.uploadedAt.toISOString() })),
    bankAccount: verified
      ? {
          bankName: verified.bankName,
          accountNumberMasked: maskAccountNumber(verified.accountNumber)!,
          accountHolder: verified.accountHolder,
          verifiedAt: verified.reviewedAt?.toISOString() ?? null,
        }
      : null,
    bankChange: change
      ? {
          status: change.status === BankAccountStatus.PENDING ? "PENDING" : "REJECTED",
          bankName: change.bankName,
          accountNumberMasked: maskAccountNumber(change.accountNumber)!,
          accountHolder: change.accountHolder,
          reason: change.changeReason,
          reviewNote: change.reviewNote,
          requestedAt: change.createdAt.toISOString(),
          reviewedAt: change.reviewedAt?.toISOString() ?? null,
        }
      : null,
  };
}
