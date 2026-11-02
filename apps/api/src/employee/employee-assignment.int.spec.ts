import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { AuditWriteError, type AuditService } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { Authorization } from "../iam/role/authorization";
import { DriverAssignmentInputSchema } from "./dto/employee-assignment.dto";
import { EmployeeAssignmentService } from "./employee-assignment.service";

/**
 * TASK-EMP-001 (phía Operator OS) — phân công tài xế trên Postgres THẬT bằng role APP (RLS có hiệu lực). Tuyến + chuyến ghi
 * thẳng bằng scope system (không cần điểm dừng / ghế cho phân công). Audit là mock.
 */
const url = process.env.DATABASE_URL;
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
const HOUR = 3_600_000;
/** 10/03/2031 00:00 giờ Việt Nam. */
const DAY0 = Date.UTC(2031, 2, 10) - 7 * HOUR;

async function rejectionOf(promise: Promise<unknown>): Promise<{ status?: number; code?: string; detail?: string; text: string }> {
  try {
    await promise;
    return { text: "" };
  } catch (error) {
    const response = (error as { getResponse?: () => { code?: string; detail?: string } }).getResponse?.();
    return {
      status: (error as { getStatus?: () => number }).getStatus?.(),
      code: response?.code,
      detail: response?.detail,
      text: JSON.stringify(error, Object.getOwnPropertyNames(error)) + String(error),
    };
  }
}

describe.skipIf(!url && !requireDb)("Phân công tài xế — Postgres thật, role app (EMP-001)", () => {
  let prisma: PrismaService;
  let assignments: EmployeeAssignmentService;
  const recordAuditEvent = vi.fn();
  const tag = randomUUID().slice(0, 8);
  const tenantA = randomUUID();
  const tenantB = randomUUID();
  const routeA = randomUUID();
  const routeA2 = randomUUID();
  const routeB = randomUUID();
  const driver = randomUUID();
  const driver2 = randomUUID();
  const lockedDriver = randomUUID();
  const ticketStaff = randomUUID();
  const driverB = randomUUID();
  const actor = { sub: `owner-${tag}`, role: "OPERATOR_OWNER" };
  const authzA = authz(tenantA);
  const authzB = authz(tenantB);

  function authz(operatorId: string): Authorization {
    return { permission: "employee:manage", scope: "tenant", db: tenantScope(operatorId) };
  }

  const input = (employeeId: string | null, reason: string | null = null) => DriverAssignmentInputSchema.parse({ employeeId, reason });

  /** Chuyến của tenant A từ `start` giờ tới `end` giờ tính từ 00:00 VN ngày `DAY0` (+ `day` ngày). */
  async function trip(start: number, end: number, options: { day?: number; status?: string; route?: string; operatorId?: string } = {}) {
    const base = DAY0 + (options.day ?? 0) * 24 * HOUR;
    const row = await prisma.withSystem((tx) =>
      tx.trip.create({
        data: {
          operatorId: options.operatorId ?? tenantA,
          routeId: options.route ?? routeA,
          departureAt: new Date(base + start * HOUR),
          arrivalAt: new Date(base + end * HOUR),
          status: (options.status ?? "DRAFT") as "DRAFT",
          statusReason: options.status === "CANCELLED" ? "Hủy trong test" : null,
        },
        select: { id: true },
      }),
    );
    return row.id;
  }

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    assignments = new EmployeeAssignmentService(prisma, { recordAuditEvent } as unknown as AuditService);
    const [role] = await prisma.$queryRaw<{ rolsuper: boolean; rolbypassrls: boolean }[]>`
      SELECT rolsuper, rolbypassrls FROM pg_roles WHERE rolname = current_user`;
    if (!role || role.rolsuper || role.rolbypassrls) {
      throw new Error("DATABASE_URL đang là superuser/BYPASSRLS — dùng role app.");
    }
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.createMany({
        data: [
          { id: tenantA, operatorSlug: `asg-a-${tag}`, displayName: "Phân công A" },
          { id: tenantB, operatorSlug: `asg-b-${tag}`, displayName: "Phân công B" },
        ],
      });
      const route = (id: string, operatorId: string, name: string) => ({
        id,
        operatorId,
        name: `${name} ${tag}`,
        totalDistanceMeters: 300_000,
        totalDurationSeconds: 5 * 3600,
        metricsSource: "GOONG" as const,
      });
      await tx.route.createMany({ data: [route(routeA, tenantA, "SG - ĐL"), route(routeA2, tenantA, "SG - NT"), route(routeB, tenantB, "B")] });
      await tx.employeeAccount.createMany({
        data: [
          { id: driver, operatorId: tenantA, username: `nv.tai-${tag}`, passwordHash: "x", role: "DRIVER" },
          { id: driver2, operatorId: tenantA, username: `nv.tai2-${tag}`, passwordHash: "x", role: "DRIVER" },
          { id: lockedDriver, operatorId: tenantA, username: `nv.khoa-${tag}`, passwordHash: "x", role: "DRIVER", status: "LOCKED" },
          { id: ticketStaff, operatorId: tenantA, username: `nv.ve-${tag}`, passwordHash: "x", role: "TICKET_STAFF" },
          { id: driverB, operatorId: tenantB, username: `nv.b-${tag}`, passwordHash: "x", role: "DRIVER" },
        ],
      });
    });
  });

  beforeEach(() => {
    recordAuditEvent.mockReset();
    recordAuditEvent.mockResolvedValue(undefined);
  });

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      const operatorId = { in: [tenantA, tenantB] };
      await tx.employeeAssignment.deleteMany({ where: { operatorId } });
      await tx.trip.deleteMany({ where: { operatorId } });
      await tx.route.deleteMany({ where: { operatorId } });
      await tx.employeeAccount.deleteMany({ where: { operatorId } });
      await tx.operatorLoginName.deleteMany({ where: { operatorId } });
      await tx.operatorProfile.deleteMany({ where: { id: operatorId } });
    });
    await prisma.$disconnect();
  });

  it("phân công: lưu + audit; gửi lại y nguyên không audit; nhân viên khóa / không phải tài xế / tenant khác → 422; chuyến tenant khác → 404; chuyến đã hủy → 409", async () => {
    const tripId = await trip(8, 12);
    const assigned = await assignments.assignDriver(actor, authzA, tripId, input(driver));
    expect(assigned).toMatchObject({ tripId, driver: { employeeId: driver, username: `nv.tai-${tag}`, status: "ACTIVE" }, editable: true, reasonRequired: false });
    expect(recordAuditEvent).toHaveBeenCalledWith(
      expect.objectContaining({ action: "trip.driver.assign", targetId: tripId, operatorId: tenantA, before: { driverId: null }, after: { driverId: driver } }),
      expect.objectContaining({ deadline: expect.any(Number) }),
    );
    recordAuditEvent.mockClear();
    await assignments.assignDriver(actor, authzA, tripId, input(driver));
    expect(recordAuditEvent).not.toHaveBeenCalled();

    for (const employeeId of [lockedDriver, ticketStaff, driverB, randomUUID()]) {
      expect(await rejectionOf(assignments.assignDriver(actor, authzA, tripId, input(employeeId)))).toMatchObject({
        status: 422,
        code: "EMPLOYEE_NOT_ASSIGNABLE",
      });
    }
    expect(await rejectionOf(assignments.assignDriver(actor, authzB, tripId, input(driverB)))).toMatchObject({ status: 404, code: "TRIP_NOT_FOUND" });
    const cancelled = await trip(13, 14, { status: "CANCELLED" });
    expect(await rejectionOf(assignments.assignDriver(actor, authzA, cancelled, input(driver2)))).toMatchObject({
      status: 409,
      code: "TRIP_NOT_ASSIGNABLE",
    });
  });

  it("một tài xế không chạy hai chuyến chồng giờ (409 nêu giờ chuyến kia); nối đúng giờ đến được; hai lần phân công đồng thời chỉ một thành công", async () => {
    const first = await trip(8, 12, { day: 1 });
    const overlap = await trip(11, 15, { day: 1, route: routeA2 });
    const next = await trip(12, 16, { day: 1, route: routeA2 });
    await assignments.assignDriver(actor, authzA, first, input(driver));
    const clash = await rejectionOf(assignments.assignDriver(actor, authzA, overlap, input(driver)));
    expect(clash).toMatchObject({ status: 409, code: "DRIVER_SCHEDULE_CONFLICT" });
    expect(clash.detail).toContain("08:00 11/03 – 12:00 11/03");
    expect((await assignments.assignDriver(actor, authzA, next, input(driver))).driver?.employeeId).toBe(driver);

    const left = await trip(8, 12, { day: 2 });
    const right = await trip(10, 14, { day: 2, route: routeA2 });
    const results = await Promise.allSettled([
      assignments.assignDriver(actor, authzA, left, input(driver2)),
      assignments.assignDriver(actor, authzA, right, input(driver2)),
    ]);
    expect(results.filter((result) => result.status === "fulfilled")).toHaveLength(1);
    const assignedCount = await prisma.withTenant(tenantA, (tx) =>
      tx.employeeAssignment.count({ where: { employeeId: driver2, tripId: { in: [left, right] } } }),
    );
    expect(assignedCount).toBe(1);
  });

  it("đổi phân công khi chuyến sắp khởi hành (< 2 giờ) / đang chạy cần lý do; lý do vào audit; bỏ phân công", async () => {
    const soon = await prisma.withSystem((tx) =>
      tx.trip.create({
        data: { operatorId: tenantA, routeId: routeA, departureAt: new Date(Date.now() + HOUR), arrivalAt: new Date(Date.now() + 2 * HOUR) },
        select: { id: true },
      }),
    );
    expect(await rejectionOf(assignments.assignDriver(actor, authzA, soon.id, input(driver2)))).toMatchObject({
      status: 422,
      code: "ASSIGNMENT_REASON_REQUIRED",
    });
    const withReason = await assignments.assignDriver(actor, authzA, soon.id, input(driver2, "Tài xế cũ báo ốm"));
    expect(withReason).toMatchObject({ reasonRequired: true, driver: { employeeId: driver2 } });
    expect(recordAuditEvent).toHaveBeenLastCalledWith(expect.objectContaining({ reason: "Tài xế cũ báo ốm" }), expect.anything());

    const running = await trip(8, 12, { day: 3, status: "IN_PROGRESS" });
    expect(await rejectionOf(assignments.assignDriver(actor, authzA, running, input(driver)))).toMatchObject({ code: "ASSIGNMENT_REASON_REQUIRED" });

    const unassigned = await assignments.assignDriver(actor, authzA, soon.id, input(null, "Đổi sang chuyến khác"));
    expect(unassigned.driver).toBeNull();
    expect(recordAuditEvent).toHaveBeenLastCalledWith(
      expect.objectContaining({ action: "trip.driver.unassign", before: { driverId: driver2 }, after: { driverId: null } }),
      expect.anything(),
    );
  });

  it("danh sách theo ngày (giờ VN): bỏ chuyến đã hủy, lọc đã / chưa phân công, phân trang; chồng giờ do sửa giờ chuyến sau khi phân công được báo; tenant khác không thấy", async () => {
    const early = await trip(6, 9, { day: 5 });
    const late = await trip(10, 13, { day: 5, route: routeA2 });
    const free = await trip(22, 29, { day: 5 });
    await trip(14, 15, { day: 5, status: "CANCELLED" });
    await trip(23.5, 25, { day: 4 }); // ngày hôm trước theo giờ VN dù tới ngày sau mới đến
    await assignments.assignDriver(actor, authzA, early, input(driver));
    await assignments.assignDriver(actor, authzA, late, input(driver));

    const date = "2031-03-15";
    const all = await assignments.list(authzA, { date, limit: 20 });
    expect(all.items.map((item) => item.tripId)).toEqual([early, late, free]);
    expect(all.items.map((item) => item.conflict)).toEqual([null, null, null]);
    expect((await assignments.list(authzA, { date, state: "UNASSIGNED", limit: 20 })).items.map((item) => item.tripId)).toEqual([free]);
    expect((await assignments.list(authzA, { date, state: "ASSIGNED", routeId: routeA2, limit: 20 })).items.map((item) => item.tripId)).toEqual([late]);
    const firstPage = await assignments.list(authzA, { date, limit: 2 });
    expect(firstPage.nextCursor).toBe(late);
    expect((await assignments.list(authzA, { date, limit: 2, cursor: firstPage.nextCursor! })).items.map((item) => item.tripId)).toEqual([free]);

    // Sửa giờ chuyến sớm (ghi thẳng) cho chồng chuyến sau → cả hai báo chồng giờ.
    await prisma.withSystem((tx) => tx.trip.update({ where: { id: early }, data: { arrivalAt: new Date(DAY0 + 5 * 24 * HOUR + 11 * HOUR) } }));
    const conflicted = await assignments.list(authzA, { date, state: "ASSIGNED", limit: 20 });
    expect(conflicted.items.find((item) => item.tripId === early)!.conflict?.tripId).toBe(late);
    expect(conflicted.items.find((item) => item.tripId === late)!.conflict?.tripId).toBe(early);

    expect((await assignments.list(authzB, { date, limit: 20 })).items).toEqual([]);
  });

  it("audit lỗi → 503, phân công không đổi; DB: một chuyến một tài xế, không gắn nhân viên tenant khác kể cả ghi thẳng", async () => {
    const tripId = await trip(8, 12, { day: 6 });
    recordAuditEvent.mockRejectedValueOnce(new AuditWriteError("mongo down"));
    expect(await rejectionOf(assignments.assignDriver(actor, authzA, tripId, input(driver)))).toMatchObject({
      status: 503,
      code: "SERVICE_UNAVAILABLE",
    });
    expect(await prisma.withTenant(tenantA, (tx) => tx.employeeAssignment.count({ where: { tripId } }))).toBe(0);

    await assignments.assignDriver(actor, authzA, tripId, input(driver));
    const second = await rejectionOf(
      prisma.withTenant(tenantA, (tx) =>
        tx.employeeAssignment.create({ data: { operatorId: tenantA, tripId, employeeId: driver2, role: "DRIVER" } }),
      ),
    );
    expect(second.text).toMatch(/trip_id|Unique constraint/i);
    const foreign = await rejectionOf(
      prisma.withTenant(tenantA, (tx) =>
        tx.employeeAssignment.create({ data: { operatorId: tenantA, tripId, employeeId: driverB, role: "TICKET_STAFF" } }),
      ),
    );
    expect(foreign.text).toMatch(/employee_assignments_employee_id_operator_id_fkey|Foreign key/i);
  });
});
