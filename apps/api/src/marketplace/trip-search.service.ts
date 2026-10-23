import { createHash } from "node:crypto";
import { HttpException, HttpStatus, Inject, Injectable, Logger } from "@nestjs/common";
import type Redis from "ioredis";
import type { SeatType } from "../database/prisma.types";
import { PrismaService } from "../database/prisma.service";
import {
  findLandmark,
  loadActiveFareRules,
  loadCancellationTiers,
  loadPublicTrip,
  searchTripCandidates,
  type FareRuleRow,
  type SearchSide,
} from "../database/public-trips";
import { PUBLIC_STORAGE, type StorageProvider } from "../external/storage/storage-provider";
import { resolveSeatPrice, vndToJson } from "../fare/fare-pricing";
import { REDIS_CLIENT } from "../redis/redis.config";
import { heldSeatCodes } from "../seat-hold/seat-hold-store";
import type { PublicTrip, TripSearchItem, TripSearchQuery, TripSearchResponse } from "./dto/public-trip.dto";

const MINUTE = 60_000;
const DAY = 24 * 60 * MINUTE;
const VN_OFFSET = 7 * 60 * MINUTE;
/** Bán kính khớp quanh địa danh (BR-80, mặc định 5 km — Admin cấu hình sau). */
const LANDMARK_RADIUS_METERS = 5_000;
/** Số chuyến khớp tối đa mỗi truy vấn trước khi lọc / sắp — một cặp điểm trong một ngày chỉ vài chục chuyến. */
const CANDIDATE_LIMIT = 300;
/** Cache kết quả tìm 60 giây (ADR-015) — tìm không giữ chỗ nên Redis lỗi thì tính lại, không chặn. */
const CACHE_TTL_SECONDS = 60;

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
    const all = await this.matching(query);
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
    };
  }

  /** Chi tiết chuyến đang hiển thị; không hiển thị (nháp, khóa, hủy, nhà xe tạm khóa, quá giờ bán online) → 404. */
  async getTrip(tripId: string): Promise<PublicTrip> {
    const now = new Date();
    const trip = await loadPublicTrip(this.prisma, tripId, now);
    if (!trip || !trip.vehicle) {
      throw new HttpException({ code: "TRIP_NOT_FOUND", detail: "Không tìm thấy chuyến.", title: "Trip error" }, HttpStatus.NOT_FOUND);
    }
    const [rules, tiers] = await Promise.all([
      loadActiveFareRules(this.prisma, [trip.route.id]),
      loadCancellationTiers(this.prisma, [trip.operator.id], now),
    ]);
    const vehicleTypeId = trip.vehicle.vehicleType.id;
    // Chỗ đang được giữ (BTP-001) hiện "không đặt được"; Redis lỗi thì chỉ dựa trạng thái Postgres — lúc giữ chỗ kiểm lại.
    const held = await heldSeatCodes(this.redis, trip.id, trip.seats.map((seat) => seat.seatCode)).catch((error: unknown) => {
      this.logger.warn({ event: "trip_detail.holds_read_failed", error });
      return new Set<string>();
    });
    return {
      tripId: trip.id,
      operator: { id: trip.operator.id, name: trip.operator.displayName, slug: trip.operator.operatorSlug, hotline: trip.operator.hotline },
      routeName: trip.route.name,
      departureAt: trip.departureAt.toISOString(),
      arrivalAt: trip.arrivalAt.toISOString(),
      onlineSaleClosesAt: new Date(trip.departureAt.getTime() - trip.onlineSaleCutoffMinutes * MINUTE).toISOString(),
      note: trip.note,
      vehicleType: { name: trip.vehicle.vehicleType.name, form: trip.vehicle.vehicleType.form, class: trip.vehicle.vehicleType.class },
      amenities: trip.vehicle.amenities.map(({ amenity }) => amenity),
      vehicleImages: trip.vehicle.images.map((image) => ({ url: this.storage.publicUrl(image.objectKey), caption: image.caption })),
      stops: trip.stops.map(({ catalogStopPoint, stopPoint, plannedAt, pickupWindowStart, pickupWindowEnd, ...stop }) => {
        const point = (catalogStopPoint ?? stopPoint)!;
        return { ...stop, ...point, plannedAt: plannedAt.toISOString(), pickupWindowStart: pickupWindowStart?.toISOString() ?? null, pickupWindowEnd: pickupWindowEnd?.toISOString() ?? null };
      }),
      seats: [...trip.seats]
        .sort((a, b) => a.deck - b.deck || a.row - b.row || a.column - b.column)
        .map(({ seatCode, status, ...seat }) => {
          const price = resolveSeatPrice(rules, vehicleTypeId, seat.type, trip.departureAt);
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

  /** Mọi chuyến khớp (điểm đi, điểm đến, ngày, số khách), kèm giá thấp nhất — cache 60 giây. */
  private async matching(query: TripSearchQuery): Promise<TripSearchItem[]> {
    const identity = {
      from: query.fromProvinceId ?? `stop:${query.fromStopPointId}`,
      to: query.toProvinceId ?? `stop:${query.toStopPointId}`,
      date: query.date,
      passengers: query.passengers,
    };
    const key = `trip-search:v1:${createHash("sha256").update(JSON.stringify(identity)).digest("hex")}`;
    const cached = await this.redis.get(key).catch((error: unknown) => {
      this.logger.warn({ event: "trip_search.cache_read_failed", error });
      return null;
    });
    if (cached) {
      return JSON.parse(cached) as TripSearchItem[];
    }
    const items = await this.compute(query);
    await this.redis.set(key, JSON.stringify(items), "EX", CACHE_TTL_SECONDS).catch((error: unknown) => {
      this.logger.warn({ event: "trip_search.cache_write_failed", error });
    });
    return items;
  }

  private async compute(query: TripSearchQuery): Promise<TripSearchItem[]> {
    const [from, to] = await Promise.all([
      this.side(query.fromProvinceId, query.fromStopPointId),
      this.side(query.toProvinceId, query.toStopPointId),
    ]);
    if (!from || !to) {
      return [];
    }
    const dayStart = new Date(Date.parse(`${query.date}T00:00:00Z`) - VN_OFFSET);
    const candidates = await searchTripCandidates(this.prisma, {
      from,
      to,
      dayStart,
      dayEnd: new Date(dayStart.getTime() + DAY),
      passengers: query.passengers,
      now: new Date(),
      limit: CANDIDATE_LIMIT,
    });
    const rules = await loadActiveFareRules(this.prisma, [...new Set(candidates.map((candidate) => candidate.routeId))]);
    const rulesByRoute = new Map<string, FareRuleRow[]>();
    for (const rule of rules) {
      rulesByRoute.set(rule.routeId, [...(rulesByRoute.get(rule.routeId) ?? []), rule]);
    }
    const items: TripSearchItem[] = [];
    for (const candidate of candidates) {
      const routeRules = rulesByRoute.get(candidate.routeId) ?? [];
      const prices = candidate.availableSeatTypes
        .map((type) => resolveSeatPrice(routeRules, candidate.vehicleTypeId, type as SeatType, candidate.departureAt))
        .filter((price): price is bigint => price !== null && price > 0n);
      if (prices.length === 0) {
        // Bảng giá bị ngừng sau khi mở bán: chưa đặt được nên không hiển thị (BR-22).
        continue;
      }
      const minPrice = prices.reduce((min, price) => (price < min ? price : min));
      items.push({
        tripId: candidate.tripId,
        operator: { id: candidate.operatorId, name: candidate.operatorName, slug: candidate.operatorSlug },
        routeName: candidate.routeName,
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
        onlineSaleClosesAt: new Date(candidate.departureAt.getTime() - candidate.onlineSaleCutoffMinutes * MINUTE).toISOString(),
      });
    }
    return items;
  }

  /** Tỉnh / thành giữ nguyên; địa danh → tọa độ + bán kính; địa danh không có / ngừng dùng → không khớp gì. */
  private async side(provinceId: string | undefined, stopPointId: string | undefined): Promise<SearchSide | null> {
    if (provinceId) {
      return { provinceId };
    }
    const landmark = await findLandmark(this.prisma, stopPointId!);
    return landmark ? { ...landmark, radiusMeters: LANDMARK_RADIUS_METERS } : null;
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
