-- Mã truy cập phụ của booking khách vãng lai (Khanh 27/10/2026, chờ duyệt): cấp sau khi khách xác minh OTP tra cứu vé để
-- hủy vé / gửi khiếu nại mà không cần trình duyệt đã đặt vé. Chỉ lưu SHA-256 của mã; hết hạn cùng phiên tra cứu (15 phút).
-- Operator-owned: `operator_id` + FK ghép tới `bookings` + RLS `tenant_isolation` như các bảng con của booking.

SET LOCAL lock_timeout = '10s';

-- CreateTable
CREATE TABLE "booking_access_grants" (
    "id" TEXT NOT NULL,
    "booking_id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "token_hash" TEXT NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "booking_access_grants_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "booking_access_grants_token_hash_key" ON "booking_access_grants"("token_hash");

-- CreateIndex
CREATE INDEX "booking_access_grants_booking_id_expires_at_idx" ON "booking_access_grants"("booking_id", "expires_at");

-- AddForeignKey
ALTER TABLE "booking_access_grants" ADD CONSTRAINT "booking_access_grants_booking_id_operator_id_fkey" FOREIGN KEY ("booking_id", "operator_id") REFERENCES "bookings"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE "booking_access_grants" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "booking_access_grants" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "booking_access_grants" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
