import { randomUUID } from "node:crypto";
import Redis from "ioredis";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { type AuditEventInput, AuditService, AuditWriteError } from "../audit/audit.service";
import { BookingService } from "../booking/booking.service";
import { BookingInputSchema } from "../booking/dto/booking.dto";
import { parseAppConfig } from "../config/env.config";
import { platformScope, tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { EmailNotifier } from "../external/notification/email-notifier";
import type { Coordinates, RouteLeg, RoutingProvider } from "../external/routing/routing-provider";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { CredentialService } from "../iam/auth/credential.service";
import type { MfaService } from "../iam/auth/mfa.service";
import type { Authorization } from "../iam/role/authorization";
import type { SessionService } from "../iam/session/session.service";
import { AdminAccountService } from "../iam/user/admin-account.service";
import { PassengerBookingQuerySchema } from "../iam/user/dto/admin-user.dto";
import type { TemporaryCredentialEmailLimiter } from "../iam/user/temporary-credential-email-limiter";
import { AdminOperatorService } from "../operator/admin-operator.service";
import { AdminPaymentService } from "../payment/admin-payment.service";
import { AdminPaymentListQuerySchema } from "../payment/dto/admin-payment.dto";
import { applyPaymentCallback } from "../payment/payment-callback";
import { createRequestRedisClientOptions, getRedisUrl } from "../redis/redis.config";
import { ReportingService } from "../reporting/reporting.service";
import { AdminRouteService } from "../route/admin-route.service";
import { AdminRouteDetailQuerySchema, AdminRouteListQuerySchema } from "../route/dto/admin-route.dto";
import { RouteInputSchema } from "../route/dto/route.dto";
import { RouteService } from "../route/route.service";
import { SeatHoldInputSchema } from "../seat-hold/dto/seat-hold.dto";
import { SeatHoldService } from "../seat-hold/seat-hold.service";
import { TicketQrSigner } from "../ticket/ticket-qr";
import { AdminTripService } from "../trip/admin-trip.service";
import { AdminTripListQuerySchema } from "../trip/dto/admin-trip.dto";
import { TripInputSchema } from "../trip/dto/trip.dto";
import { TripService } from "../trip/trip.service";
import { SeatMapInputSchema } from "../vehicle/dto/seat-map.dto";
import { VehicleInputSchema } from "../vehicle/dto/vehicle.dto";
import { SeatMapService } from "../vehicle/seat-map.service";
import { VehicleService } from "../vehicle/vehicle.service";

/**
 * Admin giám sát nhà xe / hành khách / tuyến / chuyến (tự thiết kế 28/10/2026, chờ duyệt) trên Postgres + Redis THẬT, role
 * app, ngữ cảnh platform: chi tiết nhà xe + đội xe, tuyến kèm hiệu suất + tỉnh đầu / cuối, chuyến + danh sách người đi (khách
 * vãng lai lẫn tài khoản, SĐT che, audit lượt xem), chi tiết tài khoản hành khách + đơn, báo cáo theo tuyến / khu vực,
 * tìm giao dịch theo SĐT người đặt. Tiền chỉ trả khi người xem có `payment:monitor`.
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

const vnDate = (at: Date) => new Date(at.getTime() + 7 * HOUR).toISOString().slice(0, 10);

describe.skipIf(!ready && !requireDb)("Admin giám sát nhà xe / hành khách / tuyến / chuyến — Postgres + Redis thật", () => {
  let prisma: PrismaService;
  let redis: Redis;
  let holds: SeatHoldService;
  let bookings: BookingService;
  let trips: TripService;
  let operators: AdminOperatorService;
  let accounts: AdminAccountService;
  let adminRoutes: AdminRouteService;
  let adminTrips: AdminTripService;
  let reports: ReportingService;
  let payments: AdminPaymentService;
  const recordAuditEvent = vi.fn(async (_event: AuditEventInput, _options?: unknown) => undefined);
  const audit = { recordAuditEvent } as unknown as AuditService;
  const qr = new TicketQrSigner(Buffer.alloc(32, 7));
  const tag = randomUUID().slice(0, 8);
  const operatorId = randomUUID();
  const otherOperatorId = randomUUID();
  const provinces = [randomUUID(), randomUUID()];
  const wards = [randomUUID(), randomUUID()];
  const points = [randomUUID(), randomUUID(), randomUUID()];
  const vehicleType = randomUUID();
  const userId = `usr${tag}`;
  const userPhone = `09${String(Math.floor(Math.random() * 1e8)).padStart(8, "0")}`;
  const ownerAuthz: Authorization = { permission: "trip:manage", scope: "tenant", db: tenantScope(operatorId) };
  const authz: Authorization = { permission: "user:manage", scope: "any", db: platformScope() };
  const moneyViewer = { sub: randomUUID(), role: "PLATFORM_ADMIN", scope: "platform", perms: ["user:manage", "payment:monitor"] } as VerifiedAccessToken;
  const plainViewer = { sub: randomUUID(), role: "PLATFORM_ADMIN", scope: "platform", perms: ["user:manage"] } as VerifiedAccessToken;
  let routeId: string;
  let seatMapId: string;
  const fixture: { done?: Awaited<ReturnType<typeof paidTrip>>; guest?: Awaited<ReturnType<typeof paidTrip>>; member?: Awaited<ReturnType<typeof paidTrip>> } = {};
  const period = { from: vnDate(new Date(Date.now() - 3 * DAY)), to: vnDate(new Date(Date.now() + 3 * DAY)) };

  /** Chuyến mở bán sau `hoursAhead` giờ, một đơn đã thanh toán (callback thật → vé). `user` = tài khoản đặt, null = vãng lai. */
  async function paidTrip(hoursAhead: number, seatCodes: string[], user: VerifiedAccessToken | null, phone: string) {
    const vehicle = await new VehicleService(prisma, {} as never).create(
      ownerAuthz,
      VehicleInputSchema.parse({ plateNumber: `51G${10000 + Math.floor(Math.random() * 89999)}`, vehicleTypeId: vehicleType, seatMapId, amenityIds: [], status: "ACTIVE", description: null }),
    );
    const trip = await trips.create(
      ownerAuthz,
      TripInputSchema.parse({ routeId, vehicleId: vehicle.id, departureAt: new Date(Date.now() + hoursAhead * HOUR).toISOString(), stopTimes: null, onlineSaleCutoffMinutes: 60, note: null }),
    );
    await prisma.withSystem((tx) => tx.trip.update({ where: { id: trip.id }, data: { status: "OPEN_FOR_SALE" } }));
    const hold = await holds.create(user, undefined, SeatHoldInputSchema.parse({ tripId: trip.id, seatCodes, pickupSequence: 1, dropoffSequence: 3 }));
    const total = 300_000 * seatCodes.length;
    const created = await bookings.create(
      user,
      BookingInputSchema.parse({
        holdId: hold.holdId,
        contact: { fullName: "Người đặt", phone, email: `dat-${tag}@example.com` },
        passengers: seatCodes.map((seatCode) => ({ seatCode, fullName: `Người đi ${seatCode}`, phone: "0912345678" })),
        note: null,
        expectedTotal: total,
      }),
    );
    const paymentCode = `PAY${randomUUID().replace(/-/g, "").slice(0, 12).toUpperCase()}`;
    const payment = await prisma.withTenant(operatorId, (tx) =>
      tx.payment.create({ data: { paymentCode, operatorId, bookingId: created.bookingId, provider: "VNPAY", status: "PROCESSING", amount: BigInt(total), expiresAt: new Date(Date.now() + 600_000) } }),
    );
    expect(await applyPaymentCallback(prisma, { provider: "VNPAY", paymentCode, providerTxnId: `T${randomUUID().slice(0, 10)}`, amount: String(total), success: true, resultCode: "00", fields: {} }, qr)).toBe("SUCCESS");
    return { tripId: trip.id, vehicleId: vehicle.id, bookingId: created.bookingId, paymentId: payment.id };
  }

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    redis = new Redis(getRedisUrl(), createRequestRedisClientOptions("admin-monitoring-test"));
    holds = new SeatHoldService(prisma, redis);
    bookings = new BookingService(prisma, holds, qr);
    trips = new TripService(prisma, {} as AuditService);
    const sessions = { revokeAllForSubject: async () => 0, lastLoginAt: async () => new Map() } as unknown as SessionService;
    operators = new AdminOperatorService(prisma, audit, sessions, { sendOtp: async () => undefined } as EmailNotifier);
    accounts = new AdminAccountService(
      prisma,
      audit,
      sessions,
      {} as MfaService,
      {} as CredentialService,
      {} as TemporaryCredentialEmailLimiter,
      {} as EmailNotifier,
    );
    adminRoutes = new AdminRouteService(prisma);
    adminTrips = new AdminTripService(prisma, audit);
    reports = new ReportingService(prisma, audit);
    payments = new AdminPaymentService(prisma);
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.createMany({
        data: [
          { id: operatorId, operatorSlug: `mon-${tag}`, displayName: `Nhà xe giám sát ${tag}`, hotline: "19001234", legalName: "Công ty TNHH Giám sát" },
          { id: otherOperatorId, operatorSlug: `mon-o-${tag}`, displayName: `Nhà xe khác ${tag}` },
        ],
      });
      await tx.bankAccount.create({ data: { operatorId, bankName: "VCB", accountNumber: "0011223344", accountHolder: "CONG TY", status: "VERIFIED", reviewedAt: new Date() } });
      await tx.province.createMany({ data: provinces.map((id, index) => ({ id, code: `mp${index}-${tag}`, name: index === 0 ? `Tỉnh Đi ${tag}` : `Tỉnh Đến ${tag}` })) });
      await tx.ward.createMany({ data: wards.map((id, index) => ({ id, provinceId: provinces[index]!, code: `mw${index}-${tag}`, name: "Phường" })) });
      await tx.stopPointCatalog.createMany({
        data: points.map((id, index) => ({
          id,
          name: `Bến ${index} ${tag}`,
          type: index === 1 ? ("REST_STOP" as const) : ("BUS_STATION" as const),
          legalBasis: index === 1 ? null : "QĐ (test)",
          address: `Địa chỉ ${index}`,
          provinceId: index === 2 ? provinces[1]! : provinces[0]!,
          wardId: index === 2 ? wards[1]! : wards[0]!,
          latitude: 10 + index,
          longitude: 106,
        })),
      });
      await tx.vehicleType.create({ data: { id: vehicleType, code: `MON-${tag}`, name: "Giường giám sát", form: "SLEEPER", class: "STANDARD" } });
      await tx.user.create({ data: { id: userId, email: `rider-${tag}@example.com`, name: `Khách ${tag}`, phone: userPhone } });
    });
    routeId = (
      await new RouteService(prisma, new FakeRouting()).create(
        ownerAuthz,
        RouteInputSchema.parse({
          name: `Tuyến giám sát ${tag}`,
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
    // Chuyến "đã chạy": 2 vé vãng lai, rồi dời giờ về 2 ngày trước + hoàn thành (thẻ 30 ngày của nhà xe đếm chuyến đã khởi hành).
    fixture.done = await paidTrip(30, ["A1", "A2"], null, "0901111222");
    await prisma.withSystem((tx) =>
      tx.trip.update({ where: { id: fixture.done!.tripId }, data: { status: "COMPLETED", departureAt: new Date(Date.now() - 2 * DAY), arrivalAt: new Date(Date.now() - 2 * DAY + 6 * HOUR) } }),
    );
    fixture.guest = await paidTrip(40, ["A1"], null, "0903333444");
    fixture.member = await paidTrip(50, ["A3"], { sub: userId, role: "PASSENGER", scope: "passenger", sid: randomUUID() } as VerifiedAccessToken, userPhone);
  }, 120_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      await tx.$executeRaw`SELECT set_config('app.allow_ledger_delete', 'on', true)`;
      await tx.notificationDelivery.deleteMany({ where: { operatorId } });
      await tx.notification.deleteMany({ where: { operatorId } });
      await tx.payoutItem.deleteMany({ where: { operatorId } });
      await tx.escrowLedger.deleteMany({ where: { operatorId } });
      await tx.ticketStatusHistory.deleteMany({ where: { operatorId } });
      await tx.ticket.deleteMany({ where: { operatorId } });
      await tx.paymentStatusHistory.deleteMany({ where: { operatorId } });
      await tx.payment.deleteMany({ where: { operatorId } });
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
      await tx.bankAccount.deleteMany({ where: { operatorId } });
      await tx.loyaltyAccount.deleteMany({ where: { userId } });
      await tx.user.deleteMany({ where: { id: userId } });
      await tx.stopPointCatalog.deleteMany({ where: { id: { in: points } } });
      await tx.ward.deleteMany({ where: { id: { in: wards } } });
      await tx.province.deleteMany({ where: { id: { in: provinces } } });
      await tx.vehicleType.deleteMany({ where: { id: vehicleType } });
      await tx.operatorProfile.deleteMany({ where: { id: { in: [operatorId, otherOperatorId] } } });
    });
    await redis.quit();
    await prisma.$disconnect();
  });

  beforeEach(() => {
    recordAuditEvent.mockReset();
    recordAuditEvent.mockResolvedValue(undefined);
  });

  it("chi tiết nhà xe: hồ sơ, TK nhận tiền che số, đếm xe; thẻ 30 ngày chỉ tính chuyến đã khởi hành; tiền ẩn khi thiếu payment:monitor; 404", async () => {
    const detail = await operators.detail(authz, moneyViewer, operatorId);
    expect(detail).toMatchObject({
      id: operatorId,
      hotline: "19001234",
      legalName: "Công ty TNHH Giám sát",
      bankAccount: { bankName: "VCB", accountNumber: "•••• 3344", accountHolder: "CONG TY" },
      vehicleCount: 3,
      routeCount: 1,
      openTripCount: 2,
      stats: { trips: 1, completedTrips: 1, cancelledTrips: 0, seats: 4, ticketsSold: 2, ticketRevenue: 600_000, refunded: 0 },
    });
    expect((await operators.detail(authz, plainViewer, operatorId)).stats).toMatchObject({ ticketsSold: 2, ticketRevenue: null, refunded: null });
    expect(await rejectionOf(operators.detail(authz, moneyViewer, randomUUID()))).toEqual({ status: 404, code: "OPERATOR_NOT_FOUND" });

    const fleet = await operators.vehicles(authz, operatorId);
    expect(fleet.items).toHaveLength(3);
    expect(fleet.items.every((vehicle) => vehicle.vehicleTypeName === "Giường giám sát" && vehicle.seatCount === 4)).toBe(true);
    expect(fleet.items.map((vehicle) => vehicle.upcomingTripCount).sort()).toEqual([0, 1, 1]);
  });

  it("tuyến: tỉnh đầu / cuối, số liệu kỳ, xếp + lọc tỉnh; tiền ẩn khi thiếu quyền; chi tiết có điểm dừng + chuyến sắp chạy", async () => {
    const list = (query: Record<string, unknown>, viewer = moneyViewer) => adminRoutes.list(authz, viewer, AdminRouteListQuerySchema.parse({ operatorId, ...period, ...query }));
    const page = await list({});
    expect(page.total).toBe(1);
    expect(page.items[0]).toMatchObject({
      id: routeId,
      operatorName: `Nhà xe giám sát ${tag}`,
      origin: { id: provinces[0], name: `Tỉnh Đi ${tag}` },
      destination: { id: provinces[1], name: `Tỉnh Đến ${tag}` },
      stopCount: 3,
      trips: 3,
      completedTrips: 1,
      ticketsSold: 4,
      ticketRevenue: 1_200_000,
      upcomingTrips: 2,
    });
    expect((await list({}, plainViewer)).items[0]?.ticketRevenue).toBeNull();
    expect((await list({ originProvinceId: provinces[1] })).total).toBe(0);
    expect((await list({ destinationProvinceId: provinces[1], sort: "revenue" })).total).toBe(1);
    expect(() => AdminRouteListQuerySchema.parse({ from: "2026-01-01" })).toThrow();

    const detail = await adminRoutes.detail(authz, moneyViewer, routeId, AdminRouteDetailQuerySchema.parse(period));
    expect(detail.stops.map((stop) => [stop.sequence, stop.name, stop.shared, stop.latitude])).toEqual([
      [1, `Bến 0 ${tag}`, true, 10],
      [2, `Bến 1 ${tag}`, true, 11],
      [3, `Bến 2 ${tag}`, true, 12],
    ]);
    expect(detail.nextTrips.map((trip) => trip.ticketsSold)).toEqual([1, 1]);
    expect(await rejectionOf(adminRoutes.detail(authz, moneyViewer, randomUUID(), AdminRouteDetailQuerySchema.parse({})))).toEqual({ status: 404, code: "ROUTE_NOT_FOUND" });
  });

  it("chuyến: danh sách theo kỳ + nhà xe, chi tiết có danh sách người đi (vãng lai / tài khoản, SĐT che) và ghi audit; audit lỗi → 503", async () => {
    const page = await adminTrips.list(authz, AdminTripListQuerySchema.parse({ operatorId, ...period }));
    expect(page.items.map((trip) => trip.id)).toEqual([fixture.done!.tripId, fixture.guest!.tripId, fixture.member!.tripId]);
    expect(page.items.map((trip) => trip.ticketsSold)).toEqual([2, 1, 1]);
    expect((await adminTrips.list(authz, AdminTripListQuerySchema.parse({ operatorId: otherOperatorId, ...period }))).total).toBe(0);

    const member = await adminTrips.detail(authz, moneyViewer, fixture.member!.tripId);
    expect(member).toMatchObject({ seats: 4, ticketsSold: 1, bookingCount: 1, ticketRevenue: 300_000, seatSummary: { booked: 1, available: 3 } });
    expect(member.manifest).toEqual([expect.objectContaining({ seatCode: "A3", fullName: "Người đi A3", phone: "0*** *** 678", guest: false, userId, channel: "ONLINE" })]);
    expect(member.stops).toHaveLength(3);
    expect(recordAuditEvent).toHaveBeenCalledWith(expect.objectContaining({ action: "trip.manifest.view", targetId: fixture.member!.tripId, operatorId }), expect.anything());
    expect((await adminTrips.detail(authz, plainViewer, fixture.guest!.tripId)).manifest[0]).toMatchObject({ guest: true, userId: null });

    recordAuditEvent.mockRejectedValueOnce(new AuditWriteError("down"));
    expect(await rejectionOf(adminTrips.detail(authz, moneyViewer, fixture.guest!.tripId))).toEqual({ status: 503, code: "SERVICE_UNAVAILABLE" });
  });

  it("hành khách: chi tiết tài khoản (SĐT che, số đơn / vé, tổng đã trả khi có quyền) có audit; đơn kèm người đi; 404", async () => {
    const detail = await accounts.passengerDetail(authz, moneyViewer, userId);
    expect(detail).toMatchObject({ id: userId, phone: `0*** *** ${userPhone.slice(-3)}`, bookingCount: 1, ticketCount: 1, supportTicketCount: 0, totalPaid: 300_000 });
    expect(recordAuditEvent).toHaveBeenCalledWith(expect.objectContaining({ action: "passenger.view", targetId: userId }), expect.anything());
    expect((await accounts.passengerDetail(authz, plainViewer, userId)).totalPaid).toBeNull();

    const page = await accounts.passengerBookings(authz, moneyViewer, userId, PassengerBookingQuerySchema.parse({}));
    expect(page.total).toBe(1);
    expect(page.items[0]).toMatchObject({
      tripId: fixture.member!.tripId,
      routeName: `Tuyến giám sát ${tag}`,
      total: 300_000,
      paymentId: fixture.member!.paymentId,
      passengers: [{ fullName: "Người đi A3", seatCode: "A3", ticketStatus: "VALID" }],
    });
    expect(await rejectionOf(accounts.passengerDetail(authz, moneyViewer, `missing${tag}`))).toEqual({ status: 404, code: "ACCOUNT_NOT_FOUND" });
  });

  it("báo cáo Admin: theo tuyến + theo khu vực (cặp tỉnh), CSV theo tuyến có audit; tìm giao dịch theo SĐT người đặt (cả đơn vãng lai)", async () => {
    const reportAuthz: Authorization = { permission: "payment:monitor", scope: "any", db: platformScope() };
    const report = await reports.adminReport(reportAuthz, { ...period, operatorId });
    expect(report.byRoute).toEqual([expect.objectContaining({ routeId, trips: 3, ticketsSold: 4, ticketRevenue: 1_200_000, originName: `Tỉnh Đi ${tag}` })]);
    expect(report.byRegion).toEqual([expect.objectContaining({ originProvinceId: provinces[0], destinationProvinceId: provinces[1], routes: 1, operators: 1, ticketsSold: 4 })]);
    const file = await reports.adminReportCsv(reportAuthz, moneyViewer, { ...period, operatorId, group: "region" });
    expect(file.csv.split("\r\n")[1]).toBe(`"Tỉnh Đi ${tag}","Tỉnh Đến ${tag}","1","1","3","4","33.3","1200000"`);

    const byPhone = await payments.list(reportAuthz, AdminPaymentListQuerySchema.parse({ q: "0903 333 444" }));
    expect(byPhone.items.map((item) => item.paymentId)).toEqual([fixture.guest!.paymentId]);
  });
});
