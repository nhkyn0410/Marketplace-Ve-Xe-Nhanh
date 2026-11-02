-- TASK-NSR-003 (tự thiết kế, chờ duyệt): chiến dịch thông báo của Platform và hộp thư trong app.
-- Chỉ gửi hộp thư + push, không email hàng loạt: Resend 100 email/ngày dùng chung với OTP.

-- Postgres không cho dùng giá trị enum vừa thêm trong cùng transaction; migration này chưa dùng tới.
ALTER TYPE "NotificationKind" ADD VALUE 'SERVICE_NOTICE';
ALTER TYPE "NotificationKind" ADD VALUE 'NEWS';

CREATE TYPE "NotificationCampaignType" AS ENUM ('SERVICE', 'PROMOTION', 'NEWS');
CREATE TYPE "NotificationCampaignStatus" AS ENUM ('DRAFT', 'SCHEDULED', 'SENDING', 'COMPLETED', 'CANCELLED');
CREATE TYPE "NotificationAudience" AS ENUM ('ALL', 'LOYALTY_TIER');
CREATE TYPE "NotificationLinkType" AS ENUM ('PROMOTION', 'ARTICLE', 'BOOKING');

CREATE TABLE "notification_campaigns" (
  "id" TEXT NOT NULL,
  "type" "NotificationCampaignType" NOT NULL,
  "title" TEXT NOT NULL,
  "body" TEXT NOT NULL,
  "audience" "NotificationAudience" NOT NULL DEFAULT 'ALL',
  "tiers" "LoyaltyTier"[] DEFAULT ARRAY[]::"LoyaltyTier"[],
  "promotion_id" TEXT,
  "article_id" TEXT,
  "status" "NotificationCampaignStatus" NOT NULL DEFAULT 'DRAFT',
  "scheduled_at" TIMESTAMP(3),
  "started_at" TIMESTAMP(3),
  "completed_at" TIMESTAMP(3),
  "cancelled_at" TIMESTAMP(3),
  "note" TEXT,
  "recipient_count" INTEGER NOT NULL DEFAULT 0,
  "capped_count" INTEGER NOT NULL DEFAULT 0,
  "cursor" TEXT,
  "created_by" TEXT NOT NULL,
  "updated_by" TEXT NOT NULL,
  "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "notification_campaigns_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "notification_campaigns_promotion_id_fkey" FOREIGN KEY ("promotion_id") REFERENCES "promotions"("id") ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT "notification_campaigns_article_id_fkey" FOREIGN KEY ("article_id") REFERENCES "articles"("id") ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT "notification_campaigns_counts" CHECK ("recipient_count" >= 0 AND "capped_count" >= 0)
);
CREATE INDEX "notification_campaigns_status_scheduled_at_idx" ON "notification_campaigns"("status", "scheduled_at");
CREATE INDEX "notification_campaigns_created_at_idx" ON "notification_campaigns"("created_at" DESC);

CREATE TABLE "notification_inbox_messages" (
  "id" TEXT NOT NULL,
  "subject_type" "SubjectType" NOT NULL,
  "subject_id" TEXT NOT NULL,
  "notification_id" TEXT NOT NULL,
  "campaign_id" TEXT,
  "kind" "NotificationKind" NOT NULL,
  "title" TEXT NOT NULL,
  "body" TEXT NOT NULL,
  "link_type" "NotificationLinkType",
  "link_target" TEXT,
  "read_at" TIMESTAMP(3),
  "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "notification_inbox_messages_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "notification_inbox_messages_notification_id_fkey" FOREIGN KEY ("notification_id") REFERENCES "notifications"("id") ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT "notification_inbox_messages_campaign_id_fkey" FOREIGN KEY ("campaign_id") REFERENCES "notification_campaigns"("id") ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT "notification_inbox_messages_link" CHECK (("link_type" IS NULL) = ("link_target" IS NULL))
);
CREATE UNIQUE INDEX "notification_inbox_messages_notification_id_key" ON "notification_inbox_messages"("notification_id");
CREATE INDEX "notification_inbox_messages_subject_type_subject_id_created_at_id_idx" ON "notification_inbox_messages"("subject_type", "subject_id", "created_at" DESC, "id" DESC);
CREATE INDEX "notification_inbox_messages_campaign_id_idx" ON "notification_inbox_messages"("campaign_id");

-- Không có operator_id: chỉ system / platform đọc ghi được, tenant luôn bị chặn. Chủ sở hữu tin kiểm ở service theo phiên.
ALTER TABLE "notification_campaigns" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "notification_campaigns" FORCE ROW LEVEL SECURITY;
CREATE POLICY "notification_campaigns_scope" ON "notification_campaigns" USING (app_rls_allows(NULL)) WITH CHECK (app_rls_allows(NULL));
ALTER TABLE "notification_inbox_messages" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "notification_inbox_messages" FORCE ROW LEVEL SECURITY;
CREATE POLICY "notification_inbox_messages_scope" ON "notification_inbox_messages" USING (app_rls_allows(NULL)) WITH CHECK (app_rls_allows(NULL));
