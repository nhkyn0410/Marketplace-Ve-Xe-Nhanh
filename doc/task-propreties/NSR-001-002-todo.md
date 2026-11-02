# Thông báo server — NSR-001 / NSR-002

Ngày 19/10/2026, branch `operations-passenger-completion`. Nguồn: FR-NSR-01..05/14, BR-52..54, UC-31/34, ADR-020/028; chưa chạy code-reviewer / security-auditor.

- Adapter server FCM (`firebase-admin`) và APNs HTTP/2 + ES256 nằm sau port `external/notification/push/`. Không có khóa thì không gửi push; cấu hình thiếu một phần bị từ chối khi khởi động. Token hết hạn được vô hiệu, lỗi tạm thời thử lại qua BullMQ.
- Fanout từ outbox sau commit: chỉ xếp hàng khi đã áp dụng preference. Khóa duy nhất theo sự kiện / kênh; kết quả từng thiết bị giúp retry bỏ qua thiết bị đã nhận, có collapse ID từ notificationId. BullMQ giữ job lỗi để vận hành tra cứu.
- `GET/PUT /me/notification-preferences`, `POST /me/push-devices`, `DELETE /me/push-devices/{id}`, `GET /me/notifications`: chủ thể lấy từ phiên đăng nhập, dữ liệu tenant vẫn lọc operatorId. Không được tắt mọi kênh của thông báo bắt buộc; bật push cần kênh đã cấu hình và thiết bị đã đăng ký. Hủy thiết bị chỉ tác động thiết bị của mình.
- Thông báo loyalty cá nhân không có operatorId, RLS chỉ platform/system; không gắn nhà xe giả. Nhắc điểm và voucher trước 7 ngày, cùng cơ chế outbox và preference.
- Nhật ký gửi lưu trạng thái tại `notification_deliveries` và sự kiện tại Mongo **`system_log`**, theo DB §5.2–5.3 (chỉ hai collection `audit_event`, `system_log`). `notification_log` là chức năng tra cứu, không tạo collection thứ ba.
- Admin: `GET /admin/system/notifications`, màn `/system?tab=notifications` có phân trang / làm mới / tải / lỗi / rỗng; chỉ hiện địa chỉ đã che, không trả token thiết bị.

Kiểm tra: adapter FCM và chữ ký/request APNs bằng mock; integration PostgreSQL thật cho preference, ownership, fanout không trùng, retry từng thiết bị, token hết hạn, thông báo cá nhân và nhắc hạn 7 ngày. Kết quả cuối nhánh được agent chính tổng hợp.

Cần cấu hình khóa FCM/APNs và đăng ký token từ ứng dụng khi kiểm thử giao nhận trên thiết bị thật. Phần Flutter và màn cài đặt của hành khách nằm ngoài phạm vi backend lần này. Biến môi trường được khai trong `apps/api/.env.example`.
