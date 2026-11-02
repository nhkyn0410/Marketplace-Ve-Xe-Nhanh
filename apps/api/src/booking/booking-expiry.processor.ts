import { InjectQueue, Processor, WorkerHost } from "@nestjs/bullmq";
import { Inject, Logger, type OnModuleInit } from "@nestjs/common";
import type { Job, Queue } from "bullmq";
import { PrismaService } from "../database/prisma.service";
import { QUEUE_NAMES } from "../queue/queue.constants";
import { PAYMENT_GATEWAYS, type PaymentGateways } from "../external/payment/payment-gateway";
import { BOOKING_EXPIRY_JOB, BOOKING_EXPIRY_SCHEDULE, expireOverdueBookings } from "./booking-expiry";

/** TASK-BTP-002 — booking chờ thanh toán quá hạn → `EXPIRED`, trả ghế. Chạy trong worker (ADR-024), concurrency 1. */
@Processor(QUEUE_NAMES.bookingMaintenance, { concurrency: 1 })
export class BookingExpiryProcessor extends WorkerHost implements OnModuleInit {
  private readonly logger = new Logger(BookingExpiryProcessor.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @InjectQueue(QUEUE_NAMES.bookingMaintenance) private readonly queue: Queue,
    @Inject(PAYMENT_GATEWAYS) private readonly gateways: PaymentGateways,
  ) {
    super();
  }

  /** `upsert` chứ không `add`: worker khởi động lại nhiều lần vẫn chỉ có MỘT lịch. */
  async onModuleInit(): Promise<void> {
    await this.queue.upsertJobScheduler(BOOKING_EXPIRY_JOB, BOOKING_EXPIRY_SCHEDULE, { name: BOOKING_EXPIRY_JOB });
  }

  async process(job: Job): Promise<{ expired: number }> {
    if (job.name !== BOOKING_EXPIRY_JOB) {
      throw new Error(`Unsupported booking maintenance job: ${job.name}`);
    }
    const expired = await expireOverdueBookings(this.prisma, new Date(), this.gateways);
    if (expired > 0) {
      this.logger.log({ event: "booking.expiry", expired });
    }
    return { expired };
  }
}
