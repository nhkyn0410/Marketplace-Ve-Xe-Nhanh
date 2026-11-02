import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { AuditWriteError, type AuditEventInput, type AuditService } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { platformScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { EmailNotifier, OperatorStatusEmailMessage } from "../external/notification/email-notifier";
import type { Authorization } from "../iam/role/authorization";
import type { SessionService } from "../iam/session/session.service";
import { AdminOperatorService } from "./admin-operator.service";
import { OperatorListQuerySchema } from "./dto/admin-operator.dto";

/** Admin quản lý nhà xe (FR-ADM-02/03, UC-23 A6) trên Postgres THẬT bằng role APP. */
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

describe.skipIf(!url && !requireDb)("Admin nhà xe — Postgres thật, role app", () => {
  let prisma: PrismaService;
  let operators: AdminOperatorService;
  const tag = randomUUID().slice(0, 8);
  const operatorId = randomUUID();
  const otherId = randomUUID();
  const ownerId = randomUUID();
  const employeeId = randomUUID();
  const slug = `adm002-${tag}`;
  const actor = { sub: randomUUID(), role: "PLATFORM_ADMIN" };
  const authz: Authorization = { permission: "user:manage", scope: "any", db: platformScope() };
  const recordAuditEvent = vi.fn(async (_event: AuditEventInput, _options?: unknown) => undefined);
  const revokeAllForSubject = vi.fn(async () => 1);
  const sendOperatorStatusChanged = vi.fn(async (_message: OperatorStatusEmailMessage) => undefined);
  const list = (query: Record<string, unknown> = {}) => operators.list(authz, OperatorListQuerySchema.parse(query));

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    operators = new AdminOperatorService(
      prisma,
      { recordAuditEvent } as unknown as AuditService,
      { revokeAllForSubject } as unknown as SessionService,
      { sendOtp: async () => undefined, sendOperatorStatusChanged } as EmailNotifier,
    );
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.createMany({
        data: [
          { id: operatorId, operatorSlug: slug, displayName: `Nhà xe khóa ${tag}` },
          { id: otherId, operatorSlug: `adm002-o-${tag}`, displayName: `Nhà xe khác ${tag}` },
        ],
      });
      await tx.operatorAccount.create({
        data: {
          id: ownerId,
          operatorId,
          operatorSlug: slug,
          username: "owner01",
          passwordHash: "x",
          contactEmail: `owner@${tag}.test`,
          credentialDeliveryPending: true,
          passwordChangeRequired: true,
          temporaryPasswordExpiresAt: new Date(Date.now() + 3_600_000),
        },
      });
      await tx.employeeAccount.create({
        data: { id: employeeId, operatorId, username: "nv.tai01", passwordHash: "x", role: "DRIVER" },
      });
    });
  }, 30_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      const ids = { in: [operatorId, otherId] };
      await tx.employeeAccount.deleteMany({ where: { operatorId: ids } });
      await tx.operatorAccount.deleteMany({ where: { operatorId: ids } });
      await tx.operatorProfile.deleteMany({ where: { id: ids } });
    });
    await prisma.$disconnect();
  });

  beforeEach(() => {
    recordAuditEvent.mockReset();
    recordAuditEvent.mockResolvedValue(undefined);
    revokeAllForSubject.mockClear();
    sendOperatorStatusChanged.mockReset();
    sendOperatorStatusChanged.mockResolvedValue(undefined);
  });

  it("danh sách: tìm theo mã / email chủ nhà xe, chủ nhà xe + cờ chờ gửi mật khẩu, lọc trạng thái, tổng", async () => {
    const bySlug = await list({ q: slug });
    expect(bySlug.items).toEqual([
      expect.objectContaining({
        id: operatorId,
        name: `Nhà xe khóa ${tag}`,
        status: "ACTIVE",
        applicationId: null,
        routeCount: 0,
        openTripCount: 0,
        owner: { id: ownerId, username: `${slug}/owner01`, email: `owner@${tag}.test`, credentialDeliveryPending: true },
      }),
    ]);
    expect((await list({ q: `owner@${tag}` })).items.map((item) => item.id)).toEqual([operatorId]);
    expect((await list({ q: tag })).total).toBe(2);
    expect((await list({ q: tag, status: "SUSPENDED" })).total).toBe(0);
    expect((await list({ q: "%" })).items.map((item) => item.id)).not.toContain(operatorId);
  });

  it("tạm khóa: lý do + thời điểm, audit trong transaction, thu hồi phiên chủ nhà xe + nhân viên, email; khóa lần nữa 409; mở khóa xóa lý do", async () => {
    await operators.suspend(authz, actor, operatorId, "Vi phạm chất lượng dịch vụ");
    const stored = await prisma.operatorProfile.findUniqueOrThrow({ where: { id: operatorId } });
    expect(stored).toMatchObject({ status: "SUSPENDED", suspendedReason: "Vi phạm chất lượng dịch vụ" });
    expect(stored.suspendedAt).toBeInstanceOf(Date);
    expect(recordAuditEvent).toHaveBeenCalledWith(
      expect.objectContaining({ action: "operator.suspend", targetId: operatorId, operatorId, reason: "Vi phạm chất lượng dịch vụ" }),
      expect.objectContaining({ timeoutMs: 2_000, deadline: expect.any(Number) }),
    );
    expect(revokeAllForSubject).toHaveBeenCalledWith("OPERATOR", ownerId, "ACCOUNT_LOCKED");
    expect(revokeAllForSubject).toHaveBeenCalledWith("EMPLOYEE", employeeId, "ACCOUNT_LOCKED");
    expect(sendOperatorStatusChanged).toHaveBeenCalledWith({
      email: `owner@${tag}.test`,
      operatorName: `Nhà xe khóa ${tag}`,
      suspended: true,
      reason: "Vi phạm chất lượng dịch vụ",
    });
    expect((await list({ q: slug })).items[0]).toMatchObject({ status: "SUSPENDED", suspendedReason: "Vi phạm chất lượng dịch vụ" });
    expect(await rejectionOf(operators.suspend(authz, actor, operatorId, "lần nữa"))).toEqual({
      status: 409,
      code: "OPERATOR_STATE_INVALID",
    });

    await operators.unsuspend(authz, actor, operatorId);
    expect(await prisma.operatorProfile.findUniqueOrThrow({ where: { id: operatorId } })).toMatchObject({
      status: "ACTIVE",
      suspendedReason: null,
      suspendedAt: null,
    });
    expect(sendOperatorStatusChanged).toHaveBeenLastCalledWith(expect.objectContaining({ suspended: false }));
    expect(await rejectionOf(operators.unsuspend(authz, actor, randomUUID()))).toEqual({ status: 404, code: "OPERATOR_NOT_FOUND" });
  });

  it("audit lỗi → 503, nhà xe vẫn hoạt động, không thu hồi phiên; email lỗi không làm hỏng việc khóa", async () => {
    recordAuditEvent.mockRejectedValueOnce(new AuditWriteError(new Error("mongo down")));
    expect(await rejectionOf(operators.suspend(authz, actor, otherId, "Kiểm thử audit"))).toEqual({
      status: 503,
      code: "SERVICE_UNAVAILABLE",
    });
    expect((await prisma.operatorProfile.findUniqueOrThrow({ where: { id: otherId } })).status).toBe("ACTIVE");
    expect(revokeAllForSubject).not.toHaveBeenCalled();

    sendOperatorStatusChanged.mockRejectedValueOnce(new Error("domain not verified"));
    await operators.suspend(authz, actor, operatorId, "Email lỗi vẫn khóa");
    expect((await prisma.operatorProfile.findUniqueOrThrow({ where: { id: operatorId } })).status).toBe("SUSPENDED");
    await operators.unsuspend(authz, actor, operatorId);
  });
});
