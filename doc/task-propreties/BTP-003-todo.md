# TASK-BTP-003 — Todo: Thanh toán VNPay / MoMo + webhook + dedup

> **Khanh (17/10/2026):** "Adapter thật + cổng giả lập dev" — adapter VNPay (HMAC-SHA512) / MoMo (HMAC-SHA256) thật, khóa sandbox gắn sau qua `.env`; cổng giả lập chỉ cho dev / test. Lõi đặt vé theo lát dọc, không làm giao diện khách hàng.
> Nguồn: LLD §6.3, FR-BTP-07..09/18, BR-27/28, SRS §17.8, ADR-019, API §7.2 / §8 / §10.1, LLD §7 mã lỗi. Bảng / cột / mã lỗi bổ sung AI tự đề xuất, **chờ Khanh duyệt**.
> **Nhánh:** `TASK-TRN-004` (làm tiếp), chưa commit.

## Trạng thái (17/10/2026) — 🔨 **Backend xong, chưa commit — chờ Khanh duyệt + review**

- Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu — `CLAUDE.md` §4.8). Phần Mobile (mở cổng ngoài app + deep link) và màn hình khách hàng: không làm (phạm vi khách hàng).
- Tiền thật: KHÔNG — mặc định URL sandbox; production chưa khai khóa thì cổng tắt (OQ-22 giấy phép TGTT vẫn là blocker).

## Đã làm

- Migration `20261017050000_payments`: enum `PaymentProvider` (VNPAY, MOMO), `PaymentStatus` (đủ 7 trạng thái SRS §17.8); bảng `payments` (mã `PAY` + 12 ký tự gửi cổng, tiền BIGINT > 0, `payment_url`, `provider_txn_id`, `failure_code`, `reconcile_reason`, `callback` JSONB, hạn = hạn booking) + **unique `(provider, provider_txn_id)`** (ADR-019) + partial unique "mỗi booking tối đa một payment đang mở mỗi cổng"; `payment_status_histories`. RLS `tenant_isolation`.
- Port `external/payment/payment-gateway.ts` + `VnpayGateway` (PAY v2.1.0: ký chuỗi `vnp_*` sắp tên, khoảng trắng `+`, số tiền × 100, giờ GMT+7; xác thực IPN, kiểm `vnp_TmnCode`) + `MomoGateway` (AIO v2 `captureWallet`: ký chuỗi cố định theo tài liệu, gọi `/v2/gateway/api/create` có timeout; xác thực IPN, kiểm `partnerCode`). So chữ ký thời gian hằng.
- Cổng giả lập dev (`/v1/dev/payment-gateway/{vnpay,momo}`, ngoài OpenAPI): chỉ bật khi KHÔNG phải production và cổng chưa khai khóa; dùng chính adapter thật với khóa sinh mỗi lần chạy; trang chọn "thành công / thất bại" → gửi IPN đã ký về webhook của API (như cổng thật) → đưa trình duyệt về trang kết quả.
- `POST /bookings/{bookingId}/payments { provider }` (`payment:create`, khách vãng lai dùng `X-Booking-Token`): booking phải của người gọi, `PENDING_PAYMENT`, còn hạn (hết hạn → 409 `BOOKING_EXPIRED`, đã trả / hủy → 409 `BOOKING_INVALID_STATE`), số tiền trong giới hạn cổng (VNPay 5.000đ–<1 tỷ, MoMo 1.000đ–50 triệu → 422). Gọi lặp cùng cổng → trả lại đúng payment đang mở (idempotent theo booking + cổng); không gọi cổng khi đang giữ transaction; cổng lỗi → 502 + payment `FAILED`; cổng chưa cấu hình → 503.
- Webhook IPN `GET /v1/webhooks/payment/vnpay` (trả `RspCode` 00 / 01 / 02 / 04 / 97 / 99 đúng kịch bản VNPay) và `POST /v1/webhooks/payment/momo` (204 / 400 / 503): xác thực chữ ký → kiểm nhanh → xếp hàng BullMQ `payment-callbacks` (`jobId` theo giao dịch, thử lại backoff) → worker xử lý.
- Worker `payment-callback` (một transaction, khoá payment rồi booking): thất bại → `FAILED` (giữ mã cổng, khách thanh toán lại được); thành công + booking còn chờ + còn giữ đủ ghế → payment `SUCCESS`, booking `PAID`, ghế `BOOKED`, payment đang mở ở cổng khác → `CANCELLED`; lệch số tiền / booking đã hết hạn / đã hủy / đã trả bằng payment khác / ghế đã trả → `RECONCILING` kèm lý do (không nhận vào booking, không âm thầm bỏ qua); callback lặp → không đổi gì.
- Job hết hạn booking (BTP-002) đóng luôn payment đang mở → `EXPIRED`. `GET /bookings/{id}` thêm `payment` (payment thành công, không có thì lần gần nhất) cho trang kết quả.
- `.env.example` ghi các biến `VNPAY_*`, `MOMO_*`, `PAYMENT_RETURN_BASE_URL`; khai dở khóa một cổng → API từ chối khởi động.

## Chờ Khanh (G1–G9)

| #  | Điểm | Đã làm theo | Cần Khanh |
| -- | ---- | ----------- | --------- |
| G1 | Bảng / cột payment | Thiết kế ở trên (DB §4 chỉ có tên bảng + unique) | Duyệt |
| G2 | Idempotency tạo payment (API §8 "booking id + method + client key") | Theo booking + cổng (partial unique), không đòi header `Idempotency-Key` | Duyệt / yêu cầu thêm header |
| G3 | Xử lý IPN | Kiểm nhanh đồng bộ (để trả đúng mã VNPay) + ghi tiền ở worker (ADR-019 async). **Dev cần chạy cả worker** (`pnpm --filter @vexenhanh/api dev:worker`) thì payment mới chuyển `SUCCESS` | Duyệt |
| G4 | Tiền về sau khi booking hết hạn / đã trả bằng cổng khác | `RECONCILING` + lý do; hoàn tiền / đối soát để BTP-005 / BTP-006 (querydr) | Duyệt |
| G5 | Mã lỗi mới | `PAYMENT_IN_PROGRESS`, `PAYMENT_AMOUNT_OUT_OF_RANGE`, `PAYMENT_PROVIDER_UNAVAILABLE`, `PAYMENT_PROVIDER_ERROR` (ngoài LLD §7) | Duyệt → thêm GLOSSARY |
| G6 | Trang quay về | `{PAYMENT_RETURN_BASE_URL}/bookings/{id}/payment/result` — khớp route web hành khách đang dựng; app di động dùng cùng link (universal link) khi làm Mobile | Duyệt |
| G7 | Cổng giả lập dev | Route `/v1/dev/payment-gateway/*` (404 ở production / khi đã khai khóa) | Duyệt |
| G8 | Hiển thị `vnp_IpAddr` | IP tin cậy của request (sau proxy tin cậy); không có thì `127.0.0.1` | — |
| G9 | Đối soát `querydr` định kỳ (FR-BTP-17) | Chưa làm — thuộc BTP-006 | — |

## Kiểm tra (17/10/2026)

- `vnpay-gateway.spec.ts` 3 ca (chuỗi ký + chữ ký đúng từng ký tự; IPN hợp lệ / thất bại / mã 00 nhưng trạng thái khác 00; sửa số tiền / thiếu chữ ký / khóa khác / sai merchant / lẻ xu → từ chối). `momo-gateway.spec.ts` 4 ca (chữ ký tạo giao dịch, MoMo từ chối / HTTP lỗi / mất mạng → lỗi không lộ khóa, IPN hợp lệ / thất bại, sửa / thiếu / sai đối tác / khóa khác → từ chối).
- `payment.int.spec.ts` 7 ca trên Postgres + Redis thật, role app (adapter VNPay thật): tạo payment + link + gọi lặp trả payment cũ + cần mã truy cập; IPN thành công → `SUCCESS` / `PAID` / `BOOKED` / hủy payment MoMo đang mở, IPN lặp → 02, xử lý lặp → DUPLICATE; **hai worker xử lý đồng thời cùng callback → đúng một lần ghi tiền**; chữ ký sai 97, mã lạ 01, lệch số tiền 04 + `RECONCILING`; thất bại → `FAILED` rồi thanh toán lại thành công; booking quá hạn → payment `EXPIRED`, tiền về sau → `RECONCILING BOOKING_EXPIRED`, ghế vẫn trống; cổng lỗi 502 / chưa cấu hình 503; **RLS: tenant khác không thấy payment**.
- `payment.http.spec.ts` 9 ca (guard: khách vãng lai / hành khách được, chủ nhà xe / Admin 403, cổng lạ 400; 5 mã IPN VNPay + 99 khi lỗi; MoMo 204 / 400 / 503; cổng giả lập VNPay + MoMo chạy trọn vòng với chữ ký thật, link bị sửa → 404, cổng tắt → 404).
- Chạy thật (build + API + worker, DB dev): giữ chỗ → đặt → `POST /payments` → trang giả lập → IPN → worker → booking `PAID`, payment `SUCCESS`; đã xóa dữ liệu thử.
- Toàn bộ API: 127 file / 1454 test pass (trước bước sửa lint cuối; test payment chạy lại sau đó pass); lint + typecheck sạch.
