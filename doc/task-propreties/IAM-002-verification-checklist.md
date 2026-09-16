# TASK-IAM-002 — Checklist nghiệm thu: hybrid token + `auth_sessions` + Redis

> Mục tiêu: xác nhận **phiên đăng nhập sống đúng vòng đời** — cấp, xoay vòng, phát hiện dùng lại, thu hồi — chứ không chỉ "login ra token".
> Cách dùng: chạy theo thứ tự **A → B → C → D → E**; PHẦN F là DoD từng sub-task. Tick `[x]` khi pass; mục nào không tick được thì **ghi lý do ngay tại chỗ** (đừng bỏ trống).
> Lệnh chạy ở repo root `C:\Code\Ve_Xe_Nhanh`. Thao tác chi tiết: `IAM-002-guide.md`. Phạm vi: `IAM-002-todo.md`.

## Snapshot trạng thái (15/09/2026)

- 🔲 **Chưa chạy** — task chưa bắt đầu code. Checklist này là **success-criteria viết trước** (Karpathy #4), dùng làm đích khi làm `.2`–`.11`.
- ✅ **Hết chặn**: Q1–Q5 đã chốt 16/09/2026 (cả năm theo khuyến nghị) — xem `IAM-002-todo.md`.

---

## PHẦN A — Thiết kế & ranh giới (kiểm trước, sai ở đây thì sửa sau rất đắt)

- [x] 5 quyết định **Q1–Q5** trong `IAM-002-todo.md` đã có dấu ✅ + ngày + lý do — chốt 16/09/2026
- [x] Q1 = **(a)** (refresh trả body JSON): `07-security-permission-design.md` §5.1 hàng _Token storage_ **đã ghi chú** cookie Web defer — doc không lệch code
- [ ] **Không có endpoint nào ngoài API §7.1**: đúng 3 endpoint mới `/auth/refresh`, `/auth/logout`, `/auth/re-auth` (FR-IAM-15 theo quyết định Q4)
- [ ] Code session nằm ở `apps/api/src/iam/session/` (DOMAIN-MAP §2 `iam/` split `auth,user,session,role`) — không nhét chung vào `iam/auth/`
- [ ] `AccessTokenGuard` **chỉ** xác thực (authn), **không** kiểm role/tenant — có comment ghi rõ ranh giới với IAM-003
- [ ] Không thêm ADR mới, không đổi ADR-017 (nếu thấy cần đổi → dừng, hỏi Khanh)

## PHẦN B — Schema & migration

- [ ] Model `AuthSession` có đủ: `family_id`, `refresh_token_hash`, `issued_at`, `expires_at`, `rotated_at`, `replaced_by_id`, `revoked_at`, `revoked_reason`, `operator_id`, `ip`, `user_agent`
- [ ] Index đúng DB §7 (bản v0.5): index `(user_ref, family_id)` · index `family_id` **đứng riêng** · **unique** `refresh_token_hash` · index `expires_at` · index `operator_id`
- [ ] ⚠️ Index `family_id` phải có **thật** — không có nó thì revoke-family seq-scan cả bảng đúng lúc phát hiện tấn công. Kiểm bằng `\d auth_sessions`, đừng tin mỗi `schema.prisma`
- [ ] CHECK `auth_sessions_user_ref_derived` tồn tại **và chặn được thật**: thử `insert` một row có `user_ref` sai → phải bị từ chối (xem `IAM-002-guide.md`)
- [ ] `subject_type` có **4 giá trị** (`passenger`/`operator`/`employee`/`platform`) — ⚠️ không phải 3 `scope` của JWT; thiếu tách `employee` thì revoke-all sẽ đá nhầm người của tenant
- [ ] `pnpm --filter @vexenhanh/api exec prisma migrate status` → `Database schema is up to date!`
- [ ] Migration chạy được trên DB **trống** (không chỉ DB đang có): `docker compose down -v` → `up -d` → `prisma:migrate:dev` → `db:seed`
- [ ] **Chưa** bật RLS trên `auth_sessions` (để IAM-003) nhưng cột `operator_id` đã có sẵn

## PHẦN C — Static, contract, CI

- [ ] `pnpm turbo run typecheck lint test build` → xanh toàn bộ (không giảm so với 36/36 trước đó)
- [ ] `openapi.spec.ts` assert đủ **9** path auth; test hồi quy `requestBody` vẫn còn (đừng bỏ — đây là lỗi im lặng từng xảy ra thật ở IAM-001)
- [ ] `gen:api-client` chạy lại: client **TS** và **Dart** đều có `refreshToken` / `refreshExpiresIn` và 3 endpoint mới
- [ ] `AuthTokenResponseDto` mở rộng chứ không đổi tên field cũ (client Dart đang dùng)
- [ ] CI GitHub Actions xanh trên branch `TASK-IAM-002`

## PHẦN D — Bảo mật & test bắt buộc (ADR-025 + CLAUDE.md §4.4)

- [ ] **Rotation one-time-use**: refresh cũ dùng lại → 401 `AUTH_SESSION_EXPIRED`
- [ ] ⭐ **Family invalidation (TC-SEC-002)**: sau khi phát hiện reuse, **refresh token mới cũng chết** — kiểm bằng request thật, không chỉ bằng cột DB
- [ ] **Race**: 2 refresh song song cùng 1 token → đúng **1** thành công (rotation phải atomic `UPDATE ... WHERE rotated_at IS NULL RETURNING`)
- [ ] Refresh không tồn tại / hết hạn / đã revoke → **cùng một** response 401 (không leak lý do)
- [ ] **Logout**: refresh chết **và** access token còn hạn bị guard chặn (`session:revoked:{sid}` tồn tại, TTL ~900s)
- [ ] Logout gọi 2 lần vẫn 200 (idempotent)
- [ ] `revokeAllForSubject` (account bị khoá) → mọi family của chủ thể đó chết (AC-02, FR-IAM-16)
- [ ] **Redis stop → 503** `SERVICE_UNAVAILABLE`, không bypass (ADR-015 fail-closed)
- [ ] DB chỉ lưu **hash** refresh token — token thô không xuất hiện trong `auth_sessions`, log, audit Mongo, Sentry
- [ ] Re-auth sai mật khẩu → 401 và **có đi qua rate-limit login** (không thành kênh brute-force mới đi vòng)
- [ ] `/auth/refresh` có rate-limit theo IP
- [ ] Audit Mongo có: `auth.session.rotated`, `auth.session.revoked` (kèm `reason`), `auth.token.reuse_detected`, `auth.logout`
- [ ] Mongo chết **không** làm hỏng refresh/logout (audit best-effort, đúng lối `LoginHistoryService`)

## PHẦN E — Runtime (chạy `IAM-002-guide.md` từ đầu đến cuối)

> Cần `docker compose up -d` + API chạy.

- [ ] 4A — login platform trả cặp token, JWT có claim `sid`
- [ ] 4B — refresh ra cặp mới, `family_id` giữ nguyên trong DB
- [ ] 4C — reuse → 401 + cả family `revoked_reason=reuse_detected`
- [ ] 4D — 2 refresh song song: đúng một `200`
- [ ] 4E — logout: 200 (2 lần) + refresh cũ 401
- [ ] 4F — re-auth: 401 rồi 200; `reauth:{sid}` TTL ~300s
- [ ] 4G — `docker compose stop redis` → 503; start lại thì bình thường
- [ ] 4H — **cả 4 đường login** (OTP, OAuth session exchange, operator, platform) đều trả `refreshToken` — không sót đường nào
- [ ] §5 — soi `auth_sessions` + khoá Redis + audit Mongo khớp bảng kỳ vọng

## PHẦN F — DoD theo sub-task

| Sub-task              | DoD                                                                                                   | ✓   |
| --------------------- | ----------------------------------------------------------------------------------------------------- | --- |
| `.1` Quyết định      | Q1–Q5 chốt + ghi lại; doc Security cập nhật nếu Q1=(a)                                             | [x] |
| `.2` Schema           | Model + migration + index DB §7; chạy được trên DB trống                                            | [ ] |
| `.3` Session service  | mint/rotate/revoke; rotate atomic; unit test phủ reuse + race                                          | [ ] |
| `.4` Token + guard    | claim `sid`; `verifyAccessToken`; guard authn-only chặn token sửa/hết hạn/đã revoke               | [ ] |
| `.5` Redis            | 3 nhóm khoá đúng TTL; fail-closed 503                                                                | [ ] |
| `.6` Nối 4 login     | 4 đường trả refresh; OpenAPI + client TS/Dart regen                                                  | [ ] |
| `.7` 3 endpoint       | `/auth/refresh` + `/auth/logout` (idempotent) + `/auth/re-auth`; Supertest e2e                          | [ ] |
| `.8` Audit + revoke   | Đủ event; audit hỏng không làm hỏng auth                                                           | [ ] |
| `.9` Cleanup cron     | Job `session-cleanup` đăng ký được, concurrency 1; unit test hàm dọn                               | [ ] |
| `.10` Test            | Toàn bộ PHẦN D xanh trong Vitest/Supertest (không chỉ chạy tay)                                    | [ ] |
| `.11` Đóng task      | `code-reviewer` + `security-auditor` không còn finding chặn; task row → Done; `PROJECT-STATE §7` 1 dòng | [ ] |

## PHẦN G — Ranh giới (KHÔNG kiểm ở task này)

Đừng chặn nghiệm thu vì mấy mục dưới:

- RBAC 8-role, `TenantGuard`, Postgres RLS → **TASK-IAM-003**
- TOTP `/auth/mfa/verify`, backup code, nhánh TOTP của re-auth → **TASK-IAM-004**
- Cấp/đổi/cấp lại mật khẩu, khoá account (nơi **gọi** revoke) → **TASK-IAM-005** / ADM
- Danh sách phiên + thu hồi theo thiết bị (FR-IAM-15) → theo quyết định **Q4**
- Cookie httpOnly + CSRF cho Web (nếu Q1 = (a)) → task FE khi dựng app web
- Single-flight refresh ở client Next.js / Flutter → task FE/Mobile (**phải ghi vào todo task đó**, nếu không sẽ lộ ra dưới dạng "user bị đăng xuất ngẫu nhiên")
