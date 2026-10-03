-- CreateEnum
CREATE TYPE "SubjectType" AS ENUM ('PASSENGER', 'OPERATOR', 'EMPLOYEE', 'PLATFORM');

-- CreateEnum
CREATE TYPE "SessionRevokeReason" AS ENUM ('LOGOUT', 'REUSE_DETECTED', 'ACCOUNT_LOCKED', 'PASSWORD_RESET', 'ADMIN_FORCE');

-- CreateTable
CREATE TABLE "auth_sessions" (
    "id" TEXT NOT NULL,
    "subject_type" "SubjectType" NOT NULL,
    "subject_id" TEXT NOT NULL,
    "user_ref" TEXT NOT NULL,
    "family_id" TEXT NOT NULL,
    "refresh_token_hash" TEXT NOT NULL,
    "issued_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "last_used_at" TIMESTAMP(3),
    "rotated_at" TIMESTAMP(3),
    "replaced_by_id" TEXT,
    "revoked_at" TIMESTAMP(3),
    "revoked_reason" "SessionRevokeReason",
    "operator_id" TEXT,
    "ip" TEXT,
    "user_agent" TEXT,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "auth_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "auth_sessions_refresh_token_hash_key" ON "auth_sessions"("refresh_token_hash");

-- CreateIndex
CREATE UNIQUE INDEX "auth_sessions_replaced_by_id_key" ON "auth_sessions"("replaced_by_id");

-- CreateIndex
CREATE INDEX "auth_sessions_user_ref_family_id_idx" ON "auth_sessions"("user_ref", "family_id");

-- CreateIndex
CREATE INDEX "auth_sessions_family_id_idx" ON "auth_sessions"("family_id");

-- CreateIndex
CREATE INDEX "auth_sessions_expires_at_idx" ON "auth_sessions"("expires_at");

-- CreateIndex
CREATE INDEX "auth_sessions_operator_id_idx" ON "auth_sessions"("operator_id");

ALTER TABLE "auth_sessions"
  ADD CONSTRAINT "auth_sessions_user_ref_derived"
  CHECK ("user_ref" = lower("subject_type"::text) || ':' || "subject_id");