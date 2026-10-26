# Bán vé tại văn phòng nhà xe — Phân tích mở rộng

> Ngày cập nhật: **26/10/2026**. Nguồn: Khanh xác nhận phạm vi và mốc khởi hành trong chat ngày 26/10/2026.
> **Trạng thái:** quyết định nghiệp vụ tại §1 đã được Khanh chốt; thiết kế tại §3–§8 là **ĐỀ XUẤT, chưa duyệt**, chưa triển khai code. Tài liệu này là ghi chú phân tích bổ trợ SRS, không thay thế HLD / LLD / DB / API / UI / Security / Test / Task.

## 1. Quyết định đã chốt

| Nội dung | Quyết định của Khanh |
| --- | --- |
| Chủ thể | Văn phòng bán vé của nhà xe, thuộc phạm vi nhà xe đó. |
| Số văn phòng | Quản lý **nhiều văn phòng ngay từ đầu**. |
| Phương thức thu | **Tiền mặt và chuyển khoản**. |
| Hoa hồng | Vé quầy **có chịu hoa hồng**, theo mức cấu hình **thấp hơn mức online**. Chưa chốt con số cụ thể. |
| Giờ bán | Quầy được bán sau giờ ngừng bán online, đến khi xe khởi hành. |
| Định nghĩa khởi hành | Theo lúc **tài xế / điều phối xác nhận xe thực sự khởi hành**, kể cả trễ lịch. Giờ khởi hành dự kiến không tự đóng bán quầy. |

Các quyết định này không mặc nhiên chốt phương thức xác minh chuyển khoản, cách thu hoa hồng từ nhà xe, phân quyền theo văn phòng hay quy tắc trả sau / đặt cọc.

Nguồn yêu cầu chính thức: [SRS §6.2 và §21](../SDLC/01-srs-he-thong-dat-ve-xe-khach.md).

## 2. Nền hiện có và khoảng trống

- Operator OS đã có chuyến, sơ đồ ghế, khóa ghế bán ngoài hệ thống, xem booking / vé, danh sách hành khách và xuất file. `BLOCKED` hiện chỉ chặn ghế; không đại diện cho booking, hành khách hay khoản thu tại quầy. Nguồn: [SRS FR-OPS-13..15](../SDLC/01-srs-he-thong-dat-ve-xe-khach.md), [ghi chú OPR-003](OPR-003-todo.md).
- Giữ ghế và tạo booking hiện dành cho guest / passenger; cần đường thao tác nhân viên với tenant và người bán được xác thực. Nguồn: [booking controller](../../apps/api/src/booking/booking.controller.ts), [seat-hold service](../../apps/api/src/seat-hold/seat-hold.service.ts).
- `OPERATOR_MANAGER` đã có trong code; mẫu “Bán vé & CSKH” mới có quyền xem đơn và hỗ trợ. Thiết kế tài khoản này còn chờ duyệt trong [IAM-007](IAM-007-todo.md). `Employee` hiện dùng app nhân viên; không mặc nhiên được vào Operator OS.
- `StopPoint` loại `OFFICE` hiện là văn phòng / điểm trung chuyển, chưa mô hình hóa nơi chịu trách nhiệm bán và thu tiền. Không tự đồng nhất hai khái niệm. Nguồn: [GLOSSARY](../context/GLOSSARY.md), [API §7.3](../SDLC/05-api-specification.md).
- Code đã có `TripStatus.DEPARTED` và `Trip.departedAt` thực tế. Tài xế được phân công xác nhận qua luồng vận hành; điều phối chưa có đường xác nhận tương đương. Nguồn: [schema Trip](../../apps/api/prisma/schema.prisma), [employee operations](../../apps/api/src/check-in/employee-operations.service.ts).
- Hoa hồng hiện phân giải theo nhà xe và hiệu lực, chưa có chiều kênh bán. Code chốt mức tại lúc thanh toán thành công, lưu mức áp dụng vào bút toán và dùng lại khi đảo hoa hồng; phép tính dùng BigInt, làm tròn xuống đồng. Đây là hiện trạng code cần đối chiếu khi thiết kế quầy, không phải quyết định mới. Nguồn: [escrow entries](../../apps/api/src/escrow/escrow-entries.ts), [payment callback](../../apps/api/src/payment/payment-callback.ts).

## 3. ĐỀ XUẤT — Nhiều văn phòng và trách nhiệm người bán

Mở rộng trong `apps/operator-os`, dùng chung backend và kho ghế hiện có. Chưa cần ứng dụng hay module nghiệp vụ độc lập.

| Khái niệm đề xuất | Nội dung cần thiết kế |
| --- | --- |
| Văn phòng bán vé | Mã, tên, nhà xe sở hữu, địa chỉ, trạng thái hoạt động. Quan hệ tùy chọn với điểm trung chuyển nếu thực tế cùng địa điểm. |
| Phân công tài khoản | Tài khoản được làm việc tại một hoặc nhiều văn phòng; phân biệt bán vé, xác nhận thu, xem báo cáo, chốt ca và hoàn tiền. |
| Dấu vết đơn quầy | Nhà xe, kênh bán, văn phòng và tài khoản tạo đơn; giữ lịch sử kể cả người bán chuyển văn phòng hay văn phòng ngừng hoạt động. |
| Ca thu tiền | Người chịu trách nhiệm, văn phòng, tiền đầu ca, khoản thu / hoàn theo phương thức, số thực bàn giao và chênh lệch. Mức chi tiết cần Khanh duyệt. |

Văn phòng không có kho ghế riêng. Mọi văn phòng cùng bán chuyến của nhà xe theo quyền; ghế đã giữ hoặc bán ở một nơi phải được phản ánh ở các nơi còn lại và kênh online. Giới hạn xem tiền / đơn theo văn phòng không được làm sai tồn ghế chung.

Tenant lấy từ phiên đăng nhập; server kiểm văn phòng và phân công của người bán. Giữ `operatorId` filter + PostgreSQL RLS; kiểm phạm vi văn phòng bổ sung ở backend, không chỉ ẩn menu. Dữ liệu lịch sử không bị xóa theo văn phòng.

## 4. ĐỀ XUẤT — Luồng bán và thu tiền

1. Người bán chọn văn phòng được cấp quyền, chuyến, ghế và điểm đón / trả.
2. Giữ ghế qua cơ chế chung, tái sử dụng hạn giữ 10 phút; thời điểm khởi hành thực tế có quyền kết thúc khả năng chốt vé sớm hơn hạn giữ.
3. Nhập thông tin khách và kiểm tra bảng giá. Đề xuất khách không cần tài khoản, email tùy chọn; schema thông tin liên hệ và cách tra cứu vé cần thiết kế rõ trước code.
4. Tạo đơn có nguồn bán quầy và dấu vết người bán; không dùng phiên guest giả thay cho tài khoản nhân viên.
5. Chọn tiền mặt hoặc chuyển khoản. Đề xuất thu đủ trước khi phát hành vé; chưa mở đặt cọc / công nợ hành khách trong bản đầu.
6. Xác nhận khoản thu bằng tài khoản có quyền; server kiểm lại ghế, trạng thái chuyến, quyền văn phòng và tính duy nhất của thao tác trước khi chốt.
7. Phát hành vé QR qua lõi vé hiện có, ghi khoản thu và hoa hồng tương ứng; cập nhật danh sách hành khách. In lại vé không phát sinh vé hoặc khoản thu mới.

**Chuyển khoản:** đề xuất bản đầu tiền vào tài khoản của nhà xe, người được phân quyền đối chiếu tiền thực nhận rồi xác nhận. Ảnh chụp chuyển khoản tự nó chưa đủ để kết luận đã thu. Chủ tài khoản nhận, thẩm quyền xác nhận, nguồn tham chiếu giao dịch và cách chống dùng lại cần Khanh chốt; chưa thêm ngân hàng / vendor hoặc đồng bộ tự động.

Kênh bán và phương thức thu là hai thuộc tính khác nhau: vé quầy trả chuyển khoản vẫn dùng hoa hồng quầy. Kênh, văn phòng, người bán và mức hoa hồng do server xác định, client không được đổi đơn online thành đơn quầy để nhận phí thấp hơn.

## 5. ĐỀ XUẤT — Hoa hồng và đối soát

- Mở rộng cấu hình hoa hồng theo kênh bán, nhà xe và khoảng hiệu lực; quyền cấu hình theo cơ chế Admin hiện có. Chưa đề xuất mức riêng từng văn phòng.
- Ràng buộc “quầy thấp hơn online” cần so sánh với mức online có hiệu lực của cùng nhà xe. Phải kiểm cả các lần thay đổi / khoảng hiệu lực tương lai; cách xử lý cấu hình làm hai mức không còn hợp lệ cần duyệt trước code.
- Không tự đặt tỷ lệ quầy và không dùng mặc định online 5% khi thiếu cấu hình quầy. Đề xuất thiếu mức hợp lệ thì báo chưa đủ cấu hình để bán, không mặc nhiên miễn phí.
- Đề xuất giữ thời điểm chốt tỷ lệ lúc xác nhận thu thành công cho nhất quán code hiện tại; lưu kênh, rule, rate, cơ sở tính và số tiền hoa hồng đã dùng. Đổi cấu hình không tính lại đơn cũ.
- Tiền nhà xe thu trực tiếp không tạo khoản Platform đang giữ để payout lại. Cần sổ theo dõi khoản phải thu hoa hồng của Platform đối với nhà xe. Cách thu khoản đó là OPEN QUESTION: theo kỳ, khấu trừ tiền online đủ điều kiện, hoặc phương án khác.
- Hủy / hoàn phải liên kết khoản thu gốc, đảo hoa hồng theo dữ liệu đã chốt và tránh xử lý lặp. Quy tắc hoàn một phần, phí hủy, no-show và áp dụng khuyến mãi / loyalty cho vé quầy chưa được quyết định.
- Tiền VND dùng BIGINT / Decimal, không dùng number / float cho tiền. Phải xác định quy tắc làm tròn và phân bổ khi một booking có nhiều vé, hoàn từng phần để không sai lệch tổng.

Ví dụ **minh họa, không phải mức phí đã chốt**: nhà xe thu 600.000 ₫, mức quầy 2% thì hoa hồng là 12.000 ₫. Hệ thống ghi nhà xe đã thu 600.000 ₫ và khoản hoa hồng phải trả 12.000 ₫; không ghi Platform phải payout thêm 588.000 ₫ cho đơn này.

Đối soát cần tách tiền mặt, chuyển khoản, tiền hoàn và hoa hồng; tổng thu tại quầy không được nhầm với doanh thu thuần hay số tiền trong escrow. Tiền mặt dự kiến cuối ca = đầu ca + thu tiền mặt − hoàn tiền mặt, với các khoản nộp / rút / bàn giao được ghi riêng nếu chọn đưa vào bản đầu.

## 6. ĐỀ XUẤT — Đóng bán theo khởi hành thực tế

- Online tiếp tục theo cutoff online hiện hành; quầy có chính sách kiểm riêng, không tự đóng vì đã qua giờ dự kiến.
- Cho phép quầy xử lý trạng thái đón khách phù hợp, kể cả `BOARDING` khi chuyến chưa khởi hành. Vẫn chặn chuyến nháp, bị khóa, hủy, đã khởi hành / đang chạy / hoàn thành và ghế không đủ điều kiện; bảng trạng thái chi tiết cần đồng bộ LLD.
- Mở quyền xác nhận khởi hành cho điều phối được cấp quyền trong đúng nhà xe / chuyến, đồng thời giữ luồng tài xế được phân công. Đây là phần cần bổ sung vì hiện API chỉ hỗ trợ tài xế ở thao tác này.
- Khóa dòng chuyến dùng chung giữa xác nhận `DEPARTED` và chốt khoản thu / vé. Transaction nào hợp lệ trước thì hoàn tất trước; transaction bán chạy sau khởi hành phải bị từ chối. Kiểm mốc ở server, không dựa vào đồng hồ trình duyệt.
- Ghế còn đang giữ khi xe khởi hành không cho phép phát hành vé muộn. Tiền chuyển đến sau khởi hành hoặc tiền đã thực nhận nhưng chốt vé thất bại phải vào xử lý ngoại lệ, không tự phát vé / ghi thanh toán thất bại như thể chưa nhận tiền. Cách hoàn / đổi chuyến cần Khanh duyệt.
- Ghi người xác nhận, thời điểm server và audit sự kiện khởi hành. Rủi ro tài xế / điều phối quên xác nhận cần hiển thị nhắc việc / cảnh báo; không tự đổi sang cutoff giờ lịch trái quyết định đã chốt.

## 7. ĐỀ XUẤT — Giao diện và lát triển khai

| Lát triển khai | Kết quả cần đạt |
| --- | --- |
| Văn phòng + phân quyền | Quản lý nhiều văn phòng; tài khoản có phạm vi làm việc; bộ lọc và lịch sử đầy đủ. |
| Bán quầy trọn luồng | Chọn chuyến / ghế, nhập khách, tiền mặt / chuyển khoản, phát và in vé; đồng bộ kho ghế / danh sách hành khách. |
| Hoa hồng theo kênh | Admin cấu hình, kiểm mức quầy thấp hơn, snapshot giao dịch; báo cáo khoản phải thu. |
| Vận hành chuyến | Điều phối / tài xế xác nhận khởi hành; chặn bán đồng thời sau mốc thực tế. |
| Đối soát + xử lý ngoại lệ | Ca bán, bàn giao, hủy / hoàn theo quyền; xử lý chuyển khoản muộn và giao dịch chưa hoàn tất. |

Operator OS dự kiến thêm nơi quản lý văn phòng, màn bán tại quầy, danh sách giao dịch theo kênh / văn phòng / người bán, ca thu tiền và tài chính quầy. Admin mở rộng cấu hình hoa hồng theo kênh. Đây là đầu ra đề xuất cho UI, chưa phải thiết kế màn đã duyệt.

Sau khi chốt các câu hỏi §9, cần đồng bộ HLD / LLD / DB / API / UI / Security / Test / Task, DOMAIN-MAP / GLOSSARY nếu phát sinh thuật ngữ chính thức. Chưa cấp mã task / entity / error / permission mới trong ghi chú này, chưa thay ADR / vendor.

## 8. ĐỀ XUẤT — Tiêu chí nghiệm thu trọng yếu

- Hai văn phòng và khách online cùng mua một ghế: chỉ có một kết quả bán hợp lệ; không phân mảnh kho ghế.
- Người bán không dùng văn phòng / tài khoản của nhà xe khác; kiểm cả phạm vi office đã được cấp và thao tác báo cáo / hoàn tiền.
- Gửi lại xác nhận thu hoặc tải lại trang sau timeout không tạo khoản thu, hoa hồng hay vé trùng; lỗi in vé có thể in lại an toàn.
- Giờ dự kiến đã qua nhưng xe chưa được xác nhận khởi hành: quầy vẫn bán khi các điều kiện khác hợp lệ. Sau `DEPARTED`: cả giữ mới và chốt vé đều bị chặn.
- Chốt vé đồng thời xác nhận khởi hành: khóa chuyến bảo đảm không phát hành vé sau mốc khởi hành đã ghi.
- Chuyển khoản trùng tham chiếu / chuyển thiếu / thừa / muộn, tiền đã nhận nhưng chốt vé thất bại: có kết quả nghiệp vụ và dấu vết xử lý rõ, không mất khoản thu.
- Money math, so sánh mức quầy với online theo hiệu lực, snapshot, hoàn một phần và đảo hoa hồng: tổng đúng tới đồng, không dùng số thực cho tiền.
- Tiền nhà xe tự thu không làm tăng escrow / payout; đối soát từng văn phòng khớp tổng nhà xe, tiền mặt không bị cộng lẫn chuyển khoản.

Các mục trên là kế hoạch kiểm chứng; chưa chạy test vì chưa thay code.

## 9. OPEN QUESTION — Cần chốt trước thiết kế dùng để code

| Điểm | Chưa chốt | Hướng đề xuất để thảo luận |
| --- | --- | --- |
| Xác minh chuyển khoản | Tài khoản nhận, người xác nhận, tham chiếu chống trùng, tiền thiếu / thừa / đến muộn | Chuyển vào nhà xe, xác nhận thủ công có audit ở bản đầu. |
| Thu hoa hồng | Thu theo kỳ hay khấu trừ tiền online; kỳ hạn, khoản thiếu bù, điều chỉnh khi hoàn | Theo dõi khoản phải thu riêng; chỉ áp cơ chế thu được Khanh chọn. |
| Cấu hình phí | Mức quầy ban đầu, phạm vi chung / riêng nhà xe và xử lý thay đổi online làm vi phạm “thấp hơn” | Có mức quầy riêng theo kênh / nhà xe / hiệu lực, không lấy fallback online. |
| Phân quyền văn phòng | Ai được bán / xem / chốt / hoàn tại một hay nhiều office; xử lý vé office khác | Tận dụng tài khoản quản lý Operator OS và danh sách văn phòng được cấp. |
| Ca và bàn giao | Có quỹ đầu ca, nhiều người chung két, nộp / rút, duyệt chênh lệch không | Mỗi người chịu trách nhiệm khoản thu rõ ràng; thiết kế mức tối thiểu sau khi chốt cách vận hành. |
| Ngoại lệ và ưu đãi | Thu tiền nhưng hết hạn / đã khởi hành, hoàn / đổi, giá riêng, khuyến mãi / loyalty | Bản đầu thu đủ theo bảng giá; mọi ngoại lệ có quyền và audit, không mặc nhiên áp ưu đãi online. |

Không đặt lại câu hỏi đã được chốt về nhiều văn phòng, hai phương thức thu, việc có thu hoa hồng hay cutoff theo khởi hành thực tế.
