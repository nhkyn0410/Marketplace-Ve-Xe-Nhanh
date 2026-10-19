-- TASK-ADM-002 — Thanh toán & hoàn tiền phía Admin (FR-ADM-10, UC-27 A4, UC-32 bước 8, Security §8 "Refund thủ công";
-- Figma ADM-07a–d). Cột AI tự đề xuất, chờ Khanh duyệt (`doc/task-propreties/ADM-002-payments-refunds-todo.md`).

-- Lần gửi cổng: Admin "gửi lại cổng" một refund thất bại thì tăng lên — mã yêu cầu gửi cổng mỗi lần một khác
-- (`vnp_RequestId` / `orderId` của MoMo không được trùng), mã refund hiển thị giữ nguyên.
-- Mã tham chiếu khi Admin ghi nhận đã hoàn NGOÀI luồng tự động (chuyển khoản tay / đã hoàn trên trang quản trị cổng).
ALTER TABLE "refunds"
    ADD COLUMN "attempt" INTEGER NOT NULL DEFAULT 1,
    ADD COLUMN "bank_reference" TEXT,
    ADD CONSTRAINT "refunds_attempt" CHECK ("attempt" >= 1),
    ADD CONSTRAINT "refunds_bank_reference" CHECK ("bank_reference" IS NULL OR char_length("bank_reference") BETWEEN 3 AND 64);

-- Danh sách giám sát toàn hệ thống, mới trước.
CREATE INDEX "payments_created_at_idx" ON "payments"("created_at");
CREATE INDEX "refunds_created_at_idx" ON "refunds"("created_at");
