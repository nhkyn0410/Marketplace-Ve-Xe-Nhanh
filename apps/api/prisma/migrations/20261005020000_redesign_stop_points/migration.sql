-- TASK-TRN-012 (2/2) — Thiết kế lại điểm dừng, phía nhà xe (BR-38, BR-79, BR-81; DB §5.2, §7).
--
--   1. Dọn dữ liệu thử không còn hợp lệ (Khanh chốt 05/10/2026: XÓA, không chuyển đổi).
--   2. `stop_points`: chỉ còn loại OFFICE / REST_STOP; thêm lý do khóa; nhà xe không ghi được dòng
--      SUSPENDED và không tự đặt SUSPENDED (RLS); không xóa cứng.
--   3. `stop_point_proposals`: chỉ loại BUS_STATION / PICKUP_POINT; bắt buộc căn cứ công bố.
--   4. `route_stops`: thêm cho đón / cho trả, CHECK theo vai trò điểm đầu / điểm cuối.
--   5. Tìm không dấu: cột `search_text` do database sinh ở `stop_points` và `stop_points_catalog`.
--
-- KHÔNG bọc `BEGIN` / `COMMIT`: Prisma gửi cả file trong một lệnh nhiều câu, Postgres chạy nó như một
-- transaction ngầm — lỗi ở đâu cũng hoàn tác toàn bộ, và `SET LOCAL` / `set_config(…, true)` có hiệu lực
-- tới hết file (xem migration `add_vehicle_classification`).

SET LOCAL lock_timeout = '10s';

-- Migration DML must also work when the migration owner is subject to FORCE RLS: thiếu dòng này các lệnh
-- DELETE / UPDATE bên dưới lặng lẽ khớp 0 dòng.
SELECT set_config('app.scope', 'system', true);

-- ── 1. Dọn dữ liệu thử ──
-- Tuyến bị xóa: (a) có điểm riêng loại bến xe / điểm dừng đón trả — hai loại này từ nay chỉ có ở danh mục
-- dùng chung; (b) bắt đầu hoặc kết thúc ở trạm dừng nghỉ — BR-79 không cho trạm dừng nghỉ đón / trả khách.
-- Nếu đã có bảng khác trỏ tới tuyến (chuyến của TRN-003) thì FK RESTRICT làm migration dừng, không xóa dở.
CREATE TEMP TABLE "_trn012_invalid_routes" ON COMMIT DROP AS
SELECT DISTINCT rs."route_id"
  FROM "route_stops" AS rs
  LEFT JOIN "stop_points" AS own ON own."id" = rs."stop_point_id"
  LEFT JOIN "stop_points_catalog" AS shared ON shared."id" = rs."catalog_stop_point_id"
 WHERE own."type" IN ('BUS_STATION', 'PICKUP_POINT')
    OR (rs."role" IN ('ORIGIN', 'DESTINATION') AND COALESCE(own."type", shared."type") = 'REST_STOP');

DELETE FROM "route_stops" WHERE "route_id" IN (SELECT "route_id" FROM "_trn012_invalid_routes");
DELETE FROM "routes" WHERE "id" IN (SELECT "route_id" FROM "_trn012_invalid_routes");
DELETE FROM "stop_points" WHERE "type" IN ('BUS_STATION', 'PICKUP_POINT');
DELETE FROM "stop_point_proposals" WHERE "type" IN ('OFFICE', 'REST_STOP');

-- ── 2. Điểm dừng riêng ──
ALTER TABLE "stop_points" ADD COLUMN "suspension_reason" TEXT;
ALTER TABLE "stop_points" ADD CONSTRAINT "stop_points_private_type"
  CHECK ("type" IN ('OFFICE', 'REST_STOP'));
-- Lý do khóa có khi và chỉ khi điểm đang bị khóa: mở khóa phải xóa lý do, không để lý do cũ nằm lại.
ALTER TABLE "stop_points" ADD CONSTRAINT "stop_points_suspension_consistent" CHECK (
  ("status" = 'SUSPENDED') = ("suspension_reason" IS NOT NULL)
  AND ("suspension_reason" IS NULL
       OR (btrim("suspension_reason") <> '' AND char_length("suspension_reason") <= 500))
);

-- RLS: thay policy chung `tenant_isolation` bằng policy theo lệnh. Scope tenant không ghi được dòng đang
-- SUSPENDED (USING) và không đưa được dòng nào sang SUSPENDED (WITH CHECK) — service có bug thì nhà xe vẫn
-- không tự mở lại điểm bị Admin khóa. Không xóa cứng điểm dừng (BR-38): DELETE chỉ scope platform / system.
DROP POLICY "tenant_isolation" ON "stop_points";
CREATE POLICY "tenant_read" ON "stop_points" FOR SELECT
  USING (app_rls_allows("operator_id"));
CREATE POLICY "tenant_insert_not_suspended" ON "stop_points" FOR INSERT
  WITH CHECK (
    app_rls_allows("operator_id")
    AND (current_setting('app.scope', true) IN ('platform', 'system') OR "status" <> 'SUSPENDED')
  );
CREATE POLICY "tenant_update_not_suspended" ON "stop_points" FOR UPDATE
  USING (
    app_rls_allows("operator_id")
    AND (current_setting('app.scope', true) IN ('platform', 'system') OR "status" <> 'SUSPENDED')
  )
  WITH CHECK (
    app_rls_allows("operator_id")
    AND (current_setting('app.scope', true) IN ('platform', 'system') OR "status" <> 'SUSPENDED')
  );
CREATE POLICY "platform_delete" ON "stop_points" FOR DELETE
  USING (current_setting('app.scope', true) IN ('platform', 'system'));

-- ── 3. Đề xuất vào danh mục dùng chung ──
ALTER TABLE "stop_point_proposals" ADD COLUMN "legal_basis" TEXT;
-- Đề xuất đúng loại gửi trước khi có quy định: giữ lại, đánh dấu chưa khai để Admin biết khi duyệt.
UPDATE "stop_point_proposals"
   SET "legal_basis" = 'Chưa khai (đề xuất gửi trước khi bắt buộc căn cứ công bố)';
ALTER TABLE "stop_point_proposals" ALTER COLUMN "legal_basis" SET NOT NULL;
ALTER TABLE "stop_point_proposals" ADD CONSTRAINT "stop_point_proposals_shared_type"
  CHECK ("type" IN ('BUS_STATION', 'PICKUP_POINT'));
ALTER TABLE "stop_point_proposals" ADD CONSTRAINT "stop_point_proposals_legal_basis_present"
  CHECK (btrim("legal_basis") <> '' AND char_length("legal_basis") <= 300);

-- ── 4. Cho đón / cho trả trên từng điểm của route ──
ALTER TABLE "route_stops"
  ADD COLUMN "allow_pickup" BOOLEAN,
  ADD COLUMN "allow_dropoff" BOOLEAN;
-- Route còn lại sau bước 1: điểm đầu chỉ đón, điểm cuối chỉ trả, điểm giữa cả hai — trừ trạm dừng nghỉ.
UPDATE "route_stops" AS rs
   SET "allow_pickup" = rs."role" <> 'DESTINATION' AND point."type" <> 'REST_STOP',
       "allow_dropoff" = rs."role" <> 'ORIGIN' AND point."type" <> 'REST_STOP'
  FROM (
    SELECT "id", "type" FROM "stop_points"
    UNION ALL
    SELECT "id", "type" FROM "stop_points_catalog"
  ) AS point
 WHERE point."id" = COALESCE(rs."stop_point_id", rs."catalog_stop_point_id");
ALTER TABLE "route_stops"
  ALTER COLUMN "allow_pickup" SET NOT NULL,
  ALTER COLUMN "allow_dropoff" SET NOT NULL;
-- Phần phụ thuộc loại điểm (trạm dừng nghỉ, điểm giữa phải có ít nhất một quyền) kiểm ở service.
ALTER TABLE "route_stops" ADD CONSTRAINT "route_stops_pickup_dropoff_by_role" CHECK (
  ("role" <> 'ORIGIN' OR ("allow_pickup" AND NOT "allow_dropoff"))
  AND ("role" <> 'DESTINATION' OR (NOT "allow_pickup" AND "allow_dropoff"))
);

-- ── 5. Tìm không dấu (Khanh chốt 05/10/2026) ──
-- `unaccent` là extension tin cậy của Postgres: chủ database cài được, không cần superuser.
CREATE EXTENSION IF NOT EXISTS unaccent;

-- Hàm bọc để dùng được trong cột sinh: phải IMMUTABLE (bản gốc `unaccent` chỉ STABLE) và chỉ rõ schema
-- của extension — tự dò vì môi trường có thể đã cài sẵn ở schema khác (`extensions` trên Supabase).
-- SECURITY DEFINER + `search_path` rỗng: role app không cần quyền trên schema của extension; hàm chỉ đổi
-- chữ, không đọc bảng nào.
DO $$
DECLARE
  extension_schema TEXT;
BEGIN
  SELECT n.nspname INTO STRICT extension_schema
    FROM pg_extension AS e JOIN pg_namespace AS n ON n.oid = e.extnamespace
   WHERE e.extname = 'unaccent';
  EXECUTE format(
    $fn$
    CREATE FUNCTION vxn_search_text(value TEXT) RETURNS TEXT
      LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE SECURITY DEFINER SET search_path = ''
      AS $body$ SELECT pg_catalog.lower(%1$I.unaccent(%2$L::pg_catalog.regdictionary, value)) $body$
    $fn$,
    extension_schema,
    extension_schema || '.unaccent'
  );
END $$;

-- Tên + địa chỉ, chữ thường, bỏ dấu. Database tự giữ đúng với mọi đường ghi (service, seed, Admin, SQL tay).
ALTER TABLE "stop_points"
  ADD COLUMN "search_text" TEXT GENERATED ALWAYS AS (vxn_search_text("name" || ' ' || "address")) STORED;
ALTER TABLE "stop_points_catalog"
  ADD COLUMN "search_text" TEXT GENERATED ALWAYS AS (vxn_search_text("name" || ' ' || "address")) STORED;
