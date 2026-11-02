import type { SegmentOffer } from "../fare/segment-pricing";
import type { DbTransaction, PrismaService } from "./prisma.service";

/**
 * Chặng mở bán (3.3) của các chuyến: tuyến con được chọn cho chuyến, đang bật, có bảng giá đang áp dụng, và hai đầu còn trên
 * điểm dừng của chuyến (đổi sang số thứ tự điểm của chuyến theo mã điểm). Chạy trong transaction của người gọi — `system`
 * (tìm / chi tiết công khai) hoặc tenant (đặt vé, RLS lọc theo nhà xe).
 */
export async function loadSegmentOffers(tx: DbTransaction, tripIds: readonly string[]): Promise<Map<string, SegmentOffer[]>> {
  const ids = [...new Set(tripIds)];
  const byTrip = new Map<string, SegmentOffer[]>();
  if (ids.length === 0) {
    return byTrip;
  }
  const rows = await tx.$queryRaw<{ tripId: string; routeId: string; distanceMeters: number; fromSequence: number; toSequence: number }[]>`
    SELECT tsr.trip_id AS "tripId", r.id AS "routeId", r.total_distance_meters AS "distanceMeters",
           fs.sequence AS "fromSequence", ds.sequence AS "toSequence"
    FROM trip_sub_routes tsr
    JOIN routes r ON r.id = tsr.sub_route_id AND r.operator_id = tsr.operator_id AND r.status = 'ACTIVE'
    JOIN fares f ON f.route_id = r.id AND f.status = 'ACTIVE'
    JOIN route_stops o ON o.route_id = r.id AND o.role = 'ORIGIN'
    JOIN route_stops d ON d.route_id = r.id AND d.role = 'DESTINATION'
    JOIN trip_stops fs ON fs.trip_id = tsr.trip_id
      AND (fs.catalog_stop_point_id = o.catalog_stop_point_id OR fs.stop_point_id = o.stop_point_id)
    JOIN trip_stops ds ON ds.trip_id = tsr.trip_id
      AND (ds.catalog_stop_point_id = d.catalog_stop_point_id OR ds.stop_point_id = d.stop_point_id)
    WHERE tsr.trip_id = ANY(${ids}::text[]) AND fs.sequence < ds.sequence`;
  if (rows.length === 0) {
    return byTrip;
  }
  const fares = await tx.fare.findMany({
    where: { routeId: { in: [...new Set(rows.map((row) => row.routeId))] }, status: "ACTIVE" },
    select: { routeId: true, rules: { select: { vehicleTypeId: true, seatType: true, validFrom: true, validTo: true, price: true } } },
  });
  const rulesByRoute = new Map(fares.map((fare) => [fare.routeId, fare.rules]));
  for (const row of rows) {
    const offers = byTrip.get(row.tripId) ?? [];
    offers.push({ ...row, rules: rulesByRoute.get(row.routeId) ?? [] });
    byTrip.set(row.tripId, offers);
  }
  return byTrip;
}

/** Như `loadSegmentOffers` cho luồng công khai (tìm, chi tiết, giữ chỗ): đọc mọi nhà xe nên chạy ở ngữ cảnh `system`. */
export function loadPublicSegmentOffers(prisma: Pick<PrismaService, "withSystem">, tripIds: readonly string[]): Promise<Map<string, SegmentOffer[]>> {
  return prisma.withSystem((tx) => loadSegmentOffers(tx, tripIds));
}
