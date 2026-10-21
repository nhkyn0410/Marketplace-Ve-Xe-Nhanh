# Checklist kiểm thử OTP thủ công — web khách hàng

Ngày lập: 21/10/2026. Branch đối chiếu: `marketplace-api-integration`.

**Trạng thái: CHƯA CHẠY.** Tài liệu này có 40 ca để Khanh tự kiểm thử. Đây là kế hoạch và phiếu ghi kết quả, chưa phải bằng chứng OTP đã hoạt động.

| Thông tin lần chạy | Người test điền |
| --- | --- |
| Người kiểm thử | ... |
| Ngày, giờ bắt đầu/kết thúc, múi giờ | ... |
| Commit/phiên bản web và API | ... |
| URL web / URL API, tên môi trường | ... |
| Trình duyệt, phiên bản, desktop/mobile | ... |
| Kênh gửi email thực tế / mailbox test đã xác nhận quyền sử dụng | ... |
| Kết quả tổng hợp | Pass: ... / Fail: ... / Blocked: ... / Chưa chạy: ... |
| Lỗi và bằng chứng đã che dữ liệu | ... |

## Phạm vi và cách ghi kết quả

- Tất cả thao tác yêu cầu, nhận, nhập, xác minh và gửi lại **email OTP của Passenger** được kiểm thử thủ công tại đây, tách khỏi suite E2E tự động.
- Refresh token, logout, thu hồi phiên, phối hợp nhiều tab khi refresh và refresh-token reuse thuộc nhóm kiểm thử **session**, không phải OTP. Checklist này chỉ kiểm trạng thái đăng nhập/cookie ngay sau xác minh và việc một OTP không được xác minh lại.
- `Đổi email` tại màn OTP chỉ quay lại chọn email đăng nhập. Web hiện không có luồng đổi email của tài khoản. Tra cứu vé Guest không dùng OTP. Google OAuth chưa có luồng đăng nhập web hoàn chỉnh; Facebook/Apple chưa hỗ trợ.
- Kết quả từng ca dùng `Pass`, `Fail`, `Blocked` hoặc `Chưa chạy`. Ghi mã lỗi, thời điểm và bước tái hiện; không ghi mã OTP, giá trị cookie, access/refresh token, khóa Resend hoặc ảnh chụp mailbox còn lộ mã.
- Mỗi ca độc lập cần email/phiên phù hợp. Các ca sai mã, hết hạn, gửi lại và vượt giới hạn có thể làm mã của ca khác mất hiệu lực; chạy tuần tự cho cùng email.

## Điều kiện trước khi kiểm thử

1. Web và API chạy cùng phiên bản tích hợp; API kết nối được PostgreSQL và Redis. Không dùng `?preview=...` làm bằng chứng cho luồng thật.
2. Với các ca cần nhận email: cấu hình **Resend** và địa chỉ gửi hợp lệ trong môi trường test; người test kiểm soát mailbox nhận, có quyền gửi email test tới địa chỉ đó. Kiểm tra Inbox/Spam và thời điểm nhận bằng giao diện mailbox. Chỉ ghi nhận tình trạng cấu hình, không ghi giá trị khóa vào phiếu.
3. Dev fallback `ConsoleEmailNotifier` **không gửi email và không in mã OTP**. Không tìm mã trong console/log, không trích từ DB, không dùng mã cố định, không thêm endpoint/harness hay sửa API để bỏ qua xác minh.
4. API chủ động trả `200 {status: "ok"}` khi yêu cầu gửi gặp lỗi kênh email để tránh lộ tài khoản. Vì vậy việc web chuyển sang `/verify-email` hoặc request gửi trả 200 **không chứng minh thư đã được giao**. Không nhận thư thì ca cần xác minh phải ghi `Blocked`/`Fail` theo nguyên nhân, không đánh Pass.
5. Chuẩn bị một cửa sổ Guest sạch và các browser profile riêng cho dữ liệu test. Không xóa cookie của trình duyệt đang dùng cho công việc. Chỉ xem thuộc tính cookie, không sao chép hoặc chụp giá trị.
6. Các ca khóa/mở khóa cần tài khoản test được người có quyền chuẩn bị trước. Các ca lỗi dịch vụ cần môi trường test riêng có thể chủ động ngắt/phục hồi; nếu thiếu điều kiện, ghi `Blocked`, không tác động môi trường dùng chung.
7. Ca hết hạn và hết cửa sổ rate limit dùng **thời gian máy chủ thật**; không chỉnh đồng hồ hệ thống hay thời hạn OTP để rút ngắn kiểm thử. Bộ đếm phía trình duyệt không điều khiển TTL máy chủ.

| Dữ liệu | Mục đích |
| --- | --- |
| `MAIL-NEW` | Mailbox chưa có Passenger; người test có quyền nhận thư |
| `MAIL-ACTIVE` | Passenger ACTIVE đã có hồ sơ/booking test dễ nhận biết |
| `MAIL-B` | Mailbox test khác, tách danh tính khỏi `MAIL-ACTIVE` |
| `MAIL-LOCKED` | Passenger test bị khóa trước ca; có người có quyền mở khóa sau ca |
| `MAIL-LIMIT` | Mailbox dành riêng cho cooldown/giới hạn theo giờ; không dùng để đăng nhập cho suite khác |
| `MAIL-NODELIVERY` | Mailbox test chỉ dùng khi môi trường kênh gửi chưa cấu hình/lỗi đã được chuẩn bị |

Các nhãn trên là tên dữ liệu trong phiếu, không phải địa chỉ email mẫu để gửi thật. Không giả định alias của mailbox là cùng một email trong hệ thống.

## Hợp đồng hiện tại để đối chiếu

| Nội dung | Hành vi hiện có |
| --- | --- |
| Đăng ký | `/register` chỉ nhập email, đồng ý điều khoản/bảo mật; gọi `POST /v1/auth/register` |
| Đăng nhập | `/login` nhập email; gọi `POST /v1/auth/otp/request`; chưa có mật khẩu/social login khả dụng |
| Xác minh | `/verify-email?email=...`; web chỉ gửi email và OTP gồm 6 chữ số tới `POST /v1/auth/otp/verify` qua Server Action |
| Hiệu lực mã | 6 chữ số, 300 giây; Better Auth cấu hình `allowedAttempts: 3` cho mỗi OTP |
| Giới hạn yêu cầu | Cooldown 60 giây và tối đa 5 lần/3.600 giây/email; register và login dùng chung bộ giới hạn; email được chuẩn hóa trim/lowercase ở bộ giới hạn |
| Phản hồi lỗi | Sai/hết hạn/mã đã dùng: lỗi đăng nhập chung; vượt tần suất: `AUTH_OTP_RATE_LIMITED`; OTP đúng nhưng account bị khóa: `AUTH_ACCOUNT_LOCKED` |
| Tạo tài khoản | Register và request OTP dùng cùng kiểu sign-in; Better Auth tạo Passenger khi xác minh thành công. Nhập email mới tại Login cũng có thể tạo tài khoản khi xác minh |
| Sau xác minh | Chuyển `/account`, tải hồ sơ thật; tên/điện thoại/ngày sinh bổ sung riêng, không tự lưu từ email |
| Lưu credential | Web lưu `vxn_marketplace_access` và `vxn_marketplace_refresh` trong cookie httpOnly, SameSite=Lax, Path=/; Secure khi web chạy production |

Màn OTP có bộ đếm **gửi lại** 60 giây và thông báo hiệu lực 5 phút; không có số lượt thử còn lại hoặc bộ đếm hết hạn do API cấp. Không yêu cầu UI phải tự dựng các số đó. `next` trong liên kết login hiện không thay đổi đích sau verify: hành vi hiện tại là `/account`.

## A. Đăng ký và đăng nhập

| ID / mức | Điều kiện và thao tác thủ công | Kết quả mong đợi | Kết quả / ghi chú |
| --- | --- | --- | --- |
| OTP-M01 / P0 | Kiểm môi trường và mailbox test; mở `/register` trong Guest sạch. | Form chỉ yêu cầu email, có điều khoản/bảo mật; chưa có phiên Passenger. Người test xác nhận có kênh giao thư thật trước các ca tiếp theo. | Chưa chạy |
| OTP-M02 / P1 | Tại `/login` và `/register`, thử email rỗng/sai định dạng, rồi sửa thành email test hợp lệ. | Dữ liệu không hợp lệ không tiến sang xác minh thành công; hiển thị kiểm tra của form. Email hợp lệ dùng được; không hiện lỗi thô nội bộ. | Chưa chạy |
| OTP-M03 / P1 | Tại Register nhập email hợp lệ nhưng chưa đồng ý điều khoản; thử thao tác bằng chuột/bàn phím, sau đó đồng ý và mở hai link pháp lý. | Không gửi đăng ký khi chưa đồng ý; link tới `/legal/terms`, `/legal/privacy`; không yêu cầu thêm tên/điện thoại để gửi OTP. | Chưa chạy |
| OTP-M04 / P0 | Dùng `MAIL-NEW`: Register → đồng ý → `Tạo tài khoản và gửi mã`; mở mailbox. Chưa nhập mã; mở `/account` ở tab khác. | Đi tới màn xác minh đúng email; nhận email 6 số, hiệu lực 5 phút. Trước verify chưa có quyền Passenger vào hồ sơ. Nếu chỉ chuyển trang nhưng không nhận email, không đánh Pass delivery. | Chưa chạy |
| OTP-M05 / P0 | Tiếp OTP-M04: nhập mã mới nhất nhận trong mailbox trước hạn, bấm `Xác minh`; tải lại `/account`. | Vào `/account` với đúng email, đã xác minh; trạng thái đăng nhập và hồ sơ thật còn sau reload. Tên/điện thoại chưa khai báo không bị tự gán từ email; không có thông báo lưu hồ sơ giả. | Chưa chạy |
| OTP-M06 / P0 | Trong Guest sạch khác, Login bằng `MAIL-ACTIVE`; nhận và nhập mã mới. | Đăng nhập đúng tài khoản cũ, thấy dữ liệu nhận biết của tài khoản đó; không tạo hồ sơ/điểm thành viên trùng. | Chưa chạy |
| OTP-M07 / P1 | Dùng email đã tồn tại tại Register, hoàn tất nhận/xác minh mã hợp lệ. | Không tiết lộ trạng thái tồn tại ngay bước yêu cầu gửi; xác minh đưa về cùng tài khoản cũ, không nhân đôi dữ liệu. | Chưa chạy |
| OTP-M08 / P1 | Dùng mailbox mới chưa đăng ký tại Login; nhận/xác minh mã hợp lệ. | Luồng hiện tại cho phép hoàn tất tài khoản Passenger qua sign-in OTP; chưa verify thì không có quyền hồ sơ; sau verify có đúng email mới. Không coi đây là lỗi thiếu màn đăng ký. | Chưa chạy |
| OTP-M09 / P1 | Sau lần gửi thành công, nhấn nút nhiều lần nhanh/Enter khi đang gửi; dùng mailbox riêng để không ảnh hưởng ca khác. | Form khóa khi đang gửi, không mở nhiều màn thành công khác nhau hoặc tạo phiên trước verify. Nếu có yêu cầu trùng, giới hạn máy chủ vẫn áp dụng; ghi nhận số thư nhận thực tế. | Chưa chạy |

## B. Nhập và xác minh mã

| ID / mức | Điều kiện và thao tác thủ công | Kết quả mong đợi | Kết quả / ghi chú |
| --- | --- | --- | --- |
| OTP-M10 / P1 | Mở `/verify-email` thiếu email, email sai định dạng hoặc tham số email lặp nhiều giá trị. | Quay lại `/login`; không dựng tài khoản/email fixture hoặc cho xác minh với danh tính không hợp lệ. | Chưa chạy |
| OTP-M11 / P1 | Mở trực tiếp `/verify-email?email=...` với email test hợp lệ nhưng chưa yêu cầu mã. | Màn 6 ô trống; việc mở trang không tự gửi email hoặc tự đăng nhập. Nhập mã không có phiên yêu cầu hợp lệ không tạo quyền Passenger. | Chưa chạy |
| OTP-M12 / P1 | Nhập từng số, dùng Backspace, Tab và Enter; thử trên desktop rồi bàn phím mobile. | Chỉ nhận chữ số, focus chuyển hợp lý; thiếu ô thì nút xác minh chưa cho gửi. Enter khi đủ mã đi cùng luồng xác minh như bấm nút. | Chưa chạy |
| OTP-M13 / P1 | Dán nguyên mã 6 số từ mailbox vào ô đầu; thử chức năng gợi ý mã của thiết bị nếu có. | Có thể nhập đủ, đúng thứ tự và xác minh. Nếu browser chỉ nhận một ký tự do giới hạn ô, ghi lỗi tương thích; không đánh Pass khả năng dán bằng việc gõ lại. Gợi ý mã không được hỗ trợ trên thiết bị thì ghi riêng, không khẳng định đã kiểm. | Chưa chạy |
| OTP-M14 / P1 | Thử chữ/ký tự đặc biệt, thiếu số và xóa một ô đã điền. | Không gửi mã chưa đủ 6 chữ số; không tự đổi sang tài khoản khác hoặc báo đã xác minh. Không có số lượt thử còn lại tự đoán. | Chưa chạy |
| OTP-M15 / P0 | Với mã mới còn hạn, nhập một mã cố ý sai. | Báo lỗi đăng nhập/mã không hợp lệ; vẫn chưa có quyền Passenger. Không phân biệt trong lỗi rằng email chưa tồn tại hoặc đã tồn tại. | Chưa chạy |
| OTP-M16 / P0 | Với mã mới, sai một lần rồi nhập mã đúng còn hạn trước khi đủ 3 lần sai. | Xác minh đúng thành công; một lần sai không khóa tài khoản vĩnh viễn. | Chưa chạy |
| OTP-M17 / P0 | Với một mã mới, nhập sai 3 lần; sau đó thử mã đúng ban đầu. Dùng email riêng. | Mã đã vượt số lần thử không đăng nhập được, kể cả mã đúng; lấy mã mới theo cooldown để phục hồi. UI báo lỗi chung, không bịa số lượt còn lại. | Chưa chạy |
| OTP-M18 / P0 | Yêu cầu một mã mới, ghi thời điểm gửi/nhận không ghi mã vào phiếu; đợi hơn 5 phút kể từ yêu cầu và thêm khoảng đệm, rồi nhập mã đó. | Máy chủ từ chối mã hết hạn, không có phiên mới. Reload màn hoặc bộ đếm gửi lại về 0 không làm mã sống lại. | Chưa chạy |
| OTP-M19 / P0 | Xác minh thành công một mã ở browser A. Trong browser Guest B sạch, mở màn cùng email và nhập lại mã đã dùng. | Mã đã dùng bị từ chối; browser B không nhận quyền Passenger. Phiên đang hợp lệ ở A không phải bằng chứng B đã xác minh lại. | Chưa chạy |
| OTP-M20 / P0 | Yêu cầu mã riêng cho `MAIL-ACTIVE` và `MAIL-B`; nhập mã của mailbox A trên màn mang email B. | Không đăng nhập B hoặc A bằng cặp email/mã không khớp; chỉ cặp đúng còn hạn được xác minh. | Chưa chạy |
| OTP-M21 / P1 | Mở hai browser Guest độc lập cùng email; chỉ yêu cầu một mã. Nhập mã đó gần nhau ở hai browser, tránh nhầm ca gửi lại. | Một OTP không cấp hai phiên mới qua hai lần xác minh. Nếu cả hai browser độc lập đều thành công bằng cùng một mã thì ghi Fail, kèm thời điểm không kèm mã. | Chưa chạy |

## C. Gửi lại, thời gian và giới hạn

| ID / mức | Điều kiện và thao tác thủ công | Kết quả mong đợi | Kết quả / ghi chú |
| --- | --- | --- | --- |
| OTP-M22 / P0 | Sau gửi thành công, kiểm nút gửi lại trước 60 giây và khi đủ 60 giây. | Trước hạn chỉ có trạng thái chờ, không bấm gửi lại được; sau hạn có `Gửi lại mã xác minh`. Bộ đếm là cooldown UI, không phải thời hạn còn lại của OTP. | Chưa chạy |
| OTP-M23 / P0 | Đủ cooldown: nhập một phần mã cũ rồi gửi lại; kiểm mailbox và dùng mã mới nhất. | Ô mã được xóa, cooldown về 60 giây, nhận thư mới; mã mới xác minh được. Chuyển sang màn vẫn không đủ để đánh Pass giao thư. | Chưa chạy |
| OTP-M24 / P0 | Với mã cũ còn trong 5 phút, gửi lại thành công sau cooldown; thử mã cũ trước khi dùng mã mới. | Mã cũ không xác minh được sau khi đã cấp mã mới; mã mới còn hạn hoạt động. Tách khỏi ca hết số lần sai. | Chưa chạy |
| OTP-M25 / P1 | Yêu cầu mã; reload/back/forward màn xác minh, mở lại URL cùng email và để tab nền rồi quay lại. | Không tự đăng nhập, không tự gửi thêm thư, không kéo dài hiệu lực mã trên máy chủ. Bộ đếm UI có thể khởi tạo lại sau reload; kiểm giới hạn máy chủ riêng ở OTP-M26. | Chưa chạy |
| OTP-M26 / P0 | Dùng `MAIL-LIMIT`: Register gửi một lần, ngay sau đó về Login yêu cầu mã cùng email trong 60 giây; thử từ browser profile khác. | Máy chủ chặn gửi tiếp, web báo yêu cầu quá nhiều; register/login và browser khác không vượt được cooldown cùng email. Nếu kiểm HTTP backend thì là 429 `AUTH_OTP_RATE_LIMITED`; HTTP ngoài của Next Server Action không thay thế kết quả nghiệp vụ. | Chưa chạy |
| OTP-M27 / P0 | Với email giới hạn riêng và cửa sổ mới, gửi đủ 5 lần qua Login/Register/Resend, mỗi lần cách nhau ít nhất 60 giây; lần 6 vẫn trong 3.600 giây từ lần đầu. | Lần 6 bị chặn, không có email OTP thứ 6 do yêu cầu đó; UI báo quá nhiều yêu cầu, không báo tài khoản bị khóa vĩnh viễn. Ghi thời điểm mỗi lần, không ghi mã. | Chưa chạy |
| OTP-M28 / P1 | Sau OTP-M27, đợi quá 3.600 giây từ lần đầu và quá cooldown của lần thử gần nhất, rồi yêu cầu lại một lần. | Có thể yêu cầu/nhận và xác minh mã mới; không phải khóa vĩnh viễn. Chưa chờ đủ thời gian thì ghi Chưa chạy, không giả lập đã hết cửa sổ. | Chưa chạy |
| OTP-M29 / P1 | Sau một yêu cầu thành công, trong cooldown dùng cùng email với chữ hoa/chữ thường khác nhau tại Login/Register. | Không có thêm lượt do khác chữ hoa/thường. Nếu thử khoảng trắng ngoài email, form có thể từ chối định dạng; chỉ kết luận về bucket khi yêu cầu thực sự tới nghiệp vụ, không đòi web tự trim khi hợp đồng chưa hỗ trợ. | Chưa chạy |

## D. Trạng thái tài khoản và đổi email

| ID / mức | Điều kiện và thao tác thủ công | Kết quả mong đợi | Kết quả / ghi chú |
| --- | --- | --- | --- |
| OTP-M30 / P0 | Với `MAIL-LOCKED` đã chuẩn bị, yêu cầu và nhập mã đúng còn hạn trong Guest sạch. | Có thể nhận phản hồi gửi chung, nhưng xác minh không cấp phiên Passenger; báo tài khoản bị khóa/vô hiệu, nghiệp vụ `AUTH_ACCOUNT_LOCKED` (403). | Chưa chạy |
| OTP-M31 / P1 | Với tài khoản khóa, lấy mã mới rồi nhập sai. So sánh với ca sai mã của tài khoản ACTIVE. | Sai OTP là lỗi đăng nhập chung; không lộ trạng thái khóa trước khi chứng minh đúng credential. Không có phiên mới. | Chưa chạy |
| OTP-M32 / P1 | Người có quyền mở khóa tài khoản test; trong Guest sạch yêu cầu một mã mới và xác minh. | Đăng nhập lại được với mã mới; không dùng mã đã bị tiêu thụ ở ca khóa để kết luận lỗi mở khóa. | Chưa chạy |
| OTP-M33 / P1 | Tại màn OTP cho email A, chọn `Đổi email`, nhập mailbox B tại Login, nhận mã B và xác minh. | Quay về Login để chọn danh tính; chỉ sau xác minh B mới có phiên B. Thao tác này không đổi email hồ sơ của tài khoản A. | Chưa chạy |
| OTP-M34 / P1 | Sau đăng nhập, mở `/account`, kiểm trường email và phần phương thức đăng nhập. | Email chỉ hiển thị; không có luồng đổi email/OTP đổi email hoặc liên kết OAuth giả thành công. Ghi N/A cho chức năng chưa hỗ trợ, không tự gọi endpoint Better Auth ngoài hợp đồng web. | Chưa chạy |

## E. Kênh gửi, lỗi và ranh giới với session/E2E

| ID / mức | Điều kiện và thao tác thủ công | Kết quả mong đợi | Kết quả / ghi chú |
| --- | --- | --- | --- |
| OTP-M35 / P0 | Trên môi trường test đã chuẩn bị thiếu/lỗi kênh gửi, dùng `MAIL-NODELIVERY` yêu cầu OTP; kiểm mailbox trong khoảng chờ đã thống nhất. | Không nhận mã từ dev fallback; phản hồi gửi vẫn có thể 200 và màn OTP vẫn mở. Ghi rõ delivery chưa thực hiện được; không đánh Pass xác minh, không tìm/hiện mã qua console hay tạo cách bỏ qua. | Chưa chạy |
| OTP-M36 / P1 | Mô phỏng mất kết nối trình duyệt lúc gửi hoặc xác minh trên môi trường test, sau đó khôi phục. | Báo lỗi kết nối/không hoàn tất, không dựng trạng thái thành công hoặc hồ sơ fixture. Nếu mất phản hồi sau verify, kiểm trạng thái phiên hiện tại trước khi thử lại; khi cần đăng nhập lại thì yêu cầu mã mới theo giới hạn. | Chưa chạy |
| OTP-M37 / P0 | Theo dõi URL sau gửi, verify, reload và điều hướng; kiểm link/ảnh bằng chứng đã che dữ liệu. | URL có thể chứa email ở `/verify-email?email=...` theo thiết kế hiện tại; không chứa OTP, access/refresh token hoặc bí mật trong URL/props hiển thị. Không đưa email/OTP/token vào báo cáo ảnh công khai. | Chưa chạy |
| OTP-M38 / P0 | Ngay sau verify hợp lệ, dùng giao diện DevTools chỉ kiểm **tên/thuộc tính**, không sao chép giá trị cookie hoặc storage. | Hai cookie `vxn_marketplace_access`/`vxn_marketplace_refresh` có HttpOnly, SameSite=Lax, Path=/; Secure ở production HTTPS. Không có credential trong localStorage/sessionStorage hoặc nội dung trang. Vòng đời refresh/revoke kiểm riêng ở suite session. | Chưa chạy |
| OTP-M39 / P1 | Mở `/tickets/lookup`, `/auth/callback`, Login/Register thật; ở build production thử thêm `preview=ideal` vào màn auth. | Lookup dùng mã booking + email, không có bước OTP tra cứu. Social callback thông báo chưa khả dụng, Login/Register không có social login giả. Production không dùng fixture hay xác minh preview thành công. | Chưa chạy |
| OTP-M40 / P0 | Hoàn tất Login/Verify thủ công cho tài khoản test ACTIVE; xác nhận `/account` đúng email và dữ liệu, rồi bàn giao đúng browser context cho các ca Passenger của kế hoạch E2E. | Đánh dấu điều kiện `manual login complete`, người thực hiện và thời điểm. Chỉ sau đó chạy các ca cần Passenger; thiếu phiên hợp lệ thì Blocked/precondition failed, không tự lấy mã, giả OTP hoặc tính OTP vào độ bao phủ tự động. | Chưa chạy |

## Bàn giao cho kế hoạch E2E khách hàng

| Hạng mục | Cách thực hiện |
| --- | --- |
| Các ca Guest | Dùng browser context sạch không có cookie Passenger; không cần OTP để search, mua/tra cứu bằng hợp đồng Guest |
| Các ca Passenger | Người test đăng nhập bằng mailbox thật trước; xác nhận danh tính và dữ liệu theo OTP-M40. Mỗi tài khoản A/B phải có context riêng |
| Cách runner dùng phiên | Là điều kiện phải thiết kế khi triển khai suite; hiện chưa tạo cơ chế nhập phiên, helper OTP hoặc storage-state file. Không mặc định Playwright tự dùng cookie của Chrome đang mở |
| Khi phiên không dùng được | Báo precondition failed/Blocked và để người test đăng nhập lại khi cần; không âm thầm chuyển sang Guest hoặc seed token để báo Pass |
| Session/refresh | Tiếp tục trong nhóm session E2E; thời hạn 15 phút/30 ngày của access/refresh không phải TTL 5 phút của OTP |
| Thống kê | Báo riêng OTP manual: đã chạy/Pass/Fail/Blocked; E2E tự động chỉ tính các ca thực sự tự động và đủ điều kiện. Không gộp ca manual thành tỷ lệ automation |

Phiếu bàn giao:

- Người đăng nhập thủ công: ...
- Thời điểm và môi trường: ...
- Nhãn tài khoản/context (không ghi token): ...
- OTP-M40: Chưa chạy / Pass / Fail / Blocked: ...
- Suite Passenger được phép bắt đầu vì đã đủ điều kiện: ...
- Lỗi còn tồn tại hoặc ca cần chạy lại: ...

## Tiêu chí hoàn tất và nguồn đối chiếu

- Tất cả ca P0 áp dụng phải có kết quả thực chạy; không còn lỗi cấp phiên sai danh tính, dùng lại OTP, bỏ qua khóa hoặc rò credential.
- Ca thiếu mailbox/kênh gửi/account state/môi trường lỗi được ghi rõ Blocked, không tính Pass. Các ca P1 chưa chạy được liệt kê khi báo cáo.
- Không khẳng định giao email thành công chỉ từ status request; không khẳng định đã kiểm server expiry/rate limit bằng bộ đếm UI.
- Checklist không thay đổi cấu hình hay API, không tạo harness và không thực thi gửi email trong lúc soạn tài liệu.

Nguồn nội bộ đã đọc:

- [Auth configuration](../../apps/api/src/iam/auth/auth.config.ts): 6 số, 300 giây, 3 lần thử.
- [Auth service](../../apps/api/src/iam/auth/auth.service.ts): register/request dùng chung sign-in OTP; che lỗi giao email; kiểm trạng thái Passenger trước cấp phiên.
- [OTP rate limiter](../../apps/api/src/iam/auth/otp-rate-limiter.ts), [constants](../../apps/api/src/iam/auth/auth.constants.ts): cooldown, giới hạn theo email và cửa sổ thời gian.
- [Auth controller](../../apps/api/src/iam/auth/auth.controller.ts), [errors](../../apps/api/src/iam/auth/auth.errors.ts): endpoint và phản hồi nghiệp vụ.
- [Resend adapter](../../apps/api/src/external/notification/resend-email-notifier.ts), [dev fallback](../../apps/api/src/external/notification/console-email-notifier.ts): giao thư thực tế và trường hợp không có kênh gửi.
- [Web auth actions](../../apps/marketplace/lib/data/auth.ts), [session cookies](../../apps/marketplace/lib/data/session.ts): xác minh phía server, lưu cookie.
- [Login UI](../../apps/marketplace/components/auth/login-view.tsx), [Register UI](../../apps/marketplace/components/auth/register-view.tsx), [Verify UI](../../apps/marketplace/components/auth/verify-email-view.tsx), [Verify route](../../apps/marketplace/app/verify-email/page.tsx): thao tác và điều hướng thực tế.
