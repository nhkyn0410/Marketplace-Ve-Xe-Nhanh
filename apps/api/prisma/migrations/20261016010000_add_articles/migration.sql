-- TASK-CNT-001: bài viết tin tức / cẩm nang cho trang Khám phá (FR-ADM-18..19, FR-MKT-14, BR-74, DB §5.2 Content).
-- Dữ liệu cấp Platform, KHÔNG `operator_id`. Nội dung Markdown; ảnh bìa = khóa object ở kho công khai (ADR-018).

CREATE TYPE "ArticleStatus" AS ENUM ('DRAFT', 'PUBLISHED', 'ARCHIVED');

CREATE TABLE "article_categories" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "display_order" INTEGER NOT NULL DEFAULT 0,
    "status" "CatalogStatus" NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "article_categories_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "article_categories_slug_key" ON "article_categories"("slug");

CREATE TABLE "articles" (
    "id" TEXT NOT NULL,
    "category_id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "summary" TEXT NOT NULL,
    "content_markdown" TEXT NOT NULL,
    "cover_image_key" TEXT,
    "featured" BOOLEAN NOT NULL DEFAULT false,
    "status" "ArticleStatus" NOT NULL DEFAULT 'DRAFT',
    "published_at" TIMESTAMP(3),
    "view_count" INTEGER NOT NULL DEFAULT 0,
    "created_by" TEXT NOT NULL,
    "updated_by" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "articles_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "articles_slug_key" ON "articles"("slug");
CREATE INDEX "articles_status_published_at_idx" ON "articles"("status", "published_at" DESC);
CREATE INDEX "articles_category_id_status_published_at_idx" ON "articles"("category_id", "status", "published_at" DESC);

ALTER TABLE "articles" ADD CONSTRAINT "articles_category_id_fkey"
  FOREIGN KEY ("category_id") REFERENCES "article_categories"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- BR-74 + DB §7: bài đã xuất bản phải có thời điểm xuất bản; slug chữ thường không dấu nối bằng gạch ngang.
ALTER TABLE "articles" ADD CONSTRAINT "articles_published_has_time" CHECK ("status" <> 'PUBLISHED' OR "published_at" IS NOT NULL);
ALTER TABLE "articles" ADD CONSTRAINT "articles_slug_format" CHECK ("slug" ~ '^[a-z0-9]+(-[a-z0-9]+)*$' AND char_length("slug") <= 120);
ALTER TABLE "articles" ADD CONSTRAINT "articles_title_length" CHECK (char_length(btrim("title")) BETWEEN 1 AND 200);
ALTER TABLE "articles" ADD CONSTRAINT "articles_summary_length" CHECK (char_length(btrim("summary")) BETWEEN 1 AND 300);
ALTER TABLE "articles" ADD CONSTRAINT "articles_content_length" CHECK (char_length("content_markdown") <= 50000);
ALTER TABLE "articles" ADD CONSTRAINT "articles_view_count_non_negative" CHECK ("view_count" >= 0);
ALTER TABLE "article_categories" ADD CONSTRAINT "article_categories_slug_format" CHECK ("slug" ~ '^[a-z0-9]+(-[a-z0-9]+)*$' AND char_length("slug") <= 60);
ALTER TABLE "article_categories" ADD CONSTRAINT "article_categories_name_length" CHECK (char_length(btrim("name")) BETWEEN 1 AND 60);

-- RLS như catalog (DB §7): ai cũng ĐỌC (API công khai tự lọc `PUBLISHED`), chỉ platform / system được GHI.
ALTER TABLE "article_categories" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "article_categories" FORCE ROW LEVEL SECURITY;
CREATE POLICY "public_read" ON "article_categories" FOR SELECT USING (true);
CREATE POLICY "platform_insert" ON "article_categories" FOR INSERT
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
CREATE POLICY "platform_update" ON "article_categories" FOR UPDATE
  USING (current_setting('app.scope', true) IN ('platform', 'system'))
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
CREATE POLICY "platform_delete" ON "article_categories" FOR DELETE
  USING (current_setting('app.scope', true) IN ('platform', 'system'));

ALTER TABLE "articles" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "articles" FORCE ROW LEVEL SECURITY;
CREATE POLICY "public_read" ON "articles" FOR SELECT USING (true);
CREATE POLICY "platform_insert" ON "articles" FOR INSERT
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
CREATE POLICY "platform_update" ON "articles" FOR UPDATE
  USING (current_setting('app.scope', true) IN ('platform', 'system'))
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
CREATE POLICY "platform_delete" ON "articles" FOR DELETE
  USING (current_setting('app.scope', true) IN ('platform', 'system'));

-- DB-MIG-07 (phần bài viết): chuyên mục mặc định.
INSERT INTO "article_categories" ("id", "name", "slug", "display_order", "updated_at") VALUES
  (gen_random_uuid()::text, 'Tin tức', 'tin-tuc', 1, CURRENT_TIMESTAMP),
  (gen_random_uuid()::text, 'Cẩm nang', 'cam-nang', 2, CURRENT_TIMESTAMP),
  (gen_random_uuid()::text, 'Khuyến mãi', 'khuyen-mai', 3, CURRENT_TIMESTAMP),
  (gen_random_uuid()::text, 'Mẹo du lịch', 'meo-du-lich', 4, CURRENT_TIMESTAMP),
  (gen_random_uuid()::text, 'VXN', 'vxn', 5, CURRENT_TIMESTAMP)
ON CONFLICT ("slug") DO NOTHING;
