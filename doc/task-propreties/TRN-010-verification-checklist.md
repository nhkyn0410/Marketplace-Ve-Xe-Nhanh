# TASK-TRN-010 — Checklist nghiệm thu: Phân loại xe và loại chỗ

> Mục tiêu: catalog loại xe mang dạng chỗ + hạng xe, sơ đồ ghế nhận 5 loại chỗ và tính đúng sức chứa, migration giữ nguyên xe đang gắn loại `LIMOUSINE` cũ.
> Chỉ tick `[x]` khi có evidence. Lệnh: `TRN-010-guide.md`. Phạm vi: `TRN-010-todo.md`.

## Snapshot trạng thái (04/10/2026)

- [x] Nhánh `TASK-TRN-010` từ `develop`; tạo bộ ba todo / guide / checklist.
- [x] Code, migration, test, client TS + Dart xong; đo trên máy dev bằng container tạm (Postgres 16, Redis 7, Mongo 7), test chạy bằng **role app** (không superuser, không BYPASSRLS).
- [ ] Khanh review diff → commit → CI xanh.
- [ ] Rollout database đã triển khai (guide §5).

## PHẦN A — Schema và migration

- [x] `vehicle_types.form` / `class` là `NOT NULL`, không default.
- [x] Enum loại chỗ đủ 5 giá trị: `SEAT`, `BED`, `BED_DOUBLE`, `CABIN`, `CABIN_DOUBLE`.
- [x] Database cũ (4 loại xe + một xe đang gắn `LIMOUSINE`): sau migrate, dòng đó thành `SEATER_LIMOUSINE` / `SEATER` / `LIMOUSINE`, xe vẫn trỏ đúng dòng (giữ `id`).
- [x] Tên `Limousine` gốc đổi thành `Ghế ngồi Limousine`; tên đã sửa tay (thử với `Limo VIP`) được giữ nguyên.
- [x] Chạy được khi chủ database **không** phải superuser và bảng bật FORCE RLS (giống Supabase): dữ liệu vẫn được cập nhật.
- [x] Database có mã loại xe lạ: migration dừng với thông báo nêu tên mã, **không đổi gì** (0 cột mới, 0 enum mới, enum loại chỗ vẫn 2 giá trị); xử lý theo guide §5 rồi chạy lại thành công.
- [x] Database mới hoàn toàn: migrate từ đầu + seed ra đúng 6 loại xe.
- [x] RLS của `vehicle_types` không đổi (test `catalog.int.spec` — 4 policy, đọc tự do, ghi chỉ platform / system).

## PHẦN B — Seed

- [x] Seed sau migrate ở database cũ: tạo mới đúng 2 loại xe (`SLEEPER_LIMOUSINE`, `CABIN_LIMOUSINE`); chạy lần hai tạo mới 0.
- [x] 6 loại xe phủ đủ 3 dạng chỗ × 2 hạng xe, mã khớp thuộc tính; không còn mã `LIMOUSINE` (test `catalog-seed.spec`).

## PHẦN C — API

- [x] `GET /catalog/vehicle-types` trả `form` + `class`, không lộ `status` / timestamp (`TC-TRN-012` phần catalog).
- [x] SeatMap nhận đủ 5 loại chỗ; loại lạ → `400`, service không bị gọi (`TC-TRN-013` phần sơ đồ ghế).
- [x] `passengerCapacity` = số chỗ + số chỗ đôi; `deckCount` = số tầng — đúng ở chi tiết lẫn danh sách; `PUT` thay ghế thì tính lại.
- [x] DB tự chặn loại chỗ ngoài enum và loại xe thiếu `form` / `class`, kể cả đường ghi bỏ qua Zod.
- [ ] Smoke HTTP trên API đang chạy (guide §3) — **chưa chạy**; hiện mới có test route + test database thật.

Phần còn lại của `TC-TRN-012` (lọc tìm chuyến) thuộc `TASK-TRN-004`; phần giá chỗ đôi của `TC-TRN-013` thuộc `TASK-TRN-005`.

## PHẦN D — Chất lượng

- [x] `vitest` toàn bộ `apps/api` với `REQUIRE_DB_TESTS=1`: **65 file, 764 test pass, 0 skip**.
- [x] `pnpm turbo run typecheck lint`: 19/19 task pass.
- [x] Client TS: `openapi.json` + `schema.ts` chỉ đổi `form` / `class`, `passengerCapacity` / `deckCount`, 5 loại chỗ.
- [x] Client Dart sinh bằng `openapi-generator-cli:v7.25.0`: 15 file đổi nội dung, đều thuộc loại xe / sơ đồ ghế; `dart analyze` 0 lỗi; `dart test` 423 pass.
- [ ] `code-reviewer` trước khi đóng task (DoD §6.3) — chưa chạy.

## Bàn giao cho task sau

- Port `TASK-TRN-003` / `TASK-TRN-005`: `trip_seats` và `fare_rules` dùng luôn enum 5 loại chỗ; thêm test giá riêng cho `BED_DOUBLE` / `CABIN_DOUBLE`.
- `TASK-TRN-004`: lọc `vehicleForm` / `vehicleClass` theo hai cột mới.
- Operator OS: ô chọn loại xe hiện dạng chỗ + hạng xe từ `form` / `class`; danh sách sơ đồ ghế dùng `passengerCapacity`, `deckCount`.
