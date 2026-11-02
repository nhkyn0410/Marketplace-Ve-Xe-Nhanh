import { describe, expect, it, vi } from "vitest";
import type { AuditService } from "../audit/audit.service";
import { tenantScope } from "../database/db-scope";
import type { PrismaService } from "../database/prisma.service";
import type { Authorization } from "../iam/role/authorization";
import { OperatorDepartureService } from "./operator-departure.service";

const actor = { sub: "owner-1", role: "OPERATOR_OWNER" };
const authz: Authorization = { permission: "trip:dispatch", scope: "tenant", db: tenantScope("tenant-a") };

function setup(status = "BOARDING", departedAt: Date | null = null) {
  const tx = { $queryRaw: vi.fn().mockResolvedValue([{ status, departedAt }]), trip: { updateMany: vi.fn().mockResolvedValue({ count: 1 }) } };
  const prisma = { withScope: vi.fn(async (_scope: unknown, work: (value: typeof tx) => Promise<unknown>) => work(tx)) };
  const audit = { recordAuditEvent: vi.fn().mockResolvedValue(undefined) };
  const service = new OperatorDepartureService(prisma as unknown as PrismaService, audit as unknown as AuditService);
  return { service, prisma, tx, audit };
}

describe("Điều phối xác nhận khởi hành thực tế", () => {
  it("dùng giờ máy chủ, kiểm tenant và ghi dấu vết người xác nhận", async () => {
    const ctx = setup();
    const before = Date.now();
    const result = await ctx.service.depart(actor, authz, "trip-1", { note: "Xe đã rời bến" });
    expect(Date.parse(result.departedAt)).toBeGreaterThanOrEqual(before);
    expect(Date.parse(result.departedAt)).toBeLessThanOrEqual(Date.now());
    expect(ctx.tx.trip.updateMany).toHaveBeenCalledWith(expect.objectContaining({ where: { id: "trip-1", operatorId: "tenant-a", status: "BOARDING", departedAt: null } }));
    expect(ctx.audit.recordAuditEvent).toHaveBeenCalledWith(expect.objectContaining({ actorId: "owner-1", operatorId: "tenant-a", action: "trip.departure_confirmed", after: { status: "DEPARTED", departedAt: result.departedAt } }));
  });

  it.each(["DEPARTED", "IN_PROGRESS", "COMPLETED"])("gửi lại ở %s giữ nguyên mốc đã ghi, không ghi thêm sự kiện", async (status) => {
    const actual = new Date("2026-10-27T00:30:00Z");
    const ctx = setup(status, actual);
    expect(await ctx.service.depart(actor, authz, "trip-1", {})).toEqual({ tripId: "trip-1", departedAt: actual.toISOString() });
    expect(ctx.tx.trip.updateMany).not.toHaveBeenCalled();
    expect(ctx.audit.recordAuditEvent).not.toHaveBeenCalled();
  });

  it.each(["DRAFT", "CANCELLED", "COMPLETED"])("từ chối %s chưa có mốc khởi hành", async (status) => {
    const ctx = setup(status);
    await expect(ctx.service.depart(actor, authz, "trip-1", {})).rejects.toMatchObject({ status: 409 });
    expect(ctx.tx.trip.updateMany).not.toHaveBeenCalled();
  });

  it("không tìm thấy chuyến tenant khác thì trả cùng404", async () => {
    const ctx = setup();
    ctx.tx.$queryRaw.mockResolvedValue([]);
    await expect(ctx.service.depart(actor, authz, "other-trip", {})).rejects.toMatchObject({ status: 404 });
  });

  it("quản lý thiếu quyền riêng không thể gọi service trực tiếp", async () => {
    const ctx = setup();
    await expect(ctx.service.depart({ sub: "manager-1", role: "OPERATOR_MANAGER", perms: [] }, authz, "trip-1", {})).rejects.toMatchObject({ status: 403 });
    expect(ctx.prisma.withScope).not.toHaveBeenCalled();
  });
});
