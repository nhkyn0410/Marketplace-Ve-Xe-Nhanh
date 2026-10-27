---
id: RB-08
title: Seed catalog chuẩn (tỉnh/xã, địa danh cũ, điểm dừng, loại xe, tiện ích)
match:
  - db:seed:catalog
  - catalog-seed.ts
---

# RB-08 — Seed catalog chuẩn

**Mục đích:** nạp dữ liệu chuẩn Platform cho một môi trường: 34 tỉnh / 3.321 xã sau sáp nhập 2025 (kèm cấp hành chính + văn bản pháp lý), ánh xạ địa danh cũ của 63 tỉnh, điểm dừng chuẩn, loại xe, tiện ích; dev có thêm bến xe mẫu. Chạy lại an toàn: tạo dòng mới, **cập nhật cấp / văn bản pháp lý** của tỉnh / xã đã có, không xóa dòng nào.
**Điều kiện:** đã migrate (gồm `20261021010000_administrative_units_metadata` + `20261021020000_legacy_administrative_mappings`) + `db:app-role` ([RB-02](RB-02-prisma-migration.md)). Ba file đã có trong repo, thư mục `apps/api/prisma/seed-data/`: `administrative-units.csv`, `legacy-administrative-mappings.csv`, `stop-points-catalog.csv`. `MIGRATION_DATABASE_URL` là owner.

## Các bước

1. Dev / local (chạy từ gốc repo): `pnpm --filter @vexenhanh/api run db:seed:catalog -- --with-samples`
2. Production, trong cửa sổ PowerShell mới tại gốc repo trên nhánh `develop`:
   `$env:NODE_ENV="production"` → `pnpm --filter @vexenhanh/api run db:seed:catalog` (**không** `--with-samples`) → `Remove-Item Env:NODE_ENV`.
3. Sửa dữ liệu chuẩn: sửa CSV rồi chạy lại, hoặc sửa qua Admin → Danh mục (`TASK-ADM-001`). Seed không xóa dòng đã bỏ khỏi file — ngừng dùng qua Admin.

## Kiểm tra

- Dòng đầu in `Seed catalog → <host>/<DB>` kèm số ánh xạ cũ và điểm dừng chuẩn — đúng môi trường mới đọc tiếp.
- Lần đầu: `Đọc file: 34 tỉnh, 3321 xã, 10262 ánh xạ cũ, …`; `Tạo mới:` đúng các số đó. Chạy lần hai: `Tạo mới` = 0.
- `GET /v1/catalog/provinces` trả 34 tỉnh; Admin → Danh mục tìm được tỉnh / xã khi gõ không dấu.

## Lỗi hay gặp

- `Dòng N: mã tỉnh … phải gồm đúng 2 chữ số` / mã xã 5 chữ số: file bị Excel xóa số 0 đầu — mở bằng trình soạn văn bản, không lưu lại bằng Excel. Script không ghi dòng nào khi file sai.
- `Dòng 1: tiêu đề phải đúng …` hoặc `ký tự lỗi mã hoá`: sai tên cột / dấu phân cách, hoặc file không phải UTF-8.
- `Bỏ qua điểm dừng (không tìm thấy phường): …`: mã phường của điểm dừng không có trong danh mục — sửa `stop-points-catalog.csv`.
- Lỗi cột `level` / bảng `legacy_administrative_mappings` không tồn tại: DB chưa có 2 migration ngày 21/10 — chạy `prisma:migrate:deploy` trước.

**Liên quan:** DB-MIG-04 · 04 DB §7 · API §7.5 / §7.6 · `TASK-CAT-001` · `doc/task-propreties/CAT-001-guide.md`
