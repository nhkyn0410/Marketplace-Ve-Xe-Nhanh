import { Prisma } from "../generated/prisma/client";
import type { PrismaService } from "./prisma.service";
import type { SeatType } from "./prisma.types";

// Truy vấn CÔNG KHAI của Marketplace (TASK-TRN-004, FR-MKT-01..05, BR-22, BR-80; LLD §6.13 bước 7): đọc chuyến của MỌI
// nhà xe nên phải chạy ở ngữ cảnh `system` (RLS `tenant_isolation`) — đặt ở `database/` như `article-views.ts`. Chỉ đọc,
// và luôn tự lọc đúng điều kiện hiển thị: chuyến `OPEN_FOR_SALE`, nhà xe `ACTIVE`, chưa qua giờ ngừng bán online.

/** Một phía của truy vấn tìm: tỉnh / thành, hoặc tọa độ của một địa danh dùng chung + bán kính. */
export type SearchSide = { provinceId: string } | { latitude: number; longitude: number; radiusMeters: number };

export type SearchCandidate = {
  tripId: string;
  operatorId: string;
  operatorName: string;
  operatorSlug: string;
  routeId: string;
  routeName: string;
  vehicleTypeId: string;
  vehicleTypeName: string;
  vehicleForm: string;
  vehicleClass: string;
  departureAt: Date;
  arrivalAt: Date;
  onlineSaleCutoffMinutes: number;
  pickupSequence: number;
  pickupName: string;
  pickupAddress: string;
  pickupAt: Date;
  dropoffSequence: number;
  dropoffName: string;
  dropoffAddress: string;
  dropoffAt: Date;
  availableSeats: number;
  /** Loại chỗ còn trống (để tính giá thấp nhất). */
  availableSeatTypes: string[];
  coverImageKey: string | null;
  amenityIds: string[];
  amenityNames: string[];
};

/** Tọa độ của một điểm dùng chung đang dùng (địa danh tìm theo vị trí); `null` = không có / ngừng dùng. */
export async function findLandmark(
  prisma: Pick<PrismaService, "withSystem">,
  stopPointId: string,
): Promise<{ latitude: number; longitude: number } | null> {
  return prisma.withSystem((tx) =>
    tx.stopPointCatalog.findFirst({ where: { id: stopPointId, status: "ACTIVE" }, select: { latitude: true, longitude: true } }),
  );
}

// Khoảng cách đường tròn lớn (m) giữa điểm dừng `s` và tọa độ cho trước — không gọi dịch vụ định tuyến lúc tìm (BR-80).
function sideMatch(side: SearchSide): Prisma.Sql {
  if ("provinceId" in side) {
    return Prisma.sql`s.province_id = ${side.provinceId}`;
  }
  return Prisma.sql`6371000 * 2 * asin(sqrt(
      power(sin(radians(s.lat - ${side.latitude}) / 2), 2)
      + cos(radians(${side.latitude})) * cos(radians(s.lat)) * power(sin(radians(s.lng - ${side.longitude}) / 2), 2)
    )) <= ${side.radiusMeters}`;
}

/**
 * Chuyến khớp truy vấn (BR-22, BR-80): điểm đón khớp phía đi (cho đón, giờ đón trong ngày `[dayStart, dayEnd)`) đứng trước
 * điểm trả khớp phía đến (cho trả); lấy điểm đón khớp đầu tiên và điểm trả khớp đầu tiên sau nó. Trạm dừng nghỉ không cho
 * đón / trả nên tự không khớp. Còn ít nhất `passengers` chỗ trống. Tối đa `limit` dòng, theo giờ đón.
 */
export async function searchTripCandidates(
  prisma: Pick<PrismaService, "withSystem">,
  query: { from: SearchSide; to: SearchSide; dayStart: Date; dayEnd: Date; passengers: number; now: Date; limit: number },
): Promise<SearchCandidate[]> {
  return prisma.withSystem(
    (tx) => tx.$queryRaw<SearchCandidate[]>`
      WITH open_trips AS (
        SELECT t.* FROM trips t
        JOIN operator_profiles o ON o.id = t.operator_id AND o.status = 'ACTIVE'
        WHERE t.status = 'OPEN_FOR_SALE'
          AND t.departure_at - make_interval(mins => t.online_sale_cutoff_minutes) > ${query.now}
          -- Giờ đón trong ngày chỉ có thể rơi vào chuyến khởi hành trước cuối ngày và chưa đến trước đầu ngày.
          AND t.departure_at < ${query.dayEnd} AND t.arrival_at > ${query.dayStart}
      ),
      s AS (
        SELECT ts.trip_id, ts.sequence, ts.planned_at, ts.allow_pickup, ts.allow_dropoff,
               COALESCE(c.name, p.name) AS name, COALESCE(c.address, p.address) AS address,
               COALESCE(c.province_id, p.province_id) AS province_id,
               COALESCE(c.latitude, p.latitude) AS lat, COALESCE(c.longitude, p.longitude) AS lng
        FROM trip_stops ts
        JOIN open_trips ot ON ot.id = ts.trip_id
        LEFT JOIN stop_points_catalog c ON c.id = ts.catalog_stop_point_id
        LEFT JOIN stop_points p ON p.id = ts.stop_point_id
      ),
      pick AS (
        SELECT DISTINCT ON (s.trip_id) s.* FROM s
        WHERE s.allow_pickup AND s.planned_at >= ${query.dayStart} AND s.planned_at < ${query.dayEnd} AND ${sideMatch(query.from)}
        ORDER BY s.trip_id, s.sequence
      ),
      dropoff AS (
        SELECT DISTINCT ON (s.trip_id) s.* FROM s
        JOIN pick ON pick.trip_id = s.trip_id AND s.sequence > pick.sequence
        WHERE s.allow_dropoff AND ${sideMatch(query.to)}
        ORDER BY s.trip_id, s.sequence
      ),
      seats AS (
        SELECT ts.trip_id, count(*)::int AS available, array_agg(DISTINCT ts.type::text) AS types
        FROM trip_seats ts JOIN pick ON pick.trip_id = ts.trip_id
        WHERE ts.status = 'AVAILABLE'
        GROUP BY ts.trip_id
      )
      SELECT t.id AS "tripId", o.id AS "operatorId", o.display_name AS "operatorName", o.operator_slug AS "operatorSlug",
             r.id AS "routeId", r.name AS "routeName",
             vt.id AS "vehicleTypeId", vt.name AS "vehicleTypeName", vt.form::text AS "vehicleForm", vt.class::text AS "vehicleClass",
             t.departure_at AS "departureAt", t.arrival_at AS "arrivalAt", t.online_sale_cutoff_minutes AS "onlineSaleCutoffMinutes",
             pick.sequence AS "pickupSequence", pick.name AS "pickupName", pick.address AS "pickupAddress", pick.planned_at AS "pickupAt",
             dropoff.sequence AS "dropoffSequence", dropoff.name AS "dropoffName", dropoff.address AS "dropoffAddress",
             dropoff.planned_at AS "dropoffAt",
             seats.available AS "availableSeats", seats.types AS "availableSeatTypes",
             (SELECT vi.object_key FROM vehicle_images vi WHERE vi.vehicle_id = v.id ORDER BY vi.position LIMIT 1) AS "coverImageKey",
             COALESCE((SELECT array_agg(a.id ORDER BY a.name) FROM vehicle_amenities va JOIN amenities a ON a.id = va.amenity_id
                       WHERE va.vehicle_id = v.id AND a.status = 'ACTIVE'), ARRAY[]::text[]) AS "amenityIds",
             COALESCE((SELECT array_agg(a.name ORDER BY a.name) FROM vehicle_amenities va JOIN amenities a ON a.id = va.amenity_id
                       WHERE va.vehicle_id = v.id AND a.status = 'ACTIVE'), ARRAY[]::text[]) AS "amenityNames"
      FROM pick
      JOIN dropoff ON dropoff.trip_id = pick.trip_id
      JOIN seats ON seats.trip_id = pick.trip_id AND seats.available >= ${query.passengers}
      JOIN trips t ON t.id = pick.trip_id
      JOIN operator_profiles o ON o.id = t.operator_id
      JOIN routes r ON r.id = t.route_id
      JOIN vehicles v ON v.id = t.vehicle_id
      JOIN vehicle_types vt ON vt.id = v.vehicle_type_id
      ORDER BY pick.planned_at, t.id
      LIMIT ${query.limit}`,
  );
}

export type FareRuleRow = {
  routeId: string;
  vehicleTypeId: string | null;
  seatType: SeatType | null;
  validFrom: Date | null;
  validTo: Date | null;
  price: bigint;
};

/** Rule giá của bảng giá đang áp dụng (`ACTIVE`) của các tuyến. */
export async function loadActiveFareRules(prisma: Pick<PrismaService, "withSystem">, routeIds: string[]): Promise<FareRuleRow[]> {
  if (routeIds.length === 0) {
    return [];
  }
  const fares = await prisma.withSystem((tx) =>
    tx.fare.findMany({
      where: { routeId: { in: routeIds }, status: "ACTIVE" },
      select: { routeId: true, rules: { select: { vehicleTypeId: true, seatType: true, validFrom: true, validTo: true, price: true } } },
    }),
  );
  return fares.flatMap((fare) => fare.rules.map((rule) => ({ routeId: fare.routeId, ...rule })));
}

/** Mốc hủy / hoàn đang áp dụng cho từng nhà xe: phiên bản riêng của nhà xe, nếu không có thì mặc định nền tảng. */
export async function loadCancellationTiers(
  prisma: Pick<PrismaService, "withSystem">,
  operatorIds: string[],
  now: Date,
): Promise<Map<string, { minHoursBefore: number; refundPercent: number }[]>> {
  const versions = await prisma.withSystem((tx) =>
    tx.policyVersion.findMany({
      where: {
        type: "CANCELLATION",
        status: "PUBLISHED",
        effectiveFrom: { lte: now },
        OR: [{ operatorId: null }, { operatorId: { in: operatorIds } }],
      },
      orderBy: { effectiveFrom: "desc" },
      select: { operatorId: true, rules: true },
    }),
  );
  const tiersOf = (rules: unknown) => ((rules as { tiers?: { minHoursBefore: number; refundPercent: number }[] }).tiers ?? []);
  const fallback = versions.find((version) => version.operatorId === null);
  return new Map(
    operatorIds.map((operatorId) => {
      const own = versions.find((version) => version.operatorId === operatorId);
      return [operatorId, tiersOf((own ?? fallback)?.rules ?? {})];
    }),
  );
}

/** Chi tiết một chuyến đang hiển thị công khai (BR-22); không hiển thị → `null` (API trả 404 như không tồn tại). */
export async function loadPublicTrip(prisma: Pick<PrismaService, "withSystem">, tripId: string, now: Date) {
  const trip = await prisma.withSystem((tx) =>
    tx.trip.findFirst({
      where: { id: tripId, status: "OPEN_FOR_SALE", operator: { status: "ACTIVE" }, vehicleId: { not: null } },
      select: {
        id: true,
        departureAt: true,
        arrivalAt: true,
        onlineSaleCutoffMinutes: true,
        note: true,
        operator: { select: { id: true, displayName: true, operatorSlug: true, hotline: true } },
        route: { select: { id: true, name: true } },
        vehicle: {
          select: {
            vehicleType: { select: { id: true, name: true, form: true, class: true } },
            amenities: { where: { amenity: { status: "ACTIVE" } }, select: { amenity: { select: { id: true, name: true } } } },
            images: { orderBy: { position: "asc" }, select: { objectKey: true, caption: true } },
          },
        },
        stops: {
          orderBy: { sequence: "asc" },
          select: {
            sequence: true,
            role: true,
            plannedAt: true,
              pickupWindowStart: true,
              pickupWindowEnd: true,
            allowPickup: true,
            allowDropoff: true,
            note: true,
            catalogStopPoint: { select: { name: true, address: true, type: true, latitude: true, longitude: true } },
            stopPoint: { select: { name: true, address: true, type: true, latitude: true, longitude: true } },
          },
        },
        seats: { select: { seatCode: true, deck: true, row: true, column: true, type: true, status: true } },
      },
    }),
  );
  if (!trip || trip.departureAt.getTime() - trip.onlineSaleCutoffMinutes * 60_000 <= now.getTime()) {
    return null;
  }
  return trip;
}
