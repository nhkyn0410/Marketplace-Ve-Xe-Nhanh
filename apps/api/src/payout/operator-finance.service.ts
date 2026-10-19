import { Inject, Injectable } from "@nestjs/common";
import { payoutDelayDays } from "../escrow/escrow-entries";
import { PrismaService } from "../database/prisma.service";
import { PayoutStatus } from "../database/prisma.types";
import { vndToJson } from "../fare/fare-pricing";
import type { Authorization } from "../iam/role/authorization";
import { requireTenant } from "../iam/role/require-tenant";
import type { PayoutDetail, PayoutPage } from "./dto/payout.dto";
import type { FINANCE_STATES, FinanceBookingPage, FinanceSummary } from "./dto/operator-finance.dto";
import { payoutNotFound } from "./payout.errors";
import { loadPayoutDetail, PAYOUT_SELECT, toPayoutSummary } from "./payout-view";

const VN_OFFSET_MS = 7 * 3_600_000;
const DAY_MS = 86_400_000;
const OPEN_REFUND = ["REQUESTED", "APPROVED", "PROCESSING", "FAILED"];

type FinanceState = (typeof FINANCE_STATES)[number];
type BookingQuery = { from: string; to: string; routeId?: string; state?: FinanceState; q?: string; cursor?: string; limit: number };
type PayoutQuery = { month?: string; status?: PayoutStatus; cursor?: string; limit: number };

type BookingRow = {
  id: string;
  bookingCode: string;
  tripId: string;
  departureAt: Date;
  arrivalAt: Date;
  routeName: string;
  gross: bigint;
  commission: bigint;
  other: bigint;
  eligibleAt: Date;
  state: FinanceState;
};

/**
 * Tài chính của nhà xe (TASK-OPR-002, FR-OPR-07/08, BR-08; Figma "Nhà xe · Tài chính"): số dư giữ hộ, tiền đủ điều kiện /
 * chờ, giao dịch theo đơn và các kỳ chi trả — chỉ dữ liệu của chính nhà xe (scope tenant + RLS). Chỉ đọc.
 */
@Injectable()
export class OperatorFinanceService {
  constructor(@Inject(PrismaService) private readonly prisma: PrismaService) {}

  async summary(authz: Authorization, now: Date = new Date()): Promise<FinanceSummary> {
    const { db, operatorId } = requireTenant(authz);
    return this.prisma.withScope(db, async (tx) => {
      const [totals] = await tx.$queryRaw<{ held: bigint | null; eligible: bigint | null; pending: bigint | null }[]>`
        SELECT
          SUM(e.amount)::bigint AS held,
          (SUM(e.amount) FILTER (
            WHERE COALESCE(t.payout_eligible_at, e.eligible_at) <= ${now} AND e.entry_type <> 'PAYOUT'
              AND NOT EXISTS (SELECT 1 FROM payout_items i WHERE i.ledger_entry_id = e.id)
              AND NOT EXISTS (
                SELECT 1 FROM refunds r JOIN payments pm ON pm.id = r.payment_id AND pm.operator_id = r.operator_id
                WHERE r.booking_id = e.booking_id AND r.operator_id = e.operator_id AND r.status::text = ANY(${OPEN_REFUND})
                  AND pm.status <> 'RECONCILING'
              )
          ))::bigint AS eligible,
          (SUM(e.amount) FILTER (WHERE COALESCE(t.payout_eligible_at, e.eligible_at) > ${now} AND e.entry_type <> 'PAYOUT'))::bigint AS pending
        FROM escrow_ledgers e
        -- BR-32: chuyến đã hoàn thành thực tế (TASK-EMP-002) → mốc = giờ hoàn thành + chu kỳ.
        LEFT JOIN trips t ON t.id = e.trip_id AND t.operator_id = e.operator_id
        WHERE e.operator_id = ${operatorId}`;
      const last = await tx.payout.findFirst({
        where: { operatorId, status: PayoutStatus.PAID },
        orderBy: { paidAt: "desc" },
        select: { id: true, amount: true, paidAt: true },
      });
      const money = (value: bigint | null | undefined) => {
        const amount = value ?? 0n;
        return amount < 0n ? -vndToJson(-amount) : vndToJson(amount);
      };
      return {
        heldBalance: money(totals?.held),
        eligibleAmount: money(totals?.eligible),
        pendingAmount: money(totals?.pending),
        lastPayout: last ? { payoutId: last.id, amount: vndToJson(last.amount), paidAt: last.paidAt!.toISOString() } : null,
        payoutDelayDays: await payoutDelayDays(tx, now),
      };
    });
  }

  /** Giao dịch theo đơn của các chuyến khởi hành trong khoảng ngày (giờ VN), chuyến mới trước. */
  async bookings(authz: Authorization, query: BookingQuery, now: Date = new Date()): Promise<FinanceBookingPage> {
    const { db, operatorId } = requireTenant(authz);
    const from = new Date(Date.parse(`${query.from}T00:00:00Z`) - VN_OFFSET_MS);
    const to = new Date(Date.parse(`${query.to}T00:00:00Z`) - VN_OFFSET_MS + DAY_MS);
    const rows = await this.prisma.withScope(db, async (tx) => {
      let cursorDeparture: Date | null = null;
      if (query.cursor) {
        const cursor = await tx.booking.findFirst({ where: { id: query.cursor, operatorId }, select: { trip: { select: { departureAt: true } } } });
        if (!cursor) {
          return [];
        }
        cursorDeparture = cursor.trip.departureAt;
      }
      const code = query.q ? `${query.q.toUpperCase().replace(/[\s-]/g, "")}%` : null;
      return tx.$queryRaw<BookingRow[]>`
        SELECT * FROM (
          SELECT b.id, b.booking_code AS "bookingCode", t.id AS "tripId", t.departure_at AS "departureAt", t.arrival_at AS "arrivalAt",
            r.name AS "routeName", agg.gross, agg.commission, agg.other, agg.eligible_at AS "eligibleAt",
            CASE
              WHEN agg.open_refund THEN 'ON_HOLD'
              WHEN agg.gross + agg.refunded <= 0 THEN 'REFUNDED'
              WHEN agg.eligible_at > ${now} THEN 'WAITING_TRIP'
              WHEN agg.unassigned > 0 THEN 'ELIGIBLE'
              WHEN agg.unpaid > 0 THEN 'IN_PAYOUT'
              ELSE 'PAID'
            END AS "state"
          FROM bookings b
          JOIN trips t ON t.id = b.trip_id AND t.operator_id = b.operator_id
          JOIN routes r ON r.id = t.route_id AND r.operator_id = t.operator_id
          JOIN LATERAL (
            SELECT
              -- SUM(bigint) trả numeric → ép về bigint (tiền BIGINT, không qua Decimal).
              COALESCE(SUM(e.amount) FILTER (WHERE e.entry_type IN ('PAYMENT_CAPTURED', 'PLATFORM_FUNDED_DISCOUNT')), 0)::bigint AS gross,
              (-COALESCE(SUM(e.amount) FILTER (WHERE e.entry_type IN ('COMMISSION', 'COMMISSION_REVERSAL')), 0))::bigint AS commission,
              COALESCE(SUM(e.amount) FILTER (WHERE e.entry_type IN ('REFUND', 'ADJUSTMENT', 'PLATFORM_FUNDED_DISCOUNT_REVERSAL')), 0)::bigint AS other,
              COALESCE(SUM(e.amount) FILTER (WHERE e.entry_type IN ('REFUND', 'PLATFORM_FUNDED_DISCOUNT_REVERSAL')), 0)::bigint AS refunded,
              COALESCE(t.payout_eligible_at, MIN(e.eligible_at)) AS eligible_at,
              COUNT(*) FILTER (WHERE i.id IS NULL) AS unassigned,
              COUNT(*) FILTER (WHERE i.id IS NOT NULL AND p.status <> 'PAID') AS unpaid,
              EXISTS (
                SELECT 1 FROM refunds rf JOIN payments pm ON pm.id = rf.payment_id AND pm.operator_id = rf.operator_id
                WHERE rf.booking_id = b.id AND rf.operator_id = b.operator_id AND rf.status::text = ANY(${OPEN_REFUND}) AND pm.status <> 'RECONCILING'
              ) AS open_refund,
              COUNT(*) AS entries
            FROM escrow_ledgers e
            LEFT JOIN payout_items i ON i.ledger_entry_id = e.id
            LEFT JOIN payouts p ON p.id = i.payout_id
            WHERE e.booking_id = b.id AND e.operator_id = b.operator_id
          ) agg ON agg.entries > 0
          WHERE b.operator_id = ${operatorId}
            AND t.departure_at >= ${from} AND t.departure_at < ${to}
            AND (${query.routeId ?? null}::text IS NULL OR t.route_id = ${query.routeId ?? null})
            AND (${code}::text IS NULL OR b.booking_code LIKE ${code})
        ) x
        WHERE (${query.state ?? null}::text IS NULL OR x.state = ${query.state ?? null})
          AND (${cursorDeparture}::timestamp IS NULL OR (x."departureAt", x.id) < (${cursorDeparture}::timestamp, ${query.cursor ?? ""}))
        ORDER BY x."departureAt" DESC, x.id DESC
        LIMIT ${query.limit + 1}`;
    });
    const page = rows.slice(0, query.limit);
    const signed = (value: bigint) => (value < 0n ? -vndToJson(-value) : vndToJson(value));
    return {
      items: page.map((row) => ({
        bookingId: row.id,
        bookingCode: row.bookingCode,
        trip: { tripId: row.tripId, departureAt: row.departureAt.toISOString(), arrivalAt: row.arrivalAt.toISOString(), routeName: row.routeName },
        grossAmount: vndToJson(row.gross),
        commissionAmount: signed(row.commission),
        refundAdjustmentAmount: signed(row.other),
        netAmount: signed(row.gross - row.commission + row.other),
        state: row.state,
        eligibleAt: row.eligibleAt.toISOString(),
      })),
      nextCursor: rows.length > query.limit ? page[page.length - 1]!.id : null,
    };
  }

  async payouts(authz: Authorization, query: PayoutQuery): Promise<PayoutPage> {
    const { db, operatorId } = requireTenant(authz);
    const rows = await this.prisma.withScope(db, async (tx) => {
      let after = {};
      if (query.cursor) {
        const cursor = await tx.payout.findFirst({ where: { id: query.cursor, operatorId }, select: { id: true, createdAt: true } });
        if (!cursor) {
          return [];
        }
        after = { OR: [{ createdAt: { lt: cursor.createdAt } }, { createdAt: cursor.createdAt, id: { lt: cursor.id } }] };
      }
      const month = query.month ? { gte: new Date(`${query.month}-01`), lt: nextMonth(query.month) } : undefined;
      return tx.payout.findMany({
        where: { operatorId, status: query.status, period: month, ...after },
        orderBy: [{ createdAt: "desc" }, { id: "desc" }],
        take: query.limit + 1,
        select: PAYOUT_SELECT,
      });
    });
    const page = rows.slice(0, query.limit);
    return { items: page.map(toPayoutSummary), nextCursor: rows.length > query.limit ? page[page.length - 1]!.id : null };
  }

  /** Chi tiết kỳ của chính nhà xe; người thao tác phía nền tảng hiện là "Vé Xe Nhanh" (không lộ tài khoản quản trị). */
  async payout(authz: Authorization, payoutId: string): Promise<PayoutDetail> {
    const { db, operatorId } = requireTenant(authz);
    const detail = await this.prisma.withScope(db, async (tx) => {
      if (!(await tx.payout.findFirst({ where: { id: payoutId, operatorId }, select: { id: true } }))) {
        return null;
      }
      return loadPayoutDetail(tx, payoutId, (actor) => (actor?.startsWith("platform:") ? "Vé Xe Nhanh" : null));
    });
    if (!detail) {
      throw payoutNotFound();
    }
    return detail;
  }
}

function nextMonth(month: string): Date {
  const [year, value] = month.split("-").map(Number) as [number, number];
  return value === 12 ? new Date(`${year + 1}-01-01`) : new Date(`${year}-${String(value + 1).padStart(2, "0")}-01`);
}
