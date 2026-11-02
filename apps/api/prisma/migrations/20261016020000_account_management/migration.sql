-- Quản lý nhà xe + người dùng của Admin (FR-ADM-02/03, UC-23 A6, FR-IAM-08; Figma ADM-02e/f, ADM-03a…d).
-- Tạm khóa nhà xe / khóa hành khách / khóa tài khoản quản trị bắt buộc lý do; tài khoản quản trị do Admin cấp có
-- mật khẩu tạm phải đổi ở lần đăng nhập đầu (như tài khoản nhà xe — IAM-005).

-- ── Nhà xe: lý do + thời điểm tạm khóa ──
ALTER TABLE "operator_profiles" ADD COLUMN "suspended_reason" TEXT;
ALTER TABLE "operator_profiles" ADD COLUMN "suspended_at" TIMESTAMP(3);
UPDATE "operator_profiles"
  SET "suspended_reason" = 'Chưa ghi lý do (khóa trước khi có màn quản lý nhà xe)', "suspended_at" = CURRENT_TIMESTAMP
  WHERE "status" = 'SUSPENDED' AND "suspended_reason" IS NULL;
ALTER TABLE "operator_profiles" ADD CONSTRAINT "operator_profiles_suspension_reason"
  CHECK (("status" = 'SUSPENDED') = ("suspended_reason" IS NOT NULL));

-- ── Hành khách: trạng thái tài khoản (Better Auth không có cột này; app tự kiểm khi cấp phiên) ──
ALTER TABLE "users" ADD COLUMN "status" "AccountStatus" NOT NULL DEFAULT 'ACTIVE';
ALTER TABLE "users" ADD COLUMN "locked_reason" TEXT;
ALTER TABLE "users" ADD COLUMN "locked_at" TIMESTAMP(3);
ALTER TABLE "users" ADD CONSTRAINT "users_locked_reason"
  CHECK ("status" <> 'LOCKED' OR "locked_reason" IS NOT NULL);
CREATE INDEX "users_status_created_at_idx" ON "users"("status", "created_at" DESC);

-- ── Tài khoản quản trị: email nhận mật khẩu tạm, vòng đời mật khẩu tạm, lý do khóa ──
ALTER TABLE "platform_accounts" ADD COLUMN "contact_email" TEXT;
ALTER TABLE "platform_accounts" ADD COLUMN "auth_epoch" INTEGER NOT NULL DEFAULT 0;
ALTER TABLE "platform_accounts" ADD COLUMN "credential_delivery_pending" BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE "platform_accounts" ADD COLUMN "password_change_required" BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE "platform_accounts" ADD COLUMN "temporary_password_expires_at" TIMESTAMP(3);
ALTER TABLE "platform_accounts" ADD COLUMN "locked_reason" TEXT;
ALTER TABLE "platform_accounts" ADD COLUMN "locked_at" TIMESTAMP(3);
ALTER TABLE "platform_accounts" ADD COLUMN "created_by" TEXT;
CREATE UNIQUE INDEX "platform_accounts_contact_email_key" ON "platform_accounts"("contact_email");
ALTER TABLE "platform_accounts" ADD CONSTRAINT "platform_accounts_locked_reason"
  CHECK ("status" <> 'LOCKED' OR "locked_reason" IS NOT NULL);
ALTER TABLE "platform_accounts" ADD CONSTRAINT "platform_accounts_temporary_password_expiry"
  CHECK (NOT "password_change_required" OR "temporary_password_expires_at" IS NOT NULL);
-- Tên đăng nhập `platform/{username}`: chữ thường, số, `.`, `_`, `-`, 3–40 ký tự (như form ADM-03d).
ALTER TABLE "platform_accounts" ADD CONSTRAINT "platform_accounts_username_format"
  CHECK ("username" ~ '^[a-z0-9][a-z0-9._-]{2,39}$') NOT VALID;
