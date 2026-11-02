import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { parseAppConfig } from "../config/env.config";
import { PrismaService } from "../database/prisma.service";
import { prepareNotificationChannels } from "../notification/notification-outbox";
import { deliverNotification } from "../notification/notification-delivery";
import { remindLoyaltyExpiry } from "./loyalty-notifications";
import { appendEntry, lockAccount } from "./loyalty-rules";
import { PassengerLoyaltyService } from "./passenger-loyalty.service";

describe.skipIf(!process.env.DATABASE_URL && process.env.REQUIRE_DB_TESTS !== "1")("Nhắc điểm và voucher trước 7 ngày — Postgres thật", () => {
  const userId = `loyalty-notice-${randomUUID()}`;
  const otherId = `loyalty-future-${randomUUID()}`;
  let prisma: PrismaService;
  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: process.env.DATABASE_URL }));
    await prisma.withSystem((tx) => tx.user.createMany({ data: [userId, otherId].map((id) => ({ id, name: "Nhắc hạn", email: `${id}@example.com`, emailVerified: true })) }));
  });
  afterAll(async () => {
    if (!prisma) return;
    await prisma.withSystem(async (tx) => {
      await tx.$executeRaw`SELECT set_config('app.allow_ledger_delete', 'on', true)`;
      const deliveries = await tx.notificationDelivery.findMany({ where: { recipientId: { in: [userId, otherId] } }, select: { id: true, notificationId: true } });
      const ids = deliveries.map((row) => row.id);
      await tx.notificationPushReceipt.deleteMany({ where: { deliveryId: { in: ids } } });
      await tx.notificationDelivery.deleteMany({ where: { id: { in: ids } } });
      await tx.notification.deleteMany({ where: { id: { in: deliveries.map((row) => row.notificationId) } } });
      await tx.userVoucher.deleteMany({ where: { userId: { in: [userId, otherId] } } });
      await tx.loyaltyPointTransaction.deleteMany({ where: { account: { userId: { in: [userId, otherId] } } } });
      await tx.loyaltyAccount.deleteMany({ where: { userId: { in: [userId, otherId] } } });
      await tx.user.deleteMany({ where: { id: { in: [userId, otherId] } } });
    });
    await prisma.$disconnect();
  });
  it("chỉ nhắc phần điểm chưa dùng, loại mốc 8 ngày, chạy lại không trùng và gửi email cá nhân", async () => {
    const now = new Date();
    const expiry = new Date(now.getTime() + 7 * 86400000 - 1000);
    await prisma.withSystem(async (tx) => {
      const account = await lockAccount(tx, userId);
      const other = await lockAccount(tx, otherId);
      for (const [id, points, at] of [[account.id, 250, expiry], [account.id, 100, new Date(now.getTime() + 8 * 86400000)], [other.id, 100, new Date(now.getTime() + 8 * 86400000)]] as const) await appendEntry(tx, id, { type: "ADJUST", points, tier: "BRONZE", sourceLabel: "Thử nhắc hạn", idempotencyKey: randomUUID(), actor: "system", policy: null, expiresAt: at }, now);
    });
    const voucher = await new PassengerLoyaltyService(prisma).redeem(userId, 100, randomUUID());
    await prisma.withSystem((tx) => tx.userVoucher.update({ where: { id: voucher.userVoucherId }, data: { expiresAt: expiry } }));
    await remindLoyaltyExpiry(prisma, now);
    await remindLoyaltyExpiry(prisma, now);
    const rows = await prisma.withSystem((tx) => tx.notification.findMany({ where: { operatorId: null, deliveries: { some: { recipientId: userId } } }, include: { deliveries: true } }));
    expect(rows).toHaveLength(3);
    expect(rows.filter((row) => row.dedupKey.startsWith("POINT_EXPIRY:"))).toHaveLength(1);
    expect(rows.filter((row) => row.dedupKey.startsWith("VOUCHER_EXPIRY:"))).toHaveLength(1);
    const pointNotice = rows.find((row) => row.dedupKey.startsWith("POINT_EXPIRY:"))!;
    expect(pointNotice.payload).toMatchObject({ message: expect.stringContaining("150 điểm") });
    expect(await prisma.withSystem((tx) => tx.notificationDelivery.count({ where: { recipientId: otherId } }))).toBe(0);
    await prepareNotificationChannels(prisma, [pointNotice.dedupKey]);
    const sendTransactional = vi.fn().mockResolvedValue(undefined);
    expect(await deliverNotification(prisma, { sendTransactional } as never, null, pointNotice.deliveries[0]!.id, { finalAttempt: false })).toBe("SENT");
    expect(sendTransactional.mock.calls[0]![0].email).toBe(`${userId}@example.com`);
  });
});
