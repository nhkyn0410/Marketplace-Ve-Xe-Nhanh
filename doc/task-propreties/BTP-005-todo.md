# TASK-BTP-005 — Todo: Hủy vé + hoàn tiền (theo chính sách lưu lúc đặt)

> **Khanh (17/10/2026):** lõi đặt vé theo lát dọc (SRS / ADR); thanh toán = adapter VNPay / MoMo thật + cổng giả lập dev; không làm giao diện khách hàng.
> Nguồn: UC-08, FR-BTP-12..14/18, BR-06/07/35, SRS §17.6 / §17.7 / §17.9, OQ-13 (refund API riêng từng cổng), API §8 (idempotency refund), DB §4 `refunds` + §7. Bảng / API / mã lỗi bổ sung AI tự đề xuất, **chờ Khanh duyệt**.
> **Nhánh:** `TASK-TRN-004` (làm tiếp), chưa commit.

## Trạng thái (18/10/2026) — 🔨 **Backend xong, chưa commit — chờ Khanh duyệt + review**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8). Màn hủy vé phía khách hàng không làm. Hoàn tiền thủ công / chạy lại của Admin để màn ADM-002.

## Đã làm

- Migration `20261017070000_refunds`: enum `RefundStatus` (6 trạng thái SRS §17.9); bảng `refunds` (mã `RFD` + 12 ký tự gửi cổng, tiền BIGINT > 0, % hoàn 1–100, `provider_refund_id`, `failure_code`, `requested_by`, `processed_at`) + `refund_status_histories`; `tickets.refund_id`. RLS `tenant_isolation`.
- Tiền hoàn (`refund/refund-policy.ts`): mốc hủy CHỤP lúc đặt (`snapshot.cancellationPolicy`, BR-07) — mốc có số giờ lớn nhất mà vẫn ≤ số giờ còn lại tới giờ khởi hành; tiền = giá vé × % ÷ 100, **làm tròn xuống tới đồng cho từng vé** (BIGINT).
- `GET /bookings/{id}/cancellation-quote?ticketIds=a,b` — mọi vé kèm hủy được không + lý do, mốc đang áp dụng, tổng chọn / số hoàn / phần không hoàn.
- `POST /bookings/{id}/cancellations { ticketIds, expectedRefund, reason }` (khách vãng lai dùng `X-Booking-Token`, hành khách sở hữu booking; `refund:request`): một transaction khoá booking → kiểm lại từng vé (`VALID`, chuyến chưa khởi hành / chưa hủy / chưa sự cố) → số hoàn khác `expectedRefund` (vừa qua mốc) → 409 `REFUND_AMOUNT_CHANGED` kèm số mới → vé `VALID → CANCELLED` (có điều kiện) → chỗ trả về bán lại → số hoàn > 0 thì tạo refund `APPROVED` (đủ điều kiện theo chính sách, không duyệt tay) → suy lại trạng thái booking. Hủy một phần được (UC-08 A3); số hoàn = 0 vẫn hủy, không tạo refund (A4). Gửi lặp / đồng thời → đúng một lần, lần kia 409.
- Trạng thái booking suy từ vé + refund: còn refund đang xử lý → `REFUND_PENDING`; có refund thất bại → `REFUND_FAILED`; còn vé hiệu lực → `PARTIALLY_CANCELLED`; hết vé + đã hoàn → `REFUNDED`; hết vé không hoàn → `CANCELLED`.
- Hoàn qua cổng ở worker (hàng đợi `refund-processing`, job theo refund, thử lại backoff 6 lần): `APPROVED → PROCESSING` → gọi API hoàn của cổng ngoài transaction (mã refund làm mã yêu cầu — cổng tự chặn trùng) → `SUCCESS` (vé `CANCELLED → REFUNDED`) hoặc `FAILED` khi cổng từ chối dứt khoát / hết lượt thử (UC-08 A5 → Admin xử lý tay).
- Adapter: VNPay `merchant_webapi` (`vnp_Command=refund`, loại 02 toàn phần / 03 một phần, ký HMAC-SHA512 chuỗi nối `|`, **kiểm chữ ký phản hồi**; mã 94 / 99 thử lại); MoMo `/v2/gateway/api/refund` (ký HMAC-SHA256; 7000 / 7002 / 99 thử lại). Cổng giả lập dev có thêm 2 endpoint hoàn; khóa giả lập đổi sang **cố định chỉ cho dev** để API và worker (hai tiến trình) ký khớp nhau. Biến mới `VNPAY_API_URL` (mặc định sandbox).
- `GET /bookings/{id}` thêm `refunds`. Link thanh toán VNPay dùng đúng giờ tạo payment (hoàn tiền gửi lại `vnp_TransactionDate`).
- Sửa guard "khách vãng lai / hành khách": chỉ nhận quyền ở phạm vi `own` — trước đó chủ nhà xe (có `refund:request` theo tenant) lọt vào route hủy vé của khách.

## Chờ Khanh (G1–G8)

| #  | Điểm | Đã làm theo | Cần Khanh |
| -- | ---- | ----------- | --------- |
| G1 | Bảng / cột refund | Thiết kế ở trên (DB §4 chỉ có tên bảng + unique) | Duyệt |
| G2 | Làm tròn tiền hoàn | Xuống tới đồng, từng vé | Duyệt |
| G3 | Duyệt refund | Hủy đúng chính sách → `APPROVED` tự động (không qua Admin); ngoại lệ / tranh chấp → Admin (ADM-002, UC-27) | Duyệt |
| G4 | Hủy sát giờ (mốc 0%) / booking không có mốc hủy | Vẫn cho hủy, hoàn 0, không tạo refund (UC-08 A4) | Duyệt |
| G5 | Khách vãng lai mất mã truy cập | Chưa hủy được qua API (tra cứu chỉ xem); xác minh bổ sung (OTP) theo Security §8 / UC-35 chưa làm | Quyết |
| G6 | Xếp hàng job hoàn lỗi (Redis) | Refund vẫn `APPROVED` trong DB, chờ Admin chạy lại (ADM-002); chưa có job quét | Duyệt |
| G7 | Chỗ sau khi hủy | Trả `AVAILABLE` ngay (đóng bán theo giờ ngừng bán online của chuyến) | Duyệt |
| G8 | Mã lỗi mới | `CANCELLATION_NOT_ALLOWED`, `REFUND_AMOUNT_CHANGED`, `CANCELLATION_TICKETS_INVALID` | Duyệt → thêm GLOSSARY |

## Kiểm tra (18/10/2026)

- `refund-policy.spec.ts` 3 ca (chọn mốc + biên, quá giờ / không mốc, BIGINT làm tròn xuống, % sai → lỗi). Adapter: VNPay hoàn 2 ca (chuỗi ký + chữ ký đúng từng ký tự, 02 / 03, phân loại 91 / 94 / chữ ký phản hồi sai / mất mạng), MoMo hoàn 1 ca.
- `cancellation.int.spec.ts` 5 ca trên Postgres + Redis thật, role app: điều kiện 90% + làm tròn (333.333đ → 299.999đ), vé lạ 422, thiếu mã 404; hủy một phần (số lệch 409 kèm số mới, refund `APPROVED`, vé gắn refund, chỗ trả lại, job xếp hàng, hủy lại 409), worker thành công → `REFUNDED` / `PARTIALLY_CANCELLED`, chạy lại bỏ qua; lỗi tạm thời thử lại → lần cuối `FAILED`, từ chối dứt khoát `FAILED`, booking `REFUND_FAILED`; mốc 0% hủy không refund → `CANCELLED`; vé check-in / chuyến đã khởi hành → không hủy kèm lý do; **hủy đồng thời → đúng một refund**; **RLS: tenant khác không thấy refund**.
- `cancellation.http.spec.ts` 6 ca (guard: khách vãng lai / hành khách được, chủ nhà xe 403; danh sách vé phân tách dấu phẩy; 5 ca body sai → 400).
- Chạy thật (build + API + worker, DB dev): đặt → thanh toán VNPay giả lập → `CONFIRMED` + 2 vé → hủy 1 vé 90% → worker hoàn qua cổng giả lập → refund `SUCCESS`, vé `REFUNDED`, booking `PARTIALLY_CANCELLED`; đã xóa dữ liệu thử.
- Toàn bộ API: 133 file / 1484 test — 1482 pass, 2 ca quá 5 giây do máy vừa khởi động (OpenAPI, MFA) chạy lại riêng pass; lint + typecheck sạch.
