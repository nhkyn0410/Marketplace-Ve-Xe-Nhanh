# VXN Plus phía Admin (TASK-LOY-001) — Todo

> Khanh 18/10/2026 (LLD-OQ-06): dùng số liệu Figma + tỷ lệ tích **1 điểm cho mỗi 10.000 ₫**, Admin sửa được. Khanh 19/10/2026: "VXN Plus phía Admin (LOY-001)". Schema / API AI tự thiết kế theo SRS (FR-LOY-01..03/08/10..12, BR-65..71, UC-36, UC-39) + Figma ADM-12a…12d — **chờ Khanh duyệt**. Nhánh `TASK-TRN-008`, chưa commit; chưa qua `code-reviewer` / `security-auditor`.

## Đã làm

- Migration `20261019060000_loyalty`: `loyalty_accounts` (một tài khoản / hành khách, số dư ≥ 0), `loyalty_point_transactions` (sổ điểm **chỉ ghi thêm** — trigger chặn sửa / xóa; dấu điểm theo loại bằng CHECK; hạng lúc ghi, số tiền căn cứ, phiên bản chính sách, khóa chống trùng). RLS: chỉ scope platform / system — nhà xe không đọc được. Enum `LoyaltyTier` (Đồng / Bạc / Vàng / Bạch kim), `PolicyType` thêm `LOYALTY`.
- Migration `20261019060100_loyalty_seed`: chính sách VXN Plus phiên bản 1 — 10.000 ₫ / điểm, 1 điểm = 1.000 ₫ khi đổi, đổi tối thiểu 100 điểm, voucher 30 ngày, hạng 0 / 2.000 / 5.000 / 10.000 điểm với hệ số ×1 / ×1,2 / ×1,5 / ×2, hạn điểm 12 tháng.
- Job `loyalty-maintenance` (worker, 10 phút / lần, hàng đợi `loyalty-maintenance`, hiện ở trang Tích hợp & hệ thống):
  - **Tích** (BR-66): đơn của hành khách có tài khoản (khách vãng lai không tích), đã thanh toán, chuyến `COMPLETED` → một lần / đơn; căn cứ = tiền khách thực trả của vé không ở `CANCELLED` / `REFUNDED` / `NO_SHOW` (đã trừ phần giảm khuyến mãi) − tiền hoàn theo số tiền đã xong; điểm = làm tròn xuống (căn cứ × hệ số hạng ÷ đơn vị), tính BIGINT.
  - **Thu hồi** (BR-67): hoàn tiền thành công sau khi đã tích → thu theo tỷ lệ tiền hoàn / căn cứ; số dư không đủ → thu tối đa số dư, ghi phần thiếu vào lý do, không thu lại sau.
  - **Hết hạn** (BR-70): điểm tích trước dùng / hết hạn trước; chạy lại không ghi thêm.
  - Khóa tài khoản + khóa chống trùng: chạy lại / chạy song song không ghi trùng.
- Admin (`loyalty:manage`, chỉ Quản trị viên nền tảng), theo đường dẫn 05 API §7.5: `GET /admin/loyalty/accounts?email=`, `GET /admin/loyalty/accounts/{userId}/transactions`, `POST /admin/loyalty/accounts/{userId}/adjustments` (cần xác nhận lại danh tính; header `Idempotency-Key` bắt buộc như 05 API §8; không cho âm; audit `loyalty.adjust` kèm lý do), `GET /admin/loyalty/reports?year&quarter&tier`.
- Tham số chương trình dùng API chính sách chung (`/admin/policies/LOYALTY`, quyền `finance:configure`): phiên bản có ngày hiệu lực ở tương lai, lý do + mã xác thực khi kích hoạt; trang xem phiên bản hiển thị nội dung VXN Plus, nháp VXN Plus soạn ở màn `/loyalty`.
- Màn Admin `/loyalty` (Figma ADM-12a…12d): Chính sách chương trình, Tài khoản thành viên (tra cứu email, thẻ hạng / điểm / điểm tích 12 tháng / còn bao nhiêu lên hạng, lịch sử điểm "Tải thêm", hộp thoại Điều chỉnh điểm), Báo cáo (quý, lọc hạng, xuất CSV số liệu tổng hợp).

## Chờ Khanh

| # | Điểm | Đã làm theo |
|---|------|-------------|
| L1 | Hạn dùng điểm (Figma chưa có số) | 12 tháng kể từ ngày tích — Admin đổi được bằng phiên bản mới |
| L2 | Tạo `LoyaltyAccount` "khi đăng ký" (FR-LOY-01) | Đã tạo sau xác minh OTP / OAuth thành công (19/10/2026), chống trùng theo userId; dữ liệu hành khách cũ vẫn được tạo bổ sung khi có giao dịch đầu tiên |
| L3 | Điểm tích 12 tháng để xếp hạng | Tích − thu hồi (không trừ điểm đã đổi / hết hạn — BR-68) |
| L4 | Điểm Admin cộng tay có hạn không | Có, cùng hạn điểm tích; điểm cộng tay **không** tính vào xếp hạng |
| L5 | Thu hồi khi hoàn tiền theo quyết định tranh chấp (không gắn vé) | Theo tỷ lệ số tiền hoàn / số tiền căn cứ lúc tích |
| L6 | Hết hạn khi chính sách rút ngắn hạn điểm | Lô sắp hết hạn coi như dùng trước — nếu hạn mới ngắn hơn hạn cũ, thứ tự có thể lệch nhẹ so với "tích trước dùng trước" |
| L7 | "Điểm phát hành" trong báo cáo | Tích + điều chỉnh cộng (không gồm thu hồi / điều chỉnh trừ) |
| L8 | Lọc báo cáo theo hạng | Theo hạng của thành viên lúc ghi từng giao dịch |
| L9 | Lệch so với 05 API §7.5 | Tra cứu theo email (`GET /admin/loyalty/accounts?email=`) + lịch sử tách riêng thay cho `GET /admin/loyalty/accounts/{userId}`; tham số qua API chính sách chung `/admin/policies/LOYALTY` thay cho `/admin/loyalty/policy`. Quyền `loyalty:manage` chỉ PlatformAdmin (Hỗ trợ nền tảng không xem) |
| L10 | Xuất báo cáo | CSV tạo ở trình duyệt từ số liệu tổng hợp (không dữ liệu cá nhân) — không ghi audit như xuất báo cáo hệ thống |

## Chưa làm (ngoài phạm vi "phía Admin")

- Backend đổi điểm, ví voucher và phần giảm Vé Xe Nhanh chịu đã làm cùng TASK-PROM-002 (19/10/2026). Báo cáo đọc số voucher đã thanh toán và chi phí trợ giá ròng từ sổ giữ hộ, bao gồm bút toán đảo khi hoàn tiền; còn UI hành khách.
- Màn VXN Plus của hành khách (web + `passenger_mobile`, FR-LOY-04/05).
- Đã nối thông báo tùy chọn khi tích điểm / đổi hạng, thu hồi, đổi điểm, lưu voucher và điều chỉnh Admin. Nhắc điểm / voucher sắp hết hạn trước **7 ngày** theo lựa chọn của Khanh ngày 19/10/2026; thông báo cá nhân không phụ thuộc nhà xe, chống trùng và áp dụng tùy chọn nhận (FR-LOY-08, UC-39 bước 5).

## Kiểm tra

- `loyalty-rules.spec.ts` (6): tích điểm làm tròn xuống, BIGINT số lớn; hạng + hạng kế; thu hồi theo tỷ lệ; hết hạn; cộng tháng theo lịch; kiểm schema chính sách.
- `loyalty.int.spec.ts` (4, Postgres + Redis thật): tích một lần — **hai lần chạy song song → đúng một giao dịch**, vé vắng mặt + khách vãng lai không tính; thu hồi khi số dư không đủ ghi phần thiếu, chạy lại không thu thêm; hệ số hạng Bạc ×1,2; hết hạn idempotent; Admin tra cứu / điều chỉnh **chống trùng `Idempotency-Key`** / không âm / audit / lịch sử / báo cáo theo hạng; **RLS**: nhà xe không đọc / ghi sổ điểm; sổ điểm không sửa / xóa được; số dư âm bị CHECK chặn.
- `loyalty.http.spec.ts` (2): chỉ Quản trị viên (Hỗ trợ / chủ nhà xe 403), điều chỉnh cần xác nhận lại danh tính + `Idempotency-Key` hợp lệ, validate truy vấn / body.
- Admin `loyalty-format.test.ts` (3); E2E `admin/e2e/loyalty.e2e.ts` (3, tài khoản E2E riêng `platformLoyalty` + hành khách có sổ điểm 350).
