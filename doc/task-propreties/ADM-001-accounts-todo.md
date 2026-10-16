# TASK-ADM-001 (phần nhà xe + người dùng) — Todo: Admin quản lý nhà xe, hành khách, nhân viên, tài khoản quản trị

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` — `TASK-ADM-001` (FR-ADM-02..03) + `FR-IAM-08` (khóa / mở khóa tài khoản). Nguồn chi tiết: SRS `UC-23` A6, `BR-57`; Security §7 (Admin quản lý tài khoản), §5 (TOTP bắt buộc phía Platform); Figma section `Giao diện Admin` (`1663:23890`): `ADM-02e` Danh sách nhà xe (`1670:30496`), `ADM-02f` Hộp thoại tạm khóa (`1670:30853`), `ADM-03a` Hành khách (`1671:30553`), `ADM-03b` Nhân viên nhà xe — chỉ xem (`1671:30902`), `ADM-03c` Tài khoản quản trị (`1671:31207`), `ADM-03d` Thêm tài khoản quản trị (`1671:31570`).
> **Khanh (16/10/2026):** chọn làm "Quản lý nhà xe + người dùng"; phần dữ liệu chưa có thiết kế: "Tự thiết kế + code" (ghi tài liệu, chờ duyệt).
> **Nhánh:** làm tiếp trên `TASK-ADM-004`, chưa commit.

## Trạng thái (16/10/2026) — 🔨 **Code xong, chưa commit — chờ Khanh review + CI**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).

## Đã làm

### DB — migration `20261016020000_account_management` (tự thiết kế, chờ duyệt — G1)

- `operator_profiles`: `suspended_reason`, `suspended_at` + CHECK `SUSPENDED` ⇔ có lý do.
- `users` (hành khách): `status` (`AccountStatus`, mặc định `ACTIVE`), `locked_reason`, `locked_at` + index.
- `platform_accounts`: `contact_email` (unique), `auth_epoch`, `credential_delivery_pending`, `password_change_required`, `temporary_password_expires_at`, `locked_reason`, `locked_at`, `created_by` + CHECK (định dạng tên đăng nhập `NOT VALID` để không chặn dữ liệu cũ).

### Backend

- Quyền mới `user:manage` (PLATFORM_ADMIN) — không dùng `account:lock` vì chủ nhà xe cũng có quyền đó (phạm vi tenant).
- `/admin/operators` (`operator/`): danh sách (tìm tên / mã / chủ nhà xe, lọc trạng thái, số tuyến + chuyến đang mở bán, cờ chờ gửi mật khẩu tạm); `POST …/{id}/suspend` (lý do) / `…/unsuspend` — xác nhận lại danh tính; so-rồi-đặt (409 khi trạng thái vừa đổi); audit trong transaction; tạm khóa thu hồi mọi phiên chủ nhà xe + nhân viên; email chủ nhà xe.
- `/admin/passengers` (`iam/user/`): danh sách (email, cách đăng nhập, trạng thái, lần đăng nhập gần nhất); khóa (lý do) / mở khóa; khóa thu hồi phiên; hành khách bị khóa đăng nhập → 403 `AUTH_ACCOUNT_LOCKED`.
- `/admin/employees`: nhân viên mọi nhà xe, **chỉ xem** (lọc nhà xe / vai trò).
- `/admin/platform-accounts`: danh sách; cấp mới (mật khẩu tạm gửi email nội bộ, phải đổi + bật TOTP lần đầu; gửi lỗi → `credential_delivery_pending`); cấp lại mật khẩu; đặt lại 2FA (xóa TOTP + backup code **và** cấp mật khẩu tạm mới); khóa / mở khóa. Không tự thao tác trên chính mình (409 `PLATFORM_ACCOUNT_SELF_ACTION`); không khóa quản trị viên đang hoạt động cuối cùng (409 `PLATFORM_ACCOUNT_LAST_ADMIN`, khóa dòng `FOR UPDATE`).
- Đăng nhập Platform dùng các cột mới: mật khẩu tạm hết hạn → từ chối; phải đổi mật khẩu → luồng đổi mật khẩu dùng chung (`PasswordChangeService` thêm chủ thể `PLATFORM`).

### Admin (`apps/admin`)

- `/operators` tab "Nhà xe" (ADM-02e/f); `/users` ba tab Hành khách / Nhân viên nhà xe / Tài khoản quản trị (ADM-03a…03d). Mọi thao tác thay đổi: hộp thoại lý do (khi cần) + mã TOTP (5 phút không hỏi lại).

## Chờ Khanh (G1–G9)

| #  | Điểm | Đã làm theo | Cần Khanh |
| -- | ---- | ----------- | --------- |
| G1 | Schema | Cột như trên (DB §5 chưa có trạng thái khóa hành khách / vòng đời tài khoản Platform) | Duyệt |
| G2 | Quyền | `user:manage` chỉ PLATFORM_ADMIN; Hỗ trợ nền tảng không xem / khóa | Duyệt |
| G3 | Đặt lại 2FA | Đồng thời cấp mật khẩu tạm mới (tránh người cầm mật khẩu cũ vào lại không cần 2FA) | Duyệt |
| G4 | Giới hạn an toàn | Không tự khóa / đặt lại mình; luôn còn ≥ 1 quản trị viên hoạt động; không có vai trò "super-admin" | Duyệt |
| G5 | Cột Figma chưa có dữ liệu | Bỏ: lọc "Khu vực" và đánh giá của nhà xe; số điện thoại, hạng thành viên, số vé của hành khách | Bổ sung khi có booking / loyalty |
| G6 | "Gửi lại" mật khẩu chủ nhà xe | Nút ở danh sách mở chi tiết hồ sơ đăng ký (luồng gửi lại có sẵn ở ADM-001) | Duyệt |
| G7 | "Đăng nhập gần nhất" | = thời điểm phiên gần nhất được cấp (`auth_sessions.issued_at`) | Duyệt |
| G8 | Tên đăng nhập Platform | `platform/` + 3–40 ký tự chữ thường, số, `.`, `_`, `-` | Duyệt |
| G9 | Nhân viên nhà xe | Admin chỉ xem, không khóa (nhà xe tự quản lý — UC-16) | Duyệt / có cần Admin khóa nhân viên |

## Kiểm tra (16/10/2026)

- `admin-operator.int.spec.ts` 3 ca, `admin-account.int.spec.ts` 5 ca trên Postgres thật (role app); `admin-operator.http.spec.ts` (guard thật cho 13 route nhà xe + người dùng: 401 / 403 chủ nhà xe + hỗ trợ nền tảng / 401 `AUTH_REAUTH_REQUIRED`; validate). `auth.service.spec.ts`, `password-change.int.spec.ts` thêm ca hành khách bị khóa + mật khẩu tạm Platform.
- E2E `users.e2e.ts` 3 ca (tạm khóa / mở khóa nhà xe; khóa / mở khóa hành khách + nhân viên chỉ xem; cấp tài khoản quản trị → khóa / mở khóa, không tự khóa mình).

## Việc tiếp theo

1. Khanh review, chốt G1–G9.
