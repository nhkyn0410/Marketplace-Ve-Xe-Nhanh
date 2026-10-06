# TASK-TRN-012 — Todo: Thiết kế lại điểm dừng (backend nhà xe)

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` §7.3 — điểm riêng chỉ nhận `OFFICE` / `REST_STOP`; trạng thái `SUSPENDED` + lý do, nhà xe không tự gỡ; đề xuất chỉ `BUS_STATION` / `PICKUP_POINT` + `legalBasis`; `route_stops` thêm cho đón / cho trả; list điểm thêm lọc, tìm `q`, `routeCount`; `/catalog/stop-points` thêm `q`; sinh lại client TS + Dart. Nguồn chi tiết: SRS `BR-38`, `BR-79`, `BR-81`; LLD §6.13; DB §5.2, §7; API §7.3, §7.6; Test `TC-TRN-015`, `TC-TRN-016`, `TC-TRN-018` (phần nhà xe).
> **Dependency:** `TASK-TRN-002` — đã merge `develop`.
> **Mở khóa:** `TASK-TRN-013` (màn Điểm dừng + form tuyến Operator OS), `TASK-ADM-004` (Admin quản lý điểm dừng), port `TASK-TRN-003` / `TASK-TRN-006`.
> **Cách dùng:** lệnh kiểm chứng ở `TRN-012-guide.md`; nghiệm thu ở `TRN-012-verification-checklist.md`.

## Trạng thái (05/10/2026) — 🔨 **ĐANG TRIỂN KHAI**

- ✅ Nhánh `TASK-TRN-012` tạo từ `develop` (`c803867`) ngày 05/10/2026.
- ✅ Khanh chốt 05/10/2026 ba điểm còn mở: (1) dữ liệu thử sai loại thì **xóa**, không chuyển đổi; (2) ô tìm `q` **gõ không dấu cũng tìm được**; (3) cột "số tuyến đang dùng" **chỉ có ở tab Của nhà xe**.
- ✅ Code, test, migration và hai client đã xong; số đo ở checklist. ⏳ Chờ Khanh review diff (chưa commit) → CI → Done.

---

## Phạm vi

### Thuộc TRN-012

- Điểm riêng (`/operator/stop-points`) chỉ nhận `OFFICE`, `REST_STOP` — chặn ở service (422) và CHECK ở database (`BR-38`).
- Trạng thái `SUSPENDED` + `suspensionReason`: nhà xe không tự đặt, không sửa, không mở lại được điểm đang bị khóa — chặn ở API (400 / 409) và RLS (`BR-81`).
- Đề xuất (`/operator/stop-point-proposals`) chỉ nhận `BUS_STATION`, `PICKUP_POINT` và bắt buộc `legalBasis`.
- Route: mỗi điểm thêm `allowPickup`, `allowDropoff` và quy tắc theo vị trí + loại điểm (`BR-79`); response trả thêm `type` của từng điểm.
- List điểm riêng: lọc `status`, `type`, `provinceId`, tìm `q`, trả `routeCount`.
- `/catalog/stop-points` thêm `q`.
- Migration dọn dữ liệu thử sai loại; sinh lại client TS + Dart.

### Không tự kéo vào task

- Admin khóa / mở khóa điểm riêng, quản lý điểm dùng chung, duyệt đề xuất → `TASK-ADM-004`. Task này chỉ dựng phần database + RLS để nhà xe không vượt được.
- Ràng buộc của bảng `stop_points_catalog` (CHECK loại, cột `legal_basis`) → `TASK-ADM-004`. Task này chỉ thêm cột tìm kiếm cho bảng đó.
- `trip_stops.allow_pickup` / `allow_dropoff` và lý do "điểm dừng bị khóa" khi mở bán chuyến → khi port `TASK-TRN-003` / `TASK-TRN-006` (hai bảng chuyến chưa có ở repo chính).
- Tìm chuyến theo vị trí (`provinceId` / `stopPointId`) → `TASK-TRN-004`.
- Màn hình Operator OS → `TASK-TRN-013`; bản đồ chọn tọa độ → `TASK-TRN-014`.

---

## Giả định hiện thực (AI đặt — Khanh phản đối thì sửa)

- **A1 — Phạm vi xóa của migration:** xóa (a) điểm riêng loại bến xe / điểm dừng đón trả, (b) mọi tuyến đang dùng các điểm đó, (c) tuyến bắt đầu hoặc kết thúc ở trạm dừng nghỉ (vi phạm `BR-79`), (d) đề xuất loại văn phòng / trạm dừng nghỉ. Mục (c) không nằm trong câu hỏi đã hỏi Khanh nhưng không xóa thì ràng buộc mới không thêm được. Nếu đã có bảng khác trỏ tới tuyến bị xóa thì migration dừng, không xóa dở.
- **A2 — Đề xuất đúng loại gửi trước đây được giữ:** cột căn cứ công bố điền `Chưa khai (đề xuất gửi trước khi bắt buộc căn cứ công bố)` để Admin thấy khi duyệt.
- **A3 — Lý do khóa có khi và chỉ khi điểm đang `SUSPENDED`** (tối đa 500 ký tự): mở khóa thì phải xóa lý do. DB doc trước đó chỉ ghi chiều "bị khóa thì phải có lý do".
- **A4 — Nhà xe không xóa cứng được điểm riêng ở tầng database:** quyền DELETE trên `stop_points` chỉ còn scope `platform` / `system`. API vốn không có endpoint xóa.
- **A5 — Loại điểm sai trả 422 có mã riêng, không phải 400:** biên nhận đủ 4 loại, service trả `STOP_POINT_TYPE_NOT_ALLOWED` (đúng API §7.3). Trạng thái `SUSPENDED` trong body thì là 400 vì đó không phải giá trị nhà xe được gửi.
- **A6 — Sửa điểm đang bị khóa luôn trả 409 `STOP_POINT_SUSPENDED`**, kể cả khi body không đổi gì.
- **A7 — Điểm bị khóa không gắn mới được vào tuyến** (422 `STOP_POINT_UNAVAILABLE`, như điểm ngừng dùng); tuyến đã có điểm đó vẫn giữ và vẫn sửa được phần khác.
- **A8 — Tìm `q`:** khớp một phần tên hoặc địa chỉ, không phân biệt dấu và hoa / thường, tối đa 100 ký tự, không xếp hạng kết quả. Database tự sinh cột `search_text` (tên + địa chỉ đã bỏ dấu) và cũng chính database chuẩn hoá từ khoá, nên hai phía không lệch nhau; `%` và `_` trong từ khoá được coi là chữ thường. Chưa có chỉ mục cho kiểu tìm này — đủ cho quy mô v1.
- **A9 — `routeCount`** = số tuyến của nhà xe đang có điểm đó, tính cả tuyến ngừng dùng; tính lúc đọc, không lưu cột.
- **A10 — Hai cờ cho đón / cho trả bắt buộc trong body tuyến:** thiếu là 400, không tự điền mặc định.
- **A11 — Tên ràng buộc / policy theo kiểu của code hiện có:** `stop_points_private_type`, `stop_points_suspension_consistent`, `stop_point_proposals_shared_type`, `stop_point_proposals_legal_basis_present`, `route_stops_pickup_dropoff_by_role`; policy `tenant_read`, `tenant_insert_not_suspended`, `tenant_update_not_suspended`, `platform_delete`.

## Contract thay đổi

| Endpoint | Thay đổi |
| --- | --- |
| `GET /operator/stop-points` | thêm query `type`, `provinceId`, `q`; `status` nhận thêm `SUSPENDED`; mỗi item thêm `suspensionReason`, `routeCount` |
| `POST` / `PUT /operator/stop-points[/{id}]` | `type` ngoài `OFFICE` / `REST_STOP` → 422 `STOP_POINT_TYPE_NOT_ALLOWED`; `status = SUSPENDED` → 400; sửa điểm đang bị khóa → 409 `STOP_POINT_SUSPENDED`; response thêm `suspensionReason`, `routeCount` |
| `POST` / `PUT /operator/stop-point-proposals[/{id}]` | `type` chỉ `BUS_STATION` / `PICKUP_POINT`; thêm `legalBasis` bắt buộc (1–300 ký tự); response trả lại `legalBasis` |
| `POST` / `PUT /operator/routes[/{id}]` | mỗi điểm thêm `allowPickup`, `allowDropoff` (bắt buộc); sai quy tắc → 422 `ROUTE_STOP_PICKUP_DROPOFF_INVALID`; response mỗi điểm thêm `type`, `allowPickup`, `allowDropoff` |
| `GET /catalog/stop-points` | thêm query `q` |

Ba mã lỗi mới: `STOP_POINT_TYPE_NOT_ALLOWED` (422), `STOP_POINT_SUSPENDED` (409), `ROUTE_STOP_PICKUP_DROPOFF_INVALID` (422). Không đổi quyền: vẫn `route:manage` (Owner) trong tenant; catalog vẫn công khai.

**Thay đổi phá vỡ tương thích:** client cũ gửi tuyến không có hai cờ, hoặc gửi đề xuất không có `legalBasis`, sẽ nhận 400. Chưa có màn hình nào gọi các API này nên không ảnh hưởng người dùng.
