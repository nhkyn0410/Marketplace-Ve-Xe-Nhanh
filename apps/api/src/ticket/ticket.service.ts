import { createHash, randomBytes, randomInt } from "node:crypto";
import { Inject, Injectable, Logger } from "@nestjs/common";
import type Redis from "ioredis";
import { canAccessBooking } from "../booking/booking-access";
import { BookingService } from "../booking/booking.service";
import type { BookingResponse } from "../booking/dto/booking.dto";
import { withTicketOperator } from "../database/marketplace-scope";
import { PrismaService } from "../database/prisma.service";
import { EMAIL_NOTIFIER, type EmailNotifier, maskEmail } from "../external/notification/email-notifier";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { REDIS_CLIENT } from "../redis/redis.config";
import type {
  TicketLookupInput,
  TicketLookupOtpInput,
  TicketLookupOtpResponse,
  TicketLookupSession,
  TicketLookupVerifyInput,
  TicketResponse,
} from "./dto/ticket.dto";
import { TICKET_QR, type TicketQrSigner } from "./ticket-qr";
import { lookupExpired, lookupOtpInvalid, lookupRateLimited, lookupUnavailable, ticketNotFound } from "./ticket.errors";

/** Chống dò mã booking: tối đa 10 lần gửi mã tra cứu / 10 phút / địa chỉ IP. */
const LOOKUPS_PER_WINDOW = 10;
const WINDOW_SECONDS = 600;
/** Mã 6 số sống 5 phút, gửi lại sau 60 giây, tối đa 5 lần / giờ cho mỗi cặp mã booking + email, 5 lần thử mỗi mã. */
const OTP_TTL_SECONDS = 300;
const OTP_RESEND_SECONDS = 60;
const OTP_MAX_PER_HOUR = 5;
const OTP_MAX_ATTEMPTS = 5;
/** Phiên tra cứu sau khi xác minh (UI SCR-PSG-29: "giữ trong phiên 15 phút"). */
const SESSION_TTL_SECONDS = 900;
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
/** Đúng mã → xóa thử thách, trả {1, bookingId}; sai → trừ lượt (hết lượt thì xóa), trả {0, lượt còn}; không có → {-1, 0}. */
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
/** Khóa thử thách theo cặp mã booking + email (không lưu email thô trong Redis). */
const challengeKey = (bookingCode: string, email: string) => `ticket-lookup:otp:${sha256(`${bookingCode}|${email}`)}`;
const sessionKey = (lookupToken: string) => `ticket-lookup:session:${sha256(lookupToken)}`;

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
          booking: { select: { id: true, bookingCode: true, status: true, snapshot: true, userId: true, accessTokenHash: true } },
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
   * Bước 1 tra cứu vé khách vãng lai: luôn trả cùng một phản hồi (không lộ mã booking / email có khớp). Chỉ khi khớp mới
   * gửi mã về email liên hệ của booking; vẫn ghi thử thách cho cặp không khớp để giới hạn gửi lại và số lần thử như nhau.
   */
  async requestOtp(clientIp: string | undefined, input: TicketLookupOtpInput): Promise<TicketLookupOtpResponse> {
    const email = input.email.toLowerCase();
    const key = challengeKey(input.bookingCode, email);
    const limited = await this.redisCall(async () => {
      if (clientIp && Number(await this.redis.eval(INCR_WITH_TTL, 1, `ticket-lookup:ip:${clientIp}`, String(WINDOW_SECONDS))) > LOOKUPS_PER_WINDOW) {
        return lookupRateLimited();
      }
      if ((await this.redis.set(`${key}:cooldown`, "1", "EX", OTP_RESEND_SECONDS, "NX")) === null) {
        return lookupRateLimited(`Vui lòng đợi ${OTP_RESEND_SECONDS} giây trước khi gửi lại mã.`);
      }
      if (Number(await this.redis.eval(INCR_WITH_TTL, 1, `${key}:count`, "3600")) > OTP_MAX_PER_HOUR) {
        return lookupRateLimited("Bạn đã yêu cầu quá nhiều mã cho đơn này. Vui lòng thử lại sau 1 giờ.");
      }
      return null;
    });
    if (limited) {
      throw limited;
    }
    const bookingId = await this.bookings.matchGuestContact(input.bookingCode, email);
    const otp = String(randomInt(0, 1_000_000)).padStart(6, "0");
    await this.redisCall(() => this.redis.eval(PUT_CHALLENGE, 1, key, sha256(`${key}:${otp}`), bookingId ?? "", String(OTP_MAX_ATTEMPTS), String(OTP_TTL_SECONDS)));
    if (bookingId) {
      // Không chờ gửi email: thời gian phản hồi của cặp khớp và không khớp như nhau. Lỗi gửi chỉ ghi log (như OTP đăng nhập).
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

  /** Bước 3: booking + vé của phiên tra cứu (chỉ xem). */
  async lookup(input: TicketLookupInput): Promise<BookingResponse> {
    const bookingId = await this.redisCall(() => this.redis.get(sessionKey(input.lookupToken)));
    const booking = bookingId ? await this.bookings.getForLookup(bookingId) : null;
    if (!booking) {
      throw lookupExpired();
    }
    return booking;
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
