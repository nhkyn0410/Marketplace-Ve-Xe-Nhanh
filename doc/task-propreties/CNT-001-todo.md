# TASK-CNT-001 — Todo: Bài viết (phần Admin + API công khai)

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` — `TASK-CNT-001` "Bài viết tin tức / cẩm nang". Nguồn chi tiết: SRS `FR-MKT-14`, `FR-ADM-18..19`, `UC-38`, `UC-40`, `BR-74`; ADR-018 (ảnh ở kho public); Figma section `Giao diện Admin` (`1663:23890`): `ADM-13a` Danh sách (`1676:39013`), `ADM-13b` Soạn bài Markdown + xem trước (`1676:39393`), `ADM-13c` Chuyên mục (`1676:39698`).
> **Khanh (16/10/2026):** "Hiện còn những gì chưa hoàn thiện của phần admin và op thì làm giúp tôi" → chọn làm Bài viết; phần dữ liệu chưa có thiết kế: "Tự thiết kế + code" (ghi vào tài liệu, đánh dấu chờ duyệt).
> **Nhánh:** làm tiếp trên `TASK-ADM-004`, chưa commit.

## Trạng thái (16/10/2026) — 🔨 **Code xong phần Admin + API công khai, chưa commit — chờ Khanh review + CI**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).
- **Chưa làm:** trang Khám phá / chi tiết bài ở Marketplace và `passenger_mobile` (hai app chưa dựng — để khi làm `TASK-MKT-*` / app hành khách).

## Đã làm

### DB — migration `20261016010000_add_articles` (tự thiết kế, chờ duyệt — G1)

- Enum `ArticleStatus` (`DRAFT`, `PUBLISHED`, `ARCHIVED`).
- `article_categories`: `name`, `slug` (unique, CHECK chữ thường-số-gạch), `display_order`, `status` (`CatalogStatus`), thời điểm tạo / sửa. Seed 5 chuyên mục: Tin tức, Cẩm nang, Khuyến mãi, Mẹo du lịch, VXN.
- `articles`: `category_id`, `title`, `slug` (unique), `summary`, `content_markdown` (Markdown thô), `cover_image_key`, `featured` (nổi bật), `status`, `published_at` (CHECK: `PUBLISHED` ⇒ có `published_at`), `view_count`, `created_by` / `updated_by`, thời điểm tạo / sửa.
- RLS: mọi người đọc (`public_read`), chỉ scope platform ghi; `article-views.ts` (thư mục `database/`, ngữ cảnh system) cộng lượt xem.

### Backend (`apps/api/src/content/`)

- Quyền mới `content:manage` (PLATFORM_ADMIN, phạm vi `any`).
- Admin: `GET/POST /admin/articles`, `GET/PUT /admin/articles/{id}`, `POST /admin/articles/{id}/publish` (ngay hoặc hẹn giờ qua `publishedAt`), `POST /admin/articles/{id}/archive` (gỡ), `POST /admin/articles/images` (URL tải ảnh lên kho public, khóa `articles/{uuid}.{ext}`); `GET/POST/PUT /admin/article-categories`. Ghi + audit trong một transaction (`article.create/update/publish/archive`, `article_category.*`); audit lỗi → 503. Hai lần xuất bản cùng lúc → một lần 409.
- Công khai (không cần đăng nhập): `GET /article-categories`, `GET /articles` (chỉ `PUBLISHED` và `published_at ≤ now`, lọc chuyên mục / nổi bật, tìm tiêu đề + tóm tắt, cursor), `GET /articles/{slug}`, `POST /articles/{slug}/views` (204; mỗi IP một lượt / bài / 30 phút qua Redis `SET NX EX`).

### Admin (`apps/admin`) — theo Figma ADM-13a / 13b / 13c

- `/articles`: danh sách lọc trạng thái / chuyên mục, tìm; tab Chuyên mục (thêm, sửa, ngừng dùng có xác nhận, dùng lại).
- `/articles/new`, `/articles/{id}`: soạn Markdown + xem trước (`react-markdown`, không render HTML thô), slug tự sinh từ tiêu đề, ảnh bìa (nén ở trình duyệt trước khi tải), lưu nháp / xuất bản / hẹn giờ / gỡ.

## Chờ Khanh (G1–G8)

| #  | Điểm | Đã làm theo | Cần Khanh |
| -- | ---- | ----------- | --------- |
| G1 | Schema `articles` / `article_categories` | Tự thiết kế như trên (DB §5 chưa có bảng) | Duyệt |
| G2 | Quyền | Thêm `content:manage` (PLATFORM_ADMIN); PLATFORM_SUPPORT không soạn bài | Duyệt / có cho Hỗ trợ nền tảng soạn không |
| G3 | Hẹn giờ xuất bản | `PUBLISHED` + `published_at` ở tương lai = hẹn giờ; trang công khai lọc `published_at ≤ now` (không cần job) | Duyệt |
| G4 | Nội dung rỗng | Không xuất bản được bài chưa có nội dung (422 `ARTICLE_INCOMPLETE`) | Duyệt |
| G5 | Markdown | Lưu Markdown thô, khi hiển thị không cho HTML nhúng; ảnh trong bài được dùng URL ngoài | Có chặn ảnh ngoài (chỉ ảnh tải lên kho) không |
| G6 | Ảnh mồ côi | Chưa có job dọn ảnh bài viết tải lên mà không dùng / bị thay | Có cần job dọn như ảnh xe |
| G7 | ISR | Marketplace chưa dựng nên chưa gọi revalidate khi xuất bản / gỡ | Làm khi dựng Marketplace |
| G8 | Lượt xem | Đếm theo IP / 30 phút, không loại bot | Duyệt |

## Kiểm tra (16/10/2026)

- `article.int.spec.ts` 7 ca trên Postgres + kho local thật (RLS tenant không ghi được; chuyên mục trùng slug / ngừng dùng; vòng đời nháp → xuất bản → hẹn giờ → gỡ → xuất bản lại, sai trạng thái 409, rỗng 422; xuất bản đồng thời; ảnh bìa khóa lạ / chưa tải 422; lượt xem; audit lỗi 503). `article.http.spec.ts` 12 ca (guard thật, validate).
- E2E `articles.e2e.ts` 3 ca (chuyên mục; bài mới → xem trước → ảnh bìa → nháp → xuất bản → API công khai thấy → gỡ; trùng slug báo tại ô).

## Việc tiếp theo

1. Khanh review, chốt G1–G8.
2. Trang Khám phá / chi tiết bài khi dựng Marketplace và app hành khách.
