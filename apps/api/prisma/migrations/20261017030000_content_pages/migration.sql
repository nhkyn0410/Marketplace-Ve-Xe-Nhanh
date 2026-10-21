-- TASK-ADM-003 phần nội dung công khai — banner, câu hỏi thường gặp (FAQ), trang tĩnh (FR-ADM-13, UC-28; Figma
-- ADM-10d "Kiểm duyệt / Nội dung công khai"). Entity `ContentPage` ở `catalog/` (DOMAIN-MAP). Thiết kế AI tự đề xuất,
-- chờ Khanh duyệt (`doc/task-propreties/ADM-003-content-todo.md`). Dữ liệu cấp Platform, KHÔNG `operator_id`: ai cũng
-- đọc (API công khai tự lọc bản đang hiển thị), chỉ scope platform / system ghi (mẫu `articles`).

-- CreateEnum
CREATE TYPE "ContentPageType" AS ENUM ('FAQ', 'BANNER', 'PAGE');

-- CreateEnum — vị trí hiển thị: banner ở trang chủ, trang tĩnh ở chân trang, câu hỏi thường gặp theo nhóm.
CREATE TYPE "ContentPlacement" AS ENUM ('HOME', 'FOOTER', 'BOOKING', 'TICKET', 'ACCOUNT');

-- CreateEnum
CREATE TYPE "ContentPageStatus" AS ENUM ('DRAFT', 'PUBLISHED');

-- CreateTable
CREATE TABLE "content_pages" (
    "id" TEXT NOT NULL,
    "type" "ContentPageType" NOT NULL,
    "placement" "ContentPlacement" NOT NULL,
    "title" TEXT NOT NULL,
    "slug" TEXT,
    "body_markdown" TEXT NOT NULL DEFAULT '',
    "image_key" TEXT,
    "link_url" TEXT,
    "display_order" INTEGER NOT NULL DEFAULT 0,
    "status" "ContentPageStatus" NOT NULL DEFAULT 'DRAFT',
    "published_at" TIMESTAMP(3),
    "created_by" TEXT NOT NULL,
    "updated_by" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "content_pages_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "content_pages_title_length" CHECK (char_length("title") BETWEEN 1 AND 160),
    -- Trang tĩnh có đường dẫn riêng; banner có ảnh (kho công khai) và có thể có liên kết; FAQ / trang tĩnh không có ảnh.
    CONSTRAINT "content_pages_slug_for_page" CHECK (("type" = 'PAGE') = ("slug" IS NOT NULL)),
    CONSTRAINT "content_pages_image_for_banner" CHECK (("type" = 'BANNER') = ("image_key" IS NOT NULL)),
    CONSTRAINT "content_pages_link_for_banner" CHECK ("link_url" IS NULL OR "type" = 'BANNER'),
    CONSTRAINT "content_pages_placement_by_type" CHECK (
      ("type" = 'BANNER' AND "placement" = 'HOME')
      OR ("type" = 'PAGE' AND "placement" = 'FOOTER')
      OR ("type" = 'FAQ' AND "placement" IN ('BOOKING', 'TICKET', 'ACCOUNT'))
    ),
    CONSTRAINT "content_pages_published_at" CHECK (("status" = 'PUBLISHED') = ("published_at" IS NOT NULL))
);

-- CreateIndex
CREATE UNIQUE INDEX "content_pages_slug_key" ON "content_pages"("slug");

-- CreateIndex
CREATE INDEX "content_pages_type_status_placement_display_order_idx" ON "content_pages"("type", "status", "placement", "display_order");

-- CreateIndex
CREATE INDEX "content_pages_updated_at_idx" ON "content_pages"("updated_at" DESC);

-- RLS
ALTER TABLE "content_pages" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "content_pages" FORCE ROW LEVEL SECURITY;
CREATE POLICY "public_read" ON "content_pages" FOR SELECT USING (true);
CREATE POLICY "platform_insert" ON "content_pages" FOR INSERT
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
CREATE POLICY "platform_update" ON "content_pages" FOR UPDATE
  USING (current_setting('app.scope', true) IN ('platform', 'system'))
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
CREATE POLICY "platform_delete" ON "content_pages" FOR DELETE
  USING (current_setting('app.scope', true) IN ('platform', 'system'));
