import { HttpException, HttpStatus, Inject, Injectable } from "@nestjs/common";
import type { DbScope } from "../database/db-scope";
import { PrismaService, type DbTransaction } from "../database/prisma.service";
import { TicketStatus, TripStatus } from "../database/prisma.types";
import { vndToJson } from "../fare/fare-pricing";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { can } from "../iam/role/access-policy";
import type { Authorization } from "../iam/role/authorization";
import { lastDays, routePerformance, type RoutePerformanceRow, vnRange } from "../reporting/route-performance";
import type { AdminRoute, AdminRouteDetail, AdminRouteDetailQuery, AdminRouteListQuery, AdminRoutePage } from "./dto/admin-route.dto";

type Viewer = Pick<VerifiedAccessToken, "role" | "perms">;
type Period = { from: string; to: string };

/** Kỳ mặc định khi không chọn ngày. */
const DEFAULT_DAYS = 30;
/**
 * Danh sách xếp theo số liệu nên tính trên toàn bộ tuyến khớp bộ lọc rồi mới cắt trang. Trần này đủ cho quy mô v1; vượt
 * trần thì chỉ xét các tuyến tạo gần nhất (ghi rõ trong API §7.5).
 */
const ROUTE_SCAN_LIMIT = 2_000;
const OPEN_TRIP_STATUSES = [TripStatus.OPEN_FOR_SALE, TripStatus.SOLD_OUT];
const LIVE_TICKETS: TicketStatus[] = [TicketStatus.VALID, TicketStatus.CHECKED_IN, TicketStatus.NO_SHOW, TicketStatus.USED];
const NEXT_TRIPS = 10;

const routeNotFound = () => new HttpException({ code: "ROUTE_NOT_FOUND", detail: "Không tìm thấy tuyến.", title: "Route error" }, HttpStatus.NOT_FOUND);

type StopRef = { catalogStopPoint: { provinceId: string } | null; stopPoint: { provinceId: string } | null };
const provinceOf = (stop: StopRef | undefined) => stop?.catalogStopPoint?.provinceId ?? stop?.stopPoint?.provinceId ?? null;

/**
 * Admin xem tuyến của mọi nhà xe + hiệu suất theo kỳ (FR-NSR-13; tự thiết kế 28/10/2026, chờ duyệt). Chỉ đọc, ngữ cảnh
 * platform. Tiền (doanh thu vé) chỉ trả khi người xem có `payment:monitor`.
 */
@Injectable()
export class AdminRouteService {
  constructor(@Inject(PrismaService) private readonly prisma: PrismaService) {}

  async list(authz: Authorization, viewer: Viewer, query: AdminRouteListQuery, now: Date = new Date()): Promise<AdminRoutePage> {
    const period = periodOf(query, now);
    const showMoney = can(viewer, "payment:monitor").allowed;
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const routes = await tx.route.findMany({
        where: {
          operatorId: query.operatorId,
          status: query.status,
          // Tuyến con (3.2) không có chuyến riêng — Admin xem theo tuyến chính.
          parentRouteId: null,
          ...(query.q ? { name: { contains: query.q, mode: "insensitive" as const } } : {}),
        },
        orderBy: [{ createdAt: "desc" }, { id: "desc" }],
        take: ROUTE_SCAN_LIMIT,
        select: {
          id: true,
          name: true,
          status: true,
          operatorId: true,
          totalDistanceMeters: true,
          totalDurationSeconds: true,
          operator: { select: { displayName: true } },
          stops: {
            orderBy: { sequence: "asc" },
            select: { catalogStopPoint: { select: { provinceId: true } }, stopPoint: { select: { provinceId: true } } },
          },
        },
      });
      const matched = routes
        .map((route) => ({ route, origin: provinceOf(route.stops[0]), destination: provinceOf(route.stops.at(-1)) }))
        .filter(
          (row) =>
            (!query.originProvinceId || row.origin === query.originProvinceId) &&
            (!query.destinationProvinceId || row.destination === query.destinationProvinceId),
        );
      const metrics = await this.metricsOf(
        tx,
        matched.map((row) => row.route.id),
        period,
        now,
        matched.flatMap((row) => [row.origin, row.destination]),
      );
      const items = matched.map(({ route, origin, destination }): AdminRoute => ({
        id: route.id,
        name: route.name,
        status: route.status,
        operatorId: route.operatorId,
        operatorName: route.operator.displayName,
        origin: origin ? { id: origin, name: metrics.provinceNames.get(origin) ?? "" } : null,
        destination: destination ? { id: destination, name: metrics.provinceNames.get(destination) ?? "" } : null,
        stopCount: route.stops.length,
        distanceMeters: route.totalDistanceMeters,
        durationSeconds: route.totalDurationSeconds,
        ...metricsJson(metrics.performance.get(route.id), showMoney),
        upcomingTrips: metrics.upcoming.get(route.id) ?? 0,
        averageRating: metrics.ratings.get(route.id)?.average ?? null,
        reviewCount: metrics.ratings.get(route.id)?.count ?? 0,
      }));
      const sort = query.sort === "revenue" && !showMoney ? "sold" : query.sort;
      items.sort(comparator(sort, metrics.performance));
      const offset = Number(query.cursor ?? 0);
      const pageItems = items.slice(offset, offset + query.limit);
      return {
        items: pageItems,
        nextCursor: offset + query.limit < items.length ? String(offset + query.limit) : null,
        total: items.length,
        period,
      };
    });
  }

  async detail(authz: Authorization, viewer: Viewer, id: string, query: AdminRouteDetailQuery, now: Date = new Date()): Promise<AdminRouteDetail> {
    const period = periodOf(query, now);
    const showMoney = can(viewer, "payment:monitor").allowed;
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const pointSelect = { name: true, address: true, type: true, provinceId: true, latitude: true, longitude: true } as const;
      const route = await tx.route.findUnique({
        where: { id },
        select: {
          id: true,
          name: true,
          status: true,
          note: true,
          operatorId: true,
          totalDistanceMeters: true,
          totalDurationSeconds: true,
          operator: { select: { displayName: true } },
          stops: {
            orderBy: { sequence: "asc" },
            select: {
              sequence: true,
              allowPickup: true,
              allowDropoff: true,
              latitude: true,
              longitude: true,
              distanceMetersFromPrevious: true,
              durationSecondsFromPrevious: true,
              catalogStopPoint: { select: pointSelect },
              stopPoint: { select: pointSelect },
            },
          },
        },
      });
      if (!route) {
        throw routeNotFound();
      }
      const metrics = await this.metricsOf(tx, [id], period, now, route.stops.map((stop) => (stop.catalogStopPoint ?? stop.stopPoint)?.provinceId ?? null));
      const trips = await tx.trip.findMany({
        where: { routeId: id, departureAt: { gt: now }, status: { notIn: [TripStatus.DRAFT, TripStatus.CANCELLED] } },
        orderBy: [{ departureAt: "asc" }, { id: "asc" }],
        take: NEXT_TRIPS,
        select: { id: true, departureAt: true, status: true, vehicle: { select: { plateNumber: true } }, _count: { select: { seats: true } } },
      });
      const sold = await soldByTrip(tx, trips.map((trip) => trip.id));
      const origin = route.stops[0]?.catalogStopPoint?.provinceId ?? route.stops[0]?.stopPoint?.provinceId ?? null;
      const last = route.stops.at(-1);
      const destination = last?.catalogStopPoint?.provinceId ?? last?.stopPoint?.provinceId ?? null;
      return {
        id: route.id,
        name: route.name,
        status: route.status,
        note: route.note,
        operatorId: route.operatorId,
        operatorName: route.operator.displayName,
        origin: origin ? { id: origin, name: metrics.provinceNames.get(origin) ?? "" } : null,
        destination: destination ? { id: destination, name: metrics.provinceNames.get(destination) ?? "" } : null,
        stopCount: route.stops.length,
        distanceMeters: route.totalDistanceMeters,
        durationSeconds: route.totalDurationSeconds,
        ...metricsJson(metrics.performance.get(id), showMoney),
        upcomingTrips: metrics.upcoming.get(id) ?? 0,
        averageRating: metrics.ratings.get(id)?.average ?? null,
        reviewCount: metrics.ratings.get(id)?.count ?? 0,
        period,
        stops: route.stops.map((stop) => {
          const point = stop.catalogStopPoint ?? stop.stopPoint;
          return {
            sequence: stop.sequence,
            name: point?.name ?? "",
            address: point?.address ?? "",
            type: point?.type ?? "PICKUP_POINT",
            shared: stop.catalogStopPoint !== null,
            provinceName: point ? (metrics.provinceNames.get(point.provinceId) ?? null) : null,
            latitude: stop.latitude,
            longitude: stop.longitude,
            allowPickup: stop.allowPickup,
            allowDropoff: stop.allowDropoff,
            distanceMetersFromPrevious: stop.distanceMetersFromPrevious,
            durationSecondsFromPrevious: stop.durationSecondsFromPrevious,
          };
        }),
        nextTrips: trips.map((trip) => ({
          id: trip.id,
          departureAt: trip.departureAt.toISOString(),
          status: trip.status,
          vehiclePlate: trip.vehicle?.plateNumber ?? null,
          seats: trip._count.seats,
          ticketsSold: sold.get(trip.id) ?? 0,
        })),
      };
    });
  }

  /** Số liệu kỳ, chuyến sắp chạy, đánh giá và tên tỉnh cho một nhóm tuyến. */
  private async metricsOf(tx: DbTransaction, routeIds: string[], period: Period, now: Date, provinceIds: (string | null)[]) {
    if (routeIds.length === 0) {
      return { performance: new Map<string, RoutePerformanceRow>(), upcoming: new Map<string, number>(), ratings: new Map<string, { average: number; count: number }>(), provinceNames: new Map<string, string>() };
    }
    const range = vnRange(period);
    const ids = [...new Set(provinceIds.filter((value): value is string => Boolean(value)))];
    const [performance, upcoming, ratings, provinces] = await Promise.all([
      routePerformance(tx, { ...range, routeIds }),
      tx.trip.groupBy({ by: ["routeId"], where: { routeId: { in: routeIds }, status: { in: OPEN_TRIP_STATUSES }, departureAt: { gt: now } }, _count: { _all: true } }),
      tx.$queryRaw<{ routeId: string; average: number; count: bigint }[]>`
        SELECT t.route_id AS "routeId", AVG(r.rating)::float8 AS average, COUNT(*) AS count
        FROM reviews r JOIN trips t ON t.id = r.trip_id AND t.operator_id = r.operator_id
        WHERE r.status = 'VISIBLE' AND t.route_id = ANY(${routeIds}::text[])
        GROUP BY t.route_id`,
      tx.province.findMany({ where: { id: { in: ids } }, select: { id: true, name: true } }),
    ]);
    return {
      performance: new Map(performance.map((row) => [row.routeId, row])),
      upcoming: new Map(upcoming.map((row) => [row.routeId, row._count._all])),
      ratings: new Map(ratings.map((row) => [row.routeId, { average: Math.round(row.average * 10) / 10, count: Number(row.count) }])),
      provinceNames: new Map(provinces.map((province) => [province.id, province.name])),
    };
  }
}

function periodOf(query: { from?: string; to?: string }, now: Date): Period {
  return query.from && query.to ? { from: query.from, to: query.to } : lastDays(now, DEFAULT_DAYS);
}

function metricsJson(row: RoutePerformanceRow | undefined, showMoney: boolean) {
  return {
    trips: Number(row?.trips ?? 0),
    completedTrips: Number(row?.completed ?? 0),
    cancelledTrips: Number(row?.cancelledTrips ?? 0),
    seats: Number(row?.seats ?? 0),
    ticketsSold: Number(row?.sold ?? 0),
    ticketRevenue: showMoney ? vndToJson(BigInt(row?.revenue ?? 0n)) : null,
  };
}

/** Xếp giảm dần theo số liệu (tên tuyến khi bằng nhau); `name` xếp theo tên. */
function comparator(sort: AdminRouteListQuery["sort"], performance: Map<string, RoutePerformanceRow>) {
  const fill = (route: AdminRoute) => (route.seats === 0 ? 0 : route.ticketsSold / route.seats);
  const value = (route: AdminRoute): number => {
    switch (sort) {
      case "revenue":
        return Number(performance.get(route.id)?.revenue ?? 0n);
      case "trips":
        return route.trips;
      case "fill":
        return fill(route);
      default:
        return route.ticketsSold;
    }
  };
  return (a: AdminRoute, b: AdminRoute) =>
    sort === "name" ? a.name.localeCompare(b.name, "vi") : value(b) - value(a) || a.name.localeCompare(b.name, "vi");
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
    throw new Error("Route Admin tuyến cần ngữ cảnh DB platform.");
  }
  return authz.db;
}
