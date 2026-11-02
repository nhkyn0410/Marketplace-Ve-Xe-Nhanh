-- PROM-002 / LOY-001: ví cấp nền tảng, giữ / dùng / trả cùng transaction của booking.
CREATE TYPE "UserVoucherSource" AS ENUM ('LOYALTY_REDEMPTION', 'SAVED_PROMOTION');
CREATE TYPE "UserVoucherStatus" AS ENUM ('AVAILABLE', 'RESERVED', 'USED', 'EXPIRED');
ALTER TABLE "promotions" ADD COLUMN "route_ids" TEXT[] NOT NULL DEFAULT '{}';
ALTER TABLE "promotion_redemptions" ALTER COLUMN "promotion_id" DROP NOT NULL;
ALTER TABLE "promotion_redemptions" ADD COLUMN "user_voucher_id" TEXT;

CREATE TABLE "user_vouchers" (
  "id" TEXT PRIMARY KEY,
  "user_id" TEXT NOT NULL REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
  "source" "UserVoucherSource" NOT NULL,
  "promotion_id" TEXT REFERENCES "promotions"("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
  "discount_amount" BIGINT,
  "loyalty_transaction_id" TEXT UNIQUE REFERENCES "loyalty_point_transactions"("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
  "policy_version" INTEGER,
  "status" "UserVoucherStatus" NOT NULL DEFAULT 'AVAILABLE',
  "booking_id" TEXT UNIQUE REFERENCES "bookings"("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
  "expires_at" TIMESTAMP(3) NOT NULL,
  "used_at" TIMESTAMP(3),
  "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "user_vouchers_source" CHECK (
    ("source" = 'LOYALTY_REDEMPTION' AND "discount_amount" IS NOT NULL AND "discount_amount" > 0 AND "promotion_id" IS NULL AND "loyalty_transaction_id" IS NOT NULL)
    OR ("source" = 'SAVED_PROMOTION' AND "promotion_id" IS NOT NULL AND "discount_amount" IS NULL AND "loyalty_transaction_id" IS NULL)
  ),
  CONSTRAINT "user_vouchers_booking" CHECK (("status" IN ('RESERVED', 'USED')) = ("booking_id" IS NOT NULL))
);
CREATE UNIQUE INDEX "user_vouchers_saved_promotion_key" ON "user_vouchers"("user_id", "promotion_id") WHERE "source" = 'SAVED_PROMOTION';
CREATE INDEX "user_vouchers_user_id_status_expires_at_idx" ON "user_vouchers"("user_id", "status", "expires_at");
ALTER TABLE "promotion_redemptions" ADD CONSTRAINT "promotion_redemptions_voucher_fkey" FOREIGN KEY ("user_voucher_id") REFERENCES "user_vouchers"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "promotion_redemptions" ADD CONSTRAINT "promotion_redemptions_source" CHECK ("promotion_id" IS NOT NULL OR "user_voucher_id" IS NOT NULL);

ALTER TABLE "user_vouchers" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "user_vouchers" FORCE ROW LEVEL SECURITY;
CREATE POLICY "platform_only" ON "user_vouchers"
  USING (current_setting('app.scope', true) IN ('platform', 'system'))
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));

-- Tenant không đọc ví trực tiếp. Hàm chỉ đọc đúng ID + chủ sở hữu do token xác thực cung cấp.
CREATE FUNCTION voucher_offer(p_id text, p_user_id text) RETURNS SETOF "user_vouchers"
LANGUAGE plpgsql SECURITY DEFINER SET search_path FROM CURRENT AS $$
DECLARE previous text := current_setting('app.scope', true);
BEGIN
  PERFORM set_config('app.scope', 'system', true);
  RETURN QUERY SELECT * FROM "user_vouchers" WHERE id = p_id AND user_id = p_user_id;
  PERFORM set_config('app.scope', coalesce(previous, ''), true);
END $$;

-- Khóa CAS: không thể giữ một voucher cho hai booking; booking phải đúng hành khách và tenant gọi.
CREATE FUNCTION voucher_reserve(p_id text, p_user_id text, p_booking_id text, p_operator_id text, p_now timestamp) RETURNS boolean
LANGUAGE plpgsql SECURITY DEFINER SET search_path FROM CURRENT AS $$
DECLARE previous text := current_setting('app.scope', true); changed boolean;
BEGIN
  IF previous = 'tenant' AND current_setting('app.operator_id', true) IS DISTINCT FROM p_operator_id THEN RETURN false; END IF;
  IF NOT EXISTS (SELECT 1 FROM "bookings" WHERE id = p_booking_id AND operator_id = p_operator_id AND user_id = p_user_id) THEN RETURN false; END IF;
  PERFORM set_config('app.scope', 'system', true);
  UPDATE "user_vouchers" SET status = 'RESERVED', booking_id = p_booking_id, updated_at = p_now
    WHERE id = p_id AND user_id = p_user_id AND status = 'AVAILABLE' AND expires_at > p_now RETURNING true INTO changed;
  PERFORM set_config('app.scope', coalesce(previous, ''), true);
  RETURN coalesce(changed, false);
END $$;

-- Không trả dữ liệu ví; chỉ đổi voucher gắn booking mà tenant hiện tại sở hữu.
CREATE FUNCTION voucher_transition(p_booking_id text, p_operator_id text, p_action text, p_now timestamp) RETURNS void
LANGUAGE plpgsql SECURITY DEFINER SET search_path FROM CURRENT AS $$
DECLARE previous text := current_setting('app.scope', true);
BEGIN
  IF previous = 'tenant' AND current_setting('app.operator_id', true) IS DISTINCT FROM p_operator_id THEN RETURN; END IF;
  IF NOT EXISTS (SELECT 1 FROM "bookings" WHERE id = p_booking_id AND operator_id = p_operator_id) THEN RETURN; END IF;
  PERFORM set_config('app.scope', 'system', true);
  IF p_action = 'USE' THEN
    UPDATE "user_vouchers" SET status = 'USED', used_at = p_now, updated_at = p_now WHERE booking_id = p_booking_id AND status = 'RESERVED';
  ELSIF p_action = 'RELEASE' OR p_action = 'TRIP_CANCELLED' THEN
    UPDATE "user_vouchers" SET status = CASE WHEN expires_at > p_now THEN 'AVAILABLE'::"UserVoucherStatus" ELSE 'EXPIRED'::"UserVoucherStatus" END,
      booking_id = NULL, used_at = NULL, updated_at = p_now
      WHERE booking_id = p_booking_id AND (status = 'RESERVED' OR (p_action = 'TRIP_CANCELLED' AND status = 'USED'));
  END IF;
  PERFORM set_config('app.scope', coalesce(previous, ''), true);
END $$;

-- Thanh toán thử lại sau lần thất bại: chỉ lấy lại voucher + lượt promotion nếu cả hai còn dùng được.
CREATE FUNCTION voucher_reclaim(p_booking_id text, p_operator_id text, p_now timestamp) RETURNS boolean
LANGUAGE plpgsql SECURITY DEFINER SET search_path FROM CURRENT AS $$
DECLARE previous text := current_setting('app.scope', true); v "user_vouchers"; r "promotion_redemptions"; p "promotions"; owner_id text;
BEGIN
  IF previous = 'tenant' AND current_setting('app.operator_id', true) IS DISTINCT FROM p_operator_id THEN RETURN false; END IF;
  SELECT * INTO r FROM promotion_redemptions WHERE booking_id = p_booking_id AND operator_id = p_operator_id;
  IF r.user_voucher_id IS NULL OR r.status <> 'RELEASED' THEN RETURN true; END IF;
  SELECT user_id INTO owner_id FROM bookings WHERE id = p_booking_id AND operator_id = p_operator_id;
  IF owner_id IS NULL THEN RETURN false; END IF;
  PERFORM set_config('app.scope', 'system', true);
  SELECT * INTO v FROM user_vouchers WHERE id = r.user_voucher_id AND user_id = owner_id FOR UPDATE;
  IF v.id IS NULL OR v.status <> 'AVAILABLE' OR v.expires_at <= p_now THEN
    PERFORM set_config('app.scope', coalesce(previous, ''), true); RETURN false;
  END IF;
  IF r.promotion_id IS NOT NULL THEN
    SELECT * INTO p FROM promotions WHERE id = r.promotion_id FOR UPDATE;
    IF p.id IS NULL OR p.status <> 'ACTIVE' OR p.starts_at > p_now OR p.ends_at <= p_now OR p.used_count >= p.usage_limit
      OR (p.scope = 'PLATFORM' AND NOT EXISTS (SELECT 1 FROM promotion_participations WHERE promotion_id = p.id AND operator_id = p_operator_id)) THEN
      PERFORM set_config('app.scope', coalesce(previous, ''), true); RETURN false;
    END IF;
    UPDATE promotions SET used_count = used_count + 1 WHERE id = p.id;
  END IF;
  UPDATE user_vouchers SET status = 'RESERVED', booking_id = p_booking_id, updated_at = p_now WHERE id = v.id;
  UPDATE promotion_redemptions SET status = 'RESERVED', updated_at = p_now WHERE id = r.id;
  PERFORM set_config('app.scope', coalesce(previous, ''), true);
  RETURN true;
END $$;

-- Một bút toán trợ giá mỗi payment / refund; tính tiền vẫn dùng BIGINT.
CREATE UNIQUE INDEX "escrow_platform_discount_payment_key" ON "escrow_ledgers"("payment_id") WHERE "entry_type" = 'PLATFORM_FUNDED_DISCOUNT';
CREATE UNIQUE INDEX "escrow_platform_discount_refund_key" ON "escrow_ledgers"("refund_id") WHERE "entry_type" = 'PLATFORM_FUNDED_DISCOUNT_REVERSAL';
ALTER TABLE "escrow_ledgers" DROP CONSTRAINT "escrow_ledgers_sign";
ALTER TABLE "escrow_ledgers" DROP CONSTRAINT "escrow_ledgers_links";
ALTER TABLE "escrow_ledgers" ADD CONSTRAINT "escrow_ledgers_links" CHECK (
  (entry_type IN ('PAYMENT_CAPTURED', 'COMMISSION', 'PLATFORM_FUNDED_DISCOUNT') AND payment_id IS NOT NULL AND booking_id IS NOT NULL)
  OR (entry_type IN ('REFUND', 'COMMISSION_REVERSAL', 'PLATFORM_FUNDED_DISCOUNT_REVERSAL') AND refund_id IS NOT NULL AND booking_id IS NOT NULL)
  OR (entry_type = 'PAYOUT' AND payout_id IS NOT NULL)
  OR (entry_type = 'ADJUSTMENT' AND note IS NOT NULL)
);
ALTER TABLE "escrow_ledgers" ADD CONSTRAINT "escrow_ledgers_sign" CHECK (
  (entry_type IN ('PAYMENT_CAPTURED', 'COMMISSION_REVERSAL', 'PLATFORM_FUNDED_DISCOUNT') AND amount > 0)
  OR (entry_type IN ('COMMISSION', 'REFUND', 'PAYOUT', 'PLATFORM_FUNDED_DISCOUNT_REVERSAL') AND amount < 0)
  OR (entry_type = 'ADJUSTMENT' AND amount <> 0)
);
