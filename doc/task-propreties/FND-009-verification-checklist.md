# TASK-FND-009 — Checklist nghiệm thu: 2 app Flutter

> Mục tiêu: xác nhận nền Mobile dựng đúng ADR-028 và **chuỗi Dart client ↔ API ↔ token thông suốt**.
> Cách dùng: chạy theo thứ tự **A → B → C → D**; PHẦN E là bảng DoD theo từng sub-task. Tick `[x]` khi pass.
> Lệnh chạy ở repo root `C:\Code\Ve_Xe_Nhanh`. Guide thao tác: `FND-009-guide.md`.

## Snapshot trạng thái (14/09/2026)

- ⬜ **Chưa bắt đầu** — `apps/` chưa có thư mục mobile nào.
- ✅ Môi trường: Flutter **3.47.2** stable · Dart **3.13.2** · `flutter doctor` no issues.
- ✅ Đường dẫn đã vá trước (commit `af3ec7a`): `.gitignore` + `pnpm-workspace.yaml`.

---

## PHẦN A — Cấu trúc & git (dễ hỏng nhất, kiểm trước)

- [ ] `apps/passenger_mobile/` và `apps/employee_mobile/` tồn tại, mỗi thư mục có `pubspec.yaml` + `lib/main.dart` + `android/` + `ios/`
- [ ] `packages/mobile_shared/` tồn tại, `pubspec.yaml` có `publish_to: 'none'`
- [ ] `packages/api_client_dart/` tồn tại và **được sinh tự động** (không commit code viết tay)
- [ ] ⚠️ `git check-ignore -v apps/passenger_mobile/android/app/src/main/AndroidManifest.xml` **không in gì** (exit 1) — chứng minh file không bị ignore. *(Đừng dùng `git status --short`: git gộp thư mục chưa track thành một dòng, tìm `android/` sẽ ra 0 kể cả khi đúng — phải thêm `-uall`.)* **Nếu bị ignore là hỏng**: `AndroidManifest.xml` (nơi khai permission — chỗ hiện thực hoá việc tách 2 app), `build.gradle`, `Info.plist`, cấu hình ký sẽ bị bỏ ngoài repo
- [ ] `git check-ignore apps/passenger_mobile/android/local.properties` → **có** (phần tooling sinh ra thì phải ignore)
- [ ] ⚠️ Mỗi `android/settings.gradle.kts` có `rootProject.name` **riêng** (`passenger_mobile_android` / `employee_mobile_android`). Thiếu ⇒ cả hai đều tên `android` ⇒ IDE báo `A project with the name android already exists`. Kiểm: `./gradlew projects -q` trong từng `android/`
- [ ] `pnpm install` vẫn nhận **đúng 9 package Node** — thư mục Dart không lọt vào pnpm workspace

## PHẦN B — Static

- [ ] `flutter analyze` trong `apps/passenger_mobile` → **0 lỗi**
- [ ] `flutter analyze` trong `apps/employee_mobile` → **0 lỗi**
- [ ] `dart analyze` trong `packages/mobile_shared` → 0 lỗi; `dart test` pass
- [ ] `dart analyze` trong `packages/api_client_dart` → **0 lỗi** (cảnh báo `unused_import` chấp nhận được)
- [ ] `pnpm turbo run typecheck lint test build` → vẫn **36/36** (thêm Mobile không được làm hỏng pipeline Node)

## PHẦN C — Dart client sinh từ OpenAPI 3.1

- [ ] Sinh bằng `openapitools/openapi-generator-cli:` **`v7.25.0`** — **không** dùng tag `latest` (đang là `7.26.0-SNAPSHOT`)
- [ ] `dart run build_runner build` chạy sạch, sinh đủ `.g.dart`
- [ ] `lib/src/api/auth_api.dart` có **7 method** auth
- [ ] Method `authControllerOauth` nhận `required String provider` **và** `required OAuthInitDto`; `_path` có `.replaceAll(...)` thay `{provider}` _(nếu không là spec thiếu path param / requestBody — quay lại FND-008)_
- [ ] Test round-trip: JSON `{"tokenType":"Bearer",...}` → deserialize ra enum `bearer` → serialize lại ra `"Bearer"`
- [ ] ⚠️ Nhớ: enum member Dart là `bearer` (chữ thường), giá trị trên dây là `"Bearer"` — **không so sánh chuỗi thẳng**

## PHẦN D — Runtime (đường dọc mỏng)

> Cần `docker compose up -d` + API chạy.

- [ ] App `passenger_mobile` chạy được trên emulator/thiết bị Android
- [ ] Gọi `POST /v1/auth/otp/request` → **200**
- [ ] Lấy OTP từ bảng `verifications` (xem guide §6 — console notifier **không in OTP**, Resend trả 422 vì domain chưa verify)
- [ ] Gọi `POST /v1/auth/otp/verify` → **200**, nhận `accessToken` + `scope=passenger`
- [ ] Token lưu bằng `flutter_secure_storage`, đọc lại được sau khi restart app
- [ ] Gọi một endpoint cần auth với Bearer → không 401
- [ ] Lỗi RFC 7807 parse ra được kiểu (thử sai OTP → 401 `AUTH_INVALID_CREDENTIALS`)
- [ ] ⚠️ Nếu ăn **429**: rate limit login 10/giờ/identifier, 30/giờ/IP — xoá key `login:*` trong Redis (guide §6), không phải bug

## PHẦN E — DoD theo sub-task

| Sub-task               | DoD                                                                                                                                                                  | ✓   |
| ---------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --- |
| `.1` 2 app             | `flutter analyze` sạch; `android/`+`ios/` được git theo dõi; ghi lại applicationId (`com.vexenhanh.passenger_mobile`) và bundle id (`com.vexenhanh.passengerMobile`) | [ ] |
| `.2` `mobile_shared`   | Cả 2 app import được; có test cho tiện ích tiền tệ VND `BIGINT`; **không** chứa thứ kéo theo permission                                                              | [ ] |
| `.3` `api_client_dart` | Sinh bằng v7.25.0; `dart analyze` 0 lỗi; round-trip pass                                                                                                             | [ ] |
| `.4` Pin SDK           | Phiên bản Flutter ghi ở **một** chỗ; CI đọc đúng chỗ đó                                                                                                              | [ ] |
| `.5` Plugin            | `flutter pub get` sạch cả 2 app; ⚠️ `passenger_mobile` **không** khai background location                                                                            | [ ] |
| `.6` Đường dọc         | Login OTP end-to-end trên thiết bị thật/emulator                                                                                                                     | [ ] |
| `.7` CI                | Job Mobile tách khỏi job Node; sửa file Node **không** kích hoạt job Mobile                                                                                          | [ ] |
| `.8` Đóng task         | `code-reviewer` không finding nghiêm trọng; `PROJECT-STATE §7` + task row → Done                                                                                     | [ ] |

## PHẦN F — Ranh giới (KHÔNG kiểm ở task này)

Những mục dưới đây **không** thuộc FND-009, đừng chặn nghiệm thu vì chúng:

- Màn hình nghiệp vụ (đặt vé, chọn ghế, QR check-in) → TRN/BTP/EMP
- Push notification thật (cần Firebase project) → TASK-NSR-001
- Map Goong hiển thị thật (cần API key) → TASK-TRN-002
- Build/ký/phát hành, iOS build (cần máy macOS) → TASK-OPS-001
- `integration_test` + Maestro E2E → TASK-TEST-001
