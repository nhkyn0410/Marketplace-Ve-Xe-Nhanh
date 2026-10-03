# TASK-FND-009 — Todo: Setup 2 app Flutter

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` §7.1 — _"Setup 2 app Flutter: `flutter create` `apps/passenger_mobile` + `apps/employee_mobile`; package Dart dùng chung `packages/mobile_shared/`; Dart client `packages/api_client_dart/` sinh bằng `openapi-generator` pin v7.25.0 + `dart-dio`; pin Flutter SDK qua FVM; CI job `flutter analyze` + `flutter test` tách khỏi job Node"_.
> **Nguồn thiết kế:** **ADR-028** (Flutter thay Expo/RN, supersedes ADR-014) · ADR-012 (OpenAPI 3.1 single source) · ADR-013 (monorepo) · ADR-017 (token storage) · ADR-020/028 (push) · ADR-027 (map).
> **Dependency:** `TASK-FND-008` ✓ Done (OpenAPI gen — `api_client_dart` sinh từ spec của nó).
> **Cách dùng:** tick `[x]` khi xong; AI cập nhật trạng thái khi làm. Guide thao tác: `FND-009-guide.md`. Nghiệm thu: `FND-009-verification-checklist.md`.

## Trạng thái (15/09/2026)

- ✅ **8/8 — DONE** (15/09/2026).
- **Đo được 15/09/2026**: `flutter analyze` sạch cả 3 gói Flutter · `flutter test` **26 + 1 + 1** pass · `dart analyze` `api_client_dart` sạch · `pnpm turbo run typecheck lint test build` **36/36** · pnpm workspace vẫn đúng **9 gói Node** · build APK debug **cả 2 app** thành công.
- **Permission tách đúng, verify ở tầng APK** (đọc manifest đã gộp, không phải file nguồn): `passenger` **không** còn `ACCESS_FINE/COARSE_LOCATION` — `tools:node="remove"` gỡ được quyền do AAR `org.maplibre.gl:android-sdk-opengl` tự khai; `employee` có hai quyền đó; **cả hai đều không có `ACCESS_BACKGROUND_LOCATION`**.
- ⚠️ **CI chưa chạy thật lần nào.** `mobile.yml` chỉ trigger trên `develop`, mà việc này làm trên branch `TASK-FND-009`. Toàn bộ lệnh CI sẽ chạy đã được chạy tay và pass, nhưng **“CI xanh” vẫn là suy luận cho tới lần gộp đầu tiên vào `develop`**. Rủi ro còn lại thuộc loại môi trường: runner `ubuntu-latest` thay vì Windows, và hành vi của `subosito/flutter-action` khi đọc `.fvmrc`.
- ✅ **Đã dọn đường trước** (commit `af3ec7a`): `.gitignore` sửa cho Flutter (`android/`+`ios/` là **source phải commit**, chỉ ignore phần tooling sinh ra) và `pnpm-workspace.yaml` loại trừ `packages/mobile_shared` + `packages/api_client_dart`.
- ✅ **Môi trường sẵn sàng** (đo 14/09/2026): Flutter **3.47.2** stable · Dart **3.13.2** · `flutter doctor` không có issue · Android toolchain OK.

---

## Phạm vi & ranh giới

FND-009 dừng ở **"dựng được nền và chứng minh chuỗi thông suốt"** — KHÔNG làm màn hình nghiệp vụ.

| Thuộc FND-009                                           | Để task sau                                        |
| ------------------------------------------------------- | -------------------------------------------------- |
| `flutter create` 2 app + package Dart dùng chung        | Màn hình đặt vé, chọn ghế → **TRN/BTP**            |
| Sinh + wire `api_client_dart` từ OpenAPI 3.1            | QR check-in, background geo → **TASK-EMP-001/002** |
| Một đường dọc mỏng: gọi được 1 endpoint thật, lưu token | Push notification thật → **TASK-NSR-001**          |
| CI job `flutter analyze` + `flutter test`               | Build/ký/phát hành → **TASK-OPS-001**              |
| Ánh xạ plugin theo ADR-028 (khai báo, chưa dùng hết)    | Map Goong, deep link thanh toán → TRN/BTP          |

## Quyết định đã chốt (ADR-028 — không mở lại ở task này)

1. **2 app tách biệt**, giữ nguyên lý do tách của ADR-014: permission profile khác nhau (Passenger **không** khai báo background geolocation), store listing B2C vs B2B, bundle nhỏ.
2. **Nằm ngoài pnpm workspace / Turborepo** — vòng đời chạy bằng `flutter`/`dart` CLI, CI job riêng.
3. **Android là nền tảng chính** (build local trên Windows). **iOS tuỳ chọn**, cần máy macOS + Xcode — _thiết bị iOS không thay được máy Mac_.
4. **v1 không phát hành store** ⇒ không submit, không cần OTA.
5. **`packages/types` (Zod) không dùng được cho Mobile** — contract đi qua Dart client sinh từ **cùng** OpenAPI 3.1.

## Cạm bẫy đã biết (đã kiểm chứng, đừng mất thời gian lại)

- **Tên thư mục phải là `snake_case`** — Dart không nhận dấu gạch ngang trong tên package. Dự án chốt 14/09/2026 dùng `apps/passenger_mobile` (thư mục trùng tên package) nên `flutter create` gọi thẳng được. *Nếu ai đó đặt thư mục có gạch ngang thì bắt buộc thêm `--project-name` — đã kiểm chứng là fail nếu thiếu.*
- **Mọi app Flutter đều có thư mục tên `android`** ⇒ Gradle lấy tên thư mục làm `rootProject.name` khi không khai báo, nên 2 app đụng nhau: `A project with the name android already exists` / `Duplicate root element android`. Khắc phục: khai `rootProject.name` riêng trong mỗi `android/settings.gradle.kts` (đã làm 14/09/2026, verify bằng `gradlew projects`).
- **Hai định danh khác nhau cho hai nền tảng** (bình thường, không phải lỗi): Android `applicationId = com.vexenhanh.passenger_mobile`, iOS `PRODUCT_BUNDLE_IDENTIFIER = com.vexenhanh.passengerMobile` — Flutter tự camelCase vì bundle id của Apple không nhận dấu gạch dưới. **Cần cả hai** khi tạo Firebase project (FCM/APNs) và đăng ký OAuth Google (Google cần package name Android + SHA-1).
- **`openapi-generator` dùng tag `latest` là SNAPSHOT** — pin `v7.25.0`. Bản này đã verify: xử lý đúng `const` và `exclusiveMinimum` của spec 3.1, code sinh ra `dart analyze` **0 lỗi**, round-trip đúng.
- **Enum trên dây vs trong Dart**: `"Bearer"` ↔ enum member `bearer` (chữ thường). built_value tự quy đổi — **đừng so sánh chuỗi thẳng**.

---

## Todo (ID = thứ tự thực hiện)

### ✅ #1 — [FND-009.1] Tạo 2 app Flutter

`flutter create` với `--org com.vexenhanh`, `--project-name` snake_case, `--platforms android,ios`, `--empty`.

- `apps/passenger_mobile/` — listing public, permission tối thiểu (Camera + Push + Biometric optional + Deep link).
- `apps/employee_mobile/` — listing internal, permission đầy đủ (thêm **background geolocation**).

**Success:** 2 thư mục tồn tại, `flutter analyze` sạch, `git check-ignore` xác nhận `android/`+`ios/` **không** bị ignore, và mỗi `android/settings.gradle.kts` có `rootProject.name` riêng.

### ✅ #2 — [FND-009.2] Package Dart dùng chung `packages/mobile_shared/`

`flutter create --template=package`. Thêm `publish_to: 'none'`. Wire `path:` dependency vào cả 2 app.

**Nội dung ban đầu** (chỉ những gì cả hai app đều cần và phải hành xử giống hệt):

- Wrapper HTTP + auth interceptor: gắn Bearer, xử lý 401, parse **RFC 7807** → lỗi có kiểu.
- Wrapper `flutter_secure_storage` (ADR-017).
- Tiện ích tiền tệ: VND `BIGINT` ↔ hiển thị (CLAUDE.md §4.3 cấm `float` cho tiền; Dart `int` 64-bit map thẳng được) — **phải có test**.
- ~~Design token + trạng thái nền: loading / error / empty / permission~~ — **hoãn sang task UI**, xem ghi chú dưới.

> ⚠️ **KHÔNG** đưa vào đây bất cứ thứ gì kéo theo permission — đặc biệt `flutter_background_geolocation`. Làm vậy là app hành khách phải khai background location và mất sạch lý do tách 2 app.

> ⚠️ **Design token + trạng thái nền hoãn sang task UI** (Khanh chốt 15/09/2026). Ba mục đầu đã xong và có test; riêng mục thứ tư bị hoãn vì ở FND-009 **chưa có màn hình nghiệp vụ nào** để token và trạng thái đó phục vụ — `passenger_mobile` mới có đúng một màn đăng nhập dựng để chứng minh chuỗi API chạy (xem § *Phạm vi & ranh giới* ở đầu file). Thiết kế design token khi chưa biết màn hình cần gì là đoán, mà đoán sai thì phải làm lại toàn bộ khi TRN/BTP vào. **Chuyển sang task UI đầu tiên chạm `06-ui-ux-flow-specification`**, làm cùng lúc với màn hình thật. DoD Mobile của `CLAUDE.md §6.3` (“permission state”) **không đổi**, chỉ dời thời điểm.

**Success:** cả 2 app `import 'package:mobile_shared/...'` chạy; `flutter test` trong package pass *(là `flutter test` chứ không phải `dart test` — gói này phụ thuộc `flutter`/`flutter_test`)*.

### ✅ #3 — [FND-009.3] Sinh `packages/api_client_dart/` từ OpenAPI 3.1

`openapi-generator` **pin `v7.25.0`**, generator `dart-dio`, đầu vào là `packages/api-client/src/generated/openapi.json`.

- **Không viết tay** — code sinh tự động.
- Chạy `dart pub get` → `dart run build_runner build` (built_value) → `dart analyze`.

> ⚠️ **Gói này hiện lệch bản sinh** (ghi nhận 15/09/2026). Commit `c693781` đã chạy `dart format` lên `lib/src/api/auth_api.dart` + `health_api.dart` và gỡ 4 dòng `import` thừa. Đã đối chiếu bằng `git diff -w --ignore-blank-lines`: **không có thay đổi logic nào** — chỉ xuống dòng lại và bỏ import. Hệ quả: lần regen tiếp theo sẽ **xoá các sửa đó** và `dart analyze` quay về 3 cảnh báo `unused_import` — checklist PHẦN B đã ghi rõ mấy cảnh báo này **chấp nhận được**. **Đừng sửa tay lại** — đó mới là trạng thái đúng của file sinh. Lệnh regen ở `FND-009-guide.md §3`.

**Success:** `dart analyze` 0 lỗi (cảnh báo `unused_import` không tính); có 7 method auth; test round-trip `AuthTokenResponse` (`"Bearer"` ↔ `bearer`) pass — test đặt ở `packages/mobile_shared/test/`, **không** đặt trong gói sinh.

### ✅ #4 — [FND-009.4] Pin Flutter SDK

`.fvmrc` (hoặc ghi rõ phiên bản trong `FND-009-guide.md` nếu chưa cài FVM) để CI và máy dev khớp nhau. Hiện tại: **3.47.2 stable**.

**Success:** phiên bản được ghi ở một chỗ duy nhất, CI đọc đúng chỗ đó.

### ✅ #5 — [FND-009.5] Ánh xạ plugin theo ADR-028

Khai báo trong `pubspec.yaml` (chưa cần dùng hết): `mobile_scanner` (QR) · `geolocator` (**chỉ employee**) · `firebase_messaging` (push) · `local_auth` · `flutter_secure_storage` · `maplibre_gl` (map Goong) · `app_links` (deep link `vexenhanh://` + `vexenhanh-operator://`).

> ⚠️ **`flutter_background_geolocation` KHÔNG khai ở bước này** (chốt 14/09/2026). ADR-028 có nhắc nó, nhưng nó là plugin **thương mại**: README của chính nó ghi _"A license is required for `RELEASE` builds"_ (cả iOS lẫn Android) — file `LICENSE` ghi Apache-2.0 là gây hiểu nhầm, đã cài thử và đọc tận nơi để xác nhận. FND-009 chỉ **khai báo** plugin, background geo mãi tới **TASK-EMP-001/002** mới dùng ⇒ chốt một dependency trả phí bây giờ là quyết định sớm không cần thiết. Để lại 3 phương án cân ở EMP-001: (a) chỉ build `DEBUG` — hợp lệ vì v1 không lên store (ADR-028); (b) `flutter_foreground_task` + `geolocator` — miễn phí; (c) mua license. `geolocator` (BSD-3) vẫn khai bình thường.

**Success:** `flutter pub get` cả 2 app thành công, permission khai đúng app (Passenger **không** có background location).

### ✅ #6 — [FND-009.6] Đường dọc mỏng nhất (chỉ `passenger_mobile`)

Màn login Email-OTP → gọi `/v1/auth/otp/request` + `/v1/auth/otp/verify` qua `api_client_dart` → lưu token bằng `flutter_secure_storage` → màn hình trống hiển thị `scope`/`role`.

Mục đích là **chứng minh cả chuỗi chạy được** (Dart client ↔ API ↔ token) trước khi đầu tư vào UI.

> ⚠️ Ở dev **không lấy được OTP qua email**: `ConsoleEmailNotifier` không in OTP nữa, và Resend trả **422** vì domain gửi chưa verify. Lấy mã từ bảng `verifications` — xem `FND-009-guide.md` §6.

**Success:** trên thiết bị/emulator Android, nhập email → nhập OTP → nhận token → hiển thị `scope=passenger`.

### ✅ #7 — [FND-009.7] CI job Flutter

Thêm job GitHub Actions **tách khỏi job Node** (Turborepo không quản Mobile): cài Flutter SDK đúng phiên bản pin, chạy `flutter analyze` + `flutter test` cho 2 app + `dart test` cho `mobile_shared`. Chỉ trigger khi `apps/*_mobile/**` hoặc `packages/mobile_shared/**` đổi.

**Success:** CI xanh; sửa file Node không kích hoạt job Mobile.

### ✅ #8 — [FND-009.8] Đóng task

`flutter analyze` + `flutter test` pass; spawn `code-reviewer` (CLAUDE.md §6.3); cập nhật `PROJECT-STATE §7` + task row `11-project-task-breakdown.md` → Done; chạy `FND-009-verification-checklist.md`.

---

## Điều kiện ngoài (external)

- 🔧 **Firebase project** (FCM) — cần cho push thật, **không chặn** FND-009 (chỉ khai plugin).
- 🔧 **Goong API key** — cần cho map, không chặn.
- 🔧 **Máy macOS** — chỉ cần khi build iOS; Android không cần.
- ⚠️ **Docker phải chạy** nếu làm #6 (cần API + Postgres + Redis).

## Follow-up từ vòng review đóng task (15/09/2026)

`code-reviewer` + `security-auditor` đã chạy. **Không có finding Critical/High.** Những cái nhỏ đã vá ngay (xem git log); dưới đây là phần cố ý để lại, kèm **mốc phải xử lý**:

- 🔴 **Release đang ký bằng debug keystore** — `apps/*_mobile/android/app/build.gradle.kts` vẫn là `signingConfig = signingConfigs.getByName("debug")` (TODO của template Flutter). Debug keystore là private key **công khai**, nên bất kỳ ai cũng dựng được APK cùng `applicationId` + cùng chữ ký ⇒ Android nhận nó như **bản cập nhật** và giữ nguyên data directory, kế thừa luôn token trong Keystore. **Chặn mọi việc phát tán APK release**, kể cả gửi cho giảng viên ⇒ **TASK-OPS-001**.
- 🟡 **`onUnauthorized` chưa nối dây + không có đăng xuất** — `main.dart` gọi `createApiClient(...)` bỏ trống callback, nên khi interceptor xoá token vì 401 thì UI vẫn đứng ở màn “đăng nhập thành công”. Cũng chưa lưu `expiresIn` nên client không tự biết token hết hạn. ⇒ làm cùng **màn hình thứ hai**.
- 🟡 **`AuthInterceptor` chưa có single-flight khi refresh** — nghĩa vụ kéo theo từ **TASK-IAM-002 Q5** (chốt 16/09/2026, chọn *strict* đúng ADR-017 thay vì cửa sổ ân hạn). Backend sẽ **revoke cả family** khi thấy refresh token đã dùng, nên nếu app bắn hai request song song cùng một refresh token thì người dùng bị đá ra oan. Client phải đảm bảo **chỉ một** lượt refresh chạy tại một thời điểm, các request còn lại chờ kết quả đó. Làm cùng lúc với việc nối refresh vào `AuthInterceptor`.
- 🟡 **`AuthInterceptor` gắn Bearer cho mọi host** — không kiểm `options.uri.origin`, mà Dio mặc định `followRedirects: true` và `dart:io` replay header sang host mới. Vô hại hôm nay (chỉ có endpoint cùng origin), nhưng **presigned URL R2 (ADR-018)** và **redirect VNPay/MoMo (ADR-019)** sẽ kích hoạt nó — JWT của user đi thẳng vào log bên thứ ba. Chốt nguyên tắc trước khi tác vụ nào dùng chung `Dio` instance này để tải file.
- 🟡 **CI không gác được chính bất biến permission của ADR-028** — quy tắc “passenger không có location, không app nào có background location, cleartext chỉ ở debug” hiện chỉ nằm trong comment. Thêm job `flutter build apk --debug` rồi grep merged manifest để assert — đúng tinh thần “mandatory test” của ADR-025 áp cho control ở tầng manifest.
- ⚪ **`api_client_factory` không có đường đóng** (`dio.close()`) — vô hại khi chỉ có một màn, thành rò socket ngay khi màn thứ hai tự tạo client.
- ⚪ **iOS**: khi dựng đường build iOS, đặt `IOSOptions(accessibility: first_unlock_this_device)` cho `TokenStorage` — mặc định cho phép item đi theo backup iCloud, tức bản Apple của vấn đề `allowBackup` đã vá ở Android. Ngoài ra `Info.plist` chưa có key `NSLocation*` / `NSCamera*` / `NSFaceID*` nào.

## Backlog không chặn

- Pub workspace (Dart 3.6+) để 2 app dùng chung lockfile — chỉ nâng khi lệch phiên bản plugin thành phiền.
- `flutter_test` cho widget + `integration_test` cho E2E — thuộc TASK-TEST-001 / task nghiệp vụ.
- Shorebird (OTA) — chỉ khi v1 đổi hướng lên store (ADR-028).
