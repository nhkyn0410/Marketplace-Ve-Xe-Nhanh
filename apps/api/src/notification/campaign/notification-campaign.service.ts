import { Inject, Injectable } from "@nestjs/common";
import type {
  NotificationAudienceEstimate,
  NotificationAudienceInput,
  NotificationCampaign,
  NotificationCampaignDetail,
  NotificationCampaignInput,
  NotificationCampaignOptions,
  NotificationCampaignPage,
  NotificationCampaignQuery,
  NotificationCampaignSendInput,
  NotificationCampaignTestInput,
  NotificationCampaignTestResult,
} from "@vexenhanh/types";
import { AuditService, AuditWriteError } from "../../audit/audit.service";
import { type DbScope, PrismaService, transactionDeadline, type DbTransaction } from "../../database/prisma.service";
import {
  AccountStatus,
  ArticleStatus,
  NotificationCampaignStatus,
  NotificationChannel,
  NotificationDeliveryStatus,
  PromotionStatus,
} from "../../database/prisma.types";
import { maskEmail } from "../../external/notification/email-notifier";
import type { VerifiedAccessToken } from "../../iam/auth/token.service";
import type { Authorization } from "../../iam/role/authorization";
import { platformDb } from "../../support/support.service";
import { NotificationDispatcher } from "../notification-dispatcher";
import { type AudienceBatch, audienceBatch, CAMPAIGN_BATCH_SIZE } from "./campaign-audience";
import { writeCampaignTest } from "./campaign-fanout";
import { inQuietHours, MAX_SCHEDULE_AHEAD_MS } from "./campaign-rules";
import {
  campaignInvalid,
  campaignNotFound,
  campaignQuietHours,
  campaignStateInvalid,
  campaignTestRecipientNotFound,
  campaignUnavailable,
} from "./notification-campaign.errors";

const AUDIT_TIMEOUT_MS = 2_000;
const OPTION_LIMIT = 100;

type Actor = Pick<VerifiedAccessToken, "sub" | "role">;

const INCLUDE = { promotion: { select: { code: true, name: true } }, article: { select: { title: true, slug: true } } } as const;
type CampaignRow = NonNullable<Awaited<ReturnType<typeof findRow>>>;

function findRow(tx: DbTransaction, id: string) {
  return tx.notificationCampaign.findUnique({ where: { id }, include: INCLUDE });
}

function iso(value: Date | null): string | null {
  return value?.toISOString() ?? null;
}

function present(row: CampaignRow): NotificationCampaign {
  return {
    id: row.id,
    type: row.type,
    title: row.title,
    body: row.body,
    audience: row.audience,
    tiers: row.tiers,
    promotionId: row.promotionId,
    promotionLabel: row.promotion ? `${row.promotion.code} — ${row.promotion.name}` : null,
    articleId: row.articleId,
    articleLabel: row.article?.title ?? null,
    status: row.status,
    scheduledAt: iso(row.scheduledAt),
    startedAt: iso(row.startedAt),
    completedAt: iso(row.completedAt),
    cancelledAt: iso(row.cancelledAt),
    note: row.note,
    recipientCount: row.recipientCount,
    cappedCount: row.cappedCount,
    createdAt: row.createdAt.toISOString(),
    updatedAt: row.updatedAt.toISOString(),
  };
}

/** Khóa dòng rồi đọc: hai quản trị viên bấm gửi cùng lúc chỉ một người thành công. */
async function lockRow(tx: DbTransaction, id: string): Promise<CampaignRow> {
  await tx.$queryRaw`SELECT id FROM notification_campaigns WHERE id = ${id} FOR UPDATE`;
  const row = await findRow(tx, id);
  if (!row) throw campaignNotFound();
  return row;
}

/** Chỉ gắn nội dung khách còn mở được: khuyến mãi đang chạy, bài viết đã đăng. */
async function assertLink(tx: DbTransaction, link: { promotionId: string | null; articleId: string | null }, now: Date): Promise<void> {
  if (link.promotionId) {
    const promotion = await tx.promotion.findUnique({ where: { id: link.promotionId }, select: { status: true, startsAt: true, endsAt: true } });
    if (!promotion || promotion.status !== PromotionStatus.ACTIVE || promotion.startsAt > now || promotion.endsAt <= now) {
      throw campaignInvalid("Khuyến mãi đã chọn không còn chạy.");
    }
  }
  if (link.articleId) {
    const article = await tx.article.findUnique({ where: { id: link.articleId }, select: { status: true } });
    if (article?.status !== ArticleStatus.PUBLISHED) {
      throw campaignInvalid("Bài viết đã chọn chưa được đăng.");
    }
  }
}

/** Chiến dịch thông báo của Platform (TASK-NSR-003, tự thiết kế, chờ duyệt): soạn, ước tính, gửi thử, gửi và theo dõi. */
@Injectable()
export class NotificationCampaignService {
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(NotificationDispatcher) private readonly dispatcher: NotificationDispatcher,
  ) {}

  /** Khuyến mãi đang chạy và bài viết đã đăng để gắn vào chiến dịch. */
  options(authz: Authorization, now: Date = new Date()): Promise<NotificationCampaignOptions> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const [promotions, articles] = await Promise.all([
        tx.promotion.findMany({
          where: { status: PromotionStatus.ACTIVE, startsAt: { lte: now }, endsAt: { gt: now } },
          orderBy: { endsAt: "asc" },
          take: OPTION_LIMIT,
          select: { id: true, code: true, name: true, endsAt: true },
        }),
        tx.article.findMany({
          where: { status: ArticleStatus.PUBLISHED },
          orderBy: { publishedAt: "desc" },
          take: OPTION_LIMIT,
          select: { id: true, title: true, slug: true, publishedAt: true },
        }),
      ]);
      return {
        promotions: promotions.map((row) => ({ ...row, endsAt: row.endsAt.toISOString() })),
        articles: articles.map((row) => ({ ...row, publishedAt: iso(row.publishedAt) })),
      };
    });
  }

  list(authz: Authorization, query: NotificationCampaignQuery): Promise<NotificationCampaignPage> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const where = query.status ? { status: query.status } : {};
      const [rows, total] = await Promise.all([
        tx.notificationCampaign.findMany({ where, orderBy: [{ createdAt: "desc" }, { id: "desc" }], skip: query.offset, take: query.limit, include: INCLUDE }),
        tx.notificationCampaign.count({ where }),
      ]);
      return { items: rows.map(present), total, offset: query.offset, limit: query.limit };
    });
  }

  detail(authz: Authorization, id: string): Promise<NotificationCampaignDetail> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const row = await findRow(tx, id);
      if (!row) throw campaignNotFound();
      const [read, pushes] = await Promise.all([
        tx.notificationInboxMessage.count({ where: { campaignId: id, readAt: { not: null } } }),
        tx.notificationDelivery.groupBy({
          by: ["status"],
          where: { channel: NotificationChannel.PUSH, notification: { inboxMessage: { campaignId: id } } },
          _count: { _all: true },
        }),
      ]);
      const pushCount = (status: NotificationDeliveryStatus) => pushes.find((item) => item.status === status)?._count._all ?? 0;
      return {
        ...present(row),
        stats: {
          read,
          pushSent: pushCount(NotificationDeliveryStatus.SENT),
          pushPending: pushCount(NotificationDeliveryStatus.PENDING),
          pushFailed: pushCount(NotificationDeliveryStatus.FAILED),
          pushSkipped: pushCount(NotificationDeliveryStatus.SKIPPED),
        },
      };
    });
  }

  /** Đếm đúng như lúc gửi, để màn xác nhận luôn hiện số người sẽ nhận. */
  async estimate(authz: Authorization, input: NotificationAudienceInput, now: Date = new Date()): Promise<NotificationAudienceEstimate> {
    const db = platformDb(authz);
    const result: NotificationAudienceEstimate = { recipients: 0, withPush: 0, optedOut: 0, capped: 0 };
    let cursor: string | null = null;
    for (;;) {
      const after: string | null = cursor;
      const batch: AudienceBatch = await this.prisma.withScope(db, (tx) => audienceBatch(tx, input, after, now));
      result.recipients += batch.recipients.length;
      result.withPush += batch.recipients.filter((recipient) => recipient.push).length;
      result.optedOut += batch.optedOut;
      result.capped += batch.capped;
      if (batch.scanned < CAMPAIGN_BATCH_SIZE) return result;
      cursor = batch.lastId;
    }
  }

  create(authz: Authorization, actor: Actor, input: NotificationCampaignInput): Promise<NotificationCampaign> {
    return this.write(platformDb(authz), async (tx, deadline) => {
      await assertLink(tx, input, new Date());
      const row = await tx.notificationCampaign.create({ data: { ...input, createdBy: actor.sub, updatedBy: actor.sub }, include: INCLUDE });
      await this.record(actor, "notification_campaign.create", row.id, null, { ...input }, deadline);
      return present(row);
    });
  }

  update(authz: Authorization, actor: Actor, id: string, input: NotificationCampaignInput): Promise<NotificationCampaign> {
    return this.write(platformDb(authz), async (tx, deadline) => {
      const current = await lockRow(tx, id);
      if (current.status !== NotificationCampaignStatus.DRAFT) {
        throw campaignStateInvalid("Chỉ sửa được chiến dịch đang là bản nháp.");
      }
      await assertLink(tx, input, new Date());
      const row = await tx.notificationCampaign.update({ where: { id }, data: { ...input, updatedBy: actor.sub }, include: INCLUDE });
      await this.record(actor, "notification_campaign.update", id, { title: current.title, body: current.body }, { ...input }, deadline);
      return present(row);
    });
  }

  /** Gửi ngay hoặc hẹn giờ. Worker quét đến giờ rồi mới phát tán theo lô. */
  async send(authz: Authorization, actor: Actor, id: string, input: NotificationCampaignSendInput, now: Date = new Date()): Promise<NotificationCampaign> {
    const at = input.scheduledAt ? new Date(input.scheduledAt) : now;
    if (input.scheduledAt && (at <= now || at.getTime() > now.getTime() + MAX_SCHEDULE_AHEAD_MS)) {
      throw campaignInvalid("Giờ hẹn phải ở tương lai và trong vòng 30 ngày.");
    }
    const campaign = await this.write(platformDb(authz), async (tx, deadline) => {
      const current = await lockRow(tx, id);
      if (current.status !== NotificationCampaignStatus.DRAFT) {
        throw campaignStateInvalid("Chiến dịch này đã được gửi hoặc đã hủy.");
      }
      if (inQuietHours(current.type, at)) throw campaignQuietHours();
      await assertLink(tx, current, now);
      const row = await tx.notificationCampaign.update({
        where: { id },
        data: { status: NotificationCampaignStatus.SCHEDULED, scheduledAt: at, updatedBy: actor.sub },
        include: INCLUDE,
      });
      await this.record(actor, "notification_campaign.send", id, { status: current.status }, { status: row.status, scheduledAt: at.toISOString() }, deadline);
      return present(row);
    });
    if (!input.scheduledAt) await this.dispatcher.wakeCampaigns();
    return campaign;
  }

  /** Dừng khi chưa gửi xong; tin đã vào hộp thư vẫn giữ nguyên. */
  cancel(authz: Authorization, actor: Actor, id: string, now: Date = new Date()): Promise<NotificationCampaign> {
    return this.write(platformDb(authz), async (tx, deadline) => {
      const current = await lockRow(tx, id);
      if (current.status === NotificationCampaignStatus.COMPLETED || current.status === NotificationCampaignStatus.CANCELLED) {
        throw campaignStateInvalid("Chiến dịch đã kết thúc.");
      }
      const row = await tx.notificationCampaign.update({
        where: { id },
        data: { status: NotificationCampaignStatus.CANCELLED, cancelledAt: now, updatedBy: actor.sub },
        include: INCLUDE,
      });
      await this.record(actor, "notification_campaign.cancel", id, { status: current.status }, { status: row.status }, deadline);
      return present(row);
    });
  }

  /** Gửi thử cho một tài khoản hành khách để xem tin thật trên điện thoại trước khi gửi đại trà. */
  async test(authz: Authorization, actor: Actor, id: string, input: NotificationCampaignTestInput): Promise<NotificationCampaignTestResult> {
    const db = platformDb(authz);
    const { campaign, userId } = await this.write(db, async (tx, deadline) => {
      const row = await findRow(tx, id);
      if (!row) throw campaignNotFound();
      const user = await tx.user.findFirst({ where: { email: input.email.toLowerCase(), status: AccountStatus.ACTIVE }, select: { id: true } });
      if (!user) throw campaignTestRecipientNotFound();
      await this.record(actor, "notification_campaign.test", id, null, { recipient: maskEmail(input.email) }, deadline);
      return { campaign: row, userId: user.id };
    });
    const { dedupKeys, pushDevices } = await writeCampaignTest(this.prisma, campaign, userId);
    await this.dispatcher.dispatch(dedupKeys);
    return { pushDevices };
  }

  private async write<T>(db: DbScope, work: (tx: DbTransaction, deadline: number) => Promise<T>): Promise<T> {
    try {
      return await this.prisma.withScope(db, (tx) => work(tx, transactionDeadline(Date.now())));
    } catch (error) {
      if (error instanceof AuditWriteError || (error as { code?: unknown } | null)?.code === "P2028") {
        throw campaignUnavailable();
      }
      throw error;
    }
  }

  private record(actor: Actor, action: string, campaignId: string, before: Record<string, unknown> | null, after: Record<string, unknown>, deadline: number): Promise<void> {
    return this.audit.recordAuditEvent(
      { actorId: actor.sub, actorRole: actor.role, action, targetType: "notification_campaign", targetId: campaignId, before, after },
      { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
    );
  }
}
