import { randomUUID } from "node:crypto";
import type { DbTransaction } from "../database/prisma.service";
import { NotificationChannel, type NotificationKind } from "../database/prisma.types";
import { maskEmail } from "../external/notification/email-notifier";

// Ghi thông báo TRONG transaction nghiệp vụ (TASK-NSR-001, kiểu outbox): commit thì chắc chắn có bản ghi cần gửi; worker gửi
// sau commit (người gọi `NotificationDispatcher.dispatch` theo khoá) và job quét gửi lại bản ghi còn `PENDING`. Trùng khoá chống
// trùng → bỏ qua (chạy lặp / thử lại an toàn).

export type NotificationInput = {
  kind: NotificationKind;
  /** Khoá chống trùng theo sự kiện, vd `TRIP_CHANGED:{changeId}:{bookingId}`. */
  dedupKey: string;
  /** Email người nhận — chỉ dùng để lưu bản đã che; địa chỉ đầy đủ đọc lại lúc gửi. Không có → không tạo thông báo. */
  recipientEmail: string | null;
  bookingId?: string;
  tripId?: string;
  refundId?: string;
  tripChangeId?: string;
  /** Dữ liệu chụp lúc phát sinh (số tiền, mã vé…) — KHÔNG chứa email / số điện thoại. */
  payload?: Record<string, unknown>;
};

/** Ghi thông báo + bản gửi email; `true` nếu vừa tạo (khoá chưa có). */
export async function queueNotification(tx: DbTransaction, operatorId: string, input: NotificationInput): Promise<boolean> {
  if (!input.recipientEmail) {
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
  await tx.notificationDelivery.create({
    data: { operatorId, notificationId: id, channel: NotificationChannel.EMAIL, recipientMasked: maskEmail(input.recipientEmail) },
  });
  return true;
}
