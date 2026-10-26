import { createHash, randomUUID } from "node:crypto";
import Redis from "ioredis";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import type { BookingService, GuestLookupBooking } from "../booking/booking.service";
import type { BookingResponse } from "../booking/dto/booking.dto";
import type { PrismaService } from "../database/prisma.service";
import type { EmailNotifier, OtpEmailMessage } from "../external/notification/email-notifier";
import { createRequestRedisClientOptions, getRedisUrl } from "../redis/redis.config";
import { TicketLookupOtpInputSchema, TicketLookupVerifyInputSchema } from "./dto/ticket.dto";
import { TicketService } from "./ticket.service";

/**
 * Tra cứu vé khách vãng lai bắt buộc OTP (UX-OQ-09) trên Redis THẬT — các script Lua giữ / kiểm mã và phiên tra cứu, theo
 * mã đặt vé hoặc chỉ email (27/10/2026). Booking / tài khoản là bản giả (Postgres đã có ở `payment.int.spec.ts`).
 * Chạy khi có `REDIS_URL`.
 */
const ready = Boolean(process.env.REDIS_URL);
const requireDb = process.env.REQUIRE_DB_TESTS === "1";

async function failure(promise: Promise<unknown>): Promise<{ status?: number; code?: string; detail?: string }> {
  try {
    await promise;
    return {};
  } catch (error) {
    const response = (error as { getResponse?: () => { code?: string; detail?: string } }).getResponse?.();
    return { status: (error as { getStatus?: () => number }).getStatus?.(), code: response?.code, detail: response?.detail };
  }
}

describe.skipIf(!ready && !requireDb)("Tra cứu vé khách vãng lai — OTP trên Redis thật", () => {
  let redis: Redis;
  let service: TicketService;
  const sent: OtpEmailMessage[] = [];
  const tag = randomUUID().slice(0, 8);
  const email = `khach-${tag}@example.com`;
  const accountEmail = `tk-${tag}@example.com`;
  const code = `VXN${randomUUID().replace(/-/g, "").slice(0, 6).toUpperCase()}`;
  const [guestBookingId, accountBookingId, otherBookingId] = [randomUUID(), randomUUID(), randomUUID()];
  const row = (bookingId: string, bookingCode: string, bookedWithAccount: boolean): GuestLookupBooking => ({
    bookingId, bookingCode, status: "CONFIRMED", routeName: "Tuyến", operatorName: "Nhà xe", departureAt: "2026-10-29T15:30:00.000Z",
    ticketCount: 1, total: 280_000n, bookedWithAccount, createdAt: new Date("2026-10-20T00:00:00Z"),
  });
  /** `email`: hai đơn (một đơn đặt bằng tài khoản); `accountEmail`: một đơn, email có tài khoản; email khác: không có đơn. */
  const owned: Record<string, GuestLookupBooking[]> = {
    [email]: [row(guestBookingId, code, false), row(accountBookingId, "VXNACC001", true)],
    [accountEmail]: [row(otherBookingId, "VXNOTH001", false)],
  };
  const bookings = {
    matchGuestContact: async (bookingCode: string, contact: string) => (bookingCode === code && contact === email ? guestBookingId : null),
    listForGuestLookup: async (scope: { email: string; bookingId: string | null }, _since: Date, limit: number) =>
      (owned[scope.email] ?? []).filter((item) => !scope.bookingId || item.bookingId === scope.bookingId).slice(0, limit),
    getForLookup: async (id: string, match?: { email: string }) => {
      const found = Object.entries(owned).find(([owner, items]) => items.some((item) => item.bookingId === id) && (!match || owner === match.email));
      return found ? ({ bookingId: id } as BookingResponse) : null;
    },
  } as unknown as BookingService;
  const prisma = {
    withSystem: async (work: (tx: unknown) => unknown) =>
      work({ user: { findFirst: async ({ where }: { where: { email: string } }) => (where.email === accountEmail ? { id: "u1" } : null) } }),
  } as unknown as PrismaService;
  const ip = () => `10.99.${Math.floor(Math.random() * 250)}.${Math.floor(Math.random() * 250)}`;
  const sha256 = (value: string) => createHash("sha256").update(value).digest("hex");
  const emailKey = (contact: string) => `ticket-lookup:email:${sha256(contact)}`;
  const request = (contact: string, bookingCode?: string, clientIp = ip()) =>
    service.requestOtp(clientIp, TicketLookupOtpInputSchema.parse({ email: contact, ...(bookingCode ? { bookingCode } : {}) }));
  const verify = (otp: string, contact = email, bookingCode?: string) =>
    service.verifyOtp(TicketLookupVerifyInputSchema.parse({ email: contact, otp, ...(bookingCode ? { bookingCode } : {}) }));
  const wrong = (otp: string) => (otp === "000000" ? "111111" : "000000");
  const clearLimits = (contact = email) => redis.del(`${emailKey(contact)}:cooldown`, `${emailKey(contact)}:count`);
  const lastOtp = () => sent.at(-1)!.otp;

  beforeAll(() => {
    redis = new Redis(getRedisUrl(), createRequestRedisClientOptions("ticket-lookup-test"));
    const notifier = { sendOtp: async (message: OtpEmailMessage) => void sent.push(message) } as unknown as EmailNotifier;
    service = new TicketService(prisma, bookings, {} as never, redis, notifier);
  });

  afterAll(async () => {
    for (const contact of [email, accountEmail, `la-${tag}@example.com`]) await clearLimits(contact);
    await redis.quit();
  });

  it("phản hồi như nhau dù có đơn hay không; chỉ gửi mã khi có đơn (theo mã đặt vé hoặc chỉ email); chờ 60 giây và tối đa 5 mã / giờ tính theo email", async () => {
    const neutral = { expiresInSeconds: 300, resendAfterSeconds: 60, maxAttempts: 5 };
    expect(await request(`la-${tag}@example.com`)).toEqual({ maskedEmail: "l***@example.com", ...neutral });
    expect(await request(email.toUpperCase(), code.toLowerCase())).toEqual({ maskedEmail: "k***@example.com", ...neutral });
    expect(sent.map((message) => [message.email, message.purpose])).toEqual([[email, "ticket-lookup"]]);
    expect(lastOtp()).toMatch(/^\d{6}$/);
    // Đổi sang tra theo email (không mã) vẫn chung thời gian chờ của email đó.
    expect(await failure(request(email))).toMatchObject({ status: 429, code: "TICKET_LOOKUP_RATE_LIMITED", detail: "Vui lòng đợi 60 giây trước khi gửi lại mã." });
    for (let index = 0; index < 4; index++) {
      await redis.del(`${emailKey(email)}:cooldown`);
      await request(email, index % 2 ? code : undefined);
    }
    await redis.del(`${emailKey(email)}:cooldown`);
    expect(await failure(request(email))).toMatchObject({ status: 429, detail: "Bạn đã yêu cầu quá nhiều mã cho email này. Vui lòng thử lại sau 1 giờ." });
    expect(sent).toHaveLength(5);
    await clearLimits();
  });

  it("sai mã trừ lượt (còn 4 … 1), lần thứ 5 hủy mã — mã đúng gửi sau đó cũng không dùng được", async () => {
    await request(email);
    const otp = lastOtp();
    for (const remaining of [4, 3, 2, 1]) {
      expect(await failure(verify(wrong(otp)))).toMatchObject({ status: 422, code: "TICKET_LOOKUP_OTP_INVALID", detail: `Mã xác minh không đúng. Còn ${remaining} lần thử.` });
    }
    expect(await failure(verify(wrong(otp)))).toMatchObject({ status: 422, detail: "Mã xác minh không đúng hoặc đã hết hạn. Vui lòng gửi lại mã." });
    expect(await failure(verify(otp))).toMatchObject({ status: 422, code: "TICKET_LOOKUP_OTP_INVALID" });
    await clearLimits();
  });

  it("phiên theo email: liệt kê mọi đơn của email (cả đơn đặt bằng tài khoản), xem chi tiết phải chọn đơn trong danh sách", async () => {
    await request(email);
    const session = await verify(lastOtp());
    expect(session.lookupToken).toMatch(/^[A-Za-z0-9_-]{43}$/);
    const ttl = await redis.ttl(`ticket-lookup:session:${sha256(session.lookupToken)}`);
    expect(ttl).toBeGreaterThan(890);
    expect(ttl).toBeLessThanOrEqual(900);
    const list = await service.listBookings({ lookupToken: session.lookupToken });
    expect(list).toMatchObject({ maskedEmail: "k***@example.com", scope: "EMAIL", hasAccount: false });
    expect(list.items.map((item) => [item.bookingCode, item.bookedWithAccount, item.total])).toEqual([[code, false, 280_000], ["VXNACC001", true, 280_000]]);
    expect(await service.lookup({ lookupToken: session.lookupToken, bookingId: accountBookingId })).toEqual({ bookingId: accountBookingId });
    expect(await failure(service.lookup({ lookupToken: session.lookupToken }))).toMatchObject({ status: 404, code: "BOOKING_NOT_FOUND" });
    expect(await failure(service.lookup({ lookupToken: session.lookupToken, bookingId: otherBookingId }))).toMatchObject({ status: 404, code: "BOOKING_NOT_FOUND" });
    expect(await failure(verify(lastOtp()))).toMatchObject({ status: 422 });
    expect(await failure(service.listBookings({ lookupToken: `${session.lookupToken.slice(0, -1)}x` }))).toMatchObject({ status: 404, code: "TICKET_LOOKUP_EXPIRED" });
    await clearLimits();
  });

  it("phiên theo mã đặt vé chỉ thấy đúng đơn đó; email có tài khoản → gợi ý đăng nhập", async () => {
    await request(email, code);
    const session = await verify(lastOtp(), email, code);
    const list = await service.listBookings({ lookupToken: session.lookupToken });
    expect(list).toMatchObject({ scope: "BOOKING", hasAccount: false });
    expect(list.items.map((item) => item.bookingId)).toEqual([guestBookingId]);
    expect(await service.lookup({ lookupToken: session.lookupToken })).toEqual({ bookingId: guestBookingId });
    expect(await failure(service.lookup({ lookupToken: session.lookupToken, bookingId: accountBookingId }))).toMatchObject({ status: 404, code: "BOOKING_NOT_FOUND" });

    await request(accountEmail);
    const accountSession = await verify(lastOtp(), accountEmail);
    expect(await service.listBookings({ lookupToken: accountSession.lookupToken })).toMatchObject({ scope: "EMAIL", hasAccount: true });
    await clearLimits();
  });

  it("email không có đơn / sai mã đặt vé không bao giờ xác minh được; quá 10 lần gửi mã / 10 phút / IP bị chặn", async () => {
    for (const otp of ["000000", "123456"]) {
      expect(await failure(verify(otp, `la-${tag}@example.com`))).toMatchObject({ status: 422, code: "TICKET_LOOKUP_OTP_INVALID" });
    }
    const address = ip();
    for (let index = 0; index < 10; index++) {
      await request(`ip${index}-${tag}@example.com`, undefined, address);
    }
    expect(await failure(request(`ip-last-${tag}@example.com`, undefined, address))).toMatchObject({ status: 429, code: "TICKET_LOOKUP_RATE_LIMITED" });
  });

  it("Redis lỗi → 503, không bỏ qua giới hạn", async () => {
    const down = new Redis("redis://127.0.0.1:1", { lazyConnect: true, maxRetriesPerRequest: 0, enableOfflineQueue: false, retryStrategy: () => null });
    const offline = new TicketService(prisma, bookings, {} as never, down, {} as EmailNotifier);
    expect(await failure(offline.requestOtp(ip(), TicketLookupOtpInputSchema.parse({ email })))).toMatchObject({ status: 503 });
    expect(await failure(offline.listBookings({ lookupToken: "x".repeat(43) }))).toMatchObject({ status: 503 });
    expect(await failure(offline.lookup({ lookupToken: "x".repeat(43) }))).toMatchObject({ status: 503 });
    down.disconnect();
  });
});
