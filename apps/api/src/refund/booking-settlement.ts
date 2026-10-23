import type { DbTransaction } from "../database/prisma.service";
import { BookingStatus, PaymentStatus, RefundStatus, TicketStatus } from "../database/prisma.types";

/**
 * Trạng thái booking sau khi hủy vé / có kết quả hoàn tiền (SRS §17.6), suy từ vé + refund hiện có:
 * còn refund đang xử lý → `REFUND_PENDING`; có refund thất bại → `REFUND_FAILED`; còn vé hiệu lực → `PARTIALLY_CANCELLED`;
 * hết vé, có hoàn tiền thành công → `REFUNDED`; hết vé, không hoàn → `CANCELLED`. Đổi thì ghi lịch sử. Trả trạng thái mới.
 * Refund của thanh toán cần đối soát (hoàn khoản trả thừa / trả muộn — TASK-ADM-002) không tính vào booking.
 */
export async function settleBookingStatus(
  tx: DbTransaction,
  operatorId: string,
  bookingId: string,
  actor: string,
  reason: string,
  at: Date,
): Promise<BookingStatus> {
  const booking = await tx.booking.findFirstOrThrow({
    where: { id: bookingId, operatorId },
    select: {
      status: true,
      tickets: { select: { status: true } },
      refunds: { where: { payment: { status: { not: PaymentStatus.RECONCILING } } }, select: { status: true } },
    },
  });
  const refunds = booking.refunds.map((refund) => refund.status);
  const activeTickets = booking.tickets.filter((ticket) => ticket.status !== TicketStatus.CANCELLED && ticket.status !== TicketStatus.REFUNDED);
  const next = refunds.some((status) => status === RefundStatus.APPROVED || status === RefundStatus.PROCESSING || status === RefundStatus.REQUESTED)
    ? BookingStatus.REFUND_PENDING
    : refunds.includes(RefundStatus.FAILED)
      ? BookingStatus.REFUND_FAILED
      : activeTickets.length > 0
        ? booking.tickets.length === activeTickets.length
          ? BookingStatus.CONFIRMED
          : BookingStatus.PARTIALLY_CANCELLED
        : refunds.includes(RefundStatus.SUCCESS)
          ? BookingStatus.REFUNDED
          : BookingStatus.CANCELLED;
  if (next !== booking.status) {
    await tx.booking.update({
      where: { id: bookingId },
      data: { status: next, ...(next === BookingStatus.CANCELLED || next === BookingStatus.REFUNDED ? { cancelledAt: at } : {}) },
    });
    await tx.bookingStatusHistory.create({ data: { bookingId, operatorId, fromStatus: booking.status, toStatus: next, reason, actor, createdAt: at } });
  }
  return next;
}
