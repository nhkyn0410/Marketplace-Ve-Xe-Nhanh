# TASK-FND-009 — Guide thao tác: dựng 2 app Flutter

> Làm theo thứ tự. Lệnh chạy ở **repo root** `C:\Code\Ve_Xe_Nhanh` (PowerShell) trừ khi ghi khác.
> Todo/phạm vi: `FND-009-todo.md`. Nghiệm thu: `FND-009-verification-checklist.md`.
> Môi trường đo 14/09/2026: Flutter **3.47.2** stable · Dart **3.13.2** · `flutter doctor` no issues.

## 0. Tiền đề

```powershell
flutter doctor
```

Cần `[√] Flutter`, `[√] Android toolchain`. `[√] Xcode` chỉ cần nếu định build iOS — **thiết bị iOS không thay được máy Mac**, iPhone chỉ cài được bản đã build.

Bản vá đường dẫn đã có sẵn từ commit `af3ec7a` (`.gitignore` + `pnpm-workspace.yaml`) — không phải làm lại.

---

## 1. Tạo 2 app

Thư mục dùng `snake_case` **trùng với tên package Dart** (quyết định 14/09/2026), nên gọi thẳng được — không cần `--project-name`:

```powershell
flutter create --org com.vexenhanh --project-name passenger_mobile --platforms android,ios --empty apps/passenger_mobile
```

```powershell
flutter create --org com.vexenhanh --project-name employee_mobile --platforms android,ios --empty apps/employee_mobile
```

`--empty` bỏ app đếm số mẫu. `--platforms android,ios` bỏ web/desktop cho gọn.

**Kiểm ngay** — bản vá `.gitignore` có ăn không (đây là điểm dễ hỏng nhất):

```powershell
git check-ignore -v apps/passenger_mobile/android/app/src/main/AndroidManifest.xml
```

Phải **không in ra gì** (exit 1) — nghĩa là file KHÔNG bị ignore. Nếu nó in ra một dòng rule thì `.gitignore` đang nuốt `android/`, mà với Flutter đó là **source phải commit** (`AndroidManifest.xml` khai permission, `build.gradle`, `Info.plist`, cấu hình ký). Dừng lại sửa `.gitignore` trước khi đi tiếp.

> ⚠️ **Đừng dùng `git status --short` để kiểm điều này** — git **gộp** thư mục chưa track thành một dòng `?? apps/passenger_mobile/`, không liệt kê file con, nên tìm `android/` sẽ ra 0 kể cả khi mọi thứ đúng. Muốn đếm file thì phải `git status --short -uall apps/passenger_mobile`.

### ⚠️ Đặt `rootProject.name` cho Gradle (bắt buộc, làm ngay)

Flutter sinh `android/settings.gradle.kts` **không khai `rootProject.name`**, nên Gradle lấy tên thư mục — mọi app đều thành `android`. Nạp 2 app trong cùng một IDE/Gradle workspace là đụng nhau:

```
A project with the name android already exists
Duplicate root element android
```

Thêm dòng sau vào **cuối** `android/settings.gradle.kts` của từng app (tên khác nhau):

```kotlin
rootProject.name = "passenger_mobile_android"
```

Kiểm:

```powershell
cd apps/passenger_mobile/android; ./gradlew projects -q
```

Mong đợi `Root project 'passenger_mobile_android'`.

### Định danh sinh ra

|                                 | Giá trị                          |
| ------------------------------- | -------------------------------- |
| Android `applicationId`         | `com.vexenhanh.passenger_mobile` |
| iOS `PRODUCT_BUNDLE_IDENTIFIER` | `com.vexenhanh.passengerMobile`  |

Khác nhau là **bình thường** — Flutter tự camelCase cho iOS vì bundle id của Apple không nhận dấu gạch dưới. **Ghi lại cả hai**: Firebase (FCM/APNs) cần cả hai, Google OAuth cần package name Android kèm SHA-1.

---

## 2. Package Dart dùng chung

```powershell
flutter create --template=package packages/mobile_shared
```

Sửa `packages/mobile_shared/pubspec.yaml` thêm `publish_to: 'none'` (package nội bộ). Template sinh kèm `LICENSE` + `CHANGELOG.md` — xoá được nếu không cần.

Trong `pubspec.yaml` của **cả hai app**:

```yaml
dependencies:
  mobile_shared:
    path: ../../packages/mobile_shared
```

> Chưa cần pub workspace. Với 2 app + 2 package thì `path:` dependency là đủ, và không phải đặt thêm `pubspec.yaml` ở root repo (nơi đã có `package.json`). Nâng cấp sau nếu lệch phiên bản plugin thành phiền — khoảng 15 phút.

---

## 3. Sinh Dart client từ OpenAPI 3.1

Spec nguồn: `packages/api-client/src/generated/openapi.json` (do `TASK-FND-008` sinh). Nếu chưa có hoặc đã cũ:

```powershell
pnpm gen:api-client
```

Sinh client. **Pin `v7.25.0`** — tag `latest` đang là `7.26.0-SNAPSHOT`, không dùng bản chưa phát hành để chốt:

```powershell
docker run --rm -v "${PWD}/packages/api-client/src/generated:/spec" -v "${PWD}/packages/api_client_dart:/out" openapitools/openapi-generator-cli:v7.25.0 generate -i /spec/openapi.json -g dart-dio -o /out --additional-properties=pubName=api_client_dart,pubLibrary=api_client_dart
```

Sinh code built_value rồi kiểm:

```powershell
cd packages/api_client_dart; dart pub get; dart run build_runner build; dart analyze
```

Mong đợi: `dart analyze` **0 lỗi** (có thể còn vài cảnh báo `unused_import` — vô hại).

> Generator in cảnh báo _"OpenAPI 3.1 support is still in beta"_. Đã verify với spec hiện tại là vô hại: `const` → Dart enum đúng, `exclusiveMinimum` → `int`. Nhưng nghĩa là **mỗi lần nâng generator phải regen + `dart analyze` lại**.

Wire vào 2 app:

```yaml
dependencies:
  api_client_dart:
    path: ../../packages/api_client_dart
```

---

## 4. Pin Flutter SDK

Nếu dùng FVM: tạo `.fvmrc` với `3.47.2`. Nếu chưa cài FVM, ghi phiên bản vào `README` của app và dùng đúng phiên bản đó ở CI — điều quan trọng là **một nguồn duy nhất**, không để CI và máy dev lệch.

---

## 5. Khai plugin theo ADR-028

Thêm vào `pubspec.yaml` (chưa cần dùng hết ngay):

| Nhu cầu            | Plugin                                          | App nào                      |
| ------------------ | ----------------------------------------------- | ---------------------------- |
| Quét QR            | `mobile_scanner`                                | cả hai                       |
| Token storage      | `flutter_secure_storage`                        | cả hai                       |
| Push               | `firebase_messaging`                            | cả hai                       |
| Biometric          | `local_auth`                                    | cả hai                       |
| Deep link          | `app_links`                                     | cả hai                       |
| Map (Goong)        | `maplibre_gl`                                   | cả hai                       |
| **Background geo** | `geolocator` (BSD-3) | ⚠️ **chỉ `employee_mobile`** |

> Background geo **không được** đưa vào `mobile_shared` hay `passenger_mobile`. Lý do tách 2 app (ADR-014 giữ trong ADR-028) chính là để app hành khách không phải khai permission đó.

> ⚠️ **`flutter_background_geolocation` — ADR-028 có nhắc, nhưng ĐỪNG thêm ở bước này** (chốt 14/09/2026). Nó là plugin **thương mại**: README + `help/INSTALL-ANDROID.md` của chính nó ghi _"The SDK is fully functional in `DEBUG` builds — no license required"_ và _"A license is required for `RELEASE` builds"_ (cả iOS lẫn Android). File `LICENSE` ghi **Apache-2.0** là gây hiểu nhầm — đã cài thử rồi đọc tận nơi để xác nhận, sau đó revert. FND-009 chỉ **khai báo** plugin; background geo mãi tới **TASK-EMP-001/002** mới chạy ⇒ hoãn quyết định sang lúc đó, cân 3 phương án: (a) chỉ build `DEBUG` — hợp lệ vì v1 không lên store; (b) `flutter_foreground_task` + `geolocator` — miễn phí, tự dựng foreground service; (c) mua license.

Scheme deep link: `vexenhanh://` (passenger) và `vexenhanh-operator://` (employee) — phải khớp `AUTH_ALLOWED_CALLBACK_ORIGINS` của API.

---

## 6. Đường dọc mỏng: login Email-OTP

Cần API chạy:

```powershell
docker compose up -d
```

```powershell
pnpm --filter @vexenhanh/api dev
```

Từ app Flutter gọi `POST /v1/auth/otp/request` rồi `POST /v1/auth/otp/verify`.

### ⚠️ Lấy OTP ở dev

Ở dev **không nhận được OTP qua email**:

- Có `RESEND_API_KEY` (đang set trong `.env.development`) → Resend trả **422** vì gửi từ `no-reply@vexenhanh.com` là domain chưa verify.
- Không có key → `ConsoleEmailNotifier` **throw** `"OTP delivery unavailable"` (nó không in OTP ra log nữa, có chủ ý — OTP không được chạm vào log).

Cách lấy mã: đọc thẳng từ Postgres.

```powershell
docker compose exec -T postgres psql -U vexenhanh -d vexenhanh_dev -t -A -F"|" -c "select identifier, value from verifications order by created_at desc limit 1;"
```

Kết quả dạng `sign-in-otp-rider@example.com|820725:0` — mã OTP là **6 chữ số trước dấu hai chấm**.

> Endpoint vẫn trả **200** dù gửi mail thất bại — đúng thiết kế, để không lộ email nào đã đăng ký. Lỗi gửi có được ghi log.

### Lưu ý khi test lặp

Login có rate limit: **10 lần/giờ/identifier**, **30 lần/giờ/IP**. Chạy đi chạy lại sẽ ăn **429**. Xoá bucket để test tiếp:

```powershell
docker compose exec -T redis redis-cli --scan --pattern "login:*" | ForEach-Object { docker compose exec -T redis redis-cli del $_ }
```

Tương tự OTP có cooldown **60s** + tối đa **5 lần/giờ/email** (pattern `otp:*`).

---

## 7. CI job Flutter

Thêm job **riêng**, không gộp vào job Node (Turborepo không quản Mobile): cài Flutter đúng phiên bản pin → `flutter pub get` → `flutter analyze` → `flutter test` cho 2 app, và `dart test` cho `mobile_shared`.

Giới hạn trigger theo đường dẫn `apps/*_mobile/**` và `packages/mobile_shared/**` để sửa code Node không chạy job Mobile.

---

## 8. Dọn

```powershell
docker compose stop
```
