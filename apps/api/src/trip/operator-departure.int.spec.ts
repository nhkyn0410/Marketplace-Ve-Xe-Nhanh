import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import type { AuditService } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { Authorization } from "../iam/role/authorization";
import { OperatorDepartureService } from "./operator-departure.service";

const url = process.env.DATABASE_URL;
const requireDb = process.env.REQUIRE_DB_TESTS === "1";

describe.skipIf(!url && !requireDb)("Điều phối khởi hành — PostgreSQL thật, role có RLS", () => {
  let prisma: PrismaService;
  let departures: OperatorDepartureService;
  const tenant = randomUUID();
  const other = randomUUID();
  const routeId = randomUUID();
  const actor = { sub: randomUUID(), role: "OPERATOR_OWNER" };
  const authz: Authorization = { permission: "trip:dispatch", scope: "tenant", db: tenantScope(tenant) };
  const audit = { recordAuditEvent: vi.fn().mockResolvedValue(undefined) };

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ NODE_ENV: "test", DATABASE_URL: url }));
    const [role] = await prisma.$queryRaw<{ rolsuper: boolean; rolbypassrls: boolean }[]>`SELECT rolsuper, rolbypassrls FROM pg_roles WHERE rolname = current_user`;
    if (!role || role.rolsuper || role.rolbypassrls) throw new Error("Kiểm thử phải dùng role app không có BYPASSRLS.");
    departures = new OperatorDepartureService(prisma, audit as unknown as AuditService);
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.createMany({ data: [tenant, other].map((id) => ({ id, operatorSlug: `dep-${id}`, displayName: "Nhà xe kiểm thử" })) });
      await tx.route.create({ data: { id: routeId, operatorId: tenant, name: "Tuyến kiểm thử", totalDistanceMeters: 1000, totalDurationSeconds: 3600, metricsSource: "ESTIMATE" } });
    });
  }, 30_000);

  afterAll(async () => {
    if (!prisma) return;
    await prisma.withSystem(async (tx) => {
      await tx.trip.deleteMany({ where: { operatorId: tenant } });
      await tx.route.deleteMany({ where: { operatorId: tenant } });
      await tx.operatorProfile.deleteMany({ where: { id: { in: [tenant, other] } } });
    });
    await prisma.$disconnect();
  });

  async function trip() {
    return prisma.withTenant(tenant, (tx) => tx.trip.create({ data: { operatorId: tenant, routeId, status: "BOARDING", departureAt: new Date(Date.now() - 3_600_000), arrivalAt: new Date(Date.now() + 3_600_000) } }));
  }

  it("xe trễ lịch vẫn ghi giờ thực tế; xác nhận song song chỉ ghi một mốc", async () => {
    const row = await trip();
    audit.recordAuditEvent.mockClear();
    const results = await Promise.all([departures.depart(actor, authz, row.id, {}), departures.depart(actor, authz, row.id, {})]);
    expect(results[0]).toEqual(results[1]);
    expect(Date.parse(results[0]!.departedAt)).toBeGreaterThan(row.departureAt.getTime());
    expect(audit.recordAuditEvent).toHaveBeenCalledTimes(1);
    const saved = await prisma.withTenant(tenant, (tx) => tx.trip.findFirstOrThrow({ where: { id: row.id, operatorId: tenant } }));
    expect(saved.status).toBe("DEPARTED");
    expect(saved.departedAt?.toISOString()).toBe(results[0]!.departedAt);
  });

  it("tenant khác không đọc hoặc xác nhận được chuyến", async () => {
    const row = await trip();
    await expect(departures.depart(actor, { ...authz, db: tenantScope(other) }, row.id, {})).rejects.toMatchObject({ status: 404 });
    const visible = await prisma.withTenant(other, (tx) => tx.trip.findMany({ where: { id: row.id } }));
    expect(visible).toEqual([]);
  });

  it("khóa khởi hành phải chờ giao dịch đang giữ khóa bán trên cùng chuyến", async () => {
    const row = await trip();
    let releaseSale!: () => void;
    let lockedSale!: () => void;
    const saleReady = new Promise<void>((resolve) => { lockedSale = resolve; });
    const gate = new Promise<void>((resolve) => { releaseSale = resolve; });
    const sale = prisma.withTenant(tenant, async (tx) => {
      await tx.$queryRaw`SELECT id FROM trips WHERE id = ${row.id} AND operator_id = ${tenant} FOR SHARE`;
      lockedSale();
      await gate;
      return tx.trip.findFirstOrThrow({ where: { id: row.id, operatorId: tenant } });
    });
    await saleReady;
    const departure = departures.depart(actor, authz, row.id, {});
    releaseSale();
    expect((await sale).departedAt).toBeNull();
    expect((await departure).departedAt).toBeTruthy();
  });
});
