-- TASK-OPR-001: hồ sơ đăng ký nhà xe trước khi có tài khoản (BR-75, LLD §6.11, DB §7). Dữ liệu cấp Platform,
-- chưa có tenant: RLS chỉ cho scope `platform` (Admin duyệt) và `system` (người nộp hồ sơ qua link bảo mật).

CREATE TYPE "OperatorApplicationStatus" AS ENUM ('DRAFT', 'SUBMITTED', 'NEEDS_INFO', 'APPROVED', 'REJECTED');
CREATE TYPE "OperatorApplicationDocumentType" AS ENUM ('BUSINESS_REGISTRATION', 'TRANSPORT_LICENSE', 'REPRESENTATIVE_AUTHORIZATION');

CREATE TABLE "operator_applications" (
    "id" TEXT NOT NULL,
    "application_code" TEXT NOT NULL,
    "status" "OperatorApplicationStatus" NOT NULL DEFAULT 'DRAFT',
    "operator_name" TEXT NOT NULL,
    "contact_name" TEXT NOT NULL,
    "contact_email" TEXT NOT NULL,
    "contact_email_verified_at" TIMESTAMP(3),
    "terms_accepted_at" TIMESTAMP(3) NOT NULL,
    "legal_name" TEXT,
    "tax_code" TEXT,
    "hotline" TEXT,
    "address" TEXT,
    "display_name" TEXT,
    "description" TEXT,
    "bank_name" TEXT,
    "bank_account_number" TEXT,
    "bank_account_holder" TEXT,
    "review_note" TEXT,
    "submitted_at" TIMESTAMP(3),
    "operator_id" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "operator_applications_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "operator_application_documents" (
    "id" TEXT NOT NULL,
    "application_id" TEXT NOT NULL,
    "type" "OperatorApplicationDocumentType" NOT NULL,
    "object_key" TEXT NOT NULL,
    "file_name" TEXT NOT NULL,
    "content_type" TEXT NOT NULL,
    "size_bytes" INTEGER NOT NULL,
    "uploaded_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "operator_application_documents_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "operator_application_access_tokens" (
    "id" TEXT NOT NULL,
    "application_id" TEXT NOT NULL,
    "token_hash" TEXT NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "revoked_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "operator_application_access_tokens_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "operator_applications_application_code_key" ON "operator_applications"("application_code");
CREATE UNIQUE INDEX "operator_applications_operator_id_key" ON "operator_applications"("operator_id");
CREATE INDEX "operator_applications_status_submitted_at_idx" ON "operator_applications"("status", "submitted_at");
CREATE INDEX "operator_applications_contact_email_idx" ON "operator_applications"("contact_email");
CREATE INDEX "operator_applications_tax_code_idx" ON "operator_applications"("tax_code");
CREATE UNIQUE INDEX "operator_application_documents_object_key_key" ON "operator_application_documents"("object_key");
CREATE UNIQUE INDEX "operator_application_documents_application_id_type_key" ON "operator_application_documents"("application_id", "type");
CREATE UNIQUE INDEX "operator_application_access_tokens_token_hash_key" ON "operator_application_access_tokens"("token_hash");
CREATE INDEX "operator_application_access_tokens_application_id_revoked_a_idx" ON "operator_application_access_tokens"("application_id", "revoked_at");

ALTER TABLE "operator_applications" ADD CONSTRAINT "operator_applications_operator_id_fkey"
  FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "operator_application_documents" ADD CONSTRAINT "operator_application_documents_application_id_fkey"
  FOREIGN KEY ("application_id") REFERENCES "operator_applications"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "operator_application_access_tokens" ADD CONSTRAINT "operator_application_access_tokens_application_id_fkey"
  FOREIGN KEY ("application_id") REFERENCES "operator_applications"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- BR-75: mỗi hồ sơ tối đa một Operator, và chỉ hồ sơ đã duyệt mới gắn Operator (DB §7).
ALTER TABLE "operator_applications" ADD CONSTRAINT "operator_applications_operator_when_approved"
  CHECK (("status" = 'APPROVED') = ("operator_id" IS NOT NULL));
-- Đã gửi duyệt thì phải có thời điểm gửi; nháp chưa gửi lần nào thì chưa có.
ALTER TABLE "operator_applications" ADD CONSTRAINT "operator_applications_submitted_at_present"
  CHECK ("status" IN ('DRAFT') OR "submitted_at" IS NOT NULL);
ALTER TABLE "operator_applications" ADD CONSTRAINT "operator_applications_email_lowercase"
  CHECK ("contact_email" = lower("contact_email"));
ALTER TABLE "operator_application_documents" ADD CONSTRAINT "operator_application_documents_size_range"
  CHECK ("size_bytes" BETWEEN 1 AND 10485760);
ALTER TABLE "operator_application_documents" ADD CONSTRAINT "operator_application_documents_content_type_allowed"
  CHECK ("content_type" IN ('application/pdf', 'image/jpeg', 'image/png'));
-- Token sống tối đa 30 ngày dù cấu hình sai (Security §5: mặc định 72 giờ).
ALTER TABLE "operator_application_access_tokens" ADD CONSTRAINT "operator_application_access_tokens_ttl"
  CHECK ("expires_at" > "created_at" AND "expires_at" <= "created_at" + interval '30 days');

-- RLS: không tenant nào đọc / ghi được (`app_rls_allows(NULL)` chỉ đúng với scope platform / system).
ALTER TABLE "operator_applications" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "operator_applications" FORCE ROW LEVEL SECURITY;
CREATE POLICY "platform_only" ON "operator_applications"
  USING (app_rls_allows(NULL)) WITH CHECK (app_rls_allows(NULL));

ALTER TABLE "operator_application_documents" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "operator_application_documents" FORCE ROW LEVEL SECURITY;
CREATE POLICY "platform_only" ON "operator_application_documents"
  USING (app_rls_allows(NULL)) WITH CHECK (app_rls_allows(NULL));

ALTER TABLE "operator_application_access_tokens" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "operator_application_access_tokens" FORCE ROW LEVEL SECURITY;
CREATE POLICY "platform_only" ON "operator_application_access_tokens"
  USING (app_rls_allows(NULL)) WITH CHECK (app_rls_allows(NULL));
