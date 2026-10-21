import { HttpException, HttpStatus, Inject, Injectable, Logger } from "@nestjs/common";
import { AuditService, AuditWriteError, type AuditEventInput } from "../../audit/audit.service";
import { decodeTimeCursor, encodeTimeCursor } from "../../common/time-cursor";
import type { DbScope } from "../../database/db-scope";
import { PrismaService, transactionDeadline, type DbTransaction } from "../../database/prisma.service";
import { AccountStatus, PlatformRole, SessionRevokeReason, SubjectType } from "../../database/prisma.types";
import { EMAIL_NOTIFIER, type EmailNotifier, maskEmail } from "../../external/notification/email-notifier";
import { CredentialService } from "../auth/credential.service";
import { MfaService } from "../auth/mfa.service";
import type { VerifiedAccessToken } from "../auth/token.service";
import type { Authorization } from "../role/authorization";
import { permissionDenied } from "../role/authorization.errors";
import { SessionService } from "../session/session.service";
import { Role } from "../role/role";
import { accountNotFound, accountStateConflict, isPrismaUniqueConflict } from "./account.errors";
import { accountGrants, checkPermissionChange, effectiveAssignable, grantableFor, holds } from "./account-permissions";
import { generateTemporaryPassword, TEMPORARY_PASSWORD_TTL_MS } from "./account-provisioning.service";
import type {
  AdminEmployee,
  AdminPassenger,
  AdminPlatformAccount,
  EmployeeListQuery,
  EmployeePage,
  PassengerListQuery,
  PassengerPage,
  PlatformAccountCreate,
  PlatformAccountList,
  PlatformAccountListQuery,
  PlatformPermissionsUpdate,
} from "./dto/admin-user.dto";
import { TemporaryCredentialEmailLimiter } from "./temporary-credential-email-limiter";

type Actor = Pick<VerifiedAccessToken, "sub" | "role" | "scope" | "perms">;

const AUDIT_TIMEOUT_MS = 2_000;
const TITLE = "Account management error";
/** Cách đăng nhập OAuth hiện ra ở cột "Đăng nhập bằng" (ADR-020); email OTP luôn dùng được. */
const OAUTH_PROVIDERS = new Set(["google", "facebook", "apple"]);

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  return new HttpException({ code, detail, title: TITLE }, status);
}
const selfAction = () =>
  problem(HttpStatus.CONFLICT, "PLATFORM_ACCOUNT_SELF_ACTION", "Không tự khóa hoặc đặt lại tài khoản đang đăng nhập.");
const lastAdmin = () =>
  problem(
    HttpStatus.CONFLICT,
    "PLATFORM_ACCOUNT_LAST_ADMIN",
    "Phải còn ít nhất một tài khoản quản trị đang hoạt động có quyền quản lý tài khoản và phân quyền.",
  );
const accountConflict = () =>
  problem(HttpStatus.CONFLICT, "PLATFORM_ACCOUNT_CONFLICT", "Tên đăng nhập hoặc email đã được dùng.");
const auditUnavailable = () =>
  problem(HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE", "Chưa ghi được nhật ký nên chưa đổi gì. Vui lòng thử lại sau.");

const PLATFORM_SELECT = {
  id: true,
  username: true,
  contactEmail: true,
  role: true,
  permissions: true,
  status: true,
  passwordChangeRequired: true,
  credentialDeliveryPending: true,
  lockedReason: true,
  lockedAt: true,
} as const;
type PlatformRow = {
  id: string;
  username: string;
  contactEmail: string | null;
  role: PlatformRole;
  /** JSONB mảng mã quyền; `NULL` = theo vai trò (TASK-IAM-007). */
  permissions: unknown;
  status: AccountStatus;
  passwordChangeRequired: boolean;
  credentialDeliveryPending: boolean;
  lockedReason: string | null;
  lockedAt: Date | null;
};

/**
 * Admin quản lý người dùng (FR-ADM-02/03, FR-IAM-08; Figma ADM-03a…03d): hành khách (xem, khóa / mở khóa), nhân viên
 * nhà xe (chỉ xem — tạo / khóa do chủ nhà xe), tài khoản quản trị (cấp mới bằng mật khẩu tạm, cấp lại mật khẩu, đặt
 * lại xác thực hai lớp, khóa / mở khóa). Mọi thay đổi ghi audit TRONG transaction (lỗi → 503, không đổi gì) và thu
 * hồi phiên của tài khoản bị tác động.
 */
@Injectable()
export class AdminAccountService {
  private readonly logger = new Logger(AdminAccountService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(SessionService) private readonly sessions: SessionService,
    @Inject(MfaService) private readonly mfa: MfaService,
    @Inject(CredentialService) private readonly credentials: CredentialService,
    @Inject(TemporaryCredentialEmailLimiter) private readonly emailLimiter: TemporaryCredentialEmailLimiter,
    @Inject(EMAIL_NOTIFIER) private readonly email: EmailNotifier,
  ) {}

  // ── Hành khách ──────────────────────────────────────────────────────────────────────────────────────

  async listPassengers(authz: Authorization, query: PassengerListQuery): Promise<PassengerPage> {
    const page = await this.prisma.withScope(platformDb(authz), async (tx) => {
      const contains = like(query.q);
      const where = {
        status: query.status,
        ...(contains ? { OR: [{ email: contains }, { name: contains }] } : {}),
      };
      const after = query.cursor ? decodeTimeCursor(query.cursor) : null;
      const rows = await tx.user.findMany({
        where: { AND: [where, after ? { OR: [{ createdAt: { lt: after.at } }, { createdAt: after.at, id: { lt: after.id } }] } : {}] },
        orderBy: [{ createdAt: "desc" }, { id: "desc" }],
        take: query.limit + 1,
        select: {
          id: true,
          name: true,
          email: true,
          status: true,
          lockedReason: true,
          lockedAt: true,
          createdAt: true,
          accounts: { select: { providerId: true } },
        },
      });
      return { rows, total: await tx.user.count({ where }) };
    });
    const kept = page.rows.slice(0, query.limit);
    const lastLogin = await this.sessions.lastLoginAt(SubjectType.PASSENGER, kept.map((row) => row.id));
    const last = kept.at(-1);
    return {
      items: kept.map(
        (row): AdminPassenger => ({
          id: row.id,
          name: row.name,
          email: row.email,
          providers: ["email-otp", ...new Set(row.accounts.map((account) => account.providerId).filter((id) => OAUTH_PROVIDERS.has(id)))],
          status: row.status,
          lockedReason: row.lockedReason,
          lockedAt: row.lockedAt?.toISOString() ?? null,
          createdAt: row.createdAt.toISOString(),
          lastLoginAt: lastLogin.get(row.id)?.toISOString() ?? null,
        }),
      ),
      nextCursor: page.rows.length > query.limit && last ? encodeTimeCursor(last.createdAt, last.id) : null,
      total: page.total,
    };
  }

  async lockPassenger(authz: Authorization, actor: Actor, id: string, reason: string): Promise<void> {
    await this.write(authz, async (tx, deadline) => {
      const changed = await tx.user.updateMany({
        where: { id, status: AccountStatus.ACTIVE },
        data: { status: AccountStatus.LOCKED, lockedReason: reason, lockedAt: new Date() },
      });
      if (changed.count === 0) {
        throw (await tx.user.count({ where: { id } })) ? accountStateConflict() : accountNotFound();
      }
      await this.record(deadline, actor, "iam.passenger.lock", "passenger", id, { status: "ACTIVE" }, { status: "LOCKED" }, reason);
    });
    await this.revoke(SubjectType.PASSENGER, id);
  }

  async unlockPassenger(authz: Authorization, actor: Actor, id: string): Promise<void> {
    await this.write(authz, async (tx, deadline) => {
      const changed = await tx.user.updateMany({
        where: { id, status: AccountStatus.LOCKED },
        data: { status: AccountStatus.ACTIVE, lockedReason: null, lockedAt: null },
      });
      if (changed.count === 0) {
        throw (await tx.user.count({ where: { id } })) ? accountStateConflict() : accountNotFound();
      }
      await this.record(deadline, actor, "iam.passenger.unlock", "passenger", id, { status: "LOCKED" }, { status: "ACTIVE" });
    });
  }

  // ── Nhân viên nhà xe (chỉ xem) ──────────────────────────────────────────────────────────────────────

  async listEmployees(authz: Authorization, query: EmployeeListQuery): Promise<EmployeePage> {
    const page = await this.prisma.withScope(platformDb(authz), async (tx) => {
      const contains = like(query.q);
      const where = {
        operatorId: query.operatorId,
        role: query.role,
        status: query.status,
        ...(contains ? { OR: [{ username: contains }, { contactEmail: contains }] } : {}),
      };
      const after = query.cursor ? decodeTimeCursor(query.cursor) : null;
      const rows = await tx.employeeAccount.findMany({
        where: { AND: [where, after ? { OR: [{ createdAt: { lt: after.at } }, { createdAt: after.at, id: { lt: after.id } }] } : {}] },
        orderBy: [{ createdAt: "desc" }, { id: "desc" }],
        take: query.limit + 1,
        select: {
          id: true,
          username: true,
          contactEmail: true,
          operatorId: true,
          role: true,
          status: true,
          createdAt: true,
          operator: { select: { displayName: true, operatorSlug: true } },
        },
      });
      const operatorIds = await tx.employeeAccount.groupBy({ by: ["operatorId"] });
      const operators = await tx.operatorProfile.findMany({
        where: { id: { in: operatorIds.map((group) => group.operatorId) } },
        orderBy: { displayName: "asc" },
        select: { id: true, displayName: true },
      });
      return { rows, operators, total: await tx.employeeAccount.count({ where }) };
    });
    const kept = page.rows.slice(0, query.limit);
    const lastLogin = await this.sessions.lastLoginAt(SubjectType.EMPLOYEE, kept.map((row) => row.id));
    const last = kept.at(-1);
    return {
      items: kept.map(
        (row): AdminEmployee => ({
          id: row.id,
          username: `${row.operator.operatorSlug}/${row.username}`,
          email: row.contactEmail,
          operatorId: row.operatorId,
          operatorName: row.operator.displayName,
          role: row.role,
          status: row.status,
          lastLoginAt: lastLogin.get(row.id)?.toISOString() ?? null,
        }),
      ),
      nextCursor: page.rows.length > query.limit && last ? encodeTimeCursor(last.createdAt, last.id) : null,
      total: page.total,
      operators: page.operators.map((operator) => ({ id: operator.id, name: operator.displayName })),
    };
  }

  // ── Tài khoản quản trị ──────────────────────────────────────────────────────────────────────────────

  async listPlatformAccounts(authz: Authorization, actor: Actor, query: PlatformAccountListQuery): Promise<PlatformAccountList> {
    const rows = await this.prisma.withScope(platformDb(authz), (tx) => {
      const contains = like(query.q);
      return tx.platformAccount.findMany({
        where: {
          role: query.role,
          status: query.status,
          ...(contains ? { OR: [{ username: contains }, { contactEmail: contains }] } : {}),
        },
        orderBy: [{ createdAt: "asc" }, { id: "asc" }],
        select: PLATFORM_SELECT,
      });
    });
    const ids = rows.map((row) => row.id);
    const [mfa, lastLogin] = await Promise.all([
      this.mfa.enabledSubjects(SubjectType.PLATFORM, ids),
      this.sessions.lastLoginAt(SubjectType.PLATFORM, ids),
    ]);
    // Chỉ để web khóa ô — thao tác ghi kiểm lại theo DB (`actorGrants`).
    const grants = accountGrants({ role: actor.role, permissions: actor.perms ?? null });
    return {
      items: rows.map((row) => toPlatformAccount(row, actor, mfa.has(row.id), lastLogin.get(row.id) ?? null)),
      grantable: {
        PLATFORM_ADMIN: grantableFor(Role.PLATFORM_ADMIN, grants),
        PLATFORM_SUPPORT: grantableFor(Role.PLATFORM_SUPPORT, grants),
      },
    };
  }

  /** Cấp tài khoản quản trị: mật khẩu tạm gửi tới email nội bộ; lần đăng nhập đầu phải đổi mật khẩu + bật TOTP. */
  async createPlatformAccount(authz: Authorization, actor: Actor, input: PlatformAccountCreate): Promise<AdminPlatformAccount> {
    await this.emailLimiter.reserve({ operatorId: "platform", actorType: actor.scope, actorId: actor.sub });
    const temporaryPassword = generateTemporaryPassword();
    const passwordHash = await this.credentials.hash(temporaryPassword);
    const expiresAt = new Date(Date.now() + TEMPORARY_PASSWORD_TTL_MS);
    let created: PlatformRow;
    try {
      created = await this.write(authz, async (tx, deadline) => {
        // Tài khoản mới luôn mang danh sách riêng, chỉ gồm quyền người cấp đang có (TASK-IAM-007 P5).
        const permissions = checkPermissionChange(input.role, input.permissions, [], await this.actorGrants(tx, actor));
        const row = await tx.platformAccount.create({
          data: {
            username: input.username,
            contactEmail: input.email,
            role: input.role,
            permissions,
            passwordHash,
            passwordChangeRequired: true,
            credentialDeliveryPending: true,
            temporaryPasswordExpiresAt: expiresAt,
            createdBy: actor.sub,
          },
          select: PLATFORM_SELECT,
        });
        await this.record(deadline, actor, "iam.platform_account.create", "platform_account", row.id, null, {
          username: row.username,
          email: maskEmail(input.email),
          role: row.role,
          permissions,
        });
        return row;
      });
    } catch (error) {
      if (isPrismaUniqueConflict(error)) {
        throw accountConflict();
      }
      throw error;
    }
    const delivered = await this.deliver(authz, created, temporaryPassword, expiresAt);
    return toPlatformAccount({ ...created, credentialDeliveryPending: !delivered }, actor, false, null);
  }

  /** Cấp lại mật khẩu tạm (cũng dùng để gửi lại khi lần gửi trước lỗi); thu hồi mọi phiên của tài khoản. */
  async resetPlatformPassword(authz: Authorization, actor: Actor, id: string): Promise<AdminPlatformAccount> {
    return this.rotateCredentials(authz, actor, id, false);
  }

  /**
   * Đặt lại xác thực hai lớp: xóa TOTP + mã dự phòng VÀ thay mật khẩu bằng mật khẩu tạm gửi tới email của tài khoản —
   * người chỉ biết mật khẩu cũ không tự đăng ký TOTP mới được (không vượt MFA).
   */
  async resetPlatformMfa(authz: Authorization, actor: Actor, id: string): Promise<AdminPlatformAccount> {
    return this.rotateCredentials(authz, actor, id, true);
  }

  async lockPlatformAccount(authz: Authorization, actor: Actor, id: string, reason: string): Promise<void> {
    assertNotSelf(actor, id);
    await this.write(authz, async (tx, deadline) => {
      await lockActiveAccounts(tx);
      const target = await tx.platformAccount.findUnique({ where: { id }, select: { status: true } });
      if (!target) {
        throw accountNotFound();
      }
      if (target.status !== AccountStatus.ACTIVE) {
        throw accountStateConflict();
      }
      await tx.platformAccount.update({
        where: { id },
        data: { status: AccountStatus.LOCKED, lockedReason: reason, lockedAt: new Date(), authEpoch: { increment: 1 } },
      });
      await assertAccessManagerRemains(tx);
      await this.record(deadline, actor, "iam.platform_account.lock", "platform_account", id, { status: "ACTIVE" }, { status: "LOCKED" }, reason);
    });
    await this.revoke(SubjectType.PLATFORM, id);
  }

  async unlockPlatformAccount(authz: Authorization, actor: Actor, id: string): Promise<void> {
    assertNotSelf(actor, id);
    await this.write(authz, async (tx, deadline) => {
      const changed = await tx.platformAccount.updateMany({
        where: { id, status: AccountStatus.LOCKED },
        data: { status: AccountStatus.ACTIVE, lockedReason: null, lockedAt: null },
      });
      if (changed.count === 0) {
        throw (await tx.platformAccount.count({ where: { id } })) ? accountStateConflict() : accountNotFound();
      }
      await this.record(deadline, actor, "iam.platform_account.unlock", "platform_account", id, { status: "LOCKED" }, { status: "ACTIVE" });
    });
  }

  /**
   * Phân quyền tài khoản quản trị (FR-IAM-07, TASK-IAM-007): không tự sửa mình; chỉ thêm / bớt quyền mình đang có; luôn
   * còn ≥ 1 tài khoản hoạt động có `access:manage`. Có hiệu lực ngay: tăng `auth_epoch` + thu hồi mọi phiên (trước và sau
   * khi ghi, như cấp lại mật khẩu) — người bị đổi đăng nhập lại.
   */
  async updatePlatformPermissions(
    authz: Authorization,
    actor: Actor,
    id: string,
    input: PlatformPermissionsUpdate,
  ): Promise<AdminPlatformAccount> {
    assertNotSelf(actor, id);
    // Kiểm trước khi đụng phiên: yêu cầu sai (404 / 400 / 403) không được đá người khác ra.
    await this.prisma.withScope(platformDb(authz), (tx) => this.planPermissions(tx, actor, id, input.permissions));
    await this.revoke(SubjectType.PLATFORM, id);
    const updated = await this.write(authz, async (tx, deadline) => {
      await lockActiveAccounts(tx);
      const { before, permissions } = await this.planPermissions(tx, actor, id, input.permissions);
      const row = await tx.platformAccount.update({
        where: { id },
        data: { permissions, authEpoch: { increment: 1 } },
        select: PLATFORM_SELECT,
      });
      await assertAccessManagerRemains(tx);
      await this.record(
        deadline,
        actor,
        "iam.platform_account.permissions_update",
        "platform_account",
        id,
        { permissions: before },
        { permissions },
        input.reason,
      );
      return row;
    });
    await this.revoke(SubjectType.PLATFORM, id);
    const [mfa, lastLogin] = await Promise.all([
      this.mfa.enabledSubjects(SubjectType.PLATFORM, [id]),
      this.sessions.lastLoginAt(SubjectType.PLATFORM, [id]),
    ]);
    return toPlatformAccount(updated, actor, mfa.has(id), lastLogin.get(id) ?? null);
  }

  // ── Nội bộ ────────────────────────────────────────────────────────────────────────────────────────────

  private async planPermissions(tx: DbTransaction, actor: Actor, id: string, requested: readonly string[]) {
    const grants = await this.actorGrants(tx, actor);
    const target = await tx.platformAccount.findUnique({ where: { id }, select: { role: true, permissions: true } });
    if (!target) {
      throw accountNotFound();
    }
    const before = effectiveAssignable(target);
    return { before, permissions: checkPermissionChange(target.role, requested, before, grants) };
  }

  /**
   * Quyền của người thao tác đọc lại từ DB, không tin claim: quyền vừa bị gỡ (phiên đã thu hồi nhưng request đang chạy)
   * không được dùng để cấp tiếp. Không còn hoạt động / mất `access:manage` → 403.
   */
  private async actorGrants(tx: DbTransaction, actor: Actor) {
    const row = await tx.platformAccount.findUnique({
      where: { id: actor.sub },
      select: { role: true, permissions: true, status: true },
    });
    if (!row || row.status !== AccountStatus.ACTIVE || !holds(row, "access:manage")) {
      throw permissionDenied();
    }
    return accountGrants(row);
  }

  private async rotateCredentials(authz: Authorization, actor: Actor, id: string, resetMfa: boolean): Promise<AdminPlatformAccount> {
    assertNotSelf(actor, id);
    const current = await this.prisma.withScope(platformDb(authz), (tx) =>
      tx.platformAccount.findUnique({ where: { id }, select: PLATFORM_SELECT }),
    );
    if (!current) {
      throw accountNotFound();
    }
    if (current.status !== AccountStatus.ACTIVE || !current.contactEmail) {
      // Tài khoản bị khóa: mở khóa trước; tài khoản seed chưa có email: không có nơi nhận mật khẩu tạm.
      throw accountStateConflict();
    }
    await this.emailLimiter.reserve({ operatorId: "platform", actorType: actor.scope, actorId: actor.sub });
    const temporaryPassword = generateTemporaryPassword();
    const passwordHash = await this.credentials.hash(temporaryPassword);
    const expiresAt = new Date(Date.now() + TEMPORARY_PASSWORD_TTL_MS);

    await this.revoke(SubjectType.PLATFORM, id);
    const updated = await this.write(authz, async (tx, deadline) => {
      const changed = await tx.platformAccount.updateManyAndReturn({
        where: { id, status: AccountStatus.ACTIVE },
        data: {
          passwordHash,
          authEpoch: { increment: 1 },
          passwordChangeRequired: true,
          credentialDeliveryPending: true,
          temporaryPasswordExpiresAt: expiresAt,
        },
        select: PLATFORM_SELECT,
      });
      const row = changed[0];
      if (!row) {
        throw accountStateConflict();
      }
      await this.record(
        deadline,
        actor,
        resetMfa ? "iam.platform_account.mfa_reset" : "iam.platform_account.password_reset",
        "platform_account",
        id,
        null,
        { passwordChangeRequired: true, ...(resetMfa ? { mfaEnabled: false } : {}) },
      );
      return row;
    });
    if (resetMfa) {
      await this.mfa.resetForSubject(SubjectType.PLATFORM, id);
    }
    // Quét lần hai: phiên sinh trong cửa sổ giữa lần thu hồi đầu và khi mật khẩu đổi (như IAM-005).
    await this.revoke(SubjectType.PLATFORM, id);
    const delivered = await this.deliver(authz, updated, temporaryPassword, expiresAt);
    const [mfa, lastLogin] = await Promise.all([
      this.mfa.enabledSubjects(SubjectType.PLATFORM, [id]),
      this.sessions.lastLoginAt(SubjectType.PLATFORM, [id]),
    ]);
    return toPlatformAccount({ ...updated, credentialDeliveryPending: !delivered }, actor, mfa.has(id), lastLogin.get(id) ?? null);
  }

  /** Gửi mật khẩu tạm; gửi được thì bỏ cờ chờ giao. Lỗi gửi không hoàn tác — Admin cấp lại để gửi lại. */
  private async deliver(authz: Authorization, account: PlatformRow, temporaryPassword: string, expiresAt: Date): Promise<boolean> {
    try {
      if (!this.email.sendTemporaryPassword || !account.contactEmail) {
        throw new Error("Temporary password delivery is not configured.");
      }
      await this.email.sendTemporaryPassword({
        email: account.contactEmail,
        temporaryPassword,
        loginIdentifier: `platform/${account.username}`,
        expiresAt,
      });
    } catch (error) {
      this.logger.warn({ event: "iam.platform_account.delivery_failed", accountId: account.id, error });
      return false;
    }
    await this.prisma.withScope(platformDb(authz), (tx) =>
      tx.platformAccount.updateMany({ where: { id: account.id, credentialDeliveryPending: true }, data: { credentialDeliveryPending: false } }),
    );
    return true;
  }

  private async revoke(type: SubjectType, id: string): Promise<void> {
    await this.sessions.revokeAllForSubject(type, id, SessionRevokeReason.ACCOUNT_LOCKED);
  }

  private async write<T>(authz: Authorization, work: (tx: DbTransaction, deadline: number) => Promise<T>): Promise<T> {
    try {
      return await this.prisma.withScope(platformDb(authz), (tx) => work(tx, transactionDeadline(Date.now())));
    } catch (error) {
      if (error instanceof AuditWriteError || (error as { code?: unknown } | null)?.code === "P2028") {
        throw auditUnavailable();
      }
      throw error;
    }
  }

  private record(
    deadline: number,
    actor: Actor,
    action: string,
    targetType: string,
    targetId: string,
    before: Record<string, unknown> | null,
    after: Record<string, unknown>,
    reason?: string,
  ): Promise<void> {
    const event: AuditEventInput = { actorId: actor.sub, actorRole: actor.role, action, targetType, targetId, before, after, ...(reason ? { reason } : {}) };
    return this.audit.recordAuditEvent(event, { timeoutMs: AUDIT_TIMEOUT_MS, deadline });
  }
}

/**
 * Khóa dòng mọi tài khoản đang hoạt động trước khi khóa / phân quyền: hai Admin bỏ quyền (hoặc khóa) nhau cùng lúc chạy
 * tuần tự, người sau thấy trạng thái mới — hệ thống không bao giờ hết người quản lý tài khoản.
 */
async function lockActiveAccounts(tx: DbTransaction): Promise<void> {
  await tx.$queryRaw`SELECT 1 FROM platform_accounts WHERE status = 'ACTIVE' FOR UPDATE`;
}

async function assertAccessManagerRemains(tx: DbTransaction): Promise<void> {
  const active = await tx.platformAccount.findMany({
    where: { status: AccountStatus.ACTIVE },
    select: { role: true, permissions: true },
  });
  if (!active.some((row) => holds(row, "access:manage"))) {
    throw lastAdmin();
  }
}

function toPlatformAccount(row: PlatformRow, actor: Actor, mfaEnabled: boolean, lastLoginAt: Date | null): AdminPlatformAccount {
  return {
    id: row.id,
    username: `platform/${row.username}`,
    email: row.contactEmail,
    role: row.role,
    permissions: effectiveAssignable(row),
    status: row.status,
    mfaEnabled,
    passwordChangeRequired: row.passwordChangeRequired,
    credentialDeliveryPending: row.credentialDeliveryPending,
    lockedReason: row.lockedReason,
    lockedAt: row.lockedAt?.toISOString() ?? null,
    lastLoginAt: lastLoginAt?.toISOString() ?? null,
    isSelf: row.id === actor.sub,
  };
}

function assertNotSelf(actor: Actor, id: string): void {
  if (actor.sub === id) {
    throw selfAction();
  }
}

/** `contains` không phân biệt hoa thường; `%`, `_` là ký tự thường. */
function like(q: string | undefined) {
  return q ? { contains: q.replace(/[\\%_]/g, "\\$&"), mode: "insensitive" as const } : undefined;
}

function platformDb(authz: Authorization): DbScope {
  if (authz.db?.kind !== "platform") {
    // Lỗi lập trình: route Admin thiếu `@Authorize` với quyền phạm vi `any`.
    throw new Error("Route Admin người dùng cần ngữ cảnh DB platform.");
  }
  return authz.db;
}
