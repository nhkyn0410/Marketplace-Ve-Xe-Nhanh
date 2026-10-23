-- TASK-TRUST-001 (khiếu nại / hỗ trợ, tranh chấp, đánh giá — FR-NSR-06..11, FR-DSP-*, BR-18/49/50/51/55, UC-09/27/28). Thiết
-- kế cột AI tự đề xuất theo Figma ADM-09a–e, ADM-10a, "Nhà xe · Hỗ trợ", chờ Khanh duyệt (`doc/task-propreties/TRUST-001-todo.md`).
-- Mọi bảng thuộc nhà xe của đơn liên quan + RLS `tenant_isolation`.

-- AlterEnum — thông báo cập nhật khiếu nại / tranh chấp (FR-DSP-07).
ALTER TYPE "NotificationKind" ADD VALUE 'CASE_UPDATED';

-- CreateEnum
CREATE TYPE "SupportCategory" AS ENUM ('PAYMENT_REFUND', 'SCHEDULE', 'SERVICE_QUALITY', 'TICKET_CHANGE', 'OTHER');

-- CreateEnum
CREATE TYPE "SupportPriority" AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'URGENT');

-- CreateEnum
CREATE TYPE "SupportHandler" AS ENUM ('PLATFORM', 'OPERATOR');

-- CreateEnum
CREATE TYPE "SupportStatus" AS ENUM ('NEW', 'IN_PROGRESS', 'WAITING_OPERATOR', 'WAITING_CUSTOMER', 'ESCALATED', 'RESOLVED', 'CLOSED');

-- CreateEnum
CREATE TYPE "CaseParty" AS ENUM ('PASSENGER', 'GUEST', 'OPERATOR', 'PLATFORM', 'SYSTEM');

-- CreateEnum
CREATE TYPE "DisputeStatus" AS ENUM ('OPEN', 'WAITING_USER_EVIDENCE', 'WAITING_OPERATOR_RESPONSE', 'UNDER_REVIEW', 'ESCALATED', 'RESOLVED_REFUND', 'RESOLVED_NO_REFUND', 'CLOSED');

-- CreateEnum
CREATE TYPE "DisputeDecision" AS ENUM ('REFUND', 'NO_REFUND', 'OTHER');

-- CreateEnum
CREATE TYPE "DisputeEventKind" AS ENUM ('STATUS', 'EVIDENCE', 'REQUEST');

-- CreateEnum
CREATE TYPE "ReviewStatus" AS ENUM ('VISIBLE', 'HELD', 'HIDDEN');

-- CreateTable
CREATE TABLE "support_tickets" (
    "id" TEXT NOT NULL,
    "ticket_code" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "booking_id" TEXT NOT NULL,
    "user_id" TEXT,
    "reporter_party" "CaseParty" NOT NULL,
    "reporter_name" TEXT NOT NULL,
    "subject" TEXT NOT NULL,
    "category" "SupportCategory" NOT NULL,
    "requested_priority" "SupportPriority" NOT NULL,
    "priority" "SupportPriority" NOT NULL,
    "handler" "SupportHandler" NOT NULL DEFAULT 'PLATFORM',
    "assignee_id" TEXT,
    "status" "SupportStatus" NOT NULL DEFAULT 'NEW',
    "shared_with_operator_at" TIMESTAMP(3),
    "classified_at" TIMESTAMP(3),
    "resolved_at" TIMESTAMP(3),
    "last_message_at" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "support_tickets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "support_messages" (
    "id" TEXT NOT NULL,
    "ticket_id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "party" "CaseParty" NOT NULL,
    "author_id" TEXT,
    "author_name" TEXT NOT NULL,
    "body" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "support_messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "dispute_cases" (
    "id" TEXT NOT NULL,
    "dispute_code" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "booking_id" TEXT NOT NULL,
    "support_ticket_id" TEXT,
    "title" TEXT NOT NULL,
    "customer_request" TEXT,
    "status" "DisputeStatus" NOT NULL DEFAULT 'OPEN',
    "response_due_at" TIMESTAMP(3),
    "assignee_id" TEXT,
    "decision" "DisputeDecision",
    "decision_amount" BIGINT,
    "decision_reason" TEXT,
    "decided_by" TEXT,
    "decided_at" TIMESTAMP(3),
    "refund_id" TEXT,
    "created_by" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "dispute_cases_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "dispute_events" (
    "id" TEXT NOT NULL,
    "dispute_id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "kind" "DisputeEventKind" NOT NULL,
    "party" "CaseParty" NOT NULL,
    "actor" TEXT NOT NULL,
    "actor_name" TEXT NOT NULL,
    "from_status" "DisputeStatus",
    "to_status" "DisputeStatus",
    "body" TEXT,
    "target" "CaseParty",
    "due_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "dispute_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "support_attachments" (
    "id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "message_id" TEXT,
    "dispute_event_id" TEXT,
    "object_key" TEXT NOT NULL,
    "file_name" TEXT NOT NULL,
    "content_type" TEXT NOT NULL,
    "size_bytes" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "support_attachments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reviews" (
    "id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "booking_id" TEXT NOT NULL,
    "trip_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "author_name" TEXT NOT NULL,
    "rating" INTEGER NOT NULL,
    "comment" TEXT,
    "status" "ReviewStatus" NOT NULL DEFAULT 'VISIBLE',
    "operator_reply" TEXT,
    "operator_replied_at" TIMESTAMP(3),
    "operator_reported_at" TIMESTAMP(3),
    "operator_report_reason" TEXT,
    "moderation_reason" TEXT,
    "moderated_by" TEXT,
    "moderated_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "reviews_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "support_tickets_ticket_code_key" ON "support_tickets"("ticket_code");

-- CreateIndex
CREATE INDEX "support_tickets_status_last_message_at_idx" ON "support_tickets"("status", "last_message_at");

-- CreateIndex
CREATE INDEX "support_tickets_operator_id_shared_with_operator_at_idx" ON "support_tickets"("operator_id", "shared_with_operator_at");

-- CreateIndex
CREATE INDEX "support_tickets_booking_id_idx" ON "support_tickets"("booking_id");

-- CreateIndex
CREATE UNIQUE INDEX "support_tickets_id_operator_id_key" ON "support_tickets"("id", "operator_id");

-- CreateIndex
CREATE INDEX "support_messages_ticket_id_created_at_idx" ON "support_messages"("ticket_id", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "support_messages_id_operator_id_key" ON "support_messages"("id", "operator_id");

-- CreateIndex
CREATE UNIQUE INDEX "dispute_cases_dispute_code_key" ON "dispute_cases"("dispute_code");

-- CreateIndex
CREATE UNIQUE INDEX "dispute_cases_support_ticket_id_key" ON "dispute_cases"("support_ticket_id");

-- CreateIndex
CREATE INDEX "dispute_cases_status_response_due_at_idx" ON "dispute_cases"("status", "response_due_at");

-- CreateIndex
CREATE INDEX "dispute_cases_operator_id_status_idx" ON "dispute_cases"("operator_id", "status");

-- CreateIndex
CREATE UNIQUE INDEX "dispute_cases_id_operator_id_key" ON "dispute_cases"("id", "operator_id");

-- CreateIndex
CREATE INDEX "dispute_events_dispute_id_created_at_idx" ON "dispute_events"("dispute_id", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "dispute_events_id_operator_id_key" ON "dispute_events"("id", "operator_id");

-- CreateIndex
CREATE UNIQUE INDEX "support_attachments_object_key_key" ON "support_attachments"("object_key");

-- CreateIndex
CREATE INDEX "support_attachments_message_id_idx" ON "support_attachments"("message_id");

-- CreateIndex
CREATE INDEX "support_attachments_dispute_event_id_idx" ON "support_attachments"("dispute_event_id");

-- CreateIndex
CREATE UNIQUE INDEX "reviews_booking_id_key" ON "reviews"("booking_id");

-- CreateIndex
CREATE INDEX "reviews_operator_id_status_created_at_idx" ON "reviews"("operator_id", "status", "created_at");

-- CreateIndex
CREATE INDEX "reviews_status_created_at_idx" ON "reviews"("status", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "reviews_id_operator_id_key" ON "reviews"("id", "operator_id");

-- AddForeignKey
ALTER TABLE "support_tickets" ADD CONSTRAINT "support_tickets_operator_id_fkey" FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "support_tickets" ADD CONSTRAINT "support_tickets_booking_id_operator_id_fkey" FOREIGN KEY ("booking_id", "operator_id") REFERENCES "bookings"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "support_messages" ADD CONSTRAINT "support_messages_ticket_id_operator_id_fkey" FOREIGN KEY ("ticket_id", "operator_id") REFERENCES "support_tickets"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "dispute_cases" ADD CONSTRAINT "dispute_cases_operator_id_fkey" FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "dispute_cases" ADD CONSTRAINT "dispute_cases_booking_id_operator_id_fkey" FOREIGN KEY ("booking_id", "operator_id") REFERENCES "bookings"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "dispute_cases" ADD CONSTRAINT "dispute_cases_support_ticket_id_operator_id_fkey" FOREIGN KEY ("support_ticket_id", "operator_id") REFERENCES "support_tickets"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "dispute_cases" ADD CONSTRAINT "dispute_cases_refund_id_operator_id_fkey" FOREIGN KEY ("refund_id", "operator_id") REFERENCES "refunds"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "dispute_events" ADD CONSTRAINT "dispute_events_dispute_id_operator_id_fkey" FOREIGN KEY ("dispute_id", "operator_id") REFERENCES "dispute_cases"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "support_attachments" ADD CONSTRAINT "support_attachments_message_id_operator_id_fkey" FOREIGN KEY ("message_id", "operator_id") REFERENCES "support_messages"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "support_attachments" ADD CONSTRAINT "support_attachments_dispute_event_id_operator_id_fkey" FOREIGN KEY ("dispute_event_id", "operator_id") REFERENCES "dispute_events"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_operator_id_fkey" FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_booking_id_operator_id_fkey" FOREIGN KEY ("booking_id", "operator_id") REFERENCES "bookings"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_trip_id_operator_id_fkey" FOREIGN KEY ("trip_id", "operator_id") REFERENCES "trips"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Ràng buộc
ALTER TABLE "support_tickets"
    ADD CONSTRAINT "support_tickets_code_format" CHECK ("ticket_code" ~ '^KN-[0-9]{8}-[0-9]{3,}$'),
    ADD CONSTRAINT "support_tickets_subject" CHECK (char_length(btrim("subject")) BETWEEN 3 AND 200),
    ADD CONSTRAINT "support_tickets_reporter_name" CHECK (char_length("reporter_name") BETWEEN 1 AND 120),
    -- Người gửi chỉ là hành khách (có tài khoản) hoặc khách vãng lai (không tài khoản).
    ADD CONSTRAINT "support_tickets_reporter" CHECK (("reporter_party" = 'PASSENGER' AND "user_id" IS NOT NULL) OR ("reporter_party" = 'GUEST' AND "user_id" IS NULL));
ALTER TABLE "support_messages"
    ADD CONSTRAINT "support_messages_body" CHECK (char_length(btrim("body")) BETWEEN 1 AND 2000),
    ADD CONSTRAINT "support_messages_author_name" CHECK (char_length("author_name") BETWEEN 1 AND 120);
ALTER TABLE "dispute_cases"
    ADD CONSTRAINT "dispute_cases_code_format" CHECK ("dispute_code" ~ '^DC-[0-9]{6,}$'),
    ADD CONSTRAINT "dispute_cases_title" CHECK (char_length(btrim("title")) BETWEEN 3 AND 200),
    ADD CONSTRAINT "dispute_cases_customer_request" CHECK ("customer_request" IS NULL OR char_length("customer_request") <= 200),
    -- Quyết định đi cùng lý do, người quyết, thời điểm; hoàn tiền phải có số tiền > 0, không hoàn thì không có số tiền / refund.
    ADD CONSTRAINT "dispute_cases_decision_fields" CHECK (
        ("decision" IS NULL AND "decided_at" IS NULL AND "decided_by" IS NULL AND "decision_reason" IS NULL AND "decision_amount" IS NULL AND "refund_id" IS NULL)
        OR ("decision" IS NOT NULL AND "decided_at" IS NOT NULL AND "decided_by" IS NOT NULL AND char_length("decision_reason") BETWEEN 3 AND 500)
    ),
    ADD CONSTRAINT "dispute_cases_decision_amount" CHECK (("decision" = 'REFUND') = ("decision_amount" IS NOT NULL) AND ("decision_amount" IS NULL OR "decision_amount" > 0)),
    ADD CONSTRAINT "dispute_cases_resolved_has_decision" CHECK ("status" NOT IN ('RESOLVED_REFUND', 'RESOLVED_NO_REFUND') OR "decision" IS NOT NULL);
ALTER TABLE "dispute_events"
    ADD CONSTRAINT "dispute_events_body" CHECK ("body" IS NULL OR char_length("body") <= 2000),
    ADD CONSTRAINT "dispute_events_request_target" CHECK ("kind" <> 'REQUEST' OR ("target" IS NOT NULL AND "due_at" IS NOT NULL));
ALTER TABLE "support_attachments"
    -- Mỗi tệp thuộc đúng một lượt trao đổi khiếu nại hoặc một sự kiện tranh chấp.
    ADD CONSTRAINT "support_attachments_owner" CHECK (("message_id" IS NULL) <> ("dispute_event_id" IS NULL)),
    ADD CONSTRAINT "support_attachments_size" CHECK ("size_bytes" BETWEEN 1 AND 10485760),
    ADD CONSTRAINT "support_attachments_content_type" CHECK ("content_type" IN ('application/pdf', 'image/jpeg', 'image/png')),
    ADD CONSTRAINT "support_attachments_file_name" CHECK (char_length("file_name") BETWEEN 1 AND 200);
ALTER TABLE "reviews"
    ADD CONSTRAINT "reviews_rating" CHECK ("rating" BETWEEN 1 AND 5),
    ADD CONSTRAINT "reviews_comment" CHECK ("comment" IS NULL OR char_length("comment") <= 1000),
    ADD CONSTRAINT "reviews_operator_reply" CHECK ("operator_reply" IS NULL OR char_length(btrim("operator_reply")) BETWEEN 1 AND 1000),
    ADD CONSTRAINT "reviews_report_reason" CHECK (("operator_reported_at" IS NULL) = ("operator_report_reason" IS NULL)),
    -- Ẩn bắt buộc lý do (Figma ADM-10a: "Ẩn đánh giá cần lý do và được ghi nhật ký audit").
    ADD CONSTRAINT "reviews_hidden_reason" CHECK ("status" <> 'HIDDEN' OR "moderation_reason" IS NOT NULL);

-- Số thứ tự trong mã khiếu nại `KN-YYYYMMDD-NNN` / tranh chấp `DC-NNNNNN` — dùng chung mọi nhà xe (RLS không cho đếm của nhà xe khác).
CREATE SEQUENCE "support_ticket_code_seq";
CREATE SEQUENCE "dispute_code_seq";

-- RLS
ALTER TABLE "support_tickets" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "support_tickets" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "support_tickets" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
ALTER TABLE "support_messages" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "support_messages" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "support_messages" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
ALTER TABLE "dispute_cases" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "dispute_cases" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "dispute_cases" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
ALTER TABLE "dispute_events" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "dispute_events" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "dispute_events" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
ALTER TABLE "support_attachments" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "support_attachments" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "support_attachments" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
ALTER TABLE "reviews" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "reviews" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "reviews" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
