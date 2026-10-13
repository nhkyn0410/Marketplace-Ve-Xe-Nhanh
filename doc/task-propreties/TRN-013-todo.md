# TASK-TRN-013 — Todo: Màn Điểm dừng và màn Tuyến đường (Operator OS)

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` §7.3 — màn Điểm dừng (hai tab, hộp thoại thêm / sửa, đề xuất kèm căn cứ công bố) và màn Tuyến đường (danh sách, form có cho đón / cho trả). Nguồn chi tiết: SRS `FR-OPS-04..05`, `FR-OPS-17`, `BR-38`, `BR-79`, `BR-81`, `UC-13`; UI §7; API §7.3, §7.6.
> **Thiết kế:** Figma `Section 4` ([node 1305:6710](https://www.figma.com/design/6c81q3DdHVS0anfDw2sVVj/UI-UX?node-id=1305-6710)) — `Nhà xe · Điểm dừng · TRN-013` và `Nhà xe · Tuyến đường · TRN-013`.
> **Dependency:** `TASK-TRN-012` (API điểm dừng, đã merge), `TASK-IAM-006` (đăng nhập web).
> **Mở khóa:** `TASK-TRN-014` (bản đồ Goong), port `TASK-TRN-003` (chuyến) có màn để tạo tuyến thử.
> **Cách dùng:** lệnh kiểm chứng ở `TRN-013-guide.md`; nghiệm thu ở `TRN-013-verification-checklist.md`.

## Trạng thái (07/10/2026) — 🔨 **ĐANG TRIỂN KHAI**

- ✅ Nhánh `TASK-TRN-013` tạo từ `develop` (`02385d5`) ngày 07/10/2026.
- ✅ **Phần 1 — màn Điểm dừng:** code, test và E2E xong; số đo ở checklist.
- ✅ **Phần 2 — màn Tuyến đường** (kèm bổ sung API danh sách tuyến, client TS + Dart): code, test và E2E xong.
- ⏳ Chờ Khanh review diff (chưa commit) → CI → Done. Bản đồ thuộc `TASK-TRN-014`.

---

## Quyết định của Khanh (07/10/2026, khi duyệt thiết kế Figma)

1. Nút và hộp thoại gọi là **"Đề xuất điểm dừng"**; không nhắc việc nhà xe khác dùng được.
2. **Bản đồ thuộc V1**: bản đồ tổng quan đóng mở ở màn Điểm dừng, bản đồ chọn tọa độ trong hộp thoại, bản đồ lộ trình trong form tuyến — cả ba làm ở `TASK-TRN-014`.
3. **Form tuyến đầy đủ thông tin:** có bản đồ lộ trình và thẻ Tổng quan (số điểm cho đón / cho trả, lần cập nhật cuối).
4. **Danh sách tuyến có cột "Điểm đầu → Điểm cuối"** — API danh sách tuyến trả thêm tên hai điểm.
5. **Chọn điểm dừng cho tuyến mở ngay trong form** (không dùng hộp thoại che nền), để vẫn thấy danh sách điểm và bản đồ.

## Phạm vi

### Phần 1 — màn Điểm dừng (đã làm)

- Mục "Điểm dừng" trên thanh bên, đứng trước "Tuyến đường"; trang `/stop-points`.
- Tab **Của nhà xe**: bảng điểm riêng, ô tìm (gõ không dấu vẫn ra), lọc loại / tỉnh / trạng thái, số tuyến đang dùng, nút Sửa; điểm bị Platform khóa hiện lý do và không sửa được.
- Tab **Dùng chung**: danh mục Platform (chỉ xem, có ô tìm và lọc) + bảng đề xuất của nhà xe với trạng thái Chờ duyệt / Đã duyệt / Bị từ chối kèm lý do, nút "Sửa và gửi lại".
- Hộp thoại Thêm / Sửa điểm dừng và hộp thoại Đề xuất điểm dừng / Sửa và gửi lại.

### Phần 2 — màn Tuyến đường (đã làm)

- Trang `/routes`: danh sách tuyến có cột Điểm đầu → Điểm cuối, số điểm dừng, quãng đường, thời gian chạy, trạng thái.
- Trang `/routes/new` và `/routes/{id}`: form Thêm / Chỉnh sửa tuyến — điểm dừng theo thứ tự, công tắc cho đón / cho trả, ghi chú từng điểm, số liệu từng chặng, thẻ Thông tin tuyến và thẻ Tổng quan, cảnh báo hai đầu không phải bến xe.
- Bảng chọn điểm dừng mở ngay trong form (tab Dùng chung / Của nhà xe, ô tìm, lọc).
- Backend: `GET /operator/routes` trả thêm `originName`, `destinationName`; sinh lại client TS + Dart.

### Không tự kéo vào task

- Mọi bản đồ → `TASK-TRN-014`. Trước đó khối bản đồ không hiện, tọa độ nhập tay.
- Admin duyệt đề xuất, khóa / mở khóa điểm → `TASK-ADM-004`.
- Chuyến, bảng giá → `TASK-TRN-003`, `TASK-TRN-005`.

---

## Giả định hiện thực (AI đặt — Khanh phản đối thì sửa)

- **A1 — Tab nằm trên URL:** `/stop-points` là tab Của nhà xe, `/stop-points?tab=shared` là tab Dùng chung; tải lại trang vẫn đúng tab.
- **A2 — Chưa có bản đồ:** hộp thoại một cột, hai ô vĩ độ / kinh độ nhập tay và nhận cả dấu phẩy thập phân (`10,75`).
- **A3 — Ô tìm chờ 300 ms** sau khi ngừng gõ mới gọi API; đổi tab thì ô tìm và bộ lọc về mặc định.
- **A4 — Sửa điểm dùng dữ liệu của dòng đang hiện**, không gọi thêm API chi tiết.
- **A5 — Đang nhập dở thì bấm ra ngoài hộp thoại không đóng**; vẫn đóng bằng ✕, Hủy hoặc Esc.
- **A6 — Lưu xong:** đóng hộp thoại, hiện một dòng báo màu xanh phía trên và làm mới bảng.
- **A7 — "Ngày gửi" của đề xuất là ngày tạo**; sửa và gửi lại không đổi ngày này.
- **A8 — Tỉnh / phường đã bị ngừng trong danh mục** vẫn giữ được khi sửa điểm cũ, hiện với nhãn "đã ngừng dùng".
- **A9 — Thành phần dùng chung mới:** `Dialog` trong `packages/ui`; `FormField` và các ô tìm / lọc trong Operator OS. Hai form cũ (xe, sơ đồ ghế) chưa chuyển sang `FormField` để không đụng code đang chạy.
- **A10 — Thêm tài khoản `routeOwner` vào script seed E2E của API:** mỗi bộ ca E2E tự bật xác thực hai lớp một lần nên cần tài khoản riêng.

Riêng phần 2 (màn Tuyến đường):

- **B1 — Đổi thứ tự bằng nút lên / xuống**, không kéo thả: không thêm thư viện, dùng được bằng bàn phím.
- **B2 — Điểm mới thêm xếp cuối tuyến.** Điểm cuối cũ lùi vào giữa và giữ "chỉ cho trả"; nhà xe bật thêm cho đón nếu muốn.
- **B3 — Số liệu chặng khi đang sửa:** chặng nào còn nguyên cặp điểm liền nhau thì hiện số đã lưu; chặng mới (do thêm, bỏ, đổi thứ tự) hiện "Tính khi lưu", tổng cũng vậy.
- **B4 — Ghi chú từng điểm:** bấm "Thêm ghi chú" mới hiện ô nhập (tối đa 300 ký tự).
- **B5 — Bảng chọn xếp loại điểm và tỉnh / thành chồng thành một cột** (Figma vẽ hai cột), vì cột trái của form hẹp và tên tỉnh trong danh mục dài.
- **B6 — Bảng chọn chỉ liệt kê điểm đang dùng được:** danh mục dùng chung đang hoạt động và điểm riêng `ACTIVE`.
- **B7 — Rời form khi còn thay đổi chưa lưu thì hỏi lại**, như form phương tiện.
- **B8 — Môi trường chưa có khóa Goong:** số liệu là ước lượng; danh sách ghi "Ước lượng" dưới quãng đường, form ghi một dòng chú thích.
- **B9 — Tên trường API mới:** `originName`, `destinationName`.
- **B10 — Thành phần dùng chung mới:** `Switch` trong `packages/ui`.
- **B11 — Chấm xám "điểm trong bảng chọn" trên bản đồ** (phần AI đề xuất thêm ở Figma) chưa làm vì chưa có bản đồ; quyết định giữ hay bỏ khi làm `TASK-TRN-014`.

## Màn hình ↔ API

| Chỗ trên màn | API |
| --- | --- |
| Bảng Của nhà xe | `GET /operator/stop-points` (`q`, `type`, `provinceId`, `status`, `cursor`) |
| Thêm / Sửa điểm | `POST` / `PUT /operator/stop-points[/{id}]` |
| Bảng Dùng chung | `GET /catalog/stop-points` (`q`, `type`, `provinceId`, `cursor`) |
| Bảng Đề xuất | `GET /operator/stop-point-proposals` (`status`, `cursor`) |
| Đề xuất / Gửi lại | `POST` / `PUT /operator/stop-point-proposals[/{id}]` |
| Ô chọn tỉnh, phường | `GET /catalog/provinces`, `GET /catalog/wards?provinceId=` |
| Danh sách tuyến | `GET /operator/routes` (`status`, `cursor`) — có `originName`, `destinationName` |
| Form tuyến | `GET /operator/routes/{id}`, `POST` / `PUT /operator/routes[/{id}]` |
| Bảng chọn điểm dừng | `GET /catalog/stop-points`, `GET /operator/stop-points?status=ACTIVE` |

Lỗi API được đổi thành thông báo tại ô: `STOP_POINT_NAME_CONFLICT` → ô tên; `STOP_POINT_TYPE_NOT_ALLOWED` → ô loại điểm; `CATALOG_ITEM_UNAVAILABLE` → ô phường / xã. Lỗi còn lại hiện ở đầu hộp thoại.

Với form tuyến: `ROUTE_NAME_CONFLICT` → ô tên tuyến; `STOP_POINT_UNAVAILABLE` và `ROUTE_STOP_PICKUP_DROPOFF_INVALID` → đầu danh sách điểm dừng; `ROUTING_PROVIDER_UNAVAILABLE` (dịch vụ bản đồ lỗi) → đầu form, nói rõ tuyến chưa được lưu.
