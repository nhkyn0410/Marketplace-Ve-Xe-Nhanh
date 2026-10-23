# TASK-TRN-004 — Todo: Tìm chuyến + chi tiết chuyến công khai

> **Khanh (17/10/2026):** dựng lõi đặt vé theo lát dọc — bước 1 là tìm chuyến / chi tiết chuyến công khai (TRN-004); quy tắc theo SRS/ADR; **không đụng giao diện khách hàng** (giao diện web hành khách đang dựng riêng ở worktree `Ve_Xe_Nhanh_MKT`, nối API sau).
> Nguồn: SRS FR-MKT-01..05, FR-MKT-15, BR-22, BR-77, BR-80; LLD §6.13 bước 7; 05 API §7.2. Chi tiết AI tự quyết, **chờ Khanh duyệt**.
> **Nhánh:** `TASK-TRN-004` (từ `TASK-TRN-007`), chưa commit.

## Trạng thái (17/10/2026) — 🔨 **Backend xong, chưa commit — chờ Khanh duyệt + review**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8). Không có màn hình (phía khách hàng).

## Đã làm

- Module `marketplace/` (DOMAIN-MAP lớp Marketplace), không cần đăng nhập:
  - `GET /trips/search?fromProvinceId|fromStopPointId&toProvinceId|toStopPointId&date&passengers&operatorId&vehicleForm&vehicleClass&departureFrom&departureTo&priceMin&priceMax&amenityIds&sort=departure|price|duration&page&limit` → `{ items, total, page, limit, facets: { operators, priceMin, priceMax } }`. Mỗi chuyến: nhà xe, tuyến, loại xe (dạng chỗ + hạng), điểm đón / trả khớp (kèm `sequence`), thời gian di chuyển, số chỗ trống, giá thấp nhất, ảnh đại diện xe, tiện ích, mốc ngừng bán online.
  - `GET /trips/{tripId}` → nhà xe (hotline), lịch trình đủ điểm (loại điểm, tọa độ, cho đón / trả), xe + tiện ích + bộ ảnh, sơ đồ chỗ có giá + `AVAILABLE` / `UNAVAILABLE`, mốc hủy / hoàn đang áp dụng (phiên bản riêng của nhà xe, nếu không có thì mặc định).
- Truy vấn đọc mọi nhà xe ở `database/public-trips.ts` (ngữ cảnh `system`, chỉ đọc, như `article-views.ts`), luôn lọc: chuyến `OPEN_FOR_SALE`, nhà xe `ACTIVE`, chưa qua giờ ngừng bán online (AS-20), còn đủ chỗ cho số khách, có giá. Khớp vị trí (BR-80): theo tỉnh, hoặc trong **5 km** quanh địa danh (haversine trên tọa độ đã lưu, không gọi Goong); điểm đón khớp đầu tiên có giờ đón trong ngày (giờ VN) đứng trước điểm trả khớp đầu tiên; trạm dừng nghỉ không khớp.
- Giá thấp nhất tính bằng đúng hàm giá của chuyến (`resolveSeatPrice`). Kết quả theo (điểm đi, điểm đến, ngày, số khách) **cache Redis 60 giây** (ADR-015); Redis lỗi thì tính lại, không chặn.

## Chờ Khanh (G1–G8)

| #  | Điểm | Đã làm theo | Cần Khanh |
| -- | ---- | ----------- | --------- |
| G1 | Chỗ đang giữ | Số chỗ trống ở danh sách chưa trừ chỗ đang được giữ (giữ chỗ ở Redis); chi tiết chuyến sẽ đánh dấu chỗ đang giữ khi có BTP-001 | Duyệt |
| G2 | Bán kính địa danh | 5 km cố định (BR-80 "Admin cấu hình") | Có cần ô cấu hình ở Admin |
| G3 | Điểm đón / trả khớp | Điểm đón khớp đầu tiên + điểm trả khớp đầu tiên sau nó; khách đổi điểm khác ở bước chọn chỗ | Duyệt |
| G4 | Đánh giá | Chưa lọc / sắp theo đánh giá (chờ TRUST-001) | — |
| G5 | Trần kết quả | Tối đa 300 chuyến khớp mỗi truy vấn trước khi lọc | Duyệt |
| G6 | Cache | 60 giây theo (điểm đi, điểm đến, ngày, số khách); lọc / sắp / trang làm trên kết quả cache | Duyệt |
| G7 | Sơ đồ chỗ | Trả trong `GET /trips/{tripId}` (05 API); giao diện web đang gọi `GET /trips/{tripId}/seats` riêng | Thống nhất một cách khi nối giao diện |
| G8 | Chuyến tạm dừng bán | `LOCKED` / nháp / hủy → 404 công khai | Duyệt |

## Kiểm tra (17/10/2026)

- `trip-search.int.spec.ts` 5 ca trên Postgres thật, role app: theo tỉnh (đúng 4 chuyến; bỏ nháp / ngày khác / nhà xe tạm khóa / chiều ngược; điểm đón trả, thời gian, chỗ trống trừ chỗ khóa, giá thấp nhất theo loại chỗ còn trống, facet); theo địa danh (văn phòng riêng cách ~1 km khớp, bến cách ~20 km không); số khách, lọc dạng chỗ / hạng / giờ / giá / tiện ích, sắp theo giá, phân trang; quá giờ ngừng bán không hiện, bảng giá ngừng thì chuyến không hiện, cache 60 giây; chi tiết (lịch trình, chỗ khóa `UNAVAILABLE`, giá từng chỗ, nháp / nhà xe tạm khóa / id lạ → 404).
- `public-trip.http.spec.ts` 9 ca (không cần đăng nhập, giá trị mặc định, 7 ca query sai → 400, id không phải uuid → 400).
