import { randomUUID } from "node:crypto";
import type { Queue } from "bullmq";
import Redis from "ioredis";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { type AuditEventInput, AuditService, AuditWriteError } from "../audit/audit.service";
import { BookingService } from "../booking/booking.service";
import { BookingInputSchema } from "../booking/dto/booking.dto";
import { parseAppConfig } from "../config/env.config";
import { tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import { EmailUnavailableError, type EmailNotifier, type TransactionalEmailMessage } from "../external/notification/email-notifier";
import type { PaymentGateway, PaymentGateways } from "../external/payment/payment-gateway";
import type { Coordinates, RouteLeg, RoutingProvider } from "../external/routing/routing-provider";
import type { Authorization } from "../iam/role/authorization";
import { deliverNotification } from "../notification/notification-delivery";
import type { NotificationDispatcher } from "../notification/notification-dispatcher";
import { applyPaymentCallback, type PaymentCallbackJob } from "../payment/payment-callback";
import { createRequestRedisClientOptions, getRedisUrl } from "../redis/redis.config";
import { processRefund } from "../refund/refund-processing";
import { RouteInputSchema } from "../route/dto/route.dto";
import { RouteService } from "../route/route.service";
import { SeatHoldInputSchema } from "../seat-hold/dto/seat-hold.dto";
import { SeatHoldService } from "../seat-hold/seat-hold.service";
import { TicketQrSigner } from "../ticket/ticket-qr";
import { SeatMapInputSchema } from "../vehicle/dto/seat-map.dto";
import { VehicleInputSchema } from "../vehicle/dto/vehicle.dto";
import { SeatMapService } from "../vehicle/seat-map.service";
import { VehicleService } from "../vehicle/vehicle.service";
import { TripChangeInputSchema, type TripChangeInput } from "./dto/trip-change.dto";
import { TripInputSchema } from "./dto/trip.dto";
import { TripChangeService } from "./trip-change.service";
import { TripService } from "./trip.service";

/**
 * TASK-TRN-008 + TASK-NSR-001 trên Postgres + Redis THẬT (role app): đổi giờ / xe / điểm dừng của chuyến đã bán (lý do, lịch sử
 * trước / sau, thông báo từng đơn bị ảnh hưởng, đơn thấy thay đổi), đổi xe phải giữ chỗ đã bán (BR-20), hủy chuyến có vé (hủy đơn
 * chờ thanh toán, hoàn 100% giá vé, sổ giữ hộ trả toàn bộ hoa hồng), hai lần hủy đồng thời chỉ một, audit lỗi → 503; gửi email
 * thông báo (SENT / SKIPPED / thử lại / FAILED / chạy lặp).
 */
const url = process.env.DATABASE_URL;
const ready = Boolean(url && process.env.REDIS_URL);
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
const HOUR = 3_600_000;
const DAY = 24 * HOUR;

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

describe.skipIf(!ready && !requireDb)("Đổi / hủy chuyến đã bán vé + thông báo — Postgres + Redis thật (TRN-008, NSR-001)", () => {
  let prisma: PrismaService;
  let redis: Redis;
  let holds: SeatHoldService;
  let bookings: BookingService;
  let trips: TripService;
  let changes: TripChangeService;
  const events: AuditEventInput[] = [];
  const recordAuditEvent = vi.fn(async (event: AuditEventInput) => void events.push(event));
  const refundJobs = { add: vi.fn(async (_name: string, _data: { refundId: string }) => undefined) };
  const dispatch = vi.fn(async (_keys: string[]) => undefined);
  const refund = vi.fn(async () => ({ providerRefundId: `RF${Math.floor(Math.random() * 1e8)}` }));
  const gateways: PaymentGateways = new Map<PaymentGateway["provider"], PaymentGateway>([["VNPAY", { provider: "VNPAY", refund } as unknown as PaymentGateway]]);
  const qr = new TicketQrSigner(Buffer.alloc(32, 7));
  const tag = randomUUID().slice(0, 8);
  const operatorId = randomUUID();
  const province = randomUUID();
  const ward = randomUUID();
  // 0 bến đầu, 1 trạm dừng nghỉ, 2 bến cuối, 3 bến thay thế, 4 trạm dừng nghỉ khác.
  const points = [randomUUID(), randomUUID(), randomUUID(), randomUUID(), randomUUID()];
  const vehicleType = randomUUID();
  const actor = { sub: randomUUID(), role: "OPERATOR_OWNER" };
  const authz: Authorization = { permission: "trip:manage", scope: "tenant", db: tenantScope(operatorId) };
  let routeId: string;
  let sameSeatMap: string;
  let otherSeatMap: string;

  const newVehicle = (seatMapId: string) =>
    new VehicleService(prisma, {} as never).create(
      authz,
      VehicleInputSchema.parse({ plateNumber: `51C${10000 + Math.floor(Math.random() * 89999)}`, vehicleTypeId: vehicleType, seatMapId, amenityIds: [], status: "ACTIVE", description: null }),
    );

  /** Chuyến mở bán sau 48 giờ + đơn 2 chỗ (A1, A2) đã thanh toán qua callback thật (vé, sổ giữ hộ, thông báo vé điện tử). */
  async function soldTrip() {
    const vehicle = await newVehicle(sameSeatMap);
    const departureAt = new Date(Date.now() + 48 * HOUR);
    const trip = await trips.create(
      authz,
      TripInputSchema.parse({ routeId, vehicleId: vehicle.id, departureAt: departureAt.toISOString(), stopTimes: null, onlineSaleCutoffMinutes: 60, note: null }),
    );
    await prisma.withSystem((tx) => tx.trip.update({ where: { id: trip.id }, data: { status: "OPEN_FOR_SALE" } }));
    const paid = await pendingBooking(trip.id, ["A1", "A2"]);
    expect(await applyPaymentCallback(prisma, callback(paid.paymentCode), qr)).toBe("SUCCESS");
    return { tripId: trip.id, vehicleId: vehicle.id, departureAt, booking: paid };
  }

  /** Đơn chờ thanh toán (ghế HOLDING) + payment VNPay đang mở. */
  async function pendingBooking(tripId: string, seatCodes: string[]) {
    const hold = await holds.create(null, undefined, SeatHoldInputSchema.parse({ tripId, seatCodes, pickupSequence: 1, dropoffSequence: 3 }));
    const created = await bookings.create(
      null,
      BookingInputSchema.parse({
        holdId: hold.holdId,
        contact: { fullName: "Khách", phone: "0901234567", email: `k-${randomUUID().slice(0, 6)}@example.com` },
        passengers: seatCodes.map((seatCode) => ({ seatCode, fullName: `Khách ${seatCode}`, phone: null })),
        note: null,
        expectedTotal: 300_000 * seatCodes.length,
      }),
    );
    const paymentCode = `PAY${randomUUID().replace(/-/g, "").slice(0, 12).toUpperCase()}`;
    await prisma.withTenant(operatorId, (tx) =>
      tx.payment.create({ data: { paymentCode, operatorId, bookingId: created.bookingId, provider: "VNPAY", status: "PROCESSING", amount: BigInt(created.total), expiresAt: new Date(Date.now() + 600_000) } }),
    );
    return { ...created, paymentCode };
  }

  const callback = (paymentCode: string, amount = "600000"): PaymentCallbackJob => ({ provider: "VNPAY", paymentCode, providerTxnId: `T${randomUUID().slice(0, 10)}`, amount, success: true, resultCode: "00", fields: {} });

  /** Lịch chạy hiện tại của chuyến dưới dạng body đổi chuyến (rồi ghi đè phần cần đổi). */
  async function currentInput(tripId: string, overrides: Partial<Record<keyof TripChangeInput, unknown>>): Promise<TripChangeInput> {
    const trip = await trips.get(authz, tripId);
    return TripChangeInputSchema.parse({
      departureAt: trip.departureAt,
      stopTimes: null,
      vehicleId: trip.vehicleId,
      stops: trip.stops.map((stop) => ({ sequence: stop.sequence, catalogStopPointId: stop.catalogStopPointId, stopPointId: stop.stopPointId })),
      reason: "Đổi lịch do điều phối",
      ...overrides,
    });
  }

  const notificationsOf = (bookingId: string) =>
    prisma.withSystem((tx) =>
      tx.notification.findMany({
        where: { bookingId },
        orderBy: { createdAt: "asc" },
        select: { kind: true, dedupKey: true, payload: true, tripChangeId: true, deliveries: { select: { id: true, status: true, recipientMasked: true, attempts: true, lastError: true } } },
      }),
    );

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    redis = new Redis(getRedisUrl(), createRequestRedisClientOptions("trip-change-test"));
    holds = new SeatHoldService(prisma, redis);
    bookings = new BookingService(prisma, holds, qr);
    trips = new TripService(prisma, {} as AuditService);
    changes = new TripChangeService(prisma, { recordAuditEvent } as unknown as AuditService, refundJobs as unknown as Queue, { dispatch } as unknown as NotificationDispatcher);
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.create({ data: { id: operatorId, operatorSlug: `tc-${tag}`, displayName: `Nhà xe ${tag}` } });
      await tx.commissionRule.create({ data: { operatorId, rateBps: 400, effectiveFrom: new Date(Date.now() - DAY), reason: "test" } });
      await tx.province.create({ data: { id: province, code: `tp-${tag}`, name: "Tỉnh" } });
      await tx.ward.create({ data: { id: ward, provinceId: province, code: `tw-${tag}`, name: "Phường" } });
      await tx.stopPointCatalog.createMany({
        data: points.map((id, index) => ({
          id,
          name: `Điểm ${index} ${tag}`,
          type: index === 1 || index === 4 ? ("REST_STOP" as const) : ("BUS_STATION" as const),
          legalBasis: index === 1 || index === 4 ? null : "QĐ (test)",
          address: "Địa chỉ",
          provinceId: province,
          wardId: ward,
          latitude: 10 + index,
          longitude: 106,
        })),
      });
      await tx.vehicleType.create({ data: { id: vehicleType, code: `TC-${tag}`, name: "Giường", form: "SLEEPER", class: "STANDARD" } });
    });
    routeId = (
      await new RouteService(prisma, new FakeRouting()).create(
        authz,
        RouteInputSchema.parse({
          name: `Tuyến đổi chuyến ${tag}`,
          status: "ACTIVE",
          note: null,
          stops: points.slice(0, 3).map((point, index) => ({ catalogStopPointId: point, stopPointId: null, note: null, allowPickup: index === 0, allowDropoff: index === 2 })),
        }),
      )
    ).id;
    await prisma.withSystem(async (tx) => {
      const fare = await tx.fare.create({ data: { operatorId, routeId, status: "ACTIVE" } });
      await tx.fareRule.create({ data: { operatorId, fareId: fare.id, price: 300_000n } });
    });
    const seatMap = (name: string, codes: string[]) =>
      new SeatMapService(prisma).create(
        authz,
        SeatMapInputSchema.parse({
          name: `${name} ${tag}`,
          layout: { decks: [{ deck: 1, rows: 2, columns: 2 }] },
          seats: codes.map((code, index) => ({ code, deck: 1, row: Math.floor(index / 2) + 1, column: (index % 2) + 1, type: "BED" })),
        }),
      );
    sameSeatMap = (await seatMap("Sơ đồ A", ["A1", "A2", "A3", "A4"])).id;
    otherSeatMap = (await seatMap("Sơ đồ B", ["B1", "B2", "B3", "B4"])).id;
  }, 60_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      await tx.$executeRaw`SELECT set_config('app.allow_ledger_delete', 'on', true)`;
      await tx.notificationDelivery.deleteMany({ where: { operatorId } });
      await tx.notification.deleteMany({ where: { operatorId } });
      await tx.tripChange.deleteMany({ where: { operatorId } });
      // `generatePayouts` ở payout.int.spec quét mọi nhà xe: chạy song song có thể tạo kỳ chi trả từ bút toán của file này.
      await tx.payoutItem.deleteMany({ where: { operatorId } });
      await tx.escrowLedger.deleteMany({ where: { operatorId } });
      await tx.payoutStatusHistory.deleteMany({ where: { operatorId } });
      await tx.payout.deleteMany({ where: { operatorId } });
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
      await tx.commissionRule.deleteMany({ where: { operatorId } });
      await tx.stopPointCatalog.deleteMany({ where: { provinceId: province } });
      await tx.ward.deleteMany({ where: { provinceId: province } });
      await tx.province.deleteMany({ where: { id: province } });
      await tx.vehicleType.deleteMany({ where: { id: vehicleType } });
      await tx.operatorProfile.deleteMany({ where: { id: operatorId } });
    });
    await prisma.$disconnect();
    redis.disconnect();
  }, 30_000);

  it("đổi giờ chuyến đã bán: lịch sử trước / sau + lý do, báo đơn (TRIP_CHANGED), đơn thấy thay đổi; không đổi gì → 422; có khách đang thanh toán → 409; audit lỗi → 503 không đổi", async () => {
    const { tripId, departureAt, booking } = await soldTrip();
    expect((await notificationsOf(booking.bookingId)).map((item) => item.kind)).toEqual(["BOOKING_CONFIRMED"]);
    expect(await rejectionOf(changes.change(actor, authz, tripId, await currentInput(tripId, {})))).toMatchObject({ status: 422, code: "TRIP_CHANGE_EMPTY" });

    const later = new Date(departureAt.getTime() + HOUR);
    const before = await trips.get(authz, tripId);
    const input = await currentInput(tripId, { departureAt: later.toISOString(), reason: "Tắc đường cao tốc" });
    recordAuditEvent.mockRejectedValueOnce(new AuditWriteError(new Error("mongo down")));
    expect(await rejectionOf(changes.change(actor, authz, tripId, input))).toMatchObject({ status: 503 });
    expect((await trips.get(authz, tripId)).departureAt).toBe(departureAt.toISOString());

    dispatch.mockClear();
    const updated = await changes.change(actor, authz, tripId, input);
    expect(updated.departureAt).toBe(later.toISOString());
    // Giờ đến máy chủ tính theo tuyến: dời theo giờ đi, giữ nguyên thời gian chạy.
    expect(Date.parse(updated.arrivalAt)).toBe(Date.parse(before.arrivalAt) + HOUR);
    expect(updated.stops[0]!.plannedAt).toBe(later.toISOString());
    expect(updated.seats.filter((seat) => seat.status === "BOOKED").map((seat) => seat.code)).toEqual(["A1", "A2"]);
    const sales = await changes.sales(authz, tripId);
    expect(sales).toMatchObject({ soldSeats: 2, holdingSeats: 0, activeBookings: 1, pendingBookings: 0, refundOnCancel: 600_000 });
    expect(sales.changes).toHaveLength(1);
    expect(sales.changes[0]).toMatchObject({ kinds: ["SCHEDULE"], reason: "Tắc đường cao tốc", affectedBookings: 1, before: { departureAt: departureAt.toISOString() }, after: { departureAt: later.toISOString() } });
    const sent = await notificationsOf(booking.bookingId);
    expect(sent.map((item) => item.kind)).toEqual(["BOOKING_CONFIRMED", "TRIP_CHANGED"]);
    expect(sent[1]!.deliveries).toEqual([expect.objectContaining({ status: "PENDING", recipientMasked: expect.stringMatching(/^k\*\*\*@example\.com$/) })]);
    expect(dispatch).toHaveBeenCalledWith([sent[1]!.dedupKey]);
    expect(events.at(-1)).toMatchObject({ action: "trip.sold_change", targetId: tripId, reason: "Tắc đường cao tốc" });
    const view = await bookings.get(null, booking.bookingId, booking.accessToken);
    expect(view.trip.departureAt).toBe(departureAt.toISOString());
    expect(view.tripChanges).toEqual([expect.objectContaining({ kinds: ["SCHEDULE"], reason: "Tắc đường cao tốc", after: expect.objectContaining({ departureAt: later.toISOString() }) })]);

    const pending = await pendingBooking(tripId, ["A3"]);
    expect(await rejectionOf(changes.change(actor, authz, tripId, await currentInput(tripId, { reason: "Đổi lại giờ", departureAt: departureAt.toISOString() })))).toMatchObject({
      status: 409,
      code: "TRIP_CHANGE_NOT_ALLOWED",
    });
    expect(pending.status).toBe("PENDING_PAYMENT");
  }, 30_000);

  it("đổi xe: xe thiếu chỗ đã bán → 409 kèm mã chỗ; xe đủ chỗ → chỗ đã bán giữ đơn; đổi điểm trả → báo đơn trả ở đó; trạm dừng nghỉ ở điểm trả → 422", async () => {
    const { tripId, booking } = await soldTrip();
    const wrong = await newVehicle(otherSeatMap);
    const unmappable = await rejectionOf(changes.change(actor, authz, tripId, await currentInput(tripId, { vehicleId: wrong.id })));
    expect(unmappable).toMatchObject({ status: 409, code: "TRIP_SEATS_UNMAPPABLE", reasons: ["A1", "A2"] });

    const right = await newVehicle(sameSeatMap);
    const moved = await changes.change(actor, authz, tripId, await currentInput(tripId, { vehicleId: right.id, reason: "Xe cũ hỏng điều hoà" }));
    expect(moved.vehicleId).toBe(right.id);
    const seats = await prisma.withSystem((tx) => tx.tripSeat.findMany({ where: { tripId }, orderBy: { seatCode: "asc" }, select: { seatCode: true, status: true, bookingId: true } }));
    expect(seats).toEqual([
      { seatCode: "A1", status: "BOOKED", bookingId: booking.bookingId },
      { seatCode: "A2", status: "BOOKED", bookingId: booking.bookingId },
      { seatCode: "A3", status: "AVAILABLE", bookingId: null },
      { seatCode: "A4", status: "AVAILABLE", bookingId: null },
    ]);

    const trip = await trips.get(authz, tripId);
    const stops = trip.stops.map((stop) => ({ sequence: stop.sequence, catalogStopPointId: stop.catalogStopPointId, stopPointId: stop.stopPointId }));
    const restStop = stops.map((stop) => (stop.sequence === 3 ? { ...stop, catalogStopPointId: points[4]! } : stop));
    expect(await rejectionOf(changes.change(actor, authz, tripId, await currentInput(tripId, { stops: restStop })))).toMatchObject({ status: 422, code: "TRIP_STOPS_INVALID" });
    const newDropoff = stops.map((stop) => (stop.sequence === 3 ? { ...stop, catalogStopPointId: points[3]! } : stop));
    const restopped = await changes.change(actor, authz, tripId, await currentInput(tripId, { stops: newDropoff, reason: "Bến cũ đang sửa" }));
    expect(restopped.stops[2]!.name).toBe(`Điểm 3 ${tag}`);
    const history = (await changes.sales(authz, tripId)).changes;
    expect(history.map((change) => change.kinds)).toEqual([["STOP"], ["VEHICLE"]]);
    expect(history[0]!.affectedBookings).toBe(1);
    expect((await notificationsOf(booking.bookingId)).map((item) => item.kind)).toEqual(["BOOKING_CONFIRMED", "TRIP_CHANGED", "TRIP_CHANGED"]);
  }, 30_000);

  it("hủy chuyến có vé: đơn chờ thanh toán → hủy (payment hủy, ghế trả); vé → hủy + hoàn 100% (sổ trả toàn bộ hoa hồng); báo từng đơn; callback trễ → đối soát; hai lần hủy đồng thời chỉ một", async () => {
    const { tripId, booking } = await soldTrip();
    const pending = await pendingBooking(tripId, ["A3"]);
    refundJobs.add.mockClear();
    dispatch.mockClear();
    const results = await Promise.allSettled([changes.cancel(actor, authz, tripId, "Xe hỏng nặng"), changes.cancel(actor, authz, tripId, "Xe hỏng nặng")]);
    expect(results.filter((result) => result.status === "fulfilled")).toHaveLength(1);
    expect(await rejectionOf(Promise.reject((results.find((result) => result.status === "rejected") as PromiseRejectedResult).reason))).toMatchObject({ status: 409, code: "TRIP_STATUS_TRANSITION_INVALID" });

    const state = await prisma.withSystem((tx) =>
      tx.booking.findMany({
        where: { tripId },
        orderBy: { createdAt: "asc" },
        select: { id: true, status: true, tickets: { select: { status: true } }, refunds: { select: { id: true, status: true, amount: true, refundPercent: true, requestedBy: true } }, payments: { select: { status: true } } },
      }),
    );
    expect(state[0]).toMatchObject({ id: booking.bookingId, status: "REFUND_PENDING", tickets: [{ status: "CANCELLED" }, { status: "CANCELLED" }] });
    expect(state[0]!.refunds).toEqual([expect.objectContaining({ status: "APPROVED", amount: 600_000n, refundPercent: 100, requestedBy: `operator:${actor.sub}` })]);
    expect(state[1]).toMatchObject({ id: pending.bookingId, status: "CANCELLED", payments: [{ status: "CANCELLED" }], refunds: [] });
    expect(refundJobs.add).toHaveBeenCalledTimes(1);
    expect(await prisma.withSystem((tx) => tx.tripSeat.count({ where: { tripId, status: { not: "AVAILABLE" } } }))).toBe(0);
    expect((await changes.sales(authz, tripId)).changes[0]).toMatchObject({ kinds: ["CANCEL"], reason: "Xe hỏng nặng", affectedBookings: 2 });
    const paidNotices = await notificationsOf(booking.bookingId);
    const pendingNotices = await notificationsOf(pending.bookingId);
    expect(paidNotices.at(-1)).toMatchObject({ kind: "TRIP_CANCELLED", payload: { refundAmount: 600_000 } });
    expect(pendingNotices).toEqual([expect.objectContaining({ kind: "TRIP_CANCELLED", payload: { refundAmount: null } })]);
    expect(dispatch).toHaveBeenCalledWith(expect.arrayContaining([paidNotices.at(-1)!.dedupKey, pendingNotices[0]!.dedupKey]));

    expect(await processRefund(prisma, gateways, state[0]!.refunds[0]!.id, { finalAttempt: false })).toBe("SUCCESS");
    const ledger = await prisma.withSystem((tx) => tx.escrowLedger.findMany({ where: { bookingId: booking.bookingId }, select: { entryType: true, amount: true } }));
    expect(ledger.reduce((sum, entry) => sum + entry.amount, 0n)).toBe(0n);
    expect((await prisma.withSystem((tx) => tx.booking.findUniqueOrThrow({ where: { id: booking.bookingId }, select: { status: true } }))).status).toBe("REFUNDED");
    expect(await applyPaymentCallback(prisma, callback(pending.paymentCode, "300000"), qr)).toBe("RECONCILING");
    expect((await prisma.withSystem((tx) => tx.payment.findUniqueOrThrow({ where: { paymentCode: pending.paymentCode }, select: { reconcileReason: true } }))).reconcileReason).toBe("BOOKING_CANCELLED");
    expect(await rejectionOf(changes.change(actor, authz, tripId, await currentInput(tripId, { reason: "Thử đổi chuyến đã hủy" })))).toMatchObject({ status: 409, code: "TRIP_CHANGE_NOT_ALLOWED" });
  }, 30_000);

  it("gửi email thông báo: SENT kèm nội dung; chạy lặp → ALREADY_DONE; chưa cấu hình kênh → SKIPPED; lỗi tạm thời thử lại, lần cuối FAILED", async () => {
    const { booking } = await soldTrip();
    const [confirmed] = await notificationsOf(booking.bookingId);
    const deliveryId = confirmed!.deliveries[0]!.id;
    const sentMessages: TransactionalEmailMessage[] = [];
    const notifier: EmailNotifier = { sendOtp: vi.fn(), sendTransactional: vi.fn(async (message: TransactionalEmailMessage) => void sentMessages.push(message)) };
    const systemLogs: unknown[] = [];
    const audit = { recordSystemLog: vi.fn(async (entry: unknown) => void systemLogs.push(entry)) };
    expect(await deliverNotification(prisma, notifier, audit, deliveryId, { finalAttempt: false })).toBe("SENT");
    expect(sentMessages[0]).toMatchObject({ subject: expect.stringContaining(booking.bookingCode), logLabel: "BOOKING_CONFIRMED" });
    expect(sentMessages[0]!.email).toMatch(/@example\.com$/);
    expect(sentMessages[0]!.lines.join(" ")).toContain(`${booking.bookingCode}-01`);
    expect(systemLogs[0]).toMatchObject({ source: "notification", event: "notification.sent", context: { deliveryId, kind: "BOOKING_CONFIRMED" } });
    expect(JSON.stringify(systemLogs)).not.toContain("@example.com");
    expect(await deliverNotification(prisma, notifier, audit, deliveryId, { finalAttempt: false })).toBe("ALREADY_DONE");
    expect((await notificationsOf(booking.bookingId))[0]!.deliveries[0]).toMatchObject({ status: "SENT", attempts: 1 });

    const second = await soldTrip();
    const secondId = (await notificationsOf(second.booking.bookingId))[0]!.deliveries[0]!.id;
    const unavailable: EmailNotifier = { sendOtp: vi.fn(), sendTransactional: vi.fn(async () => Promise.reject(new EmailUnavailableError())) };
    expect(await deliverNotification(prisma, unavailable, null, secondId, { finalAttempt: false })).toBe("SKIPPED");

    const third = await soldTrip();
    const thirdId = (await notificationsOf(third.booking.bookingId))[0]!.deliveries[0]!.id;
    const flaky: EmailNotifier = { sendOtp: vi.fn(), sendTransactional: vi.fn(async () => Promise.reject(new Error("Resend 503"))) };
    await expect(deliverNotification(prisma, flaky, null, thirdId, { finalAttempt: false })).rejects.toThrow("Resend 503");
    expect((await notificationsOf(third.booking.bookingId))[0]!.deliveries[0]).toMatchObject({ status: "PENDING", attempts: 1, lastError: "Resend 503" });
    expect(await deliverNotification(prisma, flaky, null, thirdId, { finalAttempt: true })).toBe("FAILED");
    expect((await notificationsOf(third.booking.bookingId))[0]!.deliveries[0]).toMatchObject({ status: "FAILED", attempts: 2 });
  });
});
