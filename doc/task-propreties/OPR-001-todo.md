# TASK-OPR-001 — Todo: Đăng ký nhà xe + Hồ sơ & KYC

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` §7 — Operator onboarding: form đăng ký công khai + link bảo mật (BR-75), upload KYC (R2 private + presigned), gửi duyệt; profile sau khi duyệt. Nguồn chi tiết: SRS `FR-OPR-01..06`, `FR-OPR-12`, `UC-10`, `BR-75`, `AC-17`, `OQ-19`; LLD §6.11, §7; DB §5.2, §7 (`operator_applications*`); API §5, §7.3; Security §4–§5, §9, §11; Test `TC-OPR-001..003`; ADR-017, ADR-018; Figma section `Giao diện nhà xe · Màn bổ sung` (`1663:23891`) — nhóm "Đăng ký tham gia" `1669:29021` … `1669:29764`, nhóm "Hồ sơ & KYC" `1667:27240`, `1667:27586`; khối "Trở thành đối tác" ở màn đăng nhập (`840:2074`).
> **Nhánh:** `TASK-OPR-001` từ `develop` (`c69403f`, sau PR #34).
> **Khanh chốt 14/10/2026 ("Làm như đề xuất"):** (1) production chưa cấu hình kho riêng tư thì API giấy tờ trả 503, không chặn khởi động (OQ-21); (2) trang đăng ký công khai đặt trong Operator OS; (3) chia việc 001a (đăng ký công khai) → Admin tối thiểu (đăng nhập Admin + phần duyệt hồ sơ của ADM-001) → 001b (Hồ sơ & KYC sau khi duyệt).

## Trạng thái (14/10/2026) — 🔨 **001a xong (BE + trang công khai), chưa commit — chờ Khanh review + CI**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).
- Kho riêng tư mới chạy với ổ đĩa local (dev / test); chưa thử R2 private thật.
- **Chưa làm:** phần duyệt (ADM-001), Hồ sơ & KYC sau khi duyệt (001b).

## Đã làm — 001a

### Backend (`apps/api`)

- **DB** — migration `20261014030000_add_operator_applications`: ba bảng `operator_applications`, `operator_application_documents`, `operator_application_access_tokens`; CHECK `status = APPROVED` ⇔ có `operator_id`, có `submitted_at` khi đã gửi, email chữ thường, giấy tờ 1 byte – 10 MB và chỉ PDF / JPEG / PNG, token sống tối đa 30 ngày; RLS policy `platform_only` (`app_rls_allows(NULL)` — chỉ scope platform / system) trên cả ba bảng.
- **Link bảo mật** (`src/iam/role/application-access.ts`): token 32 byte, DB chỉ giữ SHA-256, hạn `OPERATOR_APPLICATION_LINK_TTL_HOURS` (mặc định 72 giờ); guard kiểm header `X-Application-Token` (sai / hết hạn / bị thu hồi / hồ sơ đã có kết quả → 401 `OPERATOR_APPLICATION_LINK_INVALID`, một mã chung), lần mở đầu ghi `contact_email_verified_at`.
- **API** (`src/operator-kyc/`): `POST /operator-applications` và `POST …/access-link` (luôn 202, giới hạn tần suất theo email + IP), `GET` / `PUT …/current`, `POST …/current/documents` (URL tải lên kho riêng tư, hạn 5 phút), `POST …/current/documents/{type}/download-url` (URL xem giấy tờ, hạn 5 phút, ghi audit), `POST …/current/submit` (thiếu → 422 kèm mọi mục còn thiếu; đủ → `SUBMITTED` + audit trong cùng transaction).
- **Kho riêng tư** (`PRIVATE_STORAGE`): R2 khi có `R2_PRIVATE_BUCKET` + tài khoản R2; dev / test → ổ đĩa `.storage/private` + route dev `GET /v1/dev-storage/download?token=`; production chưa khai → `null`, API giấy tờ trả 503.
- **Email** link bảo mật qua cổng `EmailNotifier` (Resend); gửi sau commit, không chờ.
- **Job dọn giấy tờ mồ côi**: hàng đợi `kyc-maintenance`, 03:45 giờ VN mỗi ngày, xóa giấy tờ không còn hồ sơ tham chiếu và cũ hơn 24 giờ (dùng chung hàm dọn với ảnh xe — `external/storage/orphan-objects.ts`).
- Client TS + Dart sinh lại.

### Operator OS (`apps/operator-os`)

- Trang công khai, không cần đăng nhập, không có khung quản trị: `/register` (Figma 01 → 02), `/register/resend` (04), `/register/application` (03 / 05 / 06).
- Link mở dạng `/register/application#token=…`: token đọc một lần, cất trong `sessionStorage` của tab, xóa khỏi thanh địa chỉ; mở link mới khi trang đang mở cũng đọc token mới.
- Form hoàn thiện hồ sơ: thông tin doanh nghiệp, thông tin công khai, ba giấy tờ (tải lên → "chưa lưu" → gắn khi "Lưu nháp" / "Gửi duyệt"; "Xem" mở tab mới tới URL có hạn), tài khoản nhận tiền (số đã lưu chỉ hiện 4 số cuối, để trống = giữ). Cột "Tiến độ hồ sơ" tính ngay trên form; còn thiếu thì "Gửi duyệt" khóa và nêu mục thiếu.
- Màn đăng nhập: khối "Trở thành đối tác" + nút "Đăng ký" (Figma `840:2074`).

## Chờ Khanh (G1–G15)

| #   | Điểm | Đã làm theo | Cần Khanh |
| --- | ---- | ----------- | --------- |
| G1  | **Figma 07 / 08 lệch BR-75** | Figma có trang "Được duyệt" / "Bị từ chối" mở qua link, nhưng BR-75 + LLD §6.11 thu hồi link khi hồ sơ có kết quả → hai trang này không tới được; kết quả báo qua email (UC-10 bước 9, A5). Làm theo BR-75 | Giữ BR-75, hay cho link xem trạng thái cuối (đổi BR-75) |
| G2  | Ngữ cảnh DB của người nộp hồ sơ | DB §7: RLS chỉ cho scope platform / system → guard ở `iam/role` trao scope `system` cho đúng các route của hồ sơ; service luôn lọc theo hồ sơ lấy từ token. Cách chặt hơn (scope RLS riêng cho một hồ sơ) là đổi thiết kế DB | Duyệt |
| G3  | Hợp đồng API chưa có trong tài liệu | Định nghĩa body / response của 6 route; `PUT …/current` nhận cả bộ giấy tờ (giống ảnh xe); route mới `POST …/current/documents/{type}/download-url`; mã lỗi mới `OPERATOR_APPLICATION_INCOMPLETE` (422 + `reasons`), `…_DOCUMENT_INVALID` (422), `…_DOCUMENT_NOT_FOUND` (404), `…_RATE_LIMITED` (429). Đã ghi vào API v0.30 | Duyệt |
| G4  | Danh mục giấy tờ | FR-OPR-03 nói "theo danh mục Admin cấu hình"; v1 cố định ba loại theo OQ-19. Danh mục cấu hình được để ADM-001 | Xác nhận |
| G5  | Giới hạn file giấy tờ | Tài liệu chưa có: PDF / JPEG / PNG, tối đa 10 MB, kiểm chữ ký file thật | Duyệt |
| G6  | Giới hạn tần suất | Tạo hồ sơ / xin lại link: 3 lần / email / giờ và 10 lần / IP / giờ (đếm riêng từng hành động); URL tải giấy tờ: 30 lần / hồ sơ / giờ | Duyệt con số |
| G7  | Mã hồ sơ | `OA-năm-6 số ngẫu nhiên` (Figma minh họa 4 số); trùng thì sinh lại | Xác nhận |
| G8  | Gửi email | LLD ghi "enqueue BullMQ"; làm gửi thẳng sau commit, không chờ — worker chưa chạy trên production (render.yaml) nên email qua hàng đợi sẽ không bao giờ đi. Gửi lỗi chỉ ghi log; người nộp dùng "Gửi lại link" | Duyệt |
| G9  | Kho riêng tư production | Theo Q1: chưa khai `R2_PRIVATE_BUCKET` thì API giấy tờ trả 503 (OQ-21 vẫn mở) | — |
| G10 | "Thông báo Admin có hồ sơ cần duyệt" (UC-10 bước 7) | Chưa làm — Admin thấy hồ sơ trong hàng đợi ở ADM-001 | Xác nhận để ADM-001 |
| G11 | Đánh dấu trùng thông tin (UC-10 A2) | Chưa làm; đã có index `tax_code` / `contact_email` để màn duyệt ADM-001 tra | Xác nhận để ADM-001 |
| G12 | Danh sách ngân hàng | 18 ngân hàng phổ biến cố định ở giao diện, lưu theo tên; chưa có danh mục ngân hàng | Xác nhận |
| G13 | Audit của người nộp | Ghi audit khi gửi duyệt và mỗi lần cấp URL xem giấy tờ, vai trò `APPLICANT`, không có `actorId` (chưa có tài khoản) | Xác nhận |
| G14 | Token trong link | Đặt sau `#` (không gửi lên máy chủ web, không vào log / Referer), xóa khỏi thanh địa chỉ, cất theo tab | — |
| G15 | Điều khoản đối tác | Lưu thời điểm đồng ý (`terms_accepted_at`); chưa có trang Điều khoản / Chính sách để dẫn link | Cung cấp nội dung khi có |

## Kiểm tra (14/10/2026)

- API, Postgres + Redis + Mongo thật, role app: **88 file / 1154 test đạt** (migration đã áp vào DB test + `db:app-role`). Test mới: `operator-application.int.spec.ts` (RLS, link bảo mật, không lộ email, gửi lại link thu hồi link cũ, lưu nháp, giấy tờ không hợp lệ, gửi duyệt + audit, audit lỗi → giữ nháp, lưu đồng thời, kho chưa cấu hình → 503, job dọn), HTTP (guard thật, 202, 401, 400), unit (định dạng, giới hạn tần suất, kho private, cấu hình env).
- Như CI ở gốc repo: lint + typecheck + test (Operator OS 430, API 903 đạt / 251 bỏ qua vì cần DB) + build — đạt.
- E2E Operator OS: **36/36 đạt**, gồm `register.e2e.ts` 4 ca. Ca cũ ở `auth.e2e.ts` kiểm "chưa có lối đăng ký nhà xe" đã đổi thành kiểm có khối "Trở thành đối tác".
- Client Dart: 0 lỗi analyzer, 621 test đạt. Worker khởi động sạch, lịch `application-document-cleanup` đã đăng ký.

## Việc tiếp theo

1. Admin tối thiểu: đăng nhập Admin (phần còn lại của IAM-006) + phần duyệt hồ sơ của ADM-001 (`approve` tạo Operator + Owner, `request-info`, `reject`) — khép vòng đăng ký → duyệt → Owner đăng nhập.
2. OPR-001b: màn Hồ sơ & KYC sau khi duyệt (Figma `1667:27240`, `1667:27586`).
