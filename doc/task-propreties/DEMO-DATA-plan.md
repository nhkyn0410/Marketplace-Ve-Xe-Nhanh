# DEMO-DATA — Kế hoạch bộ dữ liệu toàn nền tảng để chụp ảnh báo cáo

> Bản 2, lập **17/11/2026**, thay bản 10/11/2026 (bản cũ xem lịch sử git). Trạng thái: **kế hoạch, chờ Khanh chốt** §10. Chưa ghi dữ liệu vào DB nào; kiểm kê 17/11 chỉ đọc (`BEGIN READ ONLY`) trên DB local, không chạm production.
> **Cập nhật 17/11/2026 (đêm):** Khanh yêu cầu dữ liệu demo dùng được cả trên production và luồng đặt vé chạy được khi demo trực tiếp **9:00 ngày 19/11/2026**. Đã viết script `apps/api/scripts/seed-demo.ts`, chạy thử trên bản sao local và bản diễn tập chép từ production — xem **§11**. Production chưa bị ghi gì; chờ Khanh chốt §11.6.
> Liên quan: [manual-kit](../../apps/api/prisma/seed-data/manual-kit/README.md) · [hướng dẫn ảnh mục 4.3](../report/4.3-xay-dung-cac-chuc-nang-chinh.md) · [so sánh web–app](../report/so-sanh-web-va-app-hanh-khach.md) · [PASSENGER-PARITY](PASSENGER-PARITY-plan.md).

## 0. Tóm tắt

Một bản sao DB local (`vxn_report_demo`) chứa dữ liệu mô phỏng **liền mạch cho cả 6 phân hệ**: app hành khách, Marketplace web, Operator OS (kể cả bán vé tại quầy), Admin, app nhân viên, và các kênh ngoài app (email, thông báo đẩy, cổng thanh toán thử). Cùng một đơn vé xuất hiện nhất quán ở mọi nơi: hành khách đặt → nhà xe thấy đơn → nhân viên soát vé → Admin thấy doanh thu, đối soát.

- Dữ liệu sinh bằng **code nghiệp vụ thật** (đơn, thanh toán, vé, payout, điểm thưởng…), có tham số "hôm nay", tất định, chạy lại không nhân đôi, xóa được.
- Khung thời gian tính theo **ngày chụp (D0)**: 60 ngày lịch sử, 45 ngày tương lai.
- Có **bộ nhân vật trưng bày** cố định (§3) để mỗi ảnh kể đúng một câu chuyện.
- Không gửi email / push / gọi cổng thanh toán thật khi sinh dữ liệu; production không đụng tới trừ khi Khanh yêu cầu riêng.

Ước lượng: 5–7 ngày làm (sinh dữ liệu 4–5 ngày, chạy thử và kiểm 1 ngày) + 1–2 buổi chụp.

## 1. Hiện trạng dữ liệu local (đo 17/11/2026)

| Nhóm | `vexenhanh_dev` | `vxn_web_shots` (bản sao chụp 12–14/11) |
| --- | ---: | ---: |
| Nhà xe / tài khoản nhà xe / nhân viên | 20 / 20 / 80 | như dev |
| Văn phòng bán vé / biên nhận quầy | 0 / 0 | 0 / 0 |
| Hồ sơ đăng ký nhà xe | 0 | 0 |
| Xe / tuyến / lịch chạy | 100 / 40 / 80 | như dev |
| Chuyến (còn tương lai, chuyến xa nhất) | 2.660 (1.120, tới 30/11) | như dev |
| Đơn / vé / thanh toán | 114 / 2 / 3 | 120 / 7 / 9 |
| Hoàn tiền / payout / bút toán escrow | 1 / 0 / 4 | 2 / 1 / 14 |
| Hành khách / giao dịch điểm / voucher của khách | 21 / 0 / 0 | 23 / 0 / 1 |
| Đánh giá / khuyến mãi | 100 / 20 | 101 / 20 |
| Bài viết / trang nội dung | 20 / 29 | như dev |
| Khiếu nại / tranh chấp | 0 / 0 | 1 / 0 |
| Chiến dịch / hộp thư thông báo | 0 / 0 | 0 / 7 |
| Đổi chuyến / sự cố / nhật ký hành trình / đề xuất điểm dừng | 0 / 0 / 0 / 0 | 0 / 0 / 0 / 0 |
| Phiên bản chính sách | 1 | 1 |

Vấn đề phải xử lý trước (phần lớn đã thấy từ 10/11, nay nặng hơn):

1. **Chuyến tương lai chỉ tới 30/11**; **1.440 chuyến đã qua vẫn `OPEN_FOR_SALE`** — Operator OS hiện "đang mở bán" cho chuyến đã chạy.
2. **100 đơn "vỏ" ngày 17/04** (CONFIRMED nhưng không snapshot / hành khách / vé / thanh toán) chỉ để gắn 100 đánh giá. Mở chi tiết hoặc chạy báo cáo trên các đơn này sẽ sai.
3. Giao dịch gần như trống, nên mọi danh sách, báo cáo, biểu đồ đều rỗng.
4. **Các tính năng mới sau 10/11 chưa có dòng dữ liệu nào**: văn phòng + nhân viên bán vé + hoa hồng quầy, khiếu nại có đính kèm, ví voucher theo trạng thái, lịch sử điểm, chiến dịch thông báo, hộp thư, tài khoản quản lý nhà xe, lọc theo điểm đón / trả và đánh giá, gửi lại email vé. Kit có 60 văn phòng (`06-operator-offices-datasheet.csv`) nhưng chưa nạp.
5. 21 hành khách lấy tên từ `reviews-pool.json` dùng địa chỉ `@gmail.com` theo tên người thật — không đưa lên ảnh.
6. Production (đo 10/11): 7 nhà xe (có hai Kumho), 55 chuyến, 0 đánh giá. Không phải nơi chụp phù hợp.

## 2. Nguyên tắc

1. **Đi qua code nghiệp vụ, không ghép JSON tay.** Các hàm đã nhận `now`: `applyPaymentCallback` (xác nhận đơn, phát vé, bút toán), `issueTickets`, `generatePayouts`, `runLoyaltyMaintenance`, `expireBooking`; đơn quầy dùng `BookingService.createAtCounter`; đơn online cần mở `BookingService.insert` (đang `private`) cho script, kèm test. Dữ liệu sinh ra cùng hình dạng dữ liệu thật, job chạy sau không tạo trùng.
2. **Nhất quán chéo phân hệ.** Mỗi đơn có đủ chuỗi: đơn → thanh toán → vé (QR ký bằng `TICKET_QR_SECRET` của chính môi trường chụp) → soát vé → chuyến hoàn thành → escrow → payout → điểm thưởng → đánh giá. Không còn đơn "vỏ".
3. **Đủ biến thể trạng thái** cho mỗi màn: rỗng, đang xử lý, thành công, thất bại, đã hủy, chờ duyệt.
4. **Tất định, xóa được.** PRNG có seed cố định, ID dạng UUID v5 theo namespace riêng; `--cleanup` xóa đúng phần đã sinh theo thứ tự khóa ngoại.
5. **Không có tác dụng ra ngoài.** Không enqueue BullMQ khi sinh; thông báo ghi thẳng trạng thái cuối (`SENT` / `SKIPPED` / `FAILED`), không để `PENDING`. Email hành khách mô phỏng dùng `@example.com`, số điện thoại giả. Thanh toán VNPay / MoMo / payOS chỉ là bản ghi, không gọi cổng.
6. **Ghi bằng owner kèm `app.scope=system`** như các seed hiện có (bảng có RLS). Script từ chối chạy nếu tên DB không phải bản sao demo.
7. **Chú thích ảnh** ghi "dữ liệu mô phỏng trên bản sao", theo quy ước INDEX hiện có.

## 3. Kịch bản và nhân vật trưng bày

Mỗi nhân vật có lịch sử dựng sẵn để chụp đúng câu chuyện; mật khẩu / mã TOTP ghi vào tệp local không commit (`apps/api/tmp/report-demo/accounts.local.md`).

| Nhân vật | Tài khoản | Dùng để chụp |
| --- | --- | --- |
| Hành khách thân thiết | `minhanh@example.com`, hạng cao nhất, ~25 chuyến trong 60 ngày, 5 hành khách đã lưu, 3 thiết bị đăng nhập | Trang chủ thành viên, Vé của tôi (đủ tab), đánh giá, VXN Plus, lịch sử điểm, ví voucher (đủ 4 tab), hộp thư (đã đọc / chưa đọc), khiếu nại có trao đổi + đính kèm, phiên đăng nhập |
| Hành khách mới | `khachmoi@example.com`, hạng thấp nhất, 1 đơn chờ thanh toán | Trạng thái rỗng, đăng ký → hoàn thiện hồ sơ, luồng đặt vé từ đầu |
| Khách vãng lai | đơn đặt bằng email `vanglai@example.com`, không tài khoản | Tra cứu vé bằng email + OTP, hủy vé, khiếu nại khách vãng lai |
| Nhà xe trưng bày | một nhà xe của kit (§10.4): Owner, 1 quản lý, 2 nhân viên bán vé, 3 tài xế, 2 nhân viên soát vé | Operator OS đủ màn, bán vé tại quầy, báo cáo, đối soát |
| Nhân viên app | tài xế + nhân viên soát vé của nhà xe trưng bày, có chuyến hôm nay | Chuyến hôm nay, danh sách khách, quét QR, nhật ký hành trình, sự cố |
| Nền tảng | `platform/admin` (Admin), `platform/cskh01` (CSKH) | Admin đủ màn, kiểm duyệt, xử lý khiếu nại / tranh chấp |
| Nhà xe chờ duyệt | 12 hồ sơ đăng ký ở đủ trạng thái, kèm tài liệu KYC giả của kit | Đăng ký nhà xe (Operator OS) và duyệt hồ sơ (Admin) |

## 4. Màn hình và dữ liệu cần theo phân hệ

### 4.1. App hành khách (Flutter) và Marketplace web (32 trang)

Bám theo khung mục 4.3 của báo cáo (4.3.1–4.3.16) và danh mục SCR-PSG.

| Nhóm màn | Dữ liệu cần |
| --- | --- |
| Trang chủ (khách / thành viên): tuyến phổ biến, nhà xe nổi bật, ưu đãi, bài viết, banner | Đơn đã thanh toán theo tuyến; điểm đánh giá theo nhà xe; khuyến mãi đang chạy; bài đã đăng; banner trang chủ |
| Tìm chuyến, lọc (giờ, giá, loại xe, tiện ích, nhà xe, **điểm đón / trả, đánh giá**), sắp xếp, đổi ngày | ≥ 5 nhà xe mỗi tuyến chính mỗi ngày, nhiều điểm đón / trả, giá và giờ khác nhau; đánh giá trải từ 3,5 tới 5 sao |
| Chi tiết chuyến: lịch trình, **bản đồ điểm dừng**, **đánh giá nhà xe**, chính sách | Điểm dừng có tọa độ; ≥ 3 đánh giá hiển thị, có phản hồi nhà xe; khóa Goong để hiện bản đồ |
| Sơ đồ ghế, chọn điểm đón / trả | Chuyến bán dở: ghế đã bán, đang giữ, còn trống xen kẽ |
| Thông tin hành khách, hành khách đã lưu | 5 người đã lưu của hành khách thân thiết |
| Xác nhận, chọn cổng, cổng DEMO, kết quả, **gửi lại email vé** | Cổng DEMO bật ở môi trường chụp; danh sách cổng có cả cổng chưa cấu hình ("Sắp hỗ trợ") |
| Vé QR, Vé của tôi (Sắp tới / Đã đi / Đã hủy), chi tiết vé, chia sẻ, chỉ đường | Vé VALID sắp đi, USED, CANCELLED, REFUNDED, NO_SHOW |
| Tra cứu vé khách vãng lai | Đơn của khách vãng lai, gồm một đơn hai vé |
| Hủy vé, hoàn tiền | Hoàn tiền thành công / đang xử lý / thất bại; mốc chính sách hủy khác nhau |
| Đánh giá của tôi | Đơn đã đi chưa đánh giá và đã đánh giá (hiển thị / đang kiểm duyệt / ẩn) |
| Khám phá, bài viết liên quan | ≥ 4 chuyên mục, mỗi chuyên mục ≥ 3 bài |
| Ưu đãi, ví voucher (Khả dụng / Đang giữ / Đã dùng / Hết hạn) | Voucher đổi điểm và voucher khuyến mãi ở đủ 4 trạng thái |
| VXN Plus, đổi điểm, lịch sử điểm | Giao dịch tích / đổi / hết hạn / điều chỉnh trải 60 ngày |
| Hộp thư, thông báo đẩy, cài đặt thông báo | ~30 tin của nhiều loại, có tin chưa đọc |
| FAQ, khiếu nại và hỗ trợ (danh sách, gửi, chi tiết, đính kèm) | Khiếu nại ở đủ trạng thái, có trao đổi CSKH / nhà xe, có tệp |
| Đăng nhập email OTP / Google, đăng ký, hồ sơ, phiên đăng nhập | Tài khoản trưng bày + 3 phiên trên thiết bị khác; Google client ID để nút Google hiện |

### 4.2. Operator OS (44 trang, gồm bán vé tại quầy)

| Nhóm màn | Dữ liệu cần |
| --- | --- |
| Tổng quan, Báo cáo | Chuyến hoàn thành / hủy theo kỳ, doanh thu, vé theo trạng thái, lượt soát vé theo nhân viên, đánh giá |
| Đơn hàng, chi tiết đơn, danh sách hành khách | Đơn ONLINE + COUNTER ở đủ trạng thái |
| Chuyến, lịch chạy, đổi chuyến, sửa chuyến | Chuyến hôm nay ở nhiều trạng thái; vài `trip_changes` (đổi giờ, đổi xe) |
| Tuyến, giá, sơ đồ ghế, xe, điểm dừng | Đã có từ kit; thêm ảnh xe có chú thích |
| Nhân viên, phân công, quản lý (quyền riêng) | Tài xế / soát vé được phân công cho mọi chuyến; 1 tài khoản quản lý có danh sách quyền |
| Văn phòng, bán vé tại quầy (`/counter`) | Văn phòng của kit, nhân viên bán vé, biên nhận tiền mặt / chuyển khoản, hoa hồng phải nộp và đã nộp |
| Tài chính, payout | Escrow; payout từ chờ duyệt tới đã chuyển kèm mã giao dịch ngân hàng |
| Khuyến mãi | Mã của nhà xe có lượt dùng |
| Hỗ trợ | Khiếu nại được chuyển cho nhà xe (chờ nhà xe phản hồi…) |
| Đăng ký nhà xe | Hồ sơ đang soạn / đã gửi / cần bổ sung |

### 4.3. Admin (39 trang)

| Nhóm màn | Dữ liệu cần |
| --- | --- |
| Tổng quan, Báo cáo | GMV theo ngày (biểu đồ tối đa 31 ngày), đơn hết hạn, vé hoàn, đối soát mở, đánh giá theo nhà xe |
| Nhà xe, hồ sơ đăng ký | Hồ sơ ở 5 trạng thái, kèm tài liệu |
| Thanh toán, hoàn tiền | Đủ trạng thái; có ca đang đối soát và hoàn tiền thất bại cho hàng đợi xử lý |
| Payout | Nhiều trạng thái, kèm dòng chi tiết |
| Khiếu nại, tranh chấp | Đủ trạng thái, mức ưu tiên, sự kiện, tin nhắn, quá hạn |
| Hành khách, chi tiết hành khách | ~500 người, vài tài khoản bị khóa |
| VXN Plus | Phân bố hạng, giao dịch điểm |
| Kiểm duyệt nội dung, bài viết, đánh giá | Bài nháp / đã đăng; đánh giá đang giữ / ẩn; nhà xe báo cáo đánh giá |
| Chiến dịch thông báo | Đã gửi / nháp / đã hủy theo từng loại, có số người nhận |
| Tuyến, chuyến, điểm dừng, đề xuất điểm dừng | Đề xuất chờ duyệt / đã duyệt / từ chối |
| Chính sách | Nhiều phiên bản cho mỗi loại |
| Nhật ký kiểm toán, hệ thống | Sự kiện của nhiều actor và hành động (Mongo) |

### 4.4. App nhân viên (Flutter)

| Màn | Dữ liệu cần |
| --- | --- |
| Đăng nhập, hồ sơ | Tài khoản tài xế / soát vé của nhà xe trưng bày |
| Chuyến hôm nay, sắp tới | Phân công; chuyến hôm nay ở chờ khởi hành / đang chạy / đã xong |
| Danh sách khách, quét QR | Vé VALID có QR hợp lệ; một phần đã soát |
| Nhật ký hành trình, sự cố | `journey_logs`, `incident_reports` cho chuyến hôm nay và hôm qua |

### 4.5. Ngoài app

| Kênh | Cách có ảnh |
| --- | --- |
| Email vé, OTP | Chặn gửi thật, ghi email ra tệp (cách đã dùng 12–14/11) rồi mở trong trình duyệt để chụp |
| Thông báo đẩy trên khay | FCM thật tới máy ảo của buổi chụp (cần cấu hình Firebase local), gửi từ "Gửi thử" của chiến dịch |
| Cổng thanh toán | Cổng DEMO (local); VNPay sandbox nếu cần ảnh cổng thật |
| App Link quay về app | Tên miền thật + `assetlinks.json` (nếu không có thì bỏ ảnh này) |

## 5. Quy mô

| Thực thể | Số lượng (hồ sơ M) | Ghi chú |
| --- | ---: | --- |
| Nhà xe | 20 (kit) + 12 hồ sơ chờ duyệt | |
| Văn phòng / nhân viên bán vé | 60 / ~40 | Nạp từ kit |
| Chuyến | D−60 → D+45 (~8.500) | Sinh từ lịch chạy; chuyến quá khứ đóng đúng trạng thái |
| Hành khách mô phỏng | 500 + 3 nhân vật | Tên tiếng Việt sinh tự động, `@example.com` |
| Đơn (ONLINE ~85%, COUNTER ~15%) | ~10.000 (≈ 18.000 vé) | Rải theo ngày, cao hơn cuối tuần; bán dần khi gần ngày chạy |
| Thanh toán | theo đơn, cổng VNPay / MoMo / payOS / DEMO | ~2% đối soát, ~3% thất bại |
| Hoàn tiền | ~6% số đơn | Thành công / đang xử lý / thất bại |
| Payout | ~1.100 (mỗi nhà xe mỗi ngày) | `generatePayouts(now)` |
| Đánh giá | ~1.500 (30% đơn đã đi) | 40% có phản hồi nhà xe; vài đánh giá đang giữ / ẩn |
| Giao dịch điểm / voucher của khách | ~12.000 / ~600 | `runLoyaltyMaintenance(now)` cho hết hạn |
| Khiếu nại / tranh chấp | 150 / 30 | 2–6 tin mỗi khiếu nại, 20% có tệp |
| Chiến dịch / tin hộp thư | 12 / ~8.000 | |
| Đổi chuyến / sự cố / nhật ký hành trình | 20 / 15 / theo chuyến 2 ngày gần nhất | |
| Đề xuất điểm dừng | 15 | |
| Audit (Mongo) | +3.000 sự kiện | |

Dung lượng ước tính thêm 150–200 MB ở local (`trip_seats` ≈ 350 byte/dòng kể cả index).

## 6. Cách sinh dữ liệu

Một script `apps/api/scripts/seed-report-demo.ts` (tham số `--today=YYYY-MM-DD`, `--cleanup`, `--refresh-today`, `--dry-run` chỉ in số đếm), chia bước:

1. **Nền:** xóa 100 đơn "vỏ" + đánh giá gắn kèm; nạp văn phòng của kit; tạo nhân viên bán vé, tài khoản quản lý; tạo nhân vật §3; đổi email gmail của 21 hành khách kit sang `@example.com`; công bố phiên bản chính sách hiệu lực từ D−60.
2. **Chuyến:** sinh chuyến D−60 → D+45 từ lịch chạy (tái dùng logic `seed-november-trips.ts`), phân công tài xế / soát vé.
3. **Mô phỏng từng ngày** D−60 → D−1: tạo đơn (online qua `insert`, quầy qua `createAtCounter`) → `applyPaymentCallback(now)` → soát vé (lịch sử CHECKED_IN với actor nhân viên) → chuyển chuyến sang hoàn thành → hủy / hoàn tiền một phần → `generatePayouts(now)` cuối ngày → `runLoyaltyMaintenance(now)`.
4. **Bán trước** cho D → D+45 (tỷ lệ lấp ghế giảm dần theo khoảng cách tới ngày chạy); vài đơn chờ thanh toán.
5. **Phụ trợ:** đánh giá + phản hồi + kiểm duyệt; voucher và đổi điểm; khiếu nại + tin nhắn + tệp (tệp mẫu PDF / JPG đặt trong kho riêng của bản sao); tranh chấp; chiến dịch ở trạng thái cuối + tin hộp thư; đổi chuyến; sự cố; nhật ký hành trình; hồ sơ nhà xe + tài liệu kit; đề xuất điểm dừng; audit Mongo.
6. **Hôm nay (`--refresh-today`)**, chạy ngay trước buổi chụp: đặt chuyến hôm nay về đúng trạng thái theo giờ hiện tại, đảm bảo nhân vật có vé VALID chuyến hôm nay / ngày mai, tạo vài đơn chờ thanh toán mới (job hết hạn đổi sang `EXPIRED` sau ~11 phút).
7. **Ảnh và tệp:** dùng ảnh kit; sao chép `apps/api/.storage` sang `apps/api/tmp/report-demo/storage` cho bản sao, để tệp sinh mới không lẫn vào dev.

Kiểm tra bắt buộc (Vitest + truy vấn đối chiếu, chạy sau mỗi lần sinh):

- Không có hai đơn còn hiệu lực trùng một ghế trên cùng chuyến (theo chặng).
- Mỗi nhà xe: escrow = thanh toán − hoàn tiền − hoa hồng; payout khớp tổng dòng chi tiết.
- Số vé = số hành khách của đơn; không đơn đã thanh toán nào thiếu vé.
- Không còn chuyến quá khứ `OPEN_FOR_SALE`; không còn thông báo `PENDING`.
- QR của vé quét được bằng app nhân viên trên đúng môi trường.

## 7. Môi trường chụp

| Thành phần | Cấu hình |
| --- | --- |
| DB | `vxn_report_demo` = `CREATE DATABASE … TEMPLATE vexenhanh_dev` (giữ nguyên dev), rồi chạy script |
| API | Bản build riêng (`apps/api/tmp/report-demo/dist`), cổng 3100, Redis DB riêng, `BULLMQ_PREFIX` riêng, chặn email (ghi ra tệp), `PAYMENT_DEMO_ENABLED=true`, `STORAGE_LOCAL_DIR` của bản sao |
| Worker | Chỉ bật khi chụp màn cần job chạy (hết hạn đơn, gửi thông báo) |
| Web | Marketplace, Operator OS, Admin chạy dev, trỏ API 3100 bằng `.env.development.local` tạm (xóa sau); khóa Goong + Google client ID để bản đồ và nút Google hiện |
| App hành khách / nhân viên | APK debug `API_BASE_URL=http://10.0.2.2:3100`, khóa Goong; máy ảo Pixel_6 (`wm density 450` giống máy ~384dp) |
| Khung chụp | Web 1440×900 (thêm 390×844 cho Marketplace di động nếu cần); app 1080×2400 |

Quy ước ảnh: thư mục theo phân hệ `doc/report/screenshots/<phan-he>/`, tên `<Mã>-<mo-ta>.png`, mỗi thư mục có `INDEX.md` (mã ảnh, màn, nhân vật, ngày chụp, mục báo cáo dùng). **Nén ảnh trước khi commit** (bộ 12–14/11 đã chiếm ~176 MB).

## 8. Các pha

| Pha | Việc | Xong khi | Ước lượng |
| --- | --- | --- | --- |
| 0 | Khanh chốt §10 | Có câu trả lời | — |
| 1 | Bản sao + bước nền (§6.1–6.2) | Không còn đơn "vỏ", chuyến quá khứ đóng đúng, có chuyến tới D+45, có văn phòng và nhân vật | 0,5–1 ngày |
| 2 | Lõi giao dịch (§6.3–6.4) | Bộ kiểm tra §6 qua | 1,5–2 ngày |
| 3 | Phụ trợ (§6.5) | Mỗi màn ở §4 có dữ liệu | 1,5–2 ngày |
| 4 | Chạy thử: dựng môi trường §7, đi qua từng màn ở §4, ghi màn còn rỗng / lỗi | Danh sách màn đã kiểm, sửa xong lỗi dữ liệu | 1 ngày |
| 5 | Buổi chụp: `--refresh-today`, chụp theo danh sách, viết INDEX | Ảnh + INDEX cho mọi mục báo cáo | 1–2 buổi |
| 6 (tùy chọn) | Production, hồ sơ nhỏ: `pg_dump` → `--dry-run` → chạy thật → tải ảnh lên R2 | Chỉ khi Khanh đồng ý từng bước | — |

## 9. Rủi ro và cách chặn

| Rủi ro | Biện pháp |
| --- | --- |
| Email / push tới người thật | Không enqueue khi sinh; email `@example.com`; chặn gửi trên API chụp; FCM chỉ tới máy ảo |
| Job nền thay đổi dữ liệu giữa buổi chụp | Worker tắt mặc định; chỉ ghi trạng thái cuối; không tạo chiến dịch hẹn giờ; chạy `--refresh-today` ngay trước khi chụp |
| Gọi cổng thanh toán thật | Bản ghi VNPay / MoMo / payOS không gọi cổng; chỉ thao tác trực tiếp trên cổng DEMO |
| Số liệu mô phỏng gắn với thương hiệu thật | Xem §10.5 |
| Lẫn với dữ liệu dev, khó gỡ | Bản sao riêng; UUID v5 + `--cleanup` |
| Ảnh quá nặng cho repo | Nén, chỉ commit ảnh dùng trong báo cáo |
| Lộ bí mật khi chụp (khóa API, URL DB) | Không chụp màn có biến môi trường; tài khoản và mật khẩu chỉ nằm ở tệp local không commit |

## 10. Cần Khanh chốt (kèm đề xuất mặc định)

Nếu Khanh đồng ý với đề xuất, chỉ cần trả lời "theo đề xuất".

| # | Câu hỏi | Đề xuất |
| --- | --- | --- |
| 1 | Chụp ở đâu? | **Bản sao local** `vxn_report_demo`. Production chỉ khi cần ảnh có địa chỉ web thật |
| 2 | Chụp những phân hệ nào, thứ tự nào? | **Cả 6**, theo thứ tự: app hành khách (mục 4.3 đã có khung) → Operator OS + quầy → Admin → Marketplace web → app nhân viên → ngoài app |
| 3 | Khung thời gian, quy mô | D0 = ngày chụp, **60 ngày lịch sử, 45 ngày tương lai**, hồ sơ M (§5) |
| 4 | Nhà xe trưng bày | Nhà xe của kit có nhiều tuyến và chuyến nhất (chọn khi chạy pha 1); Khanh có thể chỉ định |
| 5 | Kit dùng tên và logo nhà xe thật; ảnh báo cáo sẽ có số liệu, đánh giá mô phỏng gắn với các thương hiệu này | **Đổi tên + logo giả cho bản sao chụp** (giữ nguyên dev), để không bị hiểu là số liệu thật của doanh nghiệp. Nếu giữ tên thật thì mọi chú thích ghi "dữ liệu mô phỏng" |
| 6 | Ảnh thông báo đẩy trên khay | FCM thật tới máy ảo (cần cấu hình Firebase local); không có thì dùng lại ảnh FCM ngày 02/11 |
| 7 | Ảnh App Link (quay về app sau thanh toán) | Bỏ, trừ khi có tên miền web thật để xác minh |

## 11. Production và demo trực tiếp 9:00 ngày 19/11/2026

### 11.1. Đã làm (17/11)

Script `apps/api/scripts/seed-demo.ts` — một lệnh cho cả local và production; chạy lại chính là bước làm mới:

1. **Lịch mẫu** cho tuyến chưa có lịch (production đang 0 lịch): mỗi xe hợp bảng giá chạy một chuỗi chuyến trong ngày từ 06:30, ghi chú "Lịch mẫu (dữ liệu demo)". Tuyến chỉ còn giá đã hết hạn thì bỏ qua (vd `kumho` "TPHCM-Da lat", giá hết hạn 07/11).
2. **Chuyến** từ D−lịch-sử tới D+21 qua `insertDraftTrip`, mở bán; trùng giờ xe với chuyến tạo tay thì bỏ qua.
3. **Nhà xe trưng bày:** tạo `nv.taixe01`, `nv.taixe02`, `nv.soatve01`, `nv.banve01` khi nhà xe chưa đủ người cho vai trò đó (mật khẩu lấy từ biến `DEMO_STAFF_PASSWORD`, không in ra, không lưu ở production); văn phòng `VP01` cho bán vé tại quầy; phân công tài xế + soát vé cho chuyến từ D−lịch-sử tới D+3.
4. **Hành khách mô phỏng** `khachNNN.demo@example.com`; hành khách trưng bày theo `--passenger-email`.
5. **Chuyến đã qua:** đơn (65% khách có tài khoản, còn lại khách vãng lai `vanglai.*@example.com`) đặt trước giờ chạy 0–7 ngày → thanh toán cổng DEMO → vé → soát vé ~90% → đóng chuyến như tài xế bấm (vé `USED` / `NO_SHOW`, mốc chi trả) → cộng điểm VXN Plus → đánh giá (tùy chọn).
6. **Chuyến sắp chạy** trong `--presale-days`: bán trước, giảm dần theo khoảng cách tới ngày chạy; chuyến của nhà xe trưng bày trong 2 ngày tới chỉ bán tối đa 30% ghế để còn chỗ đặt trực tiếp.
7. `generatePayouts(now)` cho từng ngày trong khung lịch sử.

An toàn:

- Đơn demo nhận ra bằng `hold_id` bắt đầu `de30de30-`. Chuyến có đơn KHÔNG phải demo không bị đụng.
- Email vé và thông báo điểm thưởng phát sinh được đánh dấu `SKIPPED` ngay trong transaction ghi đơn, nên worker production không kịp gửi. Thanh toán chỉ là bản ghi cổng DEMO, không gọi cổng thật.
- `--dry-run` chạy mọi transaction ở chế độ `READ ONLY`. Ghi vào DB không phải local bắt buộc `--yes-production`; ghi thẳng `vexenhanh_dev` bị chặn.
- **Không gỡ được bằng script:** bút toán escrow và giao dịch điểm là append-only (trigger). Gỡ dữ liệu demo trên production = khôi phục bản sao lưu chụp ngay trước khi chạy.

### 11.2. Kết quả chạy thử (17/11)

| Lần chạy | Kết quả |
| --- | --- |
| Bản sao dev `vxn_demo_check`, 3 nhà xe, 7 ngày lịch sử | 990 đơn / 1.479 ghế, 78 chuyến hoàn thành, 110 đánh giá, 13 payout, 0 lỗi, ~1,6 phút |
| Bản diễn tập `vxn_prod_rehearsal` (chép chỉ-đọc 92 bảng / 8.603 dòng của production), tham số production | 23 lịch mẫu, 805 chuyến, 1.490 đơn / 2.100 ghế, 319 chuyến hoàn thành, 708 lần cộng điểm, 61 payout; 6 chuyến có đơn thật giữ nguyên; 0 lỗi, ~1,6 phút |
| Chạy lại lần 2 trên bản diễn tập | 0 lịch, 0 chuyến, 0 đơn mới — không nhân đôi |
| `--dry-run` trên **production** (chỉ đọc) | Kết nối `verify-full` được, hình dạng khớp bản diễn tập; độ trễ ~29 ms/truy vấn → ước tính chạy thật **15–20 phút** |

Truy vấn đối chiếu trên cả hai bản: không ghế bán trùng, mọi đơn đã thanh toán đủ vé, trạng thái ghế khớp vé, escrow bằng tiền thanh toán, payout bằng tổng dòng chi tiết, 0 thông báo `PENDING`, không đơn / đánh giá nào có giờ ở tương lai.

Luồng demo đầu-cuối qua API thật (build nhánh hiện tại, cổng 3100 + worker, cổng DEMO), đạt trên cả hai bản: tìm chuyến → chi tiết → giữ ghế → đặt vé khách vãng lai → thanh toán DEMO → worker xác nhận, phát vé QR → `kumho-samco/nv.soatve01` đăng nhập, thấy chuyến được phân công, quét QR, check-in, quét lại bị chặn → `nv.taixe01` khởi hành rồi hoàn thành → vé `USED`, có bút toán escrow.

Chưa thử: giao diện web / app trên dữ liệu này; đăng nhập hành khách bằng OTP qua email thật; chạy thật trên production.

### 11.3. Hiện trạng production liên quan (đo 17/11, chỉ đọc)

- DB đã có đủ 65 migration của nhánh này, nhưng **API đang chạy bản build cũ** (404 ở `/v1/payment-providers`, `/v1/me/reviews`, `/v1/guest/ticket-lookup/otp`): app / web bản mới sẽ lỗi ở các màn này nếu chưa deploy.
- 9 nhà xe, 6 nhà xe có tuyến + giá + xe dùng được (`hoanglongasia`, `nhaxevanminh` chưa có tuyến; `kumho` chỉ còn giá hết hạn). 0 lịch chạy, 5 chuyến trong 14 ngày tới.
- Nhân viên: `futabuslines` 1 soát vé, `hai-van` 1 tài xế, `kumho` 1 tài xế; `kumho-samco` chưa có ai và 0 văn phòng.
- Cổng DEMO đã chạy thành công 5 lần; VNPay sandbox chưa lần nào thành công.
- **Chưa có chính sách hủy** nào được công bố → hủy vé hoàn 0 đ. Mốc hủy được chụp vào đơn lúc đặt, nên nếu demo hủy vé thì công bố chính sách (Admin → Chính sách) **trước** khi chạy script và trước khi đặt vé demo.
- Có chính sách VXN Plus → điểm thưởng cộng được.

### 11.4. Lệnh (chạy trong `apps/api`)

```bash
# local — bản sao, không đụng vexenhanh_dev
pnpm exec tsx scripts/seed-demo.ts --database <bản-sao> --showcase kumho-samco
# production — chỉ đọc
pnpm exec tsx scripts/seed-demo.ts --env .env.production --showcase kumho-samco --dry-run
# production — ghi, sau khi đã sao lưu; đặt DEMO_STAFF_PASSWORD trong shell trước
pnpm exec tsx scripts/seed-demo.ts --env .env.production --yes-production --showcase kumho-samco --concurrency 6 [--passenger-email <hộp thư thật>] [--reviews]
```

Mặc định khi dùng `.env.production`: 14 ngày lịch sử, 21 ngày chuyến tương lai, bán trước 7 ngày, 40 khách mô phỏng, hệ số lấp ghế 0,6, tắt đánh giá. Đổi bằng `--history-days`, `--future-days`, `--presale-days`, `--customers`, `--fill`, `--operators a,b`.

### 11.5. Lịch đề xuất

| Khi | Việc | Ai |
| --- | --- | --- |
| 17/11 | Chốt §11.6; commit + push; deploy API (CI build image → kéo image trên Lightsail) | Khanh |
| 18/11 sáng | Công bố chính sách hủy (nếu demo hủy vé) → sao lưu production → `--dry-run` → chạy thật → truy vấn đối chiếu → mở Operator OS / Admin / Marketplace xem | Claude, khi Khanh đồng ý từng bước |
| 18/11 chiều | Tổng duyệt trên điện thoại thật: app hành khách + app nhân viên (APK trỏ `api.vexenhanh.id.vn`), đặt 1 vé bằng cổng DEMO, soát vé, hoàn thành chuyến | Khanh (+ Claude) |
| 19/11 08:15 | Chạy lại đúng lệnh hôm 18/11 (làm mới: đóng chuyến 18/11, bán trước ngày mới, phân công tới D+3, payout) — vài phút | Claude / Khanh |
| 19/11 08:30 | Checklist §11.7 | Khanh |

### 11.6. Cần Khanh chốt

| # | Câu hỏi | Đề xuất |
| --- | --- | --- |
| 1 | Deploy code hiện tại lên production trước buổi demo? | **Có**: commit + push phase 4 và script, CI build, kéo image trên Lightsail. Không deploy thì app / web dùng khi demo phải cùng phiên bản với API cũ |
| 2 | Hộp thư nhận OTP cho hành khách trưng bày trên production | Một hộp thư thật của Khanh (Gmail dạng `+demo` được). Script gắn ~15 đơn lịch sử + điểm vào tài khoản đó, không gửi email cho đơn lịch sử. Không có thì bỏ nhân vật này |
| 3 | Nhà xe trưng bày | `kumho-samco`: 5 xe, tuyến TP.HCM → Vũng Tàu 1,6 giờ — đặt, soát vé, hoàn thành gọn trong buổi demo |
| 4 | Đánh giá mô phỏng trên production (hiện công khai trên Marketplace, gắn tên thương hiệu thật) | **Tắt**; đánh giá tạo trực tiếp trong buổi demo |
| 5 | Cổng thanh toán khi demo | **DEMO** (đã chạy được trên production); VNPay sandbox chỉ thử thêm nếu 18/11 còn thời gian |
| 6 | Cách sao lưu trước khi ghi | Chép dữ liệu chỉ-đọc bằng script (như bản diễn tập) **và** `pg_dump` đầy đủ — cần tải ảnh Docker `postgres:17` (~150 MB): production chạy Postgres 17.6, máy chỉ có `pg_dump` 16 |
| 7 | Mật khẩu 4 tài khoản nhân viên demo | Khanh tự đặt vào `DEMO_STAFF_PASSWORD` lúc chạy |

### 11.7. Checklist sáng 19/11

- [ ] `https://api.vexenhanh.id.vn/v1/health` trả 200; worker đang chạy (đơn thanh toán DEMO được xác nhận trong vài giây).
- [ ] Marketplace và app hành khách: tìm TP.HCM → Vũng Tàu ngày 19/11 thấy chuyến Kumho Samco 11:45 / 13:15 / 17:00 còn ghế (giờ theo bản diễn tập).
- [ ] Đặt vé trực tiếp trên chuyến **13:15** (34 giường); app nhân viên đăng nhập sẵn `kumho-samco/nv.soatve01` và `kumho-samco/nv.taixe01`, chuyến hiện ở "Chuyến hôm nay".
- [ ] Operator OS (Owner Kumho Samco) và Admin đăng nhập sẵn (TOTP), mở tab Đơn hàng / Payout.
- [ ] Hộp thư của hành khách trưng bày mở sẵn để nhận OTP và email vé.
- [ ] Dự phòng: ảnh chụp / video buổi tổng duyệt 18/11 nếu API gặp sự cố.

## 12. Bộ dữ liệu chụp ảnh báo cáo — làm ngay 17/11 (Khanh chốt: cần trước 18/11)

Khanh tự chụp; Claude dựng dữ liệu + môi trường. Áp đề xuất §10 trừ hai điểm đổi vì hạn gấp: khung **30 ngày lịch sử** (biểu đồ báo cáo tối đa 31 ngày) thay vì 60, và **giữ tên nhà xe của kit** cho khớp bộ ảnh K/U đã chụp — chú thích ảnh ghi "dữ liệu mô phỏng".

| Thành phần | Cách làm |
| --- | --- |
| DB | `vxn_report_demo` = `CREATE DATABASE … TEMPLATE vexenhanh_dev` (dev giữ nguyên); thêm chính sách SEAT_HOLD / PAYOUT / LOYALTY chép từ production (dev chưa có LOYALTY nên VXN Plus không cộng điểm), đổi 21 email `@gmail.com` của kit sang `@example.com`; chạy `seed-demo.ts` cho cả 20 nhà xe (30 ngày lịch sử, bán trước 10 ngày, 60 khách mô phỏng, đánh giá bật, nhà xe trưng bày `kumho-samco`); 5 hành khách đã lưu cho `minhanh@example.com` |
| API + worker | `apps/api/tmp/report-demo/start.mjs` (không commit): build nhánh hiện tại, **cổng 3000** để web và app dùng cấu hình mặc định; email không gửi thật mà ghi ra `apps/api/tmp/report-demo/mail/` (lấy OTP, chụp email vé); cổng DEMO bật; không gửi push; kho tệp riêng `tmp/report-demo/storage` (chép từ `.storage`) |
| Tài khoản | Hướng dẫn + mật khẩu chụp ảnh trong `apps/api/tmp/report-demo/` (không commit); Owner + nhân viên Kumho Samco dùng chung mật khẩu chụp ảnh trên bản sao; Owner / Admin cài TOTP ở lần đăng nhập đầu |
| Trạng thái tạo trực tiếp khi chụp | Hủy vé + hoàn tiền, bán vé tại quầy, duyệt / chi payout, khiếu nại, hồ sơ đăng ký nhà xe, chiến dịch → hộp thư — làm ngay trên giao diện để vừa có dữ liệu vừa có ảnh luồng |

Kết quả 17/11 sáng (`vxn_report_demo`): 1.040 chuyến mới, 19.848 đơn / 29.493 vé, 1.814 chuyến hoàn thành, 3.461 đánh giá, 10.148 giao dịch điểm; payout 316 Đã chi / 20 Chờ chuyển / 60 Chờ duyệt (bước riêng cho bản sao, ghi bút toán `PAYOUT` như Admin xác nhận chi); hành khách trưng bày 13 đơn đã đi + 8 sắp đi, 8 đánh giá, 311 điểm. Chạy ~21 phút; 39 chuyến dính deadlock khi chạy song song (khóa tài khoản điểm chéo nhau) → script nay khóa theo thứ tự `userId` và tự chạy lại chuyến bị deadlock, chạy lại 0 lỗi. Truy vấn đối chiếu §11.2 đạt. Đã thử: Marketplace (trang chủ, kết quả tìm chuyến) hiển thị đúng; Owner Kumho Samco + Admin đăng nhập được (mật khẩu + TOTP), các màn tổng quan / báo cáo 30 ngày / payout / thanh toán / đánh giá / hành khách trả về trong 14–440 ms. Chưa thử: từng màn Operator OS / Admin trên giao diện, app hành khách và app nhân viên trên dữ liệu này.
