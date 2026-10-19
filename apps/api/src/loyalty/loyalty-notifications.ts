import type { DbTransaction, PrismaService } from "../database/prisma.service";
import { withLoyaltySystem } from "../database/loyalty-scope";
import { queueNotification } from "../notification/notification-outbox";
import { expiringPoints, lockAccount } from "./loyalty-rules";

const DAY = 86400000;
/** Khanh chốt 19/10/2026: nhắc điểm và voucher trước 7 ngày. */
export const LOYALTY_REMINDER_DAYS = 7;
const dateLabel = (at: Date) => new Intl.DateTimeFormat("vi-VN", { timeZone: "Asia/Ho_Chi_Minh" }).format(at);

/** Ghi thông báo cá nhân VXN Plus cùng transaction nghiệp vụ, không gắn nhà xe giả. */
export async function queueLoyaltyNotice(tx: DbTransaction, userId: string, key: string, title: string, message: string): Promise<boolean> {
  const user = await tx.user.findUnique({ where: { id: userId }, select: { email: true, status: true } });
  if (!user || user.status !== "ACTIVE") return false;
  return queueNotification(tx, null, { kind: "LOYALTY_UPDATED", dedupKey: key, recipientType: "PASSENGER", recipientId: userId, recipientEmail: user.email, payload: { title, message } });
}

/** Nhắc một lần cho mỗi lô điểm còn lại và voucher khả dụng sẽ hết hạn trong 7 ngày. */
export async function remindLoyaltyExpiry(prisma: Pick<PrismaService, "withSystem">, now: Date): Promise<{ points: number; vouchers: number }> {
  const through = new Date(now.getTime() + LOYALTY_REMINDER_DAYS * DAY);
  const accounts = await withLoyaltySystem(prisma, (tx) => tx.loyaltyAccount.findMany({ where: { availablePoints: { gt: 0 }, transactions: { some: { points: { gt: 0 }, expiresAt: { gt: now, lte: through } } } }, select: { id: true, userId: true }, orderBy: { id: "asc" } }));
  const result = { points: 0, vouchers: 0 };
  for (const account of accounts) {
    result.points += await withLoyaltySystem(prisma, async (tx) => {
      const locked = await lockAccount(tx, account.userId);
      const batches = await tx.loyaltyPointTransaction.groupBy({ by: ["expiresAt"], where: { accountId: account.id, points: { gt: 0 }, expiresAt: { gt: now, lte: through } }, orderBy: { expiresAt: "asc" } });
      const debits = -((await tx.loyaltyPointTransaction.aggregate({ where: { accountId: account.id, points: { lt: 0 } }, _sum: { points: true } }))._sum.points ?? 0);
      let count = 0;
      for (const batch of batches) {
        const expiry = batch.expiresAt!;
        const [before, including] = await Promise.all([tx.loyaltyPointTransaction.aggregate({ where: { accountId: account.id, points: { gt: 0 }, expiresAt: { lt: expiry } }, _sum: { points: true } }), tx.loyaltyPointTransaction.aggregate({ where: { accountId: account.id, points: { gt: 0 }, expiresAt: { lte: expiry } }, _sum: { points: true } })]);
        const points = expiringPoints(including._sum.points ?? 0, debits, locked.availablePoints) - expiringPoints(before._sum.points ?? 0, debits, locked.availablePoints);
        if (points > 0 && await queueLoyaltyNotice(tx, account.userId, `POINT_EXPIRY:${account.id}:${expiry.toISOString()}`, "Điểm VXN Plus sắp hết hạn", `${points.toLocaleString("vi-VN")} điểm sẽ hết hạn ngày ${dateLabel(expiry)}. Bạn có thể đổi điểm lấy voucher trước hạn này.`)) count++;
      }
      return count;
    });
  }
  const vouchers = await withLoyaltySystem(prisma, (tx) => tx.userVoucher.findMany({ where: { status: "AVAILABLE", expiresAt: { gt: now, lte: through }, OR: [{ promotionId: null }, { promotion: { status: "ACTIVE", endsAt: { gt: now } } }] }, orderBy: { expiresAt: "asc" }, include: { promotion: { select: { code: true } } } }));
  for (const voucher of vouchers) {
    if (await withLoyaltySystem(prisma, (tx) => queueLoyaltyNotice(tx, voucher.userId, `VOUCHER_EXPIRY:${voucher.id}:${voucher.expiresAt.toISOString()}`, "Voucher sắp hết hạn", `${voucher.promotion?.code ?? "Voucher đổi điểm VXN Plus"}${voucher.discountAmount ? ` trị giá ${new Intl.NumberFormat("vi-VN").format(voucher.discountAmount)} ₫` : ""} sẽ hết hạn ngày ${dateLabel(voucher.expiresAt)}. Mở ví voucher để sử dụng trước hạn.`))) result.vouchers++;
  }
  return result;
}
