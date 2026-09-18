# TASK-IAM-003 — Todo: RBAC 8-role + TenantGuard (JWT claims) + Postgres RLS

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` dòng 140 — _"RBAC 8-role + TenantGuard (JWT claims) + Postgres RLS"_ (`FR-IAM-06`, ADR-011/017). Nguồn thiết kế: **ADR-017** (RBAC 8 role hardcoded enum v1, ABAC defer; TenantGuard), **ADR-011** (RLS defense-in-depth), Security **§6** (tenant boundary) + **§7** (permission matrix), DB **DB-PRIN-01**, HLD-PRIN-05, LLD §7 (`PERMISSION_DENIED`, `TENANT_SCOPE_VIOLATION`), API §7.3/§7.4, `FR-IAM-05/06/08`, BR-08, BR-43, TC-SEC-001.
> **Dependency:** TASK-IAM-002 ✓ (merge PR #5, CI xanh) — `AccessTokenGuard` + `@CurrentUser()` + JWT claim `sid/scope/role/operatorId/operatorSlug`.
> **Cách dùng:** tick `[x]` khi xong. Guide chạy tay: `IAM-003-guide.md`. Nghiệm thu: `IAM-003-verification-checklist.md`.

## Trạng thái (18/09/2026) — 🟡 **CODE XONG `.1`–`.9`, CHỜ KHANH COMMIT + CI**

- Branch `TASK-IAM-003` đã tạo từ `develop` sau khi merge IAM-002.
- ✅ **Đo được (18/09/2026)**: API **248/248** test chạy bằng **role app** trên Postgres/Redis/Mongo thật (gồm toàn bộ test IAM-002 → không hồi quy); mô phỏng job CI `db-integration` trên DB **mới tinh** 248/248; `pnpm turbo run typecheck lint test build` xanh; smoke API thật 11/11 (login owner/employee/platform, refresh, reuse, logout, re-auth); guide §3 chạy tay đúng từng dòng. Đột biến có chủ đích (policy RLS, kiểm slug/operatorId, bảng quyền, policy ghi phiên/hồ sơ) → test đỏ mỗi lần.
- ✅ **Review** `code-reviewer` + `security-auditor` đã chạy; mọi finding đã xử lý hoặc ghi follow-up — xem **"Ghi nhận khi hiện thực"**.
- Nền có sẵn: `AccessTokenGuard` (authn-only, comment ghi rõ ranh giới với IAM-003), `VerifiedAccessToken` (`role`, `scope`, `operatorId`, `operatorSlug`), `PrismaService.withOperatorContext` (FND-003, **chưa ai gọi**, policy mẫu trong comment sai kiểu `::bigint`).
- ⚠️ **Thực tế lệch thiết kế, phát hiện khi đọc code**: `DATABASE_URL` hiện dùng `vexenhanh` — role **SUPERUSER** do Docker tạo. Superuser bỏ qua RLS kể cả khi `FORCE`, nên mọi test RLS chạy bằng role này sẽ **xanh giả**. Đây là lý do có Q3.

---

## Phạm vi & ranh giới

| Thuộc IAM-003                                                                                   | Để task sau                                                                                     |
| ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| Danh mục **8 role** + **danh mục quyền** + bảng role→quyền (một file, theo Security §7)          | Quyền chi tiết theo **từng** role Employee (BR-43) → task EMP; hiện 3 role Employee dùng chung   |
| `PermissionGuard` + `TenantGuard` + decorator `@Authorize()` gộp cả chuỗi guard                  | Endpoint nghiệp vụ dùng các guard này → TRN/BTP/OPR/EMP/ADM                                     |
| Hàm `can(actor, permission)` thuần — chỗ cắm ABAC sau này (thêm `context` tuỳ chọn khi cần)       | ABAC thật (assignment, ownership theo resource) → task EMP/BTP khi có resource                  |
| Role Postgres `vexenhanh_app` (không superuser, không BYPASSRLS) + tách URL migrate              | Tạo role trên DB production (Supabase/Neon) = **bước ops**, ghi trong guide §7                  |
| RLS `ENABLE + FORCE` trên **4 bảng**: `operator_accounts`, `employee_accounts` (tenant đọc/ghi), `auth_sessions` (tenant chỉ đọc, `system` ghi), `operator_profiles` (ai cũng đọc, platform/system ghi) | RLS cho bảng nghiệp vụ (vehicles, trips, bookings...) → **mỗi task tạo bảng tự áp** theo mẫu ở đây |
| `DbScope` có brand + 3 ngữ cảnh `withTenant`/`withPlatform`/`withSystem`; ESLint chặn tự dựng ngữ cảnh ngoài `iam/auth`, `iam/session`, `iam/role`, `database` | Scope `public` (Guest đọc dữ liệu công khai của tenant) → task MKT khi có bảng cần               |
| Chuyển mọi truy vấn IAM hiện có sang ngữ cảnh tường minh (login, session, cleanup, seed)         | TOTP (IAM-004), cấp/khoá account + FR-IAM-15 (IAM-005)                                         |

**Không làm**: role/quyền lưu DB (Q1), endpoint mới trong API §7 (chưa có consumer nào ở IAM-003), RLS trên `platform_accounts`/bảng Better Auth (không thuộc tenant nào).

---

## 4 quyết định — ✅ **ĐÃ CHỐT 18/09/2026** (Khanh chọn cả 4 theo khuyến nghị)

| #      | Câu hỏi | Quyết định | Lý do / hệ quả |
| ------ | ------- | ---------- | -------------- |
| **Q1** | Mở rộng role làm theo mô hình nào? ADR-017 chốt "8 role hardcoded enum v1, ABAC defer". | ✅ **Permission trên enum** | Đúng ADR-017. Guard chỉ hỏi **quyền** (`vehicle:manage`), không bao giờ hỏi tên role. Bảng role→quyền nằm **một file**; thêm role = enum + 1 dòng bảng (+ migration enum Postgres nếu là role tài khoản), **không sửa guard/controller nào**. Role/quyền lưu DB (admin tạo role lúc chạy) sẽ đổi ADR-017 → không làm; FR-IAM-07 (admin gán quyền nội bộ) v1 đáp ứng ở mức 2 role platform. |
| **Q2** | ADR-017 nói TenantGuard khớp `:operatorSlug` trên URL (`/v1/operators/:slug/...`), API §7.3 (Approved) lại dùng `/operator/*` không slug. | ✅ **Theo API §7.3** | Tenant lấy **từ JWT**; URL không mang slug nên không có gì để giả mạo hay lệch. TenantGuard **vẫn** kiểm `:operatorSlug`/`:operatorId` nếu route nào có. ⇒ **Nghĩa vụ**: ghi chú vào ADR-017 để doc hết lệch (`.1`). |
| **Q3** | App đang chạy bằng superuser → RLS vô hiệu. | ✅ **Tách 2 role** | `vexenhanh` (owner) **chỉ migrate**, qua biến mới `MIGRATION_DATABASE_URL`. App chạy bằng `vexenhanh_app`: `NOSUPERUSER NOBYPASSRLS NOCREATEDB NOCREATEROLE`, chỉ CRUD. Script idempotent `db:app-role` tạo role + cấp quyền. Production: bước ops một lần. |
| **Q4** | Login phải đọc bảng account **trước** khi biết tenant; bật RLS là login hỏng. | ✅ **Ngữ cảnh tường minh** | Mọi truy vấn bảng tenant chạy trong `withTenant(operatorId)` / `withPlatform()` / `withSystem()`; policy đọc GUC `app.scope`. **Không set gì → 0 row** (fail-closed: quên ngữ cảnh thành lỗi "không tìm thấy", không thành rò dữ liệu). ESLint chặn `withSystem` ngoài `iam/` + worker. Một role, một pool kết nối. |

**Nghĩa vụ kéo theo (làm ở `.1`, `.9`):**

1. ADR-017: ghi chú TenantGuard lấy tenant từ JWT theo API §7.3; khớp slug URL chỉ khi route có tham số.
2. DB-PRIN-01: sửa `current_setting('app.operator_id')::bigint` → so sánh **text** (id tenant là uuid string) + mô tả GUC `app.scope`.
3. Deploy (09) / `render.yaml`: `DATABASE_URL` production phải là role app; `MIGRATION_DATABASE_URL` **không** đưa vào env của service API/worker.

---

## Thiết kế (bám doc Approved + 4 quyết định)

### 8 role (ADR-017) — một nguồn: `iam/role/role.ts`

| Role | Token `scope` | Bảng nguồn | Ghi chú |
| ---- | ------------- | ---------- | ------- |
| `ANONYMOUS` | — (không token) | — | Chỉ để `can()` trả lời cho route công khai |
| `PASSENGER` | `passenger` | `users` | |
| `OPERATOR_OWNER` | `operator` | `operator_accounts` | |
| `DRIVER` · `TICKET_STAFF` · `SUPPORT_STAFF` | `operator` | `employee_accounts` | 3 role dùng chung quyền tới khi task EMP tách (BR-43) |
| `PLATFORM_ADMIN` · `PLATFORM_SUPPORT` | `platform` | `platform_accounts` | |

Role trong JWT lạ (không thuộc danh mục) → **không có quyền nào** (fail-closed) + log cảnh báo.

### Danh mục quyền (Security §7 — chỉ ô **rõ nghĩa**; ô có điều kiện để task sở hữu quyết)

Mỗi grant = `quyền + phạm vi`: `any` (toàn hệ thống) · `tenant` (trong Operator của mình) · `assigned` (theo phân công — ABAC, task EMP) · `own` (của chính mình).

| Quyền | Nguồn | ANONYMOUS | PASSENGER | OPERATOR_OWNER | 3 role Employee | PLATFORM_ADMIN | PLATFORM_SUPPORT ⚠️ |
| ----- | ----- | --------- | --------- | -------------- | --------------- | -------------- | ------------------- |
| `trip:search` | §7 Search trip | any | any | tenant | — | any | any |
| `booking:create` | §7 Create booking | own (guest session) | own | — ¹ | — | — ¹ | — |
| `payment:create` | §7 Payment | own | own | — | — | — | — |
| `payment:monitor` | §7 Payment "giám sát/đối soát" | — | — | — | — | any | any |
| `refund:request` | §7 Cancel/refund | own (đã xác minh) | own | tenant | — | any | — |
| `vehicle:manage` | §7 Vehicle/SeatMap | — | — | tenant | — | — | — |
| `vehicle:read` | §7 Vehicle/SeatMap | — | — | tenant | assigned | any | any |
| `checkin:perform` | §7 Check-in | — | — | — | assigned | — | — |
| `checkin:read` | §7 Check-in | — | — | tenant | — | any | any |
| `kyc:submit` | §7 KYC "hồ sơ của mình" | — | — | tenant | — | — | — |
| `kyc:review` | §7 KYC | — | — | — | — | any | — |
| `finance:read` | §7 Policy/commission/payout "xem phần liên quan" | — | — | tenant | — | any | any |
| `finance:configure` | §7 Policy/commission/payout | — | — | — | — | any | — |
| `audit:read` | §7 Audit log | — | — | — ² | — | any | — |
| `employee:manage` | API §7.3 `/operator/employees`, FR-IAM-05 | — | — | tenant | — | — | — |
| `account:lock` | FR-IAM-08 (Admin, Nhà xe) | — | — | tenant | — | any | — |

¹ "Có thể hỗ trợ nếu được phép" → task BTP quyết. ² "Log của tenant nếu được cấp" → task audit/report quyết.
⚠️ **`PLATFORM_SUPPORT` là giả định**: Security §7 chỉ có một cột "Admin". Chọn **tối thiểu quyền**: chỉ các quyền đọc/giám sát, không duyệt/cấu hình/hoàn tiền. Khanh đổi thì chỉ sửa một dòng.

### Chuỗi guard

`@Authorize("vehicle:manage")` = `AccessTokenGuard` (IAM-002, 401) → `PermissionGuard` (403 `PERMISSION_DENIED`) → `TenantGuard` (403 `TENANT_SCOPE_VIOLATION`) + `@ApiBearerAuth()` + mô tả lỗi OpenAPI.

- `PermissionGuard`: `can(actor, permission)` → gắn **quyết định** (`permission`, `scope`) vào request.
- `TenantGuard`: grant phạm vi `tenant`/`assigned` ⇒ token **phải** scope `operator` và có `operatorId`; route có `:operatorSlug`/`:operatorId` ⇒ phải khớp claim. Đưa ra `DbScope` cho service.
- Controller lấy `@Authz()` → truyền `DbScope` xuống service → `prisma.withScope(scope, tx => ...)`.

### RLS — một hàm policy, một policy mỗi bảng

```sql
app_rls_allows(row_operator_id text) :=
  CASE current_setting('app.scope', true)
    WHEN 'system'   THEN true            -- auth, session, cron — chỉ trong iam/ + worker (ESLint)
    WHEN 'platform' THEN true            -- admin (PLATFORM_*) — chỗ siết lại sau nếu cần
    WHEN 'tenant'   THEN row_operator_id = current_setting('app.operator_id', true)
    ELSE false                           -- KHÔNG set gì → 0 row
  END
```

`ENABLE` + `FORCE ROW LEVEL SECURITY` + `POLICY ... USING (...) WITH CHECK (...)` trên `operator_accounts`, `employee_accounts`, `auth_sessions`. GUC set bằng `set_config(..., true)` = **transaction-local** → không rò sang request khác dùng chung kết nối pool.

`operator_profiles` **có** RLS nhưng khác 3 bảng kia (sau review): ai cũng **đọc** (hồ sơ công khai cho Guest, API §7.2); chỉ `platform`/`system` được **ghi** — tenant tự sửa hồ sơ để task OPR-001 (phải chặn tự đổi `status`). `auth_sessions`: tenant chỉ **đọc**, chỉ `system` được ghi (tenant sửa được `subject_type` là leo quyền lên admin qua refresh) + CHECK phiên phía Operator bắt buộc `operator_id`. FK account → `operator_profiles` đổi `CASCADE` → **`RESTRICT`** (hành động cascade chạy với quyền owner, vượt RLS). Slug tenant bắt buộc chữ thường. Không bật RLS ở `platform_accounts`/`users`/bảng Better Auth (không thuộc tenant nào).

### Cách thêm role mới (playbook mở rộng — yêu cầu của Khanh)

1. Role tài khoản mới (vd `DISPATCHER` cho Operator): thêm giá trị vào enum Prisma (`EmployeeRole`…) + `prisma migrate dev`.
2. Thêm vào `Role` trong `iam/role/role.ts`.
3. Thêm **một dòng** vào `ROLE_GRANTS`. TypeScript **báo lỗi** nếu thiếu (bảng khai `Record<Role, …>`); test bất biến **đỏ** nếu enum Postgres có giá trị mà bảng chưa có, hoặc role phía operator nhận grant `any`.
4. Không sửa guard, controller, policy RLS nào.

Thêm quyền mới: thêm vào `PERMISSIONS` + grant cho các role cần. Nâng lên ABAC: thêm tham số `context` **tuỳ chọn** vào `can()` và luật theo resource ở đó — lời gọi cũ không phải đổi (không thêm sẵn tham số chưa ai dùng).

---

## Todo (ID = thứ tự thực hiện)

### ✅ #1 — [IAM-003.1] Chốt 4 quyết định + ghi chú doc

Chốt 18/09/2026: Q1–Q4 theo khuyến nghị. Ghi chú ADR-017 (Q2) + DB-PRIN-01 (kiểu text, `app.scope`) làm cùng `.9`.

### ✅ #2 — [IAM-003.2] Role Postgres `vexenhanh_app` + tách URL migrate

- Script idempotent `apps/api/scripts/db-app-role.mjs` (`pnpm --filter @vexenhanh/api db:app-role`): đọc `MIGRATION_DATABASE_URL` (owner) + `DATABASE_URL` (app); tạo/cập nhật role app đúng thuộc tính; `GRANT` CRUD + sequence + `ALTER DEFAULT PRIVILEGES` cho bảng tạo sau; **từ chối chạy** nếu hai URL cùng user.
- `prisma.config.ts` migrate bằng `MIGRATION_DATABASE_URL` (fallback `DATABASE_URL` để CI/máy cũ không vỡ). Seed dùng owner.
- `.env.example` ghi rõ hai biến.

**Success:** `select rolsuper, rolbypassrls from pg_roles where rolname='vexenhanh_app'` → `f|f`; app login bằng role mới; script chạy lần 2 không lỗi.

### ✅ #3 — [IAM-003.3] Migration RLS

Hàm `app_rls_allows` + `ENABLE/FORCE` + policy trên 4 bảng (xem "Thiết kế" — sau review). Kiểm `prisma migrate diff` sau đó **không** sinh lệnh xoá policy.

**Success:** migration chạy trên DB trống; `\d` 3 bảng có `Policies (forced row security enabled)`.

### ✅ #4 — [IAM-003.4] 3 ngữ cảnh DB + ESLint

`PrismaService.withTenant(operatorId, fn)` / `withPlatform(fn)` / `withSystem(fn)` / `withScope(scope, fn)` (thay `withOperatorContext`). Rule `vexenhanh-boundaries/system-db-context` chặn `withSystem` ngoài `apps/api/src/iam/**` và worker.

**Success:** test ESLint rule (đúng chỗ → sạch, sai chỗ → lỗi).

### ✅ #5 — [IAM-003.5] Đưa code IAM hiện có qua ngữ cảnh tường minh

Login operator/employee, `loadSessionOwner`, toàn bộ `SessionService`, cleanup worker, seed, test int. **Không đổi hành vi IAM-001/002.**

**Success:** toàn bộ test IAM-002 (unit + int + e2e) xanh khi chạy bằng **role app**; smoke login + refresh + logout chạy thật.

### ✅ #6 — [IAM-003.6] `iam/role/`: Role + quyền + `can()`

`role.ts`, `permissions.ts` (`PERMISSIONS`, `ROLE_GRANTS`), `can()` thuần (không DI) + test bất biến.

**Success:** test bảng quyền khớp bảng trên; role lạ → không quyền; mọi role có mặt trong bảng; enum Prisma ⊆ `Role`.

### ✅ #7 — [IAM-003.7] Guards + decorator

`PermissionGuard`, `TenantGuard`, `@Authorize()`, `@Authz()`; lỗi RFC 7807 `PERMISSION_DENIED` / `TENANT_SCOPE_VIOLATION` (LLD §7).

**Success:** e2e qua HTTP thật trên controller test: 401 / 403 PERMISSION_DENIED / 403 TENANT_SCOPE_VIOLATION / 200 đúng scope.

### ✅ #8 — [IAM-003.8] Test bắt buộc tenant-RLS (ADR-025, TC-SEC-001)

Chạy bằng **role app** trên Postgres thật:

- Tenant A **không** đọc/sửa/xoá được row của tenant B (`employee_accounts`, `auth_sessions`) kể cả khi **cố ý bỏ filter** trong query.
- Không set ngữ cảnh → 0 row; `WITH CHECK` chặn INSERT/UPDATE gắn `operator_id` tenant khác.
- GUC không rò: transaction sau trên cùng kết nối không còn `app.scope`.
- Test tự **đỏ** nếu `DATABASE_URL` là superuser hoặc có BYPASSRLS (chống xanh giả).

### ✅ #9 — [IAM-003.9] Đồng bộ doc

ADR-017 (Q2), DB-PRIN-01, `render.yaml`/Deploy (Q3), `.env.example`, `PROJECT-STATE §7`.

### 🟡 #10 — [IAM-003.10] Review + smoke + đóng task

`code-reviewer` + `security-auditor`; chạy `IAM-003-guide.md`; tick checklist; `pnpm turbo run typecheck lint test build`.

---

## Ghi nhận khi hiện thực (18/09/2026)

Sau `code-reviewer` + `security-auditor` (không finding critical/high/blocker). Đã sửa, có test:

| # | Finding | Sửa |
| - | ------- | --- |
| 1 | `withPlatform()` vượt RLS như `withSystem()` mà không bị chặn; module nghiệp vụ tự dựng `DbScope` được | `DbScope` có **brand** (không tự viết literal được) + hàm dựng `tenantScope/platformScope/systemScope`; ESLint chặn mọi hàm dựng/`with*` ngoài `iam/auth`, `iam/session`, `iam/role`, `database` (**`iam/user` không được miễn** — sẽ CRUD account tenant); chặn luôn `$queryRawUnsafe`/`$executeRawUnsafe` và chuỗi `set_config`/`app.scope` ngoài `database/` |
| 2 | Test tenant-RLS bắt buộc (ADR-025) **chưa từng chạy ở CI** | Workflow mới **`db-integration.yml`**: Postgres + Redis + Mongo thật, migrate bằng owner → `db:app-role` → toàn bộ test bằng role app; `REQUIRE_DB_TESTS=1` → thiếu DB là **đỏ** chứ không skip. Đã mô phỏng trên DB mới tinh: 248/248 |
| 3 | Cascade FK từ `operator_profiles` vượt RLS; role app sửa/xoá được tenant bất kỳ | RLS cho `operator_profiles` (đọc công khai, ghi chỉ platform/system) + FK `RESTRICT` |
| 4 | Tenant ghi được `auth_sessions` → đổi `subject_type` thành PLATFORM rồi refresh ra token admin | Split policy: tenant chỉ SELECT, chỉ `system` ghi + CHECK `auth_sessions_operator_matches_subject` + `loadSessionOwner` đối chiếu `account.operatorId === session.operatorId` |
| 5 | Không gì bảo đảm RLS thật sự có hiệu lực khi chạy | `PrismaService.rlsProblems()`; ở `NODE_ENV=production` API/worker **từ chối khởi động** nếu role là superuser/BYPASSRLS/owner hoặc một bảng trong `RLS_TABLES` chưa FORCE RLS |
| 6 | Login/refresh dùng `withSystem` dù đã biết tenant | Đổi sang `withTenant(operatorId)` — Postgres tự chặn account tenant khác. `withSystem` giờ chỉ còn ở `SessionService` (tra theo hash/sid) + cron dọn phiên |
| 7 | Token ký hợp lệ nhưng role lệch scope (vd `platform` + `PASSENGER`) vẫn tới guard | `ROLE_SCOPE` trong `role.ts` (thêm role phải khai scope — TypeScript bắt) + TokenService từ chối token lệch hoặc token operator thiếu claim tenant → 401 |
| 8 | `db-app-role` hỏng khi chạy lại trên Postgres managed; lỗ nhỏ (mật khẩu thô trong log, tham số mặc định của role, membership, `_prisma_migrations`, DB/schema lệch) | Role đã có → chỉ đổi mật khẩu (verifier **SCRAM**), `RESET ALL`, kiểm đủ thuộc tính + membership rồi báo to; bắt buộc migrate trước; kiểm hai URL cùng host/port/DB/schema; đọc `?schema=` |
| 9 | `@Authorize` đặt trên class → 500; `withTenant("")` ném đồng bộ | `Authorize()` trả `MethodDecorator` (đặt trên class là lỗi compile, có test `@ts-expect-error`); 3 hàm `with*` thành `async` |
| 10 | Slug tenant so không phân biệt hoa/thường nhưng DB phân biệt | CHECK chữ thường trên `operator_profiles` + `operator_accounts` |

**Follow-up (ngoài phạm vi / cần Khanh quyết):**

- **Hiệu năng**: policy RLS dạng CASE không dùng được index → service **vẫn phải** lọc `operator_id` tường minh (RLS là lớp chặn cuối). Mỗi lần gọi `withScope` là một transaction (BEGIN + set_config + query + COMMIT, chịu giới hạn 2s chờ / 5s chạy của Prisma) — gom query vào một lần gọi.
- `operator_accounts.operator_slug` là bản sao của slug: tenant ghi account có thể gắn slug tenant khác (audit L4). Nên thay bằng FK phức hợp `(operator_id, operator_slug)` hoặc bỏ cột → quyết ở **IAM-005** (nơi đầu tiên tenant ghi account).
- Quyền `PLATFORM_SUPPORT` (chỉ đọc) và 3 role Employee dùng chung quyền là **giả định** — xác nhận/tách ở task ADM/EMP.
- Ngữ cảnh `public` cho Guest đọc dữ liệu công khai của tenant (trip search) → task MKT.

## Rủi ro đã thấy trước

| Rủi ro | Xử lý |
| ------ | ----- |
| Test RLS chạy bằng superuser → xanh giả | Test tự kiểm `rolsuper`/`rolbypassrls` của kết nối, đỏ nếu sai |
| Quên ngữ cảnh ở một truy vấn → lỗi "không thấy dữ liệu" khó hiểu | Fail-closed là chủ ý; lỗi hiện ra ngay ở test/dev chứ không thành rò dữ liệu. Ghi rõ trong guide §6 |
| `withSystem`/`withPlatform` lan ra module nghiệp vụ → RLS thành hình thức | `DbScope` có brand + ESLint chặn ngoài `iam/auth`, `iam/session`, `iam/role`, `database` |
| GUC rò giữa các request qua pool | `set_config(..., true)` transaction-local + test chứng minh |
| Production chưa tạo role app mà đã deploy code mới | Code **vẫn chạy** (mọi truy vấn đều set ngữ cảnh), chỉ là RLS chưa có hiệu lực thật tới khi đổi `DATABASE_URL`. Guide §7 ghi bước ops |
| Prisma migrate coi policy/hàm là drift và sinh lệnh xoá | Kiểm `prisma migrate diff` ở `.3` |
