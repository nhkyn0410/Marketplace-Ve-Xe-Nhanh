import { randomUUID } from "node:crypto";
import Redis from "ioredis";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { type AuditEventInput, AuditService, AuditWriteError } from "../audit/audit.service";
import { BookingService } from "../booking/booking.service";
import { BookingInputSchema } from "../booking/dto/booking.dto";
import { EmployeeOperationsService } from "../check-in/employee-operations.service";
import { parseAppConfig } from "../config/env.config";
import { platformScope, tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { Coordinates, RouteLeg, RoutingProvider } from "../external/routing/routing-provider";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { applyPaymentCallback } from "../payment/payment-callback";
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
import { ReportingService } from "./reporting.service";

/**
 * TASK-RPT-001 / 002 trên Postgres + Redis THẬT (role app): báo cáo nhà xe theo kỳ (tuyến, xe, nhân viên soát vé), cô lập tenant,
 * xuất CSV có audit (ghi audit lỗi → 503, không xuất), tổng quan nhà xe; báo cáo + tổng quan Admin lọc theo nhà xe / cổng
 * (GMV, doanh thu sau hoàn, phương thức thanh toán, GMV theo ngày).
 */
const url = process.env.DATABASE_URL;
const ready = Boolean(url && process.env.REDIS_URL);
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
const HOUR = 3_600_000;
const DAY = 24 * HOUR;

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

/** Ngày theo giờ VN. */
function vnDate(at: Date): string {
  return new Date(at.getTime() + 7 * HOUR).toISOString().slice(0, 10);
}

describe.skipIf(!ready && !requireDb)("Báo cáo nhà xe + Admin — Postgres + Redis thật (RPT-001/002)", () => {
  let prisma: PrismaService;
  let redis: Redis;
  let holds: SeatHoldService;
  let bookings: BookingService;
  let trips: TripService;
  let reports: ReportingService;
  const events: AuditEventInput[] = [];
  const recordAuditEvent = vi.fn(async (event: AuditEventInput) => void events.push(event));
  const qr = new TicketQrSigner(Buffer.alloc(32, 9));
  const tag = randomUUID().slice(0, 8);
  const operatorId = randomUUID();
  const province = randomUUID();
  const ward = randomUUID();
  const points = [randomUUID(), randomUUID(), randomUUID()];
  const vehicleType = randomUUID();
  const driverId = randomUUID();
  const owner = { sub: randomUUID(), role: "OPERATOR_OWNER" } as VerifiedAccessToken;
  const admin = { sub: randomUUID(), role: "PLATFORM_ADMIN" } as VerifiedAccessToken;
  const ownerAuthz: Authorization = { permission: "trip:manage", scope: "tenant", db: tenantScope(operatorId) };
  const financeAuthz: Authorization = { permission: "finance:read", scope: "tenant", db: tenantScope(operatorId) };
  const platformAuthz: Authorization = { permission: "payment:monitor", scope: "any", db: platformScope() };
  let routeId: string;
  let seatMapId: string;
  const fixture: { first?: Awaited<ReturnType<typeof paidTrip>>; second?: Awaited<ReturnType<typeof paidTrip>> } = {};

  /** Chuyến mở bán sau `hoursAhead` giờ (xe 4 chỗ), một đơn đã thanh toán VNPay cho `seatCodes` (callback thật → vé + sổ). */
  async function paidTrip(hoursAhead: number, seatCodes: string[], withDriver: boolean) {
    const vehicle = await new VehicleService(prisma, {} as never).create(
      ownerAuthz,
      VehicleInputSchema.parse({ plateNumber: `51E${10000 + Math.floor(Math.random() * 89999)}`, vehicleTypeId: vehicleType, seatMapId, amenityIds: [], status: "ACTIVE", description: null }),
    );
    const departureAt = new Date(Date.now() + hoursAhead * HOUR);
    const trip = await trips.create(
      ownerAuthz,
      TripInputSchema.parse({ routeId, vehicleId: vehicle.id, departureAt: departureAt.toISOString(), arrivalAt: new Date(departureAt.getTime() + 6 * HOUR).toISOString(), stopTimes: null, onlineSaleCutoffMinutes: 60, note: null }),
    );
    await prisma.withSystem(async (tx) => {
      await tx.trip.update({ where: { id: trip.id }, data: { status: "OPEN_FOR_SALE" } });
      if (withDriver) {
        await tx.employeeAssignment.create({ data: { operatorId, tripId: trip.id, employeeId: driverId, role: "DRIVER" } });
      }
    });
    const hold = await holds.create(null, undefined, SeatHoldInputSchema.parse({ tripId: trip.id, seatCodes, pickupSequence: 1, dropoffSequence: 3 }));
    const total = 300_000 * seatCodes.length;
    const created = await bookings.create(
      null,
      BookingInputSchema.parse({
        holdId: hold.holdId,
        contact: { fullName: "Khách", phone: "0901234567", email: "k@example.com" },
        passengers: seatCodes.map((seatCode) => ({ seatCode, fullName: `Khách ${seatCode}`, phone: null })),
        note: null,
        expectedTotal: total,
      }),
    );
    const paymentCode = `PAY${randomUUID().replace(/-/g, "").slice(0, 12).toUpperCase()}`;
    const payment = await prisma.withTenant(operatorId, (tx) =>
      tx.payment.create({ data: { paymentCode, operatorId, bookingId: created.bookingId, provider: "VNPAY", status: "PROCESSING", amount: BigInt(total), expiresAt: new Date(Date.now() + 600_000) } }),
    );
    expect(await applyPaymentCallback(prisma, { provider: "VNPAY", paymentCode, providerTxnId: `T${randomUUID().slice(0, 10)}`, amount: String(total), success: true, resultCode: "00", fields: {} }, qr)).toBe("SUCCESS");
    const tickets = await prisma.withSystem((tx) => tx.ticket.findMany({ where: { bookingId: created.bookingId }, orderBy: { ticketCode: "asc" }, select: { id: true, ticketCode: true } }));
    return { tripId: trip.id, vehicleId: vehicle.id, bookingId: created.bookingId, paymentId: payment.id, tickets };
  }

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    redis = new Redis(getRedisUrl(), createRequestRedisClientOptions("reporting-test"));
    holds = new SeatHoldService(prisma, redis);
    bookings = new BookingService(prisma, holds, qr);
    trips = new TripService(prisma, {} as AuditService);
    reports = new ReportingService(prisma, { recordAuditEvent } as unknown as AuditService);
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.create({ data: { id: operatorId, operatorSlug: `rp-${tag}`, displayName: `Nhà xe báo cáo ${tag}` } });
      await tx.employeeAccount.create({ data: { id: driverId, operatorId, username: `nv.tai-${tag}`, passwordHash: "x", role: "DRIVER" } });
      await tx.province.create({ data: { id: province, code: `rp-${tag}`, name: "Tỉnh" } });
      await tx.ward.create({ data: { id: ward, provinceId: province, code: `rw-${tag}`, name: "Phường" } });
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
      await tx.vehicleType.create({ data: { id: vehicleType, code: `RP-${tag}`, name: "Giường", form: "SLEEPER", class: "STANDARD" } });
    });
    routeId = (
      await new RouteService(prisma, new FakeRouting()).create(
        ownerAuthz,
        RouteInputSchema.parse({
          name: `=Tuyến báo cáo ${tag}`,
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

    // Chuyến 1 (30 giờ tới, có tài xế): 2 vé, tài xế soát 1 vé. Chuyến 2 (40 giờ tới, chưa có tài xế): 1 vé đã hoàn 300.000đ.
    fixture.first = await paidTrip(30, ["A1", "A2"], true);
    fixture.second = await paidTrip(40, ["A1"], false);
    const operations = new EmployeeOperationsService(prisma, { recordAuditEvent: async () => undefined } as unknown as AuditService);
    await operations.checkIn(
      { permission: "checkin:perform", scope: "assigned", db: tenantScope(operatorId) },
      { sub: driverId, role: "DRIVER" } as VerifiedAccessToken,
      { tripId: fixture.first.tripId, code: fixture.first.tickets[0]!.ticketCode, status: "CHECKED_IN" },
    );
    await prisma.withSystem(async (tx) => {
      const refund = await tx.refund.create({
        data: {
          refundCode: `RFD${randomUUID().replace(/-/g, "").slice(0, 12).toUpperCase()}`,
          operatorId,
          bookingId: fixture.second!.bookingId,
          paymentId: fixture.second!.paymentId,
          status: "SUCCESS",
          amount: 300_000n,
          refundPercent: 100,
          reason: "Khách hủy",
          requestedBy: "guest",
          processedAt: new Date(),
        },
      });
      await tx.ticket.update({ where: { id: fixture.second!.tickets[0]!.id }, data: { status: "REFUNDED", cancelledAt: new Date(), refundId: refund.id } });
    });
  }, 90_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      await tx.$executeRaw`SELECT set_config('app.allow_ledger_delete', 'on', true)`;
      await tx.notificationDelivery.deleteMany({ where: { operatorId } });
      await tx.notification.deleteMany({ where: { operatorId } });
      await tx.escrowLedger.deleteMany({ where: { operatorId } });
      await tx.ticketStatusHistory.deleteMany({ where: { operatorId } });
      await tx.ticket.deleteMany({ where: { operatorId } });
      await tx.refund.deleteMany({ where: { operatorId } });
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

  it("báo cáo nhà xe: tổng theo kỳ, theo tuyến, nhân viên soát vé; lọc xe; tenant khác không thấy gì; Admin gọi route nhà xe → 403", async () => {
    const range = { from: vnDate(new Date()), to: vnDate(new Date(Date.now() + 3 * DAY)) };
    const report = await reports.operatorReport(financeAuthz, range);
    expect(report.totals).toEqual({ grossRevenue: 600_000, trips: 2, completedTrips: 0, ticketsSold: 2, bookings: 1, seats: 8, cancelledTickets: 1, refundedTickets: 1 });
    expect(report.byRoute).toEqual([{ routeId, routeName: `=Tuyến báo cáo ${tag}`, trips: 2, completedTrips: 0, seats: 8, ticketsSold: 2, grossRevenue: 600_000 }]);
    expect(report.employees).toEqual([{ employeeId: driverId, loginName: `rp-${tag}/nv.tai-${tag}`, role: "DRIVER", assignedTrips: 1, completedTrips: 0, ticketsChecked: 1 }]);

    const byVehicle = await reports.operatorReport(financeAuthz, { ...range, vehicleId: fixture.second!.vehicleId });
    expect(byVehicle.totals).toMatchObject({ trips: 1, ticketsSold: 0, seats: 4, cancelledTickets: 1, grossRevenue: 0 });
    // Kỳ không có chuyến: không có dòng tuyến; nhân viên vẫn liệt kê với số 0.
    const empty = await reports.operatorReport(financeAuthz, { from: "2031-01-01", to: "2031-01-31" });
    expect([empty.totals.trips, empty.byRoute, empty.employees[0]?.assignedTrips]).toEqual([0, [], 0]);

    const stranger = await reports.operatorReport({ permission: "finance:read", scope: "tenant", db: tenantScope(randomUUID()) }, range);
    expect([stranger.totals.trips, stranger.totals.grossRevenue, stranger.byRoute, stranger.employees]).toEqual([0, 0, [], []]);
    expect(await rejectionOf(reports.operatorReport(platformAuthz, range))).toMatchObject({ status: 403 });
  }, 30_000);

  it("xuất CSV nhà xe: BOM + tiêu đề, lấp đầy %, chặn công thức; ghi audit `report.export`; ghi audit lỗi → 503, không trả tệp", async () => {
    const range = { from: vnDate(new Date()), to: vnDate(new Date(Date.now() + 3 * DAY)) };
    const file = await reports.operatorReportCsv(financeAuthz, owner, range);
    expect(file.filename).toBe(`bao-cao-${range.from}-${range.to}.csv`);
    expect(file.csv.startsWith("﻿")).toBe(true);
    expect(file.csv.split("\r\n").slice(0, 2)).toEqual([
      '﻿"Tuyến","Chuyến","Chuyến hoàn thành","Số chỗ","Vé bán","Lấp đầy (%)","Doanh thu gộp (VND)"',
      `"'=Tuyến báo cáo ${tag}","2","0","8","2","25.0","600000"`,
    ]);
    expect(events.at(-1)).toMatchObject({ action: "report.export", targetType: "operator_report", operatorId, actorId: owner.sub, after: { ...range, rows: 1 } });

    recordAuditEvent.mockRejectedValueOnce(new AuditWriteError("mongo down"));
    expect(await rejectionOf(reports.operatorReportCsv(financeAuthz, owner, range))).toEqual({ status: 503, code: "SERVICE_UNAVAILABLE" });
  }, 30_000);

  it("tổng quan nhà xe: 7 ngày tới, chuyến 48 giờ tới chưa có tài xế, chuyến sắp chạy kèm vé bán / tài xế", async () => {
    const overview = await reports.operatorOverview(financeAuthz);
    // Chuyến cách 30 / 40 giờ luôn rơi vào "7 ngày tới" (không phải hôm nay).
    expect(overview.today).toEqual({ trips: 0, running: 0, ticketsSold: 0, seats: 0 });
    expect(overview.nextWeek).toEqual({ trips: 2, ticketsSold: 2, seats: 8 });
    expect(overview.attention).toEqual({ tripsWithoutDriver: 1, draftTrips: 0, pendingRefunds: 0 });
    expect(overview.upcoming.map((trip) => [trip.tripId, trip.ticketsSold, trip.seats, trip.driverName])).toEqual([
      [fixture.first!.tripId, 2, 4, `nv.tai-${tag}`],
      [fixture.second!.tripId, 0, 4, null],
    ]);
  }, 30_000);

  it("Admin: báo cáo + tổng quan lọc theo nhà xe (GMV, sau hoàn, phương thức, theo ngày); lọc cổng MoMo → 0; CSV có audit; route Admin cần scope platform", async () => {
    const today = vnDate(new Date());
    const range = { from: today, to: vnDate(new Date(Date.now() + 3 * DAY)), operatorId };
    const report = await reports.adminReport(platformAuthz, range);
    expect(report.totals).toMatchObject({ gmv: 900_000, bookings: 2, tickets: 3, netRevenue: 600_000, reconcileOpen: 0, trips: 2, completedTrips: 0, seats: 8, ticketsSold: 2, operatorCancelledTrips: 0, tripsWithSales: 2 });
    expect(report.byOperator).toEqual([{ operatorId, operatorName: `Nhà xe báo cáo ${tag}`, trips: 2, ticketsSold: 2, seats: 8, gmv: 900_000, refunded: 300_000 }]);
    expect(report.paymentMethods).toEqual([{ provider: "VNPAY", amount: 900_000, count: 2 }]);
    const momo = await reports.adminReport(platformAuthz, { ...range, provider: "MOMO" });
    expect([momo.totals.gmv, momo.byOperator[0]?.gmv, momo.paymentMethods]).toEqual([0, 0, [{ provider: "VNPAY", amount: 900_000, count: 2 }]]);

    const file = await reports.adminReportCsv(platformAuthz, admin, range);
    expect(file.csv.split("\r\n")[1]).toBe(`"Nhà xe báo cáo ${tag}","2","2","25.0","900000","300000"`);
    expect(events.at(-1)).toMatchObject({ action: "report.export", targetType: "platform_report", actorId: admin.sub });

    const week = { from: vnDate(new Date(Date.now() - 6 * DAY)), to: today, operatorId };
    const overview = await reports.adminOverview(platformAuthz, week);
    const held = await prisma.withSystem(async (tx) => (await tx.escrowLedger.aggregate({ where: { operatorId }, _sum: { amount: true } }))._sum.amount ?? 0n);
    expect(overview).toMatchObject({
      gmv: 900_000,
      previousGmv: 0,
      bookings: { total: 2, confirmed: 2, cancelledOrExpired: 0 },
      tickets: { issued: 3, refunded: 1 },
      // Chuyến chưa chạy: toàn bộ số dư còn chờ mốc chi trả.
      escrow: { held: Number(held), eligible: 0, pending: Number(held), onHold: 0 },
      queues: { payoutsPendingReview: 0, refundsFailed: 0, reconcileOpen: 0 },
    });
    expect(overview.escrow.commissionInRange).toBeGreaterThan(0);
    expect(overview.daily).toHaveLength(7);
    expect(overview.daily.at(-1)).toEqual({ date: today, gmv: 900_000 });
    expect(overview.daily.slice(0, 6).every((day) => day.gmv === 0)).toBe(true);
    await expect(reports.adminReport(financeAuthz, range)).rejects.toThrow("ngữ cảnh DB platform");
  }, 30_000);
});
