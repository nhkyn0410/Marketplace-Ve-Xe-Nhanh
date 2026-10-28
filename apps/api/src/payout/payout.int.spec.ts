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
import { payoutDelayDays } from "../escrow/escrow-entries";
import type { PaymentGateway, PaymentGateways } from "../external/payment/payment-gateway";
import type { Coordinates, RouteLeg, RoutingProvider } from "../external/routing/routing-provider";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { applyPaymentCallback } from "../payment/payment-callback";
import { createRequestRedisClientOptions, getRedisUrl } from "../redis/redis.config";
import { CancellationService } from "../refund/cancellation.service";
import { processRefund } from "../refund/refund-processing";
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
import { AdminPayoutService } from "./admin-payout.service";
import { OperatorFinanceService } from "./operator-finance.service";
import { generatePayouts, vnDate } from "./payout-generation";

/**
 * TASK-BTP-006 — sổ escrow + kỳ chi trả trên Postgres + Redis THẬT (role app): bút toán khi thu tiền (qua callback thật) / hoàn
 * tiền (qua worker thật), hoa hồng BIGINT, sổ chỉ ghi thêm (trigger), tạo kỳ T+N idempotent, giữ booking có hoàn tiền treo,
 * Admin rà soát → đã chi (bút toán PAYOUT), giữ lại / mở lại / hủy, màn tài chính nhà xe, RLS. Test money bắt buộc (ADR-025).
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

describe.skipIf(!ready && !requireDb)("Escrow + chi trả — Postgres + Redis thật (BTP-006)", () => {
  let prisma: PrismaService;
  let redis: Redis;
  let holds: SeatHoldService;
  let bookings: BookingService;
  let cancellations: CancellationService;
  let trips: TripService;
  let admin: AdminPayoutService;
  let finance: OperatorFinanceService;
  const events: AuditEventInput[] = [];
  const recordAuditEvent = vi.fn(async (event: AuditEventInput) => void events.push(event));
  const queue = { add: vi.fn(async () => undefined) } as unknown as Queue;
  const vnpay = { provider: "VNPAY", refund: vi.fn(async () => ({ providerRefundId: "RF1" })) } as unknown as PaymentGateway;
  const gateways: PaymentGateways = new Map<PaymentGateway["provider"], PaymentGateway>([["VNPAY", vnpay]]);
  const qr = new TicketQrSigner(Buffer.alloc(32, 4));
  const tag = randomUUID().slice(0, 8);
  const operatorId = randomUUID();
  const noBankOperator = randomUUID();
  const province = randomUUID();
  const ward = randomUUID();
  const points = [randomUUID(), randomUUID(), randomUUID()];
  const vehicleType = randomUUID();
  const adminActor = { sub: randomUUID(), role: "PLATFORM_ADMIN" } as VerifiedAccessToken;
  const platformAuthz: Authorization = { permission: "payout:manage", scope: "any", db: platformScope() };
  const tenantAuthz = (id: string): Authorization => ({ permission: "finance:read", scope: "tenant", db: tenantScope(id) });
  let delayDays: number;
  const fixtures = new Map<string, { routeId: string; seatMapId: string }>();

  async function setupOperator(id: string, bank: boolean) {
    const authz: Authorization = { permission: "trip:manage", scope: "tenant", db: tenantScope(id) };
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.create({ data: { id, operatorSlug: `po-${id.slice(0, 8)}`, displayName: `Nhà xe ${id.slice(0, 4)}` } });
      // Mức riêng 4% để không phụ thuộc mức mặc định đang có trong DB dev (BR-31 mặc định 5%).
      await tx.commissionRule.create({ data: { operatorId: id, rateBps: 400, effectiveFrom: new Date(Date.now() - DAY), reason: "test" } });
      if (bank) {
        await tx.bankAccount.create({ data: { operatorId: id, bankName: "Vietcombank", accountNumber: "0071000124521", accountHolder: "CTY TEST", status: "VERIFIED", reviewedAt: new Date() } });
      }
    });
    const routeId = (
      await new RouteService(prisma, new FakeRouting()).create(
        authz,
        RouteInputSchema.parse({
          name: `Tuyến chi trả ${tag}`,
          status: "ACTIVE",
          note: null,
          stops: points.map((point, index) => ({ catalogStopPointId: point, stopPointId: null, note: null, allowPickup: index === 0, allowDropoff: index === 2 })),
        }),
      )
    ).id;
    await prisma.withSystem(async (tx) => {
      const fare = await tx.fare.create({ data: { operatorId: id, routeId, status: "ACTIVE" } });
      await tx.fareRule.create({ data: { operatorId: id, fareId: fare.id, price: 300_000n } });
    });
    const seatMapId = (
      await new SeatMapService(prisma).create(
        authz,
        SeatMapInputSchema.parse({
          name: `Sơ đồ ${id.slice(0, 6)}`,
          layout: { decks: [{ deck: 1, rows: 2, columns: 2 }] },
          seats: ["A1", "A2", "A3", "A4"].map((code, index) => ({ code, deck: 1, row: Math.floor(index / 2) + 1, column: (index % 2) + 1, type: "BED" })),
        }),
      )
    ).id;
    fixtures.set(id, { routeId, seatMapId });
  }

  /** Booking 2 chỗ đã thanh toán qua callback thật (ghi sổ thu tiền), chuyến khởi hành sau 48 giờ, đến nơi sau 54 giờ. */
  async function paidBooking(owner: string) {
    const { routeId, seatMapId } = fixtures.get(owner)!;
    const authz: Authorization = { permission: "trip:manage", scope: "tenant", db: tenantScope(owner) };
    const vehicle = await new VehicleService(prisma, {} as never).create(
      authz,
      VehicleInputSchema.parse({ plateNumber: `51E${10000 + Math.floor(Math.random() * 89999)}`, vehicleTypeId: vehicleType, seatMapId, amenityIds: [], status: "ACTIVE", description: null }),
    );
    const departureAt = new Date(Date.now() + 48 * HOUR);
    const trip = await trips.create(
      authz,
      TripInputSchema.parse({
        routeId,
        vehicleId: vehicle.id,
        departureAt: departureAt.toISOString(),
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
        contact: { fullName: "Khách", phone: "0901234567", email: "k@example.com" },
        passengers: ["A1", "A2"].map((seatCode) => ({ seatCode, fullName: `Khách ${seatCode}`, phone: null })),
        note: null,
        expectedTotal: 600_000,
      }),
    );
    const paymentCode = `PAY${randomUUID().replace(/-/g, "").slice(0, 12).toUpperCase()}`;
    await prisma.withTenant(owner, async (tx) => {
      await tx.payment.create({ data: { paymentCode, operatorId: owner, bookingId: created.bookingId, provider: "VNPAY", status: "PROCESSING", amount: 600_000n, expiresAt: new Date(Date.now() + 600_000) } });
      const booking = await tx.booking.findUniqueOrThrow({ where: { id: created.bookingId }, select: { snapshot: true } });
      await tx.booking.update({
        where: { id: created.bookingId },
        data: { snapshot: { ...(booking.snapshot as object), cancellationPolicy: { tiers: [{ minHoursBefore: 24, refundPercent: 90 }, { minHoursBefore: 0, refundPercent: 0 }] } } },
      });
    });
    const job = { provider: "VNPAY" as const, paymentCode, providerTxnId: `T${randomUUID().slice(0, 10)}`, amount: "600000", success: true, resultCode: "00", fields: {} };
    expect(await applyPaymentCallback(prisma, job, qr)).toBe("SUCCESS");
    const view = await bookings.get(null, created.bookingId, created.accessToken);
    return { ...view, accessToken: created.accessToken, job };
  }

  const ledger = (bookingId: string) =>
    prisma.withSystem((tx) =>
      tx.escrowLedger.findMany({ where: { bookingId }, orderBy: [{ createdAt: "asc" }, { entryType: "asc" }], select: { entryType: true, amount: true, commissionRateBps: true, eligibleAt: true } }),
    );

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    redis = new Redis(getRedisUrl(), createRequestRedisClientOptions("payout-test"));
    holds = new SeatHoldService(prisma, redis);
    bookings = new BookingService(prisma, holds, qr);
    cancellations = new CancellationService(prisma, bookings, queue, { dispatch: vi.fn(async () => undefined) } as unknown as NotificationDispatcher);
    trips = new TripService(prisma, {} as AuditService);
    admin = new AdminPayoutService(prisma, { recordAuditEvent } as unknown as AuditService);
    finance = new OperatorFinanceService(prisma);
    await prisma.withSystem(async (tx) => {
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
      await tx.vehicleType.create({ data: { id: vehicleType, code: `PO-${tag}`, name: "Giường", form: "SLEEPER", class: "STANDARD" } });
    });
    await setupOperator(operatorId, true);
    await setupOperator(noBankOperator, false);
    delayDays = await prisma.withSystem((tx) => payoutDelayDays(tx, new Date()));
  }, 60_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    const ids = [operatorId, noBankOperator];
    await prisma.withSystem(async (tx) => {
      await tx.$executeRaw`SELECT set_config('app.allow_ledger_delete', 'on', true)`;
      await tx.payoutItem.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.escrowLedger.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.payoutStatusHistory.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.payout.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.notificationDelivery.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.notification.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.tripChange.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.ticketStatusHistory.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.ticket.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.refundStatusHistory.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.refund.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.paymentStatusHistory.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.payment.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.tripSeat.updateMany({ where: { operatorId: { in: ids } }, data: { bookingId: null } });
      await tx.bookingStatusHistory.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.passengerInfo.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.booking.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.tripSeat.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.tripStop.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.trip.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.fareRule.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.fare.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.routeStop.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.route.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.vehicle.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.seat.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.seatMap.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.bankAccount.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.commissionRule.deleteMany({ where: { operatorId: { in: ids } } });
      await tx.stopPointCatalog.deleteMany({ where: { provinceId: province } });
      await tx.ward.deleteMany({ where: { provinceId: province } });
      await tx.province.deleteMany({ where: { id: province } });
      await tx.vehicleType.deleteMany({ where: { id: vehicleType } });
      await tx.operatorProfile.deleteMany({ where: { id: { in: ids } } });
    });
    await prisma.$disconnect();
    redis.disconnect();
  });

  it("thu tiền → +tổng / −hoa hồng 4% (BIGINT), đủ điều kiện = giờ đến + T ngày; callback lặp không ghi trùng; hoàn 90% → −hoàn / +trả lại hoa hồng; sổ chỉ ghi thêm", async () => {
    const booking = await paidBooking(operatorId);
    const arrival = new Date(booking.trip.arrivalAt).getTime();
    expect(await ledger(booking.bookingId)).toEqual([
      { entryType: "PAYMENT_CAPTURED", amount: 600_000n, commissionRateBps: null, eligibleAt: new Date(arrival + delayDays * DAY) },
      { entryType: "COMMISSION", amount: -24_000n, commissionRateBps: 400, eligibleAt: new Date(arrival + delayDays * DAY) },
    ]);
    expect(await applyPaymentCallback(prisma, booking.job, qr)).toBe("DUPLICATE");
    expect(await ledger(booking.bookingId)).toHaveLength(2);

    await cancellations.cancel(null, booking.bookingId, booking.accessToken, { ticketIds: [booking.tickets[0]!.ticketId], expectedRefund: 270_000, reason: null });
    const refundId = (await prisma.withSystem((tx) => tx.refund.findFirstOrThrow({ where: { bookingId: booking.bookingId }, select: { id: true } }))).id;
    expect(await processRefund(prisma, gateways, refundId, { finalAttempt: false })).toBe("SUCCESS");
    const entries = await ledger(booking.bookingId);
    expect(entries.map((entry) => [entry.entryType, entry.amount])).toEqual([
      ["PAYMENT_CAPTURED", 600_000n],
      ["COMMISSION", -24_000n],
      ["REFUND", -270_000n],
      ["COMMISSION_REVERSAL", 10_800n],
    ]);
    expect(entries.reduce((sum, entry) => sum + entry.amount, 0n)).toBe(316_800n);
    expect(await processRefund(prisma, gateways, refundId, { finalAttempt: false })).toBe("SKIPPED");
    expect(await ledger(booking.bookingId)).toHaveLength(4);

    await expect(prisma.withSystem((tx) => tx.escrowLedger.updateMany({ where: { bookingId: booking.bookingId }, data: { note: "sửa" } }))).rejects.toThrow();
    await expect(prisma.withSystem((tx) => tx.escrowLedger.deleteMany({ where: { bookingId: booking.bookingId } }))).rejects.toThrow();
  });

  it("tạo kỳ T+N: chưa tới hạn → không tạo; tới hạn → kỳ PENDING_REVIEW (thực chi = gom − hoa hồng ròng − hoàn), chạy lại cùng ngày không tạo thêm; booking còn hoàn tiền treo bị giữ ngoài kỳ; nhà xe chưa có tài khoản → ON_HOLD", async () => {
    const pending = await paidBooking(operatorId);
    await cancellations.cancel(null, pending.bookingId, pending.accessToken, { ticketIds: [pending.tickets[1]!.ticketId], expectedRefund: 270_000, reason: null });
    const other = await paidBooking(noBankOperator);

    const before = await generatePayouts(prisma, new Date());
    expect(await prisma.withSystem((tx) => tx.payout.count({ where: { operatorId: { in: [operatorId, noBankOperator] } } }))).toBe(0);
    expect(before.created).toBeGreaterThanOrEqual(0);

    const due = new Date(Date.now() + (delayDays + 3) * DAY);
    await generatePayouts(prisma, due);
    const payouts = await prisma.withSystem((tx) =>
      tx.payout.findMany({ where: { operatorId: { in: [operatorId, noBankOperator] } }, select: { operatorId: true, status: true, grossAmount: true, commissionAmount: true, refundAmount: true, amount: true, payoutCode: true, period: true, holdReason: true, _count: { select: { items: true } } } }),
    );
    const mine = payouts.find((payout) => payout.operatorId === operatorId)!;
    expect(mine).toMatchObject({ status: "PENDING_REVIEW", grossAmount: 600_000n, commissionAmount: 13_200n, refundAmount: 270_000n, amount: 316_800n, _count: { items: 4 } });
    expect(mine.payoutCode).toMatch(new RegExp(`^PO-${vnDate(due).replace(/-/g, "")}-\\d{3,}$`));
    expect(payouts.find((payout) => payout.operatorId === noBankOperator)).toMatchObject({ status: "ON_HOLD", amount: 576_000n, holdReason: "Chưa có tài khoản nhận tiền đã xác minh." });
    expect(other.status).toBe("CONFIRMED");
    // Booking `pending` còn refund APPROVED → không vào kỳ.
    const pendingItems = await prisma.withSystem((tx) => tx.payoutItem.count({ where: { bookingId: pending.bookingId } }));
    expect(pendingItems).toBe(0);

    await generatePayouts(prisma, due);
    expect(await prisma.withSystem((tx) => tx.payout.count({ where: { operatorId } }))).toBe(1);
  });

  it("Admin: rà soát → sẵn sàng; giờ chuyển khoản ở tương lai → 422; xác nhận → PAID + bút toán PAYOUT (sổ của kỳ về 0), audit; xác nhận lại → 409; Mongo lỗi → 503 không đổi gì", async () => {
    const payout = await prisma.withSystem((tx) => tx.payout.findFirstOrThrow({ where: { operatorId }, select: { id: true } }));
    events.length = 0;
    const reviewed = await admin.review(platformAuthz, adminActor, payout.id);
    expect(reviewed).toMatchObject({ status: "READY_TO_TRANSFER", checks: { ledgerMatches: true, noPendingRefunds: true, bankVerified: true }, bank: { accountNumberMasked: "•••• 4521" } });
    expect(reviewed.trips).toHaveLength(1);
    expect(reviewed.trips[0]).toMatchObject({ bookingCount: 1, grossAmount: 600_000, commissionAmount: 13_200, refundAdjustmentAmount: -270_000, amount: 316_800 });

    const future = { bankReference: "FT26286104552", transferredAt: new Date(Date.now() + HOUR), note: "Đã chuyển" };
    expect(await rejectionOf(admin.confirm(platformAuthz, adminActor, payout.id, future))).toMatchObject({ status: 422, code: "PAYOUT_TRANSFER_TIME_INVALID" });
    recordAuditEvent.mockRejectedValueOnce(new AuditWriteError(new Error("mongo down")));
    expect(await rejectionOf(admin.confirm(platformAuthz, adminActor, payout.id, { ...future, transferredAt: new Date() }))).toMatchObject({ status: 503 });
    expect((await admin.get(platformAuthz, payout.id)).status).toBe("READY_TO_TRANSFER");

    const paid = await admin.confirm(platformAuthz, adminActor, payout.id, { ...future, transferredAt: new Date() });
    expect(paid).toMatchObject({ status: "PAID", bankReference: "FT26286104552" });
    expect(paid.histories.map((history) => history.toStatus)).toEqual(["PENDING_REVIEW", "READY_TO_TRANSFER", "PAID"]);
    const payoutEntry = await prisma.withSystem((tx) => tx.escrowLedger.findFirstOrThrow({ where: { payoutId: payout.id }, select: { entryType: true, amount: true } }));
    expect(payoutEntry).toEqual({ entryType: "PAYOUT", amount: -316_800n });
    expect(events.map((event) => event.action)).toEqual(["payout.review", "payout.confirm"]);
    expect(await rejectionOf(admin.confirm(platformAuthz, adminActor, payout.id, { ...future, transferredAt: new Date() }))).toMatchObject({ status: 409, code: "PAYOUT_STATUS_INVALID" });
    expect(await admin.revealBank(platformAuthz, adminActor, payout.id)).toEqual({ bankName: "Vietcombank", accountNumber: "0071000124521", accountHolder: "CTY TEST" });
  });

  it("giữ lại → không rà soát được; mở lại khi đã có tài khoản xác minh → chờ rà soát; hủy → bút toán quay lại kỳ hôm sau", async () => {
    const held = await prisma.withSystem((tx) => tx.payout.findFirstOrThrow({ where: { operatorId: noBankOperator }, select: { id: true } }));
    expect(await rejectionOf(admin.review(platformAuthz, adminActor, held.id))).toMatchObject({ status: 409, code: "PAYOUT_STATUS_INVALID" });
    const stillHeld = await admin.release(platformAuthz, adminActor, held.id);
    expect(stillHeld).toMatchObject({ status: "PENDING_REVIEW", bank: null, checks: { bankVerified: false } });
    expect(await rejectionOf(admin.review(platformAuthz, adminActor, held.id))).toMatchObject({ status: 409, code: "PAYOUT_CHECKS_FAILED", reasons: ["BANK_NOT_VERIFIED"] });
    await admin.hold(platformAuthz, adminActor, held.id, "Chờ xác minh tài khoản");
    await prisma.withSystem((tx) => tx.bankAccount.create({ data: { operatorId: noBankOperator, bankName: "ACB", accountNumber: "12071207", accountHolder: "CTY B", status: "VERIFIED", reviewedAt: new Date() } }));
    expect(await admin.release(platformAuthz, adminActor, held.id)).toMatchObject({ status: "PENDING_REVIEW", bank: { bankName: "ACB" }, checks: { bankVerified: true } });

    const cancelled = await admin.cancel(platformAuthz, adminActor, held.id, "Trùng dữ liệu");
    expect(cancelled).toMatchObject({ status: "CANCELLED", cancelReason: "Trùng dữ liệu" });
    expect(await prisma.withSystem((tx) => tx.payoutItem.count({ where: { payoutId: held.id } }))).toBe(0);
    await generatePayouts(prisma, new Date(Date.now() + (delayDays + 4) * DAY));
    const next = await prisma.withSystem((tx) => tx.payout.findMany({ where: { operatorId: noBankOperator, status: "PENDING_REVIEW" }, select: { amount: true } }));
    expect(next).toEqual([{ amount: 576_000n }]);
  });

  it("màn tài chính nhà xe: tổng quan, giao dịch theo đơn có tình trạng, kỳ chi trả + chi tiết (người thao tác = Vé Xe Nhanh); nhà xe khác không thấy", async () => {
    const at = new Date(Date.now() + (delayDays + 5) * DAY);
    const summary = await finance.summary(tenantAuthz(operatorId), at);
    // Đơn đã chi: sổ về 0; đơn còn hoàn tiền treo: 600.000 − 24.000 đang giữ (chưa vào kỳ).
    expect(summary).toMatchObject({ heldBalance: 576_000, eligibleAmount: 0, pendingAmount: 0, lastPayout: { amount: 316_800 }, payoutDelayDays: delayDays });

    const today = vnDate(new Date());
    const rows = await finance.bookings(tenantAuthz(operatorId), { from: today, to: vnDate(new Date(Date.now() + 5 * DAY)), limit: 20 }, at);
    expect(rows.items.map((row) => [row.state, row.grossAmount, row.commissionAmount, row.refundAdjustmentAmount, row.netAmount]).sort()).toEqual(
      [
        ["ON_HOLD", 600_000, 24_000, 0, 576_000],
        ["PAID", 600_000, 13_200, -270_000, 316_800],
      ].sort(),
    );
    const onlyPaid = await finance.bookings(tenantAuthz(operatorId), { from: today, to: vnDate(new Date(Date.now() + 5 * DAY)), state: "PAID", limit: 20 }, at);
    expect(onlyPaid.items).toHaveLength(1);

    const payouts = await finance.payouts(tenantAuthz(operatorId), { limit: 20 });
    expect(payouts.items.map((payout) => payout.status)).toEqual(["PAID"]);
    const detail = await finance.payout(tenantAuthz(operatorId), payouts.items[0]!.payoutId);
    expect(detail.histories.map((history) => history.actor)).toEqual([null, "Vé Xe Nhanh", "Vé Xe Nhanh"]);
    expect(await rejectionOf(finance.payout(tenantAuthz(noBankOperator), payouts.items[0]!.payoutId))).toMatchObject({ status: 404, code: "PAYOUT_NOT_FOUND" });
    // Quyền `finance:read` của Admin là phạm vi toàn hệ thống — màn tài chính của nhà xe chỉ nhận scope tenant.
    expect(await rejectionOf(finance.summary(platformAuthz))).toMatchObject({ status: 403 });
    expect(await prisma.withTenant(noBankOperator, (tx) => tx.escrowLedger.count({ where: { operatorId } }))).toBe(0);
    expect(await prisma.withTenant(noBankOperator, (tx) => tx.payout.count({ where: { operatorId } }))).toBe(0);
  });
});
