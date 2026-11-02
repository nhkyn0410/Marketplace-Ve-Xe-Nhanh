-- TASK-ADM-001 phần chính sách + khung giá (FR-ADM-06..09, UC-25, AS-23, BR-02/07/31/32, OQ-13/16/17/18; Figma ADM-06a…06d).
-- DB §5.2 đã đặt tên `policy_versions`, `commission_rules`; `fare_bands` mới (khung giá trần / sàn chỉ cảnh báo — OQ-17).
-- Mọi thay đổi tạo dòng mới có ngày hiệu lực, không sửa ngược phiên bản đã kích hoạt (AS-23).

CREATE TYPE "PolicyType" AS ENUM ('CANCELLATION', 'SEAT_HOLD', 'PAYOUT');
CREATE TYPE "PolicyVersionStatus" AS ENUM ('DRAFT', 'PUBLISHED', 'CANCELLED');
CREATE TYPE "PolicyRuleStatus" AS ENUM ('ACTIVE', 'CANCELLED');

-- ── Phiên bản chính sách: hủy / hoàn tiền (mặc định nền tảng + riêng nhà xe — OQ-13), giữ chỗ, chi trả ──
CREATE TABLE "policy_versions" (
    "id" TEXT NOT NULL,
    "type" "PolicyType" NOT NULL,
    "operator_id" TEXT,
    "version" INTEGER NOT NULL,
    "status" "PolicyVersionStatus" NOT NULL DEFAULT 'DRAFT',
    "rules" JSONB NOT NULL,
    "description" TEXT,
    "change_reason" TEXT,
    "effective_from" TIMESTAMP(3),
    "created_by" TEXT,
    "published_by" TEXT,
    "published_at" TIMESTAMP(3),
    "cancelled_by" TEXT,
    "cancelled_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "policy_versions_pkey" PRIMARY KEY ("id")
);
ALTER TABLE "policy_versions" ADD CONSTRAINT "policy_versions_operator_id_fkey"
  FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
-- Số phiên bản tăng dần theo (loại, phạm vi); phạm vi nền tảng = `operator_id` NULL.
CREATE UNIQUE INDEX "policy_versions_scope_version_key"
  ON "policy_versions"("type", COALESCE("operator_id", ''), "version");
-- Hai phiên bản đã kích hoạt cùng phạm vi không được trùng thời điểm hiệu lực.
CREATE UNIQUE INDEX "policy_versions_scope_effective_key"
  ON "policy_versions"("type", COALESCE("operator_id", ''), "effective_from") WHERE "status" = 'PUBLISHED';
CREATE INDEX "policy_versions_type_operator_id_status_idx" ON "policy_versions"("type", "operator_id", "status");
ALTER TABLE "policy_versions" ADD CONSTRAINT "policy_versions_published_fields"
  CHECK ("status" <> 'PUBLISHED' OR ("effective_from" IS NOT NULL AND "change_reason" IS NOT NULL AND "published_at" IS NOT NULL));
ALTER TABLE "policy_versions" ADD CONSTRAINT "policy_versions_cancelled_fields"
  CHECK ("status" <> 'CANCELLED' OR "cancelled_at" IS NOT NULL);
-- Giữ chỗ / chi trả chỉ ở cấp nền tảng (BR-02: v1 không cấu hình giữ chỗ riêng nhà xe).
ALTER TABLE "policy_versions" ADD CONSTRAINT "policy_versions_platform_only"
  CHECK ("type" = 'CANCELLATION' OR "operator_id" IS NULL);
ALTER TABLE "policy_versions" ADD CONSTRAINT "policy_versions_text_length"
  CHECK (char_length(coalesce("description", '')) <= 1000 AND char_length(coalesce("change_reason", '')) <= 500);

-- ── Hoa hồng: mức mặc định (`operator_id` NULL) + mức riêng theo nhà xe có ngày hiệu lực (BR-31, OQ-18) ──
CREATE TABLE "commission_rules" (
    "id" TEXT NOT NULL,
    "operator_id" TEXT,
    "rate_bps" INTEGER NOT NULL,
    "effective_from" TIMESTAMP(3) NOT NULL,
    "effective_to" TIMESTAMP(3),
    "status" "PolicyRuleStatus" NOT NULL DEFAULT 'ACTIVE',
    "reason" TEXT NOT NULL,
    "created_by" TEXT,
    "cancelled_by" TEXT,
    "cancelled_at" TIMESTAMP(3),
    "cancel_reason" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "commission_rules_pkey" PRIMARY KEY ("id")
);
ALTER TABLE "commission_rules" ADD CONSTRAINT "commission_rules_operator_id_fkey"
  FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
CREATE INDEX "commission_rules_operator_id_status_idx" ON "commission_rules"("operator_id", "status");
-- Tỷ lệ theo phần vạn (500 = 5%): số nguyên, không float (DB-PRIN-06).
ALTER TABLE "commission_rules" ADD CONSTRAINT "commission_rules_rate_range" CHECK ("rate_bps" BETWEEN 0 AND 10000);
ALTER TABLE "commission_rules" ADD CONSTRAINT "commission_rules_period"
  CHECK ("effective_to" IS NULL OR "effective_to" > "effective_from");
ALTER TABLE "commission_rules" ADD CONSTRAINT "commission_rules_cancelled_fields"
  CHECK ("status" <> 'CANCELLED' OR ("cancelled_at" IS NOT NULL AND "cancel_reason" IS NOT NULL));

-- ── Khung giá trần / sàn theo dịp (FR-ADM-09, OQ-17): chỉ cảnh báo nhà xe, không chặn lưu / mở bán ──
CREATE TABLE "fare_bands" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "min_price" BIGINT,
    "max_price" BIGINT,
    "effective_from" TIMESTAMP(3) NOT NULL,
    "effective_to" TIMESTAMP(3) NOT NULL,
    "message" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "status" "PolicyRuleStatus" NOT NULL DEFAULT 'ACTIVE',
    "created_by" TEXT,
    "cancelled_by" TEXT,
    "cancelled_at" TIMESTAMP(3),
    "cancel_reason" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "fare_bands_pkey" PRIMARY KEY ("id")
);
CREATE INDEX "fare_bands_status_effective_to_idx" ON "fare_bands"("status", "effective_to");
ALTER TABLE "fare_bands" ADD CONSTRAINT "fare_bands_price_range" CHECK (
  ("min_price" IS NOT NULL OR "max_price" IS NOT NULL)
  AND ("min_price" IS NULL OR "min_price" BETWEEN 0 AND 100000000)
  AND ("max_price" IS NULL OR "max_price" BETWEEN 0 AND 100000000)
  AND ("min_price" IS NULL OR "max_price" IS NULL OR "min_price" <= "max_price")
);
ALTER TABLE "fare_bands" ADD CONSTRAINT "fare_bands_period" CHECK ("effective_to" > "effective_from");
ALTER TABLE "fare_bands" ADD CONSTRAINT "fare_bands_cancelled_fields"
  CHECK ("status" <> 'CANCELLED' OR ("cancelled_at" IS NOT NULL AND "cancel_reason" IS NOT NULL));

-- ── RLS: chính sách là thông tin công khai với nhà xe / hành khách → ai cũng đọc; chỉ platform / system ghi ──
ALTER TABLE "policy_versions" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "policy_versions" FORCE ROW LEVEL SECURITY;
CREATE POLICY "public_read" ON "policy_versions" FOR SELECT USING (true);
CREATE POLICY "platform_insert" ON "policy_versions" FOR INSERT
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
CREATE POLICY "platform_update" ON "policy_versions" FOR UPDATE
  USING (current_setting('app.scope', true) IN ('platform', 'system'))
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
CREATE POLICY "platform_delete" ON "policy_versions" FOR DELETE
  USING (current_setting('app.scope', true) IN ('platform', 'system'));

ALTER TABLE "commission_rules" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "commission_rules" FORCE ROW LEVEL SECURITY;
-- Nhà xe chỉ thấy mức mặc định + mức riêng của mình.
CREATE POLICY "tenant_read" ON "commission_rules" FOR SELECT
  USING ("operator_id" IS NULL OR app_rls_allows("operator_id"));
CREATE POLICY "platform_insert" ON "commission_rules" FOR INSERT
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
CREATE POLICY "platform_update" ON "commission_rules" FOR UPDATE
  USING (current_setting('app.scope', true) IN ('platform', 'system'))
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
CREATE POLICY "platform_delete" ON "commission_rules" FOR DELETE
  USING (current_setting('app.scope', true) IN ('platform', 'system'));

ALTER TABLE "fare_bands" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "fare_bands" FORCE ROW LEVEL SECURITY;
CREATE POLICY "public_read" ON "fare_bands" FOR SELECT USING (true);
CREATE POLICY "platform_insert" ON "fare_bands" FOR INSERT
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
CREATE POLICY "platform_update" ON "fare_bands" FOR UPDATE
  USING (current_setting('app.scope', true) IN ('platform', 'system'))
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
CREATE POLICY "platform_delete" ON "fare_bands" FOR DELETE
  USING (current_setting('app.scope', true) IN ('platform', 'system'));

-- ── Giá trị nền đã chốt (UC-25 tiền điều kiện): giữ chỗ 10 phút (OQ-06, BR-02); chi trả T+3 thủ công qua chuyển khoản,
-- không ngưỡng tối thiểu (OQ-16, BR-32); hoa hồng mặc định 5% (OQ-18, BR-31). Hủy / hoàn tiền CHƯA có mức chốt → Admin
-- tạo phiên bản đầu. Hiệu lực từ 11/05/2026 giờ VN (ngày chốt các OQ trên).
INSERT INTO "policy_versions" ("id", "type", "version", "status", "rules", "description", "change_reason", "effective_from", "published_at", "updated_at")
VALUES
  (gen_random_uuid()::text, 'SEAT_HOLD', 1, 'PUBLISHED', '{"holdMinutes": 10}',
   'Giá trị nền v1 (OQ-06, BR-02).', 'Khởi tạo', '2026-05-10T17:00:00Z', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  (gen_random_uuid()::text, 'PAYOUT', 1, 'PUBLISHED',
   '{"delayDays": 3, "channel": "BANK_TRANSFER", "manualConfirmation": true, "minimumAmount": null}',
   'Giá trị nền v1 (OQ-16, BR-32, ADR-022).', 'Khởi tạo', '2026-05-10T17:00:00Z', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO "commission_rules" ("id", "rate_bps", "effective_from", "reason", "updated_at")
VALUES (gen_random_uuid()::text, 500, '2026-05-10T17:00:00Z', 'Mức mặc định nền tảng (OQ-18, BR-31).', CURRENT_TIMESTAMP);
