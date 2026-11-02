# TASK-NSR-003 — Todo: Chiến dịch thông báo và hộp thư

> **Khanh (02/11/2026):** "Sau đó tiến hành chức năng Theo đề xuất không gửi email hàng loạt"; "Sửa phần việc này luôn" (Firebase), "Tiếp tục phần việc này" (tài liệu, migrate).
> Nguồn: SRS `FR-NSR-16/17`, `UC-41/42`, `BR-82..85`, `NTF-20/21/27`; LLD §6.26–6.27; DB §7; API §7.2, §7.5; UI SCR-PSG-12/13/38, §9; Security §7, §9; Test `TC-NSR-001..006`, `TC-IAM-MOB-001`.
> **Nhánh:** `feat/notification-campaign`.

## Trạng thái (02/11/2026) — 🔨 **Code + kiểm thử xong, chờ Khanh duyệt thiết kế**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).
- Chưa merge, chưa deploy. Migration đã áp `vexenhanh_dev` và production; bảng mới trống đến khi code lên.
- Worker chưa chạy thường trực trên Render (ADR-024, RB-07): chiến dịch chỉ gửi khi worker đang bật.

## Đã làm

- **DB:** `notification_campaigns`, `notification_inbox_messages` (FORCE RLS), `NotificationKind` thêm `SERVICE_NOTICE`, `NEWS`.
- **API:** `/admin/notification-campaigns*` (quyền `notification:broadcast`, audit mọi thao tác), `/me/inbox*`; push mang nội dung thật với tin chiến dịch, kèm `kind` và kênh Android; `/me/loyalty/transactions` có tổng không đổi theo bộ lọc loại.
- **Worker:** `campaign-sweep` mỗi phút, `campaign-batch` mỗi lô 200 tài khoản; chạy lại an toàn nhờ khóa chống trùng; không sinh bản gửi email.
- **Admin:** mục Thông báo: danh sách, soạn + xem trước + người nhận dự kiến, gửi thử, xác nhận gửi ngay / hẹn giờ, kết quả, hủy.
- **App hành khách:** hộp thư, chuông có số tin chưa đọc thật, cài đặt thông báo nối API, chạm push theo loại tin, biểu tượng + kênh Android, Ví voucher nhận mã điền sẵn.
- **Sửa kèm:** làm mới token + khôi phục phiên + hết phiên; Back Android; vé đã đi; `setState`; bảng Điều kiện voucher; lọc điểm theo loại; số điểm lớn xuống dòng; thanh báo push không tự tắt.
- **Cấu hình:** `FIREBASE_API_KEY`, `FIREBASE_APP_ID` trong `apps/passenger_mobile/.env.local` và `.env.production` đã đúng với project Firebase (file không commit).

## Đã kiểm tra

| Phạm vi | Kết quả |
| ------- | ------- |
| API: `campaign-rules.spec`, `campaign.int.spec` (Postgres thật), `notification-campaign.http.spec`, `openapi.spec` | Đạt |
| Admin: Vitest `lib`, E2E `notifications.e2e.ts` | Đạt 68/68 và 2/2 với code cuối |
| App: `flutter analyze`, toàn bộ `flutter test`, `mobile_shared` | Analyze sạch; 334 đạt, 1 lỗi `system_navigation_bar_test` có từ `e3de0b9`; `mobile_shared` 37 đạt |
| Máy ảo Android + FCM thật | Mở lại còn phiên; 401 → refresh → gửi lại; thu hồi từ thiết bị khác, câu hết phiên một dòng; Back; vé đã đi; push khi app ở nền, đang mở, đang ở màn con và đã tắt tiến trình (`am kill`, tự khôi phục phiên rồi mở Hành trình); thanh báo tự tắt; hộp thư; Tin tức / Khuyến mãi tới đích; tắt loại tin; trần 24 giờ; đăng xuất gỡ thiết bị; chuông khách vãng lai; build từ cấu hình Firebase mới đăng ký push thành công |

Chưa kiểm tra: iOS / APNs, điện thoại thật, force stop, lượng lớn người nhận trên Upstash. Ảnh: `doc/report/screenshots/authenticated/INDEX.md`.

## Chờ Khanh (G1–G6)

| #  | Điểm | Đã làm theo | Cần Khanh |
| -- | ---- | ----------- | --------- |
| G1 | Dạng thông báo | Dịch vụ, Khuyến mãi, Tin tức; "Theo chuyến" để sau | Duyệt |
| G2 | Mặc định nhận | Ưu đãi bật, Tin tức tắt, theo màn Cài đặt | Duyệt |
| G3 | Giới hạn | Khuyến mãi 1 tin / 24 giờ; không gửi 21h–8h; hẹn tối đa 30 ngày | Duyệt con số |
| G4 | Re-auth khi gửi | Chưa yêu cầu nhập lại danh tính; chỉ có màn xác nhận số người nhận | Quyết có cần không |
| G5 | Nhà xe, Nhân viên | Chưa dùng được chiến dịch và hộp thư | Quyết phạm vi sau v1 |
| G6 | Worker production | Chưa có worker thường trực; chiến dịch hẹn giờ chỉ chạy khi bật worker | Quyết trước khi dùng thật |

## Việc còn lại

- Merge + deploy code (migration đã áp trước theo RB-07). Không sửa file migration `20261102090000_notification_campaign` vì đã áp trên production.
- Figma chưa có khung cho Hộp thư và màn Thông báo của Admin.
- Thu hồi phiên từ xa chưa tắt thiết bị push ngay; thiết bị chỉ tắt khi máy đó gặp 401 hoặc FCM báo `UNREGISTERED`.
- Tin hoàn tiền ghi "qua MoMo" với đơn DEMO (`notification-templates`), chưa sửa.
- `guest_journey_flow.dart`: SnackBar "Đăng nhập" có nút hành động nên không tự tắt, chưa sửa.
