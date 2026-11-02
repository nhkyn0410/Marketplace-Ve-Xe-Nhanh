-- TASK-OPR-001b — Hồ sơ & KYC của nhà xe sau khi duyệt (FR-OPR-*, UC-10/UC-23; Figma 1667:27240, 1667:27586).
-- Thông tin công khai, giấy tờ KYC và tài khoản nhận tiền chép từ hồ sơ đăng ký lúc duyệt sang dữ liệu của chính nhà
-- xe (tenant, RLS) — DB §5.2 đã đặt tên `kyc_documents`, `bank_accounts`.

-- ── Thông tin công khai / pháp lý của nhà xe ──
ALTER TABLE "operator_profiles" ADD COLUMN "legal_name" TEXT;
ALTER TABLE "operator_profiles" ADD COLUMN "tax_code" TEXT;
ALTER TABLE "operator_profiles" ADD COLUMN "hotline" TEXT;
ALTER TABLE "operator_profiles" ADD COLUMN "public_email" TEXT;
ALTER TABLE "operator_profiles" ADD COLUMN "address" TEXT;
ALTER TABLE "operator_profiles" ADD COLUMN "description" TEXT;
ALTER TABLE "operator_profiles" ADD COLUMN "approved_at" TIMESTAMP(3);
ALTER TABLE "operator_profiles" ADD CONSTRAINT "operator_profiles_description_length"
  CHECK ("description" IS NULL OR char_length("description") <= 1000);

UPDATE "operator_profiles" o SET
  "legal_name" = a."legal_name",
  "tax_code" = a."tax_code",
  "hotline" = a."hotline",
  "public_email" = a."contact_email",
  "address" = a."address",
  "description" = a."description",
  "approved_at" = a."reviewed_at"
FROM "operator_applications" a
WHERE a."operator_id" = o."id" AND a."status" = 'APPROVED';

-- ── Giấy tờ KYC của nhà xe (kho private, ADR-018) ──
CREATE TABLE "kyc_documents" (
    "id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "type" "OperatorApplicationDocumentType" NOT NULL,
    "object_key" TEXT NOT NULL,
    "file_name" TEXT NOT NULL,
    "content_type" TEXT NOT NULL,
    "size_bytes" INTEGER NOT NULL,
    "uploaded_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "uploaded_by" TEXT,

    CONSTRAINT "kyc_documents_pkey" PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX "kyc_documents_object_key_key" ON "kyc_documents"("object_key");
CREATE UNIQUE INDEX "kyc_documents_operator_id_type_key" ON "kyc_documents"("operator_id", "type");
ALTER TABLE "kyc_documents" ADD CONSTRAINT "kyc_documents_operator_id_fkey"
  FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "kyc_documents" ADD CONSTRAINT "kyc_documents_content_type_allowed"
  CHECK ("content_type" IN ('application/pdf', 'image/jpeg', 'image/png'));
ALTER TABLE "kyc_documents" ADD CONSTRAINT "kyc_documents_size_range" CHECK ("size_bytes" BETWEEN 1 AND 10485760);

INSERT INTO "kyc_documents" ("id", "operator_id", "type", "object_key", "file_name", "content_type", "size_bytes", "uploaded_at")
SELECT d."id", a."operator_id", d."type", d."object_key", d."file_name", d."content_type", d."size_bytes", d."uploaded_at"
FROM "operator_application_documents" d
JOIN "operator_applications" a ON a."id" = d."application_id"
WHERE a."status" = 'APPROVED' AND a."operator_id" IS NOT NULL
ON CONFLICT DO NOTHING;

ALTER TABLE "kyc_documents" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "kyc_documents" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "kyc_documents"
  USING (app_rls_allows("operator_id"))
  WITH CHECK (app_rls_allows("operator_id"));

-- ── Tài khoản nhận tiền: mỗi nhà xe tối đa một tài khoản đã xác minh và một yêu cầu đổi đang chờ ──
CREATE TYPE "BankAccountStatus" AS ENUM ('PENDING', 'VERIFIED', 'REJECTED', 'REPLACED');

CREATE TABLE "bank_accounts" (
    "id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "bank_name" TEXT NOT NULL,
    "account_number" TEXT NOT NULL,
    "account_holder" TEXT NOT NULL,
    "status" "BankAccountStatus" NOT NULL DEFAULT 'PENDING',
    "change_reason" TEXT,
    "review_note" TEXT,
    "requested_by" TEXT,
    "reviewed_by" TEXT,
    "reviewed_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "bank_accounts_pkey" PRIMARY KEY ("id")
);
CREATE INDEX "bank_accounts_operator_id_status_idx" ON "bank_accounts"("operator_id", "status");
CREATE UNIQUE INDEX "bank_accounts_one_verified" ON "bank_accounts"("operator_id") WHERE "status" = 'VERIFIED';
CREATE UNIQUE INDEX "bank_accounts_one_pending" ON "bank_accounts"("operator_id") WHERE "status" = 'PENDING';
ALTER TABLE "bank_accounts" ADD CONSTRAINT "bank_accounts_operator_id_fkey"
  FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "bank_accounts" ADD CONSTRAINT "bank_accounts_account_number_format"
  CHECK ("account_number" ~ '^[0-9]{6,20}$');
ALTER TABLE "bank_accounts" ADD CONSTRAINT "bank_accounts_rejected_note"
  CHECK ("status" <> 'REJECTED' OR "review_note" IS NOT NULL);

INSERT INTO "bank_accounts" ("id", "operator_id", "bank_name", "account_number", "account_holder", "status", "reviewed_at", "reviewed_by", "updated_at")
SELECT gen_random_uuid()::text, a."operator_id", a."bank_name", a."bank_account_number", a."bank_account_holder", 'VERIFIED',
       a."reviewed_at", a."reviewed_by", CURRENT_TIMESTAMP
FROM "operator_applications" a
WHERE a."status" = 'APPROVED' AND a."operator_id" IS NOT NULL
  AND a."bank_name" IS NOT NULL AND a."bank_account_holder" IS NOT NULL
  AND a."bank_account_number" ~ '^[0-9]{6,20}$';

-- RLS: nhà xe đọc tài khoản của mình và chỉ GỬI yêu cầu đổi (`PENDING`); xác minh / từ chối chỉ platform / system.
ALTER TABLE "bank_accounts" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "bank_accounts" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_read" ON "bank_accounts" FOR SELECT USING (app_rls_allows("operator_id"));
CREATE POLICY "tenant_request" ON "bank_accounts" FOR INSERT
  WITH CHECK (
    app_rls_allows("operator_id")
    AND ("status" = 'PENDING' OR current_setting('app.scope', true) IN ('platform', 'system'))
  );
CREATE POLICY "platform_review" ON "bank_accounts" FOR UPDATE
  USING (current_setting('app.scope', true) IN ('platform', 'system'))
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
CREATE POLICY "platform_delete" ON "bank_accounts" FOR DELETE
  USING (current_setting('app.scope', true) IN ('platform', 'system'));
