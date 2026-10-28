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
import { RouteInputSchema } from "../route/dto/route.dto";
import { RouteService } from "../route/route.service";
import { SeatHoldInputSchema } from "../seat-hold/dto/seat-hold.dto";
import { seatKey } from "../seat-hold/seat-hold-store";
import { SeatHoldService } from "../seat-hold/seat-hold.service";
import { TripInputSchema, TripStatusInputSchema } from "../trip/dto/trip.dto";
import { TripService } from "../trip/trip.service";
import { SeatMapInputSchema } from "../vehicle/dto/seat-map.dto";
import { VehicleInputSchema } from "../vehicle/dto/vehicle.dto";
import { TicketQrSigner } from "../ticket/ticket-qr";
import { SeatMapService } from "../vehicle/seat-map.service";
import { VehicleService } from "../vehicle/vehicle.service";
import { expireOverdueBookings } from "./booking-expiry";
import { BookingService } from "./booking.service";
import { BookingInputSchema } from "./dto/booking.dto";

/**
 * TASK-BTP-002 — tạo booking từ giữ chỗ trên Postgres + Redis THẬT (role app): tổng tiền BIGINT, snapshot, ghế `HOLDING`,
 * gửi lặp / đồng thời, giá đổi giữa chừng, nhà xe khóa ghế / thu hồi chuyến, hết hạn thanh toán trả ghế, RLS tenant.
 */
const url = process.env.DATABASE_URL;
const ready = Boolean(url && process.env.REDIS_URL);
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
// const HOUR = 3_600_000;

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
  "Tạo booking — Postgres + Redis thật (BTP-002)",
  () => {
    let prisma: PrismaService;
    let redis: Redis;
    let holds: SeatHoldService;
    let bookings: BookingService;
    let search: TripSearchService;
    let trips: TripService;
    const tag = randomUUID().slice(0, 8);
    const operatorId = randomUUID();
    const otherOperator = randomUUID();
    const province = randomUUID();
    const ward = randomUUID();
    const points = [randomUUID(), randomUUID(), randomUUID()];
    const vehicleType = randomUUID();
    const riderId = `rider-${tag}`;
    let routeId: string;
    let vehicleId: string;
    let fareRuleId: string;
    let day = 0;
    const rider = { sub: riderId, role: "PASSENGER" } as VerifiedAccessToken;
    const authz: Authorization = {
      permission: "trip:manage",
      scope: "tenant",
      db: tenantScope(operatorId),
    };
    const actor = { sub: "owner", role: "OPERATOR_OWNER" };

    /** Chuyến mở bán mới (mỗi lần một ngày khác — cùng xe không chồng giờ). */
    async function openTrip(status = "OPEN_FOR_SALE"): Promise<string> {
      const departureAt = new Date(Date.UTC(2031, 7, 1 + day++, 1));
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

    async function holdSeats(
      tripId: string,
      seatCodes: string[],
      user: VerifiedAccessToken | null = null,
    ) {
      return holds.create(
        user,
        undefined,
        SeatHoldInputSchema.parse({
          tripId,
          seatCodes,
          pickupSequence: 1,
          dropoffSequence: 3,
        }),
      );
    }

    function bookingInput(
      holdId: string,
      seatCodes: string[],
      expectedTotal: number,
      overrides: Record<string, unknown> = {},
    ) {
      return BookingInputSchema.parse({
        holdId,
        contact: {
          fullName: "Nguyễn Văn A",
          phone: "0901 234 567",
          email: "Khach@Example.com",
        },
        passengers: seatCodes.map((seatCode, index) => ({
          seatCode,
          fullName: `Hành khách ${index + 1}`,
          phone: null,
        })),
        note: "  Đón ở cổng chính  ",
        expectedTotal,
        ...overrides,
      });
    }

    const seatsOf = (tripId: string) =>
      prisma.withSystem((tx) =>
        tx.tripSeat.findMany({
          where: { tripId },
          orderBy: { seatCode: "asc" },
          select: { seatCode: true, status: true, bookingId: true },
        }),
      );

    beforeAll(async () => {
      prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
      redis = new Redis(
        getRedisUrl(),
        createRequestRedisClientOptions("booking-test"),
      );
      holds = new SeatHoldService(prisma, redis);
      bookings = new BookingService(
        prisma,
        holds,
        new TicketQrSigner(Buffer.alloc(32, 7)),
      );
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
            operatorSlug: `book-${tag}`,
            displayName: `Nhà xe ${tag}`,
            hotline: "19001234",
          },
        });
        await tx.operatorProfile.create({
          data: {
            id: otherOperator,
            operatorSlug: `book2-${tag}`,
            displayName: `Nhà xe khác ${tag}`,
          },
        });
        await tx.user.create({
          data: {
            id: riderId,
            email: `rider-${tag}@example.com`,
            name: `Khách ${tag}`,
          },
        });
        await tx.province.create({
          data: { id: province, code: `bp-${tag}`, name: "Tỉnh đặt vé" },
        });
        await tx.ward.create({
          data: {
            id: ward,
            provinceId: province,
            code: `bw-${tag}`,
            name: "Phường đặt vé",
          },
        });
        await tx.stopPointCatalog.createMany({
          data: points.map((id, index) => ({
            id,
            name: `Điểm ${index} ${tag}`,
            type:
              index === 1 ? ("REST_STOP" as const) : ("BUS_STATION" as const),
            legalBasis: index === 1 ? null : "QĐ (test)",
            address: `Địa chỉ ${index}`,
            provinceId: province,
            wardId: ward,
            latitude: 10 + index,
            longitude: 106,
          })),
        });
        await tx.vehicleType.create({
          data: {
            id: vehicleType,
            code: `BV-${tag}`,
            name: "Giường nằm",
            form: "SLEEPER",
            class: "STANDARD",
          },
        });
      });
      routeId = (
        await new RouteService(prisma, new FakeRouting()).create(
          authz,
          RouteInputSchema.parse({
            name: `Tuyến đặt vé ${tag}`,
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
      fareRuleId = await prisma.withSystem(async (tx) => {
        const fare = await tx.fare.create({
          data: { operatorId, routeId, status: "ACTIVE" },
        });
        return (
          await tx.fareRule.create({
            data: { operatorId, fareId: fare.id, price: 320_000n },
          })
        ).id;
      });
      const map = await new SeatMapService(prisma).create(
        authz,
        SeatMapInputSchema.parse({
          name: `Sơ đồ đặt vé ${tag}`,
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
            plateNumber: `51B${10000 + Math.floor(Math.random() * 89999)}`,
            vehicleTypeId: vehicleType,
            seatMapId: map.id,
            amenityIds: [],
            status: "ACTIVE",
            description: null,
          }),
        )
      ).id;
    }, 60_000);

    afterAll(async () => {
      if (!prisma) {
        return;
      }
      await prisma.withSystem(async (tx) => {
        await tx.tripSeat.updateMany({
          where: { operatorId },
          data: { bookingId: null },
        });
        await tx.bookingStatusHistory.deleteMany({ where: { operatorId } });
        await tx.passengerInfo.deleteMany({ where: { operatorId } });
        await tx.booking.deleteMany({ where: { operatorId } });
        await tx.tripSeat.deleteMany({ where: { operatorId } });
        await tx.tripStop.deleteMany({ where: { operatorId } });
        await tx.trip.deleteMany({ where: { operatorId } });
        await tx.fareRule.deleteMany({ where: { operatorId } });
        await tx.fare.deleteMany({ where: { operatorId } });
        await tx.routeStop.deleteMany({ where: { operatorId } });
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
        await tx.user.deleteMany({ where: { id: riderId } });
        await tx.operatorProfile.deleteMany({
          where: { id: { in: [operatorId, otherOperator] } },
        });
      });
      await prisma.$disconnect();
      redis.disconnect();
    });

    it("khách vãng lai đặt 2 chỗ: tổng BIGINT + phí 0 tách dòng, snapshot, ghế HOLDING gắn booking, trả khóa Redis; xem bằng mã truy cập", async () => {
      const tripId = await openTrip();
      const hold = await holdSeats(tripId, ["A1", "A2"]);
      const created = await bookings.create(
        null,
        bookingInput(hold.holdId, ["A1", "A2"], 640_000),
      );
      expect(created).toMatchObject({
        status: "PENDING_PAYMENT",
        tripId,
        trip: {
          routeName: `Tuyến đặt vé ${tag}`,
          operatorName: `Nhà xe ${tag}`,
          operatorHotline: "19001234",
          vehicleTypeName: "Giường nằm",
        },
        pickup: { sequence: 1, name: `Điểm 0 ${tag}`, address: "Địa chỉ 0" },
        dropoff: { sequence: 3, name: `Điểm 2 ${tag}` },
        contact: {
          fullName: "Nguyễn Văn A",
          phone: "0901234567",
          email: "khach@example.com",
        },
        passengers: [
          {
            seatCode: "A1",
            seatType: "BED",
            fullName: "Hành khách 1",
            phone: null,
            price: 320_000,
          },
          {
            seatCode: "A2",
            seatType: "BED",
            fullName: "Hành khách 2",
            phone: null,
            price: 320_000,
          },
        ],
        note: "Đón ở cổng chính",
        subtotal: 640_000,
        serviceFee: 0,
        discount: 0,
        total: 640_000,
        expiresAt: hold.expiresAt,
      });
      expect(created.bookingCode).toMatch(/^VXN[2-9A-HJ-NP-Z]{6}$/);
      expect(Array.isArray(created.cancellationPolicy.tiers)).toBe(true);
      expect(created.accessToken.length).toBeGreaterThanOrEqual(43);

      expect(await seatsOf(tripId)).toEqual([
        { seatCode: "A1", status: "HOLDING", bookingId: created.bookingId },
        { seatCode: "A2", status: "HOLDING", bookingId: created.bookingId },
        { seatCode: "A3", status: "AVAILABLE", bookingId: null },
        { seatCode: "A4", status: "AVAILABLE", bookingId: null },
      ]);
      expect(await redis.get(seatKey(tripId, "A1"))).toBeNull();
      const detail = await search.getTrip(tripId);
      expect(
        detail.seats
          .filter((seat) => seat.status === "AVAILABLE")
          .map((seat) => seat.code),
      ).toEqual(["A3", "A4"]);
      const stored = await prisma.withSystem((tx) =>
        tx.booking.findUniqueOrThrow({
          where: { id: created.bookingId },
          select: {
            total: true,
            accessTokenHash: true,
            histories: {
              select: { fromStatus: true, toStatus: true, actor: true },
            },
          },
        }),
      );
      expect(stored.total).toBe(640_000n);
      expect(stored.accessTokenHash).not.toContain(created.accessToken);
      expect(stored.histories).toEqual([
        { fromStatus: null, toStatus: "PENDING_PAYMENT", actor: "guest" },
      ]);

      expect(
        (await bookings.get(null, created.bookingId, created.accessToken))
          .bookingCode,
      ).toBe(created.bookingCode);
      expect(
        await rejectionOf(bookings.get(null, created.bookingId, undefined)),
      ).toMatchObject({ status: 404, code: "BOOKING_NOT_FOUND" });
      expect(
        await rejectionOf(bookings.get(rider, created.bookingId, "sai-ma")),
      ).toMatchObject({ status: 404, code: "BOOKING_NOT_FOUND" });
      // Giữ chỗ đã dùng → không tạo booking thứ hai.
      expect(
        await rejectionOf(
          bookings.create(
            null,
            bookingInput(hold.holdId, ["A1", "A2"], 640_000),
          ),
        ),
      ).toMatchObject({ status: 404, code: "SEAT_HOLD_EXPIRED" });
    });

    it("gửi đồng thời hai lần cùng giữ chỗ: đúng một booking, lần kia 409 / 404 — không có booking thứ hai", async () => {
      const tripId = await openTrip();
      const hold = await holdSeats(tripId, ["A3"]);
      const results = await Promise.allSettled([
        bookings.create(null, bookingInput(hold.holdId, ["A3"], 320_000)),
        bookings.create(null, bookingInput(hold.holdId, ["A3"], 320_000)),
      ]);
      expect(
        results.filter((result) => result.status === "fulfilled"),
      ).toHaveLength(1);
      const lost = await rejectionOf(
        Promise.reject(
          (
            results.find(
              (result) => result.status === "rejected",
            ) as PromiseRejectedResult
          ).reason,
        ),
      );
      expect(["BOOKING_ALREADY_CREATED", "SEAT_HOLD_EXPIRED"]).toContain(
        lost.code,
      );
      expect(
        await prisma.withSystem((tx) =>
          tx.booking.count({ where: { holdId: hold.holdId } }),
        ),
      ).toBe(1);
    });

    it("giá vừa đổi sau khi giữ chỗ → 409 BOOKING_SNAPSHOT_CHANGED kèm tổng mới, không ghi gì, giữ chỗ còn nguyên; gửi lại đúng tổng thì được", async () => {
      const tripId = await openTrip();
      const hold = await holdSeats(tripId, ["A1"]);
      await prisma.withSystem((tx) =>
        tx.fareRule.update({
          where: { id: fareRuleId },
          data: { price: 350_000n },
        }),
      );
      try {
        expect(
          await rejectionOf(
            bookings.create(null, bookingInput(hold.holdId, ["A1"], 320_000)),
          ),
        ).toMatchObject({
          status: 409,
          code: "BOOKING_SNAPSHOT_CHANGED",
          reasons: ["350000"],
        });
        expect(
          await prisma.withSystem((tx) =>
            tx.booking.count({ where: { holdId: hold.holdId } }),
          ),
        ).toBe(0);
        expect(await redis.get(seatKey(tripId, "A1"))).toBe(hold.holdId);
        const created = await bookings.create(
          null,
          bookingInput(hold.holdId, ["A1"], 350_000),
        );
        expect(created.total).toBe(350_000);
      } finally {
        await prisma.withSystem((tx) =>
          tx.fareRule.update({
            where: { id: fareRuleId },
            data: { price: 320_000n },
          }),
        );
      }
    });

    it("hành khách khai thiếu / sai chỗ → 422; nhà xe khóa ghế sau khi giữ → 409 SEAT_NOT_AVAILABLE; chuyến thu hồi → 409 TRIP_NOT_ON_SALE", async () => {
      const tripId = await openTrip();
      const hold = await holdSeats(tripId, ["A1", "A2"]);
      expect(
        await rejectionOf(
          bookings.create(null, bookingInput(hold.holdId, ["A1"], 320_000)),
        ),
      ).toMatchObject({ status: 422, code: "BOOKING_PASSENGERS_MISMATCH" });
      expect(
        await rejectionOf(
          bookings.create(
            null,
            bookingInput(hold.holdId, ["A1", "A3"], 640_000),
          ),
        ),
      ).toMatchObject({ code: "BOOKING_PASSENGERS_MISMATCH" });

      await prisma.withSystem((tx) =>
        tx.tripSeat.updateMany({
          where: { tripId, seatCode: "A2" },
          data: { status: "BLOCKED" },
        }),
      );
      expect(
        await rejectionOf(
          bookings.create(
            null,
            bookingInput(hold.holdId, ["A1", "A2"], 640_000),
          ),
        ),
      ).toMatchObject({
        status: 409,
        code: "SEAT_NOT_AVAILABLE",
        reasons: ["A2"],
      });
      await prisma.withSystem((tx) =>
        tx.tripSeat.updateMany({
          where: { tripId, seatCode: "A2" },
          data: { status: "AVAILABLE" },
        }),
      );

      await prisma.withSystem((tx) =>
        tx.trip.update({ where: { id: tripId }, data: { status: "DRAFT" } }),
      );
      expect(
        await rejectionOf(
          bookings.create(
            null,
            bookingInput(hold.holdId, ["A1", "A2"], 640_000),
          ),
        ),
      ).toMatchObject({ status: 409, code: "TRIP_NOT_ON_SALE" });
      expect(
        await prisma.withSystem((tx) =>
          tx.tripSeat.count({ where: { tripId, status: "HOLDING" } }),
        ),
      ).toBe(0);
    });

    it("chỗ đôi có người đi cùng (BR-78 bổ sung, chờ duyệt): lưu + trả trên đơn; khai cho chỗ thường → 422, không ghi gì; DB chặn ghi thẳng", async () => {
      const tripId = await openTrip();
      await prisma.withSystem((tx) => tx.tripSeat.updateMany({ where: { tripId, seatCode: "A3" }, data: { type: "BED_DOUBLE" } }));
      const hold = await holdSeats(tripId, ["A2", "A3"]);
      const passengers = (companionOfA2: string | null) => [
        { seatCode: "A2", fullName: "Người A2", phone: null, companionName: companionOfA2 },
        { seatCode: "A3", fullName: "Người A3", phone: null, companionName: "  Người đi cùng A3  " },
      ];
      expect(await rejectionOf(bookings.create(null, bookingInput(hold.holdId, [], 640_000, { passengers: passengers("Không được") })))).toMatchObject({
        status: 422,
        code: "BOOKING_COMPANION_NOT_ALLOWED",
        reasons: ["A2"],
      });
      expect(await prisma.withSystem((tx) => tx.booking.count({ where: { holdId: hold.holdId } }))).toBe(0);

      const created = await bookings.create(null, bookingInput(hold.holdId, [], 640_000, { passengers: passengers("") }));
      expect(created.passengers.map((passenger) => [passenger.seatCode, passenger.seatType, passenger.companionName])).toEqual([
        ["A2", "BED", null],
        ["A3", "BED_DOUBLE", "Người đi cùng A3"],
      ]);
      await expect(
        prisma.withSystem((tx) => tx.passengerInfo.updateMany({ where: { bookingId: created.bookingId, seatCode: "A2" }, data: { companionName: "Lách luật" } })),
      ).rejects.toThrow();
    });

    it("booking của hành khách: chỉ chính họ xem; nhà xe không hủy / thu hồi được chuyến khi còn khách đang thanh toán", async () => {
      const tripId = await openTrip();
      const hold = await holdSeats(tripId, ["A4"], rider);
      const created = await bookings.create(
        rider,
        bookingInput(hold.holdId, ["A4"], 320_000),
      );
      expect(
        (await bookings.get(rider, created.bookingId, undefined)).bookingId,
      ).toBe(created.bookingId);
      expect(
        await rejectionOf(
          bookings.get(
            { sub: "u-khac", role: "PASSENGER" } as VerifiedAccessToken,
            created.bookingId,
            undefined,
          ),
        ),
      ).toMatchObject({ code: "BOOKING_NOT_FOUND" });
      expect(
        await rejectionOf(
          bookings.get(null, created.bookingId, created.accessToken),
        ),
      ).toMatchObject({ code: "BOOKING_NOT_FOUND" });
      expect(
        await prisma.withSystem((tx) =>
          tx.bookingStatusHistory.findFirstOrThrow({
            where: { bookingId: created.bookingId },
            select: { actor: true },
          }),
        ),
      ).toEqual({ actor: `user:${riderId}` });

      expect(
        await rejectionOf(
          trips.changeStatus(
            actor,
            authz,
            tripId,
            TripStatusInputSchema.parse({
              status: "CANCELLED",
              reason: "Hỏng xe",
            }),
          ),
        ),
      ).toMatchObject({
        status: 409,
      });
      // RLS: tenant khác không thấy booking / hành khách của nhà xe này.
      expect(
        await prisma.withTenant(otherOperator, (tx) =>
          tx.booking.count({ where: { id: created.bookingId } }),
        ),
      ).toBe(0);
      expect(
        await prisma.withTenant(otherOperator, (tx) =>
          tx.passengerInfo.count({ where: { bookingId: created.bookingId } }),
        ),
      ).toBe(0);
      expect(
        await prisma.withTenant(operatorId, (tx) =>
          tx.passengerInfo.count({ where: { bookingId: created.bookingId } }),
        ),
      ).toBe(1);
    });

    it("quá hạn thanh toán: job chuyển EXPIRED + trả ghế + ghi lịch sử, chạy lại không đổi gì; xem booking quá hạn job chưa quét → EXPIRED ngay", async () => {
      const tripId = await openTrip();
      const first = await bookings.create(
        null,
        bookingInput((await holdSeats(tripId, ["A1"])).holdId, ["A1"], 320_000),
      );
      const second = await bookings.create(
        null,
        bookingInput((await holdSeats(tripId, ["A2"])).holdId, ["A2"], 320_000),
      );
      const past = new Date(Date.now() - 1000);
      await prisma.withSystem((tx) =>
        tx.booking.updateMany({
          where: { id: { in: [first.bookingId, second.bookingId] } },
          data: { expiresAt: past },
        }),
      );

      expect(
        (await bookings.get(null, second.bookingId, second.accessToken)).status,
      ).toBe("EXPIRED");
      expect(await expireOverdueBookings(prisma)).toBeGreaterThanOrEqual(1);
      const rows = await prisma.withSystem((tx) =>
        tx.booking.findMany({
          where: { id: { in: [first.bookingId, second.bookingId] } },
          select: {
            status: true,
            histories: {
              orderBy: { createdAt: "asc" },
              select: { toStatus: true, actor: true },
            },
          },
        }),
      );
      expect(rows.map((row) => row.status)).toEqual(["EXPIRED", "EXPIRED"]);
      for (const row of rows) {
        expect(row.histories).toEqual([
          { toStatus: "PENDING_PAYMENT", actor: "guest" },
          { toStatus: "EXPIRED", actor: "system" },
        ]);
      }
      expect(
        (await seatsOf(tripId)).filter(
          (seat) => seat.status !== "AVAILABLE" || seat.bookingId,
        ),
      ).toEqual([]);
      expect(
        await prisma.withSystem((tx) =>
          tx.booking.count({
            where: {
              id: { in: [first.bookingId, second.bookingId] },
              status: "PENDING_PAYMENT",
            },
          }),
        ),
      ).toBe(0);
      // Ghế đã trả → giữ + đặt lại được.
      const again = await holdSeats(tripId, ["A1"]);
      expect(
        (
          await bookings.create(
            null,
            bookingInput(again.holdId, ["A1"], 320_000),
          )
        ).status,
      ).toBe("PENDING_PAYMENT");
    });
  },
);
