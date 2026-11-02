# TASK-EMP-002 (phần backend) — Todo: soát vé + trạng thái vận hành chuyến

> Khanh 19/10/2026: làm phần backend EMP-002 (app `employee_mobile` chưa làm). Nguồn: FR-EMP-07..09/13, UC-20/21, BR-05/29/32/44, API §7.4. API / cột AI tự đề xuất, **chờ Khanh duyệt**. Nhánh `TASK-TRN-008`, chưa commit; chưa qua `code-reviewer` / `security-auditor`.

## Đã làm

- Migration `20261019020000_trip_operations`: `trips.departed_at`, `completed_at`, `payout_eligible_at`.
- Quyền mới `trip:operate` (chỉ tài xế, phạm vi phân công); soát vé dùng `checkin:perform` (mọi role Employee). `requireAssignedTenant` — service tự lọc theo phân công của chính nhân viên.
- Module `check-in/`, API §7.4 (Bearer, app Nhân viên):
  - `GET /employee/assignments?from&to` — chuyến được phân công (mặc định hôm qua → 7 ngày tới), số vé / đã lên.
  - `GET /employee/trips/{id}/passengers` — danh sách khách (số điện thoại đã che, điểm đón / trả, trạng thái vé).
  - `POST /employee/tickets/verify { tripId, code }` — QR (so hash) hoặc mã vé; kết quả `OK` / `WRONG_TRIP` / `ALREADY_CHECKED_IN` / `CANCELLED` / `REFUNDED` / `NO_SHOW` / `USED`; vé sai chuyến không lộ thông tin khách.
  - `POST /employee/check-ins { tripId, code, status: CHECKED_IN | NO_SHOW }` — có điều kiện `VALID →` (hai máy quét cùng vé chỉ một lần), ghế `CHECKED_IN`, lịch sử vé ghi `employee:{id}` (nhật ký thao tác BR-44). Vắng mặt chỉ sau khi bắt đầu đón.
  - `POST /employee/trips/{id}/status { status, note }` — tài xế: (đang bán / tạm khóa / hết chỗ) → `BOARDING` → `DEPARTED` → `IN_PROGRESS` → `COMPLETED` (cho phép bỏ qua `BOARDING` / `IN_PROGRESS`). Hoàn thành: vé đã lên → `USED`, vé chưa lên → `NO_SHOW`, `payout_eligible_at` = hoàn thành + chu kỳ chi trả.
- **Kỳ chi trả theo giờ hoàn thành thực tế (BR-32)**: tạo kỳ + màn Tài chính nhà xe dùng `COALESCE(trips.payout_eligible_at, mốc trên sổ)`.
- Operator OS: chi tiết chuyến hiện "Khởi hành thực tế" / "Hoàn thành lúc"; danh sách khách đã có số "Đã lên xe / Vắng mặt" (OPR-003).
- Bổ sung 19/10 theo yêu cầu tiếp nối: module `incident/` + `journey-log/`, migration `20261019100000_incident_journey` (tenant + FORCE RLS, FK ghép nhà xe).
  - `POST/GET /employee/incidents` — tài xế / nhân viên hỗ trợ được phân công trên chuyến đang vận hành (`BOARDING`, `DEPARTED`, `IN_PROGRESS`, `INCIDENT`); loại, ảnh hưởng, mô tả, vị trí, giờ thực tế, tối đa 5 minh chứng PDF/JPEG/PNG. Nhân viên vé không báo sự cố.
  - Minh chứng dùng kho riêng tư; `POST /employee/trips/{id}/incident-attachments` cấp URL tải lên, kiểm định dạng / dung lượng / chữ ký tệp; namespace từng nhân viên chặn dùng minh chứng của người khác. Nhà xe / Admin xem tệp qua URL 5 phút, có audit.
  - Mọi sự cố gửi cảnh báo Owner. **Khanh chốt: sự cố nghiêm trọng tự báo Admin** — mức `HIGH` / `CRITICAL` gửi thêm tới tài khoản PlatformAdmin đang hoạt động. Mức `LOW` / `MEDIUM` báo nhà xe; không tự đổi trạng thái chuyến.
  - `POST/GET /employee/journey-logs` — chỉ tài xế được phân công: điểm dừng, giờ thực tế, tình trạng xe, ghi chú; trễ = số phút thực tế sau giờ dự kiến tại điểm (không âm).
  - `GET /operator/incidents`, `/operator/journey-logs`; `PUT /operator/incidents/{id}/resolution` — tab **Sự cố và nhật trình** tại Hỗ trợ có dữ liệu, phân trang, minh chứng, ghi kết quả xử lý.
  - `GET /admin/incidents`, `/admin/journey-logs` — giám sát; Admin có tab **Sự cố vận hành** tại Khiếu nại & tranh chấp (`?tab=incidents`).
  - `PUT /operator/trips/{id}/stops/{sequence}/pickup-window { start, end }` — hai mốc giờ tuyệt đối, hoặc cả hai `null`; chỉ điểm được đón khách. Chi tiết chuyến có form theo từng điểm; API công khai + danh sách khách nhân viên trả hai mốc. `NO_SHOW` bị chặn tới khi hết cửa sổ tại đúng điểm khách lên.

## Chờ Khanh

| # | Điểm | Đã làm theo |
|---|------|-------------|
| G1 | Khung giờ soát vé | Check-in theo trạng thái; `NO_SHOW` còn phải sau cửa sổ đón riêng tại điểm khách lên nếu đã cấu hình. Điểm chưa có cửa sổ giữ điều kiện từ lúc bắt đầu đón như trước |
| G2 | Hoàn thành chuyến | Vé chưa lên tự thành vắng mặt |
| G3 | Audit đổi trạng thái | Ghi Mongo SAU commit (Mongo lỗi không chặn tài xế); check-in chỉ ghi lịch sử vé |
| G4 | Số điện thoại cho nhân viên | Đã che; chưa có nút xem đầy đủ / gọi |
| G5 | Nhật trình, sự cố (UC-22), `INCIDENT`, offline | Nhật trình + sự cố + tự báo Admin đã làm; không tự đổi trạng thái chuyến. Đồng bộ offline / ứng dụng Nhân viên nằm ngoài lượt backend này |
| G6 | Nhân viên vé / hỗ trợ | Soát vé được nếu được phân công, nhưng Operator OS mới phân công tài xế (EMP-001 G1) |

## Kiểm tra

- `employee-operations.int.spec.ts` 3 ca (Postgres + Redis thật): danh sách / soát QR + mã vé / sai chuyến / 404; check-in + lịch sử + quét lại 409 + **hai máy quét đồng thời chỉ một** + vắng mặt trước khi đón 409; thứ tự trạng thái, nhân viên vé không đổi được, hoàn thành → USED / NO_SHOW + mốc chi trả theo giờ hoàn thành (màn Tài chính thấy tiền đủ điều kiện).
- `employee-operations.http.spec.ts` 2 ca (guard: 3 role Employee soát vé, chủ nhà xe / Admin 403; chỉ tài xế đổi trạng thái; body sai 400).
- Suite trip / payout / role liên quan pass.
- Bổ sung: `incident.http.spec.ts` 4 ca (guard role, tenant từ token, Zod, tệp của nhân viên khác); `incident.int.spec.ts` 3 ca Postgres thật (phân công/chuyến đang chạy, cảnh báo Owner + Admin, tenant RLS kể cả truy vấn quên lọc, nhật trình/độ trễ/cửa sổ). `employee-operations.int.spec.ts` thêm ca `NO_SHOW` trước / sau cửa sổ tại điểm đón. Tất cả pass; chưa qua review độc lập.
