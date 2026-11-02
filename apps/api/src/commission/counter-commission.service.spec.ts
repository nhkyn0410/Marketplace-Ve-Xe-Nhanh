import { describe, expect, it, vi } from "vitest";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { platformScope, tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { Authorization } from "../iam/role/authorization";
import { CounterCommissionService } from "./counter-commission.service";

const authz: Authorization = { permission: "finance:configure", scope: "any", db: platformScope() };
const actor = { sub: "admin", role: "PLATFORM_ADMIN" };
const input = { operatorId: "op", idempotencyKey: "key", amount: "12000", reference: "REF01", reason: "Thu tháng 10" };
const row = { ...input, id: "settlement", amount: 12000n, createdBy: "platform:admin", createdAt: new Date("2030-01-01") };

function setup() {
  const tx = {
    $queryRaw: vi.fn(async () => [{ id: "op" }]),
    counterCommissionReceivable: { aggregate: vi.fn(async () => ({ _sum: { amount: 15000n } })), findMany: vi.fn(async () => []) },
    counterCommissionSettlement: { aggregate: vi.fn(async () => ({ _sum: { amount: 3000n } })), findMany: vi.fn(async () => []), findUnique: vi.fn(), create: vi.fn(async () => row) },
  };
  const prisma = { withScope: vi.fn(async (_scope: unknown, work: (value: typeof tx) => Promise<unknown>) => work(tx)) };
  const audit = { recordAuditEvent: vi.fn(async () => undefined) };
  return { tx, prisma, audit, service: new CounterCommissionService(prisma as unknown as PrismaService, audit as unknown as AuditService) };
}

describe("Manual counter commission settlement", () => {
  it("thu đúng số còn phải thu, khóa nhà xe và audit có người thu + chứng từ", async () => {
    const ctx = setup();
    expect(await ctx.service.settle(authz, actor, input)).toMatchObject({ amount: "12000", reference: "REF01" });
    expect(ctx.tx.$queryRaw).toHaveBeenCalledOnce();
    expect(ctx.tx.counterCommissionSettlement.create).toHaveBeenCalledWith({ data: expect.objectContaining({ amount: 12000n, createdBy: "platform:admin" }) });
    expect(ctx.audit.recordAuditEvent).toHaveBeenCalledWith(expect.objectContaining({ actorId: "admin", operatorId: "op", action: "counter.commission.settled" }), expect.anything());
  });
  it("không thu vượt phải thu và không ghi sổ khi dữ liệu sai", async () => {
    const ctx = setup();
    await expect(ctx.service.settle(authz, actor, { ...input, amount: "12001" })).rejects.toThrow();
    expect(ctx.tx.counterCommissionSettlement.create).not.toHaveBeenCalled();
  });
  it("retry cùng khóa trả cùng khoản thu; khóa dùng khác dữ liệu bị chặn", async () => {
    const ctx = setup();
    ctx.tx.counterCommissionSettlement.findUnique.mockResolvedValue(row);
    expect(await ctx.service.settle(authz, actor, input)).toMatchObject({ id: "settlement" });
    expect(ctx.tx.counterCommissionSettlement.create).not.toHaveBeenCalled();
    await expect(ctx.service.settle(authz, actor, { ...input, amount: "1" })).rejects.toThrow();
  });
  it("nhà xe và quyền đọc không được xác nhận đã thu phí", async () => {
    const ctx = setup();
    await expect(ctx.service.settle({ permission: "finance:read", scope: "tenant", db: tenantScope("op") }, actor, input)).rejects.toThrow();
    await expect(ctx.service.settle({ ...authz, permission: "finance:read" }, actor, input)).rejects.toThrow();
    expect(ctx.prisma.withScope).not.toHaveBeenCalled();
  });
  it("audit thất bại trả lỗi để transaction rollback", async () => {
    const ctx = setup();
    ctx.audit.recordAuditEvent.mockRejectedValue(new AuditWriteError("offline"));
    await expect(ctx.service.settle(authz, actor, input)).rejects.toMatchObject({ status: 503 });
  });
  it("báo cáo tổng dùng toàn lịch sử, bộ lọc ngày chỉ giới hạn chi tiết", async () => {
    const ctx = setup();
    expect(await ctx.service.overview(authz, { operatorId: "op", from: "2030-01-01T00:00:00Z" })).toMatchObject({ accrued: "15000", settled: "3000", outstanding: "12000" });
    expect(ctx.tx.counterCommissionReceivable.aggregate).toHaveBeenCalledWith({ where: { operatorId: "op" }, _sum: { amount: true } });
    expect(ctx.tx.counterCommissionReceivable.findMany).toHaveBeenCalledWith(expect.objectContaining({ where: { operatorId: "op", createdAt: { gte: new Date("2030-01-01") } } }));
  });
});
