import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import type { AuditService } from "../../audit/audit.service";
import { parseAppConfig } from "../../config/env.config";
import { tenantScope } from "../../database/db-scope";
import { PrismaService } from "../../database/prisma.service";
import type { EmailNotifier, TemporaryPasswordEmailMessage } from "../../external/notification/email-notifier";
import { CredentialService } from "../auth/credential.service";
import type { MfaService } from "../auth/mfa.service";
import type { Authorization } from "../role/authorization";
import type { SessionService } from "../session/session.service";
import type { AccountActor } from "./account.types";
import { ManagerCreateSchema, ManagerUpdateSchema } from "./dto/operator-manager.dto";
import { OperatorManagerService } from "./operator-manager.service";
import type { TemporaryCredentialEmailLimiter } from "./temporary-credential-email-limiter";

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

/** Tài khoản quản lý nhà xe (TASK-IAM-007) trên Postgres THẬT bằng role APP (RLS FORCE). */
describe.skipIf(!url && !requireDb)("Tài khoản quản lý nhà xe — Postgres thật, role app", () => {
  let prisma: PrismaService;
  let managers: OperatorManagerService;
  const credentials = new CredentialService();
  const tag = randomUUID().slice(0, 8);
  const tenant = randomUUID();
  const foreignTenant = randomUUID();
  const ownerId = randomUUID();
  const slug = `iam007-${tag}`;
  const foreignSlug = `iam007-foreign-${tag}`;
  const sent: TemporaryPasswordEmailMessage[] = [];
  const sendTemporaryPassword = vi.fn(async (message: TemporaryPasswordEmailMessage) => {
    sent.push(message);
  });
  const recordAuditEvent = vi.fn(async () => undefined);
  const revokeAllForSubject = vi.fn(async () => 1);
  const mfa = { enabledSubjects: vi.fn(async () => new Set<string>()), resetForSubject: vi.fn(async () => 1) };
  const owner: AccountActor = { sub: ownerId, sid: randomUUID(), scope: "operator", role: "OPERATOR_OWNER", operatorId: tenant, operatorSlug: slug };
  const foreignOwner: AccountActor = { ...owner, sub: randomUUID(), operatorId: foreignTenant, operatorSlug: foreignSlug };
  const authz = (operatorId: string): Authorization => ({ permission: "manager:manage", scope: "tenant", db: tenantScope(operatorId) });
  const input = (username: string, permissions: string[]) =>
    ManagerCreateSchema.parse({ username, contactEmail: `${username}@${tag}.test`, permissions, reason: "Cấp tài khoản quản lý" });

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    const problems = await prisma.rlsProblems();
    if (problems.length) {
      throw new Error(`IAM-007 integration requires app role with FORCE RLS: ${problems.join("; ")}`);
    }
    managers = new OperatorManagerService(
      prisma,
      credentials,
      { sendOtp: async () => undefined, sendTemporaryPassword } as EmailNotifier,
      { recordAuditEvent } as unknown as AuditService,
      { hasRecentReauth: async () => true, revokeAllForSubject, lastLoginAt: async () => new Map() } as unknown as SessionService,
      mfa as unknown as MfaService,
      { reserve: async () => undefined } as unknown as TemporaryCredentialEmailLimiter,
    );
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.createMany({
        data: [
          { id: tenant, operatorSlug: slug, displayName: "Nhà xe IAM-007" },
          { id: foreignTenant, operatorSlug: foreignSlug, displayName: "Nhà xe khác" },
        ],
      });
      await tx.operatorAccount.create({
        data: { id: ownerId, operatorId: tenant, operatorSlug: slug, username: "chu-xe", passwordHash: "x", role: "OPERATOR_OWNER" },
      });
    });
  }, 30_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      await tx.operatorAccount.deleteMany({ where: { operatorId: { in: [tenant, foreignTenant] } } });
      await tx.operatorProfile.deleteMany({ where: { id: { in: [tenant, foreignTenant] } } });
    });
    await prisma.$disconnect();
  });

  beforeEach(() => {
    sent.length = 0;
    revokeAllForSubject.mockClear();
    recordAuditEvent.mockClear();
  });

  it("chủ nhà xe cấp tài khoản quản lý: role OPERATOR_MANAGER, quyền lưu theo thứ tự danh mục, mật khẩu tạm gửi email; trùng tên Owner → 409", async () => {
    const created = await managers.create(owner, authz(tenant), input("ke-toan", ["finance:read", "booking:read"]));
    expect(created).toMatchObject({
      username: `${slug}/ke-toan`,
      permissions: ["booking:read", "finance:read"],
      status: "ACTIVE",
      passwordChangeRequired: true,
      credentialDeliveryPending: false,
    });
    const row = await prisma.withSystem((tx) => tx.operatorAccount.findUniqueOrThrow({ where: { id: created.id } }));
    expect(row).toMatchObject({ role: "OPERATOR_MANAGER", operatorId: tenant, permissions: ["booking:read", "finance:read"] });
    expect(sent).toEqual([expect.objectContaining({ email: `ke-toan@${tag}.test`, loginIdentifier: `${slug}/ke-toan` })]);
    expect(await credentials.verify(sent[0]!.temporaryPassword, row.passwordHash)).toBe(true);

    expect(await rejectionOf(managers.create(owner, authz(tenant), input("chu-xe", [])))).toEqual({
      status: 409,
      code: "ACCOUNT_USERNAME_CONFLICT",
    });
  });

  it("đổi quyền: epoch tăng, thu hồi phiên trước + sau, audit; không đổi gì → không đá ai ra; khóa → LOCKED", async () => {
    const created = await managers.create(owner, authz(tenant), input("dieu-hanh", ["trip:manage"]));
    const before = await prisma.withSystem((tx) => tx.operatorAccount.findUniqueOrThrow({ where: { id: created.id } }));
    revokeAllForSubject.mockClear();

    const updated = await managers.update(owner, authz(tenant), created.id, ManagerUpdateSchema.parse({ permissions: ["trip:manage", "vehicle:manage"], reason: "Thêm xe" }));
    expect(updated.permissions).toEqual(["vehicle:manage", "trip:manage"]);
    const after = await prisma.withSystem((tx) => tx.operatorAccount.findUniqueOrThrow({ where: { id: created.id } }));
    expect(after.authEpoch).toBe(before.authEpoch + 1);
    expect(revokeAllForSubject).toHaveBeenCalledTimes(2);
    expect(revokeAllForSubject).toHaveBeenCalledWith("OPERATOR", created.id, "ADMIN_FORCE");
    expect(recordAuditEvent).toHaveBeenCalledWith(expect.objectContaining({ action: "iam.operator_manager.update.intent", reason: "Thêm xe" }));

    revokeAllForSubject.mockClear();
    await managers.update(owner, authz(tenant), created.id, ManagerUpdateSchema.parse({ permissions: ["vehicle:manage", "trip:manage"], reason: "Không đổi" }));
    expect(revokeAllForSubject).not.toHaveBeenCalled();

    const locked = await managers.update(owner, authz(tenant), created.id, ManagerUpdateSchema.parse({ status: "LOCKED", reason: "Nghỉ việc" }));
    expect(locked.status).toBe("LOCKED");
    expect(await rejectionOf(managers.resetPassword(owner, authz(tenant), created.id, "cấp lại"))).toEqual({ status: 409, code: "ACCOUNT_STATE_CONFLICT" });
  });

  it("đặt lại 2FA: xóa TOTP + mật khẩu tạm mới, epoch tăng", async () => {
    const created = await managers.create(owner, authz(tenant), input("cskh", ["support:respond"]));
    const before = await prisma.withSystem((tx) => tx.operatorAccount.findUniqueOrThrow({ where: { id: created.id } }));
    sent.length = 0;
    await managers.resetMfa(owner, authz(tenant), created.id, "Mất điện thoại");
    const after = await prisma.withSystem((tx) => tx.operatorAccount.findUniqueOrThrow({ where: { id: created.id } }));
    expect(mfa.resetForSubject).toHaveBeenCalledWith("OPERATOR", created.id);
    expect(after.authEpoch).toBe(before.authEpoch + 1);
    expect(after.passwordHash).not.toBe(before.passwordHash);
    expect(await credentials.verify(sent[0]!.temporaryPassword, after.passwordHash)).toBe(true);
  });

  it("tenant: chủ nhà xe khác không thấy / không sửa được (404); dòng Owner không đụng được qua API quản lý (404)", async () => {
    const created = await managers.create(owner, authz(tenant), input("kho-van", ["vehicle:manage"]));
    expect((await managers.list(foreignOwner, authz(foreignTenant))).items).toEqual([]);
    expect(
      await rejectionOf(managers.update(foreignOwner, authz(foreignTenant), created.id, ManagerUpdateSchema.parse({ status: "LOCKED", reason: "lấn tenant" }))),
    ).toEqual({ status: 404, code: "ACCOUNT_NOT_FOUND" });
    expect(await rejectionOf(managers.update(owner, authz(tenant), ownerId, ManagerUpdateSchema.parse({ status: "LOCKED", reason: "khóa chủ" })))).toEqual({
      status: 404,
      code: "ACCOUNT_NOT_FOUND",
    });
    // Token tenant A nhưng ngữ cảnh DB tenant B → từ chối trước khi chạm DB.
    expect(await rejectionOf(managers.list(owner, authz(foreignTenant)))).toEqual({ status: 403, code: "TENANT_SCOPE_VIOLATION" });
    expect((await managers.list(owner, authz(tenant))).items.map((item) => item.username)).toContain(`${slug}/kho-van`);
  });

  it("tài khoản quản lý không cấp được tài khoản quản lý, kể cả khi có token đủ quyền tick", async () => {
    const manager: AccountActor = {
      ...owner,
      sub: randomUUID(),
      role: "OPERATOR_MANAGER",
      perms: ["vehicle:manage", "route:manage", "trip:manage", "booking:read", "finance:read", "employee:manage", "support:respond", "promotion:manage"],
    };
    expect(await rejectionOf(managers.create(manager, authz(tenant), input("leo-thang", ["trip:manage"])))).toEqual({ status: 403, code: "PERMISSION_DENIED" });
  });

  it("DB CHECK: Owner không mang danh sách quyền, tài khoản quản lý bắt buộc mang", async () => {
    await expect(
      prisma.withSystem((tx) =>
        tx.operatorAccount.create({
          data: { operatorId: tenant, operatorSlug: slug, username: `owner2-${tag}`, passwordHash: "x", role: "OPERATOR_OWNER", permissions: [] },
        }),
      ),
    ).rejects.toThrow();
    await expect(
      prisma.withSystem((tx) =>
        tx.operatorAccount.create({
          data: { operatorId: tenant, operatorSlug: slug, username: `mgr-${tag}`, passwordHash: "x", role: "OPERATOR_MANAGER" },
        }),
      ),
    ).rejects.toThrow();
  });
});
