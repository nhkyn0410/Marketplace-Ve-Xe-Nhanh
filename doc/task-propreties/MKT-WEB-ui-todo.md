# Tiến độ dựng giao diện Marketplace Web (apps/marketplace)

> File theo dõi tiến độ dựng giao diện theo `doc/task-propreties/MKT-WEB-ui-agent-prompts.md`.
> Cập nhật tự động sau mỗi khung / lô.

## 1. Bảng màn hình theo lô

| Lô | Mã màn | Khung Figma (node) | Route | Trạng thái đã dựng | Ảnh 1440 khớp | Đủ 7 viewport | Ghi chú |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 0 | Khung trang | `776:791`; kit `1436:12785`, `1434:11609` | `app/layout.tsx` | Guest, User (`?as=user`) | ✅ | ✅ | Bỏ "Dịch vụ bổ trợ" per A3 #7; footer ẩn khi ở trang lỗi |
| 0 | SCR-PSG-05 | `1449:21608` | `app/not-found.tsx` (`/?preview=404`) | Lỗi 404 | ✅ | ✅ | Khớp Figma 100% |
| 0 | SCR-PSG-05 | `1449:21863` | `app/error.tsx` (`/?preview=500`) | Lỗi 500 | ✅ | ✅ | Có mã tham chiếu & nút sao chép |
| 0 | SCR-PSG-05 | `1449:21736` | Component `ForbiddenState` (`/?preview=403`) | Lỗi 403 | ✅ | ✅ | Khớp Figma 100% |
| 0 | SCR-PSG-05 | `1449:21999` | Component `ServiceUnavailableState` (`/?preview=503`) | Lỗi 503 | ✅ | ✅ | Có đồng hồ đếm ngược tự thử lại |
| 1 | SCR-PSG-01 | `776:791` | `app/page.tsx` (`/?preview=ideal`) | Trang chủ đầy đủ (ideal) | ✅ | ✅ | Hero banner, Tuyến phổ biến, Khám phá, Nhà xe, Plus & Cẩm nang |
| 1 | SCR-PSG-01 | `836:113` | `app/page.tsx` (`/?preview=operator-tab`) | Tab Theo nhà xe (operator-tab) | ✅ | ✅ | Chuyển tab tìm kiếm Theo nhà xe |
| 1 | SCR-PSG-01 | `837:131` | `app/page.tsx` (`/?preview=operator-picker`) | Popover chọn nhà xe (operator-picker) | ✅ | ✅ | Card danh sách 5 nhà xe nổi bật kèm đánh giá & số chuyến |
| 2 | SCR-PSG-15 | `1440:11297` | `app/trips/page.tsx` (`/trips?preview=ideal`) | Kết quả tìm chuyến (ideal) | ✅ | ✅ | Đủ 4 chuyến, 9 bộ lọc, sort tabs, responsive 7 viewport |
| 2 | SCR-PSG-15 | `1450:22017` | `app/trips/page.tsx` (`/trips?preview=empty`) | Không tìm thấy chuyến (empty) | ✅ | ✅ | Gợi ý 2 ngày gần nhất & 3 tuyến thay thế |
| 2 | SCR-PSG-15 | `1450:22373` | `app/trips/page.tsx` (`/trips?preview=loading`) | Đang tải danh sách (loading) | ✅ | ✅ | Skeleton loading khớp Figma |
| 2 | SCR-PSG-16 | `1443:11643` | `app/trips/[tripId]/page.tsx` (`/trips/trip-pn-01?preview=ideal`) | Chi tiết chuyến xe (ideal) | ✅ | ✅ | Header, Thông tin xe, Lịch trình, Bản đồ, Sơ đồ chỗ, Giá & chính sách, Đánh giá, Sticky card |
| 2 | SCR-PSG-17 | `1443:12312` | `app/operators/[operatorId]/page.tsx` (`/operators/opr-phuongnam?preview=ideal`) | Trang nhà xe (ideal) | ✅ | ✅ | Header đối tác xác minh, 4 chỉ số chất lượng, Tuyến tiêu biểu, Đánh giá & Điều khoản |
| 3 | SCR-PSG-18 | `1443:12719` | `app/trips/[tripId]/seats/page.tsx` (`/trips/trip-pn-01/seats?preview=ideal`) | B1 Chọn điểm & Chỗ (ideal) | ✅ | ✅ | Stepper 4 bước, đếm ngược giữ chỗ, chọn điểm đón/trả, sơ đồ 2 tầng, tóm tắt chuyến |
| 3 | SCR-PSG-18 | `1450:22717` | `app/trips/[tripId]/seats/page.tsx` (`/trips/trip-pn-01/seats?preview=error`) | Lỗi chỗ vừa bị giữ (error) | ✅ | ✅ | Modal cảnh báo xung đột giữ chỗ A4 kèm nút chọn lại chỗ hoặc đổi chuyến |
| 3 | SCR-PSG-19 | `1444:12531` | `app/checkout/[holdId]/page.tsx` (`/checkout/hold-pn-789?preview=ideal`) | B2 Thông tin hành khách (ideal) | ✅ | ✅ | Thông tin liên hệ, danh sách hành khách, điểm đón/trả, ghi chú, ví voucher, tóm tắt thanh toán |
| 3 | SCR-PSG-19 | `1450:22911` | `app/checkout/[holdId]/page.tsx` (`/checkout/hold-pn-789?preview=stale`) | Cảnh báo giá vé đổi (stale) | ✅ | ✅ | Modal đối chiếu giá vé cũ/mới, voucher đổi điểm và tổng thanh toán mới |
| 3 | SCR-PSG-20 | `1444:13055` | `app/bookings/[bookingId]/payment/page.tsx` (`/bookings/book-pn-8f3k2q/payment?preview=ideal`) | B3 Thanh toán (ideal) | ✅ | ✅ | Cổng VNPay & MoMo, chọn nhanh ngân hàng, tóm tắt đơn, điều khoản, tổng thanh toán, an toàn |
| 3 | SCR-PSG-20 | `1450:23099` | `app/bookings/[bookingId]/payment/page.tsx` (`/bookings/book-pn-8f3k2q/payment?preview=expired`) | Hết hạn giữ chỗ (expired) | ✅ | ✅ | Modal cảnh báo hết hạn giữ ghế 00:00, voucher hoàn về ví, nút tìm chuyến hoặc chọn lại chỗ |
| 4 | SCR-PSG-21/22/23 | `1444:13464`, `1444:13772`, `1444:14189` | `app/bookings/[bookingId]/payment/result/page.tsx` (`.../result?preview=processing|success|failed`) | Chờ xác nhận, Thành công, Thất bại | ✅ | ✅ | Đủ 3 trạng thái: Spinner + đếm 5s, Vé điện tử QR + 2 cột thanh toán, Báo lỗi cổng + giữ chỗ còn lại |
| 4 | SCR-PSG-24 | `1445:14030`, `1450:23264` | `app/my-tickets/page.tsx` (`/my-tickets?preview=ideal|empty`) | Vé của tôi (ideal, empty) | ✅ | ✅ | Thẻ chuyến gần nhất nổi bật, danh sách vé hợp lệ/chờ thanh toán có đếm ngược, trạng thái rỗng, banner tra cứu |
| 4 | SCR-PSG-25 | `1445:14456` | `app/my-tickets/[ticketId]/page.tsx` (`/my-tickets/ticket-vxn-8f3k2q?preview=ideal`) | Chi tiết vé (ideal) | ✅ | ✅ | Boarding pass răng cưa, tab chuyển vé, mã QR, timeline đón trả, bản đồ Goong vector, quy định, thanh toán, mốc hoàn tiền, CSKH |
| 4 | SCR-PSG-26 | `1456:23988` | `app/my-tickets/[ticketId]/page.tsx` (`/my-tickets/ticket-vxn-8f3k2q?preview=cancel`) | Hộp thoại Hủy vé (cancel) | ✅ | ✅ | Modal chọn vé hủy, bảng tiền hoàn dự kiến, lý do, cảnh báo voucher, nút hủy báo lỗi tại chỗ kèm console.warn |
| 5 | SCR-PSG-27/28 | `1446:14982`, `1446:15277` | `app/tickets/lookup/page.tsx` (`/tickets/lookup?preview=ideal|otp`) | Tra cứu vé B1, B2 (OTP) | ✅ | ✅ | Đủ 2 bước: Form nhập mã + email bảo mật, Form 6 ô OTP đếm ngược 04:32, Khối hướng dẫn 3 bước |
| 5 | SCR-PSG-29 | `1446:15578` | `app/tickets/lookup/result/page.tsx` (`/tickets/lookup/result?preview=ideal`) | Kết quả tra cứu vé khách vãng lai (ideal) | ✅ | ✅ | Banner đếm ngược phiên 15p, danh sách thẻ vé có QR, điểm đón/trả, thanh toán & thao tác đơn |
| 5 | SCR-PSG-30/31 | `1446:16033`, `1446:16390` | `app/support/page.tsx` (`/support?preview=ideal|complaint`) | Khiếu nại của tôi & Hộp thoại gửi khiếu nại (ideal, complaint) | ✅ | ✅ | Tabs khiếu nại, stepper 5 bước, timeline trao đổi kèm tệp, form modal gửi khiếu nại |
| 5 | SCR-PSG-32 | `1446:16579` | `app/support/guest/page.tsx` (`/support/guest?preview=ideal`) | Khiếu nại của Guest (ideal) | ✅ | ✅ | Phiên bảo mật, chỉ xem đơn đã xác minh, gửi khiếu nại và trao đổi phản hồi |
| 6 | SCR-PSG-07 | `1447:16634` | `app/login/page.tsx` (`/login?preview=ideal`) | Đăng nhập tài khoản (ideal) | ✅ | ✅ | Modal Chào mừng trở lại, nhập email gửi OTP, 3 nút MXH Google/FB/Apple, link tạo TK và tra cứu |
| 6 | SCR-PSG-08 | `1447:17057` | `app/register/page.tsx` (`/register?preview=ideal`) | Tạo tài khoản (ideal) | ✅ | ✅ | Modal Tạo tài khoản, Họ tên, Email, SĐT, Checkbox điều khoản, nút tạo gửi mã, 3 nút OAuth |
| 6 | SCR-PSG-09 | `1447:17487` | `app/verify-email/page.tsx` (`/verify-email?preview=ideal`) | Nhập OTP xác thực email (ideal) | ✅ | ✅ | Modal Nhập mã xác minh, 6 ô số OTP, đếm ngược hạn mã, số lần thử, nút xác minh & gửi lại mã |
| 6 | SCR-PSG-10 | `1447:17897` | `app/auth/callback/page.tsx` (`/auth/callback?preview=ideal`) | OAuth callback (ideal) | ✅ | ✅ | Modal Xác thực thành công Google/FB/Apple, thông báo liên kết tài khoản có sẵn, spinner chuyển trang, nút Tiếp tục |
| 6 | SCR-PSG-11 | `1447:18295` | `app/account/page.tsx` (`/account?preview=ideal`) | Tài khoản của tôi / Hồ sơ (ideal) | ✅ | ✅ | Bố cục 2 cột, menu sidebar tài khoản, hồ sơ cá nhân, banner VXN Plus, sổ 3 hành khách đã lưu, bảo mật & đăng nhập |
| 6 | SCR-PSG-12 | `1447:18811` | `app/account/notifications/page.tsx` (`/account/notifications?preview=ideal`) | Cài đặt thông báo (ideal) | ✅ | ✅ | Bảng cài đặt thông báo, nhóm Bắt buộc (5 mục, lock toggle), nhóm Tùy chọn (5 mục, interactive toggle), nút lưu và khôi phục |
| 6 | SCR-PSG-13 | `1448:18809` | `app/account/sessions/page.tsx` (`/account/sessions?preview=ideal`) | Phiên đăng nhập & Thiết bị (ideal) | ✅ | ✅ | Danh sách thiết bị đăng nhập, badge phiên hiện tại, nút thu hồi phiên, nút đăng xuất tất cả phiên khác, ghi chú bảo mật |
| 6 | SCR-PSG-14 | `1448:19193` | `app/account/reviews/page.tsx` (`/account/reviews?preview=ideal`) | Đánh giá của tôi + form (ideal) | ✅ | ✅ | Khối Chờ đánh giá kèm form chấm sao và textarea nhận xét, khối Đã đánh giá kèm badge trạng thái duyệt và nút sửa |
| 7 | SCR-PSG-33/35 | `1448:19617`, `1448:20406` | `app/plus/page.tsx` (`/plus?preview=ideal|redeem`) | VXN Plus & Modal đổi điểm (ideal, redeem) | ✅ | ✅ | Banner thẻ thành viên Bạc, thanh tiến trình thăng hạng, điểm khả dụng, bảng 4 hạng thành viên, 3 khối quyền lợi, modal đổi điểm lấy voucher với slider & các mốc nhanh |
| 7 | SCR-PSG-34 | `1448:19985` | `app/plus/history/page.tsx` (`/plus/history?preview=ideal`) | Lịch sử điểm (ideal) | ✅ | ✅ | Bố cục 2 cột sidebar tài khoản, 4 card thống kê điểm, tabs bộ lọc loại biến động, dropdown thời gian, bảng lịch sử 4 cột kèm phân trang |
| 7 | SCR-PSG-36 | `1448:20565` | `app/account/vouchers/page.tsx` (`/account/vouchers?preview=ideal`) | Ví voucher (ideal) | ✅ | ✅ | Bố cục 2 cột sidebar tài khoản, khối lưu mã khuyến mãi vào ví kèm xử lý lỗi tại chỗ, tabs lọc Khả dụng / Đã dùng / Hết hạn, danh sách 4 voucher kèm badge trạng thái & link dùng ngay |
| 8 | SCR-PSG-02 | `1449:20595` | `app/explore/page.tsx` (`/explore?preview=ideal`) | Khám phá (ideal) | ✅ | ✅ | Header tìm kiếm, 5 tabs chuyên mục, bài viết Hero nổi bật có badge, lưới 6 bài viết cẩm nang kèm metadata và nút xem thêm |
| 8 | SCR-PSG-37 | `1449:20924` | `app/explore/[slug]/page.tsx` (`/explore/da-lat-mua-da-quy?preview=ideal`) | Chi tiết bài viết cẩm nang (ideal) | ✅ | ✅ | Breadcrumb, nhãn chuyên mục, metadata, ảnh bìa, các phần nội dung kèm bullet points xanh, card tuyến xe liên quan, sidebar cùng chuyên mục có thumbnail và bảng đếm |
| 8 | SCR-PSG-03 | `1449:21249` | `app/faq/page.tsx` (`/faq?preview=ideal`) | Câu hỏi thường gặp FAQ (ideal) | ✅ | ✅ | Hero banner tìm kiếm câu hỏi có gợi ý nhanh, 6 chuyên mục, danh sách câu hỏi dạng Accordion, khối CSKH trợ giúp chân trang |
| 8 | SCR-PSG-06 | `1449:22136` | `app/legal/[slug]/page.tsx` (`/legal/terms-of-service?preview=ideal`) | Trang pháp lý & Điều khoản (ideal) | ✅ | ✅ | 3 tabs chuyển đổi văn bản pháp lý, cột mục lục cuộn mượt sticky, box cảnh báo lưu ý, 8 điều khoản với tiêu đề và nội dung đầy đủ |

## 2. Sổ lệch Figma

| # | Khung (node) | Figma | Đã làm | Lý do (dòng A3 / kỹ thuật) |
| --- | --- | --- | --- | --- |
| 1 | Khung trang (`1436:12785`) | Có mục "Dịch vụ bổ trợ" | Bỏ hoàn toàn khỏi thanh điều hướng chính | Dòng A3 #7: SRS không có, UX-OQ-07 còn mở |
| 2 | Khung trang (`1434:11609`) | Link "Hủy vé và hoàn tiền" | Trỏ về `/refund-policy` | Dòng A3 #6: Chưa có đổi vé tự phục vụ |
| 3 | Khung trang (`1436:12785`) | Đăng nhập trên thanh bên | Trỏ về `/login` thay vì mở popup số điện thoại `830:1321` | Dòng A3 #1: Hành khách đăng nhập email OTP hoặc OAuth |
| 4 | Khung trang (`1434:11609`) | Link footer "Quản trị hệ thống", "Đăng nhập nhà xe" | Trỏ về cổng dev tương ứng (`:3002`, `:3003`) | Phục vụ điều hướng môi trường phát triển monorepo |
| 5 | SCR-PSG-01 (`776:791`) | Dữ liệu tuyến xe, nhà xe, cẩm nang | Dùng fixture khi `?preview=`; hiện `FeatureUnavailableCompact` kèm log cảnh báo khi không có preview | Dòng A5 & Bảng A2: Chưa có API backend cho các mục này |
| 6 | SCR-PSG-01 (`776:791`) | Nút "Tìm chuyến" | Hiển thị thông báo lỗi tại chỗ và `console.warn` | Dòng A5: Không chuyển trang, không giả lập thành công khi chưa có API |
| 7 | SCR-PSG-15 (`1440:11297`) | Nút "Tìm chuyến" thanh tìm kiếm đầu trang | Hiển thị thông báo lỗi tại chỗ khi bấm tìm kiếm | Dòng A5: Chưa có API backend tìm chuyến thực tế |
| 8 | SCR-PSG-16 (`1443:11643`) | Bản đồ lộ trình Goong | Hiển thị vector minh họa chuẩn Figma kèm nhãn "Bản đồ tạm thời không khả dụng" khi chưa có key | Dòng A3 #4: Chỉ dùng MapView khi có key Goong, không dùng thư viện ngoài |
| 9 | SCR-PSG-16 (`1443:11643`) | Nút "Chọn ghế" thanh bên | Hiển thị thông báo lỗi tại chỗ, không chuyển trang | Dòng A5: Chưa có API giữ chỗ trực tuyến |
| 10 | SCR-PSG-17 (`1443:12312`) | Nút "Tìm chuyến của nhà xe" | Chuyển hướng có bộ lọc `/trips?operator=opr-phuongnam` | Hỗ trợ tìm chuyến theo nhà xe |
| 11 | SCR-PSG-18 (`1443:12719`) | Nút "Tiếp tục" giữ chỗ | Hiển thị thông báo lỗi tại chỗ và `console.warn` | Dòng A5 & Bảng A2: Chưa có API POST /seat-holds |
| 12 | SCR-PSG-18 (`1443:12719`) | Đồng hồ đếm ngược giữ chỗ | Đếm theo thời gian trong dữ liệu, không viết cứng | Dòng A3 #3: Giữ chỗ 10 phút đếm theo timestamp/dữ liệu |
| 13 | SCR-PSG-19 (`1444:12531`) | Nút "Tiếp tục thanh toán" | Hiển thị thông báo lỗi tại chỗ và `console.warn` | Dòng A5 & Bảng A2: Chưa có API POST /bookings |
| 14 | SCR-PSG-19 (`1444:12531`) | Bảng giá và phí dịch vụ | Không tự tính tiền, hiển thị đúng dữ liệu trả về | Dòng A3 #8: Giao diện không tự tính tiền |
| 15 | SCR-PSG-20 (`1444:13055`) | Cổng thanh toán | Chỉ hỗ trợ VNPay và MoMo (không có tiền mặt / ZaloPay) | Dòng A3 #2 & ADR-011: Vendor thanh toán được chốt |
| 16 | SCR-PSG-20 (`1444:13055`) | Nút "Thanh toán ..." | Hiển thị cảnh báo lỗi tại chỗ và `console.warn` | Dòng A5 & Bảng A2: Chưa có API POST /bookings/{bookingId}/payments |
| 17 | SCR-PSG-25 (`1445:14456`) | Nút "In vé" & "Chia sẻ" | In vé gọi `window.print()`, Chia sẻ sao chép link vé | Tính năng hỗ trợ hành khách xem vé trực tiếp |
| 18 | SCR-PSG-25 (`1445:14456`) | Bản đồ điểm đón Goong | Dùng vector bản đồ Goong minh họa điểm Bến xe Miền Đông mới | Dòng A3 #4: Bản đồ dùng vector mô phỏng / Goong vector |
| 19 | SCR-PSG-26 (`1456:23988`) | Nút "Tiếp tục hủy vé" | Hiển thị lỗi tại chỗ trong modal và gọi `cancelTickets` ghi log console.warn | Dòng A3 #6: Chưa có API hủy vé POST /bookings/{bookingId}/cancel |
| 20 | SCR-PSG-27/28 (`1446:14982`, `1446:15277`) | Nút "Gửi mã xác minh" & "Xác minh" | Hiển thị lỗi tại chỗ và gọi `requestTicketLookupOtp`/`verifyTicketLookupOtp` ghi log console.warn | Dòng A3 #6: Chưa có API tra cứu vé và xác minh OTP |
| 21 | SCR-PSG-29 (`1446:15578`) | Thao tác hủy vé và gửi khiếu nại | Mở hộp thoại thông báo hướng dẫn, hỗ trợ phóng to mã QR và in vé | Dòng A3 #6: Chưa có API GET /guest/ticket-lookup/{token} |
| 22 | SCR-PSG-30/31 (`1446:16033`, `1446:16390`) | Nút "Gửi khiếu nại" & "Gửi phản hồi" | Hiển thị thông báo lỗi tại chỗ và gọi `submitComplaint` / `replyComplaint` ghi log console.warn | Dòng A5 & Bảng A2: Chưa có API POST /me/complaints và POST /me/complaints/{id}/messages |
| 23 | SCR-PSG-32 (`1446:16579`) | Nút "Gửi khiếu nại về đơn này" | Mở hộp thoại gửi khiếu nại với đơn hàng đã chọn sẵn, gọi `submitGuestComplaint` ghi log console.warn | Dòng A5 & Bảng A2: Chưa có API GET /guest/complaints và POST /guest/complaints |
| 24 | SCR-PSG-07 (`1447:16634`) | Nút "Tiếp tục với email" & đăng nhập MXH | Hiển thị thông báo lỗi tại chỗ và gọi `requestLoginOtp` ghi log console.warn khi không có preview | Dòng A5 & Bảng A2: Chưa có API POST /auth/otp/send và luồng OAuth |
| 25 | SCR-PSG-08 (`1447:17057`) | Nút "Tạo tài khoản và gửi mã" & đăng ký MXH | Hiển thị thông báo lỗi tại chỗ và gọi `registerAccount` ghi log console.warn khi không có preview | Dòng A5 & Bảng A2: Chưa có API POST /auth/register và luồng OAuth |
| 26 | SCR-PSG-09 (`1447:17487`) | Nút "Xác minh" & gửi lại mã | Hiển thị thông báo lỗi tại chỗ và gọi `verifyOtp` ghi log console.warn khi không có preview | Dòng A5 & Bảng A2: Chưa có API POST /auth/otp/verify |
| 27 | SCR-PSG-10 (`1447:17897`) | Xác thực OAuth callback | Ghi log console.warn khi không có preview và hỗ trợ bấm nút Tiếp tục ngay để chuyển trang | Dòng A5 & Bảng A2: Chưa có luồng trao đổi session OAuth backend |
| 28 | SCR-PSG-11 (`1447:18295`) | Chỉnh sửa hồ sơ, thêm/xóa hành khách | Các nút thao tác hiển thị thông báo phản hồi tại chỗ kèm hướng dẫn | Dòng A5: Chưa có API chỉnh sửa hồ sơ và quản lý sổ hành khách |
| 29 | SCR-PSG-12 (`1447:18811`) | Nút "Lưu thay đổi" & "Khôi phục mặc định" | Hiển thị thông báo phản hồi tại chỗ và gọi `updateNotificationSettings` ghi log console.warn khi không có preview | Dòng A5 & Bảng A2: Chưa có API PUT /me/notification-preferences |
| 30 | SCR-PSG-13 (`1448:18809`) | Nút "Thu hồi" & "Đăng xuất tất cả phiên khác" | Hiển thị thông báo phản hồi tại chỗ và gọi `revokeSession` / `revokeAllOtherSessions` ghi log console.warn khi không có preview | Dòng A5 & Bảng A2: Chưa có API DELETE /me/sessions/{id} và POST /me/sessions/revoke-others |
| 31 | SCR-PSG-14 (`1448:19193`) | Nút "Gửi đánh giá" & "Sửa đánh giá" | Hiển thị thông báo phản hồi tại chỗ và gọi `submitReview` / `updateReview` ghi log console.warn khi không có preview | Dòng A5 & Bảng A2: Chưa có API POST /me/reviews và PUT /me/reviews/{id} |
| 32 | SCR-PSG-35 (`1448:20406`) | Nút "Xác nhận đổi điểm" | Hiển thị thông báo phản hồi lỗi tại chỗ và gọi `redeemLoyaltyPoints` ghi log console.warn khi không có preview | Dòng A5 & Bảng A2: Chưa có API POST /me/loyalty/redemptions |
| 33 | SCR-PSG-36 (`1448:20565`) | Nút "Lưu vào ví" | Hiển thị thông báo phản hồi lỗi tại chỗ và gọi `saveVoucherCode` ghi log console.warn khi không có preview | Dòng A5 & Bảng A2: Chưa có API POST /me/vouchers |

## 3. API còn thiếu

| Endpoint | Màn dùng | Hành vi hiện tại |
| --- | --- | --- |
| `GET /catalog/popular-routes` | SCR-PSG-01 | Trả `unavailable()`, giao diện hiện `FeatureUnavailableCompact` kèm console.warn |
| `GET /catalog/featured-operators` | SCR-PSG-01 | Trả `unavailable()`, giao diện hiện `FeatureUnavailableCompact` kèm console.warn |
| `GET /content/articles?tag=handbook` | SCR-PSG-01 | Trả `unavailable()`, giao diện hiện `FeatureUnavailableCompact` kèm console.warn |
| `GET /content/banners?placement=home_plus` | SCR-PSG-01 | Trả `unavailable()` |
| `GET /catalog/trips` | SCR-PSG-01 | Chưa có API; form tìm kiếm hiện cảnh báo lỗi tại chỗ, không chuyển trang |
| `GET /trips/search` | SCR-PSG-15 | Trả `unavailable()`, route `/trips` hiện `FeatureUnavailable` kèm console.warn |
| `GET /trips/{tripId}` | SCR-PSG-16 | Trả `unavailable()`, route `/trips/[tripId]` hiện `FeatureUnavailable` kèm console.warn |
| `GET /operators/{operatorId}` | SCR-PSG-17 | Trả `unavailable()`, route `/operators/[operatorId]` hiện `FeatureUnavailable` kèm console.warn |
| `GET /trips/{tripId}/seats` | SCR-PSG-18 | Trả `unavailable()`, route `/trips/[tripId]/seats` hiện `FeatureUnavailable` kèm console.warn |
| `POST /seat-holds` | SCR-PSG-18 | Trả `unavailable()`, nút "Tiếp tục" hiện cảnh báo lỗi tại chỗ kèm console.warn |
| `GET /seat-holds/{holdId}` | SCR-PSG-19 | Trả `unavailable()`, route `/checkout/[holdId]` hiện `FeatureUnavailable` kèm console.warn |
| `POST /bookings` | SCR-PSG-19 | Trả `unavailable()`, nút "Tiếp tục thanh toán" hiện cảnh báo lỗi tại chỗ kèm console.warn |
| `GET /bookings/{bookingId}` | SCR-PSG-20 | Trả `unavailable()`, route `/bookings/[bookingId]/payment` hiện `FeatureUnavailable` kèm console.warn |
| `POST /bookings/{bookingId}/payments` | SCR-PSG-20 | Trả `unavailable()`, nút "Thanh toán" hiện cảnh báo lỗi tại chỗ kèm console.warn |
| `GET /bookings/{bookingId}/payment-result` | SCR-PSG-21..23 | Trả `unavailable()`, route `/bookings/[bookingId]/payment/result` hiện `FeatureUnavailable` kèm console.warn |
| `GET /me/tickets` | SCR-PSG-24 | Trả `unavailable()`, route `/my-tickets` hiện `FeatureUnavailable` kèm console.warn |
| `GET /tickets/{ticketId}` | SCR-PSG-25 | Trả `unavailable()`, route `/my-tickets/[ticketId]` hiện `FeatureUnavailable` kèm console.warn |
| `POST /bookings/{bookingId}/cancel` | SCR-PSG-26 | Trả `unavailable()`, nút "Tiếp tục hủy vé" hiện cảnh báo lỗi tại chỗ kèm console.warn |
| `POST /guest/ticket-lookup` | SCR-PSG-27 | Trả `unavailable()`, nút "Gửi mã xác minh" hiện cảnh báo lỗi tại chỗ kèm console.warn |
| `POST /guest/ticket-lookup/verify` | SCR-PSG-28 | Trả `unavailable()`, nút "Xác minh" hiện cảnh báo lỗi tại chỗ kèm console.warn |
| `GET /guest/ticket-lookup/{token}` | SCR-PSG-29 | Trả `unavailable()`, route `/tickets/lookup/result` hiện `FeatureUnavailable` kèm console.warn |
| `GET /me/complaints` | SCR-PSG-30 | Trả `unavailable()`, route `/support` hiện `FeatureUnavailable` kèm console.warn |
| `POST /me/complaints` | SCR-PSG-31 | Trả `unavailable()`, modal gửi khiếu nại hiện cảnh báo lỗi tại chỗ kèm console.warn |
| `POST /me/complaints/{id}/messages` | SCR-PSG-30 | Trả `unavailable()`, form gửi phản hồi hiện cảnh báo lỗi tại chỗ kèm console.warn |
| `GET /guest/complaints` | SCR-PSG-32 | Trả `unavailable()`, route `/support/guest` hiện `FeatureUnavailable` kèm console.warn |
| `POST /guest/complaints` | SCR-PSG-32 | Trả `unavailable()`, submit khiếu nại khách vãng lai hiện cảnh báo lỗi tại chỗ kèm console.warn |
| `POST /auth/otp/send` | SCR-PSG-07 | Trả `unavailable()`, form đăng nhập hiện cảnh báo lỗi tại chỗ kèm console.warn |
| `POST /auth/register` | SCR-PSG-08 | Trả `unavailable()`, form tạo tài khoản hiện cảnh báo lỗi tại chỗ kèm console.warn |
| `POST /auth/otp/verify` | SCR-PSG-09 | Trả `unavailable()`, form xác minh OTP hiện cảnh báo lỗi tại chỗ kèm console.warn |
| `GET /me/profile` | SCR-PSG-11 | Trả `unavailable()`, route `/account` hiện `FeatureUnavailable` kèm console.warn |
| `GET /me/notification-preferences` | SCR-PSG-12 | Trả `unavailable()`, route `/account/notifications` hiện `FeatureUnavailable` kèm console.warn |
| `PUT /me/notification-preferences` | SCR-PSG-12 | Trả `unavailable()`, nút "Lưu thay đổi" hiện cảnh báo lỗi tại chỗ kèm console.warn |
| `GET /me/sessions` | SCR-PSG-13 | Trả `unavailable()`, route `/account/sessions` hiện `FeatureUnavailable` kèm console.warn |
| `DELETE /me/sessions/{sessionId}` | SCR-PSG-13 | Trả `unavailable()`, nút "Thu hồi" hiện cảnh báo lỗi tại chỗ kèm console.warn |
| `POST /me/sessions/revoke-others` | SCR-PSG-13 | Trả `unavailable()`, nút "Đăng xuất tất cả phiên khác" hiện cảnh báo lỗi tại chỗ kèm console.warn |
| `GET /me/reviews` | SCR-PSG-14 | Trả `unavailable()`, route `/account/reviews` hiện `FeatureUnavailable` kèm console.warn |
| `POST /me/reviews` | SCR-PSG-14 | Trả `unavailable()`, form gửi đánh giá hiện cảnh báo lỗi tại chỗ kèm console.warn |
| `GET /me/loyalty` | SCR-PSG-33 | Trả `unavailable()`, route `/plus` hiện `FeatureUnavailable` kèm console.warn |
| `POST /me/loyalty/redemptions` | SCR-PSG-35 | Trả `unavailable()`, modal đổi điểm hiện cảnh báo lỗi tại chỗ kèm console.warn |
| `GET /me/loyalty/transactions` | SCR-PSG-34 | Trả `unavailable()`, route `/plus/history` hiện `FeatureUnavailable` kèm console.warn |
| `GET /me/vouchers` | SCR-PSG-36 | Trả `unavailable()`, route `/account/vouchers` hiện `FeatureUnavailable` kèm console.warn |
| `POST /me/vouchers` | SCR-PSG-36 | Trả `unavailable()`, nút "Lưu vào ví" hiện cảnh báo lỗi tại chỗ kèm console.warn |
| `GET /articles` | SCR-PSG-02 | Trả `unavailable()`, route `/explore` hiện `FeatureUnavailable` kèm console.warn |
| `GET /article-categories` | SCR-PSG-02 | Trả `unavailable()`, tabs chuyên mục khám phá |
| `GET /articles/{slug}` | SCR-PSG-37 | Trả `unavailable()`, route `/explore/[slug]` hiện `FeatureUnavailable` kèm console.warn |
| `GET /content/faq` | SCR-PSG-03 | Trả `unavailable()`, route `/faq` hiện `FeatureUnavailable` kèm console.warn |
| `GET /content/legal/{slug}` | SCR-PSG-06 | Trả `unavailable()`, route `/legal/[slug]` hiện `FeatureUnavailable` kèm console.warn |

## 4. Tình trạng kiểm thử & Review

- **Tình trạng:** Chưa qua `code-reviewer` / `security-auditor` — chỉ chạy khi Khanh yêu cầu.
- **Kiểm thử tự động:**
  - `pnpm --filter @vexenhanh/marketplace test`: 23/23 tests pass (formatVnd, getPreview, DataResult helpers, tickets data service + lookup, support service).
  - `pnpm --filter @vexenhanh/marketplace typecheck`: pass (tsc --noEmit không lỗi).
  - `pnpm --filter @vexenhanh/marketplace lint`: pass (ESLint 0 lỗi).
  - `pnpm --filter @vexenhanh/marketplace build`: pass (production build Turbopack thành công).

## 5. File đã tạo / sửa

- `apps/marketplace/package.json`
- `pnpm-lock.yaml`
- `apps/marketplace/next.config.ts`
- `apps/marketplace/lib/data/result.ts`
- `apps/marketplace/lib/data/result.test.ts`
- `apps/marketplace/lib/data/types.ts`
- `apps/marketplace/lib/data/catalog.ts`
- `apps/marketplace/lib/data/home.ts`
- `apps/marketplace/lib/data/trips.ts`
- `apps/marketplace/lib/data/operators.ts`
- `apps/marketplace/lib/data/booking.ts`
- `apps/marketplace/lib/data/tickets.ts`
- `apps/marketplace/lib/data/tickets.test.ts`
- `apps/marketplace/lib/data/support.test.ts`
- `apps/marketplace/lib/preview/index.ts`
- `apps/marketplace/lib/preview/index.test.ts`
- `apps/marketplace/lib/preview/fixtures/home.ts`
- `apps/marketplace/lib/preview/fixtures/trips.ts`
- `apps/marketplace/lib/preview/fixtures/operators.ts`
- `apps/marketplace/lib/preview/fixtures/booking.ts`
- `apps/marketplace/lib/preview/fixtures/tickets.ts`
- `apps/marketplace/lib/format/index.ts`
- `apps/marketplace/lib/format/index.test.ts`
- `apps/marketplace/components/passenger-topbar.tsx`
- `apps/marketplace/components/site-shell.tsx`
- `apps/marketplace/components/site-footer.tsx`
- `apps/marketplace/components/states/feature-unavailable.tsx`
- `apps/marketplace/components/states/error-state.tsx`
- `apps/marketplace/components/states/empty-state.tsx`
- `apps/marketplace/components/states/forbidden-state.tsx`
- `apps/marketplace/components/states/service-unavailable-state.tsx`
- `apps/marketplace/components/states/index.ts`
- `apps/marketplace/components/home/search-hero.tsx`
- `apps/marketplace/components/home/popular-routes.tsx`
- `apps/marketplace/components/home/explore-cards.tsx`
- `apps/marketplace/components/home/partner-operators.tsx`
- `apps/marketplace/components/home/plus-and-guide.tsx`
- `apps/marketplace/components/trips/trip-search-bar.tsx`
- `apps/marketplace/components/trips/trip-filters.tsx`
- `apps/marketplace/components/trips/trip-card.tsx`
- `apps/marketplace/components/trips/trip-list-header.tsx`
- `apps/marketplace/components/trips/trip-empty-state.tsx`
- `apps/marketplace/components/trips/trip-detail-header.tsx`
- `apps/marketplace/components/trips/trip-vehicle-info.tsx`
- `apps/marketplace/components/trips/trip-timeline-view.tsx`
- `apps/marketplace/components/trips/trip-map-preview.tsx`
- `apps/marketplace/components/trips/trip-seat-map-preview.tsx`
- `apps/marketplace/components/trips/trip-pricing-policy.tsx`
- `apps/marketplace/components/trips/trip-reviews-section.tsx`
- `apps/marketplace/components/trips/trip-sticky-booking-bar.tsx`
- `apps/marketplace/components/operators/operator-profile-header.tsx`
- `apps/marketplace/components/operators/operator-quality-metrics.tsx`
- `apps/marketplace/components/operators/operator-featured-routes.tsx`
- `apps/marketplace/components/operators/operator-terms-and-reviews.tsx`
- `apps/marketplace/components/seats/seat-selection-stepper.tsx`
- `apps/marketplace/components/seats/seat-selection-view.tsx`
- `apps/marketplace/components/seats/seat-conflict-modal.tsx`
- `apps/marketplace/components/checkout/checkout-contact-form.tsx`
- `apps/marketplace/components/checkout/checkout-passenger-list.tsx`
- `apps/marketplace/components/checkout/checkout-pickup-dropoff-summary.tsx`
- `apps/marketplace/components/checkout/checkout-voucher-section.tsx`
- `apps/marketplace/components/checkout/checkout-price-sidebar.tsx`
- `apps/marketplace/components/checkout/checkout-stale-modal.tsx`
- `apps/marketplace/components/checkout/checkout-view.tsx`
- `apps/marketplace/components/payment/payment-method-selector.tsx`
- `apps/marketplace/components/payment/payment-order-summary.tsx`
- `apps/marketplace/components/payment/payment-expired-modal.tsx`
- `apps/marketplace/components/payment/payment-view.tsx`
- `apps/marketplace/components/payment-result/payment-processing-card.tsx`
- `apps/marketplace/components/payment-result/payment-success-view.tsx`
- `apps/marketplace/components/payment-result/payment-failed-card.tsx`
- `apps/marketplace/components/payment-result/payment-result-view.tsx`
- `apps/marketplace/components/my-tickets/tickets-header.tsx`
- `apps/marketplace/components/my-tickets/tickets-filter-bar.tsx`
- `apps/marketplace/components/my-tickets/tickets-featured-card.tsx`
- `apps/marketplace/components/my-tickets/ticket-card-item.tsx`
- `apps/marketplace/components/my-tickets/tickets-empty-card.tsx`
- `apps/marketplace/components/my-tickets/guest-lookup-banner.tsx`
- `apps/marketplace/components/my-tickets/my-tickets-view.tsx`
- `apps/marketplace/components/ticket-detail/ticket-detail-header.tsx`
- `apps/marketplace/components/ticket-detail/boarding-pass-card.tsx`
- `apps/marketplace/components/ticket-detail/ticket-trip-itinerary.tsx`
- `apps/marketplace/components/ticket-detail/ticket-pickup-map.tsx`
- `apps/marketplace/components/ticket-detail/ticket-boarding-rules.tsx`
- `apps/marketplace/components/ticket-detail/ticket-payment-sidebar.tsx`
- `apps/marketplace/components/ticket-detail/ticket-cancel-dialog.tsx`
- `apps/marketplace/components/ticket-detail/ticket-detail-view.tsx`
- `apps/marketplace/components/tickets/lookup/lookup-instructions-card.tsx`
- `apps/marketplace/components/tickets/lookup/lookup-form-step.tsx`
- `apps/marketplace/components/tickets/lookup/lookup-otp-step.tsx`
- `apps/marketplace/components/tickets/lookup/lookup-view.tsx`
- `apps/marketplace/app/bookings/[bookingId]/payment/result/page.tsx`
- `apps/marketplace/app/my-tickets/page.tsx`
- `apps/marketplace/app/my-tickets/[ticketId]/page.tsx`
- `apps/marketplace/app/tickets/lookup/page.tsx`
- `apps/marketplace/components/trips/trip-loading-skeleton.tsx`
- `apps/marketplace/components/trips/detail/trip-detail-header.tsx`
- `apps/marketplace/components/trips/detail/trip-vehicle-info.tsx`
- `apps/marketplace/components/trips/detail/trip-itinerary.tsx`
- `apps/marketplace/components/trips/detail/trip-route-map.tsx`
- `apps/marketplace/components/trips/detail/trip-seat-preview.tsx`
- `apps/marketplace/components/trips/detail/trip-pricing-policy.tsx`
- `apps/marketplace/components/trips/detail/trip-reviews.tsx`
- `apps/marketplace/components/trips/detail/trip-booking-sidebar.tsx`
- `apps/marketplace/components/operators/operator-header.tsx`
- `apps/marketplace/components/operators/operator-metrics.tsx`
- `apps/marketplace/components/operators/operator-featured-routes.tsx`
- `apps/marketplace/components/operators/operator-reviews-and-terms.tsx`
- `apps/marketplace/app/not-found.tsx`
- `apps/marketplace/app/error.tsx`
- `apps/marketplace/app/page.tsx`
- `apps/marketplace/app/trips/page.tsx`
- `apps/marketplace/app/trips/[tripId]/page.tsx`
- `apps/marketplace/app/operators/[operatorId]/page.tsx`
- `apps/marketplace/app/trips/[tripId]/seats/page.tsx`
- `apps/marketplace/lib/data/booking.ts`
- `apps/marketplace/lib/preview/fixtures/booking.ts`
- `apps/marketplace/components/booking/checkout-stepper.tsx`
- `apps/marketplace/components/booking/seat-point-selector.tsx`
- `apps/marketplace/components/booking/seat-map.tsx`
- `apps/marketplace/components/booking/seat-selection-sidebar.tsx`
- `apps/marketplace/components/booking/seat-hold-conflict-modal.tsx`
- `apps/marketplace/components/booking/seat-selection-view.tsx`
- `apps/marketplace/app/checkout/[holdId]/page.tsx`
- `apps/marketplace/components/checkout/contact-info-form.tsx`
- `apps/marketplace/components/checkout/passenger-list-form.tsx`
- `apps/marketplace/components/checkout/trip-points-summary-card.tsx`
- `apps/marketplace/components/checkout/operator-note-box.tsx`
- `apps/marketplace/components/checkout/checkout-voucher-selector.tsx`
- `apps/marketplace/components/checkout/checkout-payment-sidebar.tsx`
- `apps/marketplace/components/checkout/checkout-stale-price-modal.tsx`
- `apps/marketplace/components/checkout/checkout-form-view.tsx`
- `apps/marketplace/components/payment/payment-method-selector.tsx`
- `apps/marketplace/components/payment/payment-order-summary-card.tsx`
- `apps/marketplace/components/payment/payment-terms-checkbox.tsx`
- `apps/marketplace/components/payment/payment-summary-sidebar.tsx`
- `apps/marketplace/components/payment/payment-expired-modal.tsx`
- `apps/marketplace/components/payment/payment-page-view.tsx`
- `apps/marketplace/app/bookings/[bookingId]/payment/page.tsx`
- `apps/marketplace/components/payment-result/payment-processing-card.tsx`
- `apps/marketplace/components/payment-result/payment-success-view.tsx`
- `apps/marketplace/components/payment-result/payment-failed-card.tsx`
- `apps/marketplace/components/payment-result/payment-result-view.tsx`
- `apps/marketplace/app/bookings/[bookingId]/payment/result/page.tsx`
- `apps/marketplace/lib/data/tickets.ts`
- `apps/marketplace/lib/preview/fixtures/tickets.ts`
- `apps/marketplace/components/my-tickets/tickets-header.tsx`
- `apps/marketplace/components/my-tickets/tickets-filter-bar.tsx`
- `apps/marketplace/components/my-tickets/tickets-featured-card.tsx`
- `apps/marketplace/components/my-tickets/ticket-card-item.tsx`
- `apps/marketplace/components/my-tickets/tickets-empty-card.tsx`
- `apps/marketplace/components/my-tickets/guest-lookup-banner.tsx`
- `apps/marketplace/components/my-tickets/my-tickets-view.tsx`
- `apps/marketplace/components/tickets/lookup-result/lookup-session-banner.tsx`
- `apps/marketplace/components/tickets/lookup-result/lookup-ticket-card.tsx`
- `apps/marketplace/components/tickets/lookup-result/lookup-pickup-dropoff.tsx`
- `apps/marketplace/components/tickets/lookup-result/lookup-actions-sidebar.tsx`
- `apps/marketplace/components/tickets/lookup-result/lookup-qr-modal.tsx`
- `apps/marketplace/components/tickets/lookup-result/lookup-result-view.tsx`
- `apps/marketplace/app/tickets/lookup/result/page.tsx`
- `apps/marketplace/lib/data/support.ts`
- `apps/marketplace/lib/preview/fixtures/support.ts`
- `apps/marketplace/components/support/complaint-list-sidebar.tsx`
- `apps/marketplace/components/support/complaint-detail-panel.tsx`
- `apps/marketplace/components/support/complaint-new-modal.tsx`
- `apps/marketplace/components/support/support-view.tsx`
- `apps/marketplace/app/support/page.tsx`
- `apps/marketplace/components/support/guest-support-view.tsx`
- `apps/marketplace/app/support/guest/page.tsx`
- `apps/marketplace/lib/data/auth.ts`
- `apps/marketplace/lib/preview/fixtures/auth.ts`
- `apps/marketplace/components/auth/login-view.tsx`
- `apps/marketplace/app/login/page.tsx`
- `apps/marketplace/components/auth/register-view.tsx`
- `apps/marketplace/app/register/page.tsx`
- `apps/marketplace/components/auth/verify-email-view.tsx`
- `apps/marketplace/app/verify-email/page.tsx`
- `apps/marketplace/components/auth/oauth-callback-view.tsx`
- `apps/marketplace/app/auth/callback/page.tsx`
- `apps/marketplace/components/account/account-sidebar.tsx`
- `apps/marketplace/components/account/account-profile-view.tsx`
- `apps/marketplace/app/account/page.tsx`
- `apps/marketplace/components/account/account-notifications-view.tsx`
- `apps/marketplace/app/account/notifications/page.tsx`
- `apps/marketplace/components/account/account-sessions-view.tsx`
- `apps/marketplace/app/account/sessions/page.tsx`
- `apps/marketplace/components/account/account-reviews-view.tsx`
- `apps/marketplace/app/account/reviews/page.tsx`
- `apps/marketplace/lib/data/loyalty.ts`
- `apps/marketplace/lib/preview/fixtures/loyalty.ts`
- `apps/marketplace/components/loyalty/loyalty-redeem-modal.tsx`
- `apps/marketplace/components/loyalty/loyalty-view.tsx`
- `apps/marketplace/app/plus/page.tsx`
- `apps/marketplace/components/loyalty/loyalty-history-view.tsx`
- `apps/marketplace/app/plus/history/page.tsx`
- `apps/marketplace/components/vouchers/vouchers-view.tsx`
- `apps/marketplace/app/account/vouchers/page.tsx`
- `apps/marketplace/lib/data/content.ts`
- `apps/marketplace/lib/preview/fixtures/content.ts`
- `apps/marketplace/components/explore/explore-view.tsx`
- `apps/marketplace/app/explore/page.tsx`
- `apps/marketplace/components/explore/article-detail-view.tsx`
- `apps/marketplace/app/explore/[slug]/page.tsx`
- `apps/marketplace/components/faq/faq-view.tsx`
- `apps/marketplace/app/faq/page.tsx`
- `apps/marketplace/components/legal/legal-view.tsx`
- `apps/marketplace/app/legal/[slug]/page.tsx`
- `doc/task-propreties/MKT-WEB-ui-todo.md`



