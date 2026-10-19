import { InjectQueue, Processor, WorkerHost } from "@nestjs/bullmq";
import { Inject, Logger, type OnModuleInit } from "@nestjs/common";
import type { Job, Queue } from "bullmq";
import { PrismaService } from "../database/prisma.service";
import { PRIVATE_STORAGE, type StorageProvider } from "../external/storage/storage-provider";
import { QUEUE_NAMES } from "../queue/queue.constants";
import {
  APPLICATION_DOCUMENT_CLEANUP_JOB,
  APPLICATION_DOCUMENT_CLEANUP_SCHEDULE,
  deleteOrphanApplicationDocuments,
} from "./application-document-cleanup";

/** TASK-OPR-001 — dọn giấy tờ hồ sơ đăng ký mồ côi trong kho riêng tư. Chạy trong worker (ADR-024), concurrency 1. */
@Processor(QUEUE_NAMES.kycMaintenance, { concurrency: 1 })
export class ApplicationDocumentCleanupProcessor extends WorkerHost implements OnModuleInit {
  private readonly logger = new Logger(ApplicationDocumentCleanupProcessor.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(PRIVATE_STORAGE) private readonly storage: StorageProvider | null,
    @InjectQueue(QUEUE_NAMES.kycMaintenance) private readonly queue: Queue,
  ) {
    super();
  }

  /** `upsert` chứ không `add`: worker khởi động lại nhiều lần vẫn chỉ có MỘT lịch. */
  async onModuleInit(): Promise<void> {
    await this.queue.upsertJobScheduler(APPLICATION_DOCUMENT_CLEANUP_JOB, APPLICATION_DOCUMENT_CLEANUP_SCHEDULE, {
      name: APPLICATION_DOCUMENT_CLEANUP_JOB,
    });
  }

  async process(job: Job): Promise<{ deleted: number }> {
    if (job.name !== APPLICATION_DOCUMENT_CLEANUP_JOB) {
      throw new Error(`Unsupported KYC maintenance job: ${job.name}`);
    }
    // Production chưa có kho riêng tư (OQ-21) thì cũng chưa có giấy tờ nào để dọn.
    const deleted = this.storage ? await deleteOrphanApplicationDocuments(this.storage, this.prisma) : 0;
    this.logger.log({ event: "operator_application.document.cleanup", deleted });
    return { deleted };
  }
}
