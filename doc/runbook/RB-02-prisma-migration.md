---
id: RB-02
title: Tạo & áp migration Prisma + cấp quyền role app
match:
  - prisma:migrate
  - prisma migrate
  - db:app-role
  - prisma:generate
  - prisma generate
  - /db:seed(?!:catalog)/
---

# RB-02 — Tạo & áp migration Prisma

**Mục đích:** đổi schema Postgres có kiểm soát, đồng thời giữ RLS có hiệu lực (app không chạy bằng owner).
**Điều kiện:** Postgres đang chạy ([RB-05](RB-05-local-infra.md)). `MIGRATION_DATABASE_URL` là role **owner**, `DATABASE_URL` là role **app** (NOSUPERUSER, NOBYPASSRLS).

## Các bước

1. Sửa `apps/api/prisma/schema.prisma`. Nếu là SQL tay (RLS, policy) thì sửa trong migration sinh ra.
2. Tạo migration ở máy local: `pnpm --filter @vexenhanh/api run prisma:migrate:dev --name <ten_ngan>`
3. Cấp lại quyền cho role app (chạy lại nhiều lần vẫn an toàn): `pnpm --filter @vexenhanh/api run db:app-role`
4. Sinh lại client: `pnpm --filter @vexenhanh/api run prisma:generate`
5. DB đã có dữ liệu (staging/production): **không** dùng `migrate dev`. Chạy `pnpm --filter @vexenhanh/api run prisma:migrate:deploy`, rồi `db:app-role`.
6. Production (Supabase): chạy [`RB-02-supabase-check.sql`](RB-02-supabase-check.sql) trong SQL Editor → phải ra `D` / `false` / `0`.

## Kiểm tra

- Có thư mục mới trong `apps/api/prisma/migrations/`, và commit nó cùng schema.
- Test DB pass với role app: `REQUIRE_DB_TESTS=1` ([RB-03](RB-03-quality-check.md)).

## Lỗi hay gặp

- Migration đã áp ở nơi khác thì **không sửa lại**. Muốn đổi thì tạo migration mới (checksum sẽ lệch).
- Test pass nhưng RLS không chặn gì: đang chạy bằng owner. Kiểm lại `DATABASE_URL`.
- Bảng tenant mới phải bật `ENABLE` + `FORCE ROW LEVEL SECURITY` và có policy, nếu không thì dữ liệu lộ giữa các nhà xe.
- Production sau migrate, đăng nhập Admin báo `unknown_account` / API không thấy dòng nào: trigger `ensure_rls` của Supabase đã bật RLS cho bảng không có policy (sự cố 20/10/2026). Chạy câu kiểm tra ở bước 6; sai thì `ALTER EVENT TRIGGER ensure_rls DISABLE;`, thu quyền `anon` / `authenticated` (cuối file SQL), rồi `DISABLE ROW LEVEL SECURITY` ở các bảng không phải tenant mà thiếu policy (DB-PRIN-01: RLS chỉ ở bảng tenant).

**Liên quan:** ADR-011 (Postgres + Prisma, RLS) · `doc/SDLC/04-database-design.md` · [RB-10](RB-10-reset-db.md) (reset toàn bộ DB)
