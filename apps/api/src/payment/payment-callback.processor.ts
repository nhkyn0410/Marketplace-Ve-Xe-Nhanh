import { Processor, WorkerHost } from "@nestjs/bullmq";
import { Inject, Logger } from "@nestjs/common";
import type { Job } from "bullmq";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { PrismaService } from "../database/prisma.service";
import { NotificationDispatcher } from "../notification/notification-dispatcher";
import { QUEUE_NAMES } from "../queue/queue.constants";
import { createTicketQrSigner, type TicketQrSigner } from "../ticket/ticket-qr";
import { applyPaymentCallback, bookingConfirmedKey, type CallbackOutcome, PAYMENT_CALLBACK_JOB, type PaymentCallbackJob } from "./payment-callback";

/** TASK-BTP-003 — xử lý callback thanh toán đã xác thực (ADR-019, ADR-024 worker). Lỗi → BullMQ thử lại theo backoff. */
@Processor(QUEUE_NAMES.paymentCallbacks, { concurrency: 4 })
export class PaymentCallbackProcessor extends WorkerHost {
  private readonly logger = new Logger(PaymentCallbackProcessor.name);
  private readonly qr: TicketQrSigner;

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(APP_CONFIG) config: AppConfig,
    @Inject(NotificationDispatcher) private readonly notifications: NotificationDispatcher,
  ) {
    super();
    this.qr = createTicketQrSigner(config);
  }

  async process(job: Job<PaymentCallbackJob>): Promise<{ outcome: CallbackOutcome }> {
    if (job.name !== PAYMENT_CALLBACK_JOB) {
      throw new Error(`Unsupported payment callback job: ${job.name}`);
    }
    const outcome = await applyPaymentCallback(this.prisma, job.data, this.qr);
    if (outcome === "SUCCESS") {
      await this.notifications.dispatch([bookingConfirmedKey(job.data.paymentCode)]);
    }
    this.logger.log({ event: "payment.callback", provider: job.data.provider, paymentCode: job.data.paymentCode, outcome });
    return { outcome };
  }
}
