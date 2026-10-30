import { createHash } from "node:crypto";
import { HttpException, HttpStatus, Inject, Injectable, Logger } from "@nestjs/common";
import type Redis from "ioredis";
import type { SeatType } from "../database/prisma.types";
import { PrismaService } from "../database/prisma.service";
import { loadOperatorRatings, NO_RATING } from "../database/public-highlights";
import {
  findArea,
  findLandmark,
  findWard,
  loadActiveFareRules,
  loadCancellationTiers,
  loadPublicTrip,
  pickupSaleOpen,
  searchTripCandidates,
  type FareRuleRow,
  type SearchSide,
} from "../database/public-trips";
import { loadPublicSegmentOffers } from "../database/segment-offers";
import { loadWardLocalities } from "../database/stop-localities";
import { PUBLIC_STORAGE, type StorageProvider } from "../external/storage/storage-provider";
import { vndToJson } from "../fare/fare-pricing";
import { coveringOffer, segmentSeatPrice } from "../fare/segment-pricing";
import { composeRouteName } from "../route/route-name";
import { REDIS_CLIENT } from "../redis/redis.config";
import { heldSeatCodes } from "../seat-hold/seat-hold-store";
import type { PublicTrip, PublicTripQuery, TripSearchItem, TripSearchQuery, TripSearchResponse } from "./dto/public-trip.dto";

const MINUTE = 60_000;
const DAY = 24 * 60 * MINUTE;
const VN_OFFSET = 7 * 60 * MINUTE;
/** Bán kính khớp quanh địa danh (BR-80, mặc định 5 km — Admin cấu hình sau). */
const LANDMARK_RADIUS_METERS = 5_000;
/** Số chuyến khớp tối đa mỗi truy vấn trước khi lọc / sắp — một cặp điểm trong một ngày chỉ vài chục chuyến. */
const CANDIDATE_LIMIT = 300;
/** Không nhập ngày: xem mọi chuyến từ bây giờ tới hết bấy nhiêu ngày (chờ duyệt 30/10/2026). */
const BROWSE_DAYS = 7;
/** Cache kết quả tìm 60 giây (ADR-015) — tìm không giữ chỗ nên Redis lỗi thì tính lại, không chặn. */
const CACHE_TTL_SECONDS = 60;

type Matched = { items: TripSearchItem[]; widenedToProvince: TripSearchResponse["widenedToProvince"] };

/**
 * Tìm chuyến + chi tiết chuyến công khai (TASK-TRN-004; FR-MKT-01..05, FR-MKT-15, BR-22, BR-77, BR-80; LLD §6.13 bước 7).
 * Khớp vị trí ở SQL (`database/public-trips.ts`, ngữ cảnh `system` vì đọc mọi nhà xe); giá tính ở đây bằng đúng hàm
 * giá của chuyến (`resolveSeatPrice`). Kết quả theo (điểm đi, điểm đến, ngày, số khách) được cache 60 giây; lọc thêm /
 * sắp xếp / phân trang làm trên kết quả đó. Danh sách chưa trừ chỗ đang được giữ (Redis); chi tiết chuyến thì có.
 */
@Injectable()
export class TripSearchService {
  private readonly logger = new Logger(TripSearchService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(PUBLIC_STORAGE) private readonly storage: StorageProvider,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
  ) {}

  async search(query: TripSearchQuery): Promise<TripSearchResponse> {
    const { items: all, widenedToProvince } = await this.matching(query);
    const operators = new Map<string, { id: string; name: string; count: number }>();
    for (const item of all) {
      const entry = operators.get(item.operator.id) ?? { id: item.operator.id, name: item.operator.name, count: 0 };
      entry.count += 1;
      operators.set(item.operator.id, entry);
    }
    const prices = all.map((item) => item.minPrice);
    const filtered = all.filter((item) => matchesFilters(item, query)).sort(compareBy(query.sort));
    const start = (query.page - 1) * query.limit;
    return {
      items: filtered.slice(start, start + query.limit),
      total: filtered.length,
      page: query.page,
      limit: query.limit,
      facets: {
        operators: [...operators.values()].sort((a, b) => a.name.localeCompare(b.name)),
        priceMin: prices.length > 0 ? Math.min(...prices) : null,
        priceMax: prices.length > 0 ? Math.max(...prices) : null,
      },
      widenedToProvince,
    };
  }

  /**
   * Chi tiết chuyến đang hiển thị; không hiển thị (nháp, khóa, hủy, nhà xe tạm khóa, mọi điểm đón đã qua giờ bán online) →
   * 404. Kèm chặng khách đi (`query`, 3.3) thì giá ghế theo chặng và tiêu đề theo nơi đón / trả.
   */
  async getTrip(tripId: string, query: PublicTripQuery = {}): Promise<PublicTrip> {
    const now = new Date();
    const trip = await loadPublicTrip(this.prisma, tripId, now);
    if (!trip || !trip.vehicle) {
      throw new HttpException({ code: "TRIP_NOT_FOUND", detail: "Không tìm thấy chuyến.", title: "Trip error" }, HttpStatus.NOT_FOUND);
    }
    const [rules, tiers, ratings, offers] = await Promise.all([
      loadActiveFareRules(this.prisma, [trip.route.id]),
      loadCancellationTiers(this.prisma, [trip.operator.id], now),
      loadOperatorRatings(this.prisma, [trip.operator.id]),
      loadPublicSegmentOffers(this.prisma, [trip.id]),
    ]);
    const pickup = trip.stops.find((stop) => stop.sequence === query.pickupSequence);
    const dropoff = trip.stops.find((stop) => stop.sequence === query.dropoffSequence);
    const chosen =
      pickup?.allowPickup && dropoff?.allowDropoff && pickup.sequence < dropoff.sequence && pickupSaleOpen(pickup.plannedAt, trip.onlineSaleCutoffMinutes, now)
        ? { pickup, dropoff }
        : null;
    const offer = chosen ? coveringOffer(offers.get(trip.id) ?? [], chosen.pickup.sequence, chosen.dropoff.sequence) : null;
    const segment = chosen
      ? {
          pickupSequence: chosen.pickup.sequence,
          dropoffSequence: chosen.dropoff.sequence,
          title: (await this.segmentTitles([[chosen.pickup, chosen.dropoff]]))[0]!,
        }
      : null;
    const lastPickup = [...trip.stops].reverse().find((stop) => stop.allowPickup)!;
    const closingStop = chosen?.pickup ?? lastPickup;
    const vehicleTypeId = trip.vehicle.vehicleType.id;
    // Chỗ đang được giữ (BTP-001) hiện "không đặt được"; Redis lỗi thì chỉ dựa trạng thái Postgres — lúc giữ chỗ kiểm lại.
    const held = await heldSeatCodes(this.redis, trip.id, trip.seats.map((seat) => seat.seatCode)).catch((error: unknown) => {
      this.logger.warn({ event: "trip_detail.holds_read_failed", error });
      return new Set<string>();
    });
    return {
      tripId: trip.id,
      operator: {
        id: trip.operator.id,
        name: trip.operator.displayName,
        slug: trip.operator.operatorSlug,
        hotline: trip.operator.hotline,
        ...(ratings.get(trip.operator.id) ?? NO_RATING),
      },
      routeName: trip.route.name,
      segment,
      departureAt: trip.departureAt.toISOString(),
      arrivalAt: trip.arrivalAt.toISOString(),
      onlineSaleClosesAt: new Date(closingStop.plannedAt.getTime() - trip.onlineSaleCutoffMinutes * MINUTE).toISOString(),
      note: trip.note,
      vehicleType: { name: trip.vehicle.vehicleType.name, form: trip.vehicle.vehicleType.form, class: trip.vehicle.vehicleType.class },
      amenities: trip.vehicle.amenities.map(({ amenity }) => amenity),
      vehicleImages: trip.vehicle.images.map((image) => ({ url: this.storage.publicUrl(image.objectKey), caption: image.caption })),
      stops: trip.stops.map(({ catalogStopPoint, stopPoint, catalogStopPointId: _catalog, stopPointId: _private, plannedAt, pickupWindowStart, pickupWindowEnd, ...stop }) => {
        const { wardId: _ward, ...point } = (catalogStopPoint ?? stopPoint)!;
        return {
          ...stop,
          ...point,
          plannedAt: plannedAt.toISOString(),
          pickupWindowStart: pickupWindowStart?.toISOString() ?? null,
          pickupWindowEnd: pickupWindowEnd?.toISOString() ?? null,
          pickupOpen: stop.allowPickup && pickupSaleOpen(plannedAt, trip.onlineSaleCutoffMinutes, now),
        };
      }),
      seats: [...trip.seats]
        .sort((a, b) => a.deck - b.deck || a.row - b.row || a.column - b.column)
        .map(({ seatCode, status, ...seat }) => {
          const price = segmentSeatPrice(offer, rules, vehicleTypeId, seat.type, trip.departureAt);
          return {
            code: seatCode,
            ...seat,
            status: status === "AVAILABLE" && price !== null && !held.has(seatCode) ? ("AVAILABLE" as const) : ("UNAVAILABLE" as const),
            price: price === null ? null : vndToJson(price),
          };
        }),
      cancellationPolicy: { tiers: tiers.get(trip.operator.id) ?? [] },
    };
  }

  /** Tiêu đề chặng theo nơi của điểm đón / trả (phường → tên nơi quen thuộc, 3.1). */
  private async segmentTitles(pairs: [StopWithPoint, StopWithPoint][]): Promise<string[]> {
    const point = (stop: StopWithPoint) => (stop.catalogStopPoint ?? stop.stopPoint)!;
    const localities = await loadWardLocalities(this.prisma, pairs.flatMap(([a, b]) => [point(a).wardId, point(b).wardId]));
    const named = (stop: StopWithPoint) => ({ name: point(stop).name, locality: localities.get(point(stop).wardId) ?? point(stop).name });
    return pairs.map(([a, b]) => segmentTitle(named(a), named(b)));
  }

  /**
   * Mọi chuyến khớp (điểm đi, điểm đến, ngày, số khách), kèm giá thấp nhất — cache 60 giây. Phía phường / xã hoặc khu vực
   * không ra chuyến nào → nới phía đó ra cả tỉnh chứa nó và đánh dấu `widenedToProvince`.
   */
  private async matching(query: TripSearchQuery): Promise<Matched> {
    const sideKey = (provinceId?: string, wardId?: string, areaId?: string, stopPointId?: string) =>
      provinceId ?? (wardId ? `ward:${wardId}` : areaId ? `area:${areaId}` : stopPointId ? `stop:${stopPointId}` : "any");
    const identity = {
      from: sideKey(query.fromProvinceId, query.fromWardId, query.fromAreaId, query.fromStopPointId),
      to: sideKey(query.toProvinceId, query.toWardId, query.toAreaId, query.toStopPointId),
      // Không nhập ngày: cửa sổ trượt theo giờ (cache 60 giây vẫn đủ mới).
      date: query.date ?? `browse:${new Date().toISOString().slice(0, 13)}`,
      passengers: query.passengers,
    };
    // Tăng `vN` mỗi khi đổi dạng kết quả cache (`Matched` / `TripSearchItem`), để kết quả cũ trong cache không lọt ra response mới.
    const key = `trip-search:v3:${createHash("sha256").update(JSON.stringify(identity)).digest("hex")}`;
    const cached = await this.redis.get(key).catch((error: unknown) => {
      this.logger.warn({ event: "trip_search.cache_read_failed", error });
      return null;
    });
    if (cached) {
      return JSON.parse(cached) as Matched;
    }
    const [from, to] = await Promise.all([
      this.side(query.fromProvinceId, query.fromWardId, query.fromAreaId, query.fromStopPointId),
      this.side(query.toProvinceId, query.toWardId, query.toAreaId, query.toStopPointId),
    ]);
    let matched: Matched = { items: [], widenedToProvince: { from: false, to: false } };
    if (from && to) {
      matched.items = await this.compute(query, from.side, to.side);
      const widen = { from: Boolean(from.wardProvinceId), to: Boolean(to.wardProvinceId) };
      if (matched.items.length === 0 && (widen.from || widen.to)) {
        const fromSide = widen.from ? { provinceId: from.wardProvinceId! } : from.side;
        const toSide = widen.to ? { provinceId: to.wardProvinceId! } : to.side;
        const widened = await this.compute(query, fromSide, toSide);
        // Nới ra cả tỉnh vẫn không có chuyến → giữ kết quả rỗng, không báo "đang hiện chuyến trong tỉnh".
        if (widened.length > 0) {
          matched = { items: widened, widenedToProvince: widen };
        }
      }
    }
    await this.redis.set(key, JSON.stringify(matched), "EX", CACHE_TTL_SECONDS).catch((error: unknown) => {
      this.logger.warn({ event: "trip_search.cache_write_failed", error });
    });
    return matched;
  }

  private async compute(query: TripSearchQuery, from: SearchSide, to: SearchSide): Promise<TripSearchItem[]> {
    const now = new Date();
    const dayStart = query.date ? new Date(Date.parse(`${query.date}T00:00:00Z`) - VN_OFFSET) : now;
    const candidates = await searchTripCandidates(this.prisma, {
      from,
      to,
      dayStart,
      dayEnd: new Date(dayStart.getTime() + (query.date ? DAY : BROWSE_DAYS * DAY)),
      passengers: query.passengers,
      now,
      limit: CANDIDATE_LIMIT,
    });
    const [rules, ratings] = await Promise.all([
      loadActiveFareRules(this.prisma, [...new Set(candidates.map((candidate) => candidate.routeId))]),
      loadOperatorRatings(this.prisma, [...new Set(candidates.map((candidate) => candidate.operatorId))]),
    ]);
    const rulesByRoute = new Map<string, FareRuleRow[]>();
    for (const rule of rules) {
      rulesByRoute.set(rule.routeId, [...(rulesByRoute.get(rule.routeId) ?? []), rule]);
    }
    const [offers, localities] = await Promise.all([
      loadPublicSegmentOffers(this.prisma, candidates.map((candidate) => candidate.tripId)),
      loadWardLocalities(this.prisma, candidates.flatMap((candidate) => [candidate.pickupWardId, candidate.dropoffWardId])),
    ]);
    const items: TripSearchItem[] = [];
    for (const candidate of candidates) {
      const routeRules = rulesByRoute.get(candidate.routeId) ?? [];
      const offer = coveringOffer(offers.get(candidate.tripId) ?? [], candidate.pickupSequence, candidate.dropoffSequence);
      const prices = candidate.availableSeatTypes
        .map((type) => segmentSeatPrice(offer, routeRules, candidate.vehicleTypeId, type as SeatType, candidate.departureAt))
        .filter((price): price is bigint => price !== null && price > 0n);
      if (prices.length === 0) {
        // Bảng giá bị ngừng sau khi mở bán: chưa đặt được nên không hiển thị (BR-22).
        continue;
      }
      const minPrice = prices.reduce((min, price) => (price < min ? price : min));
      items.push({
        tripId: candidate.tripId,
        operator: {
          id: candidate.operatorId,
          name: candidate.operatorName,
          slug: candidate.operatorSlug,
          ...(ratings.get(candidate.operatorId) ?? NO_RATING),
        },
        routeName: candidate.routeName,
        segmentTitle: segmentTitle(
          { name: candidate.pickupName, locality: localities.get(candidate.pickupWardId) ?? candidate.pickupName },
          { name: candidate.dropoffName, locality: localities.get(candidate.dropoffWardId) ?? candidate.dropoffName },
        ),
        vehicleType: {
          name: candidate.vehicleTypeName,
          form: candidate.vehicleForm as TripSearchItem["vehicleType"]["form"],
          class: candidate.vehicleClass as TripSearchItem["vehicleType"]["class"],
        },
        departureAt: candidate.departureAt.toISOString(),
        arrivalAt: candidate.arrivalAt.toISOString(),
        pickup: { sequence: candidate.pickupSequence, name: candidate.pickupName, address: candidate.pickupAddress, plannedAt: candidate.pickupAt.toISOString() },
        dropoff: {
          sequence: candidate.dropoffSequence,
          name: candidate.dropoffName,
          address: candidate.dropoffAddress,
          plannedAt: candidate.dropoffAt.toISOString(),
        },
        durationMinutes: Math.round((candidate.dropoffAt.getTime() - candidate.pickupAt.getTime()) / MINUTE),
        availableSeats: candidate.availableSeats,
        minPrice: vndToJson(minPrice),
        vehicleCoverImageUrl: candidate.coverImageKey ? this.storage.publicUrl(candidate.coverImageKey) : null,
        amenities: candidate.amenityIds.map((amenityId, index) => ({ id: amenityId, name: candidate.amenityNames[index]! })),
        onlineSaleClosesAt: new Date(candidate.pickupAt.getTime() - candidate.onlineSaleCutoffMinutes * MINUTE).toISOString(),
      });
    }
    return items;
  }

  /**
   * Tỉnh / thành giữ nguyên; phường / xã → khớp điểm trong phường; khu vực → khớp điểm trong nhóm phường của khu vực
   * (`wardProvinceId` = tỉnh để nới khi không có chuyến); địa danh → tọa độ + bán kính. Phường / khu vực / địa danh không
   * có hoặc ngừng dùng → không khớp gì.
   */
  private async side(
    provinceId: string | undefined,
    wardId: string | undefined,
    areaId: string | undefined,
    stopPointId: string | undefined,
  ): Promise<{ side: SearchSide; wardProvinceId?: string } | null> {
    if (!provinceId && !wardId && !areaId && !stopPointId) {
      return { side: { any: true } };
    }
    if (provinceId) {
      return { side: { provinceId } };
    }
    if (wardId) {
      const ward = await findWard(this.prisma, wardId);
      return ward ? { side: { wardId }, wardProvinceId: ward.provinceId } : null;
    }
    if (areaId) {
      const area = await findArea(this.prisma, areaId);
      return area ? { side: { wardIds: area.wardIds }, wardProvinceId: area.provinceId } : null;
    }
    const landmark = await findLandmark(this.prisma, stopPointId!);
    return landmark ? { side: { ...landmark, radiusMeters: LANDMARK_RADIUS_METERS } } : null;
  }
}

/** `HH:mm` giờ VN của một mốc ISO. */
function vnClock(iso: string): string {
  return new Date(Date.parse(iso) + VN_OFFSET).toISOString().slice(11, 16);
}

function matchesFilters(item: TripSearchItem, query: TripSearchQuery): boolean {
  const clock = vnClock(item.pickup.plannedAt);
  return (
    (!query.operatorId || item.operator.id === query.operatorId) &&
    (!query.vehicleForm || item.vehicleType.form === query.vehicleForm) &&
    (!query.vehicleClass || item.vehicleType.class === query.vehicleClass) &&
    (!query.departureFrom || clock >= query.departureFrom) &&
    (!query.departureTo || clock <= query.departureTo) &&
    (query.priceMin === undefined || item.minPrice >= query.priceMin) &&
    (query.priceMax === undefined || item.minPrice <= query.priceMax) &&
    query.amenityIds.every((amenityId) => item.amenities.some((amenity) => amenity.id === amenityId))
  );
}

function compareBy(sort: TripSearchQuery["sort"]): (a: TripSearchItem, b: TripSearchItem) => number {
  const byDeparture = (a: TripSearchItem, b: TripSearchItem) =>
    a.pickup.plannedAt.localeCompare(b.pickup.plannedAt) || a.tripId.localeCompare(b.tripId);
  if (sort === "price") {
    return (a, b) => a.minPrice - b.minPrice || byDeparture(a, b);
  }
  if (sort === "duration") {
    return (a, b) => a.durationMinutes - b.durationMinutes || byDeparture(a, b);
  }
  return byDeparture;
}

type StopWithPoint = { catalogStopPoint: { name: string; wardId: string } | null; stopPoint: { name: string; wardId: string } | null };

/** "Nơi đón → nơi trả" (hai điểm cùng nơi thì tên hai điểm) — cùng cách ghép tên tuyến tự động. */
function segmentTitle(pickup: { name: string; locality: string }, dropoff: { name: string; locality: string }): string {
  return composeRouteName([
    { ...pickup, allowPickup: true, allowDropoff: false },
    { ...dropoff, allowPickup: false, allowDropoff: true },
  ]);
}
