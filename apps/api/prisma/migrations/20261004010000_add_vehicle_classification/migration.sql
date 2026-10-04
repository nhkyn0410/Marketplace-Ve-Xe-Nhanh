-- TASK-TRN-010 — Phân loại xe và loại chỗ (BR-77, BR-78; DB §5.2, §7).
--
-- `vehicle_types` thêm hai thuộc tính độc lập: dạng chỗ (`form`) và hạng xe (`class`). Limousine là
-- hạng, không còn là một loại ngang hàng với ghế ngồi / giường nằm / cabin: mã `LIMOUSINE` cũ đổi
-- thành `SEATER_LIMOUSINE` và giữ nguyên `id`, nên xe đang gắn loại này không đổi gì.
-- Hai loại mới `SLEEPER_LIMOUSINE`, `CABIN_LIMOUSINE` do `db:seed:catalog` tạo (create-only) —
-- chạy seed sau migration này.
--
-- Enum `SeatType` thêm `BED_DOUBLE`, `CABIN`, `CABIN_DOUBLE`. Giá trị enum mới chưa dùng được trong
-- chính transaction thêm nó (Postgres), và migration này không dùng.
--
-- Migration DỪNG (không đổi gì) nếu `vehicle_types` có mã ngoài 4 mã seed cũ: không đoán dạng chỗ /
-- hạng xe cho dòng lạ.
--
-- KHÔNG bọc `BEGIN` / `COMMIT`: Prisma gửi cả file trong một lệnh nhiều câu, Postgres chạy nó như một
-- transaction ngầm — lỗi ở đâu cũng hoàn tác toàn bộ, và `SET LOCAL` / `set_config(…, true)` vẫn có
-- hiệu lực tới hết file. Bọc `BEGIN` tường minh thì khi `RAISE` bên dưới chạy, kết nối kẹt ở
-- transaction hỏng và Prisma chỉ báo "current transaction is aborted", mất thông báo thật.

SET LOCAL lock_timeout = '10s';

-- Migration DML must also work when the migration owner is subject to FORCE RLS: `vehicle_types`
-- chỉ cho scope platform / system ghi, thiếu dòng này UPDATE lặng lẽ khớp 0 dòng.
SELECT set_config('app.scope', 'system', true);

DO $$
DECLARE
  unknown TEXT;
BEGIN
  SELECT string_agg("code", ', ' ORDER BY "code")
    INTO unknown
    FROM "vehicle_types"
   WHERE "code" NOT IN ('SEATER', 'SLEEPER', 'CABIN', 'LIMOUSINE');
  IF unknown IS NOT NULL THEN
    RAISE EXCEPTION USING
      ERRCODE = '23514',
      MESSAGE = 'TASK-TRN-010 migration blocked: vehicle_types has codes with no known form/class: ' || unknown,
      HINT = 'Delete leftover test rows, or classify them by hand, then re-run the migration.';
  END IF;
END $$;

-- CreateEnum
CREATE TYPE "VehicleForm" AS ENUM ('SEATER', 'SLEEPER', 'CABIN');

-- CreateEnum
CREATE TYPE "VehicleClass" AS ENUM ('STANDARD', 'LIMOUSINE');

-- AlterEnum
ALTER TYPE "SeatType" ADD VALUE 'BED_DOUBLE';
ALTER TYPE "SeatType" ADD VALUE 'CABIN';
ALTER TYPE "SeatType" ADD VALUE 'CABIN_DOUBLE';

-- AlterTable — thêm cột cho phép NULL, điền dữ liệu, rồi khoá NOT NULL. Không đặt default: mọi đường
-- ghi về sau phải khai rõ cả hai thuộc tính.
ALTER TABLE "vehicle_types"
  ADD COLUMN "form" "VehicleForm",
  ADD COLUMN "class" "VehicleClass";

UPDATE "vehicle_types" SET "form" = 'SEATER', "class" = 'STANDARD' WHERE "code" = 'SEATER';
UPDATE "vehicle_types" SET "form" = 'SLEEPER', "class" = 'STANDARD' WHERE "code" = 'SLEEPER';
UPDATE "vehicle_types" SET "form" = 'CABIN', "class" = 'STANDARD' WHERE "code" = 'CABIN';
-- Tên chỉ đổi khi còn là tên seed gốc, để không ghi đè tên đã được sửa tay.
UPDATE "vehicle_types"
   SET "code" = 'SEATER_LIMOUSINE',
       "form" = 'SEATER',
       "class" = 'LIMOUSINE',
       "name" = CASE WHEN "name" = 'Limousine' THEN 'Ghế ngồi Limousine' ELSE "name" END,
       "updated_at" = CURRENT_TIMESTAMP
 WHERE "code" = 'LIMOUSINE';

ALTER TABLE "vehicle_types"
  ALTER COLUMN "form" SET NOT NULL,
  ALTER COLUMN "class" SET NOT NULL;
