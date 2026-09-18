# TASK-IAM-003 — Guide kiểm chứng: RBAC, TenantGuard, Postgres RLS

> Chạy thật IAM-003 trên máy local bằng Docker: tạo role Postgres cho app, áp RLS, chứng minh tenant A không thấy dữ liệu tenant B **kể cả khi code quên lọc**, và IAM-001/002 vẫn chạy bình thường dưới role mới.
> Lệnh chạy ở repo root `C:\Code\Ve_Xe_Nhanh` (**PowerShell**). Phạm vi/quyết định: `IAM-003-todo.md`. Nghiệm thu: `IAM-003-verification-checklist.md`.
>
> ⚠️ Guide viết **trước** khi code (18/09/2026) để làm success-criteria. Tên field/mã lỗi lệch guide ⇒ sửa code cho khớp thiết kế; chỉ sửa guide khi chính thiết kế đổi (ghi lý do vào todo).

## 0. Tiền đề

- Docker Desktop đang chạy; branch `TASK-IAM-003`; đã `pnpm install`.
- ⚠️ Máy có WSL chạy Redis riêng thì `localhost:6379` **không** phải Redis của Docker (ghi nhận IAM-002). Guide này chỉ đụng Postgres nên không ảnh hưởng.

---

## 1. Hai URL database (Q3)

`apps/api/.env.development` phải có **cả hai**:

```dotenv
# App chạy bằng role KHÔNG superuser, KHÔNG BYPASSRLS — nếu không RLS bị bỏ qua hoàn toàn.
DATABASE_URL="postgresql://vexenhanh_app:vexenhanh_app_dev@localhost:5432/vexenhanh_dev?schema=public"
# Chỉ để migrate/seed (owner). KHÔNG đưa vào env của service API/worker trên Render.
MIGRATION_DATABASE_URL="postgresql://vexenhanh:vexenhanh_dev@localhost:5432/vexenhanh_dev?schema=public"
```

```powershell
docker compose up -d
```

**Thứ tự bắt buộc: migrate (owner) TRƯỚC, tạo role app SAU** — script từ chối chạy khi chưa có bảng `_prisma_migrations` (nếu không, bảng đó tạo sau sẽ thừa hưởng quyền CRUD cho role app).

```powershell
pnpm --filter @vexenhanh/api exec prisma migrate deploy
pnpm --filter @vexenhanh/api db:app-role
```

Script idempotent (chạy lại bao nhiêu lần cũng được), gửi mật khẩu dưới dạng verifier SCRAM (không lộ trong log server), xoá tham số mặc định gắn vào role, và **báo lỗi to** nếu role app có bất kỳ thuộc tính nào vượt được RLS (SUPERUSER, BYPASSRLS, CREATEROLE, là thành viên role khác...).

Kiểm role **thật sự** không vượt được RLS:

```powershell
docker compose exec -T postgres psql -U vexenhanh -d vexenhanh_dev -c "select rolname, rolsuper, rolbypassrls, rolcreaterole from pg_roles where rolname in ('vexenhanh','vexenhanh_app');"
```

→ `vexenhanh_app | f | f | f`. (`vexenhanh` là `t` — bình thường, nó chỉ dùng để migrate.)

---

## 2. Seed + kiểm RLS đã bật

```powershell
pnpm --filter @vexenhanh/api db:seed
```

Kiểm 4 bảng đã bật **và ép** RLS:

```powershell
docker compose exec -T postgres psql -U vexenhanh -d vexenhanh_dev -c "select relname, relrowsecurity, relforcerowsecurity from pg_class where relname in ('operator_accounts','employee_accounts','auth_sessions','operator_profiles') order by relname;"
```

→ cả 4 bảng `t | t`. `operator_profiles`: ai cũng **đọc** được (hồ sơ công khai), nhưng chỉ ngữ cảnh `platform`/`system` được **ghi** — không có policy này thì role app sửa/xoá được tenant bất kỳ.

---

## 3. ⭐ Soi RLS bằng tay (TC-SEC-001) — đăng nhập psql bằng **role app**

Tạo tenant thứ hai để có dữ liệu chéo (chạy bằng owner — superuser local nên không vướng RLS):

```powershell
docker compose exec -T postgres psql -U vexenhanh -d vexenhanh_dev -c "insert into operator_profiles (id, operator_slug, display_name, updated_at) values ('00000000-0000-0000-0000-00000000000b','tenantb','Tenant B', now()) on conflict do nothing; insert into employee_accounts (id, operator_id, username, password_hash, role, updated_at) values ('00000000-0000-0000-0000-0000000000e2','00000000-0000-0000-0000-00000000000b','spy','x','DRIVER', now()) on conflict do nothing;"
```

Mở psql bằng role app:

```powershell
docker compose exec -T postgres psql "postgresql://vexenhanh_app:vexenhanh_app_dev@localhost:5432/vexenhanh_dev" -c "select count(*) as khong_ngu_canh from employee_accounts;"
```

→ **0** (không set ngữ cảnh ⇒ không thấy gì — fail-closed).

```powershell
$A = (docker compose exec -T postgres psql -U vexenhanh -d vexenhanh_dev -t -A -c "select id from operator_profiles where operator_slug='phuongtrang';").Trim()
docker compose exec -T postgres psql "postgresql://vexenhanh_app:vexenhanh_app_dev@localhost:5432/vexenhanh_dev" -c "begin; select set_config('app.scope','tenant',true), set_config('app.operator_id','$A',true); select username, operator_id from employee_accounts; commit;"
```

→ chỉ thấy nhân viên của `phuongtrang` (vd `driver042`), **không** thấy `spy` của tenant B — dù câu `select` không có `where`.

Thử ghi chéo tenant (phải **bị từ chối**):

```powershell
docker compose exec -T postgres psql "postgresql://vexenhanh_app:vexenhanh_app_dev@localhost:5432/vexenhanh_dev" -c "begin; select set_config('app.scope','tenant',true), set_config('app.operator_id','$A',true); update employee_accounts set username='hacked' where id='00000000-0000-0000-0000-0000000000e2'; insert into employee_accounts (id, operator_id, username, password_hash, role, updated_at) values (gen_random_uuid(),'00000000-0000-0000-0000-00000000000b','x','x','DRIVER',now()); rollback;"
```

→ `UPDATE 0` (không thấy row để sửa) và INSERT báo **`new row violates row-level security policy`**.

Ngữ cảnh không rò sang transaction sau:

```powershell
docker compose exec -T postgres psql "postgresql://vexenhanh_app:vexenhanh_app_dev@localhost:5432/vexenhanh_dev" -c "begin; select set_config('app.scope','system',true); commit; select current_setting('app.scope', true) as sau_commit, count(*) from employee_accounts;"
```

→ `sau_commit` rỗng, `count` = 0.

Tenant không được **ghi** `auth_sessions` (kể cả phiên của mình) và không sửa/xoá được `operator_profiles`:

```powershell
docker compose exec -T postgres psql "postgresql://vexenhanh_app:vexenhanh_app_dev@localhost:5432/vexenhanh_dev" -c "begin; select set_config('app.scope','tenant',true), set_config('app.operator_id','$A',true); update auth_sessions set subject_type='PLATFORM' where operator_id='$A'; update operator_profiles set status='ACTIVE' where id='$A'; delete from operator_profiles where id='00000000-0000-0000-0000-00000000000b'; rollback;"
```

→ ba câu đều `UPDATE 0` / `DELETE 0`. (Nếu tenant sửa được `subject_type` thì refresh sẽ ra token PLATFORM — đó là lý do phiên chỉ cho `system` ghi.)

Dọn tenant B:

```powershell
docker compose exec -T postgres psql -U vexenhanh -d vexenhanh_dev -c "delete from employee_accounts where id='00000000-0000-0000-0000-0000000000e2'; delete from operator_profiles where id='00000000-0000-0000-0000-00000000000b';"
```

---

## 4. Test tự động (Postgres thật, role app)

> CI chạy đúng các test này ở workflow **`db-integration.yml`** (Postgres + Redis + Mongo thật, migrate bằng owner, test bằng role app, `REQUIRE_DB_TESTS=1` nên thiếu DB là đỏ chứ không skip).

```powershell
$env:DATABASE_URL = "postgresql://vexenhanh_app:vexenhanh_app_dev@localhost:5432/vexenhanh_dev?schema=public"
$env:MIGRATION_DATABASE_URL = "postgresql://vexenhanh:vexenhanh_dev@localhost:5432/vexenhanh_dev?schema=public"
pnpm --filter @vexenhanh/api exec vitest run src/database src/iam
```

Mong đợi: test RLS + guard + toàn bộ test IAM-002 xanh. File RLS **tự đỏ** nếu `DATABASE_URL` là superuser/BYPASSRLS — đó là chủ ý, đừng "sửa" bằng cách đổi sang owner.

---

## 5. Hồi quy IAM-001/002 dưới role app

```powershell
pnpm --filter @vexenhanh/api build
pnpm --filter @vexenhanh/api start
```

Rồi chạy lại các lệnh 4A (login platform), 4B (refresh), 4E (logout) của `IAM-002-guide.md`, thêm login operator:

```powershell
$base = "http://localhost:3000/v1"
curl.exe -s -w "`n[%{http_code}]`n" -X POST "$base/auth/operator/login" -H "Content-Type: application/json" -d '{"identifier":"phuongtrang/owner01","password":"<SEED_OPERATOR_PASSWORD>"}'
```

→ 200 như trước IAM-003. Login operator đọc `operator_accounts` **trước** khi biết tenant — nếu ra 401 thì là quên `withSystem` ở luồng login (xem §6).

---

## 6. Gỡ vướng

| Hiện tượng | Nguyên nhân thật |
| ---------- | ---------------- |
| Login operator/employee 401 dù đúng mật khẩu | Truy vấn account chạy **ngoài** ngữ cảnh → RLS trả 0 row → trông như "account không tồn tại". Bọc bằng `withSystem` (chỉ trong `iam/`). |
| Query trả rỗng khó hiểu ở module mới | Quên `withTenant`/`withScope`. Fail-closed là chủ ý — **đừng** chuyển sang `withSystem` để "chữa"; ESLint cũng sẽ chặn. |
| `permission denied for table ...` | Role app thiếu GRANT (bảng tạo sau khi chạy script bằng một owner khác). Chạy lại `db:app-role`. |
| `prisma migrate` báo `permission denied` / `must be owner` | Đang migrate bằng role app. Kiểm `MIGRATION_DATABASE_URL`. |
| `db:app-role` báo "Chưa có bảng _prisma_migrations" | Chạy `prisma migrate deploy` trước (§1). |
| Production không khởi động: "RLS không có hiệu lực — từ chối khởi động" | `DATABASE_URL` đang là owner/superuser/BYPASSRLS, hoặc một bảng trong `RLS_TABLES` chưa FORCE RLS. Chủ ý: thà không chạy còn hơn chạy "an toàn giả". Làm §7. |
| Module mới báo lỗi ESLint `system-db-context` | Đang tự dựng ngữ cảnh (`withPlatform`, `withTenant`, `{ kind: "platform" }`, `set_config`...). Dùng `withScope(authz.db, …)` với scope `@Authz()` trao. |
| Test RLS đỏ với thông báo "superuser/BYPASSRLS" | `DATABASE_URL` đang trỏ owner. Đổi sang role app (§1). |

---

## 7. Production (Supabase/Neon) — bước ops một lần

1. `prisma migrate deploy` bằng owner (`MIGRATION_DATABASE_URL` = owner production).
2. Chạy `db:app-role` với cùng `MIGRATION_DATABASE_URL` và `DATABASE_URL` = URL role app **mới** (mật khẩu mạnh, sinh ngẫu nhiên).
3. Đổi `DATABASE_URL` của service Render sang role app. **Không** thêm `MIGRATION_DATABASE_URL` vào env service API/worker.
4. Kiểm `rolsuper`/`rolbypassrls` = `f` như §1.

⚠️ **Làm đủ 4 bước TRƯỚC khi deploy code IAM-003.** Ở `NODE_ENV=production`, API/worker **từ chối khởi động** nếu role đang dùng vượt được RLS (superuser, BYPASSRLS, owner bảng) hoặc một bảng tenant chưa FORCE RLS (`PrismaService.rlsProblems()`).

---

## 8. Bảng kỳ vọng tổng

| Case | Kết quả |
| ---- | ------- |
| Role app: `rolsuper`, `rolbypassrls` | `f`, `f` |
| 4 bảng (`operator_profiles`, `operator_accounts`, `employee_accounts`, `auth_sessions`): `relrowsecurity`, `relforcerowsecurity` | `t`, `t` |
| Không ngữ cảnh | 0 row |
| Ngữ cảnh tenant A | Chỉ row của A, dù query không lọc |
| UPDATE row tenant B từ ngữ cảnh A | `UPDATE 0` |
| INSERT row gắn tenant B từ ngữ cảnh A | Lỗi `row-level security policy` |
| Sau COMMIT | `app.scope` rỗng |
| Tenant sửa `auth_sessions` / sửa-xoá `operator_profiles` | 0 row |
| Xoá `operator_profiles` còn account (kể cả system) | Lỗi FK (RESTRICT — cascade sẽ vượt RLS) |
| Gọi route `@Authorize` không token | 401 `AUTH_SESSION_EXPIRED` |
| Token hợp lệ, role không có quyền | 403 `PERMISSION_DENIED` |
| Quyền phạm vi tenant, token platform / slug hoặc `:operatorId` URL khác claim | 403 `TENANT_SCOPE_VIOLATION` |
| Token ký hợp lệ nhưng role không thuộc scope (vd `platform` + `PASSENGER`), hoặc token operator thiếu claim tenant | 401 `AUTH_SESSION_EXPIRED` (chặn ngay khi verify) |
| Login operator/platform/OTP, refresh, logout | Như IAM-002 |

---

## 9. Dọn

```powershell
docker compose stop
```

## Lưu ý phạm vi

- Quyền riêng từng role Employee, ABAC theo phân công → task EMP. Guest đọc dữ liệu công khai của tenant (scope `public`) → task MKT.
- TOTP → IAM-004. Cấp/khoá account, FR-IAM-15 → IAM-005.
