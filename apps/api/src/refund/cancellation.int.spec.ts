import { randomUUID } from "node:crypto";
import type { Queue } from "bullmq";
import Redis from "ioredis";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import type { AuditService } from "../audit/audit.service";
import { BookingService } from "../booking/booking.service";
import { BookingInputSchema } from "../booking/dto/booking.dto";
import { parseAppConfig } from "../config/env.config";
import { tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { NotificationDispatcher } from "../notification/notification-dispatcher";
import { PaymentGatewayError, type PaymentGateway, type PaymentGateways, type RefundRequest } from "../external/payment/payment-gateway";
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
import { CancellationService } from "./cancellation.service";
import { processRefund } from "./refund-processing";

/**
 * TASK-BTP-005 — hủy vé + hoàn tiền trên Postgres + Redis THẬT (role app): tiền hoàn theo mốc chụp lúc đặt (BIGINT), hủy
 * một phần / toàn bộ, trả chỗ, refund + worker gọi cổng (giả) thành công / thất bại / thử lại, hủy đồng thời, RLS.
 */
const url = process.env.DATABASE_URL;
const ready = Boolean(url && process.env.REDIS_URL);
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
const HOUR = 3_600_000;
const TIERS = [
  { minHoursBefore: 24, refundPercent: 90 },
  { minHoursBefore: 4, refundPercent: 50 },
  { minHoursBefore: 0, refundPercent: 0 },
];

async function rejectionOf(promise: Promise<unknown>): Promise<{ status?: number; code?: string; reasons?: string[] }> {
  try {
    await promise;
    return {};
  } catch (error) {
    const response = (error as { getResponse?: () => { code?: string; reasons?: string[] } }).getResponse?.();
    return { status: (error as { getStatus?: () => number }).getStatus?.(), code: response?.code, reasons: response?.reasons };
  }
}

class FakeRouting implements RoutingProvider {
  readonly source = "GOONG" as const;
  async measureLegs(points: Coordinates[]): Promise<RouteLeg[]> {
    return points.slice(1).map(() => ({ distanceMeters: 100_000, durationSeconds: 3 * 3600 }));
  }
}

describe.skipIf(!ready && !requireDb)("Hủy vé + hoàn tiền — Postgres + Redis thật (BTP-005)", () => {
  let prisma: PrismaService;
  let redis: Redis;
  let holds: SeatHoldService;
  let bookings: BookingService;
  let cancellations: CancellationService;
  let trips: TripService;
  const jobs: { refundId: string }[] = [];
  const queue = { add: vi.fn(async (_name: string, data: { refundId: string }) => void jobs.push(data)) } as unknown as Queue;
  const refund = vi.fn(async (_request: RefundRequest) => ({ providerRefundId: `RF${Math.floor(Math.random() * 1e8)}` }));
  const vnpay = { provider: "VNPAY", minAmount: 5_000n, maxAmount: 999_999_999n, refund } as unknown as PaymentGateway;
  const gateways: PaymentGateways = new Map<PaymentGateway["provider"], PaymentGateway>([["VNPAY", vnpay]]);
  const qr = new TicketQrSigner(Buffer.alloc(32, 5));
  const tag = randomUUID().slice(0, 8);
  const operatorId = randomUUID();
  const otherOperator = randomUUID();
  const province = randomUUID();
  const ward = randomUUID();
  const points = [randomUUID(), randomUUID(), randomUUID()];
  const vehicleType = randomUUID();
  const riderId = `rf-rider-${tag}`;
  const rider = { sub: riderId, role: "PASSENGER" } as VerifiedAccessToken;
  const authz: Authorization = { permission: "trip:manage", scope: "tenant", db: tenantScope(operatorId) };
  let routeId: string;

  /** Chuyến mở bán khởi hành sau `hoursAhead` giờ, mỗi chuyến một xe riêng (giờ thực nên không xếp lịch chung một xe). */
  async function openTrip(hoursAhead: number): Promise<string> {
    const departureAt = new Date(Date.now() + hoursAhead * HOUR);
    const created = await trips.create(
      authz,
      TripInputSchema.parse({
        routeId,
        vehicleId: (await freshVehicle()).id,
        departureAt: departureAt.toISOString(),
        stopTimes: null,
        onlineSaleCutoffMinutes: 60,
        note: null,
      }),
    );
    await prisma.withSystem((tx) => tx.trip.update({ where: { id: created.id }, data: { status: "OPEN_FOR_SALE" } }));
    return created.id;
  }

  let seatMapId: string;
  async function freshVehicle() {
    return new VehicleService(prisma, {} as never).create(
      authz,
      VehicleInputSchema.parse({ plateNumber: `51R${10000 + Math.floor(Math.random() * 89999)}`, vehicleTypeId: vehicleType, seatMapId, amenityIds: [], status: "ACTIVE", description: null }),
    );
  }

  /** Booking đã thanh toán VNPay + đã phát hành vé (luồng thật kiểm ở payment.int.spec — ở đây dựng thẳng), mốc hủy cố định. */
  async function confirmedBooking(hoursAhead: number, seatCodes: string[], user: VerifiedAccessToken | null = null) {
    const tripId = await openTrip(hoursAhead);
    const hold = await holds.create(user, undefined, SeatHoldInputSchema.parse({ tripId, seatCodes, pickupSequence: 1, dropoffSequence: 3 }));
    const created = await bookings.create(
      user,
      BookingInputSchema.parse({
        holdId: hold.holdId,
        contact: { fullName: "Khách", phone: "0901234567", email: "k@example.com" },
        passengers: seatCodes.map((seatCode) => ({ seatCode, fullName: `Khách ${seatCode}`, phone: null })),
        note: null,
        expectedTotal: 333_333 * seatCodes.length,
      }),
    );
    await prisma.withTenant(operatorId, async (tx) => {
      const booking = await tx.booking.findUniqueOrThrow({ where: { id: created.bookingId }, select: { snapshot: true } });
      await tx.booking.update({
        where: { id: created.bookingId },
        data: { status: "CONFIRMED", paidAt: new Date(), confirmedAt: new Date(), snapshot: { ...(booking.snapshot as object), cancellationPolicy: { tiers: TIERS } } },
      });
      await tx.payment.create({
        data: {
          paymentCode: `PAY${randomUUID().replace(/-/g, "").slice(0, 12).toUpperCase()}`,
          operatorId,
          bookingId: created.bookingId,
          provider: "VNPAY",
          status: "SUCCESS",
          amount: BigInt(created.total),
          providerTxnId: `T${randomUUID().slice(0, 8)}`,
          expiresAt: new Date(),
          paidAt: new Date(),
        },
      });
      await tx.tripSeat.updateMany({ where: { bookingId: created.bookingId }, data: { status: "BOOKED" } });
      await issueTickets(tx, operatorId, created.bookingId, qr, new Date(), "system");
    });
    const view = await bookings.get(user, created.bookingId, created.accessToken);
    return { ...view, accessToken: created.accessToken, tripId };
  }

  const state = (bookingId: string) =>
    prisma.withSystem((tx) =>
      tx.booking.findUniqueOrThrow({
        where: { id: bookingId },
        select: {
          status: true,
          tickets: { orderBy: { ticketCode: "asc" }, select: { status: true, refundId: true } },
          refunds: { orderBy: { createdAt: "asc" }, select: { id: true, status: true, amount: true, refundPercent: true, failureCode: true } },
        },
      }),
    );

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    redis = new Redis(getRedisUrl(), createRequestRedisClientOptions("cancellation-test"));
    holds = new SeatHoldService(prisma, redis);
    bookings = new BookingService(prisma, holds, qr);
    cancellations = new CancellationService(prisma, bookings, queue, { dispatch: vi.fn(async () => undefined) } as unknown as NotificationDispatcher);
    trips = new TripService(prisma, {} as AuditService);
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.create({ data: { id: operatorId, operatorSlug: `rf-${tag}`, displayName: `Nhà xe ${tag}` } });
      await tx.operatorProfile.create({ data: { id: otherOperator, operatorSlug: `rf2-${tag}`, displayName: `Nhà xe khác ${tag}` } });
      await tx.user.create({ data: { id: riderId, email: `rf-${tag}@example.com`, name: "Khách" } });
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
      await tx.vehicleType.create({ data: { id: vehicleType, code: `RV-${tag}`, name: "Giường", form: "SLEEPER", class: "STANDARD" } });
    });
    routeId = (
      await new RouteService(prisma, new FakeRouting()).create(
        authz,
        RouteInputSchema.parse({
          name: `Tuyến hoàn tiền ${tag}`,
          status: "ACTIVE",
          note: null,
          stops: points.map((id, index) => ({ catalogStopPointId: id, stopPointId: null, note: null, allowPickup: index === 0, allowDropoff: index === 2 })),
        }),
      )
    ).id;
    await prisma.withSystem(async (tx) => {
      const fare = await tx.fare.create({ data: { operatorId, routeId, status: "ACTIVE" } });
      // Giá lẻ để kiểm làm tròn xuống: 333.333đ × 90% = 299.999,7 → 299.999đ.
      await tx.fareRule.create({ data: { operatorId, fareId: fare.id, price: 333_333n } });
    });
    seatMapId = (
      await new SeatMapService(prisma).create(
        authz,
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
      // Sổ escrow chỉ ghi thêm (trigger) — dọn dữ liệu test phải bật cờ phiên.
      await tx.$executeRaw`SELECT set_config('app.allow_ledger_delete', 'on', true)`;
      await tx.payoutItem.deleteMany({ where: { operatorId } });
      await tx.escrowLedger.deleteMany({ where: { operatorId } });
      await tx.payoutStatusHistory.deleteMany({ where: { operatorId } });
      await tx.payout.deleteMany({ where: { operatorId } });
      await tx.notificationDelivery.deleteMany({ where: { operatorId } });
      await tx.notification.deleteMany({ where: { operatorId } });
      await tx.tripChange.deleteMany({ where: { operatorId } });
      await tx.ticketStatusHistory.deleteMany({ where: { operatorId } });
      await tx.ticket.deleteMany({ where: { operatorId } });
      await tx.refundStatusHistory.deleteMany({ where: { operatorId } });
      await tx.refund.deleteMany({ where: { operatorId } });
      await tx.paymentStatusHistory.deleteMany({ where: { operatorId } });
      await tx.payment.deleteMany({ where: { operatorId } });
      await tx.tripSeat.updateMany({ where: { operatorId }, data: { bookingId: null } });
      await tx.bookingStatusHistory.deleteMany({ where: { operatorId } });
      await tx.passengerInfo.deleteMany({ where: { operatorId } });
      await tx.bookingAccessGrant.deleteMany({ where: { operatorId } });
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

  it("xem điều kiện: mốc 90% (còn > 24 giờ), tiền BIGINT làm tròn xuống từng vé; vé lạ → 422; thiếu mã truy cập → 404", async () => {
    const booking = await confirmedBooking(48, ["A1", "A2"]);
    const [first, second] = booking.tickets;
    const quote = await cancellations.quote(null, booking.bookingId, booking.accessToken, [first!.ticketId]);
    expect(quote).toMatchObject({ tier: { minHoursBefore: 24, refundPercent: 90 }, refundPercent: 90, selectedTotal: 333_333, refundAmount: 299_999, nonRefundable: 33_334 });
    expect(quote.tickets.map((ticket) => [ticket.seatCode, ticket.cancellable])).toEqual([
      ["A1", true],
      ["A2", true],
    ]);
    expect((await cancellations.quote(null, booking.bookingId, booking.accessToken, [first!.ticketId, second!.ticketId])).refundAmount).toBe(599_998);
    expect(await rejectionOf(cancellations.quote(null, booking.bookingId, booking.accessToken, [randomUUID()]))).toMatchObject({ status: 422, code: "CANCELLATION_TICKETS_INVALID" });
    expect(await rejectionOf(cancellations.quote(null, booking.bookingId, undefined, [first!.ticketId]))).toMatchObject({ status: 404, code: "BOOKING_NOT_FOUND" });
  });

  it("mã truy cập phụ cấp sau OTP tra cứu vé: xem đơn + báo giá hủy được; hết hạn → 404; RLS: nhà xe khác không thấy mã", async () => {
    const booking = await confirmedBooking(48, ["A3"]);
    const ticketIds = [booking.tickets[0]!.ticketId];
    const granted = await bookings.grantLookupAccess(booking.bookingId, undefined, new Date(Date.now() + 15 * 60_000));
    if (typeof granted === "string") throw new Error(granted);
    expect((await bookings.get(null, booking.bookingId, granted.accessToken)).bookingId).toBe(booking.bookingId);
    expect((await cancellations.quote(null, booking.bookingId, granted.accessToken, ticketIds)).refundPercent).toBe(90);
    const stored = await prisma.withTenant(operatorId, (tx) => tx.bookingAccessGrant.findMany({ where: { bookingId: booking.bookingId }, select: { tokenHash: true } }));
    expect(stored).toHaveLength(1);
    expect(stored[0]!.tokenHash).not.toContain(granted.accessToken);

    const expired = await bookings.grantLookupAccess(booking.bookingId, undefined, new Date(Date.now() - 1000));
    if (typeof expired === "string") throw new Error(expired);
    expect(await rejectionOf(cancellations.quote(null, booking.bookingId, expired.accessToken, ticketIds))).toMatchObject({ status: 404, code: "BOOKING_NOT_FOUND" });
    // Cấp mới dọn mã đã hết hạn của đơn.
    await bookings.grantLookupAccess(booking.bookingId, undefined, new Date(Date.now() + 60_000));
    expect(await prisma.withTenant(operatorId, (tx) => tx.bookingAccessGrant.count({ where: { bookingId: booking.bookingId } }))).toBe(2);
    expect(await prisma.withTenant(otherOperator, (tx) => tx.bookingAccessGrant.count({ where: { bookingId: booking.bookingId } }))).toBe(0);
    // Mã phụ không dùng cho đơn khác.
    const other = await confirmedBooking(48, ["A4"]);
    expect(await rejectionOf(cancellations.quote(null, other.bookingId, granted.accessToken, [other.tickets[0]!.ticketId]))).toMatchObject({ status: 404 });
  });

  it("hủy một phần: số hoàn lệch → 409 kèm số mới; đúng → vé CANCELLED + refund APPROVED + chỗ trả lại + booking REFUND_PENDING + xếp job; worker hoàn thành công → vé REFUNDED, booking PARTIALLY_CANCELLED; chạy lại bỏ qua", async () => {
    const booking = await confirmedBooking(48, ["A1", "A2"], rider);
    const [first] = booking.tickets;
    expect(await rejectionOf(cancellations.cancel(rider, booking.bookingId, undefined, { ticketIds: [first!.ticketId], expectedRefund: 300_000, reason: null }))).toMatchObject({
      status: 409,
      code: "REFUND_AMOUNT_CHANGED",
      reasons: ["299999"],
    });
    jobs.length = 0;
    const result = await cancellations.cancel(rider, booking.bookingId, undefined, { ticketIds: [first!.ticketId], expectedRefund: 299_999, reason: "Đổi lịch" });
    expect(result.refund).toMatchObject({ amount: 299_999, status: "APPROVED" });
    expect(result.refund!.refundCode).toMatch(/^RFD[2-9A-HJ-NP-Z]{12}$/);
    expect(result.booking).toMatchObject({ status: "REFUND_PENDING", refunds: [{ amount: 299_999, status: "APPROVED" }] });
    expect(result.booking.tickets.map((ticket) => ticket.status)).toEqual(["CANCELLED", "VALID"]);
    const afterCancel = await state(booking.bookingId);
    expect(afterCancel.refunds).toMatchObject([{ status: "APPROVED", amount: 299_999n, refundPercent: 90 }]);
    expect(afterCancel.tickets[0]!.refundId).toBe(afterCancel.refunds[0]!.id);
    expect(await prisma.withSystem((tx) => tx.tripSeat.findFirstOrThrow({ where: { tripId: booking.tripId, seatCode: "A1" }, select: { status: true, bookingId: true } }))).toEqual({
      status: "AVAILABLE",
      bookingId: null,
    });
    expect(jobs).toEqual([{ refundId: afterCancel.refunds[0]!.id }]);
    expect(await rejectionOf(cancellations.cancel(rider, booking.bookingId, undefined, { ticketIds: [first!.ticketId], expectedRefund: 0, reason: null }))).toMatchObject({
      status: 409,
      code: "CANCELLATION_NOT_ALLOWED",
    });

    refund.mockClear();
    expect(await processRefund(prisma, gateways, jobs[0]!.refundId, { finalAttempt: false })).toBe("SUCCESS");
    expect(refund.mock.calls[0]![0]).toMatchObject({ amount: 299_999n, paidAmount: 666_666n, refundCode: result.refund!.refundCode });
    const settled = await state(booking.bookingId);
    expect(settled.status).toBe("PARTIALLY_CANCELLED");
    expect(settled.tickets.map((ticket) => ticket.status)).toEqual(["REFUNDED", "VALID"]);
    expect(settled.refunds[0]!.status).toBe("SUCCESS");
    expect(await processRefund(prisma, gateways, jobs[0]!.refundId, { finalAttempt: false })).toBe("SKIPPED");
    expect(refund).toHaveBeenCalledTimes(1);
  });

  it("cổng lỗi tạm thời (chưa phải lần cuối) → ném lại để thử lại, refund vẫn PROCESSING; lần cuối / cổng từ chối dứt khoát → FAILED, booking REFUND_FAILED", async () => {
    const booking = await confirmedBooking(48, ["A1", "A2"]);
    const result = await cancellations.cancel(null, booking.bookingId, booking.accessToken, {
      ticketIds: booking.tickets.map((ticket) => ticket.ticketId),
      expectedRefund: 599_998,
      reason: null,
    });
    const refundId = (await state(booking.bookingId)).refunds[0]!.id;
    refund.mockRejectedValueOnce(new PaymentGatewayError("tạm lỗi", true, "94"));
    await expect(processRefund(prisma, gateways, refundId, { finalAttempt: false })).rejects.toBeInstanceOf(PaymentGatewayError);
    expect((await state(booking.bookingId)).refunds[0]!.status).toBe("PROCESSING");
    refund.mockRejectedValueOnce(new PaymentGatewayError("tạm lỗi", true, "94"));
    expect(await processRefund(prisma, gateways, refundId, { finalAttempt: true })).toBe("FAILED");
    const failed = await state(booking.bookingId);
    expect(failed).toMatchObject({ status: "REFUND_FAILED", refunds: [{ status: "FAILED", failureCode: "94" }] });
    expect(failed.tickets.map((ticket) => ticket.status)).toEqual(["CANCELLED", "CANCELLED"]);
    expect(result.booking.status).toBe("REFUND_PENDING");

    const other = await confirmedBooking(48, ["A3"]);
    await cancellations.cancel(null, other.bookingId, other.accessToken, { ticketIds: [other.tickets[0]!.ticketId], expectedRefund: 299_999, reason: null });
    refund.mockRejectedValueOnce(new PaymentGatewayError("từ chối", false, "91"));
    expect(await processRefund(prisma, gateways, (await state(other.bookingId)).refunds[0]!.id, { finalAttempt: false })).toBe("FAILED");
    expect((await state(other.bookingId)).status).toBe("REFUND_FAILED");
  });

  it("sát giờ (mốc 0%) → hủy không tạo refund, booking CANCELLED; chuyến đã khởi hành / vé đã check-in → không hủy được kèm lý do", async () => {
    const late = await confirmedBooking(2, ["A1"]);
    const quote = await cancellations.quote(null, late.bookingId, late.accessToken, [late.tickets[0]!.ticketId]);
    expect(quote).toMatchObject({ tier: { minHoursBefore: 0, refundPercent: 0 }, refundAmount: 0, nonRefundable: 333_333 });
    jobs.length = 0;
    const result = await cancellations.cancel(null, late.bookingId, late.accessToken, { ticketIds: [late.tickets[0]!.ticketId], expectedRefund: 0, reason: null });
    expect(result.refund).toBeNull();
    expect(result.booking.status).toBe("CANCELLED");
    expect(jobs).toEqual([]);

    const departed = await confirmedBooking(48, ["A1", "A2"]);
    await prisma.withSystem(async (tx) => {
      await tx.ticket.updateMany({ where: { ticketCode: departed.tickets[1]!.ticketCode }, data: { status: "CHECKED_IN" } });
    });
    const blocked = await cancellations.quote(null, departed.bookingId, departed.accessToken, [departed.tickets[0]!.ticketId]);
    expect(blocked.tickets.map((ticket) => [ticket.cancellable, ticket.reason])).toEqual([
      [true, null],
      [false, "Vé đã check-in."],
    ]);
    await prisma.withSystem((tx) => tx.trip.update({ where: { id: departed.tripId }, data: { status: "DEPARTED" } }));
    expect(await rejectionOf(cancellations.cancel(null, departed.bookingId, departed.accessToken, { ticketIds: [departed.tickets[0]!.ticketId], expectedRefund: 299_999, reason: null }))).toMatchObject({
      status: 409,
      code: "CANCELLATION_NOT_ALLOWED",
      reasons: [`${departed.tickets[0]!.ticketCode}: Chuyến đã khởi hành.`],
    });
  });

  it("hai lần hủy đồng thời cùng vé → đúng một lần (một refund), lần kia 409; RLS: tenant khác không thấy refund", async () => {
    const booking = await confirmedBooking(48, ["A4"]);
    const input = { ticketIds: [booking.tickets[0]!.ticketId], expectedRefund: 299_999, reason: null };
    const results = await Promise.allSettled([
      cancellations.cancel(null, booking.bookingId, booking.accessToken, input),
      cancellations.cancel(null, booking.bookingId, booking.accessToken, input),
    ]);
    expect(results.filter((result) => result.status === "fulfilled")).toHaveLength(1);
    const lost = await rejectionOf(Promise.reject((results.find((result) => result.status === "rejected") as PromiseRejectedResult).reason));
    expect(lost).toMatchObject({ status: 409, code: "CANCELLATION_NOT_ALLOWED" });
    expect((await state(booking.bookingId)).refunds).toHaveLength(1);
    expect(await prisma.withTenant(otherOperator, (tx) => tx.refund.count({ where: { bookingId: booking.bookingId } }))).toBe(0);
    expect(await prisma.withTenant(operatorId, (tx) => tx.refund.count({ where: { bookingId: booking.bookingId } }))).toBe(1);
  });
});
