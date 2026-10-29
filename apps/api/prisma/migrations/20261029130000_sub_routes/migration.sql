-- Giai đoạn 3.2 (tự thiết kế 29/10/2026, chờ duyệt): tuyến lưu nháp + tuyến con.
--   1. `RouteStatus` thêm `DRAFT` — chưa tạo chuyến được, khách không thấy.
--   2. `routes.parent_route_id`: tuyến con là một đoạn của tuyến chính; FK ghép kèm `operator_id` nên tuyến con luôn cùng
--      nhà xe với tuyến chính (RLS sẵn có của `routes` / `route_stops` áp nguyên). Điểm dừng của tuyến con là bản chép
--      đoạn đó vào `route_stops` (chỉ đọc), nên các CHECK theo vai trò điểm sẵn có vẫn giữ đúng.

ALTER TYPE "RouteStatus" ADD VALUE 'DRAFT';

ALTER TABLE "routes" ADD COLUMN "parent_route_id" TEXT;

ALTER TABLE "routes" ADD CONSTRAINT "routes_parent_route_id_operator_id_fkey"
  FOREIGN KEY ("parent_route_id", "operator_id") REFERENCES "routes"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Tuyến không làm cha của chính nó (chỉ một cấp kiểm ở service: tuyến cha phải là tuyến chính).
ALTER TABLE "routes" ADD CONSTRAINT "routes_parent_not_self" CHECK ("parent_route_id" IS NULL OR "parent_route_id" <> "id");

CREATE INDEX "routes_parent_route_id_idx" ON "routes"("parent_route_id");
