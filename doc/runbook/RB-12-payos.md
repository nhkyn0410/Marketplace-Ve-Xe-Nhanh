---
id: RB-12
title: Cấu hình payOS, MoMo, VNPay và cổng DEMO cho ứng dụng hành khách
match:
  - payOS
  - PAYOS_CLIENT_ID
  - MOMO_PARTNER_CODE
  - VNPAY_TMN_CODE
  - PAYMENT_DEMO_ENABLED
---

# RB-12 — Thanh toán payOS / MoMo / VNPay / DEMO

**Mục đích:** cấu hình các phương thức thanh toán hành khách và thử luồng từ tạo đơn tới vé được server phát hành. Màn chọn phương thức hiển thị thẻ logo payOS, MoMo, VNPay và cổng DEMO; chọn xong mới tới màn thanh toán riêng (QR / trang cổng).
**Điều kiện:** PostgreSQL / Redis sẵn sàng, migration đã áp và đã cấp quyền role app theo [RB-02](RB-02-prisma-migration.md); client TS/Dart sinh theo [RB-04](RB-04-api-client.md).

payOS [không có sandbox riêng](https://payos.vn/docs/moi-truong-test/). Khóa thật chỉ dùng ở backend local trước khi giải quyết OQ-22; `NODE_ENV=production` có khóa PAYOS sẽ bị từ chối khởi động. Cổng DEMO không có tiền thật.

## 1. Thử DEMO trước

1. Trong `apps/api/.env`, chọn `NODE_ENV=development`. Trong `apps/api/.env.development`, để trống cả ba `PAYOS_CLIENT_ID`, `PAYOS_API_KEY`, `PAYOS_CHECKSUM_KEY`. DEMO tự bật ở dev/test khi không có khóa payOS.
2. Đặt `BETTER_AUTH_URL` là origin API mà trình duyệt trên điện thoại mở được, không kèm `/v1`; đây cũng là gốc link DEMO. Với USB + `adb reverse`, có thể dùng `http://127.0.0.1:3000`.
3. Chạy ở hai terminal từ root repo:

   ```powershell
   pnpm --filter @vexenhanh/api dev
   ```

   ```powershell
   pnpm --filter @vexenhanh/api dev:worker
   ```

4. Với Android cắm USB, chạy `adb reverse tcp:3000 tcp:3000`. Tại `apps/passenger_mobile`, chạy:

   ```powershell
   fvm flutter run --dart-define=API_BASE_URL=http://127.0.0.1:3000
   ```

5. Đặt vé → tại màn chọn phương thức chọn **Cổng thanh toán thử (demo)** → tiếp tục sang màn thanh toán riêng → mở trang thử → chọn thành công / thất bại → quay lại app. App kiểm trạng thái với server; chỉ mở hoàn tất sau khi booking `CONFIRMED`, payment `SUCCESS` và đã có vé. Chuyển màn không kéo dài hạn giữ ghế.

## 2. Cấu hình payOS local

1. Đăng ký trên [my.payos.vn](https://my.payos.vn), xác thực, liên kết ngân hàng và [tạo kênh thanh toán](https://payos.vn/docs/huong-dan-su-dung/kenh-thu/tao-kenh-thanh-toan/). Tự lưu khóa, không gửi vào chat.
2. Điền vào `apps/api/.env.development` và khởi động lại **API lẫn worker**:

   ```dotenv
   PAYOS_CLIENT_ID=<client-id>
   PAYOS_API_KEY=<api-key>
   PAYOS_CHECKSUM_KEY=<checksum-key>
   PAYOS_API_URL=https://api-merchant.payos.vn
   PAYMENT_DEMO_ENABLED=false
   PAYMENT_RETURN_BASE_URL=<origin-web-marketplace>
   ```

   Khóa chỉ ở backend; không đưa vào Flutter. Có khóa payOS thì DEMO và simulator VNPay/MoMo tự bật ở dev đều tắt. Khai thiếu một khóa hoặc bật DEMO cùng khóa payOS sẽ lỗi cấu hình.
3. Webhook cần HTTPS công khai tới API local. Nếu đã cài `cloudflared`, có thể chạy:

   ```powershell
   cloudflared tunnel --url http://localhost:3000
   ```

4. Trong kênh thanh toán payOS, khai `https://<host-tunnel>/v1/webhooks/payment/payos`. Khi URL tunnel đổi, cập nhật lại. Webhook hợp lệ nhận 200; payload thử không có đơn không tạo payment/vé. Chữ ký sai nhận 400.
5. Đặt chuyến thử trên dữ liệu local với giá trị nhỏ, ví dụ 10.000 ₫; chọn payOS → quét QR / mở ngân hàng / mở trang payOS → chuyển đúng số tiền và nội dung → quay lại app. Mức ví dụ không phải khẳng định số tiền tối thiểu của payOS.

`PAYMENT_RETURN_BASE_URL` là gốc web Marketplace nhận trình duyệt quay về, khác webhook. Đặt origin web mà điện thoại truy cập được. App không tin query trên trang quay về; app poll mỗi 4 giây khi đang mở/foreground và kiểm lại khi resume. Nếu tạo link mất phản hồi rồi được phục hồi, API có thể chỉ trả link hosted, không có QR; dùng **Mở trang payOS**.

## 3. Cấu hình MoMo / VNPay sandbox

Các biến dưới đây đã có trong `apps/api/.env.example`. Điền khóa ở `apps/api/.env.development` rồi khởi động lại API và worker. Không chép khóa vào `.env` của Flutter hoặc `--dart-define`; app chỉ cần `API_BASE_URL` để gọi backend.

**MoMo:** điền đủ cả ba khóa thử nghiệm do MoMo cấp; `MOMO_ENDPOINT` là origin, adapter tự nối `/v2/gateway/api/create`.

```dotenv
MOMO_PARTNER_CODE=<partner-code>
MOMO_ACCESS_KEY=<access-key>
MOMO_SECRET_KEY=<secret-key>
MOMO_ENDPOINT=https://test-payment.momo.vn
```

Backend gửi `ipnUrl = {BETTER_AUTH_URL}/v1/webhooks/payment/momo` (POST) và `redirectUrl = {PAYMENT_RETURN_BASE_URL}/bookings/{bookingId}/payment/result` khi tạo giao dịch. `BETTER_AUTH_URL` cần là HTTPS công khai nếu nhận IPN từ MoMo. Tham khảo [Collection Link](https://developers.momo.vn/v3/docs/payment/api/collection-link/) và [Payment Notification](https://developers.momo.vn/v3/docs/payment/api/result-handling/notification/).

**VNPay:** điền Terminal ID và Secret Key thử nghiệm do VNPay cấp, giữ URL sandbox mặc định:

```dotenv
VNPAY_TMN_CODE=<terminal-id>
VNPAY_HASH_SECRET=<secret-key>
VNPAY_PAYMENT_URL=https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
VNPAY_API_URL=https://sandbox.vnpayment.vn/merchant_webapi/api/transaction
```

Khai IPN **GET** `{BETTER_AUTH_URL}/v1/webhooks/payment/vnpay` trên cấu hình merchant VNPay. Backend gửi `vnp_ReturnUrl = {PAYMENT_RETURN_BASE_URL}/bookings/{bookingId}/payment/result`. IPN và trang quay về là hai địa chỉ khác chức năng; chỉ kết quả đã xác thực tại backend được xác nhận tiền. Xem [hướng dẫn kết nối VNPay](https://sandbox.vnpayment.vn/apis/docs/thanh-toan-pay/pay.html).

`BETTER_AUTH_URL` là origin API, `PAYMENT_RETURN_BASE_URL` là origin web Marketplace mà điện thoại mở được; không kèm `/v1` hoặc đường dẫn kết quả khi điền hai biến này. Khai thiếu một phần nhóm khóa sẽ lỗi cấu hình. Dev/test không có khóa MoMo/VNPay và không có khóa payOS thì dùng simulator trong API; có khóa payOS thì các fallback này tắt. Production thiếu khóa thì cổng tương ứng không khả dụng. Thẻ logo trên app không đồng nghĩa cổng đã có khóa hoặc đã được thử giao dịch thật. OQ-22 vẫn yêu cầu dùng sandbox cho MoMo/VNPay.

## 4. Voucher khi đặt vé

Hành khách đã đăng nhập có thể mở **Ví voucher** ở bước thông tin hành khách, chọn một voucher `AVAILABLE`, hoặc nhập mã khuyến mãi. App kiểm điều kiện/giảm giá qua server trước khi hiện tổng tiền. Khách vãng lai chỉ nhập mã. Tối đa một `userVoucherId` hoặc `promotionCode` được gửi khi tạo booking; chọn/xem trước không giữ lượt voucher, server mới giữ khi tạo booking thành công. Ví thật rỗng thì cả tab Tài khoản và bước đặt vé đều hiển thị rỗng, kể cả bản debug; vẫn có thể nhập mã hoặc tiếp tục không ưu đãi.

## 5. Kiểm tra

- Chỉ một lần nhận tiền / phát hành vé khi gửi webhook lặp.
- Hết hạn booking không được gia hạn khi chuyển sang payOS; tiền đến muộn / sai số tiền vào `RECONCILING`, không phát hành vé hoặc yêu cầu khách trả thêm.
- Có thể xem kết quả qua `GET /v1/bookings/{id}` (khách vãng lai dùng `X-Booking-Token`). Hoàn tiền payOS dùng luồng thủ công.
- Thử riêng voucher từ ví / mã nhập; đổi lựa chọn phải bỏ ưu đãi cũ và lấy lại báo giá server, không cộng hai ưu đãi. Kiểm tra màn chọn phương thức và màn thanh toán là hai bước riêng.
- Không dán khóa, chữ ký hoặc dữ liệu ngân hàng thật vào log / báo cáo kiểm thử.

## 6. Khi dùng bản demo đã deploy

Chỉ bật `PAYMENT_DEMO_ENABLED=true` trên môi trường **dữ liệu mẫu, không có tiền thật**, để trống khóa PAYOS. Cổng DEMO mặc định tắt trên production và route thử trả 404 khi tắt. Không bật production payOS tới khi giải quyết OQ-22.

API và worker phải cùng DB, Redis, `BULLMQ_PREFIX` và cấu hình cổng. Manifest Render hiện chỉ bật API, worker chưa được deploy; webhook nhận thành công mà worker không chạy thì booking chưa thể hoàn tất. Xem [RB-07](RB-07-render-deploy.md).

**Lỗi hay gặp:** PAYOS trả 503 vì chưa cấu hình; trang DEMO 404 do cổng tắt; điện thoại không mở link `localhost` do thiếu `adb reverse` / origin API không truy cập được; booking còn chờ do worker hoặc Redis lỗi; QR hết hạn hoặc sai số tiền/nội dung cần đối soát, không tự xác nhận từ giao diện.

**Liên quan:** [PAYOS-plan](../task-propreties/PAYOS-plan.md), ADR-029 (Proposed), [API payOS](https://payos.vn/docs/api/).
