-- TASK-ADM-004 — Admin quản lý điểm dừng (BR-38, BR-81; DB §5.2, §7; phần TASK-TRN-012 để lại cho task này):
--   `stop_points_catalog` thêm căn cứ công bố + CHECK loại điểm dùng chung + index lọc theo tỉnh / loại / trạng thái.
--
-- KHÔNG bọc `BEGIN` / `COMMIT` (xem migration `redesign_stop_points`): cả file chạy như một transaction ngầm.

SET LOCAL lock_timeout = '10s';
SELECT set_config('app.scope', 'system', true);

-- Danh mục dùng chung không có văn phòng trung chuyển (BR-38). Môi trường nào còn dòng loại này thì DỪNG để
-- người vận hành xử lý tay — dòng đó có thể đang nằm trong tuyến / chuyến, không tự xóa hay đổi loại.
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM "stop_points_catalog" WHERE "type" = 'OFFICE') THEN
    RAISE EXCEPTION 'stop_points_catalog còn điểm loại OFFICE — đổi loại hoặc xóa trước khi chạy migration ADM-004.';
  END IF;
END $$;

ALTER TABLE "stop_points_catalog" ADD COLUMN "legal_basis" TEXT;
-- Bến xe / điểm dừng đón trả có từ trước (dữ liệu mẫu dev) chưa có căn cứ: đánh dấu để Admin biết mà bổ sung.
UPDATE "stop_points_catalog"
   SET "legal_basis" = 'Chưa khai (điểm có trước khi bắt buộc căn cứ công bố)'
 WHERE "type" IN ('BUS_STATION', 'PICKUP_POINT');

ALTER TABLE "stop_points_catalog" ADD CONSTRAINT "stop_points_catalog_shared_type"
  CHECK ("type" IN ('BUS_STATION', 'PICKUP_POINT', 'REST_STOP'));
-- Bến xe và điểm dừng đón trả bắt buộc căn cứ công bố; trạm dừng nghỉ không bắt buộc. Tối đa 300 ký tự.
ALTER TABLE "stop_points_catalog" ADD CONSTRAINT "stop_points_catalog_legal_basis_present" CHECK (
  ("type" = 'REST_STOP' OR btrim(COALESCE("legal_basis", '')) <> '')
  AND ("legal_basis" IS NULL OR char_length("legal_basis") <= 300)
);

CREATE INDEX "stop_points_catalog_province_id_type_status_idx"
  ON "stop_points_catalog" ("province_id", "type", "status");
