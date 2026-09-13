# TASK-IAM-001 — Todo: Better Auth + login 3-namespace

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` dòng 132 — *"Better Auth + custom NestJS adapter; login 3-namespace (Email/OTP/OAuth + `{slug}/{username}` + `platform/{username}`)"*. Nguồn thiết kế: `FR-IAM-*`, ADR-017/020.
> **Dependency:** TASK-FND-006 ✓ (Done).
> **Cách dùng:** file này là **bản chụp để xem** (đồng bộ với task system của phiên). Tick `[x]` khi xong; AI cập nhật trạng thái khi làm.

## Trạng thái (09/09/2026)
- ✅ **.1 → .10 DONE**; **.11 đang chạy**. 2 review bắt buộc (`code-reviewer` + `security-auditor`) **đã xong**, toàn bộ finding chặn task đã sửa.
- **Test**: 70 test IAM / **103 test API** — typecheck + lint + test + build **36/36 xanh**.
- **Không còn quyết định treo** — argon2 ↔ scrypt đã chốt 09/09/2026 (giữ scrypt, sửa doc). Còn lại chỉ là phần đóng task của `.11`.

### Review 08/09/2026 — đã sửa
| # | Vấn đề | Sửa |
| --- | --- | --- |
| SEC-H1 | scrypt 128 MiB/lần + **không giới hạn tần suất** trên 3 cổng login → DoS không cần xác thực (10 request song song = 1,25 GB trên instance Render free 512 MB) và brute-force không giới hạn | `assertCanAttemptLogin` đếm theo **cả identifier lẫn IP** (10/giờ, 30/giờ) chặn **trước** khi chạm DB/scrypt; semaphore giới hạn 2 phép scrypt song song |
| SEC-H2 | Thiếu `RESEND_API_KEY` ở production → âm thầm rơi về `ConsoleEmailNotifier` **in OTP nguyên văn ra log** → chiếm tài khoản chỉ bằng quyền đọc log | `RESEND_API_KEY` vào nhánh fail-fast production; `ConsoleEmailNotifier` throw ở production; OTP chuyển sang field object (redact được) thay vì nội suy vào chuỗi |
| SEC-H3 | Seed không chặn production, mật khẩu mặc định nằm trong repo, `update:` **reset cả `role` và `status`** → chạy nhầm là mở khoá + nâng quyền `platform/khanh` | Chặn `NODE_ENV=production`; bỏ mọi mật khẩu mặc định (`requirePassword`); `update:` chỉ đổi `passwordHash` |
| SEC-M1 | Nhánh owner tra theo `operator_slug` denormalized mà **không đối chiếu `operatorId`** → tenant bị SUSPENDED vẫn login được; JWT mang `operatorId` và `operatorSlug` của **hai tenant khác nhau** → IAM-003 sẽ có TenantGuard và RLS bất đồng | Đối chiếu `owner.operatorId === operatorId`; mint claim `operatorSlug` từ **DB** thay vì input người dùng |
| CR-A2 | 6 endpoint auth **không có trong OpenAPI** → `gen:api-client` sinh client thiếu toàn bộ auth, CI vẫn xanh | `AuthController` vào `OpenApiModule`; **assert hồi quy** trong `openapi.spec.ts` |
| CR-A3 | Redis chết trả 500 thay vì 503 (sai ADR-015) | `SERVICE_UNAVAILABLE` 503, fail-closed |
| CR-A5 | `catch {}` rỗng khi gửi OTP; lỗi hạ tầng bị map thành 401 + ghi audit `otp_invalid` sai sự thật | Log lỗi (email đã mask); chỉ map 401 khi là lỗi client của Better Auth, còn lại rethrow |
| CR-A6 | `INCR` + `EXPIRE` không nguyên tử → lỗi đúng khe giữa hai lệnh làm key mất TTL → **email đó vĩnh viễn không đăng nhập được** | Gộp vào một script Lua |
| SEC-L1 | Tham số cost của dummy hash hardcode tách rời `CredentialService` → nâng cost là timing oracle quay lại | `DUMMY_PASSWORD_HASH` export từ chính `CredentialService`; test khoá hai bên cùng tham số |
| SEC-L2 | Không audit lần thử vào account **không tồn tại** / sai cổng → password spraying không để lại dấu vết | `recordUnknownAttempt` ghi audit với identifier đã mask; response giữ nguyên |
| SEC-L3 | `verify()` ném lỗi với hash hỏng → 500 (kênh phân biệt account) + chọn được cost khuếch đại | Validate `N` luỹ thừa 2 trong biên, `r`/`p`, độ dài; bọc try/catch trả `false` |

### ✅ Đã quyết + đã làm (Khanh chốt 09/09/2026)

| # | Quyết định | Đã làm |
| --- | --- | --- |
| 1 | **Wiring OAuth (CR-A1 / SEC-M4)** — chọn **(a) mount handler**, thu hẹp **chỉ Google** cho v1 (Facebook/Apple defer v1.x: v1 không lên store nên App Store Guideline 4.8 không ép Apple Sign-In) | `app.use("/api/auth/{*splat}", toNodeHandler(...))` trong `main.ts`, `bodyParser: false` rồi bật lại sau (toNodeHandler cần raw body). Kiểm chứng 2 lớp: đọc source `better-auth@1.6.14` (`create-context.mjs:84` + `helpers.mjs:117` → `baseURL = BETTER_AUTH_URL + "/api/auth"`, `sign-in.mjs:133` ghép `/callback/{provider}`) và chạy thật Express 5 với đúng pattern → callback vào handler, route `/v1` không bị nuốt. ⇒ **task .6 giờ DONE thật** |
| 1b | **SEC-M3 (open redirect)** — bắt buộc sửa cùng lúc | Allowlist `callbackURL` ở `AuthService.assertAllowedCallback` (lớp chặn thật, vì origin-check của Better Auth thoát sớm khi gọi server-side) + `trustedOrigins` (lớp 2) + env `AUTH_ALLOWED_CALLBACK_ORIGINS`. Test phủ `https://…evil/`, `http://localhost:3000.evil.com/cb`, `javascript:alert(1)` |
| 2 | **`GET /auth/session` (CR-A4)** — đổi thành **`POST /auth/oauth/session`** | Đã đổi + bổ sung vào OpenAPI. Bỏ được side effect trên GET (mỗi lần gọi mint token + ghi 1 audit vào collection append-only) |
| 4 | **Cost scrypt** — hạ **`N=2^16, r=8, p=2`** (64 MiB) | Đã hạ; semaphore giữ đỉnh bộ nhớ ở 128 MiB. Params nhúng trong hash nên **hash cũ vẫn verify được**, không cần migration |

### Còn lại của .11

Test đã bổ sung 09/09/2026: `platformLogin` nhánh account không tồn tại (+ khẳng định vẫn chạy dummy verify) và nhánh bị khoá; cách ly tenant khi `operatorId` lệch; allowlist `callbackURL`; `token.service` đổi `decodeJwt` → **`jwtVerify` thật** + token bị sửa phải bị từ chối + fail-fast production; `credential.service` không lưu plaintext + forward-compat cost params + hash hỏng trả `false`; SEC-OQ-08 account-linking (`auth.config.spec.ts`); rate limiter Lua + Redis chết → 503.

Chưa làm:
- **e2e Supertest** cho 6 endpoint (CR-C4) — hiện chưa có test nào chạm tầng controller/DTO; đây chính là lớp đã để lọt lỗi thiếu `requestBody` trong OpenAPI.
- Test cho `register()` (endpoint duy nhất trong API §7.1 chưa có test riêng).
- **Smoke test boot thật** theo `IAM-001-verify-guide.md` — bắt buộc trước khi tick `.11` Done: A1 là lỗi *runtime*, test xanh không chứng minh callback OAuth chạy được.
- Cập nhật `PROJECT-STATE §7` + task row 11-task IAM-001 → Done.
- Backlog không chặn: SEC-M2 (rate limit OTP chỉ theo email → lách bằng `victim+1@`, `victim+2@` để bom thư cùng một hộp), SEC-L5/L7/L8/L9/L10, CR-B1..B12.

### ✅ ĐÃ CHỐT 09/09/2026 — giữ scrypt, sửa doc

*(Trước đó mục này bị viết ở hai chỗ — trong danh sách "chờ quyết" và ở đây — nhưng chỉ là **một** việc. Đã gộp rồi đóng.)*

**Khanh chốt: giữ `scrypt`, sửa tài liệu cho khớp code.** Đã cập nhật `07-security-permission-design.md` §9 (bảng Data protection) và mục `.2` bên dưới. Bối cảnh gốc: Mục .2 của file này và `07-security-permission-design.md` §169 ("Better Auth hashing (Argon2/bcrypt)") ghi argon2; `credential.service.ts` cài **scrypt** (`N=2^16, r=8, p=2` sau quyết định 09/09/2026, params nhúng trong hash).

- **Lý do code chọn scrypt là hợp lý**: Node built-in, không cần native dependency → an toàn với Docker **distroless** (ADR-023), tránh đúng loại bẫy đã gặp với Prisma/libssl (PROJECT-STATE 03/06/2026).
- **Khuyến nghị**: giữ scrypt, sửa doc (Security §169 + mục .2 file này) cho khớp code. Cách còn lại là đổi code sang argon2 và nhận thêm native dep.
- **Kết quả**: code giữ nguyên (không đổi sang argon2, không thêm native dep); tài liệu sửa theo code. Không còn quyết định nào treo trong IAM-001.

---

## Phạm vi & ranh giới

IAM-001 dừng ở **"xác thực được danh tính"** = LLD §6.5 **bước 1–2** (resolve namespace + verify credential cho 3 cổng login). Phần còn lại của luồng auth thuộc task em:

| Thuộc IAM-001 | Để task sau |
| --- | --- |
| Better Auth + custom NestJS adapter | — |
| Bảng identity (`users`, `operator_accounts`, `employee_accounts`, `platform_accounts`) | RLS policy + FORCE RLS → **IAM-003** |
| Login 3 namespace (Email-OTP / OAuth / operator+platform password) | Hybrid token đầy đủ (opaque refresh 30d + rotation + family + Redis) → **IAM-002** |
| JWT access ngắn hạn (để login test được) | MFA TOTP (Owner/PlatformAdmin/PlatformSupport) → **IAM-004** |
| Login history (audit append-only) | Provisioning đầy đủ (closed enrollment) → **IAM-005** |

## Quyết định kỹ thuật — ĐÃ CHỐT (task .1, Khanh duyệt 08/06/2026)

1. **Backend-first**: API + identity + Better Auth + test trước; login UI (FE/Mobile) sau khi API chắc.
2. **Token tối thiểu trong IAM-001**: Better Auth dùng "headless" (chỉ verify danh tính), IAM-001 **tự phát JWT access ngắn hạn** cho cả 3 namespace; full Hybrid (opaque refresh 30d + rotation + family + `auth_sessions` + Redis) → IAM-002.
3. **OTP qua port adapter**: dev = log OTP ra console (không gửi thật) → test được ngay mà chưa cần Resend.

### Better Auth delegation map (cốt lõi)

Lý do: `user.email` của Better Auth là **unique** → nhét operator/platform chung bảng user sẽ đụng email passenger + phá Account-separate (ADR-017). DB design vốn đã chốt **4 bảng riêng** → đi theo bảng riêng.

| Namespace | Ai quản lý | Cơ chế |
| --- | --- | --- |
| **Passenger** | **Better Auth native** | `users` = user/account/verification của Better Auth; plugin **email-OTP** + OAuth Google/FB/Apple + account-linking |
| **Operator / Employee / Platform** | **Bảng domain riêng** | verify password (**scrypt**), **KHÔNG** là Better Auth user, **KHÔNG** OAuth/linking → Account-separate tuyệt đối |

> KHÔNG dùng username-plugin của Better Auth cho operator/platform (vẫn nhét vào chung bảng user → collision). Verify password custom (ít code, chuẩn, security-auditor review ở .11).

### SEC-OQ-07 (OTP rate limit) — đóng
- Verify-attempt: **3 lần/OTP** (Better Auth `allowedAttempts`). OTP TTL: **5 phút**.
- Gửi lại: cooldown **60s** + tối đa **5 lần/giờ/email**.

### SEC-OQ-08 (account-linking OAuth) — đóng
- `accountLinking.enabled = true`, chỉ link khi email **khớp + verified**.
- `trustedProviders = [google, apple]`; **Facebook** đi đường verified-match. `allowDifferentEmails = false`.
- Operator/Platform: **không linking**.

### Rủi ro flag → xử lý ở .3
Better Auth "headless" (verify xong tự mint JWT) hơi ngược thiết kế thư viện → **.3 mở đầu bằng spike timebox ~0.5 ngày**; fallback = JWT plugin của Better Auth.

## Điều kiện ngoài (external)

- ✅ ADR-017 "CRITICAL re-confirm" đã xong (Khanh confirm 01/06/2026, Security §48) → không còn blocker stack auth.
- ✅ **SEC-OQ-07 + SEC-OQ-08 đã đóng** ở task .1 (xem mục "Quyết định kỹ thuật" trên + Security §12).
- 🔧 Cần khi chạy thật (không chặn dev/test): **Google + Facebook + Apple OAuth app** + **Resend API key**. Dev/test dùng OTP console + mock OAuth. Apple Dev ($99) đã có (ADR-028).

---

## Todo (ID = thứ tự thực hiện)

### ✅ #1 — [IAM-001.1] Chốt design boundary + LLD note — DONE (08/06/2026)
Lock các quyết định kỹ thuật thành 1 ghi chú LLD (không scope-creep):
- Better Auth delegation map (Passenger → Better Auth; Operator/Platform + namespace + Account-separate → custom mỏng).
- Token boundary: IAM-001 = JWT access ngắn hạn; refresh/rotation/family/auth_sessions/Redis = IAM-002 (LLD §6.5 bước 4–5).
- Resolve SEC-OQ-07 (OTP rate limit 60s / ≤5/giờ), SEC-OQ-08 (account-linking).

**Nguồn:** ADR-017/020, Security §5, LLD §6.5.
**Success:** ghi chú quyết định + Khanh duyệt; không đổi ADR đã chốt.

### ✅ #2 — [IAM-001.2] Prisma identity schema + migration — DONE
> Migration `20260608025306_init_iam`; models `User`/`Session`/`Account`/`Verification` (Better Auth) + `OperatorProfile`/`OperatorAccount`/`EmployeeAccount`/`PlatformAccount` + 5 enum. Hash = **scrypt** (`N=2^16, r=8, p=2`) — chốt 09/09/2026, `07-security` §9 đã sửa theo.
**Gộp với .3 (Better Auth-first, Khanh duyệt 08/06/2026):** cài Better Auth → sinh bảng `user`/`account`/`session`/`verification` của nó trước, rồi tay-viết bảng domain → tránh viết-rồi-bỏ.
Schema identity Account-separate 3-namespace theo DB §Identity (dòng 96): `users`, `operator_accounts`, `employee_accounts`, `platform_accounts` + bảng Better Auth (account, session, verification).
- **`operator_profiles` tối thiểu = tenant root** (id, `operator_slug` unique, status, display_name) — Khanh duyệt 08/06/2026; OPR-001 mở rộng KYC/profile sau.
- `operator_accounts` unique `(operator_slug, username)`; `employee_accounts` unique `(operator_id, username)`; `platform_accounts` unique `username` (DB §7).
- `operator_accounts`/`employee_accounts`/`operator_profiles` mang `operator_id` (RLS-ready; policy + FORCE RLS để IAM-003).
- Password hash **scrypt** (`N=2^16, r=8, p=2`) cho operator/platform, không lưu plaintext (chốt 09/09/2026 — xem mục "ĐÃ CHỐT" ở trên).
- Migration `init_iam` + migrate deploy local.

**Nguồn:** DB §Identity, DOMAIN-MAP §iam, GLOSSARY.
**Success:** migration apply OK, `prisma migrate status` up to date, typecheck pass, generated client có model mới.

### ✅ #3 — [IAM-001.3] Better Auth core + custom NestJS adapter — DONE
Module `iam/auth/`: install + config Better Auth (Prisma/Postgres adapter dùng chung PrismaService), custom NestJS adapter wrap Express handler → Nest (ADR-017).
- Plugins: email-OTP, username (operator/platform); OAuth làm ở #6.
- Controller mỏng, logic ở service, Zod tại boundary (nestjs-zod).

**Nguồn:** ADR-017, Security §5, LLD §6.5 bước 2, DOMAIN-MAP `iam/(auth,user,session,role)`.
**Success:** app boot có Better Auth handler mount, smoke 1 flow chạy.

### ✅ #4 — [IAM-001.4] EmailNotifier port cho OTP (dev console + Resend) — DONE
Port `external/notification/` theo adapter pattern (ADR-006/020): dev = LocalLogger adapter (log OTP ra console), Resend adapter = optional. Domain KHÔNG import SDK vendor (LLD-PRIN-07).

**Nguồn:** ADR-006/020, LLD-PRIN-07.
**Success:** OTP request gọi qua port, dev thấy OTP ở log; swap Resend không đụng domain.

### ✅ #5 — [IAM-001.5] Passenger auth: register + Email OTP — DONE
Endpoints (API §7.1): `POST /auth/register` (Email), `POST /auth/otp/request`, `POST /auth/otp/verify` (→ phát JWT access).
- Rate limit OTP (SEC-OQ-07: cooldown 60s, ≤5/giờ).
- Zod DTO; lỗi RFC 7807 code `AUTH_INVALID_CREDENTIALS`/`AUTH_MFA_REQUIRED`; KHÔNG tiết lộ account tồn tại hay không (LLD §7).

**Nguồn:** API §7.1, Security §5/§9, LLD §6.5 bước 1–2.
**Success:** register+otp+verify end-to-end (dev console OTP), test pass.

### ✅ #6 — [IAM-001.6] Passenger OAuth Google/Facebook/Apple — DONE
`POST /auth/oauth/{provider}` cho Google + Facebook + Apple (Better Auth built-in, ADR-020). PKCE + `state` chống CSRF, verify email ownership. Account linking email-match → merge (SEC-OQ-08). Apple Sign-In mandatory (App Store 4.8). Operator/Platform KHÔNG OAuth.

**Nguồn:** Security §5.3, ADR-020.
**Success:** ≥1 provider chạy sandbox (hoặc mock trong test), account-linking có test.

### ✅ #7 — [IAM-001.7] Operator/Employee login `{slug}/{username}` — DONE
`POST /auth/operator/login`: identifier `{operatorSlug}/{username}` + password (closed enrollment). Resolve operator theo slug → verify trong tenant → JWT access mang claim `operatorSlug`+`operatorId`.
- Từ chối nếu login qua luồng passenger (FR-IAM-02c); không self-register/OAuth.

**Nguồn:** Security §5, API §7.1, LLD §6.5, FR-IAM-02c.
**Success:** login operator+employee đúng, sai namespace bị reject, test pass.

### ✅ #8 — [IAM-001.8] Platform login `platform/{username}` — DONE
`POST /auth/platform/login`: identifier `platform/{username}` + password (closed enrollment, KHÔNG public/OAuth). JWT access mang `scope=platform`+role.

**Nguồn:** Security §5, API §7.1, FR-IAM-02b.
**Success:** login platform admin/support đúng namespace, test pass.

### ✅ #9 — [IAM-001.9] Namespace resolver + login history (audit) — DONE
Central resolver: identifier → (scope, account) cho 3 namespace (LLD §6.5 bước 1, Account-separate). Ghi login history (actor, thời điểm, device/IP nếu có, kết quả) vào Mongo audit append-only (FR-IAM-09, ADR-011). Chuẩn hoá `AUTH_*` + masking SĐT/email (Security §9).

**Nguồn:** LLD §6.5, FR-IAM-09, ADR-011, Security §9.
**Success:** resolver unit-tested mọi nhánh; login event ghi audit (append-only verify).

### ✅ #10 — [IAM-001.10] Seed tài khoản tối thiểu để test login — DONE
Prisma seed idempotent: 1 platform admin (`platform/khanh`) + 1 operator+owner (`phuongtrang/owner01`) + (optional) 1 employee — để test login Operator/Platform khi provisioning đầy đủ chưa có (= IAM-005).

**Success:** seed chạy lại không nhân đôi; 3 namespace đều có account login thử được.

### 🔄 #11 — [IAM-001.11] Tests + security review + close — IN PROGRESS
Vitest: namespace resolution (mọi nhánh), OTP request/verify + rate-limit (SEC-OQ-07), password hashing không plaintext, OAuth account-linking, login từng namespace, negative (sai namespace reject FR-IAM-02c; không leak account-existence).

**Trạng thái test (08/09/2026)** — 44 test IAM:
- ✅ `namespace.resolver.spec.ts` (5) — cả 3 namespace + chuẩn hoá hoa/thường.
- ✅ `credential.service.spec.ts` (4) — hash/verify, salt duy nhất, hash sai định dạng.
- ✅ `token.service.spec.ts` (2) — claim RS256, passenger không mang claim tenant.
- ✅ `auth.service.spec.ts` (18) — login 3 namespace, OTP, OAuth + session exchange, negative (FR-IAM-02c, không leak account-existence, account locked, operator suspended).
- ✅ `otp-rate-limiter.spec.ts` (6) — **mới 08/09/2026**: SEC-OQ-07 cooldown 60s (`SET NX EX` atomic), TTL cửa sổ 1h không trượt, cho phép đúng 5/giờ, chặn từ lần 6, chuẩn hoá email chống lách giới hạn.
- ✅ `login-history.service.spec.ts` (4) — **mới 08/09/2026**: FR-IAM-09 ghi audit success/failure, không gắn field ngữ cảnh rỗng, **audit hỏng không làm hỏng login**.
- ⚠️ **OAuth account-linking (SEC-OQ-08) chưa có test riêng** — hiện chỉ là cấu hình trong `auth.config.ts` (`accountLinking.enabled`, `trustedProviders`, `allowDifferentEmails=false`). Cần review xem có đáng thêm test cấu hình hay để IAM-002.

Mandatory review (CLAUDE.md DoD auth): spawn `code-reviewer` + `security-auditor`.
Cập nhật `PROJECT-STATE §7` + task row 11-task IAM-001 → Done. lint+typecheck+test pass.

**Success:** all test green, 2 review không finding nghiêm trọng.

---

## Error code (GLOSSARY — dùng xuyên suốt)
`AUTH_INVALID_CREDENTIALS` · `AUTH_ACCOUNT_LOCKED` · `AUTH_SESSION_EXPIRED` · `AUTH_MFA_REQUIRED` — RFC 7807, **không tiết lộ account tồn tại hay không** (LLD §7).

## Endpoints (API §7.1) trong phạm vi IAM-001
`POST /auth/register` · `/auth/otp/request` · `/auth/otp/verify` · `/auth/oauth/{provider}` · `/auth/operator/login` · `/auth/platform/login`.
*(Ngoài IAM-001: `/auth/mfa/verify` → IAM-004; `/auth/refresh`, `/auth/logout`, `/auth/re-auth` → IAM-002.)*
