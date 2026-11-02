-- TASK-EMP-002 (phần backend) — vận hành chuyến bởi nhân viên được phân công (FR-EMP-07..09/13, UC-20/21, BR-32, BR-44).
-- Cột AI tự đề xuất, chờ Khanh duyệt (`doc/task-propreties/EMP-002-todo.md`).

-- Giờ thực tế do tài xế cập nhật; `payout_eligible_at` = giờ hoàn thành thực tế + chu kỳ chi trả (BR-32 "T+3 sau khi chuyến
-- hoàn thành") — có thì thay cho mốc tính từ giờ đến dự kiến ghi trên sổ giữ hộ (sổ chỉ ghi thêm, không sửa được).
ALTER TABLE "trips"
    ADD COLUMN "departed_at" TIMESTAMP(3),
    ADD COLUMN "completed_at" TIMESTAMP(3),
    ADD COLUMN "payout_eligible_at" TIMESTAMP(3);
