import { randomUUID } from "node:crypto";
import Redis from "ioredis";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { type AuditEventInput, AuditService, AuditWriteError } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { Coordinates, RouteLeg, RoutingProvider } from "../external/routing/routing-provider";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { createRequestRedisClientOptions, getRedisUrl } from "../redis/redis.config";
import { RouteInputSchema } from "../route/dto/route.dto";
import { RouteService } from "../route/route.service";
import { SeatHoldInputSchema } from "../seat-hold/dto/seat-hold.dto";
import { SeatHoldService } from "../seat-hold/seat-hold.service";
import { issueTickets } from "../ticket/ticket-issuer";
import { TicketQrSigner } from "../ticket/ticket-qr";
import { TripInputSchema } from "../trip/dto/trip.dto";
import { TripService } from "../trip/trip.service";
import { SeatMapInputSchema } from "../vehicle/dto/seat-map.dto";
import { VehicleInputSchema } from "../vehicle/dto/vehicle.dto";
import { SeatMapService } from "../vehicle/seat-map.service";
import { VehicleService } from "../vehicle/vehicle.service";
import { BookingService } from "./booking.service";
import { BookingInputSchema } from "./dto/booking.dto";
import { OperatorBookingService } from "./operator-booking.service";

/**
 * TASK-OPR-003 — màn Đặt vé của nhà xe trên Postgres + Redis THẬT (role app): lọc / phân trang / che liên hệ, chi tiết,
 * xem đầy đủ + xuất danh sách hành khách phải ghi audit được trước, nhà xe khác không thấy (tenant + RLS).
 */
const url = process.env.DATABASE_URL;
const ready = Boolean(url && process.env.REDIS_URL);
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
const HOUR = 3_600_000;

async function rejectionOf(promise: Promise<unknown>): Promise<{ status?: number; code?: string }> {
  try {
    await promise;
    return {};
  } catch (error) {
    const response = (error as { getResponse?: () => { code?: string } }).getResponse?.();
    return { status: (error as { getStatus?: () => number }).getStatus?.(), code: response?.code };
  }
}

class FakeRouting implements RoutingProvider {
  readonly source = "GOONG" as const;
  async measureLegs(points: Coordinates[]): Promise<RouteLeg[]> {
    return points.slice(1).map(() => ({ distanceMeters: 100_000, durationSeconds: 3 * 3600 }));
  }
}

describe.skipIf(!ready && !requireDb)("Đặt vé của nhà xe — Postgres thật (OPR-003)", () => {
  let prisma: PrismaService;
  let redis: Redis;
  let holds: SeatHoldService;
  let bookings: BookingService;
  let operatorBookings: OperatorBookingService;
  const events: AuditEventInput[] = [];
  const recordAuditEvent = vi.fn(async (event: AuditEventInput) => void events.push(event));
  const qr = new TicketQrSigner(Buffer.alloc(32, 9));
  const tag = randomUUID().slice(0, 8);
  const operatorId = randomUUID();
  const otherOperator = randomUUID();
  const province = randomUUID();
  const ward = randomUUID();
  const points = [randomUUID(), randomUUID(), randomUUID()];
  const vehicleType = randomUUID();
  const riderId = `opr-rider-${tag}`;
  const rider = { sub: riderId, role: "PASSENGER" } as VerifiedAccessToken;
  const owner = { sub: "owner-1", role: "OPERATOR_OWNER" } as VerifiedAccessToken;
  const authz: Authorization = { permission: "booking:read", scope: "tenant", db: tenantScope(operatorId) };
  const otherAuthz: Authorization = { permission: "booking:read", scope: "tenant", db: tenantScope(otherOperator) };
  const departure = new Date(Date.UTC(2031, 10, 5, 15, 30));
  const date = "2031-11-05"; // 22:30 giờ VN
  let tripId: string;
  let pending: { bookingId: string; bookingCode: string };
  let confirmed: { bookingId: string; bookingCode: string };

  async function book(seatCodes: string[], user: VerifiedAccessToken | null, contact: { fullName: string; phone: string }) {
    const hold = await holds.create(user, undefined, SeatHoldInputSchema.parse({ tripId, seatCodes, pickupSequence: 1, dropoffSequence: 3 }));
    return bookings.create(
      user,
      BookingInputSchema.parse({
        holdId: hold.holdId,
        contact: { ...contact, email: "khach@example.com" },
        passengers: seatCodes.map((seatCode, index) => ({ seatCode, fullName: `${contact.fullName} ${index + 1}`, phone: index === 0 ? "0912345678" : null })),
        note: "Đón cổng chính",
        expectedTotal: 300_000 * seatCodes.length,
      }),
    );
  }

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    redis = new Redis(getRedisUrl(), createRequestRedisClientOptions("operator-booking-test"));
    holds = new SeatHoldService(prisma, redis);
    bookings = new BookingService(prisma, holds, qr);
    operatorBookings = new OperatorBookingService(prisma, { recordAuditEvent } as unknown as AuditService);
    const tenant: Authorization = { permission: "trip:manage", scope: "tenant", db: tenantScope(operatorId) };
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.create({ data: { id: operatorId, operatorSlug: `opb-${tag}`, displayName: `Nhà xe ${tag}` } });
      await tx.operatorProfile.create({ data: { id: otherOperator, operatorSlug: `opb2-${tag}`, displayName: `Nhà xe khác ${tag}` } });
      await tx.user.create({ data: { id: riderId, email: `opr-${tag}@example.com`, name: "Khách" } });
      await tx.province.create({ data: { id: province, code: `op-${tag}`, name: "Tỉnh" } });
      await tx.ward.create({ data: { id: ward, provinceId: province, code: `ow-${tag}`, name: "Phường" } });
      await tx.stopPointCatalog.createMany({
        data: points.map((id, index) => ({
          id,
          name: `Bến ${index} ${tag}`,
          type: index === 1 ? ("REST_STOP" as const) : ("BUS_STATION" as const),
          legalBasis: index === 1 ? null : "QĐ (test)",
          address: "Địa chỉ",
          provinceId: province,
          wardId: ward,
          latitude: 10 + index,
          longitude: 106,
        })),
      });
      await tx.vehicleType.create({ data: { id: vehicleType, code: `OV-${tag}`, name: "Giường", form: "SLEEPER", class: "STANDARD" } });
    });
    const routeId = (
      await new RouteService(prisma, new FakeRouting()).create(
        tenant,
        RouteInputSchema.parse({
          name: `Sài Gòn – Đà Lạt ${tag}`,
          status: "ACTIVE",
          note: null,
          stops: points.map((id, index) => ({ catalogStopPointId: id, stopPointId: null, note: null, allowPickup: index === 0, allowDropoff: index === 2 })),
        }),
      )
    ).id;
    await prisma.withSystem(async (tx) => {
      const fare = await tx.fare.create({ data: { operatorId, routeId, status: "ACTIVE" } });
      await tx.fareRule.create({ data: { operatorId, fareId: fare.id, price: 300_000n } });
    });
    const map = await new SeatMapService(prisma).create(
      tenant,
      SeatMapInputSchema.parse({
        name: `Sơ đồ ${tag}`,
        layout: { decks: [{ deck: 1, rows: 2, columns: 2 }] },
        seats: ["A1", "A2", "A3", "A4"].map((code, index) => ({ code, deck: 1, row: Math.floor(index / 2) + 1, column: (index % 2) + 1, type: "BED" })),
      }),
    );
    const vehicleId = (
      await new VehicleService(prisma, {} as never).create(
        tenant,
        VehicleInputSchema.parse({ plateNumber: `51B${10000 + Math.floor(Math.random() * 89999)}`, vehicleTypeId: vehicleType, seatMapId: map.id, amenityIds: [], status: "ACTIVE", description: null }),
      )
    ).id;
    tripId = (
      await new TripService(prisma, {} as AuditService).create(
        tenant,
        TripInputSchema.parse({
          routeId,
          vehicleId,
          departureAt: departure.toISOString(),
          arrivalAt: new Date(departure.getTime() + 7 * HOUR).toISOString(),
          stopTimes: null,
          onlineSaleCutoffMinutes: 60,
          note: null,
        }),
      )
    ).id;
    await prisma.withSystem((tx) => tx.trip.update({ where: { id: tripId }, data: { status: "OPEN_FOR_SALE" } }));

    confirmed = await book(["A1", "A2"], rider, { fullName: "Nguyễn Văn Khách", phone: "0901234567" });
    // Thanh toán thành công (đã kiểm ở payment.int.spec) — ở đây dựng thẳng trạng thái + vé.
    await prisma.withTenant(operatorId, async (tx) => {
      await tx.booking.update({ where: { id: confirmed.bookingId }, data: { status: "CONFIRMED", paidAt: new Date(), confirmedAt: new Date() } });
      await tx.tripSeat.updateMany({ where: { bookingId: confirmed.bookingId }, data: { status: "BOOKED" } });
      await issueTickets(tx, operatorId, confirmed.bookingId, qr, new Date(), "system");
    });
    pending = await book(["A3"], null, { fullName: "Lê Thị Hoa", phone: "0987654112" });
  }, 60_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      await tx.ticketStatusHistory.deleteMany({ where: { operatorId } });
      await tx.ticket.deleteMany({ where: { operatorId } });
      await tx.tripSeat.updateMany({ where: { operatorId }, data: { bookingId: null } });
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
      await tx.stopPointCatalog.deleteMany({ where: { provinceId: province } });
      await tx.ward.deleteMany({ where: { provinceId: province } });
      await tx.province.deleteMany({ where: { id: province } });
      await tx.vehicleType.deleteMany({ where: { id: vehicleType } });
      await tx.user.deleteMany({ where: { id: riderId } });
      await tx.operatorProfile.deleteMany({ where: { id: { in: [operatorId, otherOperator] } } });
    });
    await prisma.$disconnect();
    redis.disconnect();
  });

  it("danh sách theo ngày đi (giờ VN): mới đặt trước, liên hệ đã che, chỗ / khách vãng lai / tổng; phân trang; lọc trạng thái / chuyến / tìm kiếm", async () => {
    const page = await operatorBookings.list(authz, { date, limit: 20 });
    expect(page.items.map((item) => item.bookingCode)).toEqual([pending.bookingCode, confirmed.bookingCode]);
    expect(page.items[1]).toMatchObject({
      status: "CONFIRMED",
      contactName: "Nguyễn Văn Khách",
      contactPhoneMasked: "0*** *** 567",
      guest: false,
      seatCodes: ["A1", "A2"],
      cancelledTicketCount: 0,
      total: 600_000,
      payment: null,
      trip: { tripId, routeName: `Sài Gòn – Đà Lạt ${tag}` },
    });
    expect(page.items[0]).toMatchObject({ status: "PENDING_PAYMENT", guest: true, contactPhoneMasked: "0*** *** 112" });
    expect(JSON.stringify(page)).not.toContain("0901234567");

    const first = await operatorBookings.list(authz, { date, limit: 1 });
    expect(first.items).toHaveLength(1);
    const second = await operatorBookings.list(authz, { date, limit: 1, cursor: first.nextCursor! });
    expect(second.items.map((item) => item.bookingCode)).toEqual([confirmed.bookingCode]);
    expect(second.nextCursor).toBeNull();

    const codes = async (query: Record<string, string>) =>
      (await operatorBookings.list(authz, { date, limit: 20, ...query })).items.map((item) => item.bookingCode);
    expect(await codes({ status: "CONFIRMED" })).toEqual([confirmed.bookingCode]);
    expect(await codes({ tripId })).toHaveLength(2);
    expect(await codes({ q: confirmed.bookingCode.toLowerCase() })).toEqual([confirmed.bookingCode]);
    expect(await codes({ q: `${confirmed.bookingCode.slice(0, 3)}-${confirmed.bookingCode.slice(3)}-02` })).toEqual([confirmed.bookingCode]);
    expect(await codes({ q: "654 112" })).toEqual([pending.bookingCode]);
    expect(await codes({ q: "thị hoa" })).toEqual([pending.bookingCode]);
    expect(await codes({ date: "2031-11-06" })).toEqual([]);
    // Nhà xe khác: không thấy gì.
    expect((await operatorBookings.list(otherAuthz, { date, limit: 20 })).items).toEqual([]);
  });

  it("chi tiết: chỗ + vé (đơn chờ thanh toán chưa có vé), điểm đón / trả, chính sách hủy, lịch sử theo loại người làm; khác tenant / không có → 404", async () => {
    const detail = await operatorBookings.get(authz, confirmed.bookingId);
    expect(detail).toMatchObject({
      contactEmailMasked: "k***@example.com",
      note: "Đón cổng chính",
      pickup: { sequence: 1, name: `Bến 0 ${tag}` },
      dropoff: { sequence: 3 },
      subtotal: 600_000,
      serviceFee: 0,
      discount: 0,
      seats: [
        { seatCode: "A1", passengerName: "Nguyễn Văn Khách 1", phoneMasked: "0*** *** 678", ticketCode: `${confirmed.bookingCode}-01`, ticketStatus: "VALID" },
        { seatCode: "A2", phoneMasked: null, ticketCode: `${confirmed.bookingCode}-02`, ticketStatus: "VALID" },
      ],
      histories: [{ toStatus: "PENDING_PAYMENT", actor: "PASSENGER" }],
    });
    expect((await operatorBookings.get(authz, pending.bookingId)).seats).toMatchObject([{ seatCode: "A3", ticketCode: null, ticketStatus: null }]);
    expect(await rejectionOf(operatorBookings.get(otherAuthz, confirmed.bookingId))).toMatchObject({ status: 404, code: "BOOKING_NOT_FOUND" });
    expect(await rejectionOf(operatorBookings.get(authz, randomUUID()))).toMatchObject({ status: 404 });
  });

  it("hiện đầy đủ liên hệ: ghi audit trước rồi mới trả; Mongo lỗi → 503, không trả dữ liệu", async () => {
    events.length = 0;
    expect(await operatorBookings.revealContact(owner, authz, confirmed.bookingId)).toEqual({
      fullName: "Nguyễn Văn Khách",
      phone: "0901234567",
      email: "khach@example.com",
      passengers: [
        { seatCode: "A1", phone: "0912345678" },
        { seatCode: "A2", phone: null },
      ],
    });
    expect(events).toMatchObject([{ action: "booking.contact.reveal", targetId: confirmed.bookingId, operatorId, actorId: "owner-1" }]);
    recordAuditEvent.mockRejectedValueOnce(new AuditWriteError(new Error("mongo down")));
    expect(await rejectionOf(operatorBookings.revealContact(owner, authz, confirmed.bookingId))).toMatchObject({ status: 503 });
    expect(await rejectionOf(operatorBookings.revealContact(owner, otherAuthz, confirmed.bookingId))).toMatchObject({ status: 404 });
  });

  it("hành khách theo chuyến: số liệu cả chuyến, lọc điểm đón / trạng thái vé / tìm; xuất CSV số điện thoại đầy đủ có audit; khác tenant → 404", async () => {
    await prisma.withSystem((tx) => tx.ticket.updateMany({ where: { ticketCode: `${confirmed.bookingCode}-02` }, data: { status: "CHECKED_IN", checkedInAt: new Date() } }));
    const list = await operatorBookings.passengers(authz, tripId, {});
    expect(list).toMatchObject({
      trip: { tripId, seatCount: 4 },
      summary: { sold: 2, checkedIn: 1, notBoarded: 1, noShow: 0 },
      pickups: [{ sequence: 1, name: `Bến 0 ${tag}` }],
    });
    expect(list.items.map((item) => [item.seatCode, item.phoneMasked, item.ticketStatus, item.guest])).toEqual([
      ["A1", "0*** *** 678", "VALID", false],
      ["A2", "0*** *** 567", "CHECKED_IN", false],
    ]);
    expect((await operatorBookings.passengers(authz, tripId, { ticketStatus: "CHECKED_IN" })).items.map((item) => item.seatCode)).toEqual(["A2"]);
    expect((await operatorBookings.passengers(authz, tripId, { q: "678" })).items.map((item) => item.seatCode)).toEqual(["A1"]);
    expect((await operatorBookings.passengers(authz, tripId, { pickupSequence: 3 })).items).toEqual([]);

    events.length = 0;
    const { filename, csv } = await operatorBookings.exportPassengers(owner, authz, tripId);
    expect(filename).toBe("hanh-khach-2031-11-05-22h30.csv");
    expect(csv.startsWith("﻿")).toBe(true);
    const lines = csv.slice(1).trim().split("\r\n");
    expect(lines[0]).toBe('"Chỗ","Hành khách","Số điện thoại","Điểm đón","Điểm trả","Mã vé","Trạng thái vé"');
    expect(lines[1]).toContain('"0912345678"');
    expect(lines[2]).toContain('"Đã lên xe"');
    expect(events).toMatchObject([{ action: "trip.passengers.export", targetType: "trip", targetId: tripId, after: { passengers: 2 } }]);
    recordAuditEvent.mockRejectedValueOnce(new AuditWriteError(new Error("mongo down")));
    expect(await rejectionOf(operatorBookings.exportPassengers(owner, authz, tripId))).toMatchObject({ status: 503 });
    expect(await rejectionOf(operatorBookings.passengers(otherAuthz, tripId, {}))).toMatchObject({ status: 404, code: "TRIP_NOT_FOUND" });
  });
});
