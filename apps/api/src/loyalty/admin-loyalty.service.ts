import { Inject, Injectable } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import { LoyaltyPointType, LoyaltyTier, type AccountStatus } from "../database/prisma.types";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { platformDb } from "../support/support.service";
import { vndToJson } from "../fare/fare-pricing";
import type { LoyaltyMember, LoyaltyReport, LoyaltyReportQuery, LoyaltyTransactionPage, PointAdjustInput } from "./dto/loyalty.dto";
import { addMonths, appendEntry, earnedWithinWindow, lockAccount, loyaltyPolicyAt, nextTierFor, tierFor } from "./loyalty-rules";
import { loyaltyInsufficientPoints, loyaltyMemberNotFound, loyaltyRequestConflict, loyaltyUnavailable } from "./loyalty.errors";
import { queueLoyaltyNotice } from "./loyalty-notifications";

const AUDIT_TIMEOUT_MS = 2_000;
const VN_OFFSET_MS = 7 * 3_600_000;

type Actor = Pick<VerifiedAccessToken, "sub" | "role">;
type UserRow = { id: string; name: string | null; email: string; status: AccountStatus; createdAt: Date };
type MonthRow = { month: string; issued: number; redeemed: number; expired: number; vouchersRedeemed: number };
type VoucherMonthRow = { month: string; vouchersUsed: number; platformDiscount: bigint };

const USER_SELECT = { id: true, name: true, email: true, status: true, createdAt: true } as const;

/**
 * VXN Plus phía Admin (TASK-LOY-001; FR-LOY-11/12, UC-39; Figma ADM-12b/c/d): tra cứu tài khoản thành viên theo email, lịch sử
 * điểm, điều chỉnh điểm thủ công (giao dịch mới + lý do + audit, cần xác nhận lại danh tính), báo cáo theo quý. Scope platform —
 * sổ điểm chỉ platform / system đọc ghi (RLS).
 */
@Injectable()
export class AdminLoyaltyService {
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  async member(authz: Authorization, email: string): Promise<LoyaltyMember> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const user = await tx.user.findFirst({ where: { email: { equals: email, mode: "insensitive" } }, select: USER_SELECT });
      if (!user) {
        throw loyaltyMemberNotFound();
      }
      return summarize(tx, user, new Date());
    });
  }

  async transactions(authz: Authorization, userId: string, query: { offset: number; limit: number }): Promise<LoyaltyTransactionPage> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const user = await tx.user.findUnique({ where: { id: userId }, select: { loyaltyAccount: { select: { id: true } } } });
      if (!user) {
        throw loyaltyMemberNotFound();
      }
      const accountId = user.loyaltyAccount?.id;
      if (!accountId) {
        return { items: [], total: 0 };
      }
      const total = await tx.loyaltyPointTransaction.count({ where: { accountId } });
      const rows = await tx.loyaltyPointTransaction.findMany({
        where: { accountId },
        orderBy: [{ createdAt: "desc" }, { id: "desc" }],
        skip: query.offset,
        take: query.limit,
        select: { id: true, type: true, points: true, tier: true, sourceLabel: true, reason: true, policyVersion: true, expiresAt: true, createdAt: true },
      });
      return {
        total,
        items: rows.map((row) => ({ ...row, expiresAt: row.expiresAt?.toISOString() ?? null, createdAt: row.createdAt.toISOString() })),
      };
    });
  }

  /** FR-LOY-11: cộng / trừ điểm bằng giao dịch `ADJUST` mới; không cho số dư âm; gửi lại cùng `Idempotency-Key` → không ghi thêm. */
  async adjust(authz: Authorization, actor: Actor, userId: string, input: PointAdjustInput, idempotencyKey: string): Promise<LoyaltyMember> {
    return this.write(authz, async (tx, deadline) => {
      const user = await tx.user.findUnique({ where: { id: userId }, select: USER_SELECT });
      if (!user) {
        throw loyaltyMemberNotFound();
      }
      const now = new Date();
      const account = await lockAccount(tx, userId);
      const key = `ADJUST:${idempotencyKey}`;
      const existing = await tx.loyaltyPointTransaction.findUnique({ where: { idempotencyKey: key }, select: { accountId: true } });
      if (existing) {
        if (existing.accountId !== account.id) {
          throw loyaltyRequestConflict();
        }
        return summarize(tx, user, now);
      }
      const points = input.direction === "CREDIT" ? input.points : -input.points;
      if (points < 0 && input.points > account.availablePoints) {
        throw loyaltyInsufficientPoints(account.availablePoints);
      }
      const policy = await loyaltyPolicyAt(tx, now);
      const operator = await tx.platformAccount.findUnique({ where: { id: actor.sub }, select: { username: true } });
      await appendEntry(
        tx,
        account.id,
        {
          type: LoyaltyPointType.ADJUST,
          points,
          tier: policy ? tierFor(policy.rules, await earnedWithinWindow(tx, account.id, now)).tier : LoyaltyTier.BRONZE,
          sourceLabel: `platform/${operator?.username ?? actor.sub} · ${input.reason}`,
          idempotencyKey: key,
          actor: `platform:${actor.sub}`,
          policy,
          reason: input.reason,
          // Điểm cộng tay cũng có hạn như điểm tích (BR-70).
          ...(points > 0 && policy ? { expiresAt: addMonths(now, policy.rules.pointExpiryMonths) } : {}),
        },
        now,
      );
      await this.audit.recordAuditEvent(
        {
          actorId: actor.sub,
          actorRole: actor.role,
          action: "loyalty.adjust",
          targetType: "loyalty_account",
          targetId: account.id,
          before: { availablePoints: account.availablePoints },
          after: { availablePoints: account.availablePoints + points, points },
          reason: input.reason,
        },
        { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
      );
      await queueLoyaltyNotice(tx, userId, `LOYALTY_ADJUSTED:${key}`, "Điểm VXN Plus đã được điều chỉnh", `Tài khoản của bạn ${points > 0 ? "được cộng" : "bị trừ"} ${Math.abs(points).toLocaleString("vi-VN")} điểm. Mở lịch sử điểm để xem chi tiết.`);
      return summarize(tx, user, now);
    });
  }

  /** FR-LOY-12: điểm phát hành / đổi / hết hạn theo tháng của một quý (giờ VN), lọc theo hạng lúc ghi giao dịch. */
  async report(authz: Authorization, query: LoyaltyReportQuery): Promise<LoyaltyReport> {
    const start = new Date(Date.UTC(query.year, (query.quarter - 1) * 3, 1) - VN_OFFSET_MS);
    const end = new Date(Date.UTC(query.year, query.quarter * 3, 1) - VN_OFFSET_MS);
    const tier = query.tier ?? null;
    const rows = await this.prisma.withScope(platformDb(authz), (tx) =>
      tx.$queryRaw<MonthRow[]>`
        SELECT to_char(created_at + interval '7 hours', 'YYYY-MM') AS month,
          COALESCE(SUM(points) FILTER (WHERE type = 'EARN' OR (type = 'ADJUST' AND points > 0)), 0)::int AS issued,
          COALESCE(-SUM(points) FILTER (WHERE type = 'REDEEM'), 0)::int AS redeemed,
          COALESCE(-SUM(points) FILTER (WHERE type = 'EXPIRE'), 0)::int AS expired,
          COUNT(*) FILTER (WHERE type = 'REDEEM')::int AS "vouchersRedeemed"
        FROM loyalty_point_transactions
        WHERE created_at >= ${start} AND created_at < ${end} AND (${tier}::text IS NULL OR tier::text = ${tier})
        GROUP BY 1`,
    );
    const byMonth = new Map(rows.map((row) => [row.month, row]));
    const voucherMonths = await this.prisma.withScope(platformDb(authz), (tx) => tx.$queryRaw<VoucherMonthRow[]>`
      SELECT to_char(e.created_at + interval '7 hours', 'YYYY-MM') AS month,
        COUNT(*) FILTER (WHERE e.entry_type = 'PLATFORM_FUNDED_DISCOUNT')::int AS "vouchersUsed",
        COALESCE(SUM(e.amount), 0)::bigint AS "platformDiscount"
      FROM escrow_ledgers e
      JOIN promotion_redemptions r ON r.booking_id = e.booking_id AND r.operator_id = e.operator_id
      JOIN user_vouchers v ON v.id = r.user_voucher_id
      JOIN loyalty_point_transactions l ON l.id = v.loyalty_transaction_id
      WHERE e.entry_type IN ('PLATFORM_FUNDED_DISCOUNT', 'PLATFORM_FUNDED_DISCOUNT_REVERSAL')
        AND e.created_at >= ${start} AND e.created_at < ${end} AND (${tier}::text IS NULL OR l.tier::text = ${tier})
      GROUP BY 1`);
    const voucherByMonth = new Map(voucherMonths.map((row) => [row.month, row]));
    const nowLocal = new Date(Date.now() + VN_OFFSET_MS);
    const currentMonth = `${nowLocal.getUTCFullYear()}-${String(nowLocal.getUTCMonth() + 1).padStart(2, "0")}`;
    const months = [3, 2, 1]
      .map((offset) => `${query.year}-${String((query.quarter - 1) * 3 + offset).padStart(2, "0")}`)
      .filter((month) => month <= currentMonth)
      .map((month) => {
        const row = byMonth.get(month);
        const voucher = voucherByMonth.get(month);
        return { month, issued: row?.issued ?? 0, redeemed: row?.redeemed ?? 0, expired: row?.expired ?? 0, vouchersRedeemed: row?.vouchersRedeemed ?? 0, vouchersUsed: voucher?.vouchersUsed ?? 0, platformDiscount: signedVndToJson(voucher?.platformDiscount ?? 0n) };
      });
    const sum = (key: "issued" | "redeemed" | "expired" | "vouchersRedeemed" | "vouchersUsed") => months.reduce((total, month) => total + month[key], 0);
    return {
      year: query.year,
      quarter: query.quarter,
      tier,
      months,
      totals: {
        issued: sum("issued"),
        redeemed: sum("redeemed"),
        expired: sum("expired"),
        vouchersRedeemed: sum("vouchersRedeemed"),
        vouchersUsed: sum("vouchersUsed"),
        platformDiscount: signedVndToJson(months.reduce((total, month) => total + (voucherByMonth.get(month.month)?.platformDiscount ?? 0n), 0n)),
      },
    };
  }

  private async write<T>(authz: Authorization, work: (tx: DbTransaction, deadline: number) => Promise<T>): Promise<T> {
    try {
      return await this.prisma.withScope(platformDb(authz), (tx) => work(tx, transactionDeadline(Date.now())));
    } catch (error) {
      if (error instanceof AuditWriteError || (error as { code?: unknown } | null)?.code === "P2028") {
        throw loyaltyUnavailable();
      }
      throw error;
    }
  }
}

function signedVndToJson(amount: bigint): number {
  return amount < 0n ? -vndToJson(-amount) : vndToJson(amount);
}

/** Thẻ thành viên (Figma ADM-12b): điểm khả dụng, điểm tích 12 tháng, hạng + hạng kế tiếp theo chính sách đang áp dụng. */
export async function summarize(tx: DbTransaction, user: UserRow, now: Date): Promise<LoyaltyMember> {
  const account = await tx.loyaltyAccount.findUnique({ where: { userId: user.id }, select: { id: true, availablePoints: true } });
  const policy = await loyaltyPolicyAt(tx, now);
  const earned12m = account ? await earnedWithinWindow(tx, account.id, now) : 0;
  return {
    userId: user.id,
    name: user.name,
    email: user.email,
    status: user.status,
    memberSince: user.createdAt.toISOString(),
    availablePoints: account?.availablePoints ?? 0,
    earned12m,
    tier: policy ? tierFor(policy.rules, earned12m).tier : LoyaltyTier.BRONZE,
    nextTier: policy ? nextTierFor(policy.rules, earned12m) : null,
    policyVersion: policy?.version ?? null,
  };
}
