-- Đối soát tự động với cổng thanh toán (FR-BTP-17, UC-32, LLD §6.3 bước 4; TASK-ADM-002 G9). Cột AI tự đề xuất, chờ Khanh
-- duyệt (`doc/task-propreties/RECON-todo.md`): lần tra cứu cổng gần nhất — job không tra lại cùng thanh toán liên tục.
ALTER TABLE "payments" ADD COLUMN "provider_checked_at" TIMESTAMP(3);

-- Ứng viên đối soát: thanh toán chưa có kết quả cuối, đã quá hạn, tạo gần đây.
CREATE INDEX "payments_status_expires_at_idx" ON "payments"("status", "expires_at");
