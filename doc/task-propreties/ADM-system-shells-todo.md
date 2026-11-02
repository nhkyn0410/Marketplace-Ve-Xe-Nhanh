# Admin + Operator OS — Todo: Tích hợp & hệ thống (chỉ đọc) và khung các màn chờ đặt vé

> **Khanh (16/10/2026):** "Hiện còn những gì chưa hoàn thiện của phần admin và op thì làm giúp tôi" — "Tích hợp & hệ thống": **Làm phần chỉ đọc** (trang trạng thái + tác vụ nền, không chế độ bảo trì); màn phụ thuộc đặt vé (Đặt vé, Tài chính, Báo cáo, Tổng quan, Hoàn tiền, Chi trả, Khiếu nại, Khuyến mãi, VXN Plus): **Dựng khung giao diện trước** (trạng thái trống trung thực, không số liệu giả).
> Nguồn: Figma section `Giao diện Admin` (`1663:23890`): `ADM-01` Tổng quan (`1663:23894`), `ADM-07a…07d`, `ADM-08a…08c`, `ADM-09a…09e`, `ADM-11a/11b`, `ADM-12a…12d`, `ADM-14a`, `ADM-16a` (`1677:40455`), `ADM-16b` (`1677:40822`); section `Giao diện nhà xe · Màn bổ sung` (`1663:23891`): Đặt vé, Khuyến mãi, Tài chính, Báo cáo, Hỗ trợ. Task chính sở hữu từng màn: `TASK-BTP-002..006`, `TASK-ADM-002`, `TASK-TRUST-001`, `TASK-PROM-001/002`, `TASK-LOY-001`, `TASK-RPT-001/002`, `TASK-OPR-002/003`, `TASK-EMP-001/002`.
> **Nhánh:** làm tiếp trên `TASK-ADM-004`, chưa commit.

## Trạng thái (16/10/2026) — 🔨 **Code xong, chưa commit — chờ Khanh review + CI**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8).

## Đã làm

### Tích hợp & hệ thống (Admin `/system`, chỉ đọc)

- API `GET /admin/system/integrations`, `GET /admin/system/jobs` (`apps/api/src/admin/`), quyền mới **`system:read`** (PLATFORM_ADMIN).
- Tích hợp: **gọi thử thật** Postgres, Redis, Mongo audit, BullMQ, kho công khai / riêng tư (`head` một khóa không tồn tại; quá 3 giây = Lỗi) kèm thời gian phản hồi; **chỉ đọc cấu hình** Resend, Goong (không gửi / gọi thử — tránh gửi email / gọi dịch vụ ngoài khi mở trang); VNPay / MoMo / FCM-APNs = "Chưa tích hợp"; SMS = "Tắt" (ADR-020). Không trả khóa / bí mật.
- Tác vụ nền: đọc BullMQ — mỗi tác vụ (dọn phiên, dọn ảnh xe, dọn giấy tờ / KYC, smoke) có lịch (hiện "Hằng ngày · 03:00"), lần chạy kế (trễ > 5 phút → "Trễ lịch — kiểm tra worker"), lần chạy gần nhất (Hoàn tất / Lỗi + lý do / Đang chạy), số bản ghi xử lý, số lần lỗi; số job chờ / chạy / lỗi mỗi hàng đợi. Redis lỗi → "Không đọc được hàng đợi".
- Màn theo Figma ADM-16a / 16b: tab Tích hợp / Tác vụ nền, nút "Kiểm tra lại". **Không có** tab Bảo trì và nút "Chạy lại".

### Khung các màn chờ đặt vé

- Thành phần dùng chung `packages/ui/src/components/planned-screen.tsx`: thẻ số liệu hiện "—", bảng chỉ có tiêu đề cột theo Figma, trạng thái trống "Chưa có dữ liệu" + câu ghi rõ màn chờ chức năng / task nào; **không số liệu mẫu**.
- Admin: `/payments` (Thanh toán · Hoàn tiền), `/payouts`, `/disputes` (Khiếu nại · Tranh chấp), `/promotions` (Khuyến mãi nền tảng · Quyền của nhà xe), `/loyalty` (Tài khoản thành viên · Giao dịch điểm), `/reports` (Theo nhà xe · Yêu cầu xuất). Bỏ trang giữ chỗ `app/[...section]` (mọi mục thanh bên đã có trang).
- Admin Tổng quan (`/`, ADM-01): **số thật** cho "Nhà xe đang hoạt động", "Việc cần xử lý" (hồ sơ nhà xe chờ duyệt — đếm tối đa 20+, đề xuất điểm dừng, yêu cầu đổi tài khoản nhận tiền — có liên kết), "Trạng thái tích hợp" (từ `/admin/system/integrations`); chỉ số giao dịch / escrow / chi trả / tranh chấp / hoàn tiền hiện "—".
- Operator OS: `/bookings` (Đơn đặt vé · Hành khách theo chuyến), `/promotions` (mục **Khuyến mãi** thêm vào thanh bên sau Đặt vé — Khanh duyệt trên Figma 13/10/2026), `/finance` (Giao dịch · Chi trả), `/reports` (Theo tuyến · Nhân viên theo chuyến), `/support` (Khiếu nại · Tranh chấp · Đánh giá · Sự cố và nhật trình). Trang Tổng quan của Operator OS giữ nguyên (Figma chưa có màn này — làm cùng `TASK-RPT-001`).

## Chờ Khanh (G1–G7)

| #  | Điểm | Đã làm theo | Cần Khanh |
| -- | ---- | ----------- | --------- |
| G1 | Quyền trang hệ thống | Thêm `system:read` chỉ PLATFORM_ADMIN; Hỗ trợ nền tảng không xem | Duyệt / cho Hỗ trợ xem |
| G2 | Mức kiểm tra | Hạ tầng được gọi thử thật mỗi lần mở trang / bấm "Kiểm tra lại"; dịch vụ gửi đi chỉ kiểm cấu hình; không lưu lịch sử sự cố ("Sự cố gần nhất" của Figma chưa có dữ liệu) | Có cần lưu lịch sử / theo dõi định kỳ (Sentry / uptime đã chọn ở ADR-026) |
| G3 | Bảo trì / chạy lại | Không làm (Khanh chọn chỉ đọc) | Làm khi có nhu cầu vận hành |
| G4 | Hồ sơ chờ duyệt ở Tổng quan | API hàng đợi chưa trả `total` nên đếm một trang (hiện "20+") | Có cần thêm `total` cho `/admin/operator-applications` |
| G5 | Khung màn | Tab / cột lấy từ Figma; không bộ lọc, không nút hành động (chưa có dữ liệu để lọc / thao tác) | Duyệt |
| G6 | Mục Khuyến mãi Operator OS | Thêm vào thanh bên theo Figma; SDLC 06 §5 chưa có mục này | Cập nhật 06 §5 khi duyệt |
| G7 | Tổng quan Operator OS | Giữ trang cũ (chưa có Figma) | Thiết kế khi làm RPT-001 |

## Kiểm tra (16/10/2026)

- `apps/api/src/admin/system-status.service.spec.ts` 3 ca (DB lỗi → Lỗi, phần còn lại Hoạt động / Bản dev, chưa tích hợp, SMS tắt; có khóa → Đã cấu hình và không lộ khóa, production thiếu → Chưa cấu hình, kho riêng tư chưa có → OQ-21; tác vụ nền: nhãn, lịch, lần chạy kế, lần chạy gần nhất + lỗi rút gọn, Redis lỗi → không khả dụng). `system-status.http.spec.ts` 2 ca (guard 401 / 403 chủ nhà xe + hỗ trợ / 200 quản trị). Unit Admin `lib/system/system-format.test.ts` 3 ca.
- E2E Admin `policies.e2e.ts` ca 5 (Tổng quan: Việc cần xử lý có liên kết; Tích hợp: PostgreSQL Hoạt động, VNPay Chưa tích hợp, SMS Tắt; Tác vụ nền; Thanh toán & hoàn tiền: tiêu đề cột + "Chưa có dữ liệu", tab Hoàn tiền), `auth.e2e.ts` (Chi trả nhà xe là khung). E2E Operator OS `profile.e2e.ts` ca 4 (Khuyến mãi, Tài chính + tab Chi trả).
- Ảnh chụp Admin (Tổng quan, Tích hợp, Tác vụ nền, Chi trả) 1440 px; 390 px không tràn ngang. Màn khung Operator OS dùng cùng thành phần, chưa chụp riêng.
