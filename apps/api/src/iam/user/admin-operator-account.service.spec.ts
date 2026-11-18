import { randomUUID } from "node:crypto";
import { describe, expect, it, vi } from "vitest";
import { AuditWriteError, type AuditService } from "../../audit/audit.service";
import type { PrismaService } from "../../database/prisma.service";
import type { EmailNotifier } from "../../external/notification/email-notifier";
import { CredentialService } from "../auth/credential.service";
import type { MfaService } from "../auth/mfa.service";
import type { Authorization } from "../role/authorization";
import type { SessionService } from "../session/session.service";
import { AdminAccountService } from "./admin-account.service";
import { OperatorAccountListQuerySchema } from "./dto/admin-user.dto";
import type { TemporaryCredentialEmailLimiter } from "./temporary-credential-email-limiter";

const actor = { sub: randomUUID(), role: "PLATFORM_ADMIN", scope: "platform" as const };
const authz = { permission: "user:manage", scope: "any", db: { kind: "platform" } } as unknown as Authorization;

function setup(role: "OPERATOR_OWNER" | "OPERATOR_MANAGER" = "OPERATOR_OWNER") {
  const current = {
    id: randomUUID(), operatorId: randomUUID(), username: "owner01", contactEmail: "owner@example.test", role, status: "ACTIVE",
    passwordChangeRequired: false, credentialDeliveryPending: false, temporaryPasswordExpiresAt: null,
    createdAt: new Date(), version: 7,
    operator: { displayName: "Nhà xe kiểm thử", operatorSlug: "test-bus", status: "SUSPENDED" }
  };
  const updated = { ...current, version: 8, passwordChangeRequired: true, credentialDeliveryPending: true, temporaryPasswordExpiresAt: new Date(Date.now() + 86_400_000) };
  const operatorAccount = {
    findUnique: vi.fn().mockResolvedValue(current),
    findMany: vi.fn().mockResolvedValue([current]),
    count: vi.fn().mockResolvedValue(1),
    updateManyAndReturn: vi.fn().mockResolvedValue([updated]),
    updateMany: vi.fn().mockResolvedValue({ count: 1 })
  };
  const operatorProfile = { findMany: vi.fn().mockResolvedValue([{ id: current.operatorId, displayName: current.operator.displayName }]) };
  const tx = { operatorAccount, operatorProfile };
  const prisma = { withScope: vi.fn(async (_db: unknown, work: (value: typeof tx) => Promise<unknown>) => work(tx)) };
  const audit = { recordAuditEvent: vi.fn().mockResolvedValue(undefined) };
  const sessions = { revokeAllForSubject: vi.fn().mockResolvedValue(2), lastLoginAt: vi.fn().mockResolvedValue(new Map()) };
  const mfa = { enabledSubjects: vi.fn().mockResolvedValue(new Set([current.id])), resetForSubject: vi.fn() };
  const limiter = { reserve: vi.fn().mockResolvedValue(undefined) };
  const email = { sendOtp: vi.fn(), sendTemporaryPassword: vi.fn().mockResolvedValue(undefined) };
  const credentials = new CredentialService();
  const service = new AdminAccountService(
    prisma as unknown as PrismaService,
    audit as unknown as AuditService,
    sessions as unknown as SessionService,
    mfa as unknown as MfaService,
    credentials,
    limiter as unknown as TemporaryCredentialEmailLimiter,
    email as EmailNotifier
  );
  return { current, updated, operatorAccount, operatorProfile, prisma, audit, sessions, mfa, limiter, email, credentials, service };
}

describe("Admin khôi phục tài khoản nhà xe", () => {
  it.each(["OPERATOR_OWNER", "OPERATOR_MANAGER"] as const)("%s: chỉ email nhận mật khẩu, API / audit không lộ bí mật; thu hồi phiên và giữ MFA / tạm khóa nhà xe", async (role) => {
    const ctx = setup(role);
    const result = await ctx.service.resetOperatorPassword(authz, actor, ctx.current.id, "Hỗ trợ quên mật khẩu");
    const message = ctx.email.sendTemporaryPassword.mock.calls[0]![0];
    const mutation = ctx.operatorAccount.updateManyAndReturn.mock.calls[0]![0];
    expect(await ctx.credentials.verify(message.temporaryPassword, mutation.data.passwordHash)).toBe(true);
    expect(message.loginIdentifier).toBe("test-bus/owner01");
    expect(message.expiresAt.getTime() - Date.now()).toBeGreaterThan(23 * 3_600_000);
    expect(message.expiresAt.getTime() - Date.now()).toBeLessThanOrEqual(24 * 3_600_000);
    expect(mutation.where).toMatchObject({ id: ctx.current.id, operatorId: ctx.current.operatorId, version: 7, status: "ACTIVE" });
    expect(mutation.data).toMatchObject({ authEpoch: { increment: 1 }, passwordChangeRequired: true, credentialDeliveryPending: true });
    expect(mutation.data).not.toHaveProperty("status");
    expect(ctx.sessions.revokeAllForSubject).toHaveBeenCalledTimes(2);
    expect(ctx.sessions.revokeAllForSubject).toHaveBeenCalledWith("OPERATOR", ctx.current.id, "PASSWORD_RESET");
    expect(ctx.mfa.resetForSubject).not.toHaveBeenCalled();
    expect(result).toMatchObject({ role, mfaEnabled: true, operatorStatus: "SUSPENDED", status: "ACTIVE", credentialDeliveryPending: false });
    expect(JSON.stringify([result, ctx.audit.recordAuditEvent.mock.calls])).not.toContain(message.temporaryPassword);
    expect(result).not.toHaveProperty("passwordHash");
    expect(ctx.limiter.reserve).toHaveBeenCalledWith({ operatorId: ctx.current.operatorId, actorType: "platform", actorId: actor.sub, operatorAccountId: ctx.current.id });
  });

  it.each(["LOCKED", "DISABLED", "no-email", "missing"])("%s: không thay đổi credential, không gửi email hoặc thu hồi phiên", async (state) => {
    const ctx = setup();
    ctx.operatorAccount.findUnique.mockResolvedValue(state === "missing" ? null : { ...ctx.current, ...(state === "no-email" ? { contactEmail: null } : { status: state }) });
    await expect(ctx.service.resetOperatorPassword(authz, actor, ctx.current.id, "Hỗ trợ quên mật khẩu")).rejects.toMatchObject({ status: state === "missing" ? 404 : 409 });
    expect(ctx.operatorAccount.updateManyAndReturn).not.toHaveBeenCalled();
    expect(ctx.email.sendTemporaryPassword).not.toHaveBeenCalled();
    expect(ctx.sessions.revokeAllForSubject).not.toHaveBeenCalled();
    expect(ctx.limiter.reserve).not.toHaveBeenCalled();
  });

  it("audit intent hoặc quota lỗi: dừng trước khi thay credential và thu hồi phiên", async () => {
    const ctx = setup();
    ctx.audit.recordAuditEvent.mockRejectedValueOnce(new AuditWriteError(new Error("audit down")));
    await expect(ctx.service.resetOperatorPassword(authz, actor, ctx.current.id, "Hỗ trợ quên mật khẩu")).rejects.toMatchObject({ status: 503 });
    ctx.limiter.reserve.mockRejectedValueOnce(new Error("rate limited"));
    await expect(ctx.service.resetOperatorPassword(authz, actor, ctx.current.id, "Hỗ trợ quên mật khẩu")).rejects.toThrow("rate limited");
    expect(ctx.operatorAccount.updateManyAndReturn).not.toHaveBeenCalled();
    expect(ctx.sessions.revokeAllForSubject).not.toHaveBeenCalled();
    expect(ctx.email.sendTemporaryPassword).not.toHaveBeenCalled();
  });

  it("gửi email lỗi: trả pending để Admin biết cần cấp lại; không bỏ cờ chờ giao", async () => {
    const ctx = setup();
    ctx.email.sendTemporaryPassword.mockRejectedValueOnce(new Error("mail down"));
    expect(await ctx.service.resetOperatorPassword(authz, actor, ctx.current.id, "Gửi lại mật khẩu")).toMatchObject({ credentialDeliveryPending: true, passwordChangeRequired: true });
    expect(ctx.operatorAccount.updateMany).not.toHaveBeenCalled();
  });

  it("xung đột lúc ghi mật khẩu: không gửi mật khẩu của request thua", async () => {
    const ctx = setup();
    ctx.operatorAccount.updateManyAndReturn.mockResolvedValueOnce([]);
    await expect(ctx.service.resetOperatorPassword(authz, actor, ctx.current.id, "Gửi lại mật khẩu")).rejects.toMatchObject({ status: 409 });
    expect(ctx.email.sendTemporaryPassword).not.toHaveBeenCalled();
  });

  it("hai yêu cầu cùng phiên bản: chỉ request cập nhật được account mới gửi mật khẩu", async () => {
    const ctx = setup();
    ctx.operatorAccount.updateManyAndReturn.mockResolvedValueOnce([ctx.updated]).mockResolvedValueOnce([]);
    const results = await Promise.allSettled([
      ctx.service.resetOperatorPassword(authz, actor, ctx.current.id, "Yêu cầu khôi phục thứ nhất"),
      ctx.service.resetOperatorPassword(authz, actor, ctx.current.id, "Yêu cầu khôi phục thứ hai")
    ]);
    expect(results.filter((result) => result.status === "fulfilled")).toHaveLength(1);
    expect(results.find((result) => result.status === "rejected")).toMatchObject({ reason: { status: 409 } });
    expect(ctx.email.sendTemporaryPassword).toHaveBeenCalledOnce();
  });

  it("xung đột trong lúc gửi email: không xóa pending của mật khẩu mới hơn", async () => {
    const ctx = setup();
    ctx.operatorAccount.updateMany.mockResolvedValueOnce({ count: 0 });
    await expect(ctx.service.resetOperatorPassword(authz, actor, ctx.current.id, "Gửi lại mật khẩu")).rejects.toMatchObject({ status: 409 });
    expect(ctx.operatorAccount.updateMany).toHaveBeenCalledWith(expect.objectContaining({ where: { id: ctx.current.id, operatorId: ctx.current.operatorId, version: 8, credentialDeliveryPending: true } }));
  });

  it("danh sách không lộ credential, lookup MFA / phiên thuộc namespace Operator", async () => {
    const ctx = setup();
    const result = await ctx.service.listOperatorAccounts(authz, OperatorAccountListQuerySchema.parse({ operatorId: ctx.current.operatorId }));
    expect(result.items).toEqual([expect.objectContaining({ id: ctx.current.id, username: "test-bus/owner01", mfaEnabled: true })]);
    expect(result.items[0]).not.toHaveProperty("version");
    expect(result.items[0]).not.toHaveProperty("passwordHash");
    expect(ctx.mfa.enabledSubjects).toHaveBeenCalledWith("OPERATOR", [ctx.current.id]);
    expect(ctx.sessions.lastLoginAt).toHaveBeenCalledWith("OPERATOR", [ctx.current.id]);
  });
});
