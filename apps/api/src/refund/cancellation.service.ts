import { createHash, randomInt } from "node:crypto";
import { InjectQueue } from "@nestjs/bullmq";
import { HttpException, HttpStatus, Inject, Injectable, Logger } from "@nestjs/common";
import type { Queue } from "bullmq";
import { ACCESS_GRANT_SELECT, canAccessBooking } from "../booking/booking-access";
import { bookingNotFound } from "../booking/booking.errors";
import { BookingService } from "../booking/booking.service";
import { withBookingOperator } from "../database/marketplace-scope";
import { PrismaService, type DbTransaction } from "../database/prisma.service";
import { NotificationKind, PaymentStatus, RefundStatus, TicketStatus, TripStatus } from "../database/prisma.types";
import { vndToJson } from "../fare/fare-pricing";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { NotificationDispatcher } from "../notification/notification-dispatcher";
import { queueNotification } from "../notification/notification-outbox";
import { QUEUE_NAMES } from "../queue/queue.constants";
import { settleBookingStatus } from "./booking-settlement";
import type { CancellationInput, CancellationQuote, CancellationResult } from "./dto/cancellation.dto";
import { REFUND_JOB, REFUND_JOB_OPTIONS } from "./refund-processing";
import { applicableTier, type CancellationTier, paidPrice, refundOf } from "./refund-policy";
import { cancellationNotAllowed, counterRefundManualRequired, refundAmountChanged, ticketsNotInBooking } from "./refund.errors";

/** Mã gửi cổng `RFD` + 12 ký tự (CHECK `refunds_code_format`). */
const CODE_ALPHABET = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ";
/** Chuyến đã chạy / sự cố: không hủy theo luồng thường (UC-08 A2, BR-06). */
const TRIP_STARTED: readonly TripStatus[] = [TripStatus.DEPARTED, TripStatus.IN_PROGRESS, TripStatus.COMPLETED, TripStatus.INCIDENT];
const TICKET_REASON: Record<TicketStatus, string> = {
  VALID: "",
  CANCELLED: "Vé đã hủy.",
  CHECKED_IN: "Vé đã check-in.",
  NO_SHOW: "Vé đã ghi nhận vắng mặt.",
  USED: "Vé đã sử dụng.",
  REFUNDED: "Vé đã hoàn tiền.",
};

type Loaded = NonNullable<Awaited<ReturnType<typeof load>>>;

/**
 * Hủy vé / yêu cầu hoàn tiền của hành khách / khách vãng lai (TASK-BTP-005, UC-08, FR-BTP-12/13, BR-06/07): xem điều kiện
 * (mốc hủy CHỤP lúc đặt, số tiền hoàn từng vé) rồi xác nhận. Một transaction: khoá booking, kiểm lại, vé `VALID → CANCELLED`
 * (có điều kiện), trả ghế về bán lại, tạo refund `APPROVED` khi số hoàn > 0 (theo chính sách — không cần duyệt tay), suy lại
 * trạng thái booking. Sau commit xếp hàng job hoàn tiền qua cổng (worker). Hủy một phần được (UC-08 A3).
 */
@Injectable()
export class CancellationService {
  private readonly logger = new Logger(CancellationService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(BookingService) private readonly bookings: BookingService,
    @InjectQueue(QUEUE_NAMES.refundProcessing) private readonly queue: Queue,
    @Inject(NotificationDispatcher) private readonly notifications: NotificationDispatcher,
  ) {}

  async quote(user: VerifiedAccessToken | null, bookingId: string, accessToken: string | undefined, ticketIds: string[]): Promise<CancellationQuote> {
    const data = await withBookingOperator(this.prisma, bookingId, (tx, operatorId) => load(tx, operatorId, bookingId));
    if (!data || !canAccessBooking(data, user, accessToken)) {
      throw bookingNotFound();
    }
    return buildQuote(data, ticketIds, new Date());
  }

  async cancel(user: VerifiedAccessToken | null, bookingId: string, accessToken: string | undefined, input: CancellationInput): Promise<CancellationResult> {
    const now = new Date();
    const actor = user ? `user:${user.sub}` : "guest";
    const outcome = await this.transaction(() =>
      withBookingOperator(this.prisma, bookingId, async (tx, operatorId) => {
        await tx.$queryRaw`SELECT id FROM bookings WHERE id = ${bookingId} AND operator_id = ${operatorId} FOR UPDATE`;
        const data = await load(tx, operatorId, bookingId);
        if (!data || !canAccessBooking(data, user, accessToken)) {
          return null;
        }
        const quote = buildQuote(data, input.ticketIds, now);
        const blocked = quote.tickets.filter((ticket) => input.ticketIds.includes(ticket.ticketId) && !ticket.cancellable);
        if (blocked.length > 0) {
          throw cancellationNotAllowed(blocked.map((ticket) => `${ticket.ticketCode}: ${ticket.reason}`));
        }
        const amount = BigInt(quote.refundAmount);
        if (amount !== BigInt(input.expectedRefund)) {
          throw refundAmountChanged(amount);
        }
        let refund: { id: string; refundCode: string; amount: bigint; status: RefundStatus } | null = null;
        if (amount > 0n) {
          const payment = data.payments[0];
          if (!payment) {
            throw cancellationNotAllowed(["Booking chưa có thanh toán thành công."]);
          }
          refund = await tx.refund.create({
            data: {
              refundCode: newRefundCode(),
              operatorId,
              bookingId,
              paymentId: payment.id,
              status: RefundStatus.APPROVED,
              amount,
              refundPercent: quote.refundPercent,
              reason: input.reason ?? "Hành khách hủy vé.",
              requestedBy: actor,
              histories: {
                create: [
                  { toStatus: RefundStatus.REQUESTED, actor, createdAt: now },
                  { fromStatus: RefundStatus.REQUESTED, toStatus: RefundStatus.APPROVED, reason: "Đủ điều kiện theo chính sách hủy lưu lúc đặt.", actor: "system", createdAt: new Date(now.getTime() + 1) },
                ],
              },
            },
            select: { id: true, refundCode: true, amount: true, status: true },
          });
        }
        const updated = await tx.ticket.updateMany({
          where: { id: { in: input.ticketIds }, operatorId, bookingId, status: TicketStatus.VALID },
          data: { status: TicketStatus.CANCELLED, cancelledAt: now, refundId: refund?.id ?? null },
        });
        if (updated.count !== input.ticketIds.length) {
          // Chốt phòng thủ: booking đã khoá nên trạng thái vé không đổi giữa chừng được.
          throw cancellationNotAllowed(["Vé vừa thay đổi trạng thái. Tải lại rồi thử lại."]);
        }
        await tx.ticketStatusHistory.createMany({
          data: input.ticketIds.map((ticketId) => ({ ticketId, operatorId, fromStatus: TicketStatus.VALID, toStatus: TicketStatus.CANCELLED, reason: input.reason ?? "Hành khách hủy vé.", actor, createdAt: now })),
        });
        // Trả chỗ về bán lại (UC-08 bước 8) — chỗ tự đóng bán theo giờ ngừng bán online của chuyến.
        const seatCodes = data.tickets.filter((ticket) => input.ticketIds.includes(ticket.id)).map((ticket) => ticket.seatCode);
        await tx.tripSeat.updateMany({ where: { tripId: data.tripId, operatorId, bookingId, seatCode: { in: seatCodes }, status: "BOOKED" }, data: { status: "AVAILABLE", bookingId: null } });
        await settleBookingStatus(tx, operatorId, bookingId, actor, `Hủy ${input.ticketIds.length} vé.`, new Date(now.getTime() + 2));
        // Báo khách đã hủy vé (TASK-NSR-001) — ghi cùng transaction, gửi sau commit.
        const notificationKey = ticketsCancelledKey(bookingId, input.ticketIds);
        await queueNotification(tx, operatorId, {
          kind: NotificationKind.TICKETS_CANCELLED,
          dedupKey: notificationKey,
          recipientEmail: data.contactEmail,
          bookingId,
          refundId: refund?.id,
          payload: { ticketCodes: data.tickets.filter((ticket) => input.ticketIds.includes(ticket.id)).map((ticket) => ticket.ticketCode), refundAmount: Number(amount) },
        });
        return { refund, notificationKey };
      }),
    );
    if (!outcome) {
      throw bookingNotFound();
    }
    await this.notifications.dispatch([outcome.notificationKey]);
    if (outcome.refund) {
      await this.queue.add(REFUND_JOB, { refundId: outcome.refund.id }, { ...REFUND_JOB_OPTIONS, jobId: outcome.refund.id }).catch((error: unknown) => {
        // Refund vẫn `APPROVED` trong DB — Admin chạy lại được (ADM-002); không làm hỏng việc hủy đã ghi.
        this.logger.error({ event: "refund.enqueue_failed", refundId: outcome.refund!.id, error });
      });
    }
    return {
      booking: await this.bookings.get(user, bookingId, accessToken),
      refund: outcome.refund ? { refundCode: outcome.refund.refundCode, amount: vndToJson(outcome.refund.amount), status: outcome.refund.status } : null,
    };
  }

  /** Transaction hết hạn / deadlock khi tranh khoá → 503, không có gì được ghi; client thử lại. */
  private async transaction<T>(work: () => Promise<T>): Promise<T> {
    try {
      return await work();
    } catch (error) {
      const code = (error as { code?: unknown } | null)?.code;
      const dbCode = (error as { cause?: { originalCode?: unknown } } | null)?.cause?.originalCode;
      if (code === "P2028" || dbCode === "40P01") {
        throw new HttpException({ code: "SERVICE_UNAVAILABLE", title: "Refund error", detail: "Hệ thống đang bận. Vui lòng thử lại." }, HttpStatus.SERVICE_UNAVAILABLE);
      }
      throw error;
    }
  }
}

async function load(tx: DbTransaction, operatorId: string, bookingId: string) {
  return tx.booking.findFirst({
    where: { id: bookingId, operatorId },
    select: {
      tripId: true,
      channel: true,
      userId: true,
      accessTokenHash: true,
      accessGrants: ACCESS_GRANT_SELECT,
      contactEmail: true,
      snapshot: true,
      subtotal: true,
      discount: true,
      trip: { select: { status: true, departureAt: true } },
      tickets: {
        orderBy: { ticketCode: "asc" },
        select: { id: true, ticketCode: true, seatCode: true, status: true, passenger: { select: { fullName: true, price: true, companionName: true } } },
      },
      payments: { where: { status: PaymentStatus.SUCCESS }, take: 1, select: { id: true } },
    },
  });
}

function buildQuote(data: Loaded, ticketIds: string[], now: Date): CancellationQuote {
  if (data.channel === "COUNTER") throw counterRefundManualRequired();
  const known = new Set(data.tickets.map((ticket) => ticket.id));
  if (ticketIds.some((id) => !known.has(id))) {
    throw ticketsNotInBooking();
  }
  const tripReason =
    data.trip.status === TripStatus.CANCELLED
      ? "Chuyến đã hủy — hoàn tiền theo luồng nhà xe hủy chuyến."
      : TRIP_STARTED.includes(data.trip.status) || data.trip.departureAt <= now
        ? "Chuyến đã khởi hành."
        : null;
  const tiers = ((data.snapshot as { cancellationPolicy?: { tiers?: CancellationTier[] } }).cancellationPolicy?.tiers ?? []) as CancellationTier[];
  const tier = applicableTier(tiers, data.trip.departureAt, now);
  const percent = tier?.refundPercent ?? 0;
  const tickets = data.tickets.map((ticket) => {
    const reason = ticket.status !== TicketStatus.VALID ? TICKET_REASON[ticket.status] : tripReason;
    return {
      ticketId: ticket.id,
      ticketCode: ticket.ticketCode,
      seatCode: ticket.seatCode,
      passengerName: ticket.passenger.fullName,
      companionName: ticket.passenger.companionName,
      status: ticket.status,
      price: vndToJson(ticket.passenger.price),
      cancellable: reason === null,
      reason,
    };
  });
  const selected = data.tickets.filter((ticket) => ticketIds.includes(ticket.id));
  // Đơn có mã giảm giá: hoàn trên phần khách thực trả của từng vé (không hoàn quá số đã trả).
  const paid = (price: bigint) => paidPrice(price, data.subtotal, data.discount);
  const total = selected.reduce((sum, ticket) => sum + paid(ticket.passenger.price), 0n);
  const refund = selected.reduce((sum, ticket) => sum + refundOf(paid(ticket.passenger.price), percent), 0n);
  return {
    tickets,
    tier: tier ? { minHoursBefore: tier.minHoursBefore, refundPercent: tier.refundPercent } : null,
    refundPercent: percent,
    selectedTotal: vndToJson(total),
    refundAmount: vndToJson(refund),
    nonRefundable: vndToJson(total - refund),
  };
}

/** Khoá chống trùng thông báo hủy vé — mỗi vé chỉ hủy được một lần nên tập vé định danh lần hủy. */
function ticketsCancelledKey(bookingId: string, ticketIds: string[]): string {
  const digest = createHash("sha256").update([...ticketIds].sort().join(",")).digest("hex").slice(0, 16);
  return `TICKETS_CANCELLED:${bookingId}:${digest}`;
}

export function newRefundCode(): string {
  let code = "RFD";
  for (let i = 0; i < 12; i++) {
    code += CODE_ALPHABET[randomInt(CODE_ALPHABET.length)];
  }
  return code;
}
