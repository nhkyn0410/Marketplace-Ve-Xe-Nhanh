# TASK-ADM-003 — Todo: Nội dung công khai (banner, câu hỏi thường gặp, trang tĩnh)

> **Khanh (17/10/2026):** "Tiếp tục nốt phần không cần đặt vé" — phần banner / FAQ / trang tĩnh của `TASK-ADM-003` (phần ảnh phương tiện đã làm 16/10 — `ADM-003-vehicle-images-todo.md`; phần đánh giá / báo cáo vi phạm chờ `TASK-TRUST-001`).
> Nguồn: SRS FR-ADM-13 ("kiểm duyệt … banner, FAQ và nội dung tĩnh công khai"), UC-28; DOMAIN-MAP: `ContentPage` (static pages) ở `catalog/`; DB §4.1 nhóm Catalog có `content_pages` (chưa có cột). Figma: **ADM-10d "Kiểm duyệt / Nội dung công khai"** (`1675:37415`) — chỉ có màn danh sách; **trang soạn chưa có khung** (dựng theo trang soạn bài viết ADM-13b). Schema / API **AI tự thiết kế, chờ Khanh duyệt**.
> **Nhánh:** `TASK-TRN-007` (làm tiếp sau EMP-001), chưa commit. Không làm giao diện khách hàng (Marketplace / app) — chỉ có API công khai để dùng sau.

## Trạng thái (17/10/2026) — 🔨 **Code xong, chưa commit — chờ Khanh duyệt + review**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).

## Đã làm

- **DB** (migration `20261017030000_content_pages`): bảng `content_pages` cấp Platform (không `operator_id`): `type` (`FAQ` / `BANNER` / `PAGE`), `placement` (`HOME` / `FOOTER` / `BOOKING` / `TICKET` / `ACCOUNT`), tiêu đề ≤ 160, `slug` (chỉ trang tĩnh, unique), `body_markdown`, `image_key` + `link_url` (chỉ banner), `display_order`, `status` (`DRAFT` / `PUBLISHED`) + `published_at`. CHECK: vị trí theo loại, đường dẫn ↔ trang tĩnh, ảnh ↔ banner, liên kết chỉ banner, `published_at` ↔ đang hiển thị. RLS: ai cũng đọc, chỉ scope platform / system ghi (mẫu `articles`).
- **API Admin** (`catalog/`, quyền `content:moderate` — chỉ PlatformAdmin): `GET /admin/content-pages` (lọc loại / tình trạng / tiêu đề, mới sửa trước, `total`), `GET /{id}`, `POST`, `PUT /{id}` (không đổi loại → 422), `PUT /{id}/status` (hiển thị / ẩn — khoá dòng, lặp → 409), `POST /image-upload-url` (ảnh banner ở kho công khai, khóa `content-pages/{uuid}.{ext}`, kiểm object + chữ ký định dạng khi lưu như ảnh bài viết). Audit `content_page.create / update / publish / unpublish` **trong transaction** (lỗi → 503, không lưu).
- **API công khai** (không đăng nhập): `GET /content-pages?type&placement` (chỉ mục đang hiển thị, theo thứ tự), `GET /content-pages/{slug}` (trang tĩnh đang hiển thị; nháp → 404).
- **Admin**: mở tab **"Nội dung công khai"** trong màn Kiểm duyệt theo Figma ADM-10d (tab nằm trên URL `?tab=public-content`; nút "Thêm nội dung"; lọc Loại / Tình trạng / Tìm tiêu đề; cột Tiêu đề · Loại · Vị trí hiển thị · Cập nhật · Tình trạng; bút = sửa, mắt = xem trước; "Đã tải x / y nội dung"). Trang `/moderation/content/new`, `/moderation/content/{id}`: loại, vị trí (lọc theo loại), tiêu đề / câu hỏi, đường dẫn tự sinh (trang tĩnh), ảnh banner (nén ở trình duyệt rồi tải lên) + liên kết, nội dung Markdown + khung xem trước (không render HTML thô), thứ tự hiển thị; Lưu nháp / Lưu thay đổi, Hiển thị / Ẩn.

## Chờ Khanh (G1–G8)

| #  | Điểm | Đã làm theo | Cần Khanh |
| -- | ---- | ----------- | --------- |
| G1 | Module | `catalog/` theo DOMAIN-MAP (`ContentPage` ở `catalog/`), dùng chung kiểm ảnh với bài viết | Duyệt |
| G2 | Quyền | `content:moderate` (cùng tab Kiểm duyệt với ảnh phương tiện) | Hay dùng `content:manage` như bài viết |
| G3 | Vị trí hiển thị | Banner → Trang chủ; trang tĩnh → Chân trang; FAQ → 3 nhóm "Đặt vé và thanh toán", "Đổi, hủy và hoàn vé", "Tài khoản" | Duyệt / thêm nhóm |
| G4 | Banner | Một ảnh + tiêu đề + dòng phụ + liên kết (đường dẫn nội bộ `/…` hoặc `https://`); không có khung thời gian hiển thị | Có cần lịch hiển thị (từ ngày – đến ngày) |
| G5 | Trạng thái | Chỉ Bản nháp / Đang hiển thị (Figma); không có lưu trữ / xoá | Có cần xoá nội dung |
| G6 | Ảnh banner bỏ đi | Chưa dọn object mồ côi (như ảnh bài viết) | Có cần job dọn |
| G7 | Trang soạn | Chưa có Figma — dựng theo trang soạn bài viết ADM-13b | Vẽ khung nếu muốn chỉnh |
| G8 | Hiển thị ở Marketplace / app | Chưa làm (không đụng giao diện khách hàng); có API công khai | Làm cùng Marketplace / `passenger_mobile` |

## Kiểm tra (17/10/2026)

- `content-page.int.spec.ts` 5 ca trên Postgres thật, role app + kho ổ đĩa thật: validate theo loại (vị trí sai loại, trang tĩnh thiếu / sai đường dẫn, banner thiếu ảnh, liên kết ngoài banner / `//` / `javascript:`, nội dung rỗng); tạo nháp + sửa ghi audit trong transaction, trùng đường dẫn 409, đổi loại 422, ảnh khóa lạ / chưa tải 422; hiển thị / ẩn (lặp 409), API công khai chỉ trả mục đang hiển thị theo thứ tự, trang tĩnh nháp 404; danh sách Admin lọc / tổng / phân trang / con trỏ hỏng; audit lỗi → 503 không lưu, tenant không ghi được (RLS), CHECK vị trí theo loại.
- `content-page.http.spec.ts` 15 ca (guard thật 6 route Admin: không token 401, chủ nhà xe / hỗ trợ nền tảng 403, quản trị viên được; ngữ cảnh platform; API công khai không cần đăng nhập; 6 ca dữ liệu sai → 400). Toàn bộ `src/catalog` 101 ca đạt.
- Unit Admin `lib/content/content-page-format.test.ts` 4 ca. E2E `moderation-audit.e2e.ts` thêm 2 ca (FAQ: thiếu ô báo tại ô → lưu nháp → hiển thị → API công khai trả về → danh sách + xem trước; banner bắt buộc ảnh + chặn liên kết `//`, tải ảnh thật; trang tĩnh tự sinh đường dẫn, hiển thị ngay, trùng đường dẫn báo tại ô) — cả file 4 ca đạt.
- Sửa lỗi phát hiện khi chạy E2E: đổi loại làm ô "Vị trí hiển thị" (Radix Select) báo giá trị rỗng → gửi `placement: ""` → 400; nay bỏ qua giá trị rỗng.
- Ảnh chụp 1440 px khớp Figma ADM-10d; 390 px không tràn ngang.
