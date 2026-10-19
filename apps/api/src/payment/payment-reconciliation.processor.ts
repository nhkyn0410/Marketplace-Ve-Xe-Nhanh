import { InjectQueue, Processor, WorkerHost } from "@nestjs/bullmq";
import { Inject, Logger, type OnModuleInit } from "@nestjs/common";
import type { Job, Queue } from "bullmq";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { PrismaService } from "../database/prisma.service";
import { PAYMENT_GATEWAYS, type PaymentGateways } from "../external/payment/payment-gateway";
import { NotificationDispatcher } from "../notification/notification-dispatcher";
import { QUEUE_NAMES } from "../queue/queue.constants";
import { createTicketQrSigner, type TicketQrSigner } from "../ticket/ticket-qr";
import { reconcilePayments, RECONCILE_JOB, RECONCILE_SCHEDULE, type ReconcileRun } from "./payment-reconciliation";

/** Đối soát thanh toán với cổng mỗi 10 phút (FR-BTP-17, UC-32; ADR-016 concurrency 1, ADR-024 worker). */
@Processor(QUEUE_NAMES.paymentReconciliation, { concurrency: 1 })
export class PaymentReconciliationProcessor extends WorkerHost implements OnModuleInit {
  private readonly logger = new Logger(PaymentReconciliationProcessor.name);
  private readonly qr: TicketQrSigner;

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(PAYMENT_GATEWAYS) private readonly gateways: PaymentGateways,
    @Inject(APP_CONFIG) config: AppConfig,
    @Inject(NotificationDispatcher) private readonly notifications: NotificationDispatcher,
    @InjectQueue(QUEUE_NAMES.paymentReconciliation) private readonly queue: Queue,
    @InjectQueue(QUEUE_NAMES.refundProcessing) private readonly refunds: Queue,
  ) {
    super();
    this.qr = createTicketQrSigner(config);
  }

  /** `upsert` chứ không `add`: worker khởi động lại nhiều lần vẫn chỉ có MỘT lịch. */
  async onModuleInit(): Promise<void> {
    await this.queue.upsertJobScheduler(RECONCILE_JOB, RECONCILE_SCHEDULE, { name: RECONCILE_JOB });
  }

  async process(job: Job): Promise<Omit<ReconcileRun, "confirmedKeys">> {
    if (job.name !== RECONCILE_JOB) {
      throw new Error(`Unsupported reconciliation job: ${job.name}`);
    }
    const { confirmedKeys, ...run } = await reconcilePayments(this.prisma, this.gateways, this.qr, this.refunds);
    // Thanh toán được xác nhận nhờ đối soát → gửi vé điện tử như callback thường.
    await this.notifications.dispatch(confirmedKeys);
    this.logger.log({ event: "payment.reconciliation", ...run });
    return run;
  }
}
