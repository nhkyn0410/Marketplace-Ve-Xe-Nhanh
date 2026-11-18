# Kịch bản test chức năng ứng dụng hành khách

**Trạng thái:** Nháp, chờ Khanh duyệt. Chưa chạy theo tài liệu này.
**Đối chiếu với:** code app và API tại commit `c8717ab` (nhánh `feat/new-notification`), ngày 03/11/2026; [checklist 80 chức năng](passenger-mobile-function-checklist.md); [Test Plan](SDLC/08-test-plan-acceptance-criteria.md).

Tài liệu này dành cho người test thủ công trên thiết bị. Kết quả mong đợi được viết từ code và tài liệu thiết kế, nên khi thực tế khác thì ghi lại rồi đối chiếu, đừng tự sửa kỳ vọng. Test widget trong `apps/passenger_mobile/test` dùng API giả nên không thay được các kịch bản này.

## 1. Phạm vi

- **Trong phạm vi:** toàn bộ chức năng người dùng thấy trên app `apps/passenger_mobile`, chạy trên Android, với cả khách vãng lai và thành viên.
- **Dùng để hỗ trợ, không test sâu:** app nhân viên (soát vé, đổi trạng thái chuyến), Admin và Operator OS (tạo dữ liệu, xử lý hoàn tiền).
- **Ngoài phạm vi:** iOS, hiệu năng, bảo mật API, tính tiền ở tầng sổ cái. Các phần đó thuộc test tự động trong [Test Plan](SDLC/08-test-plan-acceptance-criteria.md) mục 9.
- **Phần app chưa có:** không test như lỗi mới, xem [mục 6](#6-phần-app-chưa-có).

## 2. Chuẩn bị

### 2.1. Thiết bị

| Thiết bị | Dùng cho |
| --- | --- |
| Máy ảo Android 16 (Pixel 6) | Phần lớn kịch bản, thẻ tiến độ thông báo |
| Điện thoại Android thật | Quét QR bằng camera của app nhân viên, màn khóa, thông báo trên máy thật |
| Thiết bị thứ hai đăng nhập cùng tài khoản | Tranh chỗ, thu hồi phiên (`TC-PSG-SEAT-08`, `TC-PSG-AUTH-18`) |
| Máy ảo màn nhỏ 320×568 hoặc cỡ chữ lớn | Kiểm tra bố cục (`TC-PSG-SYS-02`, `TC-PSG-SYS-03`) |

### 2.2. Môi trường

| Hồ sơ | Dùng khi | Ghi chú |
| --- | --- | --- |
| **Local** (mặc định) | Mọi kịch bản | API và worker chạy local trên DB bản sao, được phép sửa dữ liệu test |
| **Production** | Chỉ E2E-01, E2E-02 khi diễn tập demo | Không sửa DB; không chạy tình huống cần chỉnh dữ liệu; API thẻ tiến độ trả 404; phương thức thanh toán tùy cấu hình đang bật |

Các bước dựng Local:

1. Bật hạ tầng theo [RB-05](runbook/RB-05-local-infra.md), tạo DB bản sao riêng cho đợt test. Không chạy trên DB dev đang dùng.
2. Khai `PAYMENT_DEMO_ENABLED=true` và `JOURNEY_DEMO_ENABLED=true` cho API. Khai `RESEND_API_KEY` vì không có khóa này API không gửi được OTP.
3. Chạy cả API **và worker**. Thiếu worker thì callback thanh toán, hoàn tiền và thông báo không xử lý.
4. Tạo chuyến ngày mai kèm tài xế, với `DATABASE_URL` trỏ tới DB bản sao: `pnpm --filter @vexenhanh/api exec tsx scripts/seed-passenger-flow.ts`. Lệnh ghi tài khoản tài xế vào `apps/api/.cache/passenger-flow.json`. File này chứa mật khẩu, xóa sau đợt test. Script tạo thêm tỉnh trùng tên: khi tìm, chọn "Hồ Chí Minh" không có chữ "TP." và dòng "Lâm Đồng" đầu tiên, chọn dòng khác sẽ ra 0 chuyến.
5. Build app: `flutter build apk --debug --dart-define-from-file=.env.local`, cài bằng `adb install -r`. Muốn test thông báo đẩy thì `.env.local` phải có đủ `FIREBASE_*`, xem [RB-11](runbook/RB-11-fcm-push.md).
6. Chỉ khi test VNPay sandbox: cổng trả về `PAYMENT_RETURN_BASE_URL` (mặc định `http://localhost:3001`), nên cần `adb reverse tcp:3001 tcp:3001`. IPN của VNPay không tới được localhost, nên cần tunnel công khai hoặc một relay chuyển tham số đã ký của VNPay tới `GET /v1/webhooks/payment/vnpay`. Dùng thẻ thử công bố trong tài liệu sandbox VNPay, không dùng thẻ thật.

**Lưu ý về dữ liệu:**

- App gửi email thật khi có khóa Resend, nên chỉ dùng hộp thư do chính người test sở hữu.
- Bản debug hiện dữ liệu mẫu ở "Đánh giá của tôi". Bản release ở màn đó trống.
- Không test bằng tiền thật. Không dán OTP, mật khẩu, FCM token vào biên bản.

### 2.3. Dữ liệu test

| Mã | Dữ liệu | Cách có |
| --- | --- | --- |
| `TK-MOI` | Email chưa từng đăng nhập | Hộp thư người test, thêm hậu tố `+moi1` nếu Gmail |
| `TK-TV` | Thành viên đã có hồ sơ, có số điện thoại | Đăng nhập một lần bằng email riêng |
| `TK-DIEM` | Thành viên có từ 100 điểm | Đi chuyến tích đủ điểm (100 điểm cần 1.000.000đ tiền vé ở hạng Đồng), hoặc ghi giao dịch `EARN` trên DB bản sao |
| `EMAIL-KHACH` | Email đã có đơn đặt không đăng nhập | Chạy E2E-01 |
| `EMAIL-TRONG` | Email chưa có đơn nào | Hộp thư người test |
| `C-MAI` | Chuyến ngày mai, còn từ 5 chỗ, đã gắn tài xế | Script ở bước 4 |
| `C-XA` | Chuyến sau hơn 7 ngày, có mốc hoàn tiền | Operator OS |
| `C-GAN` | Chuyến sắp khởi hành, đã qua mốc hoàn thấp nhất nhưng còn bán online | Operator OS |
| `C-DOI` | Chuyến có giường đôi hoặc cabin đôi, xe hai tầng | Operator OS |
| `C-CHANG` | Tuyến từ 3 điểm đón / trả, giá khác nhau theo chặng | Operator OS |
| `C-IT` | Chuyến còn vài chỗ | Giữ bớt chỗ hoặc đặt trước |
| `KM-OK`, `KM-SAI` | Mã khuyến mãi còn hiệu lực; mã không tồn tại | Admin hoặc Operator OS |
| `NX-DU`, `NX-THIEU` | Nhà xe có logo, đánh giá, điều khoản; nhà xe thiếu các mục đó | Operator OS |
| `ND` | Bài viết đủ hai chuyên mục, bài nổi bật, FAQ, trang điều khoản đặt vé | Admin |

### 2.4. Cách tạo tình huống khó

| Tình huống | Cách làm |
| --- | --- |
| Mất mạng | Bật chế độ máy bay; trên máy ảo `adb shell svc wifi disable` và `adb shell svc data disable` |
| Hết giờ giữ chỗ | Chờ đủ 10 phút kể từ lúc giữ chỗ. Hạn thanh toán của đơn trùng hạn giữ chỗ |
| OTP hết hạn | Chờ đủ 5 phút |
| Access token hết hạn | Để app yên hơn 15 phút rồi mở màn cần đăng nhập |
| Check-in, hoàn thành chuyến | Đăng nhập app nhân viên bằng tài khoản tài xế. Máy ảo không quét được QR: dùng điện thoại thật, hoặc gọi `/employee/tickets/verify` và `/employee/check-ins` với mã QR thật của vé |
| Vé vắng mặt | Hoàn thành chuyến mà không soát vé đó |

## 3. Cách chạy và ghi kết quả

**Ưu tiên**

| Mức | Nghĩa | Yêu cầu |
| --- | --- | --- |
| P0 | Hỏng thì không đặt được vé, sai tiền, sai vé hoặc lộ dữ liệu | Đạt hết trước khi demo |
| P1 | Chức năng chính, có thể đi đường vòng | Lỗi phải ghi và có hướng xử lý |
| P2 | Trường hợp biên, hiển thị | Sửa khi có thời gian |

**Thứ tự chạy** (thời lượng là ước lượng)

| Đợt | Nội dung | Thời lượng |
| --- | --- | --- |
| 1 | E2E-01, E2E-02. Hỏng ở đây thì dừng, sửa trước | Khoảng 1 giờ |
| 2 | Các case P0 còn lại, E2E-03 đến E2E-05 | Nửa ngày |
| 3 | Các case P1, E2E-06 đến E2E-08 | Một ngày |
| 4 | Các case P2 | Nửa ngày |

**Cột trong bảng:** `Vai` là K (khách vãng lai), TV (thành viên), K+TV (cả hai). `KQ` điền một trong: `Đạt`, `Lỗi`, `Chặn` (không chạy được vì lỗi khác hoặc thiếu dữ liệu), `Bỏ qua` (có lý do).

**Khi gặp lỗi:** ghi mã case, thiết bị, Android, bản build, các bước, kết quả thực tế, ảnh chụp. Mức nặng: **S1** mất tiền, sai vé, lộ dữ liệu, không đặt được vé; **S2** chức năng hỏng nhưng có đường vòng; **S3** hiển thị, câu chữ.

## 4. Kịch bản đầu cuối

Mỗi kịch bản chạy liền mạch từ đầu tới cuối, đơn tạo ở bước trước dùng tiếp ở bước sau.

### E2E-01. Khách vãng lai đặt vé, tra cứu và hủy (P0)

Dữ liệu: `C-XA`, hộp thư người test. Máy chưa đăng nhập.

1. Mở app, chọn "Khám phá trước, đăng nhập sau". **Thấy** Trang chủ "Xin chào!" và lời mời đăng nhập.
2. Tìm chuyến theo điểm đi, điểm đến, ngày. Mở một chuyến. **Thấy** lịch trình, tiện ích, chính sách hủy.
3. Chọn 1 chỗ, điểm đón, điểm trả, bấm "Tiếp tục". **Thấy** đồng hồ giữ chỗ khoảng 10 phút.
4. Nhập họ tên, email, số điện thoại. **Không thấy** nút "Chọn hành khách đã lưu" và ví voucher.
5. Ở bước xác nhận, tích đồng ý, bấm "Tiếp tục thanh toán". **Thấy** màn "Phương thức thanh toán".
6. Chọn "Cổng thanh toán thử (demo)", bấm "Mở cổng thanh toán thử", chọn "Thanh toán thành công", quay lại app. **Thấy** "Vé của bạn", mã QR, nút "Khám phá thêm".
7. Kiểm tra hộp thư. **Thấy** email xác nhận đơn.
8. Vào tab Hành trình, nhập email, nhận OTP, xác nhận. **Thấy** đơn vừa đặt trong "Đơn của bạn".
9. Mở đơn. **Thấy** thẻ vé "Hợp lệ", QR, số tiền.
10. Bấm "Hủy vé", làm hết các bước. **Thấy** "Hủy vé thành công", số tiền hoàn đúng mốc.
11. Quay lại chi tiết. **Thấy** "Vé đã hủy · Mã QR không còn hiệu lực và chỗ ngồi đã được giải phóng."
12. Mở lại sơ đồ chuyến đó. **Thấy** chỗ vừa hủy đã trống.

### E2E-02. Thành viên đi trọn một chuyến (P0)

Dữ liệu: `TK-TV`, `C-MAI`, tài xế. Thiết lập VNPay sandbox ở mục 2.2.

Đã chạy một lần ngày 03/11/2026 trên máy ảo Android 16, soát vé bằng API thay camera. Đạt: đăng nhập, đặt vé, VNPay sandbox, thông báo đẩy, soát vé, hoàn thành chuyến, gửi đánh giá, đánh giá lên hồ sơ nhà xe. Chưa kiểm tra trong lượt đó: chạm thông báo mở đơn, phóng to QR, quét bằng camera thật, tích điểm.

1. Đăng nhập bằng email và OTP. **Thấy** Trang chủ "Xin chào, {tên}!".
2. Tìm và chọn `C-MAI`, chọn 1 chỗ. **Thấy** thông tin liên hệ điền sẵn.
3. Thanh toán bằng VNPay với thẻ thử. **Thấy** cổng báo thành công; quay lại app thấy vé. Đơn `CONFIRMED`, thanh toán `SUCCESS`, vé `VALID`.
4. **Thấy** thông báo đẩy "đặt vé thành công" và tin trong hộp thư. Chạm thông báo mở đúng đơn.
5. Vào Hành trình, mở vé, chạm QR. **Thấy** vé phóng to xoay ngang.
6. Tài xế soát vé. Mở lại vé. **Thấy** "Đã lên xe", không còn nút "Hủy vé".
7. Tài xế vuốt Đón khách, Khởi hành, Đang chạy, Hoàn thành. **Thấy** trạng thái chuyến đổi từng bước trong app nhân viên.
8. Mở lại vé. **Thấy** "Đã đi", "Đã sử dụng", khối "Chuyến đi đã hoàn thành".
9. Bấm "Đánh giá chuyến đi", chọn 4 sao, nhập nhận xét, gửi. **Thấy** "Đánh giá của bạn" với đúng 4 sao và nhận xét.
10. Mở hồ sơ nhà xe. **Thấy** đánh giá mới, tên người gửi đã che.
11. Vào "Điểm thưởng VXN Plus". **Thấy** điểm tăng đúng công thức ở `TC-PSG-LOY-02`, lịch sử có giao dịch tích điểm của đơn.

### E2E-03. Đơn nhiều vé và hủy một phần (P0)

Dữ liệu: `TK-TV`, `C-XA`.

1. Đặt 2 chỗ, nhập tên hành khách thứ hai, thanh toán DEMO. **Thấy** màn hoàn tất có "Vé 1/2", đổi được sang vé 2.
2. Mở đơn ở Vé của tôi. Chuyển sang vé 2, bấm "Hủy vé", hoàn tất. **Thấy** số tiền hoàn chỉ tính cho vé 2.
3. **Thấy** đơn ở danh sách ghi "Hủy một phần"; vé 1 vẫn "Hợp lệ"; vé 2 "Đã hủy".
4. Tài xế soát vé 1 (chuyến phải gắn tài xế). **Thấy** soát được. Soát vé 2. **Thấy** bị từ chối.

### E2E-04. Thanh toán thất bại, thử lại, rồi hết hạn (P0)

Dữ liệu: `TK-TV`, `C-XA`, một voucher trong ví.

1. Đặt 1 chỗ, chọn voucher từ ví, tới bước thanh toán, chọn DEMO, bấm "Thanh toán thất bại", quay lại app. **Thấy** "Thanh toán chưa thành công. Bạn có thể thử lại khi đơn còn hạn." Chưa có vé.
2. Thử lại, chọn "Thanh toán thành công". **Thấy** vé. Đơn chỉ có đúng một vé.
3. Đặt đơn khác cũng dùng ưu đãi, tới màn thanh toán rồi không trả. Chờ hết 10 phút. **Thấy** "Đơn đã quá hạn thanh toán. Vui lòng đặt lại." Nút tạo thanh toán bị khóa.
4. Mở sơ đồ chuyến. **Thấy** chỗ đã trống. Mở Vé của tôi. **Thấy** "Hết hạn thanh toán".
5. Mở ví. **Thấy** voucher của đơn hết hạn đã quay lại trạng thái khả dụng.

### E2E-05. Đổi điểm rồi dùng voucher (P0)

Dữ liệu: `TK-DIEM`, `C-XA`.

1. Vào "Điểm thưởng VXN Plus", bấm "Đổi điểm lấy voucher", nhập 100 điểm. **Thấy** voucher 100.000đ, điểm còn lại, hạn dùng 30 ngày.
2. Bấm xác nhận. **Thấy** số dư giảm đúng 100 điểm, ví có voucher mới.
3. Đặt vé, chọn voucher đó. **Thấy** tổng giảm đúng, không quá giá trị voucher.
4. Thanh toán DEMO thành công. **Thấy** số tiền trên vé bằng tổng sau giảm. Voucher không còn trong ví.
5. Mở "Lịch sử điểm". **Thấy** giao dịch đổi điểm.

### E2E-06. Hai người tranh một chỗ (P0)

Dữ liệu: `C-XA`, hai thiết bị.

1. Hai máy cùng mở sơ đồ, cùng chọn một chỗ. Máy A bấm "Tiếp tục" trước. **Thấy** A sang bước Thông tin.
2. Máy B bấm "Tiếp tục". **Thấy** "Chỗ bạn chọn vừa có người giữ hoặc đặt. Vui lòng chọn chỗ khác." Sơ đồ hiện chỗ đó không đặt được.
3. Máy A bấm quay lại. Máy B tải lại sơ đồ. **Thấy** chỗ trống lại và B giữ được.

### E2E-07. Phiên trên nhiều thiết bị (P1)

Dữ liệu: `TK-TV`, hai thiết bị.

1. Đăng nhập cùng tài khoản trên hai máy. Máy A mở "Phiên đăng nhập & thiết bị". **Thấy** "Phiên hiện tại" và phiên của máy B.
2. Máy A đăng xuất máy B. **Thấy** danh sách tải lại, không còn máy B.
3. Máy B mở màn cần đăng nhập. **Thấy** "Phiên đã hết hạn. Vui lòng đăng nhập lại." và về màn đăng nhập.
4. Máy A tắt hẳn app, mở lại. **Thấy** vào thẳng Trang chủ.
5. Máy A đăng xuất. Gửi thông báo tới tài khoản đó. **Thấy** máy A không còn nhận.

### E2E-08. Thông báo và cài đặt (P1)

Dữ liệu: `TK-TV` đã cấp quyền thông báo, quyền gửi chiến dịch ở Admin.

1. Mở "Cài đặt thông báo", tắt "Ưu đãi và khuyến mãi". Thoát rồi vào lại. **Thấy** vẫn tắt.
2. Admin gửi chiến dịch khuyến mãi. **Thấy** tài khoản không nhận.
3. Bật lại, Admin gửi chiến dịch khác (ngoài giờ yên tĩnh 21h đến 8h, mỗi người tối đa một tin khuyến mãi trong 24 giờ). **Thấy** có thông báo đẩy, chuông có chấm đỏ.
4. Chạm thông báo. **Thấy** mở hộp thư. Chạm tin. **Thấy** toàn văn, tin chuyển sang đã đọc, nút "Lưu mã {mã} vào ví" nếu tin có mã.
5. Lưu mã. **Thấy** mã có trong ví.

## 5. Kịch bản theo chức năng

### 5.1. Đăng nhập và phiên (SCR-PSG-07, 08, 09)

| Mã | Vai | Tình huống và thao tác | Kết quả mong đợi | Ưu tiên | KQ |
| --- | --- | --- | --- | --- | --- |
| TC-PSG-AUTH-01 | K | **Mở app lần đầu.** Cài mới, mở app | Chạy hoạt ảnh mở đầu, dừng ở bước nhập email; có Google, Facebook, Apple và "Khám phá trước, đăng nhập sau" | P1 | |
| TC-PSG-AUTH-02 | K | **Email sai.** Nhập `abc@`, bấm "Tiếp tục" | Báo "Vui lòng nhập một địa chỉ email hợp lệ."; không sang bước OTP | P1 | |
| TC-PSG-AUTH-03 | K | **Gửi OTP.** Nhập email đúng, bấm "Tiếp tục" | Sang "Xác nhận email"; "Hiệu lực của mã" đếm từ 5 phút; "Gửi lại sau" đếm 60 giây; hộp thư nhận mã 6 số | P0 | |
| TC-PSG-AUTH-04 | K | **Tài khoản mới.** Dùng `TK-MOI`, nhập đúng OTP, nhập họ tên, bấm "Hoàn tất" | Qua "Hoàn thiện hồ sơ" với email "Đã xác minh", rồi vào Trang chủ "Xin chào, {tên}!" | P0 | |
| TC-PSG-AUTH-05 | K | **Kiểm lỗi hồ sơ lần đầu.** Bỏ trống tên; nhập số thiếu chữ số; để trống số | Thiếu tên: "Vui lòng nhập họ và tên hành khách."; số sai: "Số điện thoại phải gồm 9 số sau mã quốc gia +84."; bỏ trống số vẫn hoàn tất được | P1 | |
| TC-PSG-AUTH-06 | TV | **Tài khoản cũ.** Dùng `TK-TV`, nhập đúng OTP | Vào thẳng Trang chủ, không hỏi lại hồ sơ | P0 | |
| TC-PSG-AUTH-07 | K | **OTP sai.** Nhập sai 1 lần; nhập sai đủ 3 lần rồi nhập mã đúng | Báo "Mã OTP không đúng hoặc đã hết hạn."; sau 3 lần sai mã cũ hết hiệu lực, phải gửi lại | P1 | |
| TC-PSG-AUTH-08 | K | **Ô OTP.** Nhập 5 số; dán 6 số; xóa bằng Backspace | Chưa đủ 6 số thì không xác minh; dán tự chia đúng ô; xóa không lệch ô | P2 | |
| TC-PSG-AUTH-09 | K | **Gửi lại mã.** Chờ hết 60 giây, bấm "Gửi lại mã", thử mã cũ rồi mã mới | Đồng hồ hiệu lực và thời gian chờ chạy lại; mã cũ bị từ chối; mã mới dùng được | P1 | |
| TC-PSG-AUTH-10 | K | **Mã hết hạn.** Chờ hơn 5 phút, có lúc đưa app ra nền rồi quay lại | Đồng hồ vẫn đúng sau khi quay lại; hết giờ báo "Mã đã hết hạn. Hãy gửi lại mã mới." | P2 | |
| TC-PSG-AUTH-11 | K | **Quá giới hạn.** Yêu cầu mã lần thứ 6 trong một giờ với cùng email | Báo "Bạn đã yêu cầu hoặc thử quá nhiều lần. Vui lòng thử lại sau." | P2 | |
| TC-PSG-AUTH-12 | K | **Sửa email.** Ở màn OTP bấm "Sửa email" | Về bước nhập email, sửa được | P2 | |
| TC-PSG-AUTH-13 | K | **Google.** Bấm Google, chọn tài khoản; lần khác hủy bảng chọn | Vào Trang chủ (lần đầu qua hoàn thiện hồ sơ nếu thiếu tên); hủy thì ở lại màn đăng nhập. Cần `GOOGLE_SERVER_CLIENT_ID` trong bản build | P1 | |
| TC-PSG-AUTH-14 | K | **Facebook, Apple.** Bấm từng nút | Báo "Đăng nhập {tên} chưa được tích hợp trong giai đoạn này."; không chuyển màn (GAP-01) | P2 | |
| TC-PSG-AUTH-15 | K | **Chế độ khách.** Bấm "Khám phá trước, đăng nhập sau" | Vào Trang chủ khách, đủ năm tab | P0 | |
| TC-PSG-AUTH-16 | TV | **Mở lại app.** Đăng nhập, tắt hẳn app, mở lại | Vào thẳng Trang chủ, không hỏi đăng nhập | P0 | |
| TC-PSG-AUTH-17 | TV | **Token hết hạn.** Để app yên hơn 15 phút, mở Vé của tôi | Tải được bình thường, không bị đẩy ra đăng nhập | P0 | |
| TC-PSG-AUTH-18 | TV | **Phiên bị thu hồi.** Thu hồi phiên từ máy khác, thao tác trên máy này | Báo "Phiên đã hết hạn. Vui lòng đăng nhập lại." và về màn đăng nhập | P1 | |
| TC-PSG-AUTH-19 | TV | **Mất mạng khi mở lại.** Bật chế độ máy bay, mở app, tắt chế độ máy bay | Không bị đăng xuất; có mạng lại thì dùng tiếp | P1 | |
| TC-PSG-AUTH-20 | TV | **Đăng xuất.** Tab Tài khoản, bấm "Đăng xuất"; bấm Back; mở lại app | Về màn đăng nhập, không chạy lại hoạt ảnh; Back không vào lại được; mở lại app vẫn phải đăng nhập | P0 | |

### 5.2. Trang chủ (SCR-PSG-01, 03)

| Mã | Vai | Tình huống và thao tác | Kết quả mong đợi | Ưu tiên | KQ |
| --- | --- | --- | --- | --- | --- |
| TC-PSG-HOME-01 | K | **Trang chủ khách.** Vào Trang chủ | "Xin chào!", "Bạn muốn đi đâu?", lời mời "Đăng nhập để lưu hành trình, xem vé của bạn và nhận ưu đãi." | P1 | |
| TC-PSG-HOME-02 | TV | **Trang chủ thành viên.** Vào Trang chủ | "Xin chào, {tên}!", không có lời mời đăng nhập | P1 | |
| TC-PSG-HOME-03 | K+TV | **Khối dữ liệu.** Kéo xem hết trang | "Ưu đãi nổi bật", "Tuyến phổ biến", "Nhà xe nổi bật", bài viết hiện đúng dữ liệu API, có giá "Chỉ từ" | P1 | |
| TC-PSG-HOME-04 | K+TV | **Rỗng hoặc lỗi.** DB không có ưu đãi; tắt API rồi mở | Khối không có dữ liệu bị ẩn; không hiện dữ liệu mẫu; không lỗi đỏ | P2 | |
| TC-PSG-HOME-05 | K+TV | **Chạm ưu đãi.** Chạm thẻ, dán mã vào ô bất kỳ | Báo "Đã chép mã {mã}. Dán mã khi đặt vé."; dán ra đúng mã | P1 | |
| TC-PSG-HOME-06 | K+TV | **Chạm tuyến phổ biến.** | Form tìm được điền đúng điểm đi, điểm đến | P1 | |
| TC-PSG-HOME-07 | K+TV | **Chạm nhà xe nổi bật và bài viết.** | Mở đúng trang nhà xe; mở đúng bài | P2 | |
| TC-PSG-HOME-08 | K+TV | **Trung tâm trợ giúp.** Mở, chạm một câu hỏi | Danh sách FAQ từ API, mở rộng được câu trả lời; không có dữ liệu thì "Chưa có câu hỏi thường gặp." | P2 | |
| TC-PSG-HOME-09 | K+TV | **Tổng đài.** Chạm mục tổng đài | Mở ứng dụng gọi điện với số 1900 636 707; không mở được thì "Không thể mở ứng dụng gọi điện trên thiết bị này." | P2 | |
| TC-PSG-HOME-10 | K+TV | **Chuông.** Chạm khi là khách; chạm khi là thành viên có tin chưa đọc | Khách về màn đăng nhập; thành viên có chấm đỏ, mở hộp thư | P1 | |
| TC-PSG-HOME-11 | K+TV | **Thanh tab.** Cuộn xuống, cuộn lên, đổi qua các tab | Thanh ẩn khi cuộn xuống, hiện khi cuộn lên; đúng năm tab Khám phá, Mua vé, Trang chủ, Hành trình, Tài khoản | P2 | |
| TC-PSG-HOME-12 | K+TV | **Back.** Từ tab khác bấm Back; ở Trang chủ bấm Back | Từ tab khác về Trang chủ; ở Trang chủ thoát app | P1 | |

### 5.3. Tìm chuyến (SCR-PSG-15)

| Mã | Vai | Tình huống và thao tác | Kết quả mong đợi | Ưu tiên | KQ |
| --- | --- | --- | --- | --- | --- |
| TC-PSG-SEARCH-01 | K+TV | **Tìm theo chuyến.** Chọn điểm đi, điểm đến, ngày, số khách, bấm "Tìm chuyến" | Sang "Chọn chuyến", đúng điều kiện, các chuyến đúng tuyến và ngày | P0 | |
| TC-PSG-SEARCH-02 | K+TV | **Thiếu hoặc trùng điểm.** Bỏ trống điểm; chọn hai điểm giống nhau | "Vui lòng chọn điểm đi và điểm đến từ danh mục."; "Điểm đi và điểm đến phải khác nhau." | P1 | |
| TC-PSG-SEARCH-03 | K+TV | **Gợi ý địa điểm.** Gõ `da lat`, `Vũng Tàu`, tên phường, chuỗi vô nghĩa | Gõ không dấu và tên cũ vẫn ra gợi ý; vô nghĩa báo "Không tìm thấy địa điểm phù hợp." | P1 | |
| TC-PSG-SEARCH-04 | K+TV | **Ngày và số khách.** Thử chọn ngày đã qua, ngày sau 365 ngày; đổi số khách về 1 và lên 10 | Không chọn được ngoài khoảng hôm nay tới 365 ngày; số khách trong khoảng 1 đến 10 | P2 | |
| TC-PSG-SEARCH-05 | K+TV | **Không có chuyến.** Chọn ngày không có chuyến | "Chưa có chuyến phù hợp. Hãy thử ngày khác hoặc địa điểm khác." | P1 | |
| TC-PSG-SEARCH-06 | K+TV | **Nới theo tỉnh.** Chọn phường không có chuyến nhưng tỉnh có | Có dải báo "Không có chuyến đón / trả khách tại nơi đã chọn" và hiện chuyến cùng tỉnh | P1 | |
| TC-PSG-SEARCH-07 | K+TV | **Bộ lọc.** Lần lượt lọc theo Khoảng giá, Dạng chỗ, Hạng xe, Giờ khởi hành, Tiện ích, Nhà xe, rồi "Đặt lại" | Kết quả đúng từng điều kiện; nút ghi "Lọc · {số}"; "Đặt lại" xóa hết lọc | P1 | |
| TC-PSG-SEARCH-08 | K+TV | **Lọc không ra kết quả.** Bấm "Bỏ lọc" | "Không có chuyến khớp bộ lọc. Hãy bỏ bớt bộ lọc."; "Bỏ lọc" trả lại danh sách | P2 | |
| TC-PSG-SEARCH-09 | K+TV | **Sắp xếp.** Thử 5 kiểu: khởi hành sớm nhất, giá tăng, giá giảm, thời gian ngắn nhất, đánh giá cao nhất | Chỉ tải lại sau khi bấm "Áp dụng sắp xếp"; thứ tự đúng | P1 | |
| TC-PSG-SEARCH-10 | K+TV | **Đổi ngày, sửa tìm kiếm.** Dùng "Đổi ngày"; dùng "Sửa tìm kiếm" đổi số khách, bấm "Cập nhật kết quả" | Danh sách và dòng điều kiện đổi theo | P1 | |
| TC-PSG-SEARCH-11 | K+TV | **Phân trang.** Tuyến nhiều chuyến, cuộn tới cuối | Tự tải trang sau, không trùng chuyến; hết thì "Đã hiển thị tất cả chuyến phù hợp" | P2 | |
| TC-PSG-SEARCH-12 | K+TV | **Lỗi mạng.** Tắt mạng rồi tìm; bật lại, bấm "Thử lại" | Báo lỗi kết nối; "Thử lại" tải được | P1 | |
| TC-PSG-SEARCH-13 | K+TV | **Theo nhà xe.** Tab "Theo nhà xe": bỏ trống; chọn nhà xe, chọn tuyến, tìm; gỡ chip nhà xe | "Vui lòng chọn nhà xe."; "Vui lòng chọn tuyến của nhà xe."; kết quả có chip nhà xe, gỡ chip thì tìm mọi nhà xe | P1 | |
| TC-PSG-SEARCH-14 | K+TV | **Tab Mua vé, Chuyến xe.** Mở tab khi chưa chọn gì; đổi điểm đến qua chip | Hiện chuyến sắp chạy trong 14 ngày; đổi điều kiện thì tìm lại | P1 | |
| TC-PSG-SEARCH-15 | K+TV | **Tab Mua vé, Nhà xe.** Lọc Khu vực, Tuyến phục vụ; bấm thẻ; bấm "Xem chuyến" | Lọc đúng; bấm thẻ mở trang nhà xe; "Xem chuyến" mở "Chuyến của {nhà xe}" | P1 | |
| TC-PSG-SEARCH-16 | K+TV | **Thẻ chuyến.** Dùng `C-IT`, nhà xe có và không có logo | "Còn {n} chỗ" hoặc "Chỉ còn {n} chỗ" đúng số; giá "Từ"; không logo thì có chữ thay thế | P2 | |

### 5.4. Chi tiết chuyến và trang nhà xe (SCR-PSG-16, 17)

| Mã | Vai | Tình huống và thao tác | Kết quả mong đợi | Ưu tiên | KQ |
| --- | --- | --- | --- | --- | --- |
| TC-PSG-TRIP-01 | K+TV | **Xem chi tiết.** Mở một chuyến, cuộn hết | Có ảnh xe, nhà xe, giá, "Lịch trình", "Điểm đón / Điểm trả", "Tiện ích trên xe", "Chính sách hủy", "Lưu ý"; xe không ảnh có hình thay thế | P1 | |
| TC-PSG-TRIP-02 | K+TV | **Chia sẻ.** Bấm chia sẻ, bấm nhanh hai lần | Mở bảng chia sẻ của hệ điều hành một lần, nội dung có nhà xe, giờ đón, giờ trả, loại xe | P2 | |
| TC-PSG-TRIP-03 | K+TV | **Chính sách hủy.** So với cấu hình của nhà xe; thử nhà xe chưa công bố | Đúng các mốc "Hủy trước ít nhất {n} giờ: hoàn {x}%"; chưa có thì "Nhà xe chưa công bố mốc hoàn tiền khi hủy vé." | P1 | |
| TC-PSG-TRIP-04 | K+TV | **Xem nhà xe, quay lại.** Bấm "Xem nhà xe", Back, nút quay lại | Mở đúng nhà xe của chuyến; quay lại về danh sách chuyến | P1 | |
| TC-PSG-TRIP-05 | K+TV | **Trang nhà xe đầy đủ.** Dùng `NX-DU` | "Thông tin nhà xe", "Chỉ số chất lượng", "Tuyến đang mở bán", "Đánh giá từ hành khách", "Phản hồi từ nhà xe", "Điều khoản dịch vụ" đúng dữ liệu | P1 | |
| TC-PSG-TRIP-06 | K+TV | **Thiếu dữ liệu.** Dùng `NX-THIEU` | "Chưa có dữ liệu", "Nhà xe chưa có tuyến mở bán.", "Chưa có đánh giá để hiển thị.", "Nhà xe chưa công bố điều khoản dịch vụ."; ẩn liên hệ trống | P2 | |
| TC-PSG-TRIP-07 | K+TV | **Xem thêm đánh giá.** Bấm tới hết; tắt mạng rồi bấm | Tải thêm không trùng, hết trang thì ẩn nút; lỗi vẫn giữ danh sách và bấm lại được | P2 | |
| TC-PSG-TRIP-08 | K+TV | **Liên hệ.** Bấm "Gọi", email, "Xem chuyến của nhà xe" | Mở đúng số, đúng email; xem được chuyến của riêng nhà xe, bấm chuyến mở chi tiết | P2 | |
| TC-PSG-TRIP-09 | K+TV | **Nhà xe tạm ngừng, mất mạng.** Admin khóa nhà xe rồi mở; tắt mạng rồi mở | "Nhà xe không tồn tại hoặc đang tạm ngừng hoạt động."; mất mạng có nút "Thử lại" | P2 | |

### 5.5. Chọn chỗ và giữ chỗ (SCR-PSG-18)

| Mã | Vai | Tình huống và thao tác | Kết quả mong đợi | Ưu tiên | KQ |
| --- | --- | --- | --- | --- | --- |
| TC-PSG-SEAT-01 | K+TV | **Sơ đồ.** Mở chuyến đã có người đặt | Chú giải "Trống", "Đang chọn", "Không đặt được"; chỗ đã đặt và đang giữ đều không bấm được | P0 | |
| TC-PSG-SEAT-02 | K+TV | **Chọn, bỏ chọn.** Chọn 2 chỗ, bỏ 1, bỏ hết | Thanh dưới đổi "{n} chỗ — {mã}", hết thì "Chưa chọn chỗ" và khóa "Tiếp tục"; tổng tiền cộng đúng | P0 | |
| TC-PSG-SEAT-03 | K+TV | **Quá 10 chỗ.** Chọn chỗ thứ 11 | "Mỗi lần đặt tối đa 10 chỗ."; vẫn giữ 10 chỗ đã chọn | P1 | |
| TC-PSG-SEAT-04 | K+TV | **Xe hai tầng, chỗ đôi, xe rộng.** Dùng `C-DOI` | Có "Tầng dưới", "Tầng trên"; chỗ đôi là một mã; xe rộng có "Vuốt ngang để xem toàn bộ chỗ" và chọn được hàng cuối | P1 | |
| TC-PSG-SEAT-05 | K+TV | **Điểm đón, điểm trả.** Mở từng bảng, đổi điểm đón sang điểm giữa tuyến | Bảng đón chỉ có điểm cho đón; bảng trả chỉ có điểm cho trả nằm sau điểm đón; nút "Xác nhận" không bị thanh điều hướng che | P1 | |
| TC-PSG-SEAT-06 | K+TV | **Giá theo chặng.** Dùng `C-CHANG`, đổi điểm đón, trả | Giá chỗ đổi đúng theo chặng, khớp giá ở bước xác nhận và trên vé | P0 | |
| TC-PSG-SEAT-07 | K+TV | **Giữ chỗ.** Bấm "Tiếp tục" | Sang bước Thông tin, đồng hồ đếm từ khoảng 10 phút theo hạn máy chủ trả | P0 | |
| TC-PSG-SEAT-08 | K+TV | **Xung đột.** Máy khác giữ cùng chỗ trước | "Chỗ bạn chọn vừa có người giữ hoặc đặt. Vui lòng chọn chỗ khác."; ở lại màn chọn chỗ | P0 | |
| TC-PSG-SEAT-09 | K+TV | **Quay lại.** Sau khi giữ chỗ bấm quay lại, máy khác mở sơ đồ | Chỗ được trả ngay, máy khác thấy trống | P1 | |
| TC-PSG-SEAT-10 | K+TV | **Khác số khách lúc tìm.** Tìm 2 khách, chọn 1 chỗ; lần khác chọn 3 chỗ | Hiện tại vẫn tiếp tục được; tổng và số hành khách theo số chỗ đã chọn | P2 | |
| TC-PSG-SEAT-11 | K+TV | **Chuyến ngừng bán, thao tác dồn dập.** Nhà xe tạm dừng bán khi đang chọn; giữ rồi bỏ liên tục | "Chuyến đã ngừng bán online."; "Bạn thao tác quá nhanh. Vui lòng thử lại sau ít phút." | P2 | |
| TC-PSG-SEAT-12 | K+TV | **Hạn bán online theo điểm đón.** Chuyến có điểm đón đầu đã qua giờ ngừng bán, điểm đón sau chưa qua | Bảng điểm đón không có điểm đã đóng; vẫn đặt được từ điểm đón sau | P1 | |

### 5.6. Thông tin hành khách và ưu đãi (SCR-PSG-19)

| Mã | Vai | Tình huống và thao tác | Kết quả mong đợi | Ưu tiên | KQ |
| --- | --- | --- | --- | --- | --- |
| TC-PSG-INFO-01 | K | **Một vé.** Nhập đủ liên hệ | Không có form hành khách vì người liên hệ đi chỗ đó; "Tiếp tục" mở khóa | P0 | |
| TC-PSG-INFO-02 | K+TV | **Kiểm lỗi liên hệ.** Bỏ trống tên; email sai; số sai | "Email chưa đúng định dạng."; "Số điện thoại gồm 10 số, bắt đầu bằng 0 hoặc +84."; "Tiếp tục" bị khóa | P0 | |
| TC-PSG-INFO-03 | K+TV | **Nhiều vé.** Đặt 3 chỗ, để trống hành khách bổ sung; rồi nhập tên từng người | Có mục "Hành khách bổ sung (tùy chọn)" từ ghế thứ hai; để trống vẫn tiếp tục được; tên nhập đúng ghế ở bước xác nhận và trên vé | P1 | |
| TC-PSG-INFO-04 | K+TV | **Khác nhau theo vai.** So sánh khách, thành viên chưa lưu ai, thành viên đã lưu hành khách | Thành viên được điền sẵn liên hệ, có "Chọn từ ví voucher"; đã lưu hành khách thì có thêm "Hành khách (tùy chọn)" từ ghế đầu và "Chọn hành khách đã lưu"; khách không có các mục này | P1 | |
| TC-PSG-INFO-05 | TV | **Chọn hành khách đã lưu.** Đã có người lưu. Chọn cho ghế đầu với đơn một vé và đơn nhiều vé; lần khác để trống | Điền đúng người vào ghế đó, thông tin liên hệ giữ nguyên; để trống thì người liên hệ đi chỗ đó ("Để trống nếu người liên hệ đi chỗ này") | P1 | |
| TC-PSG-INFO-06 | TV | **Số của hành khách.** Chọn người chưa có số; nhập số sai ở ghế đầu | Không lấy số của người liên hệ; số sai báo lỗi và khóa "Tiếp tục" | P2 | |
| TC-PSG-INFO-07 | K+TV | **Người đi cùng.** Chọn chỗ đôi, nhập tên; rồi để trống | Có ô "Người đi cùng (không bắt buộc)", tên lưu trên đơn; chỗ thường không có ô này | P2 | |
| TC-PSG-INFO-08 | K+TV | **Mã hợp lệ.** Nhập `KM-OK`, bấm "Áp dụng"; bấm "Bỏ mã" | "{mã} đã áp dụng", trừ đúng tiền, tổng giảm; bỏ mã thì tổng về như cũ | P0 | |
| TC-PSG-INFO-09 | K+TV | **Mã sai.** Nhập `KM-SAI`; mã không áp dụng cho nhà xe này | Báo lỗi tại ô; tổng không đổi | P1 | |
| TC-PSG-INFO-10 | TV | **Voucher từ ví.** Chọn một voucher; đổi voucher khác; sau đó nhập mã | Tổng giảm đúng; đơn chỉ giữ một ưu đãi | P0 | |
| TC-PSG-INFO-11 | TV | **Ví rỗng, lỗi tải.** Ví trống; tắt mạng rồi mở bảng | "Ví chưa có voucher có thể sử dụng."; "Không tải được ví voucher. Vui lòng thử lại." có "Thử lại"; không hiện voucher mẫu | P2 | |
| TC-PSG-INFO-12 | K+TV | **Đồng hồ.** Để hết 10 phút ở bước này | Đồng hồ đúng hạn máy chủ; hết thì "Đã hết hạn", khóa "Tiếp tục" | P1 | |
| TC-PSG-INFO-13 | K+TV | **Màn nhỏ, bàn phím.** Máy 320×568, mở bàn phím | Cuộn được tới hết form, không tràn, nút không bị che | P2 | |

### 5.7. Xác nhận đặt vé

| Mã | Vai | Tình huống và thao tác | Kết quả mong đợi | Ưu tiên | KQ |
| --- | --- | --- | --- | --- | --- |
| TC-PSG-CONF-01 | K+TV | **Nội dung và tiền.** Đơn 2 chỗ có mã giảm | "Ghế & hành khách", "Điểm đón / Điểm trả", "Ưu đãi", "Chi tiết thanh toán" đúng; tổng bằng giá từng chỗ trừ giảm giá | P0 | |
| TC-PSG-CONF-02 | K+TV | **Sửa.** Bấm "Sửa", đổi thông tin, tiếp tục | Quay lại giữ dữ liệu đã nhập; đồng hồ không chạy lại | P1 | |
| TC-PSG-CONF-03 | K+TV | **Chưa đồng ý.** Không tích ô đồng ý | "Tiếp tục thanh toán" bị khóa, không tạo đơn | P0 | |
| TC-PSG-CONF-04 | K+TV | **Điều khoản, chính sách.** Mở "Điều khoản đặt vé", "Chính sách hủy", đóng lại | Nội dung đúng; chưa có thì "Chưa có nội dung được công bố."; đóng giữ nguyên đơn và đồng hồ | P1 | |
| TC-PSG-CONF-05 | K+TV | **Tạo đơn.** Tích đồng ý, bấm liên tiếp hai lần | Chỉ tạo một đơn, sang "Phương thức thanh toán" | P0 | |
| TC-PSG-CONF-06 | K+TV | **Giá đổi giữa chừng.** Nhà xe đổi giá khi đang ở bước này, bấm thanh toán | "Giá vé vừa thay đổi. Tổng mới: {tiền}. Bấm thanh toán lần nữa nếu đồng ý."; bấm lần nữa tạo đơn theo giá mới | P1 | |
| TC-PSG-CONF-07 | K+TV | **Ưu đãi hết hiệu lực giữa chừng.** Hết lượt dùng mã khi đang ở bước này | Báo lý do kèm "Ưu đãi đã được bỏ, vui lòng xem lại tổng tiền."; tổng cập nhật | P1 | |
| TC-PSG-CONF-08 | K+TV | **Hết giờ.** Để hết hạn giữ chỗ, kể cả khi đang mở chính sách | Không được gia hạn; khóa nút tạo đơn | P1 | |

### 5.8. Thanh toán và vé sau thanh toán (SCR-PSG-20, 21, 22, 23)

| Mã | Vai | Tình huống và thao tác | Kết quả mong đợi | Ưu tiên | KQ |
| --- | --- | --- | --- | --- | --- |
| TC-PSG-PAY-01 | K+TV | **Màn phương thức.** Vừa tạo đơn | "Đơn {mã} đã được tạo và giữ chỗ tới {giờ}", có payOS, MoMo, VNPay, cổng thử; chưa tạo giao dịch nào | P0 | |
| TC-PSG-PAY-02 | K+TV | **Phương thức chưa bật.** Chọn cổng chưa cấu hình | "Phương thức này chưa được bật. Vui lòng chọn phương thức khác."; đơn và hạn giữ nguyên | P1 | |
| TC-PSG-PAY-03 | K+TV | **Cổng thử thành công.** "Mở cổng thanh toán thử", "Thanh toán thành công", quay lại app | Tự chuyển sang vé trong vài giây | P0 | |
| TC-PSG-PAY-04 | K+TV | **Cổng thử thất bại, thử lại.** Chọn "Thanh toán thất bại", rồi thử lại thành công | "Thanh toán chưa thành công. Bạn có thể thử lại khi đơn còn hạn."; chưa có vé; lần sau phát đúng một bộ vé | P0 | |
| TC-PSG-PAY-05 | K+TV | **VNPay thành công.** "Mở VNPay", trả bằng thẻ thử, quay lại app | Cổng báo mã `00`; app nhận vé sau khi máy chủ xác nhận IPN đã ký | P0 | |
| TC-PSG-PAY-06 | K+TV | **VNPay bỏ ngang.** Đóng cổng khi chưa trả, quay lại app | Vẫn ở chờ, không có vé; "Kiểm tra trạng thái thanh toán" dùng được; thử lại được khi còn hạn | P1 | |
| TC-PSG-PAY-07 | K+TV | **MoMo.** Cần khóa sandbox MoMo. "Mở MoMo" trả thành công | Nhận vé như VNPay. Không có khóa thì ghi `Chặn` | P1 | |
| TC-PSG-PAY-08 | K+TV | **payOS.** Chỉ Local. Xem QR, sao chép, mở ứng dụng ngân hàng | Đúng ngân hàng, số tài khoản, số tiền, nội dung; "Đã sao chép {mục}."; có câu nhắc không chuyển thêm | P2 | |
| TC-PSG-PAY-09 | K+TV | **Bấm liên tiếp, đổi cổng.** Bấm tạo thanh toán hai lần; quay lại chọn cổng khác | Không tạo trùng; đổi cổng giữ nguyên đơn và hạn | P1 | |
| TC-PSG-PAY-10 | K+TV | **Ra nền.** Trả tiền xong khi app ở nền, quay lại app | Kiểm tra ngay khi quay lại, hiện kết quả | P1 | |
| TC-PSG-PAY-11 | K+TV | **Mất mạng.** Tắt mạng ở màn chờ, bấm kiểm tra; bật lại | Có hướng dẫn khắc phục; bật mạng kiểm tra lại được | P1 | |
| TC-PSG-PAY-12 | K+TV | **Hết hạn.** Không trả trong hạn | "Đơn đã quá hạn thanh toán. Vui lòng đặt lại."; khóa tạo link; chỗ được trả | P0 | |
| TC-PSG-PAY-13 | K+TV | **Đối soát.** Cổng báo đã trả sau khi đơn hết hạn (theo `TC-PAY-004`) | "Giao dịch đang được đối soát. Vui lòng không chuyển tiền thêm..."; khóa thanh toán; không phát vé trên app | P2 | |
| TC-PSG-PAY-14 | K+TV | **Chưa xác nhận thì chưa có vé.** Trả xong nhưng callback chưa tới (tắt worker) | App vẫn chờ, không tự hiện vé | P0 | |
| TC-PSG-PAY-15 | K+TV | **Vé sau thanh toán.** Xem màn "Vé của bạn" | QR do máy chủ phát, đúng mã vé, hành khách, ghế, nhà xe, giờ, điểm đón, trả; không có chữ "Mã QR minh họa" | P0 | |
| TC-PSG-PAY-16 | K+TV | **Nhiều vé.** Đổi vé trước, sau; "Tất cả vé ({n})"; tìm theo tên, mã ghế, chuỗi không có | Đúng hành khách và QR từng vé; không có thì "Không tìm thấy vé phù hợp" | P1 | |
| TC-PSG-PAY-17 | K+TV | **Rời màn vé.** Bấm nút cuối; bấm Back | Thành viên "Xem chuyến hành trình" sang Hành trình; khách "Khám phá thêm" về Trang chủ; Back không mở lại thanh toán | P1 | |
| TC-PSG-PAY-18 | K+TV | **Tải PDF.** Bấm "Tải vé này (PDF)" | "Chưa hỗ trợ tải PDF. Bạn có thể xuất trình mã QR trên màn hình." (GAP-11) | P2 | |
| TC-PSG-PAY-19 | TV | **Thoát giữa chừng.** Tắt hẳn app ở màn thanh toán, mở lại khi đơn còn hạn | Đơn hiện "Chờ thanh toán" ở Vé của tôi. Chưa quay lại thanh toán được (GAP-09) | P1 | |

### 5.9. Vé của tôi và chi tiết vé (SCR-PSG-24, 25)

| Mã | Vai | Tình huống và thao tác | Kết quả mong đợi | Ưu tiên | KQ |
| --- | --- | --- | --- | --- | --- |
| TC-PSG-TICK-01 | TV | **Danh sách.** Tab Hành trình | "Vé của tôi", đúng các đơn của tài khoản, đúng tuyến, giờ, số vé, trạng thái; không có đơn của người khác | P0 | |
| TC-PSG-TICK-02 | TV | **Rỗng, lỗi.** Tài khoản chưa có đơn; tắt mạng | "Bạn chưa đặt vé nào. Tìm chuyến ở tab Mua vé để bắt đầu hành trình."; lỗi có "Thử lại" | P2 | |
| TC-PSG-TICK-03 | TV | **Chi tiết vé hợp lệ.** Mở đơn | "Đơn {mã} · {n} vé", thẻ vé vàng, QR, "Hợp lệ", "Hành trình", "Thanh toán", "Chính sách hủy / hoàn tiền" khớp đơn | P0 | |
| TC-PSG-TICK-04 | TV | **Phóng to QR.** Chạm QR; bấm Back; chạm lại và bấm đóng; quét bằng app nhân viên | Vé phóng to xoay ngang vừa màn; Back và đóng đều trở lại; QR quét được | P1 | |
| TC-PSG-TICK-05 | TV | **Nhiều vé.** Mũi tên chuyển vé; "Tất cả vé ({n})"; tìm theo tên, số ghế | Đúng thông tin và QR từng hành khách | P1 | |
| TC-PSG-TICK-06 | TV | **Sau check-in.** Tài xế soát vé, mở lại | "Đã lên xe"; không còn "Hủy vé" | P0 | |
| TC-PSG-TICK-07 | TV | **Sau hoàn thành.** Chuyến hoàn thành | Danh sách ghi "Đã đi"; chi tiết "Đã sử dụng", QR không phóng to, "Vé này không còn hủy được." | P0 | |
| TC-PSG-TICK-08 | TV | **Vắng mặt.** Hoàn thành chuyến khi chưa soát vé đó | "Vắng mặt"; không có khối đánh giá nếu cả đơn không ai đi | P1 | |
| TC-PSG-TICK-09 | TV | **Qua giờ chạy.** Vé còn hợp lệ, chuyến đã qua giờ khởi hành (lùi giờ chuyến trên DB bản sao) | Không còn nút "Hủy vé" | P1 | |
| TC-PSG-TICK-10 | TV | **Đơn chờ, đơn hết hạn.** Mở từng loại | "Xem đơn", "Đơn đang chờ thanh toán. Vé điện tử sẽ có sau khi thanh toán thành công."; đơn hết hạn "Đơn chưa có vé điện tử (Hết hạn thanh toán)." | P1 | |
| TC-PSG-TICK-11 | TV | **Tên dài, máy hẹp.** Tuyến và điểm đón tên rất dài | Hiện đủ, không tràn | P2 | |
| TC-PSG-TICK-12 | TV | **Mở đơn khác từ thông báo, Back.** Đang xem vé A, chạm thông báo đơn B; bấm Back | Màn chuyển sang vé B, khối đánh giá theo B; Back về danh sách, không rời tab | P1 | |

### 5.10. Hủy vé và hoàn tiền (SCR-PSG-26)

| Mã | Vai | Tình huống và thao tác | Kết quả mong đợi | Ưu tiên | KQ |
| --- | --- | --- | --- | --- | --- |
| TC-PSG-CANCEL-01 | K+TV | **Hủy đúng luồng.** "Hủy vé", chọn lý do, "Tiếp tục", "Xác nhận hủy vé" | "Hủy vé thành công", "Thông tin hoàn tiền" có số tiền, phương thức, mã hoàn; lý do không bắt buộc | P0 | |
| TC-PSG-CANCEL-02 | K+TV | **Số tiền theo mốc.** Dùng `C-XA`, so với chính sách lúc đặt | "Số tiền đã trả cho vé hủy", phần "Không hoàn", "Tiền hoàn dự kiến" đúng mốc; khớp số trên màn kết quả | P0 | |
| TC-PSG-CANCEL-03 | K+TV | **Qua hết mốc hoàn.** Dùng `C-GAN` | "Hiện tại: hủy vé sẽ không được hoàn tiền."; kết quả "Không hoàn (đã qua mốc hoàn)" | P1 | |
| TC-PSG-CANCEL-04 | K+TV | **Đổi ý.** Bấm "Giữ vé"; ở bước sau bấm "Quay lại" | Vé không đổi, QR vẫn dùng được | P1 | |
| TC-PSG-CANCEL-05 | K+TV | **Vé sau khi hủy.** Xem chi tiết | "Đã hủy", "Vé đã hủy · Mã QR không còn hiệu lực và chỗ ngồi đã được giải phóng."; QR không phóng to; có thẻ "Thanh toán / hoàn tiền" | P0 | |
| TC-PSG-CANCEL-06 | K+TV | **Chỗ mở bán lại.** Mở sơ đồ chuyến; tài xế quét QR vé đã hủy | Chỗ trống lại; QR bị từ chối | P1 | |
| TC-PSG-CANCEL-07 | K+TV | **Hủy một phần.** Đơn 2 vé, hủy 1 | Đơn "Hủy một phần"; vé kia vẫn dùng được; chỉ hoàn phần vé đã hủy | P0 | |
| TC-PSG-CANCEL-08 | TV | **Đơn có ưu đãi.** Đơn dùng voucher, hủy vé | Có câu "Voucher đã dùng cho đơn này không được trả lại khi bạn tự hủy vé."; tiền hoàn tính trên phần đã trả, không vượt số đã trả | P0 | |
| TC-PSG-CANCEL-09 | K+TV | **Không hủy được, mốc đổi.** Máy chủ từ chối; qua mốc hoàn giữa lúc xem và lúc xác nhận | Hiện lý do, không đổi vé; "Số tiền hoàn vừa thay đổi do qua mốc hủy. Vui lòng xem lại." | P2 | |
| TC-PSG-CANCEL-10 | K+TV | **Trạng thái hoàn, thông báo.** Admin xử lý hoàn; xem lại vé, hộp thư, email | Trạng thái đi từ "Đang xử lý" tới "Đã hoàn" (hoặc "Hoàn tiền lỗi — đang hỗ trợ", "Từ chối hoàn"); có thông báo hủy vé và hoàn tiền | P1 | |

### 5.11. Khách vãng lai tra cứu vé (SCR-PSG-27, 28, 29)

| Mã | Vai | Tình huống và thao tác | Kết quả mong đợi | Ưu tiên | KQ |
| --- | --- | --- | --- | --- | --- |
| TC-PSG-GUEST-01 | K | **Email trống, sai.** Tab Hành trình | "Vui lòng nhập email liên hệ."; "Email liên hệ chưa đúng định dạng." | P1 | |
| TC-PSG-GUEST-02 | K | **Gửi OTP.** Nhập `EMAIL-KHACH`, bấm "Nhận mã OTP" | "Xác thực tra cứu vé", email đã che, mã có hiệu lực 5 phút, "Gửi lại sau" 60 giây | P0 | |
| TC-PSG-GUEST-03 | K | **OTP thiếu, sai.** Nhập 5 số; nhập sai | "Vui lòng nhập đủ 6 số OTP."; "Mã xác minh không đúng hoặc đã hết hạn. Vui lòng kiểm tra lại." | P1 | |
| TC-PSG-GUEST-04 | K | **Gửi lại, hết hạn.** Hết 60 giây bấm gửi lại; chờ hết 5 phút | "Đã gửi lại mã xác minh."; "Mã đã hết hạn" | P1 | |
| TC-PSG-GUEST-05 | K | **Quá giới hạn.** Yêu cầu mã lần thứ 6 trong một giờ | "Bạn thao tác quá nhiều lần. Vui lòng thử lại sau ít phút." | P2 | |
| TC-PSG-GUEST-06 | K | **Email chưa có đơn.** Dùng `EMAIL-TRONG` | Vẫn gửi OTP như thường, không lộ email có đơn hay không; "Email này chưa có đơn nào trong 12 tháng gần đây." | P1 | |
| TC-PSG-GUEST-07 | K | **Có đơn.** OTP đúng | "Kết quả tra cứu vé", "Đã xác minh email {che}", "Đơn của bạn ({n})" | P0 | |
| TC-PSG-GUEST-08 | K | **Chi tiết đơn khách.** Bấm "Xem vé" | Thấy QR, thẻ vé, số tiền đúng đơn; không thấy đơn của email khác | P0 | |
| TC-PSG-GUEST-09 | K | **Hủy đơn khách.** Hủy trong phiên tra cứu | Hủy được, số hoàn đúng; vé đổi "Đã hủy" | P0 | |
| TC-PSG-GUEST-10 | K | **Đơn đặt bằng tài khoản.** Tra email từng đặt khi đăng nhập, bấm "Xem vé" | "Đơn {mã} đặt bằng tài khoản. Đăng nhập để xem và hủy vé." kèm "Đăng nhập"; không mở chi tiết | P0 | |
| TC-PSG-GUEST-11 | K | **OTP tra cứu không đăng nhập.** Sau khi tra cứu, mở tab Tài khoản | Vẫn "Bạn chưa đăng nhập" | P0 | |
| TC-PSG-GUEST-12 | K | **Phiên tra cứu hết hạn.** Để hơn 15 phút rồi mở đơn | "Phiên tra cứu đã hết hạn. Vui lòng tra cứu lại." | P1 | |
| TC-PSG-GUEST-13 | K | **Đổi email, Back.** "Thay đổi thông tin tra cứu", "Thay đổi", "Tra cứu lại"; bấm Back từng bước | Về bước nhập email; Back lùi đúng từng bước, không rời tab | P2 | |
| TC-PSG-GUEST-14 | K | **Hỗ trợ, tab Tài khoản.** "Câu hỏi thường gặp", "Liên hệ hỗ trợ"; tab Tài khoản: "Tra cứu vé đã đặt", "Đăng nhập / Đăng ký" | Mở FAQ; gọi tổng đài; sang tab Hành trình; sang màn đăng nhập. Câu "dùng mã đặt vé và email" lệch luồng thật (GAP-17) | P2 | |

### 5.12. Đánh giá chuyến (SCR-PSG-14, 25)

| Mã | Vai | Tình huống và thao tác | Kết quả mong đợi | Ưu tiên | KQ |
| --- | --- | --- | --- | --- | --- |
| TC-PSG-REV-01 | TV | **Mời đánh giá.** Vé đã đi, chưa đánh giá, mở chi tiết | Dưới thẻ vé có "Chuyến đi đã hoàn thành" và nút "Đánh giá chuyến đi" | P0 | |
| TC-PSG-REV-02 | TV | **Form.** Mở form, chưa chọn sao; chọn sao; nhập dài | Nút gửi khóa tới khi chọn sao; nhãn đổi theo sao (ví dụ "4/5 - Khá hài lòng"); bộ đếm tối đa 500 ký tự; đóng được | P1 | |
| TC-PSG-REV-03 | TV | **Gửi.** Chọn sao, nhập nhận xét có khoảng trắng đầu cuối, gửi | Form đóng; "Đánh giá của bạn" đúng số sao, nhận xét đã bỏ khoảng trắng; không còn nút gửi; DB một dòng | P0 | |
| TC-PSG-REV-04 | TV | **Mở lại.** Tắt app, mở lại vé | Vẫn hiện đánh giá đã gửi | P1 | |
| TC-PSG-REV-05 | TV | **Số sao hiển thị.** Dùng các đơn đánh giá 1, 2, 3, 4, 5 sao | Tô đúng số sao với cả năm mức | P1 | |
| TC-PSG-REV-06 | TV | **Chưa đủ điều kiện.** Vé hợp lệ; vé đã lên xe khi chuyến chưa hoàn thành; vé đã hủy | Không có khối đánh giá, không có khoảng trống thừa | P1 | |
| TC-PSG-REV-07 | TV | **Kiểm duyệt.** Admin giữ chờ, rồi ẩn đánh giá | Thêm dòng "Đánh giá đang chờ duyệt"; "Đánh giá hiện không được hiển thị" | P2 | |
| TC-PSG-REV-08 | TV | **Gửi lỗi.** Tắt mạng rồi gửi, bật mạng gửi lại | "Không thể gửi đánh giá. Vui lòng thử lại."; form giữ nội dung; gửi lại được | P1 | |
| TC-PSG-REV-09 | TV | **Đã gửi từ máy khác.** Mở form trên hai máy, gửi trên máy A rồi máy B | Máy B đóng form, hiện đánh giá đã có; DB vẫn một dòng | P2 | |
| TC-PSG-REV-10 | K+TV | **Trên trang nhà xe.** Mở trang nhà xe sau khi gửi | Có đánh giá, tên đã che; số đánh giá và điểm trung bình cập nhật | P1 | |

### 5.13. Tài khoản và hành khách đã lưu (SCR-PSG-11, 13)

| Mã | Vai | Tình huống và thao tác | Kết quả mong đợi | Ưu tiên | KQ |
| --- | --- | --- | --- | --- | --- |
| TC-PSG-ACC-01 | TV | **Tổng quan.** Tab Tài khoản | Đúng tên, email, điểm khả dụng, "{n}/5 hành khách"; các mục mở đúng màn | P1 | |
| TC-PSG-ACC-02 | TV | **Lỗi tải.** Tắt mạng rồi mở | Có nút thử lại, bật mạng tải được | P2 | |
| TC-PSG-ACC-03 | TV | **Sửa hồ sơ.** Đổi tên, ngày sinh, số điện thoại, "Lưu thay đổi", mở lại | Lưu đúng; Trang chủ đổi tên chào; đặt vé điền sẵn theo hồ sơ mới; email chỉ đọc (GAP-02) | P1 | |
| TC-PSG-ACC-04 | TV | **Kiểm lỗi hồ sơ.** Bỏ trống tên; tên quá 100 ký tự; số sai; xóa số đang có | "Vui lòng nhập họ và tên."; "Họ và tên tối đa 100 ký tự."; "Số điện thoại phải bắt đầu bằng 0 hoặc +84."; "API hiện chưa hỗ trợ xóa số điện thoại." | P2 | |
| TC-PSG-ACC-05 | TV | **Thêm hành khách đã lưu.** Từ danh sách rỗng, thêm người | Ban đầu "0/5", "Chưa có hành khách đã lưu"; thêm xong hiện trong danh sách và trong bảng chọn khi đặt vé | P1 | |
| TC-PSG-ACC-06 | TV | **Sửa, xóa.** Sửa số; xóa có xác nhận; bấm "Hủy" | Lưu đúng; "Bạn có chắc chắn muốn xóa {tên}?"; "Hủy" không xóa | P1 | |
| TC-PSG-ACC-07 | TV | **Đủ 5, số sai.** Thêm tới người thứ 5; nhập số sai | Hết nút thêm khi đủ 5; "Số điện thoại gồm 10 số, bắt đầu bằng 0 hoặc +84." | P1 | |
| TC-PSG-ACC-08 | TV | **Danh sách phiên.** Mở "Phiên đăng nhập & thiết bị" | "Phiên hiện tại" đúng thiết bị; các phiên khác có giờ đăng nhập, giờ hoạt động | P1 | |
| TC-PSG-ACC-09 | TV | **Đăng xuất một thiết bị.** Xác nhận đăng xuất phiên khác | Danh sách tải lại; thiết bị kia về đăng nhập | P1 | |
| TC-PSG-ACC-10 | TV | **Đăng xuất tất cả thiết bị khác.** | Các thiết bị khác bị đăng xuất; máy hiện tại giữ phiên | P1 | |
| TC-PSG-ACC-11 | TV | **Lỗi phiên.** Tắt mạng rồi tải, rồi đăng xuất | "Chưa thể tải danh sách phiên đăng nhập." có "Thử lại"; "Chưa đăng xuất được thiết bị. Vui lòng thử lại." | P2 | |

### 5.14. Ví voucher (SCR-PSG-36)

| Mã | Vai | Tình huống và thao tác | Kết quả mong đợi | Ưu tiên | KQ |
| --- | --- | --- | --- | --- | --- |
| TC-PSG-VCH-01 | TV | **Ví rỗng.** Tài khoản mới mở ví | Có trạng thái rỗng và ô nhập mã; không có voucher mẫu | P2 | |
| TC-PSG-VCH-02 | TV | **Sai định dạng.** Nhập `ab`, chuỗi có ký tự đặc biệt | "Mã gồm 3–20 chữ cái in hoa hoặc chữ số."; không gọi máy chủ | P1 | |
| TC-PSG-VCH-03 | TV | **Lưu mã công khai.** Nhập `KM-OK` | Voucher vào danh sách, "Đang có {n} khả dụng" tăng; dùng được khi đặt vé | P0 | |
| TC-PSG-VCH-04 | TV | **Mã không hợp lệ, đã lưu.** Nhập `KM-SAI`; nhập lại mã vừa lưu | Báo lỗi đúng lý do; danh sách không đổi, không trùng | P1 | |
| TC-PSG-VCH-05 | TV | **Xem điều kiện.** Bấm "Xem điều kiện ›" | "Mức giảm", "Giảm tối đa", "Đơn tối thiểu", "Áp dụng cho", "Hạn dùng", "Nguồn" đúng voucher; không có đơn tối thiểu thì "Không yêu cầu" | P1 | |
| TC-PSG-VCH-06 | TV | **Không đủ điều kiện ở đơn.** Dùng voucher có đơn tối thiểu cao hơn; voucher khác tuyến | Báo không áp dụng được ngay trên voucher đó; tổng không đổi | P1 | |
| TC-PSG-VCH-07 | TV | **Dùng xong, trả lại.** Thanh toán thành công; đơn khác để hết hạn | Voucher đã dùng biến mất khỏi ví; đơn hết hạn thì voucher quay lại | P0 | |

### 5.15. VXN Plus (SCR-PSG-33, 34, 35)

Chính sách mặc định: 1 điểm cho mỗi 10.000đ, 1 điểm đổi được 1.000đ, đổi từ 100 điểm, điểm có hạn 12 tháng, voucher đổi điểm có hạn 30 ngày. Hạng theo điểm tích trong 12 tháng: Đồng từ 0 (×1), Bạc từ 2.000 (×1,2), Vàng từ 5.000 (×1,5), Bạch kim từ 10.000 (×2). Nếu Admin đã đổi chính sách thì tính theo chính sách đang áp dụng.

| Mã | Vai | Tình huống và thao tác | Kết quả mong đợi | Ưu tiên | KQ |
| --- | --- | --- | --- | --- | --- |
| TC-PSG-LOY-01 | TV | **Màn VXN Plus.** Mở từ thẻ thành viên | Đúng hạng, hệ số, điểm khả dụng, "Ước tính quy đổi", bảng hạng, số điểm cần lên hạng | P1 | |
| TC-PSG-LOY-02 | TV | **Tích điểm.** Đi xong chuyến 300.000đ ở hạng Đồng, không giảm giá | Cộng đúng một lần 30 điểm sau khi chuyến hoàn thành (tiền đã trả × hệ số ÷ 10.000, làm tròn xuống); có giao dịch trong lịch sử | P0 | |
| TC-PSG-LOY-03 | K+TV | **Không tích.** Đơn khách vãng lai; vé vắng mặt | Khách không có điểm; vé vắng mặt không được tính vào số tiền tích | P1 | |
| TC-PSG-LOY-04 | TV | **Chưa đủ điểm.** Dưới 100 điểm | Khóa đổi điểm, "Bạn cần ít nhất 100 điểm để đổi voucher, còn thiếu {n} điểm." | P1 | |
| TC-PSG-LOY-05 | TV | **Bảng đổi điểm.** Mở bảng, đổi số điểm | Giá trị voucher, điểm còn lại, hạn dùng tính đúng khi đổi số; đủ đúng 100 điểm thì không có thanh trượt mà vẫn đổi được | P0 | |
| TC-PSG-LOY-06 | TV | **Nhập sai.** Dưới mức tối thiểu; vượt số dư | Báo tại ô, khóa xác nhận | P1 | |
| TC-PSG-LOY-07 | TV | **Đổi thành công.** Xác nhận | Số dư giảm đúng, có đường mở ví, ví có voucher, lịch sử có giao dịch đổi | P0 | |
| TC-PSG-LOY-08 | TV | **Không trừ hai lần.** Bấm nhanh hai lần; tắt mạng lúc gửi rồi thử lại cùng số điểm | Chỉ có một voucher, số dư chỉ giảm một lần | P0 | |
| TC-PSG-LOY-09 | TV | **Lịch sử điểm.** Xem, lọc loại giao dịch, "Lọc ngày" | Đúng giao dịch theo tháng; đổi loại vẫn giữ lọc ngày; số lớn không xuống dòng | P1 | |
| TC-PSG-LOY-10 | TV | **Không có dữ liệu, không có chính sách.** Tài khoản chưa có giao dịch; Admin ngừng chính sách | Trạng thái chưa có giao dịch; "Chưa có chính sách đổi điểm đang áp dụng." vẫn giữ số dư, khóa đổi | P2 | |
| TC-PSG-LOY-11 | TV | **Lên hạng, hết hạn.** Vượt 2.000 điểm trong 12 tháng; có điểm quá 12 tháng | Lên Bạc, chuyến sau tính ×1,2; điểm quá hạn bị trừ, có giao dịch hết hạn | P2 | |

### 5.16. Thông báo (SCR-PSG-12, 38)

| Mã | Vai | Tình huống và thao tác | Kết quả mong đợi | Ưu tiên | KQ |
| --- | --- | --- | --- | --- | --- |
| TC-PSG-NOT-01 | TV | **Quyền thông báo.** Lần đầu đăng nhập: cho phép; lần khác: từ chối | Có hộp xin quyền; từ chối vẫn dùng app bình thường, xem được vé | P1 | |
| TC-PSG-NOT-02 | TV | **Thông báo khi app ở nền.** Đặt vé xong, về màn hình chính | Nhận thông báo có logo, nội dung xuống hai dòng, "Mở" ở dòng dưới | P0 | |
| TC-PSG-NOT-03 | TV | **Thông báo khi app đang mở.** Nhận tin khi đang dùng | Thanh báo tự tắt sau 6 giây, có nút "Xem", chuông cập nhật | P1 | |
| TC-PSG-NOT-04 | TV | **Chạm thông báo.** Tin về đơn; tin khác; cả khi app đã tắt hẳn | Tin về đơn mở tab Hành trình đúng đơn; tin khác mở hộp thư | P0 | |
| TC-PSG-NOT-05 | TV | **Hộp thư.** Mở, chạm tin chưa đọc, chạm lại | "{n} tin chưa đọc"; chạm thì xem toàn văn, đánh dấu đã đọc, số giảm; nhãn giờ đúng (vừa xong, phút, giờ, ngày) | P1 | |
| TC-PSG-NOT-06 | TV | **Đọc tất cả.** Bấm "Đọc tất cả"; thử khi mất mạng | Hết chưa đọc, mất chấm đỏ ở chuông; lỗi thì báo và tải lại đúng với máy chủ | P1 | |
| TC-PSG-NOT-07 | TV | **Hành động theo tin.** Tin có liên kết đơn, bài viết, mã | "Xem hành trình", "Đọc bài viết", "Lưu mã {mã} vào ví" làm đúng; tin không liên kết chỉ để đọc | P1 | |
| TC-PSG-NOT-08 | TV | **Trống, lỗi, nhiều tin.** Tài khoản mới; tắt mạng; trên một trang tin | "Chưa có thông báo"; "Không tải được thông báo" có "Thử lại"; cuộn tải trang sau; tin mới về khi đang mở thì tự hiện | P2 | |
| TC-PSG-NOT-09 | TV | **Cài đặt.** Mở "Cài đặt thông báo", đổi rồi vào lại, cả từ máy khác | Bốn mục quan trọng "Luôn bật", không tắt được; "Ưu đãi và khuyến mãi", "VXN Plus", "Tin tức và sản phẩm mới" lưu trên máy chủ; lỗi báo "Chưa lưu được cài đặt. Vui lòng thử lại." | P1 | |
| TC-PSG-NOT-10 | TV | **Tắt tùy chọn có tác dụng.** Tắt khuyến mãi; để tin tức mặc định; bật tin tức; gửi các chiến dịch | Tắt thì không nhận; tin tức mặc định không nhận, bật mới nhận; tin dịch vụ vẫn có trong hộp thư | P1 | |
| TC-PSG-NOT-11 | K+TV | **Email.** Đặt vé, hủy vé, hoàn tiền thành công | Có email đúng mã đơn, số tiền; vé vẫn xem được kể cả khi email lỗi | P1 | |
| TC-PSG-NOT-12 | TV | **Sau đăng xuất.** Đăng xuất, gửi tin tới tài khoản | Máy không còn nhận thông báo đẩy | P1 | |
| TC-PSG-NOT-13 | TV | **Thẻ tiến độ mô phỏng.** Chỉ Local, Android, `JOURNEY_DEMO_ENABLED`. "Chạy thử hành trình", về màn hình chính | Thẻ có logo, tên tỉnh, thanh tiến độ, tới "Đã đến nơi" sau khoảng 3 phút, tự biến mất; chạm mở đúng đơn; không đổi trạng thái thật của chuyến. Chi tiết ở `TC-NSR-DEMO-002` đến `TC-NSR-DEMO-005` | P2 | |
| TC-PSG-NOT-14 | K+TV | **Nhà xe đổi chuyến.** Nhà xe đổi giờ chuyến đã có vé, kèm lý do | Thành viên có tin "Nhà xe đã thay đổi chuyến của bạn" trong hộp thư và thông báo đẩy, có email nêu thay đổi và lý do; chi tiết vé hiện giờ mới; vẫn hủy được theo chính sách | P1 | |
| TC-PSG-NOT-15 | K+TV | **Nhà xe hủy chuyến.** Nhà xe hủy chuyến đã có vé đã thanh toán, kèm lý do | Có tin "Nhà xe đã hủy chuyến" nêu lý do và hoàn toàn bộ số tiền; vé chuyển "Đã hủy", mã QR hết hiệu lực; đơn chưa thanh toán thì không bị trừ tiền | P1 | |

### 5.17. Khám phá (SCR-PSG-02, 37)

| Mã | Vai | Tình huống và thao tác | Kết quả mong đợi | Ưu tiên | KQ |
| --- | --- | --- | --- | --- | --- |
| TC-PSG-EXP-01 | K+TV | **Danh sách.** Mở tab Khám phá | Bài nổi bật, "Bài viết mới nhất" đúng bài đã xuất bản, có thời lượng đọc | P1 | |
| TC-PSG-EXP-02 | K+TV | **Chuyên mục.** Chuyển "Tất cả", "Cẩm nang", "Mẹo du lịch"; chuyên mục không có bài | Lọc đúng; rỗng thì "Chưa có bài viết trong chuyên mục này." | P1 | |
| TC-PSG-EXP-03 | K+TV | **Tìm từ khóa.** Gửi từ khóa có và không có kết quả | Tải lại theo từ khóa | P1 | |
| TC-PSG-EXP-04 | K+TV | **Đọc bài.** Chạm bài nổi bật và bài thường | Nội dung Markdown đúng định dạng, có ngày đăng, phút đọc; bài chứa thẻ `script` thì thẻ đó không chạy | P1 | |
| TC-PSG-EXP-05 | K+TV | **Tìm chuyến từ bài.** Bấm "Tìm chuyến đi" | Đóng bài, sang tab Mua vé | P1 | |
| TC-PSG-EXP-06 | K+TV | **Khối khuyến mãi.** Có và không có ưu đãi; chạm thẻ | Không có thì ẩn; có thì hiện mã thật; chạm chép mã | P2 | |
| TC-PSG-EXP-07 | K+TV | **Không có bài, lỗi tải.** DB không có bài; tắt mạng | Báo trống, không hiện bài mẫu; "Không tải được bài viết." có "Thử lại" | P1 | |

### 5.18. Hành vi chung trên thiết bị

| Mã | Vai | Tình huống và thao tác | Kết quả mong đợi | Ưu tiên | KQ |
| --- | --- | --- | --- | --- | --- |
| TC-PSG-SYS-01 | K+TV | **Back hệ thống.** Bấm Back ở mọi màn con, bảng bật lên, vé phóng to | Lùi đúng một bước, đóng bảng trước; không thoát app bất ngờ | P1 | |
| TC-PSG-SYS-02 | K+TV | **Màn nhỏ.** Máy 320×568, đi qua luồng đặt vé và Tài khoản | Không tràn, không che nút, cuộn được | P2 | |
| TC-PSG-SYS-03 | K+TV | **Chữ lớn.** Tăng cỡ chữ hệ thống, đi qua đăng nhập, Trang chủ, đặt vé | Không vỡ bố cục, không mất chữ | P2 | |
| TC-PSG-SYS-04 | K+TV | **Xoay máy.** Xoay ngang ở các màn chính và khi đang phóng to vé | Giao diện không vỡ; vé phóng to không xoay thêm | P2 | |
| TC-PSG-SYS-05 | K+TV | **Mất mạng toàn app.** Tắt mạng, thử từng tab | Báo "Không thể kết nối máy chủ. Vui lòng kiểm tra mạng và thử lại." hoặc nút thử lại; app không treo, không văng | P1 | |
| TC-PSG-SYS-06 | K+TV | **Máy chủ lỗi.** Tắt Redis trên API rồi giữ chỗ | "Hệ thống giữ chỗ đang bận. Vui lòng thử lại."; không cho đặt vượt chỗ | P2 | |
| TC-PSG-SYS-07 | K+TV | **Thanh hệ thống.** Xem các màn có ảnh nền, bảng bật lên, bàn phím | Chữ và biểu tượng thanh trạng thái đọc được; nội dung không nằm dưới thanh điều hướng | P2 | |
| TC-PSG-SYS-08 | K+TV | **Tắt hiệu ứng.** Tắt hoạt ảnh trong Cài đặt nhà phát triển | Đăng nhập, vé in ra hiện ngay trạng thái hoàn chỉnh | P2 | |

## 6. Phần app chưa có

Đối chiếu code tại commit `c8717ab`. Đây là chức năng trong checklist mà app chưa làm, không phải lỗi mới phát hiện khi test. Khi code đổi thì chuyển mục tương ứng thành case test.

| Mã | Chức năng | Hiện trạng trên app |
| --- | --- | --- |
| GAP-01 | `AUTH-01` Facebook, Apple | Chỉ có nút, bấm báo chưa tích hợp. Có Email OTP và Google |
| GAP-02 | `AUTH-03` Đổi email | Email chỉ đọc, không có luồng đổi |
| GAP-03 | `AUTH-06`, `REFUND-02` Xác minh lại trước thao tác nhạy cảm | App chưa gọi; hủy vé không hỏi OTP |
| GAP-04 | `HOME-03` Tìm trong FAQ | Có danh sách FAQ, không có ô tìm |
| GAP-05 | `HOME-04` Điều khoản, chính sách bảo mật, hoàn tiền | Hai cụm chữ ở màn đăng nhập chỉ là chữ, chạm không mở. Chỉ có "Điều khoản đặt vé" và "Chính sách hủy" ở bước xác nhận |
| GAP-06 | `SEARCH-02` Lọc theo điểm đón / trả, đánh giá | Bộ lọc có giá, dạng chỗ, hạng xe, giờ, tiện ích, nhà xe. Sắp xếp theo đánh giá thì có |
| GAP-07 | `BOOKING-06` Ghi chú đơn | Không có ô nhập |
| GAP-08 | `PAYMENT-03` Tự quay lại app sau thanh toán | Không có deep link. Người dùng tự quay lại, app kiểm tra ngay khi mở lại |
| GAP-09 | `PAYMENT-06` Thanh toán lại đơn đang chờ | Thử lại được ngay trên màn thanh toán. Đã rời màn thì không vào lại được từ Vé của tôi |
| GAP-10 | `TICKET-01`, `TICKET-02` Tab và tìm trong Vé của tôi | Một danh sách, không có tab, không có ô tìm |
| GAP-11 | `TICKET-07` In hoặc chia sẻ vé | Tải PDF báo chưa hỗ trợ; không có nút chia sẻ vé |
| GAP-12 | `TICKET-05` Quy định lên xe, liên hệ nhà xe trên vé | Chi tiết vé chỉ có tổng đài. "Lưu ý" và liên hệ nhà xe nằm ở chi tiết chuyến và trang nhà xe |
| GAP-13 | `SUPPORT-01` đến `SUPPORT-05`, `GUEST-05` Khiếu nại, hỗ trợ | App không có màn khiếu nại. "Cần hỗ trợ về chuyến đi?" chỉ gọi tổng đài |
| GAP-14 | `SUPPORT-07` Đánh giá của tôi | Bản debug là dữ liệu mẫu, bản release trống. API chưa có danh sách theo tài khoản. Gửi đánh giá thật đi từ chi tiết vé |
| GAP-15 | `NOTIFICATION-04` Thông báo theo chuyến | Chạy cả luồng chỉ tạo tin đặt vé thành công. Khi xe khởi hành, hoàn thành chuyến, mời đánh giá chưa có tin. Thẻ tiến độ chỉ là mô phỏng bật tay, không gắn chuyến thật. Android gộp thẻ này với thông báo khác của app |
| GAP-16 | `VOUCHER-01` Tab Đã dùng, Hết hạn | Ví chỉ hiện voucher khả dụng |
| GAP-17 | Câu chữ | Màn OTP đăng nhập ghi tổng đài 1900 6868, các màn khác ghi 1900 636 707. Tài khoản khách ghi "dùng mã đặt vé và email" trong khi tra cứu chỉ cần email và OTP |
| GAP-18 | `EXPLORE-05`, `EXPLORE-06` Chia sẻ bài, bài liên quan | Màn đọc bài không có hai phần này |
| GAP-19 | `BOOKING-02` Bốn trạng thái ghế | Chú giải có ba trạng thái; đang giữ và đã đặt gộp thành "Không đặt được" |

## 7. Đối chiếu với checklist 80 chức năng

Mã trong cột "Kịch bản" bỏ tiền tố `TC-PSG-` cho gọn.

| Chức năng | Kịch bản | Thiếu |
| --- | --- | --- |
| AUTH-01 | AUTH-01 đến AUTH-15 | GAP-01 |
| AUTH-02 | ACC-03, ACC-04, ACC-05, ACC-07 | |
| AUTH-03 | | GAP-02 |
| AUTH-04 | ACC-05, ACC-06, INFO-05 | |
| AUTH-05 | AUTH-16 đến AUTH-20, ACC-08 đến ACC-11 | |
| AUTH-06 | | GAP-03 |
| HOME-01 | HOME-01, HOME-02, SEARCH-01 | |
| HOME-02 | HOME-03 đến HOME-07 | |
| HOME-03 | HOME-08 | GAP-04 |
| HOME-04 | CONF-04 | GAP-05 |
| HOME-05 | SYS-05, SYS-06, SEARCH-12, TRIP-09 | |
| SEARCH-01 | SEARCH-01 đến SEARCH-06, SEARCH-13, SEARCH-14 | |
| SEARCH-02 | SEARCH-07, SEARCH-08, SEARCH-15 | GAP-06 |
| SEARCH-03 | SEARCH-09 | |
| TRIP-01 | TRIP-01, TRIP-04 | |
| TRIP-02 | TRIP-01, TRIP-03, SEAT-01 | |
| TRIP-03 | TRIP-05 đến TRIP-09 | |
| BOOKING-01 | SEAT-05, SEAT-06, SEAT-12 | |
| BOOKING-02 | SEAT-01 đến SEAT-04, SEAT-08 | GAP-19 |
| BOOKING-03 | SEAT-07, SEAT-09, INFO-12, CONF-08 | |
| BOOKING-04 | INFO-01, INFO-02, INFO-03, INFO-07 | |
| BOOKING-05 | INFO-04, INFO-05, INFO-06 | |
| BOOKING-06 | | GAP-07 |
| BOOKING-07 | INFO-08 đến INFO-11, CONF-07 | |
| BOOKING-08 | CONF-01, CONF-06 | |
| PAYMENT-01 | PAY-05, PAY-06 | |
| PAYMENT-02 | PAY-07 | |
| PAYMENT-03 | PAY-10 | GAP-08 |
| PAYMENT-04 | PAY-10, PAY-11, PAY-14 | |
| PAYMENT-05 | PAY-03, PAY-04, PAY-12, PAY-13, PAY-15 | |
| PAYMENT-06 | PAY-04, PAY-19 | GAP-09 |
| TICKET-01 | TICK-01, TICK-02 | GAP-10 |
| TICKET-02 | TICK-05 (chỉ trong đơn) | GAP-10 |
| TICKET-03 | TICK-03, TICK-04, TICK-05, PAY-15, PAY-16 | |
| TICKET-04 | TICK-03 | |
| TICKET-05 | TRIP-01 | GAP-12 |
| TICKET-06 | TICK-03, TICK-06 đến TICK-09, CANCEL-05 | |
| TICKET-07 | PAY-18 | GAP-11 |
| REFUND-01 | CANCEL-01, CANCEL-02, CANCEL-03, CANCEL-08 | |
| REFUND-02 | | GAP-03 |
| REFUND-03 | CANCEL-07, E2E-03 | |
| REFUND-04 | CANCEL-02, CANCEL-03, CANCEL-09 | |
| REFUND-05 | CANCEL-10 | |
| GUEST-01 | GUEST-01, GUEST-06, GUEST-07 | |
| GUEST-02 | GUEST-02 đến GUEST-05, GUEST-11, GUEST-12 | |
| GUEST-03 | GUEST-08, GUEST-10 | |
| GUEST-04 | GUEST-09, E2E-01 | |
| GUEST-05 | | GAP-13 |
| SUPPORT-01 | | GAP-13 |
| SUPPORT-02 | | GAP-13 |
| SUPPORT-03 | | GAP-13 |
| SUPPORT-04 | | GAP-13 |
| SUPPORT-05 | | GAP-13 |
| SUPPORT-06 | REV-01 đến REV-10, E2E-02 | |
| SUPPORT-07 | | GAP-14 |
| NOTIFICATION-01 | NOT-03, NOT-05 đến NOT-08 | |
| NOTIFICATION-02 | NOT-01, NOT-02, NOT-04, NOT-12 | iOS ngoài phạm vi |
| NOTIFICATION-03 | NOT-11 | |
| NOTIFICATION-04 | NOT-02, NOT-11, NOT-14, NOT-15, CANCEL-10 | GAP-15 |
| NOTIFICATION-05 | NOT-09, NOT-10, E2E-08 | |
| NOTIFICATION-06 | NOT-09 | |
| LOYALTY-01 | LOY-02, LOY-03 | |
| LOYALTY-02 | LOY-01, LOY-11 | |
| LOYALTY-03 | LOY-01 | |
| LOYALTY-04 | LOY-01 | |
| LOYALTY-05 | LOY-01, LOY-11 | |
| LOYALTY-06 | LOY-09, LOY-10 | |
| LOYALTY-07 | LOY-09, LOY-11 | |
| LOYALTY-08 | LOY-04 đến LOY-08, E2E-05 | |
| VOUCHER-01 | VCH-01, VCH-03, VCH-07 | GAP-16 |
| VOUCHER-02 | VCH-02, VCH-03, VCH-04 | |
| VOUCHER-03 | VCH-05 | |
| VOUCHER-04 | LOY-07, E2E-05 | |
| VOUCHER-05 | INFO-10, VCH-06 | |
| EXPLORE-01 | EXP-01, EXP-07 | |
| EXPLORE-02 | EXP-01, EXP-04 | |
| EXPLORE-03 | EXP-02 | |
| EXPLORE-04 | EXP-03 | |
| EXPLORE-05 | EXP-04, EXP-05 | GAP-18 |
| EXPLORE-06 | | GAP-18 |

Màn SCR-PSG-04 (Dịch vụ bổ trợ), SCR-PSG-05, SCR-PSG-06 (trang lỗi, trang pháp lý), SCR-PSG-10 (OAuth callback web), SCR-PSG-30, SCR-PSG-31, SCR-PSG-32 (khiếu nại) không có trên app nên không có case riêng.

## 8. Biên bản chạy

Sao chép bảng này cho mỗi đợt chạy.

| Mục | Điền |
| --- | --- |
| Đợt, ngày chạy, người chạy | |
| Bản build và commit | |
| Thiết bị, Android | |
| Môi trường (Local hay Production), cổng thanh toán đã bật | |
| Số case đã chạy, Đạt, Lỗi, Chặn, Bỏ qua | |
| Lỗi S1, S2 còn mở | |
| Phần không kiểm tra được và lý do | |
| Kết luận | |
