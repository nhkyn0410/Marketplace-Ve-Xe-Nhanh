import { Processor, WorkerHost } from "@nestjs/bullmq";
import { Inject, Logger } from "@nestjs/common";
import type { Job } from "bullmq";
import { PrismaService } from "../database/prisma.service";
import { PAYMENT_GATEWAYS, type PaymentGateways } from "../external/payment/payment-gateway";
import { QUEUE_NAMES } from "../queue/queue.constants";
import { processRefund, REFUND_JOB, type RefundOutcome } from "./refund-processing";

/** TASK-BTP-005 — hoàn tiền qua cổng thanh toán (worker, ADR-024). Lỗi cổng tạm thời → BullMQ thử lại theo backoff. */
@Processor(QUEUE_NAMES.refundProcessing, { concurrency: 2 })
export class RefundProcessor extends WorkerHost {
  private readonly logger = new Logger(RefundProcessor.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(PAYMENT_GATEWAYS) private readonly gateways: PaymentGateways,
  ) {
    super();
  }

  async process(job: Job<{ refundId: string }>): Promise<{ outcome: RefundOutcome }> {
    if (job.name !== REFUND_JOB) {
      throw new Error(`Unsupported refund job: ${job.name}`);
    }
    const finalAttempt = job.attemptsMade + 1 >= (job.opts.attempts ?? 1);
    const outcome = await processRefund(this.prisma, this.gateways, job.data.refundId, { finalAttempt });
    this.logger.log({ event: "refund.processed", refundId: job.data.refundId, outcome });
    return { outcome };
  }
}
