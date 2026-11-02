import { InjectQueue, Processor, WorkerHost } from "@nestjs/bullmq";
import { Inject, Logger, type OnModuleInit } from "@nestjs/common";
import type { Job, Queue } from "bullmq";
import { PrismaService } from "../database/prisma.service";
import { PUBLIC_STORAGE, type StorageProvider } from "../external/storage/storage-provider";
import { QUEUE_NAMES } from "../queue/queue.constants";
import {
  deleteOrphanVehicleImages,
  VEHICLE_IMAGE_CLEANUP_JOB,
  VEHICLE_IMAGE_CLEANUP_SCHEDULE,
} from "./vehicle-image-cleanup";

/** TASK-TRN-009 — dọn ảnh xe mồ côi trong kho công khai. Chạy trong worker (ADR-024), concurrency 1. */
@Processor(QUEUE_NAMES.storageMaintenance, { concurrency: 1 })
export class VehicleImageCleanupProcessor extends WorkerHost implements OnModuleInit {
  private readonly logger = new Logger(VehicleImageCleanupProcessor.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(PUBLIC_STORAGE) private readonly storage: StorageProvider,
    @InjectQueue(QUEUE_NAMES.storageMaintenance) private readonly queue: Queue,
  ) {
    super();
  }

  /** `upsert` chứ không `add`: worker khởi động lại nhiều lần vẫn chỉ có MỘT lịch. */
  async onModuleInit(): Promise<void> {
    await this.queue.upsertJobScheduler(VEHICLE_IMAGE_CLEANUP_JOB, VEHICLE_IMAGE_CLEANUP_SCHEDULE, {
      name: VEHICLE_IMAGE_CLEANUP_JOB,
    });
  }

  async process(job: Job): Promise<{ deleted: number }> {
    if (job.name !== VEHICLE_IMAGE_CLEANUP_JOB) {
      throw new Error(`Unsupported storage maintenance job: ${job.name}`);
    }
    const deleted = await deleteOrphanVehicleImages(this.storage, this.prisma);
    this.logger.log({ event: "vehicle.image.cleanup", deleted });
    return { deleted };
  }
}
