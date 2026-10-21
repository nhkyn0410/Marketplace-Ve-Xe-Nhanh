-- TASK-IAM-007 (tự thiết kế, chờ duyệt): phân quyền theo từng tài khoản (FR-IAM-07) + tài khoản quản lý nhà xe.

-- Tài khoản quản lý dùng Operator OS, do chủ nhà xe cấp. Giá trị mới chưa được dùng trong migration này
-- (Postgres không cho dùng giá trị enum vừa thêm trong cùng transaction).
ALTER TYPE "OperatorRole" ADD VALUE 'OPERATOR_MANAGER';

-- Mảng mã quyền; NULL = đủ quyền tick được của role (tài khoản cũ / seed giữ nguyên hành vi).
ALTER TABLE "platform_accounts" ADD COLUMN "permissions" JSONB;
ALTER TABLE "platform_accounts" ADD CONSTRAINT "platform_accounts_permissions_array"
  CHECK ("permissions" IS NULL OR jsonb_typeof("permissions") = 'array');

-- Chủ nhà xe luôn đủ quyền (không mang danh sách); tài khoản quản lý luôn mang danh sách.
ALTER TABLE "operator_accounts" ADD COLUMN "permissions" JSONB;
ALTER TABLE "operator_accounts" ADD CONSTRAINT "operator_accounts_permissions_by_role"
  CHECK (
    ("role" = 'OPERATOR_OWNER') = ("permissions" IS NULL)
    AND ("permissions" IS NULL OR jsonb_typeof("permissions") = 'array')
  );
