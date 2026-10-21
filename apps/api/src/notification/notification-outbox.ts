import { randomUUID } from "node:crypto";
import type { DbTransaction } from "../database/prisma.service";
import { AccountStatus, NotificationChannel, OperatorRole, SubjectType, type NotificationKind } from "../database/prisma.types";
import { withNotificationSubject } from "../database/preference-scope";
import { mandatoryNotification } from "./preference.service";
import { maskEmail } from "../external/notification/email-notifier";

// Ghi thông báo TRONG transaction nghiệp vụ (TASK-NSR-001, kiểu outbox): commit thì chắc chắn có bản ghi cần gửi; worker gửi
// sau commit (người gọi `NotificationDispatcher.dispatch` theo khoá) và job quét gửi lại bản ghi còn `PENDING`. Trùng khoá chống
// trùng → bỏ qua (chạy lặp / thử lại an toàn).

export type NotificationInput = {
  kind: NotificationKind;
  /** Khoá chống trùng theo sự kiện, vd `TRIP_CHANGED:{changeId}:{bookingId}`. */
  dedupKey: string;
  /** Email người nhận — chỉ lưu bản đã che; địa chỉ đầy đủ đọc lại lúc gửi. */
  recipientEmail: string | null;
  recipientType?: SubjectType;
  recipientId?: string;
  bookingId?: string;
  tripId?: string;
  refundId?: string;
  tripChangeId?: string;
  /** Dữ liệu chụp lúc phát sinh (số tiền, mã vé…) — KHÔNG chứa email / số điện thoại. */
  payload?: Record<string, unknown>;
};

/** Ghi thông báo + bản gửi email; `true` nếu vừa tạo (khoá chưa có). */
export async function queueNotification(tx: DbTransaction, operatorId: string | null, input: NotificationInput): Promise<boolean> {
  let recipientType = input.recipientType;
  let recipientId = input.recipientId;
  if (!recipientId && operatorId && input.payload?.audience === "OPERATOR") {
    const owner = await tx.operatorAccount.findFirst({ where: { operatorId, role: OperatorRole.OPERATOR_OWNER, status: AccountStatus.ACTIVE }, orderBy: { createdAt: "asc" }, select: { id: true } });
    recipientType = SubjectType.OPERATOR;
    recipientId = owner?.id;
  } else if (!recipientId && input.bookingId && operatorId) {
    const booking = await tx.booking.findFirst({ where: { id: input.bookingId, operatorId }, select: { userId: true } });
    if (booking?.userId) { recipientType = SubjectType.PASSENGER; recipientId = booking.userId; }
  }
  if (!input.recipientEmail && !recipientId) {
    return false;
  }
  const id = randomUUID();
  // `ON CONFLICT DO NOTHING` thay vì bắt lỗi unique: lỗi trong transaction Postgres làm hỏng cả transaction nghiệp vụ.
  const inserted = await tx.$queryRaw<{ id: string }[]>`
    INSERT INTO notifications (id, operator_id, kind, dedup_key, booking_id, trip_id, refund_id, trip_change_id, payload)
    VALUES (${id}, ${operatorId}, ${input.kind}::"NotificationKind", ${input.dedupKey}, ${input.bookingId ?? null},
      ${input.tripId ?? null}, ${input.refundId ?? null}, ${input.tripChangeId ?? null}, ${JSON.stringify(input.payload ?? {})}::jsonb)
    ON CONFLICT (dedup_key) DO NOTHING
    RETURNING id`;
  if (inserted.length === 0) {
    return false;
  }
  // Tùy chọn cá nhân cấp Platform được đọc qua helper; tenant nghiệp vụ không được tự vượt RLS.
  // Fanout bổ sung sở thích và push sau commit qua dispatcher.
  await tx.notificationDelivery.create({ data: { operatorId, notificationId: id, channel: NotificationChannel.EMAIL, recipientMasked: input.recipientEmail ? maskEmail(input.recipientEmail) : "Không có email", recipientType, recipientId } });
  return true;
}

/** Bổ sung bản gửi push sau commit, cùng khóa duy nhất loại kênh để gọi lặp an toàn. */
export async function prepareNotificationChannels(prisma: Pick<import("../database/prisma.service").PrismaService, "withSystem">, dedupKeys?: string[]): Promise<void> {
  const candidates = await withNotificationSubject(prisma, (tx) => tx.notification.findMany({ where: { channelsPreparedAt: null, ...(dedupKeys ? { dedupKey: { in: dedupKeys } } : {}) }, orderBy: { createdAt: "asc" }, take: 200, select: { id: true } }));
  for (const candidate of candidates) {
    await withNotificationSubject(prisma, async (tx) => {
      const notification = await tx.notification.findUnique({ where: { id: candidate.id }, include: { deliveries: true } });
      if (!notification || notification.channelsPreparedAt) return;
      const email = notification.deliveries.find((item) => item.channel === NotificationChannel.EMAIL);
      if (!email?.recipientType || !email.recipientId) { await tx.notification.update({ where: { id: notification.id }, data: { channelsPreparedAt: new Date() } }); return; }
      const subject = { subjectType: email.recipientType, subjectId: email.recipientId };
      const pref = await tx.notificationPreference.findUnique({ where: { subjectType_subjectId_kind: { ...subject, kind: notification.kind } } });
      const devices = await tx.pushDevice.count({ where: { ...subject, active: true } });
      const mandatory = mandatoryNotification(notification.kind);
      const sendEmail = pref?.email !== false || (mandatory && (!devices || pref?.push === false));
      if (!sendEmail) await tx.notificationDelivery.updateMany({ where: { id: email.id, status: "PENDING" }, data: { status: "SKIPPED", lastError: "Người nhận đã tắt kênh email cho loại này." } });
      if (devices && pref?.push !== false) await tx.notificationDelivery.upsert({ where: { notificationId_channel: { notificationId: notification.id, channel: NotificationChannel.PUSH } }, create: { operatorId: notification.operatorId, notificationId: notification.id, channel: NotificationChannel.PUSH, recipientType: email.recipientType, recipientId: email.recipientId, recipientMasked: "Thiết bị đã đăng ký" }, update: {} });
      await tx.notification.update({ where: { id: notification.id }, data: { channelsPreparedAt: new Date() } });
    });
  }
}
