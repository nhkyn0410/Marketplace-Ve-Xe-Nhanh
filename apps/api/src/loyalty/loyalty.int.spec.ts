import { randomUUID } from "node:crypto";
import Redis from "ioredis";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { type AuditEventInput, AuditService } from "../audit/audit.service";
import { BookingService } from "../booking/booking.service";
import { BookingInputSchema } from "../booking/dto/booking.dto";
import { parseAppConfig } from "../config/env.config";
import { platformScope, tenantScope } from "../database/db-scope";
import { listEarnCandidates, listExpiryCandidates, listReversalCandidates } from "../database/loyalty-scope";
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
import { AdminLoyaltyService } from "./admin-loyalty.service";
import { earnForBooking, expireForAccount, reverseForRefund } from "./loyalty-maintenance";
import { appendEntry, lockAccount } from "./loyalty-rules";

/**
 * TASK-LOY-001 trên Postgres + Redis THẬT (role app), chính sách VXN Plus v1 do migration seed (1 điểm / 10.000 ₫, hạng Bạc từ 2.000
 * điểm ×1,2): tích một lần mỗi đơn khi chuyến hoàn thành — chạy song song không trùng, vé vắng mặt / khách vãng lai không tính; hệ số
 * theo hạng; thu hồi theo tỷ lệ tiền hoàn, số dư không đủ → ghi phần thiếu; hết hạn idempotent; Admin tra cứu / điều chỉnh (chống
 * trùng, không âm, audit) / báo cáo; nhà xe không đọc được sổ điểm (RLS), sổ chỉ ghi thêm. Gọi bước của job cho đúng đơn của suite
 * (không chạy cả job — tránh đụng dữ liệu suite khác).
 */
const url = process.env.DATABASE_URL;
const ready = Boolean(url && process.env.REDIS_URL);
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
const HOUR = 3_600_000;

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

describe.skipIf(!ready && !requireDb)("VXN Plus — Postgres + Redis thật (LOY-001)", () => {
  let prisma: PrismaService;
  let redis: Redis;
  let holds: SeatHoldService;
  let bookings: BookingService;
  let trips: TripService;
  let loyalty: AdminLoyaltyService;
  const events: AuditEventInput[] = [];
  const audit = { recordAuditEvent: vi.fn(async (event: AuditEventInput) => void events.push(event)) } as unknown as AuditService;
  const qr = new TicketQrSigner(Buffer.alloc(32, 13));
  const tag = randomUUID().slice(0, 6).toUpperCase().replace(/-/g, "0");
  const operatorId = randomUUID();
  const province = randomUUID();
  const ward = randomUUID();
  const points = [randomUUID(), randomUUID(), randomUUID()];
  const vehicleType = randomUUID();
  const users = { rider: randomUUID(), silver: randomUUID(), expiring: randomUUID() };
  const admin = { sub: randomUUID(), role: "PLATFORM_ADMIN" } as VerifiedAccessToken;
  const ownerAuthz: Authorization = { permission: "trip:manage", scope: "tenant", db: tenantScope(operatorId) };
  const platformAuthz: Authorization = { permission: "loyalty:manage", scope: "any", db: platformScope() };
  let routeId: string;
  let seatMapId: string;

  /** Chuyến 4 chỗ, 300.000 ₫ / chỗ, mở bán sau 48 giờ. */
  async function openTrip() {
    const vehicle = await new VehicleService(prisma, {} as never).create(
      ownerAuthz,
      VehicleInputSchema.parse({ plateNumber: `51H${10000 + Math.floor(Math.random() * 89999)}`, vehicleTypeId: vehicleType, seatMapId, amenityIds: [], status: "ACTIVE", description: null }),
    );
    const departureAt = new Date(Date.now() + 48 * HOUR);
    const trip = await trips.create(
      ownerAuthz,
      TripInputSchema.parse({ routeId, vehicleId: vehicle.id, departureAt: departureAt.toISOString(), arrivalAt: new Date(departureAt.getTime() + 6 * HOUR).toISOString(), stopTimes: null, onlineSaleCutoffMinutes: 60, note: null }),
    );
    await prisma.withSystem((tx) => tx.trip.update({ where: { id: trip.id }, data: { status: "OPEN_FOR_SALE" } }));
    return trip.id;
  }

  /** Đặt + thanh toán; `userId` = đơn của hành khách có tài khoản, `null` = khách vãng lai. */
  async function paidBooking(tripId: string, seatCodes: string[], userId: string | null) {
    const hold = await holds.create(null, undefined, SeatHoldInputSchema.parse({ tripId, seatCodes, pickupSequence: 1, dropoffSequence: 3 }));
    const booking = await bookings.create(
      null,
      BookingInputSchema.parse({
        holdId: hold.holdId,
        contact: { fullName: "Khách", phone: "0901234567", email: "k@example.com" },
        passengers: seatCodes.map((seatCode) => ({ seatCode, fullName: `Khách ${seatCode}`, phone: null })),
        note: null,
        expectedTotal: seatCodes.length * 300_000,
      }),
    );
    if (userId) {
      await prisma.withSystem((tx) => tx.booking.update({ where: { id: booking.bookingId }, data: { userId } }));
    }
    const paymentCode = `PAY${randomUUID().replace(/-/g, "").slice(0, 12).toUpperCase()}`;
    const amount = seatCodes.length * 300_000;
    await prisma.withTenant(operatorId, (tx) =>
      tx.payment.create({ data: { paymentCode, operatorId, bookingId: booking.bookingId, provider: "VNPAY", status: "PROCESSING", amount: BigInt(amount), expiresAt: new Date(Date.now() + 600_000) } }),
    );
    expect(await applyPaymentCallback(prisma, { provider: "VNPAY", paymentCode, providerTxnId: `T${randomUUID().slice(0, 10)}`, amount: String(amount), success: true, resultCode: "00", fields: {} }, qr)).toBe("SUCCESS");
    return booking.bookingId;
  }

  async function completeTrip(tripId: string) {
    await prisma.withSystem((tx) => tx.trip.update({ where: { id: tripId }, data: { status: "COMPLETED", completedAt: new Date() } }));
  }

  const system = <T>(work: Parameters<PrismaService["withSystem"]>[0]) => prisma.withSystem(work) as Promise<T>;
  const ledger = (userId: string) =>
    prisma.withSystem((tx) => tx.loyaltyPointTransaction.findMany({ where: { account: { userId } }, orderBy: [{ createdAt: "asc" }, { id: "asc" }] }));
  const balance = async (userId: string) => (await prisma.withSystem((tx) => tx.loyaltyAccount.findUnique({ where: { userId } })))?.availablePoints ?? null;

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    redis = new Redis(getRedisUrl(), createRequestRedisClientOptions("loyalty-test"));
    holds = new SeatHoldService(prisma, redis);
    bookings = new BookingService(prisma, holds, qr);
    trips = new TripService(prisma, {} as AuditService);
    loyalty = new AdminLoyaltyService(prisma, audit);
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.create({ data: { id: operatorId, operatorSlug: `ly-${tag.toLowerCase()}`, displayName: `Nhà xe thành viên ${tag}` } });
      await tx.user.createMany({
        data: Object.entries(users).map(([key, id]) => ({ id, email: `loy-${key}-${tag.toLowerCase()}@example.com`, name: `Thành viên ${key}` })),
      });
      await tx.platformAccount.create({ data: { id: admin.sub, username: `loy${tag.toLowerCase()}`, role: "PLATFORM_ADMIN", passwordHash: "x" } });
      await tx.province.create({ data: { id: province, code: `lp-${tag}`, name: "Tỉnh" } });
      await tx.ward.create({ data: { id: ward, provinceId: province, code: `lw-${tag}`, name: "Phường" } });
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
      await tx.vehicleType.create({ data: { id: vehicleType, code: `LY-${tag}`, name: "Giường", form: "SLEEPER", class: "STANDARD" } });
    });
    routeId = (
      await new RouteService(prisma, new FakeRouting()).create(
        ownerAuthz,
        RouteInputSchema.parse({
          name: `Tuyến thành viên ${tag}`,
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
    const userIds = Object.values(users);
    await prisma.withSystem(async (tx) => {
      await tx.$executeRaw`SELECT set_config('app.allow_ledger_delete', 'on', true)`;
      await tx.loyaltyPointTransaction.deleteMany({ where: { account: { userId: { in: userIds } } } });
      await tx.loyaltyAccount.deleteMany({ where: { userId: { in: userIds } } });
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
      await tx.operatorLoginName.deleteMany({ where: { operatorId } });
      await tx.operatorProfile.deleteMany({ where: { id: operatorId } });
      await tx.platformAccount.deleteMany({ where: { id: admin.sub } });
      await tx.user.deleteMany({ where: { id: { in: userIds } } });
    });
    redis?.disconnect();
    await prisma.$disconnect();
  }, 60_000);

  it("tích một lần khi chuyến hoàn thành: song song không trùng, vé vắng mặt + khách vãng lai không tính; thu hồi theo tiền hoàn, thiếu số dư → ghi phần thiếu", async () => {
    const tripId = await openTrip();
    const riderBooking = await paidBooking(tripId, ["A1", "A2", "A3"], users.rider);
    const guestBooking = await paidBooking(tripId, ["A4"], null);
    // A3 vắng mặt → căn cứ = 2 × 300.000.
    await prisma.withSystem((tx) => tx.ticket.updateMany({ where: { bookingId: riderBooking, seatCode: "A3" }, data: { status: "NO_SHOW" } }));

    // Chuyến chưa hoàn thành → chưa tích.
    expect(await system<boolean>((tx) => earnForBooking(tx, riderBooking, new Date()))).toBe(false);
    await completeTrip(tripId);
    const since = new Date(Date.now() - HOUR);
    const candidates = await listEarnCandidates(prisma, since, 10_000);
    expect(candidates).toContain(riderBooking);
    expect(candidates).not.toContain(guestBooking);
    expect(await system<boolean>((tx) => earnForBooking(tx, guestBooking, new Date()))).toBe(false);

    // Hai lần chạy cùng lúc (worker trùng lịch) → đúng một giao dịch, tài khoản tạo một lần.
    const runs = await Promise.all([0, 1].map(() => system<boolean>((tx) => earnForBooking(tx, riderBooking, new Date()))));
    expect(runs.filter(Boolean)).toHaveLength(1);
    expect(await system<boolean>((tx) => earnForBooking(tx, riderBooking, new Date()))).toBe(false);
    expect(await listEarnCandidates(prisma, since, 10_000)).not.toContain(riderBooking);
    const [earn] = await ledger(users.rider);
    expect(earn).toMatchObject({ type: "EARN", points: 60, tier: "BRONZE", basisAmount: 600_000n, bookingId: riderBooking, policyVersion: 1, actor: "system" });
    expect(earn!.sourceLabel).toMatch(/· hệ số ×1$/);
    expect(Math.abs(earn!.expiresAt!.getTime() - Date.now() - 365 * 24 * HOUR)).toBeLessThan(2 * 24 * HOUR);
    expect(await balance(users.rider)).toBe(60);

    // Admin trừ 55 → còn 5; hoàn theo quyết định tranh chấp 300.000 (không gắn vé) → cần thu 30, chỉ thu được 5, ghi thiếu 25.
    await loyalty.adjust(platformAuthz, admin, users.rider, { direction: "DEBIT", points: 55, reason: "Điều chỉnh thử" }, randomUUID());
    const paymentId = (await prisma.withSystem((tx) => tx.payment.findFirstOrThrow({ where: { bookingId: riderBooking, status: "SUCCESS" }, select: { id: true } }))).id;
    const refund = await prisma.withTenant(operatorId, (tx) =>
      tx.refund.create({
        data: { refundCode: `RFD${randomUUID().replace(/-/g, "").slice(0, 12).toUpperCase()}`, operatorId, bookingId: riderBooking, paymentId, status: "SUCCESS", amount: 300_000n, refundPercent: 50, reason: "Tranh chấp (thử)", requestedBy: "platform:test", processedAt: new Date(Date.now() + 1_000) },
      }),
    );
    expect(await listReversalCandidates(prisma, 10_000)).toContainEqual({ refundId: refund.id, bookingId: riderBooking });
    expect(await system<boolean>((tx) => reverseForRefund(tx, refund.id, riderBooking, new Date()))).toBe(true);
    expect(await system<boolean>((tx) => reverseForRefund(tx, refund.id, riderBooking, new Date()))).toBe(false);
    expect(await listReversalCandidates(prisma, 10_000)).not.toContainEqual({ refundId: refund.id, bookingId: riderBooking });
    const reversal = (await ledger(users.rider)).find((row) => row.type === "REVERSAL");
    expect(reversal).toMatchObject({ points: -5, basisAmount: 300_000n, policyVersion: 1, reason: "Số dư không đủ — thiếu 25 điểm (BR-67)." });
    expect(await balance(users.rider)).toBe(0);
  }, 120_000);

  it("hệ số theo hạng: đã tích 2.000 điểm trong 12 tháng → hạng Bạc ×1,2; hết hạn điểm idempotent", async () => {
    const tripId = await openTrip();
    const booking = await paidBooking(tripId, ["A1"], users.silver);
    await completeTrip(tripId);
    await prisma.withSystem(async (tx) => {
      const account = await lockAccount(tx, users.silver);
      await appendEntry(tx, account.id, { type: "EARN", points: 2_000, tier: "BRONZE", sourceLabel: "Dữ liệu thử", idempotencyKey: `TEST:${randomUUID()}`, actor: "system", policy: null }, new Date(Date.now() - 24 * HOUR));
    });
    expect(await system<boolean>((tx) => earnForBooking(tx, booking, new Date()))).toBe(true);
    const earn = (await ledger(users.silver)).find((row) => row.bookingId === booking);
    expect(earn).toMatchObject({ points: 36, tier: "SILVER" });
    expect(earn!.sourceLabel).toContain("×1,2");
    expect(await balance(users.silver)).toBe(2_036);

    // Hết hạn: lô 100 điểm đã tới hạn, đã đổi 30 → hết hạn 70; chạy lại → không ghi thêm.
    const now = new Date();
    const accountId = await prisma.withSystem(async (tx) => {
      const account = await lockAccount(tx, users.expiring);
      await appendEntry(tx, account.id, { type: "EARN", points: 100, tier: "BRONZE", sourceLabel: "Lô cũ", idempotencyKey: `TEST:${randomUUID()}`, actor: "system", policy: null, expiresAt: new Date(now.getTime() - HOUR) }, new Date(now.getTime() - 400 * 24 * HOUR));
      await appendEntry(tx, account.id, { type: "EARN", points: 50, tier: "BRONZE", sourceLabel: "Lô mới", idempotencyKey: `TEST:${randomUUID()}`, actor: "system", policy: null, expiresAt: new Date(now.getTime() + 100 * 24 * HOUR) }, new Date(now.getTime() - 10 * 24 * HOUR));
      await appendEntry(tx, account.id, { type: "REDEEM", points: -30, tier: "BRONZE", sourceLabel: "Voucher thử", idempotencyKey: `TEST:${randomUUID()}`, actor: "system", policy: null }, new Date(now.getTime() - 5 * 24 * HOUR));
      return account.id;
    });
    expect(await listExpiryCandidates(prisma, now, 10_000)).toContain(accountId);
    expect(await system<boolean>((tx) => expireForAccount(tx, accountId, now))).toBe(true);
    expect(await system<boolean>((tx) => expireForAccount(tx, accountId, now))).toBe(false);
    expect(await listExpiryCandidates(prisma, now, 10_000)).not.toContain(accountId);
    expect((await ledger(users.expiring)).filter((row) => row.type === "EXPIRE").map((row) => row.points)).toEqual([-70]);
    expect(await balance(users.expiring)).toBe(50);
  }, 120_000);

  it("Admin: tra cứu theo email, điều chỉnh chống trùng + không âm + audit, lịch sử mới nhất trước, báo cáo quý theo hạng", async () => {
    const member = await loyalty.member(platformAuthz, `LOY-SILVER-${tag}@EXAMPLE.COM`.toLowerCase());
    expect(member).toMatchObject({ userId: users.silver, availablePoints: 2_036, earned12m: 2_036, tier: "SILVER", nextTier: { tier: "GOLD", minPoints: 5_000, remaining: 2_964 }, policyVersion: 1 });
    expect(await rejectionOf(loyalty.member(platformAuthz, `khong-co-${tag}@example.com`))).toMatchObject({ status: 404, code: "LOYALTY_MEMBER_NOT_FOUND" });

    const key = randomUUID();
    const credit = { direction: "CREDIT" as const, points: 50, reason: "Bù do sự cố chuyến" };
    expect((await loyalty.adjust(platformAuthz, admin, users.silver, credit, key)).availablePoints).toBe(2_086);
    // Gửi lại cùng Idempotency-Key → không ghi thêm.
    expect((await loyalty.adjust(platformAuthz, admin, users.silver, credit, key)).availablePoints).toBe(2_086);
    expect(await rejectionOf(loyalty.adjust(platformAuthz, admin, users.rider, credit, key))).toMatchObject({ status: 409, code: "LOYALTY_REQUEST_CONFLICT" });
    expect(await rejectionOf(loyalty.adjust(platformAuthz, admin, users.silver, { ...credit, direction: "DEBIT", points: 5_000 }, randomUUID()))).toMatchObject({
      status: 409,
      code: "LOYALTY_INSUFFICIENT_POINTS",
    });
    const adjusts = (await ledger(users.silver)).filter((row) => row.type === "ADJUST");
    expect(adjusts).toHaveLength(1);
    expect(adjusts[0]).toMatchObject({ points: 50, tier: "SILVER", actor: `platform:${admin.sub}`, reason: "Bù do sự cố chuyến", sourceLabel: `platform/loy${tag.toLowerCase()} · Bù do sự cố chuyến` });
    expect(adjusts[0]!.expiresAt).not.toBeNull();
    expect(events.filter((event) => event.action === "loyalty.adjust" && event.after?.points === 50)).toEqual([
      expect.objectContaining({ actorId: admin.sub, targetType: "loyalty_account", before: { availablePoints: 2_036 }, after: { availablePoints: 2_086, points: 50 }, reason: "Bù do sự cố chuyến" }),
    ]);

    const page = await loyalty.transactions(platformAuthz, users.silver, { offset: 0, limit: 2 });
    expect(page.total).toBe(3);
    expect(page.items.map((item) => item.type)).toEqual(["ADJUST", "EARN"]);
    expect((await loyalty.transactions(platformAuthz, users.silver, { offset: 2, limit: 2 })).items.map((item) => item.points)).toEqual([2_000]);

    // Báo cáo quý hiện tại (giờ VN): lọc hạng Bạc → điểm tích 36 + điều chỉnh cộng 50 của suite này nằm trong số phát hành.
    const local = new Date(Date.now() + 7 * HOUR);
    const quarter = Math.floor(local.getUTCMonth() / 3) + 1;
    const silver = await loyalty.report(platformAuthz, { year: local.getUTCFullYear(), quarter, tier: "SILVER" });
    const all = await loyalty.report(platformAuthz, { year: local.getUTCFullYear(), quarter });
    expect(silver.months[0]!.month).toBe(`${local.getUTCFullYear()}-${String(local.getUTCMonth() + 1).padStart(2, "0")}`);
    expect(silver.totals.issued).toBeGreaterThanOrEqual(86);
    expect(all.totals.issued).toBeGreaterThanOrEqual(silver.totals.issued + 60);
    expect(all.totals.expired).toBeGreaterThanOrEqual(70);
    expect(silver.totals).toMatchObject({ vouchersUsed: 0, platformDiscount: 0 });
    // Quý tương lai → chưa có tháng nào.
    expect((await loyalty.report(platformAuthz, { year: local.getUTCFullYear() + 1, quarter: 1 })).months).toEqual([]);
  }, 60_000);

  it("RLS + chỉ ghi thêm: nhà xe không đọc / ghi sổ điểm; không sửa / xóa giao dịch đã ghi", async () => {
    const count = await prisma.withTenant(operatorId, (tx) => tx.loyaltyPointTransaction.count({ where: { account: { userId: users.silver } } }));
    expect(count).toBe(0);
    expect(await prisma.withTenant(operatorId, (tx) => tx.loyaltyAccount.count({ where: { userId: users.silver } }))).toBe(0);
    await expect(prisma.withTenant(operatorId, (tx) => tx.loyaltyAccount.create({ data: { userId: randomUUID() } }))).rejects.toThrow();
    const [row] = await ledger(users.silver);
    await expect(prisma.withSystem((tx) => tx.loyaltyPointTransaction.update({ where: { id: row!.id }, data: { points: 9_999 } }))).rejects.toThrow(/append-only/);
    await expect(prisma.withSystem((tx) => tx.loyaltyPointTransaction.delete({ where: { id: row!.id } }))).rejects.toThrow(/append-only/);
    // Số dư âm bị CHECK chặn kể cả khi ghi thẳng.
    await expect(prisma.withSystem((tx) => tx.loyaltyAccount.update({ where: { userId: users.silver }, data: { availablePoints: -1 } }))).rejects.toThrow();
  }, 60_000);
});
