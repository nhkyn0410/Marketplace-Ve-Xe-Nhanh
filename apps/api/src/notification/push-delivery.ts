import type { AuditService } from "../audit/audit.service";
import { withNotificationSubject } from "../database/preference-scope";
import type { PrismaService } from "../database/prisma.service";
import type { PushNotifier } from "../external/notification/push/push-notifier";
import { loadTarget, type DeliveryOutcome } from "./notification-delivery";
import { renderNotification } from "./notification-templates";

/** Gửi push từng thiết bị; ghi nhận thiết bị đã nhận để retry không gửi lại chúng. */
export async function deliverPushNotification(prisma: Pick<PrismaService, "withSystem">, notifier: PushNotifier, audit: Pick<AuditService, "recordSystemLog"> | null, deliveryId: string, finalAttempt: boolean): Promise<DeliveryOutcome> {
  const loaded = await withNotificationSubject(prisma, async (tx) => {
    const delivery = await tx.notificationDelivery.findUnique({ where: { id: deliveryId }, include: { notification: true } });
    if (!delivery || delivery.channel !== "PUSH") return null;
    if (delivery.status !== "PENDING") return { delivery, content: null, devices: [] };
    const target = await loadTarget(tx, delivery.operatorId, delivery.notification);
    const devices = delivery.recipientType && delivery.recipientId ? await tx.pushDevice.findMany({ where: { subjectType: delivery.recipientType, subjectId: delivery.recipientId, active: true, ...(delivery.recipientType === "OPERATOR" || delivery.recipientType === "EMPLOYEE" ? { operatorId: delivery.operatorId } : {}) } }) : [];
    return { delivery, content: target.content, devices };
  });
  if (!loaded) return "NOT_FOUND";
  if (loaded.delivery.status !== "PENDING") return "ALREADY_DONE";
  let sent = 0;
  let failed = false;
  for (const device of loaded.devices) {
    const receipt = await withNotificationSubject(prisma, (tx) => tx.notificationPushReceipt.upsert({ where: { deliveryId_deviceId: { deliveryId, deviceId: device.id } }, create: { deliveryId, deviceId: device.id }, update: {} }));
    if (receipt.status === "SENT") { sent += 1; continue; }
    if (receipt.status === "SKIPPED") continue;
    if (!loaded.content) continue;
    try {
      const result = await notifier.send({ provider: device.provider, token: device.token, title: renderNotification(loaded.content).title, body: "Bạn có cập nhật mới trên Vé Xe Nhanh. Mở ứng dụng để xem chi tiết.", notificationId: loaded.delivery.notificationId });
      await withNotificationSubject(prisma, async (tx) => {
        await tx.notificationPushReceipt.update({ where: { id: receipt.id }, data: { status: result === "SENT" ? "SENT" : "SKIPPED" } });
        if (result === "UNREGISTERED") await tx.pushDevice.updateMany({ where: { id: device.id, subjectType: device.subjectType, subjectId: device.subjectId }, data: { active: false } });
      });
      if (result === "SENT") sent += 1;
    } catch { failed = true; }
  }
  const outcome = failed ? (finalAttempt ? "FAILED" : "PENDING") : sent > 0 ? "SENT" : "SKIPPED";
  await withNotificationSubject(prisma, (tx) => tx.notificationDelivery.updateMany({ where: { id: deliveryId, operatorId: loaded.delivery.operatorId, status: "PENDING" }, data: { status: outcome, attempts: { increment: 1 }, sentAt: outcome === "SENT" ? new Date() : null, lastError: failed ? "Kênh push gửi lỗi; token và nội dung đã được ẩn." : null } }));
  try { await audit?.recordSystemLog({ level: failed ? "error" : "info", source: "notification", event: `notification.${outcome.toLowerCase()}`, message: `Thông báo ${loaded.delivery.notification.kind} qua push: ${outcome}.`, context: { deliveryId, channel: "PUSH", kind: loaded.delivery.notification.kind, sent } }); } catch { /* Nhật ký lỗi không làm mất kết quả gửi. */ }
  if (outcome === "PENDING") throw new Error("Push delivery temporarily failed.");
  return outcome;
}
