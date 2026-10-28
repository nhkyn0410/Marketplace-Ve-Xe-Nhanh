import { createHash, randomBytes, randomInt } from "node:crypto";
import { Inject, Injectable, Logger } from "@nestjs/common";
import type Redis from "ioredis";
import { ACCESS_GRANT_SELECT, canAccessBooking } from "../booking/booking-access";
import { BookingService } from "../booking/booking.service";
import { vndToJson } from "../fare/fare-pricing";
import type { BookingResponse } from "../booking/dto/booking.dto";
import { hasActivePassengerAccount, withTicketOperator } from "../database/marketplace-scope";
import { PrismaService } from "../database/prisma.service";
import { EMAIL_NOTIFIER, type EmailNotifier, maskEmail } from "../external/notification/email-notifier";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { REDIS_CLIENT } from "../redis/redis.config";
import type {
  TicketLookupAccess,
  TicketLookupBookingList,
  TicketLookupInput,
  TicketLookupOtpInput,
  TicketLookupOtpResponse,
  TicketLookupSession,
  TicketLookupSessionInput,
  TicketLookupVerifyInput,
  TicketResponse,
} from "./dto/ticket.dto";
import { TICKET_QR, type TicketQrSigner } from "./ticket-qr";
import { lookupBookingNotFound, lookupBookingRequiresLogin, lookupExpired, lookupOtpInvalid, lookupRateLimited, lookupUnavailable, ticketNotFound } from "./ticket.errors";

/** Chống dò mã booking: tối đa 10 lần gửi mã tra cứu / 10 phút / địa chỉ IP. */
const LOOKUPS_PER_WINDOW = 10;
const WINDOW_SECONDS = 600;
/** Mã 6 số sống 5 phút, gửi lại sau 60 giây, tối đa 5 lần / giờ cho mỗi email, 5 lần thử mỗi mã. */
const OTP_TTL_SECONDS = 300;
const OTP_RESEND_SECONDS = 60;
const OTP_MAX_PER_HOUR = 5;
const OTP_MAX_ATTEMPTS = 5;
/** Phiên tra cứu sau khi xác minh (UI SCR-PSG-29: "giữ trong phiên 15 phút"). */
const SESSION_TTL_SECONDS = 900;
/** Tra cứu theo email (không mã đặt vé) thấy đơn tạo trong 12 tháng gần nhất (Khanh 27/10/2026), tối đa 50 đơn. */
const EMAIL_LOOKUP_DAYS = 365;
const EMAIL_LOOKUP_LIMIT = 50;
const INCR_WITH_TTL = `
local c = redis.call('INCR', KEYS[1])
if c == 1 then redis.call('EXPIRE', KEYS[1], ARGV[1]) end
return c
`;
/** Ghi đè thử thách cũ (gửi lại = mã mới, lượt thử mới) trong một lệnh để không còn khóa thiếu TTL. */
const PUT_CHALLENGE = `
redis.call('DEL', KEYS[1])
redis.call('HSET', KEYS[1], 'otp', ARGV[1], 'booking', ARGV[2], 'left', ARGV[3])
redis.call('EXPIRE', KEYS[1], ARGV[4])
return 1
`;
/** Đúng mã → xóa thử thách, trả {1, phạm vi}; sai → trừ lượt (hết lượt thì xóa), trả {0, lượt còn}; không có → {-1, 0}. */
const CHECK_CHALLENGE = `
local h = redis.call('HMGET', KEYS[1], 'otp', 'booking')
if not h[1] then return {-1, 0} end
if h[1] == ARGV[1] then
  redis.call('DEL', KEYS[1])
  return {1, h[2]}
end
local left = redis.call('HINCRBY', KEYS[1], 'left', -1)
if left <= 0 then redis.call('DEL', KEYS[1]) end
return {0, left}
`;

const sha256 = (value: string) => createHash("sha256").update(value).digest("hex");
/** Khóa thử thách theo cặp mã đặt vé (rỗng khi tra theo email) + email; giới hạn gửi mã theo email. Khóa không chứa email thô. */
const challengeKey = (bookingCode: string | undefined, email: string) => `ticket-lookup:otp:${sha256(`${bookingCode ?? ""}|${email}`)}`;
const emailKey = (email: string) => `ticket-lookup:email:${sha256(email)}`;
const sessionKey = (lookupToken: string) => `ticket-lookup:session:${sha256(lookupToken)}`;
const lookupSince = (now: Date) => new Date(now.getTime() - EMAIL_LOOKUP_DAYS * 86_400_000);

/** Phạm vi đã xác minh — lưu (JSON) trong thử thách rồi trong phiên, sống tối đa 15 phút. `bookingId: null` = mọi đơn của email. */
type LookupScope = { email: string; bookingId: string | null };
const parseScope = (value: string | null): LookupScope | null => {
  if (!value) return null;
  const scope = JSON.parse(value) as Partial<LookupScope>;
  return typeof scope.email === "string" ? { email: scope.email, bookingId: typeof scope.bookingId === "string" ? scope.bookingId : null } : null;
};

type Snapshot = { trip: TicketResponse["trip"]; pickup: TicketResponse["pickup"]; dropoff: TicketResponse["dropoff"] };

/**
 * Xem vé (TASK-BTP-004, FR-BTP-11, UC-07): vé thuộc booking của chính hành khách, hoặc khách vãng lai có mã truy cập
 * booking. Tra cứu vé của khách vãng lai bằng mã booking + email liên hệ, xác minh mã 6 số gửi về email đó, có giới hạn
 * tần suất (Redis lỗi → 503, không bỏ giới hạn).
 */
@Injectable()
export class TicketService {
  private readonly logger = new Logger(TicketService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(BookingService) private readonly bookings: BookingService,
    @Inject(TICKET_QR) private readonly qr: TicketQrSigner,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    @Inject(EMAIL_NOTIFIER) private readonly email: EmailNotifier,
  ) {}

  async get(user: VerifiedAccessToken | null, ticketId: string, accessToken: string | undefined): Promise<TicketResponse> {
    const ticket = await withTicketOperator(this.prisma, ticketId, (tx, operatorId) =>
      tx.ticket.findFirst({
        where: { id: ticketId, operatorId },
        select: {
          id: true,
          ticketCode: true,
          status: true,
          seatCode: true,
          issuedAt: true,
          checkedInAt: true,
          passenger: { select: { fullName: true, seatType: true } },
          booking: { select: { id: true, bookingCode: true, status: true, snapshot: true, userId: true, accessTokenHash: true, accessGrants: ACCESS_GRANT_SELECT } },
        },
      }),
    );
    if (!ticket || !canAccessBooking(ticket.booking, user, accessToken)) {
      throw ticketNotFound();
    }
    const snapshot = ticket.booking.snapshot as Snapshot;
    return {
      ticketId: ticket.id,
      ticketCode: ticket.ticketCode,
      status: ticket.status,
      seatCode: ticket.seatCode,
      seatType: ticket.passenger.seatType,
      passengerName: ticket.passenger.fullName,
      bookingId: ticket.booking.id,
      bookingCode: ticket.booking.bookingCode,
      bookingStatus: ticket.booking.status,
      trip: snapshot.trip,
      pickup: snapshot.pickup,
      dropoff: snapshot.dropoff,
      qrToken: this.qr.token(ticket.id),
      issuedAt: ticket.issuedAt.toISOString(),
      checkedInAt: ticket.checkedInAt?.toISOString() ?? null,
    };
  }

  /**
   * Bước 1 tra cứu vé khách vãng lai: luôn trả cùng một phản hồi (không lộ email / mã đặt vé có đơn hay không). Chỉ gửi mã
   * về email khi có đơn: đúng mã đặt vé + email, hoặc (không nhập mã) email có đơn trong 12 tháng gần nhất. Vẫn ghi thử
   * thách khi không có đơn để giới hạn gửi lại và số lần thử như nhau.
   */
  async requestOtp(clientIp: string | undefined, input: TicketLookupOtpInput, now = new Date()): Promise<TicketLookupOtpResponse> {
    const email = input.email.toLowerCase();
    const key = challengeKey(input.bookingCode, email);
    const limited = await this.redisCall(async () => {
      if (clientIp && Number(await this.redis.eval(INCR_WITH_TTL, 1, `ticket-lookup:ip:${clientIp}`, String(WINDOW_SECONDS))) > LOOKUPS_PER_WINDOW) {
        return lookupRateLimited();
      }
      if ((await this.redis.set(`${emailKey(email)}:cooldown`, "1", "EX", OTP_RESEND_SECONDS, "NX")) === null) {
        return lookupRateLimited(`Vui lòng đợi ${OTP_RESEND_SECONDS} giây trước khi gửi lại mã.`);
      }
      if (Number(await this.redis.eval(INCR_WITH_TTL, 1, `${emailKey(email)}:count`, "3600")) > OTP_MAX_PER_HOUR) {
        return lookupRateLimited("Bạn đã yêu cầu quá nhiều mã cho email này. Vui lòng thử lại sau 1 giờ.");
      }
      return null;
    });
    if (limited) {
      throw limited;
    }
    const scope: LookupScope | null = input.bookingCode
      ? await this.bookings.matchGuestContact(input.bookingCode, email).then((bookingId) => (bookingId ? { email, bookingId } : null))
      : (await this.bookings.listForGuestLookup({ email, bookingId: null }, lookupSince(now), 1, now)).length > 0
        ? { email, bookingId: null }
        : null;
    const otp = String(randomInt(0, 1_000_000)).padStart(6, "0");
    await this.redisCall(() =>
      this.redis.eval(PUT_CHALLENGE, 1, key, sha256(`${key}:${otp}`), scope ? JSON.stringify(scope) : "", String(OTP_MAX_ATTEMPTS), String(OTP_TTL_SECONDS)),
    );
    if (scope) {
      // Không chờ gửi email: thời gian phản hồi khi có và không có đơn như nhau. Lỗi gửi chỉ ghi log (như OTP đăng nhập).
      void this.email.sendOtp({ email, otp, purpose: "ticket-lookup" }).catch((error: unknown) => {
        this.logger.error({ event: "ticket.lookup.otp_delivery_failed", email: maskEmail(email), error });
      });
    }
    return { maskedEmail: maskEmail(email), expiresInSeconds: OTP_TTL_SECONDS, resendAfterSeconds: OTP_RESEND_SECONDS, maxAttempts: OTP_MAX_ATTEMPTS };
  }

  /** Bước 2: đúng mã → phiên tra cứu 15 phút (bí mật ngẫu nhiên, Redis chỉ giữ băm). */
  async verifyOtp(input: TicketLookupVerifyInput, now = new Date()): Promise<TicketLookupSession> {
    const key = challengeKey(input.bookingCode, input.email.toLowerCase());
    const [status, value] = await this.redisCall(async () => (await this.redis.eval(CHECK_CHALLENGE, 1, key, sha256(`${key}:${input.otp}`))) as [number, string | number]);
    if (status !== 1 || !value) {
      throw lookupOtpInvalid(status === 0 ? Number(value) : 0);
    }
    const lookupToken = randomBytes(32).toString("base64url");
    await this.redisCall(() => this.redis.set(sessionKey(lookupToken), String(value), "EX", SESSION_TTL_SECONDS));
    return { lookupToken, expiresAt: new Date(now.getTime() + SESSION_TTL_SECONDS * 1000).toISOString() };
  }

  /** Bước 3a: các đơn của phiên (một đơn khi nhập mã đặt vé) + email có tài khoản không (gợi ý đăng nhập). */
  async listBookings(input: TicketLookupSessionInput, now = new Date()): Promise<TicketLookupBookingList> {
    const scope = await this.sessionScope(input.lookupToken);
    const [items, account] = await Promise.all([
      this.bookings.listForGuestLookup(scope, lookupSince(now), EMAIL_LOOKUP_LIMIT, now),
      hasActivePassengerAccount(this.prisma, scope.email),
    ]);
    return {
      maskedEmail: maskEmail(scope.email),
      scope: scope.bookingId ? "BOOKING" : "EMAIL",
      hasAccount: account,
      items: items.map((item) => ({ ...item, total: vndToJson(item.total), createdAt: item.createdAt.toISOString() })),
    };
  }

  /** Bước 3b: booking + vé của một đơn trong phạm vi phiên (chỉ xem). */
  async lookup(input: TicketLookupInput, now = new Date()): Promise<BookingResponse> {
    const scope = await this.sessionScope(input.lookupToken);
    if (scope.bookingId && input.bookingId && input.bookingId !== scope.bookingId) {
      throw lookupBookingNotFound();
    }
    const bookingId = scope.bookingId ?? input.bookingId;
    const booking = bookingId
      ? await this.bookings.getForLookup(bookingId, scope.bookingId ? undefined : { email: scope.email, since: lookupSince(now) })
      : null;
    if (!booking) {
      throw lookupBookingNotFound();
    }
    return booking;
  }

  /** Bước 4: mã truy cập phụ để hủy vé / gửi khiếu nại một đơn khách vãng lai của phiên, hết hạn cùng phiên. */
  async grantBookingAccess(input: TicketLookupInput, now = new Date()): Promise<TicketLookupAccess> {
    const scope = await this.sessionScope(input.lookupToken);
    if (scope.bookingId && input.bookingId && input.bookingId !== scope.bookingId) {
      throw lookupBookingNotFound();
    }
    const bookingId = scope.bookingId ?? input.bookingId;
    if (!bookingId) {
      throw lookupBookingNotFound();
    }
    const ttl = await this.redisCall(() => this.redis.pttl(sessionKey(input.lookupToken)));
    if (ttl <= 0) {
      throw lookupExpired();
    }
    const expiresAt = new Date(now.getTime() + ttl);
    const granted = await this.bookings.grantLookupAccess(bookingId, scope.bookingId ? undefined : { email: scope.email, since: lookupSince(now) }, expiresAt, now);
    if (granted === "ACCOUNT") {
      throw lookupBookingRequiresLogin();
    }
    if (granted === "NOT_FOUND") {
      throw lookupBookingNotFound();
    }
    return { bookingId, accessToken: granted.accessToken, expiresAt: expiresAt.toISOString() };
  }

  private async sessionScope(lookupToken: string): Promise<LookupScope> {
    const scope = parseScope(await this.redisCall(() => this.redis.get(sessionKey(lookupToken))));
    if (!scope) {
      throw lookupExpired();
    }
    return scope;
  }

  /** Redis lỗi → 503, không bỏ qua giới hạn / xác minh (ADR-015). */
  private async redisCall<T>(work: () => Promise<T>): Promise<T> {
    try {
      return await work();
    } catch (error) {
      this.logger.error({ event: "ticket.lookup.redis_failed", error });
      throw lookupUnavailable();
    }
  }
}
