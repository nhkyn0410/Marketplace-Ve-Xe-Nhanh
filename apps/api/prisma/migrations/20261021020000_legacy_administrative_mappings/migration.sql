-- Bảng đối chiếu địa giới hành chính trước sáp nhập 2025 (`legacy_administrative_mappings`):
--   1. Lưu ánh xạ từ 63 tỉnh/thành phố cũ, quận/huyện/TX/TP thuộc tỉnh cũ và phường/xã cũ sang `province_id` và `ward_id` mới.
--   2. Khóa ngoại ghép (`ward_id`, `province_id`) REFERENCES `wards`(`id`, `province_id`) đảm bảo toàn vẹn tỉnh-phường.
--   3. Cột sinh `search_text` (`vxn_search_text(...)`) hỗ trợ tìm kiếm không dấu theo tên địa danh hành chính cũ.
--   4. Bật ENABLE + FORCE RLS theo chuẩn bảng Catalog (`public_read`, `platform_insert`, `platform_update`, `platform_delete`).

SET LOCAL lock_timeout = '10s';
SELECT set_config('app.scope', 'system', true);

CREATE TABLE "legacy_administrative_mappings" (
    "id" TEXT NOT NULL,
    "legacy_province_code" TEXT NOT NULL,
    "legacy_province_name" TEXT NOT NULL,
    "legacy_district_name" TEXT NOT NULL DEFAULT '',
    "legacy_ward_name" TEXT NOT NULL DEFAULT '',
    "province_id" TEXT NOT NULL,
    "ward_id" TEXT NOT NULL,
    "notes" TEXT,
    "search_text" TEXT GENERATED ALWAYS AS (
        vxn_search_text("legacy_province_name" || ' ' || "legacy_district_name" || ' ' || "legacy_ward_name")
    ) STORED,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "legacy_administrative_mappings_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "legacy_administrative_mappings_legacy_province_code_legacy__key"
    ON "legacy_administrative_mappings"("legacy_province_code", "legacy_district_name", "legacy_ward_name");

CREATE INDEX "legacy_administrative_mappings_province_id_idx"
    ON "legacy_administrative_mappings"("province_id");

CREATE INDEX "legacy_administrative_mappings_ward_id_idx"
    ON "legacy_administrative_mappings"("ward_id");

ALTER TABLE "legacy_administrative_mappings"
    ADD CONSTRAINT "legacy_administrative_mappings_ward_id_province_id_fkey"
    FOREIGN KEY ("ward_id", "province_id")
    REFERENCES "wards"("id", "province_id")
    ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE "legacy_administrative_mappings" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "legacy_administrative_mappings" FORCE ROW LEVEL SECURITY;

CREATE POLICY "public_read" ON "legacy_administrative_mappings" FOR SELECT
    USING (true);

CREATE POLICY "platform_insert" ON "legacy_administrative_mappings" FOR INSERT
    WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));

CREATE POLICY "platform_update" ON "legacy_administrative_mappings" FOR UPDATE
    USING (current_setting('app.scope', true) IN ('platform', 'system'))
    WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));

CREATE POLICY "platform_delete" ON "legacy_administrative_mappings" FOR DELETE
    USING (current_setting('app.scope', true) IN ('platform', 'system'));
