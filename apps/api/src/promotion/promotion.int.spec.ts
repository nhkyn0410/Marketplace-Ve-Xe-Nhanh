import { randomUUID } from "node:crypto";
import Redis from "ioredis";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { type AuditEventInput, AuditService } from "../audit/audit.service";
import { expireBooking } from "../booking/booking-expiry";
import { BookingService } from "../booking/booking.service";
import { BookingInputSchema } from "../booking/dto/booking.dto";
import { parseAppConfig } from "../config/env.config";
import { platformScope, tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { Coordinates, RouteLeg, RoutingProvider } from "../external/routing/routing-provider";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import type { NotificationDispatcher } from "../notification/notification-dispatcher";
import { applyPaymentCallback } from "../payment/payment-callback";
import { createRequestRedisClientOptions, getRedisUrl } from "../redis/redis.config";
import { CancellationService } from "../refund/cancellation.service";
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
import { PromotionInputSchema } from "./dto/promotion.dto";
import { evaluatePromotion } from "./promotion-apply";
import { PromotionService } from "./promotion.service";

/**
 * TASK-PROM-001 trên Postgres + Redis THẬT (role app): khuyến mãi nền tảng chỉ áp cho nhà xe đã tham gia (nhà xe chịu phần giảm);
 * giữ lượt dùng nguyên tử (hai đơn đồng thời, còn một lượt → đúng một đơn được giảm), đơn hết hạn trả lượt; thanh toán → "đã dùng",
 * hoa hồng trên số khách thực trả; hủy vé hoàn trên phần đã trả; khuyến mãi nhà xe trong giới hạn được cấp (BR-46), mã của nhà xe
 * khác không dùng được, không sửa điều kiện khi đã có đơn (BR-47).
 */
const url = process.env.DATABASE_URL;
const ready = Boolean(url && process.env.REDIS_URL);
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
const HOUR = 3_600_000;

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

describe.skipIf(!ready && !requireDb)("Khuyến mãi — Postgres + Redis thật (PROM-001)", () => {
  let prisma: PrismaService;
  let redis: Redis;
  let holds: SeatHoldService;
  let bookings: BookingService;
  let trips: TripService;
  let promotions: PromotionService;
  const events: AuditEventInput[] = [];
  const audit = { recordAuditEvent: vi.fn(async (event: AuditEventInput) => void events.push(event)) } as unknown as AuditService;
  const qr = new TicketQrSigner(Buffer.alloc(32, 11));
  const tag = randomUUID().slice(0, 6).toUpperCase().replace(/-/g, "0");
  const operatorId = randomUUID();
  const otherOperatorId = randomUUID();
  const province = randomUUID();
  const ward = randomUUID();
  const points = [randomUUID(), randomUUID(), randomUUID()];
  const vehicleType = randomUUID();
  const admin = { sub: randomUUID(), role: "PLATFORM_ADMIN" } as VerifiedAccessToken;
  const owner = { sub: randomUUID(), role: "OPERATOR_OWNER" } as VerifiedAccessToken;
  const ownerAuthz: Authorization = { permission: "trip:manage", scope: "tenant", db: tenantScope(operatorId) };
  const operatorAuthz: Authorization = { permission: "promotion:manage", scope: "tenant", db: tenantScope(operatorId) };
  const otherAuthz: Authorization = { permission: "promotion:manage", scope: "tenant", db: tenantScope(otherOperatorId) };
  const platformAuthz: Authorization = { permission: "promotion:configure", scope: "any", db: platformScope() };
  let routeId: string;
  let seatMapId: string;
  const window = () => ({ startsAt: new Date(Date.now() - HOUR).toISOString(), endsAt: new Date(Date.now() + 10 * 24 * HOUR).toISOString() });

  /** Chuyến mở bán sau `hoursAhead` giờ (xe 4 chỗ, 300.000 ₫ / chỗ). */
  async function openTrip(hoursAhead: number) {
    const vehicle = await new VehicleService(prisma, {} as never).create(
      ownerAuthz,
      VehicleInputSchema.parse({ plateNumber: `51G${10000 + Math.floor(Math.random() * 89999)}`, vehicleTypeId: vehicleType, seatMapId, amenityIds: [], status: "ACTIVE", description: null }),
    );
    const departureAt = new Date(Date.now() + hoursAhead * HOUR);
    const trip = await trips.create(
      ownerAuthz,
      TripInputSchema.parse({ routeId, vehicleId: vehicle.id, departureAt: departureAt.toISOString(), arrivalAt: new Date(departureAt.getTime() + 6 * HOUR).toISOString(), stopTimes: null, onlineSaleCutoffMinutes: 60, note: null }),
    );
    await prisma.withSystem((tx) => tx.trip.update({ where: { id: trip.id }, data: { status: "OPEN_FOR_SALE" } }));
    return trip.id;
  }

  async function book(tripId: string, seatCodes: string[], code: string | null, expectedTotal: number) {
    const hold = await holds.create(null, undefined, SeatHoldInputSchema.parse({ tripId, seatCodes, pickupSequence: 1, dropoffSequence: 3 }));
    return bookings.create(
      null,
      BookingInputSchema.parse({
        holdId: hold.holdId,
        contact: { fullName: "Khách", phone: "0901234567", email: "k@example.com" },
        passengers: seatCodes.map((seatCode) => ({ seatCode, fullName: `Khách ${seatCode}`, phone: null })),
        note: null,
        expectedTotal,
        promotionCode: code,
      }),
    );
  }

  async function pay(bookingId: string, amount: number) {
    const paymentCode = `PAY${randomUUID().replace(/-/g, "").slice(0, 12).toUpperCase()}`;
    await prisma.withTenant(operatorId, (tx) => tx.payment.create({ data: { paymentCode, operatorId, bookingId, provider: "VNPAY", status: "PROCESSING", amount: BigInt(amount), expiresAt: new Date(Date.now() + 600_000) } }));
    expect(await applyPaymentCallback(prisma, { provider: "VNPAY", paymentCode, providerTxnId: `T${randomUUID().slice(0, 10)}`, amount: String(amount), success: true, resultCode: "00", fields: {} }, qr)).toBe("SUCCESS");
  }

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    redis = new Redis(getRedisUrl(), createRequestRedisClientOptions("promotion-test"));
    holds = new SeatHoldService(prisma, redis);
    bookings = new BookingService(prisma, holds, qr);
    trips = new TripService(prisma, {} as AuditService);
    promotions = new PromotionService(prisma, audit);
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.createMany({
        data: [
          { id: operatorId, operatorSlug: `pr-${tag.toLowerCase()}`, displayName: `Nhà xe khuyến mãi ${tag}` },
          { id: otherOperatorId, operatorSlug: `pr2-${tag.toLowerCase()}`, displayName: `Nhà xe khác ${tag}` },
        ],
      });
      await tx.province.create({ data: { id: province, code: `pp-${tag}`, name: "Tỉnh" } });
      await tx.ward.create({ data: { id: ward, provinceId: province, code: `pw-${tag}`, name: "Phường" } });
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
      await tx.vehicleType.create({ data: { id: vehicleType, code: `PR-${tag}`, name: "Giường", form: "SLEEPER", class: "STANDARD" } });
    });
    routeId = (
      await new RouteService(prisma, new FakeRouting()).create(
        ownerAuthz,
        RouteInputSchema.parse({
          name: `Tuyến khuyến mãi ${tag}`,
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
  }, 90_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      await tx.$executeRaw`SELECT set_config('app.allow_ledger_delete', 'on', true)`;
      await tx.promotionRedemption.deleteMany({ where: { operatorId } });
      await tx.promotionParticipation.deleteMany({ where: { operatorId: { in: [operatorId, otherOperatorId] } } });
      await tx.promotion.deleteMany({ where: { OR: [{ operatorId: { in: [operatorId, otherOperatorId] } }, { code: { endsWith: tag } }] } });
      await tx.promotionPermission.deleteMany({ where: { operatorId: { in: [operatorId, otherOperatorId] } } });
      await tx.notificationDelivery.deleteMany({ where: { operatorId } });
      await tx.notification.deleteMany({ where: { operatorId } });
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
      await tx.stopPointCatalog.deleteMany({ where: { provinceId: province } });
      await tx.ward.deleteMany({ where: { provinceId: province } });
      await tx.province.deleteMany({ where: { id: province } });
      await tx.vehicleType.deleteMany({ where: { id: vehicleType } });
      await tx.operatorProfile.deleteMany({ where: { id: { in: [operatorId, otherOperatorId] } } });
    });
    await prisma.$disconnect();
    redis.disconnect();
  });

  it("khuyến mãi nền tảng: chưa tham gia → không áp; tham gia → giảm; hai đơn đồng thời còn 1 lượt → đúng một đơn; hết hạn trả lượt; thanh toán → đã dùng, hoa hồng trên số đã trả", async () => {
    const code = `NEN${tag}`;
    const created = await promotions.create(platformAuthz, admin, PromotionInputSchema.parse({ code, name: "Chào bạn mới", discountType: "AMOUNT", discountValue: 30_000, minOrder: 200_000, ...window(), usageLimit: 1 }));
    expect(created).toMatchObject({ scope: "PLATFORM", status: "DRAFT", display: "DRAFT", editable: true, participants: 0 });
    await promotions.setStatus(platformAuthz, admin, created.promotionId, { status: "ACTIVE" });
    const tripId = await openTrip(30);
    expect(await rejectionOf(promotions.check({ tripId, code, subtotal: 300_000 }))).toMatchObject({ status: 422, code: "PROMOTION_INVALID" });
    expect(await rejectionOf(book(tripId, ["A1"], code, 270_000))).toMatchObject({ status: 422, code: "PROMOTION_INVALID" });

    const joined = await promotions.setParticipation(operatorAuthz, owner, created.promotionId, true);
    expect(joined.joined).toBe(true);
    expect(await promotions.check({ tripId, code: code.toLowerCase(), subtotal: 300_000 })).toEqual({ code, name: "Chào bạn mới", discount: 30_000, total: 270_000 });

    // Hai đơn đồng thời, còn đúng một lượt → đúng một đơn có giảm, đơn kia 409 (lượt giữ nguyên tử).
    const results = await Promise.allSettled([book(tripId, ["A2"], code, 270_000), book(tripId, ["A3"], code, 270_000)]);
    const ok = results.filter((result): result is PromiseFulfilledResult<Awaited<ReturnType<typeof book>>> => result.status === "fulfilled");
    expect(ok).toHaveLength(1);
    expect(await rejectionOf(Promise.reject((results.find((result) => result.status === "rejected") as PromiseRejectedResult).reason))).toMatchObject({ status: 409, code: "PROMOTION_EXHAUSTED" });
    const first = ok[0]!.value;
    expect(first).toMatchObject({ subtotal: 300_000, discount: 30_000, total: 270_000 });
    expect((await prisma.withSystem((tx) => tx.promotion.findUniqueOrThrow({ where: { code }, select: { usedCount: true } }))).usedCount).toBe(1);

    // Đơn hết hạn → trả lượt; đơn mới dùng được mã.
    await prisma.withSystem((tx) => tx.booking.update({ where: { id: first.bookingId }, data: { expiresAt: new Date(Date.now() - 1000) } }));
    expect(await prisma.withTenant(operatorId, (tx) => expireBooking(tx, operatorId, first.bookingId, new Date()))).toBe(true);
    const state = await prisma.withSystem(async (tx) => ({
      promotion: await tx.promotion.findUniqueOrThrow({ where: { code }, select: { usedCount: true } }),
      redemption: await tx.promotionRedemption.findUniqueOrThrow({ where: { bookingId: first.bookingId }, select: { status: true, fundedBy: true, discount: true } }),
    }));
    expect(state).toEqual({ promotion: { usedCount: 0 }, redemption: { status: "RELEASED", fundedBy: "OPERATOR", discount: 30_000n } });
    const second = await book(tripId, ["A4"], code, 270_000);
    await pay(second.bookingId, 270_000);
    const paid = await prisma.withSystem(async (tx) => ({
      redemption: await tx.promotionRedemption.findUniqueOrThrow({ where: { bookingId: second.bookingId }, select: { status: true } }),
      ledger: await tx.escrowLedger.findMany({ where: { bookingId: second.bookingId }, orderBy: { amount: "desc" }, select: { entryType: true, amount: true, commissionRateBps: true } }),
      snapshot: (await tx.booking.findUniqueOrThrow({ where: { id: second.bookingId }, select: { snapshot: true } })).snapshot as { promotion?: unknown },
    }));
    expect(paid.redemption.status).toBe("USED");
    expect(paid.snapshot.promotion).toEqual({ code, name: "Chào bạn mới", discount: 30_000, fundedBy: "OPERATOR" });
    // Nhà xe chịu phần giảm: sổ giữ hộ nhận số khách thực trả, hoa hồng tính trên số đó.
    const capture = paid.ledger.find((entry) => entry.entryType === "PAYMENT_CAPTURED")!;
    const commission = paid.ledger.find((entry) => entry.entryType === "COMMISSION")!;
    expect(capture.amount).toBe(270_000n);
    expect(-commission.amount).toBe((270_000n * BigInt(commission.commissionRateBps!)) / 10_000n);

    const list = await promotions.adminList(platformAuthz, "PLATFORM", { q: code, limit: 20 });
    expect(list.items[0]).toMatchObject({ code, usedCount: 1, display: "RUNNING", editable: false, participants: 1 });
    expect(list.stats.redemptions).toBeGreaterThanOrEqual(1);
    // BR-47: đã có đơn dùng mã → không sửa điều kiện.
    expect(await rejectionOf(promotions.update(platformAuthz, admin, created.promotionId, PromotionInputSchema.parse({ code, name: "Đổi", discountType: "AMOUNT", discountValue: 50_000, ...window(), usageLimit: 5 })))).toMatchObject({
      status: 409,
      code: "PROMOTION_STATE_INVALID",
    });
  }, 60_000);

  it("khuyến mãi nhà xe: chưa có quyền → chặn; vượt giới hạn → chặn; trong giới hạn → chạy; nhà xe khác không thấy / không dùng được; hủy vé hoàn trên phần đã trả", async () => {
    const code = `NX${tag}`;
    const input = (overrides: Record<string, unknown> = {}) =>
      PromotionInputSchema.parse({ code, name: "Giảm 10% giữa tuần", discountType: "PERCENT", discountValue: 10, maxDiscount: 50_000, minOrder: 300_000, routeId, ...window(), usageLimit: 10, ...overrides });
    expect(await rejectionOf(promotions.create(operatorAuthz, owner, input()))).toMatchObject({ status: 422, code: "PROMOTION_GUARDRAIL" });
    const permission = await promotions.upsertPermission(platformAuthz, admin, operatorId, { enabled: true, maxPercent: 20, maxAmount: 50_000, routeIds: [], maxDurationDays: 60, monthlyBudget: null });
    expect(permission).toMatchObject({ enabled: true, maxPercent: 20, maxAmount: 50_000 });
    expect(await promotions.operatorPermission(operatorAuthz)).toMatchObject({ enabled: true, maxPercent: 20 });
    expect(await rejectionOf(promotions.create(operatorAuthz, owner, input({ discountValue: 25 })))).toMatchObject({ status: 422, detail: "Mức giảm vượt giới hạn 20%." });
    expect(await rejectionOf(promotions.create(operatorAuthz, owner, input({ maxDiscount: 80_000 })))).toMatchObject({ status: 422 });
    expect(await rejectionOf(promotions.create(operatorAuthz, owner, input({ endsAt: new Date(Date.now() + 90 * 24 * HOUR).toISOString() })))).toMatchObject({ status: 422 });

    const own = await promotions.create(operatorAuthz, owner, input());
    expect(own).toMatchObject({ scope: "OPERATOR", operatorId, routeName: `Tuyến khuyến mãi ${tag}`, status: "DRAFT", joined: null });
    expect((await promotions.setStatus(operatorAuthz, owner, own.promotionId, { status: "ACTIVE" })).display).toBe("RUNNING");
    expect(await rejectionOf(promotions.create(operatorAuthz, owner, input({ name: "Trùng mã" })))).toMatchObject({ status: 409, code: "PROMOTION_CODE_TAKEN" });

    // Tenant: nhà xe khác không thấy, không sửa được; thấy khuyến mãi nền tảng.
    expect((await promotions.operatorList(otherAuthz, "OPERATOR", { limit: 20 })).items).toEqual([]);
    expect(await rejectionOf(promotions.get(otherAuthz, own.promotionId))).toMatchObject({ status: 404 });
    expect(await rejectionOf(promotions.setStatus(otherAuthz, owner, own.promotionId, { status: "ENDED" }))).toMatchObject({ status: 404 });
    expect((await promotions.operatorList(otherAuthz, "PLATFORM", { q: `NEN${tag}`, limit: 20 })).items.map((item) => [item.code, item.joined])).toEqual([[`NEN${tag}`, false]]);

    // Đơn 2 vé 600.000 ₫ → giảm 10% trần 50.000 = 50.000; hủy 1 vé trước 24 giờ hoàn trên phần đã trả của vé (275.000 × %).
    const tripId = await openTrip(72);
    const booking = await book(tripId, ["A1", "A2"], code, 550_000);
    expect(booking).toMatchObject({ discount: 50_000, total: 550_000 });
    await pay(booking.bookingId, 550_000);
    const cancellations = new CancellationService(prisma, bookings, { add: vi.fn() } as never, { dispatch: vi.fn() } as unknown as NotificationDispatcher);
    const ticket = (await prisma.withSystem((tx) => tx.ticket.findFirstOrThrow({ where: { bookingId: booking.bookingId }, orderBy: { ticketCode: "asc" }, select: { id: true } }))).id;
    const quote = await cancellations.quote(null, booking.bookingId, booking.accessToken, [ticket]);
    expect(quote.selectedTotal).toBe(275_000);
    expect(quote.refundAmount).toBe((275_000 * quote.refundPercent) / 100);

    expect(await rejectionOf(promotions.update(operatorAuthz, owner, own.promotionId, input({ name: "Sửa sau khi đã dùng" })))).toMatchObject({ status: 409, code: "PROMOTION_STATE_INVALID" });
    expect((await promotions.setStatus(platformAuthz, admin, own.promotionId, { status: "PAUSED" })).display).toBe("PAUSED");
    expect(await rejectionOf(promotions.setStatus(platformAuthz, admin, own.promotionId, { status: "ACTIVE" }))).toMatchObject({ status: 409 });
    expect(await rejectionOf(promotions.check({ tripId, code, subtotal: 600_000 }))).toMatchObject({ status: 422 });
    expect(events.some((event) => event.action === "promotion.permission" && event.operatorId === operatorId)).toBe(true);
  }, 60_000);
  it("khuyến mãi nền tảng chỉ áp các tuyến Admin đã chọn và vẫn yêu cầu nhà xe tham gia", async () => {
    const input = PromotionInputSchema.parse({ code: `ROUTE${tag}`, name: "Ưu đãi theo tuyến", discountType: "AMOUNT", discountValue: 20_000, routeIds: [routeId, routeId], ...window(), usageLimit: 10 });
    expect(await rejectionOf(promotions.create(platformAuthz, admin, { ...input, routeIds: [randomUUID()] }))).toMatchObject({ status: 422, code: "PROMOTION_GUARDRAIL" });
    const campaign = await promotions.create(platformAuthz, admin, input);
    expect(campaign.routeIds).toEqual([routeId]);
    expect(campaign.routeNames).toEqual([`Tuyến khuyến mãi ${tag}`]);
    expect((await promotions.routeOptions(platformAuthz)).items.some((route) => route.routeId === routeId)).toBe(true);
    await promotions.setStatus(platformAuthz, admin, campaign.promotionId, { status: "ACTIVE" });
    const tripId = await openTrip(48);
    expect(await rejectionOf(promotions.check({ tripId, code: campaign.code, subtotal: 300_000 }))).toMatchObject({ status: 422 });
    await promotions.setParticipation(operatorAuthz, owner, campaign.promotionId, true);
    expect((await promotions.check({ tripId, code: campaign.code, subtotal: 300_000 })).discount).toBe(20_000);
    expect(await rejectionOf(prisma.withTenant(operatorId, (tx) => evaluatePromotion(tx, { operatorId, routeId: randomUUID(), tripId, subtotal: 300_000n, code: campaign.code, now: new Date() })))).toMatchObject({ status: 422, code: "PROMOTION_INVALID" });
  }, 60_000);
});
