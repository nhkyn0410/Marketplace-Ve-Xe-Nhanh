# DEMO-DATA — Kế hoạch bổ sung dữ liệu demo để chụp ảnh báo cáo

> Ngày lập: **10/11/2026**. Trạng thái: **kế hoạch, chờ Khanh chốt** các câu hỏi ở §7. Chưa ghi dữ liệu vào DB nào. Mọi truy vấn production trong lần kiểm tra này chạy trong transaction `READ ONLY` và chỉ in số liệu.
> Liên quan: [manual-kit](../../apps/api/prisma/seed-data/manual-kit/README.md) · [mục lục ảnh thành viên](../report/screenshots/authenticated/INDEX.md) · [hướng dẫn mục 4.3](../report/4.3-xay-dung-cac-chuc-nang-chinh.md).

## 1. Hiện trạng dữ liệu (đo 10/11/2026)

### 1.1. Tổng quan

| | Local `vexenhanh_dev` | Production |
| --- | --- | --- |
| Hạ tầng | Docker `ve_xe_nhanh-postgres-1`, `ve_xe_nhanh-mongo-1` | Supabase (ap-southeast-1) + MongoDB Atlas |
| Kích thước / migration | 60 MB · 65/65 | 24 MB · 65/65 (mới nhất `20261102090000_notification_campaign`) |
| Nguồn dữ liệu nền | manual-kit, nạp 30/10: 20 nhà xe, logo, ảnh xe, KYC PDF, tuyến, lịch chạy, bài viết, khuyến mãi, đánh giá | Nhập tay qua giao diện 27–28/10 |
| Ảnh | 20 logo, 400 ảnh xe, 20 ảnh bài viết, 6 banner — đủ file trong `apps/api/.storage` | 8 ảnh xe trên R2 |
| Audit (Mongo) | 5.535 sự kiện | 703 sự kiện |

Các DB local khác (`vexenhanh_flow_20261102`, `vxn_psg_demo`, `vxn_psg_ui_test`, `vexenhanh_p31_test`, `vexenhanh_trn003_test`, `vexenhanh_iam005_test`) là bản sao E2E, tên dữ liệu kiểu `flow-*`, `e2e-*`. Không dùng làm nền chụp ảnh.

### 1.2. Số bản ghi theo nhóm

| Nhóm | Bảng | Local dev | Production |
| --- | --- | ---: | ---: |
| Nhà xe, tài khoản | operator_profiles / operator_accounts / employee_accounts | 20 / 20 / 80 | 7 / 8 / 3 |
| | operator_applications | 0 | 16 |
| | sales_offices / counter_receipts | 0 / 0 | 0 / 0 |
| Đội xe | vehicles / seat_maps / vehicle_images | 100 / 120 / 400 | 14 / 13 / 8 |
| Tuyến, giá, lịch | routes / fares / fare_rules / trip_schedules | 40 / 40 / 160 / 80 | 10 / 10 / 19 / 0 |
| Chuyến | trips (còn tương lai) | 2.660 (1.635) | 55 (31) |
| Bán vé | bookings / tickets / payments | 114 / 2 / 3 | 10 / 7 / 11 |
| Hoàn tiền, đối soát | refunds / payouts / escrow_ledgers | 1 / 0 / 4 | 0 / 3 / 12 |
| Hành khách | users / loyalty_point_transactions / user_vouchers | 21 / 0 / 0 | 4 / 3 / 3 |
| Đánh giá | reviews | 100 | 0 |
| Khuyến mãi | promotions / promotion_redemptions | 20 / 1 | 3 / 2 |
| Nội dung | articles / content_pages (banner · FAQ · trang tĩnh) | 20 / 29 (6 · 18 · 5) | 4 / 18 (0 · 18 · 0) |
| CSKH | support_tickets / dispute_cases | 0 / 0 | 0 / 0 |
| Thông báo | notification_campaigns / notification_inbox_messages | 0 / 0 | 5 / 25 |
| Vận hành | trip_changes / incident_reports / journey_logs / stop_point_proposals | 0 / 0 / 0 / 0 | 0 / 0 / 0 / 0 |

### 1.3. Vấn đề cần xử lý trước khi sinh thêm

Local:

1. 100 booking ngày 17/04 chỉ là "vỏ" để gắn 100 đánh giá: có `user_id`, nhưng không có snapshot, hành khách, vé hay thanh toán. Mở chi tiết đơn/vé hoặc chạy báo cáo trên các đơn này sẽ sai hoặc lỗi.
2. 925 chuyến đã qua giờ chạy (29/10 → 10/11) vẫn ở trạng thái `OPEN_FOR_SALE`, nên danh sách chuyến của Operator OS hiện "đang mở bán" cho chuyến đã qua.
3. Chuyến tương lai chỉ có tới 30/11, trong khi 80 lịch chạy kéo dài tới 31/12.
4. 21 hành khách lấy từ `reviews-pool.json` dùng địa chỉ `@gmail.com` theo tên người, có thể trùng hộp thư thật. Trong khi đó `apps/api/.env` local có `RESEND_API_KEY` thật.
5. Dữ liệu giao dịch gần như trống (thanh toán, vé, hoàn tiền, đối soát, điểm, CSKH, thông báo), nên báo cáo, danh sách và biểu đồ đều rỗng.

Production:

1. Có hai nhà xe Kumho: `kumho` (1 xe, 1 chuyến) và `kumho-samco` (5 xe, 12 chuyến). Slug `futabuslines` cũng khác slug `phuong-trang` của manual-kit.
2. Dữ liệu mỏng: 31 chuyến tương lai của 5 nhà xe, 0 đánh giá, 0 banner, 4 bài viết. Trang chủ, tìm chuyến, trang nhà xe và báo cáo đều gần rỗng.
3. Có một thanh toán VNPAY ở trạng thái `PROCESSING` từ 10/11. Job đối soát ghi 144 bản ghi mỗi ngày: đó là log của từng lượt chạy 10 phút, đúng thiết kế, không phải lỗi dữ liệu.

Máy dev: shell đang đặt `NODE_TLS_REJECT_UNAUTHORIZED=0`, nên mọi tiến trình Node, kể cả script nối production, đều bỏ qua kiểm tra chứng chỉ TLS.

## 2. Mục tiêu dữ liệu demo

- Khung thời gian: lịch sử **60 ngày** (11/09 → 10/11/2026) và tương lai tới **31/12/2026**. Thanh toán rải theo ngày, cao hơn vào cuối tuần và trước ngày lễ; ghế bán dần khi gần ngày chạy.
- Mỗi đơn đi đủ chuỗi như code thật: đơn → thanh toán → vé → soát vé → chuyến hoàn thành → bút toán escrow → đối soát → điểm thưởng → đánh giá. Không còn đơn "vỏ".
- Mỗi màn có đủ biến thể trạng thái: chờ duyệt, đang xử lý, thất bại, đã hủy.
- Chú thích ảnh ghi rõ "dữ liệu mô phỏng trên DB bản sao", theo quy ước của INDEX.md.

### Quy mô đề xuất

| Thực thể | Local (hồ sơ M) | Production (hồ sơ S) | Cách sinh |
| --- | ---: | ---: | --- |
| Nhà xe | 20 (giữ manual-kit) | 7 hiện có (thêm kit nếu Khanh chọn) | Giữ nguyên |
| Chuyến quá khứ | ~4.800 (80/ngày × 60) | ~600 (20/ngày × 30) | Sinh từ lịch chạy, lùi ngày |
| Chuyến tương lai | tới 31/12 (~4.000) | tới 31/12 (~1.000) | Từ lịch chạy, như `seed-november-trips.ts` |
| Hành khách mô phỏng | 500 + tài khoản trưng bày | 150 | Tên tiếng Việt sinh tự động, email miền dự trữ |
| Đơn đặt vé (ONLINE + COUNTER) | ~10.000 (≈18.000 vé) | ~2.500 | Mô phỏng theo ngày |
| Hoàn tiền | ~6% số đơn | ~6% số đơn | Có ca thành công, đang xử lý, thất bại |
| Payout | ~1.100 (mỗi nhà xe mỗi ngày) | ~200 | Gọi `generatePayouts(now)` |
| Đánh giá | ~1.500 | ~300 | 30% đơn đã đi; 40% có phản hồi nhà xe |
| Phiếu hỗ trợ / tranh chấp | 150 / 30 | 40 / 8 | |
| Chiến dịch thông báo | 12 | giữ 5, thêm 3 | |
| Hồ sơ nhà xe chờ duyệt | thêm 12 | giữ 16 | |
| Đề xuất điểm dừng | 15 | 5 | |
| Audit (Mongo) | thêm 3.000 | thêm 500 | |

Dung lượng ước tính: `trip_seats` local hiện chiếm 23 MB cho 67 nghìn dòng (≈ 350 byte/dòng kể cả index). Hồ sơ M thêm khoảng 150–200 MB ở local; hồ sơ S dưới 80 MB, trong giới hạn 500 MB của gói Supabase miễn phí.

## 3. Màn hình và dữ liệu cần

### 3.1. Hành khách (app Flutter và Marketplace web)

| Màn | Cần dữ liệu | Hiện trạng |
| --- | --- | --- |
| Trang chủ: tuyến phổ biến, nhà xe nổi bật, ưu đãi, bài viết, banner | Đơn đã thanh toán theo tuyến, đánh giá theo nhà xe, khuyến mãi ACTIVE, bài PUBLISHED, banner HOME | Local đủ nội dung nhưng thiếu đơn; production thiếu gần hết |
| Tìm chuyến, lọc, sắp xếp | ≥ 5 nhà xe mỗi tuyến mỗi ngày, đủ loại xe, giá, giờ; ghế đã bán một phần | Local có chuyến tới 30/11; production 31 chuyến |
| Sơ đồ ghế | Ghế BOOKED/HOLDING xen kẽ | Gần như toàn ghế trống |
| Trang nhà xe | Điểm trung bình, đánh giá kèm phản hồi | Local 100 (gắn đơn vỏ); production 0 |
| Vé của tôi, chi tiết vé | Vé VALID sắp đi, USED, CANCELLED/REFUNDED, NO_SHOW | Rời rạc |
| Đánh giá của tôi | Đơn đã đi chưa đánh giá và đã đánh giá | Rỗng |
| VXN Plus, lịch sử điểm, ví voucher | EARN/REDEEM/EXPIRE trải nhiều tháng, nhiều hạng; voucher AVAILABLE/USED/EXPIRED | Rỗng |
| Hộp thư, cài đặt thông báo | BOOKING_CONFIRMED, REFUND_SUCCEEDED, TRIP_CHANGED, PROMOTION…, có tin đã đọc và chưa đọc | Rỗng (production 25 tin) |
| Phiên đăng nhập | Nhiều phiên trên nhiều thiết bị | Chỉ cần cho tài khoản trưng bày |

### 3.2. Operator OS

| Màn | Cần dữ liệu |
| --- | --- |
| Tổng quan, Báo cáo (`/reports`) | Chuyến COMPLETED/CANCELLED theo kỳ, vé theo trạng thái, doanh thu, lượt soát vé theo nhân viên (`ticket_status_histories` CHECKED_IN với actor `employee:*`), đánh giá |
| Đơn hàng, danh sách hành khách | Đơn đủ trạng thái, cả ONLINE và COUNTER |
| Chuyến xe, lịch chạy, đổi chuyến | Chuyến hôm nay ở BOARDING/DEPARTED/IN_PROGRESS; `trip_changes` |
| Phân công nhân viên | Tài xế và nhân viên soát vé cho mọi chuyến |
| Bán vé tại quầy (`/counter`), văn phòng | Văn phòng, `SALES_STAFF`, biên nhận tiền mặt/chuyển khoản, khoản hoa hồng phải thu |
| Tài chính, đối soát | Escrow; payout từ PENDING_REVIEW tới PAID kèm mã giao dịch ngân hàng |
| Khuyến mãi | Lượt dùng mã của nhà xe |
| Hỗ trợ | Phiếu nền tảng chuyển cho nhà xe (WAITING_OPERATOR…) |

### 3.3. Admin

| Màn | Cần dữ liệu |
| --- | --- |
| Tổng quan, Báo cáo | GMV theo ngày (biểu đồ tối đa 31 ngày), đơn mất, vé hoàn, đối soát mở, đánh giá theo nhà xe |
| Nhà xe, hồ sơ chờ duyệt | Hồ sơ DRAFT/SUBMITTED/NEEDS_INFO/REJECTED/APPROVED kèm tài liệu |
| Thanh toán, hoàn tiền | Đủ trạng thái; có ca RECONCILING và REFUND_FAILED cho hàng đợi xử lý |
| Đối soát nhà xe | Payout ở nhiều trạng thái |
| Tranh chấp, phiếu hỗ trợ | Đủ trạng thái, mức ưu tiên, sự kiện, tin nhắn |
| Hành khách | Danh sách khoảng 500 người, vài tài khoản bị khóa |
| VXN Plus | Phân bố hạng, giao dịch điểm |
| Kiểm duyệt nội dung, đánh giá | Đánh giá HELD/HIDDEN; nhà xe báo cáo đánh giá |
| Chiến dịch thông báo | COMPLETED/DRAFT/CANCELLED theo từng loại |
| Điểm dừng, đề xuất điểm dừng | Đề xuất PENDING/APPROVED/REJECTED |
| Chính sách | Nhiều phiên bản cho mỗi loại |
| Nhật ký kiểm toán | Sự kiện của nhiều actor và hành động (Mongo) |

### 3.4. App nhân viên (Flutter)

| Màn | Cần dữ liệu |
| --- | --- |
| Chuyến hôm nay và sắp tới của tài xế | Phân công; chuyến hôm nay ở nhiều trạng thái |
| Danh sách khách, soát vé | Vé VALID có QR hợp lệ (ký bằng `TICKET_QR_SECRET` của đúng môi trường); một phần đã CHECKED_IN |
| Nhật ký hành trình, sự cố | `journey_logs`, `incident_reports` |

## 4. Cách sinh dữ liệu

Một script `apps/api/scripts/seed-demo-data.ts` chạy bằng `tsx`. Script mô phỏng từng ngày từ D−60 tới hôm nay, sau đó bán trước cho các chuyến tương lai.

1. **Dùng lại code nghiệp vụ, truyền thời gian vào.** Các hàm sau đã nhận tham số `now`: `applyPaymentCallback(prisma, callback, qr, now)` (xác nhận đơn, phát vé, ghi bút toán), `issueTickets(…, now, …)`, `generatePayouts(prisma, now)`, `runLoyaltyMaintenance(prisma, now)`, `expireBooking(…, now)`. Nhờ vậy dữ liệu sinh ra cùng hình dạng với dữ liệu thật, và job production chạy sau không tạo trùng (payout khóa theo nhà xe + ngày; điểm có `idempotencyKey`).
2. **Tạo đơn qua đúng hàm của `BookingService`.** `create()` lấy giữ chỗ từ Redis, nhưng phần ghi đơn là hàm private `insert(tx, operatorId, user, hold, input, accessToken, now)` nhận `HoldRecord` dựng sẵn (đơn quầy đã có `createAtCounter` công khai). Đề xuất mở hàm này cho script, có test, thay vì tự ghép JSON snapshot. Hàm này lấy chính sách hủy có `effectiveFrom <= now`, nên trước khi sinh phải công bố phiên bản chính sách hiệu lực từ đầu khung 60 ngày.
3. **Không đụng hàng đợi.** Script không enqueue BullMQ, nên không gửi email, push hay SMS. Thông báo và hộp thư được ghi thẳng ở trạng thái cuối (`SENT`/`SKIPPED`), không để `PENDING`.
4. **Tất định và dọn được.** PRNG có seed cố định, ID dạng UUID v5 theo namespace riêng: chạy lại không nhân đôi. Lệnh `--cleanup` xóa đúng phần đã sinh theo thứ tự khóa ngoại.
5. **Danh tính an toàn.** Hành khách mô phỏng dùng email miền dự trữ (`@example.com`) và số điện thoại giả. Không đưa 20 địa chỉ gmail trong `reviews-pool.json` lên production; nếu dùng lại nội dung đánh giá thì đổi tên và email.
6. **Ghi bằng owner kèm `app.scope=system`** như các seed hiện có (bảng có RLS). Script từ chối chạy ở production trừ khi có `--target=production --confirm-host=<host>`.
7. **Trạng thái "hôm nay".** Lệnh `--refresh-today` chạy ngay trước buổi chụp: đặt chuyến hôm nay ở BOARDING/DEPARTED/IN_PROGRESS theo giờ hiện tại và tạo vài đơn `PENDING_PAYMENT` mới. Job hết hạn sẽ chuyển các đơn này sang `EXPIRED` sau khoảng 11 phút.
8. **Ảnh.** Dùng ảnh của manual-kit (local đã có đủ). Production cần tải ảnh lên R2 qua storage adapter.

Kiểm tra bắt buộc (Vitest và truy vấn đối chiếu):

- Không có hai đơn trùng một ghế trên cùng chuyến.
- Với mỗi nhà xe: tổng escrow = thanh toán − hoàn tiền − hoa hồng.
- Số vé bằng số hành khách của đơn.
- Không còn bản gửi thông báo `PENDING`.
- Payout khớp tổng `payout_items`.

## 5. Các pha

| Pha | Việc | Kiểm tra |
| --- | --- | --- |
| 0 | Khanh chốt các câu hỏi ở §7 | — |
| 1 | Tạo `vxn_report_demo` từ `vexenhanh_dev` bằng TEMPLATE (giữ nguyên dev); xóa 100 đơn vỏ và đánh giá gắn kèm; đóng các chuyến đã qua; sinh chuyến tới 31/12; công bố phiên bản chính sách hiệu lực từ đầu khung 60 ngày | Đếm bảng; không còn chuyến quá khứ `OPEN_FOR_SALE` |
| 2 | Lõi giao dịch: hành khách, đơn ONLINE/COUNTER, thanh toán, vé, soát vé, hoàn tiền, chuyến hoàn thành/hủy | Bộ kiểm tra ở §4 pass |
| 3 | Phần phụ: payout, điểm và voucher, khuyến mãi, đánh giá (phản hồi, kiểm duyệt), phiếu hỗ trợ và tranh chấp, thông báo và chiến dịch, hồ sơ nhà xe, đề xuất điểm dừng, đổi chuyến, sự cố, nhật ký hành trình, audit Mongo | Mỗi màn ở §3 có dữ liệu |
| 4 | Chạy API và worker trên cổng riêng (3100) với DB bản sao, `RESEND_API_KEY=''`; đi qua từng màn ở §3 và lập danh sách ảnh | Danh sách màn đã kiểm |
| 5 (tùy chọn) | Production, hồ sơ S: sao lưu bằng `pg_dump` → chạy thử chỉ in số đếm → chạy thật → tải ảnh lên R2 → kiểm tra | Chỉ làm khi Khanh đồng ý từng bước |

## 6. Rủi ro khi ghi production và cách chặn

| Rủi ro | Biện pháp |
| --- | --- |
| Email hoặc push tới người thật | Không enqueue; email miền dự trữ; không dùng gmail của kit |
| Job nền phản ứng với dữ liệu mới | Các job: hết hạn đơn (1 phút), đối soát thanh toán (10 phút), điểm (10 phút), tranh chấp quá hạn (15 phút), quét thông báo (5 phút), chiến dịch (1 phút), payout (00:00). Chỉ ghi trạng thái cuối; không tạo chiến dịch `SCHEDULED`; payout sinh bằng chính `generatePayouts` |
| Gọi cổng thanh toán thật | Production chỉ dùng provider `DEMO`: hoàn tiền hoặc đối soát trên mã giao dịch giả của VNPAY/MoMo/payOS sẽ gọi tới cổng. Chỉ đa dạng cổng ở local |
| Lẫn với dữ liệu thật, khó gỡ | UUID v5 + `--cleanup`; `pg_dump` trước khi chạy |
| Giới hạn gói miễn phí | Hồ sơ S dưới 80 MB (Supabase 500 MB); Mongo thêm khoảng 500 sự kiện; không ghi Redis |

## 7. Cần Khanh chốt

1. Chụp ở đâu: local DB bản sao (khuyến nghị), production, hay cả hai?
2. Cần ảnh cho ứng dụng nào: chụp lại app hành khách, hay Operator OS, Admin, Marketplace web, app nhân viên?
3. Quy mô M/S, khung 60 ngày và tương lai tới 31/12 có phù hợp không?
4. Dùng tài khoản nào làm tài khoản trưng bày để gắn lịch sử dài (hạng GOLD/PLATINUM, nhiều vé)?
5. Production: xử lý hai nhà xe Kumho và slug `futabuslines` thế nào? Có nhập 20 nhà xe của kit lên production không?
