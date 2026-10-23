# Kế hoạch E2E web khách hàng Marketplace

Ngày lập: 21/10/2026. Branch: `marketplace-api-integration`.

**Trạng thái: kế hoạch triển khai, chưa chạy E2E và chưa tạo suite Playwright Marketplace.** Theo yêu cầu bổ sung, OTP do Khanh kiểm thử thủ công theo [checklist riêng](marketplace-otp-manual-test-checklist.md); không xây harness/endpoint OTP. Phần frontend áp mã khuyến mãi công khai đã được bổ sung sau khi phát hiện API sẵn có. Không thay đổi API nghiệp vụ hoặc trạng thái tài liệu SDLC.

## 1. Mục tiêu và phạm vi

Kiểm chứng hành trình khách vãng lai (Guest) và hành khách đăng nhập (Passenger) trên toàn bộ **29 route** của `apps/marketplace`: dữ liệu từ API thật, quyền truy cập đúng, số tiền do backend xác nhận và thao tác vẫn đúng sau tải lại trang.

Bao gồm desktop và giao diện mobile web; ứng dụng Flutter, Operator OS và Admin không nằm trong suite này. Dữ liệu do nhà xe/platform tạo sẽ được chuẩn bị bằng fixture, không phải triển khai thêm các luồng quản trị trong suite khách hàng.

Ưu tiên:

- **P0:** không thể mua/xem vé, giữ trùng ghế, sai tiền, thanh toán/hủy lặp, lộ dữ liệu hoặc sai quyền, mất phiên đăng nhập.
- **P1:** tài khoản, hành khách đã lưu, đánh giá, hỗ trợ, VXN Plus, ví voucher, nội dung và đầy đủ trạng thái nghiệp vụ.
- **P2:** tương thích trình duyệt, bàn phím, bố cục, kết nối chậm và khả năng phục hồi.

Các mã `MKT-*` dưới đây là mã ca dự kiến cho kế hoạch này, không thay thế mã `TC-*` của SDLC. Một dòng có nhiều biến thể dữ liệu sẽ tách thành nhiều test khi hiện thực.

## 2. Hiện trạng và các điểm cần xử lý trước

| Hạng mục | Hiện trạng đã đối chiếu | Hướng thực hiện |
| --- | --- | --- |
| Runner | Marketplace chưa có `playwright.config.ts`, dependency Playwright hoặc script `test:e2e`; Operator OS/Admin đã có | Tái sử dụng mẫu runner hiện có, thêm cấu hình riêng port 3001 và fixture Passenger/Guest |
| Kết quả trước đây | Báo cáo tích hợp ghi 67/67 Vitest, lint/typecheck/build pass; chưa chạy hành trình backend thật | Dùng làm baseline; không tính các kết quả này là E2E đã đạt |
| OTP thủ công | `NotificationModule` chỉ chọn Resend hoặc Console; Console không in OTP và báo chưa có kênh gửi | Khanh kiểm theo checklist riêng qua mailbox kiểm thử do mình kiểm soát. Không hiện thực test inbox/harness OTP. API trả 200 chưa chứng minh email đã giao thành công |
| Thanh toán local | Có simulator VNPay/MoMo tại `/v1/dev/payment-gateway/*`, gửi IPN có chữ ký qua webhook thật | Dùng ngay cho luồng E2E local; chạy worker xử lý callback/phát hành vé. Không thay response tạo payment bằng mock |
| OTP/email bên ngoài | Có Resend adapter nhưng không có hộp thư test tự động sẵn | Kiểm tra giao nhận email qua mailbox kiểm thử riêng trong đợt kiểm nhà cung cấp; không dùng email khách thật |
| Mã khuyến mãi công khai | **Có** `/promotions/check` trả `discount`/`total`; checkout nay đã nối nhập/kiểm/bỏ mã và gửi `promotionCode` + tổng đã hiển thị | Đưa vào bộ E2E áp mã, kiểm hết lượt/giá đổi; chưa coi là pass E2E vì chưa chạy backend thật |
| Voucher trong ví | Booking hỗ trợ `userVoucherId`; chưa xác định endpoint quote riêng tương ứng, checkout chưa áp voucher | Kiểm ví/đổi điểm/lưu mã trong suite hiện tại; áp voucher vào booking là `GAP`, cần xác nhận hợp đồng trước khi nối |
| Refresh nhiều instance | Web Locks giữa tab + single-flight trong một process Next đã có | Kiểm hai tab trên một instance; thử nhiều instance là hạng mục riêng trước khi scale, không suy ra từ kết quả local |

Nguồn hiện trạng: [báo cáo tích hợp](marketplace-api-integration-report.md), [package Marketplace](../../apps/marketplace/package.json), [NotificationModule](../../apps/api/src/external/notification/notification.module.ts), [ConsoleEmailNotifier](../../apps/api/src/external/notification/console-email-notifier.ts), [simulator thanh toán](../../apps/api/src/external/payment/simulator/payment-simulator.controller.ts), [API kiểm mã](../../apps/api/src/promotion/promotion.controller.ts).

Không bổ sung endpoint OTP công khai, không bỏ xác minh OTP, không sửa rule thanh toán/hoàn tiền để test dễ pass. Nhóm công khai/Guest chạy độc lập OTP. Ca Passenger dùng phiên do Khanh đăng nhập thủ công trước trong môi trường test; thiếu phiên thì ghi `BLOCKED`. OTP chưa có biên bản kiểm thủ công thì không báo toàn bộ P0 đã đạt.

## 3. Môi trường, dữ liệu và cách quan sát

### 3.1 Môi trường chạy

- Node 24, pnpm theo lockfile; Playwright theo mẫu Operator OS/Admin. Local ưu tiên Chrome đã cài (`PLAYWRIGHT_CHANNEL=chrome`); CI cài browser phù hợp sau khi triển khai job.
- Web `http://localhost:3001`, API `http://localhost:3000/v1`; `API_BASE_URL` và `PAYMENT_RETURN_BASE_URL` phải khớp. Giữ cùng cách viết hostname để cookie không bị tách giữa `localhost` và `127.0.0.1`.
- PostgreSQL 16, Redis 7, MongoDB 7 cho test riêng; migrate bằng owner, ứng dụng dùng role không bypass RLS theo runbook. Worker riêng chạy xử lý callback, hết hạn, hoàn tiền và thông báo.
- Lane Guest local có thể để `RESEND_API_KEY` trống và chấp nhận notification `SKIPPED`; không suy ra email giao thành công. Lane kiểm OTP của Khanh cần Resend và mailbox test riêng. Với phiên Passenger đã chuẩn bị, chỉ dùng địa chỉ email thử nghiệm do Khanh kiểm soát cho booking/thông báo. Để trống đầy đủ bộ khóa VNPay/MoMo trong môi trường dev/test để dùng simulator hiện có; đặt `BETTER_AUTH_URL=http://localhost:3000` để callback nội bộ đúng. Không dùng `NODE_ENV=production` cho API simulator.
- Upload dùng local storage có `STORAGE_LOCAL_DIR` riêng cho test và không cấu hình R2 thật; API/worker dùng cùng môi trường. Chưa có global teardown Marketplace; cần xây cleanup theo manifest runId thay vì giả định seed OS/Admin đã có.
- Lần chạy chấp nhận cuối dùng bản Next build/start; API vẫn chạy dev/test. Không dùng `?preview=` trong luồng E2E thật. Có ca riêng chứng minh production web bỏ qua preview.
- Mỗi lần chạy có `runId`, email và mã fixture riêng. Seed/cleanup kiểm tra đích test trước khi ghi; không `FLUSHALL`, reset DB hoặc xóa dữ liệu môi trường dùng chung. Không sao chép seed IAM hiện tại nếu thao tác reset rate limit của nó vượt phạm vi fixture mới.

### 3.2 Bộ fixture tối thiểu

| Nhóm | Dữ liệu cần có |
| --- | --- |
| Danh tính | Guest G1/G2 là browser context độc lập; Passenger A/B không chung phiên; tài khoản mới chưa có tên, tài khoản bị khóa, không có booking; A có ít nhất hai phiên đăng nhập |
| Tenant | Hai nhà xe A/B, chỉ dữ liệu được công bố xuất hiện công khai; booking/ticket/support của hành khách A không thuộc quyền hành khách B |
| Chuyến | Mở bán D+7 theo `Asia/Ho_Chi_Minh`, chuyến qua nửa đêm, nhiều điểm đón/trả, đủ chỗ cho 10 khách, ghế/tầng/loại xe khác nhau; hết chỗ, đóng bán, hủy, hoàn tất, ID không tồn tại |
| Ghế/hold | Ghế trống, đang giữ, đã bán; hai context tranh cùng ghế/chặng; chặng chồng lấn và không chồng lấn; hold còn hạn và hết hạn do server |
| Giá/chính sách | Giá VND lẻ như 100001 để lộ làm tròn sai; nhiều ghế; các mốc chính sách hủy có/không hoàn; tổng và phí lấy từ dữ liệu API đã xác nhận |
| Booking/vé | Chờ thanh toán, hết hạn, đã trả tiền chưa phát hành xong, đã phát hành nhiều vé, thanh toán thất bại/đối soát, hủy một phần/toàn bộ, vé đã sử dụng/không còn quyền hủy |
| Support | Booking sở hữu và không sở hữu, ticket có nhiều phản hồi/trạng thái, tệp PNG/JPEG/PDF hợp lệ và biên dung lượng/định dạng không hợp lệ |
| Loyalty/voucher | Không điểm, đủ điểm, hạng cao nhất, thiếu rules, tài khoản không hoạt động; lịch sử hơn 20 dòng; voucher AVAILABLE/RESERVED/USED/EXPIRED, có/không mã công khai, phần trăm/số tiền, ví hơn 50 dòng |
| Nội dung | Chuyên mục/bài/FAQ/trang pháp lý đã xuất bản, draft chưa công khai, slug không có, Markdown có liên kết và HTML thô; dữ liệu đủ phân trang |

Tạo ngày theo thời điểm chạy, không dùng chuyến cố định sẽ quá hạn. Các test tranh chấp dùng ghế riêng; test thay đổi chính sách/điểm/phiên không chia sẻ tài khoản với worker song song. Cấu hình trình duyệt `vi-VN`, múi giờ `Asia/Ho_Chi_Minh`; thêm ca kiểm cùng dữ liệu khi timezone trình duyệt khác Việt Nam.

### 3.3 Ba loại kiểm thử và bằng chứng

| Loại | Cách chạy | Được kết luận |
| --- | --- | --- |
| E2E ứng dụng | Browser → Next Server Actions/RSC → API thật → DB/Redis/worker thật, simulator payment sẵn có; Passenger đăng nhập OTP thủ công trước | Hành trình ứng dụng hoạt động trong môi trường local, chưa chứng minh giao nhận của nhà cung cấp hoặc OTP tự động |
| Kiểm thử lỗi có kiểm soát | Proxy/harness chỉ test làm API chậm, 429, 5xx, response sai hợp đồng hoặc ngắt callback | UX xử lý lỗi đúng; báo cáo riêng, không tính là hành trình backend thật đã pass |
| Sandbox nhà cung cấp | Resend/mailbox test, VNPay/MoMo sandbox có khóa và callback truy cập được | Giao nhận/redirect/callback tương thích sandbox; tách khỏi PR smoke để không phụ thuộc dịch vụ ngoài |

`page.route()` không chặn được fetch từ Next server sang API. Các lỗi SSR/Server Actions phải tạo qua proxy/harness phía server; không chặn request browser rồi tuyên bố đã thử lỗi API backend.

Assert chính: nội dung UI + trạng thái sau reload + dữ liệu API/DB thuộc fixture khi cần. Dùng polling có timeout cho worker; không `waitForTimeout` cố định. Test QR xác nhận ảnh giải mã được và khớp token vé của fixture trong bộ nhớ; không ghi token vào report. RLS, HMAC, refresh reuse, ledger và tiền/idempotency vẫn cần Vitest/Supertest integration riêng theo ADR-025.

## 4. Ma trận ca kiểm thử

Điều kiện chung: fixture đã seed đúng trạng thái; lookup hợp lệ đi qua UI. Các ca OTP A01–A04 chuyển sang checklist do Khanh thực hiện; các ca Passenger còn lại dùng phiên đăng nhập thủ công đã chuẩn bị, không giả response OTP. Thao tác mutation phải xác nhận lại sau reload và không ảnh hưởng dữ liệu người khác.

### 4.1 Trang chủ, tìm kiếm, chi tiết chuyến/nhà xe

| ID | Ưu tiên | Bước chính → kết quả cần đạt |
| --- | --- | --- |
| MKT-S01 | P0 | `/` chọn tỉnh/điểm đi-đến, ngày, số khách → `/trips` có đúng kết quả fixture, URL giữ điều kiện, không dùng card mẫu |
| MKT-S02 | P1 | Đổi chiều, cùng điểm, thiếu trường, ngày quá khứ, số khách 1/10 và ngoài biên → kiểm tra hợp lệ, không gửi tìm kiếm sai |
| MKT-S03 | P1 | Lọc giờ/giá/loại chỗ/hạng xe, sort và sang trang → kết quả khớp API, reset và Back/Forward giữ trạng thái đúng |
| MKT-S04 | P1 | Chuyến qua nửa đêm và browser timezone khác → ngày/giờ Việt Nam, giá VND và số chỗ đúng |
| MKT-S05 | P1 | Không có kết quả; catalog lỗi; search lỗi → trạng thái riêng, có cách thử lại, không thay bằng fixture |
| MKT-S06 | P0 | Mở `/trips/[tripId]` → đúng lịch trình, đón/trả, giá, ghế, chính sách; đi tới chọn ghế đúng chuyến |
| MKT-S07 | P1 | Mở `/operators/[operatorId]`, phân trang review → đúng nhà xe/ảnh/tiện ích/đánh giá; ID sai hoặc chưa công bố không hiện dữ liệu nội bộ |
| MKT-S08 | P1 | Chuyến hết chỗ/đóng bán/hủy hoặc ID không tồn tại → không tạo hold, thông báo và hướng đi tiếp phù hợp |

### 4.2 OTP thủ công và phiên đăng nhập

**MKT-A01..A04 là ca thủ công của Khanh**, ghi kết quả trong [checklist OTP](marketplace-otp-manual-test-checklist.md), không nằm trong runner tự động. MKT-A05..A09 vẫn thuộc suite phiên/quyền, với phiên đã chuẩn bị khi cần.

| ID | Ưu tiên | Bước chính → kết quả cần đạt |
| --- | --- | --- |
| MKT-A01 | P0 · thủ công | `/register` email mới → nhận OTP qua mailbox của Khanh → `/verify-email` → `/account`; không tự lấy email làm họ tên hoặc tự lưu hồ sơ |
| MKT-A02 | P0 · thủ công | `/login` email có sẵn → OTP → vùng tài khoản; reload còn đăng nhập; Guest vào vùng riêng được hướng dẫn đăng nhập |
| MKT-A03 | P0 · thủ công | OTP sai/hết hạn/đã dùng hoặc email không khớp → không tạo phiên; thông báo từ API, không đếm lượt/thời hạn tự đoán |
| MKT-A04 | P1 · thủ công | Gửi lại OTP, cooldown/rate limit theo backend, verify-email thiếu email hợp lệ → chặn/điều hướng đúng; chỉ gửi tới mailbox test của Khanh |
| MKT-A05 | P0 | Access token hết hạn, refresh còn hạn → thao tác riêng và reload thành công; refresh hết hạn/thu hồi → yêu cầu đăng nhập lại |
| MKT-A06 | P0 | Hai tab cùng origin thao tác khi access hết hạn → không xoay refresh cạnh tranh làm mất phiên; kiểm cả tab chuyển từ nền sang hiện |
| MKT-A07 | P0 | Đăng xuất rồi Back/reload/mở URL riêng → không lấy lại dữ liệu riêng từ phiên cũ; lỗi logout không báo đã đăng xuất thành công |
| MKT-A08 | P0 | Tài khoản bị khóa hoặc context Guest/Passenger B mở URL booking/ticket của A → không lộ tên/email/QR, không mutation được |
| MKT-A09 | P1 | Kiểm cookie httpOnly/SameSite và Secure ở cấu hình HTTPS phù hợp; JS storage/URL/props công khai không có access/refresh token; không lưu storageState chứa bí mật vào artifact công khai |

Giả lập thời gian phía browser không làm JWT/hold/OTP hết hạn ở server. Ca hết hạn cần fixture/harness đúng hạn server hoặc phiên hết hạn thật, không chỉnh lifetime production. Refresh-token reuse và family revocation trực tiếp kiểm ở API integration, browser kiểm hậu quả mất quyền.

### 4.3 Chọn ghế, giữ chỗ, checkout

| ID | Ưu tiên | Bước chính → kết quả cần đạt |
| --- | --- | --- |
| MKT-B01 | P0 | `/trips/[tripId]/seats` chọn điểm đón/trả hợp lệ, ghế đúng tầng/loại → hold đúng chặng, ghế và subtotal → `/checkout/[holdId]` |
| MKT-B02 | P1 | Điểm trả trước/cùng điểm đón, không chọn ghế, chọn quá 10, ghế giữ/bán → không gửi lựa chọn sai; đổi chặng cập nhật khả dụng |
| MKT-B03 | P0 | Hai browser tranh cùng ghế trên chặng chồng lấn → chỉ một hold thành công, bên thua thấy xung đột và chọn lại; không oversell |
| MKT-B04 | P1 | Cùng ghế trên hai chặng không chồng lấn → kết quả theo quy tắc inventory server; reload sơ đồ phản ánh đúng trạng thái |
| MKT-B05 | P0 | Hold hết hạn khi đang checkout → không tạo booking/thanh toán; thoát hoặc tải lại không biến hold cũ thành còn hiệu lực; worker trả ghế đúng |
| MKT-B06 | P0 | Guest điền liên hệ và hành khách cho mỗi ghế, chấp nhận điều khoản → tạo booking đúng người/ghế/điểm; subtotal chỉ là tạm tính, tổng cuối lấy booking |
| MKT-B07 | P1 | Passenger dùng hồ sơ/hành khách đã lưu, chỉnh dữ liệu, tên có dấu/điện thoại không hợp lệ/note biên độ dài → đúng validation và ánh xạ; không tự lưu người khi chưa yêu cầu |
| MKT-B08 | P0 | Click tạo đơn hai lần, reload, Back rồi gửi lại → không có hai booking/giữ trùng cho cùng yêu cầu; trường hợp timeout phải xác minh backend trước khi thử lại |
| MKT-B09 | P0 | Backend từ chối `expectedTotal` hoặc hold không còn hợp lệ → không chấp nhận giá mới âm thầm, không tạo giao dịch với tiền sai, cho xem lại/chọn lại |
| MKT-B10 | P0 | Guest/Passenger nhập mã công khai hợp lệ → check lấy chuyến/subtotal từ hold → hiển thị giảm/tổng API → tạo booking với `promotionCode` và đúng tổng đã thấy; payment đọc lại booking đúng tiền |
| MKT-B11 | P1 | Mã sai/hết hạn/sai phạm vi/chưa đủ tối thiểu; sửa hoặc xóa mã; mã đang kiểm → lỗi tại ô, không giữ quote cũ, không submit trong lúc chờ; mã còn chữ nhưng chưa kiểm phải áp hoặc xóa trước khi tiếp tục |
| MKT-B12 | P0 | Check thành công nhưng lúc tạo đơn hết lượt/ngân sách hoặc giá thay đổi → giữ biểu mẫu/mã, báo lỗi, không tự bỏ mã hay chấp nhận tổng mới; giá ghế đổi cần quay lại chọn chỗ vì GET hold vẫn là snapshot |

### 4.4 Thanh toán VNPay/MoMo và kết quả

| ID | Ưu tiên | Bước chính → kết quả cần đạt |
| --- | --- | --- |
| MKT-P01 | P0 | **Guest mua một vé qua VNPay:** tìm chuyến → chọn ghế → checkout → simulator success → kết quả → QR/vé; reload vẫn truy cập được với capability gốc |
| MKT-P02 | P0 | **Passenger mua nhiều vé qua MoMo:** toàn hành trình từ đăng nhập → payment success → danh sách/chi tiết đủ vé, ghế, liên hệ và tổng đúng |
| MKT-P03 | P0 | Mỗi provider chọn fail, quay lại/thử lại khi booking còn hạn → không phát hành vé sai; chỉ cho retry ở trạng thái API cho phép |
| MKT-P04 | P0 | Tự mở result với query giả thành công, đổi bookingId hoặc trở về trước khi worker xong → chỉ lấy trạng thái API, chưa phát hành thì hiện đang xử lý |
| MKT-P05 | P0 | Booking hết hạn hoặc payment SUCCESS/RECONCILING → không cho trả thêm tiền; callback đến muộn không hiển thị vé thành công khi API chưa xác nhận |
| MKT-P06 | P0 | Click thanh toán lặp/Back/reload → không phát sinh thu tiền lặp; replay **cùng callback/cùng transaction id** kiểm ở API integration, không coi hai lần bấm simulator là replay giống nhau |
| MKT-P07 | P0 | Thanh toán đã ghi nhận nhưng phát hành vé/notification chậm hoặc notification thất bại → không báo đã có QR sớm, vé đã phát hành vẫn xem được dù email lỗi |
| MKT-P08 | P1 | Đóng tab cổng, mở lại booking còn hạn; provider/API lỗi hoặc mạng mất sau khi gửi → đọc lại trạng thái trước khi retry, không tự kết luận thất bại/thành công |
| MKT-P09 | P1 | Đổi lựa chọn VNPay/MoMo, chưa chấp nhận điều khoản, vào link payment không đủ quyền → gửi provider hợp lệ, chặn hành động không hợp lệ và không lộ booking |

Trong P01/P02 assert thêm: payment amount = tổng booking, số vé và seat inventory khớp dữ liệu sau callback. Tiền/ledger chính xác, HMAC sai, callback trùng, callback sai tiền và đối soát là các gate API integration đi kèm, không chỉ nhìn màn hình success.

### 4.5 Vé của tôi, QR, tra cứu Guest và hủy/hoàn

| ID | Ưu tiên | Bước chính → kết quả cần đạt |
| --- | --- | --- |
| MKT-T01 | P0 | `/my-tickets` → `/my-tickets/[ticketId]` → đủ vé/QR đúng booking, chính sách/đón-trả/tổng tiền; QR giải mã khớp vé thật |
| MKT-T02 | P1 | Các tab upcoming/completed/cancelled, tìm kiếm/bộ lọc đang có, tài khoản rỗng và hơn một trang API → không thiếu/đếm trùng booking |
| MKT-T03 | P0 | `/tickets/lookup` nhập mã booking + email đúng → `/tickets/lookup/result` xem vé/QR; sai mã/email, ticket code thay booking code → không lộ dữ liệu |
| MKT-T04 | P0 | Guest mới chỉ lookup → không được cấp quyền hủy/tạo support; Guest gốc có cookie capability → quản lý đúng booking; không suy quyền từ email hoặc bookingId query |
| MKT-T05 | P1 | Lookup hết phiên 15 phút, kết thúc phiên, reload/Back/mở context mới → yêu cầu tra cứu lại; không đưa credential/token lên URL |
| MKT-T06 | P0 | Chủ vé chọn hủy một phần → lấy quote API → xem tiền/phí → xác nhận → chỉ vé chọn bị hủy, còn vé khác dùng được, trạng thái hoàn lấy từ API |
| MKT-T07 | P0 | Hủy toàn bộ, hoàn 0/có phí, các mốc chính sách → tổng hoàn/phí chính xác; không hiển thị tiền đã về khi mới tạo yêu cầu hoàn |
| MKT-T08 | P0 | Quote cũ thay đổi khi xác nhận hoặc xác nhận hủy lặp → backend từ chối/đòi quote lại hoặc trả kết quả đúng; không hủy/hoàn hai lần |
| MKT-T09 | P0 | Vé không còn được hủy (đã dùng, trạng thái/chính sách không cho phép), vé của B, token Guest sai/thiếu → chặn cả UI và mutation |
| MKT-T10 | P1 | Booking có thông báo thay đổi chuyến/điểm/giờ hoặc chuyến bị hủy → hiển thị thông tin API đã cung cấp, hành động theo quyền/trạng thái hiện tại |

### 4.6 Hồ sơ, hành khách đã lưu, thiết lập và đánh giá

| ID | Ưu tiên | Bước chính → kết quả cần đạt |
| --- | --- | --- |
| MKT-U01 | P1 | `/account` sửa tên/điện thoại/ngày sinh, reload → dữ liệu đã lưu đúng; lỗi validation/server không hiện toast thành công |
| MKT-U02 | P1 | Thêm/sửa/xóa hành khách đã lưu → danh sách đúng và checkout dùng được; vượt giới hạn/ID của B/tạo lặp không làm sai dữ liệu |
| MKT-U03 | P1 | `/account/notifications` đổi Email/Push từng loại → reload giữ lựa chọn; loại bắt buộc không tắt được; lỗi giữa nhiều cập nhật không báo tất cả đã lưu |
| MKT-U04 | P0 | `/account/sessions` liệt kê đúng phiên hiện tại/khác, revoke một phiên → context bị thu hồi mất quyền ở request kế tiếp |
| MKT-U05 | P1 | Thu hồi các phiên khác → phiên hiện tại còn dùng được, các phiên còn lại bị chặn; lỗi thu hồi một phần không báo tất cả thành công |
| MKT-U06 | P1 | `/account/reviews` booking đủ điều kiện → gửi sao và nhận xét tùy chọn → reload thấy review, public review đúng nhà xe/chuyến; booking chưa đủ điều kiện/đã review/không sở hữu bị chặn |

### 4.7 Hỗ trợ và tệp đính kèm

| ID | Ưu tiên | Bước chính → kết quả cần đạt |
| --- | --- | --- |
| MKT-K01 | P1 | `/support` Passenger chọn booking sở hữu → tạo yêu cầu → list/detail có đúng nội dung, trạng thái, mốc giờ sau reload |
| MKT-K02 | P1 | Mở yêu cầu, phản hồi, bộ lọc/phân trang đang có → đúng thread và không mất phản hồi; trạng thái đóng/giới hạn reply tuân theo API |
| MKT-K03 | P1 | `/support/guest?bookingId=...` với capability gốc → tạo/đọc/phản hồi đúng booking; chỉ lookup hoặc email không đủ quyền |
| MKT-K04 | P0 | Passenger B/Guest khác thay bookingId/ticketId/attachmentId → không đọc thread/tải tệp hoặc gửi phản hồi của A |
| MKT-K05 | P1 | Upload và download JPEG/PNG/PDF hợp lệ → nội dung khớp; kiểm biên bằng/nhỏ hơn/lớn hơn 10MB và định dạng không được chấp nhận |
| MKT-K06 | P1 | Upload lỗi, URL tải hết hạn, mạng chậm/submit lặp, thiếu trường/nội dung dài → giữ nội dung nhập để thử lại, không báo gửi xong khi API thất bại |

### 4.8 VXN Plus, lịch sử điểm và ví voucher

| ID | Ưu tiên | Bước chính → kết quả cần đạt |
| --- | --- | --- |
| MKT-L01 | P1 | `/plus` → số dư/hạng/rules đúng API; riêng hạng cao nhất, thiếu rules, 0 điểm, tài khoản không hoạt động không có số quy đổi giả |
| MKT-L02 | P0 | Xác nhận đổi điểm hợp lệ → chỉ một redemption/voucher; double-click/retry cùng Idempotency-Key không trừ lặp; sau reload số dư đúng API |
| MKT-L03 | P1 | Thiếu điểm, điểm ngoài biên, lỗi sau redemption trước khi đọc lại profile → không hiển thị số dư dự đoán; tải lại đối chiếu kết quả trước khi đổi tiếp |
| MKT-L04 | P1 | `/plus/history` lọc loại/khoảng thời gian, sang trang >20 dòng → EARN/REDEEM/EXPIRE/ADJUST/REVERSAL, tổng và dấu điểm đúng |
| MKT-L05 | P1 | `/account/vouchers` bốn trạng thái AVAILABLE/RESERVED/USED/EXPIRED, ví >50 dòng → tổng đúng, RESERVED không đếm khả dụng |
| MKT-L06 | P1 | Lưu mã công khai hợp lệ/sai/trùng/hết hạn → theo kết quả API; voucher phần trăm/số tiền, mã null, hạn dùng/copy mã hiển thị đúng; nút tìm chuyến không hứa tự áp mã |
| MKT-L07 | P1 | Sau hoàn tất chuyến hoặc hủy/hoàn theo rule → lịch sử/số dư cập nhật đúng một lần; tự động hóa event và kiểm idempotency ở API integration, web xác nhận dữ liệu cuối |

Ca áp mã công khai ở B10..B12; voucher ví áp vào checkout vẫn ghi `GAP` ở §5, không thay thế bằng ca lưu mã vào ví.

### 4.9 Bài viết, FAQ, pháp lý và điều hướng

| ID | Ưu tiên | Bước chính → kết quả cần đạt |
| --- | --- | --- |
| MKT-C01 | P1 | `/explore` lọc chuyên mục/phân trang → `/explore/[slug]`; tiêu đề/ảnh/nội dung đúng bài đã xuất bản, draft không xuất hiện |
| MKT-C02 | P1 | Markdown heading/list/link/image và HTML thô → trình bày đúng, HTML/script không chạy; không tự sinh tác giả/lượt xem/ngày hiệu lực |
| MKT-C03 | P1 | `/faq` tìm/lọc/mở câu trả lời theo UI đang có → nội dung đúng API, rỗng/lỗi có trạng thái rõ |
| MKT-C04 | P1 | `/legal/[slug]`, link điều khoản/bảo mật từ register/checkout/footer → đúng trang; slug không có không hiển thị nội dung mẫu |
| MKT-C05 | P1 | Header/footer/account sidebar, Guest/Passenger, deep link và Back/Forward → đủ 29 route được truy vết; không link localhost tới cổng quản trị/đối tác hoặc trang chưa có |
| MKT-C06 | P1 | Bản Next production với `?preview=ideal` ở các nhóm trang → bỏ qua fixture, vẫn dùng API/quyền thật; không mutation qua preview |

### 4.10 Khả năng phục hồi, mobile web và truy cập

| ID | Ưu tiên | Bước chính → kết quả cần đạt |
| --- | --- | --- |
| MKT-R01 | P1 | API chậm/lỗi 401/403/404/409/422/429/500/503 tại từng nhóm dữ liệu/mutation → loading/error/empty/forbidden phân biệt, không toast thành công giả; giữ dữ liệu biểu mẫu khi phù hợp |
| MKT-R02 | P0 | Ngắt mạng sau gửi booking/payment/cancel/redemption → đọc lại trạng thái trước retry, không phát sinh nghiệp vụ lặp; kiểm cả sau reload |
| MKT-R03 | P1 | Browser mobile khoảng 390×844 đi trọn search→seat→checkout→payment→QR, thêm support/voucher → không tràn ngang, bàn phím không che nút chính, dialog dùng được |
| MKT-R04 | P2 | Desktop khoảng 1440×900, màn hẹp 360px, nội dung dài/ảnh thiếu → không che giá, trạng thái ghế, QR, nút xác nhận hoặc thông báo lỗi |
| MKT-R05 | P2 | Dùng bàn phím cho form/search/seat/dialog, focus sau lỗi/đóng modal, label lỗi/screen reader tên nút → hoàn tất thao tác chính không cần chuột |
| MKT-R06 | P2 | Smoke trên Firefox/WebKit khi đã chuẩn bị browser runner; mobile emulation riêng → cookie/refresh/redirect/clipboard/upload đúng; không coi emulation là kiểm thiết bị iOS/Android thật |

## 5. Chức năng chưa khả dụng và khác biệt thiết kế

| Mã | Hạng mục | Cách kiểm hiện tại / tiêu chí trước khi mở lại |
| --- | --- | --- |
| FIX-01 | Áp `promotionCode` tại checkout | Đã nối frontend qua API hiện có; đưa B10..B12 vào suite. Unit/kiểm giao diện được báo riêng, chưa xác minh E2E backend thật |
| GAP-02 | Áp `userVoucherId` tại checkout | Chưa có quote riêng được xác định; cần xác nhận hợp đồng và hiển thị tổng trước confirm. Không tự tính voucher bằng UI; khi đủ hợp đồng kiểm giữ/dùng/trả voucher sau payment/expiry/cancel |
| GAP-03 | OAuth Google/Facebook/Apple | Google cần bridge callback/session; Facebook/Apple chưa hỗ trợ. Kiểm nút chưa khả dụng không xuất hiện; `/auth/callback` xử lý trạng thái chưa khả dụng, không đăng nhập giả |
| GAP-04 | Inbox thông báo/read-state | Chỉ test preferences; không đặt ca đọc/đánh dấu đã đọc như chức năng sẵn có |
| GAP-05 | Lookup OTP và quyền quản lý từ email | Runtime dùng mã booking+email, không có OTP/capability mới từ lookup. Test theo quyền hiện tại; đề xuất bổ sung phải báo riêng, không tự đổi API |
| GAP-06 | Trường hồ sơ và tác vụ thiếu | Không giả lưu giới tính/CCCD/đổi email/liên kết OAuth, không gửi lại email vé, không chọn ngân hàng con khi API không nhận |
| GAP-07 | Danh mục nổi bật và metadata | Không có popular routes/featured operators list và một số metadata bài viết/pháp lý; kiểm UI không dựng dữ liệu giả |

Một số phần SDLC/UI còn mô tả lookup OTP, inbox hoặc giới hạn file khác runtime. Trong suite tích hợp này lấy DTO/controller đang chạy làm hợp đồng kiểm thử; ghi sự lệch để Khanh quyết định, không tự sửa SDLC hay tự bổ sung API. `GAP` được báo riêng, không đổi thành `SKIP` rồi tính toàn bộ yêu cầu đã đạt.

## 6. Truy vết với yêu cầu thiết kế

| Nguồn thiết kế | Ca ứng dụng liên quan | Kiểm chứng bổ sung bắt buộc |
| --- | --- | --- |
| 08 Test §8: critical journey search→hold→booking→VNPay/MoMo→QR→xem lại | S01/S06, B01/B06, P01/P02, T01/T03 | Chạy toàn hành trình không mock API; cả Guest và Passenger |
| TC-BOOK-001..003: tranh ghế/hết hạn/đơn | B03/B05/B08/B09 | Concurrency/idempotency/transaction thực ở API + DB |
| TC-PAY-001..004: payment/callback/QR | P01..P07, T01 | Duplicate `(provider, provider_txn_id)`, HMAC, amount mismatch, callback trễ và ledger ở API integration |
| TC-MONEY-001 và TC-REF-001 | B06/B09, P01/P02, T06..T09 | BIGINT/Decimal, phân bổ giảm/hoàn, không float; kiểm ledger/refund worker |
| TC-SEC-001..007 và TC-SEC-008 (web auth) | A01..A09, U04/U05, T04/T09, K04 | Namespace/ownership/RLS/refresh reuse/CSRF theo transport thực; không sao chép suite TOTP Operator/Admin sang Passenger OTP |
| 08 Test §8: notification lỗi vẫn xem vé, loyalty đúng một lần | P07, L02/L07 | Worker retry, delivery log và idempotency ở API integration |

Nguồn: [08 Test §4/§8/§9](../SDLC/08-test-plan-acceptance-criteria.md), [RB-09 web E2E](../runbook/RB-09-web-e2e.md), [IAM-006 guide](IAM-006-guide.md), [báo cáo tích hợp](marketplace-api-integration-report.md). Không coi tất cả yêu cầu bảo mật của SDLC đã được chứng minh bởi Playwright.

## 7. Thứ tự triển khai và phân bổ chạy

| Đợt | Công việc | Điều kiện hoàn tất |
| --- | --- | --- |
| 1 — nền kiểm thử | Thêm config/script Playwright, seed Passenger/Guest/trips, cleanup theo runId; dùng simulator/worker sẵn có; Khanh chuẩn bị phiên Passenger bằng OTP thủ công | Ca public/Guest chạy được; có phiên Passenger hợp lệ và kết quả OTP thủ công riêng; fixture không dùng dữ liệu ngoài lần chạy |
| 2 — P0 mua vé | P01/P02 full journey, hold race/expiry, checkout submit lặp/giá lệch, result không tin query, ownership và refresh/logout | Tất cả P0 đã hiện thực đều pass; có bằng chứng trạng thái backend, không oversell/sai tiền/lộ vé |
| 3 — P0 hậu mãi + P1 | Hủy/hoàn, Guest lookup/capability, tài khoản/review/support, loyalty/ví, nội dung và các trạng thái lỗi | Mọi route có ca thành công/không khả dụng và ca lỗi/quyền thích hợp; mọi mutation có kiểm persistence |
| 4 — tương thích và sandbox | Mobile web, bàn phím, browser khác; OTP email thật trong mailbox test, VNPay/MoMo sandbox; regression API bắt buộc | Tách báo cáo local và nhà cung cấp; mọi GAP/blocker có quyết định rõ trước nghiệm thu toàn bộ |

Phân bổ runner đề xuất sau khi hiện thực:

- **PR smoke tự động không cần OTP:** Chromium/Chrome desktop; Guest VNPay, search, ownership Guest, lookup, áp mã và chống submit lặp. Dùng simulator, không cần dịch vụ ngoài. Passenger MoMo/session/loyalty chạy ở đợt có phiên do Khanh chuẩn bị; CI Passenger sẽ `BLOCKED` nếu chưa có cơ chế phiên phù hợp, không thêm OTP harness trong phạm vi này.
- **Regression đầy đủ:** toàn ma trận trên desktop và nhóm mua vé trọng yếu trên mobile emulation; chạy theo yêu cầu trước merge lớn và có thể lập CI lịch sau khi suite ổn định. Kế hoạch này chưa tạo lịch/automation.
- **Sandbox nhà cung cấp:** chạy riêng khi khóa/callback/mailbox test sẵn sàng, trước release hoặc thay adapter. Thất bại hạ tầng được báo `BLOCKED`, không thay bằng response giả để đạt.
- Khởi đầu một worker cho ca mutation dùng chung trạng thái; chỉ tăng song song khi mỗi worker có fixture riêng. Race test tự tạo hai context trong cùng test. Retry tối đa một lần ở CI để chẩn đoán; flaky sau retry vẫn phải được báo và xử lý.

## 8. Tệp và lệnh dự kiến

Các tệp dưới đây **chưa được tạo trong lần lập kế hoạch**:

```text
apps/marketplace/playwright.config.ts
apps/marketplace/e2e/global-setup.ts
apps/marketplace/e2e/global-teardown.ts
apps/marketplace/e2e/fixtures/        # account, booking, trip; không có OTP inbox
apps/marketplace/e2e/*.spec.ts        # tách theo các nhóm trong §4
apps/api/prisma/e2e-marketplace-seed.ts
```

Chỉ dự kiến bổ sung dependency/config/fixture phục vụ kiểm thử; không xây harness OTP. Nếu cần thay đổi API nghiệp vụ thì ghi phát hiện và báo Khanh trước khi mở rộng. Chưa sửa CI, package hoặc backend trong lần lập kế hoạch này.

Lệnh đã tồn tại để kiểm baseline và chạy hạ tầng:

```powershell
pnpm --filter @vexenhanh/marketplace lint
pnpm --filter @vexenhanh/marketplace typecheck
pnpm --filter @vexenhanh/marketplace test
pnpm --filter @vexenhanh/api build
pnpm --filter @vexenhanh/api start
pnpm --filter @vexenhanh/api start:worker
pnpm --filter @vexenhanh/marketplace build
pnpm --filter @vexenhanh/marketplace start
```

Các server/worker chạy ở terminal riêng sau khi thiết lập env test. Khanh đăng nhập OTP thủ công để chuẩn bị phiên cho nhóm Passenger; không đổi bootstrap API để lấy OTP. Build web hiện cần tải Google Fonts; chuẩn bị mạng/cache cho bước build, không nhầm lỗi tải font với lỗi nghiệp vụ.

Lệnh **đề xuất, chưa dùng được** cho đến khi bổ sung script/config/tag:

```powershell
$env:PLAYWRIGHT_CHANNEL = "chrome"
pnpm --filter @vexenhanh/marketplace test:e2e --grep @smoke
pnpm --filter @vexenhanh/marketplace test:e2e
```

## 9. Tiêu chí pass/fail và báo cáo kết quả

1. Tất cả P0 áp dụng đã pass; không có lỗi đang mở về tiền, oversell, thu/hoàn lặp, quyền sở hữu hoặc lộ vé. P1 đã chạy đủ hoặc từng phần bị chặn có lý do rõ; không coi `not run`, `GAP`, `BLOCKED` là pass.
2. Bao phủ đủ 29 route bằng inventory đối chiếu suite; route chưa khả dụng có assertion đúng trạng thái. Danh sách route không thay thế coverage hành vi: mọi nhóm mutation ở §4 cần được kiểm chứng sau reload.
3. Hai hành trình Guest/VNPay và Passenger/MoMo chạy trọn ít nhất hai lần liên tiếp trên build web, fixture mới; lỗi chỉ pass sau retry được ghi flaky, không xóa khỏi báo cáo.
4. Các test API/DB bắt buộc về tiền/idempotency/ownership-RLS/HMAC/refresh reuse phải thực sự chạy và pass, không chỉ nhận kết quả skip do thiếu DB. Lane provider sandbox có kết quả riêng; chỉ local simulator pass chưa đủ tuyên bố cổng thật đã đạt.
5. FIX-01 đã sửa frontend nhưng vẫn cần chạy B10..B12 với backend thật. GAP-02 cùng các yêu cầu SDLC chưa hiện thực vẫn là phần chưa hoàn tất. Chỉ nghiệm thu phạm vi hiện tại nếu Khanh chấp nhận loại trừ rõ ràng; không dùng việc ẩn nút làm bằng chứng chức năng áp voucher đã hoàn tất. OTP có biên bản thủ công riêng, không tự đánh dấu pass.

Mỗi lần chạy ghi: branch/HEAD và trạng thái working tree, ngày/môi trường/browser, runId, tổng planned/executed/pass/fail/flaky/blocked/gap, lỗi theo ca + bước tái hiện, request/correlation id không nhạy cảm và nguyên nhân UI/API/fixture/infra/provider. Failure giữ screenshot/trace/log đã kiểm tra; fixture chỉ dùng danh tính giả. Playwright trace/storageState có thể chứa cookie, OTP, QR và capability: không upload nguyên bản có bí mật; cất cục bộ hạn chế quyền hoặc xuất bản bản đã làm sạch. Không in token/OTP hoặc tải `.env` lên artifact.

**Kết quả của công việc hiện tại:** hoàn thành kế hoạch, tách checklist OTP thủ công và nối frontend áp mã công khai qua API có sẵn. Chưa cài thêm thư viện, chưa tạo/chạy suite E2E, chưa thay đổi backend hoặc commit/push.
