# Đối soát tự động với cổng thanh toán (FR-BTP-17, UC-32) — Todo

> Khanh 19/10/2026: "Job đối soát tự động với cổng thanh toán" (TASK-ADM-002 G9 / BTP-006 G10). Thiết kế AI tự đề xuất, **chờ Khanh duyệt**. Nhánh `TASK-TRN-008`, chưa commit; chưa qua `code-reviewer` / `security-auditor`.

## Đã làm

- Cổng (port `PaymentGateway`): thêm `queryTransaction`.
  - VNPay `querydr` (merchant_webapi, ký HMAC-SHA512 chuỗi nối `|`, **kiểm chữ ký phản hồi**): `vnp_TransactionStatus` 00 / 04 / 05 / 06 / 09 → đã trả, 01 / 07 → còn chờ, khác → thất bại; mã 91 → không có giao dịch; 94 / 99 → lỗi thử lại.
  - MoMo `POST /v2/gateway/api/query` (ký HMAC-SHA256): 0 → đã trả, 1000 / 7000 / 7002 / 9000 → còn chờ, 42 → không có, khác → thất bại.
  - Cổng giả lập dev nhớ kết quả bấm trên trang giả lập (trong bộ nhớ API) để trả lời tra cứu.
- Migration `20261019030000_payment_reconciliation`: `payments.provider_checked_at` + index `(status, expires_at)`.
- Job `payment-reconciliation` (worker, mỗi 10 phút, concurrency 1):
  - Thanh toán `INITIATED` / `PROCESSING` / `EXPIRED` / `CANCELLED` đã quá hạn, tạo trong 48 giờ, chưa tra trong 30 phút → tra cứu cổng. Đã trả → áp như callback thành công (booking còn chờ → xác nhận + vé + email vé; không → "Cần đối soát" để Admin hoàn). Thất bại → payment thất bại. Không có / cổng lỗi → giữ nguyên.
  - Refund `APPROVED` quá 30 phút → xếp hàng lại **cùng jobId** của lần gửi (job còn trong hàng đợi thì BullMQ bỏ qua, không gọi cổng hai lần).
- Trang Tích hợp & hệ thống liệt kê job mới.

## Chờ Khanh

| # | Điểm | Đã làm theo |
|---|------|-------------|
| G1 | Tần suất / phạm vi | 10 phút, 48 giờ gần nhất, 100 thanh toán mỗi lần, không tra lại trong 30 phút |
| G2 | Đối soát sổ giữ hộ / kỳ chi trả (UC-32 bước 2) | Chưa làm — chỉ đối chiếu thanh toán + refund |
| G3 | Chạy lại thủ công từ trang Admin (UC-32 bước 1) | Chưa làm — trang Tích hợp & hệ thống vẫn chỉ đọc (Khanh 16/10) |
| G4 | Mã trạng thái cổng | Theo tài liệu công khai VNPay / MoMo; cần đối chiếu lại khi có tài khoản sandbox thật |

## Kiểm tra

- Unit adapter: VNPay querydr 2 ca (chuỗi ký + chữ ký đúng từng ký tự, ánh xạ trạng thái, 91 / 94 / chữ ký phản hồi sai), MoMo query 1 ca.
- `payment-reconciliation.int.spec.ts` 2 ca (Postgres + Redis thật): booking còn chờ → xác nhận + vé; booking hết hạn → cần đối soát `BOOKING_EXPIRED`; thất bại; không có / cổng lỗi giữ nguyên + không tra lại trong 30 phút; refund đứng yên xếp hàng lại đúng jobId, refund mới thì không.
- Suite payment / refund / payout / admin / external pass.
