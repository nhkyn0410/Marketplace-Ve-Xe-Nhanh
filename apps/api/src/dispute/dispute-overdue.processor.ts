import { InjectQueue, Processor, WorkerHost } from "@nestjs/bullmq";
import { Inject, Logger, type OnModuleInit } from "@nestjs/common";
import type { Job, Queue } from "bullmq";
import { AuditService } from "../audit/audit.service";
import { PrismaService } from "../database/prisma.service";
import { QUEUE_NAMES } from "../queue/queue.constants";
import { DISPUTE_OVERDUE_JOB, DISPUTE_OVERDUE_SCHEDULE, escalateOverdueDisputes } from "./dispute-overdue";

/** Leo thang tranh chấp quá hạn phản hồi mỗi 15 phút (FR-DSP-05; ADR-016 concurrency 1, ADR-024 worker). */
@Processor(QUEUE_NAMES.disputeMaintenance, { concurrency: 1 })
export class DisputeOverdueProcessor extends WorkerHost implements OnModuleInit {
  private readonly logger = new Logger(DisputeOverdueProcessor.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
    @InjectQueue(QUEUE_NAMES.disputeMaintenance) private readonly queue: Queue,
  ) {
    super();
  }

  /** `upsert` chứ không `add`: worker khởi động lại nhiều lần vẫn chỉ có MỘT lịch. */
  async onModuleInit(): Promise<void> {
    await this.queue.upsertJobScheduler(DISPUTE_OVERDUE_JOB, DISPUTE_OVERDUE_SCHEDULE, { name: DISPUTE_OVERDUE_JOB });
  }

  async process(job: Job): Promise<{ escalated: number }> {
    if (job.name !== DISPUTE_OVERDUE_JOB) {
      throw new Error(`Unsupported dispute job: ${job.name}`);
    }
    const escalated = await escalateOverdueDisputes(this.prisma, this.audit);
    this.logger.log({ event: "dispute.overdue", escalated });
    return { escalated };
  }
}
