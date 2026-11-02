import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { parseAppConfig } from "../config/env.config";
import { platformScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { Authorization } from "../iam/role/authorization";
import { AdminAuditLogService, maskSnapshot } from "./admin-audit-log.service";
import type { AuditEventInput, AuditService } from "./audit.service";
import { connectAuditForTest } from "./audit.testing";
import { AuditLogListQuerySchema } from "./dto/admin-audit-log.dto";

/**
 * Màn Nhật ký audit của Admin (UC-30, FR-ADM-16) trên Mongo + Postgres THẬT (role app). Collection audit chỉ ghi
 * thêm nên dữ liệu thử không xóa được: bản ghi đặt ở một khoảng giờ ngẫu nhiên năm 2001 và mọi truy vấn lọc đúng
 * khoảng đó.
 */
const url = process.env.DATABASE_URL;
const mongoUrl = process.env.MONGODB_AUDIT_URI;
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

describe.skipIf((!url || !mongoUrl) && !requireDb)("Admin nhật ký audit — Mongo + Postgres thật", () => {
  let prisma: PrismaService;
  let audit: AuditService;
  let close: () => Promise<void>;
  let logs: AdminAuditLogService;
  const tag = randomUUID().slice(0, 8);
  const tenant = randomUUID();
  const slug = `adm015-${tag}`;
  const platformId = randomUUID();
  const ownerId = randomUUID();
  const authz: Authorization = { permission: "audit:read", scope: "any", db: platformScope() };
  const viewer = { sub: platformId, role: "PLATFORM_ADMIN" };
  // Một giờ ngẫu nhiên trong năm 2001 — không lẫn với dữ liệu của test khác hay của màn thật.
  const base = new Date(Date.UTC(2001, 0, 1) + Math.floor(Math.random() * 360 * 24) * 3_600_000);
  const at = (seconds: number) => new Date(base.getTime() + seconds * 1_000);
  const range = { from: base.toISOString(), to: at(3_600).toISOString() };
  const appId = `app-${tag}`;

  const events: AuditEventInput[] = [
    {
      actorId: platformId,
      actorRole: "PLATFORM_ADMIN",
      action: "operator_application.request_info",
      targetType: "operator_application",
      targetId: appId,
      before: { status: "SUBMITTED", passwordHash: "x$y", bankAccountNumber: "0123456789" },
      after: { status: "NEEDS_INFO" },
      reason: "Thiếu giấy phép kinh doanh",
      createdAt: at(10),
    },
    {
      actorId: ownerId,
      actorRole: "OPERATOR",
      action: "auth.login.failure",
      targetType: "auth_account",
      targetId: ownerId,
      operatorId: tenant,
      after: { ip: "113.161.20.30", userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64) Chrome/120.0", result: "failure" },
      createdAt: at(20),
    },
    { action: "stop_point_catalog.update", targetType: "stop_point_catalog", targetId: `sp-${tag}`, createdAt: at(30) },
    {
      actorId: platformId,
      actorRole: "PLATFORM_ADMIN",
      action: "operator_application.approve",
      targetType: "operator_application",
      targetId: appId,
      operatorId: tenant,
      after: { operatorSlug: slug, ownerUsername: "owner01", contactEmail: "owner@nhaxe.vn" },
      createdAt: at(40),
    },
  ];

  const list = (query: Record<string, unknown> = {}) => logs.list(authz, AuditLogListQuerySchema.parse({ ...range, ...query }));
  const actions = async (query: Record<string, unknown> = {}) => (await list(query)).items.map((item) => item.action);

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    ({ audit, close } = await connectAuditForTest(mongoUrl!));
    logs = new AdminAuditLogService(prisma, audit);
    await prisma.withSystem(async (tx) => {
      await tx.platformAccount.create({
        data: { id: platformId, username: `adm-audit-${tag}`, passwordHash: "x", role: "PLATFORM_ADMIN" },
      });
      await tx.operatorProfile.create({ data: { id: tenant, operatorSlug: slug, displayName: `Nhà xe audit ${tag}` } });
      await tx.operatorAccount.create({
        data: { id: ownerId, operatorId: tenant, operatorSlug: slug, username: "owner01", passwordHash: "x" },
      });
    });
    for (const event of events) {
      await audit.recordAuditEvent(event);
    }
  }, 30_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      await tx.operatorAccount.deleteMany({ where: { operatorId: tenant } });
      await tx.operatorProfile.deleteMany({ where: { id: tenant } });
      await tx.platformAccount.deleteMany({ where: { id: platformId } });
    });
    await prisma.$disconnect();
    await close?.();
  });

  it("danh sách: mới nhất trước, tên đăng nhập người thực hiện, nhà xe, kết quả, tác vụ nền; cursor + tổng", async () => {
    const page = await list({ limit: 3 });
    expect(page.total).toBe(4);
    expect(page.items.map((item) => item.action)).toEqual([
      "operator_application.approve",
      "stop_point_catalog.update",
      "auth.login.failure",
    ]);
    expect(page.items[0]).toMatchObject({
      actorName: `platform/adm-audit-${tag}`,
      actorType: "PLATFORM",
      module: "OPERATOR_KYC",
      result: "SUCCESS",
      operator: { id: tenant, name: `Nhà xe audit ${tag}` },
    });
    expect(page.items[1]).toMatchObject({ actorId: null, actorName: null, actorType: "SYSTEM", module: "STOP_POINT", operator: null });
    expect(page.items[2]).toMatchObject({ actorName: `${slug}/owner01`, actorType: "OPERATOR", module: "AUTH", result: "FAILURE" });
    const next = await list({ limit: 3, cursor: page.nextCursor });
    expect(next.items).toEqual([expect.objectContaining({ action: "operator_application.request_info", reason: "Thiếu giấy phép kinh doanh" })]);
    expect(next.nextCursor).toBeNull();
  });

  it("lọc loại người thực hiện / phân hệ / kết quả; tìm theo tên đăng nhập, theo nhà xe `slug/`, theo mã đối tượng", async () => {
    expect(await actions({ actorType: "PLATFORM" })).toEqual(["operator_application.approve", "operator_application.request_info"]);
    expect(await actions({ actorType: "SYSTEM" })).toEqual(["stop_point_catalog.update"]);
    expect(await actions({ actorType: "PASSENGER" })).toEqual([]);
    expect(await actions({ module: "AUTH" })).toEqual(["auth.login.failure"]);
    expect(await actions({ result: "FAILURE" })).toEqual(["auth.login.failure"]);
    expect(await actions({ result: "SUCCESS", module: "OPERATOR_KYC" })).toHaveLength(2);
    expect(await actions({ q: `platform/adm-audit-${tag}` })).toHaveLength(2);
    expect(await actions({ q: `${slug}/` })).toEqual(["auth.login.failure"]);
    expect(await actions({ q: appId })).toEqual(["operator_application.approve", "operator_application.request_info"]);
    expect(await actions({ q: "%" })).toEqual([]);
  });

  it("chi tiết: che dữ liệu nhạy cảm, IP + thiết bị, chuỗi bản ghi cùng đối tượng; lượt xem được ghi audit", async () => {
    const [approve, , login, requestInfo] = (await list()).items;
    const detail = await logs.get(authz, viewer, approve!.id);
    expect(detail.after).toMatchObject({ contactEmail: "o***@nhaxe.vn", operatorSlug: slug });
    expect(detail.related.map((item) => item.id)).toEqual([approve!.id, requestInfo!.id]);

    const masked = await logs.get(authz, viewer, requestInfo!.id);
    expect(masked.before).toEqual({ status: "SUBMITTED", passwordHash: "[đã ẩn]", bankAccountNumber: "••••6789" });
    expect(masked.reason).toBe("Thiếu giấy phép kinh doanh");

    const loginDetail = await logs.get(authz, viewer, login!.id);
    expect(loginDetail).toMatchObject({ ip: "113.161.20.*", device: "Chrome on Windows" });
    expect(loginDetail.after).toMatchObject({ ip: "113.161.20.*", userAgent: "Chrome on Windows" });

    const views = await logs.list(authz, AuditLogListQuerySchema.parse({ module: "AUDIT", q: approve!.id }));
    expect(views.items).toEqual([
      expect.objectContaining({ action: "audit.event.view", actorId: platformId, targetType: "audit_event", targetId: approve!.id }),
    ]);

    expect(await rejectionOf(logs.get(authz, viewer, "0123456789abcdef01234567"))).toEqual({
      status: 404,
      code: "AUDIT_LOG_NOT_FOUND",
    });
  });

  it("che theo tên trường, đệ quy: email, số điện thoại, số tài khoản, bí mật, IP", () => {
    expect(
      maskSnapshot({
        contact: { email: "khanh@example.com", phone: "0901234567" },
        accounts: [{ accountNumber: "9704123456789012" }],
        otpCode: "123456",
        ip: "10.0.0.5",
        name: "Giữ nguyên",
      }),
    ).toEqual({
      contact: { email: "k***@example.com", phone: "•••••••567" },
      accounts: [{ accountNumber: "••••9012" }],
      otpCode: "[đã ẩn]",
      ip: "10.0.0.*",
      name: "Giữ nguyên",
    });
  });
});
