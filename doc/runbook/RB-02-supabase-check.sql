-- RB-02 — Kiểm tra Supabase sau migrate / reset (Supabase → SQL Editor). Chỉ đọc.
-- Kết quả đúng: ensure_rls = D (trigger tự bật RLS của Supabase đang TẮT) · anon_doc_duoc = false · bang_rls_khong_policy = 0.
-- Lý do (sự cố 20/10/2026): `ensure_rls` bật RLS cho bảng mới không có policy → role app không thấy dòng nào
-- (vd đăng nhập Admin trả unknown_account); role `anon` / `authenticated` của Supabase không được đọc bảng của app.
SELECT (SELECT evtenabled FROM pg_event_trigger WHERE evtname = 'ensure_rls') AS ensure_rls,
       has_table_privilege('anon', 'public.platform_accounts', 'SELECT') AS anon_doc_duoc,
       (SELECT count(*) FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
         WHERE n.nspname = 'public' AND c.relkind = 'r' AND c.relrowsecurity
           AND NOT EXISTS (SELECT 1 FROM pg_policy p WHERE p.polrelid = c.oid)) AS bang_rls_khong_policy;

-- Nếu anon_doc_duoc = true, chạy thêm:
-- REVOKE ALL ON ALL TABLES IN SCHEMA public FROM anon, authenticated;
-- REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM anon, authenticated;
