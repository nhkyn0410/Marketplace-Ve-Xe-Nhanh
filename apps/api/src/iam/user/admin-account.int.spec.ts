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
  PassengerListQuerySchema,
  PlatformAccountCreateSchema,
  PlatformAccountListQuerySchema,
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
  const passengerId = `psg${tag}`;
  const createdPlatform: string[] = [];
  const actor = { sub: adminId, role: "PLATFORM_ADMIN", scope: "platform" as const };
  const authz: Authorization = { permission: "user:manage", scope: "any", db: platformScope() };
  const recordAuditEvent = vi.fn(async (_event: AuditEventInput, _options?: unknown) => undefined);
  const revokeAllForSubject = vi.fn(async () => 1);
  const lastLoginAt = vi.fn(async () => new Map<string, Date>());
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
      { reserve: async () => undefined } as unknown as TemporaryCredentialEmailLimiter,
      { sendOtp: async () => undefined, sendTemporaryPassword } as EmailNotifier,
    );
    await prisma.withSystem(async (tx) => {
      await tx.platformAccount.create({
        data: { id: adminId, username: `adm-u-${tag}`, passwordHash: "x", role: "PLATFORM_ADMIN" },
      });
      await tx.user.create({ data: { id: passengerId, email: `rider-${tag}@example.com`, name: `Khách ${tag}` } });
      await tx.account.create({ data: { id: randomUUID(), userId: passengerId, accountId: "g-1", providerId: "google" } });
      await tx.operatorProfile.create({ data: { id: operatorId, operatorSlug: `adm-u-${tag}`, displayName: `Nhà xe U ${tag}` } });
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
      await tx.operatorProfile.deleteMany({ where: { id: operatorId } });
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

  it("cấp tài khoản quản trị: mật khẩu tạm gửi email, phải đổi lần đầu; trùng tên → 409; gửi lỗi → chờ giao, cấp lại để gửi lại", async () => {
    const input = PlatformAccountCreateSchema.parse({ username: `Ngoc.${tag}`, email: `ngoc-${tag}@vexenhanh.test`, role: "PLATFORM_SUPPORT" });
    const created = await accounts.createPlatformAccount(authz, actor, input);
    createdPlatform.push(created.id);
    expect(created).toMatchObject({
      username: `platform/ngoc.${tag}`,
      email: `ngoc-${tag}@vexenhanh.test`,
      role: "PLATFORM_SUPPORT",
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
      PlatformAccountCreateSchema.parse({ username: `minh.${tag}`, email: `minh-${tag}@vexenhanh.test`, role: "PLATFORM_ADMIN" }),
    );
    createdPlatform.push(pending.id);
    expect(pending.credentialDeliveryPending).toBe(true);
    const resent = await accounts.resetPlatformPassword(authz, actor, pending.id);
    expect(resent.credentialDeliveryPending).toBe(false);

    const list = await accounts.listPlatformAccounts(authz, actor, PlatformAccountListQuerySchema.parse({ q: tag }));
    expect(list.items.map((item) => item.username)).toEqual(
      expect.arrayContaining([`platform/adm-u-${tag}`, `platform/ngoc.${tag}`, `platform/minh.${tag}`]),
    );
    expect(list.items.find((item) => item.id === adminId)?.isSelf).toBe(true);
  });

  it("cấp lại mật khẩu / đặt lại 2FA: mật khẩu tạm mới, epoch tăng, phiên bị thu hồi; 2FA xóa credential; không tự thao tác trên mình", async () => {
    const created = await accounts.createPlatformAccount(
      authz,
      actor,
      PlatformAccountCreateSchema.parse({ username: `lan.${tag}`, email: `lan-${tag}@vexenhanh.test`, role: "PLATFORM_SUPPORT" }),
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
      PlatformAccountCreateSchema.parse({ username: `hung.${tag}`, email: `hung-${tag}@vexenhanh.test`, role: "PLATFORM_ADMIN" }),
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
});
