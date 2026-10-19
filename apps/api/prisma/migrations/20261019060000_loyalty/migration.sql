-- TASK-LOY-001 phần Admin (VXN Plus — FR-LOY-01..03/10..12, BR-65..71, DB §5.2 / §7). Cấp nền tảng, không operator_id; chỉ scope
-- platform / system đọc ghi. Tham số chương trình = policy_versions loại LOYALTY (seed ở migration kế tiếp — giá trị enum mới chưa
-- dùng được trong cùng transaction). Cột AI tự đề xuất, chờ Khanh duyệt (`doc/task-propreties/LOY-001-admin-todo.md`).

-- CreateEnum
CREATE TYPE "LoyaltyPointType" AS ENUM ('EARN', 'REDEEM', 'EXPIRE', 'ADJUST', 'REVERSAL');

-- CreateEnum
CREATE TYPE "LoyaltyTier" AS ENUM ('BRONZE', 'SILVER', 'GOLD', 'PLATINUM');

-- AlterEnum
ALTER TYPE "PolicyType" ADD VALUE IF NOT EXISTS 'LOYALTY';

-- CreateTable
CREATE TABLE "loyalty_accounts" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "available_points" INTEGER NOT NULL DEFAULT 0,
    "version" INTEGER NOT NULL DEFAULT 0,
    "expired_through" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "loyalty_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "loyalty_point_transactions" (
    "id" TEXT NOT NULL,
    "account_id" TEXT NOT NULL,
    "type" "LoyaltyPointType" NOT NULL,
    "points" INTEGER NOT NULL,
    "tier" "LoyaltyTier" NOT NULL,
    "basis_amount" BIGINT,
    "booking_id" TEXT,
    "source_label" TEXT NOT NULL,
    "policy_version_id" TEXT,
    "policy_version" INTEGER,
    "idempotency_key" TEXT NOT NULL,
    "reason" TEXT,
    "actor" TEXT NOT NULL,
    "expires_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "loyalty_point_transactions_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "loyalty_accounts_user_id_key" ON "loyalty_accounts"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "loyalty_point_transactions_idempotency_key_key" ON "loyalty_point_transactions"("idempotency_key");

-- CreateIndex
CREATE INDEX "loyalty_point_transactions_account_id_created_at_idx" ON "loyalty_point_transactions"("account_id", "created_at");

-- CreateIndex
CREATE INDEX "loyalty_point_transactions_type_created_at_idx" ON "loyalty_point_transactions"("type", "created_at");

-- AddForeignKey
ALTER TABLE "loyalty_accounts" ADD CONSTRAINT "loyalty_accounts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "loyalty_point_transactions" ADD CONSTRAINT "loyalty_point_transactions_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "loyalty_accounts"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Ràng buộc (DB §7)
ALTER TABLE "loyalty_accounts" ADD CONSTRAINT "loyalty_accounts_points" CHECK ("available_points" >= 0);
ALTER TABLE "loyalty_point_transactions"
    ADD CONSTRAINT "loyalty_point_transactions_sign" CHECK (
        ("type" = 'EARN' AND "points" > 0)
        OR ("type" IN ('REDEEM', 'EXPIRE') AND "points" < 0)
        OR ("type" = 'REVERSAL' AND "points" <= 0)
        OR ("type" = 'ADJUST' AND "points" <> 0)
    ),
    ADD CONSTRAINT "loyalty_point_transactions_adjust_reason" CHECK ("type" <> 'ADJUST' OR char_length(btrim("reason")) BETWEEN 3 AND 500),
    ADD CONSTRAINT "loyalty_point_transactions_source" CHECK (char_length("source_label") BETWEEN 1 AND 200),
    ADD CONSTRAINT "loyalty_point_transactions_basis" CHECK ("basis_amount" IS NULL OR "basis_amount" >= 0);

-- Sổ điểm CHỈ GHI THÊM (BR-69) — như sổ giữ hộ: chặn UPDATE / DELETE, riêng dọn dữ liệu test bật cờ `app.allow_ledger_delete`.
CREATE FUNCTION loyalty_point_transactions_append_only() RETURNS trigger LANGUAGE plpgsql AS $fn$
BEGIN
  IF TG_OP = 'DELETE' AND current_setting('app.allow_ledger_delete', true) = 'on' THEN
    RETURN OLD;
  END IF;
  RAISE EXCEPTION 'loyalty_point_transactions is append-only' USING ERRCODE = 'insufficient_privilege';
END;
$fn$;
CREATE TRIGGER "loyalty_point_transactions_append_only" BEFORE UPDATE OR DELETE ON "loyalty_point_transactions"
  FOR EACH ROW EXECUTE FUNCTION loyalty_point_transactions_append_only();

-- RLS: chỉ platform / system (nhà xe không đọc loyalty — DB §7).
ALTER TABLE "loyalty_accounts" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "loyalty_accounts" FORCE ROW LEVEL SECURITY;
CREATE POLICY "platform_only" ON "loyalty_accounts"
  USING (current_setting('app.scope', true) IN ('platform', 'system'))
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
ALTER TABLE "loyalty_point_transactions" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "loyalty_point_transactions" FORCE ROW LEVEL SECURITY;
CREATE POLICY "platform_only" ON "loyalty_point_transactions"
  USING (current_setting('app.scope', true) IN ('platform', 'system'))
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
