import { randomInt } from "node:crypto";
import type { Queue } from "bullmq";
import { listPaymentsToReconcile, listStuckRefunds, withPaymentOperator } from "../database/marketplace-scope";
import type { PrismaService } from "../database/prisma.service";
import { PaymentStatus } from "../database/prisma.types";
import type { PaymentGateways, TransactionStatus } from "../external/payment/payment-gateway";
import { REFUND_JOB, REFUND_JOB_OPTIONS } from "../refund/refund-processing";
import type { TicketQrSigner } from "../ticket/ticket-qr";
import { applyPaymentCallback, bookingConfirmedKey } from "./payment-callback";

// Đối soát tự động với cổng (FR-BTP-17, UC-32, LLD §6.3 bước 4; ADR-016 cron BullMQ concurrency 1). Bắt callback bị mất: thanh
// toán đã quá hạn / bị hủy mà cổng nói khách ĐÃ trả → áp như callback thành công (booking còn chờ → xác nhận; không → "cần đối
// soát" để Admin hoàn); cổng nói thất bại → ghi thất bại. Đồng thời xếp hàng lại refund đứng yên ở `APPROVED`.

export const RECONCILE_JOB = "payment-reconciliation";
export const RECONCILE_SCHEDULE = { every: 10 * 60_000 } as const;
/** Chỉ tra thanh toán tạo trong 48 giờ (cổng thường chỉ cho tra cứu / hoàn giao dịch gần). */
const LOOKBACK_MS = 48 * 3_600_000;
/** Không tra lại cùng thanh toán trong 30 phút. */
const RECHECK_MS = 30 * 60_000;
/** Refund `APPROVED` quá 30 phút chưa được worker nhận → xếp hàng lại. */
const STUCK_REFUND_MS = 30 * 60_000;
const BATCH = 100;
const CODE_ALPHABET = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ";

export type ReconcileRun = { checked: number; confirmed: number; reconciling: number; failed: number; unchanged: number; errors: number; refundsRequeued: number; confirmedKeys: string[] };

export async function reconcilePayments(
  prisma: Pick<PrismaService, "withSystem" | "withTenant">,
  gateways: PaymentGateways,
  qr: TicketQrSigner,
  refunds: Pick<Queue, "add">,
  now: Date = new Date(),
): Promise<ReconcileRun> {
  const run: ReconcileRun = { checked: 0, confirmed: 0, reconciling: 0, failed: 0, unchanged: 0, errors: 0, refundsRequeued: 0, confirmedKeys: [] };
  const candidates = await listPaymentsToReconcile(prisma, {
    expiredBefore: now,
    createdAfter: new Date(now.getTime() - LOOKBACK_MS),
    checkedBefore: new Date(now.getTime() - RECHECK_MS),
    limit: BATCH,
  });
  for (const payment of candidates) {
    const gateway = gateways.get(payment.provider);
    if (!gateway) {
      continue;
    }
    run.checked += 1;
    let result: TransactionStatus | null = null;
    try {
      result = await gateway.queryTransaction({ paymentCode: payment.paymentCode, requestCode: requestCode(), paymentCreatedAt: payment.createdAt, requestedAt: now });
    } catch {
      run.errors += 1;
    }
    if (result?.status === "SUCCESS") {
      const outcome = await applyPaymentCallback(
        prisma,
        {
          provider: payment.provider,
          paymentCode: payment.paymentCode,
          providerTxnId: result.providerTxnId,
          amount: String(result.amount ?? payment.amount),
          success: true,
          resultCode: result.resultCode,
          fields: { source: "reconciliation" },
        },
        qr,
        now,
      );
      if (outcome === "SUCCESS") {
        run.confirmed += 1;
        run.confirmedKeys.push(bookingConfirmedKey(payment.paymentCode));
      } else if (outcome === "RECONCILING") {
        run.reconciling += 1;
      } else {
        run.unchanged += 1;
      }
    } else if (result?.status === "FAILED" && (payment.status === PaymentStatus.INITIATED || payment.status === PaymentStatus.PROCESSING)) {
      await applyPaymentCallback(
        prisma,
        { provider: payment.provider, paymentCode: payment.paymentCode, providerTxnId: result.providerTxnId, amount: String(payment.amount), success: false, resultCode: result.resultCode, fields: { source: "reconciliation" } },
        qr,
        now,
      );
      run.failed += 1;
    } else if (result) {
      run.unchanged += 1;
    }
    // Ghi lần tra cứu (kể cả khi cổng lỗi) để lần chạy sau không tra dồn dập cùng thanh toán.
    await withPaymentOperator(prisma, payment.paymentCode, (tx, operatorId) => tx.payment.updateMany({ where: { id: payment.id, operatorId }, data: { providerCheckedAt: now } }));
  }
  for (const refund of await listStuckRefunds(prisma, new Date(now.getTime() - STUCK_REFUND_MS), BATCH)) {
    // Cùng jobId với lần xếp hàng gốc: job còn trong hàng đợi (chờ / đang thử lại) thì BullMQ bỏ qua — không gọi cổng hai lần.
    await refunds.add(REFUND_JOB, { refundId: refund.id }, { ...REFUND_JOB_OPTIONS, jobId: refund.attempt > 1 ? `${refund.id}-${refund.attempt}` : refund.id });
    run.refundsRequeued += 1;
  }
  return run;
}

/** Mã yêu cầu tra cứu, mỗi lần một khác (`vnp_RequestId` / `requestId` của MoMo). */
function requestCode(): string {
  let code = "RQ";
  for (let i = 0; i < 14; i++) {
    code += CODE_ALPHABET[randomInt(CODE_ALPHABET.length)];
  }
  return code;
}
