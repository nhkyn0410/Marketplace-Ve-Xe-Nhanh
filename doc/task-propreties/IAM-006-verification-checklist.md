# TASK-IAM-006 — Checklist nghiệm thu: Web auth Operator OS + Admin

> Mục tiêu: web đăng nhập bằng cookie httpOnly đúng contract OQ-05; CSRF/Origin/CORS chặn đúng; Mobile JSON/Bearer không đổi.
> Chạy theo thứ tự **A → G**; chỉ tick `[x]` khi có evidence. Lệnh: `IAM-006-guide.md`. Phạm vi: `IAM-006-todo.md`.

## Snapshot trạng thái (27/09/2026)

- [x] Tạo bộ ba todo/guide/checklist; nhánh `TASK-IAM-006` từ `develop` (`5eb6b75`).
- [x] Q1–Q4 được Khanh chốt; task row `Ready → In Progress` (11 Task v0.19).
- [ ] Khanh đặt `OPERATOR_WEB_ORIGINS` + `ADMIN_WEB_ORIGINS` + `WEB_CSRF_SECRET` trên Render trước khi deploy (production thiếu → API không khởi động); kiểm không có Owner dùng `nv.`.

## Port sang repo chính — 03/10/2026 (nhánh `TASK-IAM-006-web`, chưa commit)

Evidence các phần A–G bên dưới là của lần chạy ở repo bản sao (27/09). Phần này ghi lại lần port + đo lại trên `develop` repo chính.

- [x] **Phạm vi lần này (Khanh chốt 03/10):** BE web auth + giao diện đăng nhập **nhà xe** (Operator OS). **Chưa làm**: trang Admin (`apps/admin` không đổi), bố cục màn hình hẹp, nút đăng xuất trong shell (`app-shell.tsx`, `dashboard-shell.tsx` không đổi).
- [x] BE: lấy phần web auth của bản sao (cookie transport, CSRF, `/auth/csrf`, `/auth/me`, CORS, env); **giữ bản tách cổng Owner/Employee + migration của repo chính** (PR #16), không lấy migration `20260927010000` của bản sao. Gỡ 9 file xung đột theo nguyên tắc đó.
- [x] Sửa lệch contract lộ ra khi chạy test của repo chính: cổng chỉ-Bearer (`/auth/employee/login`, `/auth/otp/verify`, `/auth/oauth/session`) nhận `X-Auth-Transport: cookie` trả **400 `AUTH_TRANSPORT_INVALID` trước** kiểm Origin/CSRF (API §7.1.1, TC-SEC-010) — thêm `@BearerOnly()` + kiểm trong `WebCsrfGuard`. Bản sao trả 403 `AUTH_ORIGIN_FORBIDDEN` khi thiếu Origin.
- [x] Test API bằng role app, Postgres + Redis + Mongo thật, `REQUIRE_DB_TESTS=1`: **65/65 file, 748/748 test**, 0 skip; 11 migration trên DB trống, `migrate diff` rỗng.
- [x] Giao diện theo Figma "Giao diện nhà xe" (section `830:1977`, 22 khung): bố cục hai cột, hộp thoại thông báo, nút hiện/ẩn mật khẩu, nút đang xử lý, trạng thái kiểm tra phiên / chuyển tiếp. Asset biểu tượng xuất từ Figma ở `apps/operator-os/public/auth/`.
- [x] Quyết định áp dụng (Khanh, 03/10): "Cần cấp lại mật khẩu?" mở hộp thoại hướng dẫn liên hệ quản trị nền tảng; khối "Trở thành đối tác / Đăng ký" **ẩn** tới TASK-OPR-001; chip "VI" chỉ trang trí. Không còn thông báo "dùng app Nhân viên" (UI v0.11).
- [x] Trạng thái Figma chưa có khung, đã làm trong code và **bổ sung khung vào Figma**: `Màn 3A - Mã xác thực không hợp lệ` (`989:388`), `Màn 1 - Lỗi kết nối khi gửi` (`989:443`), `Màn 1 - Hướng dẫn cấp lại mật khẩu` (`989:529`).
- [x] Playwright Operator OS **4/4** (Chrome local, API build + DB thật): first-login → đổi mật khẩu → hộp thoại → login lại → TOTP → 10 mã dự phòng → vào app, reload giữ phiên; access hết hạn → đúng 1 refresh; nhân viên nhận lỗi chung; hộp thoại cấp lại mật khẩu + không có lối đăng ký. Ca đăng xuất qua giao diện bỏ vì chưa có nút.
- [x] Chụp 19 trạng thái ở 1440×890 và đối chiếu Figma (thủ công).
- [x] Co giãn desktop (Khanh yêu cầu 03/10, không thêm khung Figma): nội dung tối đa 1440px ở giữa; lề ngang 48px dưới 1440; khung nhìn thấp hơn 890px thu đệm dọc, logo 48px, thẻ đệm nhỏ hơn, QR 128px, ô mã dự phòng 36px. Đo 8 trạng thái × 8 khung nhìn (1280×585 → 2560×1305): **0 tràn ngang**; đăng nhập + xác thực hai lớp vừa khung mọi cỡ; bật xác thực + mã dự phòng vừa từ 1536×729, laptop 1366×768 / 1280×800 còn cuộn 30–90px, màn 1280×720 cuộn 110–140px (đổi mật khẩu 33px). Ở 1440×890 các màn dữ liệu cố định giống từng byte bản trước. QR giải mã lại (jsQR) khớp khóa ở 1440×890, 1366×633, 1280×585, 1536×729 phóng 125%.
- [x] Contract: OpenAPI thêm `GET /auth/csrf`, `GET /auth/me`; 8 operation auth + 3 schema đổi theo cookie mode. Client TS + Dart sinh lại: `dart test` 423/423, `dart analyze` 0 error; `mobile_shared` 30/30, 2 app Flutter analyze sạch.
- [x] `pnpm turbo run typecheck lint test build --force` **35/35**.
- [ ] Review `code-reviewer` + `security-auditor` cho phần riêng của lần port (guard `BearerOnly`, FE mới) — chưa chạy lại; phần BE web giống bản đã review ở bản sao.
- [ ] Trang Admin, màn hình hẹp (<1280px: tablet/điện thoại), nút đăng xuất — ngoài phạm vi lần này.

## PHẦN A — Quyết định & ranh giới

- [x] Q1 viết riêng từng app · Q2 QR (`qrcode`) + secret · Q3 Playwright tối thiểu trong task · Q4 Employee vào Operator OS → báo không có dữ liệu + thu hồi phiên.
- [x] Tài liệu Q4 cập nhật theo yêu cầu Khanh: UI v0.6 §4/§7, API v0.10 §7.1/§7.1.1, Test v0.4 TC-SEC-008.
- [x] Không kéo auth Passenger/Marketplace, Employee mobile, màn nghiệp vụ, Platform employee, recovery MFA.

## PHẦN B — BE transport & cookie

- [x] `X-Auth-Transport` áp đúng 6 endpoint (+ khai OpenAPI); thiếu = bearer; lạ = 400 `AUTH_TRANSPORT_INVALID` (`auth-transport.spec`, `web-auth.http.spec`).
- [x] Cookie mode: `vxn_access` (HttpOnly, Lax, `/v1`, 900 s), `vxn_refresh` (HttpOnly, Strict, `/v1/auth/refresh`, 30 ngày), `vxn_csrf` (không HttpOnly, Strict, `/v1`); host-only; có `Max-Age` + `Expires`; `Secure` ở production (`web-auth.service.spec`).
- [x] Body cookie mode không có access/refresh token thô; `backupCodes` đúng một lần khi vừa enrollment (HTTP + DB thật).
- [x] Bearer + `vxn_access` cùng lúc → 400 `AUTH_TRANSPORT_AMBIGUOUS` (GET và unsafe).
- [x] Logout / refresh hỏng (reuse, hết hạn) / revoke current family xoá cả 3 cookie đúng Path (Max-Age=0); revoke family khác không xoá.
- [x] Hồi quy Mobile: không header → JSON token, không `Set-Cookie` (HTTP + DB thật); IAM-001..005 xanh; Dart client 423/423, 2 app Flutter analyze sạch.

## PHẦN C — CSRF / Origin / CORS / bootstrap

- [x] `GET /auth/csrf` cấp cookie + `{csrfToken}`, khôi phục token còn hợp lệ; rotate khi cấp session / refresh / đổi mật khẩu.
- [x] Unsafe cookie request trong `/v1/**` (kể cả route nghiệp vụ giả `/probe`) thiếu/sai/cũ/trùng CSRF → 403 `AUTH_CSRF_INVALID`; Origin thiếu/lạ/`null`/khác port → 403 `AUTH_ORIGIN_FORBIDDEN`; Bearer và GET được miễn.
- [x] CORS echo exact origin, `credentials: true`, `Vary: Origin`, không `*`; preflight 204 không qua auth/CSRF; origin lạ không có header CORS.
- [x] `GET /auth/me` đúng field (`sessionId` = family id công khai), `no-store`, không token/secret/backup code, không tự refresh.
- [x] Env `OPERATOR_WEB_ORIGINS` + `ADMIN_WEB_ORIGINS` + `WEB_CSRF_SECRET` fail-fast ở production (thiếu, HTTP, localhost, trùng secret khác); origin không exact hoặc thuộc cả hai app bị từ chối mọi môi trường.
- [x] M1: phiên cookie từ origin app khác scope → 403 `AUTH_ORIGIN_FORBIDDEN` (GET/mutation/login); refresh sai origin bị chặn trước khi xoay, không xoá cookie (HTTP + DB thật).

## PHẦN D — FE Operator OS + Admin

- [x] Bootstrap: CSRF → `/auth/me` → 401 thì refresh single-flight đúng một lần → retry; thất bại về login (Vitest + Playwright đếm đúng 1 `/auth/refresh`).
- [x] First login Owner: mật khẩu tạm → đổi → login lại → TOTP enrollment (QR + secret) → backup code một lần → shell; reload giữ phiên.
- [x] Admin: `platform/{username}` → TOTP → shell; tài khoản nhà xe ở Admin → lỗi chung, không vào shell.
- [x] Nhân viên ở Operator OS → lỗi đăng nhập chung từ cổng Owner, không có phiên (Playwright).
- [x] Cổng nhân viên `/auth/employee/login` (Bearer, `nv.`) tách khỏi Owner: unit + HTTP + DB thật; migration đổi tên nhân viên cũ và dừng khi Owner dùng `nv.` (thử trên dữ liệu cũ).
- [x] Không render sidebar/dữ liệu trước khi bootstrap xong; login hiển thị tại URL hiện tại (không tham số redirect).
- [x] Logout xoá phiên (cookie mất, reload vẫn ở login); lỗi đăng nhập generic.

## PHẦN E — Contract

- [x] OpenAPI có `/auth/csrf`, `/auth/me`, header transport/CSRF, union login/MFA/refresh; `openapi.spec.ts` khoá các điểm này (và bắt được lỗi thiếu provider làm test bị bỏ qua).
- [x] Client TS + Dart sinh lại, chỉ đổi phần IAM-006 (16 file Dart sửa + 32 file mới).

## PHẦN F — Test & regression

- [x] Vitest BE: TC-SEC-005/006/007 + cookie flags + clear cookie + luồng cookie trên DB thật.
- [x] Test FE auth client: single-flight, retry một lần, CSRF retry, login sai không refresh (6/6 mỗi app).
- [x] E2E TC-SEC-008: Operator 3/3 (gồm nhân viên nhận lỗi chung), Admin 2/2 (Chrome local, API + DB thật) — chạy lại sau tách cổng.
- [x] `REQUIRE_DB_TESTS=1` **734/734**, 0 skip (sau tách cổng + M1 + sửa review); monorepo typecheck/lint/build 26/26, test FE 10/10 mỗi app.

## PHẦN G — Review, CI & đóng task

- [x] `code-reviewer` + `security-auditor` không còn finding blocking/high (2 High + M1/M2 + các Low đã xử lý — bảng todo #8; L2 phần Domain cha để OPS-001).
- [x] Smoke guide §2–§3 có evidence tương đương (HTTP spec + DB int + Playwright).
- [x] AI journal đã ghi; không commit `.ai-journal/`.
- [ ] CI xanh — Khanh xác nhận; task row → `Done`; không đổi trạng thái Approved của tài liệu SDLC.
- [ ] Job CI Playwright (dựng API + DB + 2 app) — để TASK-TEST-001/OPS-001 theo Q3.
