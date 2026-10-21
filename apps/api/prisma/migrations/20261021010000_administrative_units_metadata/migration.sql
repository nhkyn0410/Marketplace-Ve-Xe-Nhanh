-- Mở rộng danh mục đơn vị hành chính (`provinces`, `wards`):
--   1. Thêm cột `level` (Cấp hành chính) và `decree` (Văn bản pháp lý / Nghị quyết).
--   2. Thêm cột sinh `search_text` dùng hàm `vxn_search_text("name")` để tìm kiếm Tỉnh / Phường không dấu.
--   3. Chuyển mã 3 phường mẫu dev cũ (`90001`, `90002`, `90003`) sang mã chính thức (`26833`, `00592`) để giữ nguyên FK.

SET LOCAL lock_timeout = '10s';
SELECT set_config('app.scope', 'system', true);

ALTER TABLE "provinces"
  ADD COLUMN "level" TEXT,
  ADD COLUMN "decree" TEXT,
  ADD COLUMN "search_text" TEXT GENERATED ALWAYS AS (vxn_search_text("name")) STORED;

ALTER TABLE "wards"
  ADD COLUMN "level" TEXT,
  ADD COLUMN "decree" TEXT,
  ADD COLUMN "search_text" TEXT GENERATED ALWAYS AS (vxn_search_text("name")) STORED;

-- Chuẩn hoá mã các dòng phường mẫu dev cũ nếu đang tồn tại trong DB local trước khi seed danh mục chính thức:
UPDATE "wards"
   SET "code" = '26833',
       "level" = 'Phường',
       "decree" = 'Số: 1685/NQ-UBTVQH15; Ngày: 16/06/2025'
 WHERE "code" = '90001'
   AND NOT EXISTS (SELECT 1 FROM "wards" WHERE "code" = '26833');

UPDATE "wards"
   SET "code" = '00592',
       "level" = 'Phường',
       "decree" = 'Số: 1656/NQ-UBTVQH15; Ngày: 16/06/2025'
 WHERE "code" = '90003'
   AND NOT EXISTS (SELECT 1 FROM "wards" WHERE "code" = '00592');

DELETE FROM "wards"
 WHERE "code" = '90002'
   AND NOT EXISTS (SELECT 1 FROM "stop_points_catalog" WHERE "ward_id" = "wards"."id")
   AND NOT EXISTS (SELECT 1 FROM "stop_points" WHERE "ward_id" = "wards"."id")
   AND NOT EXISTS (SELECT 1 FROM "stop_point_proposals" WHERE "ward_id" = "wards"."id");
