import { randomUUID } from "node:crypto";
import Redis from "ioredis";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { type AuditEventInput, AuditService } from "../audit/audit.service";
import { BookingService } from "../booking/booking.service";
import { BookingInputSchema } from "../booking/dto/booking.dto";
import { parseAppConfig } from "../config/env.config";
import { tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { Coordinates, RouteLeg, RoutingProvider } from "../external/routing/routing-provider";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { applyPaymentCallback } from "../payment/payment-callback";
import { OperatorFinanceService } from "../payout/operator-finance.service";
import { createRequestRedisClientOptions, getRedisUrl } from "../redis/redis.config";
import { RouteInputSchema } from "../route/dto/route.dto";
import { RouteService } from "../route/route.service";
import { SeatHoldInputSchema } from "../seat-hold/dto/seat-hold.dto";
import { SeatHoldService } from "../seat-hold/seat-hold.service";
import { TicketQrSigner } from "../ticket/ticket-qr";
import { TripInputSchema } from "../trip/dto/trip.dto";
import { TripService } from "../trip/trip.service";
import { SeatMapInputSchema } from "../vehicle/dto/seat-map.dto";
import { VehicleInputSchema } from "../vehicle/dto/vehicle.dto";
import { SeatMapService } from "../vehicle/seat-map.service";
import { VehicleService } from "../vehicle/vehicle.service";
import { EmployeeOperationsService } from "./employee-operations.service";

/**
 * TASK-EMP-002 (phần backend) trên Postgres + Redis THẬT (role app): chuyến được phân công, danh sách khách, soát vé bằng QR /
 * mã vé (sai chuyến / chưa phân công / không có), check-in có điều kiện (hai máy quét cùng vé chỉ một lần), vắng mặt, tài xế
 * đổi trạng thái theo thứ tự, hoàn thành chuyến → vé đã dùng / vắng mặt + mốc chi trả theo giờ hoàn thành thực tế (BR-32).
 */
const url = process.env.DATABASE_URL;
const ready = Boolean(url && process.env.REDIS_URL);
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
const HOUR = 3_600_000;
const DAY = 24 * HOUR;

async function rejectionOf(promise: Promise<unknown>): Promise<{ status?: number; code?: string; detail?: string }> {
  try {
    await promise;
    return {};
  } catch (error) {
    const response = (error as { getResponse?: () => { code?: string; detail?: string } }).getResponse?.();
    return { status: (error as { getStatus?: () => number }).getStatus?.(), code: response?.code, detail: response?.detail };
  }
}

class FakeRouting implements RoutingProvider {
  readonly source = "GOONG" as const;
  async measureLegs(points: Coordinates[]): Promise<RouteLeg[]> {
    return points.slice(1).map(() => ({ distanceMeters: 100_000, durationSeconds: 3 * 3600 }));
  }
}

describe.skipIf(!ready && !requireDb)("Soát vé + vận hành chuyến của nhân viên — Postgres + Redis thật (EMP-002)", () => {
  let prisma: PrismaService;
  let redis: Redis;
  let holds: SeatHoldService;
  let bookings: BookingService;
  let trips: TripService;
  let operations: EmployeeOperationsService;
  const events: AuditEventInput[] = [];
  const recordAuditEvent = vi.fn(async (event: AuditEventInput) => void events.push(event));
  const qr = new TicketQrSigner(Buffer.alloc(32, 8));
  const tag = randomUUID().slice(0, 8);
  const operatorId = randomUUID();
  const province = randomUUID();
  const ward = randomUUID();
  const points = [randomUUID(), randomUUID(), randomUUID()];
  const vehicleType = randomUUID();
  const driverId = randomUUID();
  const staffId = randomUUID();
  const driver = { sub: driverId, role: "DRIVER" } as VerifiedAccessToken;
  const staff = { sub: staffId, role: "TICKET_STAFF" } as VerifiedAccessToken;
  const authz: Authorization = { permission: "checkin:perform", scope: "assigned", db: tenantScope(operatorId) };
  const ownerAuthz: Authorization = { permission: "trip:manage", scope: "tenant", db: tenantScope(operatorId) };
  let routeId: string;
  let seatMapId: string;

  /** Chuyến mở bán sau `hoursAhead` giờ, tài xế được phân công, một đơn 2 chỗ đã thanh toán (callback thật → vé + sổ). */
  async function assignedTrip(hoursAhead = 48) {
    const vehicle = await new VehicleService(prisma, {} as never).create(
      ownerAuthz,
      VehicleInputSchema.parse({ plateNumber: `51D${10000 + Math.floor(Math.random() * 89999)}`, vehicleTypeId: vehicleType, seatMapId, amenityIds: [], status: "ACTIVE", description: null }),
    );
    const departureAt = new Date(Date.now() + hoursAhead * HOUR);
    const trip = await trips.create(
      ownerAuthz,
      TripInputSchema.parse({ routeId, vehicleId: vehicle.id, departureAt: departureAt.toISOString(), arrivalAt: new Date(departureAt.getTime() + 6 * HOUR).toISOString(), stopTimes: null, onlineSaleCutoffMinutes: 60, note: null }),
    );
    await prisma.withSystem(async (tx) => {
      await tx.trip.update({ where: { id: trip.id }, data: { status: "OPEN_FOR_SALE" } });
      await tx.employeeAssignment.create({ data: { operatorId, tripId: trip.id, employeeId: driverId, role: "DRIVER" } });
    });
    const hold = await holds.create(null, undefined, SeatHoldInputSchema.parse({ tripId: trip.id, seatCodes: ["A1", "A2"], pickupSequence: 1, dropoffSequence: 3 }));
    const created = await bookings.create(
      null,
      BookingInputSchema.parse({
        holdId: hold.holdId,
        contact: { fullName: "Khách", phone: "0901234567", email: "k@example.com" },
        passengers: ["A1", "A2"].map((seatCode) => ({ seatCode, fullName: `Khách ${seatCode}`, phone: null })),
        note: null,
        expectedTotal: 600_000,
      }),
    );
    const paymentCode = `PAY${randomUUID().replace(/-/g, "").slice(0, 12).toUpperCase()}`;
    await prisma.withTenant(operatorId, (tx) =>
      tx.payment.create({ data: { paymentCode, operatorId, bookingId: created.bookingId, provider: "VNPAY", status: "PROCESSING", amount: 600_000n, expiresAt: new Date(Date.now() + 600_000) } }),
    );
    expect(await applyPaymentCallback(prisma, { provider: "VNPAY", paymentCode, providerTxnId: `T${randomUUID().slice(0, 10)}`, amount: "600000", success: true, resultCode: "00", fields: {} }, qr)).toBe("SUCCESS");
    const tickets = await prisma.withSystem((tx) => tx.ticket.findMany({ where: { bookingId: created.bookingId }, orderBy: { ticketCode: "asc" }, select: { id: true, ticketCode: true } }));
    return { tripId: trip.id, bookingId: created.bookingId, tickets };
  }

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    redis = new Redis(getRedisUrl(), createRequestRedisClientOptions("employee-ops-test"));
    holds = new SeatHoldService(prisma, redis);
    bookings = new BookingService(prisma, holds, qr);
    trips = new TripService(prisma, {} as AuditService);
    operations = new EmployeeOperationsService(prisma, { recordAuditEvent } as unknown as AuditService);
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.create({ data: { id: operatorId, operatorSlug: `eo-${tag}`, displayName: `Nhà xe ${tag}` } });
      await tx.employeeAccount.createMany({
        data: [
          { id: driverId, operatorId, username: `nv.tai-${tag}`, passwordHash: "x", role: "DRIVER" },
          { id: staffId, operatorId, username: `nv.ve-${tag}`, passwordHash: "x", role: "TICKET_STAFF" },
        ],
      });
      await tx.province.create({ data: { id: province, code: `ep-${tag}`, name: "Tỉnh" } });
      await tx.ward.create({ data: { id: ward, provinceId: province, code: `ew-${tag}`, name: "Phường" } });
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
      await tx.vehicleType.create({ data: { id: vehicleType, code: `EO-${tag}`, name: "Giường", form: "SLEEPER", class: "STANDARD" } });
    });
    routeId = (
      await new RouteService(prisma, new FakeRouting()).create(
        ownerAuthz,
        RouteInputSchema.parse({
          name: `Tuyến soát vé ${tag}`,
          status: "ACTIVE",
          note: null,
          stops: points.map((point, index) => ({ catalogStopPointId: point, stopPointId: null, note: null, allowPickup: index === 0, allowDropoff: index === 2 })),
        }),
      )
    ).id;
    await prisma.withSystem(async (tx) => {
      const fare = await tx.fare.create({ data: { operatorId, routeId, status: "ACTIVE" } });
      await tx.fareRule.create({ data: { operatorId, fareId: fare.id, price: 300_000n } });
    });
    seatMapId = (
      await new SeatMapService(prisma).create(
        ownerAuthz,
        SeatMapInputSchema.parse({
          name: `Sơ đồ ${tag}`,
          layout: { decks: [{ deck: 1, rows: 2, columns: 2 }] },
          seats: ["A1", "A2", "A3", "A4"].map((code, index) => ({ code, deck: 1, row: Math.floor(index / 2) + 1, column: (index % 2) + 1, type: "BED" })),
        }),
      )
    ).id;
  }, 60_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      await tx.$executeRaw`SELECT set_config('app.allow_ledger_delete', 'on', true)`;
      await tx.notificationDelivery.deleteMany({ where: { operatorId } });
      await tx.notification.deleteMany({ where: { operatorId } });
      // Job tạo kỳ chi trả của suite khác (chạy song song) có thể đã gom bút toán của nhà xe này.
      await tx.payoutItem.deleteMany({ where: { operatorId } });
      await tx.escrowLedger.deleteMany({ where: { operatorId } });
      await tx.payoutStatusHistory.deleteMany({ where: { operatorId } });
      await tx.payout.deleteMany({ where: { operatorId } });
      await tx.ticketStatusHistory.deleteMany({ where: { operatorId } });
      await tx.ticket.deleteMany({ where: { operatorId } });
      await tx.paymentStatusHistory.deleteMany({ where: { operatorId } });
      await tx.payment.deleteMany({ where: { operatorId } });
      await tx.tripSeat.updateMany({ where: { operatorId }, data: { bookingId: null } });
      await tx.bookingStatusHistory.deleteMany({ where: { operatorId } });
      await tx.passengerInfo.deleteMany({ where: { operatorId } });
      await tx.booking.deleteMany({ where: { operatorId } });
      await tx.employeeAssignment.deleteMany({ where: { operatorId } });
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
      await tx.employeeAccount.deleteMany({ where: { operatorId } });
      await tx.stopPointCatalog.deleteMany({ where: { provinceId: province } });
      await tx.ward.deleteMany({ where: { provinceId: province } });
      await tx.province.deleteMany({ where: { id: province } });
      await tx.vehicleType.deleteMany({ where: { id: vehicleType } });
      await tx.operatorProfile.deleteMany({ where: { id: operatorId } });
    });
    await prisma.$disconnect();
    redis.disconnect();
  });

  it("chuyến được phân công + danh sách khách (số điện thoại che); soát vé bằng QR / mã vé; sai chuyến; chưa phân công / không có vé → 404", async () => {
    const first = await assignedTrip(24);
    const second = await assignedTrip(72);
    const list = await operations.assignments(authz, driver, {});
    expect(list.items.map((item) => item.tripId)).toEqual([first.tripId, second.tripId]);
    expect(list.items[0]).toMatchObject({ role: "DRIVER", status: "OPEN_FOR_SALE", ticketCount: 2, checkedInCount: 0, origin: `Bến 0 ${tag}`, destination: `Bến 2 ${tag}` });
    expect((await operations.assignments(authz, staff, {})).items).toEqual([]);

    const manifest = await operations.manifest(authz, driver, first.tripId);
    expect(manifest.passengers.map((passenger) => [passenger.seatCode, passenger.phoneMasked, passenger.pickup.name, passenger.status])).toEqual([
      ["A1", "0*** *** 567", `Bến 0 ${tag}`, "VALID"],
      ["A2", "0*** *** 567", `Bến 0 ${tag}`, "VALID"],
    ]);
    expect(await rejectionOf(operations.manifest(authz, staff, first.tripId))).toMatchObject({ status: 404, code: "ASSIGNMENT_NOT_FOUND" });

    const byQr = await operations.verify(authz, driver, { tripId: first.tripId, code: qr.token(first.tickets[0]!.id) });
    expect(byQr).toMatchObject({ result: "OK", ticket: { seatCode: "A1", passengerName: "Khách A1" } });
    expect((await operations.verify(authz, driver, { tripId: first.tripId, code: first.tickets[1]!.ticketCode.toLowerCase() })).result).toBe("OK");
    const wrong = await operations.verify(authz, driver, { tripId: first.tripId, code: qr.token(second.tickets[0]!.id) });
    expect(wrong).toMatchObject({ result: "WRONG_TRIP", ticket: null, ticketCode: second.tickets[0]!.ticketCode });
    expect(await rejectionOf(operations.verify(authz, driver, { tripId: first.tripId, code: qr.token(randomUUID()) }))).toMatchObject({ status: 404, code: "TICKET_NOT_FOUND" });
  }, 30_000);

  it("check-in: vé → đã lên xe (ghế, lịch sử ghi nhân viên); quét lại → 409; hai máy quét cùng vé chỉ một lần; vé sai chuyến → 409; vắng mặt trước khi đón → 409", async () => {
    const trip = await assignedTrip(30);
    const other = await assignedTrip(80);
    const done = await operations.checkIn(authz, driver, { tripId: trip.tripId, code: qr.token(trip.tickets[0]!.id), status: "CHECKED_IN" });
    expect(done).toMatchObject({ ticket: { status: "CHECKED_IN" }, checkedInCount: 1, ticketCount: 2 });
    expect(done.ticket.checkedInAt).not.toBeNull();
    const state = await prisma.withSystem(async (tx) => ({
      seat: await tx.tripSeat.findFirstOrThrow({ where: { tripId: trip.tripId, seatCode: "A1" }, select: { status: true } }),
      history: await tx.ticketStatusHistory.findMany({ where: { ticketId: trip.tickets[0]!.id }, orderBy: { createdAt: "asc" }, select: { toStatus: true, actor: true } }),
    }));
    expect(state.seat.status).toBe("CHECKED_IN");
    expect(state.history.at(-1)).toEqual({ toStatus: "CHECKED_IN", actor: `employee:${driverId}` });
    expect(await rejectionOf(operations.checkIn(authz, driver, { tripId: trip.tripId, code: trip.tickets[0]!.ticketCode, status: "CHECKED_IN" }))).toMatchObject({ status: 409, detail: "Vé đã check-in trước đó." });

    const results = await Promise.allSettled([
      operations.checkIn(authz, driver, { tripId: trip.tripId, code: trip.tickets[1]!.ticketCode, status: "CHECKED_IN" }),
      operations.checkIn(authz, driver, { tripId: trip.tripId, code: qr.token(trip.tickets[1]!.id), status: "CHECKED_IN" }),
    ]);
    expect(results.filter((result) => result.status === "fulfilled")).toHaveLength(1);
    expect(await prisma.withSystem((tx) => tx.ticketStatusHistory.count({ where: { ticketId: trip.tickets[1]!.id, toStatus: "CHECKED_IN" } }))).toBe(1);

    expect(await rejectionOf(operations.checkIn(authz, driver, { tripId: trip.tripId, code: other.tickets[0]!.ticketCode, status: "CHECKED_IN" }))).toMatchObject({ status: 409, detail: "Vé thuộc chuyến khác." });
    expect(await rejectionOf(operations.checkIn(authz, driver, { tripId: other.tripId, code: other.tickets[0]!.ticketCode, status: "NO_SHOW" }))).toMatchObject({ status: 409, code: "CHECK_IN_REJECTED" });
  }, 30_000);

  it("vắng mặt chỉ sau cửa sổ đón tại đúng điểm của hành khách", async () => {
    const trip = await assignedTrip(44);
    await operations.operate(authz, driver, trip.tripId, { status: "BOARDING", note: null });
    const start = new Date(Date.now() - HOUR).toISOString();
    const futureEnd = new Date(Date.now() + HOUR).toISOString();
    await trips.setPickupWindow(ownerAuthz, trip.tripId, 1, { start, end: futureEnd });
    const manifest = await operations.manifest(authz, driver, trip.tripId);
    expect(manifest.passengers[0]!.pickup.pickupWindowEnd).toBe(futureEnd);
    expect(await rejectionOf(operations.checkIn(authz, driver, { tripId: trip.tripId, code: trip.tickets[0]!.ticketCode, status: "NO_SHOW" }))).toMatchObject({ status: 409, code: "CHECK_IN_REJECTED", detail: "Chưa hết cửa sổ đón tại điểm của hành khách." });
    await trips.setPickupWindow(ownerAuthz, trip.tripId, 1, { start, end: new Date(Date.now() - 60_000).toISOString() });
    expect((await operations.checkIn(authz, driver, { tripId: trip.tripId, code: trip.tickets[0]!.ticketCode, status: "NO_SHOW" })).ticket.status).toBe("NO_SHOW");
  }, 30_000);

  it("tài xế đổi trạng thái theo thứ tự; nhân viên vé không đổi được; hoàn thành → vé đã dùng / vắng mặt, mốc chi trả theo giờ hoàn thành; hết soát vé sau hoàn thành", async () => {
    const trip = await assignedTrip(36);
    await prisma.withSystem((tx) => tx.employeeAssignment.create({ data: { operatorId, tripId: trip.tripId, employeeId: staffId, role: "TICKET_STAFF" } }));
    expect(await rejectionOf(operations.operate(authz, staff, trip.tripId, { status: "BOARDING", note: null }))).toMatchObject({ status: 404, code: "ASSIGNMENT_NOT_FOUND" });
    expect(await rejectionOf(operations.operate(authz, driver, trip.tripId, { status: "COMPLETED", note: null }))).toMatchObject({ status: 409, code: "TRIP_OPERATION_INVALID" });

    expect((await operations.operate(authz, driver, trip.tripId, { status: "BOARDING", note: "Bắt đầu đón" })).status).toBe("BOARDING");
    expect(events.at(-1)).toMatchObject({ action: "trip.operation_status", targetId: trip.tripId, before: { status: "OPEN_FOR_SALE" }, after: { status: "BOARDING" }, reason: "Bắt đầu đón" });
    await operations.checkIn(authz, staff, { tripId: trip.tripId, code: trip.tickets[0]!.ticketCode, status: "CHECKED_IN" });
    await operations.operate(authz, driver, trip.tripId, { status: "DEPARTED", note: null });
    expect(await rejectionOf(operations.operate(authz, driver, trip.tripId, { status: "BOARDING", note: null }))).toMatchObject({ status: 409 });
    const before = Date.now();
    const completed = await operations.operate(authz, driver, trip.tripId, { status: "COMPLETED", note: null });
    expect(completed).toMatchObject({ status: "COMPLETED", checkedInCount: 1, ticketCount: 2 });
    const row = await prisma.withSystem(async (tx) => ({
      trip: await tx.trip.findUniqueOrThrow({ where: { id: trip.tripId }, select: { departedAt: true, completedAt: true, payoutEligibleAt: true } }),
      tickets: await tx.ticket.findMany({ where: { bookingId: trip.bookingId }, orderBy: { ticketCode: "asc" }, select: { status: true } }),
    }));
    expect(row.trip.departedAt).not.toBeNull();
    expect(row.trip.completedAt!.getTime()).toBeGreaterThanOrEqual(before);
    expect(row.trip.payoutEligibleAt!.getTime() - row.trip.completedAt!.getTime()).toBeGreaterThanOrEqual(DAY);
    expect(row.tickets).toEqual([{ status: "USED" }, { status: "NO_SHOW" }]);
    expect(await rejectionOf(operations.checkIn(authz, staff, { tripId: trip.tripId, code: trip.tickets[1]!.ticketCode, status: "CHECKED_IN" }))).toMatchObject({ status: 409, code: "CHECK_IN_CLOSED" });

    // BR-32: mốc chi trả theo giờ hoàn thành thực tế — đưa mốc về quá khứ thì tiền của chuyến đủ điều kiện ngay (mốc dự kiến
    // trên sổ vẫn ở tương lai vì chuyến được lên lịch sau 36 giờ).
    const finance = new OperatorFinanceService(prisma);
    const financeAuthz: Authorization = { permission: "finance:read", scope: "tenant", db: tenantScope(operatorId) };
    const eligibleBefore = (await finance.summary(financeAuthz)).eligibleAmount;
    await prisma.withSystem((tx) => tx.trip.update({ where: { id: trip.tripId }, data: { payoutEligibleAt: new Date(Date.now() - HOUR) } }));
    expect((await finance.summary(financeAuthz)).eligibleAmount - eligibleBefore).toBe(600_000 - (await commissionOf(trip.bookingId)));
  }, 30_000);

  /** Hoa hồng đã ghi sổ của booking (mức mặc định đang có trong DB) — dương. */
  async function commissionOf(bookingId: string): Promise<number> {
    const rows = await prisma.withSystem((tx) => tx.escrowLedger.findMany({ where: { bookingId, entryType: "COMMISSION" }, select: { amount: true } }));
    return Number(-rows.reduce((sum, row) => sum + row.amount, 0n));
  }
});
