import { randomUUID } from "node:crypto";
import { Inject, Injectable, Logger } from "@nestjs/common";
import { AuditService, type AuditEventInput } from "../../audit/audit.service";
import type { DbScope } from "../../database/db-scope";
import { PrismaService } from "../../database/prisma.service";
import { OperatorRole, SessionRevokeReason, SubjectType } from "../../database/prisma.types";
import { EMAIL_NOTIFIER, type EmailNotifier, maskEmail } from "../../external/notification/email-notifier";
import { reauthRequired } from "../auth/auth.errors";
import { CredentialService } from "../auth/credential.service";
import { MfaService } from "../auth/mfa.service";
import { can } from "../role/access-policy";
import type { Authorization } from "../role/authorization";
import { permissionDenied, tenantScopeViolation } from "../role/authorization.errors";
import type { Permission } from "../role/permissions";
import { SessionService } from "../session/session.service";
import {
  accountNotFound,
  accountStateConflict,
  accountUsernameConflict,
  isPrismaUniqueConflict,
} from "./account.errors";
import { accountGrants, checkPermissionChange, effectiveAssignable } from "./account-permissions";
import { generateTemporaryPassword, TEMPORARY_PASSWORD_TTL_MS } from "./account-provisioning.service";
import type { AccountActor, AccountRequestContext } from "./account.types";
import type { ManagerAccount, ManagerCreate, ManagerList, ManagerUpdate } from "./dto/operator-manager.dto";
import { auditSnapshot } from "./employee-account.service";
import { TemporaryCredentialEmailLimiter } from "./temporary-credential-email-limiter";

const MANAGER_SELECT = {
  id: true,
  username: true,
  contactEmail: true,
  permissions: true,
  status: true,
  passwordChangeRequired: true,
  credentialDeliveryPending: true,
  temporaryPasswordExpiresAt: true,
  version: true,
  createdAt: true,
} as const;

type ManagerRow = {
  id: string;
  username: string;
  contactEmail: string | null;
  permissions: unknown;
  status: "ACTIVE" | "LOCKED" | "DISABLED";
  passwordChangeRequired: boolean;
  credentialDeliveryPending: boolean;
  temporaryPasswordExpiresAt: Date | null;
  version: number;
  createdAt: Date;
};

type Tenant = { db: DbScope; operatorId: string; operatorSlug: string };

/**
 * Tài khoản quản lý dùng Operator OS (TASK-IAM-007, tự thiết kế — chờ duyệt): chủ nhà xe cấp (closed enrollment như
 * nhân viên — UC-16), tick quyền trong trần `OPERATOR_MANAGER`, khóa / mở khóa, cấp lại mật khẩu, đặt lại 2FA. Mọi đổi
 * quyền / trạng thái / mật khẩu tăng `auth_epoch` + thu hồi phiên trước và sau khi ghi (như nhân viên — IAM-005). Chỉ
 * đụng dòng `role = OPERATOR_MANAGER` của đúng tenant: dòng Owner coi như không tồn tại.
 */
@Injectable()
export class OperatorManagerService {
  private readonly logger = new Logger(OperatorManagerService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(CredentialService) private readonly credentials: CredentialService,
    @Inject(EMAIL_NOTIFIER) private readonly email: EmailNotifier,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(SessionService) private readonly sessions: SessionService,
    @Inject(MfaService) private readonly mfa: MfaService,
    @Inject(TemporaryCredentialEmailLimiter) private readonly emailLimiter: TemporaryCredentialEmailLimiter,
  ) {}

  async list(actor: AccountActor, authz: Authorization): Promise<ManagerList> {
    const tenant = this.assertOwner(actor, authz);
    const rows = await this.prisma.withScope(tenant.db, (tx) =>
      tx.operatorAccount.findMany({
        where: { operatorId: tenant.operatorId, role: OperatorRole.OPERATOR_MANAGER },
        orderBy: [{ createdAt: "asc" }, { id: "asc" }],
        select: MANAGER_SELECT,
      }),
    );
    return { items: await this.present(tenant, rows) };
  }

  async create(
    actor: AccountActor,
    authz: Authorization,
    input: ManagerCreate,
    context: AccountRequestContext = {},
  ): Promise<ManagerAccount> {
    const tenant = this.assertOwner(actor, authz);
    await this.assertRecentReauth(actor.sid);
    const permissions = checkPermissionChange(OperatorRole.OPERATOR_MANAGER, input.permissions, [], this.grants(actor));
    const id = randomUUID();
    const audit = { actorId: actor.sub, actorRole: actor.role, targetType: "operator_account", targetId: id, operatorId: tenant.operatorId, reason: input.reason };

    // Ghi ý định TRƯỚC khi tạo (lỗi audit → không tạo gì), như tạo nhân viên.
    await this.audit.recordAuditEvent({
      ...audit,
      action: "iam.operator_manager.create.intent",
      after: auditSnapshot(context, { username: input.username, contactEmail: maskEmail(input.contactEmail), permissions }),
    });
    await this.emailLimiter.reserve({ operatorId: tenant.operatorId, actorType: actor.scope, actorId: actor.sub });

    const temporaryPassword = generateTemporaryPassword();
    const passwordHash = await this.credentials.hash(temporaryPassword);
    const expiresAt = new Date(Date.now() + TEMPORARY_PASSWORD_TTL_MS);
    let created: ManagerRow;
    try {
      created = await this.prisma.withScope(tenant.db, (tx) =>
        tx.operatorAccount.create({
          data: {
            id,
            operatorId: tenant.operatorId,
            operatorSlug: tenant.operatorSlug,
            username: input.username,
            contactEmail: input.contactEmail,
            passwordHash,
            role: OperatorRole.OPERATOR_MANAGER,
            permissions,
            passwordChangeRequired: true,
            credentialDeliveryPending: true,
            temporaryPasswordExpiresAt: expiresAt,
          },
          select: MANAGER_SELECT,
        }),
      );
    } catch (error) {
      if (isPrismaUniqueConflict(error)) {
        throw accountUsernameConflict();
      }
      throw error;
    }

    const delivered = await this.deliver(tenant, created, temporaryPassword, expiresAt);
    this.recordBestEffort({ ...audit, action: delivered ? "iam.operator_manager.create.success" : "iam.operator_manager.create.delivery_failed" });
    const [account] = await this.present(tenant, [{ ...created, credentialDeliveryPending: !delivered }]);
    return account!;
  }

  /** Đổi quyền và / hoặc khóa / mở khóa. Có đổi thì tăng `auth_epoch` + thu hồi phiên — quyền mới có hiệu lực ngay. */
  async update(
    actor: AccountActor,
    authz: Authorization,
    managerId: string,
    input: ManagerUpdate,
    context: AccountRequestContext = {},
  ): Promise<ManagerAccount> {
    const tenant = this.assertOwner(actor, authz);
    await this.assertRecentReauth(actor.sid);
    const current = await this.find(tenant, managerId);
    if (current.status === "DISABLED") {
      throw accountStateConflict();
    }
    const before = effectiveAssignable({ role: OperatorRole.OPERATOR_MANAGER, permissions: current.permissions });
    const permissions =
      input.permissions === undefined
        ? before
        : checkPermissionChange(OperatorRole.OPERATOR_MANAGER, input.permissions, before, this.grants(actor));
    const status = input.status ?? current.status;
    const changed = status !== current.status || !sameList(before, permissions);
    if (!changed) {
      const [account] = await this.present(tenant, [current]);
      return account!;
    }

    const audit = { actorId: actor.sub, actorRole: actor.role, targetType: "operator_account", targetId: managerId, operatorId: tenant.operatorId, reason: input.reason };
    await this.audit.recordAuditEvent({
      ...audit,
      action: "iam.operator_manager.update.intent",
      before: { permissions: before, status: current.status },
      after: auditSnapshot(context, { permissions, status }),
    });
    await this.revoke(managerId, SessionRevokeReason.ADMIN_FORCE);
    const rows = await this.prisma.withScope(tenant.db, (tx) =>
      tx.operatorAccount.updateManyAndReturn({
        where: { id: managerId, operatorId: tenant.operatorId, role: OperatorRole.OPERATOR_MANAGER, version: current.version },
        data: { permissions, status, authEpoch: { increment: 1 }, version: { increment: 1 } },
        select: MANAGER_SELECT,
      }),
    );
    const updated = rows[0];
    if (!updated) {
      throw accountStateConflict();
    }
    // Quét lần hai: phiên sinh trong cửa sổ giữa lần thu hồi đầu và khi ghi xong.
    await this.revoke(managerId, SessionRevokeReason.ADMIN_FORCE);
    this.recordBestEffort({ ...audit, action: "iam.operator_manager.update.success", after: { permissions, status } });
    const [account] = await this.present(tenant, [updated]);
    return account!;
  }

  async resetPassword(actor: AccountActor, authz: Authorization, managerId: string, reason: string, context: AccountRequestContext = {}): Promise<ManagerAccount> {
    return this.rotateCredentials(actor, authz, managerId, reason, false, context);
  }

  /**
   * Đặt lại 2FA: xóa TOTP + mã dự phòng VÀ cấp mật khẩu tạm mới qua email của tài khoản — người chỉ biết mật khẩu cũ
   * không tự đăng ký TOTP mới được (như Admin đặt lại 2FA tài khoản quản trị).
   */
  async resetMfa(actor: AccountActor, authz: Authorization, managerId: string, reason: string, context: AccountRequestContext = {}): Promise<ManagerAccount> {
    return this.rotateCredentials(actor, authz, managerId, reason, true, context);
  }

  private async rotateCredentials(
    actor: AccountActor,
    authz: Authorization,
    managerId: string,
    reason: string,
    resetMfa: boolean,
    context: AccountRequestContext,
  ): Promise<ManagerAccount> {
    const tenant = this.assertOwner(actor, authz);
    await this.assertRecentReauth(actor.sid);
    const current = await this.find(tenant, managerId);
    if (current.status !== "ACTIVE" || !current.contactEmail) {
      // Đang khóa: mở khóa trước; không có email: không có nơi nhận mật khẩu tạm.
      throw accountStateConflict();
    }
    const action = resetMfa ? "iam.operator_manager.mfa_reset" : "iam.operator_manager.password_reset";
    const audit = { actorId: actor.sub, actorRole: actor.role, targetType: "operator_account", targetId: managerId, operatorId: tenant.operatorId, reason };
    await this.audit.recordAuditEvent({
      ...audit,
      action: `${action}.intent`,
      after: auditSnapshot(context, { passwordChangeRequired: true, ...(resetMfa ? { mfaEnabled: false } : {}) }),
    });
    await this.emailLimiter.reserve({ operatorId: tenant.operatorId, actorType: actor.scope, actorId: actor.sub });

    const temporaryPassword = generateTemporaryPassword();
    const passwordHash = await this.credentials.hash(temporaryPassword);
    const expiresAt = new Date(Date.now() + TEMPORARY_PASSWORD_TTL_MS);
    await this.revoke(managerId, SessionRevokeReason.PASSWORD_RESET);
    const rows = await this.prisma.withScope(tenant.db, (tx) =>
      tx.operatorAccount.updateManyAndReturn({
        where: { id: managerId, operatorId: tenant.operatorId, role: OperatorRole.OPERATOR_MANAGER, version: current.version },
        data: {
          passwordHash,
          authEpoch: { increment: 1 },
          version: { increment: 1 },
          passwordChangeRequired: true,
          credentialDeliveryPending: true,
          temporaryPasswordExpiresAt: expiresAt,
        },
        select: MANAGER_SELECT,
      }),
    );
    const updated = rows[0];
    if (!updated) {
      throw accountStateConflict();
    }
    if (resetMfa) {
      await this.mfa.resetForSubject(SubjectType.OPERATOR, managerId);
    }
    await this.revoke(managerId, SessionRevokeReason.PASSWORD_RESET);
    const delivered = await this.deliver(tenant, updated, temporaryPassword, expiresAt);
    this.recordBestEffort({ ...audit, action: delivered ? `${action}.success` : `${action}.delivery_failed` });
    const [account] = await this.present(tenant, [{ ...updated, credentialDeliveryPending: !delivered }]);
    return account!;
  }

  private async find(tenant: Tenant, managerId: string): Promise<ManagerRow> {
    const row = await this.prisma.withScope(tenant.db, (tx) =>
      tx.operatorAccount.findFirst({
        where: { id: managerId, operatorId: tenant.operatorId, role: OperatorRole.OPERATOR_MANAGER },
        select: MANAGER_SELECT,
      }),
    );
    if (!row) {
      throw accountNotFound();
    }
    return row;
  }

  /** Gửi mật khẩu tạm; gửi được thì bỏ cờ chờ giao. Lỗi gửi không hoàn tác — Owner cấp lại để gửi lại. */
  private async deliver(tenant: Tenant, row: ManagerRow, temporaryPassword: string, expiresAt: Date): Promise<boolean> {
    try {
      if (!this.email.sendTemporaryPassword || !row.contactEmail) {
        throw new Error("Temporary password delivery is not configured.");
      }
      await this.email.sendTemporaryPassword({
        email: row.contactEmail,
        temporaryPassword,
        loginIdentifier: `${tenant.operatorSlug}/${row.username}`,
        expiresAt,
      });
    } catch (error) {
      this.logger.warn({ event: "iam.operator_manager.delivery_failed", accountId: row.id, error });
      return false;
    }
    await this.prisma.withScope(tenant.db, (tx) =>
      tx.operatorAccount.updateMany({
        where: { id: row.id, operatorId: tenant.operatorId, credentialDeliveryPending: true },
        data: { credentialDeliveryPending: false },
      }),
    );
    return true;
  }

  private async present(tenant: Tenant, rows: ManagerRow[]): Promise<ManagerAccount[]> {
    const ids = rows.map((row) => row.id);
    const [mfa, lastLogin] = await Promise.all([
      this.mfa.enabledSubjects(SubjectType.OPERATOR, ids),
      this.sessions.lastLoginAt(SubjectType.OPERATOR, ids),
    ]);
    return rows.map((row) => ({
      id: row.id,
      username: `${tenant.operatorSlug}/${row.username}`,
      contactEmail: row.contactEmail,
      permissions: effectiveAssignable({ role: OperatorRole.OPERATOR_MANAGER, permissions: row.permissions }) as ManagerAccount["permissions"],
      status: row.status,
      mfaEnabled: mfa.has(row.id),
      passwordChangeRequired: row.passwordChangeRequired,
      credentialDeliveryPending: row.credentialDeliveryPending,
      temporaryPasswordExpiresAt: row.temporaryPasswordExpiresAt?.toISOString() ?? null,
      lastLoginAt: lastLogin.get(row.id)?.toISOString() ?? null,
      createdAt: row.createdAt.toISOString(),
    }));
  }

  /** Chỉ Owner (`manager:manage`), đúng tenant của token. */
  private assertOwner(actor: AccountActor, authz: Authorization): Tenant {
    if (!can(actor, "manager:manage").allowed) {
      throw permissionDenied();
    }
    if (
      actor.scope !== "operator" ||
      !actor.operatorId ||
      !actor.operatorSlug ||
      authz.db?.kind !== "tenant" ||
      authz.db.operatorId !== actor.operatorId
    ) {
      throw tenantScopeViolation();
    }
    return { db: authz.db, operatorId: actor.operatorId, operatorSlug: actor.operatorSlug };
  }

  /** Owner luôn đủ quyền của tenant — vẫn đi qua cùng phép kiểm "chỉ cấp quyền mình có" với Admin. */
  private grants(actor: AccountActor): ReadonlySet<Permission> {
    return accountGrants({ role: actor.role, permissions: actor.perms ?? null });
  }

  private async assertRecentReauth(sid: string): Promise<void> {
    if (!(await this.sessions.hasRecentReauth(sid))) {
      throw reauthRequired();
    }
  }

  private async revoke(managerId: string, reason: SessionRevokeReason): Promise<void> {
    await this.sessions.revokeAllForSubject(SubjectType.OPERATOR, managerId, reason);
  }

  private recordBestEffort(event: AuditEventInput): void {
    this.audit.recordAuditEvent(event).catch(() => {
      this.logger.error(`Ghi audit ${event.action} thất bại.`);
    });
  }
}

function sameList(a: readonly string[], b: readonly string[]): boolean {
  return a.length === b.length && a.every((item, index) => item === b[index]);
}
