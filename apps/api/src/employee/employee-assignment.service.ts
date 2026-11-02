import { Inject, Injectable } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import { EmployeeRole, TripStatus } from "../database/prisma.types";
import type { Authorization } from "../iam/role/authorization";
import { requireTenant } from "../iam/role/require-tenant";
import type { DriverAssignmentInput, TripAssignment, TripAssignmentPage } from "./dto/employee-assignment.dto";
import {
  assignmentHistoryUnavailable,
  assignmentReasonRequired,
  driverScheduleConflict,
  employeeNotAssignable,
  tripNotAssignable,
  tripNotFound,
} from "./employee-assignment.errors";

/** Người thực hiện thao tác (từ access token) — ghi vào audit. */
export type AssignmentActor = { sub: string; role: string };

type ListQuery = {
  date: string;
  routeId?: string;
  state?: "ASSIGNED" | "UNASSIGNED";
  cursor?: string;
  limit: number;
};

const DAY_MS = 24 * 3_600_000;
const VN_OFFSET_MS = 7 * 3_600_000;
/** Đổi phân công khi còn dưới 2 giờ là khởi hành phải có lý do (UC-16 A4). */
const REASON_WINDOW_MS = 2 * 3_600_000;
const AUDIT_TIMEOUT_MS = 2_000;
const CLOSED_STATUSES: readonly TripStatus[] = [TripStatus.CANCELLED, TripStatus.COMPLETED];
const RUNNING_STATUSES: readonly TripStatus[] = [
  TripStatus.BOARDING,
  TripStatus.DEPARTED,
  TripStatus.IN_PROGRESS,
  TripStatus.INCIDENT,
];

/**
 * Phân công tài xế cho chuyến (TASK-EMP-001 phía Operator OS, UC-16 bước 4–6, Figma "05 · Nhân viên / Phân công chuyến" —
 * thiết kế chờ Khanh duyệt). Mỗi chuyến một tài xế; một tài xế không chạy hai chuyến chồng giờ — khoá dòng nhân viên
 * (`FOR NO KEY UPDATE`) rồi kiểm, nên hai lần phân công đồng thời cùng một tài xế xếp hàng. Thông báo cho nhân viên
 * (UC-16 bước 7) chờ `TASK-NSR-001` + app nhân viên.
 */
@Injectable()
export class EmployeeAssignmentService {
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  /** Chuyến chưa hủy khởi hành trong ngày (giờ VN) kèm tài xế đang phân công + chồng giờ nếu có. */
  async list(authz: Authorization, query: ListQuery): Promise<TripAssignmentPage> {
    const { db, operatorId } = requireTenant(authz);
    const from = new Date(Date.parse(`${query.date}T00:00:00Z`) - VN_OFFSET_MS);
    const to = new Date(from.getTime() + DAY_MS);
    const { rows, conflicts } = await this.prisma.withScope(db, async (tx) => {
      let after = {};
      if (query.cursor) {
        const cursor = await tx.trip.findFirst({ where: { id: query.cursor, operatorId }, select: { id: true, departureAt: true } });
        if (!cursor) {
          return { rows: [], conflicts: new Map<string, Slot>() };
        }
        after = {
          OR: [
            { departureAt: { gt: cursor.departureAt } },
            { departureAt: cursor.departureAt, id: { gt: cursor.id } },
          ],
        };
      }
      const driverFilter =
        query.state === "ASSIGNED"
          ? { assignments: { some: { role: EmployeeRole.DRIVER } } }
          : query.state === "UNASSIGNED"
            ? { assignments: { none: { role: EmployeeRole.DRIVER } } }
            : {};
      const rows = await tx.trip.findMany({
        where: {
          operatorId,
          status: { not: TripStatus.CANCELLED },
          departureAt: { gte: from, lt: to },
          routeId: query.routeId,
          ...driverFilter,
          ...after,
        },
        orderBy: [{ departureAt: "asc" }, { id: "asc" }],
        take: query.limit + 1,
        select: TRIP_SELECT,
      });
      const assigned = rows.filter((row) => row.assignments.length > 0).map((row) => row.id);
      return { rows, conflicts: await conflictsOf(tx, operatorId, assigned) };
    });
    const page = rows.slice(0, query.limit);
    const now = Date.now();
    return {
      items: page.map((row) => toAssignment(row, conflicts.get(row.id) ?? null, now)),
      nextCursor: rows.length > query.limit ? page[page.length - 1]!.id : null,
    };
  }

  /**
   * Phân công / đổi / bỏ tài xế của một chuyến. Khoá dòng chuyến (xếp hàng với đổi trạng thái / sửa chuyến) và dòng nhân
   * viên. Chuyến đang chạy hoặc còn dưới 2 giờ là khởi hành → bắt buộc lý do (UC-16 A4). Audit là lệnh cuối trong
   * transaction: Mongo lỗi → 503, không đổi gì. Gửi lại đúng người đang phân công → trả nguyên, không audit.
   */
  async assignDriver(
    actor: AssignmentActor,
    authz: Authorization,
    tripId: string,
    input: DriverAssignmentInput,
  ): Promise<TripAssignment> {
    const { db, operatorId } = requireTenant(authz);
    try {
      return await this.prisma.withScope(db, async (tx) => {
        const deadline = transactionDeadline(Date.now());
        const [trip] = await tx.$queryRaw<{ status: TripStatus; departureAt: Date; arrivalAt: Date }[]>`
          SELECT status::text AS "status", departure_at AS "departureAt", arrival_at AS "arrivalAt"
          FROM trips
          WHERE id = ${tripId} AND operator_id = ${operatorId}
          FOR NO KEY UPDATE`;
        if (!trip) {
          throw tripNotFound();
        }
        if (CLOSED_STATUSES.includes(trip.status)) {
          throw tripNotAssignable();
        }
        const current = await tx.employeeAssignment.findUnique({
          where: { tripId_role: { tripId, role: EmployeeRole.DRIVER } },
          select: { employeeId: true },
        });
        const before = current?.employeeId ?? null;
        if (before === input.employeeId) {
          return toAssignment((await findTrip(tx, operatorId, tripId))!, null, Date.now());
        }
        if (needsReason(trip, Date.now()) && !input.reason) {
          throw assignmentReasonRequired();
        }
        if (input.employeeId) {
          await assertDriverFree(tx, operatorId, tripId, input.employeeId, trip);
          await tx.employeeAssignment.upsert({
            where: { tripId_role: { tripId, role: EmployeeRole.DRIVER } },
            create: { operatorId, tripId, employeeId: input.employeeId, role: EmployeeRole.DRIVER, assignedBy: actor.sub },
            update: { employeeId: input.employeeId, assignedBy: actor.sub },
          });
        } else {
          await tx.employeeAssignment.deleteMany({ where: { tripId, operatorId, role: EmployeeRole.DRIVER } });
        }
        const row = (await findTrip(tx, operatorId, tripId))!;
        await this.audit.recordAuditEvent(
          {
            actorId: actor.sub,
            actorRole: actor.role,
            action: input.employeeId ? "trip.driver.assign" : "trip.driver.unassign",
            targetType: "trip",
            targetId: tripId,
            operatorId,
            before: { driverId: before },
            after: { driverId: input.employeeId },
            reason: input.reason ?? undefined,
          },
          { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
        );
        return toAssignment(row, null, Date.now());
      });
    } catch (error) {
      // Audit Mongo lỗi / chậm hoặc transaction hết hạn (P2028) → 503 thử lại được: Postgres đã rollback.
      if (error instanceof AuditWriteError || (error as { code?: unknown } | null)?.code === "P2028") {
        throw assignmentHistoryUnavailable();
      }
      throw error;
    }
  }
}

type Slot = { tripId: string; departureAt: Date; arrivalAt: Date };

const TRIP_SELECT = {
  id: true,
  departureAt: true,
  arrivalAt: true,
  status: true,
  route: { select: { name: true } },
  vehicle: { select: { plateNumber: true } },
  assignments: {
    where: { role: EmployeeRole.DRIVER },
    select: { employeeId: true, employee: { select: { username: true, status: true } } },
  },
} as const;

function findTrip(tx: DbTransaction, operatorId: string, tripId: string) {
  return tx.trip.findFirst({ where: { id: tripId, operatorId }, select: TRIP_SELECT });
}

/**
 * Nhân viên phải là tài xế đang hoạt động của nhà xe (UC-16 A1, A2) và không có chuyến chưa hủy chồng giờ (A3). Khoá
 * dòng nhân viên trước khi kiểm: hai lần phân công cùng tài xế vào hai chuyến chồng giờ không lọt được cả hai.
 */
async function assertDriverFree(
  tx: DbTransaction,
  operatorId: string,
  tripId: string,
  employeeId: string,
  trip: { departureAt: Date; arrivalAt: Date },
): Promise<void> {
  const [employee] = await tx.$queryRaw<{ role: string; status: string }[]>`
    SELECT role::text AS "role", status::text AS "status"
    FROM employee_accounts
    WHERE id = ${employeeId} AND operator_id = ${operatorId}
    FOR NO KEY UPDATE`;
  if (!employee || employee.role !== EmployeeRole.DRIVER || employee.status !== "ACTIVE") {
    throw employeeNotAssignable();
  }
  const [clash] = await tx.$queryRaw<{ departureAt: Date; arrivalAt: Date }[]>`
    SELECT t.departure_at AS "departureAt", t.arrival_at AS "arrivalAt"
    FROM employee_assignments a
    JOIN trips t ON t.id = a.trip_id
    WHERE a.employee_id = ${employeeId} AND a.role = 'DRIVER' AND a.trip_id <> ${tripId} AND t.status <> 'CANCELLED'
      AND t.departure_at < ${trip.arrivalAt} AND t.arrival_at > ${trip.departureAt}
    ORDER BY t.departure_at
    LIMIT 1`;
  if (clash) {
    throw driverScheduleConflict(
      `Tài xế đã chạy chuyến ${vnClock(clash.departureAt)} – ${vnClock(clash.arrivalAt)} trùng giờ với chuyến này.`,
    );
  }
}

/** Với mỗi chuyến có tài xế: chuyến chưa hủy khác của cùng tài xế chồng giờ (sớm nhất). */
async function conflictsOf(tx: DbTransaction, operatorId: string, tripIds: string[]): Promise<Map<string, Slot>> {
  if (tripIds.length === 0) {
    return new Map();
  }
  const rows = await tx.$queryRaw<{ tripId: string; otherId: string; departureAt: Date; arrivalAt: Date }[]>`
    SELECT a.trip_id AS "tripId", o.id AS "otherId", o.departure_at AS "departureAt", o.arrival_at AS "arrivalAt"
    FROM employee_assignments a
    JOIN trips t ON t.id = a.trip_id
    JOIN employee_assignments b ON b.employee_id = a.employee_id AND b.role = a.role AND b.trip_id <> a.trip_id
    JOIN trips o ON o.id = b.trip_id AND o.status <> 'CANCELLED'
    WHERE a.operator_id = ${operatorId} AND a.role = 'DRIVER' AND a.trip_id = ANY(${tripIds})
      AND o.departure_at < t.arrival_at AND o.arrival_at > t.departure_at
    ORDER BY o.departure_at`;
  const conflicts = new Map<string, Slot>();
  for (const row of rows) {
    if (!conflicts.has(row.tripId)) {
      conflicts.set(row.tripId, { tripId: row.otherId, departureAt: row.departureAt, arrivalAt: row.arrivalAt });
    }
  }
  return conflicts;
}

function needsReason(trip: { status: TripStatus; departureAt: Date }, now: number): boolean {
  return RUNNING_STATUSES.includes(trip.status) || trip.departureAt.getTime() - now < REASON_WINDOW_MS;
}

/** `06:00 16/10` theo giờ Việt Nam. */
function vnClock(at: Date): string {
  const shifted = new Date(at.getTime() + VN_OFFSET_MS).toISOString();
  return `${shifted.slice(11, 16)} ${shifted.slice(8, 10)}/${shifted.slice(5, 7)}`;
}

function toAssignment(
  row: NonNullable<Awaited<ReturnType<typeof findTrip>>>,
  conflict: Slot | null,
  now: number,
): TripAssignment {
  const driver = row.assignments[0];
  return {
    tripId: row.id,
    departureAt: row.departureAt.toISOString(),
    arrivalAt: row.arrivalAt.toISOString(),
    status: row.status,
    routeName: row.route.name,
    vehiclePlateNumber: row.vehicle?.plateNumber ?? null,
    driver: driver ? { employeeId: driver.employeeId, username: driver.employee.username, status: driver.employee.status } : null,
    conflict: conflict
      ? { tripId: conflict.tripId, departureAt: conflict.departureAt.toISOString(), arrivalAt: conflict.arrivalAt.toISOString() }
      : null,
    reasonRequired: needsReason(row, now),
    editable: !CLOSED_STATUSES.includes(row.status),
  };
}
