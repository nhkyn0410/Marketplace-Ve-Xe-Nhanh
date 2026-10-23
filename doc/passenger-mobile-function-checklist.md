# Checklist chức năng ứng dụng hành khách Vé Xe Nhanh

Checklist này tổng hợp 80 chức năng v1 của ứng dụng di động đa nền tảng dành cho hành khách. Đánh dấu `- [x]` khi chức năng đã được triển khai và xác minh hoàn tất; giữ `- [ ]` khi chức năng chưa hoàn thành.

**Tiến độ:** _____ / 80 chức năng

**Quy ước kiểm tra:** Chỉ đánh dấu `[x]` khi chức năng đã được triển khai đầy đủ trên ứng dụng mobile và có bằng chứng xác minh. Mục `[ ]` có thể chưa làm hoặc mới hoàn thành một phần; xem ghi chú kiểm tra bên dưới mục đó.

**Phạm vi đã rà soát:** `AUTH-01` đến `AUTH-06` ngày 23/10/2026 — 0 hoàn tất, 5 một phần, 1 chưa có.

## 1. Tài khoản và xác thực

- [ ] **AUTH-01** Đăng ký hoặc đăng nhập bằng Email và OTP, hoặc OAuth Google, Facebook, Apple; cho phép khách vãng lai sử dụng ứng dụng mà không cần đăng nhập.
  - **Trạng thái: Một phần.** Mobile đã gọi API gửi và xác minh OTP, lưu access token và cho phép vào trang chủ ở chế độ khách. Các nút Google, Facebook và Apple mới hiển thị thông báo chưa tích hợp; backend hiện chỉ hỗ trợ OAuth Google.
- [ ] **AUTH-02** Xem và cập nhật hồ sơ cá nhân; lưu tối đa 5 hành khách thường đi để đặt nhanh.
  - **Trạng thái: Một phần ở backend.** Backend và API client đã có API đọc/cập nhật hồ sơ và CRUD hành khách đã lưu. Mobile chưa có màn hình hoặc lời gọi API tương ứng; backend chưa giới hạn tối đa 5 hành khách đã lưu.
- [ ] **AUTH-03** Đổi email và xác minh lại bằng OTP.
  - **Trạng thái: Chưa có.** Chưa tìm thấy API đổi email dành cho hành khách, luồng xác minh email mới hoặc màn hình mobile tương ứng.
- [ ] **AUTH-04** Quản lý hành khách đã lưu: thêm, sửa, xóa và chọn nhanh khi đặt vé.
  - **Trạng thái: Một phần ở backend.** Backend và API client đã có thao tác liệt kê, thêm, sửa và xóa; mobile chưa tích hợp màn hình quản lý hoặc chọn nhanh khi đặt vé.
- [ ] **AUTH-05** Quản lý phiên đăng nhập và thiết bị, thu hồi phiên; lưu token bằng `flutter_secure_storage`.
  - **Trạng thái: Một phần.** Access token đã được lưu, đọc và xóa bằng `flutter_secure_storage`; backend và API client đã có API liệt kê/thu hồi phiên. Mobile chưa có màn hình quản lý phiên, chưa gọi API thu hồi phiên, chưa lưu refresh token và chưa khôi phục hoặc làm mới phiên khi mở lại ứng dụng.
- [ ] **AUTH-06** Xác minh lại bằng OTP trước các thao tác nhạy cảm.
  - **Trạng thái: Một phần ở backend.** Backend và API client đã có endpoint re-auth bằng OTP; mobile chưa có UI hoặc lời gọi re-auth trước thao tác nhạy cảm.

## 2. Trang chủ và nội dung chung

- [ ] **HOME-01** Hiển thị form tìm chuyến.
- [ ] **HOME-02** Hiển thị ưu đãi, tuyến phổ biến, nhà xe đối tác và tin tức.
- [ ] **HOME-03** Xem và tìm kiếm Câu hỏi thường gặp (FAQ).
- [ ] **HOME-04** Xem Điều khoản sử dụng, Chính sách bảo mật và Chính sách hoàn tiền.
- [ ] **HOME-05** Xử lý các trạng thái lỗi 404, 403, 500, 503 và trạng thái offline.

## 3. Tìm chuyến

- [ ] **SEARCH-01** Tìm chuyến theo điểm đi, điểm đến, ngày đi và số lượng khách.
- [ ] **SEARCH-02** Lọc theo nhà xe, giờ khởi hành, giá vé, loại xe, tiện ích, điểm đón hoặc trả và đánh giá.
- [ ] **SEARCH-03** Sắp xếp theo giá, giờ đi, đánh giá hoặc thời gian di chuyển.

## 4. Chi tiết chuyến và nhà xe

- [ ] **TRIP-01** Xem nhà xe, tuyến, lịch trình và điểm đón hoặc trả.
- [ ] **TRIP-02** Xem loại xe, sơ đồ ghế, giá vé, tiện ích và chính sách hủy.
- [ ] **TRIP-03** Xem trang hoặc hồ sơ nhà xe, đánh giá, scorecard, tuyến tiêu biểu và điều khoản dịch vụ.

## 5. Đặt vé

- [ ] **BOOKING-01** Chọn điểm đón và điểm trả.
- [ ] **BOOKING-02** Chọn một hoặc nhiều ghế hoặc giường còn khả dụng; sơ đồ ghế có 4 trạng thái: trống, đang chọn, đang giữ, đã đặt; tối đa 10 ghế.
- [ ] **BOOKING-03** Giữ ghế trong 10 phút và hiển thị đồng hồ đếm ngược; tự động nhả ghế khi hết thời gian.
- [ ] **BOOKING-04** Nhập thông tin liên hệ và thông tin hành khách theo từng ghế.
- [ ] **BOOKING-05** Chọn nhanh hành khách từ danh sách đã lưu.
- [ ] **BOOKING-06** Nhập ghi chú cho booking khi cần.
- [ ] **BOOKING-07** Nhập mã giảm giá hoặc chọn voucher hợp lệ.
- [ ] **BOOKING-08** Hiển thị tổng tiền, tách riêng giá vé, phí và khoản giảm giá.

## 6. Thanh toán

- [ ] **PAYMENT-01** Thanh toán bằng VNPay.
- [ ] **PAYMENT-02** Thanh toán bằng MoMo.
- [ ] **PAYMENT-03** Quay lại ứng dụng qua app link hoặc deep link sau khi thanh toán.
- [ ] **PAYMENT-04** Hiển thị trạng thái chờ xác nhận thanh toán.
- [ ] **PAYMENT-05** Hiển thị kết quả thanh toán thành công, thất bại hoặc hết hạn.
- [ ] **PAYMENT-06** Cho phép thanh toán lại khi booking vẫn còn đủ điều kiện.

## 7. Vé điện tử và hành trình

- [ ] **TICKET-01** Xem “Vé của tôi” theo các tab Sắp tới, Đã đi, Đã hủy và Tất cả.
- [ ] **TICKET-02** Tìm vé theo mã vé hoặc tuyến.
- [ ] **TICKET-03** Xem chi tiết vé và mã QR.
- [ ] **TICKET-04** Xem thông tin chuyến, hành khách, thanh toán và điểm đón hoặc trả.
- [ ] **TICKET-05** Xem quy định lên xe và thông tin liên hệ nhà xe.
- [ ] **TICKET-06** Theo dõi các trạng thái vé `VALID`, `CHECKED_IN`, `USED`, `NO_SHOW`, `CANCELLED`, `REFUNDED`.
- [ ] **TICKET-07** In hoặc chia sẻ vé nếu được triển khai theo UI spec.

## 8. Hủy vé và hoàn tiền

- [ ] **REFUND-01** Hủy vé theo chính sách đã được lưu tại thời điểm booking.
- [ ] **REFUND-02** Xác minh lại bằng OTP trước thao tác hủy khi hệ thống yêu cầu.
- [ ] **REFUND-03** Hủy một phần vé trong booking có nhiều vé khi đủ điều kiện.
- [ ] **REFUND-04** Xem số tiền hoàn dự kiến và phí hủy.
- [ ] **REFUND-05** Theo dõi trạng thái hoàn tiền: `REQUESTED` (Đã yêu cầu), `PROCESSING` (Đang xử lý), `SUCCESS` (Thành công), `FAILED` (Lỗi), `REJECTED` (Bị từ chối).

## 9. Tra cứu vé dành cho khách vãng lai

- [ ] **GUEST-01** Nhập thông tin liên hệ hợp lệ để tra cứu booking hoặc vé.
- [ ] **GUEST-02** Nhận và xác minh OTP để tạo phiên tra cứu có thời hạn.
- [ ] **GUEST-03** Xem vé điện tử sau khi xác minh.
- [ ] **GUEST-04** Hủy vé hoặc yêu cầu hoàn tiền trong phạm vi booking hoặc vé đã xác minh.
- [ ] **GUEST-05** Tạo và theo dõi hỗ trợ hoặc khiếu nại trong phạm vi booking hoặc vé đã xác minh.

## 10. Hỗ trợ, khiếu nại và đánh giá

- [ ] **SUPPORT-01** Tạo support ticket hoặc khiếu nại.
- [ ] **SUPPORT-02** Chọn booking hoặc vé liên quan khi gửi yêu cầu.
- [ ] **SUPPORT-03** Theo dõi danh sách, chi tiết, dòng thời gian và trạng thái xử lý.
- [ ] **SUPPORT-04** Gửi phản hồi và đính kèm minh chứng.
- [ ] **SUPPORT-05** Gửi minh chứng khi khiếu nại được chuyển thành `DisputeCase`.
- [ ] **SUPPORT-06** Đánh giá chuyến đi hoặc nhà xe sau khi chuyến hoàn thành và vé hợp lệ.
- [ ] **SUPPORT-07** Xem danh sách “Đánh giá của tôi”.

## 11. Thông báo

- [ ] **NOTIFICATION-01** Nhận thông báo trong ứng dụng (in-app).
- [ ] **NOTIFICATION-02** Nhận push notification qua FCM trên Android và APNs trên iOS.
- [ ] **NOTIFICATION-03** Nhận thông báo qua email.
- [ ] **NOTIFICATION-04** Nhận thông báo cho các sự kiện đặt vé, thanh toán, phát vé, hủy vé, hoàn tiền, thay đổi hoặc hủy chuyến, hỗ trợ và dispute.
- [ ] **NOTIFICATION-05** Cấu hình notification preference cho các thông báo không bắt buộc.
- [ ] **NOTIFICATION-06** Không cho phép tắt hoàn toàn các thông báo bắt buộc về bảo mật, vé, thanh toán, đổi hoặc hủy chuyến và dispute.

## 12. Thành viên VXN Plus

- [ ] **LOYALTY-01** Tích điểm sau khi chuyến hoàn thành theo điều kiện chương trình.
- [ ] **LOYALTY-02** Xem hạng thành viên `BRONZE`, `SILVER`, `GOLD`, `PLATINUM`.
- [ ] **LOYALTY-03** Xem số điểm khả dụng và giá trị quy đổi ước tính.
- [ ] **LOYALTY-04** Xem số điểm cần để lên hạng tiếp theo.
- [ ] **LOYALTY-05** Xem hệ số tích điểm của từng hạng.
- [ ] **LOYALTY-06** Xem lịch sử giao dịch điểm.
- [ ] **LOYALTY-07** Theo dõi điểm sắp hết hạn và ngày hết hạn.
- [ ] **LOYALTY-08** Đổi điểm lấy voucher giảm giá.

## 13. Ví voucher

- [ ] **VOUCHER-01** Xem voucher theo các trạng thái Khả dụng, Đã dùng và Hết hạn.
- [ ] **VOUCHER-02** Lưu mã khuyến mãi công khai vào ví.
- [ ] **VOUCHER-03** Xem giá trị giảm, điều kiện áp dụng và hạn dùng.
- [ ] **VOUCHER-04** Nhận voucher từ việc đổi điểm VXN Plus.
- [ ] **VOUCHER-05** Chọn tối đa một voucher hoặc mã giảm giá cho mỗi booking.

## 14. Khám phá

- [ ] **EXPLORE-01** Xem danh sách bài viết hoặc cẩm nang đã xuất bản.
- [ ] **EXPLORE-02** Xem bài viết nổi bật.
- [ ] **EXPLORE-03** Lọc bài viết theo chuyên mục.
- [ ] **EXPLORE-04** Tìm bài viết theo từ khóa.
- [ ] **EXPLORE-05** Xem chi tiết bài viết và chia sẻ.
- [ ] **EXPLORE-06** Xem các bài viết liên quan cùng chuyên mục.
