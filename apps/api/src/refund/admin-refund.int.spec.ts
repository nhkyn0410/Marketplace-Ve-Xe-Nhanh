import { randomUUID } from "node:crypto";
import type { Queue } from "bullmq";
import Redis from "ioredis";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { type AuditEventInput, AuditService, AuditWriteError } from "../audit/audit.service";
import { BookingService } from "../booking/booking.service";
import { BookingInputSchema } from "../booking/dto/booking.dto";
import { parseAppConfig } from "../config/env.config";
import { platformScope, tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { NotificationDispatcher } from "../notification/notification-dispatcher";
import { PaymentGatewayError, type PaymentGateway, type PaymentGateways, type RefundRequest } from "../external/payment/payment-gateway";
import type { Coordinates, RouteLeg, RoutingProvider } from "../external/routing/routing-provider";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { AdminPaymentService } from "../payment/admin-payment.service";
import { applyPaymentCallback, type PaymentCallbackJob } from "../payment/payment-callback";
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
import { AdminRefundService } from "./admin-refund.service";
import { CancellationService } from "./cancellation.service";
import { processRefund } from "./refund-processing";

/**
 * TASK-ADM-002 — Thanh toán & hoàn tiền phía Admin trên Postgres + Redis THẬT (role app): giám sát thanh toán (lọc, phân bổ
 * theo sổ giữ hộ), thanh toán trùng cần đối soát → hoàn toàn bộ (không đụng booking / sổ / kỳ chi trả), refund thất bại →
 * gửi lại cổng (mã yêu cầu mới) / ghi nhận đã hoàn ngoài cổng, thao tác đồng thời chỉ thắng một, audit lỗi → 503.
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

describe.skipIf(!ready && !requireDb)("Thanh toán & hoàn tiền phía Admin — Postgres + Redis thật (ADM-002)", () => {
  let prisma: PrismaService;
  let redis: Redis;
  let holds: SeatHoldService;
  let bookings: BookingService;
  let cancellations: CancellationService;
  let trips: TripService;
  let payments: AdminPaymentService;
  let refunds: AdminRefundService;
  const events: AuditEventInput[] = [];
  const recordAuditEvent = vi.fn(async (event: AuditEventInput) => void events.push(event));
  const dispatch = vi.fn(async (_keys: string[]) => undefined);
  const dispatcher = { dispatch } as unknown as NotificationDispatcher;
  const add = vi.fn(async (_name: string, _data: { refundId: string }, _options: { jobId: string }) => undefined);
  const queue = { add } as unknown as Queue;
  const refund = vi.fn(async (_request: RefundRequest) => ({ providerRefundId: `RF${Math.floor(Math.random() * 1e8)}` }));
  const vnpay = { provider: "VNPAY", refund } as unknown as PaymentGateway;
  const gateways: PaymentGateways = new Map<PaymentGateway["provider"], PaymentGateway>([["VNPAY", vnpay]]);
  const qr = new TicketQrSigner(Buffer.alloc(32, 6));
  const tag = randomUUID().slice(0, 8);
  const operatorId = randomUUID();
  const province = randomUUID();
  const ward = randomUUID();
  const points = [randomUUID(), randomUUID(), randomUUID()];
  const vehicleType = randomUUID();
  const adminActor = { sub: randomUUID(), role: "PLATFORM_ADMIN" } as VerifiedAccessToken;
  const platformAuthz: Authorization = { permission: "refund:manage", scope: "any", db: platformScope() };
  const tenantAuthz: Authorization = { permission: "trip:manage", scope: "tenant", db: tenantScope(operatorId) };
  let routeId: string;
  let seatMapId: string;

  const newPaymentCode = () => `PAY${randomUUID().replace(/-/g, "").slice(0, 12).toUpperCase()}`;
  const callback = (paymentCode: string, amount = "600000"): PaymentCallbackJob => ({
    provider: "VNPAY",
    paymentCode,
    providerTxnId: `T${randomUUID().slice(0, 10)}`,
    amount,
    success: true,
    resultCode: "00",
    fields: {},
  });

  /** Booking 2 chỗ (300.000đ / chỗ) đã thanh toán qua callback thật — sổ giữ hộ ghi thu tiền + hoa hồng 4%. */
  async function paidBooking() {
    const vehicle = await new VehicleService(prisma, {} as never).create(
      tenantAuthz,
      VehicleInputSchema.parse({ plateNumber: `51A${10000 + Math.floor(Math.random() * 89999)}`, vehicleTypeId: vehicleType, seatMapId, amenityIds: [], status: "ACTIVE", description: null }),
    );
    const departureAt = new Date(Date.now() + 48 * HOUR);
    const trip = await trips.create(
      tenantAuthz,
      TripInputSchema.parse({
        routeId,
        vehicleId: vehicle.id,
        departureAt: departureAt.toISOString(),
        arrivalAt: new Date(departureAt.getTime() + 6 * HOUR).toISOString(),
        stopTimes: null,
        onlineSaleCutoffMinutes: 60,
        note: null,
      }),
    );
    await prisma.withSystem((tx) => tx.trip.update({ where: { id: trip.id }, data: { status: "OPEN_FOR_SALE" } }));
    const hold = await holds.create(null, undefined, SeatHoldInputSchema.parse({ tripId: trip.id, seatCodes: ["A1", "A2"], pickupSequence: 1, dropoffSequence: 3 }));
    const created = await bookings.create(
      null,
      BookingInputSchema.parse({
        holdId: hold.holdId,
        contact: { fullName: "Nguyễn Văn Khánh", phone: "0901234567", email: "k@example.com" },
        passengers: ["A1", "A2"].map((seatCode) => ({ seatCode, fullName: `Khách ${seatCode}`, phone: null })),
        note: null,
        expectedTotal: 600_000,
      }),
    );
    const paymentCode = newPaymentCode();
    await prisma.withTenant(operatorId, async (tx) => {
      await tx.payment.create({ data: { paymentCode, operatorId, bookingId: created.bookingId, provider: "VNPAY", status: "PROCESSING", amount: 600_000n, expiresAt: new Date(Date.now() + 600_000) } });
      const booking = await tx.booking.findUniqueOrThrow({ where: { id: created.bookingId }, select: { snapshot: true } });
      await tx.booking.update({
        where: { id: created.bookingId },
        data: { snapshot: { ...(booking.snapshot as object), cancellationPolicy: { tiers: [{ minHoursBefore: 24, refundPercent: 90 }, { minHoursBefore: 0, refundPercent: 0 }] } } },
      });
    });
    expect(await applyPaymentCallback(prisma, callback(paymentCode), qr)).toBe("SUCCESS");
    const payment = await prisma.withSystem((tx) => tx.payment.findUniqueOrThrow({ where: { paymentCode }, select: { id: true } }));
    const view = await bookings.get(null, created.bookingId, created.accessToken);
    return { ...view, accessToken: created.accessToken, paymentId: payment.id };
  }

  /** Thanh toán thứ hai cho cùng booking, cổng báo thành công → cần đối soát (trả trùng / lệch tiền). */
  async function extraPayment(bookingId: string, amount = "600000") {
    const paymentCode = newPaymentCode();
    await prisma.withTenant(operatorId, (tx) =>
      tx.payment.create({ data: { paymentCode, operatorId, bookingId, provider: "VNPAY", status: "PROCESSING", amount: 600_000n, expiresAt: new Date(Date.now() + 600_000) } }),
    );
    expect(await applyPaymentCallback(prisma, callback(paymentCode, amount), qr)).toBe("RECONCILING");
    return prisma.withSystem((tx) => tx.payment.findUniqueOrThrow({ where: { paymentCode }, select: { id: true, paymentCode: true } }));
  }

  /** Hủy vé theo chính sách (90%) rồi worker gọi cổng bị từ chối dứt khoát → refund `FAILED`. */
  async function failedRefund(booking: Awaited<ReturnType<typeof paidBooking>>, ticketIds: string[]) {
    const quote = await cancellations.quote(null, booking.bookingId, booking.accessToken, ticketIds);
    const result = await cancellations.cancel(null, booking.bookingId, booking.accessToken, { ticketIds, expectedRefund: quote.refundAmount, reason: null });
    const refundRow = await prisma.withSystem((tx) => tx.refund.findUniqueOrThrow({ where: { refundCode: result.refund!.refundCode }, select: { id: true, refundCode: true } }));
    refund.mockRejectedValueOnce(new PaymentGatewayError("Giao dịch không đủ điều kiện hoàn", false, "91"));
    expect(await processRefund(prisma, gateways, refundRow.id, { finalAttempt: false })).toBe("FAILED");
    return { ...refundRow, amount: quote.refundAmount };
  }

  const state = (bookingId: string) =>
    prisma.withSystem((tx) =>
      tx.booking.findUniqueOrThrow({
        where: { id: bookingId },
        select: { status: true, tickets: { orderBy: { ticketCode: "asc" }, select: { status: true } } },
      }),
    );
  const ledger = (bookingId: string) =>
    prisma.withSystem((tx) => tx.escrowLedger.findMany({ where: { bookingId }, orderBy: [{ createdAt: "asc" }, { entryType: "asc" }], select: { entryType: true, amount: true } }));

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    redis = new Redis(getRedisUrl(), createRequestRedisClientOptions("admin-refund-test"));
    holds = new SeatHoldService(prisma, redis);
    bookings = new BookingService(prisma, holds, qr);
    cancellations = new CancellationService(prisma, bookings, { add: vi.fn(async () => undefined) } as unknown as Queue, { dispatch: vi.fn(async () => undefined) } as unknown as NotificationDispatcher);
    trips = new TripService(prisma, {} as AuditService);
    payments = new AdminPaymentService(prisma);
    refunds = new AdminRefundService(prisma, { recordAuditEvent } as unknown as AuditService, queue, dispatcher);
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.create({ data: { id: operatorId, operatorSlug: `ar-${tag}`, displayName: `Nhà xe ${tag}` } });
      // Mức riêng 4% để không phụ thuộc mức mặc định đang có trong DB dev.
      await tx.commissionRule.create({ data: { operatorId, rateBps: 400, effectiveFrom: new Date(Date.now() - DAY), reason: "test" } });
      await tx.province.create({ data: { id: province, code: `ap-${tag}`, name: "Tỉnh" } });
      await tx.ward.create({ data: { id: ward, provinceId: province, code: `aw-${tag}`, name: "Phường" } });
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
      await tx.vehicleType.create({ data: { id: vehicleType, code: `AR-${tag}`, name: "Giường", form: "SLEEPER", class: "STANDARD" } });
    });
    routeId = (
      await new RouteService(prisma, new FakeRouting()).create(
        tenantAuthz,
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
        tenantAuthz,
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
  });

  it("giám sát thanh toán: lọc theo nhà xe / trạng thái / mã / ngày; chi tiết phân bổ theo sổ (hoa hồng 4% BIGINT), vé, callback của cổng, tên khách đã che", async () => {
    const booking = await paidBooking();
    const mine = await payments.list(platformAuthz, { operatorId, limit: 20 });
    expect(mine.items.find((item) => item.paymentId === booking.paymentId)).toMatchObject({ bookingCode: booking.bookingCode, status: "SUCCESS", amount: 600_000, provider: "VNPAY", reconcileResolved: false });
    expect(mine.total).toBeGreaterThanOrEqual(1);
    const byCode = await payments.list(platformAuthz, { q: booking.bookingCode.toLowerCase(), limit: 20 });
    expect(byCode.items.map((item) => item.paymentId)).toEqual([booking.paymentId]);
    expect(byCode.total).toBe(1);
    expect((await payments.list(platformAuthz, { operatorId, status: "FAILED", limit: 20 })).items).toEqual([]);
    const tomorrow = new Date(Date.now() + 7 * HOUR + DAY).toISOString().slice(0, 10);
    expect((await payments.list(platformAuthz, { operatorId, from: tomorrow, limit: 20 })).items).toEqual([]);

    const detail = await payments.get(platformAuthz, booking.paymentId);
    expect(detail).toMatchObject({
      status: "SUCCESS",
      amountMatches: true,
      allocation: { commissionAmount: 24_000, commissionRateBps: 400, operatorNet: 576_000 },
      booking: { contactName: "Nguyễn Văn K***", seatCodes: ["A1", "A2"], subtotal: 600_000, serviceFee: 0, total: 600_000, status: "CONFIRMED" },
      canRefund: false,
      refunds: [],
    });
    expect(detail.tickets.map((ticket) => ticket.seatCode)).toEqual(["A1", "A2"]);
    expect(detail.ledger.map((entry) => [entry.entryType, entry.amount])).toEqual([
      ["PAYMENT_CAPTURED", 600_000],
      ["COMMISSION", -24_000],
    ]);
    expect(detail.histories.some((history) => history.actor === "Cổng VNPay" && history.toStatus === "SUCCESS")).toBe(true);
    expect(detail.lastCallbackAt).not.toBeNull();
    expect(await rejectionOf(payments.get(platformAuthz, randomUUID()))).toMatchObject({ status: 404, code: "PAYMENT_NOT_FOUND" });
  });

  it("thanh toán trùng → cần đối soát; hoàn toàn bộ → refund 100% APPROVED + job + audit; worker hoàn xong: booking vẫn CONFIRMED, sổ giữ hộ không đổi; hoàn lần nữa → 409; lệch số tiền → 409", async () => {
    const booking = await paidBooking();
    const duplicate = await extraPayment(booking.bookingId);
    const open = await payments.list(platformAuthz, { operatorId, reconcile: "open", limit: 20 });
    expect(open.items.map((item) => item.paymentId)).toEqual([duplicate.id]);
    expect(open.reconcileOpen).toBeGreaterThanOrEqual(1);
    expect(await payments.get(platformAuthz, duplicate.id)).toMatchObject({ status: "RECONCILING", reconcileReason: "DUPLICATE_PAYMENT", allocation: null, tickets: [], canRefund: true });

    add.mockClear();
    const created = await refunds.refundPayment(platformAuthz, adminActor, duplicate.id, "Khách trả hai lần cho cùng đơn");
    expect(created).toMatchObject({ status: "APPROVED", amount: 600_000, refundPercent: 100, source: "PLATFORM", paymentStatus: "RECONCILING", paidAmount: 600_000, tickets: [] });
    expect(add).toHaveBeenCalledWith("refund", { refundId: created.refundId }, expect.objectContaining({ jobId: created.refundId }));
    expect(events.at(-1)).toMatchObject({ action: "payment.reconcile_refund", targetType: "refund", targetId: created.refundId, operatorId });
    expect((await state(booking.bookingId)).status).toBe("CONFIRMED");
    expect((await payments.list(platformAuthz, { operatorId, reconcile: "open", limit: 20 })).items).toEqual([]);
    expect(await payments.get(platformAuthz, duplicate.id)).toMatchObject({ reconcileResolved: true, canRefund: false });
    expect(await rejectionOf(refunds.refundPayment(platformAuthz, adminActor, duplicate.id, "Lần hai"))).toMatchObject({ status: 409, code: "REFUND_STATUS_INVALID" });
    expect(await rejectionOf(refunds.refundPayment(platformAuthz, adminActor, booking.paymentId, "Không phải cần đối soát"))).toMatchObject({ status: 409, code: "REFUND_STATUS_INVALID" });

    expect(await processRefund(prisma, gateways, created.refundId, { finalAttempt: false })).toBe("SUCCESS");
    expect((await refunds.get(platformAuthz, created.refundId)).status).toBe("SUCCESS");
    expect(await state(booking.bookingId)).toEqual({ status: "CONFIRMED", tickets: [{ status: "VALID" }, { status: "VALID" }] });
    // Tiền trả trùng chưa từng vào sổ giữ hộ → không ghi bút toán hoàn.
    expect((await ledger(booking.bookingId)).map((entry) => entry.entryType)).toEqual(["PAYMENT_CAPTURED", "COMMISSION"]);

    const mismatch = await extraPayment(booking.bookingId, "500000");
    expect(await payments.get(platformAuthz, mismatch.id)).toMatchObject({ reconcileReason: "AMOUNT_MISMATCH", amountMatches: false, canRefund: false });
    expect(await rejectionOf(refunds.refundPayment(platformAuthz, adminActor, mismatch.id, "Lệch tiền"))).toMatchObject({ status: 409, code: "REFUND_STATUS_INVALID" });
    expect(await rejectionOf(refunds.refundPayment(platformAuthz, adminActor, randomUUID(), "Không có"))).toMatchObject({ status: 404, code: "PAYMENT_NOT_FOUND" });
  });

  it("refund thất bại → gửi lại cổng: FAILED → APPROVED lần 2, booking REFUND_PENDING, job mới; worker gửi mã yêu cầu mới (…R2) → hoàn xong, sổ ghi hoàn; gửi lại khi không còn FAILED → 409", async () => {
    const booking = await paidBooking();
    const failed = await failedRefund(booking, [booking.tickets[0]!.ticketId]);
    expect(failed.amount).toBe(270_000);
    expect((await state(booking.bookingId)).status).toBe("REFUND_FAILED");
    const list = await refunds.list(platformAuthz, { operatorId, status: "FAILED", limit: 20 });
    expect(list.items.find((item) => item.refundId === failed.id)).toMatchObject({ source: "CUSTOMER", amount: 270_000, refundPercent: 90, failureCode: "91" });
    expect((await refunds.list(platformAuthz, { operatorId, source: "PLATFORM", status: "FAILED", limit: 20 })).items).toEqual([]);
    expect(await refunds.get(platformAuthz, failed.id)).toMatchObject({ canRetry: true, canResolve: true, attempt: 1, paymentStatus: "SUCCESS" });

    add.mockClear();
    const retried = await refunds.retry(platformAuthz, adminActor, failed.id, "Cổng đã hoạt động lại");
    expect(retried).toMatchObject({ status: "APPROVED", attempt: 2, failureCode: null, canRetry: false });
    expect(retried.histories.at(-1)).toMatchObject({ fromStatus: "FAILED", toStatus: "APPROVED", reason: "Cổng đã hoạt động lại", actor: "Vé Xe Nhanh" });
    expect(add).toHaveBeenCalledWith("refund", { refundId: failed.id }, expect.objectContaining({ jobId: `${failed.id}-2` }));
    expect(events.at(-1)).toMatchObject({ action: "refund.retry", targetId: failed.id, before: { status: "FAILED", attempt: 1 }, after: { status: "APPROVED", attempt: 2 } });
    expect((await state(booking.bookingId)).status).toBe("REFUND_PENDING");

    refund.mockClear();
    expect(await processRefund(prisma, gateways, failed.id, { finalAttempt: false })).toBe("SUCCESS");
    expect(refund.mock.calls[0]![0]).toMatchObject({ refundCode: `${failed.refundCode}R2`, amount: 270_000n });
    expect(await state(booking.bookingId)).toEqual({ status: "PARTIALLY_CANCELLED", tickets: [{ status: "REFUNDED" }, { status: "VALID" }] });
    expect((await ledger(booking.bookingId)).map((entry) => [entry.entryType, entry.amount])).toEqual(
      expect.arrayContaining([
        ["REFUND", -270_000n],
        ["COMMISSION_REVERSAL", 10_800n],
      ]),
    );
    expect(await rejectionOf(refunds.retry(platformAuthz, adminActor, failed.id, "Lần nữa"))).toMatchObject({ status: 409, code: "REFUND_STATUS_INVALID" });
  });

  it("ghi nhận đã hoàn ngoài cổng: audit lỗi → 503 không đổi gì; hai Admin cùng ghi nhận → đúng một thành công; SUCCESS + mã tham chiếu, vé REFUNDED, sổ ghi hoàn, booking REFUNDED; refund không có → 404", async () => {
    const booking = await paidBooking();
    const failed = await failedRefund(booking, booking.tickets.map((ticket) => ticket.ticketId));
    expect(failed.amount).toBe(540_000);

    recordAuditEvent.mockRejectedValueOnce(new AuditWriteError(new Error("mongo down")));
    expect(await rejectionOf(refunds.resolve(platformAuthz, adminActor, failed.id, { reference: "FT26291000001", reason: "Đã chuyển khoản tay" }))).toMatchObject({ status: 503 });
    expect((await refunds.get(platformAuthz, failed.id)).status).toBe("FAILED");
    expect((await ledger(booking.bookingId)).map((entry) => entry.entryType)).toEqual(["PAYMENT_CAPTURED", "COMMISSION"]);

    const results = await Promise.allSettled([
      refunds.resolve(platformAuthz, adminActor, failed.id, { reference: "FT26291000002", reason: "Đã chuyển khoản tay" }),
      refunds.retry(platformAuthz, adminActor, failed.id, "Gửi lại"),
    ]);
    expect(results.filter((result) => result.status === "fulfilled")).toHaveLength(1);
    const winner = (results.find((result) => result.status === "fulfilled") as PromiseFulfilledResult<{ status: string }>).value;
    const loser = results.find((result) => result.status === "rejected") as PromiseRejectedResult;
    expect(await rejectionOf(Promise.reject(loser.reason))).toMatchObject({ status: 409, code: "REFUND_STATUS_INVALID" });

    if (winner.status === "APPROVED") {
      // Gửi lại thắng: để worker chạy thất bại lần nữa rồi ghi nhận tay.
      refund.mockRejectedValueOnce(new PaymentGatewayError("Từ chối", false, "91"));
      expect(await processRefund(prisma, gateways, failed.id, { finalAttempt: false })).toBe("FAILED");
      await refunds.resolve(platformAuthz, adminActor, failed.id, { reference: "FT26291000002", reason: "Đã chuyển khoản tay" });
    }
    const resolved = await refunds.get(platformAuthz, failed.id);
    expect(resolved).toMatchObject({ status: "SUCCESS", bankReference: "FT26291000002", canRetry: false, canResolve: false });
    expect(resolved.processedAt).not.toBeNull();
    expect(events.at(-1)).toMatchObject({ action: "refund.resolve_manual", targetId: failed.id, reason: "Đã chuyển khoản tay", after: { status: "SUCCESS", bankReference: "FT26291000002" } });
    expect(await state(booking.bookingId)).toEqual({ status: "REFUNDED", tickets: [{ status: "REFUNDED" }, { status: "REFUNDED" }] });
    expect((await ledger(booking.bookingId)).map((entry) => [entry.entryType, entry.amount])).toEqual(
      expect.arrayContaining([
        ["REFUND", -540_000n],
        ["COMMISSION_REVERSAL", 21_600n],
      ]),
    );
    expect(await rejectionOf(refunds.resolve(platformAuthz, adminActor, failed.id, { reference: "FT1", reason: "Lần nữa" }))).toMatchObject({ status: 409 });
    expect(await rejectionOf(refunds.get(platformAuthz, randomUUID()))).toMatchObject({ status: 404, code: "REFUND_NOT_FOUND" });
  });
});
