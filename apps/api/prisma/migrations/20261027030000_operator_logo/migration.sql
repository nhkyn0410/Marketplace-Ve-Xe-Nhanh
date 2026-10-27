-- Logo nhà xe (FR-OPR-02; Khanh 27/10/2026, tự thiết kế — chờ duyệt): ảnh ở kho công khai (ADR-018), bảng chỉ lưu khóa
-- object; địa chỉ công khai do API ghép. Trigger `operator_profiles_tenant_columns` chặn theo danh sách cột cấm nên nhà
-- xe sửa được cột mới qua policy `tenant_update_public` — đúng ý: logo là thông tin công khai nhà xe tự quản lý.

SET LOCAL lock_timeout = '10s';

ALTER TABLE "operator_profiles" ADD COLUMN "logo_object_key" TEXT;

CREATE UNIQUE INDEX "operator_profiles_logo_object_key_key" ON "operator_profiles"("logo_object_key");
