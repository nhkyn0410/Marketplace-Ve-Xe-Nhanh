# TASK-TRN-015 — Todo: Lịch xe (Operator OS)

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` — `TASK-TRN-015` (đề xuất 14/10/2026). Nguồn chi tiết: SRS `FR-OPS-06`, `BR-14`; 06 UI §7 "Trip calendar/list"; Figma section `Nhà xe · Chuyến xe · TRN-003` (`1338:9560`): `07 · Chuyến xe / Lịch xe` (`1703:41114`), `08 · Tạo chuyến · Chọn xe` (`1705:41320`), công tắc "Danh sách | Lịch xe" ở khung 01, thẻ "Lịch xe trong ngày" ở khung 02 (Khanh duyệt thiết kế 13/10/2026).
> **Khanh (16/10/2026):** chọn làm "Lịch xe (TRN-015)" trong đợt hoàn thiện Admin + Operator OS → coi là duyệt task (G1).
> **Nhánh:** làm tiếp trên `TASK-ADM-004`, chưa commit. **Chỉ giao diện** — dùng `GET /operator/trips`, `/operator/vehicles`, `/operator/routes` đã có; không đổi API / DB.

## Trạng thái (16/10/2026) — 🔨 **Code xong, chưa commit — chờ Khanh review + CI**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).

## Đã làm (`apps/operator-os`)

- `lib/trip/vehicle-schedule.ts` (hàm thuần + test): cửa sổ ngày giờ VN, tải mọi chuyến khởi hành từ đầu **hôm trước** tới hết ngày (thấy chuyến qua đêm — API lọc theo giờ khởi hành), dựng dải chuyến theo xe (cắt theo ngày, "+1" / "đến 04:30"), "Rảnh từ (dự kiến)" = giờ đến của chuyến chưa hủy cuối cùng chạm ngày + nơi đến (điểm cuối tuyến, chỉ hiển thị), số liệu tóm tắt, xe rảnh / trùng giờ cho một khoảng giờ (bận = mọi chuyến chưa hủy, giống ràng buộc EXCLUDE ở DB; bỏ qua chính chuyến đang sửa), dòng phụ "Rảnh từ 18:30 · chuyến trước đến Sài Gòn" / "Bận tới 21:15 · …".
- Màn Chuyến xe: công tắc **Danh sách | Lịch xe** (`/trips?view=schedule`). Lịch xe (khung 07): chọn ngày (ô ngày, ‹ ›, Hôm nay), lọc tuyến / trạng thái, dòng tóm tắt, vạch "Bây giờ" (chỉ hôm nay), mỗi xe một hàng trên trục 24 giờ (dải tô theo trạng thái, chấm cam "nối chuyến sát giờ"), hàng "Chưa gắn xe", cột "Rảnh từ (dự kiến)", chú giải. Bấm dải chuyến → chi tiết; bấm khoảng trống của xe → `/trips/new?vehicleId=…&date=…&time=…` (giờ làm tròn 30 phút) điền sẵn xe + ngày giờ.
- Form chuyến (khung 08): ô Xe chia nhóm **Rảnh trong giờ chuyến** / **Trùng giờ — không chọn được** (kèm lý do + nhãn "Trùng giờ") khi đã có đủ giờ khởi hành / đến; ô đã chọn chỉ hiện biển số + sơ đồ ghế. Thẻ **Lịch xe trong ngày** (khung 02) cho xe đang chọn: dải chuyến của xe + chuyến đang tạo (viền đứt), Chuyến trước, Khoảng nghỉ, "Sau chuyến này: Rảnh từ … tại …".
- `PageHeader` của Operator OS: cụm nút xuống dòng được ở màn hẹp (trước đây có thể tràn ngang).

## Chờ Khanh (G1–G7)

| #  | Điểm | Đã làm theo | Cần Khanh |
| -- | ---- | ----------- | --------- |
| G1 | Trạng thái task | Task còn ghi "đề xuất — chờ Khanh duyệt"; Khanh chọn làm 16/10/2026 | Xác nhận để đổi task sang In Progress / Done |
| G2 | "Nối chuyến sát giờ" | Chuyến khởi hành trong vòng 30 phút sau khi chuyến trước của cùng xe đến (Figma chưa định mốc) | Duyệt mốc 30 phút |
| G3 | Nơi xe dừng | "tại …" = điểm cuối của tuyến, chỉ hiển thị; không cảnh báo khi chuyến sau xuất phát ở nơi khác (sẽ là quy tắc SRS mới) | Có cần cảnh báo lệch nơi xuất phát không |
| G4 | Xe hiện trên lịch | Xe đang hoạt động + xe đã ngừng nhưng còn chuyến trong ngày; xe chưa có sơ đồ ghế không bấm tạo chuyến được | Duyệt |
| G5 | Trạng thái giữ xe | Mọi trạng thái trừ Đã hủy (kể cả Hoàn thành) — đúng ràng buộc DB `trips_vehicle_no_overlap` | Duyệt |
| G6 | Tải dữ liệu | Giao diện tải hết chuyến của 2 ngày (trang 100); đủ cho quy mô v1, chưa có API gộp theo xe | Duyệt |
| G7 | Lỗi trùng xe ở máy chủ | Vẫn giữ (hai người tạo cùng lúc); giao diện nay chặn sớm bằng ô chọn | — |

## Kiểm tra (16/10/2026)

- Unit `lib/trip/vehicle-schedule.test.ts` 5 ca (theo đúng ví dụ Figma 07/08: tóm tắt 5 xe / 8 chuyến / 1 chưa gắn / 1 xe trống, chuyến qua đêm, rảnh từ + nơi đến, chuyến hủy không giữ xe, nối sát giờ, nhóm Rảnh / Trùng giờ + dòng phụ); `trip-form.test.ts` thêm ca điền sẵn. Toàn bộ unit Operator OS 421 ca đạt.
- E2E `trips.e2e.ts` 11 ca đạt — ca "xe trùng giờ" đổi sang kiểm nhóm Trùng giờ (không chọn được) + thẻ Lịch xe trong ngày; ca mới "lịch xe" (hai chuyến nối sát giờ, rảnh từ 17:00, bấm khoảng trống → tạo chuyến điền sẵn).
- Đối chiếu Figma 07 / 08 / thẻ khung 02 ở 1440 px; 390 px không tràn ngang (lưới cuộn trong khung).

## Việc tiếp theo

1. Khanh review, chốt G1–G7.
