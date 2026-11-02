# Đề xuất Chương 4 và danh sách giao diện cần chụp — Passenger Mobile

Ngày đối chiếu mã nguồn: 01/11/2026. Phạm vi: ứng dụng Flutter `apps/passenger_mobile`, các package Dart phục vụ ứng dụng và hành vi kết nối API của ứng dụng. Đây là đề cương báo cáo và kế hoạch chụp ảnh; chưa phải biên bản chạy thử hoặc xác nhận tất cả chức năng đã hoạt động trên thiết bị.

## 1. Thống nhất cách trình bày chương

Tên chương: **CHƯƠNG 4. XÂY DỰNG VÀ KIỂM THỬ ỨNG DỤNG**. Đổi các số `1.x` trong bản nháp thành `4.x`.

Giữ các phần 4.1, 4.2, 4.4 và 4.5 của bản nháp. Tầng backend chỉ cần trình bày đến mức giải thích hợp đồng OpenAPI, dữ liệu trả về và cách ứng dụng gọi API; phần triển khai giao diện, xử lý trạng thái, điều hướng và tương tác thiết bị là trọng tâm của môn học.

Mỗi chức năng ở 4.3 nên có: mục đích và người dùng được sử dụng; giao diện; luồng thao tác; cách Flutter xử lý trạng thái, gọi API và điều hướng; kết quả thực hiện kèm trường hợp lỗi tiêu biểu. Chỉ mô tả mức đã triển khai và có bằng chứng tương ứng.

## 2. Đề cương thay thế mục 4.3

### 4.3. Xây dựng các chức năng chính của ứng dụng hành khách

#### 4.3.1. Khởi động, Trang chủ và điều hướng theo trạng thái đăng nhập

- Splash/hoạt ảnh mở đầu; tiếp tục sử dụng với tư cách khách hoặc xác thực tài khoản.
- Năm tab Khám phá, Mua vé, Trang chủ, Hành trình và Tài khoản; khác biệt giữa khách và thành viên.
- Trang chủ: biểu mẫu tìm chuyến, tuyến phổ biến, nhà xe nổi bật, ưu đãi, bài viết và hỗ trợ.

#### 4.3.2. Đăng ký, đăng nhập bằng email OTP và Google

- Nhập email, yêu cầu OTP, xác minh, gửi lại mã và sửa email; xử lý dữ liệu không hợp lệ.
- Đăng nhập Google; hoàn thiện hồ sơ khi chưa có họ tên; lưu phiên thông qua package dùng chung.
- Phân biệt OTP đăng nhập và OTP tra cứu vé của khách. Facebook/Apple hiện chỉ có nút giao diện, chưa có luồng tích hợp tương đương Google.

#### 4.3.3. Quản lý hồ sơ, phiên đăng nhập và đăng xuất

- Tổng quan tài khoản; xem và cập nhật họ tên, số điện thoại, ngày sinh; hiển thị email và thông tin hồ sơ.
- Giao diện phiên đăng nhập và hộp xác nhận đăng xuất thiết bị; ghi rõ danh sách này hiện dùng dữ liệu cục bộ.
- Đăng xuất tài khoản đang dùng, gỡ đăng ký push và xóa token theo luồng trong ứng dụng.

#### 4.3.4. Tìm kiếm, lọc và sắp xếp chuyến xe

- Tìm theo chuyến hoặc theo nhà xe; chọn điểm đi, điểm đến, ngày đi, số hành khách, nhà xe và tuyến.
- Xem các chuyến sắp chạy khi chưa nhập điều kiện; hiển thị kết quả sau tìm kiếm.
- Bộ lọc, sắp xếp, thay đổi ngày và sửa điều kiện; trạng thái đang tải, không có kết quả và lỗi tải dữ liệu.

#### 4.3.5. Xem chi tiết và chia sẻ thông tin chuyến xe

- Nhà xe, loại xe, giá/chặng, thời gian, lịch trình, điểm đón trả, tiện ích, chính sách hủy và lưu ý.
- Mở giao diện chia sẻ của hệ điều hành; chuyển sang bước chọn chỗ.

#### 4.3.6. Chọn ghế, điểm đón trả và giữ chỗ

- Sơ đồ ghế và trạng thái ghế; chọn ghế; đổi điểm đón/trả và cập nhật giá theo chặng.
- Gửi yêu cầu giữ chỗ trước khi nhập thông tin; xử lý xung đột ghế, thời hạn giữ chỗ và quay lại chọn chỗ.

#### 4.3.7. Nhập thông tin và quản lý hành khách đã lưu

- Thông tin liên hệ và thông tin hành khách theo từng ghế; kiểm tra biểu mẫu.
- Thành viên: danh sách hành khách đã lưu, thêm/sửa/xóa, chọn người đã lưu để điền vào đơn.
- Khách vẫn nhập thông tin và đặt vé; không có tiện ích danh sách hành khách cá nhân đã lưu.

#### 4.3.8. Xác nhận đặt vé và thanh toán trực tuyến

- Tổng hợp hành trình, hành khách, các khoản tiền, mã ưu đãi, điều khoản và chính sách; tạo đơn.
- Màn chọn phương thức tách với màn thực hiện thanh toán QR/cổng thanh toán.
- Các lựa chọn có trong mã: payOS, MoMo, VNPay, DEMO; phương thức dùng được phụ thuộc cấu hình phía dịch vụ.
- Theo dõi trạng thái thanh toán, quay lại từ ứng dụng ngoài, thử lại, hết hạn và đối soát; chỉ hiển thị hoàn tất khi API xác nhận đơn, thanh toán và vé đã phát hành.

#### 4.3.9. Hiển thị vé điện tử QR và quản lý lịch sử đặt vé

- Hoàn tất đặt vé, QR và thông tin của từng vé; bảng chọn vé khi đơn có nhiều hành khách.
- Thành viên: Hành trình → Vé của tôi → chi tiết đơn/vé.
- Sự khác nhau ở nút kết thúc: khách về Trang chủ; thành viên chuyển sang Hành trình.

#### 4.3.10. Tra cứu vé dành cho hành khách chưa đăng nhập

- Email liên hệ → OTP tra cứu → kết quả → chi tiết vé của đơn khách.
- Gửi lại OTP, đổi email/tra cứu lại và kết quả rỗng.
- Nếu đơn được đặt bằng tài khoản: ứng dụng yêu cầu đăng nhập để xem/hủy; OTP tra cứu không tạo phiên đăng nhập tài khoản.

#### 4.3.11. Hủy vé và hiển thị thông tin hoàn tiền

- Chọn vé cần hủy; lấy điều kiện và số tiền hoàn dự kiến; nhập/chọn lý do, xác nhận hủy.
- Hiển thị kết quả hủy và cập nhật vé; thông tin/trạng thái hoàn tiền do API trả về.
- Không mô tả ứng dụng tự xử lý nghiệp vụ chi trả; chức năng trên mobile là yêu cầu hủy và hiển thị kết quả.

#### 4.3.12. Xem và gửi đánh giá chuyến đi

- Giao diện chuyến chờ đánh giá, đánh giá đã gửi và biểu mẫu số sao/nhận xét.
- Hàm gửi đánh giá đã nối API; danh sách hiện dùng fixture ở debug và trả rỗng ở release do chưa có endpoint danh sách cho Passenger.

#### 4.3.13. Khám phá, tìm kiếm và đọc bài viết

- Danh sách bài viết, chuyên mục, tìm theo từ khóa, nội dung chi tiết.
- Mở bài từ Trang chủ/Khám phá; nút Tìm chuyến đi đóng bài và chuyển sang Mua vé.

#### 4.3.14. Khuyến mãi và ví voucher cá nhân

- Hiển thị ưu đãi công khai, sao chép mã và áp mã khi đặt vé.
- Thành viên: lưu mã vào ví, xem voucher khả dụng, chọn voucher từ ví khi đặt vé.
- Khách có thể nhập mã giảm giá; không có ví voucher cá nhân.

#### 4.3.15. Thành viên VXN Plus và lịch sử điểm

- Thẻ thành viên/tổng quan điểm trong Tài khoản; lịch sử giao dịch điểm, lọc loại giao dịch và thời gian.
- Phân biệt xem lịch sử đổi điểm với thực hiện đổi điểm: chưa có màn đổi điểm lấy voucher riêng được nối trong ứng dụng hiện tại.
- Lịch sử điểm có gọi API, nhưng debug có thể dùng dữ liệu mẫu khi API không có giao dịch.

#### 4.3.16. Thông báo và hỗ trợ hành khách

- Đăng ký thiết bị nhận FCM sau đăng nhập; nhận thông báo khi app đang mở; chạm thông báo để mở tab Hành trình.
- Giao diện bật/tắt nhóm thông báo hiện lưu state cục bộ; phân biệt với luồng nhận push đã có mã tích hợp.
- FAQ/Trung tâm trợ giúp và gọi tổng đài; nút góp ý ở Trang chủ hiện chỉ hiện thông báo hướng dẫn, chưa mở màn gửi yêu cầu hỗ trợ riêng.

## 3. Quy ước danh sách ảnh

- **Khách:** chưa đăng nhập tài khoản. Xác minh OTP tra cứu vẫn thuộc trạng thái khách.
- **Thành viên:** đã đăng nhập tài khoản hành khách.
- **Dùng chung:** chức năng có ở cả hai trạng thái. Chụp một bộ đại diện nếu giao diện giống nhau; chụp hai phiên bản ở những dòng ghi rõ khác biệt.
- Một dòng có thể cần nhiều ảnh hoặc một hình ghép, đặc biệt với màn dài và các bảng chọn. Bảng bật lên không cần gọi là màn hình độc lập.
- Đây là danh sách giao diện/trạng thái cần lấy minh chứng, không phải số lượng màn hình độc lập của ứng dụng.

## 4. Giao diện mở đầu và xác thực

| Mã | Cần chụp | Trạng thái / nội dung minh chứng |
| --- | --- | --- |
| A01 | Splash/hoạt ảnh mở đầu | Trước khi vào ứng dụng; một ảnh đại diện nếu đưa vào báo cáo. |
| A02 | Đăng nhập / Đăng ký | Ô email, nút gửi OTP, Google và Tiếp tục với khách. |
| A03 | Xác nhận email | Ô OTP, email đã che, đếm thời gian/gửi lại mã và sửa email. |
| A04 | Hoàn thiện hồ sơ lần đầu | Sau xác thực, trước khi vào Trang chủ thành viên. |
| A05 | Chọn tài khoản Google | Ảnh bổ sung; đây là giao diện nhà cung cấp/hệ điều hành. |

## 5. Giao diện dùng được khi là khách và khi đã đăng nhập

| Mã | Cần chụp | Cách chụp / khác biệt cần thể hiện |
| --- | --- | --- |
| C01 | Tab Mua vé khi chưa tìm | Danh sách chuyến sắp chạy. |
| C02 | Tìm theo chuyến và theo nhà xe | Chụp hai chế độ; có thể ghép thành một hình so sánh. |
| C03 | Các bảng chọn điều kiện tìm | Điểm đi/đến, ngày đi, số khách, nhà xe, tuyến theo nhà xe; mỗi loại bảng một ảnh đại diện. |
| C04 | Kết quả tìm chuyến | Thấy điều kiện và các thẻ chuyến; thêm phần kết quả trong tab Mua vé nếu cần giải thích khác màn kết quả mở từ Trang chủ. |
| C05 | Bộ lọc, sắp xếp, sửa điều kiện | Chụp các bảng riêng; chọn tiêu chí để người đọc thấy tác dụng. |
| C06 | Chi tiết chuyến | Phần đầu và các phần lịch trình, tiện ích, chính sách ở phía dưới; màn dài nên lấy 2–3 ảnh. |
| C07 | Chia sẻ chuyến đi | Ảnh bổ sung của bảng chia sẻ hệ điều hành. |
| C08 | Sơ đồ ghế | Trước khi chọn và sau khi chọn; thấy phân biệt ghế khả dụng/không khả dụng/đang chọn theo giao diện. |
| C09 | Bảng chọn điểm đón/trả | Một ảnh điểm đón và một ảnh điểm trả khi cần chứng minh đủ hai thao tác. |
| C10 | Thông tin hành khách | Chụp cả khách và thành viên; bản thành viên cần thấy nút chọn hành khách đã lưu. |
| C11 | Áp mã giảm giá | Mã đã áp dụng và tổng tiền thay đổi; lỗi mã ở nhóm kiểm thử. |
| C12 | Xác nhận đặt vé | Hành trình, hành khách, tổng tiền, điều khoản/chính sách; chụp thêm phần dưới nếu một khung không đủ. |
| C13 | Điều khoản / chính sách hủy | Bảng nội dung mở từ bước đặt vé. |
| C14 | Chọn phương thức thanh toán | Các phương thức đang hiển thị; ghi rõ môi trường thử nghiệm. |
| C15 | Thanh toán QR / thông tin chuyển khoản | Mã QR, nội dung chuyển khoản và thời hạn đơn khi phương thức được bật. |
| C16 | Cổng thanh toán bên ngoài | Trang thử nghiệm của phương thức thực sự chạy được; ghi rõ đây là trang ngoài app Flutter. |
| C17 | Hoàn tất thanh toán và vé QR | Chụp cả khách và thành viên để thấy khác nút điều hướng cuối; chọn đơn có vé do API phát hành. |
| C18 | Bảng chọn vé trong đơn nhiều khách | Thể hiện chuyển sang vé/QR của hành khách khác. |
| C19 | Hủy vé và lý do hủy | Mở từ chi tiết vé; thấy điều kiện/số tiền dự kiến và lý do. |
| C20 | Xác nhận hủy, kết quả hủy, vé đã cập nhật | Lấy ba bước để minh chứng cả thao tác và kết quả; nếu khách/thành viên giống nhau thì dùng một bộ ảnh. |
| C21 | Khám phá, kết quả tìm bài, chi tiết bài | Chụp danh sách, tìm/chọn chuyên mục và nội dung bài; thể hiện nút Tìm chuyến đi. |
| C22 | FAQ/Trung tâm trợ giúp | Bảng câu hỏi và ít nhất một nội dung trả lời mở rộng. |
| C23 | Gọi tổng đài | Ảnh bổ sung của ứng dụng gọi điện; không tính là giao diện Flutter tự xây dựng. |

## 6. Giao diện riêng khi chưa đăng nhập

| Mã | Cần chụp | Nội dung cần thấy |
| --- | --- | --- |
| K01 | Trang chủ khách | Lời mời đăng nhập và năm tab điều hướng. |
| K02 | Tài khoản khách | Lợi ích tài khoản, Đăng nhập/Đăng ký, Tra cứu vé đã đặt và tổng đài. |
| K03 | Hành trình — nhập email tra cứu | Form email liên hệ; luồng hiện tại không yêu cầu nhập mã đặt vé để bắt đầu. |
| K04 | OTP tra cứu vé | Phân biệt với OTP đăng nhập; gửi lại và đổi email. |
| K05 | Kết quả tra cứu | Danh sách đơn của email đã xác minh. |
| K06 | Chi tiết vé của đơn khách | QR, thông tin vé, trạng thái và thao tác được phép. |
| K07 | Thông báo yêu cầu đăng nhập với đơn tài khoản | Trường hợp khách tra thấy đơn đặt bằng tài khoản; bổ sung ở phần kiểm thử phân quyền. |

## 7. Giao diện riêng khi đã đăng nhập

| Mã | Cần chụp | Nội dung cần thấy |
| --- | --- | --- |
| U01 | Trang chủ thành viên | Thông tin chào theo tài khoản; đối chiếu với K01. |
| U02 | Hành trình — Vé của tôi | Danh sách đơn đặt bằng tài khoản; không cần OTP tra cứu. |
| U03 | Chi tiết vé/đơn của tài khoản | Mở từ U02; có thể dẫn lại ảnh dùng chung nếu bố cục không khác. |
| U04 | Tổng quan Tài khoản | Hồ sơ, thẻ VXN Plus và toàn bộ nhóm tiện ích/cài đặt; chụp cả phần dưới nếu cần. |
| U05 | Chỉnh sửa hồ sơ | Thông tin hiện có, trường chỉnh sửa và nút lưu; thêm bảng chọn ngày sinh nếu muốn minh họa tương tác thiết bị. |
| U06 | Quản lý hành khách đã lưu | Danh sách, form thêm, form sửa và xác nhận xóa; có thể ghép thành hình nhiều ảnh. |
| U07 | Chọn hành khách đã lưu khi đặt vé | Bảng chọn và kết quả tự điền vào bước Thông tin hành khách. |
| U08 | Ví voucher | Voucher khả dụng và ô nhập mã để lưu; dữ liệu từ API. |
| U09 | Chọn voucher từ ví trong đơn | Bảng chọn ở bước đặt vé và tổng tiền sau áp dụng. |
| U10 | VXN Plus / Lịch sử điểm | Tổng quan điểm và các giao dịch; thẻ thành viên nằm trong Tài khoản, không cần gọi là màn riêng. |
| U11 | Bộ lọc lịch sử điểm | Theo loại giao dịch và thời gian; chụp bảng lọc ngày. |
| U12 | Đánh giá của tôi | Hai phần chuyến chờ đánh giá/đánh giá đã gửi; ghi rõ fixture nếu ảnh dùng dữ liệu mẫu debug. |
| U13 | Viết đánh giá | Chọn số sao, nhập nhận xét và gửi; không coi fixture danh sách là bằng chứng đã đọc lịch sử thật từ API. |
| U14 | Cài đặt thông báo | Các công tắc và thay đổi UI; ghi rõ state cục bộ. |
| U15 | Phiên đăng nhập và xác nhận đăng xuất thiết bị | Chụp danh sách và hộp xác nhận; ghi rõ dữ liệu mẫu/cục bộ. |
| U16 | Thông báo đẩy | Hộp xin quyền nếu xuất hiện, thông báo hệ điều hành khi app ở nền, thanh báo khi app đang mở. Chụp kết quả chuyển sang Hành trình khi cần minh chứng điều hướng. |

## 8. Ảnh bổ sung cho mục kiểm thử

Không cần đưa mọi ảnh lỗi vào phần trình bày giao diện. Chọn các trường hợp có dữ liệu và thao tác chạy thử thực tế; lưu phần còn lại ở phụ lục nếu cần.

| Mã | Trường hợp cần minh chứng | Đặt ở phần báo cáo |
| --- | --- | --- |
| E01 | Email không hợp lệ, OTP sai/hết hạn hoặc chưa đến thời điểm gửi lại | Kiểm thử xác thực. |
| E02 | Không tìm thấy chuyến, tra cứu không có đơn | Kiểm thử trạng thái rỗng. |
| E03 | Thông tin hành khách thiếu/sai, mã giảm giá không hợp lệ | Kiểm thử biểu mẫu và ưu đãi. |
| E04 | Ghế vừa bị giữ hoặc không còn đặt được | Kiểm thử giữ chỗ và tải lại sơ đồ; chỉ chụp khi tái hiện được. |
| E05 | Thanh toán thất bại, đơn hết hạn hoặc đang đối soát | Các trạng thái trong màn thanh toán; không gọi là ba màn hình độc lập. |
| E06 | Vé không đủ điều kiện hủy | Kiểm thử chính sách hủy. |
| E07 | Mất mạng/lỗi tải dữ liệu và nút Thử lại | Kiểm thử xử lý lỗi API. |
| E08 | Màn hình nhỏ, bàn phím mở hoặc chữ hệ thống lớn | Kiểm thử bố cục; chọn form hành khách, OTP hoặc bảng chọn làm đại diện. |

## 9. Những điểm phải ghi đúng mức hoàn thành

| Hạng mục | Hiện trạng đọc từ mã nguồn | Cách ghi trong báo cáo |
| --- | --- | --- |
| Cài đặt thông báo | Công tắc cập nhật state trong widget. | Đã xây dựng giao diện và tương tác cục bộ; chưa xác nhận đồng bộ tùy chọn với máy chủ. |
| Phiên đăng nhập/thiết bị | Danh sách mẫu, thao tác xác nhận sửa danh sách cục bộ. | Đã xây dựng giao diện quản lý phiên; chưa mô tả thu hồi phiên thiết bị khác bằng API là hoàn tất. |
| Đánh giá của tôi | Debug dùng fixture; release danh sách rỗng. Hàm gửi đánh giá có gọi API. | Tách kết quả xây dựng giao diện, tích hợp gửi và phần tải danh sách còn hạn chế. |
| Lịch sử điểm | Gọi API; debug có thể thay bằng fixture khi không có giao dịch. | Đánh dấu ảnh dữ liệu mẫu; ảnh đó không chứng minh giao dịch thật. |
| Đổi điểm | Có loại giao dịch/lịch sử đổi điểm; chưa có màn đổi điểm riêng được nối. | Chỉ nêu xem lịch sử, chưa nêu người dùng đã tự đổi điểm trong app. |
| Tải vé PDF | Nút hiện thông báo chưa hỗ trợ. | Ghi hạn chế; kết quả chính là hiển thị vé QR. |
| Facebook/Apple | Nút giao diện chưa nối callback xác thực như Google. | Không liệt kê là phương thức đã tích hợp hoàn chỉnh. |
| Thanh toán | Có lựa chọn provider và xử lý QR/URL; phụ thuộc cấu hình dịch vụ. | Nêu đúng provider/môi trường đã chạy thử; DEMO là mô phỏng, không phải thanh toán tiền thật. |
| Hoàn tiền | Mobile gọi yêu cầu hủy, nhận và hiển thị dữ liệu hoàn. | Dùng tên “Hủy vé và hiển thị thông tin hoàn tiền”; không khẳng định đã kiểm chứng tiền về ngân hàng chỉ bằng màn thành công. |
| Thông báo | Có tích hợp nhận push và mở Hành trình; không có màn hộp thư thông báo riêng trong cây điều hướng. | Chụp thanh báo/hệ điều hành và kết quả điều hướng, không bổ sung màn chưa có. |

## 10. Bổ sung nhỏ cho phần kiểm thử và cách đưa ảnh vào báo cáo

Đề xuất đổi 4.4 thành:

1. **4.4.1. Kiểm thử đơn vị.**
2. **4.4.2. Kiểm thử widget và điều hướng giao diện.** Bổ sung vì Flutter hiện có nhiều `testWidgets`, bao gồm biểu mẫu, điều hướng, bảng chọn và bố cục.
3. **4.4.3. Kiểm thử hợp đồng OpenAPI và Dart API Client.**
4. **4.4.4. Kiểm thử tích hợp với API.**
5. **4.4.5. Kiểm thử luồng nghiệp vụ, vòng đời ứng dụng và bố cục trên thiết bị.** Ghi rõ thiết bị/nền tảng nào thực sự đã chạy.

Một bài kiểm thử dùng fake/mock API chỉ chứng minh lớp được kiểm thử và không thay thế minh chứng gọi backend thật. Bản báo cáo cần tách rõ kết quả đọc mã, kết quả test tự động đã chạy và kết quả chạy thử thiết bị.

Gợi ý trình tự chụp:

1. Vào chế độ khách: chụp K01/K02, các màn dùng chung, đặt đơn khách và hoàn tất, sau đó K03–K06.
2. Đăng nhập: chụp A02–A04, U01/U04, các tiện ích thành viên; đặt đơn tài khoản để chụp các khác biệt và U02/U03.
3. Dùng đơn/vé đủ điều kiện để chụp hủy vé và kết quả cập nhật.
4. Chạy riêng các tình huống kiểm thử E01–E08 có thể tái hiện; không dàn dựng kết quả chưa chạy được.

Đặt tên ảnh theo mã, ví dụ `K01-trang-chu-khach.png`, `U04-tai-khoan-thanh-vien.png`, `C10a-thong-tin-hanh-khach-khach.png`, `C10b-thong-tin-hanh-khach-thanh-vien.png`. Dùng dữ liệu thử và cùng kích thước hiển thị để hình ghép dễ so sánh. Một hình báo cáo có thể ghép 2–3 ảnh dọc; không cần một hình đánh số riêng cho từng bảng chọn.

Trong 4.3, ưu tiên ảnh luồng chính và ảnh thể hiện khác biệt khách/thành viên. Chuyển ảnh lỗi, dữ liệu rỗng và biến thể bố cục sang 4.4 hoặc phụ lục. Ví dụ chú thích: “Hình 4.x. Giao diện thông tin hành khách: (a) khách chưa đăng nhập; (b) thành viên sử dụng hành khách đã lưu”.

## 11. Nguồn mã đã đối chiếu

- [Điều phối xác thực, tab và tiện ích tài khoản](C:/Code/Ve_Xe_Nhanh/apps/passenger_mobile/lib/main.dart:124).
- [Danh sách đánh giá và hàm gửi đánh giá](C:/Code/Ve_Xe_Nhanh/apps/passenger_mobile/lib/main.dart:636).
- [Lịch sử điểm và fixture dự phòng ở debug](C:/Code/Ve_Xe_Nhanh/apps/passenger_mobile/lib/main.dart:678).
- [Điều hướng màn hiện tại](C:/Code/Ve_Xe_Nhanh/apps/passenger_mobile/lib/main.dart:1001).
- [Luồng khách và tài khoản trong Hành trình](C:/Code/Ve_Xe_Nhanh/apps/passenger_mobile/lib/features/journey/guest_journey_flow.dart:14).
- [Hủy vé và kết quả hoàn](C:/Code/Ve_Xe_Nhanh/apps/passenger_mobile/lib/features/journey/guest_ticket_detail_screen.dart:110).
- [Điều kiện mở màn hoàn tất thanh toán](C:/Code/Ve_Xe_Nhanh/apps/passenger_mobile/lib/features/ticket/payment_models.dart:100).
- [Tải PDF hiện chưa hỗ trợ](C:/Code/Ve_Xe_Nhanh/apps/passenger_mobile/lib/features/ticket/payment_completion_screen.dart:138).
- [Công tắc thông báo cục bộ](C:/Code/Ve_Xe_Nhanh/apps/passenger_mobile/lib/features/account/notification_settings_screen.dart:18).
- [Phiên thiết bị mẫu và thao tác cục bộ](C:/Code/Ve_Xe_Nhanh/apps/passenger_mobile/lib/features/account/login_sessions_screen.dart:16).
- [Luồng nhận push FCM](C:/Code/Ve_Xe_Nhanh/apps/passenger_mobile/lib/features/notification/push_service.dart:57).
- [Ví dụ kiểm thử widget các cài đặt](C:/Code/Ve_Xe_Nhanh/apps/passenger_mobile/test/account_settings_screens_test.dart:20).

Sơ đồ điều hướng đã tạo: [passenger-mobile-navigation.drawio](C:/Code/Ve_Xe_Nhanh/doc/diagrams/passenger-mobile-navigation.drawio).
