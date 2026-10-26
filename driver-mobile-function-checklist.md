# Checklist công việc giao diện tài xế Vé Xe Nhanh

Checklist này tổng hợp **66 hạng mục** của phần giao diện tài xế trong ứng dụng `employee_mobile`, trình bày theo nhóm chức năng tương tự checklist ứng dụng hành khách.

**Phần phụ trách:** Giao diện tài xế — Flutter.

**Tiến độ giao diện và bản mẫu:** **40 / 66 hạng mục đã kiểm tra trong phạm vi ghi dưới đây.**

**Ngày cập nhật:** 25/10/2026.

**Quy ước kiểm tra:**

- `[x]`: Đã có giao diện hoặc thao tác với dữ liệu mẫu và đã có bằng chứng kiểm tra bằng widget test, phân tích mã hoặc bản dựng web, tùy hạng mục.
- `[ ]`: Chưa làm xong, mới có một phần, hoặc chưa đủ bằng chứng xác minh.
- Các dấu `[x]` **không đồng nghĩa chức năng đã kết nối máy chủ hoặc chạy hoàn chỉnh trên điện thoại thật**. Đây là checklist phần giao diện; không phải xác nhận hoàn tất hệ thống mobile v1.
- Các màn bổ sung theo Figma vẫn đang trong đợt đối chiếu trực quan. Không đánh dấu hoàn tất việc khớp toàn bộ thiết kế khi chưa rà soát hết.

**Nguồn đối chiếu:** [Figma — Giao diện Tài Xế](https://www.figma.com/design/6c81q3DdHVS0anfDw2sVVj/UI-UX?node-id=1484-3742), mã nguồn tại `apps/employee_mobile/lib/`, kiểm thử tại `apps/employee_mobile/test/` và hướng dẫn trong `apps/employee_mobile/README.md`.

## 1. Đăng nhập tài xế

- [x] **AUTH-01** Hiển thị màn đăng nhập nhân viên với logo, minh họa, tên đăng nhập và mật khẩu.
- [x] **AUTH-02** Kiểm tra bỏ trống tên đăng nhập hoặc mật khẩu; chỉ thực hiện xác nhận khi kéo đủ thanh đăng nhập.
- [x] **AUTH-03** Mở phiên xem thử và thông báo rõ việc sử dụng dữ liệu mẫu.
- [ ] **AUTH-04** Kết nối xác thực tài khoản do nhà xe cấp và hiển thị lỗi đăng nhập thực tế.
- [ ] **AUTH-05** Lưu token an toàn, khôi phục phiên và xử lý phiên hết hạn hoặc bị thu hồi.
- [ ] **AUTH-06** Xác minh luồng đăng xuất và đăng nhập lại với tài khoản thật trên điện thoại.

## 2. Chuyến của tôi

- [x] **ASSIGN-01** Hiển thị danh sách chuyến mẫu được phân công, phân biệt chuyến gần nhất và chuyến tiếp theo.
- [x] **ASSIGN-02** Đổi ngày xem chuyến, giữ ngày đã chọn khi chuyển giữa mục Chuyến và Cá nhân.
- [x] **ASSIGN-03** Hiển thị mã chuyến, tuyến, giờ đi, biển số, số khách và trạng thái trên thẻ chuyến.
- [x] **ASSIGN-04** Có giao diện chuyến đang tải, chưa có chuyến và tải thất bại theo thiết kế cập nhật.
- [ ] **ASSIGN-05** Lấy danh sách chuyến từ API và xử lý tải lại bằng dữ liệu thực tế.
- [ ] **ASSIGN-06** Đối chiếu trực quan đầy đủ các trạng thái tải, trống, lỗi và đổi ngày trên thiết bị mobile.

## 3. Chi tiết chuyến và điều hướng

- [x] **TRIP-01** Hiển thị mã chuyến, ngày đi, giờ khởi hành và trạng thái chuyến.
- [x] **TRIP-02** Hiển thị điểm đi, điểm đến và bến đón hoặc trả theo chuyến được chọn.
- [x] **TRIP-03** Hiển thị thông tin phương tiện và ghi chú vận hành của từng chuyến mẫu.
- [x] **TRIP-04** Mở danh sách khách, vận hành hoặc báo sự cố từ màn chi tiết chuyến.
- [x] **TRIP-05** Có giao diện chặn xem chuyến ngoài phạm vi phân công trong bản mẫu.
- [ ] **TRIP-06** Kiểm tra quyền phân công thực tế qua API và xử lý khi quyền truy cập thay đổi trong phiên.

## 4. Danh sách hành khách

- [x] **MANIFEST-01** Hiển thị ghế, tên khách, số điện thoại đã che, mã vé và trạng thái lên xe.
- [x] **MANIFEST-02** Tìm khách theo tên, mã vé hoặc số điện thoại được phép; có thao tác xóa từ khóa.
- [x] **MANIFEST-03** Lọc Tất cả, Chưa lên và Đã lên; kết hợp bộ lọc với từ khóa tìm kiếm.
- [x] **MANIFEST-04** Mở vé của khách và cập nhật số khách chưa lên khi quay lại sau xác nhận mẫu.
- [ ] **MANIFEST-05** Kết nối tải manifest và kéo làm mới từ máy chủ; xử lý khi dữ liệu thay đổi từ thiết bị khác.
- [ ] **MANIFEST-06** Rà soát toàn bộ màn danh sách trống, không tìm thấy, bàn phím và cuộn danh sách theo Figma mới.

## 5. Quét, nhập mã và đối chiếu vé

- [x] **TICKET-01** Nhập mã vé, chuẩn hóa khoảng trắng và chữ hoa, rồi mở kết quả đối chiếu trong dữ liệu mẫu.
- [x] **TICKET-02** Có màn không tìm thấy vé, sai chuyến, đã hủy và hoàn tiền; không cho xác nhận lên xe ở các kết quả này.
- [x] **TICKET-03** Có màn lên xe thành công với thông tin vé, thời điểm soát và tiến độ số khách động; tránh xác nhận trùng trong phiên mẫu.
- [ ] **TICKET-04** Kết nối camera quét QR, xin quyền camera, điều khiển đèn pin và xử lý quyền bị từ chối.
- [ ] **TICKET-05** Xác minh vé, xác nhận lên xe và chặn trùng bằng API; đồng bộ kết quả giữa nhiều thiết bị.
- [ ] **TICKET-06** Xác minh trạng thái mất kết nối và thử lại bằng mạng thật; không xác nhận vé khi chưa được máy chủ chấp thuận.

## 6. Cập nhật trạng thái hành khách

- [x] **PASSENGER-01** Hiển thị màn Cập nhật khách với thông tin ghế, tên, số đã che và trạng thái hiện tại.
- [x] **PASSENGER-02** Chọn Chưa lên, Vắng mặt hoặc Cần xử lý và lưu ghi chú trong phiên xem thử.
- [x] **PASSENGER-03** Chỉ cho chọn vắng mặt sau khi bắt đầu đón khách; giữ trạng thái khách đã lên xe trong bản mẫu.
- [ ] **PASSENGER-04** Kết nối API cập nhật trạng thái và ghi chú theo quyền của tài xế.
- [ ] **PASSENGER-05** Xử lý đang lưu, lưu thất bại hoặc xung đột cập nhật hành khách từ thiết bị khác.
- [ ] **PASSENGER-06** Kiểm tra luồng cập nhật khách từ đầu đến cuối trên điện thoại và đối chiếu lại cách chọn trạng thái với Figma.

## 7. Vận hành chuyến

- [x] **OPERATE-01** Chuyển lần lượt qua Đón khách, Khởi hành, Đang chạy và Hoàn thành trong dữ liệu mẫu.
- [x] **OPERATE-02** Có trạng thái chờ cập nhật; khi lỗi mẫu, giữ trạng thái cũ và cho thử cập nhật lại.
- [x] **OPERATE-03** Lưu lịch sử mốc vận hành trong phiên, giữ lại khi đóng và mở màn Vận hành.
- [x] **OPERATE-04** Hiển thị chuyến đã kết thúc và dừng thao tác chuyển trạng thái khi hoàn thành.
- [ ] **OPERATE-05** Kết nối API vận hành, xử lý quyền tài xế và dữ liệu trạng thái từ máy chủ.
- [ ] **OPERATE-06** Xác minh toàn bộ trạng thái vận hành với Figma và kiểm tra kết quả sau khi mở lại ứng dụng.

## 8. Nhật trình và kiểm tra xe

- [x] **JOURNAL-01** Có biểu mẫu nhật trình điểm dừng: thời gian, địa điểm, tình trạng xe, độ trễ và ghi chú.
- [x] **JOURNAL-02** Có loại nhật trình Kiểm tra xe; ẩn độ trễ và lưu địa điểm kiểm tra trong dữ liệu mẫu.
- [x] **JOURNAL-03** Mở chi tiết nhật trình đã lưu và hiển thị nội dung đã nhập trong phiên.
- [x] **JOURNAL-04** Có tình huống lưu thất bại; giữ nội dung để chỉnh sửa và thử lưu lại mà không tạo bản ghi trùng.
- [ ] **JOURNAL-05** Đồng bộ nhật trình với API, lưu hàng đợi bền vững nếu được hỗ trợ và xác minh trạng thái chờ gửi hoặc đã gửi.
- [ ] **JOURNAL-06** Hoàn thiện đối chiếu mọi màn nhật trình, gồm chưa tải được chi tiết, chưa đồng bộ và kiểm tra xe.

## 9. Báo sự cố

- [x] **INCIDENT-01** Hiển thị biểu mẫu loại sự cố, mức độ, thời gian, vị trí, mô tả và khu vực minh chứng.
- [x] **INCIDENT-02** Kiểm tra mô tả bắt buộc trước khi thực hiện thao tác gửi mẫu.
- [x] **INCIDENT-03** Có tình huống gửi thất bại và gửi lại trong bản mẫu.
- [ ] **INCIDENT-04** Chọn hoặc chụp ảnh minh chứng thật, kiểm tra quyền và tải ảnh qua dịch vụ được phê duyệt.
- [ ] **INCIDENT-05** Gửi báo cáo bằng API và hiển thị kết quả, mã báo cáo hoặc trạng thái xử lý thực tế.
- [ ] **INCIDENT-06** Xác minh nội dung biểu mẫu được giữ khi lỗi, điều hướng quay lại và bố cục trên điện thoại.

## 10. Cá nhân, thiết bị và hỗ trợ nhà xe

- [x] **PROFILE-01** Hiển thị thẻ nhân viên, nhà xe, vai trò tài xế và tên đăng nhập.
- [x] **PROFILE-02** Chuyển giao diện sáng hoặc tối trong phiên xem thử.
- [x] **PROFILE-03** Có danh sách thiết bị mẫu, xác nhận thu hồi hoặc đăng xuất, hủy xác nhận và trạng thái chỉ còn thiết bị hiện tại.
- [x] **PROFILE-04** Có màn liên hệ nhà xe, email hỗ trợ, chưa có liên hệ và thông báo không mở được email.
- [ ] **PROFILE-05** Tải hồ sơ hoặc phiên từ API, thu hồi phiên thật, mở ứng dụng email và lưu tùy chọn giao diện.
- [ ] **PROFILE-06** Đối chiếu đầy đủ các màn cá nhân sáng/tối, hộp xác nhận và trạng thái hỗ trợ trên mobile.

## 11. Kiểm thử và bàn giao

- [x] **QA-01** Chạy `flutter analyze` cho phiên bản mã đã kiểm tra; không có lỗi hoặc cảnh báo phân tích mã tại lần chạy gần nhất.
- [x] **QA-02** Chạy bộ widget test; lần kiểm tra gần nhất có 26 kiểm thử đạt.
- [x] **QA-03** Dựng bản web của ứng dụng chính và trang đối chiếu các trạng thái mới.
- [ ] **QA-04** Hoàn tất rà soát trực quan toàn bộ màn theo Figma mới và ghi lại các điểm chưa khớp.
- [ ] **QA-05** Build và kiểm thử trên Android; xác minh iOS khi có môi trường macOS/Xcode phù hợp.
- [ ] **QA-06** Review độc lập khi được yêu cầu, kiểm tra lại thay đổi cuối cùng và commit/push phiên bản cập nhật sau khi được yêu cầu.

## Thứ tự công việc tiếp theo

1. Khi chuyển sang tích hợp chức năng thật: làm xác thực, phân công, manifest và kiểm tra vé trước; sau đó trạng thái khách, vận hành, nhật trình, sự cố và quản lý phiên. Đối chiếu hợp đồng API trước khi triển khai.
2. Chạy lại kiểm thử, kiểm tra bản dựng và bàn giao phiên bản đã được xác minh; commit/push khi được yêu cầu.

Checklist chỉ theo dõi phần tài xế đang thực hiện; không đưa chức năng đặt vé, thanh toán, voucher hoặc tích điểm của hành khách vào phần việc này.
