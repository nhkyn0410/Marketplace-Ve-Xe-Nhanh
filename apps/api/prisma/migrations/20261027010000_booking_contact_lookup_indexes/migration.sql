-- Chỉ mục tra cứu đơn theo thông tin liên hệ (Khanh 27/10/2026, chờ duyệt):
--   1. (`contact_email`, `created_at` DESC) — tra cứu vé khách vãng lai bằng email đã xác minh OTP, đơn 12 tháng gần nhất,
--      mới nhất trước (`POST /guest/ticket-lookup/otp`, `/guest/ticket-lookup/bookings`). `contact_email` luôn lưu chữ thường.
--   2. (`contact_phone`, `created_at` DESC) — tra theo số điện thoại liên hệ (CSKH / tra cứu bằng SĐT khi có SMS).
-- Bảng `bookings` còn nhỏ ở v1 nên tạo chỉ mục thường trong transaction của migrate (không CONCURRENTLY).

SET LOCAL lock_timeout = '10s';

-- CreateIndex
CREATE INDEX "bookings_contact_email_created_at_idx" ON "bookings"("contact_email", "created_at" DESC);

-- CreateIndex
CREATE INDEX "bookings_contact_phone_created_at_idx" ON "bookings"("contact_phone", "created_at" DESC);
