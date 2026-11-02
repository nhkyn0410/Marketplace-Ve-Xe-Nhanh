# COUNTER-SALES — Todo: bán vé tại văn phòng nhà xe

> Ngày cập nhật: **28/10/2026**. Khanh yêu cầu thực hiện theo [kế hoạch phân tích](COUNTER-SALES-analysis.md).
> Worktree: `C:\Code\vexenhanh_OPUPDATE`; nhánh `feat/selling_tickets`, từ `develop`. Không commit / push trong lượt này.
> **Trạng thái:** đã triển khai và kiểm tra phạm vi bán/thu/phát vé được chốt. Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu). Ca/quỹ/bàn giao và hoàn/đổi quầy còn chờ chính sách.

## 1. Phạm vi và quyết định

- Nhiều văn phòng nhà xe ngay từ đầu, dùng chung kho ghế với online.
- Tiền mặt và chuyển khoản; Khanh đồng ý chuyển khoản vào nhà xe, đối chiếu và xác nhận thủ công. Chưa có đồng bộ ngân hàng / vendor mới.
- Hoa hồng quầy thấp hơn online khi được cấu hình; **mặc định 0% nếu chưa có cấu hình riêng** (Khanh 27/10), không lấy mặc định online 5%.
- Khoản hoa hồng phải thu theo dõi riêng; thu theo kỳ và xác nhận thủ công (Khanh đồng ý 27/10). Chưa chốt kỳ hạn / chênh lệch.
- Quầy được bán sau cutoff online đến khi tài xế / điều phối xác nhận khởi hành thực tế; giờ lịch không tự đóng bán quầy.
- Nhân viên bán vé đăng nhập cổng riêng, do nhà xe quản lý; role `SALES_STAFF` tách `TICKET_STAFF` soát vé. Chủ nhà xe cũng được bán web và mọi đơn phải lưu người bán. Triển khai chủ nhà xe thấy mọi office, nhân viên thấy office đang hoạt động được phân công; chưa mở quyền chốt ca / hoàn.

## 2. Nền đã triển khai

- [x] Dữ liệu văn phòng bán vé riêng với điểm trung chuyển `StopPoint.OFFICE`; nhiều văn phòng thuộc một nhà xe, ngừng hoạt động thay vì xóa lịch sử.
- [x] API và Operator OS quản lý văn phòng: tải / lỗi / rỗng / phân quyền, tenant từ phiên, kiểm service + PostgreSQL RLS.
- [x] Điều phối xác nhận khởi hành thực tế trên Operator OS; dùng timestamp server và khóa dòng chuyến cùng luồng tài xế, không ghi đè mốc đã xác nhận.
- [x] Đồng bộ contract entity / API / quyền / RLS / test vào SDLC và DOMAIN-MAP / GLOSSARY, giữ trạng thái tài liệu hiện có.
- [x] Kiểm tra lint, typecheck, test liên quan; ghi rõ test đã chạy và phần chưa kiểm tra bên dưới.

Cổng `/auth/counter/login` → `/counter` đã có luồng bán/thu/phát/in lại vé. Owner tạo văn phòng và nhân viên `SALES_STAFF` qua Operator OS. Hướng dẫn: [COUNTER-SALES-guide.md](COUNTER-SALES-guide.md). Chưa commit/push hoặc áp migration lên dữ liệu dùng chung.

## 3. Luồng nghiệp vụ và giới hạn

- [x] Cổng đăng nhập nhân viên bán vé + quản lý `SALES_STAFF`; phân công theo văn phòng, server kiểm cả tenant và office, không chỉ ẩn giao diện.
- [x] Luồng giữ ghế / đơn quầy dùng kho chung, người bán được xác thực, lưu channel / office / seller; chính sách quầy tách cutoff online.
- [x] Thu tiền mặt / chuyển khoản thủ công, idempotency, chống trùng tham chiếu, xử lý tiền đã nhận khi chốt vé thất bại; không coi ảnh chuyển khoản là xác nhận tự động.
- [x] Phát và in lại vé QR, đồng bộ danh sách hành khách; không tạo vé / khoản thu trùng khi gọi lại.
- [x] Cấu hình hoa hồng theo kênh / operator / hiệu lực, mặc định quầy 0%, snapshot bất biến và kiểm quầy thấp hơn online.
- [x] Sổ khoản phải thu hoa hồng + thu theo kỳ thủ công; tiền nhà xe tự thu không tăng escrow / payout.
- [ ] Ca / quỹ / bàn giao, hoàn / đổi, chuyển khoản muộn và ưu đãi sau khi chốt quy tắc.
- [x] Test race hai văn phòng + online cùng ghế, race bán / khởi hành, idempotency, tenant / office isolation, money / snapshot. Đảo phí khi hoàn chờ chính sách hoàn quầy.

Tiền đã thực nhận khác tổng/hết hạn/khởi hành/lỗi phát vé hoặc có ngoại lệ chưa xử lý được giữ dưới `EXCEPTION`; không tự gộp thành trả sau/đặt cọc. Cùng khóa trả lại kết quả cũ; khóa mới là khoản tiền mới, kể cả số tiền mặt trùng khoản trước. QR/response được dựng sau commit để lỗi hiển thị không rollback tiền đã ghi. Chỉ Platform xác nhận thu hoa hồng; tenant chỉ đọc settlement.

## 4. Còn cần Khanh chốt

| Nội dung | Trạng thái |
| --- | --- |
| Xác minh chuyển khoản: tham chiếu, thiếu / thừa / muộn | Đã chốt tiền vào nhà xe, xác nhận thủ công; chi tiết ngoại lệ còn mở. |
| Quyền chốt ca / hoàn và thao tác với vé văn phòng khác | Đã chốt cổng nhân viên bán vé riêng + chủ nhà xe bán được; chưa tự mở thêm các quyền này. |
| Kỳ thu hoa hồng, xác nhận / minh chứng / chênh lệch và điều chỉnh khi hoàn | Đã chọn thu theo kỳ thủ công; chi tiết còn mở. |
| So sánh mức cấu hình quầy / online khi thay đổi khoảng hiệu lực | Đã kiểm mọi khoảng hiệu lực; từ chối cấu hình/sửa/hủy làm mức quầy không thấp hơn online. Thiếu cấu hình quầy riêng áp0%. |
| Ca / quỹ / bàn giao, hoàn / đổi, giá riêng, promotion / loyalty | Chưa chốt; chưa triển khai. |

## 5. Kiểm tra

Môi trường kiểm tra: PostgreSQL16/Redis7/MongoDB7 tạm riêng, role app không BYPASSRLS; toàn bộ56 migration áp thành công. Không áp migration lên database dùng chung.

| Kiểm tra cuối ngày28/10/2026 | Kết quả |
| --- | --- |
| Web/package unit test | 672 đạt: Operator OS464, Marketplace95, Admin62, UI40, shared types11. |
| API liên quan COUNTER-SALES, sau khi code ổn định | 17 file /237 test đạt, không skip; gồm11 integration test lõi quầy trên PostgreSQL/Redis thật, văn phòng/RLS, hoa hồng/thu phí, auth/RBAC, khởi hành, chặn hoàn online và OpenAPI. |
| Chrome giao diện quầy | 5/5 đạt, API giả có chủ đích; retry sau reload giữ cùng key/payload, in lại, chuyển khoản ngoại lệ, giữ vé khi có khoản thu bổ sung, không tràn ngang màn hẹp. Đã xem ảnh desktop/mobile. |
| Lint / typecheck toàn monorepo | Đạt. |
| Build toàn monorepo | Đạt, gồm API và ba web. |
| OpenAPI/client | Sinh lại thành công; OpenAPI đối chiếu khớp bản build API mới nhất; có hồi quy chặn thiếu controller/DTO quầy. |

Lượt toàn API tuần tự đạt1731/1732 test (179 file đạt,1 file chưa đạt): ca lỗi QR chưa đạt trong lượt chạy có cập nhật code/test giữa chừng. Sau khi chốt ranh giới commit, đã chạy lại toàn nhóm17 file/237 test nêu trên và đạt, bao gồm đủ11 test của file quầy. Chưa chạy lại toàn bộ API trên bản chốt cuối; không ghi lượt toàn API này là pass và chưa có kết quả CI remote. Lượt song song trước còn timeout/xung đột fixture payout; kiểm tra DB dùng thứ tự tuần tự để tránh batch job tác động dữ liệu của suite khác.

Không coi API giả trong browser là kiểm thử transaction thật. Chưa review độc lập; chưa commit/push. Ca/quỹ/bàn giao, hoàn/đổi, đảo phí khi hoàn và kết thúc khoản thu ngoại lệ chưa có chính sách để triển khai.
