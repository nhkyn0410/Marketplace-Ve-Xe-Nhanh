import type { DbTransaction } from "../../database/prisma.service";
import {
  AccountStatus,
  LoyaltyPointType,
  type LoyaltyTier,
  NotificationAudience,
  NotificationCampaignType,
  NotificationKind,
  SubjectType,
} from "../../database/prisma.types";
import { addMonths, loyaltyPolicyAt, TIER_WINDOW_MONTHS, tierFor } from "../../loyalty/loyalty-rules";
import { CAMPAIGN_KIND, campaignDelivery, PROMOTION_CAP_MS } from "./campaign-rules";

export const CAMPAIGN_BATCH_SIZE = 200;

export type CampaignTarget = {
  /** Có khi đang gửi: tin của chính chiến dịch không tính vào trần tần suất. */
  id?: string;
  type: NotificationCampaignType;
  audience: NotificationAudience;
  tiers: readonly LoyaltyTier[];
};

export type AudienceBatch = {
  /** Số tài khoản đã xét; nhỏ hơn cỡ lô nghĩa là đã hết. */
  scanned: number;
  lastId: string | null;
  recipients: { userId: string; push: boolean }[];
  optedOut: number;
  capped: number;
};

/** Hạng hiện tại của một lô tài khoản, cùng công thức với `summarize` (BR-68). */
async function tiersOf(tx: DbTransaction, userIds: string[], now: Date): Promise<Map<string, LoyaltyTier> | null> {
  const policy = await loyaltyPolicyAt(tx, now);
  if (!policy) return null;
  const accounts = await tx.loyaltyAccount.findMany({ where: { userId: { in: userIds } }, select: { id: true, userId: true } });
  const earned = await tx.loyaltyPointTransaction.groupBy({
    by: ["accountId"],
    where: {
      accountId: { in: accounts.map((account) => account.id) },
      type: { in: [LoyaltyPointType.EARN, LoyaltyPointType.REVERSAL] },
      createdAt: { gt: addMonths(now, -TIER_WINDOW_MONTHS), lte: now },
    },
    _sum: { points: true },
  });
  const points = new Map(earned.map((row) => [row.accountId, Math.max(0, row._sum.points ?? 0)]));
  const byUser = new Map(accounts.map((account) => [account.userId, points.get(account.id) ?? 0]));
  return new Map(userIds.map((userId) => [userId, tierFor(policy.rules, byUser.get(userId) ?? 0).tier]));
}

/** Một lô tài khoản hành khách đang hoạt động, xếp theo id, kèm quyết định gửi từng người. */
export async function audienceBatch(tx: DbTransaction, target: CampaignTarget, after: string | null, now: Date, limit = CAMPAIGN_BATCH_SIZE): Promise<AudienceBatch> {
  const users = await tx.user.findMany({
    where: { status: AccountStatus.ACTIVE, ...(after ? { id: { gt: after } } : {}) },
    orderBy: { id: "asc" },
    take: limit,
    select: { id: true },
  });
  const empty: AudienceBatch = { scanned: users.length, lastId: users.at(-1)?.id ?? null, recipients: [], optedOut: 0, capped: 0 };
  if (users.length === 0) return empty;
  let ids = users.map((user) => user.id);

  if (target.audience === NotificationAudience.LOYALTY_TIER) {
    const tiers = await tiersOf(tx, ids, now);
    if (!tiers) return empty;
    ids = ids.filter((id) => target.tiers.includes(tiers.get(id)!));
    if (ids.length === 0) return empty;
  }

  const subject = { subjectType: SubjectType.PASSENGER, subjectId: { in: ids } };
  const preferences = await tx.notificationPreference.findMany({ where: { ...subject, kind: CAMPAIGN_KIND[target.type] }, select: { subjectId: true, email: true, push: true } });
  const devices = await tx.pushDevice.findMany({ where: { ...subject, active: true }, distinct: ["subjectId"], select: { subjectId: true } });
  const capped =
    target.type === NotificationCampaignType.PROMOTION
      ? await tx.notificationInboxMessage.findMany({
          where: {
            ...subject,
            kind: NotificationKind.PROMOTION,
            campaignId: target.id ? { not: target.id } : { not: null },
            createdAt: { gt: new Date(now.getTime() - PROMOTION_CAP_MS) },
          },
          distinct: ["subjectId"],
          select: { subjectId: true },
        })
      : [];
  const preferenceOf = new Map(preferences.map((row) => [row.subjectId, row]));
  const withDevice = new Set(devices.map((row) => row.subjectId));
  const cappedIds = new Set(capped.map((row) => row.subjectId));

  const batch: AudienceBatch = { ...empty, recipients: [] };
  for (const userId of ids) {
    const preference = preferenceOf.get(userId);
    const delivery = campaignDelivery(target.type, preference ? { email: preference.email, push: preference.push } : null, withDevice.has(userId));
    if (!delivery.inbox) {
      batch.optedOut += 1;
    } else if (cappedIds.has(userId)) {
      batch.capped += 1;
    } else {
      batch.recipients.push({ userId, push: delivery.push });
    }
  }
  return batch;
}
