-- TASK-BTP-003 — payment qua cổng VNPay / MoMo (FR-BTP-07..09/18, LLD §6.3, SRS §17.8, ADR-019; DB §4 nhóm Payment).
-- Thiết kế cột AI tự đề xuất, chờ Khanh duyệt (`doc/task-propreties/BTP-003-todo.md`). Tiền = BIGINT VND.
-- Operator-owned (theo booking): `operator_id` + RLS `tenant_isolation`. Dedup callback: unique (provider, provider_txn_id).

-- CreateEnum
CREATE TYPE "PaymentProvider" AS ENUM ('VNPAY', 'MOMO');
-- SRS §17.8
CREATE TYPE "PaymentStatus" AS ENUM ('INITIATED', 'PROCESSING', 'SUCCESS', 'FAILED', 'EXPIRED', 'CANCELLED', 'RECONCILING');

-- CreateTable
CREATE TABLE "payments" (
    "id" TEXT NOT NULL,
    "payment_code" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "booking_id" TEXT NOT NULL,
    "provider" "PaymentProvider" NOT NULL,
    "status" "PaymentStatus" NOT NULL DEFAULT 'INITIATED',
    "amount" BIGINT NOT NULL,
    "payment_url" TEXT,
    "provider_txn_id" TEXT,
    "failure_code" TEXT,
    "reconcile_reason" TEXT,
    "callback" JSONB,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "paid_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "payments_amount" CHECK ("amount" > 0),
    -- Mã gửi cổng (vnp_TxnRef / orderId): chỉ chữ hoa + số để hợp cả hai cổng.
    CONSTRAINT "payments_code_format" CHECK ("payment_code" ~ '^PAY[A-Z0-9]{12}$')
);

-- CreateTable
CREATE TABLE "payment_status_histories" (
    "id" TEXT NOT NULL,
    "payment_id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "from_status" "PaymentStatus",
    "to_status" "PaymentStatus" NOT NULL,
    "reason" TEXT,
    "actor" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payment_status_histories_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "payments_payment_code_key" ON "payments"("payment_code");
-- Idempotency callback (ADR-019, FR-BTP-08): một giao dịch của cổng chỉ ghi nhận một lần.
CREATE UNIQUE INDEX "payments_provider_provider_txn_id_key" ON "payments"("provider", "provider_txn_id");
CREATE UNIQUE INDEX "payments_id_operator_id_key" ON "payments"("id", "operator_id");
-- Mỗi booking tối đa một payment đang mở cho mỗi cổng (tạo lặp / đồng thời trả lại payment đang mở).
CREATE UNIQUE INDEX "payments_booking_id_provider_open_key" ON "payments"("booking_id", "provider") WHERE "status" IN ('INITIATED', 'PROCESSING');
CREATE INDEX "payments_booking_id_created_at_idx" ON "payments"("booking_id", "created_at" DESC);
CREATE INDEX "payments_operator_id_status_idx" ON "payments"("operator_id", "status");
CREATE INDEX "payment_status_histories_payment_id_created_at_idx" ON "payment_status_histories"("payment_id", "created_at");

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_booking_id_operator_id_fkey" FOREIGN KEY ("booking_id", "operator_id") REFERENCES "bookings"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "payment_status_histories" ADD CONSTRAINT "payment_status_histories_payment_id_operator_id_fkey" FOREIGN KEY ("payment_id", "operator_id") REFERENCES "payments"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- RLS
ALTER TABLE "payments" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "payments" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "payments" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
ALTER TABLE "payment_status_histories" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "payment_status_histories" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "payment_status_histories" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
