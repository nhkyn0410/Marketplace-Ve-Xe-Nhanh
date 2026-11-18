import { HttpException, HttpStatus, Inject, Injectable } from "@nestjs/common";
import { withBookingOperator } from "../database/marketplace-scope";
import { PrismaService, type DbTransaction } from "../database/prisma.service";
import { BookingStatus, NotificationKind, TicketStatus } from "../database/prisma.types";
import { maskEmail } from "../external/notification/email-notifier";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { NotificationDispatcher } from "../notification/notification-dispatcher";
import { queueNotification } from "../notification/notification-outbox";
import { ACCESS_GRANT_SELECT, canAccessBooking } from "./booking-access";
import { bookingNotFound } from "./booking.errors";

/** Mỗi đơn gửi lại tối đa 1 lần / phút và 5 lần / ngày (giờ VN). */
export const TICKET_EMAIL_INTERVAL_SECONDS = 60;
export const TICKET_EMAIL_DAILY_LIMIT = 5;
const VN_OFFSET_MS = 7 * 3_600_000;
const ISSUED: readonly BookingStatus[] = [BookingStatus.PAID, BookingStatus.CONFIRMED, BookingStatus.PARTIALLY_CANCELLED];

export type TicketEmailResult = { sentTo: string; resendAfterSeconds: number };

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  return new HttpException({ code, detail, title: "Ticket email error" }, status);
}

/** Khoá chống trùng của lần gửi lại theo phút: bấm nhiều lần trong một phút chỉ ra một email. */
export function ticketEmailKey(bookingId: string, now: Date): string {
  return `BOOKING_CONFIRMED:RESEND:${bookingId}:${Math.floor(now.getTime() / (TICKET_EMAIL_INTERVAL_SECONDS * 1000))}`;
}

/**
 * Ghi lại thông báo vé điện tử (cùng loại `BOOKING_CONFIRMED` gửi lúc thanh toán xong) tới email liên hệ của đơn. Chỉ đơn có
 * vé còn hiệu lực; người gọi phải sở hữu đơn (tài khoản hoặc mã truy cập của khách vãng lai). Không nhận email khác: tránh
 * dùng chức năng này gửi vé cho người lạ.
 */
export async function queueTicketEmail(
  tx: DbTransaction,
  operatorId: string,
  bookingId: string,
  user: VerifiedAccessToken | null,
  accessToken: string | undefined,
  now: Date,
): Promise<{ result: TicketEmailResult; dedupKey: string } | null> {
  const booking = await tx.booking.findFirst({
    where: { id: bookingId, operatorId },
    select: {
      userId: true,
      accessTokenHash: true,
      accessGrants: ACCESS_GRANT_SELECT,
      status: true,
      contactEmail: true,
      tickets: { where: { status: TicketStatus.VALID }, select: { id: true } },
    },
  });
  if (!booking || !canAccessBooking(booking, user, accessToken, now)) return null;
  if (!ISSUED.includes(booking.status) || booking.tickets.length === 0) {
    throw problem(HttpStatus.CONFLICT, "TICKET_EMAIL_NOT_AVAILABLE", "Đơn chưa có vé điện tử còn hiệu lực để gửi.");
  }
  const email = booking.contactEmail;
  if (!email) {
    // Đơn bán tại quầy có thể không có email liên hệ.
    throw problem(HttpStatus.CONFLICT, "TICKET_EMAIL_NOT_AVAILABLE", "Đơn không có email liên hệ để gửi vé.");
  }
  const vnDayStart = new Date(Math.floor((now.getTime() + VN_OFFSET_MS) / 86_400_000) * 86_400_000 - VN_OFFSET_MS);
  const sentToday = await tx.notification.count({
    where: { bookingId, operatorId, dedupKey: { startsWith: `BOOKING_CONFIRMED:RESEND:${bookingId}:` }, createdAt: { gte: vnDayStart } },
  });
  if (sentToday >= TICKET_EMAIL_DAILY_LIMIT) {
    throw problem(HttpStatus.TOO_MANY_REQUESTS, "TICKET_EMAIL_RATE_LIMITED", "Hôm nay đơn này đã gửi lại vé nhiều lần. Vui lòng thử lại vào ngày mai.");
  }
  const dedupKey = ticketEmailKey(bookingId, now);
  const queued = await queueNotification(tx, operatorId, {
    kind: NotificationKind.BOOKING_CONFIRMED,
    dedupKey,
    recipientEmail: email,
    bookingId,
    payload: { resend: true },
  });
  if (!queued) {
    throw problem(HttpStatus.TOO_MANY_REQUESTS, "TICKET_EMAIL_RATE_LIMITED", "Vé vừa được gửi. Vui lòng chờ 1 phút rồi gửi lại.");
  }
  return { result: { sentTo: maskEmail(email), resendAfterSeconds: TICKET_EMAIL_INTERVAL_SECONDS }, dedupKey };
}

/** Gửi lại email vé điện tử ở màn đặt vé thành công / chi tiết vé (SCR-PSG-22; PASSENGER-PARITY giai đoạn 4 — chờ duyệt). */
@Injectable()
export class TicketEmailService {
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(NotificationDispatcher) private readonly notifications: NotificationDispatcher,
  ) {}

  async resend(user: VerifiedAccessToken | null, bookingId: string, accessToken: string | undefined): Promise<TicketEmailResult> {
    const now = new Date();
    const queued = await withBookingOperator(this.prisma, bookingId, (tx, operatorId) =>
      queueTicketEmail(tx, operatorId, bookingId, user, accessToken, now),
    );
    if (!queued) throw bookingNotFound();
    await this.notifications.dispatch([queued.dedupKey]);
    return queued.result;
  }
}
