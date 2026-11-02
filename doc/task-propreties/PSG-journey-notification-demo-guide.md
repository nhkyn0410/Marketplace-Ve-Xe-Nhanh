# Chạy thử thông báo hành trình — Android

Ngày: 03/11/2026. Chỉ bản demo nội bộ, chưa nghiệm thu thiết bị thật; không phải GPS hành khách/xe.

Đã bật cờ trong `apps/api/.env.development` và `apps/passenger_mobile/.env.local` trên máy hiện tại (file local không commit). Cần khởi động lại API/worker và chạy lại Flutter nếu chúng đang chạy bản cũ. APK debug đã build tại `apps/passenger_mobile/build/app/outputs/flutter-apk/app-debug.apk`.

## Cấu hình

1. API và worker dùng cùng DB/Redis/Firebase. Đặt `JOURNEY_DEMO_ENABLED=true`, `NODE_ENV=development` (hoặc test); production luôn trả 404 cho API demo.
2. Cấu hình FCM server theo RB-11: `FCM_PROJECT_ID`, `FCM_CLIENT_EMAIL`, `FCM_PRIVATE_KEY`. Không commit khóa.
3. Trong file cấu hình build Flutter đang dùng, thêm `JOURNEY_DEMO_ENABLED=true`; giữ các `FIREBASE_*` và `API_BASE_URL` hiện có. Không cần cấu hình iOS hay quyền GPS.
4. Khởi động API (`pnpm --filter @vexenhanh/api dev`) và worker (`pnpm --filter @vexenhanh/api dev:worker`).
5. Chạy app từ `apps/passenger_mobile`, ví dụ `flutter run --dart-define-from-file=.env.development --dart-define=JOURNEY_DEMO_ENABLED=true`. Dùng file cấu hình thật của máy; tắt hẳn rồi chạy lại để đổi dart-define.

## Luồng demo

Đăng nhập Passenger → Hành trình → mở chi tiết đơn **CONFIRMED** của mình → **Mô phỏng hành trình** → **Chạy thử hành trình** → cấp quyền thông báo nếu được hỏi. Sau đó về Home hoặc khóa màn hình.

Một phiên dài khoảng 3 phút, nhận mốc mới mỗi 30 giây từ worker; đến nơi ở giây 180 và gỡ ở giây 210. Thông báo hiển thị thời gian còn lại, tuyến, tiến độ, nhận diện logo và tỉnh đang đi qua. Tỉnh được mô phỏng từ các điểm dừng trong chặng đã đặt. Chạm thông báo mở đúng đơn sau xác thực. **Dừng mô phỏng** hoặc đăng xuất tắt thẻ và chặn update muộn. Một thiết bị có một phiên đang chạy.

Android 16 dùng ProgressStyle khi hỗ trợ; máy cũ dùng thanh tiến độ chuẩn. Logo màu ở vị trí large icon và mark đơn sắc ở small icon; vị trí hiển thị phụ thuộc template Android. Không ép Figma bằng RemoteViews. Nội dung màn hình khóa có thể bị Android ẩn theo cài đặt riêng tư của người dùng.

## API và payload

- `POST /v1/me/journey-demo`: `{bookingId, deviceId}` → 201 snapshot.
- `GET /v1/me/journey-demo?deviceId=...` → snapshot hoặc null.
- `DELETE /v1/me/journey-demo/{sessionId}` → 204.
- FCM data-only: `{type:'journey_demo', snapshot:'<JSON snapshot>'}`. Không gửi kèm notification title/body để tránh hai thẻ.
- Chỉ Passenger sở hữu booking và FCM device active được dùng. Không dùng Guest booking token, không thay đổi trạng thái chuyến/vé và không cần migration DB.

## Kiểm chứng và giới hạn

- Backend: types/API typecheck, lint; 40 test service/sender/env và 15 test regression liên quan đã pass (hai lượt có test trùng nhau); thêm 2 test schema chống lỗi numeric enum của Dart generator.
- Integration mới: 4/4 pass, không skip, PostgreSQL 16 + Redis thật, role `vexenhanh_app`, kiểm RLS sạch; queue và FCM mock. Kiểm isolation, quyền booking/device, tỉnh, dedup, stop, thu hồi device và không thay trạng thái booking/trip/ticket. Dùng DB/container riêng, đã dọn fixture/Redis key và container tạm.
- Plugin: 2 test Flutter MethodChannel và 5 test Kotlin pass; plugin analyze và compile Kotlin pass.
- App: bộ test đầy đủ 351/351 pass; sau bổ sung dọn thẻ khi mất push cuối, 12 test service/API liên quan pass. `flutter analyze` không issue và APK debug build thành công. OpenAPI, TS/Dart client đã sinh lại; nguồn Dart khớp generator v7.25.0 sau chuẩn hóa định dạng.
- Chưa chứng minh trên điện thoại thật: chưa có thiết bị Android/AVD kết nối; cần Passenger có booking, cấu hình FCM và server/worker đang chạy để nghiệm thu màn hình khóa.
- Cần kiểm lại: Android 16 promoted, máy cũ fallback, mất mạng, từ chối quyền, mở từ trạng thái process đã bị OS thu hồi. Force stop trong Settings có thể chặn FCM tới khi mở lại app.
- Chưa chạy review độc lập, chưa commit/push/deploy. Không dùng kết quả demo làm bằng chứng tính năng GPS thật.

## Khi không thấy thông báo

- Khối demo không hiện: kiểm tra build Android có dart-define, đã đăng nhập và mở chi tiết đơn của tài khoản.
- API 404: kiểm tra cờ của API và worker; không chạy production.
- Báo cần quyền/Firebase: cấp quyền thông báo và kiểm tra cấu hình build; không dán token vào log/chat.
- Chỉ có mốc đầu: kiểm tra worker, Redis, cấu hình FCM và kết nối Internet; app không tự chạy Timer nền để che lỗi worker.
- Đã vuốt bỏ thẻ: mở app và chủ động chạy lại; native không tự hồi sinh thông báo đã bị tắt. Phiên hết hạn tự ngừng gửi.
