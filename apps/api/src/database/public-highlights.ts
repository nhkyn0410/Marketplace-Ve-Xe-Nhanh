import type { PrismaService } from "./prisma.service";

const DAY = 86_400_000;
/** Cửa sổ "tuyến đang bán" và "bán chạy": chuyến mở bán trong 30 ngày tới, vé đã thanh toán trong 30 ngày qua. */
const WINDOW_DAYS = 30;
/** Số tuyến (cặp tỉnh) tối đa trả kèm mỗi nhà xe tiêu biểu — đủ cho ô "Tuyến đường" của tab Theo nhà xe. */
const OPERATOR_ROUTE_LIMIT = 6;

type Tx = Parameters<Parameters<PrismaService["withSystem"]>[0]>[0];

/** Chuyến mở bán, đã gắn xe (như tìm chuyến công khai), khởi hành trong 30 ngày tới. */
const upcomingTrips = (now: Date) => ({ status: "OPEN_FOR_SALE" as const, vehicleId: { not: null }, departureAt: { gt: now, lt: new Date(now.getTime() + WINDOW_DAYS * DAY) } });

/** Một tuyến của nhà xe kèm số liệu, trước khi gộp theo cặp tỉnh. */
export type HighlightRouteRow = {
  readonly routeId: string;
  readonly operatorId: string;
  readonly originProvinceId: string | null;
  readonly destinationProvinceId: string | null;
  readonly distanceMeters: number;
  readonly durationSeconds: number;
  /** Giá các luật giá đang áp dụng của tuyến (VND, BigInt). */
  readonly prices: readonly bigint[];
  readonly upcomingTrips: number;
  readonly nextDepartureAt: Date | null;
  readonly vehicleTypeNames: readonly string[];
  readonly paidBookings: number;
  readonly ratings: readonly number[];
};

export type ProvincePair = {
  originProvinceId: string;
  originName: string;
  destinationProvinceId: string;
  destinationName: string;
};

export type PopularRoute = ProvincePair & {
  distanceMeters: number;
  durationSeconds: number;
  /** Giá thấp nhất trong các luật giá đang áp dụng (VND); null khi chưa có bảng giá. */
  minPrice: bigint | null;
  vehicleTypeNames: string[];
  /** Giờ khởi hành sớm nhất của chuyến đang mở bán — để trang chủ dẫn tới đúng ngày có chuyến. */
  nextDepartureAt: Date | null;
  operatorCount: number;
  averageRating: number | null;
  reviewCount: number;
};

/** "Thành phố Hồ Chí Minh" → "TP. Hồ Chí Minh", "Tỉnh Lâm Đồng" → "Lâm Đồng" (tên ngắn cho thẻ tuyến). */
export function shortProvinceName(name: string): string {
  if (name.startsWith("Thành phố ")) return `TP. ${name.slice("Thành phố ".length)}`;
  if (name.startsWith("Tỉnh ")) return name.slice("Tỉnh ".length);
  return name;
}

const averageOf = (ratings: readonly number[]) => (ratings.length ? Math.round((ratings.reduce((sum, value) => sum + value, 0) / ratings.length) * 10) / 10 : null);

/** Cặp tỉnh điểm đầu → điểm cuối của tuyến; null khi thiếu tỉnh hoặc đi và đến cùng một tỉnh. */
function provincePair(row: Pick<HighlightRouteRow, "originProvinceId" | "destinationProvinceId">, provinceNames: ReadonlyMap<string, string>): ProvincePair | null {
  const { originProvinceId, destinationProvinceId } = row;
  if (!originProvinceId || !destinationProvinceId || originProvinceId === destinationProvinceId) return null;
  const originName = provinceNames.get(originProvinceId);
  const destinationName = provinceNames.get(destinationProvinceId);
  if (!originName || !destinationName) return null;
  return { originProvinceId, originName: shortProvinceName(originName), destinationProvinceId, destinationName: shortProvinceName(destinationName) };
}

/**
 * Gộp tuyến của nhiều nhà xe theo cặp tỉnh điểm đầu → điểm cuối; xếp theo vé đã bán 30 ngày qua, rồi số chuyến sắp
 * chạy, rồi tên. Hàm thuần để test không cần DB.
 */
export function groupPopularRoutes(rows: readonly HighlightRouteRow[], provinceNames: ReadonlyMap<string, string>, limit: number): PopularRoute[] {
  const groups = new Map<string, { route: PopularRoute; bookings: number; trips: number; operators: Set<string>; vehicleTypes: Set<string>; ratings: number[] }>();
  for (const row of rows) {
    const pair = provincePair(row, provinceNames);
    if (!pair) continue;
    const key = `${pair.originProvinceId}>${pair.destinationProvinceId}`;
    const group = groups.get(key) ?? {
      route: { ...pair, distanceMeters: row.distanceMeters, durationSeconds: row.durationSeconds, minPrice: null, vehicleTypeNames: [], nextDepartureAt: null, operatorCount: 0, averageRating: null, reviewCount: 0 },
      bookings: 0,
      trips: 0,
      operators: new Set<string>(),
      vehicleTypes: new Set<string>(),
      ratings: [],
    };
    const { route } = group;
    route.distanceMeters = Math.min(route.distanceMeters, row.distanceMeters);
    route.durationSeconds = Math.min(route.durationSeconds, row.durationSeconds);
    for (const price of row.prices) {
      if (route.minPrice === null || price < route.minPrice) route.minPrice = price;
    }
    if (row.nextDepartureAt && (!route.nextDepartureAt || row.nextDepartureAt < route.nextDepartureAt)) route.nextDepartureAt = row.nextDepartureAt;
    group.trips += row.upcomingTrips;
    group.bookings += row.paidBookings;
    group.operators.add(row.operatorId);
    for (const name of row.vehicleTypeNames) group.vehicleTypes.add(name);
    group.ratings.push(...row.ratings);
    groups.set(key, group);
  }
  return [...groups.values()]
    .sort((a, b) => b.bookings - a.bookings || b.trips - a.trips || `${a.route.originName}${a.route.destinationName}`.localeCompare(`${b.route.originName}${b.route.destinationName}`, "vi"))
    .slice(0, limit)
    .map(({ route, operators, vehicleTypes, ratings }) => ({
      ...route,
      vehicleTypeNames: [...vehicleTypes].sort((a, b) => a.localeCompare(b, "vi")),
      operatorCount: operators.size,
      reviewCount: ratings.length,
      averageRating: averageOf(ratings),
    }));
}

/** Tuyến ACTIVE của nhà xe ACTIVE có chuyến sắp chạy. */
async function loadRouteRows(tx: Tx, now: Date, operatorIds?: readonly string[]): Promise<HighlightRouteRow[]> {
  const upcoming = upcomingTrips(now);
  const routes = await tx.route.findMany({
    where: { status: "ACTIVE", operator: { status: "ACTIVE" }, trips: { some: upcoming }, ...(operatorIds ? { operatorId: { in: [...operatorIds] } } : {}) },
    select: {
      id: true,
      operatorId: true,
      totalDistanceMeters: true,
      totalDurationSeconds: true,
      stops: { orderBy: { sequence: "asc" }, select: { catalogStopPoint: { select: { provinceId: true } }, stopPoint: { select: { provinceId: true } } } },
      fare: { select: { status: true, rules: { select: { price: true } } } },
    },
  });
  if (routes.length === 0) return [];
  const routeIds = routes.map((route) => route.id);
  const tripGroups = await tx.trip.groupBy({ by: ["routeId", "vehicleId"], where: { ...upcoming, routeId: { in: routeIds } }, _count: { _all: true }, _min: { departureAt: true } });
  const vehicleIds = [...new Set(tripGroups.map((row) => row.vehicleId).filter((id): id is string => Boolean(id)))];
  const vehicles = await tx.vehicle.findMany({ where: { id: { in: vehicleIds } }, select: { id: true, vehicleType: { select: { name: true } } } });
  const vehicleTypeOf = new Map(vehicles.map((vehicle) => [vehicle.id, vehicle.vehicleType.name]));
  const tripsByRoute = new Map<string, { count: number; next: Date | null; vehicleTypes: Set<string> }>();
  for (const row of tripGroups) {
    const entry = tripsByRoute.get(row.routeId) ?? { count: 0, next: null, vehicleTypes: new Set<string>() };
    entry.count += row._count._all;
    const first = row._min.departureAt;
    if (first && (!entry.next || first < entry.next)) entry.next = first;
    const typeName = row.vehicleId ? vehicleTypeOf.get(row.vehicleId) : undefined;
    if (typeName) entry.vehicleTypes.add(typeName);
    tripsByRoute.set(row.routeId, entry);
  }
  const since = new Date(now.getTime() - WINDOW_DAYS * DAY);
  const [paid, reviews] = await Promise.all([
    tx.booking.groupBy({ by: ["tripId"], where: { paidAt: { gte: since }, trip: { routeId: { in: routeIds } } }, _count: { _all: true } }),
    tx.review.findMany({ where: { status: "VISIBLE", trip: { routeId: { in: routeIds } } }, select: { rating: true, trip: { select: { routeId: true } } } }),
  ]);
  const tripRoutes = new Map((await tx.trip.findMany({ where: { id: { in: paid.map((row) => row.tripId) } }, select: { id: true, routeId: true } })).map((trip) => [trip.id, trip.routeId]));
  const bookingsByRoute = new Map<string, number>();
  for (const row of paid) {
    const routeId = tripRoutes.get(row.tripId);
    if (routeId) bookingsByRoute.set(routeId, (bookingsByRoute.get(routeId) ?? 0) + row._count._all);
  }
  const ratingsByRoute = new Map<string, number[]>();
  for (const review of reviews) {
    ratingsByRoute.set(review.trip.routeId, [...(ratingsByRoute.get(review.trip.routeId) ?? []), review.rating]);
  }
  const provinceOf = (stop: (typeof routes)[number]["stops"][number] | undefined) => stop?.catalogStopPoint?.provinceId ?? stop?.stopPoint?.provinceId ?? null;
  return routes.map((route) => {
    const trips = tripsByRoute.get(route.id);
    return {
      routeId: route.id,
      operatorId: route.operatorId,
      originProvinceId: provinceOf(route.stops[0]),
      destinationProvinceId: provinceOf(route.stops.at(-1)),
      distanceMeters: route.totalDistanceMeters,
      durationSeconds: route.totalDurationSeconds,
      prices: route.fare?.status === "ACTIVE" ? route.fare.rules.map((rule) => rule.price) : [],
      upcomingTrips: trips?.count ?? 0,
      nextDepartureAt: trips?.next ?? null,
      vehicleTypeNames: [...(trips?.vehicleTypes ?? [])],
      paidBookings: bookingsByRoute.get(route.id) ?? 0,
      ratings: ratingsByRoute.get(route.id) ?? [],
    };
  });
}

async function provinceNamesOf(tx: Tx, rows: readonly HighlightRouteRow[]): Promise<Map<string, string>> {
  const ids = [...new Set(rows.flatMap((row) => [row.originProvinceId, row.destinationProvinceId]).filter((id): id is string => Boolean(id)))];
  const provinces = await tx.province.findMany({ where: { id: { in: ids } }, select: { id: true, name: true } });
  return new Map(provinces.map((province) => [province.id, province.name]));
}

/** Tuyến phổ biến công khai (đọc mọi nhà xe ở ngữ cảnh system, chỉ dữ liệu được phép hiển thị). */
export async function loadPopularRoutes(prisma: Pick<PrismaService, "withSystem">, limit: number, now: Date): Promise<PopularRoute[]> {
  return prisma.withSystem(async (tx) => {
    const rows = await loadRouteRows(tx, now);
    return groupPopularRoutes(rows, await provinceNamesOf(tx, rows), limit);
  });
}

export type FeaturedOperator = {
  operatorId: string;
  displayName: string;
  averageRating: number | null;
  reviewCount: number;
  /** Cặp tỉnh các tuyến đang mở bán của nhà xe, bán chạy trước. */
  routes: ProvincePair[];
};

/** Nhà xe tiêu biểu: đang hoạt động và có chuyến sắp chạy; xếp theo số đánh giá hiển thị, rồi điểm trung bình, rồi tên. */
export async function loadFeaturedOperators(prisma: Pick<PrismaService, "withSystem">, limit: number, now: Date): Promise<FeaturedOperator[]> {
  return prisma.withSystem(async (tx) => {
    const operators = await tx.operatorProfile.findMany({
      where: { status: "ACTIVE", trips: { some: upcomingTrips(now) } },
      select: { id: true, displayName: true },
    });
    if (operators.length === 0) return [];
    const ratings = await tx.review.groupBy({ by: ["operatorId"], where: { status: "VISIBLE", operatorId: { in: operators.map((operator) => operator.id) } }, _avg: { rating: true }, _count: { id: true } });
    const byOperator = new Map(ratings.map((row) => [row.operatorId, row]));
    const featured = operators
      .map((operator) => {
        const rating = byOperator.get(operator.id);
        const average = rating?._avg.rating ?? null;
        return { operatorId: operator.id, displayName: operator.displayName, averageRating: average === null ? null : Math.round(average * 10) / 10, reviewCount: rating?._count.id ?? 0 };
      })
      .sort((a, b) => b.reviewCount - a.reviewCount || (b.averageRating ?? 0) - (a.averageRating ?? 0) || a.displayName.localeCompare(b.displayName, "vi"))
      .slice(0, limit);
    const rows = await loadRouteRows(tx, now, featured.map((operator) => operator.operatorId));
    const names = await provinceNamesOf(tx, rows);
    return featured.map((operator) => ({
      ...operator,
      routes: groupPopularRoutes(rows.filter((row) => row.operatorId === operator.operatorId), names, OPERATOR_ROUTE_LIMIT).map(({ originProvinceId, originName, destinationProvinceId, destinationName }) => ({ originProvinceId, originName, destinationProvinceId, destinationName })),
    }));
  });
}
