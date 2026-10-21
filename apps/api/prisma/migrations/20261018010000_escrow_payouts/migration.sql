-- TASK-BTP-006 — sổ escrow chỉ ghi thêm + hoa hồng + kỳ chi trả T+3 thủ công (FR-BTP-15..17, BR-30/31/33, ADR-005/022,
-- LLD §6.6, SRS §17.10; DB §4 `escrow_ledgers`, `payouts`, `payout_items`; DB §7 index `(operator_id, created_at)`,
-- `(booking_id, payment_id)`). DB-OQ-03 (mô hình ghi sổ) còn mở: v1 dùng một dòng có dấu (+ vào sổ nhà xe, − ra) theo loại
-- bút toán. Thiết kế cột AI tự đề xuất, chờ Khanh duyệt (`doc/task-propreties/BTP-006-todo.md`). Tiền = BIGINT VND.

-- CreateEnum
CREATE TYPE "EscrowEntryType" AS ENUM ('PAYMENT_CAPTURED', 'COMMISSION', 'REFUND', 'COMMISSION_REVERSAL', 'PAYOUT', 'ADJUSTMENT');
-- SRS §17.10
CREATE TYPE "PayoutStatus" AS ENUM ('PENDING_REVIEW', 'ON_HOLD', 'READY_TO_TRANSFER', 'TRANSFERRING', 'PAID', 'FAILED', 'CANCELLED');

-- CreateTable
CREATE TABLE "escrow_ledgers" (
    "id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "entry_type" "EscrowEntryType" NOT NULL,
    "amount" BIGINT NOT NULL,
    "booking_id" TEXT,
    "trip_id" TEXT,
    "payment_id" TEXT,
    "refund_id" TEXT,
    "payout_id" TEXT,
    "commission_rate_bps" INTEGER,
    "eligible_at" TIMESTAMP(3) NOT NULL,
    "note" TEXT,
    "created_by" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "escrow_ledgers_pkey" PRIMARY KEY ("id"),
    -- Dấu theo loại: tiền vào sổ nhà xe dương, tiền ra âm; điều chỉnh khác 0.
    CONSTRAINT "escrow_ledgers_sign" CHECK (
      ("entry_type" IN ('PAYMENT_CAPTURED', 'COMMISSION_REVERSAL') AND "amount" > 0)
      OR ("entry_type" IN ('COMMISSION', 'REFUND', 'PAYOUT') AND "amount" < 0)
      OR ("entry_type" = 'ADJUSTMENT' AND "amount" <> 0)
    ),
    CONSTRAINT "escrow_ledgers_rate" CHECK (
      ("entry_type" IN ('COMMISSION', 'COMMISSION_REVERSAL')) = ("commission_rate_bps" IS NOT NULL)
      AND ("commission_rate_bps" IS NULL OR "commission_rate_bps" BETWEEN 0 AND 10000)
    ),
    CONSTRAINT "escrow_ledgers_links" CHECK (
      ("entry_type" IN ('PAYMENT_CAPTURED', 'COMMISSION') AND "payment_id" IS NOT NULL AND "booking_id" IS NOT NULL)
      OR ("entry_type" IN ('REFUND', 'COMMISSION_REVERSAL') AND "refund_id" IS NOT NULL AND "booking_id" IS NOT NULL)
      OR ("entry_type" = 'PAYOUT' AND "payout_id" IS NOT NULL)
      OR ("entry_type" = 'ADJUSTMENT' AND "note" IS NOT NULL)
    )
);

-- CreateTable
CREATE TABLE "payouts" (
    "id" TEXT NOT NULL,
    "payout_code" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "period" DATE NOT NULL,
    "status" "PayoutStatus" NOT NULL DEFAULT 'PENDING_REVIEW',
    "gross_amount" BIGINT NOT NULL,
    "commission_amount" BIGINT NOT NULL,
    "refund_amount" BIGINT NOT NULL,
    "adjustment_amount" BIGINT NOT NULL,
    "amount" BIGINT NOT NULL,
    "commission_rate_bps" INTEGER,
    "hold_reason" TEXT,
    "bank_name" TEXT,
    "bank_account_number" TEXT,
    "bank_account_holder" TEXT,
    "bank_reference" TEXT,
    "transferred_at" TIMESTAMP(3),
    "confirmation_note" TEXT,
    "reviewed_by" TEXT,
    "reviewed_at" TIMESTAMP(3),
    "paid_by" TEXT,
    "paid_at" TIMESTAMP(3),
    "cancel_reason" TEXT,
    "failure_reason" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "payouts_pkey" PRIMARY KEY ("id"),
    -- Thực chi = đủ điều kiện − hoa hồng ròng − hoàn tiền + điều chỉnh (BR-33); luôn > 0 khi tạo. Hoa hồng ròng của một kỳ có
    -- thể âm (hoàn tiền sau khi vé đã chi ở kỳ trước → chỉ còn phần trả lại hoa hồng).
    CONSTRAINT "payouts_amounts" CHECK (
      "gross_amount" >= 0 AND "refund_amount" >= 0
      AND "amount" = "gross_amount" - "commission_amount" - "refund_amount" + "adjustment_amount" AND "amount" > 0
    ),
    CONSTRAINT "payouts_code_format" CHECK ("payout_code" ~ '^PO-[0-9]{8}-[0-9]{3,}$'),
    CONSTRAINT "payouts_paid_fields" CHECK ("status" <> 'PAID' OR ("bank_reference" IS NOT NULL AND "paid_at" IS NOT NULL AND "transferred_at" IS NOT NULL))
);

-- Số thứ tự trong mã kỳ chi trả `PO-YYYYMMDD-NNN` — dùng chung mọi nhà xe (RLS không cho đếm kỳ của nhà xe khác).
CREATE SEQUENCE "payout_code_seq";

-- CreateTable
CREATE TABLE "payout_items" (
    "id" TEXT NOT NULL,
    "payout_id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "ledger_entry_id" TEXT NOT NULL,
    "entry_type" "EscrowEntryType" NOT NULL,
    "amount" BIGINT NOT NULL,
    "booking_id" TEXT,
    "trip_id" TEXT,

    CONSTRAINT "payout_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payout_status_histories" (
    "id" TEXT NOT NULL,
    "payout_id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "from_status" "PayoutStatus",
    "to_status" "PayoutStatus" NOT NULL,
    "reason" TEXT,
    "actor" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payout_status_histories_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "escrow_ledgers_operator_id_created_at_idx" ON "escrow_ledgers"("operator_id", "created_at");
CREATE INDEX "escrow_ledgers_booking_id_payment_id_idx" ON "escrow_ledgers"("booking_id", "payment_id");
CREATE INDEX "escrow_ledgers_operator_id_eligible_at_idx" ON "escrow_ledgers"("operator_id", "eligible_at");
CREATE UNIQUE INDEX "escrow_ledgers_id_operator_id_key" ON "escrow_ledgers"("id", "operator_id");
-- Ghi sổ idempotent: mỗi payment / refund / payout chỉ một bút toán mỗi loại (callback / job chạy lặp không ghi trùng).
CREATE UNIQUE INDEX "escrow_ledgers_payment_entry_key" ON "escrow_ledgers"("payment_id", "entry_type") WHERE "payment_id" IS NOT NULL;
CREATE UNIQUE INDEX "escrow_ledgers_refund_entry_key" ON "escrow_ledgers"("refund_id", "entry_type") WHERE "refund_id" IS NOT NULL;
CREATE UNIQUE INDEX "escrow_ledgers_payout_entry_key" ON "escrow_ledgers"("payout_id", "entry_type") WHERE "payout_id" IS NOT NULL;
CREATE UNIQUE INDEX "payouts_payout_code_key" ON "payouts"("payout_code");
-- Idempotent theo (nhà xe, kỳ) — LLD §6.6 bước 3.
CREATE UNIQUE INDEX "payouts_operator_id_period_key" ON "payouts"("operator_id", "period");
CREATE UNIQUE INDEX "payouts_id_operator_id_key" ON "payouts"("id", "operator_id");
CREATE INDEX "payouts_status_period_idx" ON "payouts"("status", "period");
-- Một bút toán thuộc tối đa một kỳ chi trả (kỳ hủy / thất bại thì xóa item để bút toán vào kỳ sau).
CREATE UNIQUE INDEX "payout_items_ledger_entry_id_key" ON "payout_items"("ledger_entry_id");
CREATE INDEX "payout_items_payout_id_idx" ON "payout_items"("payout_id");
CREATE INDEX "payout_status_histories_payout_id_created_at_idx" ON "payout_status_histories"("payout_id", "created_at");

-- AddForeignKey
ALTER TABLE "escrow_ledgers" ADD CONSTRAINT "escrow_ledgers_operator_id_fkey" FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "escrow_ledgers" ADD CONSTRAINT "escrow_ledgers_booking_id_operator_id_fkey" FOREIGN KEY ("booking_id", "operator_id") REFERENCES "bookings"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "escrow_ledgers" ADD CONSTRAINT "escrow_ledgers_payment_id_operator_id_fkey" FOREIGN KEY ("payment_id", "operator_id") REFERENCES "payments"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "escrow_ledgers" ADD CONSTRAINT "escrow_ledgers_refund_id_operator_id_fkey" FOREIGN KEY ("refund_id", "operator_id") REFERENCES "refunds"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "escrow_ledgers" ADD CONSTRAINT "escrow_ledgers_payout_id_operator_id_fkey" FOREIGN KEY ("payout_id", "operator_id") REFERENCES "payouts"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "payouts" ADD CONSTRAINT "payouts_operator_id_fkey" FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "payout_items" ADD CONSTRAINT "payout_items_payout_id_operator_id_fkey" FOREIGN KEY ("payout_id", "operator_id") REFERENCES "payouts"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "payout_items" ADD CONSTRAINT "payout_items_ledger_entry_id_operator_id_fkey" FOREIGN KEY ("ledger_entry_id", "operator_id") REFERENCES "escrow_ledgers"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "payout_status_histories" ADD CONSTRAINT "payout_status_histories_payout_id_operator_id_fkey" FOREIGN KEY ("payout_id", "operator_id") REFERENCES "payouts"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Sổ escrow CHỈ GHI THÊM (ADR-005, DB-PRIN-02): chặn UPDATE / DELETE ở DB. Sửa sai = bút toán `ADJUSTMENT` mới. Riêng dọn dữ
-- liệu test được bật cờ phiên `app.allow_ledger_delete = 'on'` (SET LOCAL trong transaction của test, không có ở code chạy thật).
CREATE FUNCTION escrow_ledgers_append_only() RETURNS trigger LANGUAGE plpgsql AS $fn$
BEGIN
  IF TG_OP = 'DELETE' AND current_setting('app.allow_ledger_delete', true) = 'on' THEN
    RETURN OLD;
  END IF;
  RAISE EXCEPTION 'escrow_ledgers is append-only' USING ERRCODE = 'insufficient_privilege';
END;
$fn$;
CREATE TRIGGER "escrow_ledgers_append_only" BEFORE UPDATE OR DELETE ON "escrow_ledgers"
  FOR EACH ROW EXECUTE FUNCTION escrow_ledgers_append_only();

-- RLS: nhà xe chỉ thấy sổ / kỳ chi trả của mình; Admin (platform) thấy hết.
ALTER TABLE "escrow_ledgers" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "escrow_ledgers" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "escrow_ledgers" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
ALTER TABLE "payouts" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "payouts" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "payouts" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
ALTER TABLE "payout_items" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "payout_items" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "payout_items" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
ALTER TABLE "payout_status_histories" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "payout_status_histories" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "payout_status_histories" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
