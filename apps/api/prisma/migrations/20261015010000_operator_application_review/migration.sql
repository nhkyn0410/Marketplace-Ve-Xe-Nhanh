-- TASK-ADM-001 (phần duyệt hồ sơ đăng ký nhà xe, UC-23): ghi người duyệt + thời điểm ra quyết định, và khóa
-- idempotency của lần duyệt (API §8) — duyệt lặp cùng khóa trả lại đúng kết quả cũ, khác khóa bị từ chối.

ALTER TABLE "operator_applications"
  ADD COLUMN "reviewed_at" TIMESTAMP(3),
  ADD COLUMN "reviewed_by" TEXT,
  ADD COLUMN "approval_idempotency_key" TEXT;

-- Người duyệt và thời điểm đi cùng nhau; hồ sơ đã có quyết định (bổ sung / từ chối / duyệt) thì phải có cả hai.
ALTER TABLE "operator_applications" ADD CONSTRAINT "operator_applications_reviewed_pair"
  CHECK (("reviewed_at" IS NULL) = ("reviewed_by" IS NULL));
ALTER TABLE "operator_applications" ADD CONSTRAINT "operator_applications_reviewed_when_decided"
  CHECK ("status" NOT IN ('NEEDS_INFO', 'APPROVED', 'REJECTED') OR "reviewed_at" IS NOT NULL);
-- Khóa idempotency chỉ có ở hồ sơ đã duyệt, và hồ sơ đã duyệt luôn có khóa.
ALTER TABLE "operator_applications" ADD CONSTRAINT "operator_applications_idempotency_when_approved"
  CHECK (("status" = 'APPROVED') = ("approval_idempotency_key" IS NOT NULL));

-- Cảnh báo trùng tài khoản nhận tiền ở hàng đợi duyệt (UC-10 A2); mã số thuế / email đã có index.
CREATE INDEX "operator_applications_bank_account_number_idx" ON "operator_applications"("bank_account_number");
