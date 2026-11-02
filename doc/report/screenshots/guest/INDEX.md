# Mục lục minh chứng ảnh chụp màn hình ứng dụng Passenger Mobile (Trạng thái Khách)

Thư mục lưu trữ: `doc/report/screenshots/guest/`  
Đối tượng kiểm thử: Ứng dụng di động hành khách (`passenger_mobile` Flutter Android trên emulator-5554)  
Trạng thái tài khoản: **Khách vãng lai (Guest) — Chưa đăng nhập**  
Ngày thực hiện: **01/11/2026**

---

## 1. Bảng tổng hợp chi tiết các màn hình minh chứng (K01 – K43)

| Tên file | Giao diện | Nội dung minh chứng | Dữ liệu thật/mẫu | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| `K01-trang-chu.png` | Trang chủ (Khung trên) | Banner chào mừng, form tìm kiếm chuyến, dock bar điều hướng 5 tab ở trạng thái khách. | Dữ liệu thật (API) | Thanh dock hiển thị 5 mục: Khám phá, Mua vé, Trang chủ, Hành trình, Tài khoản. |
| `K02-trang-chu-tuyen-pho-bien.png` | Trang chủ (Cuộn giữa) | Mục banner ưu đãi nổi bật, danh sách thẻ tuyến đường phổ biến dạng card chữ nhật và khối Nhà xe nổi bật. | Dữ liệu thật (API/DB) | Khối tuyến phổ biến hiển thị ảnh thật, giá vé và số chuyến mỗi ngày. |
| `K03-trang-chu-nha-xe-bai-viet.png` | Trang chủ (Cuộn chân trang) | Danh sách đối tác nhà xe tiêu biểu, các bài viết cẩm nang du lịch và trạm hỗ trợ khách hàng. | Dữ liệu thật (API) | Footer cung cấp hotline hỗ trợ và các liên kết quy chế, trợ giúp. |
| `K04-tai-khoan-khach.png` | Tab Tài khoản | Giao diện tab Tài khoản ở trạng thái khách: thông báo "Chưa đăng nhập", nút Đăng nhập / Đăng ký, mục Tra cứu vé đã đặt, Hotline và Trung tâm trợ giúp. | Dữ liệu thật | Các tính năng yêu cầu hồ sơ (ví voucher, khách hàng thân thiết, điểm thưởng) được ẩn hoặc yêu cầu đăng nhập. |
| `K05-mua-ve-chua-tim.png` | Tab Mua vé (Mặc định) | Giao diện tab Mua vé khi vừa chuyển tab, hiển thị danh sách các chuyến xe sắp khởi hành trong 14 ngày tới. | Dữ liệu thật (API /trips) | Hiển thị 10 chuyến xe sắp chạy của các đối tác Phương Trang, Toàn Thắng, Sao Việt... |
| `K06-tim-theo-chuyen.png` | Tab Trang chủ / Mua vé | Form tìm kiếm theo chuyến: ô Điểm đi (TP. Hồ Chí Minh), Điểm đến (Lâm Đồng), Ngày đi (02/11/2026), Số lượng khách (1 khách), nút Tìm chuyến. | Dữ liệu thật | Form tìm chuyến trực quan với nút đảo chiều chuyến tiện lợi. |
| `K07-tim-theo-nha-xe.png` | Tab Trang chủ / Mua vé | Form tìm kiếm theo nhà xe: tab chuyển đổi "Theo nhà xe", chọn nhà xe đối tác và chọn tuyến đường do nhà xe đó khai thác. | Dữ liệu thật | Cho phép khách hàng tìm trực diện theo thương hiệu vận tải yêu thích. |
| `K08-bang-chon-nha-xe.png` | Modal chọn nhà xe | Bottom sheet danh sách nhà xe đối tác: An Anh Limousine, Chín Nghĩa, Hải Vân Express, Hoàng Long, Kumho Samco, Liên Hưng, Phương Trang, Sao Việt... | Dữ liệu thật (DB) | Kèm đánh giá sao, loại dịch vụ và logo chính thức của từng nhà xe. |
| `K09-bang-chon-tuyen-nha-xe.png` | Modal chọn tuyến của nhà xe | Danh sách các tuyến vận tải trực thuộc nhà xe đã chọn (ví dụ: An Anh Limousine tuyến Sài Gòn - Phan Rang, Ninh Thuận - Đà Lạt...). | Dữ liệu thật (DB) | Hiển thị đầy đủ điểm xuất phát và bến đến của tuyến đường. |
| `K10-bang-chon-diem-di.png` | Modal tìm & chọn điểm đi | Bottom sheet chọn điểm đi với thanh tìm kiếm trực quan và danh sách 34 tỉnh/thành phố chuẩn mới nhất (Hồ Chí Minh, Hà Nội, Đà Nẵng, Lâm Đồng...). | Dữ liệu thật (DB 34 tỉnh) | Hỗ trợ tìm kiếm thông minh địa danh hành chính mới và cũ. |
| `K11-bang-chon-diem-den.png` | Modal tìm & chọn điểm đến | Bottom sheet chọn điểm đến (chọn Lâm Đồng - Đà Lạt) sau khi tìm kiếm theo từ khóa. | Dữ liệu thật (DB 34 tỉnh) | Tự động loại trừ hoặc cảnh báo trùng lặp với điểm đi đã chọn. |
| `K12-bang-chon-ngay-di.png` | Dialog chọn ngày khởi hành | Lịch Material DatePicker trực quan cho phép khách chọn ngày khởi hành trong tương lai (02/11/2026). | Dữ liệu hệ thống | Khóa các ngày trong quá khứ, đánh dấu ngày hiện tại và hỗ trợ chọn nhanh. |
| `K13-bang-chon-so-khach.png` | Modal chọn số lượng khách | Bottom sheet chọn số lượng hành khách từ 1 đến 5 vé cho một lần đặt chỗ. | Dữ liệu hệ thống | Giao diện nút tăng/giảm số lượng trực quan kèm quy định trần số ghế. |
| `K14-ket-qua-tim-chuyen.png` | Danh sách kết quả tìm chuyến | Danh sách 14 chuyến xe TP. Hồ Chí Minh đi Lâm Đồng ngày 02/11/2026 kèm giá vé, giờ chạy, số chỗ trống, thanh công cụ Lọc, Sắp xếp và Đổi ngày. | Dữ liệu thật (API /trips/search) | Card chuyến đi hiển thị ảnh thật, đánh giá sao, điểm đón trả và tiện ích (Wifi, nước uống, rèm che). |
| `K15-bo-loc.png` | Modal bộ lọc chuyến | Bottom sheet bộ lọc đa tiêu chí: khoảng giá vé (slider), dạng chỗ (ghế ngồi/giường nằm/cabin), hạng xe (Limousine/thường), khung giờ khởi hành và tiện ích xe. | Dữ liệu hệ thống | Cho phép lọc kết hợp nhiều điều kiện cùng lúc để thu hẹp kết quả. |
| `K16-sap-xep.png` | Modal sắp xếp chuyến | Bottom sheet sắp xếp danh sách chuyến: Giờ khởi hành sớm nhất, Giờ khởi hành muộn nhất, Giá tăng dần, Giá giảm dần, Đánh giá cao nhất. | Dữ liệu hệ thống | Lựa chọn được áp dụng tức thì vào danh sách hiển thị chuyến xe. |
| `K17-doi-ngay.png` | Modal đổi ngày đi nhanh | Bottom sheet chọn nhanh các ngày kế tiếp hoặc lùi ngày để xem giá vé và chuyến xe của các ngày lân cận mà không cần tìm lại từ đầu. | Dữ liệu hệ thống | Kèm thông tin giá vé tham khảo theo từng ngày trong tuần. |
| `K18-chi-tiet-chuyen-phan-dau.png` | Chi tiết chuyến xe (Khung trên) | Ảnh xe thực tế, tên nhà xe Phương Trang (FUTA Bus Lines), giá vé 290.000đ, thời gian chạy 6h15, tiện ích trên xe, nút Chia sẻ chuyến đi. | Dữ liệu thật (DB /trips/:id) | Khách vãng lai xem chi tiết minh bạch thông tin trước khi giữ chỗ. |
| `K19-chi-tiet-chuyen-lich-trinh.png` | Chi tiết chuyến xe (Cuộn dưới) | Lộ trình chi tiết từng trạm dừng đón/trả, bản đồ dự kiến và chính sách hủy đổi vé theo mốc thời gian quy định của nhà xe. | Dữ liệu thật (DB) | Mốc hủy vé hoàn 90% (trước 24h), hoàn 50% (trước 4h), không hoàn (sát giờ chạy). |
| `K20-chia-se-chuyen.png` | Sheet chia sẻ hệ điều hành | Hộp thoại Native Android 16 System Share Sheet bung lên với link chia sẻ chi tiết chuyến đi qua Zalo, Messenger, Tin nhắn, Gmail... | Dữ liệu thật (Android Native) | Tạo deep link chuẩn giúp khách chia sẻ thông tin chuyến xe cho người thân. |
| `K21-so-do-ghe-chua-chon.png` | Sơ đồ ghế (Bước 1: Chọn chỗ) | Sơ đồ tầng dưới xe Giường nằm Limousine 34 phòng: trạng thái ghế trống (màu trắng), ghế đã bán/khóa (màu xám), nút chuyển tầng 1 / tầng 2. | Dữ liệu thật (DB sơ đồ xe) | Hiển thị rõ vị trí tài xế, cửa lên xuống và mã số từng giường nằm. |
| `K22-so-do-ghe-da-chon.png` | Sơ đồ ghế đã chọn 2 chỗ | Sơ đồ sau khi khách chọn 2 giường A01 và A02: 2 ghế đổi sang màu xanh thương hiệu, thanh tóm tắt hiện "2 chỗ: A01, A02 - 580.000 đ". | Dữ liệu thật | Ràng buộc kiểm tra số ghế tối đa và cập nhật tổng tiền tạm tính tự động. |
| `K23-bang-chon-diem-don.png` | Modal chọn điểm đón | Bottom sheet danh sách các điểm đón tại TP.HCM (Văn phòng Lê Hồng Phong 07:30, Bến xe Miền Đông mới 08:15...) kèm địa chỉ cụ thể. | Dữ liệu thật (DB lộ trình) | Khách chọn điểm đón phù hợp nhất trên cung đường di chuyển. |
| `K24-bang-chon-diem-tra.png` | Modal chọn điểm trả | Bottom sheet danh sách điểm trả tại Lâm Đồng (Ngã ba Liên Khương - Đức Trọng 13:45, Bến xe liên tỉnh Đà Lạt 14:15...) kèm giờ đến dự kiến. | Dữ liệu thật (DB lộ trình) | Khách chọn điểm trả thuận tiện trước khi chuyển sang bước điền thông tin. |
| `K25-thong-tin-hanh-khach.png` | Bước 2: Thông tin hành khách | Form điền thông tin liên hệ: Họ tên (Nguyen Van Khach), Email (guest.tester@vexenhanh.local), Số điện thoại (0912345678) và thông tin khách bổ sung A02. | Dữ liệu mẫu kiểm thử | Đồng hồ đếm ngược giữ chỗ 15 phút (05:57) hiển thị ở góc trên bên phải. |
| `K26-bang-chon-voucher.png` | Áp dụng mã khuyến mãi | Khối Ưu đãi sau khi nhập mã `VEXENHANH50` và bấm Áp dụng: thông báo "VEXENHANH50 đã áp dụng - Ưu đãi bạn mới giảm 15% tối đa 50.000đ · -50.000 đ", tạm tính giảm còn 530.000 đ. | Dữ liệu thật (API /promotions) | Khách vãng lai áp dụng thành công mã khuyến mãi nền tảng mà không cần đăng nhập. |
| `K27-xac-nhan-dat-ve.png` | Màn hình Xác nhận đặt vé | Xem lại toàn bộ thông tin đơn hàng trước thanh toán: Chuyến Phương Trang 07:30 - 13:45, Chỗ A01 & A02, Điểm đón/trả, Tổng thanh toán 530.000 đ. | Dữ liệu thật (DB/Session) | Đảm bảo khách kiểm tra kỹ mọi chi tiết hành trình trước khi tạo thanh toán. |
| `K28-dieu-khoan-chinh-sach.png` | Bottom sheet Điều khoản & Chính sách | Nội dung đầy đủ quy chế hoạt động sàn, chính sách bảo vệ dữ liệu cá nhân, cơ chế giải quyết tranh chấp và hướng dẫn đi xe bằng vé điện tử QR. | Dữ liệu hệ thống | Mục 1 được bung mở chi tiết về sứ mệnh và cam kết dịch vụ minh bạch. |
| `K29-chon-phuong-thuc-thanh-toan.png` | Bước 3: Phương thức thanh toán | Đơn hàng `VXNFYBUNR` được tạo, hiển thị danh sách cổng thanh toán: Chuyển khoản VietQR qua payOS, Ví MoMo, Cổng VNPay và Cổng thanh toán thử (demo). | Dữ liệu thật (DB Booking) | Mỗi phương thức có logo nhận diện riêng biệt và mô tả chi tiết. |
| `K30-thanh-toan-sandbox.png` | Cổng thanh toán thử (Sandbox Web) | Giao diện sandbox trình duyệt web mô phỏng: CỔNG THỬ - không có tiền thật, đơn hàng VXNFYBUNR 530.000 đ, nút "Thanh toán thành công" và "Thanh toán thất bại". | Dữ liệu thử nghiệm (Sandbox) | Môi trường thử nghiệm an toàn phục vụ nghiệm thu không phát sinh giao dịch thật. |
| `K31-hoan-tat-ve-qr.png` | Bước 4: Hoàn tất đặt vé & Vé QR | Giao diện vé điện tử chính thức: mã QR lên xe sắc nét, thông tin chuyến đi, chỗ ngồi A01, tên khách Nguyen Van Khach, nút xem "Tất cả vé (2) >". | Dữ liệu thật (DB Ticket/QR) | Mã QR được sinh mã hóa phục vụ máy soát vé của tiếp viên / phụ xe. |
| `K32-bang-chon-ve-nhieu-khach.png` | Bảng chọn vé nhiều khách | Bottom sheet danh sách vé điện tử trong cùng một đơn đặt chỗ: Vé A01 (Nguyen Van Khach) và Vé A02 (Nguyen Van Khach) kèm ô tìm kiếm vé nhanh. | Dữ liệu thật (DB 2 vé) | Cho phép người đặt chuyển đổi qua lại giữa vé của các thành viên trong đoàn. |
| `K33-tab-hanh-trinh-guest.png` | Tab Hành trình (Khách vãng lai) | Giao diện mặc định tab Hành trình khi chưa đăng nhập: form "Tra cứu vé khách vãng lai", ô nhập Email liên hệ, ghi chú xác minh OTP và nút "Nhận mã OTP". | Dữ liệu thật | Đảm bảo tính riêng tư: chỉ người sở hữu email mới nhận mã tra cứu được vé. |
| `K34-otp-tra-cuu.png` | Màn hình Xác thực tra cứu vé | Form nhập 6 số OTP gửi tới email `g***@vexenhanh.local`, đồng hồ đếm ngược hết hạn 5 phút và nút "Gửi lại sau 56s". | Dữ liệu bảo mật (Redis OTP) | Cơ chế bảo vệ rate limit phòng chống brute force mã tra cứu của khách. |
| `K35-ket-qua-tra-cuu-chi-tiet-ve.png` | Kết quả tra cứu chi tiết vé khách | Chi tiết đơn `VXNFYBUNR` sau khi xác thực OTP thành công: vé điện tử A01 kèm QR `VXNFYBUNR-01`, hành trình, thông tin thanh toán DEMO, chính sách hoàn hủy. | Dữ liệu thật (DB /guest lookup) | Khách vãng lai xem được toàn bộ quyền lợi vé như người dùng có tài khoản. |
| `K36-modal-huy-ve-ly-do.png` | Modal yêu cầu hủy vé | Bottom sheet yêu cầu hủy vé: thông tin vé hủy A01, bảng tính tiền hoàn dự kiến (238.500 đ sau trừ 10% phí quy định) và danh sách dropdown lý do hủy vé bung mở. | Dữ liệu thật (Quy định hoàn vé) | Minh bạch số tiền hoàn về cổng thanh toán ban đầu của khách trước khi xác nhận. |
| `K37-xac-nhan-huy-ve.png` | Modal xác nhận hủy vé | Dialog cảnh báo xác nhận cuối cùng: "Vé đã hủy không khôi phục được và chỗ sẽ được mở bán lại", số tiền hoàn 238.500 đ, nút Quay lại và nút Xác nhận hủy vé. | Dữ liệu hệ thống | Phòng ngừa thao tác bấm nhầm dẫn đến mất vé của hành khách. |
| `K38-ket-qua-huy-ve.png` | Thông báo hủy vé thành công | Modal kết quả "Bạn đã hủy vé thành công", mã hoàn tiền `RFDFRVM37BE4ZH3`, tag Đang xử lý, thẻ vé phía sau lập tức đổi sang "Đã hủy" và QR bị vô hiệu hóa. | Dữ liệu thật (DB Refund) | Cập nhật đồng bộ trạng thái đơn hàng trên toàn hệ sinh thái và giải phóng ghế. |
| `K39-yeu-cau-dang-nhap-don-account.png` | Màn hình yêu cầu đăng nhập | Màn hình đăng nhập tài khoản xuất hiện khi khách truy cập chức năng thành viên (nhập email nhận mã xác minh, đăng nhập qua Google, Facebook, Apple). | Dữ liệu hệ thống | Hướng dẫn khách vãng lai nâng cấp lên tài khoản để quản lý hành trình dài hạn. |
| `K40-tab-kham-pha.png` | Tab Khám phá hành trình | Giao diện tab Khám phá: thanh tìm kiếm bài viết, các chip chuyên mục (Tất cả, Cẩm nang, Mẹo du lịch), bài viết nổi bật cập nhật danh mục 34 tỉnh và bài mới nhất. | Dữ liệu thật (API Explore) | Cung cấp thông tin giá trị gia tăng giúp khách tra cứu cẩm nang đi lại. |
| `K41-chuyen-muc-bai-viet.png` | Tìm kiếm & lọc bài viết | Giao diện tab Khám phá sau khi nhập từ khóa "Ben xe" trên thanh tìm kiếm và hiển thị danh sách bài viết lọc theo chủ đề bến xe, tỉnh thành. | Dữ liệu thật | Hỗ trợ tìm kiếm bài viết tức thì theo từ khóa không dấu hoặc có dấu. |
| `K42-chi-tiet-bai-viet.png` | Chi tiết bài viết cẩm nang | Trang đọc bài viết chi tiết, cuộn xuống chân bài hiển thị mẹo hữu ích và khối kêu gọi hành động "Sẵn sàng lên đường? Tìm chuyến đi >" dẫn thẳng về form tìm vé. | Dữ liệu thật | Gắn kết liền mạch giữa trải nghiệm đọc cẩm nang và đặt vé xe thực tế. |
| `K43-faq-cau-hoi-mo.png` | Trung tâm trợ giúp (FAQ) | Bottom sheet Câu hỏi thường gặp với câu hỏi "Thời gian giữ chỗ (Seat Hold) khi đặt vé trực tuyến là bao lâu?" được bung mở chi tiết quy định giữ chỗ 15 phút. | Dữ liệu thật (FaqLoader) | Giải đáp nhanh các băn khoăn phổ biến của khách hàng 24/7. |

---

## 2. Thống kê theo phân nhóm chức năng

| Nhóm chức năng | Mã ảnh | Số lượng ảnh | Trạng thái kiểm thử |
| :--- | :--- | :---: | :--- |
| **Nhóm A: Trang chủ & Điều hướng khách** | `K01` – `K04` | 4 | Đã hoàn thành 100%, đúng giao diện khách vãng lai. |
| **Nhóm B: Tìm và xem chuyến xe** | `K05` – `K20` | 16 | Đã hoàn thành 100%, tìm theo tuyến/nhà xe, lọc, đổi ngày, chi tiết chuyến, share sheet. |
| **Nhóm C: Đặt vé của khách** | `K21` – `K32` | 12 | Đã hoàn thành 100%, chọn ghế, đón/trả, thông tin khách, voucher, điều khoản, thanh toán demo, QR vé, nhiều khách. |
| **Nhóm D: Tra cứu và quản lý vé khách** | `K33` – `K39` | 7 | Đã hoàn thành 100%, tra cứu email + OTP, chi tiết vé, quy trình hủy vé hoàn tiền, yêu cầu đăng nhập. |
| **Nhóm E: Nội dung và hỗ trợ khách hàng** | `K40` – `K43` | 4 | Đã hoàn thành 100%, tab Khám phá, tìm bài viết, chi tiết bài cẩm nang, FAQ bung câu trả lời. |
| **TỔNG CỘNG** | `K01` – `K43` | **43** | **Đầy đủ 100% minh chứng theo yêu cầu.** |

---

## 3. Quy chuẩn kỹ thuật minh chứng
- **Độ phân giải**: Chuẩn thiết bị Pixel 6 Android 16 (1080 x 2400 pixels), ảnh PNG không nén mất chi tiết.
- **Tính toàn vẹn**: Toàn bộ thao tác thực hiện trực tiếp trên môi trường máy ảo `emulator-5554` kết nối Backend NestJS và cơ sở dữ liệu thật.
- **Bảo mật dữ liệu**: Email hành khách và mã OTP tuân thủ quy tắc ẩn thông tin PII (`g***@vexenhanh.local`).
