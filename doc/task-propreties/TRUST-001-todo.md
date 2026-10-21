# Khiếu nại / hỗ trợ, tranh chấp, đánh giá (TASK-TRUST-001) — Todo

> Khanh 19/10/2026: "Khiếu nại/tranh chấp và Hỗ trợ (TRUST-001)". Schema / API / luồng trạng thái AI tự thiết kế theo SRS (FR-NSR-06..11, FR-DSP-01..08, BR-18/49/50/51/55, UC-09/27/28) + Figma ADM-09a–e, ADM-10a, "Nhà xe · Hỗ trợ" 01–03 — **chờ Khanh duyệt**. Nhánh `TASK-TRN-008`, chưa commit; chưa qua `code-reviewer` / `security-auditor`.

## Đã làm

- Migration `20261019040000_support_trust`: `support_tickets`, `support_messages`, `dispute_cases`, `dispute_events`, `support_attachments`, `reviews` (đều thuộc nhà xe của đơn, RLS `tenant_isolation`, CHECK đầy đủ), sequence mã `KN-YYYYMMDD-NNN` / `DC-NNNNNN`, `NotificationKind.CASE_UPDATED`.
- Quyền mới: `support:create` (khách vãng lai + hành khách, phạm vi own), `review:create` (chỉ hành khách), `support:respond` (chủ nhà xe, tenant), `support:manage` (PlatformAdmin + PlatformSupport), `dispute:decide` (chỉ PlatformAdmin). Kiểm duyệt đánh giá dùng `content:moderate` sẵn có.
- Khiếu nại (`support/`):
  - Khách: `GET/POST /bookings/{bookingId}/support-tickets`, xem, trả lời, tải / xem tệp (`X-Booking-Token` cho khách vãng lai).
  - Nhà xe: `/operator/support-tickets*` — chỉ thấy khiếu nại Vé Xe Nhanh đã chuyển cho mình; phản hồi khách (kèm tệp).
  - Admin: `/admin/support-tickets*` — lọc trạng thái / danh mục / nhà xe / người phụ trách / mã; phân loại (danh mục, ưu tiên, bên xử lý chính, người phụ trách); bên xử lý = nhà xe → "Chờ nhà xe" + nhà xe nhận email; trả lời / yêu cầu khách bổ sung; đã giải quyết / đóng.
- Tranh chấp (`dispute/`): Admin chuyển khiếu nại thành tranh chấp; yêu cầu minh chứng (bên + nội dung + hạn ≤ 30 ngày); đang xem xét / leo thang; quyết định (cần xác nhận lại danh tính): hoàn tiền → refund `APPROVED` trên thanh toán thành công, tối đa phần khách đã trả còn lại, worker hoàn qua cổng, khi xong trừ sổ giữ hộ nhà xe + trả lại hoa hồng tương ứng (MQ-03 "hoàn qua đầu nhà xe"); không hoàn / phương án khác; đóng. Nhà xe + khách gửi minh chứng; mỗi bên chỉ thấy minh chứng của chính mình (Admin thấy cả hai). Job `dispute-overdue` (worker, 15 phút): chờ một bên mà quá hạn → leo thang + sự kiện hệ thống (FR-DSP-05).
- Đánh giá (`review/`): hành khách (không phải khách vãng lai) đánh giá 1 lần mỗi đơn khi chuyến đã hoàn thành và có vé đã đi; nhà xe phản hồi / báo vi phạm (không sửa / xóa được); Admin giữ chờ / ẩn (bắt buộc lý do) / hiển thị lại; chỉ đánh giá đang hiển thị tính điểm trung bình (BR-55). Tín hiệu "Cần xem xét": nghi spam (số điện thoại / đường dẫn), nhà xe báo cáo, đơn đang tranh chấp, nội dung lặp.
- Tệp minh chứng: kho riêng tư (ADR-018) — xin URL tải thẳng, khóa server sinh theo nhà xe + nơi tải (khách của đơn / nhà xe / Vé Xe Nhanh), kiểm tồn tại, dung lượng ≤ 10 MB, loại PDF/JPEG/PNG, chữ ký định dạng; xem = URL 5 phút + audit mỗi lần. Production chưa có kho riêng tư (OQ-21) → 503 phần tệp.
- Email (FR-DSP-07): chuyển nhà xe, phản hồi cho khách, yêu cầu bổ sung / minh chứng, mở tranh chấp, quyết định, đóng — qua outbox thông báo sẵn có.
- UI Admin: Khiếu nại & tranh chấp (2 tab, chi tiết khiếu nại, chi tiết tranh chấp + hộp thoại yêu cầu minh chứng / đổi trạng thái / ra quyết định), Kiểm duyệt → tab Đánh giá (mặc định), Tổng quan có số tranh chấp đang mở + khiếu nại chưa phân loại.
- UI Operator OS: Hỗ trợ — Khiếu nại, Tranh chấp (banner yêu cầu + hạn, gửi giải trình), Đánh giá (điểm trung bình, phản hồi, báo vi phạm); tab "Sự cố và nhật trình" để trống (chờ app Nhân viên).
- Component dùng chung `packages/ui/components/attachments.tsx` (chọn / tải / mở tệp).

## Chờ Khanh

| # | Điểm | Đã làm theo |
|---|------|-------------|
| G1 | Khiếu nại không gắn đơn (hỗ trợ chung) | Chưa — mọi khiếu nại gắn một đơn (Figma luôn có "Đơn") |
| G2 | Nhà xe thấy khiếu nại khi nào | Chỉ sau khi Admin chọn bên xử lý chính = nhà xe lần đầu; thấy toàn bộ trao đổi (liên hệ khách đã che) |
| G3 | Mở tranh chấp trực tiếp từ đơn / thanh toán (FR-DSP-01) | Đã có `POST /admin/disputes` theo bookingId; nút trên chi tiết thanh toán Admin; `support:manage`, audit, thông báo hai bên; khóa đơn tránh gửi lặp tạo hai vụ trực tiếp đang mở |
| G4 | Quyết định "phương án khác" (đổi vé…) | Chỉ ghi quyết định + lý do, trạng thái "Đã quyết định · không hoàn"; không tự đổi vé |
| G5 | Ai được ra quyết định | Chỉ PlatformAdmin + xác nhận lại danh tính; PlatformSupport xử lý khiếu nại, yêu cầu minh chứng, đổi trạng thái |
| G6 | Hạn phản hồi / leo thang | Admin tự đặt (tối đa 30 ngày); quá hạn → "Đã leo thang" (job 15 phút) |
| G7 | Danh mục khiếu nại | 5 mục: thanh toán / hoàn tiền, giờ chạy, chất lượng dịch vụ, đổi vé, khác |
| G8 | Tín hiệu đánh giá nghi spam | Heuristic số điện thoại / đường dẫn / ký tự lặp — cần quy tắc chính thức |
| G9 | Nhà xe thấy đánh giá đã ẩn? | Không (chỉ đang hiển thị + giữ chờ) |
| G10 | Thẻ đánh giá trên báo cáo nhà xe / cột đánh giá báo cáo Admin, scorecard (FR-NSR-11), hồ sơ công khai (MKT-001) | Đã nối báo cáo và hồ sơ công khai; chỉ review VISIBLE tính điểm; chỉ số thiếu dữ liệu trả null — xem `MKT-backend-todo.md` |
| G11 | Danh sách khiếu nại của hành khách trên mọi đơn (`/me/...`) | Đã có `/me/support-tickets`, `/me/disputes` kèm `/me/bookings`, `/me/tickets`; phân trang và lọc qua booking.userId từ token; app hành khách chưa làm |

## Kiểm tra

- `support.int.spec.ts` 3 ca (Postgres + Redis thật): luồng khiếu nại đầy đủ + tenant / chưa chuyển → 404 + khóa tệp của bên khác bị từ chối + audit xem tệp; tranh chấp (mở lần hai 409, mỗi bên chỉ thấy minh chứng mình, quá hạn → leo thang, hoàn vượt phần đã trả 422, refund + `REFUND_PENDING` → hoàn xong trừ sổ giữ hộ + đơn về đã xác nhận, quyết định lần hai 409, đóng); đánh giá (BR-18, một lần, phản hồi / báo cáo / cần xem xét / ẩn → hết tính điểm).
- `support.http.spec.ts` 3 ca: guard thật cho khách / nhà xe / Admin / Hỗ trợ, quyết định cần xác nhận lại danh tính + chỉ Admin, validate body.
- Unit: mẫu email `CASE_UPDATED`, `support-format` (Admin 4, Operator 2).
- E2E: `operator-os/e2e/support.e2e.ts` (3, gồm tải tệp minh chứng), `admin/e2e/trust.e2e.ts` (3, tài khoản E2E riêng `platformTrust`); sửa `moderation-audit.e2e.ts` (tab mặc định giờ là Đánh giá).
