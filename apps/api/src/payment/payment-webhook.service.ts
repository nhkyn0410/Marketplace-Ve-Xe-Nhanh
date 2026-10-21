import { InjectQueue } from "@nestjs/bullmq";
import { Inject, Injectable, Logger } from "@nestjs/common";
import type { Queue } from "bullmq";
import { findPaymentByCode } from "../database/marketplace-scope";
import { PrismaService } from "../database/prisma.service";
import { PaymentStatus } from "../database/prisma.types";
import { type GatewayProvider, PAYMENT_GATEWAYS, type PaymentGateways } from "../external/payment/payment-gateway";
import { QUEUE_NAMES } from "../queue/queue.constants";
import { PAYMENT_CALLBACK_JOB, type PaymentCallbackJob } from "./payment-callback";
import { callbackUnavailable } from "./payment.errors";

/** Kết quả nhận callback — controller đổi sang phản hồi riêng của từng cổng (mã IPN VNPay / 204 MoMo). */
export type CallbackAck = "ACCEPTED" | "ALREADY_CONFIRMED" | "NOT_FOUND" | "AMOUNT_MISMATCH" | "INVALID_SIGNATURE";

/**
 * Nhận IPN (ADR-019, API §10.1): xác thực chữ ký bằng adapter của cổng, kiểm nhanh payment có tồn tại / đúng số tiền /
 * đã chốt chưa (VNPay chấm IPN theo các mã này), rồi xếp hàng BullMQ cho worker xử lý (`applyPaymentCallback`). `jobId`
 * theo giao dịch → cổng gửi lặp chỉ thành một job. Không xếp hàng được (Redis lỗi) → 503 để cổng gửi lại.
 */
@Injectable()
export class PaymentWebhookService {
  private readonly logger = new Logger(PaymentWebhookService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(PAYMENT_GATEWAYS) private readonly gateways: PaymentGateways,
    @InjectQueue(QUEUE_NAMES.paymentCallbacks) private readonly queue: Queue,
  ) {}

  async receive(provider: GatewayProvider, input: Record<string, unknown>): Promise<CallbackAck> {
    const callback = this.gateways.get(provider)?.verifyCallback(input);
    if (!callback) {
      this.logger.warn({ event: "payment.callback.invalid_signature", provider });
      return "INVALID_SIGNATURE";
    }
    const payment = await findPaymentByCode(this.prisma, callback.paymentCode);
    if (!payment || payment.provider !== provider) {
      return "NOT_FOUND";
    }
    const settled =
      payment.status === PaymentStatus.SUCCESS ||
      payment.status === PaymentStatus.RECONCILING ||
      (payment.status === PaymentStatus.FAILED && !callback.success);
    const mismatch = payment.amount !== callback.amount;
    if (settled && !mismatch) {
      return "ALREADY_CONFIRMED";
    }
    const job: PaymentCallbackJob = {
      provider,
      paymentCode: callback.paymentCode,
      providerTxnId: callback.providerTxnId,
      amount: callback.amount.toString(),
      success: callback.success,
      resultCode: callback.resultCode,
      fields: callback.fields,
    };
    try {
      await this.queue.add(PAYMENT_CALLBACK_JOB, job, {
        jobId: [provider, callback.paymentCode, callback.providerTxnId ?? "none", callback.resultCode].join("_"),
        attempts: 8,
        backoff: { type: "exponential", delay: 2_000 },
        removeOnComplete: { age: 7 * 24 * 3600 },
        removeOnFail: false,
      });
    } catch (error) {
      this.logger.error({ event: "payment.callback.enqueue_failed", provider, paymentCode: callback.paymentCode, error });
      throw callbackUnavailable();
    }
    // Lệch số tiền: vẫn xếp hàng để worker ghi `RECONCILING`, nhưng báo cổng mã "sai số tiền".
    return mismatch ? "AMOUNT_MISMATCH" : "ACCEPTED";
  }
}
