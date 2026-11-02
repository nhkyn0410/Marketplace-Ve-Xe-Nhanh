import { InjectQueue, Processor, WorkerHost } from "@nestjs/bullmq";
import { Inject, Logger, type OnModuleInit } from "@nestjs/common";
import type { Job, Queue } from "bullmq";
import { PrismaService } from "../database/prisma.service";
import { QUEUE_NAMES } from "../queue/queue.constants";
import { generatePayouts, PAYOUT_JOB, PAYOUT_SCHEDULE, type PayoutRun } from "./payout-generation";

/** TASK-BTP-006 — tạo kỳ chi trả T+3 hằng ngày (ADR-022, ADR-024 worker), concurrency 1 (ADR-016). */
@Processor(QUEUE_NAMES.payoutMaintenance, { concurrency: 1 })
export class PayoutGenerationProcessor extends WorkerHost implements OnModuleInit {
  private readonly logger = new Logger(PayoutGenerationProcessor.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @InjectQueue(QUEUE_NAMES.payoutMaintenance) private readonly queue: Queue,
  ) {
    super();
  }

  /** `upsert` chứ không `add`: worker khởi động lại nhiều lần vẫn chỉ có MỘT lịch. */
  async onModuleInit(): Promise<void> {
    await this.queue.upsertJobScheduler(PAYOUT_JOB, PAYOUT_SCHEDULE, { name: PAYOUT_JOB });
  }

  async process(job: Job): Promise<PayoutRun> {
    if (job.name !== PAYOUT_JOB) {
      throw new Error(`Unsupported payout job: ${job.name}`);
    }
    const run = await generatePayouts(this.prisma);
    this.logger.log({ event: "payout.generation", ...run });
    return run;
  }
}
