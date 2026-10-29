import { randomUUID } from "node:crypto";
import Redis from "ioredis";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import type { AuditService } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type {
  Coordinates,
  RouteLeg,
  RoutingProvider,
} from "../external/routing/routing-provider";
import type { StorageProvider } from "../external/storage/storage-provider";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { TripSearchService } from "../marketplace/trip-search.service";
import {
  createRequestRedisClientOptions,
  getRedisUrl,
} from "../redis/redis.config";
import { RouteInputSchema, SubRouteInputSchema } from "../route/dto/route.dto";
import { RouteService } from "../route/route.service";
import { TripInputSchema } from "../trip/dto/trip.dto";
import { TripService } from "../trip/trip.service";
import { SeatMapInputSchema } from "../vehicle/dto/seat-map.dto";
import { VehicleInputSchema } from "../vehicle/dto/vehicle.dto";
import { SeatMapService } from "../vehicle/seat-map.service";
import { VehicleService } from "../vehicle/vehicle.service";
import { SeatHoldInputSchema } from "./dto/seat-hold.dto";
import { seatKey } from "./seat-hold-store";
import { SeatHoldService } from "./seat-hold.service";

/**
 * TASK-BTP-001 — giữ chỗ trên Postgres + Redis THẬT (role app). Chuyến dựng qua service thật rồi mở bán thẳng DB.
 */
const url = process.env.DATABASE_URL;
const ready = Boolean(url && process.env.REDIS_URL);
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
// const HOUR = 3_600_000;
const MINUTE = 60_000;

async function rejectionOf(
  promise: Promise<unknown>,
): Promise<{ status?: number; code?: string; reasons?: string[] }> {
  try {
    await promise;
    return {};
  } catch (error) {
    const response = (
      error as { getResponse?: () => { code?: string; reasons?: string[] } }
    ).getResponse?.();
    return {
      status: (error as { getStatus?: () => number }).getStatus?.(),
      code: response?.code,
      reasons: response?.reasons,
    };
  }
}

class FakeRouting implements RoutingProvider {
  readonly source = "GOONG" as const;
  async measureLegs(points: Coordinates[]): Promise<RouteLeg[]> {
    return points
      .slice(1)
      .map(() => ({ distanceMeters: 100_000, durationSeconds: 3 * 3600 }));
  }
}

describe.skipIf(!ready && !requireDb)(
  "Giữ chỗ — Postgres + Redis thật (BTP-001)",
  () => {
    let prisma: PrismaService;
    let redis: Redis;
    let holds: SeatHoldService;
    let search: TripSearchService;
    let trips: TripService;
    const tag = randomUUID().slice(0, 8);
    const operatorId = randomUUID();
    const province = randomUUID();
    const ward = randomUUID();
    const points = [randomUUID(), randomUUID(), randomUUID()];
    const vehicleType = randomUUID();
    let routeId: string;
    let vehicleId: string;
    let openTrip: string;
    const passenger = (sub: string) =>
      ({ sub, role: "PASSENGER" }) as VerifiedAccessToken;
    const authz: Authorization = {
      permission: "trip:manage",
      scope: "tenant",
      db: tenantScope(operatorId),
    };
    const hold = (overrides: Record<string, unknown> = {}) =>
      SeatHoldInputSchema.parse({
        tripId: openTrip,
        seatCodes: ["A1"],
        pickupSequence: 1,
        dropoffSequence: 3,
        ...overrides,
      });
    let ipSeq = 0;
    const nextIp = () => `10.99.${tag.charCodeAt(0)}.${ipSeq++}`;

    async function trip(departureAt: Date, status = "OPEN_FOR_SALE") {
      const created = await trips.create(
        authz,
        TripInputSchema.parse({
          routeId,
          vehicleId,
          departureAt: departureAt.toISOString(),
          stopTimes: null,
          onlineSaleCutoffMinutes: 60,
          note: null,
        }),
      );
      await prisma.withSystem((tx) =>
        tx.trip.update({
          where: { id: created.id },
          data: { status: status as "OPEN_FOR_SALE" },
        }),
      );
      return created.id;
    }

    beforeAll(async () => {
      prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
      redis = new Redis(
        getRedisUrl(),
        createRequestRedisClientOptions("seat-hold-test"),
      );
      holds = new SeatHoldService(prisma, redis);
      search = new TripSearchService(
        prisma,
        { publicUrl: (key: string) => key } as unknown as StorageProvider,
        redis,
      );
      trips = new TripService(prisma, {} as AuditService);
      await prisma.withSystem(async (tx) => {
        await tx.operatorProfile.create({
          data: {
            id: operatorId,
            operatorSlug: `hold-${tag}`,
            displayName: `Giữ chỗ ${tag}`,
          },
        });
        await tx.province.create({
          data: { id: province, code: `hp-${tag}`, name: "Tỉnh giữ chỗ" },
        });
        await tx.ward.create({
          data: {
            id: ward,
            provinceId: province,
            code: `hw-${tag}`,
            name: "Phường giữ chỗ",
          },
        });
        await tx.stopPointCatalog.createMany({
          data: points.map((id, index) => ({
            id,
            name: `Điểm ${index} ${tag}`,
            type:
              index === 1 ? ("REST_STOP" as const) : ("BUS_STATION" as const),
            legalBasis: index === 1 ? null : "QĐ (test)",
            address: "Địa chỉ",
            provinceId: province,
            wardId: ward,
            latitude: 10 + index,
            longitude: 106,
          })),
        });
        await tx.vehicleType.create({
          data: {
            id: vehicleType,
            code: `HV-${tag}`,
            name: "Giường",
            form: "SLEEPER",
            class: "STANDARD",
          },
        });
      });
      routeId = (
        await new RouteService(prisma, new FakeRouting()).create(
          authz,
          RouteInputSchema.parse({
            name: `Tuyến giữ chỗ ${tag}`,
            status: "ACTIVE",
            note: null,
            stops: points.map((id, index) => ({
              catalogStopPointId: id,
              stopPointId: null,
              note: null,
              allowPickup: index === 0,
              allowDropoff: index === 2,
            })),
          }),
        )
      ).id;
      await prisma.withSystem(async (tx) => {
        const fare = await tx.fare.create({
          data: { operatorId, routeId, status: "ACTIVE" },
        });
        await tx.fareRule.create({
          data: { operatorId, fareId: fare.id, price: 320_000n },
        });
      });
      const map = await new SeatMapService(prisma).create(
        authz,
        SeatMapInputSchema.parse({
          name: `Sơ đồ giữ chỗ ${tag}`,
          layout: { decks: [{ deck: 1, rows: 2, columns: 2 }] },
          seats: ["A1", "A2", "A3", "A4"].map((code, index) => ({
            code,
            deck: 1,
            row: Math.floor(index / 2) + 1,
            column: (index % 2) + 1,
            type: "BED",
          })),
        }),
      );
      vehicleId = (
        await new VehicleService(prisma, {} as never).create(
          authz,
          VehicleInputSchema.parse({
            plateNumber: `51H${10000 + Math.floor(Math.random() * 89999)}`,
            vehicleTypeId: vehicleType,
            seatMapId: map.id,
            amenityIds: [],
            status: "ACTIVE",
            description: null,
          }),
        )
      ).id;
      openTrip = await trip(new Date(Date.UTC(2031, 6, 1, 1)));
      await prisma.withSystem((tx) =>
        tx.tripSeat.updateMany({
          where: { tripId: openTrip, seatCode: "A4" },
          data: { status: "BLOCKED" },
        }),
      );
    }, 60_000);

    afterAll(async () => {
      if (!prisma) {
        return;
      }
      const keys = await redis.keys(`seat:{*}:*:hold`);
      const mine = [];
      for (const key of keys) {
        if (key.includes(openTrip)) mine.push(key);
      }
      if (mine.length > 0) await redis.del(...mine);
      await prisma.withSystem(async (tx) => {
        await tx.tripSeat.deleteMany({ where: { operatorId } });
        await tx.tripStop.deleteMany({ where: { operatorId } });
        await tx.trip.deleteMany({ where: { operatorId } });
        await tx.fareRule.deleteMany({ where: { operatorId } });
        await tx.fare.deleteMany({ where: { operatorId } });
        await tx.routeStop.deleteMany({ where: { operatorId } });
        await tx.route.deleteMany({ where: { operatorId, parentRouteId: { not: null } } });
        await tx.route.deleteMany({ where: { operatorId } });
        await tx.vehicle.deleteMany({ where: { operatorId } });
        await tx.seat.deleteMany({ where: { operatorId } });
        await tx.seatMap.deleteMany({ where: { operatorId } });
        await tx.stopPointCatalog.deleteMany({
          where: { provinceId: province },
        });
        await tx.ward.deleteMany({ where: { provinceId: province } });
        await tx.province.deleteMany({ where: { id: province } });
        await tx.vehicleType.deleteMany({ where: { id: vehicleType } });
        await tx.operatorProfile.deleteMany({ where: { id: operatorId } });
      });
      await prisma.$disconnect();
      redis.disconnect();
    });

    it("giữ 2 chỗ: giá + tổng, hạn = 10 phút theo chính sách, khóa Redis có TTL; chi tiết chuyến hiện hai chỗ đó không đặt được; bỏ giữ chỗ trả lại", async () => {
      const before = Date.now();
      const created = await holds.create(
        null,
        nextIp(),
        hold({ seatCodes: ["A1", "A2"] }),
      );
      expect(created).toMatchObject({
        tripId: openTrip,
        pickup: { sequence: 1, name: `Điểm 0 ${tag}` },
        dropoff: { sequence: 3 },
        seats: [
          { code: "A1", type: "BED", price: 320_000 },
          { code: "A2", type: "BED", price: 320_000 },
        ],
        subtotal: 640_000,
      });
      const ttl = Date.parse(created.expiresAt) - before;
      expect(ttl).toBeGreaterThan(9.9 * MINUTE);
      expect(ttl).toBeLessThanOrEqual(10 * MINUTE + 1000);
      expect(await redis.get(seatKey(openTrip, "A1"))).toBe(created.holdId);
      expect(await redis.pttl(seatKey(openTrip, "A1"))).toBeGreaterThan(
        9 * MINUTE,
      );

      const detail = await search.getTrip(openTrip);
      expect(detail.seats.map((seat) => [seat.code, seat.status])).toEqual([
        ["A1", "UNAVAILABLE"],
        ["A2", "UNAVAILABLE"],
        ["A3", "AVAILABLE"],
        ["A4", "UNAVAILABLE"],
      ]);

      expect((await holds.get(null, created.holdId)).subtotal).toBe(640_000);
      await holds.release(null, created.holdId);
      expect(await redis.get(seatKey(openTrip, "A1"))).toBeNull();
      expect(await rejectionOf(holds.get(null, created.holdId))).toMatchObject({
        status: 404,
        code: "SEAT_HOLD_EXPIRED",
      });
    });

    it("hai lần giữ đồng thời chồng chỗ: đúng một thành công, bên thua nhận SEAT_HOLD_CONFLICT và không giữ dở chỗ nào", async () => {
      const results = await Promise.allSettled([
        holds.create(null, nextIp(), hold({ seatCodes: ["A1", "A2"] })),
        holds.create(null, nextIp(), hold({ seatCodes: ["A2", "A3"] })),
      ]);
      const won = results.filter((result) => result.status === "fulfilled");
      expect(won).toHaveLength(1);
      const lost = await rejectionOf(
        Promise.reject(
          (
            results.find(
              (result) => result.status === "rejected",
            ) as PromiseRejectedResult
          ).reason,
        ),
      );
      expect(lost).toMatchObject({
        status: 409,
        code: "SEAT_HOLD_CONFLICT",
        reasons: ["A2"],
      });
      const winner = (
        won[0] as PromiseFulfilledResult<{
          holdId: string;
          seats: { code: string }[];
        }>
      ).value;
      const free = ["A1", "A3"].find(
        (code) => !winner.seats.some((seat) => seat.code === code),
      )!;
      expect(await redis.get(seatKey(openTrip, free))).toBeNull();
      await holds.release(null, winner.holdId);
    });

    it("chỗ khóa / mã lạ / điểm đón là trạm nghỉ / điểm trả trước điểm đón / chuyến nháp → lỗi đúng mã, không giữ gì", async () => {
      expect(
        await rejectionOf(
          holds.create(null, nextIp(), hold({ seatCodes: ["A4"] })),
        ),
      ).toMatchObject({
        status: 409,
        code: "SEAT_NOT_AVAILABLE",
        reasons: ["A4"],
      });
      expect(
        await rejectionOf(
          holds.create(null, nextIp(), hold({ seatCodes: ["Z9"] })),
        ),
      ).toMatchObject({ status: 422, code: "TRIP_SEAT_UNKNOWN" });
      expect(
        await rejectionOf(
          holds.create(null, nextIp(), hold({ pickupSequence: 2 })),
        ),
      ).toMatchObject({ status: 422, code: "SEAT_HOLD_STOPS_INVALID" });
      expect(
        await rejectionOf(
          holds.create(
            null,
            nextIp(),
            hold({ pickupSequence: 3, dropoffSequence: 1 }),
          ),
        ),
      ).toMatchObject({ code: "SEAT_HOLD_STOPS_INVALID" });
      const draft = await trip(new Date(Date.UTC(2031, 6, 2, 1)), "DRAFT");
      expect(
        await rejectionOf(
          holds.create(null, nextIp(), hold({ tripId: draft })),
        ),
      ).toMatchObject({ status: 404, code: "TRIP_NOT_FOUND" });
      expect(await redis.get(seatKey(openTrip, "A1"))).toBeNull();
    });

    it("giữ chỗ của hành khách: người khác / khách vãng lai không xem / bỏ được; giữ chỗ của khách vãng lai ai có holdId cũng dùng được", async () => {
      const mine = await holds.create(
        passenger("u1"),
        nextIp(),
        hold({ seatCodes: ["A3"] }),
      );
      expect(
        await rejectionOf(holds.get(passenger("u2"), mine.holdId)),
      ).toMatchObject({ code: "SEAT_HOLD_EXPIRED" });
      expect(await rejectionOf(holds.release(null, mine.holdId))).toMatchObject(
        { code: "SEAT_HOLD_EXPIRED" },
      );
      expect(
        (await holds.get(passenger("u1"), mine.holdId)).seats[0]!.code,
      ).toBe("A3");
      await holds.release(passenger("u1"), mine.holdId);
      const guest = await holds.create(
        null,
        nextIp(),
        hold({ seatCodes: ["A3"] }),
      );
      expect((await holds.get(passenger("u9"), guest.holdId)).holdId).toBe(
        guest.holdId,
      );
      await holds.release(null, guest.holdId);
    });

    it("chặng (3.3): giữ chỗ tính giá tuyến con bao trọn chặng, không có thì giá tuyến chính; điểm đón đã hết giờ bán → 422", async () => {
      const middle = randomUUID();
      await prisma.withSystem((tx) =>
        tx.stopPointCatalog.create({
          data: { id: middle, name: `Điểm giữa ${tag}`, type: "BUS_STATION", legalBasis: "QĐ (test)", address: "x", provinceId: province, wardId: ward, latitude: 10.5, longitude: 106 },
        }),
      );
      const routing = new RouteService(prisma, new FakeRouting());
      const stop = (id: string, pickup: boolean, dropoff: boolean) => ({ catalogStopPointId: id, stopPointId: null, note: null, allowPickup: pickup, allowDropoff: dropoff });
      const main = await routing.create(
        authz,
        RouteInputSchema.parse({ name: `Chặng ${tag}`, status: "ACTIVE", note: null, stops: [stop(points[0]!, true, false), stop(middle, true, true), stop(points[2]!, false, true)] }),
      );
      const point = (id: string) => ({ catalogStopPointId: id, stopPointId: null });
      const subInput = (status: string) =>
        SubRouteInputSchema.parse({ from: point(points[0]!), to: point(middle), name: "", nameSource: "AUTO", status, note: null });
      const sub = await routing.createSubRoute(authz, main.id, subInput("DRAFT"));
      await prisma.withSystem(async (tx) => {
        for (const [routeId, price] of [[main.id, 300_000n], [sub.id, 110_000n]] as const) {
          const fare = await tx.fare.create({ data: { operatorId, routeId, status: "ACTIVE" } });
          await tx.fareRule.create({ data: { operatorId, fareId: fare.id, price } });
        }
      });
      await routing.updateSubRoute(authz, main.id, sub.id, subInput("ACTIVE"));
      const created = await trips.create(
        authz,
        TripInputSchema.parse({
          routeId: main.id,
          vehicleId,
          departureAt: new Date(Date.UTC(2031, 6, 5, 1)).toISOString(),
          stopTimes: null,
          onlineSaleCutoffMinutes: 60,
          note: null,
          subRouteIds: [sub.id],
        }),
      );
      await prisma.withSystem((tx) => tx.trip.update({ where: { id: created.id }, data: { status: "OPEN_FOR_SALE" } }));

      const short = await holds.create(null, nextIp(), hold({ tripId: created.id, seatCodes: ["A1", "A2"], pickupSequence: 1, dropoffSequence: 2 }));
      expect(short.seats.map((seat) => seat.price)).toEqual([110_000, 110_000]);
      expect(short.subtotal).toBe(220_000);
      await holds.release(null, short.holdId);
      const whole = await holds.create(null, nextIp(), hold({ tripId: created.id, seatCodes: ["A1"], pickupSequence: 1, dropoffSequence: 3 }));
      expect(whole.subtotal).toBe(300_000);
      await holds.release(null, whole.holdId);

      // Điểm đầu đã qua giờ ngừng bán (khởi hành sau 30 phút, ngừng 60 phút trước) nhưng điểm giữa còn bán.
      const soon = await trips.create(
        authz,
        TripInputSchema.parse({
          routeId: main.id,
          vehicleId,
          departureAt: new Date(Math.ceil((Date.now() + 30 * MINUTE) / (5 * MINUTE)) * 5 * MINUTE).toISOString(),
          stopTimes: null,
          onlineSaleCutoffMinutes: 60,
          note: null,
        }),
      );
      await prisma.withSystem((tx) => tx.trip.update({ where: { id: soon.id }, data: { status: "OPEN_FOR_SALE" } }));
      // Trả xe cho các test sau (chuyến sắp chạy của chúng dùng cùng xe).
      const release = async () =>
        prisma.withSystem((tx) => tx.trip.update({ where: { id: soon.id }, data: { status: "CANCELLED", statusReason: "Hết test" } }));
      expect(await rejectionOf(holds.create(null, nextIp(), hold({ tripId: soon.id, pickupSequence: 1, dropoffSequence: 3 })))).toMatchObject({
        status: 422,
        code: "SEAT_HOLD_PICKUP_CLOSED",
      });
      const fromMiddle = await holds.create(null, nextIp(), hold({ tripId: soon.id, pickupSequence: 2, dropoffSequence: 3 }));
      expect(fromMiddle.subtotal).toBe(300_000);
      await holds.release(null, fromMiddle.holdId);
      await release();
    });

    it("hạn giữ không quá giờ ngừng bán online; 21 lần / 10 phút / IP → 429; Redis mất kết nối → 503", async () => {
      // Giờ chạy lưu theo mốc 5 phút (giai đoạn 3.1): lấy sẵn mốc → ngừng bán sau 5–10 phút, sớm hơn hạn giữ 10 phút.
      const departureAt = Math.ceil((Date.now() + 65 * MINUTE) / (5 * MINUTE)) * 5 * MINUTE;
      const soon = await trip(new Date(departureAt));
      const capped = await holds.create(null, nextIp(), hold({ tripId: soon }));
      expect(capped.expiresAt).toBe(new Date(departureAt - 60 * MINUTE).toISOString());
      await holds.release(null, capped.holdId);

      const ip = nextIp();
      for (let index = 0; index < 20; index++) {
        const created = await holds.create(
          null,
          ip,
          hold({ seatCodes: ["A1"] }),
        );
        await holds.release(null, created.holdId);
      }
      expect(
        await rejectionOf(holds.create(null, ip, hold({ seatCodes: ["A1"] }))),
      ).toMatchObject({ status: 429, code: "SEAT_HOLD_RATE_LIMITED" });

      const broken = new Redis("redis://127.0.0.1:6390", {
        ...createRequestRedisClientOptions("broken"),
        retryStrategy: () => null,
      });
      broken.on("error", () => undefined);
      const down = new SeatHoldService(prisma, broken);
      expect(
        await rejectionOf(
          down.create(null, undefined, hold({ seatCodes: ["A2"] })),
        ),
      ).toMatchObject({ status: 503, code: "SERVICE_UNAVAILABLE" });
      broken.disconnect();
    }, 30_000);
  },
);
