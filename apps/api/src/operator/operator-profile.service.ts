import { randomUUID } from "node:crypto";
import { HttpException, Inject, Injectable, Logger } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import { BankAccountStatus, type OperatorApplicationDocumentType } from "../database/prisma.types";
import { PRIVATE_STORAGE, PUBLIC_STORAGE, type StorageProvider } from "../external/storage/storage-provider";
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
import { detectImageType, IMAGE_SIGNATURE_BYTES } from "../vehicle/vehicle-image-format";
import type {
  BankChangeInput,
  KycDownloadResponse,
  KycReplaceInput,
  KycUploadInput,
  KycUploadResponse,
  LogoAttachInput,
  LogoUploadInput,
  LogoUploadResponse,
  OperatorProfileResponse,
  ProfileUpdateInput,
} from "./dto/operator-profile.dto";
import { contentTypeOfKycKey, KYC_DOCUMENT_ROOT, kycDocumentKey } from "./kyc-document-format";
import {
  contentTypeOfLogoKey,
  MAX_OPERATOR_LOGO_BYTES,
  type OperatorLogoContentType,
  operatorLogoKey,
} from "./operator-logo-format";
import {
  bankChangePending,
  bankChangeUnchanged,
  kycDocumentInvalid,
  kycDocumentNotFound,
  operatorLogoInvalid,
  operatorProfileUnavailable,
} from "./operator-profile.errors";

type Actor = Pick<VerifiedAccessToken, "sub" | "role">;

/** URL tải lên / xem giấy tờ hạn 5 phút (ADR-018). */
export const KYC_URL_TTL_SECONDS = 300;
/** Giấy tờ tải lên quá lâu mà chưa gắn thì không gắn được — nhỏ hơn tuổi tối thiểu (24 giờ) của job dọn. */
export const KYC_ATTACHABLE_MAX_AGE_MS = 23 * 3_600_000;
/** Logo tải lên quá lâu mà chưa gắn thì không gắn được (cùng mốc với giấy tờ, ảnh xe). */
export const LOGO_ATTACHABLE_MAX_AGE_MS = 23 * 3_600_000;
const AUDIT_TIMEOUT_MS = 2_000;

/**
 * Hồ sơ nhà xe phía Operator OS (TASK-OPR-001b, UC-11 bước 1–4, FR-OPR-02..05; Figma 1667:27240): xem / sửa thông
 * tin công khai, đổi / gỡ logo (kho công khai), xem / thay giấy tờ KYC (kho private, URL 5 phút, audit mỗi lần xem),
 * gửi yêu cầu đổi tài khoản nhận tiền chờ Admin xác minh (BR-37). Chỉ chủ nhà xe (`kyc:submit` phạm vi tenant); mọi
 * truy vấn lọc `operatorId` và chạy trong scope tenant (RLS).
 */
@Injectable()
export class OperatorProfileService {
  private readonly logger = new Logger(OperatorProfileService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(PRIVATE_STORAGE) private readonly storage: StorageProvider | null,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(PUBLIC_STORAGE) private readonly publicStorage: StorageProvider,
  ) {}

  async get(authz: Authorization): Promise<OperatorProfileResponse> {
    const { db, operatorId } = requireTenant(authz);
    return this.prisma.withScope(db, (tx) => loadProfile(tx, operatorId, this.publicStorage));
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
      return loadProfile(tx, operatorId, this.publicStorage);
    });
  }

  /** Cấp URL để trình duyệt tải thẳng logo lên kho công khai; khóa do server sinh dưới tiền tố nhà xe. */
  async createLogoUpload(authz: Authorization, input: LogoUploadInput): Promise<LogoUploadResponse> {
    const { operatorId } = requireTenant(authz);
    const objectKey = operatorLogoKey(operatorId, randomUUID(), input.contentType);
    const target = await this.callStorage(
      () =>
        this.publicStorage.createUploadUrl({
          key: objectKey,
          contentType: input.contentType,
          sizeBytes: input.sizeBytes,
          expiresInSeconds: KYC_URL_TTL_SECONDS,
        }),
      "operator.logo.storage_failed",
    );
    return { uploadUrl: target.uploadUrl, objectKey, expiresAt: target.expiresAt.toISOString() };
  }

  /**
   * Gắn logo vừa tải lên (FR-OPR-02). Kiểm object trước transaction (gọi kho là gọi mạng); khóa dòng hồ sơ để hai lần
   * đổi / gỡ logo đồng thời xếp hàng — lần sau thấy logo của lần trước và xóa đúng object đó. Gửi lại đúng logo đang
   * dùng thì không đổi gì. Logo cũ bị xóa khỏi kho sau commit; lỗi xóa chỉ ghi log.
   */
  async setLogo(authz: Authorization, actor: Actor, input: LogoAttachInput): Promise<OperatorProfileResponse> {
    const { db, operatorId } = requireTenant(authz);
    const contentType = contentTypeOfLogoKey(operatorId, input.objectKey);
    if (!contentType) {
      throw this.invalidLogo("foreign_key", input.objectKey);
    }
    const file = await this.inspectLogo(input.objectKey, contentType);
    const { profile, previousKey } = await this.write(db, async (tx, deadline) => {
      const previous = await lockLogo(tx, operatorId);
      if (previous === input.objectKey) {
        return { profile: await loadProfile(tx, operatorId, this.publicStorage), previousKey: null };
      }
      await tx.operatorProfile.update({ where: { id: operatorId }, data: { logoObjectKey: input.objectKey } });
      await this.audit.recordAuditEvent(
        {
          actorId: actor.sub,
          actorRole: actor.role,
          action: "operator.logo.update",
          targetType: "operator",
          targetId: operatorId,
          operatorId,
          before: previous ? { logoObjectKey: previous } : null,
          after: { logoObjectKey: input.objectKey, ...file },
        },
        { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
      );
      return { profile: await loadProfile(tx, operatorId, this.publicStorage), previousKey: previous };
    }).catch((error: unknown) => {
      // Cùng một object đã là logo của dòng khác → vi phạm unique `logo_object_key`.
      throw isPrismaUniqueConflict(error) ? this.invalidLogo("reused_key", input.objectKey) : error;
    });
    if (previousKey) {
      await this.deleteLogoObject(previousKey);
    }
    return profile;
  }

  /** Gỡ logo (trang nhà xe quay về chữ viết tắt). Chưa có logo thì không đổi gì. Object bị xóa khỏi kho sau commit. */
  async removeLogo(authz: Authorization, actor: Actor): Promise<OperatorProfileResponse> {
    const { db, operatorId } = requireTenant(authz);
    const { profile, previousKey } = await this.write(db, async (tx, deadline) => {
      const previous = await lockLogo(tx, operatorId);
      if (previous) {
        await tx.operatorProfile.update({ where: { id: operatorId }, data: { logoObjectKey: null } });
        await this.audit.recordAuditEvent(
          {
            actorId: actor.sub,
            actorRole: actor.role,
            action: "operator.logo.remove",
            targetType: "operator",
            targetId: operatorId,
            operatorId,
            before: { logoObjectKey: previous },
            after: null,
          },
          { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
        );
      }
      return { profile: await loadProfile(tx, operatorId, this.publicStorage), previousKey: previous };
    });
    if (previousKey) {
      await this.deleteLogoObject(previousKey);
    }
    return profile;
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
      return { profile: await loadProfile(tx, operatorId, this.publicStorage), previousKey: previous?.objectKey ?? null };
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
      return loadProfile(tx, operatorId, this.publicStorage);
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

  /** Kiểm một logo vừa tải lên: tồn tại, đủ mới, đúng dung lượng, đúng loại và đúng chữ ký định dạng ảnh. */
  private async inspectLogo(
    objectKey: string,
    expected: OperatorLogoContentType,
  ): Promise<{ sizeBytes: number; contentType: OperatorLogoContentType }> {
    const event = "operator.logo.storage_failed";
    const object = await this.callStorage(() => this.publicStorage.head(objectKey), event);
    if (!object) {
      throw this.invalidLogo("missing", objectKey);
    }
    if (Date.now() - object.lastModified.getTime() > LOGO_ATTACHABLE_MAX_AGE_MS) {
      throw this.invalidLogo("stale", objectKey);
    }
    if (object.sizeBytes < 1 || object.sizeBytes > MAX_OPERATOR_LOGO_BYTES) {
      throw this.invalidLogo("size", objectKey);
    }
    if (object.contentType !== expected) {
      throw this.invalidLogo("content_type", objectKey);
    }
    const start = await this.callStorage(() => this.publicStorage.readStart(objectKey, IMAGE_SIGNATURE_BYTES), event);
    if (detectImageType(start) !== expected) {
      throw this.invalidLogo("signature", objectKey);
    }
    return { sizeBytes: object.sizeBytes, contentType: expected };
  }

  /** Lý do cụ thể chỉ ghi log; người dùng nhận một thông báo chung. */
  private invalidDocument(reason: string, objectKey: string): HttpException {
    this.logger.warn({ event: "operator.kyc_document.invalid", reason, objectKey });
    return kycDocumentInvalid();
  }

  private invalidLogo(reason: string, objectKey: string): HttpException {
    this.logger.warn({ event: "operator.logo.invalid", reason, objectKey });
    return operatorLogoInvalid();
  }

  /** Logo đã gỡ khỏi hồ sơ: xóa object sau commit; lỗi chỉ ghi log (object mồ côi không lộ gì ngoài ảnh công khai cũ). */
  private async deleteLogoObject(key: string): Promise<void> {
    await this.publicStorage.delete(key).catch((error: unknown) => {
      this.logger.warn({ event: "operator.logo.delete_failed", key, error });
    });
  }

  private requireStorage(): StorageProvider {
    // Production chưa có kho riêng tư cho KYC (OQ-21) → 503.
    if (!this.storage) {
      throw operatorProfileUnavailable();
    }
    return this.storage;
  }

  private async callStorage<T>(work: () => Promise<T>, event = "operator.kyc_document.storage_failed"): Promise<T> {
    try {
      return await work();
    } catch (error) {
      if (error instanceof HttpException) {
        throw error;
      }
      this.logger.error({ event, error });
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

/**
 * Khóa dòng hồ sơ (`FOR NO KEY UPDATE`) rồi đọc logo đang dùng: hai lần đổi / gỡ logo đồng thời xếp hàng. Chạy trong
 * scope tenant — policy `tenant_update_public` cho khóa đúng dòng của nhà xe mình.
 */
async function lockLogo(tx: DbTransaction, operatorId: string): Promise<string | null> {
  const rows = await tx.$queryRaw<{ logo_object_key: string | null }[]>`
    SELECT logo_object_key FROM operator_profiles WHERE id = ${operatorId} FOR NO KEY UPDATE`;
  return rows[0]?.logo_object_key ?? null;
}

async function loadProfile(
  tx: DbTransaction,
  operatorId: string,
  publicStorage: Pick<StorageProvider, "publicUrl">,
): Promise<OperatorProfileResponse> {
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
      logoObjectKey: true,
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
    logoUrl: row.logoObjectKey ? publicStorage.publicUrl(row.logoObjectKey) : null,
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
