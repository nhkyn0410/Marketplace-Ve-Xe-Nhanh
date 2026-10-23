import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { IncidentInputSchema, JourneyLogInputSchema } from "@vexenhanh/types";
import type { AuditService } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { platformScope, tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { Authorization } from "../iam/role/authorization";
import { JourneyLogService } from "../journey-log/journey-log.service";
import type { NotificationDispatcher } from "../notification/notification-dispatcher";
import type { SupportAttachmentService } from "../support/support-attachments";
import { TripService } from "../trip/trip.service";
import { IncidentService } from "./incident.service";

const ready = Boolean(process.env.DATABASE_URL);
const required = process.env.REQUIRE_DB_TESTS === "1";

describe.skipIf(!ready && !required)("Sự cố + nhật trình — phân công, tự báo Admin và RLS thật", () => {
  let prisma: PrismaService;
  let incidents: IncidentService;
  let logs: JourneyLogService;
  const operatorId = randomUUID();
  const otherOperator = randomUUID();
  const driverId = randomUUID();
  const unassigned = randomUUID();
  const ownerId = randomUUID();
  const adminId = randomUUID();
  const tripId = randomUUID();
  const otherTrip = randomUUID();
  const routeId = randomUUID();
  const provinceId = randomUUID();
  const wardId = randomUUID();
  const pointId = randomUUID();
  const tag = randomUUID().slice(0, 8);
  const actor = { sub: driverId, role: "DRIVER" };
  const authz: Authorization = { permission: "incident:create", scope: "assigned", db: tenantScope(operatorId) };
  const owner: Authorization = { permission: "support:respond", scope: "tenant", db: tenantScope(operatorId) };
  const platform: Authorization = { permission: "support:manage", scope: "any", db: platformScope() };
  const dispatch = vi.fn(async () => undefined);
  const now = new Date();
  const plannedAt = new Date(now.getTime() - 15 * 60_000);

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: process.env.DATABASE_URL }));
    incidents = new IncidentService(prisma, { inspectAll: async () => [] } as unknown as SupportAttachmentService, { dispatch } as unknown as NotificationDispatcher, { recordAuditEvent: async () => undefined } as unknown as AuditService);
    logs = new JourneyLogService(prisma);
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.createMany({ data: [{ id: operatorId, operatorSlug: `ij-${tag}`, displayName: "Nhà xe sự cố" }, { id: otherOperator, operatorSlug: `ij-other-${tag}`, displayName: "Nhà xe khác" }] });
      await tx.operatorAccount.create({ data: { id: ownerId, operatorId, operatorSlug: `ij-${tag}`, username: `owner-${tag}`, contactEmail: `owner-${tag}@example.com`, passwordHash: "x" } });
      await tx.employeeAccount.createMany({ data: [{ id: driverId, operatorId, username: `nv.driver-${tag}`, role: "DRIVER", passwordHash: "x" }, { id: unassigned, operatorId, username: `nv.other-${tag}`, role: "DRIVER", passwordHash: "x" }] });
      await tx.platformAccount.create({ data: { id: adminId, username: `incident-${tag}`, contactEmail: `admin-${tag}@example.com`, role: "PLATFORM_ADMIN", passwordHash: "x" } });
      await tx.route.create({ data: { id: routeId, operatorId, name: "Tuyến sự cố", metricsSource: "GOONG", totalDistanceMeters: 1000, totalDurationSeconds: 3600 } });
      await tx.trip.createMany({ data: [tripId, otherTrip].map((id) => ({ id, operatorId, routeId, departureAt: plannedAt, arrivalAt: new Date(now.getTime() + 3600_000), status: "IN_PROGRESS" })) });
      await tx.employeeAssignment.create({ data: { operatorId, employeeId: driverId, tripId, role: "DRIVER" } });
      await tx.province.create({ data: { id: provinceId, code: `ij-${tag}`, name: "Tỉnh" } });
      await tx.ward.create({ data: { id: wardId, provinceId, code: `ij-${tag}`, name: "Phường" } });
      await tx.stopPointCatalog.create({ data: { id: pointId, name: `Điểm ${tag}`, type: "BUS_STATION", legalBasis: "QĐ test", address: "Địa chỉ", provinceId, wardId, latitude: 10, longitude: 106 } });
      await tx.tripStop.create({ data: { tripId, operatorId, sequence: 1, role: "ORIGIN", catalogStopPointId: pointId, allowPickup: true, allowDropoff: false, plannedAt } });
    });
  }, 30_000);

  afterAll(async () => {
    if (!prisma) return;
    await prisma.withSystem(async (tx) => {
      await tx.notificationDelivery.deleteMany({ where: { operatorId } });
      await tx.notification.deleteMany({ where: { operatorId } });
      await tx.incidentReport.deleteMany({ where: { operatorId } });
      await tx.journeyLog.deleteMany({ where: { operatorId } });
      await tx.employeeAssignment.deleteMany({ where: { operatorId } });
      await tx.tripStop.deleteMany({ where: { operatorId } });
      await tx.trip.deleteMany({ where: { operatorId } });
      await tx.route.deleteMany({ where: { operatorId } });
      await tx.employeeAccount.deleteMany({ where: { operatorId } });
      await tx.operatorAccount.deleteMany({ where: { operatorId } });
      await tx.operatorLoginName.deleteMany({ where: { operatorId } });
      await tx.operatorProfile.deleteMany({ where: { id: { in: [operatorId, otherOperator] } } });
      await tx.platformAccount.delete({ where: { id: adminId } });
      await tx.stopPointCatalog.delete({ where: { id: pointId } });
      await tx.ward.delete({ where: { id: wardId } });
      await tx.province.delete({ where: { id: provinceId } });
    });
    await prisma.$disconnect();
  }, 30_000);

  it("chỉ người được giao chuyến đang chạy ghi được; HIGH tự báo Owner + Admin; mức nhẹ chỉ báo Owner", async () => {
    const base = { tripId, type: "VEHICLE", severity: "HIGH", description: "Xe hỏng máy, đã dừng an toàn.", occurredAt: now.toISOString() };
    await expect(incidents.create(authz, { sub: unassigned, role: "DRIVER" }, IncidentInputSchema.parse(base))).rejects.toMatchObject({ status: 404 });
    await expect(incidents.create(authz, { sub: driverId, role: "TICKET_STAFF" }, IncidentInputSchema.parse(base))).rejects.toMatchObject({ status: 403 });
    await expect(incidents.create(authz, actor, IncidentInputSchema.parse({ ...base, tripId: otherTrip }))).rejects.toMatchObject({ status: 404 });
    const severe = await incidents.create(authz, actor, IncidentInputSchema.parse(base));
    const notificationRows = await prisma.withSystem((tx) => tx.notification.findMany({ where: { operatorId, tripId, kind: "OPERATIONS_ALERT" } }));
    expect(notificationRows.some((row) => row.dedupKey.endsWith(`OPERATOR:${ownerId}`))).toBe(true);
    expect(notificationRows.some((row) => row.dedupKey.endsWith(`PLATFORM:${adminId}`))).toBe(true);
    expect(dispatch).toHaveBeenCalled();
    const low = await incidents.create(authz, actor, IncidentInputSchema.parse({ ...base, severity: "LOW" }));
    expect(await prisma.withSystem((tx) => tx.notification.count({ where: { operatorId, dedupKey: { startsWith: `OPERATIONS_ALERT:${low.id}:PLATFORM:` } } }))).toBe(0);
    expect((await incidents.resolve(owner, { sub: ownerId }, severe.id, "Đã điều xe hỗ trợ.")).resolution).toBe("Đã điều xe hỗ trợ.");
  });

  it("tenant khác không đọc dù query quên lọc; con trỏ không lộ sự cố ngoài tenant; Admin thấy", async () => {
    const otherAuthz: Authorization = { ...owner, db: tenantScope(otherOperator) };
    const mine = await incidents.list(owner, { sub: ownerId }, { limit: 20 });
    expect(mine.items.length).toBeGreaterThan(0);
    expect((await incidents.list(otherAuthz, { sub: randomUUID() }, { limit: 20, cursor: mine.items[0]!.id })).items).toEqual([]);
    expect(await prisma.withTenant(otherOperator, (tx) => tx.incidentReport.findMany())).toEqual([]);
    expect(await prisma.withTenant(otherOperator, (tx) => tx.journeyLog.findMany())).toEqual([]);
    expect((await incidents.list(platform, { sub: adminId }, { limit: 100, tripId })).items.length).toBe(mine.items.length);
  });

  it("nhật trình tính trễ theo điểm; từ chối nhân viên hỗ trợ và điểm không thuộc chuyến; cửa sổ lưu đúng tenant", async () => {
    const input = JourneyLogInputSchema.parse({ tripId, stopSequence: 1, actualAt: now.toISOString(), note: "Đã tới điểm đón." });
    const row = await logs.create({ ...authz, permission: "journey-log:create" }, actor, input);
    expect(row.delayMinutes).toBe(15);
    await expect(logs.create(authz, { ...actor, role: "SUPPORT_STAFF" }, input)).rejects.toMatchObject({ status: 403 });
    await expect(logs.create(authz, actor, { ...input, stopSequence: 99 })).rejects.toMatchObject({ status: 400 });
    expect((await logs.list(authz, actor, { limit: 20 })).items.map((entry) => entry.id)).toContain(row.id);
    expect((await logs.list(authz, { sub: unassigned }, { limit: 20 })).items).toEqual([]);
    const start = new Date(now.getTime() - 10 * 60_000).toISOString();
    const end = new Date(now.getTime() + 10 * 60_000).toISOString();
    const trip = await new TripService(prisma, {} as AuditService).setPickupWindow({ ...owner, permission: "trip:manage" }, tripId, 1, { start, end });
    expect(trip.stops[0]).toMatchObject({ pickupWindowStart: start, pickupWindowEnd: end });
    await expect(new TripService(prisma, {} as AuditService).setPickupWindow({ ...owner, db: tenantScope(otherOperator) }, tripId, 1, { start, end })).rejects.toMatchObject({ status: 404 });
    await prisma.withSystem((tx) => tx.trip.update({ where: { id: tripId }, data: { status: "COMPLETED" } }));
    await expect(logs.create(authz, actor, input)).rejects.toMatchObject({ status: 409 });
  });
});
