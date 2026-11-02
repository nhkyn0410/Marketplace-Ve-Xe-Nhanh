import { randomUUID } from "node:crypto";
import type { DbTransaction } from "../database/prisma.service";
import { LoyaltyPointType, LoyaltyTier, PolicyType } from "../database/prisma.types";
import { LoyaltyRulesSchema, type LoyaltyRules } from "../policy/dto/policy.dto";

/** Hạng xét theo điểm tích trong 12 tháng gần nhất (BR-68). */
export const TIER_WINDOW_MONTHS = 12;

export type LoyaltyPolicy = { id: string; version: number; rules: LoyaltyRules };

/** Phiên bản chính sách VXN Plus đang áp dụng tại `at` (FR-LOY-10); chưa có / nội dung hỏng → `null` (chương trình chưa chạy). */
export async function loyaltyPolicyAt(tx: DbTransaction, at: Date): Promise<LoyaltyPolicy | null> {
  const row = await tx.policyVersion.findFirst({
    where: { type: PolicyType.LOYALTY, operatorId: null, status: "PUBLISHED", effectiveFrom: { lte: at } },
    orderBy: { effectiveFrom: "desc" },
    select: { id: true, version: true, rules: true },
  });
  const parsed = row ? LoyaltyRulesSchema.safeParse(row.rules) : null;
  return row && parsed?.success ? { id: row.id, version: row.version, rules: parsed.data } : null;
}

/** Hạng theo điểm tích 12 tháng: mốc cao nhất đã đạt. */
export function tierFor(rules: LoyaltyRules, earned12m: number): LoyaltyRules["tiers"][number] {
  return [...rules.tiers].reverse().find((tier) => earned12m >= tier.minPoints) ?? rules.tiers[0]!;
}

/** Hạng kế tiếp + số điểm còn thiếu; hạng cao nhất → `null`. */
export function nextTierFor(rules: LoyaltyRules, earned12m: number): { tier: LoyaltyTier; minPoints: number; remaining: number } | null {
  const next = rules.tiers.find((tier) => tier.minPoints > earned12m);
  return next ? { tier: next.tier, minPoints: next.minPoints, remaining: next.minPoints - earned12m } : null;
}

/** Điểm tích (BR-66): làm tròn xuống (số tiền căn cứ ÷ đơn vị tích × hệ số), tính số nguyên BIGINT — không sai số. */
export function earnPoints(basis: bigint, earnUnit: number, multiplierPercent: number): number {
  if (basis <= 0n) {
    return 0;
  }
  return Number((basis * BigInt(multiplierPercent)) / (BigInt(earnUnit) * 100n));
}

/** Điểm thu hồi cho một lần hoàn (BR-67): theo tỷ lệ số tiền hoàn trên số tiền căn cứ lúc tích, làm tròn xuống, không vượt phần còn lại. */
export function reversalPoints(earned: number, earnBasis: bigint, refundAmount: bigint, alreadyReversed: number): number {
  const left = earned - alreadyReversed;
  if (left <= 0 || earnBasis <= 0n || refundAmount <= 0n) {
    return 0;
  }
  const points = Number((BigInt(earned) * refundAmount) / earnBasis);
  return Math.min(points, left);
}

/**
 * Điểm hết hạn (BR-70 — điểm tích trước dùng / hết hạn trước): mọi giao dịch trừ điểm coi như lấy từ lô sắp hết hạn nhất, nên phần
 * hết hạn = tổng các lô đã tới hạn − tổng đã trừ (kể cả lần hết hạn trước), không âm, không vượt số dư. Chạy lại cùng dữ liệu → 0.
 */
export function expiringPoints(expiredCredits: number, debits: number, available: number): number {
  return Math.max(0, Math.min(available, expiredCredits - debits));
}

/** Cộng tháng theo lịch (UTC); ngày 31 sang tháng ngắn hơn → ngày cuối tháng. */
export function addMonths(at: Date, months: number): Date {
  const result = new Date(at.getTime());
  const day = result.getUTCDate();
  result.setUTCDate(1);
  result.setUTCMonth(result.getUTCMonth() + months);
  const last = new Date(Date.UTC(result.getUTCFullYear(), result.getUTCMonth() + 1, 0)).getUTCDate();
  result.setUTCDate(Math.min(day, last));
  return result;
}

/** Tổng điểm tích 12 tháng tới `at` (tích − thu hồi; không trừ điểm đã đổi / hết hạn — BR-68). */
export async function earnedWithinWindow(tx: DbTransaction, accountId: string, at: Date): Promise<number> {
  const sum = await tx.loyaltyPointTransaction.aggregate({
    where: { accountId, type: { in: [LoyaltyPointType.EARN, LoyaltyPointType.REVERSAL] }, createdAt: { gt: addMonths(at, -TIER_WINDOW_MONTHS), lte: at } },
    _sum: { points: true },
  });
  return Math.max(0, sum._sum.points ?? 0);
}

/** Khóa tài khoản thành viên (tạo nếu chưa có — FR-LOY-01) để cộng / trừ điểm tuần tự. */
export async function lockAccount(tx: DbTransaction, userId: string): Promise<{ id: string; availablePoints: number }> {
  // ON CONFLICT: hai transaction cùng tạo tài khoản lần đầu không lỗi trùng (upsert của Prisma đọc rồi mới ghi).
  await tx.$executeRaw`
    INSERT INTO loyalty_accounts (id, user_id, updated_at) VALUES (${randomUUID()}, ${userId}, CURRENT_TIMESTAMP) ON CONFLICT (user_id) DO NOTHING`;
  const [row] = await tx.$queryRaw<{ id: string; availablePoints: number }[]>`
    SELECT id, available_points AS "availablePoints" FROM loyalty_accounts WHERE user_id = ${userId} FOR UPDATE`;
  return row!;
}

export type LoyaltyEntry = {
  type: LoyaltyPointType;
  points: number;
  tier: LoyaltyTier;
  sourceLabel: string;
  idempotencyKey: string;
  actor: string;
  policy: { id: string; version: number } | null;
  bookingId?: string;
  basisAmount?: bigint;
  reason?: string;
  expiresAt?: Date;
};

/** Ghi một giao dịch điểm + cập nhật số dư trong cùng transaction (BR-69: số dư = tổng sổ điểm). Gọi sau `lockAccount`. */
export async function appendEntry(tx: DbTransaction, accountId: string, entry: LoyaltyEntry, at: Date): Promise<void> {
  await tx.loyaltyPointTransaction.create({
    data: {
      accountId,
      type: entry.type,
      points: entry.points,
      tier: entry.tier,
      basisAmount: entry.basisAmount ?? null,
      bookingId: entry.bookingId ?? null,
      sourceLabel: entry.sourceLabel.slice(0, 200),
      policyVersionId: entry.policy?.id ?? null,
      policyVersion: entry.policy?.version ?? null,
      idempotencyKey: entry.idempotencyKey,
      reason: entry.reason ?? null,
      actor: entry.actor,
      expiresAt: entry.expiresAt ?? null,
      createdAt: at,
    },
  });
  if (entry.points !== 0) {
    await tx.loyaltyAccount.update({ where: { id: accountId }, data: { availablePoints: { increment: entry.points }, version: { increment: 1 } } });
  }
}
