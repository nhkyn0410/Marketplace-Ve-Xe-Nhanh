import { randomUUID } from "node:crypto";
import { withNotificationSubject } from "../../database/preference-scope";
import type { DbTransaction, PrismaService } from "../../database/prisma.service";
import {
  ArticleStatus,
  NotificationCampaignStatus,
  NotificationChannel,
  NotificationLinkType,
  PromotionStatus,
  SubjectType,
} from "../../database/prisma.types";
import { audienceBatch, CAMPAIGN_BATCH_SIZE, type CampaignTarget } from "./campaign-audience";
import { CAMPAIGN_KIND } from "./campaign-rules";

// Gửi chiến dịch theo lô ở worker (TASK-NSR-003). Mỗi lô một transaction, ghi hộp thư + bản gửi push; KHÔNG tạo bản gửi email
// (Resend 100 email/ngày dùng chung với OTP). Khoá chống trùng theo chiến dịch + người nhận nên chạy lại một lô an toàn.

/** Chiến dịch đang gửi mà quá lâu không có lô mới: worker khởi động lại giữa chừng, cần xếp hàng tiếp. */
const STALE_SENDING_MS = 2 * 60_000;
const SWEEP_LIMIT = 20;

type Prisma = Pick<PrismaService, "withSystem">;
type Content = { title: string; body: string; linkType: NotificationLinkType | null; linkTarget: string | null };
type CampaignWithLink = CampaignTarget & {
  id: string;
  title: string;
  body: string;
  promotion: { code: string } | null;
  article: { slug: string } | null;
};

function contentOf(campaign: CampaignWithLink): Content {
  const link = campaign.promotion
    ? { linkType: NotificationLinkType.PROMOTION, linkTarget: campaign.promotion.code }
    : campaign.article
      ? { linkType: NotificationLinkType.ARTICLE, linkTarget: campaign.article.slug }
      : { linkType: null, linkTarget: null };
  return { title: campaign.title, body: campaign.body, ...link };
}

/** Ghi thông báo + tin hộp thư + bản gửi push; trùng khoá thì bỏ qua. Trả số tin mới và các khoá để xếp hàng gửi. */
async function writeMessages(
  tx: DbTransaction,
  campaign: CampaignWithLink,
  content: Content,
  recipients: { userId: string; push: boolean; dedupKey: string }[],
  campaignId: string | null,
  now: Date,
): Promise<{ created: number; dedupKeys: string[] }> {
  if (recipients.length === 0) return { created: 0, dedupKeys: [] };
  const kind = CAMPAIGN_KIND[campaign.type];
  const dedupKeys = recipients.map((recipient) => recipient.dedupKey);
  await tx.notification.createMany({
    data: recipients.map((recipient) => ({
      id: randomUUID(),
      kind,
      dedupKey: recipient.dedupKey,
      // Đã biết kênh gửi: đánh dấu đã chuẩn bị để `prepareNotificationChannels` không thêm gì (nhất là email).
      channelsPreparedAt: now,
      payload: { title: content.title, message: content.body, campaignId: campaign.id },
    })),
    skipDuplicates: true,
  });
  const stored = await tx.notification.findMany({ where: { dedupKey: { in: dedupKeys } }, select: { id: true, dedupKey: true } });
  const notificationOf = new Map(stored.map((row) => [row.dedupKey, row.id]));
  const inbox = await tx.notificationInboxMessage.createMany({
    data: recipients.map((recipient) => ({
      subjectType: SubjectType.PASSENGER,
      subjectId: recipient.userId,
      notificationId: notificationOf.get(recipient.dedupKey)!,
      campaignId,
      kind,
      title: content.title,
      body: content.body,
      linkType: content.linkType,
      linkTarget: content.linkTarget,
    })),
    skipDuplicates: true,
  });
  await tx.notificationDelivery.createMany({
    data: recipients
      .filter((recipient) => recipient.push)
      .map((recipient) => ({
        notificationId: notificationOf.get(recipient.dedupKey)!,
        channel: NotificationChannel.PUSH,
        recipientType: SubjectType.PASSENGER,
        recipientId: recipient.userId,
        recipientMasked: "Thiết bị đã đăng ký",
      })),
    skipDuplicates: true,
  });
  return { created: inbox.count, dedupKeys };
}

export type CampaignBatchResult = { done: boolean; cursor: string | null; dedupKeys: string[] };

/** Xử lý lô kế tiếp của một chiến dịch `SENDING`; chiến dịch đã bị dừng thì không gửi thêm. */
export function runCampaignBatch(prisma: Prisma, campaignId: string, now: Date = new Date()): Promise<CampaignBatchResult> {
  return withNotificationSubject(prisma, async (tx) => {
    // Khoá dòng: hai job của cùng chiến dịch (xếp lại sau sự cố) không xử lý chồng một lô.
    await tx.$queryRaw`SELECT id FROM notification_campaigns WHERE id = ${campaignId} FOR UPDATE`;
    const campaign = await tx.notificationCampaign.findUnique({
      where: { id: campaignId },
      include: { promotion: { select: { code: true } }, article: { select: { slug: true } } },
    });
    if (!campaign || campaign.status !== NotificationCampaignStatus.SENDING) {
      return { done: true, cursor: null, dedupKeys: [] };
    }
    const batch = await audienceBatch(tx, campaign, campaign.cursor, now);
    const { created, dedupKeys } = await writeMessages(
      tx,
      campaign,
      contentOf(campaign),
      batch.recipients.map((recipient) => ({ ...recipient, dedupKey: `CAMPAIGN:${campaign.id}:${recipient.userId}` })),
      campaign.id,
      now,
    );
    const done = batch.scanned < CAMPAIGN_BATCH_SIZE;
    const cursor = batch.lastId ?? campaign.cursor;
    await tx.notificationCampaign.update({
      where: { id: campaign.id },
      data: {
        cursor,
        recipientCount: { increment: created },
        cappedCount: { increment: batch.capped },
        ...(done ? { status: NotificationCampaignStatus.COMPLETED, completedAt: now } : {}),
      },
    });
    return { done, cursor, dedupKeys };
  });
}

/**
 * Chuyển chiến dịch đến giờ sang `SENDING` và trả các chiến dịch cần xếp hàng lô (gồm cả chiến dịch đang gửi bị gián đoạn).
 * Khuyến mãi / bài viết không còn hiệu lực lúc tới giờ thì dừng, không gửi tin trỏ vào nội dung đã hết.
 */
export function startDueCampaigns(prisma: Prisma, now: Date = new Date()): Promise<{ id: string; cursor: string | null; resumed: boolean }[]> {
  return withNotificationSubject(prisma, async (tx) => {
    const due = await tx.notificationCampaign.findMany({
      where: { status: NotificationCampaignStatus.SCHEDULED, scheduledAt: { lte: now } },
      orderBy: { scheduledAt: "asc" },
      take: SWEEP_LIMIT,
      include: { promotion: { select: { status: true, startsAt: true, endsAt: true } }, article: { select: { status: true } } },
    });
    const started: { id: string; cursor: string | null; resumed: boolean }[] = [];
    for (const campaign of due) {
      const stale =
        (campaign.promotionId !== null && (!campaign.promotion || campaign.promotion.status !== PromotionStatus.ACTIVE || campaign.promotion.endsAt <= now)) ||
        (campaign.articleId !== null && campaign.article?.status !== ArticleStatus.PUBLISHED);
      const claimed = await tx.notificationCampaign.updateMany({
        where: { id: campaign.id, status: NotificationCampaignStatus.SCHEDULED },
        data: stale
          ? { status: NotificationCampaignStatus.CANCELLED, cancelledAt: now, note: "Nội dung gắn kèm không còn hiệu lực lúc tới giờ gửi." }
          : { status: NotificationCampaignStatus.SENDING, startedAt: now },
      });
      if (claimed.count === 1 && !stale) started.push({ id: campaign.id, cursor: null, resumed: false });
    }
    const interrupted = await tx.notificationCampaign.findMany({
      where: { status: NotificationCampaignStatus.SENDING, updatedAt: { lt: new Date(now.getTime() - STALE_SENDING_MS) } },
      take: SWEEP_LIMIT,
      select: { id: true, cursor: true },
    });
    return [...started, ...interrupted.map((row) => ({ id: row.id, cursor: row.cursor, resumed: true }))];
  });
}

/** Gửi thử cho đúng một tài khoản, gắn nhãn thử và không tính vào số liệu chiến dịch. */
export function writeCampaignTest(prisma: Prisma, campaign: CampaignWithLink, userId: string, now: Date = new Date()): Promise<{ dedupKeys: string[]; pushDevices: number }> {
  return withNotificationSubject(prisma, async (tx) => {
    const pushDevices = await tx.pushDevice.count({ where: { subjectType: SubjectType.PASSENGER, subjectId: userId, active: true } });
    const content = contentOf(campaign);
    const { dedupKeys } = await writeMessages(
      tx,
      campaign,
      { ...content, title: `[Thử] ${content.title}` },
      [{ userId, push: pushDevices > 0, dedupKey: `CAMPAIGN_TEST:${campaign.id}:${userId}:${now.getTime()}` }],
      null,
      now,
    );
    return { dedupKeys, pushDevices };
  });
}

/** Tên job BullMQ; `:` không hợp lệ trong jobId nên id người dùng phải được làm sạch. */
export function campaignBatchJobId(campaignId: string, cursor: string | null, suffix = ""): string {
  return `campaign-${campaignId}-${(cursor ?? "start").replace(/:/g, "_")}${suffix}`;
}
