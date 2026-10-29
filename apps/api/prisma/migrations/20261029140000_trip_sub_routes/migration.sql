-- Giai đoạn 3.3 (tự thiết kế 29/10/2026, chờ duyệt): chặng mở bán của chuyến / lịch lặp lại theo tuyến con. Một chuyến
-- (một lần xe chạy) bán thêm theo giá của tuyến con cho khách đi trong đoạn của tuyến con; không tạo chuyến riêng.

CREATE TABLE "trip_sub_routes" (
    "trip_id" TEXT NOT NULL,
    "sub_route_id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "trip_sub_routes_pkey" PRIMARY KEY ("trip_id", "sub_route_id")
);

CREATE TABLE "trip_schedule_sub_routes" (
    "schedule_id" TEXT NOT NULL,
    "sub_route_id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "trip_schedule_sub_routes_pkey" PRIMARY KEY ("schedule_id", "sub_route_id")
);

CREATE INDEX "trip_sub_routes_sub_route_id_idx" ON "trip_sub_routes"("sub_route_id");
CREATE INDEX "trip_schedule_sub_routes_sub_route_id_idx" ON "trip_schedule_sub_routes"("sub_route_id");

-- FK ghép kèm `operator_id`: chuyến, lịch và tuyến con luôn cùng một nhà xe.
ALTER TABLE "trip_sub_routes" ADD CONSTRAINT "trip_sub_routes_trip_id_operator_id_fkey"
  FOREIGN KEY ("trip_id", "operator_id") REFERENCES "trips"("id", "operator_id") ON DELETE CASCADE ON UPDATE RESTRICT;
ALTER TABLE "trip_sub_routes" ADD CONSTRAINT "trip_sub_routes_sub_route_id_operator_id_fkey"
  FOREIGN KEY ("sub_route_id", "operator_id") REFERENCES "routes"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "trip_schedule_sub_routes" ADD CONSTRAINT "trip_schedule_sub_routes_schedule_id_operator_id_fkey"
  FOREIGN KEY ("schedule_id", "operator_id") REFERENCES "trip_schedules"("id", "operator_id") ON DELETE CASCADE ON UPDATE RESTRICT;
ALTER TABLE "trip_schedule_sub_routes" ADD CONSTRAINT "trip_schedule_sub_routes_sub_route_id_operator_id_fkey"
  FOREIGN KEY ("sub_route_id", "operator_id") REFERENCES "routes"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- RLS tenant (mẫu `trip_stops`).
ALTER TABLE "trip_sub_routes" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "trip_sub_routes" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "trip_sub_routes"
  USING (app_rls_allows("operator_id"))
  WITH CHECK (app_rls_allows("operator_id"));

ALTER TABLE "trip_schedule_sub_routes" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "trip_schedule_sub_routes" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "trip_schedule_sub_routes"
  USING (app_rls_allows("operator_id"))
  WITH CHECK (app_rls_allows("operator_id"));
