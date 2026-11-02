# Kế hoạch thông báo hành trình ngoài ứng dụng hành khách

> Ngày: 31/10/2026. Trạng thái: **Draft — kế hoạch, chưa triển khai**.
> Khanh đã chọn: **mô phỏng hành trình để demo trước**.
> Phạm vi nền tảng: **chỉ Android** (Khanh chốt 31/10/2026).
> Thiết kế: [Figma — thông báo có logo, hai dòng thông tin và thanh tiến độ](https://www.figma.com/design/6c81q3DdHVS0anfDw2sVVj/UI-UX?node-id=2629-1931).
> Liên quan: `TASK-NSR-001`, `TASK-FND-009`, ADR-020/024/025/028. Đây là kế hoạch bổ sung, chưa tự cấp task ID hay promote tài liệu SDLC.

## 1. Kết quả cần đạt

Hành khách bật bản demo từ ứng dụng Android, trở về màn hình chính hoặc khóa máy và vẫn thấy thông báo cập nhật qua ba giai đoạn: xe đến đón, đang di chuyển, đã đến nơi.

- Giữ logo gốc Vé Xe Nhanh, nội dung ngắn, tuyến/điểm đón và đường tiến độ có biểu tượng xe.
- Không thêm nhãn từng mốc, giờ trùng lặp, nút hành động hoặc lời chào thừa vào phần nội dung tùy biến.
- Dữ liệu mô phỏng tách khỏi dữ liệu vận hành; không đổi `TripStatus`, `TicketStatus`, booking, check-in hoặc số liệu thanh toán.
- Nghiệm thu trên thiết bị thật với push từ máy chủ. Bộ đếm Flutter chạy khi app mở chỉ phục vụ kiểm tra ban đầu, không chứng minh cập nhật nền.

### Phạm vi đề xuất cho demo

- Bản build nội bộ và API dev/sandbox, bật bằng cờ riêng; mặc định tắt và không đăng ký route demo trong production.
- Hành khách đăng nhập chọn một booking của mình rồi bấm **Chạy thử hành trình** trong khu vực demo. Nhãn **Mô phỏng** ở màn kích hoạt giúp tránh nhầm với chuyến thật.
- Một hoạt động đang theo dõi trên mỗi thiết bị; chạy demo khác thì kết thúc hoạt động trước. Đây là giới hạn demo đề xuất, chưa phải chính sách sản phẩm.
- V1 demo chưa hỗ trợ Guest/booking token, tự bật ngay sau mua vé, GPS thật, tính ETA qua Goong hoặc thêm dữ liệu từ app tài xế.
- Kịch bản ngắn khoảng 3–5 phút, điều chỉnh trong cấu hình demo. Các giai đoạn và phần trăm là dữ liệu trình bày, không phải enum nghiệp vụ mới.

## 2. Nền hiện có và khoảng trống

| Phần | Đã có trong code | Cần bổ sung |
| --- | --- | --- |
| Flutter | `PushService`, Firebase Messaging, đăng ký/gỡ FCM token | Payload dữ liệu có phiên bản, xử lý nền, quản lý hoạt động đang theo dõi |
| Điều hướng | Chạm push hiện mở tab Hành trình | Mở đúng booking; xử lý cả khởi động nguội và phiên đăng nhập hết hạn |
| Booking | `JourneyApi.loadBooking`, danh sách booking của tài khoản | Tái dùng dữ liệu tuyến/điểm đón; kiểm quyền trước khi chạy demo |
| Máy chủ | `notification/`, BullMQ worker, adapter FCM, `PushDevice` | Nguồn mô phỏng và payload dữ liệu cập nhật tiến độ |
| Android | `MainActivity` hiện chỉ kế thừa `FlutterActivity` | Bộ dựng thông báo native và cầu nối dùng được ở background engine |
| Logo | SVG wordmark/mark trong `assets/auth/logo/` và `assets/ticket/completion/` | Xuất tài nguyên native phù hợp Android, giữ đúng tỉ lệ |

Tài liệu thiết kế chưa mô tả riêng live journey của Passenger. Kết quả đọc code mới hơn cho thấy device token và push thường đã có; không triển khai lại các phần này theo ghi chú cũ của foundation.

Các điểm tích hợp chính:

- `apps/passenger_mobile/lib/features/notification/push_service.dart`
- `apps/passenger_mobile/lib/features/journey/journey_api.dart`
- `apps/passenger_mobile/lib/main.dart`
- `apps/api/src/notification/` và `apps/api/src/external/notification/push/`
- Zod ở `packages/types`; sinh lại OpenAPI/Dart client khi bổ sung API.

## 3. Ràng buộc hiển thị Android

- Android 16/API 36+: ưu tiên `Notification.ProgressStyle`, tracker icon và milestone points; yêu cầu promoted ongoing khi thiết bị và quyền cho phép.
- Live Update không cho `customContentView`/`RemoteViews` và không cho colorized notification. Vì vậy **không cam kết sao chép bố cục logo trái/chữ phải của Figma**.
- Chuyển mark gốc thành small icon đơn sắc; thử large icon màu ở vị trí template hỗ trợ. Wordmark đầy đủ chỉ dùng nếu template thực sự giữ được mà không phá cơ chế promoted. Chốt ảnh chụp Android thật ở bước thử nghiệm trước khi code sâu.
- Android cũ hoặc không được promoted: thông báo chuẩn có tiến độ, cùng notification ID để cập nhật một thẻ; không thêm custom RemoteViews chỉ để ép giống Figma.
- Xin quyền thông báo theo phiên bản; thiếu quyền thì tính năng vé vẫn dùng bình thường. Không xin GPS, vị trí nền, exact alarm hoặc foreground location service cho demo.
- Không dùng notification có nội dung giao dịch như vé QR, họ tên, email hoặc booking token trên màn hình khóa.

## 4. Luồng dữ liệu và quản lý vòng đời

1. Hành khách mở booking của mình và chạy demo. Kiểm tra môi trường, quyền, khả năng hệ điều hành và đăng ký thiết bị hiện tại.
2. Flutter tạo/khôi phục phiên demo và tạo notification Android ban đầu.
3. Gắn phiên demo với thiết bị FCM đã đăng ký. Chỉ bắt đầu lịch phát khi thiết bị đã sẵn sàng, tránh gửi trước khi có token.
4. Worker phát các snapshot mô phỏng theo mốc qua FCM data.
5. Native cập nhật cùng một hoạt động/thông báo. Snapshot cũ hoặc lặp không làm tiến độ lùi hay tạo thẻ mới.
6. Kết thúc demo: gửi trạng thái đến nơi rồi gỡ thông báo theo chính sách demo; dọn phiên và hủy job còn lại. Dừng thủ công/đăng xuất cũng phải thu hồi phiên.
7. Khi mở lại app: đối chiếu phiên server với hoạt động còn tồn tại; không tự tạo lại hoạt động đã bị người dùng tắt.

### Snapshot và API — đề xuất, chưa là contract đã duyệt

Snapshot tối thiểu: `schemaVersion`, `demoSessionId`, `bookingId`, `revision`, `displayStage`, `routeLabel`, `etaAt`, `progress`, `updatedAt`, `expiresAt`, `ended`.

- `progress`: số nguyên trong miền cố định, ví dụ 0–1000. Đồng hồ và tiến độ lấy từ snapshot có hạn dùng; không tăng mãi khi thiếu cập nhật.
- Dùng `etaAt` và giờ máy chủ để hiển thị thời gian còn lại; không giảm dần một con số phụ thuộc Timer Flutter.
- `displayStage` chỉ phục vụ UI mô phỏng, không ghi vào trạng thái chuyến.
- API đề xuất thuộc module `notification/` hiện có: tạo/đọc/dừng phiên demo gắn booking và thiết bị FCM của hành khách. Tiền tố `/v1/me/...`; chốt đường dẫn cụ thể khi bổ sung API spec, không mở module tracking mới.
- Phải kiểm `scope=passenger`, sở hữu booking và thiết bị cho cả tạo, đọc và dừng phiên; đăng ký token tiếp tục dùng API hiện có với kiểm quyền thiết bị. Không dùng endpoint chuyến công khai làm bằng chứng quyền theo dõi.
- Ưu tiên session Redis có TTL cho demo, không thêm bảng DB/migration nếu không cần. FCM device token tiếp tục dùng `PushDevice`, bảo vệ như bí mật và không log.
- Worker tái dùng Redis/BullMQ hiện có; job khóa theo session + revision, có retry/backoff và hạn dùng. Đánh dấu session đã dừng trước khi gửi snapshot kết thúc; job cũ phải đọc lại trạng thái để không phát tiếp.
- Bổ sung cổng gửi payload chuyên biệt trong `external/notification/push/`; giữ hành vi push giao dịch hiện có. Không tự thêm NotificationKind nghiệp vụ hoặc gửi email cho từng frame demo.

### Flutter và native bridge

- Thêm vùng `features/journey_activity/` trong app: model snapshot, service start/update/end, đối chiếu vòng đời và điều hướng booking.
- Dùng cầu nối native cục bộ của app cho chức năng này; không đổi Flutter hay thêm framework nền mới. Nếu đóng gói thành local Flutter plugin, phải đăng ký được cho cả foreground và background engine.
- Đặc biệt: không đặt toàn bộ MethodChannel handler trong `MainActivity` rồi giả định FCM background isolate gọi được. Bước thử nghiệm phải chứng minh đường gọi background thực tế.
- Android nhận data-only message có type riêng, đăng ký background handler đúng FlutterFire; không để hệ thống tạo thêm notification text mặc định cho cùng một snapshot.
- Giữ tách biệt với `_showPush` và thông báo giao dịch hiện có. Tiến độ cập nhật yên lặng, không phát âm thanh mỗi mốc.
- Lưu notification ID và revision cần thiết để dedup/cleanup sau khi process được tạo lại. Chạm thông báo chỉ chứa định danh, không nhét access token vào deep link.

## 5. Thứ tự triển khai và tiêu chí hoàn thành

| Bước | Công việc | Điều kiện qua bước |
| --- | --- | --- |
| 1. Thử nghiệm native | Một snapshot tĩnh có logo thật trên Android mục tiêu | Có ảnh thiết bị thật, xác định bố cục logo khả thi, bridge gọi được từ nền |
| 2. Lõi Flutter | Snapshot, kiểm dữ liệu, start/update/end, nguồn mô phỏng khi app mở, điều hướng | Test format thời gian, giới hạn tiến độ, revision, trạng thái kết thúc; chạm mở đúng booking |
| 3. Demo server | API giới hạn sandbox, session TTL, lịch worker, FCM data | Phát trọn kịch bản từ server mà không mở app; retry không tạo bản sao; không sửa dữ liệu chuyến/vé |
| 4. Vòng đời và tương thích | Màn hình khóa, thiếu quyền, mất mạng, mở lại, đăng xuất, dừng demo | Không lộ vé/QR, không hồi sinh thông báo đã dừng, không ảnh hưởng thông báo cũ |
| 5. Nghiệm thu | Chạy ma trận Android thật, đối chiếu Figma trong giới hạn native, ghi video demo và hướng dẫn chạy | Đủ bằng chứng Android 16 và bản cũ/fallback; ghi rõ máy/OS và kiểm tra chưa thực hiện |

Ước lượng tham khảo cho một người có sẵn thiết bị Android và cấu hình Firebase: **4–6 ngày làm việc**, gồm kiểm thử. Đây là ước lượng sơ bộ, cập nhật sau bước 1; không tính thời gian chờ cấp tài khoản hoặc sửa cấu hình hạ tầng ngoài phạm vi.

## 6. Kiểm thử và nghiệm thu

- Flutter unit: parse payload, schema version sai, countdown theo giờ tuyệt đối, tiến độ hợp lệ, snapshot cũ/trùng, kết thúc rồi nhận update muộn.
- Backend unit/integration: chỉ chủ booking/thiết bị được đăng ký; chặn tài khoản/tenant khác; token rotation; session hết hạn/dừng; retry và worker restart; cờ tắt và production không lộ route demo.
- Native Android: logo không biến dạng; chữ dài/cỡ chữ lớn không đè tiến độ; cập nhật/gỡ một thẻ; channel/permission; FCM token thay đổi; nhấn deep link khi app chưa chạy.
- Thiết bị: Android 16 hỗ trợ promoted và Android cũ/fallback. Kiểm tra cả cho phép và từ chối quyền.
- Luồng bắt buộc: mở demo → Home → khóa màn hình → nhận ít nhất hai mốc từ server → chạm mở đúng booking → kết thúc. Thêm mất mạng/khôi phục và đăng xuất/đăng nhập tài khoản khác.
- Phân biệt đưa app về nền, OS thu hồi process, vuốt khỏi recent apps và Force stop trong Settings. Không cam kết cập nhật sau người dùng cưỡng bức dừng; kiểm tra lại khi mở app.
- Thông báo lỗi hoặc bị từ chối quyền không chặn xem vé, đặt vé hoặc đăng nhập.
- Dùng Flutter `test`/`analyze`, native build/test, Vitest/Supertest liên quan; chạy kiểm tra OpenAPI/client sau thay đổi contract. Maestro/integration_test cho luồng app và bằng chứng native/thiết bị thật cho màn hình khóa.
- Đây mới là kế hoạch: chưa chạy test tính năng, chưa qua `code-reviewer`/`security-auditor`; chỉ chạy các agent review khi Khanh yêu cầu.

## 7. Tài liệu và bàn giao khi triển khai

- Bổ sung UI/API/Test/Task của SDLC với nhãn demo và trạng thái chờ Khanh duyệt; áp dụng `doc/AGENT.md`, không tự promote.
- Ghi các đề xuất được chọn trong file kế hoạch này trước khi chuyển thành contract; cập nhật khi spike native phát hiện giới hạn khác.
- Có hướng dẫn cấu hình Firebase bằng tên biến, không đưa credentials vào repo; hướng dẫn bật/tắt demo, chạy worker, reset session và chụp bằng chứng.
- Ghi AI journal bằng hook khi bắt đầu sinh/sửa code đáng kể; không commit nhật ký. Commit/push chỉ theo yêu cầu Khanh.
- Chuyển sang GPS thật là đợt riêng: cần chốt nguồn vị trí xe, ETA tới điểm đón/trả của từng hành khách, quyền Guest, nhiều chuyến và quy tắc bắt đầu/kết thúc. Không dùng thời gian mô phỏng để tự hoàn tất chuyến thật.

## 8. Nguồn đối chiếu

- Code hiện tại: các file ở §2; native config trong `apps/passenger_mobile/android/`.
- SDLC: SRS FR-EMP-09..13, FR-NSR-01..03/14, BR-52..54/62; LLD vòng đời chuyến; API booking/ticket; ADR-020/024/025/028. `trip.operation.updated` hiện chưa có consumer Passenger trong thiết kế.
- [Android — Live Update, quyền và giới hạn custom layout](https://developer.android.com/develop/ui/views/notifications/live-update).
- [Android — ProgressStyle, points và tracker](https://developer.android.com/develop/ui/compose/notifications/progress-centric).
- [FlutterFire — nhận FCM và giới hạn background/force quit](https://firebase.google.com/docs/cloud-messaging/flutter/receive-messages).
