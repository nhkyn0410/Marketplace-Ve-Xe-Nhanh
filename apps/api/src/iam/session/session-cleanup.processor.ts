import { InjectQueue, Processor, WorkerHost } from "@nestjs/bullmq";
import { Inject, Logger, type OnModuleInit } from "@nestjs/common";
import type { Job, Queue } from "bullmq";
import { PrismaService } from "../../database/prisma.service";
import { QUEUE_NAMES } from "../../queue/queue.constants";
import {
  deleteExpiredSessions,
  SESSION_CLEANUP_JOB,
  SESSION_CLEANUP_SCHEDULE,
} from "./session-cleanup";

/** IAM-002.9 — dọn `auth_sessions` hết hạn. Chạy trong worker (ADR-024), concurrency 1. */
@Processor(QUEUE_NAMES.sessionMaintenance, { concurrency: 1 })
export class SessionCleanupProcessor extends WorkerHost implements OnModuleInit {
  private readonly logger = new Logger(SessionCleanupProcessor.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @InjectQueue(QUEUE_NAMES.sessionMaintenance) private readonly queue: Queue,
  ) {
    super();
  }

  /** `upsert` chứ không `add`: worker khởi động lại nhiều lần vẫn chỉ có MỘT lịch. */
  async onModuleInit(): Promise<void> {
    await this.queue.upsertJobScheduler(SESSION_CLEANUP_JOB, SESSION_CLEANUP_SCHEDULE, {
      name: SESSION_CLEANUP_JOB,
    });
  }

  async process(job: Job): Promise<{ deleted: number }> {
    if (job.name !== SESSION_CLEANUP_JOB) {
      throw new Error(`Unsupported session maintenance job: ${job.name}`);
    }
    const deleted = await deleteExpiredSessions(this.prisma);
    this.logger.log({ event: "auth.session.cleanup", deleted });
    return { deleted };
  }
}
