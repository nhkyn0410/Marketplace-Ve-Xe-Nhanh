import { withPaymentOperator } from "../database/marketplace-scope";
import type { DbTransaction, PrismaService } from "../database/prisma.service";
import { BookingStatus, PaymentStatus } from "../database/prisma.types";
import type { GatewayProvider } from "../external/payment/payment-gateway";
import { recordCapture } from "../escrow/escrow-entries";
import { issueTickets } from "../ticket/ticket-issuer";
import type { TicketQrSigner } from "../ticket/ticket-qr";

// Xử lý callback ĐÃ xác thực chữ ký (TASK-BTP-003, LLD §6.3, FR-BTP-08/09, BR-27/28): chạy trong worker (job
// `payment-callback`). Một transaction ở tenant của nhà xe: khoá payment rồi booking, quyết theo trạng thái hiện tại —
// chạy lặp / song song với cùng callback chỉ đổi trạng thái một lần (dedup unique `(provider, provider_txn_id)`).

export const PAYMENT_CALLBACK_JOB = "payment-callback";

/** Dữ liệu job (tiền dạng chuỗi — JSON không có bigint). */
export type PaymentCallbackJob = {
  provider: GatewayProvider;
  paymentCode: string;
  providerTxnId: string | null;
  amount: string;
  success: boolean;
  resultCode: string;
  fields: Record<string, string>;
};

export type CallbackOutcome = "NOT_FOUND" | "DUPLICATE" | "IGNORED" | "FAILED" | "SUCCESS" | "RECONCILING";

const OPEN: readonly PaymentStatus[] = [PaymentStatus.INITIATED, PaymentStatus.PROCESSING];

export async function applyPaymentCallback(
  prisma: Pick<PrismaService, "withSystem" | "withTenant">,
  callback: PaymentCallbackJob,
  qr: TicketQrSigner,
  now: Date = new Date(),
): Promise<CallbackOutcome> {
  try {
    const outcome = await withPaymentOperator(prisma, callback.paymentCode, (tx, operatorId) => apply(tx, operatorId, callback, qr, now));
    return outcome ?? "NOT_FOUND";
  } catch (error) {
    // Cùng giao dịch của cổng đã ghi ở payment khác (unique provider + provider_txn_id) → đã xử lý, bỏ qua.
    if ((error as { code?: unknown } | null)?.code === "P2002") {
      return "DUPLICATE";
    }
    throw error;
  }
}

async function apply(tx: DbTransaction, operatorId: string, callback: PaymentCallbackJob, qr: TicketQrSigner, now: Date): Promise<CallbackOutcome> {
  const actor = `provider:${callback.provider}`;
  const [payment] = await tx.$queryRaw<{ id: string; bookingId: string; provider: string; status: PaymentStatus; amount: bigint; providerTxnId: string | null }[]>`
    SELECT id, booking_id AS "bookingId", provider::text AS "provider", status::text AS "status", amount,
      provider_txn_id AS "providerTxnId"
    FROM payments WHERE payment_code = ${callback.paymentCode} AND operator_id = ${operatorId}
    FOR UPDATE`;
  if (!payment || payment.provider !== callback.provider) {
    return "NOT_FOUND";
  }
  const history = (to: PaymentStatus, reason: string) =>
    tx.paymentStatusHistory.create({ data: { paymentId: payment.id, operatorId, fromStatus: payment.status, toStatus: to, reason, actor } });

  if (payment.status === PaymentStatus.SUCCESS || payment.status === PaymentStatus.RECONCILING) {
    return "DUPLICATE";
  }
  if (!callback.success) {
    if (!OPEN.includes(payment.status)) {
      return "IGNORED";
    }
    await tx.payment.update({
      where: { id: payment.id },
      data: { status: PaymentStatus.FAILED, failureCode: callback.resultCode, providerTxnId: callback.providerTxnId, callback: callback.fields },
    });
    await history(PaymentStatus.FAILED, `Cổng báo thất bại (mã ${callback.resultCode}).`);
    return "FAILED";
  }

  // Thành công: tiền đã bị trừ ở cổng. Nhận vào booking nếu booking còn chờ thanh toán VÀ còn giữ đủ ghế; ngược lại
  // chuyển đối soát (Admin / job đối soát xử lý — thường là hoàn tiền), không bao giờ âm thầm bỏ qua.
  const reconcile = async (reason: string) => {
    await tx.payment.update({
      where: { id: payment.id },
      data: { status: PaymentStatus.RECONCILING, reconcileReason: reason, providerTxnId: callback.providerTxnId, callback: callback.fields },
    });
    await history(PaymentStatus.RECONCILING, `Cần đối soát: ${reason}.`);
    return "RECONCILING" as const;
  };
  if (BigInt(callback.amount) !== payment.amount) {
    return reconcile("AMOUNT_MISMATCH");
  }
  await tx.$queryRaw`SELECT id FROM bookings WHERE id = ${payment.bookingId} AND operator_id = ${operatorId} FOR UPDATE`;
  const booking = await tx.booking.findFirstOrThrow({
    where: { id: payment.bookingId, operatorId },
    select: { status: true, tripId: true, total: true, subtotal: true, trip: { select: { arrivalAt: true } }, _count: { select: { passengers: true } } },
  });
  if (booking.status !== BookingStatus.PENDING_PAYMENT) {
    return reconcile(booking.status === BookingStatus.EXPIRED ? "BOOKING_EXPIRED" : booking.status === BookingStatus.CANCELLED ? "BOOKING_CANCELLED" : "DUPLICATE_PAYMENT");
  }
  const held = await tx.tripSeat.count({ where: { bookingId: payment.bookingId, operatorId, status: "HOLDING" } });
  if (held !== booking._count.passengers) {
    return reconcile("SEATS_RELEASED");
  }

  await tx.payment.update({
    where: { id: payment.id },
    data: { status: PaymentStatus.SUCCESS, providerTxnId: callback.providerTxnId, paidAt: now, callback: callback.fields },
  });
  await history(PaymentStatus.SUCCESS, "Cổng xác nhận thanh toán thành công.");
  await tx.booking.update({ where: { id: payment.bookingId }, data: { status: BookingStatus.PAID, paidAt: now } });
  await tx.bookingStatusHistory.create({
    data: { bookingId: payment.bookingId, operatorId, fromStatus: BookingStatus.PENDING_PAYMENT, toStatus: BookingStatus.PAID, reason: `Thanh toán ${callback.provider}.`, actor, createdAt: now },
  });
  await tx.tripSeat.updateMany({ where: { bookingId: payment.bookingId, operatorId, status: "HOLDING" }, data: { status: "BOOKED" } });
  // Ghi sổ escrow + hoa hồng (BR-30/31), phát hành vé cùng transaction (BR-28) rồi `PAID → CONFIRMED` (SRS §17.6).
  await recordCapture(
    tx,
    operatorId,
    { bookingId: payment.bookingId, tripId: booking.tripId, paymentId: payment.id, total: booking.total, ticketRevenue: booking.subtotal, arrivalAt: booking.trip.arrivalAt },
    now,
  );
  await issueTickets(tx, operatorId, payment.bookingId, qr, now, "system");
  await tx.booking.update({ where: { id: payment.bookingId }, data: { status: BookingStatus.CONFIRMED, confirmedAt: now } });
  await tx.bookingStatusHistory.create({
    // +1 ms: hai dòng lịch sử cùng transaction vẫn sắp đúng thứ tự PAID → CONFIRMED.
    data: { bookingId: payment.bookingId, operatorId, fromStatus: BookingStatus.PAID, toStatus: BookingStatus.CONFIRMED, reason: "Đã phát hành vé.", actor: "system", createdAt: new Date(now.getTime() + 1) },
  });
  // Payment đang mở ở cổng khác của cùng booking → hủy (nếu khách vẫn trả ở đó, callback đến sau sẽ vào đối soát).
  const others = await tx.payment.findMany({
    where: { bookingId: payment.bookingId, operatorId, id: { not: payment.id }, status: { in: [...OPEN] } },
    select: { id: true, status: true },
  });
  for (const other of others) {
    await tx.payment.update({ where: { id: other.id }, data: { status: PaymentStatus.CANCELLED } });
    await tx.paymentStatusHistory.create({
      data: { paymentId: other.id, operatorId, fromStatus: other.status, toStatus: PaymentStatus.CANCELLED, reason: "Booking đã thanh toán qua cổng khác.", actor: "system" },
    });
  }
  return "SUCCESS";
}
