import { InjectQueue, Processor, WorkerHost } from "@nestjs/bullmq";
import { Inject, Logger, type OnModuleInit } from "@nestjs/common";
import type { Job, Queue } from "bullmq";
import { AuditService } from "../audit/audit.service";
import { stalePendingDeliveryIds } from "../database/notification-scope";
import { PrismaService } from "../database/prisma.service";
import { withNotificationSubject } from "../database/preference-scope";
import { PUSH_NOTIFIER, type PushNotifier } from "../external/notification/push/push-notifier";
import { deliverPushNotification } from "./push-delivery";
import { prepareNotificationChannels } from "./notification-outbox";
import { EMAIL_NOTIFIER, type EmailNotifier } from "../external/notification/email-notifier";
import { QUEUE_NAMES } from "../queue/queue.constants";
import { campaignBatchJobId, runCampaignBatch, startDueCampaigns } from "./campaign/campaign-fanout";
import { pendingDeliveryIds } from "../database/notification-scope";
import {
  CAMPAIGN_BATCH_JOB,
  CAMPAIGN_SWEEP_JOB,
  CAMPAIGN_SWEEP_SCHEDULE,
  deliverNotification,
  NOTIFICATION_JOB,
  NOTIFICATION_JOB_OPTIONS,
  NOTIFICATION_SWEEP_JOB,
  NOTIFICATION_SWEEP_SCHEDULE,
  type DeliveryOutcome,
} from "./notification-delivery";

/** Bản gửi `PENDING` lâu hơn mức này mới coi là kẹt (job vừa xếp hàng thì để nó tự chạy). */
const STALE_AFTER_MS = 2 * 60_000;
const SWEEP_LIMIT = 200;

/** TASK-NSR-001 — gửi email thông báo (worker, ADR-024) + quét gửi lại bản gửi kẹt. */
@Processor(QUEUE_NAMES.notifications, { concurrency: 4 })
export class NotificationProcessor extends WorkerHost implements OnModuleInit {
  private readonly logger = new Logger(NotificationProcessor.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(EMAIL_NOTIFIER) private readonly notifier: EmailNotifier,
    @Inject(AuditService) private readonly audit: AuditService,
    @InjectQueue(QUEUE_NAMES.notifications) private readonly queue: Queue,
    @Inject(PUSH_NOTIFIER) private readonly push: PushNotifier,
  ) {
    super();
  }

  /** `upsert` chứ không `add`: worker khởi động lại nhiều lần vẫn chỉ có MỘT lịch quét. */
  async onModuleInit(): Promise<void> {
    await this.queue.upsertJobScheduler(NOTIFICATION_SWEEP_JOB, NOTIFICATION_SWEEP_SCHEDULE, { name: NOTIFICATION_SWEEP_JOB });
    await this.queue.upsertJobScheduler(CAMPAIGN_SWEEP_JOB, CAMPAIGN_SWEEP_SCHEDULE, { name: CAMPAIGN_SWEEP_JOB });
  }

  private enqueueBatch(campaignId: string, cursor: string | null, suffix = ""): Promise<unknown> {
    return this.queue.add(CAMPAIGN_BATCH_JOB, { campaignId }, { ...NOTIFICATION_JOB_OPTIONS, jobId: campaignBatchJobId(campaignId, cursor, suffix) });
  }

  async process(job: Job<{ deliveryId?: string; campaignId?: string }>): Promise<{ outcome?: DeliveryOutcome; requeued?: number }> {
    if (job.name === CAMPAIGN_SWEEP_JOB) {
      const campaigns = await startDueCampaigns(this.prisma);
      for (const campaign of campaigns) {
        await this.enqueueBatch(campaign.id, campaign.cursor, campaign.resumed ? `-resume-${Date.now()}` : "");
      }
      return { requeued: campaigns.length };
    }
    if (job.name === CAMPAIGN_BATCH_JOB && job.data.campaignId) {
      const result = await runCampaignBatch(this.prisma, job.data.campaignId);
      for (const deliveryId of await pendingDeliveryIds(this.prisma, result.dedupKeys)) {
        await this.queue.add(NOTIFICATION_JOB, { deliveryId }, { ...NOTIFICATION_JOB_OPTIONS, jobId: deliveryId });
      }
      if (!result.done) await this.enqueueBatch(job.data.campaignId, result.cursor);
      return { requeued: result.dedupKeys.length };
    }
    if (job.name === NOTIFICATION_SWEEP_JOB) {
      await prepareNotificationChannels(this.prisma);
      const ids = await stalePendingDeliveryIds(this.prisma, new Date(Date.now() - STALE_AFTER_MS), SWEEP_LIMIT);
      for (const deliveryId of ids) {
        // Cùng jobId với lần xếp hàng đầu: job còn trong hàng đợi thì BullMQ bỏ qua, không gửi trùng.
        await this.queue.add(NOTIFICATION_JOB, { deliveryId }, { ...NOTIFICATION_JOB_OPTIONS, jobId: deliveryId });
      }
      return { requeued: ids.length };
    }
    if (job.name !== NOTIFICATION_JOB || !job.data.deliveryId) {
      throw new Error(`Unsupported notification job: ${job.name}`);
    }
    const finalAttempt = job.attemptsMade + 1 >= (job.opts.attempts ?? 1);
    const delivery = await withNotificationSubject(this.prisma, (tx) => tx.notificationDelivery.findUnique({ where: { id: job.data.deliveryId! }, select: { channel: true } }));
    const outcome = delivery?.channel === "PUSH" ? await deliverPushNotification(this.prisma, this.push, this.audit, job.data.deliveryId, finalAttempt) : await deliverNotification(this.prisma, this.notifier, this.audit, job.data.deliveryId, { finalAttempt });
    this.logger.log({ event: "notification.delivered", deliveryId: job.data.deliveryId, outcome });
    return { outcome };
  }
}
