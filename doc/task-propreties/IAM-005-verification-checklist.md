# TASK-IAM-005 — Checklist nghiệm thu: closed enrollment + session theo thiết bị

> Mục tiêu: chứng minh chỉ actor có thẩm quyền mới cấp/quản lý account nội bộ, tenant không thể vượt biên và mỗi actor tự xem/thu hồi đúng device family của mình.
> Chạy theo thứ tự **A → G**; chỉ tick `[x]` khi có evidence. Lệnh: `IAM-005-guide.md`. Phạm vi/sub-task: `IAM-005-todo.md`.

## Snapshot trạng thái (22/09/2026)

- [x] Đã đối chiếu SDLC/code và tạo bộ ba todo/guide/checklist.
- [x] Q1–Q8 được Khanh chốt theo khuyến nghị ngày 22/09/2026; task đã qua design gate và đang triển khai.
- [x] Local evidence 22/09/2026: migration 6/6 trên PostgreSQL 16 test rỗng và SQL upgrade từ 5 migration IAM-004 có 3 account legacy (slug backfill/registry/default flags/FORCE RLS đúng), `db:app-role` chạy lại idempotent, Prisma schema diff = `No difference detected`; `REQUIRE_DB_TESTS=1` với app role + Redis 7 + Mongo 7: API 386/386 test pass, 0 skip (gồm provisioning/Employee service trên DB thật). `pnpm turbo run typecheck lint test build`: 35/35 task pass. `pnpm gen:api-client` pass; Dart client 47 generated lib files khớp byte-for-byte, `dart test` 148/148 pass. Chưa có CI branch/smoke production; `dart analyze` còn 7 warning từ generator.

## PHẦN A — Quyết định & ranh giới

- [x] Q1: duyệt session list/revoke endpoints và resource id theo family/device.
- [x] Q2: provisioning Operator+Owner là service primitive cho OPR-001, không dựng KYC giả.
- [x] Q3–Q4: temp password delivery/expiry + first-login one-time password-change challenge.
- [x] Q5–Q6: Employee lifecycle, namespace xuyên Owner/Employee và slug invariant.
- [x] Q7: v1 không hard cap device; list/revoke semantics/idempotency/current session rõ.
- [x] Q8: re-auth/audit/defer MFA reset/Platform employee/FE được ghi rõ.
- [x] Không mở public register/reset cho Operator, Employee hoặc Platform.
- [x] Không kéo assignment/KYC/UI ngoài owner task vào IAM-005.

## PHẦN B — Schema, migration & RLS

- [x] Fields temp credential/force-change/contact và `auth_epoch` đúng migration; không plaintext secret.
- [x] DB invariant cấm username trùng Owner/Employee trong một tenant, cho phép tenant khác trùng (`account-lifecycle.int.spec.ts`).
- [x] Compound FK/invariant chặn `operator_id`/`operator_slug` drift; slug immutable (`account-lifecycle.int.spec.ts`).
- [x] Migration chạy được trên DB trống và DB IAM-004 có Owner/Employee legacy; `prisma migrate diff` không drift trên DB test rỗng đã migrate.
- [x] `db:app-role` chạy lại idempotent trên DB test; app role không DDL, SUPERUSER, BYPASSRLS hay table owner.
- [x] Tenant tables/session giữ `ENABLE + FORCE RLS`; thiếu context → 0 row (`tenant-rls.int.spec.ts` + registry test).
- [ ] Index phục vụ lookup username, subject/family, expiry; không seq-scan đường revoke nóng.

## PHẦN C — Closed enrollment & password lifecycle

- [ ] Chỉ PlatformAdmin provision Operator+Owner; PlatformSupport/Operator/Employee bị từ chối.
- [x] Provision transactionally: profile + Owner cùng DB transaction; integration DB thật xác nhận delivery lỗi để Owner `LOCKED`, retry cấp password mới và chỉ kích hoạt sau khi gửi thành công.
- [ ] Server sinh temp password đủ entropy; hash scrypt; plaintext chỉ đi qua delivery đã chốt.
- [ ] Temp password hết hạn đúng TTL; expired không cấp challenge/token.
- [ ] Login temp password không cấp access/refresh token, MFA secret/backup code.
- [ ] Password-change token TTL/one-time/bind subject; fake/expired/replay trả lỗi generic.
- [ ] Hai consume đồng thời → đúng một thành công; password cũ chết sau đổi.
- [ ] Owner bắt buộc login lại rồi enroll/verify MFA trước khi nhận token.

## PHẦN D — Employee account & tenant isolation

- [x] Owner tạo/list Employee đúng tenant trên DB thật; unit test chặn role không có quyền create.
- [ ] DTO chỉ nhận field cho phép; tenant/operator id không lấy từ body.
- [ ] Chỉ nhận `DRIVER`, `TICKET_STAFF`, `SUPPORT_STAFF`.
- [ ] Duplicate username trong namespace tenant → 409; concurrent create vẫn chỉ một account.
- [x] Tenant A query không filter vẫn chỉ thấy A qua RLS (`tenant-rls.int.spec.ts`); update id B trả 404 trên DB thật (`account-services.int.spec.ts`).
- [ ] Role/status/password reset bắt reason + recent re-auth theo Q8.
- [x] Lock/disable/role-change/reset tăng `auth_epoch`, revoke mọi family; test DB thật chứng minh access cũ bị chặn dù cache `active`, refresh epoch cũ bị từ chối.
- [ ] Unlock không tự cấp credential hoặc phục hồi session cũ.
- [ ] Audit intent fail-closed trước account mutation; success best-effort sau commit; residual cross-DB được ghi rõ; không password/hash/token/contact đầy đủ.

## PHẦN E — Session list/revoke (FR-IAM-15)

- [x] GET trả đúng một item/family, kể cả family đã rotate nhiều lần (`session.service.int.spec.ts`).
- [ ] Response có current/timestamps/device label/IP masked; `sessionId` là public family id; không row `sid`/hash/token/raw user-agent.
- [ ] Chỉ list subject hiện tại cho Passenger/Owner/Employee/Platform.
- [ ] DELETE ownership check trong query; family subject khác và id giả cùng 404 generic.
- [ ] DELETE idempotent 204; revoke current family được phép.
- [ ] Revoke một family chặn access JWT + refresh của family đó, không ảnh hưởng device khác.
- [ ] Redis down → 503/fail-closed, không success giả; retry sau recovery an toàn.
- [ ] Không tự áp hard cap session ngoài quyết định IAM-002.

## PHẦN F — Contract, leak scan & regression

- [ ] OpenAPI có đủ route, Bearer security, requestBody/response/RFC7807 error.
- [ ] Generated TS + Dart client khớp spec, không drift.
- [ ] Log Pino/Mongo audit/Sentry/Redis/DB/response không lộ temp password, change token, refresh hash, MFA data.
- [ ] IAM-001 namespace/OTP/OAuth regression xanh.
- [ ] IAM-002 rotation/reuse/logout/re-auth regression xanh.
- [ ] IAM-003 permission/TenantGuard/RLS regression xanh bằng role app.
- [ ] IAM-004 MFA challenge/TOTP/backup/re-auth regression xanh.

## PHẦN G — Static, review, smoke & CI

- [ ] Unit + integration/Supertest test happy/negative/race/IDOR/fail-closed.
- [x] `REQUIRE_DB_TESTS=1`; Postgres/Redis/Mongo thật, 386/386 pass, không skip im lặng.
- [x] `pnpm gen:api-client` pass; 47 Dart generated lib files khớp generator v7.25.0 byte-for-byte (không gồm `.g.dart`), `dart test` 148/148.
- [x] `pnpm turbo run typecheck lint test build` xanh 35/35.
- [ ] Guide smoke chạy đủ provisioning/password/employee/session/race/failure.
- [ ] `code-reviewer` + `security-auditor` không còn finding blocking/high.
- [ ] AI journal đã ghi cho code sinh/sửa; không commit journal.
- [ ] CI branch xanh do Khanh xác nhận.
- [ ] Chỉ sau toàn bộ gate mới cập nhật task row/PROJECT-STATE; không đổi status Approved của SDLC.

## PHẦN H — DoD theo sub-task

| Sub-task | DoD | ✓ |
| --- | --- | --- |
| `.1` Quyết định | Q1–Q8 chốt + contract/defer ghi rõ | [x] |
| `.2` Schema | Migration/invariant/RLS/index chạy DB thật | [ ] |
| `.3` Temp credential | Delivery + force-change one-time/fail-closed | [ ] |
| `.4` Owner provision | Platform-only, atomic, conflict/race safe | [ ] |
| `.5` Employee API | RBAC + tenant filter + RLS + revoke-all | [ ] |
| `.6` Session API | Family grouping + ownership + idempotent revoke | [x] |
| `.7` Security | Re-auth + audit + notification, không leak | [ ] |
| `.8` Contract | OpenAPI + TS/Dart clients không drift | [x] |
| `.9` Test | Full regression + hạ tầng thật + mutation evidence | [ ] |
| `.10` Đóng task | review + smoke + CI + state update đúng gate | [ ] |

## PHẦN I — Ranh giới không chặn nghiệm thu nếu Q8 giữ khuyến nghị

- UI KYC/Admin/Employee/session hoàn chỉnh → task feature/UI sở hữu sau khi API ổn định.
- Employee assignment/trip/manifest → TASK-EMP-001.
- KYC document/review/status workflow → TASK-OPR-001/TASK-ADM-001.
- Platform employee provisioning và MFA recovery/regenerate backup code → TASK-ADM-001 hoặc task riêng sau khi có contract.
