-- TASK-TRN-007 — lịch chuyến lặp lại (FR-OPS-07, UC-14 bước 7). Thiết kế AI tự đề xuất, chờ Khanh duyệt
-- (`doc/task-propreties/TRN-007-todo.md`). Lịch là QUY TẮC; Owner bấm "Sinh chuyến" để tạo chuyến nháp cho từng ngày
-- khớp quy tắc. `trips.schedule_id` + `service_date` UNIQUE → chạy lại (kể cả hai lần đồng thời) không sinh trùng.
-- Operator-owned: `operator_id` + RLS, FK ghép chặn gắn chéo tenant (mẫu `fares`).

-- CreateTable
CREATE TABLE "trip_schedules" (
    "id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "route_id" TEXT NOT NULL,
    "vehicle_id" TEXT,
    "departure_minute" INTEGER NOT NULL,
    "duration_minutes" INTEGER NOT NULL,
    "days_of_week" SMALLINT NOT NULL,
    "start_date" DATE NOT NULL,
    "end_date" DATE NOT NULL,
    "online_sale_cutoff_minutes" INTEGER NOT NULL,
    "note" TEXT,
    "created_by" TEXT,
    "last_generated_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "trip_schedules_pkey" PRIMARY KEY ("id"),
    -- Giờ khởi hành theo giờ Việt Nam (UTC+7, không đổi giờ theo mùa), phút trong ngày.
    CONSTRAINT "trip_schedules_departure_minute" CHECK ("departure_minute" BETWEEN 0 AND 1439),
    -- Như chuyến lẻ: tối đa 7 ngày (MAX_TRIP_DURATION_MS).
    CONSTRAINT "trip_schedules_duration_minutes" CHECK ("duration_minutes" BETWEEN 1 AND 10080),
    -- Bit 0 = thứ Hai … bit 6 = Chủ nhật; ít nhất một ngày.
    CONSTRAINT "trip_schedules_days_of_week" CHECK ("days_of_week" BETWEEN 1 AND 127),
    -- Tối đa 93 ngày mỗi lịch: giới hạn số chuyến sinh trong một lần bấm.
    CONSTRAINT "trip_schedules_date_range" CHECK ("end_date" >= "start_date" AND "end_date" - "start_date" <= 92),
    CONSTRAINT "trip_schedules_online_sale_cutoff" CHECK ("online_sale_cutoff_minutes" BETWEEN 0 AND 1440)
);

-- CreateIndex
CREATE INDEX "trip_schedules_operator_id_end_date_idx" ON "trip_schedules"("operator_id", "end_date");

-- CreateIndex
CREATE UNIQUE INDEX "trip_schedules_id_operator_id_key" ON "trip_schedules"("id", "operator_id");

-- AddForeignKey
ALTER TABLE "trip_schedules" ADD CONSTRAINT "trip_schedules_operator_id_fkey" FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey — tuyến / xe phải thuộc đúng tenant của lịch.
ALTER TABLE "trip_schedules" ADD CONSTRAINT "trip_schedules_route_id_operator_id_fkey" FOREIGN KEY ("route_id", "operator_id") REFERENCES "routes"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "trip_schedules" ADD CONSTRAINT "trip_schedules_vehicle_id_operator_id_fkey" FOREIGN KEY ("vehicle_id", "operator_id") REFERENCES "vehicles"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AlterTable — chuyến sinh từ lịch: ngày chạy (giờ Việt Nam) của lịch đó.
ALTER TABLE "trips" ADD COLUMN "schedule_id" TEXT,
ADD COLUMN "service_date" DATE,
ADD CONSTRAINT "trips_schedule_service_date" CHECK (("schedule_id" IS NULL) = ("service_date" IS NULL));

-- CreateIndex — mỗi lịch tối đa một chuyến mỗi ngày (chuyến đã hủy vẫn giữ chỗ: sinh lại không tạo lại chuyến đã hủy).
CREATE UNIQUE INDEX "trips_schedule_id_service_date_key" ON "trips"("schedule_id", "service_date");

-- AddForeignKey
ALTER TABLE "trips" ADD CONSTRAINT "trips_schedule_id_operator_id_fkey" FOREIGN KEY ("schedule_id", "operator_id") REFERENCES "trip_schedules"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- RLS
ALTER TABLE "trip_schedules" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "trip_schedules" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "trip_schedules"
  USING (app_rls_allows("operator_id"))
  WITH CHECK (app_rls_allows("operator_id"));
