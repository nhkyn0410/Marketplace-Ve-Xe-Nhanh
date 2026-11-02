-- TASK-BTP-005 — hủy vé + hoàn tiền theo chính sách lưu lúc đặt (FR-BTP-12..14/18, UC-08, BR-06/07, SRS §17.9; DB §4
-- `refunds`, §7 unique `refund_code` + index `(payment_id, status)`). Thiết kế cột AI tự đề xuất, chờ Khanh duyệt
-- (`doc/task-propreties/BTP-005-todo.md`). Tiền = BIGINT VND. Operator-owned theo booking + RLS `tenant_isolation`.

-- CreateEnum (SRS §17.9)
CREATE TYPE "RefundStatus" AS ENUM ('REQUESTED', 'APPROVED', 'PROCESSING', 'SUCCESS', 'FAILED', 'REJECTED');

-- CreateTable
CREATE TABLE "refunds" (
    "id" TEXT NOT NULL,
    "refund_code" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "booking_id" TEXT NOT NULL,
    "payment_id" TEXT NOT NULL,
    "status" "RefundStatus" NOT NULL DEFAULT 'REQUESTED',
    "amount" BIGINT NOT NULL,
    "refund_percent" INTEGER NOT NULL,
    "reason" TEXT NOT NULL,
    "provider_refund_id" TEXT,
    "failure_code" TEXT,
    "requested_by" TEXT NOT NULL,
    "processed_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "refunds_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "refunds_amount" CHECK ("amount" > 0),
    CONSTRAINT "refunds_percent" CHECK ("refund_percent" BETWEEN 1 AND 100),
    -- Mã gửi cổng khi hoàn (vnp_RequestId / orderId của MoMo).
    CONSTRAINT "refunds_code_format" CHECK ("refund_code" ~ '^RFD[A-Z0-9]{12}$')
);

-- CreateTable
CREATE TABLE "refund_status_histories" (
    "id" TEXT NOT NULL,
    "refund_id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "from_status" "RefundStatus",
    "to_status" "RefundStatus" NOT NULL,
    "reason" TEXT,
    "actor" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "refund_status_histories_pkey" PRIMARY KEY ("id")
);

-- AlterTable — vé hủy thuộc lần hoàn nào (vé hủy không hoàn tiền thì để trống).
ALTER TABLE "tickets" ADD COLUMN "refund_id" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "refunds_refund_code_key" ON "refunds"("refund_code");
CREATE UNIQUE INDEX "refunds_id_operator_id_key" ON "refunds"("id", "operator_id");
CREATE INDEX "refunds_payment_id_status_idx" ON "refunds"("payment_id", "status");
CREATE INDEX "refunds_booking_id_idx" ON "refunds"("booking_id");
CREATE INDEX "refunds_operator_id_status_idx" ON "refunds"("operator_id", "status");
CREATE INDEX "refund_status_histories_refund_id_created_at_idx" ON "refund_status_histories"("refund_id", "created_at");
CREATE INDEX "tickets_refund_id_idx" ON "tickets"("refund_id");

-- AddForeignKey
ALTER TABLE "refunds" ADD CONSTRAINT "refunds_booking_id_operator_id_fkey" FOREIGN KEY ("booking_id", "operator_id") REFERENCES "bookings"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "refunds" ADD CONSTRAINT "refunds_payment_id_operator_id_fkey" FOREIGN KEY ("payment_id", "operator_id") REFERENCES "payments"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "refund_status_histories" ADD CONSTRAINT "refund_status_histories_refund_id_operator_id_fkey" FOREIGN KEY ("refund_id", "operator_id") REFERENCES "refunds"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "tickets" ADD CONSTRAINT "tickets_refund_id_operator_id_fkey" FOREIGN KEY ("refund_id", "operator_id") REFERENCES "refunds"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- RLS
ALTER TABLE "refunds" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "refunds" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "refunds" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
ALTER TABLE "refund_status_histories" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "refund_status_histories" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "refund_status_histories" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
