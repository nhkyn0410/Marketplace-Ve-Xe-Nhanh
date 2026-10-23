import { Inject, Injectable, Logger } from "@nestjs/common";
import type Redis from "ioredis";
import { canAccessBooking } from "../booking/booking-access";
import { BookingService } from "../booking/booking.service";
import type { BookingResponse } from "../booking/dto/booking.dto";
import { withTicketOperator } from "../database/marketplace-scope";
import { PrismaService } from "../database/prisma.service";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { REDIS_CLIENT } from "../redis/redis.config";
import type { TicketLookupInput, TicketResponse } from "./dto/ticket.dto";
import { TICKET_QR, type TicketQrSigner } from "./ticket-qr";
import { lookupNotFound, lookupRateLimited, lookupUnavailable, ticketNotFound } from "./ticket.errors";

/** Chống dò mã booking: tối đa 10 lần tra cứu / 10 phút / địa chỉ IP. */
const LOOKUPS_PER_WINDOW = 10;
const WINDOW_SECONDS = 600;
const INCR_WITH_TTL = `
local c = redis.call('INCR', KEYS[1])
if c == 1 then redis.call('EXPIRE', KEYS[1], ARGV[1]) end
return c
`;

type Snapshot = { trip: TicketResponse["trip"]; pickup: TicketResponse["pickup"]; dropoff: TicketResponse["dropoff"] };

/**
 * Xem vé (TASK-BTP-004, FR-BTP-11, UC-07): vé thuộc booking của chính hành khách, hoặc khách vãng lai có mã truy cập
 * booking. Tra cứu vé của khách vãng lai bằng mã booking + liên hệ, có giới hạn tần suất theo IP (Redis lỗi → 503, không
 * bỏ giới hạn).
 */
@Injectable()
export class TicketService {
  private readonly logger = new Logger(TicketService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(BookingService) private readonly bookings: BookingService,
    @Inject(TICKET_QR) private readonly qr: TicketQrSigner,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
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

  async lookup(clientIp: string | undefined, input: TicketLookupInput): Promise<BookingResponse> {
    if (clientIp) {
      let count: number;
      try {
        count = Number(await this.redis.eval(INCR_WITH_TTL, 1, `ticket-lookup:ip:${clientIp}`, String(WINDOW_SECONDS)));
      } catch (error) {
        this.logger.error({ event: "ticket.lookup.redis_failed", error });
        throw lookupUnavailable();
      }
      if (count > LOOKUPS_PER_WINDOW) {
        throw lookupRateLimited();
      }
    }
    const booking = await this.bookings.lookup(input.bookingCode, { phone: input.phone, email: input.email });
    if (!booking) {
      throw lookupNotFound();
    }
    return booking;
  }
}
