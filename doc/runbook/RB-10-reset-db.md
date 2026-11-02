---
id: RB-10
title: Reset toàn bộ DB + tạo quản trị viên đầu tiên
match:
  - RB-10-reset-app-schema.sql
  - db:create-first-admin
---

# RB-10 — Reset toàn bộ DB + tạo quản trị viên đầu tiên

**Mục đích:** xóa sạch dữ liệu + cấu trúc ứng dụng trong Postgres rồi dựng lại từ migration (vd đổi role / quyền làm tài khoản cũ không dùng được — lần đầu 21/10/2026). **Mất toàn bộ tài khoản, nhà xe, đặt vé.** Giữ: Mongo audit, file R2, extension + trigger `ensure_rls` của Supabase.
**Điều kiện:** cửa sổ PowerShell **mới** (biến DB dev còn trong phiên cũ sẽ không bị file env ghi đè), tại `C:\Code\Ve_Xe_Nhanh` trên `develop`. Có `apps/api/.env.production` (`MIGRATION_DATABASE_URL` owner, `MONGODB_AUDIT_URI`); Atlas cho IP máy đang chạy.

## Các bước (production)

1. Render → `vexenhanh-api` → **Suspend** (không còn request giữ khóa bảng).
2. Supabase → SQL Editor: dán toàn bộ [`RB-10-reset-app-schema.sql`](RB-10-reset-app-schema.sql) → Run → đồng ý cảnh báo phá hủy. Phải ra `bang_con_lai = 0`.
3. `$env:NODE_ENV="production"` → `prisma:migrate:deploy` → `db:app-role` ([RB-02](RB-02-prisma-migration.md)). Máy chủ in ở đầu phải là pooler Supabase, không phải `localhost`.
4. Nạp danh mục: `pnpm --filter @vexenhanh/api run db:seed:catalog` ([RB-08](RB-08-catalog-seed.md)) → `Remove-Item Env:NODE_ENV`.
5. Chạy câu kiểm tra Supabase ở [RB-02](RB-02-prisma-migration.md) → `D` / `false` / `0`.
6. Upstash → database production → **Flush** (job, phiên, bộ đếm đăng nhập cũ). Render → **Resume**, đợi `/v1/health` OK.
7. Quản trị viên đầu tiên — script **giữ ngoài repo**, lấy từ commit `4fc8e67` (20/10/2026) bằng worktree tạm:
   `git worktree add --detach ..\Ve_Xe_Nhanh_FIRSTADMIN 4fc8e67` → `cd ..\Ve_Xe_Nhanh_FIRSTADMIN` → `pnpm install` → `pnpm --filter @vexenhanh/api run prisma:generate` →
   `pnpm --filter @vexenhanh/api db:create-first-admin --env-file C:\Code\Ve_Xe_Nhanh\apps\api\.env.production --username khanh --email <email>`
   → chép mật khẩu tạm vào trình quản lý mật khẩu → `Clear-Host`.
8. Gỡ worktree: `cd ..\Ve_Xe_Nhanh` → `git worktree remove --force ..\Ve_Xe_Nhanh_FIRSTADMIN`.
9. Admin production: đăng nhập `platform/khanh` → đổi mật khẩu → bật TOTP, lưu mã dự phòng → tạo ngay quản trị viên thứ hai (tick đủ `access:manage`).

**Local:** bước 2 chạy file SQL bằng owner (hoặc `docker compose down -v` rồi dựng lại — [RB-05](RB-05-local-infra.md)), bước 3–4 không đặt `NODE_ENV` + `-- --with-samples`, xóa Redis local; tài khoản mẫu dùng `db:seed` (đặt mật khẩu theo `SEED_PLATFORM_PASSWORD`).

## Kiểm tra

- Script in `Đã tạo quản trị viên đầu tiên.` + tên đăng nhập, hạn 24 giờ; Mongo có sự kiện `iam.platform_account.bootstrap`.
- Đăng nhập bằng mật khẩu tạm → hệ thống bắt đổi mật khẩu; sai mật khẩu → 401.

## Lỗi hay gặp

- `Không tạo: Đã có quản trị viên dùng được…`: DB chưa reset hoặc đã tạo rồi — thêm người qua Admin. Quá 24 giờ chưa đăng nhập: chạy lại đúng `--username` + `--email` cũ để cấp lại mật khẩu tạm.
- `--env-file` tính từ `apps/api` → luôn dùng **đường dẫn tuyệt đối**. Thiếu biến: `Cần MIGRATION_DATABASE_URL … và MONGODB_AUDIT_URI`.
- Treo rồi lỗi kết nối Mongo: Atlas chưa cho IP. Đăng nhập trả `unknown_account` sau reset: `ensure_rls` bật lại — xem RB-02.

**Liên quan:** ADR-011 · ADR-017 · 07 Security · `TASK-IAM-007` · RB-02 · RB-07 · RB-08
