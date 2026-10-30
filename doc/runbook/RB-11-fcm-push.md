---
id: RB-11
title: Bật push FCM cho app hành khách trên production
match:
  - FIREBASE_API_KEY
  - FCM_PRIVATE_KEY
---

# RB-11 — Bật push FCM (app hành khách + API trên Render)

**Mục đích:** app hành khách nhận thông báo đẩy (đặt vé, hủy vé, hoàn tiền…). API gửi qua Firebase Cloud Messaging (ADR-020/028); app đăng ký token ở `POST /v1/me/push-devices` sau khi đăng nhập.
**Điều kiện:** tài khoản Google; quyền sửa env của service API trên Render; file `apps/passenger_mobile/.env.production` (gitignored).

## Các bước

1. **Tạo dự án Firebase:** vào https://console.firebase.google.com → *Add project* (vd `vexenhanh`). Không cần Google Analytics.
2. **Thêm app Android:** *Project settings → General → Add app → Android*, package name `com.vexenhanh.passenger_mobile`. Bỏ qua bước tải `google-services.json` và thêm SDK (app khởi tạo Firebase bằng biến môi trường).
3. **Lấy cấu hình cho app** (*Project settings → General → Your apps → app Android*) rồi thêm vào `apps/passenger_mobile/.env.production`:
   ```
   FIREBASE_API_KEY=<Web API key, dạng AIza...>
   FIREBASE_APP_ID=<Mobile SDK app ID, dạng 1:123...:android:abc...>
   FIREBASE_MESSAGING_SENDER_ID=<Project number>
   FIREBASE_PROJECT_ID=<Project ID>
   ```
4. **Tạo khóa cho API:** *Project settings → Service accounts → Generate new private key* → tải file JSON. **Không commit, không gửi qua chat.**
5. **Điền env API trên Render** (service API, và worker nếu chạy riêng): lấy từ file JSON
   - `FCM_PROJECT_ID` = `project_id`
   - `FCM_CLIENT_EMAIL` = `client_email`
   - `FCM_PRIVATE_KEY` = `private_key` (dán nguyên chuỗi, giữ các ký tự `\n`)
   Lưu → Render tự deploy lại. Khai thiếu 1 trong 3 biến thì API từ chối khởi động (cố ý).
6. **Build lại app:** `flutter build apk --release --dart-define-from-file=.env.production` (hoặc `--debug` để thử), cài lên máy.

## Kiểm tra

- Đăng nhập app → máy hỏi quyền thông báo → cho phép. Sau khi có sự kiện (đặt / hủy vé), nhật ký gửi xem ở `GET /v1/me/notifications` (kênh `PUSH`, trạng thái `SENT`).
- Gửi thử ở *Firebase Console → Messaging → New campaign → Send test message* với token (xem log `flutter run`), hoặc đặt / hủy một vé.
- App đang mở: thông báo hiện thành thanh báo trong app; app ở nền: hiện ở khay hệ thống, chạm vào mở tab Hành trình.

## Hay lỗi

- Không hỏi quyền / không có token: bản build thiếu một trong 4 biến `FIREBASE_*` (app tự tắt push, không báo lỗi).
- API không lên sau khi điền env: thiếu một trong 3 biến `FCM_*`, hoặc `FCM_PRIVATE_KEY` bị mất `-----BEGIN/END PRIVATE KEY-----`.
- Đã gửi nhưng máy không nhận: hành khách tắt kênh push ở *Tài khoản → Cài đặt thông báo*, hoặc tắt thông báo của app trong cài đặt Android.
- Lộ file JSON khóa dịch vụ: vào *Service accounts* xóa khóa đó, tạo khóa mới, cập nhật Render.
