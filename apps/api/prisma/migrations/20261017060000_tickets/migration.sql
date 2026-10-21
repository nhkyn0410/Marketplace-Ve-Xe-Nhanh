-- TASK-BTP-004 — vé điện tử + QR (FR-BTP-10/11/18, BR-04/25/29, SRS §17.7; DB §4 nhóm Booking & Ticket, §7 unique
-- `ticket_code` + `qr_token_hash`). Thiết kế cột AI tự đề xuất, chờ Khanh duyệt (`doc/task-propreties/BTP-004-todo.md`).
-- Mỗi chỗ (passenger_info) đúng một vé — phát hành lặp không tạo trùng. QR chỉ lưu hash (SHA-256), không lưu nguyên văn.

-- CreateEnum (SRS §17.7)
CREATE TYPE "TicketStatus" AS ENUM ('VALID', 'CANCELLED', 'CHECKED_IN', 'NO_SHOW', 'USED', 'REFUNDED');

-- CreateTable
CREATE TABLE "tickets" (
    "id" TEXT NOT NULL,
    "ticket_code" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "booking_id" TEXT NOT NULL,
    "trip_id" TEXT NOT NULL,
    "passenger_info_id" TEXT NOT NULL,
    "seat_code" TEXT NOT NULL,
    "status" "TicketStatus" NOT NULL DEFAULT 'VALID',
    "qr_token_hash" TEXT NOT NULL,
    "issued_at" TIMESTAMP(3) NOT NULL,
    "checked_in_at" TIMESTAMP(3),
    "cancelled_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tickets_pkey" PRIMARY KEY ("id"),
    -- Mã vé = mã booking + số thứ tự chỗ (đọc được qua điện thoại khi soát vé thủ công).
    CONSTRAINT "tickets_code_format" CHECK ("ticket_code" ~ '^VXN[A-Z0-9]{6}-[0-9]{2}$')
);

-- CreateTable
CREATE TABLE "ticket_status_histories" (
    "id" TEXT NOT NULL,
    "ticket_id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "from_status" "TicketStatus",
    "to_status" "TicketStatus" NOT NULL,
    "reason" TEXT,
    "actor" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ticket_status_histories_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "tickets_ticket_code_key" ON "tickets"("ticket_code");
CREATE UNIQUE INDEX "tickets_qr_token_hash_key" ON "tickets"("qr_token_hash");
-- Phát hành idempotent theo chỗ (API §8 "Ticket issuance — booking item id").
CREATE UNIQUE INDEX "tickets_passenger_info_id_key" ON "tickets"("passenger_info_id");
CREATE UNIQUE INDEX "tickets_id_operator_id_key" ON "tickets"("id", "operator_id");
CREATE INDEX "tickets_booking_id_idx" ON "tickets"("booking_id");
CREATE INDEX "tickets_trip_id_status_idx" ON "tickets"("trip_id", "status");
CREATE INDEX "ticket_status_histories_ticket_id_created_at_idx" ON "ticket_status_histories"("ticket_id", "created_at");
CREATE UNIQUE INDEX "passenger_infos_id_operator_id_key" ON "passenger_infos"("id", "operator_id");

-- AddForeignKey
ALTER TABLE "tickets" ADD CONSTRAINT "tickets_booking_id_operator_id_fkey" FOREIGN KEY ("booking_id", "operator_id") REFERENCES "bookings"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "tickets" ADD CONSTRAINT "tickets_passenger_info_id_operator_id_fkey" FOREIGN KEY ("passenger_info_id", "operator_id") REFERENCES "passenger_infos"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "ticket_status_histories" ADD CONSTRAINT "ticket_status_histories_ticket_id_operator_id_fkey" FOREIGN KEY ("ticket_id", "operator_id") REFERENCES "tickets"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- RLS
ALTER TABLE "tickets" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "tickets" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "tickets" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
ALTER TABLE "ticket_status_histories" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "ticket_status_histories" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "ticket_status_histories" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
