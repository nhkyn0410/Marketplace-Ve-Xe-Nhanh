import { InjectQueue } from "@nestjs/bullmq";
import { Inject, Injectable, Logger } from "@nestjs/common";
import type { Queue } from "bullmq";
import { pendingDeliveryIds } from "../database/notification-scope";
import { PrismaService } from "../database/prisma.service";
import { QUEUE_NAMES } from "../queue/queue.constants";
import { NOTIFICATION_JOB, NOTIFICATION_JOB_OPTIONS } from "./notification-delivery";

/**
 * Xếp hàng gửi các thông báo vừa ghi (TASK-NSR-001) — gọi SAU commit với khoá chống trùng đã dùng khi ghi. Job theo id bản
 * gửi nên gọi lặp không gửi trùng; xếp hàng lỗi thì bản gửi vẫn `PENDING`, job quét 5 phút gửi lại.
 */
@Injectable()
export class NotificationDispatcher {
  private readonly logger = new Logger(NotificationDispatcher.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @InjectQueue(QUEUE_NAMES.notifications) private readonly queue: Queue,
  ) {}

  async dispatch(dedupKeys: string[]): Promise<void> {
    try {
      for (const deliveryId of await pendingDeliveryIds(this.prisma, dedupKeys)) {
        await this.queue.add(NOTIFICATION_JOB, { deliveryId }, { ...NOTIFICATION_JOB_OPTIONS, jobId: deliveryId });
      }
    } catch (error) {
      // Không làm hỏng thao tác nghiệp vụ đã commit — job quét sẽ gửi.
      this.logger.error({ event: "notification.enqueue_failed", dedupKeys, error });
    }
  }
}
