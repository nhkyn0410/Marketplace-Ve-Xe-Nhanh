import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { AuditWriteError, type AuditEventInput, type AuditService } from "../../audit/audit.service";
import { parseAppConfig } from "../../config/env.config";
import { platformScope } from "../../database/db-scope";
import { PrismaService } from "../../database/prisma.service";
import type { EmailNotifier, TemporaryPasswordEmailMessage } from "../../external/notification/email-notifier";
import { CredentialService } from "../auth/credential.service";
import type { MfaService } from "../auth/mfa.service";
import type { Authorization } from "../role/authorization";
import type { SessionService } from "../session/session.service";
import { AdminAccountService } from "./admin-account.service";
import {
  EmployeeListQuerySchema,
  OperatorAccountListQuerySchema,
  PassengerListQuerySchema,
  PlatformAccountCreateSchema,
  PlatformAccountListQuerySchema,
  PlatformPermissionsUpdateSchema,
} from "./dto/admin-user.dto";
import type { TemporaryCredentialEmailLimiter } from "./temporary-credential-email-limiter";

/** Admin quản lý người dùng (FR-ADM-02/03, FR-IAM-08; Figma ADM-03a…03d) trên Postgres THẬT bằng role APP. */
const url = process.env.DATABASE_URL;
const requireDb = process.env.REQUIRE_DB_TESTS === "1";

async function rejectionOf(promise: Promise<unknown>): Promise<{ status?: number; code?: string }> {
  try {
    await promise;
    return {};
  } catch (error) {
    const response = (error as { getResponse?: () => { code?: string } }).getResponse?.();
    return { status: (error as { getStatus?: () => number }).getStatus?.(), code: response?.code };
  }
}

describe.skipIf(!url && !requireDb)("Admin người dùng — Postgres thật, role app", () => {
  let prisma: PrismaService;
  let accounts: AdminAccountService;
  const credentials = new CredentialService();
  const tag = randomUUID().slice(0, 8);
  const adminId = randomUUID();
  const operatorId = randomUUID();
  const employeeId = randomUUID();
  const ownerId = randomUUID();
  const managerId = randomUUID();
  const foreignOperatorId = randomUUID();
  const foreignOwnerId = randomUUID();
  const passengerId = `psg${tag}`;
  const createdPlatform: string[] = [];
  const actor = { sub: adminId, role: "PLATFORM_ADMIN", scope: "platform" as const };
  const authz: Authorization = { permission: "user:manage", scope: "any", db: platformScope() };
  const recordAuditEvent = vi.fn(async (_event: AuditEventInput, _options?: unknown) => undefined);
  const revokeAllForSubject = vi.fn(async () => 1);
  const lastLoginAt = vi.fn(async () => new Map<string, Date>());
  const reserve = vi.fn(async (_request: unknown) => undefined);
  const mfa = { enabledSubjects: vi.fn(async () => new Set<string>()), resetForSubject: vi.fn(async () => 1) };
  const sent: TemporaryPasswordEmailMessage[] = [];
  const sendTemporaryPassword = vi.fn(async (message: TemporaryPasswordEmailMessage) => {
    sent.push(message);
  });

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    accounts = new AdminAccountService(
      prisma,
      { recordAuditEvent } as unknown as AuditService,
      { revokeAllForSubject, lastLoginAt } as unknown as SessionService,
      mfa as unknown as MfaService,
      credentials,
      { reserve } as unknown as TemporaryCredentialEmailLimiter,
      { sendOtp: async () => undefined, sendTemporaryPassword } as EmailNotifier,
    );
    await prisma.withSystem(async (tx) => {
      await tx.platformAccount.create({
        data: { id: adminId, username: `adm-u-${tag}`, passwordHash: "x", role: "PLATFORM_ADMIN" },
      });
      await tx.user.create({ data: { id: passengerId, email: `rider-${tag}@example.com`, name: `Khách ${tag}` } });
      await tx.account.create({ data: { id: randomUUID(), userId: passengerId, accountId: "g-1", providerId: "google" } });
      await tx.operatorProfile.create({ data: { id: operatorId, operatorSlug: `adm-u-${tag}`, displayName: `Nhà xe U ${tag}` } });
      await tx.operatorProfile.create({ data: { id: foreignOperatorId, operatorSlug: `adm-f-${tag}`, displayName: `Nhà xe F ${tag}` } });
      await tx.operatorAccount.createMany({ data: [
        { id: ownerId, operatorId, operatorSlug: `adm-u-${tag}`, username: "owner01", contactEmail: `owner-${tag}@example.test`, passwordHash: "old-owner-hash", role: "OPERATOR_OWNER" },
        { id: managerId, operatorId, operatorSlug: `adm-u-${tag}`, username: "manager01", contactEmail: `manager-${tag}@example.test`, passwordHash: "old-manager-hash", role: "OPERATOR_MANAGER", permissions: ["booking:read"] },
        { id: foreignOwnerId, operatorId: foreignOperatorId, operatorSlug: `adm-f-${tag}`, username: "owner01", contactEmail: `foreign-${tag}@example.test`, passwordHash: "foreign-owner-hash", role: "OPERATOR_OWNER" },
      ] });
      await tx.employeeAccount.create({
        data: { id: employeeId, operatorId, username: "nv.ve01", passwordHash: "x", role: "TICKET_STAFF", contactEmail: `ve@${tag}.test` },
      });
    });
  }, 30_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      await tx.employeeAccount.deleteMany({ where: { operatorId } });
      await tx.operatorAccount.deleteMany({ where: { operatorId: { in: [operatorId, foreignOperatorId] } } });
      await tx.operatorProfile.deleteMany({ where: { id: { in: [operatorId, foreignOperatorId] } } });
      await tx.account.deleteMany({ where: { userId: passengerId } });
      await tx.user.deleteMany({ where: { id: passengerId } });
      await tx.platformAccount.deleteMany({ where: { id: { in: [adminId, ...createdPlatform] } } });
    });
    await prisma.$disconnect();
  });

  beforeEach(() => {
    recordAuditEvent.mockReset();
    recordAuditEvent.mockResolvedValue(undefined);
    revokeAllForSubject.mockClear();
    sendTemporaryPassword.mockClear();
    reserve.mockReset().mockResolvedValue(undefined);
    sent.length = 0;
  });

  it("hành khách: tìm theo email, cách đăng nhập (email OTP + Google); khóa kèm lý do → thu hồi phiên; khóa lần nữa 409; mở khóa", async () => {
    const page = await accounts.listPassengers(authz, PassengerListQuerySchema.parse({ q: `rider-${tag}` }));
    expect(page.items).toEqual([
      expect.objectContaining({ id: passengerId, name: `Khách ${tag}`, providers: ["email-otp", "google"], status: "ACTIVE" }),
    ]);

    await accounts.lockPassenger(authz, actor, passengerId, "Nghi gian lận thanh toán");
    expect(await prisma.user.findUniqueOrThrow({ where: { id: passengerId } })).toMatchObject({
      status: "LOCKED",
      lockedReason: "Nghi gian lận thanh toán",
    });
    expect(revokeAllForSubject).toHaveBeenCalledWith("PASSENGER", passengerId, "ACCOUNT_LOCKED");
    expect(recordAuditEvent).toHaveBeenCalledWith(
      expect.objectContaining({ action: "iam.passenger.lock", targetId: passengerId, reason: "Nghi gian lận thanh toán" }),
      expect.objectContaining({ timeoutMs: 2_000 }),
    );
    expect(await rejectionOf(accounts.lockPassenger(authz, actor, passengerId, "lần nữa"))).toEqual({
      status: 409,
      code: "ACCOUNT_STATE_CONFLICT",
    });
    expect((await accounts.listPassengers(authz, PassengerListQuerySchema.parse({ q: `rider-${tag}`, status: "LOCKED" }))).total).toBe(1);

    await accounts.unlockPassenger(authz, actor, passengerId);
    expect((await prisma.user.findUniqueOrThrow({ where: { id: passengerId } })).lockedReason).toBeNull();
    expect(await rejectionOf(accounts.unlockPassenger(authz, actor, "khong-co"))).toEqual({ status: 404, code: "ACCOUNT_NOT_FOUND" });
  });

  it("nhân viên nhà xe chỉ xem: tên đăng nhập kèm slug, nhà xe, vai trò; lọc nhà xe / vai trò; ô lọc nhà xe", async () => {
    const page = await accounts.listEmployees(authz, EmployeeListQuerySchema.parse({ operatorId, role: "TICKET_STAFF" }));
    expect(page.items).toEqual([
      expect.objectContaining({ id: employeeId, username: `adm-u-${tag}/nv.ve01`, operatorName: `Nhà xe U ${tag}`, role: "TICKET_STAFF" }),
    ]);
    expect(page.operators).toEqual(expect.arrayContaining([{ id: operatorId, name: `Nhà xe U ${tag}` }]));
    expect((await accounts.listEmployees(authz, EmployeeListQuerySchema.parse({ operatorId, role: "DRIVER" }))).total).toBe(0);
  });

  it("tài khoản nhà xe: Owner + Manager, lọc tenant / vai trò / tên đăng nhập đầy đủ và phân trang không trùng", async () => {
    const query = OperatorAccountListQuerySchema.parse({ operatorId, limit: 1 });
    const first = await accounts.listOperatorAccounts(authz, query);
    const second = await accounts.listOperatorAccounts(authz, { ...query, cursor: first.nextCursor! });
    expect(first.total).toBe(2);
    expect(first.nextCursor).not.toBeNull();
    expect(second.nextCursor).toBeNull();
    expect(new Set([...first.items, ...second.items].map((row) => row.id))).toEqual(new Set([ownerId, managerId]));
    expect(JSON.stringify(first)).not.toMatch(/passwordHash|authEpoch|old-owner-hash/);
    expect((await accounts.listOperatorAccounts(authz, OperatorAccountListQuerySchema.parse({ operatorId, role: "OPERATOR_MANAGER" }))).items.map((row) => row.id)).toEqual([managerId]);
    expect((await accounts.listOperatorAccounts(authz, OperatorAccountListQuerySchema.parse({ q: `adm-u-${tag}/owner01` }))).items.map((row) => row.id)).toEqual([ownerId]);
    expect((await accounts.listOperatorAccounts(authz, OperatorAccountListQuerySchema.parse({ operatorId: foreignOperatorId }))).items.map((row) => row.id)).toEqual([foreignOwnerId]);
  });

  it.each([ownerId, managerId])("cấp mật khẩu nhà xe %s: hạn 24h, epoch tăng, thu hồi phiên trước / sau, giữ 2FA và tài khoản tenant khác", async (id) => {
    const before = await prisma.withSystem((tx) => tx.operatorAccount.findUniqueOrThrow({ where: { id } }));
    const foreign = await prisma.withSystem((tx) => tx.operatorAccount.findUniqueOrThrow({ where: { id: foreignOwnerId } }));
    mfa.resetForSubject.mockClear();
    const updated = await accounts.resetOperatorPassword(authz, actor, id, "Hỗ trợ nhà xe quên mật khẩu");
    const after = await prisma.withSystem((tx) => tx.operatorAccount.findUniqueOrThrow({ where: { id } }));
    expect(after.authEpoch).toBe(before.authEpoch + 1);
    expect(after.version).toBe(before.version + 2);
    expect(after.passwordChangeRequired).toBe(true);
    expect(after.credentialDeliveryPending).toBe(false);
    expect(after.temporaryPasswordExpiresAt!.getTime() - Date.now()).toBeGreaterThan(23 * 3_600_000);
    expect(await credentials.verify(sent[0]!.temporaryPassword, after.passwordHash)).toBe(true);
    expect(sent[0]!.loginIdentifier).toBe(updated.username);
    expect(updated).toMatchObject({ id, passwordChangeRequired: true, credentialDeliveryPending: false });
    expect(JSON.stringify(updated)).not.toContain(sent[0]!.temporaryPassword);
    expect(revokeAllForSubject).toHaveBeenCalledTimes(2);
    expect(revokeAllForSubject).toHaveBeenCalledWith("OPERATOR", id, "PASSWORD_RESET");
    expect(mfa.resetForSubject).not.toHaveBeenCalled();
    expect(reserve).toHaveBeenCalledWith({ operatorId, actorType: "platform", actorId: actor.sub, operatorAccountId: id });
    expect(recordAuditEvent).toHaveBeenCalledWith(expect.objectContaining({ action: "iam.operator_account.password_reset", operatorId, reason: "Hỗ trợ nhà xe quên mật khẩu" }), expect.anything());
    expect(await prisma.withSystem((tx) => tx.operatorAccount.findUniqueOrThrow({ where: { id: foreignOwnerId } }))).toEqual(foreign);
  });

  it("email lỗi → chờ giao; cấp lại thành công bỏ cờ pending; không tự mở nhà xe tạm khóa", async () => {
    await prisma.withSystem((tx) => tx.operatorProfile.update({ where: { id: operatorId }, data: { status: "SUSPENDED" } }));
    try {
      sendTemporaryPassword.mockRejectedValueOnce(new Error("mail unavailable"));
      const pending = await accounts.resetOperatorPassword(authz, actor, ownerId, "Gửi lại mật khẩu");
      expect(pending).toMatchObject({ credentialDeliveryPending: true, operatorStatus: "SUSPENDED", status: "ACTIVE" });
      expect((await prisma.withSystem((tx) => tx.operatorAccount.findUniqueOrThrow({ where: { id: ownerId } }))).credentialDeliveryPending).toBe(true);
      const delivered = await accounts.resetOperatorPassword(authz, actor, ownerId, "Thử gửi lại email");
      expect(delivered.credentialDeliveryPending).toBe(false);
      expect((await prisma.withSystem((tx) => tx.operatorProfile.findUniqueOrThrow({ where: { id: operatorId } }))).status).toBe("SUSPENDED");
    } finally {
      await prisma.withSystem((tx) => tx.operatorProfile.update({ where: { id: operatorId }, data: { status: "ACTIVE" } }));
    }
  });

  it("quota hoặc audit lỗi → không đổi mật khẩu; lỗi audit sau update → transaction rollback", async () => {
    const before = await prisma.withSystem((tx) => tx.operatorAccount.findUniqueOrThrow({ where: { id: ownerId } }));
    reserve.mockRejectedValueOnce(new Error("quota exhausted"));
    await expect(accounts.resetOperatorPassword(authz, actor, ownerId, "Hỗ trợ khôi phục")).rejects.toThrow("quota exhausted");
    expect(sendTemporaryPassword).not.toHaveBeenCalled();
    expect(revokeAllForSubject).not.toHaveBeenCalled();
    recordAuditEvent.mockRejectedValueOnce(new AuditWriteError(new Error("mongo unavailable")));
    expect(await rejectionOf(accounts.resetOperatorPassword(authz, actor, ownerId, "Hỗ trợ khôi phục"))).toEqual({ status: 503, code: "SERVICE_UNAVAILABLE" });
    recordAuditEvent.mockResolvedValueOnce(undefined).mockRejectedValueOnce(new AuditWriteError(new Error("mongo unavailable")));
    expect(await rejectionOf(accounts.resetOperatorPassword(authz, actor, ownerId, "Hỗ trợ khôi phục"))).toEqual({ status: 503, code: "SERVICE_UNAVAILABLE" });
    expect(await prisma.withSystem((tx) => tx.operatorAccount.findUniqueOrThrow({ where: { id: ownerId } }))).toEqual(before);
    expect(sendTemporaryPassword).not.toHaveBeenCalled();
  });

  it.each(["LOCKED", "DISABLED"] as const)("không cấp lại hoặc tự mở tài khoản %s; thiếu email / id không có bị chặn", async (status) => {
    await prisma.withSystem((tx) => tx.operatorAccount.update({ where: { id: ownerId }, data: { status } }));
    try {
      expect(await rejectionOf(accounts.resetOperatorPassword(authz, actor, ownerId, "Hỗ trợ khôi phục"))).toEqual({ status: 409, code: "ACCOUNT_STATE_CONFLICT" });
      expect((await prisma.withSystem((tx) => tx.operatorAccount.findUniqueOrThrow({ where: { id: ownerId } }))).status).toBe(status);
      expect(sendTemporaryPassword).not.toHaveBeenCalled();
      expect(reserve).not.toHaveBeenCalled();
    } finally {
      await prisma.withSystem((tx) => tx.operatorAccount.update({ where: { id: ownerId }, data: { status: "ACTIVE" } }));
    }
    const before = await prisma.withSystem((tx) => tx.operatorAccount.update({ where: { id: ownerId }, data: { contactEmail: null } }));
    try {
      expect(await rejectionOf(accounts.resetOperatorPassword(authz, actor, ownerId, "Hỗ trợ khôi phục"))).toEqual({ status: 409, code: "ACCOUNT_STATE_CONFLICT" });
      expect(await rejectionOf(accounts.resetOperatorPassword(authz, actor, randomUUID(), "Hỗ trợ khôi phục"))).toEqual({ status: 404, code: "ACCOUNT_NOT_FOUND" });
    } finally {
      await prisma.withSystem((tx) => tx.operatorAccount.update({ where: { id: ownerId }, data: { contactEmail: `owner-${tag}@example.test`, passwordHash: before.passwordHash } }));
    }
  });

  it("không xóa cờ chờ giao của mật khẩu mới hơn nếu account thay đổi trong lúc gửi email", async () => {
    sendTemporaryPassword.mockImplementationOnce(async () => {
      await prisma.withSystem((tx) => tx.operatorAccount.update({ where: { id: ownerId }, data: { version: { increment: 1 }, credentialDeliveryPending: true } }));
    });
    expect(await rejectionOf(accounts.resetOperatorPassword(authz, actor, ownerId, "Hỗ trợ khôi phục"))).toEqual({ status: 409, code: "ACCOUNT_STATE_CONFLICT" });
    expect((await prisma.withSystem((tx) => tx.operatorAccount.findUniqueOrThrow({ where: { id: ownerId } }))).credentialDeliveryPending).toBe(true);
  });

  it("cấp tài khoản quản trị: mật khẩu tạm gửi email, phải đổi lần đầu; trùng tên → 409; gửi lỗi → chờ giao, cấp lại để gửi lại", async () => {
    const input = PlatformAccountCreateSchema.parse({
      username: `Ngoc.${tag}`,
      email: `ngoc-${tag}@vexenhanh.test`,
      role: "PLATFORM_SUPPORT",
      permissions: ["payment:monitor", "support:manage"],
    });
    const created = await accounts.createPlatformAccount(authz, actor, input);
    createdPlatform.push(created.id);
    expect(created).toMatchObject({
      username: `platform/ngoc.${tag}`,
      email: `ngoc-${tag}@vexenhanh.test`,
      role: "PLATFORM_SUPPORT",
      permissions: ["payment:monitor", "support:manage"],
      passwordChangeRequired: true,
      credentialDeliveryPending: false,
      mfaEnabled: false,
    });
    expect(sent).toEqual([expect.objectContaining({ email: `ngoc-${tag}@vexenhanh.test`, loginIdentifier: `platform/ngoc.${tag}` })]);
    const stored = await prisma.platformAccount.findUniqueOrThrow({ where: { id: created.id } });
    expect(await credentials.verify(sent[0]!.temporaryPassword, stored.passwordHash)).toBe(true);
    expect(stored).toMatchObject({ passwordChangeRequired: true, createdBy: adminId });
    expect(recordAuditEvent).toHaveBeenCalledWith(expect.objectContaining({ action: "iam.platform_account.create" }), expect.anything());

    expect(await rejectionOf(accounts.createPlatformAccount(authz, actor, input))).toEqual({
      status: 409,
      code: "PLATFORM_ACCOUNT_CONFLICT",
    });

    sendTemporaryPassword.mockRejectedValueOnce(new Error("domain not verified"));
    const pending = await accounts.createPlatformAccount(
      authz,
      actor,
      PlatformAccountCreateSchema.parse({
        username: `minh.${tag}`,
        email: `minh-${tag}@vexenhanh.test`,
        role: "PLATFORM_ADMIN",
        permissions: ["audit:read"],
      }),
    );
    createdPlatform.push(pending.id);
    expect(pending.credentialDeliveryPending).toBe(true);
    const resent = await accounts.resetPlatformPassword(authz, actor, pending.id);
    expect(resent.credentialDeliveryPending).toBe(false);

    const list = await accounts.listPlatformAccounts(authz, actor, PlatformAccountListQuerySchema.parse({ q: tag }));
    expect(list.items.map((item) => item.username)).toEqual(
      expect.arrayContaining([`platform/adm-u-${tag}`, `platform/ngoc.${tag}`, `platform/minh.${tag}`]),
    );
    expect(list.items.find((item) => item.id === adminId)).toMatchObject({
      isSelf: true,
      // Tài khoản seed (permissions NULL) = đủ quyền tick được của vai trò.
      permissions: expect.arrayContaining(["access:manage", "payout:manage"]),
    });
    expect(list.grantable.PLATFORM_SUPPORT).toEqual(["payment:monitor", "support:manage"]);
  });

  it("cấp lại mật khẩu / đặt lại 2FA: mật khẩu tạm mới, epoch tăng, phiên bị thu hồi; 2FA xóa credential; không tự thao tác trên mình", async () => {
    const created = await accounts.createPlatformAccount(
      authz,
      actor,
      PlatformAccountCreateSchema.parse({
        username: `lan.${tag}`,
        email: `lan-${tag}@vexenhanh.test`,
        role: "PLATFORM_SUPPORT",
        permissions: ["payment:monitor", "support:manage"],
      }),
    );
    createdPlatform.push(created.id);
    const before = await prisma.platformAccount.findUniqueOrThrow({ where: { id: created.id } });
    sent.length = 0;

    await accounts.resetPlatformMfa(authz, actor, created.id);
    const after = await prisma.platformAccount.findUniqueOrThrow({ where: { id: created.id } });
    expect(after.authEpoch).toBe(before.authEpoch + 1);
    expect(after.passwordHash).not.toBe(before.passwordHash);
    expect(await credentials.verify(sent[0]!.temporaryPassword, after.passwordHash)).toBe(true);
    expect(mfa.resetForSubject).toHaveBeenCalledWith("PLATFORM", created.id);
    expect(revokeAllForSubject).toHaveBeenCalledWith("PLATFORM", created.id, "ACCOUNT_LOCKED");
    expect(recordAuditEvent).toHaveBeenCalledWith(expect.objectContaining({ action: "iam.platform_account.mfa_reset" }), expect.anything());

    for (const call of [
      accounts.resetPlatformPassword(authz, actor, adminId),
      accounts.resetPlatformMfa(authz, actor, adminId),
      accounts.lockPlatformAccount(authz, actor, adminId, "tự khóa"),
    ]) {
      expect(await rejectionOf(call)).toEqual({ status: 409, code: "PLATFORM_ACCOUNT_SELF_ACTION" });
    }
  });

  it("khóa tài khoản quản trị: lý do, epoch tăng, thu hồi phiên, không cấp lại khi đang khóa; mở khóa; audit lỗi → 503 không khóa", async () => {
    const created = await accounts.createPlatformAccount(
      authz,
      actor,
      PlatformAccountCreateSchema.parse({
        username: `hung.${tag}`,
        email: `hung-${tag}@vexenhanh.test`,
        role: "PLATFORM_ADMIN",
        permissions: ["catalog:manage"],
      }),
    );
    createdPlatform.push(created.id);

    recordAuditEvent.mockRejectedValueOnce(new AuditWriteError(new Error("mongo down")));
    expect(await rejectionOf(accounts.lockPlatformAccount(authz, actor, created.id, "Nghỉ việc"))).toEqual({
      status: 503,
      code: "SERVICE_UNAVAILABLE",
    });
    expect((await prisma.platformAccount.findUniqueOrThrow({ where: { id: created.id } })).status).toBe("ACTIVE");

    await accounts.lockPlatformAccount(authz, actor, created.id, "Nghỉ việc");
    expect(await prisma.platformAccount.findUniqueOrThrow({ where: { id: created.id } })).toMatchObject({
      status: "LOCKED",
      lockedReason: "Nghỉ việc",
    });
    expect(revokeAllForSubject).toHaveBeenCalledWith("PLATFORM", created.id, "ACCOUNT_LOCKED");
    expect(await rejectionOf(accounts.resetPlatformPassword(authz, actor, created.id))).toEqual({
      status: 409,
      code: "ACCOUNT_STATE_CONFLICT",
    });
    await accounts.unlockPlatformAccount(authz, actor, created.id);
    expect((await prisma.platformAccount.findUniqueOrThrow({ where: { id: created.id } })).status).toBe("ACTIVE");
  });

  it("phân quyền (TASK-IAM-007): epoch tăng + thu hồi phiên trước / sau + audit trước / sau; trần theo vai trò; không tự sửa mình", async () => {
    const created = await accounts.createPlatformAccount(
      authz,
      actor,
      PlatformAccountCreateSchema.parse({
        username: `ke-toan.${tag}`,
        email: `ke-toan-${tag}@vexenhanh.test`,
        role: "PLATFORM_ADMIN",
        permissions: ["payment:monitor"],
      }),
    );
    createdPlatform.push(created.id);
    const before = await prisma.platformAccount.findUniqueOrThrow({ where: { id: created.id } });
    revokeAllForSubject.mockClear();

    const updated = await accounts.updatePlatformPermissions(
      authz,
      actor,
      created.id,
      PlatformPermissionsUpdateSchema.parse({ permissions: ["refund:manage", "payout:manage", "payment:monitor"], reason: "Kế toán" }),
    );
    expect(updated.permissions).toEqual(["payment:monitor", "payout:manage", "refund:manage"]);
    const after = await prisma.platformAccount.findUniqueOrThrow({ where: { id: created.id } });
    expect(after.authEpoch).toBe(before.authEpoch + 1);
    expect(after.permissions).toEqual(["payment:monitor", "payout:manage", "refund:manage"]);
    expect(revokeAllForSubject).toHaveBeenCalledTimes(2);
    expect(recordAuditEvent).toHaveBeenCalledWith(
      expect.objectContaining({
        action: "iam.platform_account.permissions_update",
        before: { permissions: ["payment:monitor"] },
        after: { permissions: ["payment:monitor", "payout:manage", "refund:manage"] },
        reason: "Kế toán",
      }),
      expect.anything(),
    );

    // Trần theo vai trò: hỗ trợ nền tảng không nhận được quyền đọc audit → 400, không thu hồi phiên ai.
    const support = list(await accounts.listPlatformAccounts(authz, actor, PlatformAccountListQuerySchema.parse({ q: `ngoc.${tag}` })));
    revokeAllForSubject.mockClear();
    expect(
      await rejectionOf(
        accounts.updatePlatformPermissions(authz, actor, support, PlatformPermissionsUpdateSchema.parse({ permissions: ["audit:read"], reason: "thử" })),
      ),
    ).toEqual({ status: 400, code: "PERMISSION_NOT_ASSIGNABLE" });
    expect(revokeAllForSubject).not.toHaveBeenCalled();

    expect(
      await rejectionOf(
        accounts.updatePlatformPermissions(authz, actor, adminId, PlatformPermissionsUpdateSchema.parse({ permissions: [], reason: "tự sửa" })),
      ),
    ).toEqual({ status: 409, code: "PLATFORM_ACCOUNT_SELF_ACTION" });
  });

  it("không leo thang (TASK-IAM-007): người thao tác chỉ cấp / gỡ quyền mình có, đọc lại từ DB; mất `access:manage` → 403", async () => {
    const limited = await accounts.createPlatformAccount(
      authz,
      actor,
      PlatformAccountCreateSchema.parse({
        username: `nhan-su.${tag}`,
        email: `nhan-su-${tag}@vexenhanh.test`,
        role: "PLATFORM_ADMIN",
        permissions: ["access:manage", "content:manage"],
      }),
    );
    const target = await accounts.createPlatformAccount(
      authz,
      actor,
      PlatformAccountCreateSchema.parse({
        username: `bien-tap.${tag}`,
        email: `bien-tap-${tag}@vexenhanh.test`,
        role: "PLATFORM_ADMIN",
        permissions: ["content:manage", "audit:read"],
      }),
    );
    createdPlatform.push(limited.id, target.id);
    const limitedActor = { sub: limited.id, role: "PLATFORM_ADMIN", scope: "platform" as const, perms: ["access:manage", "content:manage"] };
    const update = (permissions: string[]) =>
      accounts.updatePlatformPermissions(authz, limitedActor, target.id, PlatformPermissionsUpdateSchema.parse({ permissions, reason: "đổi" }));

    // Thêm quyền mình không có, hoặc gỡ quyền mình không có → 403; tạo tài khoản đủ quyền → 403.
    expect(await rejectionOf(update(["content:manage", "audit:read", "payout:manage"]))).toEqual({ status: 403, code: "PERMISSION_GRANT_FORBIDDEN" });
    expect(await rejectionOf(update(["content:manage"]))).toEqual({ status: 403, code: "PERMISSION_GRANT_FORBIDDEN" });
    expect(
      await rejectionOf(
        accounts.createPlatformAccount(
          authz,
          limitedActor,
          PlatformAccountCreateSchema.parse({
            username: `leo-thang.${tag}`,
            email: `leo-thang-${tag}@vexenhanh.test`,
            role: "PLATFORM_ADMIN",
            permissions: ["access:manage", "finance:configure"],
          }),
        ),
      ),
    ).toEqual({ status: 403, code: "PERMISSION_GRANT_FORBIDDEN" });
    // Gỡ quyền mình có, giữ nguyên quyền mình không có → được.
    expect((await update(["audit:read"])).permissions).toEqual(["audit:read"]);

    // Quyền đọc lại từ DB: claim còn `access:manage` nhưng DB đã gỡ → 403.
    await prisma.withSystem((tx) => tx.platformAccount.update({ where: { id: limited.id }, data: { permissions: ["content:manage"] } }));
    expect(await rejectionOf(update(["audit:read", "content:manage"]))).toEqual({ status: 403, code: "PERMISSION_DENIED" });
  });
});

function list(page: { items: { id: string; username: string }[] }): string {
  const item = page.items[0];
  if (!item) {
    throw new Error("Không thấy tài khoản cần thử.");
  }
  return item.id;
}
