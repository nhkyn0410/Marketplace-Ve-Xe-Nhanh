import { HttpStatus, Inject, Injectable } from "@nestjs/common";
import type { JourneyLog, JourneyLogInput, JourneyLogPage, OperationsQuery } from "@vexenhanh/types";
import { PrismaService } from "../database/prisma.service";
import type { Authorization } from "../iam/role/authorization";
import { requireAssignedTenant } from "../iam/role/require-tenant";
import { assignedActiveTrip, assignedTripIds, operationsError, operationsReadScope } from "./operations-access";

/** Nhật trình của tài xế trên chuyến được phân công (FR-EMP-10, UC-22). */
@Injectable()
export class JourneyLogService {
  constructor(@Inject(PrismaService) private readonly prisma: PrismaService) {}

  /** Ghi giờ thực tế, độ trễ, tình trạng xe và ghi chú vào nhật trình. */
  async create(authz: Authorization, actor: { sub: string; role: string }, input: JourneyLogInput): Promise<JourneyLog> {
    const { db, operatorId } = requireAssignedTenant(authz);
    if (actor.role !== "DRIVER") throw operationsError(HttpStatus.FORBIDDEN, "PERMISSION_DENIED", "Chỉ tài xế ghi nhật trình.");
    const actualAt = new Date(input.actualAt);
    if (actualAt.getTime() > Date.now() + 60_000) throw operationsError(HttpStatus.BAD_REQUEST, "VALIDATION_ERROR", "Giờ thực tế không được ở tương lai.");
    return this.prisma.withScope(db, async (tx) => {
      await assignedActiveTrip(tx, operatorId, actor.sub, input.tripId);
      const stop = input.stopSequence === null ? null : await tx.tripStop.findFirst({ where: { operatorId, tripId: input.tripId, sequence: input.stopSequence }, select: { plannedAt: true } });
      if (input.stopSequence !== null && !stop) throw operationsError(HttpStatus.BAD_REQUEST, "TRIP_STOP_TIMES_INVALID", "Điểm dừng không thuộc chuyến.");
      const delayMinutes = stop ? Math.max(0, Math.floor((actualAt.getTime() - stop.plannedAt.getTime()) / 60_000)) : 0;
      return serialize(await tx.journeyLog.create({ data: { ...input, actualAt, operatorId, employeeId: actor.sub, delayMinutes } }));
    });
  }

  /** Xem nhật trình trong đúng phạm vi nhà xe / phân công / nền tảng. */
  async list(authz: Authorization, actor: { sub: string }, query: OperationsQuery): Promise<JourneyLogPage> {
    const { db, operatorId } = operationsReadScope(authz);
    return this.prisma.withScope(db, async (tx) => {
      const assigned = authz.scope === "assigned" ? await assignedTripIds(tx, operatorId!, actor.sub, query.tripId) : null;
      const where = { ...(operatorId ? { operatorId } : {}), ...(assigned ? { tripId: { in: assigned } } : query.tripId ? { tripId: query.tripId } : {}) };
      const cursor = query.cursor ? await tx.journeyLog.findFirst({ where: { ...where, id: query.cursor }, select: { id: true } }) : null;
      if (query.cursor && !cursor) return { items: [], nextCursor: null };
      const rows = await tx.journeyLog.findMany({ where, orderBy: [{ createdAt: "desc" }, { id: "desc" }], take: query.limit + 1, ...(cursor ? { cursor: { id: cursor.id }, skip: 1 } : {}) });
      return { items: rows.slice(0, query.limit).map(serialize), nextCursor: rows.length > query.limit ? rows[query.limit - 1]!.id : null };
    });
  }
}

function serialize(row: { id: string; operatorId: string; tripId: string; employeeId: string; stopSequence: number | null; actualAt: Date; vehicleStatus: string | null; note: string | null; delayMinutes: number; createdAt: Date }): JourneyLog {
  return { ...row, actualAt: row.actualAt.toISOString(), createdAt: row.createdAt.toISOString() };
}
