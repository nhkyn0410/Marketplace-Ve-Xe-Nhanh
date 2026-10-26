import { createHash, randomUUID } from "node:crypto";
import Redis from "ioredis";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import type { BookingService } from "../booking/booking.service";
import type { BookingResponse } from "../booking/dto/booking.dto";
import type { EmailNotifier, OtpEmailMessage } from "../external/notification/email-notifier";
import { createRequestRedisClientOptions, getRedisUrl } from "../redis/redis.config";
import { TicketLookupOtpInputSchema, TicketLookupVerifyInputSchema } from "./dto/ticket.dto";
import { TicketService } from "./ticket.service";

/**
 * Tra cứu vé khách vãng lai bắt buộc OTP (UX-OQ-09) trên Redis THẬT — các script Lua giữ / kiểm mã và phiên tra cứu.
 * Booking là bản giả (Postgres đã có ở `payment.int.spec.ts`). Chạy khi có `REDIS_URL`.
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
  const bookingId = randomUUID();
  const code = `VXN${randomUUID().replace(/-/g, "").slice(0, 6).toUpperCase()}`;
  const email = "khach@example.com";
  const booking = { bookingId, bookingCode: code } as BookingResponse;
  const bookings = {
    matchGuestContact: async (bookingCode: string, contact: string) => (bookingCode === code && contact === email ? bookingId : null),
    getForLookup: async (id: string) => (id === bookingId ? booking : null),
  } as unknown as BookingService;
  const ip = () => `10.99.${Math.floor(Math.random() * 250)}.${Math.floor(Math.random() * 250)}`;
  const challengeKey = (bookingCode: string, contact: string) =>
    `ticket-lookup:otp:${createHash("sha256").update(`${bookingCode}|${contact}`).digest("hex")}`;
  const request = (contact: string, clientIp = ip(), bookingCode = code) => service.requestOtp(clientIp, TicketLookupOtpInputSchema.parse({ bookingCode, email: contact }));
  const verify = (otp: string, contact = email) => service.verifyOtp(TicketLookupVerifyInputSchema.parse({ bookingCode: code, email: contact, otp }));
  const wrong = (otp: string) => (otp === "000000" ? "111111" : "000000");
  const clearCooldown = (contact = email) => redis.del(`${challengeKey(code, contact)}:cooldown`);

  beforeAll(() => {
    redis = new Redis(getRedisUrl(), createRequestRedisClientOptions("ticket-lookup-test"));
    const notifier = { sendOtp: async (message: OtpEmailMessage) => void sent.push(message) } as unknown as EmailNotifier;
    service = new TicketService({} as never, bookings, {} as never, redis, notifier);
  });

  afterAll(async () => {
    const keys = await redis.keys(`${challengeKey(code, email)}*`);
    if (keys.length) await redis.del(...keys);
    await redis.quit();
  });

  it("phản hồi như nhau dù khớp hay không; chỉ cặp khớp nhận mã; gửi lại phải chờ 60 giây; tối đa 5 mã / giờ", async () => {
    const neutral = { expiresInSeconds: 300, resendAfterSeconds: 60, maxAttempts: 5 };
    expect(await request("la@example.com")).toEqual({ maskedEmail: "l***@example.com", ...neutral });
    expect(await request("Khach@Example.com", ip(), code.toLowerCase())).toEqual({ maskedEmail: "k***@example.com", ...neutral });
    expect(sent.map((message) => [message.email, message.purpose])).toEqual([[email, "ticket-lookup"]]);
    expect(sent[0]!.otp).toMatch(/^\d{6}$/);
    expect(await failure(request(email))).toMatchObject({ status: 429, code: "TICKET_LOOKUP_RATE_LIMITED", detail: "Vui lòng đợi 60 giây trước khi gửi lại mã." });
    for (let index = 0; index < 4; index++) {
      await clearCooldown();
      await request(email);
    }
    await clearCooldown();
    expect(await failure(request(email))).toMatchObject({ status: 429, code: "TICKET_LOOKUP_RATE_LIMITED" });
    await redis.del(`${challengeKey(code, email)}:count`, `${challengeKey(code, email)}:cooldown`);
  });

  it("sai mã trừ lượt (còn 4 … 1), lần thứ 5 hủy mã — mã đúng gửi sau đó cũng không dùng được", async () => {
    sent.length = 0;
    await clearCooldown();
    await request(email);
    const otp = sent.at(-1)!.otp;
    for (const remaining of [4, 3, 2, 1]) {
      expect(await failure(verify(wrong(otp)))).toMatchObject({ status: 422, code: "TICKET_LOOKUP_OTP_INVALID", detail: `Mã xác minh không đúng. Còn ${remaining} lần thử.` });
    }
    expect(await failure(verify(wrong(otp)))).toMatchObject({ status: 422, detail: "Mã xác minh không đúng hoặc đã hết hạn. Vui lòng gửi lại mã." });
    expect(await failure(verify(otp))).toMatchObject({ status: 422, code: "TICKET_LOOKUP_OTP_INVALID" });
  });

  it("đúng mã → phiên 15 phút đọc được booking nhiều lần; mã chỉ dùng một lần; gửi lại thay mã cũ", async () => {
    sent.length = 0;
    await clearCooldown();
    await request(email);
    const first = sent.at(-1)!.otp;
    await clearCooldown();
    await request(email);
    const second = sent.at(-1)!.otp;
    if (first !== second) {
      expect(await failure(verify(first))).toMatchObject({ status: 422 });
    }
    const session = await verify(second);
    expect(session.lookupToken).toMatch(/^[A-Za-z0-9_-]{43}$/);
    const ttl = await redis.ttl(`ticket-lookup:session:${createHash("sha256").update(session.lookupToken).digest("hex")}`);
    expect(ttl).toBeGreaterThan(890);
    expect(ttl).toBeLessThanOrEqual(900);
    expect(await service.lookup({ lookupToken: session.lookupToken })).toBe(booking);
    expect(await service.lookup({ lookupToken: session.lookupToken })).toBe(booking);
    expect(await failure(verify(second))).toMatchObject({ status: 422 });
    expect(await failure(service.lookup({ lookupToken: `${session.lookupToken.slice(0, -1)}x` }))).toMatchObject({ status: 404, code: "TICKET_LOOKUP_EXPIRED" });
  });

  it("cặp không khớp không bao giờ xác minh được; quá 10 lần gửi mã / 10 phút / IP bị chặn", async () => {
    for (const otp of ["000000", "123456"]) {
      expect(await failure(verify(otp, "la@example.com"))).toMatchObject({ status: 422, code: "TICKET_LOOKUP_OTP_INVALID" });
    }
    const address = ip();
    for (let index = 0; index < 10; index++) {
      await request(`ip${index}@example.com`, address);
    }
    expect(await failure(request("ip-last@example.com", address))).toMatchObject({ status: 429, code: "TICKET_LOOKUP_RATE_LIMITED" });
  });

  it("Redis lỗi → 503, không bỏ qua giới hạn", async () => {
    const down = new Redis("redis://127.0.0.1:1", { lazyConnect: true, maxRetriesPerRequest: 0, enableOfflineQueue: false, retryStrategy: () => null });
    const offline = new TicketService({} as never, bookings, {} as never, down, {} as EmailNotifier);
    expect(await failure(offline.requestOtp(ip(), TicketLookupOtpInputSchema.parse({ bookingCode: code, email })))).toMatchObject({ status: 503 });
    expect(await failure(offline.lookup({ lookupToken: "x".repeat(43) }))).toMatchObject({ status: 503 });
    down.disconnect();
  });
});
