import { randomUUID } from "node:crypto";
import type { Queue } from "bullmq";
import Redis from "ioredis";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import type { AuditService } from "../audit/audit.service";
import { expireBooking } from "../booking/booking-expiry";
import { BookingService } from "../booking/booking.service";
import { BookingInputSchema } from "../booking/dto/booking.dto";
import { parseAppConfig } from "../config/env.config";
import { tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import { PaymentGatewayError, type PaymentGateway, type PaymentGateways, type TransactionQuery, type TransactionStatus } from "../external/payment/payment-gateway";
import type { Coordinates, RouteLeg, RoutingProvider } from "../external/routing/routing-provider";
import type { Authorization } from "../iam/role/authorization";
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
import { reconcilePayments } from "./payment-reconciliation";

/**
 * Đối soát tự động với cổng (FR-BTP-17, UC-32) trên Postgres + Redis THẬT: callback bị mất mà cổng nói đã trả → booking còn chờ
 * được xác nhận (vé phát hành) / booking đã hết hạn → cần đối soát; cổng nói thất bại → payment thất bại; không có giao dịch / cổng
 * lỗi → giữ nguyên nhưng không tra lại trong 30 phút; refund đứng yên ở `APPROVED` → xếp hàng lại cùng jobId.
 */
const url = process.env.DATABASE_URL;
const ready = Boolean(url && process.env.REDIS_URL);
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
const HOUR = 3_600_000;
const MINUTE = 60_000;

class FakeRouting implements RoutingProvider {
  readonly source = "GOONG" as const;
  async measureLegs(points: Coordinates[]): Promise<RouteLeg[]> {
    return points.slice(1).map(() => ({ distanceMeters: 100_000, durationSeconds: 3 * 3600 }));
  }
}

describe.skipIf(!ready && !requireDb)("Đối soát thanh toán với cổng — Postgres + Redis thật (FR-BTP-17)", () => {
  let prisma: PrismaService;
  let redis: Redis;
  let holds: SeatHoldService;
  let bookings: BookingService;
  let trips: TripService;
  const answers = new Map<string, TransactionStatus | Error>();
  const queryTransaction = vi.fn(async (request: TransactionQuery) => {
    const answer = answers.get(request.paymentCode) ?? { status: "NOT_FOUND", providerTxnId: null, amount: null, resultCode: "91" };
    if (answer instanceof Error) {
      throw answer;
    }
    return answer;
  });
  const gateways: PaymentGateways = new Map<PaymentGateway["provider"], PaymentGateway>([["VNPAY", { provider: "VNPAY", queryTransaction } as unknown as PaymentGateway]]);
  const refundAdd = vi.fn(async () => undefined);
  const refunds = { add: refundAdd } as unknown as Pick<Queue, "add">;
  const qr = new TicketQrSigner(Buffer.alloc(32, 9));
  const tag = randomUUID().slice(0, 8);
  const operatorId = randomUUID();
  const province = randomUUID();
  const ward = randomUUID();
  const points = [randomUUID(), randomUUID(), randomUUID()];
  const vehicleType = randomUUID();
  const authz: Authorization = { permission: "trip:manage", scope: "tenant", db: tenantScope(operatorId) };
  let routeId: string;
  let seatMapId: string;

  /** Booking chờ thanh toán + payment VNPay `PROCESSING` đã quá hạn (khách bấm trả nhưng callback chưa về). */
  async function overduePayment() {
    const vehicle = await new VehicleService(prisma, {} as never).create(
      authz,
      VehicleInputSchema.parse({ plateNumber: `51F${10000 + Math.floor(Math.random() * 89999)}`, vehicleTypeId: vehicleType, seatMapId, amenityIds: [], status: "ACTIVE", description: null }),
    );
    const departureAt = new Date(Date.now() + 48 * HOUR);
    const trip = await trips.create(
      authz,
      TripInputSchema.parse({ routeId, vehicleId: vehicle.id, departureAt: departureAt.toISOString(), arrivalAt: new Date(departureAt.getTime() + 6 * HOUR).toISOString(), stopTimes: null, onlineSaleCutoffMinutes: 60, note: null }),
    );
    await prisma.withSystem((tx) => tx.trip.update({ where: { id: trip.id }, data: { status: "OPEN_FOR_SALE" } }));
    const hold = await holds.create(null, undefined, SeatHoldInputSchema.parse({ tripId: trip.id, seatCodes: ["A1"], pickupSequence: 1, dropoffSequence: 3 }));
    const created = await bookings.create(
      null,
      BookingInputSchema.parse({ holdId: hold.holdId, contact: { fullName: "Khách", phone: "0901234567", email: "k@example.com" }, passengers: [{ seatCode: "A1", fullName: "Khách A1", phone: null }], note: null, expectedTotal: 300_000 }),
    );
    const paymentCode = `PAY${randomUUID().replace(/-/g, "").slice(0, 12).toUpperCase()}`;
    await prisma.withTenant(operatorId, (tx) =>
      tx.payment.create({ data: { paymentCode, operatorId, bookingId: created.bookingId, provider: "VNPAY", status: "PROCESSING", amount: 300_000n, expiresAt: new Date(Date.now() - MINUTE) } }),
    );
    return { bookingId: created.bookingId, paymentCode };
  }

  const stateOf = (paymentCode: string) =>
    prisma.withSystem((tx) =>
      tx.payment.findUniqueOrThrow({
        where: { paymentCode },
        select: { status: true, reconcileReason: true, providerCheckedAt: true, booking: { select: { status: true, tickets: { select: { status: true } } } } },
      }),
    );

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    redis = new Redis(getRedisUrl(), createRequestRedisClientOptions("reconciliation-test"));
    holds = new SeatHoldService(prisma, redis);
    bookings = new BookingService(prisma, holds, qr);
    trips = new TripService(prisma, {} as AuditService);
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.create({ data: { id: operatorId, operatorSlug: `rc-${tag}`, displayName: `Nhà xe ${tag}` } });
      await tx.province.create({ data: { id: province, code: `rp2-${tag}`, name: "Tỉnh" } });
      await tx.ward.create({ data: { id: ward, provinceId: province, code: `rw2-${tag}`, name: "Phường" } });
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
      await tx.vehicleType.create({ data: { id: vehicleType, code: `RC-${tag}`, name: "Giường", form: "SLEEPER", class: "STANDARD" } });
    });
    routeId = (
      await new RouteService(prisma, new FakeRouting()).create(
        authz,
        RouteInputSchema.parse({
          name: `Tuyến đối soát ${tag}`,
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
        authz,
        SeatMapInputSchema.parse({ name: `Sơ đồ ${tag}`, layout: { decks: [{ deck: 1, rows: 2, columns: 2 }] }, seats: ["A1", "A2", "A3", "A4"].map((code, index) => ({ code, deck: 1, row: Math.floor(index / 2) + 1, column: (index % 2) + 1, type: "BED" })) }),
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
      await tx.escrowLedger.deleteMany({ where: { operatorId } });
      await tx.ticketStatusHistory.deleteMany({ where: { operatorId } });
      await tx.ticket.deleteMany({ where: { operatorId } });
      await tx.refundStatusHistory.deleteMany({ where: { operatorId } });
      await tx.refund.deleteMany({ where: { operatorId } });
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
      await tx.stopPointCatalog.deleteMany({ where: { provinceId: province } });
      await tx.ward.deleteMany({ where: { provinceId: province } });
      await tx.province.deleteMany({ where: { id: province } });
      await tx.vehicleType.deleteMany({ where: { id: vehicleType } });
      await tx.operatorProfile.deleteMany({ where: { id: operatorId } });
    });
    await prisma.$disconnect();
    redis.disconnect();
  });

  it("callback mất: cổng báo đã trả → booking còn chờ được xác nhận (vé) / booking đã hết hạn → cần đối soát; thất bại → payment thất bại; không có / cổng lỗi → giữ nguyên, 30 phút không tra lại", async () => {
    const pending = await overduePayment();
    const expired = await overduePayment();
    const failed = await overduePayment();
    const missing = await overduePayment();
    const broken = await overduePayment();
    await prisma.withTenant(operatorId, async (tx) => {
      await tx.booking.update({ where: { id: expired.bookingId }, data: { expiresAt: new Date(Date.now() - MINUTE) } });
      expect(await expireBooking(tx, operatorId, expired.bookingId, new Date())).toBe(true);
    });
    const paid = (txn: string): TransactionStatus => ({ status: "SUCCESS", providerTxnId: txn, amount: 300_000n, resultCode: "00" });
    answers.set(pending.paymentCode, paid(`T${tag}1`));
    answers.set(expired.paymentCode, paid(`T${tag}2`));
    answers.set(failed.paymentCode, { status: "FAILED", providerTxnId: null, amount: null, resultCode: "02" });
    answers.set(broken.paymentCode, new PaymentGatewayError("VNPay timeout"));

    const now = new Date();
    const run = await reconcilePayments(prisma, gateways, qr, refunds, now);
    expect(run).toMatchObject({ confirmed: 1, reconciling: 1, failed: 1, errors: 1 });
    expect(run.confirmedKeys).toEqual([`BOOKING_CONFIRMED:${pending.paymentCode}`]);
    expect(await stateOf(pending.paymentCode)).toMatchObject({ status: "SUCCESS", booking: { status: "CONFIRMED", tickets: [{ status: "VALID" }] } });
    expect(await stateOf(expired.paymentCode)).toMatchObject({ status: "RECONCILING", reconcileReason: "BOOKING_EXPIRED", booking: { status: "EXPIRED" } });
    expect(await stateOf(failed.paymentCode)).toMatchObject({ status: "FAILED" });
    expect(await stateOf(missing.paymentCode)).toMatchObject({ status: "PROCESSING" });
    expect((await stateOf(broken.paymentCode)).providerCheckedAt?.getTime()).toBe(now.getTime());

    // Chạy lại ngay: thanh toán vừa tra không bị tra lại trong 30 phút.
    queryTransaction.mockClear();
    await reconcilePayments(prisma, gateways, qr, refunds, new Date(now.getTime() + MINUTE));
    expect(queryTransaction.mock.calls.map(([request]) => request.paymentCode)).not.toContain(missing.paymentCode);
    await reconcilePayments(prisma, gateways, qr, refunds, new Date(now.getTime() + 31 * MINUTE));
    expect(queryTransaction.mock.calls.map(([request]) => request.paymentCode)).toContain(missing.paymentCode);
  }, 60_000);

  it("refund đứng yên ở APPROVED quá 30 phút → xếp hàng lại đúng jobId của lần gửi; refund mới tạo thì chưa", async () => {
    const order = await overduePayment();
    answers.set(order.paymentCode, { status: "SUCCESS", providerTxnId: `T${tag}9`, amount: 300_000n, resultCode: "00" });
    await reconcilePayments(prisma, gateways, qr, refunds);
    const payment = await prisma.withSystem((tx) => tx.payment.findUniqueOrThrow({ where: { paymentCode: order.paymentCode }, select: { id: true } }));
    const [stuck, fresh] = await prisma.withTenant(operatorId, async (tx) => [
      await tx.refund.create({ data: { refundCode: `RFD${tag.toUpperCase().replace(/[^A-Z0-9]/g, "0").padEnd(8, "0").slice(0, 8)}AAAA`, operatorId, bookingId: order.bookingId, paymentId: payment.id, status: "APPROVED", amount: 1_000n, refundPercent: 100, reason: "test", requestedBy: "system", attempt: 2 } }),
      await tx.refund.create({ data: { refundCode: `RFD${tag.toUpperCase().replace(/[^A-Z0-9]/g, "0").padEnd(8, "0").slice(0, 8)}BBBB`, operatorId, bookingId: order.bookingId, paymentId: payment.id, status: "APPROVED", amount: 1_000n, refundPercent: 100, reason: "test", requestedBy: "system" } }),
    ]);
    await prisma.withSystem((tx) => tx.$executeRaw`UPDATE refunds SET updated_at = now() - interval '1 hour' WHERE id = ${stuck!.id}`);
    refundAdd.mockClear();
    const run = await reconcilePayments(prisma, gateways, qr, refunds);
    const jobIds = (refundAdd.mock.calls as unknown as [string, { refundId: string }, { jobId: string }][]).map(([, data, options]) => [data.refundId, options.jobId]);
    expect(jobIds).toContainEqual([stuck!.id, `${stuck!.id}-2`]);
    expect(jobIds.map(([id]) => id)).not.toContain(fresh!.id);
    expect(run.refundsRequeued).toBeGreaterThanOrEqual(1);
  }, 60_000);
});
