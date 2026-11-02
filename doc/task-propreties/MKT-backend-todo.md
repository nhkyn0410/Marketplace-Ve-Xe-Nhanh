# Hồ sơ công khai nhà xe và tài khoản hành khách — Backend

> Khanh 19/10/2026 yêu cầu B6/B7: MKT-001, MKT-002 và danh sách đơn / vé / khiếu nại của hành khách. Shape API hồ sơ hành khách và danh sách do AI đề xuất theo quy ước hiện có; không thay trạng thái phê duyệt SDLC. Chưa qua code-reviewer / security-auditor.

## Đã làm

- `GET /operators/{operatorId}/public-profile`: chỉ nhà xe ACTIVE; trường công khai (tên, slug, mô tả, hotline, email công khai, địa chỉ), tối đa 6 tuyến có chuyến mở bán sắp tới và review VISIBLE phân trang. Không trả KYC, mã số thuế, thông tin tài khoản ngân hàng hoặc trường kiểm duyệt.
- Scorecard FR-NSR-11/15: rating / số review VISIBLE; tỷ lệ hủy do nhà xe trên chuyến đã hoàn thành hoặc hủy đã qua giờ đi; tỷ lệ đơn đã trả có refund thành công / có tranh chấp; check-in / no-show trên vé đã có kết quả ở chuyến hoàn thành. Không có mẫu số hoặc không xác định được bên hủy → null.
- `GET/PUT /me/profile`: tên, điện thoại, ngày sinh; email và trạng thái xác minh chỉ đọc. `GET/POST /me/saved-passengers`, `PUT/DELETE /me/saved-passengers/{passengerId}`: họ tên, điện thoại tùy chọn, luôn lọc chủ sở hữu.
- `GET /me/bookings`, `/me/tickets`, `/me/support-tickets`, `/me/disputes`: `limit` 1–100 (mặc định 20), cursor, thứ tự `(createdAt, id)` giảm dần. Chủ sở hữu lấy từ token PASSENGER, không nhận userId từ client. Vé không kèm QR trong danh sách. Tổng tiền đơn trả chuỗi VND để giữ độ chính xác BIGINT.
- Migration `20261019120000_passenger_profiles`: User phone/dateOfBirth, bảng saved_passengers thuộc tài khoản hành khách, không có operator_id theo DB-PRIN-01. Các truy vấn đơn / vé / khiếu nại qua scope hệ thống tại database helper và luôn lọc booking.userId.
- Shared Zod schema tại `packages/types/src/passenger-profile.ts`; controller dùng nestjs-zod, OpenAPI và client do agent chính sinh lại.

## Còn lại

- Nhà xe chưa có dữ liệu logo và điều khoản dịch vụ riêng trong schema hiện tại; API trả `serviceTerms: null`, không tạo nội dung thay nhà xe. Cần xác định nguồn nhập / duyệt nội dung trước khi có dữ liệu.
- Kênh hành khách web / mobile chưa xây màn hình; phạm vi lần này là backend.
- Chỉ số scorecard dùng dữ liệu hiện có; hủy chuyến cũ thiếu TripChange actor không thể kết luận bên gây hủy, trả null.

## Kiểm tra bổ sung

- `passenger-profile.int.spec.ts`: chỉ sửa hồ sơ mình; không đọc / sửa / xóa hành khách thường dùng của tài khoản khác.
- `support.int.spec.ts`: danh sách riêng không lẫn đơn guest / tài khoản khác, cursor của người khác không dùng được; mở trực tiếp tranh chấp chống lặp; public profile không lộ dữ liệu riêng và review ẩn không tính điểm.
- Kết quả lint / typecheck / test toàn nhánh được agent chính tổng hợp. Test integration cần PostgreSQL + Redis thật.
