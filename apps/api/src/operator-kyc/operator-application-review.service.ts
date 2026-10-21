import { HttpException, Inject, Injectable, Logger } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import type { DbScope } from "../database/db-scope";
import { PrismaService, type DbTransaction } from "../database/prisma.service";
import { type OperatorApplicationDocumentType, OperatorApplicationStatus } from "../database/prisma.types";
import {
  EMAIL_NOTIFIER,
  type EmailNotifier,
  maskEmail,
  type OperatorApplicationDecisionEmailMessage,
} from "../external/notification/email-notifier";
import { PRIVATE_STORAGE, type StorageProvider } from "../external/storage/storage-provider";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { newApplicationToken } from "../iam/role/application-access";
import type { Authorization } from "../iam/role/authorization";
import { AccountProvisioningService } from "../iam/user/account-provisioning.service";
import type { AccountRequestContext } from "../iam/user/account.types";
import type { DocumentDownloadResponse } from "./dto/operator-application.dto";
import type {
  AdminApplicationDetail,
  AdminApplicationListQuery,
  AdminApplicationListResponse,
  ApprovalInput,
  ApprovalResponse,
  DecisionResponse,
  DuplicateField,
} from "./dto/operator-application-review.dto";
import { maskAccountNumber, REVIEWABLE_STATUSES } from "./operator-application-format";
import {
  applicationDocumentNotFound,
  applicationInvalidState,
  applicationNotFound,
  applicationServiceUnavailable,
  operatorSlugConflict,
} from "./operator-application.errors";
import { applicationLink, applicationLinkExpiry, DOCUMENT_URL_TTL_SECONDS } from "./operator-application.service";
import { copyApplicationToOperator } from "./approved-operator-copy";

const AUDIT_TIMEOUT_MS = 2_000;
const AUDIT_TARGET = "operator_application";
const MAX_DUPLICATES = 10;
/** Sự kiện audit của hồ sơ dựng lại lịch sử (người nộp gửi duyệt + quyết định của Admin). */
const HISTORY_ACTIONS = {
  "operator_application.submit": "SUBMITTED",
  "operator_application.request_info": "NEEDS_INFO",
  "operator_application.reject": "REJECTED",
  "operator_application.approve": "APPROVED",
} as const;

type Actor = Pick<VerifiedAccessToken, "sub" | "sid" | "scope" | "role" | "operatorId" | "operatorSlug">;
type IdentityRow = {
  id: string;
  contactEmail: string;
  taxCode: string | null;
  bankAccountNumber: string | null;
};
type DuplicateRow = IdentityRow & { applicationCode: string; operatorName: string; status: OperatorApplicationStatus };
type Duplicates = Record<"contactEmail" | "taxCode" | "bankAccount", DuplicateRow[]>;

/**
 * Admin duyệt hồ sơ đăng ký nhà xe (TASK-ADM-001 phần hồ sơ, UC-23, LLD §6.11 bước 4–5). Chỉ PlatformAdmin
 * (`kyc:review`); scope DB `platform` do `TenantGuard` trao. Duyệt = một transaction tạo Operator + Owner
 * (`provisionOperatorOwner`) và đóng hồ sơ; gửi lặp cùng `Idempotency-Key` trả lại kết quả cũ.
 */
@Injectable()
export class OperatorApplicationReviewService {
  private readonly logger = new Logger(OperatorApplicationReviewService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(PRIVATE_STORAGE) private readonly storage: StorageProvider | null,
    @Inject(EMAIL_NOTIFIER) private readonly email: EmailNotifier,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
    @Inject(AccountProvisioningService) private readonly provisioning: AccountProvisioningService,
  ) {}

  /** Hàng đợi hồ sơ đã gửi duyệt, mới gửi trước, kèm trường trùng với hồ sơ khác (UC-23 bước 1). */
  async list(authz: Authorization, query: AdminApplicationListQuery): Promise<AdminApplicationListResponse> {
    const q = query.q;
    const digits = q?.replace(/[\s.-]/g, "");
    const cursor = query.cursor && {
      submittedAt: new Date(query.cursor.slice(0, query.cursor.indexOf("_"))),
      id: query.cursor.slice(query.cursor.indexOf("_") + 1),
    };
    const { rows, duplicates } = await this.prisma.withScope(platformDb(authz), async (tx) => {
      const flagged = query.duplicatesOnly ? await idsWithDuplicates(tx) : null;
      const found = await tx.operatorApplication.findMany({
        where: {
          status: query.status ? query.status : { in: [...REVIEWABLE_STATUSES] },
          ...(flagged ? { id: { in: flagged } } : {}),
          ...(query.submittedSince ? { submittedAt: { gte: new Date(query.submittedSince) } } : {}),
          AND: [
            q
              ? {
                  OR: [
                    { applicationCode: { contains: q.toUpperCase() } },
                    { operatorName: { contains: q, mode: "insensitive" } },
                    { legalName: { contains: q, mode: "insensitive" } },
                    { contactEmail: { contains: q.toLowerCase() } },
                    ...(digits ? [{ taxCode: { contains: digits } }] : []),
                  ],
                }
              : {},
            // Trang sau: dòng gửi duyệt trước dòng cuối trang trước (cùng thời điểm thì so `id`).
            cursor
              ? { OR: [{ submittedAt: { lt: cursor.submittedAt } }, { submittedAt: cursor.submittedAt, id: { lt: cursor.id } }] }
              : {},
          ],
        },
        orderBy: [{ submittedAt: "desc" }, { id: "desc" }],
        take: query.limit + 1,
        select: {
          id: true,
          applicationCode: true,
          status: true,
          operatorName: true,
          legalName: true,
          taxCode: true,
          contactName: true,
          contactEmail: true,
          bankAccountNumber: true,
          submittedAt: true,
          reviewedAt: true,
        },
      });
      return { rows: found, duplicates: await findDuplicates(tx, found.slice(0, query.limit)) };
    });
    const page = rows.slice(0, query.limit);
    const last = page.at(-1);
    return {
      items: page.map(({ bankAccountNumber: _bankAccountNumber, ...row }) => ({
        ...row,
        submittedAt: row.submittedAt!.toISOString(),
        reviewedAt: row.reviewedAt?.toISOString() ?? null,
        duplicates: duplicateFields(duplicates.get(row.id)!),
      })),
      nextCursor: rows.length > query.limit && last ? `${last.submittedAt!.toISOString()}_${last.id}` : null,
    };
  }

  /** Chi tiết hồ sơ: thông tin, giấy tờ (chỉ metadata), trùng định danh, nhà xe đã tạo, lịch sử (UC-23 bước 2). */
  async get(authz: Authorization, applicationId: string): Promise<AdminApplicationDetail> {
    const found = await this.prisma.withScope(platformDb(authz), async (tx) => {
      const row = await tx.operatorApplication.findUnique({
        where: { id: applicationId },
        select: {
          id: true,
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
          createdAt: true,
          submittedAt: true,
          reviewedAt: true,
          operatorId: true,
          documents: {
            select: { type: true, fileName: true, contentType: true, sizeBytes: true, uploadedAt: true },
            orderBy: { type: "asc" },
          },
        },
      });
      if (!row || row.status === OperatorApplicationStatus.DRAFT) {
        // Nháp chưa gửi duyệt không thuộc phạm vi Admin xem.
        return null;
      }
      const duplicates = (await findDuplicates(tx, [row])).get(row.id)!;
      const operator = row.operatorId ? await ownerOf(tx, row.operatorId) : null;
      return { row, duplicates, operator };
    });
    if (!found) {
      throw applicationNotFound();
    }
    const { row, duplicates, operator } = found;
    const { bankAccountNumber, operatorId: _operatorId, ...rest } = row;
    return {
      ...rest,
      bankAccountNumberMasked: maskAccountNumber(bankAccountNumber),
      contactEmailVerifiedAt: row.contactEmailVerifiedAt?.toISOString() ?? null,
      documents: row.documents.map((document) => ({ ...document, uploadedAt: document.uploadedAt.toISOString() })),
      createdAt: row.createdAt.toISOString(),
      submittedAt: row.submittedAt?.toISOString() ?? null,
      reviewedAt: row.reviewedAt?.toISOString() ?? null,
      duplicates: {
        contactEmail: duplicates.contactEmail.slice(0, MAX_DUPLICATES).map(publicDuplicate),
        taxCode: duplicates.taxCode.slice(0, MAX_DUPLICATES).map(publicDuplicate),
        bankAccount: duplicates.bankAccount.slice(0, MAX_DUPLICATES).map(publicDuplicate),
      },
      operator,
      history: await this.history(row),
    };
  }

  /** URL xem một giấy tờ, hạn 5 phút; mỗi lần cấp ghi audit kèm Admin xem (UC-23 bước 2, ADR-018). */
  async createDocumentDownload(
    authz: Authorization,
    actor: Actor,
    applicationId: string,
    type: OperatorApplicationDocumentType,
  ): Promise<DocumentDownloadResponse> {
    const storage = this.requireStorage();
    const document = await this.prisma.withScope(platformDb(authz), (tx) =>
      tx.operatorApplicationDocument.findFirst({
        where: { applicationId, type, application: { status: { in: [...REVIEWABLE_STATUSES] } } },
        select: { id: true, objectKey: true, fileName: true },
      }),
    );
    if (!document) {
      throw applicationDocumentNotFound();
    }
    await this.recordAudit(actor, {
      action: "operator_application.document.view",
      targetId: applicationId,
      after: { documentId: document.id, type, viewer: "platform" },
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
   * Duyệt (UC-23 bước 4–6): tạo Operator `ACTIVE` + Owner mật khẩu tạm, đóng hồ sơ `APPROVED`, thu hồi mọi link,
   * audit — một transaction. Gửi lặp cùng khóa → trả lại kết quả cũ; khác khóa → 409. Email mật khẩu tạm lỗi sau
   * commit → vẫn trả thành công kèm `credentialDeliveryPending` để Admin gửi lại (UC-23 A4).
   */
  async approve(
    authz: Authorization,
    actor: Actor,
    applicationId: string,
    input: ApprovalInput,
    idempotencyKey: string,
    context: AccountRequestContext,
  ): Promise<ApprovalResponse> {
    const db = platformDb(authz);
    const current = await this.prisma.withScope(db, async (tx) => {
      const application = await tx.operatorApplication.findUnique({
        where: { id: applicationId },
        select: {
          status: true,
          applicationCode: true,
          operatorName: true,
          displayName: true,
          contactEmail: true,
          approvalIdempotencyKey: true,
        },
      });
      const slugTaken = await tx.operatorProfile.findUnique({
        where: { operatorSlug: input.operatorSlug },
        select: { id: true },
      });
      return application && { ...application, slugTaken: slugTaken !== null };
    });
    if (!current || current.status === OperatorApplicationStatus.DRAFT) {
      throw applicationNotFound();
    }
    if (current.status === OperatorApplicationStatus.APPROVED) {
      return this.replayOrConflict(db, applicationId, idempotencyKey);
    }
    if (current.status !== OperatorApplicationStatus.SUBMITTED) {
      throw applicationInvalidState();
    }
    if (current.slugTaken) {
      throw operatorSlugConflict();
    }

    try {
      await this.provisioning.provisionOperatorOwner(
        actor,
        authz,
        {
          operatorSlug: input.operatorSlug,
          displayName: current.displayName ?? current.operatorName,
          ownerUsername: input.ownerUsername,
          contactEmail: current.contactEmail,
          reason: `Duyệt hồ sơ đăng ký ${current.applicationCode}`,
        },
        context,
        {
          inTransaction: async (tx, created) => {
            // Khóa dòng hồ sơ: hai lần duyệt đồng thời (khác slug) xếp hàng, lần sau thấy đã APPROVED → rollback.
            if ((await lockStatus(tx, applicationId)) !== OperatorApplicationStatus.SUBMITTED) {
              throw applicationInvalidState();
            }
            const now = new Date();
            await tx.operatorApplication.update({
              where: { id: applicationId },
              data: {
                status: OperatorApplicationStatus.APPROVED,
                operatorId: created.operatorId,
                approvalIdempotencyKey: idempotencyKey,
                reviewedAt: now,
                reviewedBy: actor.sub,
              },
            });
            await tx.operatorApplicationAccessToken.updateMany({
              where: { applicationId, revokedAt: null },
              data: { revokedAt: now },
            });
            await copyApplicationToOperator(tx, applicationId, created.operatorId, actor.sub, now);
            await this.recordAudit(actor, {
              action: "operator_application.approve",
              targetId: applicationId,
              before: { status: OperatorApplicationStatus.SUBMITTED },
              after: {
                status: OperatorApplicationStatus.APPROVED,
                operatorId: created.operatorId,
                operatorSlug: input.operatorSlug,
                ownerAccountId: created.ownerAccountId,
              },
            });
          },
        },
      );
    } catch (error) {
      // Hồ sơ đã APPROVED bằng chính khóa này: lần gửi song song đã thắng, hoặc lỗi xảy ra SAU commit (email).
      const approved = await this.approvalResult(db, applicationId, idempotencyKey);
      if (approved) {
        return approved;
      }
      if (codeOf(error) === "ACCOUNT_USERNAME_CONFLICT") {
        // Slug vừa bị nhà xe khác lấy giữa lúc kiểm và lúc tạo (unique `operator_slug`).
        throw (await this.isApproved(db, applicationId)) ? applicationInvalidState() : operatorSlugConflict();
      }
      throw error;
    }
    const approved = await this.approvalResult(db, applicationId, idempotencyKey);
    if (!approved) {
      throw new Error("Hồ sơ vừa duyệt không đọc lại được.");
    }
    return approved;
  }

  /** Yêu cầu bổ sung (UC-23 bước 3, UC-10 A4): `NEEDS_INFO` + lý do + link mới (link cũ hết hiệu lực). */
  async requestInfo(authz: Authorization, actor: Actor, applicationId: string, reason: string): Promise<DecisionResponse> {
    const now = new Date();
    const { token, tokenHash } = newApplicationToken();
    const expiresAt = applicationLinkExpiry(this.config, now);
    const application = await this.decide(authz, actor, applicationId, reason, now, {
      status: OperatorApplicationStatus.NEEDS_INFO,
      action: "operator_application.request_info",
      onDecided: (tx) => tx.operatorApplicationAccessToken.create({ data: { applicationId, tokenHash, expiresAt } }),
    });
    const emailDelivered = await this.sendDecision({
      ...application,
      decision: OperatorApplicationStatus.NEEDS_INFO,
      reason,
      link: applicationLink(this.config, token),
      expiresAt,
    });
    return { applicationCode: application.applicationCode, status: OperatorApplicationStatus.NEEDS_INFO, emailDelivered };
  }

  /** Từ chối (UC-23 bước 3, UC-10 A5): `REJECTED` + lý do, mọi link hết hiệu lực; muốn tham gia lại phải nộp mới. */
  async reject(authz: Authorization, actor: Actor, applicationId: string, reason: string): Promise<DecisionResponse> {
    const application = await this.decide(authz, actor, applicationId, reason, new Date(), {
      status: OperatorApplicationStatus.REJECTED,
      action: "operator_application.reject",
    });
    const emailDelivered = await this.sendDecision({
      ...application,
      decision: OperatorApplicationStatus.REJECTED,
      reason,
    });
    return { applicationCode: application.applicationCode, status: OperatorApplicationStatus.REJECTED, emailDelivered };
  }

  /** Gửi lại mật khẩu tạm cho chủ nhà xe khi lần gửi lúc duyệt lỗi (UC-23 A4), theo hạn mức IAM-005. */
  async resendOwnerCredentials(
    authz: Authorization,
    actor: Actor,
    applicationId: string,
    context: AccountRequestContext,
  ): Promise<ApprovalResponse> {
    const db = platformDb(authz);
    const application = await this.prisma.withScope(db, (tx) =>
      tx.operatorApplication.findUnique({
        where: { id: applicationId },
        select: { status: true, applicationCode: true, approvalIdempotencyKey: true, operatorId: true },
      }),
    );
    if (!application || application.status === OperatorApplicationStatus.DRAFT) {
      throw applicationNotFound();
    }
    if (application.status !== OperatorApplicationStatus.APPROVED) {
      throw applicationInvalidState();
    }
    const owner = await this.prisma.withScope(db, (tx) => ownerOf(tx, application.operatorId!));
    await this.provisioning.retryOwnerDelivery(
      actor,
      authz,
      {
        operatorSlug: owner.operatorSlug,
        ownerUsername: owner.ownerUsername,
        reason: `Gửi lại thông tin đăng nhập cho hồ sơ ${application.applicationCode}`,
      },
      context,
    );
    return (await this.approvalResult(db, applicationId, application.approvalIdempotencyKey!))!;
  }

  /** Chuyển hồ sơ `SUBMITTED` sang quyết định của Admin + thu hồi mọi link + audit, một transaction. */
  private decide(
    authz: Authorization,
    actor: Actor,
    applicationId: string,
    reason: string,
    now: Date,
    decision: {
      status: "NEEDS_INFO" | "REJECTED";
      action: string;
      onDecided?: (tx: DbTransaction) => Promise<unknown>;
    },
  ): Promise<{ applicationCode: string; operatorName: string; email: string }> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const status = await lockStatus(tx, applicationId);
      if (status === null || status === OperatorApplicationStatus.DRAFT) {
        throw applicationNotFound();
      }
      if (status !== OperatorApplicationStatus.SUBMITTED) {
        throw applicationInvalidState();
      }
      const application = await tx.operatorApplication.update({
        where: { id: applicationId },
        data: { status: decision.status, reviewNote: reason, reviewedAt: now, reviewedBy: actor.sub },
        select: { applicationCode: true, operatorName: true, contactEmail: true },
      });
      await tx.operatorApplicationAccessToken.updateMany({
        where: { applicationId, revokedAt: null },
        data: { revokedAt: now },
      });
      await decision.onDecided?.(tx);
      await this.recordAudit(actor, {
        action: decision.action,
        targetId: applicationId,
        reason,
        before: { status },
        after: { status: decision.status, reviewNote: reason },
      });
      return {
        applicationCode: application.applicationCode,
        operatorName: application.operatorName,
        email: application.contactEmail,
      };
    });
  }

  /** Hồ sơ đã duyệt bằng đúng khóa → kết quả lần duyệt đó; khóa khác → 409 (mỗi hồ sơ một Operator). */
  private async replayOrConflict(db: DbScope, applicationId: string, idempotencyKey: string): Promise<ApprovalResponse> {
    const approved = await this.approvalResult(db, applicationId, idempotencyKey);
    if (!approved) {
      throw applicationInvalidState();
    }
    return approved;
  }

  private async approvalResult(
    db: DbScope,
    applicationId: string,
    idempotencyKey: string,
  ): Promise<ApprovalResponse | null> {
    return this.prisma.withScope(db, async (tx) => {
      const application = await tx.operatorApplication.findUnique({
        where: { id: applicationId },
        select: { applicationCode: true, status: true, approvalIdempotencyKey: true, operatorId: true },
      });
      if (
        application?.status !== OperatorApplicationStatus.APPROVED ||
        application.approvalIdempotencyKey !== idempotencyKey
      ) {
        return null;
      }
      return {
        applicationCode: application.applicationCode,
        status: OperatorApplicationStatus.APPROVED,
        ...(await ownerOf(tx, application.operatorId!)),
      };
    });
  }

  private async isApproved(db: DbScope, applicationId: string): Promise<boolean> {
    const application = await this.prisma.withScope(db, (tx) =>
      tx.operatorApplication.findUnique({ where: { id: applicationId }, select: { status: true } }),
    );
    return application?.status === OperatorApplicationStatus.APPROVED;
  }

  /** Mốc tạo / xác minh email lấy từ hồ sơ, các mốc gửi duyệt và quyết định lấy từ audit. Audit lỗi → `null`. */
  private async history(row: {
    id: string;
    createdAt: Date;
    contactEmailVerifiedAt: Date | null;
  }): Promise<AdminApplicationDetail["history"]> {
    try {
      const events = await this.audit.listAuditEvents({
        targetType: AUDIT_TARGET,
        targetId: row.id,
        operatorId: null,
        actions: Object.keys(HISTORY_ACTIONS),
        limit: 50,
      });
      const history: NonNullable<AdminApplicationDetail["history"]> = events.map((event) => ({
        event: HISTORY_ACTIONS[event.action as keyof typeof HISTORY_ACTIONS],
        at: event.createdAt.toISOString(),
        note: typeof event.after?.reviewNote === "string" ? event.after.reviewNote : null,
      }));
      if (row.contactEmailVerifiedAt) {
        history.push({ event: "EMAIL_VERIFIED", at: row.contactEmailVerifiedAt.toISOString(), note: null });
      }
      history.push({ event: "CREATED", at: row.createdAt.toISOString(), note: null });
      return history;
    } catch (error) {
      this.logger.warn({ event: "operator_application.history_unavailable", error });
      return null;
    }
  }

  /** Báo người nộp (NTF-15); lỗi không hoàn tác quyết định — trả `false` để màn Admin báo. */
  private async sendDecision(message: OperatorApplicationDecisionEmailMessage): Promise<boolean> {
    try {
      if (!this.email.sendOperatorApplicationDecision) {
        throw new Error("Email adapter does not support application decisions.");
      }
      await this.email.sendOperatorApplicationDecision(message);
      return true;
    } catch (error) {
      this.logger.warn({
        event: "operator_application.decision.delivery_failed",
        decision: message.decision,
        email: maskEmail(message.email),
        error,
      });
      return false;
    }
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

  private recordAudit(
    actor: Actor,
    input: {
      action: string;
      targetId: string;
      reason?: string;
      before?: Record<string, unknown>;
      after: Record<string, unknown>;
    },
  ): Promise<void> {
    // Hồ sơ chưa thuộc tenant nào: không gắn `operatorId` (lịch sử hồ sơ đọc sự kiện cấp Platform).
    return this.audit
      .recordAuditEvent(
        { actorId: actor.sub, actorRole: actor.role, targetType: AUDIT_TARGET, before: null, ...input },
        { timeoutMs: AUDIT_TIMEOUT_MS },
      )
      .catch((error: unknown) => {
        throw error instanceof AuditWriteError ? applicationServiceUnavailable() : error;
      });
  }
}

function platformDb(authz: Authorization): DbScope {
  if (authz.db?.kind !== "platform") {
    // Lỗi lập trình: route Admin thiếu `@Authorize` với quyền phạm vi `any`.
    throw new Error("Route duyệt hồ sơ cần ngữ cảnh DB platform.");
  }
  return authz.db;
}

/** Khóa dòng hồ sơ, trả trạng thái; `null` = không có hồ sơ. */
async function lockStatus(tx: DbTransaction, applicationId: string): Promise<OperatorApplicationStatus | null> {
  const rows = await tx.$queryRaw<{ status: OperatorApplicationStatus }[]>`
    SELECT status FROM operator_applications WHERE id = ${applicationId} FOR NO KEY UPDATE`;
  return rows[0]?.status ?? null;
}

/** Chủ nhà xe đầu tiên của Operator tạo từ hồ sơ. */
async function ownerOf(
  tx: DbTransaction,
  operatorId: string,
): Promise<{ operatorId: string; operatorSlug: string; ownerUsername: string; credentialDeliveryPending: boolean }> {
  const owner = await tx.operatorAccount.findFirstOrThrow({
    where: { operatorId, role: "OPERATOR_OWNER" },
    orderBy: { createdAt: "asc" },
    select: { operatorSlug: true, username: true, credentialDeliveryPending: true },
  });
  return {
    operatorId,
    operatorSlug: owner.operatorSlug,
    ownerUsername: owner.username,
    credentialDeliveryPending: owner.credentialDeliveryPending,
  };
}

/** Hồ sơ KHÁC trùng email liên hệ / mã số thuế / số tài khoản nhận tiền với từng hồ sơ trong `rows` (UC-10 A2). */
async function findDuplicates(tx: DbTransaction, rows: IdentityRow[]): Promise<Map<string, Duplicates>> {
  const select = {
    id: true,
    applicationCode: true,
    operatorName: true,
    status: true,
    contactEmail: true,
    taxCode: true,
    bankAccountNumber: true,
  } as const;
  const values = <K extends "taxCode" | "bankAccountNumber">(key: K) =>
    [...new Set(rows.map((row) => row[key]).filter((value): value is string => value !== null))];
  const [byEmail, byTaxCode, byBankAccount] = await Promise.all([
    tx.operatorApplication.findMany({ where: { contactEmail: { in: [...new Set(rows.map((row) => row.contactEmail))] } }, select }),
    tx.operatorApplication.findMany({ where: { taxCode: { in: values("taxCode") } }, select }),
    tx.operatorApplication.findMany({ where: { bankAccountNumber: { in: values("bankAccountNumber") } }, select }),
  ]);
  const others = (found: DuplicateRow[], row: IdentityRow, key: keyof IdentityRow) =>
    row[key] === null ? [] : found.filter((other) => other.id !== row.id && other[key] === row[key]);
  return new Map(
    rows.map((row) => [
      row.id,
      {
        contactEmail: others(byEmail, row, "contactEmail"),
        taxCode: others(byTaxCode, row, "taxCode"),
        bankAccount: others(byBankAccount, row, "bankAccountNumber"),
      },
    ]),
  );
}

/** Hồ sơ (đã gửi duyệt) có ít nhất một trường định danh trùng hồ sơ khác — cho bộ lọc "Có cảnh báo". */
async function idsWithDuplicates(tx: DbTransaction): Promise<string[]> {
  const rows = await tx.$queryRaw<{ id: string }[]>`
    SELECT a.id FROM operator_applications a
    WHERE a.status <> 'DRAFT' AND EXISTS (
      SELECT 1 FROM operator_applications b
      WHERE b.id <> a.id
        AND (b.contact_email = a.contact_email
          OR b.tax_code = a.tax_code
          OR b.bank_account_number = a.bank_account_number))`;
  return rows.map((row) => row.id);
}

function duplicateFields(duplicates: Duplicates): DuplicateField[] {
  return [
    ...(duplicates.contactEmail.length > 0 ? (["CONTACT_EMAIL"] as const) : []),
    ...(duplicates.taxCode.length > 0 ? (["TAX_CODE"] as const) : []),
    ...(duplicates.bankAccount.length > 0 ? (["BANK_ACCOUNT"] as const) : []),
  ];
}

function publicDuplicate(row: DuplicateRow) {
  return { id: row.id, applicationCode: row.applicationCode, operatorName: row.operatorName, status: row.status };
}

function codeOf(error: unknown): string | undefined {
  if (error instanceof HttpException) {
    const response = error.getResponse();
    return typeof response === "object" && response !== null ? (response as { code?: string }).code : undefined;
  }
  return undefined;
}
