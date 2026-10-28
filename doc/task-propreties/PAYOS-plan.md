# Kế hoạch triển khai payOS (API + app hành khách) — chờ duyệt

> Trạng thái: **Draft — chờ Khanh duyệt** (AI soạn 27/10/2026, chưa review). Nguồn quyết định: Khanh 21/10/2026 chọn
> payOS (VietQR, tiền thật số nhỏ) + cổng thử nội bộ thay VNPay/MoMo; Figma SCR-PSG-20 (1444:13055, 1450:23099) vẽ lại
> 26/10. Cần ADR mới thay một phần ADR-019 trước khi code.

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
| Hoàn tiền | **Không có API** | Hoàn bằng luồng hoàn thủ công đã có (`MANUAL_REFUND`) |

Cần xác minh khi có tài khoản (tài liệu không ghi rõ): danh sách đủ của `status` (thấy `PENDING`, `CANCELLED`; còn
`PAID`/`EXPIRED`… lấy từ SDK `@payos/node` hoặc thử thật), tham số payOS gắn vào `returnUrl`, giới hạn `orderCode`,
có sandbox hay chỉ live, số tiền tối thiểu. `description` tối đa 25 ký tự, **chỉ 9 ký tự** nếu tài khoản ngân hàng
không liên kết qua payOS.

## 2. Thiết kế API

### 2.1 Tài liệu trước (Khanh duyệt)
- **ADR-029** "Thanh toán v1: payOS (VietQR) + cổng thử nội bộ", thay phần cổng của ADR-019; giữ `EscrowLedger`
  in-house, đối soát cron, hoàn thủ công. OQ-22 (TGTT) giữ nguyên là production-blocker.
- Cập nhật 04 DB, 05 API, 07 Security, 08 Test, 11 Task, PROJECT-STATE — tất cả "chờ duyệt".

### 2.2 Dữ liệu (migration)
- `PaymentProvider` thêm `PAYOS`, `DEMO` (giữ `VNPAY`/`MOMO` tới khi dọn dữ liệu dev — xem câu hỏi Q1).
- `Payment` thêm `providerOrderCode BIGINT UNIQUE NULL` (payOS bắt buộc số nguyên; `paymentCode` `PAY…` hiện tại là
  chuỗi) — sinh từ sequence Postgres, và `checkout JSONB NULL` (bin, số TK, tên TK, nội dung CK, `qrCode`).
- Dedup webhook giữ `@@unique([provider, providerTxnId])` với `providerTxnId = data.reference`.

### 2.3 Adapter `external/payment/payos/` (cùng mẫu VNPay/MoMo, viết tay bằng `fetch`, không thêm SDK)
- `createCheckout`: ký → gọi tạo link → **kiểm chữ ký phản hồi** → trả `paymentUrl = checkoutUrl` + `transfer`
  (qrCode, bin, accountNumber, accountName, amount, description **lấy từ phản hồi**, không phải từ request).
- `verifyCallback`: kiểm chữ ký webhook; `success && data.code == "00"` mới là thành công.
- `queryTransaction`: `GET /v2/payment-requests/{orderCode}` → map `PAID`→SUCCESS, `CANCELLED`/`EXPIRED`→FAILED, …
- `refund`: ném `PaymentGatewayError(retryable=false)` → luồng hoàn thủ công.
- Port `CheckoutRequest` thêm `cancelUrl`, `orderCode`; kết quả `createCheckout` thêm `transfer?` (tuỳ chọn).
- Env: `PAYOS_CLIENT_ID`, `PAYOS_API_KEY`, `PAYOS_CHECKSUM_KEY`, `PAYOS_API_URL` (mặc định production URL). Thiếu khóa ở
  dev → cổng giả lập như hiện nay; thiếu ở production → 503.

### 2.4 Cổng thử (DEMO)
- Tái dùng simulator `/v1/dev/payment-gateway/*`: một trang có nút "Thanh toán thành công / thất bại" gọi webhook nội bộ
  có ký.
- Bật trên bản demo đã deploy qua cờ `PAYMENT_DEMO_ENABLED` (mặc định tắt ở production). **Rủi ro**: ai mở được trang thì
  đánh dấu đơn đã trả — chỉ bật ở môi trường không có tiền thật.

### 2.5 Endpoint
- `POST /bookings/{id}/payments {provider: PAYOS | DEMO}` → thêm `transfer` cho PAYOS.
- `POST /webhooks/payment/payos`: kiểm chữ ký → đẩy BullMQ (processor hiện có) → trả 200. Webhook thử của
  confirm-webhook (orderCode không có trong DB) → 200 + log, không lỗi.
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

1. **Chọn phương thức** (SCR-PSG-20): "Chuyển khoản VietQR qua payOS" / "Cổng thanh toán thử (demo)" — thay nút khóa
   "Thanh toán (sắp mở)" ở `payment_screen.dart`. API: `TripBookingApi.startPayment(bookingId, provider)`.
2. **Màn chuyển khoản payOS**:
   - QR vẽ bằng `qr_flutter` từ `transfer.qrCode`; bên dưới là ngân hàng, số TK, tên TK, số tiền, nội dung CK, mỗi
     dòng có nút sao chép; đếm ngược tới `expiresAt`.
   - "Mở ứng dụng ngân hàng": danh sách ~10 app phổ biến (bundle tĩnh) → mở
     `https://dl.vietqr.io/pay?app=<appId>&ba=<số TK>@<mã NH>&am=<số tiền>&tn=<nội dung>&url=<returnUrl>`
     (`launchUrl`, `LaunchMode.externalApplication`). Mã NH suy từ `bin` bằng bảng tĩnh.
   - "Mở trang payOS": `checkoutUrl` trong trình duyệt (dự phòng: app không tự điền, muốn tải QR).
   - Hỏi trạng thái mỗi 4 giây khi màn đang mở + ngay khi app quay lại foreground (`AppLifecycleState.resumed`).
     `PAID` → màn thành công/vé; hết hạn → báo đặt lại.
3. **Cổng thử**: mở `paymentUrl` trong trình duyệt → khi quay lại app thì hỏi trạng thái như trên.
4. **Quay về app**: v1 **không dựa vào `returnUrl`**. Khách tự chuyển lại app (nút Back / app switcher) → app hỏi
   trạng thái. `returnUrl` trỏ trang kết quả web Marketplace như hiện nay. App Links (về thẳng app) để sau (Q4).
5. Test widget (fake API): chọn phương thức, sao chép, mở deeplink (mock launcher), poll → PAID, hết hạn, lỗi mạng.

## 4. Thanh toán qua app ngân hàng / MoMo trên máy thật

### 4.1 Hai cách khách trả
| Cách | Khi nào | Luồng |
| --- | --- | --- |
| **Hai thiết bị** | Khách có máy khác hoặc trả bằng app trên máy khác | App ngân hàng/MoMo **quét QR** trên màn hình |
| **Cùng một máy** | Thường gặp nhất | "Mở ứng dụng ngân hàng" → `dl.vietqr.io` chuyển sang app ngân hàng, tự điền TK/số tiền/nội dung (tuỳ app hỗ trợ) → xác nhận → quay lại app VXN |

**MoMo / ZaloPay**: không có trong danh sách deeplink VietQR (35 app, chỉ ngân hàng). MoMo vẫn trả được VietQR (chuyển
tới ngân hàng qua NAPAS) nhưng phải **quét QR**: trên cùng máy thì lưu ảnh QR rồi trong MoMo chọn "Quét mã → ảnh từ thư
viện". Lưu ảnh cần thêm plugin (vd `gal`) — **dependency mới, chờ Khanh duyệt (Q5)**; nếu không thêm, dùng "Mở trang
payOS" để tải QR, hoặc chụp màn hình.

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
   kênh thanh toán → lấy Client ID / API Key / Checksum Key → ghi vào `apps/api/.env` (không commit, không dán vào chat).
2. **Webhook cần URL HTTPS công khai**: (a) deploy API lên Render, hoặc (b) tunnel từ máy dev tới `localhost:3100`
   (vd `cloudflared tunnel --url http://localhost:3100` — công cụ mới, chờ duyệt Q6). Khai
   `https://<host>/v1/webhooks/payment/payos` trên my.payos.vn. Không có webhook thì cron đối soát vẫn chốt đơn, chậm
   tối đa ~10 phút.
3. **Dữ liệu thử**: trên DB demo, tạo một chuyến giá nhỏ (vd 10.000 ₫/chỗ) để chuyển tiền thật số nhỏ.
4. **Build và cài**: bật USB debugging trên điện thoại →
   `flutter run --dart-define=API_BASE_URL=<URL>` với `<URL>` = IP LAN của máy dev (`http://192.168.x.x:3100`, cùng
   Wi-Fi) hoặc URL tunnel/Render HTTPS.
5. **Kịch bản**: đặt vé → payOS → "Mở ứng dụng ngân hàng" → chuyển → quay lại app → thấy "Đã thanh toán". Lặp lại với
   MoMo (quét QR từ máy khác / từ ảnh). Thử thêm: chuyển sai số tiền, để đơn hết hạn rồi mới chuyển → kiểm đơn vào
   `RECONCILING` và hoàn thủ công qua Admin.

## 5. Thứ tự làm và tiêu chí xong

| # | Việc | Xong khi |
| --- | --- | --- |
| P0 | ADR-029 + cập nhật doc (chờ duyệt) | Khanh duyệt hướng |
| P1 | Migration enum + cột | `prisma migrate` sạch, int test cũ pass |
| P2 | `PayosGateway` + env + wiring | Unit test vector chữ ký pass |
| P3 | Webhook payOS + hủy link khi hết hạn + đối soát | Int test dedup / sai tiền / hết hạn pass |
| P4 | Cổng DEMO + cờ | E2E: tạo payment DEMO → bấm thành công → booking PAID |
| P5 | OpenAPI + client TS/Dart | CI contract pass |
| M1–M3 | Chọn phương thức, màn payOS (QR + deeplink + poll), cổng thử | Widget test pass; máy ảo chạy hết luồng DEMO |
| M4 | Manifest `<queries>` + thử máy thật | Một giao dịch thật số nhỏ chốt PAID |
| M5 | Màn vé (`qr_flutter` QR vé) | Bước tiếp theo, tách task |

## 6. Rủi ro
- **OQ-22**: tiền thật vào tài khoản của Khanh không phải ví ký quỹ có giấy phép — chỉ thử số nhỏ, không mở cho người
  ngoài.
- Khách sửa nội dung/số tiền → không khớp → đối soát tay.
- Không phải app ngân hàng nào cũng tự điền qua `dl.vietqr.io`.
- Cổng DEMO bật nhầm ở môi trường có tiền thật.
- payOS có thể chỉ có môi trường live (chưa xác minh) → test tự động dùng giả lập, chỉ thử tay với tiền thật.

## 7. Câu hỏi cần Khanh chốt
- **Q1**: Xóa hẳn adapter VNPay/MoMo khỏi code, hay giữ tắt tới khi dọn dữ liệu?
- **Q2**: Cho bật cổng DEMO trên bản deploy (qua cờ)?
- **Q3**: `orderCode` sinh từ sequence Postgres (đề xuất) hay số ngẫu nhiên?
- **Q4**: v1 quay lại app thủ công + poll (đề xuất), hay làm App Links ngay (cần domain + `assetlinks.json`)?
- **Q5**: Thêm plugin lưu ảnh QR (cho MoMo cùng máy)?
- **Q6**: Dùng tunnel (cloudflared) để thử webhook từ máy dev, hay chỉ thử trên Render?

Nguồn: payos.vn/docs/api, payos.vn/docs/tich-hop-webhook/kiem-tra-du-lieu-voi-signature, vietqr.io (deeplink app ngân
hàng), api.vietqr.io/v2/android-app-deeplinks.
