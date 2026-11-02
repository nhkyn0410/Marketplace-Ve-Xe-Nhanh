import { Inject, Injectable } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import type { DbScope } from "../database/db-scope";
import { PrismaService, type DbTransaction } from "../database/prisma.service";
import { TicketStatus, type EmployeeRole, type PaymentProvider } from "../database/prisma.types";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { requireTenant } from "../iam/role/require-tenant";
import type {
  AdminOverview,
  AdminReport,
  AdminReportExportQuery,
  AdminReportQuery,
  OperatorOverview,
  OperatorReport,
  OperatorReportQuery,
} from "./dto/reporting.dto";
import { routePerformance } from "./route-performance";
import { auditUnavailable } from "./reporting.errors";

const DAY_MS = 86_400_000;
const VN_OFFSET_MS = 7 * 3_600_000;
/** Vé còn đi chuyến (đã bán, chưa hủy / hoàn). */
const SOLD: TicketStatus[] = [TicketStatus.VALID, TicketStatus.CHECKED_IN, TicketStatus.NO_SHOW, TicketStatus.USED];
const OPEN_REFUND = ["REQUESTED", "APPROVED", "PROCESSING", "FAILED"];
const AUDIT_TIMEOUT_MS = 2_000;

type Actor = Pick<VerifiedAccessToken, "sub" | "role">;
type RouteAgg = { routeId: string; routeName: string; trips: bigint; completed: bigint; seats: bigint; sold: bigint; cancelled: bigint; refunded: bigint; revenue: bigint; bookings: bigint };

/**
 * Báo cáo (TASK-RPT-001 / 002, FR-NSR-12/13, FR-ADM-17, BR-56): tính trực tiếp từ Postgres theo kỳ (giờ VN). Chỉ số theo chuyến
 * lấy chuyến KHỞI HÀNH trong kỳ (trừ nháp); tiền giao dịch lấy thanh toán thành công / hoàn tiền thành công theo giờ phát sinh.
 * Nhà xe chỉ thấy dữ liệu của mình (tenant + RLS); Admin xem toàn hệ thống. Xuất CSV ghi audit (BR-56).
 */
@Injectable()
export class ReportingService {
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  async operatorReport(authz: Authorization, query: OperatorReportQuery): Promise<OperatorReport> {
    const { db, operatorId } = requireTenant(authz);
    const { from, to } = range(query);
    return this.prisma.withScope(db, async (tx) => {
      const rows = await routeAggregates(tx, operatorId, from, to, query);
      const sum = (key: keyof RouteAgg) => rows.reduce((total, row) => total + Number(row[key]), 0);
      const slug = (await tx.operatorProfile.findUnique({ where: { id: operatorId }, select: { operatorSlug: true } }))?.operatorSlug ?? "";
      const reviews = await tx.review.aggregate({
        where: { operatorId, status: "VISIBLE", trip: { departureAt: { gte: from, lt: to }, ...(query.routeId ? { routeId: query.routeId } : {}), ...(query.vehicleId ? { vehicleId: query.vehicleId } : {}), ...(query.status ? { status: query.status } : {}) } },
        _avg: { rating: true }, _count: { _all: true },
      });
      const employees = await tx.$queryRaw<{ employeeId: string; username: string; role: EmployeeRole; assigned: bigint; completed: bigint; checked: bigint; incidents: bigint }[]>`
        SELECT e.id AS "employeeId", e.username, e.role::text AS "role",
          COUNT(DISTINCT t.id) AS assigned,
          COUNT(DISTINCT t.id) FILTER (WHERE t.status = 'COMPLETED') AS completed,
          (SELECT COUNT(*) FROM ticket_status_histories h
            WHERE h.operator_id = e.operator_id AND h.actor = 'employee:' || e.id AND h.to_status = 'CHECKED_IN'
              AND h.created_at >= ${from} AND h.created_at < ${to}) AS checked,
          (SELECT COUNT(*) FROM incident_reports i WHERE i.operator_id = e.operator_id AND i.employee_id = e.id
            AND i.created_at >= ${from} AND i.created_at < ${to}) AS incidents
        FROM employee_accounts e
        LEFT JOIN employee_assignments a ON a.employee_id = e.id AND a.operator_id = e.operator_id
        LEFT JOIN trips t ON t.id = a.trip_id AND t.operator_id = a.operator_id AND t.departure_at >= ${from} AND t.departure_at < ${to}
        WHERE e.operator_id = ${operatorId} AND e.status = 'ACTIVE'
        GROUP BY e.id, e.username, e.role
        ORDER BY checked DESC, assigned DESC, e.username`;
      return {
        totals: {
          grossRevenue: sum("revenue"),
          trips: sum("trips"),
          completedTrips: sum("completed"),
          ticketsSold: sum("sold"),
          bookings: sum("bookings"),
          seats: sum("seats"),
          cancelledTickets: sum("cancelled"),
          refundedTickets: sum("refunded"),
          averageRating: reviews._avg.rating,
          reviewCount: reviews._count._all,
        },
        byRoute: rows.map((row) => ({
          routeId: row.routeId,
          routeName: row.routeName,
          trips: Number(row.trips),
          completedTrips: Number(row.completed),
          seats: Number(row.seats),
          ticketsSold: Number(row.sold),
          grossRevenue: Number(row.revenue),
        })),
        employees: employees.map((row) => ({
          employeeId: row.employeeId,
          loginName: `${slug}/${row.username}`,
          role: row.role,
          assignedTrips: Number(row.assigned),
          completedTrips: Number(row.completed),
          ticketsChecked: Number(row.checked),
          incidentsReported: Number(row.incidents),
        })),
      };
    });
  }

  /** CSV theo tuyến (BR-56: ghi audit mỗi lần xuất). */
  async operatorReportCsv(authz: Authorization, actor: Actor, query: OperatorReportQuery): Promise<{ filename: string; csv: string }> {
    const report = await this.operatorReport(authz, query);
    await this.record(actor, "operator_report", query, report.byRoute.length, requireTenant(authz).operatorId);
    return {
      filename: `bao-cao-${query.from}-${query.to}.csv`,
      csv: csv(
      ["Tuyến", "Chuyến", "Chuyến hoàn thành", "Số chỗ", "Vé bán", "Lấp đầy (%)", "Doanh thu gộp (VND)"],
        report.byRoute.map((row) => [row.routeName, row.trips, row.completedTrips, row.seats, row.ticketsSold, percent(row.ticketsSold, row.seats), row.grossRevenue]),
      ),
    };
  }

  async operatorOverview(authz: Authorization, now: Date = new Date()): Promise<OperatorOverview> {
    const { db, operatorId } = requireTenant(authz);
    const today = vnDayStart(vnDate(now));
    const tomorrow = new Date(today.getTime() + DAY_MS);
    const weekEnd = new Date(tomorrow.getTime() + 7 * DAY_MS);
    const monthStart = vnDayStart(`${vnDate(now).slice(0, 7)}-01`);
    return this.prisma.withScope(db, async (tx) => {
      const window = async (from: Date, to: Date) => {
        const [row] = await tx.$queryRaw<{ trips: bigint; running: bigint; completed: bigint; seats: bigint; sold: bigint; revenue: bigint }[]>`
          SELECT COUNT(*) AS trips,
            COUNT(*) FILTER (WHERE t.status IN ('BOARDING', 'DEPARTED', 'IN_PROGRESS')) AS running,
            COUNT(*) FILTER (WHERE t.status = 'COMPLETED') AS completed,
            COALESCE(SUM((SELECT COUNT(*) FROM trip_seats s WHERE s.trip_id = t.id AND s.operator_id = t.operator_id)), 0)::bigint AS seats,
            COALESCE(SUM((SELECT COUNT(*) FROM tickets k WHERE k.trip_id = t.id AND k.operator_id = t.operator_id AND k.status::text = ANY(${SOLD}))), 0)::bigint AS sold,
            COALESCE(SUM((SELECT COALESCE(SUM(p.price), 0) FROM tickets k JOIN passenger_infos p ON p.id = k.passenger_info_id AND p.operator_id = k.operator_id
              WHERE k.trip_id = t.id AND k.operator_id = t.operator_id AND k.status::text = ANY(${SOLD}))), 0)::bigint AS revenue
          FROM trips t
          WHERE t.operator_id = ${operatorId} AND t.departure_at >= ${from} AND t.departure_at < ${to} AND t.status NOT IN ('DRAFT', 'CANCELLED')`;
        return row!;
      };
      const day = await window(today, tomorrow);
      const week = await window(tomorrow, weekEnd);
      const month = await window(monthStart, tomorrow);
      const tripsWithoutDriver = await tx.trip.count({
        where: {
          operatorId,
          status: { in: ["OPEN_FOR_SALE", "LOCKED", "SOLD_OUT"] },
          departureAt: { gte: now, lt: new Date(now.getTime() + 2 * DAY_MS) },
          assignments: { none: { role: "DRIVER" } },
        },
      });
      const draftTrips = await tx.trip.count({ where: { operatorId, status: "DRAFT", departureAt: { gte: now, lt: weekEnd } } });
      const pendingRefunds = await tx.booking.count({ where: { operatorId, status: { in: ["REFUND_PENDING", "REFUND_FAILED"] } } });
      const upcoming = await tx.trip.findMany({
        where: { operatorId, status: { notIn: ["DRAFT", "CANCELLED", "COMPLETED"] }, arrivalAt: { gte: now } },
        orderBy: { departureAt: "asc" },
        take: 6,
        select: {
          id: true,
          departureAt: true,
          status: true,
          route: { select: { name: true } },
          vehicle: { select: { plateNumber: true } },
          assignments: { where: { role: "DRIVER" }, select: { employee: { select: { username: true } } } },
          _count: { select: { seats: true } },
        },
      });
      const soldByTrip = upcoming.length
        ? await tx.ticket.groupBy({ by: ["tripId"], where: { operatorId, tripId: { in: upcoming.map((trip) => trip.id) }, status: { in: SOLD } }, _count: { _all: true } })
        : [];
      return {
        today: { trips: Number(day.trips), running: Number(day.running), ticketsSold: Number(day.sold), seats: Number(day.seats) },
        nextWeek: { trips: Number(week.trips), ticketsSold: Number(week.sold), seats: Number(week.seats) },
        month: { grossRevenue: Number(month.revenue), ticketsSold: Number(month.sold), completedTrips: Number(month.completed) },
        attention: { tripsWithoutDriver, draftTrips, pendingRefunds },
        upcoming: upcoming.map((trip) => ({
          tripId: trip.id,
          routeName: trip.route.name,
          departureAt: trip.departureAt.toISOString(),
          status: trip.status,
          vehiclePlateNumber: trip.vehicle?.plateNumber ?? null,
          ticketsSold: soldByTrip.find((row) => row.tripId === trip.id)?._count._all ?? 0,
          seats: trip._count.seats,
          driverName: trip.assignments[0]?.employee.username ?? null,
        })),
      };
    });
  }

  async adminReport(authz: Authorization, query: AdminReportQuery): Promise<AdminReport> {
    const db = platformDb(authz);
    const { from, to } = range(query);
    const operator = query.operatorId ?? null;
    const provider = query.provider ?? null;
    return this.prisma.withScope(db, async (tx) => {
      const operators = await tx.$queryRaw<{ operatorId: string; operatorName: string; trips: bigint; seats: bigint; sold: bigint; gmv: bigint; refunded: bigint }[]>`
        WITH trip_rows AS (
          SELECT t.operator_id,
            COUNT(*) AS trips,
            COALESCE(SUM((SELECT COUNT(*) FROM trip_seats s WHERE s.trip_id = t.id AND s.operator_id = t.operator_id)), 0) AS seats,
            COALESCE(SUM((SELECT COUNT(*) FROM tickets k WHERE k.trip_id = t.id AND k.operator_id = t.operator_id AND k.status::text = ANY(${SOLD}))), 0) AS sold
          FROM trips t
          WHERE t.departure_at >= ${from} AND t.departure_at < ${to} AND t.status NOT IN ('DRAFT', 'CANCELLED')
          GROUP BY t.operator_id
        ), pay AS (
          SELECT operator_id, SUM(amount) AS gmv FROM payments
          WHERE status = 'SUCCESS' AND paid_at >= ${from} AND paid_at < ${to} AND (${provider}::text IS NULL OR provider::text = ${provider})
          GROUP BY operator_id
        ), ref AS (
          SELECT operator_id, SUM(amount) AS refunded FROM refunds
          WHERE status = 'SUCCESS' AND processed_at >= ${from} AND processed_at < ${to}
          GROUP BY operator_id
        )
        SELECT o.id AS "operatorId", o.display_name AS "operatorName",
          COALESCE(tr.trips, 0)::bigint AS trips, COALESCE(tr.seats, 0)::bigint AS seats, COALESCE(tr.sold, 0)::bigint AS sold,
          COALESCE(pay.gmv, 0)::bigint AS gmv, COALESCE(ref.refunded, 0)::bigint AS refunded
        FROM operator_profiles o
        LEFT JOIN trip_rows tr ON tr.operator_id = o.id
        LEFT JOIN pay ON pay.operator_id = o.id
        LEFT JOIN ref ON ref.operator_id = o.id
        WHERE (${operator}::text IS NULL OR o.id = ${operator}) AND (tr.trips IS NOT NULL OR pay.gmv IS NOT NULL OR ref.refunded IS NOT NULL)
        ORDER BY gmv DESC, o.display_name
        LIMIT 200`;
      const [money] = await tx.$queryRaw<{ gmv: bigint; bookings: bigint; refunded: bigint }[]>`
        SELECT
          (SELECT COALESCE(SUM(amount), 0) FROM payments WHERE status = 'SUCCESS' AND paid_at >= ${from} AND paid_at < ${to}
            AND (${operator}::text IS NULL OR operator_id = ${operator}) AND (${provider}::text IS NULL OR provider::text = ${provider}))::bigint AS gmv,
          (SELECT COUNT(DISTINCT booking_id) FROM payments WHERE status = 'SUCCESS' AND paid_at >= ${from} AND paid_at < ${to}
            AND (${operator}::text IS NULL OR operator_id = ${operator}) AND (${provider}::text IS NULL OR provider::text = ${provider}))::bigint AS bookings,
          (SELECT COALESCE(SUM(amount), 0) FROM refunds WHERE status = 'SUCCESS' AND processed_at >= ${from} AND processed_at < ${to}
            AND (${operator}::text IS NULL OR operator_id = ${operator}))::bigint AS refunded`;
      const [tripTotals] = await tx.$queryRaw<{ trips: bigint; completed: bigint; seats: bigint; sold: bigint; tickets: bigint; cancelledWithSales: bigint; withSales: bigint }[]>`
        SELECT
          COUNT(*) FILTER (WHERE t.status <> 'CANCELLED') AS trips,
          COUNT(*) FILTER (WHERE t.status = 'COMPLETED') AS completed,
          COALESCE(SUM((SELECT COUNT(*) FROM trip_seats s WHERE s.trip_id = t.id AND s.operator_id = t.operator_id)) FILTER (WHERE t.status <> 'CANCELLED'), 0)::bigint AS seats,
          COALESCE(SUM((SELECT COUNT(*) FROM tickets k WHERE k.trip_id = t.id AND k.operator_id = t.operator_id AND k.status::text = ANY(${SOLD}))), 0)::bigint AS sold,
          (SELECT COUNT(*) FROM tickets k WHERE k.issued_at >= ${from} AND k.issued_at < ${to} AND (${operator}::text IS NULL OR k.operator_id = ${operator}))::bigint AS tickets,
          COUNT(*) FILTER (WHERE t.status = 'CANCELLED' AND EXISTS (SELECT 1 FROM tickets k WHERE k.trip_id = t.id AND k.operator_id = t.operator_id)) AS "cancelledWithSales",
          COUNT(*) FILTER (WHERE EXISTS (SELECT 1 FROM tickets k WHERE k.trip_id = t.id AND k.operator_id = t.operator_id)) AS "withSales"
        FROM trips t
        WHERE t.departure_at >= ${from} AND t.departure_at < ${to} AND t.status <> 'DRAFT' AND (${operator}::text IS NULL OR t.operator_id = ${operator})`;
      const methods = await tx.$queryRaw<{ provider: PaymentProvider; amount: bigint; count: bigint }[]>`
        SELECT provider::text AS provider, COALESCE(SUM(amount), 0)::bigint AS amount, COUNT(*) AS count FROM payments
        WHERE status = 'SUCCESS' AND paid_at >= ${from} AND paid_at < ${to} AND (${operator}::text IS NULL OR operator_id = ${operator})
        GROUP BY provider ORDER BY amount DESC`;
      const reconcileOpen = await tx.payment.count({
        where: { status: "RECONCILING", refunds: { none: { status: { in: ["REQUESTED", "APPROVED", "PROCESSING", "SUCCESS"] } } }, ...(operator ? { operatorId: operator } : {}) },
      });
      const reviews = await tx.review.groupBy({ by: ["operatorId"], where: { status: "VISIBLE", ...(operator ? { operatorId: operator } : {}), trip: { departureAt: { gte: from, lt: to } } }, _avg: { rating: true }, _count: { _all: true } });
      return {
        totals: {
          gmv: Number(money!.gmv),
          bookings: Number(money!.bookings),
          tickets: Number(tripTotals!.tickets),
          netRevenue: Number(money!.gmv - money!.refunded),
          reconcileOpen,
          trips: Number(tripTotals!.trips),
          completedTrips: Number(tripTotals!.completed),
          seats: Number(tripTotals!.seats),
          ticketsSold: Number(tripTotals!.sold),
          operatorCancelledTrips: Number(tripTotals!.cancelledWithSales),
          tripsWithSales: Number(tripTotals!.withSales),
          supportTickets: await tx.supportTicket.count({ where: { createdAt: { gte: from, lt: to }, ...(operator ? { operatorId: operator } : {}) } }),
          disputesOpened: await tx.disputeCase.count({ where: { createdAt: { gte: from, lt: to }, ...(operator ? { operatorId: operator } : {}) } }),
        },
        byOperator: operators.map((row) => ({
          operatorId: row.operatorId,
          operatorName: row.operatorName,
          trips: Number(row.trips),
          ticketsSold: Number(row.sold),
          seats: Number(row.seats),
          gmv: Number(row.gmv),
          refunded: Number(row.refunded),
          averageRating: reviews.find((review) => review.operatorId === row.operatorId)?._avg.rating ?? null,
          reviewCount: reviews.find((review) => review.operatorId === row.operatorId)?._count._all ?? 0,
        })),
        paymentMethods: methods.map((row) => ({ provider: row.provider, amount: Number(row.amount), count: Number(row.count) })),
        ...(await routeBreakdown(tx, from, to, operator)),
      };
    });
  }

  /** CSV theo nhà xe / tuyến / khu vực (BR-56: ghi audit mỗi lần xuất). */
  async adminReportCsv(authz: Authorization, actor: Actor, query: AdminReportQuery & { group?: AdminReportExportQuery["group"] }): Promise<{ filename: string; csv: string }> {
    const report = await this.adminReport(authz, query);
    if (query.group === "route") {
      await this.record(actor, "platform_report_route", query, report.byRoute.length);
      return {
        filename: `bao-cao-theo-tuyen-${query.from}-${query.to}.csv`,
        csv: csv(
          ["Tuyến", "Nhà xe", "Tỉnh đi", "Tỉnh đến", "Chuyến", "Vé bán", "Lấp đầy (%)", "Doanh thu vé (VND)"],
          report.byRoute.map((row) => [row.routeName, row.operatorName, row.originName ?? "", row.destinationName ?? "", row.trips, row.ticketsSold, percent(row.ticketsSold, row.seats), row.ticketRevenue]),
        ),
      };
    }
    if (query.group === "region") {
      await this.record(actor, "platform_report_region", query, report.byRegion.length);
      return {
        filename: `bao-cao-theo-khu-vuc-${query.from}-${query.to}.csv`,
        csv: csv(
          ["Tỉnh đi", "Tỉnh đến", "Số tuyến", "Số nhà xe", "Chuyến", "Vé bán", "Lấp đầy (%)", "Doanh thu vé (VND)"],
          report.byRegion.map((row) => [row.originName, row.destinationName, row.routes, row.operators, row.trips, row.ticketsSold, percent(row.ticketsSold, row.seats), row.ticketRevenue]),
        ),
      };
    }
    await this.record(actor, "platform_report", query, report.byOperator.length);
    return {
      filename: `bao-cao-he-thong-${query.from}-${query.to}.csv`,
      csv: csv(
      ["Nhà xe", "Chuyến", "Vé bán", "Lấp đầy (%)", "Giá trị giao dịch (VND)", "Đã hoàn (VND)", "Điểm đánh giá", "Lượt đánh giá"],
        report.byOperator.map((row) => [row.operatorName, row.trips, row.ticketsSold, percent(row.ticketsSold, row.seats), row.gmv, row.refunded, row.averageRating ?? "", row.reviewCount]),
      ),
    };
  }

  async adminOverview(authz: Authorization, query: AdminReportQuery, now: Date = new Date()): Promise<AdminOverview> {
    const db = platformDb(authz);
    const { from, to } = range(query);
    const previousFrom = new Date(from.getTime() - (to.getTime() - from.getTime()));
    const operator = query.operatorId ?? null;
    const provider = query.provider ?? null;
    return this.prisma.withScope(db, async (tx) => {
      const gmvBetween = async (start: Date, end: Date) => {
        const [row] = await tx.$queryRaw<{ gmv: bigint }[]>`
          SELECT COALESCE(SUM(amount), 0)::bigint AS gmv FROM payments
          WHERE status = 'SUCCESS' AND paid_at >= ${start} AND paid_at < ${end}
            AND (${operator}::text IS NULL OR operator_id = ${operator}) AND (${provider}::text IS NULL OR provider::text = ${provider})`;
        return Number(row!.gmv);
      };
      const [bookings] = await tx.$queryRaw<{ total: bigint; confirmed: bigint; lost: bigint }[]>`
        SELECT COUNT(*) AS total,
          COUNT(*) FILTER (WHERE paid_at IS NOT NULL) AS confirmed,
          COUNT(*) FILTER (WHERE status IN ('EXPIRED', 'CANCELLED') AND paid_at IS NULL) AS lost
        FROM bookings WHERE created_at >= ${from} AND created_at < ${to} AND (${operator}::text IS NULL OR operator_id = ${operator})`;
      const [tickets] = await tx.$queryRaw<{ issued: bigint; refunded: bigint }[]>`
        SELECT COUNT(*) AS issued, COUNT(*) FILTER (WHERE status = 'REFUNDED') AS refunded
        FROM tickets WHERE issued_at >= ${from} AND issued_at < ${to} AND (${operator}::text IS NULL OR operator_id = ${operator})`;
      const [escrow] = await tx.$queryRaw<{ held: bigint | null; eligible: bigint | null; pending: bigint | null; onHold: bigint | null; commission: bigint | null }[]>`
        SELECT
          SUM(e.amount)::bigint AS held,
          (SUM(e.amount) FILTER (
            WHERE COALESCE(t.payout_eligible_at, e.eligible_at) <= ${now} AND e.entry_type <> 'PAYOUT'
              AND NOT EXISTS (SELECT 1 FROM payout_items i WHERE i.ledger_entry_id = e.id)
          ))::bigint AS eligible,
          (SUM(e.amount) FILTER (WHERE COALESCE(t.payout_eligible_at, e.eligible_at) > ${now} AND e.entry_type <> 'PAYOUT'))::bigint AS pending,
          (SUM(e.amount) FILTER (
            WHERE e.entry_type <> 'PAYOUT' AND EXISTS (
              SELECT 1 FROM refunds r JOIN payments pm ON pm.id = r.payment_id AND pm.operator_id = r.operator_id
              WHERE r.booking_id = e.booking_id AND r.operator_id = e.operator_id AND r.status::text = ANY(${OPEN_REFUND}) AND pm.status <> 'RECONCILING'
            )
          ))::bigint AS "onHold",
          (-SUM(e.amount) FILTER (WHERE e.entry_type IN ('COMMISSION', 'COMMISSION_REVERSAL') AND e.created_at >= ${from} AND e.created_at < ${to}))::bigint AS commission
        FROM escrow_ledgers e
        LEFT JOIN trips t ON t.id = e.trip_id AND t.operator_id = e.operator_id
        WHERE (${operator}::text IS NULL OR e.operator_id = ${operator})`;
      const dailyRows = await tx.$queryRaw<{ day: string; gmv: bigint }[]>`
        SELECT to_char(paid_at + interval '7 hours', 'YYYY-MM-DD') AS day, COALESCE(SUM(amount), 0)::bigint AS gmv FROM payments
        WHERE status = 'SUCCESS' AND paid_at >= ${from} AND paid_at < ${to}
          AND (${operator}::text IS NULL OR operator_id = ${operator}) AND (${provider}::text IS NULL OR provider::text = ${provider})
        GROUP BY 1`;
      const days = Math.min(Math.round((to.getTime() - from.getTime()) / DAY_MS), 31);
      const daily = Array.from({ length: days }, (_, index) => {
        const date = vnDate(new Date(to.getTime() - (days - index) * DAY_MS));
        return { date, gmv: Number(dailyRows.find((row) => row.day === date)?.gmv ?? 0n) };
      });
      const scope = operator ? { operatorId: operator } : {};
      return {
        gmv: await gmvBetween(from, to),
        previousGmv: await gmvBetween(previousFrom, from),
        bookings: { total: Number(bookings!.total), confirmed: Number(bookings!.confirmed), cancelledOrExpired: Number(bookings!.lost) },
        tickets: { issued: Number(tickets!.issued), refunded: Number(tickets!.refunded) },
        escrow: { held: Number(escrow!.held ?? 0n), eligible: Number(escrow!.eligible ?? 0n), pending: Number(escrow!.pending ?? 0n), onHold: Number(escrow!.onHold ?? 0n), commissionInRange: Number(escrow!.commission ?? 0n) },
        daily,
        queues: {
          payoutsPendingReview: await tx.payout.count({ where: { status: "PENDING_REVIEW", ...scope } }),
          refundsFailed: await tx.refund.count({ where: { status: "FAILED", ...scope } }),
          reconcileOpen: await tx.payment.count({ where: { status: "RECONCILING", refunds: { none: { status: { in: ["REQUESTED", "APPROVED", "PROCESSING", "SUCCESS"] } } }, ...scope } }),
        },
      };
    });
  }

  /** BR-56: xuất báo cáo phải có nhật ký — ghi không được thì không xuất (503). */
  private async record(actor: Actor, targetType: string, query: { from: string; to: string }, rows: number, operatorId?: string): Promise<void> {
    try {
      await this.audit.recordAuditEvent(
        { actorId: actor.sub, actorRole: actor.role, action: "report.export", targetType, targetId: `${query.from}_${query.to}`, operatorId, after: { ...query, rows } },
        { timeoutMs: AUDIT_TIMEOUT_MS },
      );
    } catch (error) {
      if (error instanceof AuditWriteError) {
        throw auditUnavailable();
      }
      throw error;
    }
  }
}

/** Tổng hợp theo tuyến cho chuyến khởi hành trong kỳ (trừ nháp; chuyến hủy chỉ tính vé hủy). */
function routeAggregates(tx: DbTransaction, operatorId: string, from: Date, to: Date, query: OperatorReportQuery): Promise<RouteAgg[]> {
  const routeId = query.routeId ?? null;
  const vehicleId = query.vehicleId ?? null;
  const status = query.status ?? null;
  return tx.$queryRaw<RouteAgg[]>`
    WITH per_trip AS (
      SELECT t.id, t.route_id, t.status,
        (SELECT COUNT(*) FROM trip_seats s WHERE s.trip_id = t.id AND s.operator_id = t.operator_id) AS seats,
        (SELECT COUNT(*) FROM tickets k WHERE k.trip_id = t.id AND k.operator_id = t.operator_id AND k.status::text = ANY(${SOLD})) AS sold,
        (SELECT COUNT(*) FROM tickets k WHERE k.trip_id = t.id AND k.operator_id = t.operator_id AND k.status IN ('CANCELLED', 'REFUNDED')) AS cancelled,
        (SELECT COUNT(*) FROM tickets k WHERE k.trip_id = t.id AND k.operator_id = t.operator_id AND k.status = 'REFUNDED') AS refunded,
        (SELECT COALESCE(SUM(p.price), 0) FROM tickets k JOIN passenger_infos p ON p.id = k.passenger_info_id AND p.operator_id = k.operator_id
          WHERE k.trip_id = t.id AND k.operator_id = t.operator_id AND k.status::text = ANY(${SOLD})) AS revenue,
        (SELECT COUNT(DISTINCT k.booking_id) FROM tickets k WHERE k.trip_id = t.id AND k.operator_id = t.operator_id AND k.status::text = ANY(${SOLD})) AS bookings
      FROM trips t
      WHERE t.operator_id = ${operatorId} AND t.departure_at >= ${from} AND t.departure_at < ${to} AND t.status <> 'DRAFT'
        AND (${routeId}::text IS NULL OR t.route_id = ${routeId})
        AND (${vehicleId}::text IS NULL OR t.vehicle_id = ${vehicleId})
        AND (${status}::text IS NULL OR t.status::text = ${status})
    )
    SELECT r.id AS "routeId", r.name AS "routeName",
      COUNT(*) FILTER (WHERE p.status <> 'CANCELLED') AS trips,
      COUNT(*) FILTER (WHERE p.status = 'COMPLETED') AS completed,
      COALESCE(SUM(p.seats) FILTER (WHERE p.status <> 'CANCELLED'), 0)::bigint AS seats,
      COALESCE(SUM(p.sold), 0)::bigint AS sold,
      COALESCE(SUM(p.cancelled), 0)::bigint AS cancelled,
      COALESCE(SUM(p.refunded), 0)::bigint AS refunded,
      COALESCE(SUM(p.revenue), 0)::bigint AS revenue,
      COALESCE(SUM(p.bookings), 0)::bigint AS bookings
    FROM per_trip p JOIN routes r ON r.id = p.route_id AND r.operator_id = ${operatorId}
    GROUP BY r.id, r.name
    ORDER BY revenue DESC, r.name`;
}

function range(query: { from: string; to: string }): { from: Date; to: Date } {
  return { from: vnDayStart(query.from), to: new Date(vnDayStart(query.to).getTime() + DAY_MS) };
}

function vnDayStart(date: string): Date {
  return new Date(`${date}T00:00:00+07:00`);
}

function vnDate(at: Date): string {
  return new Date(at.getTime() + VN_OFFSET_MS).toISOString().slice(0, 10);
}

function percent(part: number, whole: number): string {
  return whole === 0 ? "0" : ((part / whole) * 100).toFixed(1);
}

/** CSV UTF-8 có BOM (Excel đọc đúng tiếng Việt); mọi ô bọc ngoặc kép, chặn công thức (CSV injection) ở ô chữ. */
function csv(header: string[], rows: (string | number)[][]): string {
  const cell = (value: string | number) => {
    const text = typeof value === "string" && /^[=+\-@\t\r]/.test(value) ? `'${value}` : String(value);
    return `"${text.replace(/"/g, '""')}"`;
  };
  return `﻿${[header, ...rows].map((row) => row.map(cell).join(",")).join("\r\n")}\r\n`;
}

function platformDb(authz: Authorization): DbScope {
  if (authz.db?.kind !== "platform") {
    // Lỗi lập trình: route Admin thiếu `@Authorize` với quyền chỉ role Platform có.
    throw new Error("Route Admin báo cáo cần ngữ cảnh DB platform (quyền `payment:monitor`).");
  }
  return authz.db;
}

/** Số dòng tối đa của khối Theo tuyến / Theo khu vực. */
const BREAKDOWN_LIMIT = 50;

type Totals = { sold: bigint; revenue: bigint };
const bySold = (a: Totals, b: Totals) => (a.sold === b.sold ? (a.revenue === b.revenue ? 0 : a.revenue < b.revenue ? 1 : -1) : a.sold < b.sold ? 1 : -1);

/**
 * Theo tuyến + theo khu vực (cặp tỉnh điểm đầu → điểm cuối) cho báo cáo Admin (FR-NSR-13; chờ duyệt 28/10/2026). Xếp theo
 * vé bán, rồi doanh thu vé.
 */
async function routeBreakdown(tx: DbTransaction, from: Date, to: Date, operatorId: string | null): Promise<Pick<AdminReport, "byRoute" | "byRegion">> {
  const rows = (await routePerformance(tx, { from, to, operatorId })).map((row) => ({
    ...row,
    trips: BigInt(row.trips),
    seats: BigInt(row.seats),
    sold: BigInt(row.sold),
    revenue: BigInt(row.revenue),
  }));
  if (rows.length === 0) {
    return { byRoute: [], byRegion: [] };
  }
  const routes = await tx.route.findMany({
    where: { id: { in: rows.map((row) => row.routeId) } },
    select: {
      id: true,
      name: true,
      operator: { select: { displayName: true } },
      stops: { orderBy: { sequence: "asc" }, select: { catalogStopPoint: { select: { provinceId: true } }, stopPoint: { select: { provinceId: true } } } },
    },
  });
  type Stop = (typeof routes)[number]["stops"][number] | undefined;
  const provinceOf = (stop: Stop) => stop?.catalogStopPoint?.provinceId ?? stop?.stopPoint?.provinceId ?? null;
  const info = new Map(routes.map((route) => [route.id, { ...route, origin: provinceOf(route.stops[0]), destination: provinceOf(route.stops.at(-1)) }]));
  const provinceIds = [...new Set([...info.values()].flatMap((route) => [route.origin, route.destination]).filter((id): id is string => Boolean(id)))];
  const names = new Map((await tx.province.findMany({ where: { id: { in: provinceIds } }, select: { id: true, name: true } })).map((province) => [province.id, province.name]));

  const byRoute = [...rows]
    .sort(bySold)
    .slice(0, BREAKDOWN_LIMIT)
    .map((row) => {
      const route = info.get(row.routeId);
      return {
        routeId: row.routeId,
        routeName: route?.name ?? "",
        operatorId: row.operatorId,
        operatorName: route?.operator.displayName ?? "",
        originName: route?.origin ? (names.get(route.origin) ?? null) : null,
        destinationName: route?.destination ? (names.get(route.destination) ?? null) : null,
        trips: Number(row.trips),
        seats: Number(row.seats),
        ticketsSold: Number(row.sold),
        ticketRevenue: Number(row.revenue),
      };
    });

  const regions = new Map<string, { origin: string; destination: string; routes: number; operators: Set<string>; trips: bigint; seats: bigint; sold: bigint; revenue: bigint }>();
  for (const row of rows) {
    const route = info.get(row.routeId);
    if (!route?.origin || !route.destination) {
      continue;
    }
    const key = `${route.origin}>${route.destination}`;
    const region = regions.get(key) ?? { origin: route.origin, destination: route.destination, routes: 0, operators: new Set<string>(), trips: 0n, seats: 0n, sold: 0n, revenue: 0n };
    region.routes += 1;
    region.operators.add(row.operatorId);
    region.trips += row.trips;
    region.seats += row.seats;
    region.sold += row.sold;
    region.revenue += row.revenue;
    regions.set(key, region);
  }
  const byRegion = [...regions.values()]
    .sort(bySold)
    .slice(0, BREAKDOWN_LIMIT)
    .map((region) => ({
      originProvinceId: region.origin,
      originName: names.get(region.origin) ?? "",
      destinationProvinceId: region.destination,
      destinationName: names.get(region.destination) ?? "",
      routes: region.routes,
      operators: region.operators.size,
      trips: Number(region.trips),
      seats: Number(region.seats),
      ticketsSold: Number(region.sold),
      ticketRevenue: Number(region.revenue),
    }));
  return { byRoute, byRegion };
}
