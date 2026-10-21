# Tích hợp API web khách hàng

Ngày: 21/10/2026. Branch: `marketplace-api-integration`.

## Git và phạm vi

- Tạo branch từ `origin/develop` (`99151f8`), gộp `origin/MKT-WEB-ui` (`10f26ef`); merge commit `3125a28`, không xung đột.
- Tên branch nguồn thực tế là `MKT-WEB-ui`, khác thứ tự chữ `MTK-WEB-ui` trong yêu cầu.
- Chỉ sửa web `apps/marketplace`, dependency/lockfile và báo cáo này. Không sửa backend, Prisma, Zod hợp đồng hoặc client được sinh.
- Phần nối API đang ở working tree, chưa commit/push. Merge commit được tạo bởi thao tác gộp branch đã yêu cầu.

## Các luồng đã nối

- Danh mục tỉnh/điểm dừng: đọc đúng envelope `{items}`.
- Tìm chuyến: form → query → `/trips/search`; ngày theo Việt Nam, số khách 1–10, lọc giờ/giá/dạng chỗ/hạng xe, sắp xếp và phân trang.
- Chi tiết chuyến/nhà xe: lịch trình, tiện ích, ảnh, trạng thái ghế, chính sách hủy và đánh giá từ dữ liệu công khai.
- OTP đăng nhập/đăng ký: Server Actions; Passenger vẫn dùng Bearer theo backend, token giữ trong cookie httpOnly riêng của web. Bootstrap/refresh/logout không đưa token vào localStorage, props hay URL.
- Hồ sơ, hành khách đã lưu, phiên đăng nhập, tùy chọn thông báo và đánh giá theo booking.
- Chọn điểm/ghế → giữ chỗ → thông tin hành khách → tạo booking → VNPay/MoMo → đọc lại trạng thái booking. Giá/hoàn tiền do API xác nhận; không lấy trạng thái thành công từ URL cổng thanh toán.
- Vé của tôi/chi tiết/QR thật và hủy vé qua báo giá hoàn tiền trước khi xác nhận.
- Tra cứu khách vãng lai dùng hợp đồng trực tiếp mã booking + email; thông tin tra cứu ở cookie httpOnly, không có token trên URL.
- Bài viết, chuyên mục, FAQ và trang pháp lý dùng các endpoint đã xuất bản; dữ liệu mẫu chỉ còn trong nhánh preview phát triển.
- Hỗ trợ: danh sách/chi tiết, tạo/phản hồi theo booking, upload/download tệp; Guest dùng quyền booking đã lưu trên trình duyệt.
- VXN Plus/ví voucher: chính sách thật, lịch sử có bộ lọc/phân trang, đổi điểm với Idempotency-Key ổn định cho một lần xác nhận, cập nhật số dư và lưu mã khuyến mãi.

## API lệch hoặc thiếu cần Khanh quyết định

| Nhóm | Hợp đồng hiện tại và cách xử lý phía web |
| --- | --- |
| OTP/đăng ký | UI cũ dùng `/auth/otp/send`; thực tế là `/auth/otp/request`. Form đăng ký nay chỉ nhập email; khách tự bổ sung tên/điện thoại tại hồ sơ sau OTP, không lưu ngầm. |
| Phiên/đánh giá | Không có `/me/sessions`, revoke-others hoặc `/me/reviews`. Web dùng `/auth/sessions`, thu hồi từng phiên khác, và review gắn booking. |
| OAuth | Google đã có backend nhưng cần cầu nối cookie Better Auth callback → session exchange cho web này. Facebook/Apple chưa hỗ trợ. Đã gỡ các nút đăng nhập mạng xã hội chưa hoạt động. |
| Hộp thư thông báo | `/me/notifications` là nhật ký gửi; thiếu title/content/read-state của hộp thư UI. Chỉ nối cài đặt kênh thông báo. |
| Trang chủ | Chưa có danh sách tuyến phổ biến và nhà xe nổi bật (`/catalog/popular-routes`, `/catalog/featured-operators`). Nhánh thật chỉ hiển thị tìm chuyến, bài viết và hướng dẫn có thể sử dụng; bỏ khối placeholder và bộ chọn nhà xe không có danh mục. |
| Tiền trong hợp đồng | Một số DTO trip/hold/booking/payment/cancellation dùng JSON integer `number`, khác quy ước chuỗi/BIGINT phía web. Web kiểm tra safe integer rồi chuyển BigInt/chuỗi; không tính tiền bằng float. Không đổi API. |
| Voucher ở checkout | Hold trả subtotal; chưa có API báo giá tổng tiền/voucher trước khi tạo booking. Booking kiểm tra `expectedTotal` và tính giảm giá trong transaction. Chưa bật áp voucher tại checkout để tránh tự tính hoặc tự chấp nhận số tiền mới. |
| Thanh toán | Backend nhận provider `VNPAY`/`MOMO`, không nhận lựa chọn ngân hàng con; web chỉ gửi provider. Chưa có endpoint gửi lại email vé. |
| Tra cứu khách | API trực tiếp `/guest/ticket-lookup`, không có OTP request/verify hoặc token phiên lookup như UI cũ. Web thích ứng bằng phiên tra cứu riêng 15 phút. API không cấp booking capability từ lookup nên không thể dùng kết quả lookup đơn thuần để hủy vé hoặc gửi hỗ trợ. |
| Hồ sơ | API chưa có giới tính/CCCD, đổi email hay liên kết OAuth. Các trường/thao tác đó không được giả lưu thành công. |
| Nội dung | API article chưa trả tác giả/lượt xem/thời gian đọc/bài liên quan; trang pháp lý chưa có ngày hiệu lực riêng. Web chỉ hiển thị dữ liệu được cung cấp. Markdown được render bằng react-markdown 10.1.0 đang dùng trong repo, không thực thi HTML thô. |
| Hỗ trợ | `/me/complaints` và `/guest/complaints` trong UI cũ không tồn tại. Đã nối `/me/support-tickets` và các endpoint gắn booking. API chấp nhận JPEG/PNG/PDF ≤10MB; UI theo giới hạn này. Guest cần `X-Booking-Token`, không thể xác minh quyền hỗ trợ bằng email đơn thuần. |
| VXN Plus | Dùng rules đang áp dụng; không dùng số quy đổi/hạng từ Figma. `RESERVED` tương ứng đang giữ, `REVERSAL` tương ứng thu hồi. Voucher đổi điểm có thể không có mã công khai; không tạo mã giả. `pointValue` dạng number được kiểm tra số nguyên an toàn trước khi tính bằng BigInt. |
| Refresh khi scale | Chống xoay lặp bằng Web Locks giữa tab và single-flight trong process Next. Nhiều instance cần phối hợp dùng chung hoặc Passenger cookie transport ở backend trước khi mở rộng triển khai. |

Nguồn đối chiếu thực tế: `packages/api-client/src/generated/openapi.json`, `packages/types/src/passenger-profile.ts`, `packages/types/src/passenger-loyalty.ts`, controller/DTO tương ứng trong `apps/api/src`. Không thay đổi các nguồn này.

## Chỉnh giao diện theo hợp đồng hiện tại

- Đăng nhập/đăng ký dùng email OTP; bỏ thời hạn OTP và số lượt thử tự đoán. Hồ sơ chỉ cho sửa trường được hỗ trợ, không biến email thành họ tên khi tên đang trống.
- Cài đặt thông báo chỉ hiển thị tùy chọn Email/Push; bỏ hộp thư/read-state giả. Review theo booking, nhận xét tùy chọn và không có nút lưu tạm/chỉnh sửa giả.
- Checkout phân biệt giá giữ chỗ với tổng tiền booking; không có ô áp voucher hoặc chọn ngân hàng khi API chưa hỗ trợ. Trạng thái vé/thanh toán và nút quản lý đơn theo dữ liệu/quyền thực tế.
- Ví voucher tách bốn trạng thái; voucher đang giữ không tính là khả dụng. Hiển thị mức giảm phần trăm/số tiền, mã công khai và hạn dùng thật; không hứa tự áp mã khi chuyển tới tìm chuyến.
- VXN Plus xử lý riêng hạng cao nhất, thiếu chính sách, tài khoản chưa hoạt động và thiếu điểm. Sau đổi điểm, hiển thị số dư API trả về; preview không thể gửi yêu cầu đổi/lưu thật.
- Không hiển thị endpoint hoặc nhãn kỹ thuật trong trạng thái chưa khả dụng. Footer chỉ dẫn tới các luồng khách hàng đang có; bỏ cổng localhost, đăng ký nhà xe chưa có trang và địa chỉ liên hệ mẫu.

## Chạy và kiểm chứng

- Cấu hình `API_BASE_URL` theo `apps/marketplace/.env.example`; mặc định `http://localhost:3000/v1`.
- Web: `pnpm --filter @vexenhanh/marketplace dev` (port 3001).
- Kết quả sau chỉnh UI: lint PASS, typecheck PASS, Vitest **67/67 tests (14 suites) PASS**, production build PASS; `git diff --check` PASS.
- Xác nhận cả hai branch nguồn là ancestor của HEAD; không có diff ở `apps/api`, `packages/types`, `packages/api-client` so với HEAD tích hợp.
- Build cần kết nối Google Fonts đang dùng sẵn trong layout. Build sandbox ban đầu lỗi tải font; build có mạng đã qua.
- Đã kiểm tra trình duyệt production: trang chủ không thay danh mục lỗi bằng fixture, tìm chuyến lỗi hiển thị lỗi kết nối, form đăng nhập kiểm tra email.
- Sau chỉnh UI, đã kiểm tra trực tiếp form đăng ký chỉ còn email và tra cứu mã booking + email không có bước OTP; sửa liên kết điều khoản/bảo mật về đường dẫn pháp lý hiện có.
- API local port 3000 không chạy trong phiên này: chưa xác minh hành trình mua vé/OTP/thanh toán sandbox với backend thật.
- Chưa chạy review độc lập hoặc security audit, theo quy tắc chỉ chạy khi Khanh yêu cầu.
