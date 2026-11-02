import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { parseAppConfig } from "../config/env.config";
import { PrismaService } from "../database/prisma.service";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { queueNotification, prepareNotificationChannels } from "./notification-outbox";
import { PreferenceService } from "./preference.service";
import { deliverPushNotification } from "./push-delivery";
import { deliverNotification } from "./notification-delivery";
import { pendingDeliveryIds } from "../database/notification-scope";

const ready = Boolean(process.env.DATABASE_URL);
describe.skipIf(!ready && process.env.REQUIRE_DB_TESTS !== "1")("Tùy chọn và push — Postgres thật", () => {
  const suffix = randomUUID();
  const operatorId = randomUUID();
  const userId = `notification-${suffix}`;
  const otherId = `notification-other-${suffix}`;
  const actor = { sub: userId, sid: randomUUID(), scope: "passenger", role: "PASSENGER" } as VerifiedAccessToken;
  const other = { ...actor, sub: otherId };
  let prisma: PrismaService;
  let service: PreferenceService;
  const config = parseAppConfig({ DATABASE_URL: process.env.DATABASE_URL, FCM_PROJECT_ID: "test", FCM_CLIENT_EMAIL: "test@example.com", FCM_PRIVATE_KEY: "test-key" });
  beforeAll(async () => {
    prisma = new PrismaService(config);
    service = new PreferenceService(prisma, config);
    await prisma.withSystem(async (tx) => {
      await tx.user.createMany({ data: [{ id: userId, email: `${userId}@example.com`, name: "Test", emailVerified: true }, { id: otherId, email: `${otherId}@example.com`, name: "Other", emailVerified: true }] });
      await tx.operatorProfile.create({ data: { id: operatorId, operatorSlug: `nt-${suffix}`, displayName: "Push test" } });
    });
  });
  afterAll(async () => {
    if (!prisma) return;
    await prisma.withSystem(async (tx) => {
      await tx.notificationPushReceipt.deleteMany({ where: { deliveryId: { in: (await tx.notificationDelivery.findMany({ where: { operatorId }, select: { id: true } })).map((item) => item.id) } } });
      await tx.notificationDelivery.deleteMany({ where: { operatorId } });
      await tx.notification.deleteMany({ where: { operatorId } });
      await tx.pushDevice.deleteMany({ where: { subjectId: { in: [userId, otherId] } } });
      await tx.notificationPreference.deleteMany({ where: { subjectId: { in: [userId, otherId] } } });
      await tx.operatorProfile.delete({ where: { id: operatorId } });
      await tx.user.deleteMany({ where: { id: { in: [userId, otherId] } } });
    });
    await prisma.$disconnect();
  });
  it("bảo vệ kênh bắt buộc, ownership, tắt tin tùy chọn và fanout không trùng", async () => {
    await expect(service.save(actor, { kind: "TRIP_CANCELLED", email: false, push: false })).rejects.toThrow();
    await expect(service.save(actor, { kind: "TRIP_CANCELLED", email: false, push: true })).rejects.toThrow();
    const device = await service.registerDevice(actor, { provider: "FCM", token: `test-token-${suffix}` });
    await service.removeDevice(other, device.id);
    expect((await prisma.withSystem((tx) => tx.pushDevice.findUnique({ where: { id: device.id } })))?.active).toBe(true);
    await service.save(actor, { kind: "PROMOTION", email: false, push: false });
    const key = `pref-${suffix}`;
    await prisma.withTenant(operatorId, (tx) => queueNotification(tx, operatorId, { kind: "PROMOTION", dedupKey: key, recipientEmail: `${userId}@example.com`, recipientType: "PASSENGER", recipientId: userId, payload: { title: "Ưu đãi", message: "Tin mới" } }));
    expect(await pendingDeliveryIds(prisma, [key])).toEqual([]);
    await prepareNotificationChannels(prisma, [key]);
    await prepareNotificationChannels(prisma, [key]);
    const deliveries = await prisma.withSystem((tx) => tx.notificationDelivery.findMany({ where: { notification: { dedupKey: key } } }));
    expect(deliveries).toHaveLength(1);
    expect(deliveries[0]!.status).toBe("SKIPPED");
    expect((await service.history(other, { offset: 0, limit: 25 })).total).toBe(0);
  });
  it("retry bỏ qua thiết bị đã nhận và vô hiệu token hết hạn", async () => {
    await service.registerDevice(actor, { provider: "FCM", token: `second-token-${suffix}` });
    const key = `push-${suffix}`;
    await prisma.withTenant(operatorId, (tx) => queueNotification(tx, operatorId, { kind: "OPERATIONS_ALERT", dedupKey: key, recipientEmail: `${userId}@example.com`, recipientType: "PASSENGER", recipientId: userId, payload: { title: "Test", message: "Cập nhật" } }));
    await prepareNotificationChannels(prisma, [key]);
    const delivery = await prisma.withSystem((tx) => tx.notificationDelivery.findFirstOrThrow({ where: { notification: { dedupKey: key }, channel: "PUSH" } }));
    const send = vi.fn().mockResolvedValueOnce("SENT").mockRejectedValueOnce(new Error("temporary"));
    const audit = { recordSystemLog: vi.fn().mockResolvedValue(undefined) };
    await expect(deliverPushNotification(prisma, { send }, audit, delivery.id, false)).rejects.toThrow();
    send.mockResolvedValueOnce("UNREGISTERED");
    expect(await deliverPushNotification(prisma, { send }, audit, delivery.id, false)).toBe("SENT");
    expect(send).toHaveBeenCalledTimes(3);
    expect(await deliverPushNotification(prisma, { send }, audit, delivery.id, false)).toBe("ALREADY_DONE");
    expect((await prisma.withSystem((tx) => tx.pushDevice.count({ where: { subjectId: userId, active: true } })))).toBe(1);
    expect(JSON.stringify(audit.recordSystemLog.mock.calls)).not.toContain("token");
    const email = await prisma.withSystem((tx) => tx.notificationDelivery.findFirstOrThrow({ where: { notification: { dedupKey: key }, channel: "EMAIL" } }));
    const sendTransactional = vi.fn().mockResolvedValue(undefined);
    expect(await deliverNotification(prisma, { sendTransactional } as never, audit, email.id, { finalAttempt: false })).toBe("SENT");
    expect(sendTransactional.mock.calls[0]![0].email).toBe(`${userId}@example.com`);
  });
});
