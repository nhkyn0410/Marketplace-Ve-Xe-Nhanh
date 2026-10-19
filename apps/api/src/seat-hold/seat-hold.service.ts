import { randomUUID } from "node:crypto";
import { HttpException, Inject, Injectable, Logger } from "@nestjs/common";
import type Redis from "ioredis";
import { PrismaService } from "../database/prisma.service";
import { loadActiveFareRules, loadPublicTrip } from "../database/public-trips";
import { resolveSeatPrice, vndToJson } from "../fare/fare-pricing";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { REDIS_CLIENT } from "../redis/redis.config";
import type { SeatHoldInput, SeatHoldResponse } from "./dto/seat-hold.dto";
import {
  holdRateLimited,
  holdUnavailable,
  seatHoldConflict,
  seatHoldExpired,
  seatNotAvailable,
  seatUnknown,
  stopsInvalid,
  tripNotFound,
} from "./seat-hold.errors";
import { acquireHold, type HoldRecord, readHold, releaseHold, stillHeld } from "./seat-hold-store";

const MINUTE = 60_000;
/** Mặc định khi chưa có phiên bản chính sách giữ chỗ (ADR-015: 10 phút). */
const DEFAULT_HOLD_MINUTES = 10;
/** Chống giữ chỗ hàng loạt: tối đa 20 lần giữ chỗ / 10 phút / địa chỉ IP. */
const HOLDS_PER_WINDOW = 20;
const WINDOW_SECONDS = 600;
const INCR_WITH_TTL = `
local c = redis.call('INCR', KEYS[1])
if c == 1 then redis.call('EXPIRE', KEYS[1], ARGV[1]) end
return c
`;

/**
 * Giữ chỗ (TASK-BTP-001, LLD §6.1, ADR-015): kiểm chuyến đang hiển thị công khai (BR-22), điểm đón / trả (BR-23), chỗ còn
 * trống trong Postgres + có giá, rồi giữ cả lô trên Redis (`SET NX PX` qua Lua — được cả lô hoặc không). Hạn = phút giữ chỗ
 * theo chính sách nền tảng đang áp dụng, không quá giờ ngừng bán online. Redis lỗi → 503, KHÔNG giữ trong bộ nhớ.
 * Giữ chỗ của hành khách đã đăng nhập chỉ chính họ thấy; của khách vãng lai thì ai có `holdId` (bí mật, ngẫu nhiên) là chủ.
 */
@Injectable()
export class SeatHoldService {
  private readonly logger = new Logger(SeatHoldService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
  ) {}

  async create(user: VerifiedAccessToken | null, clientIp: string | undefined, input: SeatHoldInput): Promise<SeatHoldResponse> {
    if (clientIp) {
      await this.limit(clientIp);
    }
    const now = new Date();
    const trip = await loadPublicTrip(this.prisma, input.tripId, now);
    if (!trip || !trip.vehicle) {
      throw tripNotFound();
    }
    const pickup = trip.stops.find((stop) => stop.sequence === input.pickupSequence);
    const dropoff = trip.stops.find((stop) => stop.sequence === input.dropoffSequence);
    if (!pickup?.allowPickup || !dropoff?.allowDropoff || pickup.sequence >= dropoff.sequence) {
      throw stopsInvalid();
    }
    const seats = input.seatCodes.map((code) => trip.seats.find((seat) => seat.seatCode === code));
    if (seats.some((seat) => !seat)) {
      throw seatUnknown();
    }
    const rules = await loadActiveFareRules(this.prisma, [trip.route.id]);
    const priced = seats.map((seat) => ({
      code: seat!.seatCode,
      type: seat!.type,
      status: seat!.status,
      price: resolveSeatPrice(rules, trip.vehicle!.vehicleType.id, seat!.type, trip.departureAt),
    }));
    const unavailable = priced.filter((seat) => seat.status !== "AVAILABLE" || seat.price === null || seat.price <= 0n);
    if (unavailable.length > 0) {
      throw seatNotAvailable(unavailable.map((seat) => seat.code));
    }

    const saleClosesAt = trip.departureAt.getTime() - trip.onlineSaleCutoffMinutes * MINUTE;
    const ttlMs = Math.min((await this.holdMinutes(now)) * MINUTE, saleClosesAt - now.getTime());
    const point = (stop: NonNullable<typeof pickup>) => ({
      sequence: stop.sequence,
      name: (stop.catalogStopPoint ?? stop.stopPoint)!.name,
      plannedAt: stop.plannedAt.toISOString(),
    });
    const record: HoldRecord = {
      holdId: randomUUID(),
      tripId: trip.id,
      seatCodes: input.seatCodes,
      pickup: point(pickup),
      dropoff: point(dropoff),
      userId: user?.sub ?? null,
      seats: priced.map((seat) => ({ code: seat.code, type: seat.type, price: vndToJson(seat.price!) })),
      subtotal: vndToJson(priced.reduce((sum, seat) => sum + seat.price!, 0n)),
      createdAt: now.toISOString(),
      expiresAt: new Date(now.getTime() + ttlMs).toISOString(),
    };
    const conflict = await this.redisCall(() => acquireHold(this.redis, record, ttlMs));
    if (conflict) {
      throw seatHoldConflict(conflict);
    }
    return toResponse(record);
  }

  async get(user: VerifiedAccessToken | null, holdId: string): Promise<SeatHoldResponse> {
    return toResponse(await this.owned(user, holdId));
  }

  /** Bỏ giữ chỗ (khách quay lại chọn chỗ khác); đã hết hạn → 404 như không tồn tại. */
  async release(user: VerifiedAccessToken | null, holdId: string): Promise<void> {
    const record = await this.owned(user, holdId);
    await this.redisCall(() => releaseHold(this.redis, record));
  }

  /**
   * Phiên giữ chỗ để tạo booking (BTP-002): đúng chủ và MỌI chỗ vẫn đang được giữ bởi chính phiên — hết hạn / bị giữ lại
   * → 404 `SEAT_HOLD_EXPIRED`. Trả bản ghi để booking dùng; xong booking thì gọi `release` để trả khóa Redis.
   */
  async takeForBooking(user: VerifiedAccessToken | null, holdId: string): Promise<HoldRecord> {
    const record = await this.owned(user, holdId);
    if (!(await this.redisCall(() => stillHeld(this.redis, record)))) {
      throw seatHoldExpired();
    }
    return record;
  }

  /** Trả khóa Redis của phiên đã dùng tạo booking (chỗ giờ do Postgres giữ). Redis lỗi chỉ ghi log — khóa tự hết hạn. */
  async releaseConsumed(record: HoldRecord): Promise<void> {
    await releaseHold(this.redis, record).catch((error: unknown) => {
      this.logger.warn({ event: "seat_hold.release_after_booking_failed", holdId: record.holdId, error });
    });
  }

  private async owned(user: VerifiedAccessToken | null, holdId: string): Promise<HoldRecord> {
    const record = await this.redisCall(() => readHold(this.redis, holdId));
    // Giữ chỗ của hành khách khác = không tồn tại (không lộ việc holdId có thật).
    if (!record || (record.userId !== null && record.userId !== user?.sub)) {
      throw seatHoldExpired();
    }
    return record;
  }

  /** Phút giữ chỗ của phiên bản chính sách nền tảng đang áp dụng (A6); chưa có → 10 phút. */
  private async holdMinutes(now: Date): Promise<number> {
    const version = await this.prisma.policyVersion.findFirst({
      where: { type: "SEAT_HOLD", operatorId: null, status: "PUBLISHED", effectiveFrom: { lte: now } },
      orderBy: { effectiveFrom: "desc" },
      select: { rules: true },
    });
    const minutes = (version?.rules as { holdMinutes?: number } | undefined)?.holdMinutes;
    return typeof minutes === "number" && minutes > 0 ? minutes : DEFAULT_HOLD_MINUTES;
  }

  private async limit(clientIp: string): Promise<void> {
    const count = await this.redisCall(async () =>
      Number(await this.redis.eval(INCR_WITH_TTL, 1, `seat-hold:ip:${clientIp}`, String(WINDOW_SECONDS))),
    );
    if (count > HOLDS_PER_WINDOW) {
      throw holdRateLimited();
    }
  }

  private async redisCall<T>(work: () => Promise<T>): Promise<T> {
    try {
      return await work();
    } catch (error) {
      if (error instanceof HttpException) {
        throw error;
      }
      this.logger.error({ event: "seat_hold.redis_failed", error });
      throw holdUnavailable();
    }
  }
}

function toResponse(record: HoldRecord): SeatHoldResponse {
  return {
    holdId: record.holdId,
    tripId: record.tripId,
    pickup: record.pickup,
    dropoff: record.dropoff,
    seats: record.seats as SeatHoldResponse["seats"],
    subtotal: record.subtotal,
    expiresAt: record.expiresAt,
  };
}
