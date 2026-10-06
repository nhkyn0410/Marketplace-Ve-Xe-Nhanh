-- TASK-TRN-012 (1/2) — thêm trạng thái `SUSPENDED` cho điểm dừng riêng của nhà xe (BR-81: Admin khóa).
--
-- Tách thành migration riêng: Postgres không cho DÙNG giá trị enum mới trong chính transaction vừa thêm
-- nó, mà CHECK và policy RLS ở migration `redesign_stop_points` kế tiếp đều nhắc tới `SUSPENDED`.

-- AlterEnum
ALTER TYPE "StopPointStatus" ADD VALUE 'SUSPENDED';
