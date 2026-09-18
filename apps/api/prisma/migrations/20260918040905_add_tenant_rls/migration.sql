-- TASK-IAM-003 — Tenant isolation bằng Postgres RLS (ADR-011, ADR-017, DB-PRIN-01).
--
-- Ngữ cảnh do app set bằng `set_config(..., true)` (transaction-local) ở PrismaService:
--   app.scope       = 'tenant' | 'platform' | 'system'
--   app.operator_id = id Operator (chỉ khi scope = 'tenant')
-- KHÔNG set gì → policy trả false → 0 row. Quên ngữ cảnh thành lỗi "không thấy dữ liệu", không
-- thành rò dữ liệu tenant khác (fail-closed).
--
-- Chỉ có tác dụng với role KHÔNG superuser, KHÔNG BYPASSRLS, không phải owner (scripts/db-app-role.mjs).
-- `operator_id` là text (uuid dạng chuỗi) — so sánh text, KHÔNG ép ::bigint như bản nháp DB-PRIN-01.
--
-- RLS là LỚP CHẶN CUỐI, không phải bộ lọc: điều kiện CASE bên dưới không dùng được index, nên
-- service VẪN phải lọc `operator_id` tường minh trong query (DB-PRIN-01 "app guard **và** RLS").
-- GUC do bất kỳ role nào tự set được → RLS chống quên lọc / nhầm ngữ cảnh, KHÔNG chống SQL injection.

CREATE OR REPLACE FUNCTION app_rls_allows(row_operator_id text) RETURNS boolean
LANGUAGE sql STABLE AS $$
  SELECT CASE current_setting('app.scope', true)
    WHEN 'system' THEN true      -- auth / session / cron: chỉ iam/auth, iam/session (ESLint)
    WHEN 'platform' THEN true    -- PLATFORM_*: toàn hệ thống theo RBAC
    WHEN 'tenant' THEN row_operator_id IS NOT NULL
      AND row_operator_id = current_setting('app.operator_id', true)
    ELSE false
  END
$$;

-- ── Tài khoản phía Operator: tenant đọc/ghi account của chính mình (IAM-005 employee:manage) ──
-- FORCE: RLS áp cả cho owner bảng (không phải superuser). Thiếu FORCE thì chạy nhầm bằng owner là lọt.
ALTER TABLE "operator_accounts" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "operator_accounts" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "operator_accounts"
  USING (app_rls_allows("operator_id"))
  WITH CHECK (app_rls_allows("operator_id"));

ALTER TABLE "employee_accounts" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "employee_accounts" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation" ON "employee_accounts"
  USING (app_rls_allows("operator_id"))
  WITH CHECK (app_rls_allows("operator_id"));

-- ── auth_sessions: tenant chỉ ĐỌC; chỉ `system` (SessionService) được GHI ──
-- Cho tenant ghi thì một row của tenant A có thể bị đổi `subject_type` thành PLATFORM (operator_id
-- vẫn là A, qua được WITH CHECK) rồi refresh ra token admin.
ALTER TABLE "auth_sessions" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "auth_sessions" FORCE ROW LEVEL SECURITY;
CREATE POLICY "tenant_read" ON "auth_sessions" FOR SELECT
  USING (app_rls_allows("operator_id"));
CREATE POLICY "system_insert" ON "auth_sessions" FOR INSERT
  WITH CHECK (current_setting('app.scope', true) = 'system');
CREATE POLICY "system_update" ON "auth_sessions" FOR UPDATE
  USING (current_setting('app.scope', true) = 'system')
  WITH CHECK (current_setting('app.scope', true) = 'system');
CREATE POLICY "system_delete" ON "auth_sessions" FOR DELETE
  USING (current_setting('app.scope', true) = 'system');
-- Phiên phía Operator luôn gắn tenant; phiên passenger/platform thì không.
ALTER TABLE "auth_sessions" ADD CONSTRAINT "auth_sessions_operator_matches_subject"
  CHECK (("subject_type" IN ('OPERATOR', 'EMPLOYEE')) = ("operator_id" IS NOT NULL));

-- ── operator_profiles: hồ sơ công khai (Guest đọc, API §7.2) nhưng CHỈ platform/system được ghi ──
-- Không có policy nào thì role app sửa/xoá được tenant bất kỳ; tenant tự sửa hồ sơ → task OPR-001
-- (phải chặn tự đổi `status`, nên không mở UPDATE cho tenant ở đây).
ALTER TABLE "operator_profiles" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "operator_profiles" FORCE ROW LEVEL SECURITY;
CREATE POLICY "public_read" ON "operator_profiles" FOR SELECT
  USING (true);
CREATE POLICY "platform_insert" ON "operator_profiles" FOR INSERT
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
CREATE POLICY "platform_update" ON "operator_profiles" FOR UPDATE
  USING (current_setting('app.scope', true) IN ('platform', 'system'))
  WITH CHECK (current_setting('app.scope', true) IN ('platform', 'system'));
CREATE POLICY "platform_delete" ON "operator_profiles" FOR DELETE
  USING (current_setting('app.scope', true) IN ('platform', 'system'));

-- Slug là định danh tenant không phân biệt hoa/thường (namespace.resolver hạ chữ thường; TenantGuard
-- so không phân biệt) → DB phải cấm hai tenant chỉ khác nhau hoa/thường.
ALTER TABLE "operator_profiles" ADD CONSTRAINT "operator_profiles_slug_lowercase"
  CHECK ("operator_slug" = lower("operator_slug"));
ALTER TABLE "operator_accounts" ADD CONSTRAINT "operator_accounts_slug_lowercase"
  CHECK ("operator_slug" = lower("operator_slug"));

-- ── FK RESTRICT thay CASCADE: hành động cascade chạy với quyền owner và BỎ QUA RLS (kể cả FORCE) ──
ALTER TABLE "operator_accounts" DROP CONSTRAINT "operator_accounts_operator_id_fkey";
ALTER TABLE "operator_accounts" ADD CONSTRAINT "operator_accounts_operator_id_fkey"
  FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "employee_accounts" DROP CONSTRAINT "employee_accounts_operator_id_fkey";
ALTER TABLE "employee_accounts" ADD CONSTRAINT "employee_accounts_operator_id_fkey"
  FOREIGN KEY ("operator_id") REFERENCES "operator_profiles"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
