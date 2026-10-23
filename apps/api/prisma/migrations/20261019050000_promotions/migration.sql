-- TASK-PROM-001 (khuyến mãi — FR-PROM-01..07, FR-MKT-10, BR-46/47/48, UC-33). Khanh 18/10/2026 (LLD-OQ-07): khuyến mãi cấp nền
-- tảng do NHÀ XE chịu phần giảm và nhà xe phải tham gia. Cột AI tự đề xuất theo Figma ADM-11a/b, "Nhà xe · Khuyến mãi", chờ Khanh
-- duyệt (`doc/task-propreties/PROM-001-todo.md`).

-- CreateEnum
CREATE TYPE "PromotionScope" AS ENUM ('PLATFORM', 'OPERATOR');

-- CreateEnum
CREATE TYPE "DiscountType" AS ENUM ('PERCENT', 'AMOUNT');

-- CreateEnum
CREATE TYPE "PromotionStatus" AS ENUM ('DRAFT', 'ACTIVE', 'PAUSED', 'ENDED');

-- CreateEnum
CREATE TYPE "RedemptionStatus" AS ENUM ('RESERVED', 'USED', 'RELEASED');

-- CreateEnum
CREATE TYPE "DiscountFunding" AS ENUM ('OPERATOR', 'PLATFORM');

-- CreateTable
CREATE TABLE "promotion_permissions" (
    "operator_id" TEXT NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT false,
    "max_percent" INTEGER,
    "max_amount" BIGINT,
    "route_ids" TEXT[],
    "max_duration_days" INTEGER NOT NULL DEFAULT 30,
    "monthly_budget" BIGINT,
    "updated_by" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "promotion_permissions_pkey" PRIMARY KEY ("operator_id")
);

-- CreateTable
CREATE TABLE "promotions" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "scope" "PromotionScope" NOT NULL,
    "operator_id" TEXT,
    "discount_type" "DiscountType" NOT NULL,
    "discount_value" BIGINT NOT NULL,
    "max_discount" BIGINT,
    "min_order" BIGINT NOT NULL DEFAULT 0,
    "route_id" TEXT,
    "trip_id" TEXT,
    "starts_at" TIMESTAMP(3) NOT NULL,
    "ends_at" TIMESTAMP(3) NOT NULL,
    "usage_limit" INTEGER NOT NULL,
    "used_count" INTEGER NOT NULL DEFAULT 0,
    "status" "PromotionStatus" NOT NULL DEFAULT 'DRAFT',
    "created_by" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "promotions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "promotion_participations" (
    "promotion_id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "joined_by" TEXT NOT NULL,
    "joined_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "promotion_participations_pkey" PRIMARY KEY ("promotion_id","operator_id")
);

-- CreateTable
CREATE TABLE "promotion_redemptions" (
    "id" TEXT NOT NULL,
    "promotion_id" TEXT NOT NULL,
    "operator_id" TEXT NOT NULL,
    "booking_id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "discount" BIGINT NOT NULL,
    "funded_by" "DiscountFunding" NOT NULL,
    "status" "RedemptionStatus" NOT NULL DEFAULT 'RESERVED',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "promotion_redemptions_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "promotions_code_key" ON "promotions"("code");

-- CreateIndex
CREATE INDEX "promotions_scope_status_idx" ON "promotions"("scope", "status");

-- CreateIndex
CREATE INDEX "promotions_operator_id_status_idx" ON "promotions"("operator_id", "status");

-- CreateIndex
CREATE INDEX "promotion_participations_operator_id_idx" ON "promotion_participations"("operator_id");

-- CreateIndex
CREATE UNIQUE INDEX "promotion_redemptions_booking_id_key" ON "promotion_redemptions"("booking_id");

-- CreateIndex
CREATE INDEX "promotion_redemptions_promotion_id_status_idx" ON "promotion_redemptions"("promotion_id", "status");

-- CreateIndex
CREATE INDEX "promotion_redemptions_operator_id_created_at_idx" ON "promotion_redemptions"("operator_id", "created_at");

-- AddForeignKey
ALTER TABLE "promotion_permissions" ADD CONSTRAINT "promotion_permissions_operator_id_fkey" FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "promotions" ADD CONSTRAINT "promotions_operator_id_fkey" FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "promotion_participations" ADD CONSTRAINT "promotion_participations_promotion_id_fkey" FOREIGN KEY ("promotion_id") REFERENCES "promotions"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "promotion_participations" ADD CONSTRAINT "promotion_participations_operator_id_fkey" FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "promotion_redemptions" ADD CONSTRAINT "promotion_redemptions_promotion_id_fkey" FOREIGN KEY ("promotion_id") REFERENCES "promotions"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "promotion_redemptions" ADD CONSTRAINT "promotion_redemptions_booking_id_operator_id_fkey" FOREIGN KEY ("booking_id", "operator_id") REFERENCES "bookings"("id", "operator_id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Ràng buộc
ALTER TABLE "promotion_permissions"
    ADD CONSTRAINT "promotion_permissions_max_percent" CHECK ("max_percent" IS NULL OR "max_percent" BETWEEN 1 AND 100),
    ADD CONSTRAINT "promotion_permissions_max_amount" CHECK ("max_amount" IS NULL OR "max_amount" > 0),
    ADD CONSTRAINT "promotion_permissions_duration" CHECK ("max_duration_days" BETWEEN 1 AND 366),
    ADD CONSTRAINT "promotion_permissions_budget" CHECK ("monthly_budget" IS NULL OR "monthly_budget" > 0),
    -- Bật quyền phải có ít nhất một mức giảm tối đa.
    ADD CONSTRAINT "promotion_permissions_enabled_cap" CHECK (NOT "enabled" OR "max_percent" IS NOT NULL OR "max_amount" IS NOT NULL);
ALTER TABLE "promotions"
    ADD CONSTRAINT "promotions_code_format" CHECK ("code" ~ '^[A-Z0-9]{3,20}$'),
    ADD CONSTRAINT "promotions_name" CHECK (char_length(btrim("name")) BETWEEN 3 AND 120),
    ADD CONSTRAINT "promotions_scope_operator" CHECK (("scope" = 'OPERATOR') = ("operator_id" IS NOT NULL)),
    -- Tuyến / chuyến chỉ cho khuyến mãi của nhà xe.
    ADD CONSTRAINT "promotions_route_scope" CHECK ("scope" = 'OPERATOR' OR ("route_id" IS NULL AND "trip_id" IS NULL)),
    ADD CONSTRAINT "promotions_discount" CHECK (
        ("discount_type" = 'PERCENT' AND "discount_value" BETWEEN 1 AND 100)
        OR ("discount_type" = 'AMOUNT' AND "discount_value" > 0 AND "max_discount" IS NULL)
    ),
    ADD CONSTRAINT "promotions_max_discount" CHECK ("max_discount" IS NULL OR "max_discount" > 0),
    ADD CONSTRAINT "promotions_min_order" CHECK ("min_order" >= 0),
    ADD CONSTRAINT "promotions_window" CHECK ("ends_at" > "starts_at"),
    ADD CONSTRAINT "promotions_usage" CHECK ("usage_limit" BETWEEN 1 AND 1000000 AND "used_count" BETWEEN 0 AND "usage_limit");
ALTER TABLE "promotion_redemptions"
    ADD CONSTRAINT "promotion_redemptions_discount" CHECK ("discount" > 0);

-- Giữ / trả lượt dùng của một khuyến mãi NGUYÊN TỬ, kể cả khuyến mãi cấp nền tảng mà tenant không được ghi (luồng đặt vé chạy ở
-- tenant của nhà xe). SECURITY DEFINER + đổi scope về `system` chỉ trong lời gọi: hàm chỉ đổi đúng cột `used_count` của đúng một
-- dòng theo điều kiện, không trả dữ liệu nào khác.
CREATE FUNCTION promotion_claim(p_promotion_id text) RETURNS boolean
LANGUAGE plpgsql SECURITY DEFINER SET search_path FROM CURRENT AS $$
DECLARE
  previous text := current_setting('app.scope', true);
  claimed boolean;
BEGIN
  PERFORM set_config('app.scope', 'system', true);
  UPDATE "promotions" SET "used_count" = "used_count" + 1
    WHERE "id" = p_promotion_id AND "status" = 'ACTIVE' AND "used_count" < "usage_limit"
    RETURNING true INTO claimed;
  PERFORM set_config('app.scope', coalesce(previous, ''), true);
  RETURN coalesce(claimed, false);
END $$;

CREATE FUNCTION promotion_release(p_promotion_id text) RETURNS void
LANGUAGE plpgsql SECURITY DEFINER SET search_path FROM CURRENT AS $$
DECLARE
  previous text := current_setting('app.scope', true);
BEGIN
  PERFORM set_config('app.scope', 'system', true);
  UPDATE "promotions" SET "used_count" = "used_count" - 1 WHERE "id" = p_promotion_id AND "used_count" > 0;
  PERFORM set_config('app.scope', coalesce(previous, ''), true);
END $$;

-- RLS
ALTER TABLE "promotion_permissions" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "promotion_permissions" FORCE ROW LEVEL SECURITY;
-- Nhà xe chỉ đọc quyền của mình; chỉ Admin cấu hình.
CREATE POLICY "tenant_read" ON "promotion_permissions" FOR SELECT USING (app_rls_allows("operator_id"));
CREATE POLICY "platform_insert" ON "promotion_permissions" FOR INSERT WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
CREATE POLICY "platform_update" ON "promotion_permissions" FOR UPDATE
  USING (current_setting('app.scope', true) IN ('platform', 'system'))
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
CREATE POLICY "platform_delete" ON "promotion_permissions" FOR DELETE USING (current_setting('app.scope', true) IN ('platform', 'system'));

ALTER TABLE "promotions" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "promotions" FORCE ROW LEVEL SECURITY;
-- Nhà xe đọc khuyến mãi nền tảng (để tham gia / áp mã) + của mình; ghi chỉ của mình (app_rls_allows(NULL) = false với tenant).
CREATE POLICY "tenant_read" ON "promotions" FOR SELECT USING ("operator_id" IS NULL OR app_rls_allows("operator_id"));
CREATE POLICY "tenant_insert" ON "promotions" FOR INSERT WITH CHECK (app_rls_allows("operator_id"));
CREATE POLICY "tenant_update" ON "promotions" FOR UPDATE USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
CREATE POLICY "tenant_delete" ON "promotions" FOR DELETE USING (app_rls_allows("operator_id"));

ALTER TABLE "promotion_participations" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "promotion_participations" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "promotion_participations" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));

ALTER TABLE "promotion_redemptions" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "promotion_redemptions" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "promotion_redemptions" USING (app_rls_allows("operator_id")) WITH CHECK (app_rls_allows("operator_id"));
