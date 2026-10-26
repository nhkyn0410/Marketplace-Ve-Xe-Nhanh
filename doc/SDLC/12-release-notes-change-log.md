# 12. Release Notes & Change Log - Marketplace-Ve-Xe-Nhanh

## 1. Thông tin tài liệu

### 1.1. Metadata

| Thuộc tính    | Giá trị                          |
| ------------- | -------------------------------- |
| Tên tài liệu  | Release Notes & Change Log       |
| Mã tài liệu   | 12-release-notes-change-log      |
| Dự án         | Marketplace-Ve-Xe-Nhanh          |
| Trạng thái    | Draft                            |
| Người viết    | Nguyễn Hồng Khanh, AI Agent      |
| Người duyệt   | Nguyễn Hồng Khanh                |
| Ngày tạo      | 01/06/2026                       |
| Ngày cập nhật | 25/10/2026                       |
| Loại (15289)  | Release information / Change log |

### 1.2. Lịch sử thay đổi

| Phiên bản | Ngày       | Người cập nhật | Nội dung thay đổi                                                                                                                                                                                                                           |
| --------- | ---------- | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| v0.1      | 01/06/2026 | AI Agent       | Tạo **skeleton** Release Notes & Change Log theo ISO/IEC/IEEE 15289 + quy ước Keep a Changelog. Định nghĩa SemVer, quy trình release, phân loại thay đổi, template release log (chưa có release — pre-code). Chưa có nội dung release thật. |
| v0.2      | 09/09/2026 | AI Agent       | **TASK-DOC-008 — kích hoạt khi vào code v1.** §9 bổ sung **ADR-028** vào phạm vi release `1.0.0` (mapping cũ dừng ở ADR-027) + tách dòng riêng cho Mobile. §7 ghi nhận **kênh phát hành Mobile v1 = phân phối trực tiếp, KHÔNG qua store** (ADR-028) nên `Rollback` của Mobile khác Web. §10 đóng **REL-OQ-04** (kênh phát hành Mobile). Bối cảnh: nền tảng xong (TASK-FND-001..008 Done, thêm **TASK-FND-009** setup Flutter), IAM-001 gần đóng → tài liệu này bắt đầu có việc thật. |
| v0.3      | 25/10/2026 | AI Agent       | **Ghi mốc demo 10/2026** (Khanh 25/10: cập nhật toàn bộ tài liệu). §7 thêm mục **"Mốc demo nội bộ — 25/10/2026"**: ảnh chụp những gì đã có trên `develop` + môi trường demo (Render + Supabase), **không phải release** — chưa gắn tag / version vì REL-OQ-01 còn mở. §8 ghi lần **reset toàn bộ DB** ngày 21/10/2026 (RB-10) và 3 migration ngày 21/10. §3.2 sửa câu "chưa code v1". Giữ Draft. |

---

## 2. Mục lục

1. Thông tin tài liệu
2. Mục lục
3. Giới thiệu
4. Quy ước đánh version (SemVer)
5. Quy trình release
6. Phân loại thay đổi
7. Release log
8. Migration & breaking change notes
9. Mapping ADR ↔ release
10. Open Questions / TBD

---

## 3. Giới thiệu

### 3.1. Mục đích

Tài liệu này ghi nhận **release của sản phẩm/code** (v1.0.0 trở đi) và change log theo từng release: tính năng thêm/sửa/bỏ, breaking change, migration, bảo mật. Đây là nguồn tra cứu cho người vận hành, người duyệt và (sau này) khách hàng Operator.

### 3.2. Phân biệt với các change log khác

| Loại thay đổi                         | Theo dõi tại                                                         |
| ------------------------------------- | -------------------------------------------------------------------- |
| Thay đổi **tài liệu SDLC** (pre-code) | `context/PROJECT-STATE.md §7` + Lịch sử thay đổi (§1.2) của từng doc |
| Quyết định kiến trúc                  | `10-architecture-decision-record.md`                                 |
| Thay đổi **code/sản phẩm** (release)  | **Tài liệu này (12)** — bắt đầu từ release v1.0.0                    |

Dự án đang **code v1** (từ 09/2026). Chưa cắt release nào; §7 chỉ ghi **mốc demo nội bộ** (ảnh chụp tiến độ, không gắn version). Release đầu tiên dự kiến **v1.0.0** khi code v1 lên production (hoặc `0.x` beta — REL-OQ-01).

### 3.3. Tài liệu tham chiếu

| Tài liệu                                     | Vai trò                                    |
| -------------------------------------------- | ------------------------------------------ |
| `09-deployment-operation-standard.md` | Quy trình release (§5), rollback (§10)     |
| `10-architecture-decision-record.md` | Quyết định kỹ thuật phản ánh trong release |
| `context/PROJECT-STATE.md`                   | Trạng thái doc, OQ, change log SDLC        |
| `08-test-plan-acceptance-criteria.md` | Exit criteria gate cho release             |

---

## 4. Quy ước đánh version (SemVer)

Dùng **Semantic Versioning** `MAJOR.MINOR.PATCH` cho release code (v1.0.0+).

| Thành phần | Tăng khi                                                             | Ví dụ           |
| ---------- | -------------------------------------------------------------------- | --------------- |
| MAJOR      | Breaking change API/DB/contract (cần migration phía client/Operator) | `1.0.0 → 2.0.0` |
| MINOR      | Thêm tính năng tương thích ngược                                     | `1.0.0 → 1.1.0` |
| PATCH      | Sửa lỗi/bảo mật tương thích ngược                                    | `1.0.0 → 1.0.1` |

- API URL version (`/v1`, `/v2`) đổi theo MAJOR breaking (ADR-012).
- Mobile (Flutter): v1 **không phát hành store** (ADR-028) → mọi thay đổi = build lại + phân phối trực tiếp (APK / cài qua Xcode), không có store review và cũng không cần OTA. Khi nào lên store thì áp lại quy tắc PATCH/MINOR/MAJOR + cân nhắc Shorebird.
- Pre-release: hậu tố `-alpha.N` / `-beta.N` / `-rc.N` khi cần (vd `1.0.0-beta.1`).

---

## 5. Quy trình release

| Bước | Nội dung                                                                 | Nguồn               |
| ---- | ------------------------------------------------------------------------ | ------------------- |
| 1    | Đạt Exit criteria test (critical pass: money/idempotency/tenant/seat)    | 08 Test §10.2       |
| 2    | GitHub Actions pass (lint + typecheck + Vitest + build + gen-client)     | ADR-026             |
| 3    | Tag version SemVer + viết entry release log (§7) + change log (§6)       | Tài liệu này        |
| 4    | Backup production (Postgres PITR + Mongo) trước deploy                   | 09 Deploy §5 REL-06 |
| 5    | Merge `main` → Render auto-deploy (API + worker cùng image); Mobile build riêng (`flutter build apk`, Android local — ADR-028) | ADR-023/024/026/028 |
| 6    | Smoke test + theo dõi Sentry (không error spike)                         | 09 Deploy §5 REL-07 |
| 7    | Nếu lỗi → rollback (Render previous deploy; Mobile = phân phối lại bản build trước — v1 không qua store nên không phải chờ review) | 09 Deploy §10       |

> Người duyệt release (promote trạng thái) = **Khanh** (AI không tự duyệt).

---

## 6. Phân loại thay đổi

Mỗi release liệt kê thay đổi theo nhóm (Keep a Changelog):

| Nhóm         | Ý nghĩa                                                  |
| ------------ | -------------------------------------------------------- |
| `Added`      | Tính năng/endpoint/màn hình mới                          |
| `Changed`    | Thay đổi hành vi hiện có                                 |
| `Deprecated` | Sắp loại bỏ (kèm ngày, header `Deprecation` per ADR-012) |
| `Removed`    | Đã loại bỏ                                               |
| `Fixed`      | Sửa lỗi                                                  |
| `Security`   | Vá bảo mật (ưu tiên cao nhất)                            |

---

## 7. Release log

> **Chưa có release.** Bảng dưới là **template**; điền khi cắt release v1.0.0 đầu tiên (code v1 lên production).

> ⚠️ **Mobile phát hành khác Web (ADR-028)**: v1 phục vụ môn học, **không lên App Store / Play Store** → không có store review, cũng không có OTA. Mỗi bản Mobile = build lại + phân phối trực tiếp (APK, hoặc cài qua Xcode nếu có máy macOS). Vì vậy cột `Rollback` của Mobile là "phát hành lại bản trước", không phải "rollback deploy" như Web/API. Lên store về sau ⇒ áp lại quy trình store + cân nhắc Shorebird cho OTA.

| Version            | Ngày | Loại  | Tóm tắt                                            | Migration | Link |
| ------------------ | ---- | ----- | -------------------------------------------------- | --------- | ---- |
| `1.0.0` (template) | TBD  | MAJOR | MVP v1: marketplace + operator OS + platform admin | TBD       | TBD  |

<!--
Template entry cho mỗi release (copy khi release thật):

### vX.Y.Z — DD/MM/YYYY

**Loại**: MAJOR / MINOR / PATCH
**Phạm vi**: (module/actor ảnh hưởng)

#### Added
- ...
#### Changed
- ...
#### Fixed
- ...
#### Security
- ...

**Breaking change / Migration**: (xem §8) hoặc "Không"
**Rollback**: (cách rollback nếu cần)
-->

### Mốc demo nội bộ — 25/10/2026 (không phải release)

**Loại**: ảnh chụp tiến độ — chưa tag, chưa gắn version (REL-OQ-01 còn mở).
**Môi trường**: `develop` → Render (API) + Supabase Postgres + Mongo Atlas + Upstash Redis + R2; chỉ dữ liệu mẫu (OQ-21 đóng cho giai đoạn demo, 20/10/2026). Trạng thái từng task: 11 Task §7.

#### Added

- Nền tảng: monorepo, Docker API + worker, Prisma + RLS, Mongo audit, BullMQ, Zod env, Pino + Sentry, OpenAPI + client TS / Dart, nền FE web, 2 app Flutter (`TASK-FND-001..010`).
- Đăng nhập 3 namespace, JWT + refresh xoay vòng, RBAC + `TenantGuard` + RLS, TOTP + mã dự phòng, cấp tài khoản khép kín (`TASK-IAM-001..005`); web đăng nhập Operator OS / Admin (`TASK-IAM-006`, đang làm).
- **Phân quyền theo từng tài khoản** (`TASK-IAM-007`, PR #44): tài khoản quản trị tick quyền, tài khoản quản lý nhà xe do Owner cấp (`OPERATOR_MANAGER`).
- Operator OS: xe + sơ đồ ghế + ảnh xe, tuyến, điểm dừng, chuyến + lịch lặp, bảng giá, hỗ trợ / khiếu nại, khuyến mãi, báo cáo; Admin: duyệt nhà xe, danh mục, điểm dừng, kiểm duyệt nội dung, bài viết, báo cáo, nhật ký audit (phần lớn **In Progress — chờ Khanh duyệt**).
- Danh mục hành chính chính thức sau sáp nhập 2025 (34 tỉnh, 3.321 xã) + ánh xạ địa danh cũ + điểm dừng chuẩn (PR #46, #48).
- Web Marketplace nối API + giao diện theo Figma (PR #49, #50); `passenger_mobile` giao diện đăng nhập + OTP (PR #47); `employee_mobile` giao diện tài xế bằng dữ liệu mẫu.

#### Security

- Tắt trigger `ensure_rls` của Supabase, thu quyền `anon` / `authenticated` trên bảng của app (sự cố 20/10/2026 — RB-02).
- Đổi quyền / khóa tài khoản tăng `auth_epoch` + thu hồi phiên; không cấp quyền vượt quyền người thao tác (`TASK-IAM-007`).

#### Chưa có ở mốc này

- Đặt vé lõi: tìm chuyến, giữ chỗ, đặt vé, thanh toán, vé + QR, hủy / hoàn tiền, escrow + payout (`TASK-TRN-004`, `TASK-BTP-001..006` — Draft). Thay VNPay / MoMo bằng payOS + cổng demo (Khanh 21/10/2026) chưa có task.
- Thông báo (`TASK-NSR-001/002`), deploy staging + build APK (`TASK-OPS-001`).
- Chưa chạy `code-reviewer` / `security-auditor` cho các phần trên.

**Breaking change / Migration**: reset toàn bộ DB 21/10/2026 — xem §8.
**Rollback**: không áp dụng (chưa release).

---

## 8. Migration & breaking change notes

> Mỗi mục cần: nguyên nhân, bước migration (DB Prisma / API client / mobile), thời gian downtime dự kiến, rollback plan. Tham chiếu 04 DB §10 (migration) + 09 Deploy §10 (rollback).

| Ngày | Nội dung | Bước | Downtime | Rollback |
| ---- | -------- | ---- | -------- | -------- |
| 21/10/2026 | **Reset toàn bộ DB** (local + production) vì thêm role `OPERATOR_MANAGER` + cột `permissions` (`TASK-IAM-007`) — Khanh quyết xóa mọi tài khoản cũ. Mất toàn bộ tài khoản / nhà xe / dữ liệu nghiệp vụ; giữ Mongo audit + file R2 | RB-10: SQL xóa đối tượng ứng dụng → `prisma migrate deploy` → `db:app-role` → `db:seed:catalog` → kiểm tra Supabase → flush Upstash → tạo quản trị viên đầu tiên | Suốt lúc reset (Render suspend) | Không — chỉ dữ liệu mẫu |
| 21/10/2026 | 3 migration: `20261021010000_account_permissions` (enum `OPERATOR_MANAGER`, cột `permissions` JSONB, CHECK Owner ⇔ `NULL`), `20261021010000_administrative_units_metadata` (`level`, `decree`, `search_text`), `20261021020000_legacy_administrative_mappings` (bảng ánh xạ hành chính cũ) | `prisma migrate deploy` + `db:app-role` (RB-02) rồi `db:seed:catalog` (RB-08); client TS / Dart sinh lại (RB-04) | Không | Migration mới đảo ngược (không sửa migration đã áp) |

---

## 9. Mapping ADR ↔ release

Release v1.0.0 sẽ là hiện thực hóa toàn bộ **19-layer stack** đã chốt (ADR-002 + ADR-009..027). Bảng này ghi nhận release nào đưa quyết định ADR nào vào production (điền khi release).

| Release           | ADR hiện thực hóa                                      | Ghi chú                                       |
| ----------------- | ------------------------------------------------------ | --------------------------------------------- |
| `1.0.0` (dự kiến) | ADR-002, ADR-009..028 (toàn bộ stack v1)               | TBD khi cắt release                           |
| ↳ phần Mobile     | **ADR-028** (Flutter thay Expo/RN, supersedes ADR-014) | Phát hành **ngoài store** ở v1 — xem §7 và §8 |

---

## 10. Open Questions / TBD

| ID        | Câu hỏi                                                                                | Tác động     | Trạng thái                         |
| --------- | -------------------------------------------------------------------------------------- | ------------ | ---------------------------------- |
| REL-OQ-01 | Release đầu tiên gắn version `1.0.0` hay `0.x` beta trước?                             | Versioning   | Mở (quyết khi gần code production) |
| REL-OQ-02 | Cadence release v1.x (theo Sprint 1 tuần per CLAUDE.md §6.1) cố định hay theo nhu cầu? | Release plan | Mở                                 |
| REL-OQ-03 | Release notes có công khai cho Operator (customer-facing) hay chỉ nội bộ?              | Audience     | Mở                                 |
| REL-OQ-04 | Kênh phát hành Mobile v1 là gì?                                                        | Release plan | **Đóng 09/09/2026 theo ADR-028**: phân phối trực tiếp (APK / cài qua Xcode), KHÔNG qua store; mở lại nếu thương mại hoá |

---

### Quy ước mã trong Release Notes

- `REL-OQ-NN`: Câu hỏi mở của Release Notes.
- Version release: SemVer `MAJOR.MINOR.PATCH` (§4).
