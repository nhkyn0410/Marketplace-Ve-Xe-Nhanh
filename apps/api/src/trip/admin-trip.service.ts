import { HttpException, HttpStatus, Inject, Injectable } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { decodeTimeCursor, encodeTimeCursor } from "../common/time-cursor";
import type { DbScope } from "../database/db-scope";
import { PrismaService, type DbTransaction } from "../database/prisma.service";
import { TicketStatus, TripSeatStatus } from "../database/prisma.types";
import { maskPhone } from "../booking/operator-booking.service";
import { vndToJson } from "../fare/fare-pricing";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { can } from "../iam/role/access-policy";
import type { Authorization } from "../iam/role/authorization";
import { vnDate, vnRange } from "../reporting/route-performance";
import type { AdminTrip, AdminTripDetail, AdminTripListQuery, AdminTripPage } from "./dto/admin-trip.dto";

type Viewer = Pick<VerifiedAccessToken, "sub" | "role" | "perms">;

const DAY_MS = 86_400_000;
/** Kỳ mặc định: hôm nay + 6 ngày tới (giờ VN). */
const DEFAULT_DAYS = 7;
const AUDIT_TIMEOUT_MS = 2_000;
const LIVE_TICKETS: TicketStatus[] = [TicketStatus.VALID, TicketStatus.CHECKED_IN, TicketStatus.NO_SHOW, TicketStatus.USED];

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  return new HttpException({ code, detail, title: "Trip error" }, status);
}
const tripNotFound = () => problem(HttpStatus.NOT_FOUND, "TRIP_NOT_FOUND", "Không tìm thấy chuyến.");
const auditUnavailable = () =>
  problem(HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE", "Chưa ghi được nhật ký lượt xem nên chưa hiện danh sách người đi. Vui lòng thử lại sau.");

/**
 * Admin giám sát chuyến của mọi nhà xe (tự thiết kế 28/10/2026, chờ duyệt). Chỉ đọc, ngữ cảnh platform. Chi tiết chuyến
 * có danh sách người đi (dữ liệu cá nhân) → mỗi lượt xem ghi audit (Security §239); chưa ghi được → 503, không trả dữ liệu.
 */
@Injectable()
export class AdminTripService {
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  async list(authz: Authorization, query: AdminTripListQuery, now: Date = new Date()): Promise<AdminTripPage> {
    const period = query.from && query.to ? { from: query.from, to: query.to } : { from: vnDate(now), to: vnDate(new Date(now.getTime() + (DEFAULT_DAYS - 1) * DAY_MS)) };
    const range = vnRange(period);
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const where = {
        departureAt: { gte: range.from, lt: range.to },
        operatorId: query.operatorId,
        routeId: query.routeId,
        status: query.status,
        ...(query.q
          ? {
              OR: [
                { route: { name: { contains: query.q, mode: "insensitive" as const } } },
                { vehicle: { plateNumber: { contains: query.q.toUpperCase().replace(/[\s.-]/g, "") } } },
              ],
            }
          : {}),
      };
      const after = query.cursor ? decodeTimeCursor(query.cursor) : null;
      const [rows, total] = await Promise.all([
        tx.trip.findMany({
          where: { AND: [where, after ? { OR: [{ departureAt: { gt: after.at } }, { departureAt: after.at, id: { gt: after.id } }] } : {}] },
          orderBy: [{ departureAt: "asc" }, { id: "asc" }],
          take: query.limit + 1,
          select: {
            id: true,
            departureAt: true,
            arrivalAt: true,
            status: true,
            operatorId: true,
            routeId: true,
            operator: { select: { displayName: true } },
            route: { select: { name: true } },
            vehicle: { select: { plateNumber: true } },
            _count: { select: { seats: true } },
          },
        }),
        tx.trip.count({ where }),
      ]);
      const kept = rows.slice(0, query.limit);
      const sold = await soldByTrip(tx, kept.map((row) => row.id));
      const last = kept.at(-1);
      return {
        items: kept.map(
          (row): AdminTrip => ({
            id: row.id,
            departureAt: row.departureAt.toISOString(),
            arrivalAt: row.arrivalAt.toISOString(),
            status: row.status,
            operatorId: row.operatorId,
            operatorName: row.operator.displayName,
            routeId: row.routeId,
            routeName: row.route.name,
            vehiclePlate: row.vehicle?.plateNumber ?? null,
            seats: row._count.seats,
            ticketsSold: sold.get(row.id) ?? 0,
          }),
        ),
        nextCursor: rows.length > query.limit && last ? encodeTimeCursor(last.departureAt, last.id) : null,
        total,
        period,
      };
    });
  }

  async detail(authz: Authorization, viewer: Viewer, id: string): Promise<AdminTripDetail> {
    const showMoney = can(viewer, "payment:monitor").allowed;
    const pointSelect = { select: { name: true, address: true } } as const;
    const trip = await this.prisma.withScope(platformDb(authz), async (tx) => {
      const row = await tx.trip.findUnique({
        where: { id },
        select: {
          id: true,
          departureAt: true,
          arrivalAt: true,
          status: true,
          statusReason: true,
          departedAt: true,
          completedAt: true,
          onlineSaleCutoffMinutes: true,
          operatorId: true,
          routeId: true,
          operator: { select: { displayName: true } },
          route: { select: { name: true } },
          vehicle: { select: { plateNumber: true, vehicleType: { select: { name: true } } } },
          stops: {
            orderBy: { sequence: "asc" },
            select: { sequence: true, plannedAt: true, allowPickup: true, allowDropoff: true, catalogStopPoint: pointSelect, stopPoint: pointSelect },
          },
          seats: { select: { status: true } },
          assignments: { orderBy: { createdAt: "asc" }, select: { role: true, employee: { select: { username: true } } } },
        },
      });
      if (!row) {
        throw tripNotFound();
      }
      const tickets = await tx.ticket.findMany({
        where: { tripId: id },
        orderBy: { seatCode: "asc" },
        select: {
          ticketCode: true,
          seatCode: true,
          status: true,
          passenger: { select: { fullName: true, phone: true, price: true } },
          booking: { select: { bookingCode: true, channel: true, userId: true } },
        },
      });
      const bookingCount = await tx.booking.count({ where: { tripId: id, tickets: { some: {} } } });
      return { row, tickets, bookingCount };
    });
    await this.audit
      .recordAuditEvent(
        {
          actorId: viewer.sub,
          actorRole: viewer.role,
          action: "trip.manifest.view",
          targetType: "trip",
          targetId: id,
          operatorId: trip.row.operatorId,
          before: null,
          after: { tickets: trip.tickets.length },
        },
        { timeoutMs: AUDIT_TIMEOUT_MS },
      )
      .catch((error: unknown) => {
        throw error instanceof AuditWriteError ? auditUnavailable() : error;
      });
    const { row, tickets } = trip;
    const live = tickets.filter((ticket) => LIVE_TICKETS.includes(ticket.status));
    const countSeats = (status: TripSeatStatus) => row.seats.filter((seat) => seat.status === status).length;
    return {
      id: row.id,
      departureAt: row.departureAt.toISOString(),
      arrivalAt: row.arrivalAt.toISOString(),
      status: row.status,
      operatorId: row.operatorId,
      operatorName: row.operator.displayName,
      routeId: row.routeId,
      routeName: row.route.name,
      vehiclePlate: row.vehicle?.plateNumber ?? null,
      seats: row.seats.length,
      ticketsSold: live.length,
      statusReason: row.statusReason,
      departedAt: row.departedAt?.toISOString() ?? null,
      completedAt: row.completedAt?.toISOString() ?? null,
      onlineSaleCutoffMinutes: row.onlineSaleCutoffMinutes,
      vehicleTypeName: row.vehicle?.vehicleType.name ?? null,
      stops: row.stops.map((stop) => {
        const point = stop.catalogStopPoint ?? stop.stopPoint;
        return {
          sequence: stop.sequence,
          name: point?.name ?? "",
          address: point?.address ?? "",
          plannedAt: stop.plannedAt.toISOString(),
          allowPickup: stop.allowPickup,
          allowDropoff: stop.allowDropoff,
        };
      }),
      seatSummary: {
        available: countSeats(TripSeatStatus.AVAILABLE),
        holding: countSeats(TripSeatStatus.HOLDING),
        booked: countSeats(TripSeatStatus.BOOKED),
        checkedIn: countSeats(TripSeatStatus.CHECKED_IN),
        blocked: countSeats(TripSeatStatus.BLOCKED),
      },
      staff: row.assignments.map((assignment) => ({ username: assignment.employee.username, role: assignment.role })),
      bookingCount: trip.bookingCount,
      ticketRevenue: showMoney ? vndToJson(live.reduce((sum, ticket) => sum + ticket.passenger.price, 0n)) : null,
      manifest: tickets.map((ticket) => ({
        ticketCode: ticket.ticketCode,
        seatCode: ticket.seatCode,
        fullName: ticket.passenger.fullName,
        phone: ticket.passenger.phone ? maskPhone(ticket.passenger.phone) : null,
        status: ticket.status,
        bookingCode: ticket.booking.bookingCode,
        channel: ticket.booking.channel,
        guest: ticket.booking.userId === null,
        userId: ticket.booking.userId,
      })),
    };
  }
}

async function soldByTrip(tx: DbTransaction, tripIds: string[]): Promise<Map<string, number>> {
  if (tripIds.length === 0) {
    return new Map();
  }
  const rows = await tx.ticket.groupBy({ by: ["tripId"], where: { tripId: { in: tripIds }, status: { in: LIVE_TICKETS } }, _count: { _all: true } });
  return new Map(rows.map((row) => [row.tripId, row._count._all]));
}

function platformDb(authz: Authorization): DbScope {
  if (authz.db?.kind !== "platform") {
    // Lỗi lập trình: route Admin thiếu `@Authorize` với quyền phạm vi `any`.
    throw new Error("Route Admin chuyến cần ngữ cảnh DB platform.");
  }
  return authz.db;
}
