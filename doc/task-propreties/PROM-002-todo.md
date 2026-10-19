# TASK-PROM-002 + LOY-001 — ví voucher và API hành khách

Ngày: 19/10/2026. Phạm vi backend `FR-LOY-04..07/09`, `FR-PROM-08..10`, `BR-71..73`; chưa chạy code-reviewer / security-auditor.

- `GET /me/loyalty`: điểm, hạng, hạng tiếp theo và chính sách hiện hành; `GET /me/loyalty/transactions`: lọc loại / thời gian, phân trang và tổng điểm.
- `POST /me/loyalty/redemptions`: bắt buộc `Idempotency-Key`; khóa tài khoản, xử lý điểm hết hạn rồi trừ điểm và tạo voucher trong cùng transaction. Gửi lại cùng khóa / số điểm trả đúng voucher cũ, khác số điểm trả conflict.
- `GET /me/vouchers`, `POST /me/vouchers`: ví theo trạng thái, lưu mã đang hiệu lực một lần, không giữ lượt promotion. Tiền của API ví dùng chuỗi số nguyên VND.
- `POST /bookings`: nhận `userVoucherId` hoặc `promotionCode`, gửi cả hai trả `422 VOUCHER_ONE_PER_BOOKING`; chỉ voucher của chính hành khách; giữ nguyên tử cùng transaction. Response thêm `discountFunding`.
- Voucher được giữ khi tạo đơn, tiêu khi thanh toán thành công, trả khi hết hạn / thanh toán thất bại / nhà xe hủy chuyến. Callback trả tiền sau lần thất bại chỉ nhận vào đơn nếu lấy lại được voucher và lượt promotion; nếu voucher đã sang đơn khác thì chuyển đối soát. Hành khách tự hủy vé không trả voucher.
- `PLATFORM_FUNDED_DISCOUNT` bù phần giảm loyalty vào sổ nhà xe; commission tính trên giá trước giảm loyalty. Hoàn tiền khách theo phần thực trả, đảo trợ giá và commission theo tỷ lệ lũy kế để không mất đồng lẻ / đảo quá mức. Kỳ chi trả và trang sổ giữ hộ tính đủ các bút toán này.
- Migration ví có FK / CHECK / partial unique, RLS chỉ platform / system; tenant dùng hàm giới hạn theo voucher + chủ sở hữu + booking / nhà xe, không đọc trực tiếp ví.
- Báo cáo Admin có voucher đã dùng và chi phí trợ giá thực tế, lọc hạng lúc đổi điểm. Job hiện tại hết hạn cả voucher khả dụng.
- Sự kiện tích điểm / đổi hạng và thu hồi điểm sau hoàn tiền ghi outbox `LOYALTY_UPDATED` trong transaction, worker gửi theo tùy chọn của hành khách; khóa theo sự kiện điểm nên chạy lại không tạo trùng.
- Đổi điểm, lưu voucher và điều chỉnh điểm của Admin có thông báo cá nhân không gắn nhà xe. Điểm / voucher sắp hết hạn được nhắc trước **7 ngày** (Khanh chốt 19/10/2026), chỉ nhắc phần điểm còn lại sau khi dùng, chống trùng theo lô điểm / voucher và áp dụng tùy chọn nhận.
- Tài khoản VXN Plus được khởi tạo sau xác minh OTP / OAuth thành công; đăng nhập lại không tạo thêm tài khoản.

Kiểm tra bổ sung: test BIGINT trợ giá / đảo nhiều lần; HTTP guard hành khách, ownership từ token, validation và khóa yêu cầu; integration đổi điểm song song / không âm, giữ voucher song song, RLS, trả khi hết hạn, thanh toán lỗi rồi callback muộn và đảo toàn bộ trợ giá khi hoàn hai lần. Kết quả tổng hợp và integration thật do lượt kiểm tra cuối của nhánh ghi nhận.

Còn: UI ví / VXN Plus phía web hành khách và Flutter (ngoài phạm vi backend lần này).
