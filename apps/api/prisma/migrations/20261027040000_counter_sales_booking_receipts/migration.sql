-- COUNTER-SALES: nguồn bán quầy, khoản thu trực tiếp và hoa hồng phải thu riêng.
CREATE TYPE "SalesChannel" AS ENUM ('ONLINE', 'COUNTER');
CREATE TYPE "CounterReceiptMethod" AS ENUM ('CASH', 'BANK_TRANSFER');
CREATE TYPE "CounterReceiptStatus" AS ENUM ('COMPLETED', 'EXCEPTION');
ALTER TABLE "commission_rules" ADD COLUMN "channel" "SalesChannel" NOT NULL DEFAULT 'ONLINE';
ALTER TABLE "bookings" ADD COLUMN "channel" "SalesChannel" NOT NULL DEFAULT 'ONLINE',
  ADD COLUMN "office_id" TEXT, ADD COLUMN "sold_by" TEXT,
  ALTER COLUMN "contact_email" DROP NOT NULL;
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_counter_attribution"
  CHECK (("channel" = 'ONLINE' AND "office_id" IS NULL AND "sold_by" IS NULL)
    OR ("channel" = 'COUNTER' AND "office_id" IS NOT NULL AND "sold_by" ~ '^(operator|employee):.+$' AND "user_id" IS NULL));
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_online_contact_email" CHECK ("channel" <> 'ONLINE' OR "contact_email" IS NOT NULL);
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_office_id_operator_id_fkey"
  FOREIGN KEY ("office_id", "operator_id") REFERENCES "sales_offices"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
CREATE INDEX "bookings_operator_id_office_id_created_at_idx" ON "bookings"("operator_id", "office_id", "created_at" DESC);

CREATE TABLE "counter_receipts" (
  "id" TEXT NOT NULL PRIMARY KEY,
  "operator_id" TEXT NOT NULL,
  "booking_id" TEXT NOT NULL,
  "office_id" TEXT NOT NULL,
  "idempotency_key" TEXT NOT NULL,
  "method" "CounterReceiptMethod" NOT NULL,
  "amount" BIGINT NOT NULL CHECK ("amount" > 0),
  "reference" TEXT,
  "status" "CounterReceiptStatus" NOT NULL,
  "exception_reason" TEXT,
  "recorded_by" TEXT NOT NULL CHECK ("recorded_by" ~ '^(operator|employee):.+$'),
  "received_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "counter_receipts_bank_reference" CHECK (("method" = 'BANK_TRANSFER' AND "reference" IS NOT NULL AND char_length("reference") BETWEEN 3 AND 100) OR ("method" = 'CASH' AND "reference" IS NULL)),
  CONSTRAINT "counter_receipts_exception_reason" CHECK (("status" = 'EXCEPTION' AND "exception_reason" IS NOT NULL) OR ("status" = 'COMPLETED' AND "exception_reason" IS NULL)),
  CONSTRAINT "counter_receipts_booking_id_operator_id_fkey" FOREIGN KEY ("booking_id", "operator_id") REFERENCES "bookings"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT "counter_receipts_office_id_operator_id_fkey" FOREIGN KEY ("office_id", "operator_id") REFERENCES "sales_offices"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE UNIQUE INDEX "counter_receipts_id_operator_id_key" ON "counter_receipts"("id", "operator_id");
CREATE UNIQUE INDEX "counter_receipts_operator_id_idempotency_key_key" ON "counter_receipts"("operator_id", "idempotency_key");
CREATE UNIQUE INDEX "counter_receipts_operator_id_reference_key" ON "counter_receipts"("operator_id", "reference");
CREATE UNIQUE INDEX "counter_receipts_booking_completed_once" ON "counter_receipts"("booking_id") WHERE "status" = 'COMPLETED';
CREATE INDEX "counter_receipts_operator_id_office_id_created_at_idx" ON "counter_receipts"("operator_id", "office_id", "created_at");

CREATE TABLE "counter_commission_receivables" (
  "id" TEXT NOT NULL PRIMARY KEY,
  "operator_id" TEXT NOT NULL,
  "receipt_id" TEXT NOT NULL,
  "booking_id" TEXT NOT NULL,
  "commission_rule_id" TEXT,
  "rate_bps" INTEGER NOT NULL CHECK ("rate_bps" BETWEEN 0 AND 10000),
  "basis" BIGINT NOT NULL CHECK ("basis" >= 0),
  "amount" BIGINT NOT NULL CHECK ("amount" >= 0),
  "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "counter_commission_receivables_exact_amount" CHECK ("amount" = floor("basis"::numeric * "rate_bps"::numeric / 10000)::bigint),
  CONSTRAINT "counter_commission_receivables_receipt_id_operator_id_fkey" FOREIGN KEY ("receipt_id", "operator_id") REFERENCES "counter_receipts"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT "counter_commission_receivables_booking_id_operator_id_fkey" FOREIGN KEY ("booking_id", "operator_id") REFERENCES "bookings"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT "counter_commission_receivables_commission_rule_id_fkey" FOREIGN KEY ("commission_rule_id") REFERENCES "commission_rules"("id") ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE UNIQUE INDEX "counter_commission_receivables_receipt_id_key" ON "counter_commission_receivables"("receipt_id");
CREATE UNIQUE INDEX "counter_commission_receivables_receipt_id_operator_id_key" ON "counter_commission_receivables"("receipt_id", "operator_id");
CREATE INDEX "counter_commission_receivables_operator_id_created_at_idx" ON "counter_commission_receivables"("operator_id", "created_at");

CREATE TABLE "counter_commission_settlements" (
  "id" TEXT NOT NULL PRIMARY KEY,
  "operator_id" TEXT NOT NULL,
  "idempotency_key" TEXT NOT NULL,
  "amount" BIGINT NOT NULL CHECK ("amount" > 0),
  "reference" TEXT NOT NULL,
  "reason" TEXT NOT NULL,
  "created_by" TEXT NOT NULL,
  "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "counter_commission_settlements_operator_id_fkey" FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE UNIQUE INDEX "counter_commission_settlements_operator_id_idempotency_key_key" ON "counter_commission_settlements"("operator_id", "idempotency_key");
CREATE UNIQUE INDEX "counter_commission_settlements_operator_id_reference_key" ON "counter_commission_settlements"("operator_id", "reference");
CREATE INDEX "counter_commission_settlements_operator_id_created_at_idx" ON "counter_commission_settlements"("operator_id", "created_at");

ALTER TABLE "counter_receipts" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "counter_receipts" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "counter_receipts" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
ALTER TABLE "counter_commission_receivables" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "counter_commission_receivables" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "counter_commission_receivables" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
ALTER TABLE "counter_commission_settlements" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "counter_commission_settlements" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "counter_commission_settlements" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));

-- Giữ snapshot nguồn thu và số phải thu; sửa sai bằng quy trình có dấu vết ở lát hoàn/ngoại lệ, không sửa lịch sử.
CREATE FUNCTION counter_money_append_only() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  RAISE EXCEPTION 'Counter money records are append-only' USING ERRCODE = '42501';
END;
$$;
CREATE TRIGGER counter_receipts_append_only BEFORE UPDATE OR DELETE ON "counter_receipts" FOR EACH ROW EXECUTE FUNCTION counter_money_append_only();
CREATE TRIGGER counter_receivables_append_only BEFORE UPDATE OR DELETE ON "counter_commission_receivables" FOR EACH ROW EXECUTE FUNCTION counter_money_append_only();
CREATE TRIGGER counter_settlements_append_only BEFORE UPDATE OR DELETE ON "counter_commission_settlements" FOR EACH ROW EXECUTE FUNCTION counter_money_append_only();
