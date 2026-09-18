# TASK-IAM-003 — Checklist nghiệm thu: RBAC + TenantGuard + Postgres RLS

> Mục tiêu: chứng minh **tenant A không chạm được dữ liệu tenant B ở cả hai lớp** (guard ứng dụng **và** Postgres), quyền đi theo bảng một nguồn, và thêm role không phải sửa guard/controller.
> Cách dùng: chạy **A → F**; PHẦN G là DoD từng sub-task. Tick `[x]` khi pass; mục không tick được ghi lý do tại chỗ.
> Thao tác chi tiết: `IAM-003-guide.md`. Phạm vi: `IAM-003-todo.md`.

## Snapshot trạng thái (18/09/2026)

- 🟡 **18/09/2026 — PHẦN A–E xong**; còn CI trên GitHub (chưa push) và đổi task row → Done. Số đo: 248/248 test bằng role app; mô phỏng job `db-integration` trên DB mới 248/248; turbo xanh; smoke thật 11/11.

---

## PHẦN A — Thiết kế & ranh giới

- [x] Q1–Q4 trong `IAM-003-todo.md` có ✅ + ngày + lý do — chốt 18/09/2026
- [x] Guard/controller **không** so sánh tên role ở bất kỳ đâu — chỉ hỏi quyền (`grep` không thấy `role ===` ngoài `iam/role/`)
- [x] Bảng role→quyền nằm **một** file; mỗi quyền ghi nguồn (Security §7 / API / FR)
- [x] Ô "có điều kiện" của Security §7 **không** được cấp mặc định (booking hộ, audit tenant); `PLATFORM_SUPPORT` chỉ quyền đọc — ghi là giả định
- [x] Không có endpoint mới ngoài API §7; không đổi ADR (chỉ thêm ghi chú Q2 vào ADR-017)
- [x] Code nằm đúng DOMAIN-MAP: `iam/role/` (role, quyền, guard), `database/` (ngữ cảnh DB) — ✅ thêm `database/db-scope.ts` (DbScope có brand)

## PHẦN B — Role Postgres & migration

- [x] `vexenhanh_app`: `rolsuper=f`, `rolbypassrls=f`, `rolcreaterole=f`, `rolcreatedb=f`
- [x] App (`DATABASE_URL`) chạy bằng `vexenhanh_app`; migrate/seed chạy bằng owner (`MIGRATION_DATABASE_URL`)
- [x] `db:app-role` idempotent (chạy 2 lần không lỗi) và **từ chối** khi hai URL cùng user
- [x] Role app **không** có quyền trên `_prisma_migrations`, không DDL
- [x] Migration RLS chạy được trên **DB trống**; `prisma migrate diff` sau đó không sinh lệnh xoá policy/hàm
- [x] 4 bảng `operator_profiles`, `operator_accounts`, `employee_accounts`, `auth_sessions`: `relrowsecurity=t` **và** `relforcerowsecurity=t`

## PHẦN C — RLS hành vi (Postgres thật, role app) — mandatory ADR-025

- [x] ⭐ **TC-SEC-001**: ngữ cảnh tenant A, query **không lọc** → chỉ thấy row A (`employee_accounts`, `auth_sessions`)
- [x] Không ngữ cảnh → **0 row** (fail-closed)
- [x] UPDATE/DELETE row tenant B từ ngữ cảnh A → 0 row bị ảnh hưởng
- [x] INSERT/UPDATE gắn `operator_id` tenant B từ ngữ cảnh A → lỗi RLS (`WITH CHECK`)
- [x] `auth_sessions` passenger/platform (`operator_id` NULL) **không** hiện trong ngữ cảnh tenant
- [x] GUC transaction-local: sau COMMIT/ROLLBACK, kết nối pool không còn `app.scope`
- [x] Test RLS **tự đỏ** nếu kết nối là superuser/BYPASSRLS (chống xanh giả)

## PHẦN D — RBAC & guard

- [x] Mọi `Role` có mặt trong `ROLE_GRANTS` (TypeScript + test); enum Prisma `OperatorRole`/`EmployeeRole`/`PlatformRole` ⊆ `Role`
- [x] Role operator-side chỉ có grant `tenant`/`assigned`/`own`; không role nào ngoài `PLATFORM_*` có grant `any` trên quyền quản trị
- [x] Role lạ trong JWT → không quyền nào (403) + log cảnh báo — ✅ nay chặn sớm hơn: TokenService từ chối role lệch scope → 401
- [x] Không token → 401 `AUTH_SESSION_EXPIRED`; có token thiếu quyền → 403 `PERMISSION_DENIED` (RFC 7807)
- [x] Grant `tenant` + token platform / thiếu `operatorId` → 403 `TENANT_SCOPE_VIOLATION`
- [x] Route có `:operatorSlug`/`:operatorId` khác claim → 403 `TENANT_SCOPE_VIOLATION`
- [x] Controller nhận `DbScope` đúng: tenant → `{ tenant, operatorId }`; admin → `platform`
- [x] ESLint `system-db-context` chặn `withSystem` ngoài `iam/` + worker (có test rule) — ✅ mở rộng sau audit: chặn cả `withPlatform/withTenant`, hàm dựng scope, `$queryRawUnsafe`, chuỗi `set_config`; `iam/user` KHÔNG được miễn

## PHẦN E — Hồi quy IAM-001/002 dưới role app

- [x] Login operator (owner + employee), platform, OTP passenger → 200
- [x] Refresh rotation, reuse → family chết, logout idempotent → như IAM-002
- [x] Toàn bộ test IAM-002 (unit + `*.int.spec.ts`) xanh với `DATABASE_URL` = role app
- [x] Worker `session-cleanup` chạy được dưới role app

## PHẦN F — Static & CI

- [x] `pnpm turbo run typecheck lint test build` xanh toàn bộ
- [x] OpenAPI không đổi ngoài dự kiến (IAM-003 không thêm endpoint)
- [ ] CI GitHub Actions xanh trên branch `TASK-IAM-003` — ⏳ **chưa tick**: chưa commit/push (CLAUDE.md §4.7 — chờ Khanh). Có thêm workflow `db-integration.yml`

## PHẦN G — DoD theo sub-task

| Sub-task | DoD | ✓ |
| -------- | --- | - |
| `.1` Quyết định | Q1–Q4 chốt + ghi lại | [x] |
| `.2` Role Postgres | Role app đúng thuộc tính; tách URL migrate; script idempotent | [x] |
| `.3` Migration RLS | Hàm + 3 bảng ENABLE/FORCE + policy; chạy trên DB trống; không drift | [x] |
| `.4` Ngữ cảnh DB | `withTenant/withPlatform/withSystem/withScope`; ESLint rule + test | [x] |
| `.5` Chuyển code IAM | Không đổi hành vi IAM-001/002; test cũ xanh dưới role app | [x] |
| `.6` Role + quyền | Bảng một nguồn; `can()`; test bất biến | [x] |
| `.7` Guards | `@Authorize` chuỗi 3 guard; lỗi đúng mã; e2e HTTP | [x] |
| `.8` Test tenant-RLS | PHẦN C xanh trên Postgres thật, role app | [x] |
| `.9` Doc | ADR-017 ghi chú Q2; DB-PRIN-01; render.yaml/deploy; `.env.example`; PROJECT-STATE | [x] |
| `.10` Đóng task | 2 review không còn finding chặn; guide chạy hết; task row → Done | 🟡 review + smoke xong; còn commit, CI, task row |

## PHẦN H — Ranh giới (KHÔNG kiểm ở task này)

- Quyền riêng từng role Employee + ABAC theo phân công → task EMP (BR-43)
- Guest đọc dữ liệu công khai của tenant (scope `public`) → task MKT
- Booking hộ khách (Operator/Admin), audit log tenant → task BTP / audit
- TOTP → IAM-004 · cấp/khoá account + FR-IAM-15 → IAM-005
