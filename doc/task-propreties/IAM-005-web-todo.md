# TASK-IAM-005 (phần giao diện) — Màn Nhân viên và màn Tài khoản của Operator OS

> **Nguồn:** `doc/SDLC/11-project-task-breakdown.md` §7 mốc M2 (việc đầu tiên) — phần giao diện còn thiếu của `TASK-IAM-005`. Yêu cầu: SRS `UC-16`, `FR-IAM-15`; 06 UI §7 dòng Employee; API §7.1 (`/auth/sessions`, `/auth/re-auth`) và §7.3 (`/operator/employees`); quyết định Q1–Q8 của `IAM-005-todo.md`.
> **Thiết kế:** Figma `Giao diện nhà xe · Màn bổ sung` — Nhân viên `1666:25163` (danh sách), `1666:25550` (thêm), `1666:25738` (cấp lại mật khẩu tạm), `1666:25910` (khóa); Tài khoản `1668:28980` (bảo mật).
> **Nhánh:** `TASK-IAM-005-web`, tách từ `TASK-TRN-006` (TRN-005 và TRN-006 chưa merge `develop`).

## Trạng thái (14/10/2026) — 🔨 xong code + test, chưa commit, chờ Khanh review

Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8). Phần này chạm xác thực (xác nhận lại danh tính, thu hồi phiên) nên đáng được review trước khi merge.

## Đã làm

- **Màn Nhân viên** (`/employees`): bảng tài khoản (tên đăng nhập đầy đủ + email, vai trò, trạng thái, tình trạng mật khẩu), tìm theo tên đăng nhập / email, lọc vai trò và trạng thái (lọc ở giao diện — API chưa có tìm / lọc). Thêm, sửa, khóa / mở khóa, cấp lại mật khẩu tạm qua hộp thoại.
- **Xác nhận lại danh tính** (IAM-005 Q8): tạo / sửa / khóa / cấp lại đều cần. Một ô nhận mật khẩu hoặc mã 6 số của ứng dụng xác thực; sau khi xác nhận, khoảng 5 phút không hỏi lại. Máy chủ báo bằng chứng không còn thì ô hiện lại.
- **Màn Tài khoản và bảo mật** (`/account`, mở từ khối tài khoản ở cuối thanh bên): bảng phiên đăng nhập (thiết bị, IP đã che, lúc đăng nhập, lần dùng gần nhất), thu hồi từng phiên, "Đăng xuất các phiên khác"; thẻ Xác thực hai lớp và thẻ Mật khẩu chỉ để đọc.
- **API bổ sung (cần Khanh duyệt):** tài khoản nhân viên trả thêm `passwordChangeRequired` và `temporaryPasswordExpiresAt` để cột "Mật khẩu" biết ai còn dùng mật khẩu tạm và mật khẩu tạm nào đã hết hạn. Hai trường chỉ đọc, đã có sẵn trong bảng `employee_accounts`.
- **`apiRequest` của Operator OS:** 401 mang mã `AUTH_REAUTH_REQUIRED` hoặc `AUTH_INVALID_CREDENTIALS` không còn bị coi là hết phiên. Trước đây mọi 401 đều dẫn tới làm mới phiên rồi đăng xuất; với hai mã này người dùng sẽ bị đăng xuất oan khi gõ sai mật khẩu xác nhận.

## Điểm làm khác khung Figma / phần AI tự quyết — cần Khanh xem

| # | Figma | Đã làm | Lý do |
| --- | --- | --- | --- |
| N1 | Cột "Mật khẩu" ghi "Đăng nhập gần nhất …", "Khóa ngày …" | Ghi tình trạng mật khẩu tạm; dòng phụ ghi ngày cập nhật | API không có ngày đăng nhập gần nhất và ngày khóa |
| N2 | Hộp thoại thêm nhân viên không có ô lý do, không có ô xác nhận danh tính | Có ô xác nhận danh tính (khi cần); lý do tạo dùng một câu có sẵn | API bắt buộc cả lý do lẫn xác nhận danh tính khi tạo; bắt chủ nhà xe gõ lý do cho việc thêm người là thừa |
| N3 | Không vẽ hộp thoại sửa và mở khóa | Sửa dùng lại form thêm + ô lý do; mở khóa dùng lại hộp thoại khóa | Cùng API `PATCH` |
| N4 | Không có nút vô hiệu hóa vĩnh viễn | Chưa làm; tài khoản đã vô hiệu hóa hiện trong bảng nhưng không còn thao tác | API hỗ trợ `DISABLED` (không mở lại được) nhưng thiết kế chưa vẽ — cần Khanh quyết có thêm nút không |
| N5 | Nút "Phân công chuyến" và khung 05 | Chưa làm | Thuộc `TASK-EMP-001` (M5) |
| N6 | Thẻ Xác thực hai lớp ghi ngày thiết lập và số mã dự phòng còn lại | Chỉ ghi "Đang bật" | Chưa có API trả hai số liệu đó |
| N7 | Tab "Thông báo" và nút "Liên hệ hỗ trợ đối tác" | Chưa làm | Thuộc `TASK-NSR-002` (M8); trang Hỗ trợ chưa có |
| N8 | Mô tả từng vai trò | Câu ngắn do AI viết | Tài liệu chưa có mô tả quyền theo vai trò để chép |

## Điều cần biết khi chạy thử

- **Bản dev không gửi được mật khẩu tạm.** Không có `RESEND_API_KEY` thì bộ gửi email của bản dev từ chối gửi (thiết kế có chủ ý: không in mật khẩu ra log), nên tạo nhân viên và cấp lại mật khẩu luôn trả 503. Màn hình xử lý đúng nhánh này: tài khoản vẫn được tạo, dòng ghi "Chưa gửi được mật khẩu tạm", hộp thoại dặn cấp lại chứ không tạo lại. Nhánh gửi thành công chỉ kiểm được khi có email thật.
- **Có `RESEND_API_KEY` thật trong `.env` thì API gửi email thật.** E2E vì vậy phải chạy API với `RESEND_API_KEY` để trống. Lượt chạy đầu của AI ngày 14/10/2026 chưa làm việc này nên API đã gọi Resend một lần với địa chỉ `…@example.com`; Resend từ chối (HTTP 422), không có email nào được gửi.
- **Cấp lại mật khẩu mà gửi email lỗi** (hành vi có sẵn của backend, không sửa ở đây): mật khẩu cũ đã bị thay, phiên đã bị thu hồi và lượt cấp lại của giờ đó đã bị tính — nhân viên không đăng nhập được tới khi cấp lại thành công, sớm nhất sau một giờ. Câu báo lỗi trên màn hình nói rõ điều này.
- Seed E2E đặt lại ngân sách email mật khẩu tạm toàn hệ thống (30 / 24 giờ) ở Redis local, vì mọi lần chạy E2E trên máy dev dùng chung một Redis.

## Evidence (14/10/2026)

- API, `REQUIRE_DB_TESTS=1`, role app, Postgres 16 + Redis + Mongo 7 thật: **76 / 76 file, 1035 / 1035 test, 0 skip**; `account-services.int.spec.ts` kiểm hai trường mới (mật khẩu tạm hết hạn sau 24 giờ, không lộ `passwordHash`). `pnpm lint`, `typecheck`, `test`, `build` cả monorepo: đạt.
- Operator OS: 404 test đơn vị (thêm `lib/auth/reauth.test.ts`, `lib/employee/*.test.ts`, `lib/account/session-format.test.ts`; `api-client.test.ts` thêm ca 401 không thuộc phiên).
- E2E Playwright (Chrome), API chạy thật với `RESEND_API_KEY` trống: **30 / 30** — bốn ca mới ở `employees.e2e.ts`: thêm nhân viên (lỗi tại ô, sai mật khẩu xác nhận không bị đăng xuất, chưa gửi được mật khẩu tạm thì có hướng dẫn); trùng tên đăng nhập + không hỏi lại mật khẩu trong 5 phút + tìm / lọc; khóa / mở khóa / cấp lại / sửa vai trò; thu hồi phiên ở trình duyệt khác thì trình duyệt đó về màn đăng nhập.
- Client TS + Dart sinh lại (openapi-generator v7.25.0): `dart analyze` không lỗi, `dart test` 544 / 544.
- Soi ảnh chụp ba màn (danh sách, hộp thoại thêm, tài khoản) với khung Figma: đúng bố cục, trừ N1–N8.
