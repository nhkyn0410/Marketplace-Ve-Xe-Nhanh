import { Inject, Injectable, Logger } from "@nestjs/common";
import { AuditService } from "../audit/audit.service";
import { maskPhone } from "../booking/operator-booking.service";
import { PrismaService, type DbTransaction } from "../database/prisma.service";
import { EmployeeRole, TicketStatus, TripSeatStatus, TripStatus } from "../database/prisma.types";
import { payoutDelayDays } from "../escrow/escrow-entries";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { requireAssignedTenant } from "../iam/role/require-tenant";
import { TicketQrSigner } from "../ticket/ticket-qr";
import { assignmentNotFound, checkInClosed, checkInRejected, ticketNotFound, tripOperationInvalid } from "./check-in.errors";
import type {
  CheckInInput,
  CheckInResult,
  EmployeeAssignmentList,
  ManifestTicket,
  TicketVerifyInput,
  TicketVerifyResult,
  TripOperationInput,
} from "./dto/employee-operations.dto";

const DAY_MS = 86_400_000;
const VN_OFFSET_MS = 7 * 3_600_000;
/** Vé còn đi chuyến (hiện trên danh sách khách). */
const ON_TRIP: TicketStatus[] = [TicketStatus.VALID, TicketStatus.CHECKED_IN, TicketStatus.NO_SHOW, TicketStatus.USED];
/** Trạng thái chuyến còn soát vé: từ lúc bán tới khi chưa hoàn thành (khách lên dọc đường). */
const CHECK_IN_OPEN: TripStatus[] = [TripStatus.OPEN_FOR_SALE, TripStatus.LOCKED, TripStatus.SOLD_OUT, TripStatus.BOARDING, TripStatus.DEPARTED, TripStatus.IN_PROGRESS];
/** Ghi nhận vắng mặt chỉ khi đã bắt đầu đón khách. */
const NO_SHOW_OPEN: TripStatus[] = [TripStatus.BOARDING, TripStatus.DEPARTED, TripStatus.IN_PROGRESS];
/** UC-21: thứ tự vận hành — trạng thái đích → trạng thái được chuyển từ. */
const OPERATION_FROM: Record<"BOARDING" | "DEPARTED" | "IN_PROGRESS" | "COMPLETED", TripStatus[]> = {
  BOARDING: [TripStatus.OPEN_FOR_SALE, TripStatus.LOCKED, TripStatus.SOLD_OUT],
  DEPARTED: [TripStatus.OPEN_FOR_SALE, TripStatus.LOCKED, TripStatus.SOLD_OUT, TripStatus.BOARDING],
  IN_PROGRESS: [TripStatus.DEPARTED],
  COMPLETED: [TripStatus.DEPARTED, TripStatus.IN_PROGRESS],
};
const REJECT_REASON: Partial<Record<TicketStatus, string>> = {
  CHECKED_IN: "Vé đã check-in trước đó.",
  CANCELLED: "Vé đã hủy.",
  REFUNDED: "Vé đã hoàn tiền.",
  NO_SHOW: "Vé đã ghi nhận vắng mặt.",
  USED: "Vé đã dùng cho chuyến đã hoàn thành.",
};

type Actor = Pick<VerifiedAccessToken, "sub" | "role">;

const TRIP_SELECT = {
  id: true,
  departureAt: true,
  arrivalAt: true,
  status: true,
  route: { select: { name: true } },
  vehicle: { select: { plateNumber: true } },
  stops: { orderBy: { sequence: "asc" }, select: { sequence: true, pickupWindowStart: true, pickupWindowEnd: true, catalogStopPoint: { select: { name: true } }, stopPoint: { select: { name: true } } } },
} as const;

type TripRow = {
  id: string;
  departureAt: Date;
  arrivalAt: Date;
  status: TripStatus;
  route: { name: string };
  vehicle: { plateNumber: string } | null;
  stops: { sequence: number; pickupWindowStart: Date | null; pickupWindowEnd: Date | null; catalogStopPoint: { name: string } | null; stopPoint: { name: string } | null }[];
};

/**
 * Thao tác của nhân viên trên chuyến ĐƯỢC PHÂN CÔNG (TASK-EMP-002 phần backend, API §7.4, UC-20/21, BR-05/29/44): xem chuyến
 * của mình, danh sách khách, soát vé bằng QR / mã vé (xác thực server-side theo hash), check-in / vắng mặt (có điều kiện —
 * hai máy quét cùng vé chỉ một lần thành công, lịch sử vé là nhật ký thao tác), tài xế đổi trạng thái vận hành. Hoàn thành
 * chuyến: vé đã lên → đã dùng, vé chưa lên → vắng mặt, mốc chi trả = giờ hoàn thành thực tế + chu kỳ (BR-32).
 */
@Injectable()
export class EmployeeOperationsService {
  private readonly logger = new Logger(EmployeeOperationsService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  async assignments(authz: Authorization, actor: Actor, query: { from?: string; to?: string }, now: Date = new Date()): Promise<EmployeeAssignmentList> {
    const { db, operatorId } = requireAssignedTenant(authz);
    const today = vnDayStart(new Date(now.getTime() + VN_OFFSET_MS).toISOString().slice(0, 10));
    const from = query.from ? vnDayStart(query.from) : new Date(today.getTime() - DAY_MS);
    const to = query.to ? new Date(vnDayStart(query.to).getTime() + DAY_MS) : new Date(today.getTime() + 8 * DAY_MS);
    return this.prisma.withScope(db, async (tx) => {
      const rows = await tx.employeeAssignment.findMany({
        where: { operatorId, employeeId: actor.sub, trip: { departureAt: { gte: from, lt: to }, status: { not: TripStatus.DRAFT } } },
        orderBy: { trip: { departureAt: "asc" } },
        select: { role: true, trip: { select: TRIP_SELECT } },
      });
      const items = [];
      for (const row of rows) {
        items.push(await summarize(tx, operatorId, row.trip, row.role));
      }
      return { items };
    });
  }

  async manifest(authz: Authorization, actor: Actor, tripId: string) {
    const { db, operatorId } = requireAssignedTenant(authz);
    return this.prisma.withScope(db, async (tx) => {
      const assignment = await requireAssignment(tx, operatorId, actor, tripId);
      const tickets = await loadTickets(tx, operatorId, { tripId, status: { in: ON_TRIP } }, assignment.trip);
      return {
        trip: await summarize(tx, operatorId, assignment.trip, assignment.role),
        passengers: tickets.sort((a, b) => a.pickup.sequence - b.pickup.sequence || a.seatCode.localeCompare(b.seatCode)),
      };
    });
  }

  /** Soát vé (không đổi gì): trả kết quả + thông tin đối chiếu (UC-20 bước 3–4). */
  async verify(authz: Authorization, actor: Actor, input: TicketVerifyInput): Promise<TicketVerifyResult> {
    const { db, operatorId } = requireAssignedTenant(authz);
    return this.prisma.withScope(db, async (tx) => {
      const assignment = await requireAssignment(tx, operatorId, actor, input.tripId);
      const found = await findTicket(tx, operatorId, input.code);
      if (found.tripId !== input.tripId) {
        const other = await tx.trip.findFirst({ where: { id: found.tripId, operatorId }, select: { departureAt: true, route: { select: { name: true } } } });
        return { result: "WRONG_TRIP", ticket: null, ticketCode: found.ticketCode, ticketTrip: other ? { routeName: other.route.name, departureAt: other.departureAt.toISOString() } : null };
      }
      const [ticket] = await loadTickets(tx, operatorId, { id: found.id }, assignment.trip);
      const result = found.status === TicketStatus.VALID ? "OK" : found.status === TicketStatus.CHECKED_IN ? "ALREADY_CHECKED_IN" : found.status;
      return { result, ticket: ticket!, ticketCode: found.ticketCode, ticketTrip: null };
    });
  }

  /** Check-in / vắng mặt (UC-20 bước 5–6, FR-EMP-08): có điều kiện `VALID →`, lịch sử vé ghi người thao tác. */
  async checkIn(authz: Authorization, actor: Actor, input: CheckInInput): Promise<CheckInResult> {
    const { db, operatorId } = requireAssignedTenant(authz);
    const by = `employee:${actor.sub}`;
    return this.prisma.withScope(db, async (tx) => {
      const assignment = await requireAssignment(tx, operatorId, actor, input.tripId);
      if (!CHECK_IN_OPEN.includes(assignment.trip.status)) {
        throw checkInClosed();
      }
      if (input.status === TicketStatus.NO_SHOW && !NO_SHOW_OPEN.includes(assignment.trip.status)) {
        throw checkInRejected("Chỉ ghi nhận vắng mặt sau khi chuyến bắt đầu đón khách.");
      }
      const found = await findTicket(tx, operatorId, input.code);
      if (found.tripId !== input.tripId) {
        throw checkInRejected("Vé thuộc chuyến khác.");
      }
      const now = new Date();
      if (input.status === TicketStatus.NO_SHOW) {
        const pickup = assignment.trip.stops.find((stop) => stop.sequence === found.booking.pickupSequence);
        if (pickup?.pickupWindowEnd && now.getTime() <= pickup.pickupWindowEnd.getTime()) {
          throw checkInRejected("Chưa hết cửa sổ đón tại điểm của hành khách.");
        }
      }
      const updated = await tx.ticket.updateMany({
        where: { id: found.id, operatorId, status: TicketStatus.VALID },
        data: { status: input.status, ...(input.status === TicketStatus.CHECKED_IN ? { checkedInAt: now } : {}) },
      });
      if (updated.count === 0) {
        const current = await tx.ticket.findFirstOrThrow({ where: { id: found.id, operatorId }, select: { status: true } });
        throw checkInRejected(REJECT_REASON[current.status] ?? "Vé không check-in được.");
      }
      await tx.ticketStatusHistory.create({
        data: {
          ticketId: found.id,
          operatorId,
          fromStatus: TicketStatus.VALID,
          toStatus: input.status,
          reason: input.status === TicketStatus.CHECKED_IN ? "Soát vé lên xe." : "Ghi nhận vắng mặt.",
          actor: by,
          createdAt: now,
        },
      });
      if (input.status === TicketStatus.CHECKED_IN) {
        await tx.tripSeat.updateMany({ where: { tripId: input.tripId, operatorId, seatCode: found.seatCode, status: TripSeatStatus.BOOKED }, data: { status: TripSeatStatus.CHECKED_IN } });
      }
      const [ticket] = await loadTickets(tx, operatorId, { id: found.id }, assignment.trip);
      const summary = await summarize(tx, operatorId, assignment.trip, assignment.role);
      return { ticket: ticket!, checkedInCount: summary.checkedInCount, ticketCount: summary.ticketCount };
    });
  }

  /** Tài xế đổi trạng thái vận hành theo thứ tự (UC-21, FR-EMP-09). Audit sau commit — Mongo lỗi không chặn tài xế. */
  async operate(authz: Authorization, actor: Actor, tripId: string, input: TripOperationInput) {
    const { db, operatorId } = requireAssignedTenant(authz);
    const by = `employee:${actor.sub}`;
    const result = await this.prisma.withScope(db, async (tx) => {
      const assignment = await requireAssignment(tx, operatorId, actor, tripId, EmployeeRole.DRIVER);
      const [locked] = await tx.$queryRaw<{ status: TripStatus }[]>`
        SELECT status::text AS "status" FROM trips WHERE id = ${tripId} AND operator_id = ${operatorId} FOR NO KEY UPDATE`;
      if (!locked || !OPERATION_FROM[input.status].includes(locked.status)) {
        throw tripOperationInvalid(`Không chuyển được chuyến từ ${locked?.status ?? "?"} sang ${input.status}.`);
      }
      const now = new Date();
      const data: Record<string, unknown> = { status: input.status };
      if (input.status === TripStatus.DEPARTED) {
        data.departedAt = now;
      }
      if (input.status === TripStatus.COMPLETED) {
        // BR-32: chu kỳ chi trả tính từ lúc hoàn thành thực tế.
        data.completedAt = now;
        data.payoutEligibleAt = new Date(now.getTime() + (await payoutDelayDays(tx, now)) * DAY_MS);
        await closeTickets(tx, operatorId, tripId, by, now);
      }
      await tx.trip.updateMany({ where: { id: tripId, operatorId, status: locked.status }, data });
      const trip = (await tx.trip.findFirst({ where: { id: tripId, operatorId }, select: TRIP_SELECT }))!;
      return { from: locked.status, summary: await summarize(tx, operatorId, trip, assignment.role) };
    });
    this.audit
      .recordAuditEvent({
        actorId: actor.sub,
        actorRole: actor.role,
        action: "trip.operation_status",
        targetType: "trip",
        targetId: tripId,
        operatorId,
        before: { status: result.from },
        after: { status: input.status },
        ...(input.note ? { reason: input.note } : {}),
      })
      .catch((error: unknown) => this.logger.error({ event: "audit.write_failed", action: "trip.operation_status", tripId, error }));
    return result.summary;
  }
}

/** Phân công của nhân viên cho chuyến (đúng vai trò nếu yêu cầu); không có → 404 như chuyến không tồn tại. */
async function requireAssignment(tx: DbTransaction, operatorId: string, actor: Actor, tripId: string, role?: EmployeeRole) {
  const assignment = await tx.employeeAssignment.findFirst({
    where: { operatorId, tripId, employeeId: actor.sub, ...(role ? { role } : {}) },
    select: { role: true, trip: { select: TRIP_SELECT } },
  });
  if (!assignment) {
    throw assignmentNotFound();
  }
  return assignment;
}

/** Vé theo mã gõ tay (`VXN…-NN`) hoặc theo QR (so hash — DB không lưu token). Vé nhà xe khác không thấy (RLS). */
async function findTicket(tx: DbTransaction, operatorId: string, code: string) {
  const ticketCode = /^VXN[A-Z0-9-]+-\d{2}$/i.test(code) ? code.toUpperCase() : null;
  const ticket = await tx.ticket.findFirst({
    where: { operatorId, ...(ticketCode ? { ticketCode } : { qrTokenHash: TicketQrSigner.hash(code) }) },
    select: { id: true, tripId: true, ticketCode: true, seatCode: true, status: true, booking: { select: { pickupSequence: true } } },
  });
  if (!ticket) {
    throw ticketNotFound();
  }
  return ticket;
}

async function loadTickets(tx: DbTransaction, operatorId: string, where: object, trip: TripRow): Promise<ManifestTicket[]> {
  const rows = await tx.ticket.findMany({
    where: { operatorId, ...where },
    orderBy: { seatCode: "asc" },
    select: {
      id: true,
      ticketCode: true,
      seatCode: true,
      status: true,
      checkedInAt: true,
      passenger: { select: { fullName: true, phone: true } },
      booking: { select: { contactPhone: true, pickupSequence: true, dropoffSequence: true } },
    },
  });
  const point = (sequence: number) => {
    const stop = trip.stops.find((item) => item.sequence === sequence);
    return { sequence, name: (stop?.catalogStopPoint ?? stop?.stopPoint)?.name ?? `Điểm ${sequence}`, pickupWindowStart: stop?.pickupWindowStart?.toISOString() ?? null, pickupWindowEnd: stop?.pickupWindowEnd?.toISOString() ?? null };
  };
  return rows.map((row) => ({
    ticketId: row.id,
    ticketCode: row.ticketCode,
    seatCode: row.seatCode,
    passengerName: row.passenger.fullName,
    phoneMasked: maskPhone(row.passenger.phone ?? row.booking.contactPhone),
    pickup: point(row.booking.pickupSequence),
    dropoff: point(row.booking.dropoffSequence),
    status: row.status,
    checkedInAt: row.checkedInAt?.toISOString() ?? null,
  }));
}

async function summarize(tx: DbTransaction, operatorId: string, trip: TripRow, role: EmployeeRole) {
  const counts = await tx.ticket.groupBy({ by: ["status"], where: { operatorId, tripId: trip.id, status: { in: ON_TRIP } }, _count: { _all: true } });
  const name = (stop: TripRow["stops"][number] | undefined) => (stop?.catalogStopPoint ?? stop?.stopPoint)?.name ?? "";
  return {
    tripId: trip.id,
    role,
    routeName: trip.route.name,
    departureAt: trip.departureAt.toISOString(),
    arrivalAt: trip.arrivalAt.toISOString(),
    status: trip.status,
    vehiclePlateNumber: trip.vehicle?.plateNumber ?? null,
    origin: name(trip.stops[0]),
    destination: name(trip.stops[trip.stops.length - 1]),
    ticketCount: counts.reduce((sum, row) => sum + row._count._all, 0),
    checkedInCount: counts.filter((row) => row.status === TicketStatus.CHECKED_IN || row.status === TicketStatus.USED).reduce((sum, row) => sum + row._count._all, 0),
  };
}

/** Hoàn thành chuyến: vé đã lên xe → đã dùng; vé còn hiệu lực mà chưa lên → vắng mặt (kèm lịch sử). */
async function closeTickets(tx: DbTransaction, operatorId: string, tripId: string, actor: string, now: Date): Promise<void> {
  for (const [from, to, reason] of [
    [TicketStatus.CHECKED_IN, TicketStatus.USED, "Chuyến hoàn thành."],
    [TicketStatus.VALID, TicketStatus.NO_SHOW, "Chuyến hoàn thành, khách không lên xe."],
  ] as const) {
    const tickets = await tx.ticket.findMany({ where: { tripId, operatorId, status: from }, select: { id: true } });
    if (tickets.length === 0) {
      continue;
    }
    await tx.ticket.updateMany({ where: { id: { in: tickets.map((ticket) => ticket.id) }, status: from }, data: { status: to } });
    await tx.ticketStatusHistory.createMany({ data: tickets.map((ticket) => ({ ticketId: ticket.id, operatorId, fromStatus: from, toStatus: to, reason, actor, createdAt: now })) });
  }
}

/** `2026-10-13` → 00:00 giờ VN ngày đó. */
function vnDayStart(date: string): Date {
  return new Date(`${date}T00:00:00+07:00`);
}
