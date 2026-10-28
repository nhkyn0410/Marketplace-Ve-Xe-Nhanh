-- Người đi cùng trên chỗ đôi (BR-78 bổ sung — Khanh 28/10/2026, chờ duyệt): không bắt buộc, chỉ họ tên, chung vé / QR với
-- người đứng tên. Chỉ chỗ giường đôi / cabin đôi được có tên này.
ALTER TABLE "passenger_infos" ADD COLUMN "companion_name" TEXT;

ALTER TABLE "passenger_infos" ADD CONSTRAINT "passenger_infos_companion_double_seat" CHECK (
  "companion_name" IS NULL
  OR ("seat_type" IN ('BED_DOUBLE', 'CABIN_DOUBLE') AND char_length(btrim("companion_name")) BETWEEN 1 AND 100)
);
