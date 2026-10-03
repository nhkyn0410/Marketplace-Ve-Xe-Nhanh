# TASK-FND-009 — Checklist nghiệm thu: 2 app Flutter

> Mục tiêu: xác nhận nền Mobile dựng đúng ADR-028 và **chuỗi Dart client ↔ API ↔ token thông suốt**.
> Cách dùng: chạy theo thứ tự **A → B → C → D**; PHẦN E là bảng DoD theo từng sub-task. Tick `[x]` khi pass.
> Lệnh chạy ở repo root `C:\Code\Ve_Xe_Nhanh`. Guide thao tác: `FND-009-guide.md`.

## Snapshot trạng thái (15/09/2026 — đã nghiệm thu)

- ✅ **Đạt** — chạy ngày 15/09/2026. `flutter analyze` sạch 3 gói · `flutter test` **26 + 1 + 1** pass · `dart analyze` `api_client_dart` sạch · `pnpm turbo run typecheck lint test build` **36/36** · build APK debug cả 2 app OK.
- ⚠️ **2 mục PHẦN D không tick được** — có ghi lý do tại chỗ; cả hai đều là thiếu **tính năng chưa tới lượt làm**, không phải hỏng.
- ⚠️ **`mobile.yml` chưa chạy thật trên GitHub** — chỉ trigger trên `develop`; mọi lệnh CI đã chạy tay và pass.
- ✅ Môi trường: Flutter **3.47.2** stable · Dart **3.13.2** · `flutter doctor` no issues.
- ✅ Đường dẫn đã vá trước (commit `af3ec7a`): `.gitignore` + `pnpm-workspace.yaml`.

---

## PHẦN A — Cấu trúc & git (dễ hỏng nhất, kiểm trước)

- [x] `apps/passenger_mobile/` và `apps/employee_mobile/` tồn tại, mỗi thư mục có `pubspec.yaml` + `lib/main.dart` + `android/` + `ios/`
- [x] `packages/mobile_shared/` tồn tại, `pubspec.yaml` có `publish_to: 'none'`
- [x] `packages/api_client_dart/` tồn tại và **được sinh tự động** (không commit code viết tay). *Ngoại lệ đã ghi nhận 15/09/2026: `lib/src/api/{auth,health}_api.dart` có chạy `dart format` + gỡ import thừa — chỉ định dạng, không đổi logic (verify bằng `git diff -w`). Regen sẽ xoá chúng và đó là bình thường, đừng sửa tay lại.*
- [x] ⚠️ `git check-ignore -v apps/passenger_mobile/android/app/src/main/AndroidManifest.xml` **không in gì** (exit 1) — chứng minh file không bị ignore. *(Đừng dùng `git status --short`: git gộp thư mục chưa track thành một dòng, tìm `android/` sẽ ra 0 kể cả khi đúng — phải thêm `-uall`.)* **Nếu bị ignore là hỏng**: `AndroidManifest.xml` (nơi khai permission — chỗ hiện thực hoá việc tách 2 app), `build.gradle`, `Info.plist`, cấu hình ký sẽ bị bỏ ngoài repo
- [x] `git check-ignore apps/passenger_mobile/android/local.properties` → **có** (phần tooling sinh ra thì phải ignore)
- [x] ⚠️ Mỗi `android/settings.gradle.kts` có `rootProject.name` **riêng** (`passenger_mobile_android` / `employee_mobile_android`). Thiếu ⇒ cả hai đều tên `android` ⇒ IDE báo `A project with the name android already exists`. Kiểm: `./gradlew projects -q` trong từng `android/`
- [x] `pnpm install` vẫn nhận **đúng 9 package Node** — thư mục Dart không lọt vào pnpm workspace

## PHẦN B — Static

- [x] `flutter analyze` trong `apps/passenger_mobile` → **0 lỗi**
- [x] `flutter analyze` trong `apps/employee_mobile` → **0 lỗi**
- [x] `flutter analyze` trong `packages/mobile_shared` → 0 lỗi; `flutter test` pass *(là `flutter` chứ không phải `dart` — gói này phụ thuộc `flutter_test`)*
- [x] `dart analyze` trong `packages/api_client_dart` → **0 lỗi** (cảnh báo `unused_import` chấp nhận được)
- [x] `pnpm turbo run typecheck lint test build` → vẫn **36/36** (thêm Mobile không được làm hỏng pipeline Node)

## PHẦN C — Dart client sinh từ OpenAPI 3.1

- [x] Sinh bằng `openapitools/openapi-generator-cli:` **`v7.25.0`** — **không** dùng tag `latest` (đang là `7.26.0-SNAPSHOT`)
- [x] `dart run build_runner build` chạy sạch, sinh đủ `.g.dart`
- [x] `lib/src/api/auth_api.dart` có **7 method** auth
- [x] Method `authControllerOauth` nhận `required String provider` **và** `required OAuthInitDto`; `_path` có `.replaceAll(...)` thay `{provider}` _(nếu không là spec thiếu path param / requestBody — quay lại FND-008)_
- [x] Test round-trip: JSON `{"tokenType":"Bearer",...}` → deserialize ra enum `bearer` → serialize lại ra `"Bearer"`
- [x] ⚠️ Nhớ: enum member Dart là `bearer` (chữ thường), giá trị trên dây là `"Bearer"` — **không so sánh chuỗi thẳng**

## PHẦN D — Runtime (đường dọc mỏng)

> Cần `docker compose up -d` + API chạy.

- [x] App `passenger_mobile` chạy được trên emulator/thiết bị Android
- [x] Gọi `POST /v1/auth/otp/request` → **200**
- [x] Lấy OTP từ bảng `verifications` (xem guide §6 — console notifier **không in OTP**, Resend trả 422 vì domain chưa verify)
- [x] Gọi `POST /v1/auth/otp/verify` → **200**, nhận `accessToken` + `scope=passenger`
- [ ] Token lưu bằng `flutter_secure_storage`, đọc lại được sau khi restart app — **chưa chạy**: app hiện luôn mở ở màn đăng nhập, chưa có đường đọc token lúc khởi động (follow-up “nối onUnauthorized + đăng xuất”). Lớp đọc/ghi đã có test riêng ở `token_storage_test.dart`
- [ ] Gọi một endpoint cần auth với Bearer → không 401 — **chưa kiểm được**: API chưa có endpoint nào yêu cầu auth (spec không khai security scheme nào). `AuthInterceptor` có test riêng cho việc gắn header và xử 401
- [x] Lỗi RFC 7807 parse ra được kiểu (thử sai OTP → 401 `AUTH_INVALID_CREDENTIALS`)
- [x] ⚠️ Nếu ăn **429**: rate limit login 10/giờ/identifier, 30/giờ/IP — xoá key `login:*` trong Redis (guide §6), không phải bug

## PHẦN E — DoD theo sub-task

| Sub-task               | DoD                                                                                                                                                                  | ✓   |
| ---------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --- |
| `.1` 2 app             | `flutter analyze` sạch; `android/`+`ios/` được git theo dõi; ghi lại applicationId (`com.vexenhanh.passenger_mobile`) và bundle id (`com.vexenhanh.passengerMobile`) | [x] |
| `.2` `mobile_shared`   | Cả 2 app import được; có test cho tiện ích tiền tệ VND `BIGINT`; **không** chứa thứ kéo theo permission. *Design token + trạng thái nền đã **hoãn sang task UI** (15/09/2026) — không chặn nghiệm thu*                                                              | [x] |
| `.3` `api_client_dart` | Sinh bằng v7.25.0; `dart analyze` 0 lỗi; round-trip pass                                                                                                             | [x] |
| `.4` Pin SDK           | Phiên bản Flutter ghi ở **một** chỗ; CI đọc đúng chỗ đó                                                                                                              | [x] |
| `.5` Plugin            | `flutter pub get` sạch cả 2 app; ⚠️ `passenger_mobile` **không** khai background location; **không** có `flutter_background_geolocation` trong `pubspec.yaml` nào (trả phí — hoãn tới EMP-001)                                                                            | [x] |
| `.6` Đường dọc         | Login OTP end-to-end trên thiết bị thật/emulator                                                                                                                     | [x] |
| `.7` CI                | Job Mobile tách khỏi job Node; sửa file Node **không** kích hoạt job Mobile                                                                                          | [x] |
| `.8` Đóng task         | `code-reviewer` không finding nghiêm trọng; `PROJECT-STATE §7` + task row → Done                                                                                     | [x] |

## PHẦN F — Ranh giới (KHÔNG kiểm ở task này)

Những mục dưới đây **không** thuộc FND-009, đừng chặn nghiệm thu vì chúng:

- Màn hình nghiệp vụ (đặt vé, chọn ghế, QR check-in) → TRN/BTP/EMP
- Push notification thật (cần Firebase project) → TASK-NSR-001
- Map Goong hiển thị thật (cần API key) → TASK-TRN-002
- Build/ký/phát hành, iOS build (cần máy macOS) → TASK-OPS-001
- `integration_test` + Maestro E2E → TASK-TEST-001
