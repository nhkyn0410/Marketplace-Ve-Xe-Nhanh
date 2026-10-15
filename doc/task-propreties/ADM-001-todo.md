# Cổng Admin — Todo: đăng nhập + khung (phần web Admin của TASK-IAM-006) và duyệt hồ sơ nhà xe (phần hồ sơ của TASK-ADM-001)

> **Yêu cầu (Khanh, 15/10/2026):** "Hướng tới dựng hoàn thiện phần admin". Làm theo thứ tự đã đề xuất: **A1** đăng nhập Admin + khung → **A2** duyệt hồ sơ đăng ký nhà xe → A3 Điểm dừng (`TASK-ADM-004`) → A4 Danh mục → A5 Kiểm duyệt ảnh xe + Nhật ký audit → A6 Chính sách + khung giá → A7 Bài viết (`TASK-CNT-001`).
> **Nguồn:** `doc/SDLC/11-project-task-breakdown.md` — `TASK-IAM-006` (phần web Admin), `TASK-ADM-001` (duyệt hồ sơ, gọi `provisionOperatorOwner`). SRS `UC-23`, `UC-10` A2 / A4 / A5, `BR-75`, `FR-ADM-03`, `NTF-15`; LLD §6.11 bước 4–5, §7; DB §7, §8; API §7.5, §8; Security §7 (`kyc:review`), §9; Test `TC-OPR-002`; Figma section `Giao diện Admin` (`1663:23890`): `ADM-00a/00b` (đăng nhập), `ADM-02a` hàng đợi (`1670:29313`), `ADM-02b` chi tiết (`1670:29689`), `ADM-02c` hộp thoại duyệt (`1670:30067`), `ADM-02d` hộp thoại từ chối (`1670:30288`).
> **Nhánh:** `TASK-IAM-006-admin` tạo từ `TASK-OPR-001` (cần OPR-001a: bảng hồ sơ + luồng người nộp). Merge theo thứ tự `TASK-OPR-001` → `TASK-IAM-006-admin`.

## Trạng thái (15/10/2026) — 🔨 **A1 + A2 xong, chưa commit — chờ Khanh review + CI**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).
- Chưa thử với email thật (Resend) và R2 private thật: E2E chạy với bộ gửi chỉ ghi log + kho ổ đĩa local.
- **Chưa làm:** A3–A7; tab "Nhà xe" (danh sách / khóa nhà xe) của màn Nhà xe & KYC — xem "Đề xuất task mới".

## Đã làm

### A1 — Đăng nhập Admin + khung (phần web Admin của `TASK-IAM-006`)

- Giao diện đăng nhập web dùng chung chuyển từ Operator OS sang `packages/ui` (`lib/auth/api-client`, `lib/auth/reauth`, `components/auth/{auth-context,auth-ui,login-flow}`); mỗi cổng khai một cấu hình `AuthPortal` (đường login, scope / vai trò được nhận, chữ, màu, khối hero). Operator OS giữ file cũ dạng re-export — giao diện nhà xe không đổi.
- Admin: `platform/{username}` → mật khẩu → bật TOTP lần đầu (bắt buộc) / nhập mã → khung Admin. Màu indigo + thanh bên tối theo Figma (`DashboardShell` thêm `tone="dark"`). Thanh bên đủ mục theo Figma; mục chưa làm có trang giữ chỗ "Chưa có trong phiên bản này". Header bảo mật (`frame-ancestors 'none'`, `X-Frame-Options: DENY`, `Referrer-Policy: no-referrer`).
- Tài khoản nhà xe đăng nhập ở cổng Admin → cùng một lỗi chung như sai mật khẩu.

### A2 — Duyệt hồ sơ đăng ký nhà xe (phần hồ sơ của `TASK-ADM-001`)

**Backend (`apps/api/src/operator-kyc/`)** — quyền `kyc:review` (chỉ `PLATFORM_ADMIN`), scope DB `platform`:

| Route | Việc |
| ----- | ---- |
| `GET /admin/operator-applications` | Hàng đợi hồ sơ đã gửi duyệt (nháp không hiện), mới gửi trước, phân trang cursor; lọc `status`, `submittedSince`, `duplicatesOnly`; tìm `q` theo mã / tên / email / mã số thuế; mỗi dòng kèm trường trùng hồ sơ khác (`CONTACT_EMAIL`, `TAX_CODE`, `BANK_ACCOUNT`) |
| `GET …/{id}` | Chi tiết: thông tin, giấy tờ (chỉ metadata), số tài khoản che 4 số cuối, hồ sơ trùng (tối đa 10 / loại), nhà xe + chủ nhà xe đã tạo (khi duyệt), lịch sử (tạo → xác minh email → gửi duyệt / bổ sung / từ chối / duyệt, đọc từ audit; Mongo lỗi → `history: null`, hồ sơ vẫn xem được) |
| `POST …/{id}/documents/{type}/download-url` | URL xem giấy tờ hạn 5 phút, mỗi lần cấp ghi audit kèm Admin xem |
| `POST …/{id}/approve` | Bắt buộc `Idempotency-Key` + xác nhận lại danh tính. Một transaction: `provisionOperatorOwner` (Operator `ACTIVE` + Owner mật khẩu tạm) → khóa dòng hồ sơ → `APPROVED` + `operator_id` + người / thời điểm duyệt + khóa idempotency → thu hồi mọi link → audit. Gửi lặp cùng khóa → trả lại kết quả cũ; khác khóa → 409. Slug đã dùng → 409 `OPERATOR_SLUG_CONFLICT`, không tạo gì. Email mật khẩu tạm lỗi → vẫn duyệt, trả `credentialDeliveryPending: true` |
| `POST …/{id}/request-info` | Lý do 3–500 ký tự → `NEEDS_INFO`, thu hồi link cũ, cấp link mới, gửi email kèm nội dung + link (NTF-15) |
| `POST …/{id}/reject` | Lý do + xác nhận lại danh tính → `REJECTED`, thu hồi mọi link, gửi email kèm lý do |
| `POST …/{id}/resend-owner-credentials` | Gửi lại mật khẩu tạm khi lần gửi lúc duyệt lỗi (UC-23 A4), dùng `retryOwnerDelivery` + hạn mức IAM-005 |

- Ba quyết định chỉ nhận hồ sơ `SUBMITTED` (UC-23 A1); đổi trạng thái + thu hồi link + audit trong một transaction (audit lỗi → 503, không đổi gì). Email kết quả gửi sau commit; lỗi thì quyết định vẫn lưu, phản hồi `emailDelivered: false` để màn hình báo.
- `AccountProvisioningService.provisionOperatorOwner` nhận thêm bước `inTransaction` chạy trong cùng transaction (không đổi hành vi cũ).
- Migration `20261015010000_operator_application_review`: `reviewed_at`, `reviewed_by`, `approval_idempotency_key` + CHECK (người duyệt đi cùng thời điểm; đã có quyết định thì có người duyệt; khóa idempotency ⇔ `APPROVED`) + index `bank_account_number`.
- Cổng email thêm `sendOperatorApplicationDecision` (Resend + bộ ghi log dev). `AuditService.listAuditEvents` nhận `operatorId: null` = đối tượng cấp Platform (chỉ đọc sự kiện không gắn tenant; thiếu `operatorId` vẫn bị từ chối).
- Client TS + Dart sinh lại.

**Admin (`apps/admin`)** — theo Figma ADM-02a…02d:

- `/operators`: hàng đợi — lọc trạng thái, thời điểm gửi (mặc định 30 ngày như Figma), cảnh báo trùng, tìm kiếm; cột cảnh báo; "Tải thêm"; trạng thái tải / lỗi / rỗng.
- `/operators/applications/{id}`: chi tiết + ba nút quyết định khi Chờ duyệt; "Mở tệp" mở tab mới tới URL có hạn; kiểm tra trùng định danh (liên kết tới hồ sơ trùng); lịch sử; dải kết quả sau khi duyệt (tài khoản `slug/username`, nút "Gửi lại mật khẩu tạm" khi chưa gửi được) / lý do bổ sung, từ chối.
- Hộp thoại: duyệt (slug gợi ý từ tên hiển thị, tên đăng nhập có tiền tố `slug/`, kiểm luật như máy chủ, báo trùng slug tại ô; một `Idempotency-Key` cho mỗi lần mở), yêu cầu bổ sung (không hỏi TOTP), từ chối (cảnh báo kết quả cuối), gửi lại mật khẩu tạm. Ô "Mã xác thực (TOTP)" chỉ hiện khi chưa xác nhận trong 5 phút.
- Dùng chung với Operator OS (chuyển sang `packages/ui`, Operator OS giữ re-export): `FormField`, `IdentityField` (thêm chế độ `totp`), `list-parts`, phần chung của `list-controls`; `apiRequest` nhận thêm `headers`.

## Chờ Khanh (G1–G12)

| #   | Điểm | Đã làm theo | Cần Khanh |
| --- | ---- | ----------- | --------- |
| G1  | **Chép giấy tờ sang `kyc_documents` + tạo `bank_accounts` khi duyệt** (LLD §6.11 bước 4, UC-23 bước 5, TC-OPR-002 vế cuối) | DB §5.2 mới có tên hai bảng, chưa có cột. **Chưa làm**: giấy tờ và tài khoản nhận tiền vẫn ở hồ sơ, gắn với nhà xe qua `operator_id` (RLS hồ sơ chỉ cho platform — nhà xe chưa đọc được) | Thiết kế hai bảng ở OPR-001b (Hồ sơ & KYC sau duyệt) / payout, hay làm ngay |
| G2  | Hợp đồng API §7.5 chưa có body / response | Định nghĩa đủ 7 route (bảng trên); thêm 2 route chưa có trong tài liệu: `…/documents/{type}/download-url` (xem giấy tờ từng tệp, audit từng lần mở thay vì ký URL cho mọi tệp mỗi lần xem chi tiết) và `…/resend-owner-credentials` (UC-23 A4). Đã ghi API v0.31 | Duyệt |
| G3  | Xác nhận lại danh tính | Duyệt, từ chối, gửi lại mật khẩu tạm: bắt buộc (Figma 02c / 02d có ô TOTP). Yêu cầu bổ sung: không (API §7.5 chỉ ghi TOTP cho duyệt; quyết định đảo ngược được) | Duyệt |
| G4  | Idempotency của duyệt | Khóa lưu ở cột `approval_idempotency_key` (cùng transaction), không dùng Redis. Lặp cùng khóa → trả kết quả cũ (cờ `credentialDeliveryPending` là trạng thái lúc đọc); khác khóa sau khi đã duyệt → 409 `OPERATOR_APPLICATION_INVALID_STATE`. Khóa 8–128 ký tự `[A-Za-z0-9_-]`, sai / thiếu → 400 `VALIDATION_FAILED` | Duyệt |
| G5  | Mã lỗi mới | `OPERATOR_APPLICATION_NOT_FOUND` (404) cho id lạ và hồ sơ nháp (Admin không thấy nháp) | Duyệt |
| G6  | Admin không thấy hồ sơ nháp | Hàng đợi chỉ gồm hồ sơ đã gửi duyệt ít nhất một lần; nháp → 404 | Xác nhận |
| G7  | Trùng định danh (UC-10 A2) | So email liên hệ, mã số thuế, số tài khoản nhận tiền với **mọi** hồ sơ khác (kể cả nháp, đã duyệt — hồ sơ đã duyệt = nhà xe đang hoạt động). Không có số giấy phép vận tải nên Figma "Giấy phép vận tải: không trùng" chưa làm được | Xác nhận; có cần nhập số giấy phép không |
| G8  | Xem đầy đủ số tài khoản | Figma ghi "xem đầy đủ cần xác nhận lại danh tính" — chưa làm, chỉ hiện 4 số cuối | Có cần trong v1 không |
| G9  | Email kết quả | Gửi thẳng sau commit, chờ kết quả để báo Admin (`emailDelivered`); lỗi không hoàn tác quyết định. Yêu cầu bổ sung gửi lỗi thì người nộp vẫn tự xin lại link được | Duyệt |
| G10 | Tab "Nhà xe (n)" của Figma ADM-02a + đếm số hồ sơ trên tab | Chưa làm — danh sách / khóa nhà xe (FR-ADM-02/03, Figma ADM-02e/f) chưa có task | Xem "Đề xuất task mới" |
| G11 | Mặc định "Thời điểm gửi" = 30 ngày (như Figma) | Hồ sơ chờ quá 30 ngày bị ẩn khỏi màn mặc định | Giữ, hay đổi mặc định "Mọi thời điểm" |
| G12 | Lịch sử chỉ ghi "Quản trị viên nền tảng" | Chưa hiện tên tài khoản Admin ra quyết định (cột `reviewed_by` + audit có id) | Có cần hiện tên không |

## Đề xuất task mới (chưa có trong file 11 — chờ Khanh)

1. **Quản lý nhà xe + người dùng** (FR-ADM-02, FR-ADM-03, UC-23 bước 7 / A6; Figma ADM-02e/f, ADM-03a–d): danh sách nhà xe, tạm ngưng / mở lại kèm lý do (thu hồi phiên, chặn mở bán), tra cứu người dùng, khóa tài khoản.
2. **Tích hợp & hệ thống** (FR-ADM-14/15, Figma ADM-16): trạng thái cổng thanh toán / email / kho, cấu hình hệ thống.

## Kiểm tra (15/10/2026)

- API, Postgres + Redis + Mongo thật, role app: **90 file / 1181 test đạt** (migration đã áp vào DB test + `db:app-role`). Mới: `operator-application-review.int.spec.ts` 14 ca (TC-OPR-002: một Operator + một Owner khi gửi lặp cùng khóa / đồng thời cùng khóa / hai Admin khác slug cùng lúc; slug trùng không tạo gì; audit lỗi không tạo gì; email lỗi → chờ giao rồi gửi lại; bổ sung → người nộp gửi lại; từ chối; lọc + cursor + cảnh báo trùng; lịch sử), `operator-application-review.http.spec.ts` 10 ca (guard thật: không token 401, chủ nhà xe / hỗ trợ nền tảng 403, re-auth, `Idempotency-Key`, validate), audit Mongo thật (đọc lịch sử cấp Platform không lẫn tenant), email Resend.
- Gốc repo: lint 9/9, typecheck 11/11, test (Admin 8, Operator OS 409, `packages/ui` 32) đạt.
- E2E Admin **7/7** (`auth.e2e.ts` 3, `operator-applications.e2e.ts` 4: hàng đợi + cảnh báo trùng + lọc; chi tiết + số tài khoản che + mở giấy tờ ở tab mới; yêu cầu bổ sung → người nộp gửi lại → từ chối kèm TOTP; duyệt: tên đăng nhập `nv.` / slug trùng báo tại ô, duyệt xong báo tài khoản + mật khẩu tạm chờ gửi lại). E2E Operator OS **36/36** sau khi chuyển thành phần dùng chung.
- Client Dart: 0 lỗi analyzer (29 cảnh báo `unused_import` có sẵn trong code sinh), 696 test đạt.
- Đối chiếu Figma bằng ảnh chụp 1440 px: hàng đợi, chi tiết, hai hộp thoại khớp bố cục; ở 390 px không tràn ngang (đã sửa nhãn ẩn `sr-only` trong tiêu đề bảng làm rộng trang).
- E2E Admin cần API + DB test như Operator OS (`IAM-006-guide.md` §3) và **nạp biến môi trường E2E trước khi chạy Playwright** (script seed / cấp link ghi thẳng DB). Seed E2E thêm tài khoản `platformReviewer`.

## Việc tiếp theo

1. Khanh review A1 + A2, chốt G1–G12; commit / PR theo thứ tự `TASK-OPR-001` → `TASK-IAM-006-admin`.
2. A3 — màn Điểm dừng của Admin (`TASK-ADM-004`, hộp thoại dùng lại bản đồ của `TASK-TRN-014`).
