import { createHash, randomUUID } from "node:crypto";
import type { Queue } from "bullmq";
import Redis from "ioredis";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import type { AuditService } from "../audit/audit.service";
import { expireOverdueBookings } from "../booking/booking-expiry";
import { BookingService } from "../booking/booking.service";
import { BookingInputSchema } from "../booking/dto/booking.dto";
import { type AppConfig, parseAppConfig } from "../config/env.config";
import { tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { EmailNotifier, OtpEmailMessage } from "../external/notification/email-notifier";
import { PaymentGatewayError, type PaymentGateway, type PaymentGateways } from "../external/payment/payment-gateway";
import type { Coordinates, RouteLeg, RoutingProvider } from "../external/routing/routing-provider";
import { sign, signedQuery, VnpayGateway } from "../external/payment/vnpay/vnpay-gateway";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { createRequestRedisClientOptions, getRedisUrl } from "../redis/redis.config";
import { RouteInputSchema } from "../route/dto/route.dto";
import { RouteService } from "../route/route.service";
import { SeatHoldInputSchema } from "../seat-hold/dto/seat-hold.dto";
import { SeatHoldService } from "../seat-hold/seat-hold.service";
import { TripInputSchema } from "../trip/dto/trip.dto";
import { TripService } from "../trip/trip.service";
import { SeatMapInputSchema } from "../vehicle/dto/seat-map.dto";
import { VehicleInputSchema } from "../vehicle/dto/vehicle.dto";
import { SeatMapService } from "../vehicle/seat-map.service";
import { VehicleService } from "../vehicle/vehicle.service";
import { issueTickets } from "../ticket/ticket-issuer";
import { TicketQrSigner } from "../ticket/ticket-qr";
import { TicketService } from "../ticket/ticket.service";
import { TicketLookupInputSchema, TicketLookupOtpInputSchema, TicketLookupVerifyInputSchema } from "../ticket/dto/ticket.dto";
import { applyPaymentCallback, type PaymentCallbackJob } from "./payment-callback";
import { PaymentService } from "./payment.service";
import { PaymentWebhookService } from "./payment-webhook.service";

/**
 * TASK-BTP-003 — payment trên Postgres + Redis THẬT (role app): adapter VNPay thật (khóa test), cổng MoMo giả; IPN ký
 * thật → webhook xếp hàng (hàng đợi giả bắt job) → xử lý callback như worker. Tiền / idempotency / RLS bắt buộc (ADR-025).
 */
const url = process.env.DATABASE_URL;
const ready = Boolean(url && process.env.REDIS_URL);
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
// const HOUR = 3_600_000;

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

describe.skipIf(!ready && !requireDb)("Thanh toán — Postgres + Redis thật (BTP-003)", () => {
  let prisma: PrismaService;
  let redis: Redis;
  let holds: SeatHoldService;
  let bookings: BookingService;
  let payments: PaymentService;
  let webhooks: PaymentWebhookService;
  let trips: TripService;
  let tickets: TicketService;
  const jobs: PaymentCallbackJob[] = [];
  const qr = new TicketQrSigner(Buffer.alloc(32, 7));
  const queue = { add: vi.fn(async (_name: string, data: PaymentCallbackJob) => void jobs.push(data)) } as unknown as Queue;
  const vnpayConfig = { tmnCode: "TESTTMN1", hashSecret: "bi-mat-vnpay-test", paymentUrl: "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html", apiUrl: "https://sandbox.vnpayment.vn/merchant_webapi/api/transaction" };
  const momoCheckout = vi.fn(async () => ({ paymentUrl: "https://momo.example/pay" }));
  const momo = { provider: "MOMO", minAmount: 1_000n, maxAmount: 50_000_000n, createCheckout: momoCheckout, verifyCallback: () => null } as unknown as PaymentGateway;
  const gateways: PaymentGateways = new Map<PaymentGateway["provider"], PaymentGateway>([
    ["VNPAY", new VnpayGateway(vnpayConfig)],
    ["MOMO", momo],
  ]);
  const tag = randomUUID().slice(0, 8);
  const operatorId = randomUUID();
  const otherOperator = randomUUID();
  const province = randomUUID();
  const ward = randomUUID();
  const points = [randomUUID(), randomUUID(), randomUUID()];
  const vehicleType = randomUUID();
  const riderId = `payer-${tag}`;
  const rider = { sub: riderId, role: "PASSENGER" } as VerifiedAccessToken;
  let routeId: string;
  let vehicleId: string;
  let day = 0;
  const authz: Authorization = { permission: "trip:manage", scope: "tenant", db: tenantScope(operatorId) };

  async function openTrip(): Promise<string> {
    const departureAt = new Date(Date.UTC(2031, 8, 1 + day++, 1));
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
    await prisma.withSystem((tx) => tx.trip.update({ where: { id: created.id }, data: { status: "OPEN_FOR_SALE" } }));
    return created.id;
  }

  /** Booking `PENDING_PAYMENT` 1–2 chỗ của khách vãng lai (hoặc hành khách). */
  async function booking(seatCodes = ["A1"], user: VerifiedAccessToken | null = null) {
    const tripId = await openTrip();
    const hold = await holds.create(user, undefined, SeatHoldInputSchema.parse({ tripId, seatCodes, pickupSequence: 1, dropoffSequence: 3 }));
    const created = await bookings.create(
      user,
      BookingInputSchema.parse({
        holdId: hold.holdId,
        contact: { fullName: "Nguyễn Văn A", phone: "0901234567", email: "a@example.com" },
        passengers: seatCodes.map((seatCode) => ({ seatCode, fullName: "Hành khách", phone: null })),
        note: null,
        expectedTotal: 320_000 * seatCodes.length,
      }),
    );
    return { ...created, tripId };
  }

  /** IPN VNPay ký bằng khóa test — như query VNPay gửi (đã giải mã). */
  function vnpayIpn(paymentCode: string, amount: bigint, overrides: Record<string, string> = {}): Record<string, string> {
    const params = {
      vnp_Amount: (amount * 100n).toString(),
      vnp_BankCode: "NCB",
      vnp_OrderInfo: "Thanh toan ve",
      vnp_PayDate: "20310801081000",
      vnp_ResponseCode: "00",
      vnp_TmnCode: vnpayConfig.tmnCode,
      vnp_TransactionNo: String(10_000_000 + Math.floor(Math.random() * 89_999_999)),
      vnp_TransactionStatus: "00",
      vnp_TxnRef: paymentCode,
      ...overrides,
    };
    return { ...params, vnp_SecureHash: sign(signedQuery(params), vnpayConfig.hashSecret) };
  }

  /** IPN → webhook (xếp hàng) → xử lý như worker; trả kết quả hai bước. */
  async function deliver(input: Record<string, string>) {
    const before = jobs.length;
    const ack = await webhooks.receive("VNPAY", input);
    const outcome = jobs.length > before ? await applyPaymentCallback(prisma, jobs[jobs.length - 1]!, qr) : null;
    return { ack, outcome };
  }

  const state = (bookingId: string) =>
    prisma.withSystem((tx) =>
      tx.booking.findUniqueOrThrow({
        where: { id: bookingId },
        select: {
          status: true,
          paidAt: true,
          seats: { select: { status: true } },
          payments: { orderBy: { createdAt: "asc" }, select: { status: true, providerTxnId: true, reconcileReason: true, failureCode: true, provider: true } },
        },
      }),
    );

  const sentOtps: OtpEmailMessage[] = [];

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    redis = new Redis(getRedisUrl(), createRequestRedisClientOptions("payment-test"));
    holds = new SeatHoldService(prisma, redis);
    bookings = new BookingService(prisma, holds, qr);
    payments = new PaymentService(prisma, gateways, { PAYMENT_RETURN_BASE_URL: "http://localhost:3001" } as AppConfig);
    webhooks = new PaymentWebhookService(prisma, gateways, queue);
    trips = new TripService(prisma, {} as AuditService);
    tickets = new TicketService(prisma, bookings, qr, redis, { sendOtp: async (message: OtpEmailMessage) => void sentOtps.push(message) } as unknown as EmailNotifier);
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.create({ data: { id: operatorId, operatorSlug: `pay-${tag}`, displayName: `Nhà xe ${tag}` } });
      await tx.operatorProfile.create({ data: { id: otherOperator, operatorSlug: `pay2-${tag}`, displayName: `Nhà xe khác ${tag}` } });
      await tx.user.create({ data: { id: riderId, email: `payer-${tag}@example.com`, name: `Khách ${tag}` } });
      await tx.province.create({ data: { id: province, code: `pp-${tag}`, name: "Tỉnh thanh toán" } });
      await tx.ward.create({ data: { id: ward, provinceId: province, code: `pw-${tag}`, name: "Phường thanh toán" } });
      await tx.stopPointCatalog.createMany({
        data: points.map((id, index) => ({
          id,
          name: `Điểm ${index} ${tag}`,
          type: index === 1 ? ("REST_STOP" as const) : ("BUS_STATION" as const),
          legalBasis: index === 1 ? null : "QĐ (test)",
          address: "Địa chỉ",
          provinceId: province,
          wardId: ward,
          latitude: 10 + index,
          longitude: 106,
        })),
      });
      await tx.vehicleType.create({ data: { id: vehicleType, code: `PV-${tag}`, name: "Giường", form: "SLEEPER", class: "STANDARD" } });
    });
    routeId = (
      await new RouteService(prisma, new FakeRouting()).create(
        authz,
        RouteInputSchema.parse({
          name: `Tuyến thanh toán ${tag}`,
          status: "ACTIVE",
          note: null,
          stops: points.map((id, index) => ({ catalogStopPointId: id, stopPointId: null, note: null, allowPickup: index === 0, allowDropoff: index === 2 })),
        }),
      )
    ).id;
    await prisma.withSystem(async (tx) => {
      const fare = await tx.fare.create({ data: { operatorId, routeId, status: "ACTIVE" } });
      await tx.fareRule.create({ data: { operatorId, fareId: fare.id, price: 320_000n } });
    });
    const map = await new SeatMapService(prisma).create(
      authz,
      SeatMapInputSchema.parse({
        name: `Sơ đồ thanh toán ${tag}`,
        layout: { decks: [{ deck: 1, rows: 1, columns: 2 }] },
        seats: ["A1", "A2"].map((code, index) => ({ code, deck: 1, row: 1, column: index + 1, type: "BED" })),
      }),
    );
    vehicleId = (
      await new VehicleService(prisma, {} as never).create(
        authz,
        VehicleInputSchema.parse({ plateNumber: `51P${10000 + Math.floor(Math.random() * 89999)}`, vehicleTypeId: vehicleType, seatMapId: map.id, amenityIds: [], status: "ACTIVE", description: null }),
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
      await tx.paymentStatusHistory.deleteMany({ where: { operatorId } });
      await tx.payment.deleteMany({ where: { operatorId } });
      await tx.notificationDelivery.deleteMany({ where: { operatorId } });
      await tx.notification.deleteMany({ where: { operatorId } });
      await tx.tripChange.deleteMany({ where: { operatorId } });
      await tx.ticketStatusHistory.deleteMany({ where: { operatorId } });
      await tx.ticket.deleteMany({ where: { operatorId } });
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

  it("tạo payment VNPay: PROCESSING, link ký đúng mã + số tiền × 100 + hạn = hạn booking; gọi lại trả đúng payment cũ; cần mã truy cập", async () => {
    const created = await booking(["A1", "A2"]);
    const first = await payments.create(null, created.bookingId, created.accessToken, { provider: "VNPAY" }, "10.1.1.1");
    expect(first).toMatchObject({ provider: "VNPAY", status: "PROCESSING", amount: 640_000, expiresAt: created.expiresAt });
    expect(first.paymentCode).toMatch(/^PAY[2-9A-HJ-NP-Z]{12}$/);
    const link = new URL(first.paymentUrl);
    expect(link.searchParams.get("vnp_TxnRef")).toBe(first.paymentCode);
    expect(link.searchParams.get("vnp_Amount")).toBe("64000000");
    expect(link.searchParams.get("vnp_IpAddr")).toBe("10.1.1.1");
    expect(link.searchParams.get("vnp_ReturnUrl")).toBe(`http://localhost:3001/bookings/${created.bookingId}/payment/result`);
    expect(await payments.create(null, created.bookingId, created.accessToken, { provider: "VNPAY" }, "10.1.1.1")).toEqual(first);

    expect(await rejectionOf(payments.create(null, created.bookingId, undefined, { provider: "VNPAY" }, undefined))).toMatchObject({ status: 404, code: "BOOKING_NOT_FOUND" });
    expect(await rejectionOf(payments.create(rider, created.bookingId, "sai", { provider: "VNPAY" }, undefined))).toMatchObject({ code: "BOOKING_NOT_FOUND" });
    expect((await state(created.bookingId)).payments).toEqual([{ status: "PROCESSING", providerTxnId: null, reconcileReason: null, failureCode: null, provider: "VNPAY" }]);
  });

  it("IPN thành công: webhook nhận (00) → worker ghi payment SUCCESS + booking PAID + ghế BOOKED + hủy payment MoMo đang mở; IPN lặp → 02, xử lý lặp → DUPLICATE", async () => {
    const created = await booking(["A1"], rider);
    const vnpay = await payments.create(rider, created.bookingId, undefined, { provider: "VNPAY" }, undefined);
    await payments.create(rider, created.bookingId, undefined, { provider: "MOMO" }, undefined);
    const ipn = vnpayIpn(vnpay.paymentCode, 320_000n);
    expect(await deliver(ipn)).toEqual({ ack: "ACCEPTED", outcome: "SUCCESS" });

    const after = await state(created.bookingId);
    expect(after.status).toBe("CONFIRMED");
    expect(after.paidAt).not.toBeNull();
    expect(after.seats).toEqual([{ status: "BOOKED" }]);
    expect(after.payments).toMatchObject([
      { provider: "VNPAY", status: "SUCCESS", providerTxnId: ipn.vnp_TransactionNo },
      { provider: "MOMO", status: "CANCELLED" },
    ]);
    expect((await bookings.get(rider, created.bookingId, undefined)).payment).toMatchObject({ paymentCode: vnpay.paymentCode, status: "SUCCESS", amount: 320_000 });

    expect(await deliver(ipn)).toEqual({ ack: "ALREADY_CONFIRMED", outcome: null });
    expect(await applyPaymentCallback(prisma, jobs[jobs.length - 1]!, qr)).toBe("DUPLICATE");
    expect(await rejectionOf(payments.create(rider, created.bookingId, undefined, { provider: "VNPAY" }, undefined))).toMatchObject({ status: 409, code: "BOOKING_INVALID_STATE" });
    const histories = await prisma.withSystem((tx) =>
      tx.bookingStatusHistory.findMany({ where: { bookingId: created.bookingId }, orderBy: { createdAt: "asc" }, select: { toStatus: true, actor: true } }),
    );
    expect(histories).toEqual([
      { toStatus: "PENDING_PAYMENT", actor: `user:${riderId}` },
      { toStatus: "PAID", actor: "provider:VNPAY" },
      { toStatus: "CONFIRMED", actor: "system" },
    ]);
  });

  it("hai worker xử lý đồng thời cùng callback thành công → đúng một lần ghi tiền (SUCCESS + DUPLICATE)", async () => {
    const created = await booking();
    const payment = await payments.create(null, created.bookingId, created.accessToken, { provider: "VNPAY" }, undefined);
    await webhooks.receive("VNPAY", vnpayIpn(payment.paymentCode, 320_000n));
    const job = jobs[jobs.length - 1]!;
    const outcomes = await Promise.all([applyPaymentCallback(prisma, job, qr), applyPaymentCallback(prisma, job, qr)]);
    expect(outcomes.sort()).toEqual(["DUPLICATE", "SUCCESS"]);
    const histories = await prisma.withSystem((tx) => tx.paymentStatusHistory.count({ where: { payment: { paymentCode: payment.paymentCode }, toStatus: "SUCCESS" } }));
    expect(histories).toBe(1);
  });

  it("chữ ký sai → 97, mã lạ → 01 (không xếp hàng); lệch số tiền → 04 + đối soát AMOUNT_MISMATCH, booking vẫn chờ thanh toán", async () => {
    const created = await booking();
    const payment = await payments.create(null, created.bookingId, created.accessToken, { provider: "VNPAY" }, undefined);
    const before = jobs.length;
    expect(await webhooks.receive("VNPAY", { ...vnpayIpn(payment.paymentCode, 320_000n), vnp_Amount: "100" })).toBe("INVALID_SIGNATURE");
    expect(await webhooks.receive("VNPAY", vnpayIpn("PAYZZZZZZZZZZZZ", 320_000n))).toBe("NOT_FOUND");
    expect(jobs.length).toBe(before);

    expect(await deliver(vnpayIpn(payment.paymentCode, 300_000n))).toEqual({ ack: "AMOUNT_MISMATCH", outcome: "RECONCILING" });
    const after = await state(created.bookingId);
    expect(after.status).toBe("PENDING_PAYMENT");
    expect(after.payments).toMatchObject([{ status: "RECONCILING", reconcileReason: "AMOUNT_MISMATCH" }]);
  });

  it("IPN thất bại → payment FAILED (mã cổng), booking vẫn chờ; tạo payment mới được và thanh toán lại thành công", async () => {
    const created = await booking();
    const first = await payments.create(null, created.bookingId, created.accessToken, { provider: "VNPAY" }, undefined);
    expect(await deliver(vnpayIpn(first.paymentCode, 320_000n, { vnp_ResponseCode: "24", vnp_TransactionStatus: "02", vnp_TransactionNo: "0" }))).toEqual({
      ack: "ACCEPTED",
      outcome: "FAILED",
    });
    const retry = await payments.create(null, created.bookingId, created.accessToken, { provider: "VNPAY" }, undefined);
    expect(retry.paymentCode).not.toBe(first.paymentCode);
    expect(await deliver(vnpayIpn(retry.paymentCode, 320_000n))).toMatchObject({ outcome: "SUCCESS" });
    const after = await state(created.bookingId);
    expect(after.status).toBe("CONFIRMED");
    expect(after.payments).toMatchObject([
      { status: "FAILED", failureCode: "24" },
      { status: "SUCCESS" },
    ]);
  });

  it("booking quá hạn: job đóng payment đang mở (EXPIRED); tiền về sau → đối soát BOOKING_EXPIRED, không nhận vào booking; tạo payment mới → 409 BOOKING_EXPIRED", async () => {
    const created = await booking();
    const payment = await payments.create(null, created.bookingId, created.accessToken, { provider: "VNPAY" }, undefined);
    await prisma.withSystem((tx) => tx.booking.update({ where: { id: created.bookingId }, data: { expiresAt: new Date(Date.now() - 1000) } }));
    expect(await rejectionOf(payments.create(null, created.bookingId, created.accessToken, { provider: "MOMO" }, undefined))).toMatchObject({ status: 409, code: "BOOKING_EXPIRED" });
    await expireOverdueBookings(prisma);
    expect((await state(created.bookingId)).payments).toMatchObject([{ status: "EXPIRED" }]);

    expect(await deliver(vnpayIpn(payment.paymentCode, 320_000n))).toEqual({ ack: "ACCEPTED", outcome: "RECONCILING" });
    const after = await state(created.bookingId);
    expect(after.status).toBe("EXPIRED");
    expect(after.seats).toEqual([]);
    expect(await prisma.withSystem((tx) => tx.tripSeat.findMany({ where: { tripId: created.tripId }, select: { status: true } }))).toEqual([
      { status: "AVAILABLE" },
      { status: "AVAILABLE" },
    ]);
    expect(after.payments).toMatchObject([{ status: "RECONCILING", reconcileReason: "BOOKING_EXPIRED" }]);
  });

  it("cổng lỗi khi tạo link → 502, payment FAILED, tạo lại được; cổng chưa cấu hình → 503; RLS: tenant khác không thấy payment", async () => {
    const created = await booking();
    momoCheckout.mockRejectedValueOnce(new PaymentGatewayError("MoMo từ chối"));
    expect(await rejectionOf(payments.create(null, created.bookingId, created.accessToken, { provider: "MOMO" }, undefined))).toMatchObject({ status: 502, code: "PAYMENT_PROVIDER_ERROR" });
    expect((await state(created.bookingId)).payments).toMatchObject([{ provider: "MOMO", status: "FAILED", failureCode: "GATEWAY_ERROR" }]);
    expect((await payments.create(null, created.bookingId, created.accessToken, { provider: "MOMO" }, undefined)).status).toBe("PROCESSING");

    const vnpayOnly = new PaymentService(prisma, new Map([["VNPAY", gateways.get("VNPAY")!]]), { PAYMENT_RETURN_BASE_URL: "http://localhost:3001" } as AppConfig);
    expect(await rejectionOf(vnpayOnly.create(null, created.bookingId, created.accessToken, { provider: "MOMO" }, undefined))).toMatchObject({ status: 503, code: "PAYMENT_PROVIDER_UNAVAILABLE" });

    expect(await prisma.withTenant(otherOperator, (tx) => tx.payment.count({ where: { bookingId: created.bookingId } }))).toBe(0);
    expect(await prisma.withTenant(operatorId, (tx) => tx.payment.count({ where: { bookingId: created.bookingId } }))).toBe(2);
  });
  it("vé: thanh toán thành công phát hành mỗi chỗ một vé VALID (mã booking-NN, DB chỉ lưu hash QR); phát hành lặp không trùng; xem vé đúng quyền; tra cứu bằng mã + liên hệ; RLS", async () => {
    const created = await booking(["A1", "A2"]);
    const payment = await payments.create(null, created.bookingId, created.accessToken, { provider: "VNPAY" }, undefined);
    expect((await deliver(vnpayIpn(payment.paymentCode, 640_000n))).outcome).toBe("SUCCESS");

    const view = await bookings.get(null, created.bookingId, created.accessToken);
    expect(view.status).toBe("CONFIRMED");
    expect(view.tickets.map((ticket) => [ticket.ticketCode, ticket.seatCode, ticket.status])).toEqual([
      [`${created.bookingCode}-01`, "A1", "VALID"],
      [`${created.bookingCode}-02`, "A2", "VALID"],
    ]);
    const [first] = view.tickets;
    const stored = await prisma.withSystem((tx) =>
      tx.ticket.findUniqueOrThrow({ where: { id: first!.ticketId }, select: { qrTokenHash: true, histories: { select: { toStatus: true } } } }),
    );
    expect(stored.qrTokenHash).toBe(TicketQrSigner.hash(first!.qrToken));
    expect(stored.qrTokenHash).not.toContain(first!.qrToken);
    expect(stored.histories).toEqual([{ toStatus: "VALID" }]);
    expect(first!.qrToken).not.toBe(view.tickets[1]!.qrToken);
    expect(await prisma.withTenant(operatorId, (tx) => issueTickets(tx, operatorId, created.bookingId, qr, new Date(), "system"))).toBe(0);
    expect(await prisma.withSystem((tx) => tx.ticket.count({ where: { bookingId: created.bookingId } }))).toBe(2);

    const ticket = await tickets.get(null, first!.ticketId, created.accessToken);
    expect(ticket).toMatchObject({ ticketCode: `${created.bookingCode}-01`, seatType: "BED", bookingStatus: "CONFIRMED", qrToken: first!.qrToken, checkedInAt: null });
    expect(await rejectionOf(tickets.get(null, first!.ticketId, undefined))).toMatchObject({ status: 404, code: "TICKET_NOT_FOUND" });
    expect(await rejectionOf(tickets.get(rider, first!.ticketId, "sai"))).toMatchObject({ code: "TICKET_NOT_FOUND" });

    // Tra cứu vé khách vãng lai bắt buộc OTP (UX-OQ-09): phản hồi trung tính, mã gửi về email liên hệ, phiên 15 phút;
    // mã đặt vé không bắt buộc (27/10/2026) — chỉ email thì thấy các đơn của email trong 12 tháng.
    const ip = `10.77.${tag.charCodeAt(1)}.${tag.charCodeAt(2)}`;
    const emailLimits = `ticket-lookup:email:${createHash("sha256").update("a@example.com").digest("hex")}`;
    // Email liên hệ dùng chung giữa các lần chạy: xóa giới hạn gửi mã còn lại của lần trước.
    await redis.del(`${emailLimits}:cooldown`, `${emailLimits}:count`);
    // `null` = không nhập mã đặt vé (truyền `undefined` sẽ lấy giá trị mặc định là mã của đơn).
    const requestOtp = (email: string, bookingCode: string | null = created.bookingCode) =>
      tickets.requestOtp(ip, TicketLookupOtpInputSchema.parse({ email, ...(bookingCode ? { bookingCode } : {}) }));
    const verify = (otp: string, bookingCode: string | null = created.bookingCode) =>
      tickets.verifyOtp(TicketLookupVerifyInputSchema.parse({ email: "a@example.com", otp, ...(bookingCode ? { bookingCode } : {}) }));
    const neutral = { expiresInSeconds: 300, resendAfterSeconds: 60, maxAttempts: 5 };
    expect(await requestOtp("khac@example.com")).toEqual({ maskedEmail: "k***@example.com", ...neutral });
    expect(sentOtps).toEqual([]);
    expect(await requestOtp("A@Example.com", created.bookingCode.toLowerCase())).toEqual({ maskedEmail: "a***@example.com", ...neutral });
    expect(sentOtps).toEqual([{ email: "a@example.com", otp: expect.stringMatching(/^\d{6}$/), purpose: "ticket-lookup" }]);
    expect(await rejectionOf(requestOtp("a@example.com", null))).toMatchObject({ status: 429, code: "TICKET_LOOKUP_RATE_LIMITED" });
    const otp = sentOtps[0]!.otp;
    expect(await rejectionOf(verify(otp === "000000" ? "111111" : "000000"))).toMatchObject({ status: 422, code: "TICKET_LOOKUP_OTP_INVALID" });
    const session = await verify(otp);
    expect(await rejectionOf(verify(otp))).toMatchObject({ status: 422, code: "TICKET_LOOKUP_OTP_INVALID" });
    const single = await tickets.listBookings({ lookupToken: session.lookupToken });
    expect(single).toMatchObject({ maskedEmail: "a***@example.com", scope: "BOOKING", hasAccount: false });
    expect(single.items).toEqual([expect.objectContaining({ bookingId: created.bookingId, status: "CONFIRMED", ticketCount: 2, total: 640_000, bookedWithAccount: false })]);
    const viewed = await tickets.lookup(TicketLookupInputSchema.parse({ lookupToken: session.lookupToken }));
    expect(viewed.bookingId).toBe(created.bookingId);
    expect(viewed.tickets).toHaveLength(2);
    expect(await rejectionOf(tickets.lookup({ lookupToken: "x".repeat(43) }))).toMatchObject({ status: 404, code: "TICKET_LOOKUP_EXPIRED" });

    // Chỉ email: hết thời gian chờ gửi lại → mã mới, phiên thấy đơn vừa đặt trong danh sách và xem được khi chọn đúng đơn.
    await redis.del(`${emailLimits}:cooldown`);
    await requestOtp("a@example.com", null);
    expect(sentOtps).toHaveLength(2);
    const byEmail = await verify(sentOtps[1]!.otp, null);
    const listed = await tickets.listBookings({ lookupToken: byEmail.lookupToken });
    expect(listed.scope).toBe("EMAIL");
    expect(listed.items.map((item) => item.bookingId)).toContain(created.bookingId);
    expect((await tickets.lookup({ lookupToken: byEmail.lookupToken, bookingId: created.bookingId })).tickets).toHaveLength(2);
    expect(await rejectionOf(tickets.lookup({ lookupToken: byEmail.lookupToken }))).toMatchObject({ status: 404, code: "BOOKING_NOT_FOUND" });
    // Sau OTP được cấp mã truy cập phụ cho đúng đơn (hủy vé / khiếu nại); không thay mã gốc lúc đặt.
    const access = await tickets.grantBookingAccess({ lookupToken: byEmail.lookupToken, bookingId: created.bookingId });
    expect((await bookings.get(null, created.bookingId, access.accessToken)).bookingId).toBe(created.bookingId);
    expect((await bookings.get(null, created.bookingId, created.accessToken)).bookingId).toBe(created.bookingId);

    // Email không có đơn không bao giờ xác minh được; 10 lần gửi mã / 10 phút / IP (đã dùng 4).
    for (let index = 0; index < 6; index++) {
      await requestOtp(`x${index}-${tag}@example.com`, null);
    }
    expect(await rejectionOf(requestOtp(`y-${tag}@example.com`))).toMatchObject({ status: 429, code: "TICKET_LOOKUP_RATE_LIMITED" });
    expect(sentOtps).toHaveLength(2);

    expect(await prisma.withTenant(otherOperator, (tx) => tx.ticket.count({ where: { bookingId: created.bookingId } }))).toBe(0);
  });
});
