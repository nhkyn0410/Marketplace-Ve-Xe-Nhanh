# Mục lục minh chứng ảnh chụp màn hình ứng dụng Passenger Mobile (Trạng thái Thành viên)

Thư mục lưu trữ: `doc/report/screenshots/authenticated/`  
Đối tượng kiểm thử: Ứng dụng di động hành khách (`passenger_mobile` Flutter Android trên emulator-5554)  
Trạng thái tài khoản: **Thành viên đã đăng nhập** (tài khoản kiểm thử trên DB bản sao)  
Ngày thực hiện: **01–02/11/2026**. Các ảnh ghi "Chụp lại" hoặc "Mới" lấy từ bản build ngày 02/11/2026.

---

## 1. Ghi chú hiện trạng

- Ảnh minh họa giao diện, không tự coi là bằng chứng tích hợp backend hoàn chỉnh. Đối chiếu mã nguồn trước khi dùng làm khẳng định.
- Cài đặt thông báo và Phiên đăng nhập **nay dùng dữ liệu thật** từ API (khác với danh sách yêu cầu ban đầu ngày 01/11/2026, khi hai màn này còn dữ liệu cục bộ).
- Lịch sử điểm dùng API thật; mã nguồn hiện không còn đưa dữ liệu mẫu vào màn này. Danh sách Đánh giá của tôi vẫn là dữ liệu mẫu ở bản debug, vì API chưa có danh sách cho hành khách.
- Thanh toán và hoàn tiền chỉ qua cổng DEMO: không có giao dịch tiền thật; ảnh hoàn tiền "Đang xử lý" không chứng minh tiền đã về tài khoản.
- Push dùng FCM thật, chỉ tới máy ảo; email bị chặn ở API thử. Chưa thử iOS/APNs, điện thoại thật, force stop.
- Biểu tượng thông báo là logo một màu (đổi tối 02/11/2026): Android chỉ dùng độ trong suốt của biểu tượng này nên không hiện màu logo. `U42`, `U43a`, `U43b`, `U43c`, `U44`, `U47`, `U48` được chụp lại sau thay đổi.
- Không chụp luồng đăng nhập / OTP: Khanh tự thực hiện phần này.
- Bảy ảnh cũ đã gỡ vì không còn đúng hoặc không hữu ích (`U23c`, `U34b` cuộn dưới, `U42b`, `U43`, `U43b` trong luồng đặt vé, `U43d` mở đăng nhập, `U43e`); vẫn xem được trong lịch sử git.

---

## 2. Bảng tổng hợp các màn hình minh chứng

### A. Trang chủ và tài khoản

| Tên file | Giao diện | Nội dung minh chứng | Dữ liệu | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| `U01-trang-chu.png` | Trang chủ thành viên | Lời chào theo tên tài khoản, form tìm chuyến, ưu đãi nổi bật, thanh 5 tab. Chuông có chấm đỏ vì còn tin chưa đọc. | API thật (DB bản sao) | Chụp lại 02/11/2026; chấm đỏ theo số tin thật. |
| `U02-tai-khoan-tong-quan.png` | Tab Tài khoản | Hồ sơ, thẻ VXN Plus (hạng, điểm khả dụng), đầu danh sách tiện ích. | API thật (DB bản sao) | Số điểm theo thời điểm chụp 01/11/2026. |
| `U02b-tai-khoan-cuon-duoi.png` | Tab Tài khoản (cuộn dưới) | Tiện ích tài khoản, nhóm Cài đặt & bảo mật, nút Đăng xuất. | API thật (DB bản sao) |  |
| `U03-chinh-sua-ho-so.png` | Chỉnh sửa thông tin | Họ tên, ngày sinh, số điện thoại, email đã xác minh, nút lưu. | API thật (DB bản sao) |  |
| `U04-bang-chon-ngay-sinh.png` | Bảng chọn ngày sinh | Lịch chọn ngày trong màn chỉnh sửa hồ sơ. | Dữ liệu hệ thống | Không lưu thay đổi. |
| `U05-danh-sach-hanh-khach-da-luu.png` | Hành khách đã lưu | Danh sách 3/5 người, nút sửa, xóa, thêm. | API thật (DB bản sao) |  |
| `U06-form-them-hanh-khach.png` | Form thêm hành khách | Họ tên, số điện thoại, nút lưu. | Dữ liệu hệ thống | Không gửi form. |
| `U06b-form-sua-hanh-khach.png` | Form sửa hành khách | Dữ liệu điền sẵn từ người đã chọn. | API thật (DB bản sao) | Không lưu thay đổi. |
| `U07-xac-nhan-xoa-hanh-khach.png` | Xác nhận xóa | Bảng xác nhận xóa hành khách đã lưu. | API thật (DB bản sao) | Đóng bảng, không xóa. |

### B. Tìm và đặt vé bằng tài khoản

| Tên file | Giao diện | Nội dung minh chứng | Dữ liệu | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| `U08-mua-ve-theo-chuyen.png` | Tab Mua vé, theo chuyến | Bộ lọc nhanh và danh sách chuyến đang mở bán. | API thật (DB bản sao) |  |
| `U09-mua-ve-theo-nha-xe.png` | Tab Mua vé, theo nhà xe | Danh sách nhà xe đang phục vụ kèm đánh giá, tuyến, giá từ. | API thật (DB bản sao) |  |
| `U10-ket-qua-tim-chuyen.png` | Kết quả tìm chuyến | TP.HCM → Lâm Đồng theo ngày, đổi ngày nhanh, lọc, sắp xếp. | API thật (DB bản sao) |  |
| `U10b-bang-loc.png` | Bảng lọc chuyến | Khoảng giá, dạng chỗ, hạng xe, giờ khởi hành, tiện ích. | Dữ liệu hệ thống |  |
| `U10b2-bang-sap-xep.png` | Bảng sắp xếp | Giá, giờ khởi hành, thời gian di chuyển, đánh giá. | Dữ liệu hệ thống |  |
| `U10c-chi-tiet-chuyen.png` | Chi tiết chuyến (đầu) | Ảnh xe, nhà xe, giờ đi đến, loại xe, tiện ích, lịch trình. | API thật (DB bản sao) |  |
| `U10d-chi-tiet-chuyen-lich-trinh.png` | Chi tiết chuyến (lịch trình) | Các điểm dừng, điểm đón và điểm trả. | API thật (DB bản sao) |  |
| `U10e-chi-tiet-chuyen-chinh-sach.png` | Chi tiết chuyến (chính sách) | Tiện ích, chính sách hủy, lưu ý. | API thật (DB bản sao) |  |
| `U11-so-do-ghe-chua-chon.png` | Chọn chỗ | Sơ đồ tầng dưới, chưa chọn chỗ, nút Tiếp tục khóa. | API thật (DB bản sao) |  |
| `U11b-so-do-ghe-da-chon.png` | Chọn chỗ | Đã chọn A04, A05, tạm tính 580.000 đ. | API thật (DB bản sao) |  |
| `U11c-bang-chon-diem-don.png` | Bảng điểm đón | Danh sách điểm đón kèm giờ. | API thật (DB bản sao) |  |
| `U11d-bang-chon-diem-tra.png` | Bảng điểm trả | Danh sách điểm trả kèm giờ. | API thật (DB bản sao) |  |
| `U12-thong-tin-khach-nut-chon-nguoi-luu.png` | Bước Thông tin | Khối hành khách có nút Chọn hành khách đã lưu, khác với khách vãng lai. | API thật (DB bản sao) | Đúng bước Thông tin; dùng cho hình đối chiếu 4.3.7. |
| `U12a-thong-tin-lien-he-dien-san.png` | Bước Thông tin | Thông tin liên hệ điền sẵn từ tài khoản. | API thật (DB bản sao) |  |
| `U13-bang-chon-hanh-khach-da-luu.png` | Bảng hành khách đã lưu | Chọn từ danh sách đã lưu của tài khoản. | API thật (DB bản sao) |  |
| `U13b-thong-tin-dien-tu-nguoi-da-luu.png` | Bước Thông tin | Họ tên, số điện thoại điền từ người đã chọn. | API thật (DB bản sao) |  |
| `U14-bang-chon-voucher.png` | Bảng chọn voucher | Voucher khả dụng trong ví, mỗi đơn dùng một voucher. | API thật (DB bản sao) |  |
| `U15-tong-tien-sau-ap-voucher.png` | Khối Ưu đãi | Voucher VXNPLUS đã áp, giảm 100.000 đ, tạm tính 480.000 đ. | API thật (DB bản sao) |  |
| `U16-xac-nhan-dat-ve.png` | Xác nhận đặt vé (đầu) | Chuyến, chỗ và hành khách. | API thật (DB bản sao) |  |
| `U16b-xac-nhan-dat-ve-hanh-trinh.png` | Xác nhận đặt vé (hành trình) | Điểm đón, điểm trả, ưu đãi, chi tiết thanh toán. | API thật (DB bản sao) |  |
| `U16c-xac-nhan-dat-ve-tong-tien.png` | Xác nhận đặt vé (tổng tiền) | Tổng tiền, ô đồng ý điều khoản. | API thật (DB bản sao) |  |
| `U17-chon-phuong-thuc-thanh-toan.png` | Phương thức thanh toán | Đơn đã tạo, số tiền, thời hạn giữ chỗ, phương thức chọn. | API thật (DB bản sao) |  |
| `U17b-danh-sach-phuong-thuc-thanh-toan.png` | Danh sách phương thức | VietQR qua payOS, MoMo, VNPay, cổng thanh toán thử. | API thật (DB bản sao) | Chỉ dùng cổng thử; không có giao dịch tiền thật. |
| `U18-cong-thanh-toan-thu-nghiem.png` | Cổng thử (trình duyệt) | Trang cổng thử: thanh toán thành công hoặc thất bại. | Dữ liệu kiểm thử | Trang ngoài ứng dụng Flutter. |
| `U19-hoan-tat-ve-qr.png` | Hoàn tất, vé QR | Vé điện tử A04, mã QR, nút Xem chuyến hành trình của thành viên. | API thật (DB bản sao) |  |
| `U19b-hoan-tat-ve-thu-hai.png` | Hoàn tất, vé thứ hai | Vé A05 trong cùng đơn. | API thật (DB bản sao) |  |
| `U20-bang-chon-ve-nhieu-hanh-khach.png` | Bảng chọn vé | Chuyển giữa các vé trong đơn nhiều hành khách. | API thật (DB bản sao) |  |

### C. Hành trình và hủy vé

| Tên file | Giao diện | Nội dung minh chứng | Dữ liệu | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| `U21-hanh-trinh-ve-cua-toi.png` | Tab Hành trình, Vé của tôi | Đơn của tài khoản, không qua OTP tra cứu; nhãn theo trạng thái vé thật (Đã hoàn tiền, Hợp lệ). | API thật (DB bản sao) | Chụp lại 02/11/2026 sau khi sửa nhãn. |
| `U21b-hanh-trinh-ve-da-di.png` | Vé của tôi (cuộn dưới) | Đơn đã đi hiển thị "Đã đi" thay vì "Hợp lệ". | API thật (DB bản sao) | Mới 02/11/2026. |
| `U22-ve-da-thanh-toan-chi-tiet.png` | Chi tiết vé đã thanh toán | Vé QR, hành trình, thanh toán. | API thật (DB bản sao) | Thanh toán qua cổng thử. |
| `U22b-ve-da-thanh-toan-thao-tac.png` | Chi tiết vé (thao tác) | Chính sách hủy, nút Hủy vé khi vé còn hiệu lực. | API thật (DB bản sao) |  |
| `U23-ve-da-su-dung-chi-tiet.png` | Chi tiết vé đã đi | Nhãn Đã đi, QR mờ ghi Đã sử dụng. | API thật (DB bản sao) | Chụp lại 02/11/2026. |
| `U23b-ve-da-su-dung-thao-tac.png` | Chi tiết vé đã đi (thao tác) | Ghi "Vé này không còn hủy được", không còn nút Hủy vé; có Liên hệ hỗ trợ. | API thật (DB bản sao) | Chụp lại 02/11/2026. |
| `U24-bang-ly-do-huy-tien-hoan-du-kien.png` | Bảng Hủy vé | Tiền hoàn dự kiến theo chính sách lúc đặt, ô lý do. | API thật (DB bản sao) |  |
| `U24b-danh-sach-ly-do-huy.png` | Bảng Hủy vé | Danh sách lý do hủy. | Dữ liệu hệ thống |  |
| `U24c-da-chon-ly-do-huy.png` | Bảng Hủy vé | Đã chọn lý do. | Dữ liệu hệ thống |  |
| `U25-xac-nhan-huy-ve.png` | Xác nhận hủy | Cảnh báo không khôi phục được, số tiền hoàn. | API thật (DB bản sao) |  |
| `U26-huy-ve-thanh-cong-thong-tin-hoan-tien.png` | Kết quả hủy | Thông tin hoàn tiền, mã hoàn, trạng thái Đang xử lý. | API thật (DB bản sao) | Chưa chứng minh tiền đã về tài khoản. |
| `U27-ve-da-huy-cap-nhat.png` | Vé đã hủy | Nhãn Đã hủy, QR gạch chéo. | API thật (DB bản sao) |  |
| `U27b-ve-da-huy-thong-tin-hoan-tien.png` | Vé đã hủy (cuộn dưới) | Thanh toán, hoàn tiền, nút Liên hệ hỗ trợ. | API thật (DB bản sao) |  |
| `U28-hanh-trinh-sau-khi-huy.png` | Vé của tôi sau khi hủy | Các đơn đã hủy mang nhãn Đã hoàn tiền. | API thật (DB bản sao) | Chụp lại 02/11/2026. |

### D. Tiện ích thành viên

| Tên file | Giao diện | Nội dung minh chứng | Dữ liệu | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| `U29-vi-voucher-danh-sach-o-luu-ma.png` | Ví voucher | Danh sách voucher khả dụng và ô lưu mã. | API thật (DB bản sao) | Số voucher theo thời điểm chụp 01/11/2026. |
| `U29b-vi-voucher-da-nhap-ma.png` | Ví voucher | Đã nhập mã khuyến mãi. | API thật (DB bản sao) |  |
| `U29c-vi-voucher-sau-khi-luu-ma.png` | Ví voucher | Sau khi lưu mã, thêm một voucher. | API thật (DB bản sao) |  |
| `U29d-vi-voucher-bang-dieu-kien.png` | Bảng Điều kiện sử dụng | Mức giảm, đơn tối thiểu, phạm vi áp dụng, hạn dùng, nguồn, mã. | API thật (DB bản sao) | Mới 02/11/2026; trước đây "Xem điều kiện" không bấm được. |
| `U30-lich-su-diem-tong-quan-giao-dich.png` | Lịch sử điểm | Tổng đã tích / đã đổi / hết hạn, chip lọc loại, giao dịch theo tháng. | API thật (DB bản sao) | Chụp lại 02/11/2026. |
| `U30b-loc-lich-su-diem-theo-thoi-gian.png` | Bảng lọc thời gian | Tất cả, tháng này, tháng trước, 3 tháng, 6 tháng, tùy chọn khác. | Dữ liệu hệ thống | "Tùy chọn khác" chưa có tác dụng (đã báo). |
| `U30c-lich-su-diem-sau-khi-loc.png` | Lịch sử điểm | Kết quả lọc Tháng trước; tổng theo khoảng thời gian. | API thật (DB bản sao) |  |
| `U30d-loc-lich-su-diem-theo-loai.png` | Lịch sử điểm | Lọc loại Đổi điểm; tổng ở thẻ trên không đổi theo bộ lọc loại. | API thật (DB bản sao) | Mới 02/11/2026. |
| `U31-vxn-plus-tong-quan.png` | VXN Plus | Hạng, điểm 12 tháng, điểm khả dụng, ước tính voucher. | API thật (DB bản sao) |  |
| `U31b-vxn-plus-bang-hang.png` | VXN Plus (cuộn dưới) | Bảng hạng, cách tích và đổi điểm. | API thật (DB bản sao) |  |
| `U31c-bang-doi-diem.png` | Bảng đổi điểm | Số điểm muốn đổi, voucher nhận được, xác nhận. | API thật (DB bản sao) |  |
| `U31d-doi-diem-thanh-cong.png` | Đổi điểm thành công | Voucher vào ví, điểm còn lại, hạn dùng. | API thật (DB bản sao) |  |
| `U32-danh-gia-cua-toi-cho-danh-gia.png` | Đánh giá của tôi | Tab Chờ đánh giá. | Dữ liệu mẫu (bản debug) | API chưa có danh sách cho hành khách; bản release trống. |
| `U32b-danh-gia-cua-toi-da-danh-gia.png` | Đánh giá của tôi | Tab Đã đánh giá. | Dữ liệu mẫu (bản debug) | Như trên. |
| `U33-form-viet-danh-gia.png` | Form viết đánh giá | Số sao, nhận xét, nút gửi. | Dữ liệu mẫu (bản debug) | Không gửi; hàm gửi đã nối API. |
| `U34-cai-dat-thong-bao.png` | Cài đặt thông báo | Nhóm quan trọng khóa Luôn bật (BR-52); Ưu đãi, VXN Plus bật, Tin tức tắt. | API thật (DB bản sao) | Chụp lại 02/11/2026; nay đọc và lưu ở máy chủ. |
| `U34b-cai-dat-thong-bao-bat-tin-tuc.png` | Cài đặt thông báo | Sau khi bật Tin tức (`PUT /me/notification-preferences` trả 200). | API thật (DB bản sao) | Mới 02/11/2026. |
| `U35-phien-dang-nhap-thiet-bi.png` | Phiên đăng nhập & thiết bị | Phiên hiện tại và các phiên khác từ API, nút đăng xuất từng phiên. | API thật (DB bản sao) | Chụp lại 02/11/2026; nay là dữ liệu thật. |
| `U35b-xac-nhan-dang-xuat-thiet-bi-khac.png` | Bảng xác nhận | Đăng xuất một thiết bị khác. | API thật (DB bản sao) | Đóng bảng, không thu hồi. |
| `U35c-xac-nhan-dang-xuat-tat-ca-thiet-bi-khac.png` | Bảng xác nhận | Đăng xuất tất cả thiết bị khác. | API thật (DB bản sao) | Đóng bảng, không thu hồi. |
| `U36-thong-tin-nha-xe-tong-quan.png` | Thông tin nhà xe | Logo, mô tả, liên hệ, chỉ số chất lượng. | API thật (DB bản sao) |  |
| `U36b-thong-tin-nha-xe-tuyen-danh-gia.png` | Thông tin nhà xe | Tuyến đang mở bán, đánh giá từ hành khách. | API thật (DB bản sao) |  |
| `U36c-thong-tin-nha-xe-danh-sach-danh-gia.png` | Thông tin nhà xe | Danh sách đánh giá kèm phản hồi của nhà xe. | API thật (DB bản sao) |  |
| `U36d-thong-tin-nha-xe-dieu-khoan.png` | Thông tin nhà xe | Đánh giá, khối điều khoản dịch vụ. | API thật (DB bản sao) |  |
| `U36e-thong-tin-nha-xe-mo-ta-day-du.png` | Thông tin nhà xe | Mô tả mở rộng đầy đủ. | API thật (DB bản sao) |  |
| `U37-chuyen-cua-nha-xe.png` | Chuyến của nhà xe | Chuyến sắp chạy trong 14 ngày tới của nhà xe. | API thật (DB bản sao) |  |

### E. Nội dung, hỗ trợ và thông báo đẩy

| Tên file | Giao diện | Nội dung minh chứng | Dữ liệu | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| `U38-kham-pha-tong-quan.png` | Tab Khám phá | Tìm bài, chuyên mục, bài nổi bật, bài mới nhất. | API thật (DB bản sao) |  |
| `U39-tim-bai-co-ket-qua.png` | Tìm bài | Có kết quả với từ khóa có dấu. | API thật (DB bản sao) |  |
| `U39b-tim-bai-khong-dau-khong-co-ket-qua.png` | Tìm bài | Từ khóa không dấu không ra kết quả. | API thật (DB bản sao) | Lỗi đã báo, chưa sửa; dùng cho 4.4. |
| `U40-chi-tiet-bai-viet.png` | Chi tiết bài viết | Ảnh bìa, tiêu đề, phần mở đầu. | API thật (DB bản sao) |  |
| `U40b-chi-tiet-bai-viet-noi-dung.png` | Chi tiết bài viết | Phần nội dung. | API thật (DB bản sao) |  |
| `U41-trang-chu-tram-ho-tro.png` | Trang chủ (trạm hỗ trợ) | Khối hỗ trợ, trung tâm trợ giúp, gọi tổng đài. | API thật (DB bản sao) |  |
| `U41b-trung-tam-tro-giup-faq.png` | Trung tâm trợ giúp | Danh sách câu hỏi thường gặp. | API thật (DB bản sao) |  |
| `U41c-faq-mo-mot-cau-hoi.png` | Trung tâm trợ giúp | Một câu trả lời đang mở. | API thật (DB bản sao) | Nội dung còn dấu `**` và nêu 15 phút giữ chỗ (đã báo); không trích làm quy định. |
| `U42-thong-bao-he-dieu-hanh-khi-app-o-nen.png` | Khay thông báo Android | Tin Đã hủy vé, Hoàn tiền thành công khi app ở nền; biểu tượng logo và kênh riêng. Tin giao dịch giữ câu chung (BR-53). | FCM thật + DB bản sao | Chụp lại 02/11/2026; Android tự gộp nhóm. Mở rộng từng tin mới thấy câu chung xuống dòng. |
| `U43a-thanh-thong-bao-khi-dang-doc-bai-viet.png` | Thanh báo trong app | Tin đến khi đang đọc bài viết, có nút Xem. | FCM thật + DB bản sao | Mới 02/11/2026. |
| `U43b-bam-xem-tu-man-con-ve-hanh-trinh.png` | Tab Hành trình | Sau khi bấm Xem từ màn con: đóng màn con, mở Hành trình. | FCM thật + DB bản sao | Thay ảnh cũ (trước đây chỉ mở Vé của bạn). |
| `U43c-cham-thong-bao-chuyen-sang-hanh-trinh.png` | Tab Hành trình | Sau khi chạm một thông báo trong khay. | FCM thật + DB bản sao | Chạm dòng tóm tắt của nhóm thu gọn thì Android chỉ mở app. |
| `U43d-cham-thong-bao-khi-app-da-tat-mo-hanh-trinh.png` | Tab Hành trình | App đã tắt tiến trình (`am kill`): chạm thông báo, app tự khôi phục phiên rồi mở Hành trình, không đăng nhập lại. | FCM thật + DB bản sao | Trang chủ hiện trước khoảng 15 giây ở bản debug. Chưa thử force stop. |
| `U44-thanh-thong-bao-khi-app-dang-mo.png` | Thanh báo trong app | Tin Đặt vé thành công khi app đang mở, có nút Xem. | FCM thật + DB bản sao | Chụp lại 02/11/2026; thanh báo tự tắt sau 6 giây. |
| `U44b-bam-xem-chuyen-sang-hanh-trinh.png` | Tab Hành trình | Sau khi bấm Xem. | FCM thật + DB bản sao |  |

### F. Hộp thư, chiến dịch thông báo, phiên đăng nhập (bổ sung 02/11/2026, chờ duyệt)

| Tên file | Giao diện | Nội dung minh chứng | Dữ liệu | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| `U45-chuong-co-tin-chua-doc.png` | Trang chủ | Chuông có chấm đỏ khi còn tin chưa đọc. | API thật (DB bản sao) |  |
| `U45b-chuong-da-doc-het.png` | Trang chủ | Hết chấm đỏ sau khi đọc hết tin. | API thật (DB bản sao) |  |
| `U46-hop-thu-thong-bao.png` | Hộp thư | Tin giao dịch và chiến dịch, số tin chưa đọc, Đọc tất cả, biểu tượng theo loại. | API thật (DB bản sao) | Figma chưa có khung. |
| `U46b-doc-toan-van-tin-giao-dich.png` | Bảng đọc tin | Toàn văn tin Đã hủy vé, nút Xem hành trình. | API thật (DB bản sao) |  |
| `U47-push-gui-thu-khi-app-o-nen.png` | Khay thông báo Android | Tin gửi thử từ Admin, mang nhãn [Thử] và nguyên nội dung. | FCM thật + DB bản sao | Chụp lại 02/11/2026, đã mở rộng tin. |
| `U47b-cham-push-mo-hop-thu.png` | Hộp thư | Chạm push loại không gắn đơn vé thì mở Hộp thư. | FCM thật + DB bản sao |  |
| `U47c-thanh-bao-chien-dich-khi-app-dang-mo.png` | Thanh báo trong app | Chiến dịch dịch vụ đến khi app đang mở; chuông cập nhật ngay. | FCM thật + DB bản sao | Cổng Admin gửi thật. |
| `U48-push-tin-tuc.png` | Khay thông báo Android | Tin tức gửi tới đúng khách đã bật nhận. | FCM thật + DB bản sao | Estimate trước khi bật: 0 người nhận. |
| `U48b-doc-tin-tuc-nut-doc-bai.png` | Bảng đọc tin | Tin tức có nút Đọc bài viết. | API thật (DB bản sao) |  |
| `U48c-mo-bai-viet-tu-thong-bao.png` | Chi tiết bài viết | Mở đúng bài gắn với tin. | API thật (DB bản sao) |  |
| `U49-doc-tin-khuyen-mai-nut-luu-ma.png` | Bảng đọc tin | Tin khuyến mãi có nút Lưu mã vào ví. | Dữ liệu kiểm thử | Mã từ seed kiểm thử. |
| `U49b-vi-voucher-dien-san-ma.png` | Ví voucher | Mã khuyến mãi điền sẵn từ tin. | Dữ liệu kiểm thử |  |
| `U49c-vi-voucher-da-luu-ma.png` | Ví voucher | Đã lưu mã, ví tăng một voucher. | Dữ liệu kiểm thử |  |
| `U50-trang-chu-khach-chuong-khong-cham-do.png` | Trang chủ khách vãng lai | Chuông không có chấm đỏ, không gọi API hộp thư. | API thật (DB bản sao) |  |
| `U50b-khach-cham-chuong-yeu-cau-dang-nhap.png` | Màn đăng nhập | Khách chạm chuông được đưa về đăng nhập. | Dữ liệu hệ thống |  |
| `U51-het-phien-ve-man-dang-nhap.png` | Màn đăng nhập | Phiên bị thu hồi từ thiết bị khác: "Phiên đã hết hạn. Vui lòng đăng nhập lại." | API thật (DB bản sao) | Trạng thái hết phiên, dùng cho 4.4. |
| `U52-hanh-trinh-sau-khi-token-het-han.png` | Tab Hành trình | Sau khi access token hết hạn, app tự làm mới và tải được dữ liệu. | API thật (DB bản sao) | API thử đặt token 60 giây; log `401 → refresh → 200`. |

### Cổng Admin — chiến dịch thông báo (thư mục `doc/report/screenshots/admin/`)

Trình duyệt 1440 × 1000 px, Admin dev với API thử và DB bản sao. Phục vụ phần nguồn gửi thông báo ở 4.3.16; không thuộc ứng dụng hành khách.

| Tên file | Giao diện | Nội dung minh chứng | Dữ liệu | Ghi chú |
| :--- | :--- | :--- | :--- | :--- |
| `A01-danh-sach-thong-bao.png` | Thông báo | Danh sách chiến dịch, lọc trạng thái, ghi chú không gửi email hàng loạt. | Dữ liệu kiểm thử | Tiêu đề do test E2E tạo. |
| `A02-soan-khuyen-mai-chon-hang.png` | Tạo thông báo | Chọn dạng Khuyến mãi, theo hạng VXN Plus, xem trước, người nhận dự kiến. | Dữ liệu kiểm thử |  |
| `A03-ban-nhap-nguoi-nhan-gui-thu.png` | Bản nháp | Người nhận dự kiến, khối gửi thử. | Dữ liệu kiểm thử |  |
| `A04-xac-nhan-so-nguoi-nhan.png` | Hộp thoại gửi | Luôn hiện số người nhận; gửi ngay hoặc hẹn giờ. | Dữ liệu kiểm thử |  |
| `A05-ket-qua-gui.png` | Kết quả | Đã vào hộp thư, đã đọc, kết quả push, các mốc thời gian. | Dữ liệu kiểm thử | Worker không có FCM nên push bằng 0. |
| `A06-soan-kho-dien-thoai.png` | Tạo thông báo (khổ 390 px) | Bố cục một cột, không tràn ngang. | Dữ liệu kiểm thử | Kích thước khác bộ ảnh điện thoại. |

---

## 3. Thống kê theo nhóm

| Nhóm | Mã ảnh | Số ảnh |
| :--- | :--- | :---: |
| A. Trang chủ và tài khoản | `U01` – `U07` | 9 |
| B. Tìm và đặt vé bằng tài khoản | `U08` – `U20` | 27 |
| C. Hành trình và hủy vé | `U21` – `U28` | 14 |
| D. Tiện ích thành viên | `U29` – `U37` | 26 |
| E. Nội dung, hỗ trợ và thông báo đẩy | `U38` – `U44b` | 15 |
| F. Hộp thư, chiến dịch thông báo, phiên đăng nhập (bổ sung 02/11/2026, chờ duyệt) | `U45` – `U52` | 17 |
| **Tổng bộ ảnh thành viên** | | **108** |
| Cổng Admin (thư mục riêng) | `A01` – `A06` | 6 |

---

## 4. Quy chuẩn kỹ thuật

- **Độ phân giải:** PNG gốc 1080 × 2400 của Pixel 6, Android 16, cùng thiết bị với bộ ảnh khách. Ảnh Admin theo kích thước trình duyệt.
- **Môi trường:** `emulator-5554`, API NestJS và worker chạy cục bộ, cơ sở dữ liệu là bản sao của `vexenhanh_dev`.
- **Bảo mật:** không có mật khẩu, mã OTP hay token trong ảnh; tài khoản và số điện thoại là dữ liệu kiểm thử.
- **Mức tin cậy:** chú thích là mô tả hỗ trợ, cần đối chiếu với ảnh và mã nguồn trước khi đưa vào báo cáo.
