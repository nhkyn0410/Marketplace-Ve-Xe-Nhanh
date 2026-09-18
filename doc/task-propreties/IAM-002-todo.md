# TASK-IAM-002 — Todo: Hybrid token (JWT 15min + opaque refresh 30d) + `auth_sessions` + Redis cache

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` dòng 136 — _"Hybrid token (JWT RS256 15min + opaque refresh 30d rotation/family) + `auth_sessions` + Redis cache"_. Nguồn thiết kế: **ADR-017**, Security §5.1, LLD §6.5 **bước 4–5**, DB §7 (`auth_sessions`), API §7.1, `FR-IAM-13..16`, `FR-IAM-10`, AC-02, TC-SEC-002.
> **Dependency:** TASK-IAM-001 ✓ (Done 14/09/2026) — Better Auth + login 3 namespace + `TokenService` mint JWT access.
> **Cách dùng:** tick `[x]` khi xong; AI cập nhật trạng thái khi làm. Guide chạy tay: `IAM-002-guide.md`. Nghiệm thu: `IAM-002-verification-checklist.md`.

## Trạng thái (17/09/2026) — 🟡 **CODE XONG `.1`–`.10`, CHỜ KHANH COMMIT + CI**

- ✅ **`.3`–`.10` xong (17/09/2026)** — chi tiết + quyết định lúc hiện thực ở mục **"Ghi nhận khi hiện thực"** cuối file. Đo được: API **202/202** test (có Postgres/Redis/Mongo thật), `pnpm turbo run typecheck lint test build` **36/36**, smoke chạy thật theo `IAM-002-guide.md` **41/41**, `mobile_shared` **30/30**, contract check Dart xanh.
- 🟡 **`.11` còn**: commit + push để CI chạy (chưa commit — chờ Khanh), rồi đổi task row → Done. Hai review (`code-reviewer`, `security-auditor`) đã chạy; mọi finding đã sửa, có test.
- ✅ **`.1` xong (16/09/2026)**: 5 quyết định đã chốt theo đúng khuyến nghị — xem bảng dưới.
- ✅ **`.2` xong (16/09/2026)**: migration `20260916035828_add_auth_sessions` đã áp dụng. `prisma migrate status` → *Database schema is up to date*; `prisma:generate` + `typecheck` pass. Đủ 7 index/constraint trong DB thật, và **CHECK `auth_sessions_user_ref_derived` đã thử cả hai chiều**: `user_ref` sai format bị từ chối, đúng format thì vào được. DB §7 đã cập nhật (v0.5) để ghi 2 index thêm — doc không lệch code.
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

## 5 quyết định — ✅ **ĐÃ CHỐT 16/09/2026** (task `.1`)

Khanh chốt **cả năm theo đúng khuyến nghị**. Cột cuối giữ nguyên lập luận — đó chính là lý do chốt, không viết lại.

| #      | Câu hỏi                                                                                                                                                                                                             | Lựa chọn                                                                                                                                                                       | Quyết định (chốt 16/09/2026)                                                                                                                                                                                                                                                                                     |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Q1** | **Refresh token giao cho client thế nào?** Security §5.1 ghi _Web = httpOnly cookie (+ CSRF), Mobile = `flutter_secure_storage`_. IAM-001 đang trả token trong **body JSON**.                                    | (a) Body JSON cho cả web + mobile, cookie defer tới khi làm app web · (b) Dual-mode ngay: cookie cho web + body cho mobile (thêm `cookie-parser` + CSRF token)              | ✅ **(a)** — v1 chưa app web nào gọi auth thật (`apps/marketplace`, `operator-os`, `admin` còn rỗng); làm cookie + CSRF bây giờ là code không ai dùng mà vẫn phải test và bảo trì. Chọn (a) ⇒ **phải ghi chú defer vào `07-security` §5.1** để doc không lệch code.                                  |
| **Q2** | **`auth_sessions` trỏ tới account kiểu gì?** Account-separate (ADR-017) ⇒ chủ thể nằm ở **4 bảng khác nhau** (`users`, `operator_accounts`, `employee_accounts`, `platform_accounts`) → không FK nào trỏ đủ cả 4. | (a) 1 cột `user_ref` = `"{subjectType}:{id}"` (khớp đúng chữ DB §7) · (b) 2 cột `subject_type` + `subject_id` · (c) 4 cột FK nullable                                   | ✅ **(b)** + cột `user_ref` sinh từ 2 cột đó để index `(user_ref, family_id)` của DB §7 vẫn đúng. ⚠️ `subject_type` phải có **4 giá trị** (`passenger`/`operator`/`employee`/`platform`), **không** phải 3 `scope` của JWT — scope `operator` gộp cả `operator_accounts` lẫn `employee_accounts`, chỉ lưu scope thì revoke-all sẽ đá nhầm người. |
| **Q3** | **`/auth/re-auth` (FR-IAM-10) làm tới đâu ở v1?**                                                                                                                                                                  | (a) Chỉ cấp **bằng chứng re-auth** (Redis `reauth:{sid}` TTL 5 phút), chưa endpoint nghiệp vụ nào đọc · (b) Làm luôn guard `@RequireReauth()` cho endpoint nhạy cảm       | ✅ **(a)** — endpoint nhạy cảm (refund, payout confirm, đổi bank account) thuộc BTP/ADM **chưa tồn tại**; viết guard bây giờ là viết cho hư không. Cấp bằng chứng + service đọc, guard để task tiêu thụ đầu tiên làm. Nhánh TOTP của re-auth = IAM-004.                                            |
| **Q4** | **FR-IAM-15 (xem danh sách phiên + thu hồi từng phiên)** — API §7.1 **không có** endpoint nào cho việc này.                                                                                                        | (a) Defer sang IAM-005 (provisioning / quản lý account) · (b) Thêm `GET /auth/sessions` + `DELETE /auth/sessions/{id}` ngay ở IAM-002                                        | ✅ **(a)** — thêm endpoint ngoài API §7.1 là mở rộng phạm vi (CLAUDE.md §4.1), cần Khanh duyệt riêng. Dữ liệu vẫn sẵn (`ip`/`user_agent`/`last_used_at`), chỉ thiếu endpoint. **Giới hạn số phiên hoạt động: v1 không giới hạn.**                                                            |
| **Q5** | **Race refresh song song**: app bắn 2 request cùng lúc với cùng 1 refresh token → 1 cái rotate thắng, cái kia thấy token "đã dùng" → luật reuse detection **revoke cả family** ⇒ user bị đá ra oan.              | (a) **Strict** đúng ADR-017 + client single-flight (Dart `AuthInterceptor` / FE chỉ cho 1 refresh chạy) · (b) Cửa sổ ân hạn 10s: token vừa rotate trả lại đúng cặp kế nhiệm | ✅ **(a)** — đúng ADR, ít state hơn; nếu đo được lỗi thật thì nâng lên (b) (cùng lối "chốt đơn giản, nâng khi đo được" của seat-hold ADR-015). Đổi lại: **task FE/Mobile bắt buộc single-flight** — phải ghi vào todo của task đó, không để quên.                                             |

> ✅ Chốt xong 16/09/2026 → `.1` đóng, sang `.2` được.
>
> **Ba nghĩa vụ kéo theo, đã thực hiện / đã ghi nhận:**
>
> 1. **Q1 (a)** ⇒ `07-security-permission-design.md` §5.1 hàng _Token storage_ đã ghi chú cookie Web defer — doc không còn lệch code. **Xong 16/09/2026.**
> 2. **Q4 (a)** ⇒ FR-IAM-15 chuyển sang **TASK-IAM-005**, đã ghi vào `11-project-task-breakdown.md`. IAM-002 **không** được thêm endpoint ngoài API §7.1.
> 3. **Q5 (a)** ⇒ client **bắt buộc single-flight** khi refresh. Phía Mobile đã ghi vào `FND-009-todo.md` (nơi `AuthInterceptor` sống); phía Web ghi vào todo của task dựng app web đầu tiên — chưa có task nào nên **chưa ghi được**, phải nhớ khi task đó ra đời.

---

## Thiết kế đã bám sẵn (không phải hỏi — trích từ doc đã Approved)

**Bảng `auth_sessions`** — DB §7 yêu cầu: index `(user_ref, family_id)`, unique `refresh_token_hash`, index `expires_at`.
**Bổ sung khi hiện thực (16/09/2026):** thêm index `family_id` **đứng riêng** và index `operator_id` — xem khối ⚠️ dưới bảng.

| Cột                                   | Kiểu             | Ghi chú                                                                                                                                 |
| -------------------------------------- | ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `id`                                   | uuid PK           | = `sid` trong JWT                                                                                                                         |
| `subject_type` / `subject_id` / `user_ref` | enum / text / text | Q2. `user_ref` là **cột thường do app ghi**, không phải generated column — Prisma không tả được generated column; ràng buộc bằng một `CHECK` constraint đặt trong migration (nối `lower(subject_type)` + `:` + `subject_id`) |
| `family_id`                            | uuid              | 1 lần login = 1 family; rotation **giữ nguyên** `family_id`                                                                            |
| `refresh_token_hash`                   | text unique       | **SHA-256** của token opaque — không dùng scrypt: token là random 32-byte (entropy đầy), và mỗi lần refresh phải tra cứu O(1) theo hash |
| `issued_at` / `expires_at` / `last_used_at` | timestamptz  | TTL **30 ngày** (Security §5.1)                                                                                                          |
| `rotated_at` / `replaced_by_id`        | timestamptz / uuid **unique** | Dấu vết rotation; row cũ **giữ lại** để còn phát hiện reuse. `replaced_by_id` để `@unique` (hai row cùng trỏ một kế nhiệm = bug rotation), **không** làm self-relation FK |
| `revoked_at` / `revoked_reason`        | timestamptz / **enum** | `LOGOUT` · `REUSE_DETECTED` · `ACCOUNT_LOCKED` · `PASSWORD_RESET` · `ADMIN_FORCE` (FR-IAM-16). Dùng enum thay `text`: tập giá trị đóng, để DB tự chặn giá trị lạ |
| `operator_id`                          | uuid nullable     | Tenant cho IAM-003 (RLS) + revoke hàng loạt khi Operator bị suspend                                                                      |
| `ip` / `user_agent`                    | text nullable     | FR-IAM-09/15; IP lấy qua `resolveTrustedClientIp` đã có                                                                                 |

> ⚠️ **4 chỗ hiện thực lệch bảng trên — ghi nhận 16/09/2026, đã áp dụng:**
>
> 1. **Thêm `@@index([familyId])` đứng riêng.** DB §7 chỉ liệt kê `(user_ref, family_id)`, nhưng revoke-family tra **theo `family_id` một mình** — index composite có `user_ref` đứng đầu không phục vụ được truy vấn đó. Thiếu nó thì mỗi lần phát hiện reuse là seq-scan cả bảng, **đúng lúc đang bị tấn công**. Đã bổ sung vào DB §7 (bản v0.5).
> 2. **`revoked_reason` là enum, không phải `text`.** DB §7 không quy định kiểu cột (chỉ quy định index), nên không nghịch doc Approved nào; enum để Postgres chặn giá trị lạ.
> 3. **`replaced_by_id` có `@unique`, không làm self-relation.** Rows không bao giờ bị xoá nên FK không mang lại gì; `@unique` thì bắt được đúng cái bug đáng sợ (hai row cùng trỏ một kế nhiệm).
> 4. **Không có cột `created_at`.** `issued_at` đã là thời điểm tạo — thêm cột nữa là hai nguồn cho cùng một sự thật. Vẫn giữ `updated_at` (`@updatedAt`) để debug.
>
> Và một chỗ lệch so với **chữ** của Q2: `user_ref` **không** phải generated column. Prisma không mô hình hoá được generated column, mà nếu thêm bằng SQL thô rồi không khai trong `schema.prisma` thì lần `migrate dev` sau sẽ coi là drift và sinh `DROP COLUMN`. Giải pháp: khai cột thường + `CHECK` constraint — Prisma **không** diff CHECK nên không xoá nó, khác hẳn cột. Tinh thần Q2 ("user_ref luôn khớp 2 cột kia") vẫn được Postgres bảo đảm.

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

### ✅ #1 — [IAM-002.1] Chốt 5 quyết định + ghi chú boundary

Chốt 16/09/2026: **cả năm theo khuyến nghị** — Q1 (a) · Q2 (b) · Q3 (a) · Q4 (a) · Q5 (a). Lý do giữ nguyên ở cột cuối bảng trên.

**Nguồn:** ADR-017, Security §5.1, API §7.1.
**Success:** 5 quyết định có dấu ✅; không đổi ADR đã chốt; không phát sinh endpoint ngoài API §7.1. — **Đạt.** Security §5.1 đã ghi chú defer cookie; FR-IAM-15 đã chuyển sang IAM-005.

### ✅ #2 — [IAM-002.2] Prisma model `AuthSession` + migration

Model theo bảng thiết kế trên + enum `SubjectType`; đủ index `(user_ref, family_id)`, unique `refresh_token_hash`, index `expires_at` (DB §7). Migration tên `add_auth_sessions`.

**Nguồn:** DB §7, DB §9, ADR-017.
**Success:** `prisma migrate status` → up to date; `prisma:generate` ra model mới; `typecheck` pass; **chưa** bật RLS (để IAM-003) nhưng đã có sẵn cột `operator_id`.

### ✅ #3 — [IAM-002.3] `iam/session/` — `SessionService` + `RefreshTokenService`

Folder mới `apps/api/src/iam/session/` (DOMAIN-MAP §2: `iam/` split `auth/`, `user/`, `session/`, `role/`).

- `mint()`: `randomBytes(32)` → base64url; lưu **SHA-256** hash; trả token thô **đúng một lần**.
- `rotate()`: thuật toán 5 bước ở trên, atomic bằng `UPDATE ... WHERE rotated_at IS NULL RETURNING`.
- `revokeFamily(familyId, reason)` · `revokeAllForSubject(type, id, reason)` (FR-IAM-16) · `revokeSession(sid, reason)`.
- **Không log token thô** ở bất kỳ đâu; audit chỉ ghi `sid` / `familyId`.

**Nguồn:** ADR-017, Security §5.1, LLD §6.5 bước 5.
**Success:** unit test phủ rotate / reuse / expired / revoked + test **2 rotate song song chỉ 1 thắng**. — **Đạt.** Test race ép hai request chồng lên nhau bằng rào chắn; bỏ điều kiện `rotatedAt: null` thì đỏ 3/3 lần. `revokeSession` bị **bỏ** (xem ghi nhận #6).

### ✅ #4 — [IAM-002.4] `sid` claim + verify access token + guard authn-only

- `TokenService`: thêm claim `sid` (giữ nguyên `operatorId`/`operatorSlug`); **giữ cả publicKey** (dev ephemeral hiện chỉ giữ private) + `verifyAccessToken()` (`jwtVerify`, check `iss`).
- `AccessTokenGuard` (chỉ xác thực **đã đăng nhập**, chưa phân quyền) + decorator `@CurrentUser()` — dùng cho `/auth/logout`, `/auth/re-auth`.
- ⚠️ Guard này **không phải** `TenantGuard`/RBAC — đó là IAM-003. Ghi rõ ranh giới trong comment để IAM-003 không viết chồng.

**Nguồn:** ADR-017 (payload có `sessionId`), Security §5.1/§6.
**Success:** token sửa / hết hạn / sai issuer → 401; token hợp lệ nhưng có `session:revoked:{sid}` → 401; Redis chết → 503. — **Đạt**, thêm: `alg: none`, ký bởi key khác, thiếu `sid`, thiếu `exp` đều → 401.

### ✅ #5 — [IAM-002.5] Redis session cache + tín hiệu revoke

3 nhóm khoá ở bảng trên: ghi cache lúc login/refresh; xoá + set `session:revoked:{sid}` lúc logout/revoke. Fail-closed 503 theo ADR-015 (tái dùng đúng lối `OtpRateLimiter` đã có).

**Nguồn:** ADR-015, ADR-017.
**Success:** test cache hit/miss; test revoke → guard chặn **ngay**, không phải chờ hết 15 phút. — **Đạt.** Cache ghi lúc guard miss, không lúc login/refresh (ghi nhận #3).

### ✅ #6 — [IAM-002.6] Nối refresh vào 4 đường login sẵn có

`verifyOtp` · `exchangeSession` (OAuth) · `operatorLogin` · `platformLogin` → tạo session + trả `refreshToken` + `refreshExpiresIn` + `sid`. Mở rộng `LoginResult` + `AuthTokenResponseDto`; cập nhật assert trong `openapi.spec.ts`; chạy lại `gen:api-client` (TS + Dart).

**Nguồn:** LLD §6.5 bước 4, API §7.1.
**Success:** 4 đường login đều trả cặp token; client TS + Dart regen có field mới; test hồi quy OpenAPI xanh. — **Đạt.** Không trả `sid` riêng trong body (đã nằm trong JWT). `AccessTokenClaims.sid` giờ **bắt buộc**.

### ✅ #7 — [IAM-002.7] 3 endpoint mới (API §7.1)

- `POST /auth/refresh` — rotation + family; rate-limit theo IP như login (tái dùng `OtpRateLimiter`).
- `POST /auth/logout` — revoke family của `sid` + set `session:revoked:{sid}`; **idempotent** (gọi 2 lần vẫn 200).
- `POST /auth/re-auth` — passenger = OTP; operator/platform = nhập lại password (qua `CredentialService`, **có đi qua rate-limit login**); thành công → `reauth:{sid}` TTL 5 phút (Q3).

**Nguồn:** API §7.1, FR-IAM-10/13/14.
**Success:** Supertest e2e cho cả 3; OpenAPI có đủ **9** path auth. — **Đạt**, e2e dùng `listen(0)` + `fetch` như `proxy-auth.integration.spec.ts` sẵn có thay vì thêm Supertest (ghi nhận #9).

### ✅ #8 — [IAM-002.8] Audit + force-revoke (FR-IAM-16, AC-02)

Sự kiện Mongo append-only qua `AuditService`: `auth.session.issued` · `auth.session.rotated` · `auth.session.revoked` (kèm `reason`) · `auth.token.reuse_detected` · `auth.logout` · `auth.reauth.success|failure`. Audit hỏng **không được** làm hỏng luồng auth (đúng lối `LoginHistoryService`).

**Nguồn:** ADR-011, FR-IAM-09/16, AC-02.
**Success:** test có đủ event; test Mongo chết → refresh/logout vẫn chạy. — **Đạt**, thêm test Mongo **chậm** (không bao giờ trả lời) → rotate vẫn trả ngay.

### ✅ #9 — [IAM-002.9] Dọn session hết hạn (BullMQ cron)

Job `session-cleanup` trên queue sẵn có (`apps/api/src/queue/`), `repeat: { pattern: "0 3 * * *" }`, concurrency 1: xoá row `expires_at` cũ hơn 30 ngày. Row đã revoke/rotate phải giữ đủ lâu để còn điều tra được reuse.

**Nguồn:** ADR-016, DB §9.
**Success:** job đăng ký được; unit test hàm dọn (không chạy cron thật trong test). — **Đạt.** Queue riêng `session-maintenance`, lịch `0 3 * * *` giờ `Asia/Ho_Chi_Minh`; chạy worker thật thấy scheduler trong Redis, lần chạy kế tiếp 03:00 giờ VN.

### ✅ #10 — [IAM-002.10] Test — mandatory + hồi quy

Vitest unit + Supertest e2e. **Bắt buộc** (ADR-025 + CLAUDE.md §4.4, nhóm idempotency):

- Rotation **one-time-use**: dùng lại refresh cũ → 401 **và cả family chết** (TC-SEC-002).
- 2 refresh **song song** cùng token → đúng 1 thành công (không sinh 2 token hợp lệ).
- Refresh hết hạn / đã revoke / không tồn tại → 401 `AUTH_SESSION_EXPIRED`, **cùng một response** (không leak).
- Logout → refresh cũ 401 **và** access token cũ bị guard chặn dù còn hạn.
- `revokeAllForSubject` khi account bị khoá → mọi family chết (AC-02).
- Redis chết → 503 `SERVICE_UNAVAILABLE`, không bypass.
- DB chỉ lưu hash, log/audit không chứa token thô.

**Success:** test xanh; `pnpm turbo run typecheck lint test build` xanh toàn bộ. — **Đạt** (36/36). ⚠️ CI **chưa có** Postgres/Redis/Mongo nên các file `*.int.spec.ts` bị skip ở CI — xem follow-up.

### 🟡 #11 — [IAM-002.11] Review + smoke + đóng task

Spawn `code-reviewer` **và** `security-auditor` (CLAUDE.md §6.3 — task chạm auth). Chạy hết `IAM-002-guide.md` trên Docker local, tick `IAM-002-verification-checklist.md`. Cập nhật task row `11-project-task-breakdown.md` → Done + `PROJECT-STATE §7` một dòng + commit.

**Success:** 2 review không còn finding chặn; checklist tick hết (mục không tick được phải ghi lý do tại chỗ). — **Review + smoke xong 17/09/2026**; còn commit + CI + đổi task row → Done.

---

## Ghi nhận khi hiện thực (17/09/2026)

Những chỗ code khác chữ của bảng trên, hoặc lộ ra lúc chạy thật. Mỗi mục có lý do; mục nào Khanh không đồng ý thì sửa trước khi commit.

1. **Tên claim `sid`, không phải `sessionId`** như payload ADR-017. `sid` là tên chuẩn OIDC, cùng lối IAM-001 đã đổi `userId` → `sub`. Muốn đúng chữ ADR thì phải đổi **trước khi phát hành client**.
2. **Logout cho phép phiên đã revoke** (`@AllowRevokedSession()`), vẫn đòi token ký hợp lệ + còn hạn. Không có thì lần logout thứ hai bị chính guard chặn 401, trái "idempotent 200".
3. **Cache `session:{sid}` ghi lúc guard miss**, không lúc login/refresh. Ghi lúc refresh mà Redis lỗi SAU khi Postgres đã rotate thì client mất token mới, lần sau gửi token cũ bị coi là reuse và bị đá ra oan. Khoá `session:revoked:{sid}` được đọc TRƯỚC khoá active nên một lần ghi cache muộn không hồi sinh được phiên.
4. **Revoke: Redis trước, Postgres sau, UPDATE lặp tới khi 0 row.** Tái hiện được bằng test: một rotate đang commit chen giữa lúc revoke sinh row con mà UPDATE đầu không thấy (READ COMMITTED) → kẻ trộm giữ được token sống. Lặp thì bắt được; để 1 vòng thì test đỏ.
5. **Refresh đọc lại account TRƯỚC khi commit rotate**: account khoá / tenant suspend → revoke family + 403. Chưa có luồng khoá account nào gọi revoke (IAM-005), nên đây là chốt chặn duy nhất hiện tại.
6. **Bỏ `revokeSession(sid)`** khỏi `.3`: chưa ai gọi, và gọi với `sid` của một phiên đã rotate thì chỉ revoke row đã chết, row con đang sống vẫn còn. FR-IAM-15 (IAM-005) nên revoke theo **family**.
7. **Rate limit refresh**: 600/giờ theo IP (IPv6 gom theo **/64**) **+ 30/giờ theo family** (không phụ thuộc IP — gọi thẳng origin bỏ Cloudflare không lách được). Mã lỗi mới `AUTH_REFRESH_RATE_LIMITED` — cùng họ với `AUTH_LOGIN_RATE_LIMITED`/`AUTH_OTP_RATE_LIMITED` của IAM-001, **cả ba chưa có trong LLD §7 / GLOSSARY**. Con số là giả định v1.
8. **Re-auth dùng bucket chủ thể riêng** (`reauth-attempt:{user_ref}`) + **chung bucket IP** với login. Dùng chung `login:id:` thì ai biết `sub` trong JWT cũng gõ được đúng chuỗi đó vào cổng login 11 lần để khoá re-auth của nạn nhân.
9. **E2E không dùng Supertest** — theo đúng lối `proxy-auth.integration.spec.ts` sẵn có (`listen(0)` + `fetch`), khỏi thêm dependency.
10. **Xoá phiên Better Auth ngay sau khi đổi sang phiên của ta** (OTP verify, OAuth session exchange, re-auth OTP). Để nó sống thì cookie Better Auth còn trên trình duyệt đổi ra family mới vô hạn lần, kể cả sau logout.
11. **Audit không chờ** (fire-and-forget, vẫn bắt lỗi). Chờ thì Mongo chậm làm refresh treo ~10 giây SAU khi token cũ đã bị tiêu.
12. **Response mang token có `Cache-Control: no-store`** (RFC 6749 §5.1). JWT verify bắt buộc có `exp` + `iat`.
13. **Redis client của đường request đổi 3 option** (`redis.config.ts`, đo trên container thật): `maxRetriesPerRequest: 1` (trước đó Redis chết là request **treo mãi**, không 503 — lỗi có từ IAM-001), `commandTimeout: 1000`, `enableReadyCheck: true` (để `false` thì Redis sống lại mà API vẫn **503 mãi** tới khi restart). BullMQ giữ nguyên option cũ. `redis.constants.ts` đã bỏ, hằng chuyển vào `redis.config.ts` (Khanh yêu cầu).
14. ⚠️ **Máy dev này**: `localhost:6379` trỏ vào **Redis trong WSL Ubuntu** (8.6.3), KHÔNG phải container `docker compose` (7.4.9). `docker compose stop redis` vì thế không ảnh hưởng API chạy với `REDIS_URL` mặc định. Smoke 4G đã chạy với `REDIS_URL=redis://<IP LAN>:6379`.

**Follow-up (ngoài phạm vi, cần Khanh quyết):**

- **CI chưa có service Postgres/Redis/Mongo** → mọi `*.int.spec.ts` (race, reuse, revoke, e2e) chỉ chạy trên máy dev. Test bắt buộc ADR-025 nhóm idempotency vì thế chưa được CI gác.
- **Refresh hết hạn kiểu trượt**: mỗi lần rotate cấp thêm 30 ngày → phiên dùng đều không bao giờ hết hạn. ADR-017 chỉ ghi "TTL 30 ngày"; có cần trần tuyệt đối theo family không?
- `LoginHistoryService` (IAM-001) vẫn **chờ** audit → Mongo chậm làm login chậm theo; kết nối Mongo audit chưa đặt `serverSelectionTimeoutMS`.
- Bổ sung 3 mã `AUTH_*_RATE_LIMITED` vào LLD §7 / GLOSSARY. `JWT_ACCESS_PUBLIC_KEY` vẫn không dùng. `JWT_ACCESS_TTL_SECONDS` chưa có trần.
- Client **single-flight** khi refresh (Q5) — đã ghi ở `FND-009-todo.md`; phía Web chờ task dựng app web.

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
