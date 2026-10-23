import { Logger } from "@nestjs/common";
import { listEarnCandidates, listExpiryCandidates, listReversalCandidates, withLoyaltySystem } from "../database/loyalty-scope";
import type { DbTransaction, PrismaService } from "../database/prisma.service";
import { LoyaltyPointType, LoyaltyTier, NotificationKind, RefundStatus, SubjectType, TicketStatus, TripStatus } from "../database/prisma.types";
import { queueNotification } from "../notification/notification-outbox";
import { paidPrice } from "../refund/refund-policy";
import { addMonths, appendEntry, earnedWithinWindow, earnPoints, expiringPoints, lockAccount, loyaltyPolicyAt, reversalPoints, tierFor } from "./loyalty-rules";

export const LOYALTY_MAINTENANCE_JOB = "loyalty-maintenance";
/** Mỗi 10 phút — điểm về sau khi chuyến hoàn thành, không cần tức thì. */
export const LOYALTY_MAINTENANCE_SCHEDULE = { every: 10 * 60_000 } as const;
const BATCH = 200;
/** Chỉ quét chuyến hoàn thành trong 30 ngày (job chạy 10 phút / lần, đủ bắt lại khi worker dừng vài ngày). */
const EARN_LOOKBACK_MS = 30 * 86_400_000;
/** Vé không tính điểm (BR-66). */
const EXCLUDED_TICKETS: TicketStatus[] = [TicketStatus.CANCELLED, TicketStatus.REFUNDED, TicketStatus.NO_SHOW];
const VN_DATE = new Intl.DateTimeFormat("vi-VN", { timeZone: "Asia/Ho_Chi_Minh", day: "2-digit", month: "2-digit", year: "numeric" });
const TIER_LABELS = { BRONZE: "Đồng", SILVER: "Bạc", GOLD: "Vàng", PLATINUM: "Bạch kim" };

const logger = new Logger("LoyaltyMaintenance");

export type LoyaltyMaintenanceResult = { earned: number; reversed: number; expired: number; failed: number };

/**
 * VXN Plus (TASK-LOY-001): cộng điểm đơn có chuyến hoàn thành (BR-66), thu hồi khi đơn đã tích được hoàn tiền (BR-67), hết hạn điểm
 * (BR-70). Mỗi đơn / lần hoàn / tài khoản một transaction, khóa tài khoản + khóa chống trùng → chạy lại hay chạy song song đều
 * không ghi trùng. Một mục lỗi không chặn các mục khác.
 */
export async function runLoyaltyMaintenance(prisma: Pick<PrismaService, "withSystem">, now: Date = new Date()): Promise<LoyaltyMaintenanceResult> {
  const result: LoyaltyMaintenanceResult = { earned: 0, reversed: 0, expired: 0, failed: 0 };
  const step = async (key: "earned" | "reversed" | "expired", target: string, work: (tx: DbTransaction) => Promise<boolean>) => {
    try {
      result[key] += (await withLoyaltySystem(prisma, work)) ? 1 : 0;
    } catch (error) {
      result.failed++;
      logger.warn({ event: "loyalty.step_failed", step: key, target, error: (error as Error).message });
    }
  };
  for (const bookingId of await listEarnCandidates(prisma, new Date(now.getTime() - EARN_LOOKBACK_MS), BATCH)) {
    await step("earned", bookingId, (tx) => earnForBooking(tx, bookingId, now));
  }
  for (const { refundId, bookingId } of await listReversalCandidates(prisma, BATCH)) {
    await step("reversed", refundId, (tx) => reverseForRefund(tx, refundId, bookingId, now));
  }
  for (const accountId of await listExpiryCandidates(prisma, now, BATCH)) {
    await step("expired", accountId, (tx) => expireForAccount(tx, accountId, now));
  }
  await withLoyaltySystem(prisma, (tx) => tx.$executeRaw`
    UPDATE user_vouchers v SET status = 'EXPIRED', updated_at = ${now}
    WHERE v.status = 'AVAILABLE' AND (v.expires_at <= ${now} OR EXISTS (
      SELECT 1 FROM promotions p WHERE p.id = v.promotion_id AND (p.status IN ('PAUSED', 'ENDED') OR p.ends_at <= ${now})
    ))`);
  return result;
}

/** Cộng điểm một lần cho đơn (BR-66): tiền khách thực trả của vé hợp lệ − phần đã hoàn theo số tiền, theo hệ số hạng hiện tại. */
export async function earnForBooking(tx: DbTransaction, bookingId: string, now: Date): Promise<boolean> {
  const booking = await tx.booking.findUnique({
    where: { id: bookingId },
    select: {
      bookingCode: true,
      operatorId: true,
      userId: true,
      paidAt: true,
      subtotal: true,
      discount: true,
      trip: { select: { status: true } },
      tickets: { select: { status: true, passenger: { select: { price: true } } } },
      refunds: { where: { status: RefundStatus.SUCCESS }, select: { amount: true, _count: { select: { tickets: true } } } },
    },
  });
  if (!booking?.userId || !booking.paidAt || booking.trip.status !== TripStatus.COMPLETED) {
    return false;
  }
  const policy = await loyaltyPolicyAt(tx, now);
  if (!policy) {
    return false;
  }
  const account = await lockAccount(tx, booking.userId);
  const key = `EARN:${bookingId}`;
  if (await tx.loyaltyPointTransaction.findUnique({ where: { idempotencyKey: key }, select: { id: true } })) {
    return false;
  }
  const ticketsPaid = booking.tickets
    .filter((ticket) => !EXCLUDED_TICKETS.includes(ticket.status))
    .reduce((sum, ticket) => sum + paidPrice(ticket.passenger.price, booking.subtotal, booking.discount), 0n);
  // Hoàn theo số tiền (quyết định tranh chấp, không gắn vé) đã xong trước lúc tích → trừ khỏi số tiền căn cứ.
  const amountRefunds = booking.refunds.filter((refund) => refund._count.tickets === 0).reduce((sum, refund) => sum + refund.amount, 0n);
  const basis = ticketsPaid > amountRefunds ? ticketsPaid - amountRefunds : 0n;
  const tier = tierFor(policy.rules, await earnedWithinWindow(tx, account.id, now));
  const points = earnPoints(basis, policy.rules.earnUnit, tier.multiplierPercent);
  if (points <= 0) {
    return false;
  }
  await appendEntry(
    tx,
    account.id,
    {
      type: LoyaltyPointType.EARN,
      points,
      tier: tier.tier,
      sourceLabel: `Đơn ${booking.bookingCode} · hệ số ×${(tier.multiplierPercent / 100).toLocaleString("vi-VN")}`,
      idempotencyKey: key,
      actor: "system",
      policy,
      bookingId,
      basisAmount: basis,
      expiresAt: addMonths(now, policy.rules.pointExpiryMonths),
    },
    now,
  );
  const recipient = await tx.user.findUnique({ where: { id: booking.userId }, select: { email: true } });
  const nextTier = tierFor(policy.rules, await earnedWithinWindow(tx, account.id, now)).tier;
  await queueNotification(tx, booking.operatorId, { kind: NotificationKind.LOYALTY_UPDATED, dedupKey: `LOYALTY_UPDATED:${key}`, bookingId, recipientEmail: recipient?.email ?? null, recipientType: SubjectType.PASSENGER, recipientId: booking.userId, payload: { title: "Điểm VXN Plus đã được cộng", message: `Bạn vừa nhận ${points} điểm từ đơn ${booking.bookingCode}.${nextTier !== tier.tier ? ` Hạng thành viên mới: ${TIER_LABELS[nextTier]}.` : ""}` } });
  return true;
}

/** Thu hồi điểm theo tỷ lệ số tiền hoàn (BR-67); số dư không đủ → thu tối đa số dư, ghi nhận phần thiếu, không thu lại sau. */
export async function reverseForRefund(tx: DbTransaction, refundId: string, bookingId: string, now: Date): Promise<boolean> {
  const earn = await tx.loyaltyPointTransaction.findUnique({
    where: { idempotencyKey: `EARN:${bookingId}` },
    select: { points: true, basisAmount: true, policyVersionId: true, policyVersion: true, account: { select: { userId: true } } },
  });
  const refund = await tx.refund.findUnique({ where: { id: refundId }, select: { operatorId: true, amount: true, status: true, booking: { select: { bookingCode: true } } } });
  if (!earn || !refund || refund.status !== RefundStatus.SUCCESS) {
    return false;
  }
  const account = await lockAccount(tx, earn.account.userId);
  const key = `REVERSAL:${refundId}`;
  if (await tx.loyaltyPointTransaction.findUnique({ where: { idempotencyKey: key }, select: { id: true } })) {
    return false;
  }
  const prior = await tx.loyaltyPointTransaction.aggregate({ where: { accountId: account.id, bookingId, type: LoyaltyPointType.REVERSAL }, _sum: { points: true } });
  const points = reversalPoints(earn.points, earn.basisAmount ?? 0n, refund.amount, -(prior._sum.points ?? 0));
  const taken = Math.min(points, account.availablePoints);
  const policy = await loyaltyPolicyAt(tx, now);
  await appendEntry(
    tx,
    account.id,
    {
      type: LoyaltyPointType.REVERSAL,
      points: -taken,
      tier: policy ? tierFor(policy.rules, await earnedWithinWindow(tx, account.id, now)).tier : LoyaltyTier.BRONZE,
      sourceLabel: `Hoàn tiền thuộc đơn ${refund.booking.bookingCode}`,
      idempotencyKey: key,
      actor: "system",
      policy: earn.policyVersionId && earn.policyVersion !== null ? { id: earn.policyVersionId, version: earn.policyVersion } : null,
      bookingId,
      basisAmount: refund.amount,
      ...(points > taken ? { reason: `Số dư không đủ — thiếu ${points - taken} điểm (BR-67).` } : {}),
    },
    now,
  );
  const recipient = await tx.user.findUnique({ where: { id: earn.account.userId }, select: { email: true } });
  await queueNotification(tx, refund.operatorId, { kind: NotificationKind.LOYALTY_UPDATED, dedupKey: `LOYALTY_UPDATED:${key}`, bookingId, recipientEmail: recipient?.email ?? null, recipientType: SubjectType.PASSENGER, recipientId: earn.account.userId, payload: { title: "Điểm VXN Plus đã điều chỉnh sau hoàn tiền", message: `Đơn ${refund.booking.bookingCode} đã được hoàn tiền; số điểm đã thu hồi: ${taken}.` } });
  return true;
}

/** Hết hạn điểm tới hạn của một tài khoản (BR-70), rồi dời mốc đã quét. */
export async function expireForAccount(tx: DbTransaction, accountId: string, now: Date): Promise<boolean> {
  const owner = await tx.loyaltyAccount.findUnique({ where: { id: accountId }, select: { userId: true } });
  if (!owner) {
    return false;
  }
  const account = await lockAccount(tx, owner.userId);
  const due = { accountId, points: { gt: 0 }, expiresAt: { lte: now } };
  // Tuần tự: một transaction là một kết nối.
  const credits = await tx.loyaltyPointTransaction.aggregate({ where: due, _sum: { points: true } });
  const debits = await tx.loyaltyPointTransaction.aggregate({ where: { accountId, points: { lt: 0 } }, _sum: { points: true } });
  const latest = await tx.loyaltyPointTransaction.findFirst({ where: due, orderBy: [{ expiresAt: "desc" }, { id: "desc" }], select: { id: true, createdAt: true } });
  const points = expiringPoints(credits._sum.points ?? 0, -(debits._sum.points ?? 0), account.availablePoints);
  const key = latest ? `EXPIRE:${accountId}:${latest.id}` : null;
  let wrote = false;
  if (points > 0 && key && latest && !(await tx.loyaltyPointTransaction.findUnique({ where: { idempotencyKey: key }, select: { id: true } }))) {
    const policy = await loyaltyPolicyAt(tx, now);
    await appendEntry(
      tx,
      accountId,
      {
        type: LoyaltyPointType.EXPIRE,
        points: -points,
        tier: policy ? tierFor(policy.rules, await earnedWithinWindow(tx, accountId, now)).tier : LoyaltyTier.BRONZE,
        sourceLabel: `Điểm tích tới ngày ${VN_DATE.format(latest.createdAt)}`,
        idempotencyKey: key,
        actor: "system",
        policy,
      },
      now,
    );
    wrote = true;
  }
  await tx.loyaltyAccount.update({ where: { id: accountId }, data: { expiredThrough: now } });
  return wrote;
}
