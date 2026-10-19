import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { AuditWriteError, type AuditEventInput, type AuditService } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { platformScope, tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { Authorization } from "../iam/role/authorization";
import { AdminCommissionService } from "./admin-commission.service";
import { CommissionRuleCreateSchema, CommissionRuleInputSchema } from "./dto/admin-commission.dto";

/** Hoa hồng mặc định + mức riêng theo nhà xe (FR-ADM-07, BR-31, AS-23) trên Postgres THẬT bằng role APP. */
const url = process.env.DATABASE_URL;
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
const DAY = 24 * 3_600_000;

async function rejectionOf(promise: Promise<unknown>): Promise<{ status?: number; code?: string }> {
  try {
    await promise;
    return {};
  } catch (error) {
    const response = (error as { getResponse?: () => { code?: string } }).getResponse?.();
    return { status: (error as { getStatus?: () => number }).getStatus?.(), code: response?.code };
  }
}

describe.skipIf(!url && !requireDb)("Hoa hồng — Postgres thật, role app", () => {
  let prisma: PrismaService;
  let commission: AdminCommissionService;
  const tag = randomUUID().slice(0, 8);
  const operatorA = randomUUID();
  const operatorB = randomUUID();
  const actor = { sub: randomUUID(), role: "PLATFORM_ADMIN" };
  const authz: Authorization = { permission: "finance:configure", scope: "any", db: platformScope() };
  const recordAuditEvent = vi.fn(async (_event: AuditEventInput, _options?: unknown) => undefined);
  const at = (days: number) => new Date(Date.now() + days * DAY).toISOString();
  const create = (overrides: Record<string, unknown> = {}) =>
    CommissionRuleCreateSchema.parse({
      operatorId: operatorA,
      rateBps: 400,
      effectiveFrom: at(10),
      effectiveTo: at(40),
      reason: "Ưu đãi đối tác khối lượng lớn",
      ...overrides,
    });
  const edit = (overrides: Record<string, unknown>) =>
    CommissionRuleInputSchema.parse({ reason: "Điều chỉnh", ...overrides });

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    commission = new AdminCommissionService(prisma, { recordAuditEvent } as unknown as AuditService);
    await prisma.withSystem((tx) =>
      tx.operatorProfile.createMany({
        data: [
          { id: operatorA, operatorSlug: `cms-a-${tag}`, displayName: `Hà Linh ${tag}` },
          { id: operatorB, operatorSlug: `cms-b-${tag}`, displayName: `Tâm Hạnh ${tag}` },
        ],
      }),
    );
  }, 30_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      const ids = { in: [operatorA, operatorB] };
      await tx.commissionRule.deleteMany({ where: { operatorId: ids } });
      await tx.operatorProfile.deleteMany({ where: { id: ids } });
    });
    await prisma.$disconnect();
  });

  beforeEach(() => {
    recordAuditEvent.mockReset();
    recordAuditEvent.mockResolvedValue(undefined);
  });

  const mine = async () => (await commission.overview(authz)).overrides.filter((rule) => ([operatorA, operatorB] as string[]).includes(rule.operatorId));

  it("mặc định 5% đang áp dụng; thêm mức riêng: bắt đầu ở quá khứ → 422, chồng thời gian → 409, nối tiếp được; audit có lý do", async () => {
    expect((await commission.overview(authz)).default).toMatchObject({ rateBps: 500 });
    expect(await rejectionOf(commission.create(authz, actor, create({ effectiveFrom: at(-1) })))).toEqual({
      status: 422,
      code: "COMMISSION_PERIOD_INVALID",
    });
    const first = await commission.create(authz, actor, create());
    expect(first).toMatchObject({ rateBps: 400, state: "SCHEDULED", operatorName: `Hà Linh ${tag}`, operatorSlug: `cms-a-${tag}` });
    expect(recordAuditEvent).toHaveBeenCalledWith(
      expect.objectContaining({ action: "commission_rule.create", operatorId: operatorA, reason: "Ưu đãi đối tác khối lượng lớn" }),
      expect.objectContaining({ deadline: expect.any(Number) }),
    );
    expect(await rejectionOf(commission.create(authz, actor, create({ effectiveFrom: at(20), effectiveTo: null })))).toEqual({
      status: 409,
      code: "COMMISSION_RULE_OVERLAP",
    });
    const next = await commission.create(authz, actor, create({ rateBps: 450, effectiveFrom: first.effectiveTo, effectiveTo: null }));
    expect(next.state).toBe("SCHEDULED");
    // Nhà xe khác không bị coi là chồng.
    await commission.create(authz, actor, create({ operatorId: operatorB }));
    expect(await rejectionOf(commission.create(authz, actor, create({ operatorId: randomUUID(), effectiveFrom: at(500), effectiveTo: null })))).toEqual({
      status: 404,
      code: "COMMISSION_RULE_NOT_FOUND",
    });
  });

  it("sửa: chưa bắt đầu → sửa tự do; đã bắt đầu → chỉ đổi ngày kết thúc (đổi tỷ lệ → 422, kết thúc ở quá khứ → 422)", async () => {
    const scheduled = (await mine()).find((rule) => rule.operatorId === operatorA && rule.rateBps === 400)!;
    const changed = await commission.update(
      authz,
      actor,
      scheduled.id,
      edit({ rateBps: 350, effectiveFrom: scheduled.effectiveFrom, effectiveTo: scheduled.effectiveTo }),
    );
    expect(changed.rateBps).toBe(350);
    expect(recordAuditEvent).toHaveBeenLastCalledWith(
      expect.objectContaining({ action: "commission_rule.update", before: expect.objectContaining({ rateBps: 400 }), after: expect.objectContaining({ rateBps: 350 }) }),
      expect.anything(),
    );

    // Mức đã bắt đầu chỉ tạo được bằng đường ghi thẳng (API không cho bắt đầu ở quá khứ).
    const started = await prisma.withSystem((tx) =>
      tx.commissionRule.create({
        data: { operatorId: operatorB, rateBps: 420, effectiveFrom: new Date(Date.now() - 5 * DAY), effectiveTo: new Date(Date.now() + 5 * DAY), reason: "test" },
      }),
    );
    const base = { rateBps: 420, effectiveFrom: started.effectiveFrom.toISOString() };
    expect(await rejectionOf(commission.update(authz, actor, started.id, edit({ ...base, rateBps: 300, effectiveTo: at(5) })))).toEqual({
      status: 422,
      code: "COMMISSION_RULE_LOCKED",
    });
    expect(await rejectionOf(commission.update(authz, actor, started.id, edit({ ...base, effectiveTo: at(-1) })))).toEqual({
      status: 422,
      code: "COMMISSION_PERIOD_INVALID",
    });
    const shortened = await commission.update(authz, actor, started.id, edit({ ...base, effectiveTo: at(2) }));
    expect(shortened).toMatchObject({ state: "ACTIVE", rateBps: 420 });
  });

  it("ngừng: chưa bắt đầu → Đã hủy; đang áp dụng → kết thúc ngay (Hết hiệu lực); ngừng lần nữa → 422", async () => {
    const rules = await mine();
    const scheduled = rules.find((rule) => rule.operatorId === operatorA && rule.state === "SCHEDULED")!;
    expect(await commission.cancel(authz, actor, scheduled.id, "Đối tác rút")).toMatchObject({ state: "CANCELLED", cancelReason: "Đối tác rút" });
    const active = rules.find((rule) => rule.operatorId === operatorB && rule.state === "ACTIVE")!;
    const stopped = await commission.cancel(authz, actor, active.id, "Hết hợp đồng");
    expect(stopped.state).toBe("EXPIRED");
    expect(new Date(stopped.effectiveTo!).getTime()).toBeLessThanOrEqual(Date.now());
    expect(await rejectionOf(commission.cancel(authz, actor, active.id, "Lần nữa"))).toEqual({ status: 422, code: "COMMISSION_RULE_LOCKED" });
  });

  it("RLS: nhà xe chỉ đọc mức mặc định + mức riêng của mình, không ghi được", async () => {
    const seen = await prisma.withScope(tenantScope(operatorA), (tx) => tx.commissionRule.findMany({ select: { operatorId: true } }));
    expect(seen.every((rule) => rule.operatorId === null || rule.operatorId === operatorA)).toBe(true);
    expect(seen.some((rule) => rule.operatorId === null)).toBe(true);
    await expect(
      prisma.withScope(tenantScope(operatorA), (tx) =>
        tx.commissionRule.create({ data: { operatorId: operatorA, rateBps: 0, effectiveFrom: new Date(), reason: "tự giảm" } }),
      ),
    ).rejects.toThrow();
  });

  it("audit lỗi → 503, không thêm mức riêng", async () => {
    recordAuditEvent.mockRejectedValue(new AuditWriteError("mongo down"));
    const before = (await mine()).length;
    expect(await rejectionOf(commission.create(authz, actor, create({ effectiveFrom: at(900), effectiveTo: null })))).toEqual({
      status: 503,
      code: "SERVICE_UNAVAILABLE",
    });
    expect((await mine()).length).toBe(before);
  });
});
