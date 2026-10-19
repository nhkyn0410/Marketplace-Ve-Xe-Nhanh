# TASK-BTP-002 — Todo: Tạo booking (snapshot + tổng tiền)

> **Khanh (17/10/2026):** lõi đặt vé theo lát dọc, quy tắc SRS/ADR (giữ chỗ 10 phút, chỉ trả trước, mỗi chỗ một vé, phí dịch vụ 0 nhưng tách dòng), không làm giao diện khách hàng.
> Nguồn: LLD §6.2, FR-BTP-05/06/18, SRS §9.4 (dữ liệu snapshot bắt buộc) + §17.6 (trạng thái booking), DB §4 nhóm Booking & Ticket, CO-12, BR-07, OQ-07 (chỉ trả trước). Cột / API chưa có trong thiết kế → AI tự đề xuất, **chờ Khanh duyệt**.
> **Nhánh:** `TASK-TRN-004` (làm tiếp), chưa commit.

## Trạng thái (17/10/2026) — 🔨 **Backend xong, chưa commit — chờ Khanh duyệt + review**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8). Không có màn hình (phía khách hàng).
- Chưa sinh lại client TS / Dart cho `/bookings` (làm gộp khi xong lát thanh toán).

## Đã làm

- Migration `20261017040000_bookings`: enum `BookingStatus` (đủ 10 trạng thái SRS §17.6); bảng `bookings` (mã `VXN` + 6 ký tự, `hold_id` unique, tiền BIGINT với CHECK `total = subtotal + service_fee − discount`, `snapshot` JSONB, `access_token_hash`, `expires_at`), `passenger_infos` (mỗi chỗ một dòng, giá chỗ lúc đặt > 0), `booking_status_histories`; `trip_seats.booking_id`. Cả ba bảng RLS `tenant_isolation`.
- `POST /bookings { holdId, contact {fullName, phone, email}, passengers [{seatCode, fullName, phone}], note, expectedTotal }` (khách vãng lai hoặc hành khách, `booking:create`):
  - Giữ chỗ phải còn hiệu lực + đúng chủ (Lua kiểm MỌI khóa chỗ còn mang đúng `holdId`); hành khách khai đúng các chỗ đã giữ.
  - Một transaction ở tenant của nhà xe sở hữu chuyến: khoá chuyến `FOR SHARE` (xếp hàng với nhà xe đổi trạng thái — bàn giao TRN-006) + kiểm còn mở bán / chưa quá giờ bán / nhà xe `ACTIVE`; khoá ghế `FOR UPDATE` theo thứ tự mã + kiểm còn `AVAILABLE`; tính lại giá từ bảng giá đang áp dụng; khác `expectedTotal` → 409 `BOOKING_SNAPSHOT_CHANGED` (`reasons[0]` = tổng mới), không thu khác số khách đã đồng ý.
  - Ghi booking `PENDING_PAYMENT` + hành khách + lịch sử (`guest` / `user:{id}`), chuyển ghế sang `HOLDING` gắn booking. Hạn thanh toán = hạn giữ chỗ còn lại. Xong mới trả khóa Redis.
  - Snapshot: tuyến, nhà xe (tên, hotline), loại xe, giờ đi / đến, điểm đón / trả (tên, địa chỉ, giờ), mốc hủy / hoàn đang áp dụng (riêng nhà xe, không có thì mặc định nền tảng). Giá từng chỗ ở `passenger_infos`.
  - Trả `accessToken` (32 byte ngẫu nhiên) MỘT lần; server chỉ lưu SHA-256.
  - Gửi lặp / đồng thời cùng giữ chỗ → đúng một booking, lần kia 409 `BOOKING_ALREADY_CREATED` (hoặc 404 nếu khóa Redis đã trả).
- `GET /bookings/{bookingId}`: booking của hành khách chỉ chính họ xem; của khách vãng lai cần header `X-Booking-Token`. Không quyền = 404 `BOOKING_NOT_FOUND`. Quá hạn mà job chưa quét → chuyển `EXPIRED` ngay.
- Job nền `booking-expiry` (hàng đợi mới `booking-maintenance`, mỗi phút, worker riêng — ADR-024): booking `PENDING_PAYMENT` quá hạn → `EXPIRED`, trả ghế `AVAILABLE`, ghi lịch sử `system`. Có điều kiện nên chạy lặp an toàn. Hiện ở trang Tác vụ nền của Admin.
- Đổi nhỏ ở TRN-006: nhà xe thu hồi nháp / hủy chuyến khi còn ghế `HOLDING` (khách đang thanh toán) → 409 — tránh tiền về sau cho chuyến đã hủy.

## Chờ Khanh (G1–G8)

| #  | Điểm | Đã làm theo | Cần Khanh |
| -- | ---- | ----------- | --------- |
| G1 | Bảng / cột booking | Thiết kế ở trên (DB §4 chỉ có tên bảng) | Duyệt |
| G2 | Mã booking | `VXN` + 6 ký tự, bỏ 0/O/1/I cho dễ đọc qua điện thoại | Duyệt định dạng |
| G3 | Khách vãng lai xem / thanh toán booking | Mã truy cập trả một lần lúc đặt, gửi ở header `X-Booking-Token`; tra cứu bằng mã booking + liên hệ (Security §8) để lát hủy / hoàn | Duyệt |
| G4 | Giá đổi giữa lúc giữ chỗ và lúc đặt | 409 kèm tổng mới, khách xác nhận lại (không tự thu theo giá mới) | Duyệt |
| G5 | Hạn thanh toán | = hạn giữ chỗ còn lại (không cộng thêm thời gian) | Duyệt |
| G6 | Nhà xe hủy chuyến khi khách đang thanh toán | Chặn 409 tới khi hết hạn thanh toán; hủy chuyến đã bán vé để BTP-005 | Duyệt |
| G7 | Khuyến mãi / voucher / phí dịch vụ | Chưa có (TASK-PROM-001, TASK-LOY-001 chờ LLD-OQ-06) → `discount` 0, `serviceFee` 0 tách dòng | — |
| G8 | Mức tối thiểu của cổng thanh toán (LLD §6.2 bước 3) | Để lát thanh toán (BTP-003) kiểm theo từng cổng | — |

## Kiểm tra (17/10/2026)

- `booking.int.spec.ts` 6 ca trên Postgres + Redis thật, role app: đặt 2 chỗ (tổng BIGINT, phí 0, snapshot, ghế `HOLDING` gắn booking, khóa Redis đã trả, chi tiết chuyến hiện chỗ đã đặt, lưu hash không lưu mã, lịch sử, xem bằng mã / không mã / sai mã); **gửi đồng thời hai lần cùng giữ chỗ → đúng một booking**; giá đổi sau khi giữ → 409 + tổng mới, không ghi gì, giữ chỗ còn nguyên, gửi lại đúng tổng thì được; hành khách khai sai chỗ 422, nhà xe khóa ghế sau khi giữ 409, chuyến thu hồi 409; booking của hành khách chỉ chính họ xem, nhà xe không hủy chuyến khi còn khách thanh toán, **RLS: tenant khác không thấy booking / hành khách**; quá hạn → job chuyển `EXPIRED` + trả ghế + lịch sử, xem booking quá hạn → `EXPIRED` ngay, ghế đặt lại được.
- `booking.http.spec.ts` 10 ca (guard thật: khách vãng lai / hành khách được, token rác 401, chủ nhà xe / tài xế / Admin 403; header mã truy cập; 7 ca body sai → 400).
- Toàn bộ API: 123 file / 1431 test pass; lint + typecheck sạch; drift migration chỉ còn `search_text` có sẵn.
