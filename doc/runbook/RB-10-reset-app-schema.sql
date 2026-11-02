-- RB-10 — Xóa SẠCH dữ liệu + cấu trúc của ứng dụng trong schema public để migrate lại từ đầu (dùng lần đầu 21/10/2026).
-- Giữ: schema public, quyền mặc định của schema, extension (unaccent, btree_gist...) và hàm / trigger của Supabase
-- (`rls_auto_enable` + event trigger `ensure_rls` đang TẮT). Chạy bằng role owner (local: owner migrate; Supabase: SQL Editor).
-- Cả khối là một transaction: lỗi giữa chừng thì không có gì bị xóa. Sau đó làm tiếp các bước trong RB-10-reset-db.md.
DO $$
DECLARE
  r record;
BEGIN
  -- Bảng (CASCADE gỡ luôn FK, policy RLS, trigger, sequence sở hữu bởi cột).
  FOR r IN SELECT tablename FROM pg_tables WHERE schemaname = 'public' LOOP
    EXECUTE format('DROP TABLE IF EXISTS public.%I CASCADE', r.tablename);
  END LOOP;
  -- View / sequence rời (nếu có).
  FOR r IN SELECT viewname FROM pg_views WHERE schemaname = 'public' LOOP
    EXECUTE format('DROP VIEW IF EXISTS public.%I CASCADE', r.viewname);
  END LOOP;
  FOR r IN
    SELECT c.relname FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE n.nspname = 'public' AND c.relkind = 'S'
      AND NOT EXISTS (SELECT 1 FROM pg_depend d WHERE d.objid = c.oid AND d.deptype = 'e')
  LOOP
    EXECUTE format('DROP SEQUENCE IF EXISTS public.%I CASCADE', r.relname);
  END LOOP;
  -- Hàm của ứng dụng (bỏ qua hàm thuộc extension và hàm của Supabase).
  FOR r IN
    SELECT p.oid::regprocedure AS signature FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.proname <> 'rls_auto_enable'
      AND NOT EXISTS (SELECT 1 FROM pg_depend d WHERE d.objid = p.oid AND d.deptype = 'e')
  LOOP
    EXECUTE format('DROP FUNCTION IF EXISTS %s CASCADE', r.signature);
  END LOOP;
  -- Enum / domain của ứng dụng.
  FOR r IN
    SELECT t.typname FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE n.nspname = 'public' AND t.typtype IN ('e', 'd')
      AND NOT EXISTS (SELECT 1 FROM pg_depend d WHERE d.objid = t.oid AND d.deptype = 'e')
  LOOP
    EXECUTE format('DROP TYPE IF EXISTS public.%I CASCADE', r.typname);
  END LOOP;
END $$;

-- Kiểm tra: phải ra 0 bảng.
SELECT count(*) AS bang_con_lai FROM pg_tables WHERE schemaname = 'public';
