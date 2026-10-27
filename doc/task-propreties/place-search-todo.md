# Tìm chuyến theo phường / xã + gợi ý địa điểm (kể cả tên hành chính cũ) — Todo

> **Nguồn:** Khanh 27/10/2026 — "web và mobile đều tìm theo tỉnh/thành và các địa điểm gợi ý, vậy nếu người dùng nhập phường/xã thì sao hoặc địa chỉ hành chính cũ. Tôi có mapping với dữ liệu hành chính cũ." Khanh chọn: **gợi ý chung + tìm theo phường** (chưa làm địa chỉ tự do / geocoding); dùng file ánh xạ đầy đủ Khanh tải về.
> **Task:** `TASK-TRN-004` (tìm chuyến) + `TASK-CAT-001` (danh mục hành chính).
> **Nhánh:** `feat/place-search` (từ `feat/operator-public-page`), chưa commit.

## Trạng thái (27/10/2026) — 🔨 Code xong, chưa commit — chờ Khanh duyệt

- Chưa qua `code-reviewer` / `security-auditor` (`CLAUDE.md` §4.8).
- Test: API tích hợp trên Postgres thật bằng role app (DB tạm, đã xóa); thử `/catalog/places` trên danh mục thật (≈ 10 ms / lần); web: unit test + chạy thật bằng Playwright (gõ tên cũ → chọn → tìm). App Flutter chưa nối (client Dart đã sinh lại).

## Đã làm

- **Dữ liệu:** `seed-data/legacy-administrative-mappings.csv` từ 239 → **10.262 dòng** (10.035 phường / xã cũ, 164 huyện, 63 tỉnh) từ file Khanh cung cấp (UTF-8). Mọi mã phường mới đều có trong danh mục.
- **API:** `GET /catalog/places?q=&limit=` (tỉnh, phường mới, địa danh, tên cũ → đơn vị mới); `/trips/search` thêm `fromWardId` / `toWardId` + `widenedToProvince`.
- **Web:** ô "Điểm đi / Điểm đến" ở trang chủ và trang kết quả thành ô gõ có gợi ý (nhãn "Tên cũ"); URL mang `originType` / `destinationType` + tên; link cũ chỉ có id tỉnh vẫn chạy; báo khi đã nới ra cả tỉnh.

## Chờ Khanh duyệt (tự thiết kế)

| # | Quyết định | Ghi chú |
| - | ---------- | ------- |
| P1 | Phường cũ bị tách (471 phường) → phường mới đại diện = dòng "Tách — nhập chủ yếu"; phần tách khác ghi ở `notes` | Bảng chỉ lưu một phường đại diện / tên cũ |
| P2 | 2 dòng soạn tay trước đây đổi theo file chính thức: Phường Giáp Bát → **Phường Tương Mai** (trước: Hoàng Mai, chỗ có bến xe); Phường Hòa Minh → **Phường Hòa Khánh** (trước: Liên Chiểu) | Bến xe vẫn tìm được qua địa danh. **DB đã có 239 dòng cũ không bị ghi đè** (seed chỉ thêm mới) → 2 dòng này giữ giá trị cũ tới khi sửa tay |
| P3 | Tìm theo phường = điểm đón / trả nằm trong phường; không có chuyến → tự nới ra cả tỉnh, báo cho người dùng | Phường không có tọa độ nên không tìm theo bán kính |
| P4 | Tên cũ cấp huyện / tỉnh dẫn tới **tỉnh mới** (không dẫn tới phường đại diện) | Một huyện cũ trải nhiều phường mới |
| P5 | Gợi ý tên cũ chỉ so với tên cấp nhỏ nhất của dòng; bỏ tên cũ trùng hệt tên mới; không gợi ý trạm dừng nghỉ | Tránh gõ "hà nội" ra hàng trăm phường cũ |
| P6 | Xếp gợi ý: khớp đầu tên → đầu một từ → giữa; cùng hạng thì khớp đúng dấu như người dùng gõ lên trước | "cờ đỏ" → Xã Cờ Đỏ trước Xã Cổ Đô |
| P7 | Trang chủ thôi tải sẵn danh sách tỉnh (ô gợi ý tự gọi API) | — |

## Còn lại / ngoài phạm vi

- **Production:** chạy lại `db:seed:catalog` (RB-08) để thêm ~10.000 dòng ánh xạ; nếu đồng ý P2 thì sửa tay 2 dòng trong DB.
- App hành khách (Flutter): dùng `/catalog/places` + `fromWardId` / `toWardId` cho màn tìm chuyến — nhánh `feat/passenger-mobile-ui` đang làm màn này.
- Địa chỉ tự do (số nhà, đường) qua Goong Geocoding → chưa làm (Khanh chưa chọn).
