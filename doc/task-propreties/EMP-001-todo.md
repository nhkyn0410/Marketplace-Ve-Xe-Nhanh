# TASK-EMP-001 — Todo: Phân công tài xế cho chuyến (phía Operator OS)

> **Khanh (17/10/2026):** "Tiếp tục nốt phần không cần đặt vé" — làm phần Operator OS của `TASK-EMP-001` (màn Phân công chuyến). App nhân viên (`employee_mobile`, danh sách khách, đăng nhập `/auth/employee/login`) **chưa làm** — "không đụng giao diện khách hàng" và đợt này tập trung nhà xe + Admin.
> Nguồn: SRS UC-16 bước 4–6 + A1–A4, §8 "gán nhân viên (Employee có role DRIVER)"; Figma "05 · Nhân viên / Phân công chuyến" (`1666:26082`). Schema / API **AI tự thiết kế, chờ Khanh duyệt** (quy ước 16/10/2026).
> **Nhánh:** `TASK-TRN-007` (làm tiếp sau TRN-007), chưa commit.

## Trạng thái (17/10/2026) — 🔨 **Code xong phần Operator OS, chưa commit — chờ Khanh duyệt + review**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).

## Đã làm

- **DB** (migration `20261017020000_employee_assignments`): bảng `employee_assignments` (tenant + RLS `tenant_isolation`): `trip_id`, `employee_id`, `role` (`EmployeeRole`), `assigned_by`; **UNIQUE `(trip_id, role)`** (mỗi chuyến một người mỗi vai trò); FK ghép `(trip_id, operator_id)` / `(employee_id, operator_id)` chặn gắn nhân viên / chuyến tenant khác (thêm unique `(id, operator_id)` cho `employee_accounts`).
- **API** (module `employee/`, quyền `employee:manage` — chỉ chủ nhà xe):
  - `GET /operator/trip-assignments?date&routeId&state&cursor&limit` — chuyến chưa hủy khởi hành trong ngày (giờ VN), kèm tài xế, `conflict` (chuyến khác của cùng tài xế chồng giờ — xảy ra khi giờ chuyến bị sửa SAU khi phân công), `reasonRequired`, `editable`.
  - `PUT /operator/trips/{tripId}/driver { employeeId | null, reason }` — phân công / đổi / bỏ. Khoá dòng chuyến + dòng nhân viên (`FOR NO KEY UPDATE`) rồi kiểm: nhân viên phải là tài xế đang hoạt động của nhà xe (422 `EMPLOYEE_NOT_ASSIGNABLE`), không chồng giờ chuyến chưa hủy khác (409 `DRIVER_SCHEDULE_CONFLICT`, câu nêu giờ chuyến kia), chuyến hủy / hoàn thành → 409 `TRIP_NOT_ASSIGNABLE`, chuyến đang chạy hoặc còn < 2 giờ là khởi hành mà thiếu lý do → 422 `ASSIGNMENT_REASON_REQUIRED`. Audit `trip.driver.assign` / `.unassign` (trước / sau / lý do) **trong transaction** — Mongo lỗi → 503, không đổi gì. Gửi lại đúng người đang giao → không audit.
- **Operator OS**: nút "Phân công chuyến" ở đầu trang Nhân viên → `/employees/assignments` theo Figma: lọc ngày khởi hành / tuyến / tình trạng, bảng Khởi hành (Đến … / hôm sau) · Tuyến · Xe · Tài xế (ô chọn — chọn là lưu) · Tình trạng (Đã phân công / Chưa phân công / Trùng lịch), lỗi trùng giờ hiện ngay dưới ô (viền đỏ), "Tải thêm", ghi chú cuối trang; chuyến sắp chạy mở hộp thoại nhập lý do.

## Chờ Khanh (G1–G8)

| #  | Điểm | Đã làm theo | Cần Khanh |
| -- | ---- | ----------- | --------- |
| G1 | Phạm vi vai trò | Chỉ tài xế (theo Figma); bảng có cột `role` để thêm nhân viên vé / hỗ trợ sau | Có phân công nhân viên vé / hỗ trợ cho chuyến không (UC-16 bước 4 nêu cả ba) |
| G2 | Quyền | `employee:manage` (chủ nhà xe) — UC-16 "Quản lý Employee và phân công nhiệm vụ" | Duyệt |
| G3 | Trùng lịch | Chặn khi phân công (Figma: "không được phân công vào hai chuyến trùng thời gian"); chuyến bị sửa giờ sau khi phân công → chỉ báo "Trùng lịch" | Có cần chặn luôn ở lúc sửa giờ chuyến |
| G4 | "Sắp khởi hành" | Còn dưới **2 giờ** là khởi hành hoặc đang chạy (BOARDING / DEPARTED / IN_PROGRESS / INCIDENT) → bắt buộc lý do | Duyệt con số |
| G5 | Thông báo nhân viên (UC-16 bước 7) | Chưa gửi — chờ `TASK-NSR-001` + app nhân viên; mô tả trang không hứa thông báo (Figma có câu "nhận thông báo") | Duyệt |
| G6 | Nhân viên bị khóa sau khi đã giao | Giữ phân công, ô hiện "(không còn hoạt động)", không chọn lại được | Có tự gỡ khi khóa nhân viên không |
| G7 | Chuyến hiển thị | Chuyến chưa hủy khởi hành trong ngày (giờ VN), kể cả đã hoàn thành (chỉ xem) | Duyệt |
| G8 | App nhân viên | `GET /employee/assignments` (05 API §7.4) + màn `employee_mobile` chưa làm | Làm cùng EMP-002 / khi mở lại phần app |

## Kiểm tra (17/10/2026)

- `employee-assignment.int.spec.ts` 5 ca trên Postgres thật, role app: phân công + audit, gửi lại không audit, nhân viên khóa / nhân viên vé / tenant khác / id lạ → 422, chuyến tenant khác 404, chuyến hủy 409; trùng giờ 409 kèm giờ chuyến kia, nối đúng giờ đến được, **hai lần phân công đồng thời cùng tài xế vào hai chuyến chồng giờ → chỉ một thành công**; < 2 giờ / đang chạy cần lý do, lý do vào audit, bỏ phân công; danh sách theo ngày VN (chuyến 23:30 hôm trước không lẫn vào), bỏ chuyến hủy, lọc, phân trang, chồng giờ do sửa giờ sau được báo hai phía, tenant khác rỗng; audit lỗi → 503 không đổi gì; DB chặn hai tài xế một chuyến và nhân viên tenant khác kể cả ghi thẳng.
- `employee-assignment.http.spec.ts` 10 ca (guard thật: chủ nhà xe được, không token 401, nhân viên / Platform 403; người thực hiện + tenant từ JWT; RFC 7807 cho 409; 6 ca dữ liệu sai → 400).
- Unit `lib/employee/assignment-format.test.ts` 3 ca. E2E `assignments.e2e.ts` 3 ca (nhà xe riêng do seed dựng: chọn là lưu, trùng giờ bị chặn kèm giờ chuyến kia + "Trùng lịch", nhân viên vé không có trong danh sách, lọc chưa phân công, bỏ phân công, chuyến còn 1 giờ phải nhập lý do).
- Ảnh chụp 1440 px khớp Figma; 390 px không tràn ngang.
