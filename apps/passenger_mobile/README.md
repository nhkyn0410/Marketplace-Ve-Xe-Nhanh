# Passenger Mobile

Ứng dụng Flutter cho hành khách Vé Xe Nhanh. Android là nền tảng demo chính của v1.

## Chạy local với Google Sign-In

1. Trong Google Cloud, tạo OAuth client Android cho package
   `com.vexenhanh.passenger_mobile` và khai SHA-1/SHA-256 của keystore đang dùng.
2. Tạo OAuth client loại **Web application**. Đặt ID/secret của client này vào
   `apps/api/.env` dưới tên `GOOGLE_CLIENT_ID` và `GOOGLE_CLIENT_SECRET`.
3. Chạy app bằng đúng Web client ID ở bước 2 (client ID không phải secret):

```powershell
.\.fvm\flutter_sdk\bin\flutter.bat run `
  --dart-define=API_BASE_URL=http://10.0.2.2:3000 `
  --dart-define=GOOGLE_SERVER_CLIENT_ID=<WEB_OAUTH_CLIENT_ID>
```

Thiết bị Android thật dùng IP LAN của máy chạy API, hoặc `adb reverse tcp:3000 tcp:3000`
rồi đặt `API_BASE_URL=http://127.0.0.1:3000`.

iOS là nền tảng tùy chọn của v1. Khi build iOS, truyền thêm
`GOOGLE_IOS_CLIENT_ID` và khai URL scheme đảo ngược của iOS client trong
`ios/Runner/Info.plist` theo hướng dẫn của `google_sign_in_ios`.
