-- TASK-OPR-001b — nhà xe tự sửa thông tin công khai của mình (UC-11 bước 2). Trước đây chỉ platform / system được ghi
-- `operator_profiles` (20260918040905_add_tenant_rls: "phải chặn tự đổi `status`"). Mở UPDATE cho đúng tenant đó và
-- dùng trigger chặn tenant đổi bất kỳ cột nào ngoài tên hiển thị, hotline, email, địa chỉ, mô tả.
CREATE POLICY "tenant_update_public" ON "operator_profiles" FOR UPDATE
  USING (current_setting('app.scope', true) = 'tenant' AND app_rls_allows("id"))
  WITH CHECK (current_setting('app.scope', true) = 'tenant' AND app_rls_allows("id"));

CREATE OR REPLACE FUNCTION operator_profiles_tenant_columns() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  IF current_setting('app.scope', true) IS DISTINCT FROM 'platform'
     AND current_setting('app.scope', true) IS DISTINCT FROM 'system'
     AND (NEW."id", NEW."operator_slug", NEW."status", NEW."suspended_reason", NEW."suspended_at", NEW."legal_name",
          NEW."tax_code", NEW."approved_at", NEW."created_at")
         IS DISTINCT FROM
         (OLD."id", OLD."operator_slug", OLD."status", OLD."suspended_reason", OLD."suspended_at", OLD."legal_name",
          OLD."tax_code", OLD."approved_at", OLD."created_at") THEN
    RAISE EXCEPTION 'operator_profiles: tenant chỉ được sửa thông tin công khai' USING ERRCODE = '42501';
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER "operator_profiles_tenant_columns"
  BEFORE UPDATE ON "operator_profiles"
  FOR EACH ROW EXECUTE FUNCTION operator_profiles_tenant_columns();
