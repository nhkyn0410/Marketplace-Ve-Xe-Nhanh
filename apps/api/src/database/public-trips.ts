import { Prisma } from "../generated/prisma/client";
import type { PrismaService } from "./prisma.service";
import type { SeatType } from "./prisma.types";

// Truy vấn CÔNG KHAI của Marketplace (TASK-TRN-004, FR-MKT-01..05, BR-22, BR-80; LLD §6.13 bước 7): đọc chuyến của MỌI
// nhà xe nên phải chạy ở ngữ cảnh `system` (RLS `tenant_isolation`) — đặt ở `database/` như `article-views.ts`. Chỉ đọc,
// và luôn tự lọc đúng điều kiện hiển thị: chuyến `OPEN_FOR_SALE`, nhà xe `ACTIVE`, chưa qua giờ ngừng bán online.

/**
 * Một phía của truy vấn tìm: tỉnh / thành, phường / xã, nhóm phường của một khu vực, hoặc tọa độ của một địa danh dùng
 * chung + bán kính.
 */
export type SearchSide =
  /** Không chọn phía này: mọi điểm cho đón / cho trả. */
  | { any: true }
  | { provinceId: string }
  | { wardId: string }
  | { wardIds: string[] }
  | { latitude: number; longitude: number; radiusMeters: number };

/**
 * Khu vực = một đơn vị hành chính cũ trước sáp nhập 2025 — tỉnh cũ, hoặc quận / huyện / thị xã / thành phố cũ — ứng với các
 * phường mới đã nhận phần đất của nó, suy ra từ `legacy_administrative_mappings` (không có bảng riêng; tự thiết kế
 * 29/10/2026, chờ duyệt). Mã: `{mã tỉnh cũ}` hoặc `{mã tỉnh cũ}-{tên quận / huyện cũ không dấu, nối gạch}`, vd
 * `77-thanh-pho-vung-tau` (Vũng Tàu cũ = 5 phường mới của TP.HCM).
 */
export const AREA_ID = /^(\d{2})(?:-([a-z0-9]+(?:-[a-z0-9]+)*))?$/;

/**
 * Phần tên của mã khu vực tính từ `m.legacy_district_name` (bảng `legacy_administrative_mappings` đặt bí danh `m`) — dùng
 * chung khi gợi ý (tạo mã, `catalog`) và khi tìm (đọc mã, `findArea`) để hai bên luôn khớp.
 */
export const LEGACY_DISTRICT_SLUG = Prisma.sql`trim(both '-' from regexp_replace(vxn_search_text(m.legacy_district_name), '[^a-z0-9]+', '-', 'g'))`;

/** Các phường mới (đang dùng) của một khu vực + tỉnh mới chứa chúng (để nới); mã sai / không có → `null`. */
export async function findArea(
  prisma: Pick<PrismaService, "withSystem">,
  areaId: string,
): Promise<{ wardIds: string[]; provinceId: string } | null> {
  const match = AREA_ID.exec(areaId);
  if (!match) {
    return null;
  }
  const [, code, slug] = match;
  const district = slug === undefined
    ? Prisma.sql`TRUE`
    : Prisma.sql`m.legacy_district_name <> '' AND ${LEGACY_DISTRICT_SLUG} = ${slug}`;
  const [row] = await prisma.withSystem((tx) =>
    tx.$queryRaw<{ wardIds: string[] | null; provinceId: string | null }[]>`
      SELECT array_agg(DISTINCT w.id) AS "wardIds", min(w.province_id) AS "provinceId"
      FROM legacy_administrative_mappings m
      JOIN wards w ON w.id = m.ward_id AND w.status = 'ACTIVE'
      JOIN provinces p ON p.id = w.province_id AND p.status = 'ACTIVE'
      WHERE m.legacy_province_code = ${code} AND ${district}`,
  );
  return row?.wardIds?.length && row.provinceId ? { wardIds: row.wardIds, provinceId: row.provinceId } : null;
}

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
  /** Phường của điểm đón / trả — ghép tiêu đề chặng cho khách (3.3). */
  pickupWardId: string;
  dropoffSequence: number;
  dropoffName: string;
  dropoffAddress: string;
  dropoffAt: Date;
  dropoffWardId: string;
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

/** Tỉnh của một phường / xã đang dùng (để nới tìm ra cả tỉnh khi phường không có chuyến); `null` = không có / ngừng dùng. */
export async function findWard(
  prisma: Pick<PrismaService, "withSystem">,
  wardId: string,
): Promise<{ provinceId: string } | null> {
  return prisma.withSystem((tx) =>
    tx.ward.findFirst({ where: { id: wardId, status: "ACTIVE", province: { status: "ACTIVE" } }, select: { provinceId: true } }),
  );
}

// Khoảng cách đường tròn lớn (m) giữa điểm dừng `s` và tọa độ cho trước — không gọi dịch vụ định tuyến lúc tìm (BR-80).
function sideMatch(side: SearchSide): Prisma.Sql {
  if ("any" in side) {
    return Prisma.sql`TRUE`;
  }
  if ("provinceId" in side) {
    return Prisma.sql`s.province_id = ${side.provinceId}`;
  }
  if ("wardId" in side) {
    return Prisma.sql`s.ward_id = ${side.wardId}`;
  }
  if ("wardIds" in side) {
    return Prisma.sql`s.ward_id = ANY(${side.wardIds}::text[])`;
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
          -- Giờ ngừng bán online tính theo giờ xe tới điểm đón (3.3) — kiểm ở CTE pick; ở đây chỉ bỏ chuyến đã tới nơi.
          AND t.arrival_at > ${query.now}
          -- Giờ đón trong ngày chỉ có thể rơi vào chuyến khởi hành trước cuối ngày và chưa đến trước đầu ngày.
          AND t.departure_at < ${query.dayEnd} AND t.arrival_at > ${query.dayStart}
      ),
      s AS (
        SELECT ts.trip_id, ts.sequence, ts.planned_at, ts.allow_pickup, ts.allow_dropoff, ot.online_sale_cutoff_minutes AS cutoff,
               COALESCE(c.name, p.name) AS name, COALESCE(c.address, p.address) AS address,
               COALESCE(c.province_id, p.province_id) AS province_id, COALESCE(c.ward_id, p.ward_id) AS ward_id,
               COALESCE(c.latitude, p.latitude) AS lat, COALESCE(c.longitude, p.longitude) AS lng
        FROM trip_stops ts
        JOIN open_trips ot ON ot.id = ts.trip_id
        LEFT JOIN stop_points_catalog c ON c.id = ts.catalog_stop_point_id
        LEFT JOIN stop_points p ON p.id = ts.stop_point_id
      ),
      pick AS (
        SELECT DISTINCT ON (s.trip_id) s.* FROM s
        WHERE s.allow_pickup AND s.planned_at >= ${query.dayStart} AND s.planned_at < ${query.dayEnd} AND ${sideMatch(query.from)}
          AND s.planned_at - make_interval(mins => s.cutoff) > ${query.now}
        ORDER BY s.trip_id, s.sequence
      ),
      dropoff AS (
        SELECT DISTINCT ON (s.trip_id) s.* FROM s
        JOIN pick ON pick.trip_id = s.trip_id AND s.sequence > pick.sequence
        WHERE s.allow_dropoff AND ${sideMatch(query.to)}
        -- Không chọn điểm đến: lấy điểm trả cuối (đi hết chuyến); có thì điểm trả khớp đầu tiên.
        ORDER BY s.trip_id, s.sequence ${"any" in query.to ? Prisma.sql`DESC` : Prisma.empty}
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
             pick.ward_id AS "pickupWardId", dropoff.ward_id AS "dropoffWardId",
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

/** Điểm đón còn bán online: giờ xe tới điểm đó trừ số phút ngừng bán vẫn sau `now` (3.3, chờ duyệt). */
export function pickupSaleOpen(plannedAt: Date, cutoffMinutes: number, now: Date): boolean {
  return plannedAt.getTime() - cutoffMinutes * 60_000 > now.getTime();
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
            catalogStopPointId: true,
            stopPointId: true,
            catalogStopPoint: { select: { name: true, address: true, type: true, latitude: true, longitude: true, wardId: true } },
            stopPoint: { select: { name: true, address: true, type: true, latitude: true, longitude: true, wardId: true } },
          },
        },
        seats: { select: { seatCode: true, deck: true, row: true, column: true, type: true, status: true } },
      },
    }),
  );
  // Còn bán online khi còn ít nhất một điểm đón chưa qua giờ ngừng bán (tính theo giờ xe tới điểm đón — 3.3).
  if (!trip || !trip.stops.some((stop) => stop.allowPickup && pickupSaleOpen(stop.plannedAt, trip.onlineSaleCutoffMinutes, now))) {
    return null;
  }
  return trip;
}
