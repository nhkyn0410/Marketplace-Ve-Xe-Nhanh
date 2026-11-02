# Kế hoạch thanh toán hành khách: payOS / MoMo / VNPay / DEMO — chờ duyệt

> Trạng thái: **Draft — chờ Khanh duyệt** (AI soạn 27/10, cập nhật hiện thực 31/10/2026, chưa review độc lập). Nguồn quyết định: Khanh 21/10/2026 chọn
> payOS (VietQR, tiền thật số nhỏ) + cổng thử nội bộ thay VNPay/MoMo; Figma SCR-PSG-20 (1444:13055, 1450:23099) vẽ lại
> 26/10; Khanh yêu cầu làm phần code ngày 31/10. Đã bổ sung ADR-029 **Proposed / chờ duyệt** cho phần chọn cổng của ADR-019; không tự promote tài liệu. Cấu hình vận hành xem [RB-12](../runbook/RB-12-payos.md).

> Bổ sung theo yêu cầu Khanh trong lượt 31/10: mở lại **MoMo và VNPay như phương thức đang dùng**, cùng payOS / DEMO; màn chọn phương thức có logo tách khỏi màn thanh toán QR / cổng. Bước thông tin hành khách thêm chọn voucher từ ví cho User đăng nhập, vẫn cho nhập mã. Đã kiểm lại sau bổ sung: Flutter analyze không có issue, **265 Flutter tests pass**; backend lint/typecheck và **60 gateway/config tests pass**.

31/10: đã có migration, adapter payOS / DEMO, webhook, đối soát, QR / mở ngân hàng / poll trong app và màn hoàn tất dùng vé từ server. Phần nền payOS đã kiểm migration + role app trên PostgreSQL tạm, test thanh toán / HTTP / hồi quy booking-refund-payout và `pnpm lint`, `pnpm typecheck`, `pnpm test`, `pnpm build` pass. Đã sinh OpenAPI/TS + Dart 7.25.0 và `build_runner`; package Dart không có lỗi analyze nhưng còn 142 cảnh báo mã sinh (`dart analyze --no-fatal-warnings` exit 0). Bổ sung ví voucher / bốn phương thức / tách màn không đổi API/schema/contract nên không cần sinh lại client hoặc build backend. **Chưa nạp khóa hay thử giao dịch cổng bên ngoài / điện thoại thật; chưa qua `code-reviewer` / `security-auditor`; chưa deploy.**

## 1. payOS hoạt động thế nào (đã tra tài liệu chính thức)

| Việc | payOS | Ghi chú |
| --- | --- | --- |
| Tạo link | `POST https://api-merchant.payos.vn/v2/payment-requests`, header `x-client-id`, `x-api-key` | Body: `orderCode` (**số nguyên**), `amount`, `description`, `returnUrl`, `cancelUrl`, `expiredAt` (Unix giây), `signature` |
| Chữ ký tạo link | HMAC-SHA256(checksumKey, `amount=…&cancelUrl=…&description=…&orderCode=…&returnUrl=…`) — khóa xếp alphabet | |
| Kết quả tạo link | `checkoutUrl`, `qrCode` (chuỗi VietQR EMVCo), `bin`, `accountNumber`, `accountName`, `paymentLinkId`, `status` | App tự vẽ QR từ `qrCode` |
| Tra cứu | `GET /v2/payment-requests/{orderCode hoặc paymentLinkId}` → `status`, `amountPaid`, `amountRemaining`, `transactions` | Dùng cho đối soát |
| Hủy link | `POST /v2/payment-requests/{id}/cancel` | Gọi khi đơn hết hạn |
| Webhook | payOS POST `{code, desc, success, data{orderCode, amount, description, reference, paymentLinkId, transactionDateTime, …}, signature}` | Chữ ký = HMAC-SHA256 trên **các khóa của `data`** xếp alphabet, `k=v` nối `&`, null → chuỗi rỗng |
| Đăng ký webhook | `POST /confirm-webhook {webhookUrl}` (hoặc khai trên my.payos.vn) | payOS gửi thử một webhook — endpoint phải trả 2xx |
| Hoàn tiền | Adapter v1 không gọi API hoàn tiền | Chuyển sang luồng hoàn thủ công đã có (`MANUAL_REFUND`); không dùng API chi hộ để tự suy ra hoàn tiền |

Đã xác minh tài liệu chính thức ngày 31/10: payOS **không có sandbox riêng**; mọi giao dịch thật đi qua production API ([nguồn](https://payos.vn/docs/moi-truong-test/)). Adapter nhận `PENDING`, `PROCESSING`, `PAID`, `CANCELLED`, `EXPIRED`; trạng thái lạ không được đoán thành công. `orderCode` trong ứng dụng bị chặn vượt `Number.MAX_SAFE_INTEGER` tại biên JSON, còn DB/domain dùng `bigint`. Mô tả gửi payOS dùng 9 ký tự ASCII cuối của mã payment để hợp giới hạn tài khoản không liên kết. Số tiền tối thiểu của từng kênh cần xác minh trên tài khoản; ứng dụng chỉ chặn số tiền không dương và số nguyên không an toàn, không tự nhận 10.000 ₫ là mức tối thiểu nhà cung cấp.

## 2. Thiết kế API

### 2.1 Tài liệu trước (Khanh duyệt)
- **ADR-029** "Thanh toán hành khách: payOS / MoMo / VNPay + cổng thử nội bộ", bổ sung payOS / DEMO vào hai cổng của ADR-019; cả bốn phương thức đều hiện ở màn chọn theo yêu cầu mới. Giữ `EscrowLedger`
  in-house, đối soát cron, hoàn thủ công. OQ-22 (TGTT) giữ nguyên là production-blocker.
- Cập nhật 04 DB, 05 API, 07 Security, 08 Test, 11 Task, PROJECT-STATE — tất cả "chờ duyệt".

### 2.2 Dữ liệu (migration)
- `PaymentProvider` thêm `PAYOS`, `DEMO`; `VNPAY`/`MOMO` tiếp tục dùng cho giao dịch mới lẫn dữ liệu hiện có.
- `Payment` thêm `providerOrderCode BIGINT UNIQUE NULL` (payOS bắt buộc số nguyên; `paymentCode` `PAY…` hiện tại là
  chuỗi) — sinh từ sequence Postgres không tái sử dụng, mặc định cấp cho payment mới (dữ liệu cũ giữ NULL), và `checkout JSONB NULL` (bin, số TK, tên TK, nội dung CK, `qrCode`, `paymentLinkId`; tiền là chuỗi). Sau migration cấp quyền sequence bằng `db:app-role`.
- Dedup webhook giữ `@@unique([provider, providerTxnId])` với `providerTxnId = data.reference`.

### 2.3 Adapter `external/payment/payos/` (cùng mẫu VNPay/MoMo, viết tay bằng `fetch`, không thêm SDK)
- `createCheckout`: ký → gọi tạo link → **kiểm chữ ký phản hồi** → trả `paymentUrl = checkoutUrl` + `transfer`
  (qrCode, bin, accountNumber, accountName, amount, description **lấy từ phản hồi**, không phải từ request).
- Timeout / trùng mã: giữ `INITIATED` và thử lại cùng `orderCode`, không cấp mã mới. Có thể phục hồi link hosted từ query đã ký và đúng mã / số tiền; khi đó không có `transfer`, app dùng nút mở trang payOS.
- `verifyCallback`: kiểm chữ ký webhook; `success && data.code == "00"` mới là thành công.
- `queryTransaction`: `GET /v2/payment-requests/{orderCode}` → map `PAID`→SUCCESS; link đóng còn tiền đã nhận cũng đưa qua kiểm số tiền / đối soát, không bỏ qua chuyển thiếu. `CANCELLED`/`EXPIRED` không nhận tiền → FAILED.
- `refund`: ném `PaymentGatewayError(retryable=false)` → luồng hoàn thủ công.
- Port `CheckoutRequest` thêm `cancelUrl`, `orderCode`; kết quả `createCheckout` thêm `transfer?` (tuỳ chọn).
- Env: `PAYOS_CLIENT_ID`, `PAYOS_API_KEY`, `PAYOS_CHECKSUM_KEY`, `PAYOS_API_URL` (mặc định production URL). Thiếu cả ba khóa → PAYOS tắt (tạo payment trả 503), **không tự giả lập PAYOS**; khai dở khóa → từ chối khởi động. `NODE_ENV=production` có khóa payOS → từ chối khởi động tới khi giải quyết OQ-22. Secret chỉ ở API / worker.

### 2.4 Cổng thử (DEMO)
- Tái dùng simulator `/v1/dev/payment-gateway/*`: một trang có nút "Thanh toán thành công / thất bại" gọi webhook nội bộ
  có ký.
- Bật trên bản demo đã deploy qua cờ `PAYMENT_DEMO_ENABLED` (mặc định tắt ở production). **Rủi ro**: ai mở được trang thì
  đánh dấu đơn đã trả — chỉ bật ở môi trường không có tiền thật.
- Dev/test tự bật DEMO khi không có khóa payOS. Có khóa payOS thì DEMO tắt; khai cờ DEMO cùng khóa payOS bị từ chối. Route demo trả 404 khi cổng bị tắt. Callback demo có chữ ký và provider riêng, không xác nhận được payment PAYOS.
- Khi đã nạp khóa payOS, cả simulator VNPay/MoMo tự bật ở dev cũng bị tắt; adapter MoMo / VNPay vẫn nhận giao dịch mới nếu đã khai đủ khóa tương ứng. Không trộn khóa thật với cổng thử; MoMo / VNPay giữ URL sandbox tới khi giải quyết OQ-22.

### 2.5 Endpoint
- `POST /bookings/{id}/payments {provider: PAYOS | MOMO | VNPAY | DEMO}` → `transfer?` cho PAYOS, các cổng hosted trả `paymentUrl`.
- `POST /webhooks/payment/payos`: kiểm chữ ký → đẩy BullMQ (processor hiện có) → trả 200. Webhook thử của
  confirm-webhook **đã kiểm chữ ký** (orderCode không có trong DB) → 200, không tạo payment / vé. Sai chữ ký → 400; DB/queue chưa nhận bền vững → lỗi để gửi lại. Cổng thử dùng `POST /webhooks/payment/demo`.
- App hỏi trạng thái qua `GET /bookings/{id}` (đã có, khách vãng lai dùng `X-Booking-Token`).
- Đơn hết hạn (`booking-expiry`) → gọi hủy link payOS (best-effort). Tiền tới sau khi hủy/hết hạn → `RECONCILING`
  (`BOOKING_EXPIRED`) → hoàn thủ công.
- Đối soát cron 10 phút hiện có gọi `queryTransaction` cho payment PAYOS còn chờ.

### 2.6 Test bắt buộc (ADR-025)
- Vector chữ ký tạo link + webhook (đúng / sai / thiếu trường / null).
- Webhook trùng `reference` → idempotent; sai số tiền → `RECONCILING`; đơn hết hạn → `RECONCILING`.
- Webhook thử của confirm-webhook → 200; tiền luôn `BigInt`.
- Int test trên DB tạm; regenerate OpenAPI → client TS + Dart.

## 3. Thiết kế app hành khách

1. **Ưu đãi ở bước thông tin hành khách** (SCR-PSG-19): User đăng nhập mở ví từ `GET /me/vouchers` và chọn voucher `AVAILABLE`, hoặc nhập mã. Guest chỉ nhập mã. `POST /promotions/check` nhận đúng một `userVoucherId` hoặc `code` để lấy báo giá server; chọn/xem trước chưa giữ voucher. Tạo booking chỉ gửi tối đa một `userVoucherId` hoặc `promotionCode`; không cộng hai ưu đãi và không tự tính giảm tiền ở app.
   - Ví rỗng từ API giữ trạng thái rỗng ở cả tab Tài khoản và bước đặt vé, kể cả bản debug; dữ liệu mẫu chỉ còn trong preview/test, không thay cho dữ liệu ví thật.
2. **Màn chọn phương thức riêng** (SCR-PSG-20, `PaymentScreen`): bốn thẻ logo **payOS**, **MoMo**, **VNPay**, **DEMO**, đồng ý điều khoản / hạn giữ ghế / tóm tắt. Nút tiếp tục mở `PaymentCheckoutScreen`; màn chọn không chứa QR hoặc poll cổng. Chuyển qua lại không kéo dài hạn booking.
3. **Màn thanh toán riêng** (`PaymentCheckoutScreen`): tạo payment qua `TripBookingApi.startPayment(bookingId, provider)`, loading / lỗi / thử lại / kiểm trạng thái. Với payOS:
   - QR vẽ bằng `qr_flutter` từ `transfer.qrCode`; bên dưới là ngân hàng, số TK, tên TK, số tiền, nội dung CK, mỗi
     dòng có nút sao chép; đếm ngược tới `expiresAt`.
   - "Mở ứng dụng ngân hàng": danh sách ~10 app phổ biến (bundle tĩnh) → mở
     `https://dl.vietqr.io/pay?app=<appId>&ba=<số TK>@<mã NH>&am=<số tiền>&tn=<nội dung>&url=<checkoutUrl>`
     (`launchUrl`, `LaunchMode.externalApplication`). Mã NH suy từ `bin` bằng bảng tĩnh.
   - "Mở trang payOS": `checkoutUrl` trong trình duyệt (dự phòng: app không tự điền, muốn tải QR).
   - Hỏi trạng thái mỗi 4 giây khi màn đang mở và foreground + ngay khi app quay lại (`AppLifecycleState.resumed`). Chỉ booking `CONFIRMED` + payment `SUCCESS` + có vé → màn thành công/vé thật; hết hạn → báo đặt lại; `RECONCILING` → chờ xử lý, không hướng dẫn trả thêm.
4. **MoMo / VNPay / cổng thử**: màn thanh toán mở `paymentUrl` trong trình duyệt / giao diện cổng hỗ trợ → khi quay lại app thì hỏi trạng thái như trên; không xác nhận từ redirect. MoMo / VNPay cần khóa do Khanh tự điền, xem [RB-12 §3](../runbook/RB-12-payos.md#3-cấu-hình-momo--vnpay-sandbox).
5. **Quay về app**: v1 **không dựa vào `returnUrl`**. Khách tự chuyển lại app (nút Back / app switcher) → app hỏi
   trạng thái. `returnUrl` trỏ trang kết quả web Marketplace như hiện nay. App Links (về thẳng app) để sau (Q4).
6. Test widget / API (fake server): ví chỉ cho User, lọc AVAILABLE, chọn voucher / mã loại trừ nhau, quote server và request booking đúng ID/code; bốn thẻ logo; chuyển màn trước checkout; sao chép, mở URL / deeplink (mock launcher), poll → CONFIRMED + vé, hết hạn, lỗi mạng, resume, chặn nhấn lặp.

## 4. Thanh toán qua app ngân hàng / MoMo trên máy thật

### 4.1 Hai cách khách trả
| Cách | Khi nào | Luồng |
| --- | --- | --- |
| **Hai thiết bị** | Khách có máy khác hoặc trả bằng app trên máy khác | App ngân hàng/MoMo **quét QR** trên màn hình |
| **Cùng một máy** | Thường gặp nhất | "Mở ứng dụng ngân hàng" → `dl.vietqr.io` chuyển sang app ngân hàng, tự điền TK/số tiền/nội dung (tuỳ app hỗ trợ) → xác nhận → quay lại app VXN |

**Phân biệt MoMo và quét QR payOS:** chọn thẻ MoMo dùng adapter MoMo và `paymentUrl` của chính cổng đó. Thẻ payOS dùng VietQR / deeplink ngân hàng / trang payOS; chưa thêm plugin lưu ảnh hoặc deeplink ví. Khả năng quét QR payOS từ ảnh bằng từng ví cần thử trên máy thật; chưa tính là nghiệm thu. ZaloPay không phải phương thức của task này.

Khách **không được sửa nội dung chuyển khoản / số tiền**, nếu không payOS không khớp đơn → đơn treo → đối soát thủ công.
App ghi rõ cảnh báo này cạnh nút sao chép.

### 4.2 Cấu hình Android
- `AndroidManifest.xml` (`main`): thêm vào `<queries>`
  `<intent><action android:name="android.intent.action.VIEW"/><data android:scheme="https"/></intent>` để
  `canLaunchUrl` trả đúng trên Android 11+.
- Bản **debug** đã cho phép cleartext (`src/debug/AndroidManifest.xml`); bản release phải gọi API qua HTTPS.
- iOS (tuỳ chọn, cần Mac): link `https` không cần `LSApplicationQueriesSchemes`; chỉ cần nếu sau này dùng scheme riêng.

### 4.3 Các bước thử trên máy thật
1. **Tài khoản payOS** (Khanh tự làm): đăng ký my.payos.vn → xác thực → liên kết tài khoản ngân hàng nhận tiền → tạo
   kênh thanh toán → lấy Client ID / API Key / Checksum Key → ghi vào `apps/api/.env.development` (`.env` chọn `NODE_ENV=development`; không commit, không dán khóa vào chat).
2. **Webhook cần URL HTTPS công khai** tới backend local, ví dụ tunnel đã cài sẵn: `cloudflared tunnel --url http://localhost:3000`. Khai `https://<host>/v1/webhooks/payment/payos` trên my.payos.vn. Không tự cài tunnel / mở tài khoản trong task code. API + worker phải cùng chạy; đối soát định kỳ là dự phòng, không bảo đảm phản hồi tức thời hoặc giữ ghế qua hạn. Render chỉ chạy DEMO ở giai đoạn này, không nạp khóa payOS thật (OQ-22).
3. **Dữ liệu thử**: trên DB demo, tạo một chuyến giá nhỏ (vd 10.000 ₫/chỗ) để chuyển tiền thật số nhỏ.
4. **Build và cài**: bật USB debugging trên điện thoại →
   `flutter run --dart-define=API_BASE_URL=<URL>` với `<URL>` = IP LAN của máy dev (`http://192.168.x.x:3000`, cùng
   Wi-Fi) hoặc URL tunnel HTTPS. Port mặc định hiện tại là **3000**, không phải 3100.
5. **Kịch bản**: đặt vé → payOS → "Mở ứng dụng ngân hàng" → chuyển → quay lại app → thấy "Đã thanh toán". Lặp lại với
   MoMo (quét QR từ máy khác / từ ảnh). Thử thêm: chuyển sai số tiền, để đơn hết hạn rồi mới chuyển → kiểm đơn vào
   `RECONCILING` và hoàn thủ công qua Admin.

## 5. Thứ tự làm và tiêu chí xong

| # | Việc | Xong khi |
| --- | --- | --- |
| P0 | ADR-029 + cập nhật doc | Đã thêm Proposed / chờ duyệt; không tự promote |
| P1 | Migration enum + cột | Đã áp trên PostgreSQL tạm + cấp role app; chưa áp DB dùng chung |
| P2 | `PayosGateway` + env + wiring | Đã code; gateway test pass |
| P3 | Webhook payOS + hủy link khi hết hạn + đối soát | Đã code; int test dedup / sai tiền / hết hạn / RLS pass trên DB tạm |
| P4 | Cổng DEMO + cờ | Đã code; HTTP flow và callback tới xác nhận booking / vé có test pass |
| P5 | OpenAPI + client TS/Dart | Đã sinh OpenAPI/TS và Dart 7.25.0 + build_runner; typecheck pass, Dart analyze còn cảnh báo mã sinh tự động |
| M1–M3 | Chọn phương thức riêng, QR + deeplink + poll, cổng thử | Đã code; Flutter analyze không có issue, toàn bộ 265 Flutter tests pass sau bổ sung ví / tách màn / bốn cổng; chưa thử máy thật |
| M4 | Manifest `<queries>` + thử máy thật | Đã sửa manifest; **chưa thử máy thật / tiền thật** |
| M5 | Màn vé | Luồng hoàn tất đã dùng vé + QR thật từ server; tải PDF / lưu ảnh vẫn ngoài task |

**Bổ sung 31/10 — đã kiểm tra code:** chọn voucher từ ví cho User, bốn thẻ phương thức có logo và tách `PaymentScreen` khỏi `PaymentCheckoutScreen`; cấu hình MoMo / VNPay sandbox giữ nhóm env hiện có. Flutter analyze không có issue, 265 tests pass; backend lint/typecheck và 60 gateway/config tests pass (không gọi cổng ngoài). Khóa vẫn để Khanh tự điền; chưa nghiệm thu giao dịch hoặc thiết bị thật.

## 6. Rủi ro
- **OQ-22**: tiền thật vào tài khoản của Khanh không phải ví ký quỹ có giấy phép — chỉ thử số nhỏ, không mở cho người
  ngoài.
- Khách sửa nội dung/số tiền → không khớp → đối soát tay.
- Không phải app ngân hàng nào cũng tự điền qua `dl.vietqr.io`.
- Cổng DEMO bật nhầm ở môi trường có tiền thật.
- payOS không có sandbox riêng → test tự động dùng mock / DEMO; thử tay tiền thật chỉ local với giá trị nhỏ tới khi giải quyết OQ-22.

## 7. Lựa chọn áp dụng khi hiện thực 31/10 (tài liệu vẫn chờ duyệt)
- **Q1**: Theo yêu cầu mới cùng ngày, VNPay/MoMo là phương thức có thể chọn cho giao dịch mới cùng payOS/DEMO; không xóa dữ liệu cũ.
- **Q2**: Có cờ DEMO trên môi trường production chỉ dữ liệu mẫu, mặc định tắt; không kết hợp khóa payOS thật.
- **Q3**: `orderCode` từ sequence PostgreSQL không tái sử dụng.
- **Q4**: Quay lại app thủ công + poll/resume; App Links để sau.
- **Q5**: Không thêm plugin lưu ảnh QR; dùng QR hiển thị / trang hosted.
- **Q6**: Chưa cài tunnel hoặc deploy; runbook hướng dẫn tunnel tới API local khi thử thật. Khóa payOS production đang bị chặn bởi OQ-22.

Nguồn: payos.vn/docs/api, payos.vn/docs/tich-hop-webhook/kiem-tra-du-lieu-voi-signature, vietqr.io (deeplink app ngân
hàng), api.vietqr.io/v2/android-app-deeplinks.
