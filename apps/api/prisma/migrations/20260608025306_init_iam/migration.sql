-- CreateEnum
CREATE TYPE "AccountStatus" AS ENUM ('ACTIVE', 'LOCKED', 'DISABLED');

-- CreateEnum
CREATE TYPE "OperatorStatus" AS ENUM ('ACTIVE', 'SUSPENDED');

-- CreateEnum
CREATE TYPE "OperatorRole" AS ENUM ('OPERATOR_OWNER');

-- CreateEnum
CREATE TYPE "EmployeeRole" AS ENUM ('DRIVER', 'TICKET_STAFF', 'SUPPORT_STAFF');

-- CreateEnum
CREATE TYPE "PlatformRole" AS ENUM ('PLATFORM_ADMIN', 'PLATFORM_SUPPORT');

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "name" TEXT,
    "email" TEXT NOT NULL,
    "email_verified" BOOLEAN NOT NULL DEFAULT false,
    "image" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_sessions" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "ip_address" TEXT,
    "user_agent" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_accounts" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "account_id" TEXT NOT NULL,
    "provider_id" TEXT NOT NULL,
    "access_token" TEXT,
    "refresh_token" TEXT,
    "access_token_expires_at" TIMESTAMP(3),
    "refresh_token_expires_at" TIMESTAMP(3),
    "scope" TEXT,
    "id_token" TEXT,
    "password" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "verifications" (
    "id" TEXT NOT NULL,
    "identifier" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "verifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "operator_profiles" (
    "id" TEXT NOT NULL,
    "operator_slug" TEXT NOT NULL,
    "display_name" TEXT NOT NULL,
    "status" "OperatorStatus" NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "operator_profiles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "operator_accounts" (
    "id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "operator_slug" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "role" "OperatorRole" NOT NULL DEFAULT 'OPERATOR_OWNER',
    "status" "AccountStatus" NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "operator_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employee_accounts" (
    "id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "role" "EmployeeRole" NOT NULL,
    "status" "AccountStatus" NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "employee_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "platform_accounts" (
    "id" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "role" "PlatformRole" NOT NULL,
    "status" "AccountStatus" NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "platform_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "user_sessions_token_key" ON "user_sessions"("token");

-- CreateIndex
CREATE INDEX "user_sessions_user_id_idx" ON "user_sessions"("user_id");

-- CreateIndex
CREATE INDEX "user_accounts_user_id_idx" ON "user_accounts"("user_id");

-- CreateIndex
CREATE INDEX "verifications_identifier_idx" ON "verifications"("identifier");

-- CreateIndex
CREATE UNIQUE INDEX "operator_profiles_operator_slug_key" ON "operator_profiles"("operator_slug");

-- CreateIndex
CREATE INDEX "operator_accounts_operator_id_idx" ON "operator_accounts"("operator_id");

-- CreateIndex
CREATE UNIQUE INDEX "operator_accounts_operator_slug_username_key" ON "operator_accounts"("operator_slug", "username");

-- CreateIndex
CREATE UNIQUE INDEX "employee_accounts_operator_id_username_key" ON "employee_accounts"("operator_id", "username");

-- CreateIndex
CREATE UNIQUE INDEX "platform_accounts_username_key" ON "platform_accounts"("username");

-- AddForeignKey
ALTER TABLE "user_sessions" ADD CONSTRAINT "user_sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_accounts" ADD CONSTRAINT "user_accounts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "operator_accounts" ADD CONSTRAINT "operator_accounts_operator_id_fkey" FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee_accounts" ADD CONSTRAINT "employee_accounts_operator_id_fkey" FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;
