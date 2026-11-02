# TASK-BTP-004 — Todo: Phát hành vé điện tử + QR

> **Khanh (17/10/2026):** lõi đặt vé theo lát dọc, mỗi chỗ một vé + QR (SRS / ADR), không làm giao diện khách hàng.
> Nguồn: FR-BTP-10/11/18, BR-04/25/29, SRS §17.6 / §17.7, LLD §6.3 bước 3 + §6.4 bước 2, DB §4 (`tickets`, `ticket_qr_tokens`) + §7 (unique `ticket_code`, `qr_token_hash`), API §7.2 (`/tickets/{ticketId}`, `/guest/ticket-lookup`), API §8 (phát hành idempotent), Security §8 (tra cứu khách vãng lai). Chi tiết AI tự quyết, **chờ Khanh duyệt**.
> **Nhánh:** `TASK-TRN-004` (làm tiếp), chưa commit.

## Trạng thái (17/10/2026) — 🔨 **Backend xong, chưa commit — chờ Khanh duyệt + review**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8). Màn vé phía khách hàng (web / app) không làm; soát vé QR ở app nhân viên thuộc TASK-EMP-002.

## Đã làm

- Migration `20261017060000_tickets`: enum `TicketStatus` (6 trạng thái SRS §17.7); bảng `tickets` (mã vé `{mã booking}-NN`, unique `ticket_code`, `qr_token_hash`, **unique `passenger_info_id`** = mỗi chỗ đúng một vé, phát hành lặp không trùng) + `ticket_status_histories`; RLS `tenant_isolation`.
- QR: token = HMAC-SHA256(khóa server `TICKET_QR_SECRET`, `ticket-qr:v1:{ticketId}`) dạng base64url — không đoán được, không chứa dữ liệu vé (BR-29). DB chỉ lưu SHA-256 của token; mở vé thì tính lại token để hiển thị. `TICKET_QR_SECRET` bắt buộc ở production; dev / test thiếu thì dùng khóa cố định chỉ cho dev.
- Phát hành trong CÙNG transaction ghi nhận thanh toán thành công (BR-28): vé `VALID` cho mọi chỗ → booking `PAID → CONFIRMED` (SRS §17.6) + lịch sử vé / booking.
- `GET /bookings/{id}` thêm `tickets` (mã vé, chỗ, hành khách, trạng thái, `qrToken`).
- `GET /tickets/{ticketId}`: vé của booking hành khách / khách vãng lai có `X-Booking-Token`; không quyền = 404 `TICKET_NOT_FOUND`.
- `POST /guest/ticket-lookup { bookingCode, phone | email }`: đúng mã + đúng liên hệ lúc đặt → booking kèm vé; sai bất kỳ → cùng một 404 (chống dò); giới hạn 10 lần / 10 phút / IP (Redis lỗi → 503, không bỏ giới hạn). Mã nhập chữ thường / có gạch vẫn nhận.

## Chờ Khanh (G1–G6)

| #  | Điểm | Đã làm theo | Cần Khanh |
| -- | ---- | ----------- | --------- |
| G1 | Bảng `ticket_qr_tokens` (DB §4) | Chưa tách bảng: v1 không xoay QR, hash nằm ở `tickets.qr_token_hash` (đúng DB §7). Xoay QR sau này = đổi `v1` → `v2` hoặc thêm bảng | Duyệt |
| G2 | Mã vé | `{mã booking}-01`, `-02`… theo thứ tự mã chỗ | Duyệt |
| G3 | QR | HMAC khóa server, tính lại khi hiển thị (không lưu token) | Duyệt |
| G4 | `PAID` → `CONFIRMED` | Cùng transaction với thanh toán (phát hành vé không lỗi riêng được) | Duyệt |
| G5 | Tra cứu khách vãng lai | Mã booking + SĐT **hoặc** email; 10 lần / 10 phút / IP | Duyệt (UX-OQ-09 đang mở — Figma vẽ email) |
| G6 | `GET /tickets/{id}` | Cho cả khách vãng lai có mã truy cập booking (API §7.2 ghi "User") | Duyệt |

## Kiểm tra (17/10/2026)

- `payment.int.spec.ts` thêm ca vé (Postgres + Redis thật, role app): thanh toán thành công → 2 vé `VALID` mã `-01` / `-02`, DB chỉ lưu hash khớp `qrToken`, hai vé khác token, lịch sử vé; **phát hành lặp → 0 vé mới**; xem vé đúng / thiếu / sai mã truy cập; tra cứu bằng mã chữ thường + SĐT có khoảng trắng / email chữ hoa, sai SĐT / sai mã → 404, lần thứ 11 → 429; **RLS: tenant khác không thấy vé**. Các ca thanh toán cập nhật kỳ vọng `CONFIRMED` + lịch sử `PAID → CONFIRMED`.
- `ticket.http.spec.ts` 2 ca (guard, header mã truy cập, chuẩn hoá mã booking, thiếu / thừa liên hệ / mã sai dạng → 400).
- Toàn bộ API: 130 file / 1467 test pass; lint + typecheck sạch.
