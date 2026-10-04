# TASK-TRN-010 — Todo: Phân loại xe và loại chỗ

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` §7.3 — migration `vehicle_types.form` + `class`, seed 6 loại xe, enum loại chỗ thêm `BED_DOUBLE` / `CABIN` / `CABIN_DOUBLE`; API catalog trả `form` + `class`, SeatMap trả `passengerCapacity`; sinh lại client TS + Dart. Nguồn chi tiết: SRS `BR-77`, `BR-78`, `AC-41`; DB §5.2, §7; API §7.3, §7.6; Test `TC-TRN-012`, `TC-TRN-013`.
> **Dependency:** `TASK-CAT-001`, `TASK-TRN-001` — đã merge `develop`.
> **Mở khóa:** màn xe / sơ đồ ghế Operator OS; port `TASK-TRN-003` và `TASK-TRN-005`; `TASK-TRN-004` (lọc theo dạng chỗ + hạng xe).
> **Cách dùng:** lệnh kiểm chứng ở `TRN-010-guide.md`; nghiệm thu ở `TRN-010-verification-checklist.md`.

## Trạng thái (04/10/2026) — 🔨 **ĐANG TRIỂN KHAI**

- ✅ Nhánh `TASK-TRN-010` tạo từ `develop` (`153f578`) ngày 04/10/2026.
- ✅ Thiết kế đã được Khanh chốt 04/10/2026 (SRS v1.33) nên task không có câu hỏi cần chốt thêm; phần AI tự đặt nằm ở mục "Giả định hiện thực".
- ✅ Code, test, migration và hai client đã xong; số đo ở checklist. ⏳ Chờ Khanh review diff (chưa commit) → CI → Done.

---

## Phạm vi

### Thuộc TRN-010

- `vehicle_types` thêm `form` (`SEATER` / `SLEEPER` / `CABIN`) và `class` (`STANDARD` / `LIMOUSINE`), cả hai bắt buộc (`BR-77`).
- Seed 6 loại xe; mã `LIMOUSINE` cũ đổi thành `SEATER_LIMOUSINE`.
- Enum loại chỗ có 5 giá trị: `SEAT`, `BED`, `BED_DOUBLE`, `CABIN`, `CABIN_DOUBLE` (`BR-78`).
- `GET /catalog/vehicle-types` trả thêm `form`, `class`.
- SeatMap (danh sách + chi tiết) trả thêm `passengerCapacity` và `deckCount`. `deckCount` thuộc `TASK-TRN-011` nhưng task đó ghi rõ "làm cùng TRN-010".
- Sinh lại client TS + Dart.

### Không tự kéo vào task

- Lọc tìm chuyến theo `vehicleForm` / `vehicleClass` → `TASK-TRN-004`.
- Giá riêng cho chỗ đôi (`fare_rules`) → khi port `TASK-TRN-005`; `trip_seats` → khi port `TASK-TRN-003`. Hai bảng này chưa có ở repo chính; khi port sẽ dùng luôn enum 5 giá trị.
- Luồng bán chỗ đôi (`OQ-23`, `LLD-OQ-09`) → nhóm BTP.
- Cờ `seatMapLocked`, `inUse` của `TASK-TRN-011` → khi port `TASK-TRN-003`.
- Admin sửa loại xe → `TASK-ADM-001`.

---

## Giả định hiện thực (AI đặt — Khanh phản đối thì sửa)

- **A1 — Tên 6 loại xe:** `Ghế ngồi`, `Giường nằm`, `Cabin`, `Ghế ngồi Limousine`, `Giường nằm Limousine`, `Cabin Limousine`. Tài liệu chưa quy định tên hiển thị; Admin sửa được sau (`TASK-ADM-001`).
- **A2 — Đổi mã trong migration, không tạo dòng mới:** dòng `LIMOUSINE` giữ nguyên `id`, chỉ đổi `code` → `SEATER_LIMOUSINE`, nên xe đang gắn loại này không bị ảnh hưởng. Tên chỉ đổi khi còn là tên seed gốc `Limousine`.
- **A3 — Migration dừng khi gặp mã lạ:** nếu `vehicle_types` có mã ngoài 4 mã seed cũ thì migration dừng và báo tên các mã đó, không tự đoán dạng chỗ / hạng xe. Cách xử lý ở guide §5.
- **A4 — Không đặt default cho `form` / `class`:** mọi đường ghi phải khai rõ cả hai; DB từ chối dòng thiếu.
- **A5 — Hai loại xe mới do seed tạo:** `SLEEPER_LIMOUSINE`, `CABIN_LIMOUSINE` được `db:seed:catalog` tạo (seed chỉ tạo mới, không ghi đè). Sau khi migrate phải chạy lại seed catalog.
- **A6 — `passengerCapacity` tính lúc đọc, không lưu cột:** bằng `seatCount` + số chỗ đôi, đếm ngay trong truy vấn. DB §7 không có cột sức chứa nên không thêm.
- **A7 — Không ràng buộc loại chỗ theo dạng chỗ của loại xe:** đúng `BR-78` — một sơ đồ được trộn nhiều loại chỗ.
- **A8 — Tên enum trong DB theo kiểu của code hiện có:** `"VehicleForm"`, `"VehicleClass"`, `"SeatType"` (DB doc ghi tên logic `vehicle_form`, `vehicle_class`, `seat_type`).

## Contract thay đổi

| Endpoint | Thay đổi |
| --- | --- |
| `GET /catalog/vehicle-types` | mỗi item thêm `form`, `class` |
| `GET /operator/seat-maps` | mỗi item thêm `passengerCapacity`, `deckCount` |
| `GET` / `POST` / `PUT /operator/seat-maps[/{id}]` | response thêm `passengerCapacity`, `deckCount`; `seats[].type` nhận 5 giá trị, giá trị khác → `400` |

Không thêm mã lỗi mới. Không đổi quyền: catalog vẫn công khai, SeatMap vẫn `vehicle:manage` trong tenant.
