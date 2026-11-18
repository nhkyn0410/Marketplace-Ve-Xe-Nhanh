# So sánh Web hành khách và Ứng dụng hành khách — đối chiếu chi tiết trên cùng dữ liệu

> Ngày chụp và đối chiếu: **13–14/11/2026** (lần 2, thay bản 12–13/11). Trạng thái: **chờ Khanh duyệt**.
> Hai nền tảng chạy **cùng lúc, cùng API, cùng tài khoản, cùng chuyến xe và cùng các đơn vé**, rồi so từng chi tiết: trường nhập, nút, nhãn, lựa chọn, giá trị mặc định, thông báo lỗi, trạng thái và số liệu.
> Mã nguồn: `apps/marketplace` (Next.js) và `apps/passenger_mobile` (Flutter).

## 0. Cách làm

| Hạng mục | Giá trị |
| --- | --- |
| Web | `next dev` cổng 3001, Chrome 1440 px (Playwright), ngôn ngữ vi-VN, múi giờ Asia/Ho_Chi_Minh |
| App | Bản debug Android x64 trên emulator Pixel_6 (1080×2400) |
| API | Bản build nhánh `feat/new-notification`, chạy cô lập cổng 3100 + worker, **dùng chung cho cả hai** |
| Dữ liệu | DB nhân bản `vxn_web_shots` (Redis db 6). Không đụng DB dev hay production |
| Tài khoản | `nguyenvanan.demo@example.com` (mã OTP ghi ra file cục bộ, không gửi email thật) |
| Kịch bản chung | TP. Hồ Chí Minh → Lâm Đồng, ngày **15/11/2026**, 1 khách, chuyến **Phương Trang 07:30** (Giường nằm Limousine, 290.000đ), mã **VEXENHANH50**, VNPay sandbox |
| Đơn tạo trong lần này | Web **VXNLK7ELH** (chỗ A09) và app **VXNUY6MKL** (chỗ A08), cùng 246.500đ, cả hai `CONFIRMED` |
| Cách so | Mỗi màn chụp ảnh hai bên và trích toàn bộ chữ hiển thị (web: chữ trong trang + danh sách ô nhập/nút; app: cây giao diện uiautomator), rồi so từng dòng |
| Ảnh | Tất cả nằm trong một thư mục `screenshots/hanh-khach-web-app-12-14-11/`: ảnh ghép `Sxx-so-sanh-*.png` (trái là web, phải là app), ảnh gốc `Sxx-web-*.png` và `Sxx-app-*.png`; ảnh lần 1: `W…` (web 12/11) và `M…` (app 13/11) |

Ký hiệu cột **KL** (kết luận):

| Ký hiệu | Nghĩa |
| --- | --- |
| **Giống** | Cùng dữ liệu, cùng hành vi (chữ có thể khác vài từ) |
| **Khác** | Cùng chức năng, khác cách trình bày hoặc thao tác. Không sai |
| **Chỉ web** / **Chỉ app** | Một bên không có |
| **Lệch** | Hai bên áp quy tắc hoặc cho kết quả khác nhau, cần chốt một cách |
| **Lỗi web** / **Lỗi app** | Sai so với dữ liệu, với thiết kế, hoặc tự mâu thuẫn trong chính nền tảng đó |

Lưu ý thời điểm chụp: ở S19, web chụp sau khi app đã đặt chỗ A08 nên A08 bị khóa trên web, còn app chụp trước khi đặt. Đây không phải khác biệt.

## 1. Tóm tắt

Đã đối chiếu **62 màn** (S01–S66), gồm **285 chi tiết** ở mục 3, gộp lại thành **81 tính năng** ở mục 2:

| Kết luận | Số chi tiết (mục 3) | Số tính năng (mục 2) |
| --- | --- | --- |
| Giống | 88 | 16 |
| Khác | 101 | 25 |
| Chỉ web | 42 | 12 |
| Chỉ app | 22 | 13 |
| Lệch | 13 | 8 |
| Lỗi web | 6 | 1 |
| Lỗi app | 12 | 6 |
| Chưa kiểm | 1 | — |

Những điểm **giống nhau** cho thấy hai nền tảng thật sự dùng chung dữ liệu:

- Cùng 14 chuyến cho TP.HCM → Lâm Đồng ngày 15/11. Lọc Giường nằm ra cùng 6 chuyến, cùng thứ tự.
- Chỗ A09 do web bán hiện "không đặt được" trên app. Đơn và vé đặt ở nền tảng này hiện ngay ở nền tảng kia.
- Cùng báo giá hủy vé VXNTXEBEZ: đã trả 290.000đ, hoàn 50% = 145.000đ.
- Cùng thông báo khi lưu mã sai: "Mã khuyến mãi chưa hoặc hết hiệu lực."
- Mã VEXENHANH50 cho cùng kết quả −43.500đ, tổng 246.500đ.
- Voucher `HE2026`, hành khách đã lưu "Trần Văn Bảo", cài đặt thông báo, 7 phiên đăng nhập: thao tác ở web hiện đúng trên app.

Các điểm **cần Khanh quyết hoặc cần sửa**, xếp theo mức (đầy đủ ở mục 4):

| Mức | Vấn đề | Màn |
| --- | --- | --- |
| Cao | App "Đánh giá của tôi" hiện dữ liệu mẫu (nhà xe không có trong hệ thống) | S47 |
| Cao | Ba số tổng đài khác nhau; số của web (1900 6067) trùng số tổng đài nhà xe Phương Trang | S01, S38, S54 |
| Cao | VNPay sandbox trả lỗi 99 cho tra cứu giao dịch (`querydr`) và hoàn tiền | mục 5 |
| Trung bình | Web tick sẵn ô "Tôi đã đọc và đồng ý điều khoản"; app để trống và khóa nút | S61 |
| Trung bình | Tra cứu vé: web chỉ hiện đơn theo mã, app hiện mọi đơn của email; đơn tài khoản web cho xem, app chặn | S32, S33 |
| Trung bình | Tên hành khách từng chỗ: web bắt buộc, app tùy chọn | S58 |
| Trung bình | App Khám phá: 3 chuyên mục viết cứng, chọn "Cẩm nang" ra trống; web 6 chuyên mục | S23 |
| Trung bình | Thông báo (snackbar) của app không tự tắt, che nút và lỗi ở màn OTP | S33, S39 |
| Trung bình | Kết quả tra cứu trên web thiếu dòng ưu đãi: 290.000đ + 0đ nhưng "Đã thanh toán 246.500đ" | S32 |
| Trung bình | Web vẫn ghi "Áp dụng voucher khi đặt vé trên web hiện chưa khả dụng" dù đã áp dụng được | S44 |
| Trung bình | Bộ chọn ngày của app hiện tiếng Anh | S05 |

## 2. Ma trận tính năng

Cột **Màn** trỏ tới ảnh ở mục 3.

### 2.1. Trang chủ, điều hướng, nội dung

| Tính năng | Web | App | KL | Màn |
| --- | --- | --- | --- | --- |
| Điều hướng chính | Thanh bên trái: Khám phá, Trang chủ, Mua vé, Hành trình, Thành viên, Tra cứu vé, Khiếu nại, Câu hỏi thường gặp | Dock 5 tab: Khám phá, Mua vé, Trang chủ, Hành trình, Tài khoản | Khác | S01 |
| Form tìm chuyến trên trang chủ | Có, ngày đi để trống | Có, ngày đi mặc định là ngày mai | Lệch | S01 |
| Lời chào theo tên khi đã đăng nhập | Không | Có ("Xin chào, Nguyễn Văn An!") | Chỉ app | S40 |
| Chuông thông báo + hộp thư | Không | Có | Chỉ app | S40, S50 |
| Ưu đãi nổi bật (mã công khai) | Không | Có | Chỉ app | S01 |
| Tuyến phổ biến | 7 tuyến, có đánh giá, km, thời gian | 3 tuyến, giá "Chỉ từ" | Khác | S01 |
| Nhà xe tiêu biểu | 5 nhà xe | 3 nhà xe | Khác | S01 |
| Khám phá theo vùng, lợi ích dịch vụ, quảng bá hạng thành viên | Có | Không | Chỉ web | S01 |
| Cẩm nang trên trang chủ | 3 bài | 3 bài (cùng bài) | Giống | S01 |
| Khối hỗ trợ | Ở chân trang | Khối riêng: Trung tâm trợ giúp, Gọi tổng đài, Góp ý | Khác | S01 |
| Nút ngôn ngữ | Có nút "VI" nhưng chưa đổi được ngôn ngữ | Không | Lỗi web | S01 |
| Khám phá: chuyên mục bài viết | 6 chuyên mục lấy từ CMS, có số bài | 3 chip viết cứng, lọc sai | Lỗi app | S23 |
| Khám phá: tìm bài, đọc bài | Có | Có | Giống | S24, S25 |
| Khuyến mãi trong tab Khám phá | Không | Có | Chỉ app | S23 |

### 2.2. Tìm chuyến, chi tiết chuyến, nhà xe

| Tính năng | Web | App | KL | Màn |
| --- | --- | --- | --- | --- |
| Gợi ý địa danh, gõ không dấu | Có | Có, cùng danh sách và thứ tự | Giống | S04 |
| Chọn ngày | Lịch tiếng Việt, tuần bắt đầu Thứ Hai | Hộp thoại tiếng Anh, tuần bắt đầu Chủ Nhật | Lỗi app | S05 |
| Số hành khách | 1–10, danh sách chọn | 1–10, bảng tăng giảm + "Xác nhận" | Khác | S06 |
| Tìm theo nhà xe | Có ô tìm nhà xe; cho chọn "Tất cả tuyến" | Không có ô tìm; bắt buộc chọn tuyến | Lệch | S07 |
| Tìm chỉ theo ngày (không chọn điểm) | Có, ở trang Mua vé | Tab Mua vé liệt kê chuyến 14 ngày tới | Khác | S08, S26 |
| Kết quả tìm | 14 chuyến | 14 chuyến | Giống | S09 |
| Dải đổi ngày 5 ngày | Có | Có | Giống | S09, S12 |
| Bộ lọc: giờ, dạng chỗ, hạng xe, giá | Có (giá nhập Từ/Đến) | Có (giá kéo thanh trượt) | Khác | S10 |
| Bộ lọc: tiện ích, nhà xe | Không | Có | Chỉ app | S10 |
| Sắp xếp | 3 cách | 5 cách (thêm giá cao→thấp, đánh giá cao nhất) | Khác | S11 |
| Chi tiết chuyến: ảnh, tiện ích, lịch trình, chính sách hủy | Có | Có | Giống | S14 |
| Bản đồ điểm dừng | Có (Goong) | Không | Chỉ web | S14 |
| Xem trước sơ đồ chỗ, số chỗ còn | Có | Không | Chỉ web | S14 |
| Đánh giá nhà xe ngay ở chi tiết chuyến | Có | Không (xem ở trang nhà xe) | Chỉ web | S14 |
| Chia sẻ chuyến | Không | Có | Chỉ app | S14 |
| Trang nhà xe: chỉ số, tuyến, đánh giá | Có, đánh giá có sắp xếp | Có, kèm nút gọi + email nhà xe | Khác | S17 |
| Mua vé theo nhà xe: lọc khu vực, tuyến | Có | Có, nhưng danh sách không xếp theo ABC tiếng Việt | Lỗi app | S27 |

### 2.3. Đặt vé và thanh toán

| Tính năng | Web | App | KL | Màn |
| --- | --- | --- | --- | --- |
| Chọn điểm đón/trả | Ngay trên trang | Bảng chọn riêng | Khác | S19, S20 |
| Sơ đồ 2 tầng | Hiện cả hai tầng | Tab Tầng dưới / Tầng trên | Khác | S19 |
| Giữ chỗ 10 phút có đồng hồ | Có | Có | Giống | S58 |
| Thông tin liên hệ điền sẵn | Có | Có | Giống | S58 |
| Tên hành khách từng chỗ | Bắt buộc | Tùy chọn | Lệch | S58 |
| Chọn hành khách đã lưu | Có | Có | Giống | S58b |
| Ghi chú cho nhà xe | Có (tối đa 300 ký tự) | Không | Chỉ web | S58 |
| Ví voucher khi đặt | Có, báo trước mã không đủ điều kiện | Có, không báo trước | Khác | S59 |
| Nhập mã khuyến mãi | Có | Có, cùng kết quả | Giống | S60 |
| Màn xác nhận đặt vé riêng | Không (gộp vào trang thanh toán) | Có | Khác | S61 |
| Đồng ý điều khoản | Tick sẵn | Phải tự tick | Lệch | S61 |
| Phương thức thanh toán | VNPay, MoMo | payOS, MoMo, VNPay, cổng thử (demo) | Lệch | S62 |
| VNPay sandbox | Chuyển trang | Mở trong ứng dụng (WebView) | Khác | S63 |
| Chờ kết quả | Tự kiểm tra lại 3 giây/lần | Bấm "Kiểm tra trạng thái thanh toán" | Khác | S64 |
| Màn thành công | Chi tiết thanh toán + danh sách vé + In vé | Vé dạng vé in, lật từng vé | Khác | S65 |
| In vé / tải vé | In bằng trình duyệt | Nút PDF báo "chưa hỗ trợ" | Lỗi app | S65 |

### 2.4. Hành trình, chi tiết vé, hủy vé

| Tính năng | Web | App | KL | Màn |
| --- | --- | --- | --- | --- |
| Phân loại đơn | 4 tab: Sắp tới, Đã đi, Đã hủy, Tất cả | Một danh sách chung | Khác | S51–S53 |
| Tìm đơn theo mã hoặc tuyến | Có | Không | Chỉ web | S51 |
| Hủy vé ngay từ danh sách | Có | Không | Chỉ web | S51 |
| Trạng thái hoàn tiền trong danh sách | Không (chỉ "Đã hủy / hết hạn") | Có ("Hoàn tiền lỗi") | Lệch | S53 |
| Mở đơn hết hạn thanh toán | Không ("Chưa phát hành vé") | Có | Khác | S53 |
| Vé QR, ẩn QR khi vé hủy | Có | Có | Giống | S54, S56 |
| Phóng to vé | Không | Có | Chỉ app | S54 |
| In vé, chia sẻ vé | Có | Không | Chỉ web | S54 |
| Bản đồ điểm đón + chỉ đường | Có | Không | Chỉ web | S54 |
| Mốc hoàn tiền theo giờ cụ thể + "Hiện tại được hoàn 50%" | Không (mốc tương đối) | Có | Chỉ app | S54 |
| Mô phỏng hành trình | Không | Có (bật bằng cờ build `JOURNEY_DEMO_ENABLED`) | Chỉ app | S54 |
| Đánh giá trong chi tiết vé | Không (ở "Đánh giá của tôi") | Có | Chỉ app | S55 |
| Số tiền hoàn và mã hoàn tiền trên vé đã hủy | Không | Có | Chỉ app | S56 |
| Hủy vé | Nhiều vé một lần, lý do tự nhập | Từng vé, lý do chọn sẵn | Khác | S57 |

### 2.5. Tra cứu vé, đăng nhập

| Tính năng | Web | App | KL | Màn |
| --- | --- | --- | --- | --- |
| Tra cứu vé không đăng nhập | Mã đặt vé (tùy chọn) + email | Chỉ email | Khác | S30 |
| OTP tra cứu | 6 ô, 5 phút, 5 lần thử | 6 ô, 5 phút | Giống | S31 |
| Phạm vi kết quả | Một đơn theo mã | Mọi đơn của email | Lệch | S32 |
| Đơn đặt bằng tài khoản | Hỏi đăng nhập, vẫn cho xem | Chặn, yêu cầu đăng nhập | Lệch | S33 |
| Đăng nhập email + OTP | Hộp thoại | Màn riêng, hiện ngay khi mở app | Khác | S36, S38 |
| Đăng nhập Google | Không | Có nút | Chỉ app | S36 |
| Facebook, Apple | Không | Nút "Chưa được tích hợp" | Chỉ app | S36 |
| Báo OTP sai | "Thông tin đăng nhập không hợp lệ." | Bị snackbar che, không thấy lỗi | Lỗi app | S39 |

### 2.6. Tài khoản, hỗ trợ

| Tính năng | Web | App | KL | Màn |
| --- | --- | --- | --- | --- |
| Hồ sơ, sửa hồ sơ | Có | Có, thêm ảnh đại diện | Khác | S41, S42 |
| Hành khách đã lưu | Có | Có, hiện giới hạn "1/5" | Giống | S43 |
| Ví voucher: lưu mã | Có | Có | Giống | S44 |
| Ví voucher: tab Khả dụng / Đang giữ / Đã dùng / Hết hạn | Có | Không | Chỉ web | S44 |
| VXN Plus | Có | Có, thêm lối tắt | Giống | S45 |
| Lịch sử điểm: tổng, lọc loại, lọc thời gian | Có | Không (chỉ trạng thái trống) | Chỉ web | S46 |
| Đánh giá của tôi | Dữ liệu thật | Dữ liệu mẫu | Lỗi app | S47 |
| Cài đặt thông báo | Từng loại, tách kênh Email/Push | Gộp nhóm, một công tắc mỗi loại | Khác | S48 |
| Phiên đăng nhập | Có | Có | Giống | S49 |
| Khiếu nại có hội thoại, đính kèm | Có | Không | Chỉ web | S66 |
| Câu hỏi thường gặp | Trang riêng, có ô tìm | Bảng trong Trung tâm trợ giúp, không có ô tìm | Khác | S28 |
| Trang pháp lý | `/legal/*` | Chỉ trong bảng điều khoản ở bước đặt vé | Khác | S29 |

## 3. Đối chiếu từng màn

### S01 · Trang chủ (khách) — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S01-so-sanh-trang-chu.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Lời chào | "ĐẶT VÉ XE KHÁCH TRỰC TUYẾN — Đi Việt Nam. Nhanh hơn, gọn hơn." | "Xin chào! Bạn muốn đi đâu?" | Khác |
| Mời đăng nhập | Nút "Đăng nhập" ở thanh bên | Thẻ "Đăng nhập để lưu hành trình, xem vé của bạn và nhận ưu đãi. Đăng nhập →" | Khác |
| Chế độ tìm | "Theo chuyến" / "Theo nhà xe" | "Theo chuyến" / "Theo nhà xe" | Giống |
| Ô điểm đi/đến | Ô gõ, gợi ý "Tỉnh, phường/xã, bến xe" | Nút mở bảng chọn | Khác |
| Nút đảo chiều | Có, nhãn trợ năng "Đảo chiều điểm đi - điểm đến" | Có, **không có nhãn trợ năng** (TalkBack đọc trống) | Lỗi app |
| Ngày đi mặc định | Trống ("Chọn ngày") | Ngày mai | Lệch |
| Số khách mặc định | "1 hành khách" | "1 khách" | Giống |
| Ưu đãi nổi bật | — | 2 mã: SAOVIET40K (Giảm 40K, đơn từ 300K), TOANTHANG25K (Giảm 25K, đơn từ 200K) | Chỉ app |
| Tuyến phổ biến | 7 tuyến + "Xem tất cả tuyến"; thẻ đầu có đánh giá 4.9, 305 km, 6 tiếng 40 phút, dạng chỗ, "Đặt vé ngay" | 3 tuyến: TP.HCM → Lâm Đồng 250.000đ, → An Giang 220.000đ, → Khánh Hòa 250.000đ ("Chỉ từ") | Khác |
| Giá "từ" của tuyến | 250.000đ / 220.000đ | 250.000đ / 220.000đ | Giống |
| Tên tỉnh | "TP. Hồ Chí Minh" | "TP.HCM" | Khác |
| Khám phá theo vùng | "KHÁM PHÁ — Hành trình • Văn hóa • Ẩm thực" | — | Chỉ web |
| Lợi ích dịch vụ | "Chuyến đi đầu tiên?" + 4 thẻ: Vé điện tử QR, Chính sách hủy rõ ràng, Tích điểm thành viên, Hỗ trợ khách hàng | — | Chỉ web |
| Nhà xe | "Nhà xe đối tác": 5 nhà xe + "Xem các nhà xe" | "Nhà xe nổi bật": 3 nhà xe, cùng thứ tự | Khác |
| Hạng thành viên | "HẠNG THÀNH VIÊN — Tích điểm cùng Vé xe nhanh" (viết thường "xe nhanh") | — | Chỉ web |
| Cẩm nang | "Cẩm nang xe khách — Tin tức →", 3 bài | "Khám phá & cẩm nang — Xem tất cả ›", cùng 3 bài | Giống |
| Hỗ trợ | Chân trang: Hotline **1900 6067**, support@vexenhanh.vn | "Luôn sẵn sàng hỗ trợ — **Support Station** — Trạm hỗ trợ hành trình": Liên hệ hỗ trợ, Trung tâm trợ giúp, Gọi tổng đài **1900 636 707**, Góp ý | Lệch |
| Chuông thông báo | — | Có | Chỉ app |
| Nút ngôn ngữ | "VI", bấm không đổi ngôn ngữ | — | Lỗi web |

### S04 · Gợi ý điểm đi "Ho Chi Minh" — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S04-so-sanh-goi-y-diem-di.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Gõ không dấu | Ra kết quả | Ra kết quả | Giống |
| Dòng đầu | "Thành phố Hồ Chí Minh" | "TP. Hồ Chí Minh" | Khác |
| Danh sách bến | Bà Rịa, Củ Chi, Quận 8, Bến Cát, Chợ Lớn, Hóc Môn, Tân Phú | Cùng danh sách, cùng thứ tự | Giống |
| Địa chỉ dưới tên bến | Có | Có | Giống |
| Kiểu hiển thị | Danh sách thả xuống dưới ô | Bảng "Chọn điểm đi" có ô tìm | Khác |

### S05 · Chọn ngày đi — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S05-so-sanh-chon-ngay.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Ngôn ngữ | Tiếng Việt: "Tháng 11, 2026", T2…CN | **Tiếng Anh**: "Sat, Nov 14", "Select year", "Switch to input", Cancel/OK | Lỗi app |
| Ngày đầu tuần | Thứ Hai | Chủ Nhật | Khác |
| Ngày quá khứ | Khóa, nút "Tháng trước" khóa | Khóa | Giống |
| Kiểu | Lịch thả xuống | Hộp thoại Material, có nhập tay | Khác |
| Giới hạn xa nhất | Chưa kiểm | 365 ngày | — |

### S06 · Chọn số hành khách — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S06-so-sanh-chon-so-khach.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Kiểu | Danh sách "1 hành khách" … "10 hành khách" | Bảng tăng giảm "N khách" + "Xác nhận" | Khác |
| Tối đa | 10 | 10 | Giống |

### S07 · Tìm theo nhà xe — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S07-so-sanh-tim-theo-nha-xe.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Ô tìm nhà xe | "Tìm nhà xe" | — | Chỉ web |
| Thông tin mỗi nhà xe | Chữ viết tắt, điểm, số đánh giá | Điểm, số đánh giá, **số tuyến** ("· 2 tuyến"; Nhà xe Hoa Mai "0 tuyến") | Khác |
| Thứ tự nhà xe | Phương Trang, An Anh, Hải Vân, Chín Nghĩa, Đồng Phước… | Cùng thứ tự | Giống |
| Chọn tuyến | Cho phép "Tất cả tuyến" | Bắt buộc chọn: "Vui lòng chọn tuyến của nhà xe." | Lệch |

### S08 · Tìm khi thiếu điểm đến — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S08-so-sanh-tim-thieu-diem-den.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Thông báo trên trang chủ | "Chọn ngày đi và hai điểm khác nhau từ danh sách gợi ý." | "Vui lòng chọn điểm đi và điểm đến từ danh mục." | Khác |
| Tìm chỉ theo ngày | Được ở trang Mua vé: "Điểm đi (tùy chọn)", "Có thể chỉ chọn ngày đi để xem chuyến trên mọi tuyến." | Tab Mua vé liệt kê "Chuyến sắp chạy trong 14 ngày tới" | Khác |

### S09 · Kết quả TP.HCM → Lâm Đồng 15/11 — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S09-so-sanh-ket-qua-tim-chuyen.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Số chuyến | "14 chuyến đang mở bán" | "14 chuyến phù hợp" | Giống |
| Sửa tìm kiếm | Form đầy đủ trên đầu trang | Nút "Sửa tìm kiếm" | Khác |
| Dải ngày | T6 13/11 → T3 17/11 | Thứ 6 13/11 → Thứ 3 17/11 | Giống |
| Bộ lọc | Cột trái luôn hiện | Nút mở bảng | Khác |
| Sắp xếp | 3 nút | 1 nút mở bảng | Khác |
| Thời gian đi | "6 giờ 15 phút" | "6h15" | Khác |
| Điểm đón/trả trên thẻ | Tên điểm đầy đủ + dòng "Đón: … • Trả: …" | Tên địa phương ngắn: "TP.HCM", "Đức Trọng" | Khác |
| Tiện ích trên thẻ | Đủ 8 tiện ích | Một dòng rút gọn | Khác |
| Giá | "290.000đ từ / chỗ" | "Từ 290.000 ₫" | Khác |
| Thứ tự chuyến | Phương Trang 07:30, Hạnh Cafe 08:00… | Cùng thứ tự | Giống |

### S10 · Bộ lọc chuyến — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S10-so-sanh-bo-loc.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Giờ khởi hành | 00:00–06:00, 06:00–12:00, 12:00–18:00, 18:00–24:00 | Có tên buổi: Sáng sớm 00:00–05:59, Sáng, Chiều, Tối 18:00–24:00 | Khác |
| Dạng chỗ | Ghế ngồi, Giường nằm, Cabin | Ghế ngồi, Giường nằm, Cabin | Giống |
| Hạng xe | "Tiêu chuẩn", "Limousine" | "Thường", "Limousine" | Khác |
| Khoảng giá | 2 ô nhập Từ/Đến (VND) | Thanh trượt 280.000–460.000 | Khác |
| Tiện ích | — | 11 tiện ích | Chỉ app |
| Nhà xe | — | Có | Chỉ app |
| Nút | "Áp dụng", "Xóa lọc" | "Áp dụng", "Đặt lại" | Giống |

### S11 · Sắp xếp — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S11-so-sanh-sap-xep.png)

Ảnh web dùng lại ảnh S10 vì nút sắp xếp nằm trên trang kết quả.

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Lựa chọn | Giờ đi sớm, Giá thấp, Đi nhanh nhất | Khởi hành sớm nhất, Giá từ thấp đến cao, **Giá từ cao đến thấp**, Thời gian di chuyển ngắn nhất, **Đánh giá cao nhất** | Khác |
| Mặc định | Giờ đi sớm | Khởi hành sớm nhất | Giống |

### S12 · Đổi ngày — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S12-so-sanh-doi-ngay.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Đổi ngày trên trang kết quả | Dải 5 ngày + ô ngày trong form | Dải 5 ngày + "Sửa tìm kiếm" | Giống |

### S13 · Lọc Giường nằm — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S13-so-sanh-ket-qua-sau-loc.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Số chuyến sau lọc | 6 | 6 | Giống |
| Thứ tự | Theo giờ đi | Cùng thứ tự | Giống |

### S14 · Chi tiết chuyến Phương Trang 07:30 — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S14-so-sanh-chi-tiet-chuyen.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Ảnh xe, tiện ích | Có | Có | Giống |
| Lịch trình, điểm đón/trả | "Lịch trình và điểm dừng" | "Lịch trình", "Điểm đón / Điểm trả" | Giống |
| Bản đồ điểm dừng | "Vị trí các điểm dừng" (Goong) | — | Chỉ web |
| Sơ đồ chỗ xem trước | "Còn 30 / 32 chỗ" | — | Chỉ web |
| Chính sách hủy | 24 giờ 90%, 4 giờ 50%, 0% | Cùng mốc | Giống |
| Mốc ngừng bán online | Có | — | Chỉ web |
| Lịch chạy cố định | "07:30" | — | Chỉ web |
| Đánh giá nhà xe | Có + "Xem tất cả" | — | Chỉ web |
| Mục "Lưu ý" | — | Có | Chỉ app |
| Chia sẻ chuyến | — | Có | Chỉ app |
| Nút đặt | Khung bên: Ngày đi, Hành khách, "Tạm tính từ", "Chọn ghế" | Thanh dưới: "Từ … / người", "Chọn chỗ" | Khác |
| Gợi ý thanh toán, hỗ trợ | "Chọn VNPay hoặc MoMo…", "Trung tâm hỗ trợ" | — | Chỉ web |
| Đến trang nhà xe | "Xem trang nhà xe" | "Xem nhà xe" | Giống |

### S17 · Trang nhà xe — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S17-so-sanh-trang-nha-xe.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Chỉ số chất lượng | Đánh giá trung bình, Hủy chuyến do nhà xe, Đơn có hoàn tiền / tranh chấp, Tỷ lệ check-in | Cùng chỉ số + chú thích "Tính từ đánh giá và dữ liệu vận hành trên Vé Xe Nhanh" | Giống |
| Liên hệ nhà xe | — | Nút gọi 19006067, email hotro@futabus.vn | Chỉ app |
| Tuyến | "Tuyến tiêu biểu" | "Tuyến đang mở bán" | Giống |
| Đánh giá | Sắp xếp Mới nhất / Cao nhất trang / Thấp nhất trang + "Xem thêm đánh giá" | Danh sách 6 đánh giá, không sắp xếp | Chỉ web |
| Tên người đánh giá | Che: "Nguyễn Văn A***" | Che như web | Giống |
| Nút tìm chuyến | "Tìm chuyến của nhà xe" | "Xem chuyến của nhà xe" | Giống |
| Điều khoản dịch vụ của nhà xe | Có | Có | Giống |

### S19 · Chọn chỗ (A09 đã bán) — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S19-so-sanh-chon-cho-co-ghe-da-ban.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Các bước | Chọn ghế / Thông tin hành khách / Thanh toán / Hoàn tất | Chọn ghế / Thông tin / Thanh toán / Hoàn tất | Giống |
| Điểm đón/trả | Chọn ngay: 3 điểm đón (07:30, 08:15, 09:15), 2 điểm trả (13:45, 14:30) | 2 nút mở bảng, mặc định điểm đầu | Khác |
| Ghi chú điểm đón | "Điểm đón phải đứng trước điểm trả… Văn phòng nhà xe có xe trung chuyển miễn phí ra bến." | — | Chỉ web |
| Hai tầng | Hiện cùng lúc A01–A16, B01–B16 | Tab "Tầng dưới" / "Tầng trên" | Khác |
| Chỗ đã bán A09 | Khóa | "Giường nằm A09, không đặt được" | Giống |
| Ghi chú loại chỗ | "Chỗ đang giữ hoặc đã đặt không chọn được. Giường đôi bán nguyên chỗ cho 1–2 hành khách." | — | Chỉ web |
| Giới hạn số chỗ | "Đã chọn 0 / 10 chỗ" | Không hiện | Khác |
| Tóm tắt chuyến | Khung "CHUYẾN ĐI" bên phải | Thẻ đầu trang: nhà xe, 5.0, ngày, 07:30–13:45, 6h15 | Khác |
| Chưa chọn chỗ | "Vui lòng chọn ít nhất một chỗ trên sơ đồ.", "Tiếp tục" khóa, "Đổi chuyến khác" | "0 ₫ — Chưa chọn chỗ — Tiếp tục" | Khác |

### S20 · Chọn điểm đón — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S20-so-sanh-chon-diem-don.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Kiểu chọn | Ngay trên trang chọn chỗ (ảnh S19) | Bảng "Chọn điểm đón": giờ, tên, địa chỉ + "Xác nhận" | Khác |
| Danh sách | 3 điểm | Cùng 3 điểm | Giống |

### S23 · Khám phá bài viết — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S23-so-sanh-kham-pha.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Chuyên mục | 6, có số bài: Tất cả (20), Cẩm nang du lịch (4), Kinh nghiệm đi xe khách (4), Tuyến đường nổi bật (4), Ẩm thực vùng miền (4), Tin tức & Khuyến mãi (4) | 3 chip viết cứng: Tất cả, Cẩm nang, Mẹo du lịch | Lỗi app |
| Lọc chuyên mục | Đúng | Chọn "Cẩm nang" → "Chưa có bài viết phù hợp. Hãy thử chuyên mục khác." | Lỗi app |
| Bài nổi bật | Thẻ "NỔI BẬT" | Thẻ lớn đầu trang, cùng bài | Giống |
| Khuyến mãi | — | "Khuyến mãi nổi bật — Xem tất cả ›" | Chỉ app |
| Ô tìm | "Tìm bài viết trong trang này" | "Tìm bài viết, cẩm nang..." | Giống |

### S24 · Tìm bài "QR" — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S24-so-sanh-kham-pha-tim-qr.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Kết quả | 1 bài "Hướng dẫn sử dụng mã vé điện tử QR…" | Cùng 1 bài | Giống |
| Trạng thái trống | — | Bài tìm được hiện ở thẻ lớn, ngay dưới lại ghi "Bài viết mới nhất: Chưa có bài viết trong chuyên mục này." | Lỗi app |

### S25 · Chi tiết bài viết — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S25-so-sanh-chi-tiet-bai-viet.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Điều hướng | Đường dẫn "Khám phá › Kinh nghiệm đi xe khách" + "Tất cả bài viết" | Nút "Quay lại" | Khác |
| Thông tin bài | "Xuất bản 20/04/2026" | "20/04/2026 · 3 phút đọc · Vé Xe Nhanh" | Khác |
| Nội dung, đề mục | Giới thiệu tổng quan, Điểm nhấn nổi bật…, Kinh nghiệm đặt vé… | Cùng nội dung | Giống |
| Bài cùng chuyên mục | "Cùng chuyên mục" | Không thấy trong 2 ảnh app | Chỉ web |

### S26 · Mua vé – chuyến — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S26-so-sanh-mua-ve-chuyen.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Tab | Chuyến xe / Nhà xe | Chuyến xe / Nhà xe | Giống |
| Bộ tìm | Form: Điểm đi (tùy chọn), Điểm đến (tùy chọn), Ngày đi, Hành khách, "Tìm chuyến" | Chip: Ngày đi, 1 khách, Điểm đi, Điểm đến, Bộ lọc | Khác |
| Dải ngày | 5 ngày | — | Chỉ web |
| Danh sách | Chuyến của ngày đang chọn (CN 15/11), "Mọi chuyến sắp chạy — Xem tất cả, lọc và sắp xếp" | "Chuyến sắp chạy trong 14 ngày tới", bắt đầu từ Thứ Bảy 14/11 | Khác |
| Sắp xếp mặc định | Giờ đi sớm nhất | Giờ đi sớm nhất | Giống |

### S27 · Mua vé – nhà xe — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S27-so-sanh-mua-ve-nha-xe.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Bộ lọc | 2 ô chọn "Khu vực", "Tuyến phục vụ" + "Áp dụng" | 3 chip "Khu vực", "Tuyến phục vụ", "Bộ lọc" (bảng "Lọc nhà xe" gồm 2 lựa chọn + "Áp dụng") | Khác |
| Danh sách khu vực | 18 tỉnh/thành, xếp ABC tiếng Việt | Cùng 18, nhưng xếp theo mã ký tự: "TP. Đà Nẵng" sau "TP. Hồ Chí Minh", "Tuyên Quang" trước "Tây Ninh", "Điện Biên" và "Đắk Lắk" ở cuối | Lỗi app |
| Danh sách tuyến | 25 tuyến, tên đầy đủ | Cùng tuyến, viết "TP.HCM", cùng lỗi xếp thứ tự | Lỗi app |
| Ngày tính giá | Dải ngày + "Đánh giá cao • giá vé ngày T7, 14/11/2026" | Không có ngày, chỉ "Đánh giá cao" | Khác |
| Thẻ nhà xe | Điểm, "Tuyến đang phục vụ … +1 tuyến", "Giá vé từ 290.000đ", "Xem chuyến" | Cùng nội dung, "290.000 ₫" | Giống |

### S28 · Câu hỏi thường gặp — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S28-so-sanh-cau-hoi-thuong-gap.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Vị trí | Trang riêng "Câu hỏi thường gặp" | Bảng "Trung tâm trợ giúp" | Khác |
| Ô tìm | "Tìm câu hỏi, ví dụ: hủy vé, hoàn tiền, giữ chỗ" | — | Chỉ web |
| Gợi ý nhanh | Hủy vé, Hoàn tiền, Tra cứu vé, Điểm VXN Plus | — | Chỉ web |
| Câu hỏi | 18 câu ("18 câu hỏi") | Cùng câu hỏi, cùng thứ tự | Giống |
| Cuối trang | "Chưa tìm thấy câu trả lời? … Trung tâm hỗ trợ" | — | Chỉ web |

### S29 · Điều khoản — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S29-so-sanh-dieu-khoan.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Truy cập | Trang `/legal/*`, 5 văn bản: Quy chế hoạt động, Giới thiệu, Chính sách bảo mật, Cơ chế giải quyết tranh chấp, Hướng dẫn đặt vé | Chỉ trong bảng "Điều khoản và chính sách" ở bước xác nhận đặt vé (ảnh lấy từ M36c) | Khác |
| Ngày cập nhật | "Cập nhật lần cuối 30/10/2026" | — | Chỉ web |

### S30 · Tra cứu vé – nhập thông tin — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S30-so-sanh-tra-cuu-ve.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Lối vào | Menu "Tra cứu vé" | Tab Hành trình khi chưa đăng nhập; mục trong Tài khoản | Khác |
| Mã đặt vé | "Mã đặt vé hoặc mã vé (không bắt buộc)", ví dụ "VXN-4H9P6C" | — | Chỉ web |
| Email | "Email liên hệ của đơn *" | "Email liên hệ" | Giống |
| Nút | "Gửi mã xác minh" (khóa khi trống) | "Nhận mã OTP" | Giống |
| Hướng dẫn | 3 bước; "Không còn dùng email đặt vé? Gọi CSKH 1900 6067"; "Đã có tài khoản? Đăng nhập để xem toàn bộ vé" | "Cần hỗ trợ?": Câu hỏi thường gặp, Liên hệ hỗ trợ; nút "Đăng nhập" | Khác |

### S31 · Tra cứu vé – OTP — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S31-so-sanh-tra-cuu-nhap-otp.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Email che | "n***@example…" | "n***@example.com" | Giống |
| Ô nhập | 6 ô | 6 ô | Giống |
| Hiệu lực | "Mã hết hạn sau 05:00" | "Mã hết hạn sau 04:54" (đếm ngược) | Giống |
| Số lần thử còn lại | "Còn 5 lần thử" | — | Chỉ web |
| Gửi lại | "Gửi lại sau 60 giây" | "Gửi lại sau 54s" | Giống |
| Sửa thông tin | "Đổi mã đặt vé hoặc email" | "Thay đổi thông tin tra cứu" | Giống |
| Nút | "Xác minh" | "Xác nhận OTP" | Giống |

### S32 · Tra cứu vé – kết quả — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S32-so-sanh-tra-cuu-ket-qua.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Phạm vi | Chỉ đơn có mã đã nhập: "chỉ hiển thị đơn VXNLK7ELH" | Mọi đơn của email: "Đơn của bạn (6)", gồm đơn hết hạn và đơn hoàn tiền lỗi | Lệch |
| Phiên tra cứu | "Phiên còn 14:57" + "Kết thúc phiên" | "Email đã xác minh … Thay đổi" | Khác |
| Nội dung | Chi tiết một đơn: vé, chỗ, mã vé, "Xem mã QR", điểm đón/trả, thanh toán | Danh sách thẻ đơn + "Xem vé" | Khác |
| Khối thanh toán | Giá vé 290.000đ, Phí dịch vụ 0đ, Đã thanh toán **246.500đ**, **thiếu dòng ưu đãi −43.500đ** | — | Lỗi web |
| Mời tạo tài khoản | "Tạo tài khoản Vé Xe Nhanh" hiện cả khi email đã có tài khoản | — | Lỗi web |
| In thông tin đơn | Có | — | Chỉ web |

### S33 · Tra cứu – đơn đặt bằng tài khoản — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S33-so-sanh-tra-cuu-don-tai-khoan.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Xử lý | Hộp thoại "Bạn có muốn đăng nhập không? Email n***@example.com đã có tài khoản…"; chọn "Tiếp tục tra cứu" thì vẫn xem chi tiết, không hủy/khiếu nại được | Không mở đơn; snackbar "Đơn VXNLK7ELH đặt bằng tài khoản. Đăng nhập để xem và hủy vé." + "Đăng nhập" | Lệch |
| Thời gian hiện snackbar | — | **Không tự tắt**, còn hiện sang màn đăng nhập và OTP (S38, S39) | Lỗi app |

### S34 · Hành trình khi chưa đăng nhập — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S34-so-sanh-hanh-trinh-khach.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Nội dung | "Vui lòng đăng nhập — Đăng nhập bằng email để xem và quản lý **tài khoản** của bạn." | Form tra cứu vé khách vãng lai (như S30) | Khác |

### S35 · Tài khoản khi chưa đăng nhập — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S35-so-sanh-tai-khoan-khach.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Nội dung | "Vui lòng đăng nhập" + nút "Đăng nhập" | "Bạn chưa đăng nhập" + 4 lợi ích (Hành khách đã lưu, Ví voucher, Điểm VXN Plus, Đánh giá chuyến đi) + "Đăng nhập / Đăng ký" | Khác |
| Lối tra cứu vé | — | "Tra cứu vé đã đặt — Không cần đăng nhập: **dùng mã đặt vé và email**", nhưng form tra cứu của app chỉ có email | Lỗi app |
| Tổng đài | — | "Tổng đài hỗ trợ 1900 636 707" | Chỉ app |

### S36 · Đăng nhập — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S36-so-sanh-dang-nhap.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Dạng | Hộp thoại "Chào mừng trở lại" | Màn "Đăng nhập", hiện ngay khi mở app | Khác |
| Gợi ý ô email | "tenban@gmail.com" | "tenban@email.com" | Khác |
| Nút | "Tiếp tục với email" | "Tiếp tục" | Giống |
| Giải thích | "Chúng tôi gửi mã xác minh 6 số tới email của bạn. Không cần mật khẩu." | "Nhập email để nhận mã xác minh" | Giống |
| Đăng ký | Liên kết "Chưa có tài khoản? Tạo tài khoản" | Một luồng chung đăng nhập/đăng ký | Khác |
| Google | — | "Đăng nhập bằng Google" | Chỉ app |
| Facebook, Apple | — | Nút "Chưa được tích hợp" | Chỉ app |
| Bỏ qua | Đóng hộp thoại | "Khám phá trước, đăng nhập sau" | Khác |
| Lối tra cứu vé | "Chỉ cần xem vé đã mua? Tra cứu vé ›" | — | Chỉ web |
| Dòng đồng ý điều khoản | — | "Bằng việc tiếp tục, bạn đồng ý với Điều khoản sử dụng và Chính sách dữ liệu…" | Chỉ app |

### S37 · Email sai định dạng — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S37-so-sanh-dang-nhap-email-sai.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Báo lỗi | Bong bóng kiểm tra của trình duyệt (chữ theo trình duyệt) | Chữ đỏ dưới tiêu đề: "Vui lòng nhập một địa chỉ email hợp lệ." | Khác |

### S38 · Nhập mã OTP — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S38-so-sanh-nhap-ma-otp.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Email nhận mã | "Mã gồm 6 số đã gửi tới nguyenvanan.demo@example.com" | "Nếu email hợp lệ, mã xác minh sẽ được gửi đến bạn." (không nêu email) | Khác |
| Ô nhập | 6 ô | 6 ô, dán được cả mã | Giống |
| Hiệu lực | "Mã có hiệu lực trong 5 phút…" (chữ tĩnh) | "Hiệu lực của mã: 04:54" (đếm ngược) | Khác |
| Gửi lại | "Gửi lại mã (sau 59 giây)" | "Gửi lại sau 00:54" | Giống |
| Đổi email | "Đổi email" | "Sửa email" | Giống |
| Tổng đài | — | "Cần hỗ trợ? Liên hệ tổng đài **1900 6868**" (số thứ ba) | Lệch |

### S39 · OTP sai — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S39-so-sanh-otp-sai.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Thông báo khi nhập 000000 | "Thông tin đăng nhập không hợp lệ." | Không thấy chữ lỗi; snackbar của S33 đè lên vùng dưới, che cả nút "Xác minh". Hết giờ mới hiện "Mã đã hết hạn. Hãy gửi lại mã mới." | Lỗi app |

### S40 · Trang chủ đã đăng nhập — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S40-so-sanh-trang-chu-da-dang-nhap.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Cá nhân hóa | Không, trang giống hệt lúc chưa đăng nhập | "Xin chào, Nguyễn Văn An!" | Chỉ app |
| Thông báo chưa đọc | — | Chuông "4 tin chưa đọc" | Chỉ app |
| Các khối còn lại | Như S01 | Như S01 | Giống |

### S41 · Tài khoản — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S41-so-sanh-tai-khoan.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Menu | 9 mục: Hồ sơ, VXN Plus, Hành khách đã lưu, Ví voucher, Lịch sử điểm, Phiên đăng nhập, Cài đặt thông báo, Đánh giá của tôi, **Hỗ trợ** | 7 mục (không có Hỗ trợ) + Đăng xuất | Khác |
| Hồ sơ | Họ tên, Ngày sinh "Chưa cập nhật", Email "Đã xác minh", SĐT | Thẻ đầu: tên, email, SĐT + "Chỉnh sửa" | Giống |
| VXN Plus | "Xem điểm và quyền lợi tại trang VXN Plus" + "Xem VXN Plus" | Thẻ "Hạng Đồng · 0 điểm khả dụng · Xem quyền lợi" | Khác |
| Hành khách đã lưu | "Hành khách đã lưu (0)" + "Thêm hành khách" ngay trên trang | Mục riêng "0/5 hành khách" | Khác |
| Bảo mật | "Mã OTP qua email — Đang dùng"; "Xem các thiết bị đang đăng nhập — Quản lý" | "Phiên đăng nhập & thiết bị" | Giống |
| Đăng xuất | Ở thanh bên, không hỏi lại | Cuối danh sách, không hỏi lại | Giống |

### S42 · Sửa hồ sơ — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S42-so-sanh-sua-ho-so.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Dạng | Khung "Cập nhật hồ sơ" trên đầu trang | Màn "Chỉnh sửa thông tin" | Khác |
| Trường | Họ tên, Số điện thoại, Ngày sinh | Họ và tên *, Ngày sinh, Số điện thoại, Email * (chỉ đọc) | Khác |
| Ngày sinh | Ô ngày của trình duyệt "dd/mm/yyyy" | "Chọn ngày sinh" | Khác |
| Ảnh đại diện | — | Ảnh + nút máy ảnh (chưa thử) | Chỉ app |
| Nút | "Lưu", "Đóng" | "Lưu thay đổi" (khóa khi chưa đổi gì) | Khác |

### S43, S43b · Hành khách đã lưu — [thêm](screenshots/hanh-khach-web-app-12-14-11/S43-so-sanh-them-hanh-khach.png) · [danh sách](screenshots/hanh-khach-web-app-12-14-11/S43b-so-sanh-hanh-khach-da-luu.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Trường | Họ tên, Số điện thoại | Họ và tên *, Số điện thoại | Giống |
| Nút | "Lưu", "Đóng" | "Lưu hành khách" | Giống |
| Sau khi lưu | "Đã lưu thông tin.", "Hành khách đã lưu (1)" | "1/5 hành khách", Trần Văn Bảo 0912 345 678 | Giống |
| Giới hạn 5 người | Không ghi | Ghi "1/5" | Khác |

### S44, S44b · Ví voucher — [ví](screenshots/hanh-khach-web-app-12-14-11/S44-so-sanh-vi-voucher.png) · [mã sai](screenshots/hanh-khach-web-app-12-14-11/S44b-so-sanh-nhap-ma-sai.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Lưu mã | Ô "Nhập mã khuyến mãi, ví dụ THU10" + "Lưu vào ví" (khóa khi trống) | "Nhập mã khuyến mãi" + "Lưu mã" | Giống |
| Mã sai SAIMA123 | "Mã khuyến mãi chưa hoặc hết hiệu lực." | Cùng câu | Giống |
| Tab trạng thái | Khả dụng (1), Đang giữ (0), Đã dùng (0), Hết hạn (0) | Không có tab, dòng "Đang có 1 voucher khả dụng" | Chỉ web |
| Thẻ voucher HE2026 | Tên, "Giảm 10%", "Đơn tối thiểu 300.000đ · Giảm tối đa 80.000đ", "Mã: HE2026", "Hạn dùng 01/01/2027", "Dùng ngay ›" | Tên, "Giảm 10%", "Đơn tối thiểu 300.000đ", "Hạn dùng: 01/01/2027", "Xem điều kiện ›" | Khác |
| Đổi điểm | Nút "Đổi điểm lấy voucher" | Ở trang VXN Plus | Khác |
| Câu hướng dẫn | "**Áp dụng voucher khi đặt vé trên web hiện chưa khả dụng.**" — sai, web đã áp dụng được (S59, S60) | — | Lỗi web |
| Ghi chú quy tắc | "Mỗi mã chỉ lưu một lần…", "Voucher đang giữ chưa thể dùng cho đơn khác…" | — | Chỉ web |

### S45 · VXN Plus — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S45-so-sanh-vxn-plus.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Hạng | "Đồng — Chưa có chính sách — Đã tích 0 điểm trong 12 tháng gần nhất" | "Hạng Đồng — Đã tích 0 điểm trong 12 tháng gần nhất" | Giống |
| Điểm khả dụng | 0 | 0 | Giống |
| Đổi điểm | Nút khóa + "Chưa có chính sách đổi điểm đang áp dụng…" | Cùng câu | Giống |
| Lối tắt | — | "Lịch sử điểm", "Ví voucher", "Tìm chuyến" | Chỉ app |
| Bảng hạng, quy tắc tích, đổi, hạn điểm | 4 mục | Cùng 4 mục, cùng chữ | Giống |

### S46 · Lịch sử điểm — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S46-so-sanh-lich-su-diem.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Tổng | Điểm hiện có, Đã tích, Đã đổi, Đã hết hạn | — | Chỉ web |
| Lọc loại | Tất cả, Tích điểm, Đổi điểm, Hết hạn, Thu hồi, Điều chỉnh | — | Chỉ web |
| Lọc thời gian | 12 / 6 / 3 tháng gần nhất, Tất cả thời gian | — | Chỉ web |
| Khi trống | Bảng "NGÀY / LOẠI / NGUỒN / ĐIỂM", "Chưa có giao dịch điểm trong bộ lọc này.", phân trang | "Chưa có giao dịch điểm — Bạn sẽ thấy lịch sử tích, đổi và hết hạn điểm tại đây." + "Tìm hiểu VXN Plus", "Đổi điểm" | Khác |

### S47 · Đánh giá của tôi — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S47-so-sanh-danh-gia-cua-toi.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Dữ liệu | Thật: "Đã đánh giá (1)" (Phương Trang, 12/11/2026, "Đang hiển thị"); "Không có chuyến đủ điều kiện đang chờ đánh giá." | **Dữ liệu mẫu**: "Chờ đánh giá (3)", "Đã đánh giá (5)" với Phương Nam Travel, Hoàng Long, Queen Cafe (không có trong hệ thống) | Lỗi app |
| Quy tắc | "Bạn chỉ đánh giá được chuyến đã hoàn thành với vé hợp lệ." | — | Chỉ web |

### S48 · Cài đặt thông báo — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S48-so-sanh-cai-dat-thong-bao.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Thông báo bắt buộc | 9 loại liệt kê riêng, khóa: Xác nhận đặt vé, Hủy vé, Hoàn tiền thành công, Thay đổi chuyến, Hủy chuyến, Hoàn tiền thủ công, Cập nhật yêu cầu hỗ trợ, Thông báo vận hành, Thông báo dịch vụ | 4 nhóm "Luôn bật": Bảo mật tài khoản, Vé và thanh toán, Thay đổi hoặc hủy chuyến, Khiếu nại và tranh chấp | Khác |
| Thông báo tùy chọn | 3 loại × 2 kênh (Email, Push) | 3 loại × 1 công tắc | Khác |
| Trạng thái hiện tại | VXN Plus bật, Khuyến mãi bật, Tin tức tắt | Cùng trạng thái | Giống |
| Lưu | "Lưu thay đổi", "Hủy thay đổi" | Không có nút lưu | Khác |
| Ghi chú | "Push chỉ được gửi tới thiết bị đã đăng ký trên ứng dụng…" | — | Chỉ web |

### S49 · Phiên đăng nhập — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S49-so-sanh-phien-dang-nhap.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Số phiên | 7 | 7 | Giống |
| Tên thiết bị | "Chrome **on** Windows", "**Mobile app**" (tiếng Anh) | "Chrome trên Windows", "Ứng dụng di động" | Lỗi web |
| Phiên hiện tại | Phiên web, nhãn "Phiên hiện tại" | Phiên app, "Thiết bị hiện tại — Đang hoạt động" | Giống |
| Thời gian | "Đăng nhập 17:12:19 13/11/2026 · Hoạt động lần cuối 23:38:59…" | "Đăng nhập lúc 17:12 • 13/11/2026", "Hoạt động lúc …" | Khác |
| IP | Che "IP 1:*" | Che như web | Giống |
| Thu hồi | "Thu hồi" từng phiên + "Đăng xuất tất cả phiên khác" | "Đăng xuất" từng phiên + "Đăng xuất tất cả thiết bị khác" | Giống |

### S50 · Hộp thư thông báo — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S50-so-sanh-hop-thu-thong-bao.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Hộp thư | — (chỉ nhận email) | "4 tin chưa đọc", "Đọc tất cả"; tin đặt vé, hủy vé, lưu voucher do thao tác trên web sinh ra | Chỉ app |

### S51 · Hành trình – sắp tới — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S51-so-sanh-hanh-trinh-sap-toi.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Phân loại | Tab Sắp tới (1), Đã đi (1), Đã hủy (2), Tất cả (4) | Một danh sách "Đơn của bạn (4)" | Khác |
| Ô tìm | "Tìm theo mã đặt vé hoặc tuyến" | — | Chỉ web |
| Thẻ đơn | Ngày, tuyến, trạng thái, giờ đi–đến, nhà xe, dạng xe, mã đặt vé, số vé + chỗ (A06), điểm đón, giá | Ngày, giờ khởi hành, tuyến, trạng thái, nhà xe, mã, giá | Khác |
| Hủy vé từ danh sách | Nút "Hủy vé" | — | Chỉ web |
| Đặt vé mới | "Đặt vé mới" | — | Chỉ web |
| Lối tra cứu đơn khách | "Đã đặt vé khi chưa đăng nhập? … Tra cứu vé" | — | Chỉ web |

### S52 · Hành trình – đã đi — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S52-so-sanh-hanh-trinh-da-di.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Đơn VXNXJGJSM | Tab "Đã đi", nhãn "Đã sử dụng" | Trong danh sách chung, nhãn "Đã đi" | Khác |

### S53 · Hành trình – đã hủy / hết hạn — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S53-so-sanh-hanh-trinh-da-huy.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Đơn hết hạn VXNX3WCZA | Nhãn "Đã hủy / hết hạn", "Chưa phát hành vé", không mở được | Nhãn "Hết hạn thanh toán", mở được: "Đơn chưa có vé điện tử (Hết hạn thanh toán)" | Khác |
| Đơn đã hủy VXNPKEXRM | Nhãn "Đã hủy / hết hạn", không nói hoàn tiền | Nhãn "Hoàn tiền lỗi" | Lệch |

### S54 · Vé sắp đi VXNTXEBEZ — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S54-so-sanh-ve-sap-di.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Thao tác đầu trang | "In vé", "Chia sẻ", "Hủy vé" | "Tất cả vé (1) ›", chạm vé để phóng to; cuối trang "Hủy vé", "Quay lại kết quả" | Khác |
| Tiêu đề vé | Điểm đón → điểm trả (Văn phòng Phương Trang Lê Hồng Phong → Ngã ba Liên Khương - Đức Trọng) | Tuyến (TP. Hồ Chí Minh (BX Miền Đông mới) → Đà Lạt (Quốc lộ 20)) | Khác |
| Ngày | "Thứ Bảy · 14/11/26" | "Thứ Bảy · 14/11/2026" | Khác |
| Loại chỗ A06 | "Giường nằm" | "**Giường đơn**" | Lệch |
| Giờ đến | "13:45 Dự kiến" | "13:45" | Khác |
| Thời gian di chuyển | "6 giờ 15 phút" | — | Chỉ web |
| Mã QR | Có, "Lên xe quét mã" | Có, "Lên xe quét mã" | Giống |
| Bản đồ + "Mở chỉ đường Goong" | Có | — | Chỉ web |
| "Xem trang nhà xe" | Có | — | Chỉ web |
| Mô phỏng hành trình | — | "Chạy thử hành trình" (cờ build) | Chỉ app |
| Dòng giảm giá | Chỉ hiện khi có, tên "Ưu đãi" | Luôn hiện, tên "Giảm giá" (ở đây 0đ) | Khác |
| Trạng thái thanh toán | "Đã thanh toán" | "Thành công" | Khác |
| Chính sách hủy | Mốc tương đối: "Trước giờ đi ít nhất 24 giờ 90% / 4 giờ 50% / 0 giờ 0%" | Mốc cụ thể: "Trước 07:30 · 13/11 Hoàn 90% / Trước 03:30 · 14/11 Hoàn 50% / Trước 07:30 · 14/11 Không hoàn" + "Hiện tại: vé này được hoàn 50%…" | Khác |
| Hỗ trợ | "Nhà xe · 19006067" + "Gửi khiếu nại về đơn này" | "Cần hỗ trợ về chuyến đi? Gửi yêu cầu →" (gọi tổng đài) | Khác |

### S55 · Vé đã đi VXNXJGJSM — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S55-so-sanh-ve-da-di.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Nhãn vé | "ĐÃ SỬ DỤNG" | "Đã đi", "Đã sử dụng" | Giống |
| Chữ dưới QR | Vẫn ghi "**Lên xe quét mã**" cho vé đã dùng | Không ghi | Lỗi web |
| Đánh giá | — (ở "Đánh giá của tôi") | "Đánh giá của bạn" ngay trong vé, đúng nội dung đã gửi từ web | Chỉ app |
| Hủy vé | Không có nút | "Vé này không còn hủy được." | Giống |
| Phương thức | "VNPAY" | "VNPay" | Giống |
| Liên hệ | "Gửi khiếu nại về đơn này" | "Liên hệ hỗ trợ", "Gửi yêu cầu" | Khác |

### S56 · Vé đã hủy VXNPKEXRM — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S56-so-sanh-ve-da-huy.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Trạng thái đơn | "Hoàn tiền chưa thành công" | "Hoàn tiền lỗi — đang hỗ trợ" | Lệch |
| QR | Ẩn: "Vé đã hủy — mã QR không còn hiệu lực" | Ẩn: "Mã QR không còn hiệu lực và chỗ ngồi đã được giải phóng." | Giống |
| Hành khách | Trần Văn Bảo, A08 | Trần Văn Bảo, A08 | Giống |
| Khối tiền | Giá vé 290.000đ, Phí 0đ, Ưu đãi −43.500đ, Đã thanh toán 246.500đ, VNPAY, mã giao dịch | "Thanh toán / hoàn tiền": Đã thanh toán 246.500đ, **Tiền hoàn 221.850đ**, Phương thức hoàn VNPay, **Mã hoàn tiền** RFDSAGLES8PS93X | Lệch |
| Nút In vé, Chia sẻ | Vẫn hiện với đơn đã hủy | — | Khác |

### S57 · Hủy vé – báo giá hoàn tiền — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S57-so-sanh-huy-ve-bao-gia.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Chọn vé | Danh sách vé có ô chọn (hủy nhiều vé) | Vé đang xem | Khác |
| Số tiền | Đã trả 290.000đ, "Không hoàn lại" −145.000đ, "Tiền hoàn (50%)" 145.000đ | Đã trả 290.000đ, "Không hoàn (50%)" −145.000đ, "**Hoàn về DEMO**" 145.000đ | Giống |
| Cách ghi | % đặt ở dòng tiền hoàn | % đặt ở dòng không hoàn; tên cổng ghi mã thô "DEMO" | Khác |
| Lý do hủy | Ô tự nhập "Ví dụ: đổi kế hoạch đi lại" (không bắt buộc) | Chọn: Thay đổi kế hoạch, Không phù hợp giờ đi, Lý do khác (không bắt buộc) | Khác |
| Cảnh báo | "Vé đã hủy không khôi phục được. Hệ thống kiểm tra lại số tiền hoàn khi xác nhận." | "Voucher đã dùng cho đơn này không được trả lại khi bạn tự hủy vé. Vé đã hủy không khôi phục được." | Khác |
| Nút | "Giữ vé", "Hủy 1 vé" | "Giữ vé", "Tiếp tục" | Khác |

### S58, S58b · Đặt vé – thông tin hành khách — [thông tin](screenshots/hanh-khach-web-app-12-14-11/S58-so-sanh-thong-tin-hanh-khach.png) · [người đã lưu](screenshots/hanh-khach-web-app-12-14-11/S58b-so-sanh-chon-hanh-khach-da-luu.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Giữ chỗ | "Giữ ghế còn 09:58" | "Thời gian giữ chỗ còn lại 09:49" | Giống |
| Liên hệ | Họ và tên *, Số điện thoại *, Email *, điền sẵn | Họ và tên, Email (nhận vé điện tử), Số điện thoại, điền sẵn | Giống |
| Tên hành khách từng chỗ | **Bắt buộc**: "Mỗi chỗ một hành khách. Họ tên cần khớp giấy tờ tùy thân khi lên xe." | **Tùy chọn**: "Để trống nếu người liên hệ đi chỗ này" | Lệch |
| Chọn người đã lưu | Ô chọn "Chọn từ hành khách đã lưu" | Bảng "Chọn hành khách đã lưu": Trần Văn Bảo 0912345678 | Giống |
| SĐT hành khách | Có | Có (tùy chọn) | Giống |
| Điểm đón/trả | Nhắc lại + "Thay đổi ở bước 1 >" | Thẻ tóm tắt đầu trang | Khác |
| Ghi chú cho nhà xe | Tối đa 300 ký tự | — | Chỉ web |
| Số giấy tờ | — | — | Giống |
| Tóm tắt, nút | Khung "CHUYẾN ĐI", "Tiền vé đang giữ 290.000đ", "Tiếp tục thanh toán", "Quay lại chọn chỗ" | Thanh dưới "1 hành khách — 290.000 ₫ — Tạm tính — Tiếp tục" | Khác |

Bản 12–13/11 ghi web có trường số giấy tờ. Lần này kiểm lại danh sách ô nhập của web: không có.

### S59 · Ưu đãi – ví voucher khi đặt vé — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S59-so-sanh-uu-dai-vi-voucher.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Voucher HE2026 (đơn 290.000đ < 300.000đ) | Khóa, ghi "Đơn chưa đạt giá trị tối thiểu 300.000 ₫ của mã. — Không phù hợp" | Hiện như chọn được, chỉ ghi "Đơn từ 300.000 ₫" (chưa thử bấm) | Khác |
| Quy tắc | "Mỗi đơn áp dụng tối đa một voucher hoặc một mã khuyến mãi." | "Mỗi đơn dùng một ưu đãi. Điều kiện được kiểm tra cho chuyến bạn chọn." | Giống |
| Kiểu | Tab "Ví voucher (1)" / "Nhập mã" ngay trên trang | Bảng "Chọn từ ví voucher" | Khác |

### S60 · Áp mã VEXENHANH50 — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S60-so-sanh-ap-ma-khuyen-mai.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Kết quả | "Đã áp dụng VEXENHANH50 · Ưu đãi bạn mới giảm 15% tối đa 50.000đ", −43.500đ, tạm tính 246.500đ | "VEXENHANH50 đã áp dụng — Ưu đãi bạn mới giảm 15% tối đa 50.000đ · −43.500 ₫", 246.500 ₫ | Giống |
| Bỏ mã | "Xóa mã" | "Bỏ mã" | Giống |
| Ghi chú | "Mã được kiểm tra lại khi tạo đơn; lượt ưu đãi chưa được giữ ở bước này." | — | Chỉ web |

### S61 · Xác nhận và thanh toán — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S61-so-sanh-xac-nhan-va-thanh-toan.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Màn xác nhận | Gộp vào trang Thanh toán (bước 3) | Màn "Xác nhận đặt vé" riêng (vẫn ở bước 2) | Khác |
| Sửa ghế/hành khách | "Quay lại chọn chỗ" | Nút "Sửa" | Giống |
| Chi tiết tiền | Giá vé 290.000đ, Phí dịch vụ 0đ, Ưu đãi −43.500đ, Tổng 246.500đ | Chỗ A08 290.000đ, Phí dịch vụ 0đ, Giảm giá (VEXENHANH50) −43.500đ, Tổng 246.500đ | Giống |
| Ô đồng ý điều khoản | **Tick sẵn** (`components/payment/payment-page-view.tsx:36`, `useState(true)`) | Để trống; "Tiếp tục thanh toán" khóa tới khi tick | Lệch |
| Nội dung đồng ý | "Điều khoản sử dụng, Chính sách bảo mật và chính sách hủy / hoàn tiền của chuyến này" | "Điều khoản đặt vé và Chính sách hủy" | Khác |

### S62 · Phương thức thanh toán — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S62-so-sanh-phuong-thuc-thanh-toan.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Danh sách | VNPay, Ví MoMo | Chuyển khoản VietQR qua payOS, Ví MoMo, VNPay, Cổng thanh toán thử (demo) | Lệch |
| Mô tả VNPay | "Chọn ngân hàng hoặc cách thanh toán trên cổng VNPay." | "Thanh toán qua VNPay-QR, tài khoản hoặc thẻ được cổng hỗ trợ." | Khác |
| Thông tin đơn | Liên hệ, Email nhận vé, Chỗ + hành khách; mã đơn "Chờ thanh toán" | Thẻ "Đơn của bạn"; "Đơn VXNUY6MKL đã được tạo và giữ chỗ tới 00:03…" | Khác |
| Kiểm tra trạng thái | — | "Kiểm tra trạng thái thanh toán" | Chỉ app |
| Nút | "Thanh toán 246.500đ" | "Tiếp tục" | Khác |

### S63 · Cổng VNPay sandbox — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S63-so-sanh-cong-vnpay.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Mở cổng | Chuyển cả trang sang VNPay | WebView "Thanh toán VNPay" có "Quay lại", "Đóng thanh toán" | Khác |
| Trang VNPay | Trang sandbox của VNPay | Cùng trang | Giống |

### S64 · Chờ kết quả thanh toán — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S64-so-sanh-ket-qua-dang-xu-ly.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Nội dung | "Đang kiểm tra đơn đặt vé… Vui lòng chưa thanh toán thêm cho đơn này.", Mã, Phương thức VNPAY, Số tiền 246.500đ, Trạng thái "Đang xử lý" | "Thanh toán qua VNPay — Sau khi hoàn tất, quay lại ứng dụng để nhận kết quả và vé." | Khác |
| Kiểm tra lại | Tự kiểm tra 3 giây/lần + "Kiểm tra lại ngay" | Bấm "Kiểm tra trạng thái thanh toán" | Khác |
| Trả lại cổng | "Tiếp tục thanh toán" | "Mở VNPay" | Giống |

### S65 · Thanh toán thành công — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S65-so-sanh-ket-qua-thanh-cong.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Tiêu đề | "Thanh toán thành công", mã VXNLK7ELH | "Vé của bạn" (bước 4 Hoàn tất) | Khác |
| Sao chép mã đặt vé | Có | — | Chỉ web |
| Vé | "Vé điện tử (1)", "Xem vé và mã QR" | Vé dạng vé in, QR "do máy chủ phát hành", "Vé trước / Vé sau", "Tất cả vé (1)" | Khác |
| Chi tiết thanh toán | Giá vé, Phí, Ưu đãi −43.500đ, Tổng 246.500đ, VNPAY, mã giao dịch, thời gian, trạng thái | — | Chỉ web |
| In / tải vé | "In vé" | "Tải vé này (PDF)" báo chưa hỗ trợ | Lỗi app |
| Tiếp theo | — | "Xem chuyến hành trình" | Chỉ app |

### S66 · Khiếu nại / hỗ trợ — [ảnh](screenshots/hanh-khach-web-app-12-14-11/S66-so-sanh-khieu-nai-ho-tro.png)

| Chi tiết | Web | App | KL |
| --- | --- | --- | --- |
| Khiếu nại | Trang "Khiếu nại và hỗ trợ": "Gửi khiếu nại", tab Đang xử lý (1) / Đã đóng (0), KN-20261112-040 "Mới tiếp nhận", đơn liên quan, danh mục, trao đổi | — | Chỉ web |
| Đính kèm | JPEG, PNG, PDF; tối đa 10 MB/tệp, 5 tệp | — | Chỉ web |
| Thay thế trên app | — | "Liên hệ hỗ trợ", "Trung tâm trợ giúp", "Gọi tổng đài 1900 636 707", "Góp ý" | Chỉ app |

## 4. Lỗi và điểm lệch đề xuất xử lý

Chưa sửa mục nào trong lần này. Mục đánh dấu "bản trước" đã có trong bản 12–13/11 và vẫn đúng. Kế hoạch xử lý và các quyết định: [PASSENGER-PARITY-plan.md](../task-propreties/PASSENGER-PARITY-plan.md).

| # | Vấn đề | Nền tảng | Mức | Vị trí | Đề xuất |
| --- | --- | --- | --- | --- | --- |
| 4.1 | "Đánh giá của tôi" dùng dữ liệu mẫu: bản debug hiện fixture Figma (`figmaMyReviewsSample`, gọi từ `_loadMyReviews` trong `main.dart`), bản release luôn trống (bản trước) | App | Cao | S47 | Merge nhánh `claude/my-reviews-real-data-042393` hoặc lấy dữ liệu như web |
| 4.2 | Ba số tổng đài: web **1900 6067**, app **1900 636 707** (trang chủ, tài khoản) và **1900 6868** (màn OTP). Số của web trùng số tổng đài nhà xe Phương Trang trong dữ liệu (19006067) | Cả hai | Cao | S01, S35, S38, S54 | Chốt một số của sàn, sửa chuỗi cứng ở cả hai |
| 4.3 | VNPay sandbox trả `99 Unexpected error` cho `querydr` và hoàn tiền (bản trước, chi tiết ở mục 5) | API | Cao | — | Kiểm tra log đối soát và hoàn tiền trên production |
| 4.4 | Ô đồng ý điều khoản trên web được tick sẵn, khách bấm thanh toán ngay được. App bắt tự tick. Câu đồng ý có cả Chính sách bảo mật | Web | Trung bình | S61, `payment-page-view.tsx:36` | Để mặc định chưa tick như app |
| 4.5 | Tra cứu vé: web chỉ hiện đơn theo mã đã nhập, app hiện mọi đơn của email; đơn đặt bằng tài khoản thì web cho xem, app chặn (bản trước, mở rộng) | Cả hai | Trung bình | S32, S33 | Thống nhất theo SRS tra cứu vé |
| 4.6 | Tên hành khách từng chỗ: web bắt buộc, app cho để trống | Cả hai | Trung bình | S58 | Chốt theo SRS, sửa bên lệch |
| 4.7 | Khám phá trên app: 3 chuyên mục viết cứng không khớp CMS, chọn "Cẩm nang" ra trống | App | Trung bình | S23 | Lấy danh sách chuyên mục từ API như web |
| 4.8 | Snackbar "Đơn … đặt bằng tài khoản" không tự tắt, theo sang màn đăng nhập, che nút "Xác minh" và lỗi OTP (bản trước, mở rộng) | App | Trung bình | S33, S39 | Cho snackbar tự tắt và xóa khi chuyển màn |
| 4.9 | Kết quả tra cứu trên web thiếu dòng ưu đãi: 290.000đ + 0đ nhưng "Đã thanh toán 246.500đ". Chi tiết vé của tài khoản thì có dòng "Ưu đãi" | Web | Trung bình | S32, `components/tickets/lookup-result/lookup-actions-sidebar.tsx` | Thêm dòng ưu đãi như `ticket-payment-sidebar.tsx` |
| 4.10 | Câu "Áp dụng voucher khi đặt vé trên web hiện chưa khả dụng" còn ở 3 chỗ, trong khi web đã áp dụng được voucher | Web | Trung bình | S44, `vouchers-view.tsx:125`, `loyalty-view.tsx:162`, `loyalty-redeem-modal.tsx:261` | Bỏ hoặc sửa câu |
| 4.11 | Bộ chọn ngày của app hiện tiếng Anh, tuần bắt đầu Chủ Nhật | App | Trung bình | S05 | Đặt locale `vi` cho date picker |
| 4.12 | Danh sách cổng của app cố định 4 cổng, mặc định payOS kể cả khi server chưa bật (bản trước) | App | Trung bình | S62 | Lấy danh sách cổng đang bật từ API |
| 4.13 | Cổng mở bằng trình duyệt ngoài trả khách về trang kết quả của web, không về app (bản trước) | App | Trung bình | — | Thêm return URL dạng deep link |
| 4.14 | App không có khiếu nại; "Gửi yêu cầu" chỉ gọi tổng đài (bản trước) | App | Trung bình | S54, S66 | Bổ sung hoặc mở trang khiếu nại của web |
| 4.15 | Web không hiện trạng thái hoàn tiền trong danh sách hành trình; chi tiết vé đã hủy không có số tiền hoàn và mã hoàn tiền | Web | Trung bình | S53, S56 | Hiện như app |
| 4.16 | Cùng chỗ giường đơn A06: web ghi "Giường nằm", app ghi "Giường đơn" | Cả hai | Thấp | S54–S56 | Dùng một tên theo GLOSSARY |
| 4.17 | Nhãn hoàn tiền lỗi khác nhau: "Hoàn tiền chưa thành công" và "Hoàn tiền lỗi — đang hỗ trợ" (bản trước) | Cả hai | Thấp | S56 | Dùng một nhãn |
| 4.18 | Tìm theo nhà xe: app bắt chọn tuyến, web cho "Tất cả tuyến" | Cả hai | Thấp | S07 | Chọn một cách |
| 4.19 | Ngày đi mặc định: web trống, app ngày mai | Cả hai | Thấp | S01, S05 | Chọn một cách |
| 4.20 | App xếp danh sách khu vực và tuyến theo mã ký tự, không theo ABC tiếng Việt | App | Thấp | S27 | Sắp xếp bằng collation tiếng Việt |
| 4.21 | App tìm "QR" ra 1 bài nhưng ngay dưới ghi "Chưa có bài viết trong chuyên mục này." | App | Thấp | S24 | Ẩn dòng trống khi đã có kết quả |
| 4.22 | App ghi "Tra cứu vé … dùng mã đặt vé và email" nhưng form chỉ có email | App | Thấp | S35 | Sửa chữ hoặc thêm ô mã đặt vé |
| 4.23 | Web phiên đăng nhập ghi "Chrome on Windows", "Mobile app" | Web | Thấp | S49 | Việt hóa như app |
| 4.24 | Web: vé đã sử dụng vẫn ghi "Lên xe quét mã" | Web | Thấp | S55, `boarding-pass-card.tsx:151` | Chỉ hiện với vé còn hiệu lực |
| 4.25 | Web tra cứu: mời "Tạo tài khoản" khi email đã có tài khoản | Web | Thấp | S32 | Ẩn khi đơn đặt bằng tài khoản |
| 4.26 | App: chữ tiếng Anh "Support Station" ở khối hỗ trợ trang chủ | App | Thấp | S01 | Bỏ chữ tiếng Anh |
| 4.27 | App: nút đảo chiều điểm đi/đến không có nhãn trợ năng | App | Thấp | S01 | Thêm `Semantics`/tooltip |
| 4.28 | Web: "Tích điểm cùng Vé xe nhanh" viết sai hoa tên thương hiệu | Web | Thấp | S01 | Sửa thành "Vé Xe Nhanh" |
| 4.29 | Ký hiệu tiền lẫn "đ" và "₫" (app nhiều chỗ; web ở thông báo voucher) | Cả hai | Thấp | S09, S58 | Dùng một ký hiệu |
| 4.30 | App ghi mã cổng thô "Hoàn về DEMO" khi hủy vé | App | Thấp | S57 | Dùng tên hiển thị của cổng |
| 4.31 | Web trang Hành trình khi chưa đăng nhập ghi "quản lý tài khoản của bạn" | Web | Thấp | S34 | Sửa thành câu về vé/hành trình |
| 4.32 | Hủy vé: web hủy nhiều vé + lý do tự nhập; app từng vé + lý do chọn sẵn (bản trước) | Cả hai | Thấp | S57 | Thống nhất hoặc ghi rõ trong UI doc |
| 4.33 | Nút "VI" trên web chưa đổi ngôn ngữ (bản trước) | Web | Thấp | S01 | Ẩn nút hoặc làm đa ngôn ngữ |
| 4.34 | App: nút "Tải vé này (PDF)" báo chưa hỗ trợ (bản trước) | App | Thấp | S65 | Làm PDF hoặc ẩn nút |

Phần chỉ một bên có (bản đồ, in vé, ghi chú cho nhà xe, lịch sử điểm có lọc, ví voucher có tab trên web; hộp thư, đăng nhập Google, ưu đãi trên trang chủ, lọc tiện ích, sắp xếp theo đánh giá trên app) xem mục 2. Nên đưa vào backlog từng nền tảng nếu cần đồng bộ.

## 5. Ghi chú môi trường

- **Đơn web VXNLK7ELH.** Trả bằng thẻ test NCB trên VNPay sandbox. IPN của VNPay không về được máy local, nên chuyển tiếp tham số có chữ ký VNPay trả về tới `GET /v1/webhooks/payment/vnpay` của API local → `CONFIRMED`.
- **Đơn app VXNUY6MKL.** App mở VNPay trong WebView (S63). Để có tham số trả về có chữ ký thật, mở cùng `payment_url` trong trình duyệt tự động, trả bằng thẻ test NCB, rồi chuyển tiếp tham số tới IPN local như trên → `CONFIRMED` (S65).
- **VNPay sandbox `querydr` và hoàn tiền trả lỗi 99** (từ 13/11, vẫn đúng). Job đối soát chỉ xét thanh toán đã quá hạn và lỗi khi gọi VNPay; hoàn tiền tự động của đơn VXNPKEXRM lỗi `GATEWAY_ERROR` → `REFUND_FAILED`. Production dùng cùng khóa sandbox nên có thể bị y hệt, chưa kiểm tra trên production.
- **Dữ liệu dev chưa có chính sách điểm**, nên VXN Plus ở cả hai nền tảng ghi "chưa có chính sách".
- **Bản app là debug, bật cờ `JOURNEY_DEMO_ENABLED`**, nên có "Chạy thử hành trình" và "Đánh giá của tôi" hiện dữ liệu mẫu.
- **Chưa thử trong lần này:** bấm voucher không đủ điều kiện trên app (S59), hoàn tất hủy vé trên app (chỉ chụp báo giá), đổi ảnh đại diện trên app, đăng nhập Google, thanh toán MoMo và payOS.

## 6. Các đơn dùng khi chụp

| Đơn | Nền tảng | Cổng | Kết quả |
| --- | --- | --- | --- |
| `VXNLK7ELH` | Web | VNPay sandbox + `VEXENHANH50`, chỗ A09, chuyến 15/11 07:30 | `CONFIRMED`, 246.500đ |
| `VXNUY6MKL` | App | VNPay sandbox + `VEXENHANH50`, chỗ A08, chuyến 15/11 07:30 | `CONFIRMED`, 246.500đ |
| `VXNTXEBEZ` | App (13/11) | Cổng thử nghiệm (demo), chỗ A06 | `CONFIRMED`, 290.000đ — dùng cho S54, S57 |
| `VXNXJGJSM` | Web (12/11) | VNPay sandbox, chỗ A05 | `CONFIRMED`, chuyến được giả lập đã đi để chụp đánh giá — S55 |
| `VXNPKEXRM` | Web (12/11) | VNPay sandbox + `VEXENHANH50`, chỗ A08 | Đã hủy, hoàn tiền tự động lỗi → `REFUND_FAILED` — S56 |
| `VXNX3WCZA` | App (13/11) | VNPay sandbox (WebView) | Hết hạn thanh toán (không có IPN, `querydr` lỗi 99) — S53 |

## 7. Danh mục ảnh so sánh (`screenshots/hanh-khach-web-app-12-14-11/`)

Mỗi `Sxx-so-sanh-*.png` ghép ảnh web (trái) và app (phải). Ảnh gốc: `Sxx-web-*.png`, `Sxx-app-*.png`.

| Ảnh | Nội dung | Ghi chú |
| --- | --- | --- |
| S01 | Trang chủ (khách) | App 4 ảnh cuộn |
| S04 | Gợi ý điểm đi "Ho Chi Minh" | |
| S05 | Chọn ngày đi | |
| S06 | Chọn số hành khách | |
| S07 | Tìm theo nhà xe | |
| S08 | Tìm khi thiếu điểm đến | |
| S09 | Kết quả TP.HCM → Lâm Đồng 15/11 | |
| S10 | Bộ lọc chuyến | |
| S11 | Sắp xếp chuyến | Ảnh web dùng lại S10 |
| S12 | Đổi ngày | Ảnh web dùng lại S10 |
| S13 | Lọc Giường nằm | |
| S14 | Chi tiết chuyến Phương Trang 07:30 | App 4 ảnh cuộn |
| S17 | Trang nhà xe | |
| S19 | Chọn chỗ (A09 đã bán) | |
| S20 | Chọn điểm đón | Ảnh web dùng lại S19 |
| S23 | Khám phá bài viết | Có ảnh app lọc "Cẩm nang" ra trống |
| S24 | Tìm bài "QR" | |
| S25 | Chi tiết bài viết | |
| S26 | Mua vé – chuyến | |
| S27 | Mua vé – nhà xe | Chụp lại 14/11; ảnh app thứ 2 là danh sách Khu vực |
| S28 | Câu hỏi thường gặp | |
| S29 | Điều khoản | Ảnh app lấy từ M36c |
| S30 | Tra cứu vé – nhập thông tin | |
| S31 | Tra cứu vé – OTP | |
| S32 | Tra cứu vé – kết quả | |
| S33 | Tra cứu – đơn đặt bằng tài khoản | |
| S34 | Hành trình khi chưa đăng nhập | Ảnh app giống S30 |
| S35 | Tài khoản khi chưa đăng nhập | |
| S36 | Đăng nhập | |
| S37 | Email sai định dạng | |
| S38 | Nhập mã OTP | |
| S39 | OTP sai | |
| S40 | Trang chủ đã đăng nhập | |
| S41 | Tài khoản | |
| S42 | Sửa hồ sơ | |
| S43, S43b | Thêm hành khách; danh sách hành khách đã lưu | |
| S44, S44b | Ví voucher; lưu mã sai | |
| S45 | VXN Plus | |
| S46 | Lịch sử điểm | |
| S47 | Đánh giá của tôi | |
| S48 | Cài đặt thông báo | |
| S49 | Phiên đăng nhập | |
| S50 | Hộp thư thông báo | Chỉ app |
| S51 | Hành trình – sắp tới | |
| S52 | Hành trình – đã đi | Ảnh app là danh sách chung cuộn xuống |
| S53 | Hành trình – đã hủy / hết hạn | |
| S54 | Vé sắp đi VXNTXEBEZ | |
| S55 | Vé đã đi VXNXJGJSM | |
| S56 | Vé đã hủy VXNPKEXRM | |
| S57 | Hủy vé – báo giá hoàn tiền | |
| S58, S58b | Đặt vé – thông tin hành khách; chọn hành khách đã lưu | |
| S59 | Ưu đãi – ví voucher khi đặt vé | |
| S60 | Áp mã VEXENHANH50 | |
| S61 | Xác nhận và thanh toán | |
| S62 | Phương thức thanh toán | |
| S63 | Cổng VNPay sandbox | |
| S64 | Chờ kết quả thanh toán | |
| S65 | Thanh toán thành công – vé QR | |
| S66 | Khiếu nại / hỗ trợ | |

## Phụ lục. Ảnh app chụp ngày 13/11/2026 (`M…` trong `screenshots/hanh-khach-web-app-12-14-11/`)

Bộ ảnh lần 1, vẫn dùng được để tra cứu.

| File | Nội dung |
| --- | --- |
| `M00-man-dang-nhap-khi-mo-app.png` | Màn đăng nhập khi mở app: email OTP, Google, Facebook/Apple "Chưa được tích hợp", "Khám phá trước, đăng nhập sau". |
| `M01-trang-chu-khach.png`, `M01b-…`, `M01c-…` | Trang chủ khách: tìm chuyến, banner đăng nhập, ưu đãi nổi bật, tuyến phổ biến, nhà xe nổi bật, cẩm nang, trạm hỗ trợ. |
| `M01d-chon-diem-di.png`, `M01e-form-tim-chuyen-da-chon.png` | Gợi ý điểm đi và form đã chọn TP.HCM → Lâm Đồng. |
| `M01f-tram-ho-tro.png` | Khối "Luôn sẵn sàng hỗ trợ": Trung tâm trợ giúp, Gọi tổng đài 1900 636 707, Góp ý. |
| `M02-kham-pha-bai-viet.png`, `M02b-kham-pha-tim-bai-qr.png` | Tab Khám phá; tìm bài với từ khóa "QR". |
| `M03-chi-tiet-bai-viet.png`, `M03b-…` | Chi tiết bài "Hướng dẫn sử dụng mã vé điện tử QR…". |
| `M04-mua-ve.png`, `M05-mua-ve-theo-nha-xe.png` | Tab Mua vé: chuyến sắp chạy; nhà xe đang phục vụ. |
| `M06-ket-qua-tim-chuyen.png` | 14 chuyến TP.HCM → Lâm Đồng ngày 14/11/2026. |
| `M06b-bo-loc.png`, `M06c-sap-xep.png`, `M06d-doi-ngay.png` | Bảng lọc, sắp xếp, đổi ngày. |
| `M07-chi-tiet-chuyen.png`, `M07b-…`, `M07c-…` | Chi tiết chuyến Phương Trang 07:30: ảnh, tiện ích, lịch trình, điểm đón/trả, chính sách hủy, lưu ý. |
| `M08-so-do-ghe.png`, `M08b-so-do-ghe-da-chon.png`, `M08c-chon-diem-don.png` | Chọn chỗ (khách vãng lai), đã chọn A05, bảng chọn điểm đón. |
| `M09-trang-nha-xe.png`, `M09b-…`, `M09c-…` | Trang nhà xe: chỉ số, tuyến, đánh giá, điều khoản. |
| `M10-hanh-trinh-khach-tra-cuu.png` → `M10e-…` | Tra cứu vé khách vãng lai: nhập email, OTP, danh sách 2 đơn. |
| `M10f-don-tai-khoan-yeu-cau-dang-nhap.png` | Đơn đặt bằng tài khoản: app yêu cầu đăng nhập, không mở chi tiết. |
| `M13-trung-tam-tro-giup-faq.png`, `M13b-faq-mo-cau-hoi.png` | Trung tâm trợ giúp (FAQ). |
| `M17-dang-nhap-nhap-email.png`, `M23-nhap-ma-otp.png` | Đăng nhập bằng email; màn OTP (ghi tổng đài 1900 6868). |
| `M21-tai-khoan-khach.png` | Tab Tài khoản khi chưa đăng nhập. |
| `M24a-xin-quyen-thong-bao.png`, `M24-trang-chu-da-dang-nhap.png` | Xin quyền thông báo; trang chủ "Xin chào, Nguyễn Văn An!" (chuông 4 tin chưa đọc). |
| `M25-tai-khoan.png`, `M25b-tai-khoan-cuon-duoi.png` | Tài khoản của tôi: VXN Plus, tiện ích, cài đặt & bảo mật, đăng xuất. |
| `M26-cai-dat-thong-bao.png` | Cài đặt thông báo theo nhóm. |
| `M27-danh-gia-cua-toi.png` | Đánh giá của tôi — dữ liệu mẫu Figma (mục 4.1). |
| `M28-phien-dang-nhap.png` | Phiên đăng nhập & thiết bị (gồm cả phiên web). |
| `M29-vi-voucher.png` | Ví voucher có mã HE2026 (lưu từ web). |
| `M30-vxn-plus.png`, `M31-lich-su-diem.png` | VXN Plus hạng Đồng; lịch sử điểm trống. |
| `M32-hanh-khach-da-luu.png` | Hành khách đã lưu (0/5). |
| `M33-hop-thu-thong-bao.png`, `M33b-doc-thong-bao-huy-ve.png` | Hộp thư thông báo; đọc tin "Đã hủy vé". |
| `M35-thong-tin-hanh-khach.png`, `M35b-chon-voucher-tu-vi.png`, `M35c-ap-ma-khuyen-mai.png` | Thông tin hành khách điền sẵn; chọn voucher trong ví; áp mã VEXENHANH50. |
| `M36-xac-nhan-dat-ve.png` → `M36d-dong-y-dieu-khoan.png` | Xác nhận đặt vé, chi tiết thanh toán 246.500đ, bảng điều khoản, đã đồng ý. |
| `M36e-chon-phuong-thuc-thanh-toan.png`, `M36f-danh-sach-phuong-thuc.png` | Đơn VXNX3WCZA; 4 phương thức, mặc định payOS. |
| `M37a-vnpay-trong-app.png` → `M37e-vnpay-nhap-otp.png` | VNPay sandbox trong WebView: chọn phương thức, chọn NCB, nhập thẻ test, điều khoản, OTP. |
| `M38-ket-qua-sau-vnpay.png`, `M38b-kiem-tra-trang-thai.png`, `M38c-het-thoi-gian-giu-cho.png` | Sau khi VNPay trả về; kiểm tra trạng thái; hết thời gian giữ chỗ. |
| `M39a-cong-thanh-toan-thu-demo.png` | Trang cổng thử nghiệm (demo) mở trong Chrome ngoài app. |
| `M39-hoan-tat-ve-qr.png`, `M39c-hoan-tat-ve-qr-cuon.png` | "Vé của bạn" sau khi thanh toán demo: vé điện tử dạng vé in, mã QR, "Xem chuyến hành trình". |
| `M39d-tai-pdf-chua-ho-tro.png` | Bấm "Tải vé này (PDF)": báo chưa hỗ trợ. |
| `M40-hanh-trinh-cua-toi.png` | Hành trình của tôi (đã đăng nhập). |
| `M41-chi-tiet-ve-da-di.png`, `M41b-…`, `M41c-…` | Vé đã đi: QR, chính sách, đánh giá đã gửi từ web, liên hệ hỗ trợ. |
| `M43-chi-tiet-ve-da-huy-hoan-tien-loi.png`, `M43b-…` | Vé đã hủy: ẩn QR, "Hoàn tiền lỗi — đang hỗ trợ". |
