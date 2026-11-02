# Auth assets manifest

## Nguồn và phạm vi

- Figma file: `6c81q3DdHVS0anfDw2sVVj` (`UI-UX`)
- Frame tĩnh: `Splash · Tĩnh` — node `1272:226`
- Frame motion: `Đăng nhập · Motion` — node `1253:174`
- Frame OTP: `Xác nhận email · Tĩnh` — node `537:265`
- Timeline owner: node `2043:24837`
- Kích thước thiết kế của cả hai frame: **412 × 915 px**, bo góc **40 px**, clip nội dung.
- Các file dưới đây được tải trực tiếp từ URL asset do Figma Design Context hoặc export node con của Figma MCP trả về. Không dùng screenshot toàn màn hình, không trace/vẽ lại, không tối ưu hoặc sửa path.

## Hiện trạng ứng dụng Flutter

- `apps/passenger_mobile` hiện là Flutter app (Dart `^3.13.2`, Flutter `>=3.47.2 <4.0.0`).
- UI hiện tại nằm trong một file `lib/main.dart`, chứa luồng OTP email/verify và lưu token; test hiện có là `test/login_screen_test.dart`.
- Trước lần trích xuất này chưa có thư mục `assets/` và `pubspec.yaml` chưa khai báo asset.
- Giai đoạn này không sửa Dart UI, không sửa `pubspec.yaml`, không thay dependencies.

## Design tokens trích từ Design Context

### Màu

| Token / vai trò | Giá trị |
|---|---:|
| Primary 50 / nền form | `#EBF5FB` |
| Primary 100 | `#C8E3F3` |
| Primary 200 | `#95C8E8` |
| Primary 300 | `#62ACDC` |
| Primary 500 | `#2B7EAD` |
| Primary 800 / splash background | `#123D5C` |
| Primary 900 / text chính | `#0A2840` |
| Tertiary 500 / progress | `#E89B26` |
| CTA gradient | `#F4B028 → #EA831D` |
| Neutral 0 | `#FFFFFF` |
| Neutral 100 / border | `#E4E5E7` |
| Neutral 600 / text phụ | `#5E6165` |
| Neutral 900 | `#1C1E22` |
| Text tertiary | `#93969A` |
| Link | `#226A92` |
| Sky gradient | `#62ACDC → #95C8E8 → #C8E3F3` |

### Typography

Tất cả text dùng **Be Vietnam Pro**.

| Style | Weight | Size | Line height | Letter spacing |
|---|---:|---:|---:|---:|
| h3 | 600 | 28 px | 28 px | 0 |
| body-sm | 400 | 14 px | 16.8 px | 0 |
| Passenger Auth / 14 Medium | 500 | 14 px | 21 px | 0 |
| Passenger Auth / 16 Regular | 400 | 16 px | 24 px | 0 |
| Passenger Auth / 16 SemiBold | 600 | 16 px | 24 px | 0 |
| Passenger Auth / 12 Regular | 400 | 12 px | 18 px | 0 |
| caption | 400 | 12 px | 12 px | 1 px |
| Splash overline | 600 | 11 px | 2.2 px theo payload | 0.88 px |
| Status time | 600 | 15 px | normal | 0 |

## Hình học chính

### Splash · Tĩnh

| Layer | Node | Vị trí / kích thước |
|---|---|---|
| Glow | `1272:227` | x -122, y 273, 560 × 560 |
| Núi · lớp xa | `1272:229` | x 0, y 664, 412 × 150 |
| Núi · lớp gần | `1272:231` | x 0, y 690, 412 × 150 |
| Đồi | `1272:233` | x 0, y 760, 412 × 200 |
| Full Logo - Dark Mode | `1272:235` | x 86, y 407, 240 × 61.317 |
| Subtitle | `1272:240` | tâm x 206, y 492, rộng 332 |
| Progress track | `1272:241` | x 140, y 532, 132 × 4 |
| Progress fill | `1272:242` | x 0 trong track, 52 × 4 |
| Version | `1272:243` | tâm x 206, y 858, rộng 332 |
| Status bar | `1272:244` | x 28, y 18, 356 × 22 |
| Home indicator | `1272:255` | x 139, y 902, 134 × 5 |

### Đăng nhập · Motion

| Layer | Node | Vị trí / kích thước |
|---|---|---|
| Hero · Cảnh hành trình | `1255:214` | x 0, y 0, 412 × 915, clip |
| Bầu trời | `1257:214` | x 0, y 0, 412 × 440 |
| Xe khách | `1256:214` | x 111, y 247, 190 × 72 |
| Biểu mẫu đăng nhập | `1257:219` | x 24, y 394, rộng 364, gap 16 |
| Logo pill | `1259:253` | x 24, y 60; padding 14 × 9 |
| Status bar | `1259:242` | x 28, y 18, 356 × 22 |
| Home indicator | `1259:259` | x 139, y 902, 134 × 5 |
| Splash overlay | `1259:260` | x 0, y 0, 412 × 915 |
| Splash logo overlay | `1259:261` | x 86, y 407, 240 × 61.317 |

## Danh sách asset

`Kích thước slot` là kích thước layer/slot trong frame. `Kích thước nguồn` lấy từ root `width`/`height` của SVG hoặc IHDR của PNG.

### Splash

| File | Figma node | Kích thước slot | Kích thước nguồn | Bytes | Mục đích |
|---|---|---:|---:|---:|---|
| `splash/mountains_far.svg` | `1272:229` | 412 × 150 | 412 × 150 | 367 | Dãy núi xa trên splash |
| `splash/mountains_near.svg` | `1272:231` | 412 × 150 | 412 × 150 | 408 | Dãy núi gần trên splash |
| `splash/hill.svg` | `1272:233` | 412 × 200 | 412 × 200 | 352 | Đồi foreground trên splash |

### Landscape

| File | Figma node | Kích thước slot | Kích thước nguồn | Bytes | Mục đích |
|---|---|---:|---:|---:|---|
| `landscape/sun_halo_outer.svg` | `1255:216` | 128 × 128 | 128 × 128 | 265 | Halo ngoài của mặt trời |
| `landscape/sun_halo_inner.svg` | `1255:217` | 86 × 86 | 86 × 86 | 250 | Halo trong của mặt trời |
| `landscape/sun.svg` | `1255:218` | 52 × 52 | 52 × 52 | 269 | Đĩa mặt trời |
| `landscape/mountains_far.svg` | `1255:219` | 412 × 150 | 412 × 150 | 367 | Núi xa của hero |
| `landscape/cloud_c.svg` | `1255:221` | 50 × 21 | 50 × 23.2217 | 1,059 | Mây C; source tràn 10.58% phía trên slot |
| `landscape/mountains_near.svg` | `1255:223` | 412 × 150 | 412 × 150 | 407 | Núi gần của hero |
| `landscape/cloud_a.svg` | `1255:225` | 96 × 40 | 96 × 44.2319 | 1,028 | Mây A |
| `landscape/cloud_b.svg` | `1255:227` | 74 × 31 | 74 × 34.2797 | 1,055 | Mây B |
| `landscape/hill.svg` | `1255:229` | 412 × 110 | 412 × 110 | 338 | Đồi hero |
| `landscape/pine_1.svg` | `1255:231` | 18 × 30 | 18 × 30 | 305 | Cây thông 1 |
| `landscape/pine_2.svg` | `1255:233` | 14.4 × 24 | 14.4 × 24 | 331 | Cây thông 2 |
| `landscape/pine_3.svg` | `1255:235` | 14.4 × 24 | 14.4 × 24 | 331 | Cây thông 3 |
| `landscape/pine_4.svg` | `1255:237` | 18 × 30 | 18 × 30 | 305 | Cây thông 4 |
| `landscape/pine_5.svg` | `1255:239` | 16.2 × 27 | 16.2 × 27 | 334 | Cây thông 5 |
| `landscape/ground.svg` | `1255:241` | 412 × 164 | 412 × 164 | 337 | Mặt đất |
| `landscape/road.svg` | `1255:243` | 412 × 28 | 414 × 28 | 3,084 | Đường; source tràn 2 px sang phải |

### Bus

| File | Figma node | Kích thước slot | Kích thước nguồn | Bytes | Mục đích |
|---|---|---:|---:|---:|---|
| `bus/shadow.svg` | `1256:215` | 176 × 8 | 176 × 8 | 399 | Bóng đổ dưới xe |
| `bus/speed_streak_top.svg` | `1256:218` | x 14, y 0 trong group; 42 × 3 | 42 × 3 | 338 | Vệt tốc độ phía trên |
| `bus/speed_streak_middle.svg` | `1256:219` | x 0, y 13 trong group; 50 × 3 | 50 × 3 | 338 | Vệt tốc độ ở giữa |
| `bus/speed_streak_bottom.svg` | `1256:220` | x 24, y 26 trong group; 30 × 3 | 30 × 3 | 338 | Vệt tốc độ phía dưới |
| `bus/body.svg` | `1256:221` | 188 × 54 | 188 × 54 | 2,523 | Thân xe |
| `bus/wheel_rear.svg` | `1256:237` | 22 × 22 | 22 × 22 | 805 | Bánh sau |
| `bus/wheel_front.svg` | `1256:242` | 22 × 22 | 22 × 22 | 835 | Bánh trước |

### Waves

| File | Figma node | Kích thước slot | Kích thước nguồn | Bytes | Mục đích |
|---|---|---:|---:|---:|---|
| `waves/back.svg` | `1259:235` | 532 × 678 | 532 × 678 | 350 | Sóng lớp sau, đi lên từ dưới viewport |
| `waves/form_background.svg` | `1259:237` | 412 × ~663; source tràn slot | 452 × 702.939 | 1,133 | Sóng nền biểu mẫu |

### Logo

| File | Figma node | Kích thước slot | Kích thước nguồn | Bytes | Mục đích |
|---|---|---:|---:|---:|---|
| `logo/light_mark.svg` | `I1259:254;10:224` | 30 × 30 | 30 × 22.9091 | 1,632 | Logo mark trong pill sáng |
| `logo/light_wordmark.svg` | `I1259:254;10:226` | 87.422 × 30 | 87.4219 × 11.7188 | 4,073 | Wordmark trong pill sáng |
| `logo/dark_mark.svg` | `I1272:235;10:230`, `I1259:261;10:230` | 61.317 × 61.317 | 61.3174 × 46.8242 | 1,641 | Logo mark splash/dark mode |
| `logo/dark_wordmark.svg` | `I1272:235;10:232`, `I1259:261;10:232` | 178.683 × 61.317 | 178.683 × 23.9521 | 4,087 | Wordmark splash/dark mode |

### Icons

| File | Figma node | Kích thước slot | Kích thước nguồn | Bytes | Mục đích |
|---|---|---:|---:|---:|---|
| `icons/cta_shine.svg` | `1259:240` | 96 × 56 | 96 × 56 | 683 | Dải sáng chạy qua CTA |
| `icons/google.svg` | `I1257:234;1031:373` | 20 × 20 | 20 × 20 | 1,219 | Google OAuth |
| `icons/apple.png` | `I1257:242;1031:385` | 20 × 20 | 800 × 800 | 29,731 | Apple OAuth; giữ nguyên ảnh PNG nguồn |
| `icons/facebook.svg` | `I1257:245;1031:380` | 20 × 20 | 20 × 20 | 977 | Facebook OAuth |
| `icons/status_light.svg` | `1272:246` | 68 × 14 | 68 × 14 | 2,137 | Cellular/Wi-Fi/battery màu sáng |
| `icons/status_dark.svg` | `1259:244` | 68 × 14 | 68 × 14 | 2,155 | Cellular/Wi-Fi/battery màu tối |
| `icons/otp_clock.svg` | `537:466` | 16 × 16 | 16 × 16 | 472 | Đồng hồ tại dòng hiệu lực OTP |
| `icons/otp_arrow.svg` | `537:486` | 20 × 20 | 20 × 20 | 353 | Mũi tên trong CTA Xác minh |

## Kết quả kiểm tra

- **40 asset**: 39 SVG + 1 PNG (38 asset Giai đoạn 1 + 2 icon OTP Giai đoạn 3A).
- 39/39 SVG parse XML thành công, root là `<svg>`, có `width`, `height` và `viewBox`.
- PNG có signature chuẩn và IHDR **800 × 800**.
- 40/40 file có kích thước lớn hơn 0 byte.
- 0 tham chiếu tới `figma.com/api/mcp/asset`.
- 0 `href`/`xlink:href` trỏ tới asset HTTP bên ngoài.
- Design Context có 38 lượt tham chiếu asset ở hai frame Giai đoạn 1 và thêm 2 icon riêng từ frame OTP. Hai vector logo dark dùng chung giữa splash tĩnh và splash overlay. Riêng frame `Vệt tốc độ` (`1256:217`) có opacity nghỉ bằng 0 nên SVG export ở cấp frame chứa `opacity="0"`; manifest không dùng wrapper đó mà export nguyên gốc ba vector con `1256:218`–`1256:220` (opacity 1) để Flutter có thể animate opacity ở group đúng theo Motion Context. Không path nào bị sửa.
- Screenshot từ Design Context chỉ dùng để đối chiếu hình ảnh; không được lưu hoặc dùng làm runtime asset.
