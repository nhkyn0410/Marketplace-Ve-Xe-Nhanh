-- TASK-BTP-002 — booking + hành khách + lịch sử trạng thái (FR-BTP-05/06/18, LLD §6.2, SRS §9.4 / §17.6; DB §4 nhóm
-- Booking & Ticket). Thiết kế cột AI tự đề xuất, chờ Khanh duyệt (`doc/task-propreties/BTP-002-todo.md`). Tiền = BIGINT VND.
-- Operator-owned: `operator_id` + RLS `tenant_isolation`; luồng khách đặt vé chạy ở tenant của nhà xe sở hữu chuyến.

-- CreateEnum (SRS §17.6)
CREATE TYPE "BookingStatus" AS ENUM ('PENDING_PAYMENT', 'PENDING_CONFIRMATION', 'PAID', 'CONFIRMED', 'PARTIALLY_CANCELLED', 'CANCELLED', 'EXPIRED', 'REFUND_PENDING', 'REFUNDED', 'REFUND_FAILED');

-- CreateTable
CREATE TABLE "bookings" (
    "id" TEXT NOT NULL,
    "booking_code" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "trip_id" TEXT NOT NULL,
    "user_id" TEXT,
    "hold_id" TEXT NOT NULL,
    "status" "BookingStatus" NOT NULL DEFAULT 'PENDING_PAYMENT',
    "contact_name" TEXT NOT NULL,
    "contact_phone" TEXT NOT NULL,
    "contact_email" TEXT NOT NULL,
    "pickup_sequence" INTEGER NOT NULL,
    "dropoff_sequence" INTEGER NOT NULL,
    "subtotal" BIGINT NOT NULL,
    "service_fee" BIGINT NOT NULL DEFAULT 0,
    "discount" BIGINT NOT NULL DEFAULT 0,
    "total" BIGINT NOT NULL,
    "snapshot" JSONB NOT NULL,
    "note" TEXT,
    "access_token_hash" TEXT NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "paid_at" TIMESTAMP(3),
    "confirmed_at" TIMESTAMP(3),
    "cancelled_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "bookings_pkey" PRIMARY KEY ("id"),
    -- Tổng tiền = giá vé + phí − giảm (FR-BTP-06, CO-12); không âm.
    CONSTRAINT "bookings_amounts" CHECK ("subtotal" >= 0 AND "service_fee" >= 0 AND "discount" >= 0 AND "total" >= 0 AND "total" = "subtotal" + "service_fee" - "discount"),
    CONSTRAINT "bookings_stops_order" CHECK ("pickup_sequence" < "dropoff_sequence"),
    CONSTRAINT "bookings_code_format" CHECK ("booking_code" ~ '^VXN[A-Z0-9]{6}$')
);

-- CreateTable
CREATE TABLE "passenger_infos" (
    "id" TEXT NOT NULL,
    "booking_id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "trip_id" TEXT NOT NULL,
    "seat_code" TEXT NOT NULL,
    "seat_type" "SeatType" NOT NULL,
    "price" BIGINT NOT NULL,
    "full_name" TEXT NOT NULL,
    "phone" TEXT,

    CONSTRAINT "passenger_infos_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "passenger_infos_price" CHECK ("price" > 0)
);

-- CreateTable
CREATE TABLE "booking_status_histories" (
    "id" TEXT NOT NULL,
    "booking_id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "from_status" "BookingStatus",
    "to_status" "BookingStatus" NOT NULL,
    "reason" TEXT,
    "actor" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "booking_status_histories_pkey" PRIMARY KEY ("id")
);

-- AlterTable — chỗ đang chờ thanh toán / đã bán gắn với booking (giữ chỗ trước đó ở Redis — ADR-015).
ALTER TABLE "trip_seats" ADD COLUMN "booking_id" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "bookings_booking_code_key" ON "bookings"("booking_code");
-- Một phiên giữ chỗ tạo tối đa một booking (gửi lặp / đồng thời).
CREATE UNIQUE INDEX "bookings_hold_id_key" ON "bookings"("hold_id");
CREATE UNIQUE INDEX "bookings_id_operator_id_key" ON "bookings"("id", "operator_id");
CREATE INDEX "bookings_user_id_created_at_idx" ON "bookings"("user_id", "created_at" DESC);
CREATE INDEX "bookings_operator_id_status_idx" ON "bookings"("operator_id", "status");
CREATE INDEX "bookings_trip_id_idx" ON "bookings"("trip_id");
-- Quét booking chờ thanh toán đã quá hạn.
CREATE INDEX "bookings_status_expires_at_idx" ON "bookings"("status", "expires_at");
CREATE UNIQUE INDEX "passenger_infos_booking_id_seat_code_key" ON "passenger_infos"("booking_id", "seat_code");
CREATE INDEX "passenger_infos_trip_id_idx" ON "passenger_infos"("trip_id");
CREATE INDEX "booking_status_histories_booking_id_created_at_idx" ON "booking_status_histories"("booking_id", "created_at");
CREATE INDEX "trip_seats_booking_id_idx" ON "trip_seats"("booking_id");

-- AddForeignKey
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_operator_id_fkey" FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_trip_id_operator_id_fkey" FOREIGN KEY ("trip_id", "operator_id") REFERENCES "trips"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "passenger_infos" ADD CONSTRAINT "passenger_infos_booking_id_operator_id_fkey" FOREIGN KEY ("booking_id", "operator_id") REFERENCES "bookings"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "booking_status_histories" ADD CONSTRAINT "booking_status_histories_booking_id_operator_id_fkey" FOREIGN KEY ("booking_id", "operator_id") REFERENCES "bookings"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "trip_seats" ADD CONSTRAINT "trip_seats_booking_id_operator_id_fkey" FOREIGN KEY ("booking_id", "operator_id") REFERENCES "bookings"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- RLS
ALTER TABLE "bookings" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "bookings" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "bookings" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
ALTER TABLE "passenger_infos" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "passenger_infos" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "passenger_infos" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
ALTER TABLE "booking_status_histories" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "booking_status_histories" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "booking_status_histories" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
