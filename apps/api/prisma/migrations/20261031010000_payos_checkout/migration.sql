-- payOS + cổng demo; giữ provider cũ để không thay đổi dữ liệu lịch sử.
ALTER TYPE "PaymentProvider" ADD VALUE 'PAYOS';
ALTER TYPE "PaymentProvider" ADD VALUE 'DEMO';

-- Không vượt giới hạn số nguyên chính xác ở biên JSON của payOS; không tái sử dụng mã.
CREATE SEQUENCE "payment_provider_order_code_seq" AS BIGINT
  MINVALUE 1 MAXVALUE 9007199254740991 NO CYCLE;
ALTER TABLE "payments"
  ADD COLUMN "provider_order_code" BIGINT,
  ADD COLUMN "checkout" JSONB;
ALTER TABLE "payments" ALTER COLUMN "provider_order_code"
  SET DEFAULT nextval('payment_provider_order_code_seq'::regclass);
ALTER SEQUENCE "payment_provider_order_code_seq" OWNED BY "payments"."provider_order_code";
CREATE UNIQUE INDEX "payments_provider_order_code_key" ON "payments"("provider_order_code");
ALTER TABLE "payments" ADD CONSTRAINT "payments_provider_order_code_range"
  CHECK ("provider_order_code" IS NULL OR "provider_order_code" BETWEEN 1 AND 9007199254740991);
