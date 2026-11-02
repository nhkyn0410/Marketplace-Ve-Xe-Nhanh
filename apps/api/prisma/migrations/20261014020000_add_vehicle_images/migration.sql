-- TASK-TRN-009: ảnh công khai của phương tiện (BR-76, FR-OPS-16). Object nằm ở kho public (ADR-018), bảng này
-- chỉ giữ khóa object, thứ tự và chú thích. Thay bộ ảnh = xóa + ghi lại trong một transaction ở service.

CREATE TABLE "vehicle_images" (
    "id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "vehicle_id" TEXT NOT NULL,
    "object_key" TEXT NOT NULL,
    "position" INTEGER NOT NULL,
    "caption" TEXT,
    "size_bytes" INTEGER NOT NULL,
    "content_type" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "vehicle_images_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "vehicle_images_object_key_key" ON "vehicle_images"("object_key");
CREATE UNIQUE INDEX "vehicle_images_vehicle_id_position_key" ON "vehicle_images"("vehicle_id", "position");
CREATE INDEX "vehicle_images_operator_id_idx" ON "vehicle_images"("operator_id");

-- FK ghép (vehicle_id, operator_id): ảnh không gắn được vào xe của nhà xe khác. RESTRICT — service tự xóa ảnh.
ALTER TABLE "vehicle_images" ADD CONSTRAINT "vehicle_images_vehicle_id_operator_id_fkey"
  FOREIGN KEY ("vehicle_id", "operator_id") REFERENCES "vehicles"("id", "operator_id")
  ON DELETE RESTRICT ON UPDATE RESTRICT;

-- BR-76 giữ ở DB để mọi đường ghi (kể cả ghi thẳng) đều không vượt: tối đa 8 ảnh / xe (vị trí 0–7), mỗi ảnh
-- 1 byte – 5 MB, chỉ JPEG / PNG / WebP, chú thích 1–60 ký tự hoặc NULL.
ALTER TABLE "vehicle_images" ADD CONSTRAINT "vehicle_images_position_range" CHECK ("position" BETWEEN 0 AND 7);
ALTER TABLE "vehicle_images" ADD CONSTRAINT "vehicle_images_size_range" CHECK ("size_bytes" BETWEEN 1 AND 5242880);
ALTER TABLE "vehicle_images" ADD CONSTRAINT "vehicle_images_content_type_allowed"
  CHECK ("content_type" IN ('image/jpeg', 'image/png', 'image/webp'));
ALTER TABLE "vehicle_images" ADD CONSTRAINT "vehicle_images_caption_length"
  CHECK ("caption" IS NULL OR (char_length("caption") BETWEEN 1 AND 60 AND btrim("caption") <> ''));

-- Tenant RLS (ADR-011): nhà xe chỉ thấy / ghi ảnh của mình; scope platform (Admin gỡ ảnh — ADM-003) và system
-- (job dọn object mồ côi) đi qua `app_rls_allows`.
ALTER TABLE "vehicle_images" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "vehicle_images" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "vehicle_images"
  USING (app_rls_allows("operator_id"))
  WITH CHECK (app_rls_allows("operator_id"));
