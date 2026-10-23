# TASK-IAM-007 — Todo: Phân quyền theo từng tài khoản (Admin + tài khoản quản lý nhà xe)

> **Nguồn:** Khanh 21/10/2026 — "lên chiến lược để triển khai quyền truy cập cho từng tài khoản ở admin và nhà xe". Khanh chọn: phía nhà xe = **tài khoản quản lý** dùng Operator OS, **Owner tự tạo** trong OS; làm phân quyền **trước**, sau đó mới thay VNPay/MoMo (payOS + cổng demo — task riêng).
> **Căn cứ:** SRS `FR-IAM-07` ("Admin cấu hình hoặc gán quyền nội bộ cho tài khoản Admin theo phạm vi trách nhiệm" — chưa có task); ADR-017 (RBAC hardcoded enum v1, ABAC defer; `can()` là điểm cắm); Security §5 (TOTP), §7 (ma trận quyền), §8. Phần nhà xe **mở rộng SRS** (SRS chỉ có Owner dùng Operator OS) — tự thiết kế, chờ duyệt.
> **Nhánh:** `feat/account-permissions` từ `develop` (`99151f8`), worktree riêng `C:\Code\Ve_Xe_Nhanh_IAM` — không đụng nhánh Marketplace đang dở.

## Trạng thái (21/10/2026) — ✅ Code xong, đã commit + push nhánh `feat/account-permissions` (chưa merge) — chờ Khanh duyệt + sinh lại Dart client

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).
- **Còn thiếu trước khi push:** sinh lại Dart client (`packages/api_client_dart`, FND-009-guide §3) — cần Docker hoặc tải `openapi-generator-cli-7.25.0.jar`; không sinh lại thì CI `contract.yml` đỏ (DTO `/auth/me`, tài khoản quản trị, `/operator/managers` đã đổi).

## Thiết kế (tự thiết kế — chờ duyệt P1–P12)

### Mô hình: vai trò là trần, tài khoản mang danh sách quyền riêng

- Role vẫn là enum của ADR-017: quyết định scope token, MFA, phạm vi grant (`any` / `tenant` …) và là **trần** quyền.
- Tài khoản Platform và tài khoản quản lý nhà xe có cột `permissions text[]`: tập con của **quyền tick được** của role. Quyền không tick được của role (vd `notification:manage`) luôn đi theo role.
- `can(actor, permission)`: role có grant **và** (quyền không tick được **hoặc** tài khoản không mang danh sách **hoặc** danh sách có quyền đó). Không route nào phải sửa.
- Tài khoản Platform cũ / seed: `permissions = NULL` = đủ quyền tick được của role → hành vi không đổi.

### Quyền mới / tách (P1)

| Quyền | Thay cho | Phạm vi |
| ----- | -------- | ------- |
| `access:manage` | phần tài khoản quản trị của `user:manage` | PLATFORM_ADMIN `any`: cấp / khóa / cấp lại mật khẩu, 2FA, **phân quyền** tài khoản quản trị |
| `manager:manage` | (mới) | OPERATOR_OWNER `tenant`: tài khoản quản lý của nhà xe + phân quyền. Tên riêng vì route Admin chỉ khai quyền — dùng chung `access:manage` thì grant `tenant` của Owner lọt vào route Admin |
| `payout:manage` | 6 route ghi của `/admin/payouts` (đang `finance:configure`) | PLATFORM_ADMIN |
| `refund:manage` | 3 route ghi của `/admin/refunds` (đang `finance:configure`) | PLATFORM_ADMIN |

`finance:configure` còn lại: chính sách + hoa hồng + khung giá. Mục đích tách: tick "Kế toán" (chi trả, hoàn tiền) mà không cho đổi hoa hồng.

### Quyền tick được theo role (P2)

| Role | Quyền tick được |
| ---- | --------------- |
| PLATFORM_ADMIN | `kyc:review`, `user:manage`, `access:manage`, `catalog:manage`, `finance:configure`, `payout:manage`, `refund:manage`, `payment:monitor`, `system:run`, `system:read`, `audit:read`, `promotion:configure`, `loyalty:manage`, `content:manage`, `content:moderate`, `support:manage`, `dispute:decide` |
| PLATFORM_SUPPORT | `payment:monitor`, `support:manage` |
| OPERATOR_MANAGER (mới) | `vehicle:manage`, `route:manage`, `trip:manage`, `booking:read`, `finance:read`, `employee:manage`, `support:respond`, `promotion:manage` |
| OPERATOR_OWNER | Không tick — luôn đủ quyền. Chỉ Owner: `kyc:submit` (hồ sơ, giấy tờ, **tài khoản nhận tiền**), `manager:manage` |

### Role mới `OPERATOR_MANAGER` (P3)

- Lưu ở `operator_accounts` (cùng cổng đăng nhập Owner `{slug}/{username}`, cùng registry tên đăng nhập, cấm tiền tố `nv.`). `permissions` bắt buộc (CHECK: Owner ⇔ `NULL`).
- **TOTP bắt buộc** như Owner (Operator OS có dữ liệu tài chính, booking, hành khách).
- Không nhận thông báo / email của chủ nhà xe (truy vấn `role = OPERATOR_OWNER` giữ nguyên).
- Owner tạo trong Operator OS (closed enrollment như nhân viên): mật khẩu tạm gửi email, lần đầu đổi mật khẩu + bật TOTP.

### Rào chắn (P4–P8)

1. **Trần** (P4): danh sách ⊆ quyền tick được của role — Zod ở HTTP + kiểm lại ở service.
2. **Không leo thang** (P5): chỉ thêm / bớt quyền mình đang có (còn lại phải giữ nguyên, sai → 403 `PERMISSION_GRANT_FORBIDDEN`). Tạo tài khoản Platform mới **bắt buộc** kèm danh sách — không còn tạo mới với `NULL`.
3. **Không tự khóa ngoài** (P6): không tự sửa quyền mình; trong transaction khóa dòng mọi tài khoản Platform đang hoạt động rồi kiểm "còn ≥ 1 tài khoản hoạt động có `access:manage`" (hai Admin bỏ quyền của nhau cùng lúc không làm hệ thống hết người phân quyền). Khóa tài khoản dùng cùng điều kiện, thay cho "≥ 1 PLATFORM_ADMIN".
4. **Hiệu lực ngay** (P7): đổi quyền = tăng `auth_epoch` + thu hồi mọi phiên (trước và sau khi ghi) — người bị đổi đăng nhập lại. Không để quyền cũ sống thêm 15 phút của access token.
5. **Kiểm soát** (P8): đổi quyền cần xác nhận lại danh tính + lý do + audit trước / sau (ghi audit trong transaction như ADM-001; lỗi → 503, không đổi gì).

### Token và `/auth/me` (P9)

- Claim `perms` (mảng mã quyền) chỉ có khi tài khoản mang danh sách riêng. Token `OPERATOR_MANAGER` thiếu claim → bị từ chối (fail-closed).
- Đăng nhập, xác thực MFA và làm mới phiên đều đọc lại danh sách từ DB.
- `GET /auth/me` thêm `permissions` = quyền hiệu lực — web ẩn menu / nút theo đó; server vẫn là nơi chặn.

### API (P10 — chờ duyệt cùng 05 API)

| Endpoint | Quyền | Ghi chú |
| -------- | ----- | ------- |
| `GET /admin/platform-accounts` | `access:manage` | Mỗi dòng thêm `permissions` (hiệu lực); response thêm `grantable` = quyền người xem được tick, theo role |
| `POST /admin/platform-accounts` | `access:manage` + xác nhận lại | Thêm `permissions` (bắt buộc) |
| `PUT /admin/platform-accounts/{id}/permissions` | `access:manage` + xác nhận lại | `{ permissions, reason }`; 409 `PLATFORM_ACCOUNT_SELF_ACTION` / `PLATFORM_ACCOUNT_LAST_ADMIN` |
| `…/reset-password`, `…/reset-mfa`, `…/lock`, `…/unlock` | đổi `user:manage` → `access:manage` | |
| `GET /operator/managers` | `manager:manage` (Owner) | Kèm `grantable` |
| `POST /operator/managers` | `manager:manage` + xác nhận lại | `{ username, contactEmail, permissions, reason }` |
| `PATCH /operator/managers/{id}` | `manager:manage` + xác nhận lại | `{ permissions?, status?, reason }` |
| `POST /operator/managers/{id}/password-reset`, `…/mfa-reset` | `manager:manage` + xác nhận lại | Mật khẩu tạm mới gửi email; reset 2FA kèm mật khẩu tạm (như Admin) |

### DB

Migration `add_account_permissions`: `OperatorRole` thêm `OPERATOR_MANAGER`; `platform_accounts.permissions text[] NULL`; `operator_accounts.permissions text[] NULL` + CHECK `(role = 'OPERATOR_OWNER') = (permissions IS NULL)`.

### Giao diện (Figma chưa có khung — dựng theo kit hiện có)

- Admin: tab "Tài khoản quản trị" thêm cột Quyền + hành động "Phân quyền" (hộp thoại tick theo nhóm màn hình); hộp thoại cấp tài khoản thêm phần tick (điền sẵn theo mẫu). Thanh bên ẩn mục không có quyền.
- Operator OS: mục "Tài khoản quản lý" (chỉ Owner); tài khoản quản lý đăng nhập OS, thanh bên + trang theo quyền.

### Phát sinh khi làm (P11–P12)

- **P11 `transport:read`** (mới, không tick — luôn có với Owner + tài khoản quản lý): GET danh sách / chi tiết xe, sơ đồ ghế, tuyến, điểm dừng, chuyến, lịch chạy, bảng giá (+ lịch sử giá) đổi từ `*:manage` sang `transport:read`. Lý do: màn Đặt vé / Tài chính / Báo cáo / Phân công đọc chéo danh sách chuyến, tuyến, xe — không tách thì tick "Kế toán" vẫn hỏng màn hoặc phải cấp kèm quyền **sửa** xe / tuyến. Ghi vẫn giữ `*:manage`.
- **P12 giao diện theo quyền:** `/auth/me.permissions` → thanh bên hai cổng ẩn mục không có quyền, vào thẳng URL → "Bạn chưa được cấp quyền dùng trang này"; Tổng quan Admin / Operator OS chỉ gọi API được phép (khối khác ẩn); nút thao tác ẩn theo quyền riêng: chi trả (`payout:manage`), hoàn tiền (`refund:manage`), ra quyết định tranh chấp (`dispute:decide`), chạy đối soát (`system:run`); tab Người dùng / Nhà xe & KYC theo quyền; bộ lọc "Nhà xe" ở báo cáo cần `user:manage`.

### Ngoài phạm vi

- Nhân viên app (Driver / TicketStaff / SupportStaff): giữ theo role + phân công.
- Đổi role tài khoản Platform (Admin ↔ Hỗ trợ); quản lý tạo quản lý.

## Việc

- [x] BE lõi: quyền mới / tách, quyền tick được (`ACCOUNT_PERMISSIONS`), `can()` + claim `perms`, `/auth/me.permissions`
- [x] DB migration `20261021010000_account_permissions` + Prisma
- [x] BE Admin: `access:manage`, `PUT /admin/platform-accounts/{id}/permissions`, cấp mới kèm quyền, khóa theo "còn người có `access:manage`"
- [x] BE Operator: role `OPERATOR_MANAGER`, `/operator/managers*`, `transport:read`
- [x] Test: bất biến quyền, `can()`, token, HTTP guard, int Postgres thật (role app, RLS FORCE)
- [x] Admin web: cột Quyền, hộp thoại Phân quyền + tick khi cấp, ẩn menu / tab / nút / khối Tổng quan
- [x] Operator OS: màn Tài khoản quản lý, cổng nhận tài khoản quản lý, ẩn menu / link
- [x] Sinh lại OpenAPI + client TS (`OpenApiModule` thêm `OperatorManagerController`)
- [ ] Sinh lại Dart client — **chờ Docker / tải generator** (xem Trạng thái)
- [x] Tài liệu: SRS `FR-IAM-19`, ADR-017 bổ sung, DB v0.34, API v0.38, Security v0.25, UI v0.35, Task v0.57 (`TASK-IAM-007`), GLOSSARY, PROJECT-STATE §7 — **chờ duyệt**. LLD chưa sửa.

## Kiểm tra (21/10/2026)

- `pnpm typecheck` + `pnpm lint` toàn monorepo: sạch.
- Vitest không DB: API 1.195 ca, UI 40, Admin 62, Operator OS 452 — qua.
- Vitest có DB (DB tạm `vexenhanh_iam007` trên Postgres dev local, migrate bằng owner, chạy bằng role app như `db-integration.yml`; đã xóa sau khi chạy): 1.619 / 1.621 qua; 2 ca (`operator-application-review` email lỗi, `seat-hold` Redis) lỗi khi chạy song song toàn bộ, chạy riêng qua 19/19 — không liên quan thay đổi. Ca mới: `admin-account.int.spec.ts` (phân quyền, không leo thang, đọc quyền người thao tác từ DB), `operator-manager.int.spec.ts` (cấp / đổi quyền / khóa / 2FA, tenant, CHECK DB).
- Chạy thật trên trình duyệt (API + Admin + Operator OS của nhánh, DB tạm, tắt gửi email): Admin phân quyền một tài khoản theo mẫu "Kế toán" → dòng hiện "4 quyền"; đăng nhập tài khoản đó → thanh bên chỉ còn Tổng quan / Thanh toán & hoàn tiền / Chi trả nhà xe / Báo cáo, `/users` báo chưa được cấp quyền, Tổng quan chỉ gọi `/admin/overview`. Owner tạo tài khoản quản lý "Kế toán" → đăng nhập bắt buộc bật TOTP → thanh bên Tổng quan / Đặt vé / Tài chính / Báo cáo; mọi API các trang này gọi đều 200 (nhờ `transport:read`).
