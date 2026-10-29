import type { DbTransaction } from "../database/prisma.service";
import { TicketStatus } from "../database/prisma.types";

/** Vé còn đi chuyến (đã bán, chưa hủy / hoàn) — cùng định nghĩa với báo cáo. */
const SOLD: TicketStatus[] = [TicketStatus.VALID, TicketStatus.CHECKED_IN, TicketStatus.NO_SHOW, TicketStatus.USED];

/** Số liệu một tuyến trong kỳ (chuyến khởi hành trong kỳ, trừ nháp). Tiền = tổng giá vé đã bán (VND, BigInt). */
export type RoutePerformanceRow = {
  routeId: string;
  operatorId: string;
  /** Chuyến không bị hủy. */
  trips: bigint;
  completed: bigint;
  cancelledTrips: bigint;
  seats: bigint;
  sold: bigint;
  revenue: bigint;
};

/**
 * Hiệu suất theo tuyến cho Admin (FR-NSR-13 "theo tuyến"; tự thiết kế 28/10/2026, chờ duyệt) — chạy trong ngữ cảnh
 * platform của request Admin. Chỉ trả tuyến CÓ chuyến trong kỳ; `operatorId` / `routeIds` thu hẹp phạm vi.
 */
export function routePerformance(
  tx: DbTransaction,
  filter: { from: Date; to: Date; operatorId?: string | null; routeIds?: readonly string[] | null },
): Promise<RoutePerformanceRow[]> {
  const operatorId = filter.operatorId ?? null;
  const routeIds = filter.routeIds ? [...filter.routeIds] : null;
  return tx.$queryRaw<RoutePerformanceRow[]>`
    WITH per_trip AS (
      SELECT t.id, t.route_id, t.operator_id, t.status,
        (SELECT COUNT(*) FROM trip_seats s WHERE s.trip_id = t.id AND s.operator_id = t.operator_id) AS seats,
        (SELECT COUNT(*) FROM tickets k WHERE k.trip_id = t.id AND k.operator_id = t.operator_id AND k.status::text = ANY(${SOLD})) AS sold,
        (SELECT COALESCE(SUM(p.price), 0) FROM tickets k JOIN passenger_infos p ON p.id = k.passenger_info_id AND p.operator_id = k.operator_id
          WHERE k.trip_id = t.id AND k.operator_id = t.operator_id AND k.status::text = ANY(${SOLD})) AS revenue
      FROM trips t
      WHERE t.departure_at >= ${filter.from} AND t.departure_at < ${filter.to} AND t.status <> 'DRAFT'
        AND (${operatorId}::text IS NULL OR t.operator_id = ${operatorId})
        AND (${routeIds}::text[] IS NULL OR t.route_id = ANY(${routeIds}::text[]))
    )
    SELECT route_id AS "routeId", operator_id AS "operatorId",
      COUNT(*) FILTER (WHERE status <> 'CANCELLED') AS trips,
      COUNT(*) FILTER (WHERE status = 'COMPLETED') AS completed,
      COUNT(*) FILTER (WHERE status = 'CANCELLED') AS "cancelledTrips",
      COALESCE(SUM(seats) FILTER (WHERE status <> 'CANCELLED'), 0)::bigint AS seats,
      COALESCE(SUM(sold), 0)::bigint AS sold,
      COALESCE(SUM(revenue), 0)::bigint AS revenue
    FROM per_trip
    GROUP BY route_id, operator_id`;
}

/** Cộng dồn nhiều dòng tuyến (thẻ số của một nhà xe / một khu vực). */
export function sumPerformance(rows: readonly RoutePerformanceRow[]): Omit<RoutePerformanceRow, "routeId" | "operatorId"> {
  const total = { trips: 0n, completed: 0n, cancelledTrips: 0n, seats: 0n, sold: 0n, revenue: 0n };
  for (const row of rows) {
    total.trips += BigInt(row.trips);
    total.completed += BigInt(row.completed);
    total.cancelledTrips += BigInt(row.cancelledTrips);
    total.seats += BigInt(row.seats);
    total.sold += BigInt(row.sold);
    total.revenue += BigInt(row.revenue);
  }
  return total;
}

const DAY_MS = 86_400_000;
const VN_OFFSET_MS = 7 * 3_600_000;

/** Ngày `YYYY-MM-DD` theo giờ Việt Nam. */
export function vnDate(at: Date): string {
  return new Date(at.getTime() + VN_OFFSET_MS).toISOString().slice(0, 10);
}

/** Kỳ `[from, to]` (ngày VN, gồm cả hai đầu) → mốc giờ `[from, to)`. */
export function vnRange(query: { from: string; to: string }): { from: Date; to: Date } {
  return { from: new Date(`${query.from}T00:00:00+07:00`), to: new Date(new Date(`${query.to}T00:00:00+07:00`).getTime() + DAY_MS) };
}

/** `days` ngày gần nhất tính tới hôm nay (giờ VN). */
export function lastDays(now: Date, days: number): { from: string; to: string } {
  return { from: vnDate(new Date(now.getTime() - (days - 1) * DAY_MS)), to: vnDate(now) };
}
