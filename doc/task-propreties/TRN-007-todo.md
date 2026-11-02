# TASK-TRN-007 — Todo: Lịch chuyến lặp lại

> **Khanh (17/10/2026):** "Tiếp tục nốt phần không cần đặt vé" — thứ tự đã chốt: TRN-007 → EMP-001 (phía Operator OS) → ADM-003 (banner / FAQ / trang tĩnh) → lõi đặt vé. Theo quy ước 16/10/2026 "Tự thiết kế + code": schema / API AI tự thiết kế, ghi vào tài liệu, **chờ Khanh duyệt**.
> Nguồn: SRS FR-OPS-07, UC-14 bước 7 ("tạo lịch chuyến lặp theo rule ngày chạy, giờ chạy và thời gian áp dụng"); 11 Task: "chạy lại không sinh chuyến trùng (05 API chưa có endpoint → cần Khanh duyệt)". **Figma chưa có khung** — màn dựng theo bộ kit màn Chuyến xe.
> **Nhánh:** `TASK-TRN-007` (từ `TASK-ADM-004`), chưa commit.

## Trạng thái (17/10/2026) — 🔨 **Code xong, chưa commit — chờ Khanh duyệt thiết kế + review**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).

## Đã làm

### Dữ liệu (migration `20261017010000_trip_schedules`)

- Bảng `trip_schedules` (tenant + RLS `tenant_isolation`): tuyến, xe (tuỳ chọn), giờ khởi hành theo giờ VN (`departure_minute` 0–1439), thời gian chạy (1–10080 phút), thứ chạy (bitmask, bit 0 = thứ Hai), `start_date` / `end_date` (DATE, tối đa 92 ngày giữa hai đầu), số phút ngừng bán online, ghi chú, `created_by`, `last_generated_at`. FK ghép `(route_id, operator_id)` / `(vehicle_id, operator_id)` chặn gắn chéo tenant.
- `trips` thêm `schedule_id` + `service_date` (CHECK cùng có / cùng `null`), **UNIQUE `(schedule_id, service_date)`** → chạy lại không sinh trùng, kể cả hai lần đồng thời.

### API (`/operator/trip-schedules*`, quyền `trip:manage` — chỉ chủ nhà xe)

- `GET` danh sách (lịch còn hiệu lực trước, tối đa 200), `GET /{id}`, `POST` tạo, `PUT /{id}` thay toàn bộ quy tắc, `POST /{id}/generate { openForSale }`.
- Sinh chuyến: mỗi ngày khớp quy tắc là một transaction riêng, **khoá dòng lịch `FOR UPDATE`** rồi đọc quy tắc hiện tại → ngày đã có chuyến của lịch = `EXISTS`, giờ khởi hành đã qua = `PAST`, xe chồng giờ (EXCLUDE `trips_vehicle_no_overlap`) = `VEHICLE_CONFLICT` (bỏ qua ngày đó, chạy lại sau khi gỡ trùng sẽ sinh nốt); còn lại chèn chuyến `DRAFT` qua hàm dùng chung `insertDraftTrip` (tách từ `TripService.create`, cùng luồng chép điểm dừng + ghế).
- `openForSale = true`: mở bán từng chuyến vừa sinh qua đúng `TripService.changeStatus` (BR-39 + audit `trip.status.change`); chưa đủ điều kiện → giữ nháp, trả `notOpenedReasons`.
- Tuyến ngừng dùng / xe không hoạt động → 422 `ROUTE_UNAVAILABLE` / `VEHICLE_UNAVAILABLE` (kiểm khi tạo / sửa / trước khi sinh). Lịch khác tenant → 404 `TRIP_SCHEDULE_NOT_FOUND`.
- Audit `trip_schedule.create` / `.update` (trước / sau) / `.generate` (số chuyến tạo / mở bán / bỏ qua, ngày trùng xe) ghi sau commit, không chặn.

### Operator OS

- Nút **"Lịch chạy lặp lại"** ở đầu trang Chuyến xe → `/trips/schedules` (danh sách: tuyến, giờ chạy, ngày chạy `T2, T4, T6` / `Hằng ngày`, khoảng áp dụng, xe, số chuyến đã sinh, Đang áp dụng / Sắp áp dụng / Đã hết hạn).
- `/trips/schedules/new`, `/trips/schedules/{id}`: form quy tắc (tuyến, giờ khởi hành, thời gian chạy gợi ý theo tuyến, nút chọn thứ + "Hằng ngày", khoảng ngày, xe, ngừng bán online, ghi chú), thẻ "Ngày có chuyến" (số ngày + 8 ngày đầu), khối **"Sinh chuyến"** (công tắc "Mở bán ngay chuyến đủ điều kiện", có thay đổi chưa lưu thì khoá nút, kết quả từng ngày: trạng thái + "Xem chuyến" + lý do chưa mở bán / lý do bỏ qua).
- `PageHeader` dùng chung: khối tiêu đề thêm `basis-80` — màn hẹp thì cụm nút xuống dòng thay vì ép tiêu đề dài thành cột chữ (áp mọi trang Operator OS).

## Chờ Khanh (G1–G10)

| #   | Điểm | Đã làm theo | Cần Khanh |
| --- | ---- | ----------- | --------- |
| G1  | Cách sinh chuyến | Thủ công (bấm "Sinh chuyến"), không job tự động hằng ngày | Có cần job tự sinh cuốn chiếu (vd luôn có sẵn 30 ngày tới) |
| G2  | Giới hạn mỗi lịch | 93 ngày (một lần bấm tối đa 93 chuyến); hết hạn thì sửa ngày kết thúc / tạo lịch mới | Duyệt con số |
| G3  | Múi giờ | Giờ VN = UTC+7 cố định; `service_date` = ngày khởi hành theo giờ VN (chuyến 22:30 thuộc đúng ngày đã chọn) | Duyệt |
| G4  | Ngày xe trùng giờ | Bỏ qua ngày đó (không tạo chuyến chưa gắn xe), báo trong kết quả | Hay tạo chuyến chưa gắn xe |
| G5  | Chuyến đã hủy | Vẫn giữ chỗ ngày của lịch → sinh lại không tạo lại | Duyệt |
| G6  | Sửa lịch | Chỉ áp cho ngày chưa sinh; chuyến đã sinh giữ nguyên, sửa ở từng chuyến | Có cần "áp thay đổi cho chuyến nháp đã sinh" |
| G7  | Xoá / ngừng lịch | Không có; lịch hết hạn giữ để tra cứu | Có cần nút ngừng / xoá |
| G8  | Audit lịch | Ghi sau commit, không chặn (lịch không phải tiền / chống bán trùng — mẫu khoá ghế) | Duyệt |
| G9  | Mở bán ngay | Qua đúng luồng đổi trạng thái từng chuyến (BR-39, audit từng chuyến); lỗi → giữ nháp + lý do | Duyệt |
| G10 | Giao diện | Chưa có Figma — dựng theo bộ kit màn Chuyến xe; nút vào ở đầu trang Chuyến xe | Vẽ khung Figma nếu muốn chỉnh |

## Kiểm tra (17/10/2026)

- `trip-schedule-dates.spec.ts` 4 ca (bitmask thứ, ngày khớp gồm hai đầu, giờ VN → UTC kể cả 22:30, hôm nay theo giờ VN).
- `trip-schedule.int.spec.ts` 6 ca trên Postgres thật, role app: validate (ngày ngược / > 93 ngày / đã qua / trùng thứ / giờ sai → 400; tuyến ngừng / xe không hoạt động / tuyến tenant khác → 422); sinh đúng ngày + giờ VN, chép 3 điểm dừng + 3 ghế, chạy lại toàn `EXISTS`, tenant B 404; **hai lần sinh đồng thời → mỗi ngày đúng một chuyến**; xe trùng giờ → đúng ngày đó `VEHICLE_CONFLICT`, ngày đã qua `PAST`, sửa giờ chạy không đổi chuyến cũ và lần chạy sau dùng giờ mới; mở bán ngay (có giá + xe → Đang mở bán + audit; thiếu xe / giá → nháp + `VEHICLE_MISSING`, `FARE_MISSING`); DB chặn trùng `(schedule_id, service_date)` khi ghi thẳng, CHECK khoảng ngày, tenant khác không ghi được.
- `trip-schedule.http.spec.ts` 13 ca (guard thật 5 route: chủ nhà xe được, không token 401, nhân viên / Platform 403; tenant + người thực hiện từ JWT; 8 ca dữ liệu sai → 400 không gọi service). Toàn bộ `src/trip` 172 ca đạt.
- Unit Operator OS `trip-schedule-form.test.ts` 6 ca. E2E `trips.e2e.ts` thêm 2 ca (tạo lịch T2 / T4 / T6 → sinh 6 chuyến, sinh lại không trùng, danh sách hiện số chuyến; sửa chưa lưu khoá nút sinh, kéo dài 7 ngày + mở bán ngay → 3 chuyến Đang mở bán) — cả file 13 ca đạt.
- Ảnh chụp 1440 px; 390 px không tràn ngang.
