# TASK-IAM-002 — Todo: Hybrid token (JWT 15min + opaque refresh 30d) + `auth_sessions` + Redis cache

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` dòng 136 — _"Hybrid token (JWT RS256 15min + opaque refresh 30d rotation/family) + `auth_sessions` + Redis cache"_. Nguồn thiết kế: **ADR-017**, Security §5.1, LLD §6.5 **bước 4–5**, DB §7 (`auth_sessions`), API §7.1, `FR-IAM-13..16`, `FR-IAM-10`, AC-02, TC-SEC-002.
> **Dependency:** TASK-IAM-001 ✓ (Done 14/09/2026) — Better Auth + login 3 namespace + `TokenService` mint JWT access.
> **Cách dùng:** tick `[x]` khi xong; AI cập nhật trạng thái khi làm. Guide chạy tay: `IAM-002-guide.md`. Nghiệm thu: `IAM-002-verification-checklist.md`.

## Trạng thái (15/09/2026) — 🔲 **CHƯA BẮT ĐẦU**

- Branch `TASK-IAM-002` đã tạo, code chưa có gì: `apps/api/src/iam/session/` chưa tồn tại, `auth_sessions` chưa có trong `schema.prisma`.
- **Chặn ở `.1`**: 5 quyết định dưới đây cần Khanh chốt **trước khi** viết schema — chọn khác nhau thì schema + DTO khác nhau, sửa sau là migration + đổi contract client (TS lẫn Dart).
- Nền dùng lại được: `TokenService` (RS256), `OtpRateLimiter` (Redis + Lua, fail-closed 503), `LoginHistoryService` (Mongo append-only), `REDIS_CLIENT` (ioredis), queue BullMQ (`apps/api/src/queue/`), `resolveTrustedClientIp`.

---

## Phạm vi & ranh giới

IAM-002 = **LLD §6.5 bước 4–5** (phát hành hybrid token + refresh rotation/family). Không lấn sang task khác:

| Thuộc IAM-002                                                             | Để task sau                                                                 |
| ------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| Bảng `auth_sessions` + migration (DB §7)                                 | RLS policy + `FORCE ROW LEVEL SECURITY` → **IAM-003**                       |
| Opaque refresh 32-byte, TTL 30d, hash SHA-256, rotation one-time-use       | RBAC 8-role + `TenantGuard` khớp `:operatorSlug` → **IAM-003**             |
| Family invalidation khi phát hiện reuse (TC-SEC-002)                      | `POST /auth/mfa/verify` + TOTP / backup code → **IAM-004**                  |
| Redis cache session metadata + tín hiệu revoke (TTL 15 phút)            | Nhánh re-auth bằng **TOTP** → **IAM-004**                                  |
| `sid` claim vào JWT + **guard xác thực (authn-only)** cho 3 endpoint mới | Đổi/cấp lại mật khẩu, khoá account — nơi **gọi** revoke → **IAM-005**, ADM |
| `POST /auth/refresh` · `/auth/logout` · `/auth/re-auth` (API §7.1)         | Xem danh sách phiên + thu hồi theo thiết bị (FR-IAM-15) → xem **Q4**       |
| Service `revokeFamily` / `revokeAllForSubject` (FR-IAM-16)                | Nối refresh vào Next.js / Flutter (`AuthInterceptor` đã có hook 401) → FE/Mobile |

---

## 5 quyết định cần Khanh chốt (task `.1`)

| #      | Câu hỏi                                                                                                                                                                                                             | Lựa chọn                                                                                                                                                                       | Khuyến nghị của AI                                                                                                                                                                                                                                                                                       |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Q1** | **Refresh token giao cho client thế nào?** Security §5.1 ghi _Web = httpOnly cookie (+ CSRF), Mobile = `flutter_secure_storage`_. IAM-001 đang trả token trong **body JSON**.                                    | (a) Body JSON cho cả web + mobile, cookie defer tới khi làm app web · (b) Dual-mode ngay: cookie cho web + body cho mobile (thêm `cookie-parser` + CSRF token)              | **(a)** — v1 chưa app web nào gọi auth thật (`apps/marketplace`, `operator-os`, `admin` còn rỗng); làm cookie + CSRF bây giờ là code không ai dùng mà vẫn phải test và bảo trì. Chọn (a) ⇒ **phải ghi chú defer vào `07-security` §5.1** để doc không lệch code.                                  |
| **Q2** | **`auth_sessions` trỏ tới account kiểu gì?** Account-separate (ADR-017) ⇒ chủ thể nằm ở **4 bảng khác nhau** (`users`, `operator_accounts`, `employee_accounts`, `platform_accounts`) → không FK nào trỏ đủ cả 4. | (a) 1 cột `user_ref` = `"{subjectType}:{id}"` (khớp đúng chữ DB §7) · (b) 2 cột `subject_type` + `subject_id` · (c) 4 cột FK nullable                                   | **(b)** + cột `user_ref` sinh từ 2 cột đó để index `(user_ref, family_id)` của DB §7 vẫn đúng. ⚠️ `subject_type` phải có **4 giá trị** (`passenger`/`operator`/`employee`/`platform`), **không** phải 3 `scope` của JWT — scope `operator` gộp cả `operator_accounts` lẫn `employee_accounts`, chỉ lưu scope thì revoke-all sẽ đá nhầm người. |
| **Q3** | **`/auth/re-auth` (FR-IAM-10) làm tới đâu ở v1?**                                                                                                                                                                  | (a) Chỉ cấp **bằng chứng re-auth** (Redis `reauth:{sid}` TTL 5 phút), chưa endpoint nghiệp vụ nào đọc · (b) Làm luôn guard `@RequireReauth()` cho endpoint nhạy cảm       | **(a)** — endpoint nhạy cảm (refund, payout confirm, đổi bank account) thuộc BTP/ADM **chưa tồn tại**; viết guard bây giờ là viết cho hư không. Cấp bằng chứng + service đọc, guard để task tiêu thụ đầu tiên làm. Nhánh TOTP của re-auth = IAM-004.                                            |
| **Q4** | **FR-IAM-15 (xem danh sách phiên + thu hồi từng phiên)** — API §7.1 **không có** endpoint nào cho việc này.                                                                                                        | (a) Defer sang IAM-005 (provisioning / quản lý account) · (b) Thêm `GET /auth/sessions` + `DELETE /auth/sessions/{id}` ngay ở IAM-002                                        | **(a)** — thêm endpoint ngoài API §7.1 là mở rộng phạm vi (CLAUDE.md §4.1), cần Khanh duyệt riêng. Dữ liệu vẫn sẵn (`ip`/`user_agent`/`last_used_at`), chỉ thiếu endpoint. **Giới hạn số phiên hoạt động: v1 không giới hạn.**                                                            |
| **Q5** | **Race refresh song song**: app bắn 2 request cùng lúc với cùng 1 refresh token → 1 cái rotate thắng, cái kia thấy token "đã dùng" → luật reuse detection **revoke cả family** ⇒ user bị đá ra oan.              | (a) **Strict** đúng ADR-017 + client single-flight (Dart `AuthInterceptor` / FE chỉ cho 1 refresh chạy) · (b) Cửa sổ ân hạn 10s: token vừa rotate trả lại đúng cặp kế nhiệm | **(a)** — đúng ADR, ít state hơn; nếu đo được lỗi thật thì nâng lên (b) (cùng lối "chốt đơn giản, nâng khi đo được" của seat-hold ADR-015). Đổi lại: **task FE/Mobile bắt buộc single-flight** — phải ghi vào todo của task đó, không để quên.                                             |

> Chốt xong → cập nhật chính file này (✅ + ngày + lý do) rồi mới sang `.2`.

---

## Thiết kế đã bám sẵn (không phải hỏi — trích từ doc đã Approved)

**Bảng `auth_sessions`** — DB §7 yêu cầu: index `(user_ref, family_id)`, unique `refresh_token_hash`, index `expires_at`.

| Cột                                   | Kiểu             | Ghi chú                                                                                                                                 |
| -------------------------------------- | ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `id`                                   | uuid PK           | = `sid` trong JWT                                                                                                                         |
| `subject_type` / `subject_id` / `user_ref` | enum / text / text | Q2                                                                                                                                        |
| `family_id`                            | uuid              | 1 lần login = 1 family; rotation **giữ nguyên** `family_id`                                                                            |
| `refresh_token_hash`                   | text unique       | **SHA-256** của token opaque — không dùng scrypt: token là random 32-byte (entropy đầy), và mỗi lần refresh phải tra cứu O(1) theo hash |
| `issued_at` / `expires_at` / `last_used_at` | timestamptz  | TTL **30 ngày** (Security §5.1)                                                                                                          |
| `rotated_at` / `replaced_by_id`        | timestamptz / uuid | Dấu vết rotation; row cũ **giữ lại** để còn phát hiện reuse                                                                          |
| `revoked_at` / `revoked_reason`        | timestamptz / text | `logout` · `reuse_detected` · `account_locked` · `password_reset` · `admin_force` (FR-IAM-16)                                              |
| `operator_id`                          | uuid nullable     | Tenant cho IAM-003 (RLS) + revoke hàng loạt khi Operator bị suspend                                                                      |
| `ip` / `user_agent`                    | text nullable     | FR-IAM-09/15; IP lấy qua `resolveTrustedClientIp` đã có                                                                                 |

**Thuật toán refresh (bắt buộc atomic):**

1. Hash token nhận được → tra theo `refresh_token_hash`.
2. Không thấy / hết hạn / `revoked_at` ≠ null → **401 `AUTH_SESSION_EXPIRED`** (một response duy nhất, không phân biệt lý do → không leak).
3. Thấy nhưng `rotated_at` ≠ null ⇒ **token đã dùng rồi = tín hiệu tấn công** → revoke **toàn bộ family** + audit `auth.token.reuse_detected` + 401.
4. Hợp lệ → rotate bằng **một câu có điều kiện**: `UPDATE ... WHERE id = ? AND rotated_at IS NULL AND revoked_at IS NULL RETURNING *`, cùng transaction với `INSERT` row mới. Đọc-rồi-ghi hai bước sẽ để **hai request song song cùng thắng** → hai refresh token hợp lệ sinh ra từ một token, đúng thứ mà family invalidation sinh ra để chặn.
5. Trả cặp mới: access JWT 15 phút (`sid` mới) + refresh mới 30 ngày; cập nhật cache Redis; ghi `last_used_at`.

**Khoá Redis** (ADR-015 — Redis chết thì **503 fail-closed**, không fallback in-memory):

| Key                     | TTL                  | Dùng để                                                                                              |
| ----------------------- | -------------------- | ------------------------------------------------------------------------------------------------------ |
| `session:{sid}`         | 900s                 | Metadata phiên (scope/role/operatorId/status) cho hot path — khỏi hit Postgres mỗi request           |
| `session:revoked:{sid}` | = TTL access (900s)  | Giết access token **còn hạn** khi logout/revoke — JWT stateless không tự chết được                |
| `reauth:{sid}`          | 300s                 | Bằng chứng re-auth (Q3)                                                                                |

**Error code** (LLD §7 — không tự chế code mới): `AUTH_SESSION_EXPIRED` · `AUTH_INVALID_CREDENTIALS` · `AUTH_ACCOUNT_LOCKED` · `AUTH_MFA_REQUIRED` (IAM-004) · `SERVICE_UNAVAILABLE` (Redis down). RFC 7807 qua `AuthException` đã có sẵn.

---

## Todo (ID = thứ tự thực hiện)

### 🔲 #1 — [IAM-002.1] Chốt 5 quyết định + ghi chú boundary

Trình Khanh bảng Q1–Q5; chốt xong ghi lại vào file này (✅ + ngày + lý do). Nếu Q1 = (a): mở `07-security-permission-design.md` §5.1 ghi rõ _"cookie Web defer — v1 trả body JSON"_ (doc không được lệch code).

**Nguồn:** ADR-017, Security §5.1, API §7.1.
**Success:** 5 quyết định có dấu ✅; không đổi ADR đã chốt; không phát sinh endpoint ngoài API §7.1.

### 🔲 #2 — [IAM-002.2] Prisma model `AuthSession` + migration

Model theo bảng thiết kế trên + enum `SubjectType`; đủ index `(user_ref, family_id)`, unique `refresh_token_hash`, index `expires_at` (DB §7). Migration tên `add_auth_sessions`.

**Nguồn:** DB §7, DB §9, ADR-017.
**Success:** `prisma migrate status` → up to date; `prisma:generate` ra model mới; `typecheck` pass; **chưa** bật RLS (để IAM-003) nhưng đã có sẵn cột `operator_id`.

### 🔲 #3 — [IAM-002.3] `iam/session/` — `SessionService` + `RefreshTokenService`

Folder mới `apps/api/src/iam/session/` (DOMAIN-MAP §2: `iam/` split `auth/`, `user/`, `session/`, `role/`).

- `mint()`: `randomBytes(32)` → base64url; lưu **SHA-256** hash; trả token thô **đúng một lần**.
- `rotate()`: thuật toán 5 bước ở trên, atomic bằng `UPDATE ... WHERE rotated_at IS NULL RETURNING`.
- `revokeFamily(familyId, reason)` · `revokeAllForSubject(type, id, reason)` (FR-IAM-16) · `revokeSession(sid, reason)`.
- **Không log token thô** ở bất kỳ đâu; audit chỉ ghi `sid` / `familyId`.

**Nguồn:** ADR-017, Security §5.1, LLD §6.5 bước 5.
**Success:** unit test phủ rotate / reuse / expired / revoked + test **2 rotate song song chỉ 1 thắng**.

### 🔲 #4 — [IAM-002.4] `sid` claim + verify access token + guard authn-only

- `TokenService`: thêm claim `sid` (giữ nguyên `operatorId`/`operatorSlug`); **giữ cả publicKey** (dev ephemeral hiện chỉ giữ private) + `verifyAccessToken()` (`jwtVerify`, check `iss`).
- `AccessTokenGuard` (chỉ xác thực **đã đăng nhập**, chưa phân quyền) + decorator `@CurrentUser()` — dùng cho `/auth/logout`, `/auth/re-auth`.
- ⚠️ Guard này **không phải** `TenantGuard`/RBAC — đó là IAM-003. Ghi rõ ranh giới trong comment để IAM-003 không viết chồng.

**Nguồn:** ADR-017 (payload có `sessionId`), Security §5.1/§6.
**Success:** token sửa / hết hạn / sai issuer → 401; token hợp lệ nhưng có `session:revoked:{sid}` → 401; Redis chết → 503.

### 🔲 #5 — [IAM-002.5] Redis session cache + tín hiệu revoke

3 nhóm khoá ở bảng trên: ghi cache lúc login/refresh; xoá + set `session:revoked:{sid}` lúc logout/revoke. Fail-closed 503 theo ADR-015 (tái dùng đúng lối `OtpRateLimiter` đã có).

**Nguồn:** ADR-015, ADR-017.
**Success:** test cache hit/miss; test revoke → guard chặn **ngay**, không phải chờ hết 15 phút.

### 🔲 #6 — [IAM-002.6] Nối refresh vào 4 đường login sẵn có

`verifyOtp` · `exchangeSession` (OAuth) · `operatorLogin` · `platformLogin` → tạo session + trả `refreshToken` + `refreshExpiresIn` + `sid`. Mở rộng `LoginResult` + `AuthTokenResponseDto`; cập nhật assert trong `openapi.spec.ts`; chạy lại `gen:api-client` (TS + Dart).

**Nguồn:** LLD §6.5 bước 4, API §7.1.
**Success:** 4 đường login đều trả cặp token; client TS + Dart regen có field mới; test hồi quy OpenAPI xanh.

### 🔲 #7 — [IAM-002.7] 3 endpoint mới (API §7.1)

- `POST /auth/refresh` — rotation + family; rate-limit theo IP như login (tái dùng `OtpRateLimiter`).
- `POST /auth/logout` — revoke family của `sid` + set `session:revoked:{sid}`; **idempotent** (gọi 2 lần vẫn 200).
- `POST /auth/re-auth` — passenger = OTP; operator/platform = nhập lại password (qua `CredentialService`, **có đi qua rate-limit login**); thành công → `reauth:{sid}` TTL 5 phút (Q3).

**Nguồn:** API §7.1, FR-IAM-10/13/14.
**Success:** Supertest e2e cho cả 3; OpenAPI có đủ **9** path auth.

### 🔲 #8 — [IAM-002.8] Audit + force-revoke (FR-IAM-16, AC-02)

Sự kiện Mongo append-only qua `AuditService`: `auth.session.issued` · `auth.session.rotated` · `auth.session.revoked` (kèm `reason`) · `auth.token.reuse_detected` · `auth.logout` · `auth.reauth.success|failure`. Audit hỏng **không được** làm hỏng luồng auth (đúng lối `LoginHistoryService`).

**Nguồn:** ADR-011, FR-IAM-09/16, AC-02.
**Success:** test có đủ event; test Mongo chết → refresh/logout vẫn chạy.

### 🔲 #9 — [IAM-002.9] Dọn session hết hạn (BullMQ cron)

Job `session-cleanup` trên queue sẵn có (`apps/api/src/queue/`), `repeat: { pattern: "0 3 * * *" }`, concurrency 1: xoá row `expires_at` cũ hơn 30 ngày. Row đã revoke/rotate phải giữ đủ lâu để còn điều tra được reuse.

**Nguồn:** ADR-016, DB §9.
**Success:** job đăng ký được; unit test hàm dọn (không chạy cron thật trong test).

### 🔲 #10 — [IAM-002.10] Test — mandatory + hồi quy

Vitest unit + Supertest e2e. **Bắt buộc** (ADR-025 + CLAUDE.md §4.4, nhóm idempotency):

- Rotation **one-time-use**: dùng lại refresh cũ → 401 **và cả family chết** (TC-SEC-002).
- 2 refresh **song song** cùng token → đúng 1 thành công (không sinh 2 token hợp lệ).
- Refresh hết hạn / đã revoke / không tồn tại → 401 `AUTH_SESSION_EXPIRED`, **cùng một response** (không leak).
- Logout → refresh cũ 401 **và** access token cũ bị guard chặn dù còn hạn.
- `revokeAllForSubject` khi account bị khoá → mọi family chết (AC-02).
- Redis chết → 503 `SERVICE_UNAVAILABLE`, không bypass.
- DB chỉ lưu hash, log/audit không chứa token thô.

**Success:** test xanh; `pnpm turbo run typecheck lint test build` xanh toàn bộ.

### 🔲 #11 — [IAM-002.11] Review + smoke + đóng task

Spawn `code-reviewer` **và** `security-auditor` (CLAUDE.md §6.3 — task chạm auth). Chạy hết `IAM-002-guide.md` trên Docker local, tick `IAM-002-verification-checklist.md`. Cập nhật task row `11-project-task-breakdown.md` → Done + `PROJECT-STATE §7` một dòng + commit.

**Success:** 2 review không còn finding chặn; checklist tick hết (mục không tick được phải ghi lý do tại chỗ).

---

## Rủi ro đã thấy trước

| Rủi ro                                                       | Xử lý                                                                                    |
| -------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| Rotation đọc-rồi-ghi 2 bước → 2 refresh hợp lệ từ 1 token | `UPDATE ... WHERE rotated_at IS NULL RETURNING` + test song song (`.3`, `.10`)              |
| Refresh song song của client làm user bị đá ra oan          | Q5 — strict + single-flight ở client; nâng lên cửa sổ ân hạn nếu đo được lỗi thật |
| JWT stateless không chết khi logout                          | `session:revoked:{sid}` TTL 900s + guard đọc Redis (`.5`)                                 |
| Mỗi request có auth đều hit Redis → Redis thành SPOF      | Đúng chủ ý ADR-015 (503 thay vì bypass); TTL 15 phút giữ tải thấp                  |
| Revoke-all đá nhầm người vì chỉ lưu `scope`              | Q2 — `subject_type` **4 giá trị**, tách `operator` khỏi `employee`                       |
| Token thô lọt vào log / audit / Sentry                       | Chỉ lưu hash; audit chỉ ghi `sid`/`familyId`; có test khẳng định                      |

## Endpoint sau IAM-002 (API §7.1 — 9/10)

`/auth/register` · `/auth/otp/request` · `/auth/otp/verify` · `/auth/oauth/{provider}` (+ `/auth/oauth/session`) · `/auth/operator/login` · `/auth/platform/login` · **`/auth/refresh`** · **`/auth/logout`** · **`/auth/re-auth`**.
_(Còn `/auth/mfa/verify` → IAM-004.)_
