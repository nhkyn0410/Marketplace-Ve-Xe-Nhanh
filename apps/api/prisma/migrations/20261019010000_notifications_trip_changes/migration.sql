-- TASK-NSR-001 (thông báo email, FR-NSR-01..05, ADR-020, DB §4 `notifications` / `notification_deliveries`) + TASK-TRN-008
-- (đổi / hủy chuyến đã bán vé, FR-OPS-11..12, BR-10/12/20, BF-06). Thiết kế cột AI tự đề xuất, chờ Khanh duyệt
-- (`doc/task-propreties/TRN-008-todo.md`). Operator-owned theo booking / chuyến + RLS `tenant_isolation`.

-- CreateEnum
CREATE TYPE "NotificationKind" AS ENUM ('BOOKING_CONFIRMED', 'TICKETS_CANCELLED', 'REFUND_SUCCEEDED', 'TRIP_CHANGED', 'TRIP_CANCELLED', 'MANUAL_REFUND');
CREATE TYPE "NotificationChannel" AS ENUM ('EMAIL', 'PUSH', 'SMS');
CREATE TYPE "NotificationDeliveryStatus" AS ENUM ('PENDING', 'SENT', 'FAILED', 'SKIPPED');
CREATE TYPE "TripChangeKind" AS ENUM ('SCHEDULE', 'VEHICLE', 'STOP', 'CANCEL');

-- CreateTable — một sự kiện cần báo (ghi CÙNG transaction nghiệp vụ, gửi sau commit — kiểu outbox).
CREATE TABLE "notifications" (
    "id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "kind" "NotificationKind" NOT NULL,
    -- Khoá chống trùng theo sự kiện (vd `TRIP_CHANGED:{changeId}:{bookingId}`).
    "dedup_key" TEXT NOT NULL,
    "booking_id" TEXT,
    "trip_id" TEXT,
    "refund_id" TEXT,
    "trip_change_id" TEXT,
    -- Dữ liệu dựng nội dung đã chụp lúc phát sinh (số tiền, giờ cũ / mới…) — không chứa email / số điện thoại.
    "payload" JSONB NOT NULL DEFAULT '{}',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable — trạng thái gửi theo kênh (v1 chỉ email; push chờ app di động, SMS hoãn — ADR-020).
CREATE TABLE "notification_deliveries" (
    "id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "notification_id" TEXT NOT NULL,
    "channel" "NotificationChannel" NOT NULL,
    -- Người nhận đã che (`k***@example.com`) — địa chỉ đầy đủ đọc lại từ booking / tài khoản lúc gửi.
    "recipient_masked" TEXT NOT NULL,
    "status" "NotificationDeliveryStatus" NOT NULL DEFAULT 'PENDING',
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "last_error" TEXT,
    "sent_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "notification_deliveries_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "notification_deliveries_attempts" CHECK ("attempts" >= 0)
);

-- CreateTable — lịch sử đổi / hủy chuyến đã bán vé (BR-10): lý do + trước / sau + số đơn bị ảnh hưởng.
CREATE TABLE "trip_changes" (
    "id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "trip_id" TEXT NOT NULL,
    "kinds" "TripChangeKind"[] NOT NULL,
    "before" JSONB NOT NULL,
    "after" JSONB NOT NULL,
    "reason" TEXT NOT NULL,
    "affected_bookings" INTEGER NOT NULL DEFAULT 0,
    "actor" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "trip_changes_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "trip_changes_kinds" CHECK (cardinality("kinds") > 0),
    CONSTRAINT "trip_changes_reason" CHECK (char_length("reason") BETWEEN 3 AND 500),
    CONSTRAINT "trip_changes_affected" CHECK ("affected_bookings" >= 0)
);

-- CreateIndex
CREATE UNIQUE INDEX "notifications_dedup_key_key" ON "notifications"("dedup_key");
CREATE UNIQUE INDEX "notifications_id_operator_id_key" ON "notifications"("id", "operator_id");
CREATE INDEX "notifications_booking_id_idx" ON "notifications"("booking_id");
CREATE UNIQUE INDEX "notification_deliveries_notification_id_channel_key" ON "notification_deliveries"("notification_id", "channel");
CREATE INDEX "notification_deliveries_status_created_at_idx" ON "notification_deliveries"("status", "created_at");
CREATE UNIQUE INDEX "trip_changes_id_operator_id_key" ON "trip_changes"("id", "operator_id");
CREATE INDEX "trip_changes_trip_id_created_at_idx" ON "trip_changes"("trip_id", "created_at");

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_operator_id_fkey" FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "notification_deliveries" ADD CONSTRAINT "notification_deliveries_notification_id_operator_id_fkey" FOREIGN KEY ("notification_id", "operator_id") REFERENCES "notifications"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "trip_changes" ADD CONSTRAINT "trip_changes_trip_id_operator_id_fkey" FOREIGN KEY ("trip_id", "operator_id") REFERENCES "trips"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- RLS
ALTER TABLE "notifications" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "notifications" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "notifications" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
ALTER TABLE "notification_deliveries" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "notification_deliveries" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "notification_deliveries" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
ALTER TABLE "trip_changes" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "trip_changes" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "trip_changes" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
