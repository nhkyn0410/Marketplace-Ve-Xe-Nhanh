# Logo nhà xe + trang công khai trên Operator OS — Todo

> **Nguồn:** Khanh 27/10/2026 — "Tại operator.vexenhanh.id.vn/profile chưa có phần để đi đến trang hiển thị thông tin nhà xe dù đã có web khách hàng … thêm cả api để hiển thị cả avt nhà xe và cả phần preview trên ứng dụng di động". Khanh chọn: preview = **xem trước trong Operator OS** (không sửa app Flutter); logo hiện ở **trang nhà xe trên web** + **Nhà xe đối tác ở trang chủ** (chưa đưa vào kết quả tìm chuyến).
> **Task:** `TASK-OPR-001` (hồ sơ sau duyệt — FR-OPR-02 có logo) + `TASK-MKT-001` (trang nhà xe công khai). SRS đã có logo ở FR-OPR-02 và UC-03 bước 6; DB / API trước đây chưa có ("Không trả logo (schema chưa có)").
> **Nhánh:** `feat/operator-public-page` (từ `develop` 6481b4e), chưa commit.

## Trạng thái (27/10/2026) — 🔨 Code xong, chưa commit — chờ Khanh duyệt

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).
- Test: API unit + tích hợp trên Postgres thật bằng role app (DB tạm, đã xóa sau khi chạy), E2E `profile.e2e.ts` 5/5 trên trình duyệt thật. Web khách hàng chỉ có unit test + typecheck (chưa có E2E cho trang nhà xe).

## Đã làm

### DB + API

- Migration `20261027030000_operator_logo`: `operator_profiles.logo_object_key` (TEXT nullable, unique). Chỉ lưu khóa object; địa chỉ CDN do API ghép (`publicUrl`).
- `POST /operator/profile/logo/upload-url` → URL tải thẳng lên kho **công khai**, khóa `operator-logos/{operatorId}/{uuid}.{ext}`; `PUT /operator/profile/logo` `{ objectKey }` kiểm object (tiền tố, < 23 giờ, ≤ 2 MB, loại, chữ ký ảnh) → 422 `OPERATOR_LOGO_INVALID`; `DELETE /operator/profile/logo`. Quyền `kyc:submit` (chỉ chủ nhà xe), audit `operator.logo.update` / `operator.logo.remove` trong transaction, khóa dòng khi đổi / gỡ, object cũ xóa sau commit.
- `logoUrl` ở `GET /operator/profile`, `GET /operators/{id}/public-profile`, `GET /catalog/featured-operators`. Client TS + Dart sinh lại.

### Giao diện

- Operator OS `/profile`: thẻ Hồ sơ doanh nghiệp — Tải logo / Đổi logo / Gỡ logo (hộp xác nhận); thẻ Trang công khai — "Mở trang nhà xe" (tab mới tới `{NEXT_PUBLIC_MARKETPLACE_URL}/operators/{id}`), "Xem trước trên ứng dụng" (khung điện thoại mô phỏng màn nhà xe của app hành khách, dữ liệu `public-profile`).
- Web khách hàng: đầu trang `/operators/[id]` và thẻ Nhà xe đối tác ở trang chủ hiện logo; chưa có logo → chữ viết tắt như cũ.

## Chờ Khanh duyệt (tự thiết kế)

| # | Quyết định | Lý do / phương án khác |
| - | ---------- | ---------------------- |
| L1 | Logo chỉ nhận JPEG / PNG / WebP (không SVG), tối đa 2 MB | SVG chứa được script; logo hiện nhỏ nên 2 MB là dư (ảnh xe 5 MB) |
| L2 | Operator OS thu nhỏ logo còn cạnh dài 512 px, xuất PNG trước khi tải | Giữ nền trong suốt, bỏ EXIF; khác ảnh xe (1600 px, JPEG) |
| L3 | Hiện logo `object-contain` trên nền trắng, không cắt ảnh | Logo không vuông vẫn hiện đủ; chưa có bước cắt ảnh |
| L4 | Đổi / gỡ logo chỉ chủ nhà xe (`kyc:submit`), không cần xác nhận lại danh tính | Cùng mức với sửa thông tin công khai; tài khoản quản lý không có quyền này |
| L5 | Chưa có job dọn logo mồ côi (tải lên rồi bỏ dở / xóa sau commit thất bại) | Giống ảnh bài viết; ảnh xe và giấy tờ có job — thêm khi cần |
| L6 | Admin chưa gỡ được logo vi phạm (ảnh xe thì có, FR-ADM-20) | SRS chưa yêu cầu cho logo — cần thì thêm vào màn Kiểm duyệt |
| L7 | Khung "Xem trước trên ứng dụng" tự dựng, chưa có frame Figma; các khối bám trang nhà xe trên web (SCR-PSG-17) | App hành khách chưa có màn nhà xe; khi làm màn thật nên đối chiếu lại |
| L8 | "Mở trang nhà xe" dùng biến `NEXT_PUBLIC_MARKETPLACE_URL` của Operator OS; build production thiếu biến → nút tắt | Tránh link trỏ nhầm `localhost` |
| L9 | Nhà xe tạm khóa → tắt cả hai nút (trang công khai trả 404 với hành khách) | — |

## Còn lại / ngoài phạm vi

- **Khanh đặt `NEXT_PUBLIC_MARKETPLACE_URL`** (địa chỉ web khách hàng, không có `/` cuối) ở nơi deploy Operator OS (Vercel) rồi build lại — không có thì nút "Mở trang nhà xe" trên production bị tắt.
- **Production:** chạy `prisma migrate deploy` (RB-02) để có cột `logo_object_key` trước khi deploy API mới.
- Logo trong kết quả tìm chuyến / chi tiết chuyến và app hành khách (Flutter) chưa làm — nhánh `feat/passenger-mobile-ui` đang sửa đúng phần đó.
- 3 test Dart (`loyalty_member_dto_output_next_tier_test.dart`, `loyalty_transaction_page_dto_output_items_inner_test.dart`, `policy_overview_dto_output_versions_inner_rules_any_of3_tiers_inner_test.dart`) lỗi sẵn trên `develop` vì trỏ tới model không còn — không do phần này.
