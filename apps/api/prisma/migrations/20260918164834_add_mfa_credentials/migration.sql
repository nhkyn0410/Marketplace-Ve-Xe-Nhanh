-- TASK-IAM-004 — MFA TOTP + backup code (ADR-017, Security §5.2).
--
-- Secret TOTP chỉ lưu dạng AES-256-GCM (`secret_ciphertext`), backup code chỉ lưu SHA-256.
-- Chủ thể là đa hình (OPERATOR / EMPLOYEE / PLATFORM) nên không có FK tới bảng account.

-- AlterEnum — thu hồi phiên role bắt buộc MFA cấp trước IAM-004 (không có mfa_verified_at).
ALTER TYPE "SessionRevokeReason" ADD VALUE 'MFA_REQUIRED';

-- AlterTable
ALTER TABLE "auth_sessions" ADD COLUMN "mfa_verified_at" TIMESTAMP(3);

-- CreateTable
CREATE TABLE "mfa_credentials" (
    "id" TEXT NOT NULL,
    "subject_type" "SubjectType" NOT NULL,
    "subject_id" TEXT NOT NULL,
    "secret_ciphertext" TEXT NOT NULL,
    "last_totp_counter" BIGINT,
    "enabled_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "mfa_credentials_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "mfa_credentials_subject_not_passenger" CHECK ("subject_type" <> 'PASSENGER')
);

-- CreateTable
CREATE TABLE "mfa_backup_codes" (
    "id" TEXT NOT NULL,
    "credential_id" TEXT NOT NULL,
    "code_hash" TEXT NOT NULL,
    "used_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "mfa_backup_codes_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "mfa_credentials_subject_type_subject_id_key" ON "mfa_credentials"("subject_type", "subject_id");

-- CreateIndex
CREATE UNIQUE INDEX "mfa_backup_codes_credential_id_code_hash_key" ON "mfa_backup_codes"("credential_id", "code_hash");

-- CreateIndex
CREATE INDEX "mfa_backup_codes_credential_id_used_at_idx" ON "mfa_backup_codes"("credential_id", "used_at");

-- AddForeignKey
ALTER TABLE "mfa_backup_codes" ADD CONSTRAINT "mfa_backup_codes_credential_id_fkey" FOREIGN KEY ("credential_id") REFERENCES "mfa_credentials"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ── RLS: CHỈ ngữ cảnh `system` (iam/auth — MfaService) được đọc/ghi ──
-- Không có policy thì mọi query của role app đọc/xoá được credential của bất kỳ ai. Xoá được một row
-- `mfa_credentials` = lần login sau quay về enrollment, chỉ cần mật khẩu → bypass MFA. Không ngữ cảnh
-- → 0 row (fail-closed, cùng quy ước TASK-IAM-003). Cascade từ credential sang backup code chạy bằng
-- owner, nhưng chỉ `system` xoá được credential nên không mở đường nào mới.
ALTER TABLE "mfa_credentials" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "mfa_credentials" FORCE ROW LEVEL SECURITY;
CREATE POLICY "system_only" ON "mfa_credentials"
  USING (current_setting('app.scope', true) = 'system')
  WITH CHECK (current_setting('app.scope', true) = 'system');

ALTER TABLE "mfa_backup_codes" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "mfa_backup_codes" FORCE ROW LEVEL SECURITY;
CREATE POLICY "system_only" ON "mfa_backup_codes"
  USING (current_setting('app.scope', true) = 'system')
  WITH CHECK (current_setting('app.scope', true) = 'system');
