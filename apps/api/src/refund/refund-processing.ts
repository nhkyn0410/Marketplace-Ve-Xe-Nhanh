import { withRefundOperator } from "../database/marketplace-scope";
import type { DbTransaction, PrismaService } from "../database/prisma.service";
import { PaymentStatus, RefundStatus, TicketStatus } from "../database/prisma.types";
import { PaymentGatewayError, type PaymentGateways } from "../external/payment/payment-gateway";
import { recordRefund } from "../escrow/escrow-entries";
import { settleBookingStatus } from "./booking-settlement";

// Hoàn tiền qua cổng (TASK-BTP-005, UC-08 bước 9, OQ-13, ADR-019): job BullMQ ở worker. Ba bước để KHÔNG gọi cổng khi đang
// giữ transaction: (1) nhận việc `APPROVED → PROCESSING`; (2) gọi API hoàn của cổng (mã refund làm mã yêu cầu — cổng tự chặn
// trùng khi thử lại); (3) ghi `SUCCESS` (vé `CANCELLED → REFUNDED`) hoặc `FAILED` (UC-08 A5 → Admin xử lý tay).
// Refund của thanh toán CẦN ĐỐI SOÁT (tiền bị trừ nhưng không nhận vào booking — TASK-ADM-002): không có vé, tiền chưa vào sổ
// giữ hộ → chỉ đổi trạng thái refund, không ghi sổ, không suy lại booking.

export const REFUND_JOB = "refund";
export const REFUND_JOB_OPTIONS = {
  attempts: 6,
  backoff: { type: "exponential", delay: 30_000 },
  removeOnComplete: { age: 30 * 24 * 3600 },
  removeOnFail: false,
} as const;

export type RefundOutcome = "NOT_FOUND" | "SKIPPED" | "SUCCESS" | "FAILED";

/**
 * Xử lý một refund. Lỗi cổng có thể thử lại → ném lại cho BullMQ thử lại theo backoff, trừ lần cuối (`finalAttempt`) thì ghi
 * `FAILED`. Refund không còn `APPROVED` / `PROCESSING` → bỏ qua (chạy lặp an toàn).
 */
export async function processRefund(
  prisma: Pick<PrismaService, "withSystem" | "withTenant">,
  gateways: PaymentGateways,
  refundId: string,
  options: { finalAttempt: boolean; now?: () => Date },
): Promise<RefundOutcome> {
  const now = options.now ?? (() => new Date());
  const claim = await withRefundOperator(prisma, refundId, async (tx, operatorId) => {
    const [locked] = await tx.$queryRaw<{ status: RefundStatus }[]>`
      SELECT status::text AS "status" FROM refunds WHERE id = ${refundId} AND operator_id = ${operatorId} FOR UPDATE`;
    if (!locked || (locked.status !== RefundStatus.APPROVED && locked.status !== RefundStatus.PROCESSING)) {
      return { skip: true as const };
    }
    if (locked.status === RefundStatus.APPROVED) {
      await transition(tx, operatorId, refundId, RefundStatus.APPROVED, RefundStatus.PROCESSING, {}, "Đã gửi yêu cầu hoàn tới cổng thanh toán.", "system", now());
    }
    const refund = await tx.refund.findFirstOrThrow({
      where: { id: refundId, operatorId },
      select: {
        refundCode: true,
        attempt: true,
        amount: true,
        bookingId: true,
        booking: { select: { bookingCode: true } },
        payment: { select: { paymentCode: true, provider: true, providerTxnId: true, amount: true, createdAt: true, status: true } },
      },
    });
    return { skip: false as const, operatorId, ...refund };
  });
  if (!claim) {
    return "NOT_FOUND";
  }
  if (claim.skip) {
    return "SKIPPED";
  }
  const fail = async (failureCode: string, reason: string): Promise<RefundOutcome> => {
    await withRefundOperator(prisma, refundId, async (tx, operatorId) => {
      const failed = await transition(tx, operatorId, refundId, RefundStatus.PROCESSING, RefundStatus.FAILED, { failureCode }, reason, "system", now());
      if (failed && claim.payment.status !== PaymentStatus.RECONCILING) {
        await settleBookingStatus(tx, operatorId, claim.bookingId, "system", "Hoàn tiền thất bại — chuyển xử lý thủ công.", now());
      }
    });
    return "FAILED";
  };

  const gateway = gateways.get(claim.payment.provider);
  if (!gateway || !claim.payment.providerTxnId) {
    return fail(gateway ? "MISSING_PROVIDER_TXN" : "GATEWAY_UNAVAILABLE", "Không gửi được yêu cầu hoàn tới cổng.");
  }
  let providerRefundId: string | null;
  try {
    ({ providerRefundId } = await gateway.refund({
      refundCode: gatewayRequestCode(claim.refundCode, claim.attempt),
      paymentCode: claim.payment.paymentCode,
      providerTxnId: claim.payment.providerTxnId,
      amount: claim.amount,
      paidAmount: claim.payment.amount,
      paymentCreatedAt: claim.payment.createdAt,
      reason: `Hoan tien ve ${claim.booking.bookingCode}`,
      requestedAt: now(),
    }));
  } catch (error) {
    if (!(error instanceof PaymentGatewayError)) {
      throw error;
    }
    if (error.retryable && !options.finalAttempt) {
      throw error;
    }
    return fail(error.resultCode ?? "GATEWAY_ERROR", error.message);
  }
  const done = await withRefundOperator(prisma, refundId, async (tx, operatorId) => {
    const completed = await completeRefund(tx, operatorId, refundId, {
      from: RefundStatus.PROCESSING,
      data: { providerRefundId },
      reason: "Cổng xác nhận hoàn tiền thành công.",
      actor: "system",
      at: now(),
    });
    return completed ? ("SUCCESS" as const) : ("SKIPPED" as const);
  });
  return done ?? "NOT_FOUND";
}

/** Mã yêu cầu gửi cổng của một lần gửi: lần 1 = mã refund; Admin gửi lại thì thêm `R{lần}` (cổng không nhận mã trùng). */
export function gatewayRequestCode(refundCode: string, attempt: number): string {
  return attempt > 1 ? `${refundCode}R${attempt}` : refundCode;
}

/**
 * Hoàn tiền đã xong — cổng xác nhận (worker) hoặc Admin ghi nhận đã hoàn ngoài luồng tự động: `from → SUCCESS`, vé
 * `CANCELLED → REFUNDED`, tiền ra khỏi sổ giữ hộ + trả lại phần hoa hồng (BTP-006), suy lại booking. Refund của thanh toán
 * cần đối soát chỉ đổi trạng thái refund. `false` khi refund không còn ở `from` (thao tác khác vừa đổi).
 */
export async function completeRefund(
  tx: DbTransaction,
  operatorId: string,
  refundId: string,
  change: { from: RefundStatus; data: { providerRefundId?: string | null; bankReference?: string }; reason: string; actor: string; at: Date },
): Promise<boolean> {
  const { at, actor } = change;
  if (!(await transition(tx, operatorId, refundId, change.from, RefundStatus.SUCCESS, { ...change.data, processedAt: at }, change.reason, actor, at))) {
    return false;
  }
  const refund = await tx.refund.findFirstOrThrow({
    where: { id: refundId, operatorId },
    select: { bookingId: true, amount: true, payment: { select: { status: true } } },
  });
  if (refund.payment.status === PaymentStatus.RECONCILING) {
    return true;
  }
  const tickets = await tx.ticket.findMany({ where: { refundId, operatorId, status: TicketStatus.CANCELLED }, select: { id: true } });
  await tx.ticket.updateMany({ where: { id: { in: tickets.map((ticket) => ticket.id) } }, data: { status: TicketStatus.REFUNDED } });
  await tx.ticketStatusHistory.createMany({
    data: tickets.map((ticket) => ({ ticketId: ticket.id, operatorId, fromStatus: TicketStatus.CANCELLED, toStatus: TicketStatus.REFUNDED, reason: "Đã hoàn tiền.", actor, createdAt: at })),
  });
  await recordRefund(tx, operatorId, { refundId, bookingId: refund.bookingId, amount: refund.amount }, at);
  await settleBookingStatus(tx, operatorId, refund.bookingId, actor, "Đã hoàn tiền.", new Date(at.getTime() + 1));
  return true;
}

/** Đổi trạng thái refund có điều kiện + lịch sử; `false` khi trạng thái đã khác (thao tác khác vừa đổi). */
export async function transition(
  tx: DbTransaction,
  operatorId: string,
  refundId: string,
  from: RefundStatus,
  to: RefundStatus,
  data: { failureCode?: string | null; providerRefundId?: string | null; bankReference?: string; processedAt?: Date; attempt?: number },
  reason: string,
  actor: string,
  at: Date,
): Promise<boolean> {
  const updated = await tx.refund.updateMany({ where: { id: refundId, operatorId, status: from }, data: { status: to, ...data } });
  if (updated.count === 0) {
    return false;
  }
  await tx.refundStatusHistory.create({ data: { refundId, operatorId, fromStatus: from, toStatus: to, reason, actor, createdAt: at } });
  return true;
}
