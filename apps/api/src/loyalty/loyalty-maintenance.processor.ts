import { InjectQueue, Processor, WorkerHost } from "@nestjs/bullmq";
import { Inject, Logger, type OnModuleInit } from "@nestjs/common";
import type { Job, Queue } from "bullmq";
import { PrismaService } from "../database/prisma.service";
import { QUEUE_NAMES } from "../queue/queue.constants";
import { LOYALTY_MAINTENANCE_JOB, LOYALTY_MAINTENANCE_SCHEDULE, runLoyaltyMaintenance, type LoyaltyMaintenanceResult } from "./loyalty-maintenance";

/** Tích / thu hồi / hết hạn điểm VXN Plus mỗi 10 phút (FR-LOY-02/08, BR-66/67/70; ADR-016 concurrency 1, ADR-024 worker). */
@Processor(QUEUE_NAMES.loyaltyMaintenance, { concurrency: 1 })
export class LoyaltyMaintenanceProcessor extends WorkerHost implements OnModuleInit {
  private readonly logger = new Logger(LoyaltyMaintenanceProcessor.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @InjectQueue(QUEUE_NAMES.loyaltyMaintenance) private readonly queue: Queue,
  ) {
    super();
  }

  /** `upsert` chứ không `add`: worker khởi động lại nhiều lần vẫn chỉ có MỘT lịch. */
  async onModuleInit(): Promise<void> {
    await this.queue.upsertJobScheduler(LOYALTY_MAINTENANCE_JOB, LOYALTY_MAINTENANCE_SCHEDULE, { name: LOYALTY_MAINTENANCE_JOB });
  }

  async process(job: Job): Promise<LoyaltyMaintenanceResult> {
    if (job.name !== LOYALTY_MAINTENANCE_JOB) {
      throw new Error(`Unsupported loyalty job: ${job.name}`);
    }
    const result = await runLoyaltyMaintenance(this.prisma);
    this.logger.log({ event: "loyalty.maintenance", ...result });
    return result;
  }
}
