# 06. UI/UX Flow Specification - Hệ thống đặt vé xe khách

## 1. Thông tin tài liệu

### 1.1. Metadata

| Thuộc tính    | Giá trị                     |
| ------------- | --------------------------- |
| Tên tài liệu  | UI/UX Flow Specification    |
| Mã tài liệu   | 06-ui-ux-flow-specification |
| Dự án         | Marketplace-Ve-Xe-Nhanh     |
| Trạng thái    | Review                      |
| Người viết    | Nguyễn Hồng Khanh, AI Agent |
| Người duyệt   | Nguyễn Hồng Khanh           |
| Ngày tạo      | 11/05/2026                  |
| Ngày cập nhật | 28/10/2026                  |

### 1.2. Lịch sử thay đổi

| Phiên bản | Ngày       | Người cập nhật | Nội dung thay đổi                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| --------- | ---------- | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| v0.1      | 11/05/2026 | AI Agent       | Tạo bản nháp UI/UX Flow Specification                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| v0.2      | 01/06/2026 | AI Agent       | **Rework** đồng bộ stack/quyết định (UI vốn tech-independent, chỉ chỉnh touchpoint): §4 kênh = Marketplace/Operator OS/Admin (Next.js) + 2 app Expo (Passenger/Employee) (ADR-013/014); §6.1 thêm flow đăng nhập Passenger (Email OTP + OAuth Google/FB/Apple, ADR-020); §6.2 payment = VNPay/MoMo redirect + seat hold timer 10 phút; §7/§9 login `{slug}/{username}` + `platform/{username}` + TOTP (ADR-017); §9 thêm flow payout confirm (manual + bank ref, ADR-022); KYC upload R2 (ADR-018). Đổi "User" → "Passenger". **Đóng UX-OQ-01** (guest checkout per SRS), **UX-OQ-02** (cookie+Bearer per ADR-017), **UX-OQ-05** (brand trung lập per OQ-20). |
| v0.3      | 17/09/2026 | AI Agent       | §3: component lib đã chốt **Shadcn/ui + Tailwind CSS 4** cho cả 3 app web (ADR-013, Khanh chốt). |
| v0.4      | 23/09/2026 | AI Agent       | **Viết lại §6 Passenger/Guest theo Figma** (section _Giao diện dành cho Khách hàng_, 24 frame): §6.1 danh mục 35 màn `SCR-PSG-NN` (24 Review = có frame; 11 Draft = AI bổ sung); §6.2 luồng; §6.3 mỗi màn 1 bảng 5 trạng thái (Ideal / Empty / Loading / Partial-Edge / Error) đánh dấu Review/Draft; §10.1 thêm quy tắc 5 Key UI States áp cho mọi màn §6–§9; §6.4 8 điểm Figma lệch ADR/SRS (auth mật khẩu, phương thức thanh toán, hold 15', bản đồ OSM, SMS, copy hoàn/đổi vé, loyalty, add-on). §5 IA Passenger theo nav Figma. §11 mở UX-OQ-06..09. Trạng thái doc Approved → **Review** (còn OQ ảnh hưởng code, 00a §3.2). §7–§9 chưa đổi. |
| v0.5      | 25/09/2026 | AI Agent       | **TASK-IAM-006:** bổ sung §7/§9 state machine đăng nhập web, first-login đổi mật khẩu, TOTP, bootstrap cookie session, refresh single-flight và logout. Giữ trạng thái Review. |
| v0.6      | 28/09/2026 | AI Agent       | **ADR-017 amend / TASK-IAM-006 (Khanh chốt 28/09):** §4 Operator OS chỉ còn Owner; §7 login chỉ Owner, FE nhận ra username `nv.` và chỉ sang app Nhân viên, shell chỉ render khi `/auth/me` là `OPERATOR_OWNER`; form Employee có tiền tố cố định `nv.`; §8 Employee login `{slug}/nv.{…}` qua `/auth/employee/login`. Giữ trạng thái Review. |
| v0.7      | 29/09/2026 | AI Agent | **Loyalty VXN Plus / ví voucher / bài viết (Khanh chốt 29/09/2026, SRS v1.21) — đóng UX-OQ-06, UX-OQ-08:** §5 nav Thành viên + menu Ví voucher / Lịch sử điểm, Admin thêm Loyalty / Articles; §6.1 SCR-PSG-02, 33–35 vào phạm vi, thêm SCR-PSG-36 (Ví voucher) và SCR-PSG-37 (Chi tiết bài viết); §6.2 luồng VXN Plus và Khám phá; §6.3 viết đủ 5 trạng thái cho 33–37; §6.4 #7 đổi thành lệch "giảm giá / ưu tiên CSKH theo hạng" (v1 chỉ hệ số điểm); §9 Admin Loyalty + Bài viết. Giữ trạng thái Review. |
| v0.8      | 29/09/2026 | AI Agent | SRS v1.22 tách use case: §9 Admin dòng Loyalty → `UC-39`, dòng Bài viết → `UC-40` (SCR-PSG-02/37 vẫn là `UC-38` đọc bài). Giữ trạng thái Review. |
| v0.9      | 30/09/2026 | AI Agent | **A2 — đăng ký nhà xe theo closed enrollment (Khanh duyệt 30/09/2026, SRS v1.23)**: §7 dòng đăng ký nhà xe là trang công khai + link bảo mật, không cần đăng nhập; §9 Admin duyệt hồ sơ nhập slug + username Owner. Giữ trạng thái Review. |
| v0.10     | 30/09/2026 | AI Agent | §6.4 #1: ghi nhận SRS v1.25 đã đồng bộ xác thực hành khách (email OTP + OAuth, không mật khẩu); Figma vẫn cần sửa. Giữ trạng thái Review. |
| v0.11     | 02/10/2026 | AI Agent | **Bỏ hướng dẫn "sai cổng" ở cả hai màn đăng nhập (Khanh chốt 02/10/2026):** §7 màn Login Operator OS không còn nhận ra tiền tố `nv.` để hiện "đăng nhập trên app Nhân viên"; nhân viên gõ vào Operator OS nhận cùng lỗi generic `AUTH_INVALID_CREDENTIALS` từ API. §8 app Nhân viên đối xứng: username thiếu `nv.` không còn bị chặn tại app để hiện "Chủ nhà xe đăng nhập trên web Operator OS", cũng nhận lỗi generic từ API. Lớp phòng thủ thứ hai (kiểm role qua `/auth/me`) giữ nguyên nhưng chỉ hiện thông báo chung về phiên. Không đổi API / Security / Test (TC-SEC-009 đã kiểm lỗi generic). Giữ trạng thái Review. |
| v0.12     | 03/10/2026 | AI Agent | **Hình ảnh phương tiện (Khanh chốt 03/10/2026, SRS v1.32):** SCR-PSG-15 thêm ảnh đại diện xe trên thẻ chuyến; SCR-PSG-16 thêm bộ ảnh xe trong khối "Thông tin xe"; §6.4 #9 — Figma `385:7387` và `385:5411` chưa có vùng ảnh; §7 form xe thêm khối ảnh; §9 Admin rà soát / gỡ ảnh xe. Giữ trạng thái Review. |
| v0.13     | 04/10/2026 | AI Agent | **Phân loại xe và loại chỗ (Khanh chốt 04/10/2026, SRS v1.33):** SCR-PSG-15 lọc loại xe tách hai nhóm (dạng chỗ, hạng); SCR-PSG-18 hiển thị chỗ đôi; §6.4 #10; §7 form xe hiện dạng chỗ + hạng, seat map editor chọn 5 loại chỗ; `UX-OQ-03` thêm cách vẽ chỗ đôi. Giữ trạng thái Review. |
| v0.14     | 04/10/2026 | AI Agent | **Đối chiếu Figma nhà xe (Khanh chốt 04/10/2026):** đóng phần "chỗ đôi" của `UX-OQ-03` — chỗ đôi là một ô lưới, vẽ rộng hơn chỗ đơn (Figma `1115:4906`); §7 — ảnh xe có chú thích, mỗi tầng có số hàng / cột riêng, khóa trước sơ đồ đang dùng theo `seatMapLocked` / `inUse`. Giữ trạng thái Review. |
| v0.15     | 04/10/2026 | AI Agent | **Đóng `UX-OQ-03` (Khanh chốt 04/10/2026):** trình soạn sơ đồ ghế dùng lưới tự do, v1 không làm mẫu theo loại xe; §7 thêm quy tắc tạo lưới (số hàng / cột theo từng tầng, mã tự đánh, đổi ô, xác nhận khi tạo lại lưới). "Bố cục gợi ý" điền sẵn để sau v1. Giữ trạng thái Review. |
| v0.16     | 04/10/2026 | AI Agent | **Thiết kế lại điểm dừng (Khanh chốt 04/10/2026, SRS v1.35):** §5 thêm mục Điểm dừng cho Operator OS và Admin; §7 màn Điểm dừng của nhà xe (hai tab, hộp thoại, đề xuất kèm căn cứ, bản đồ chọn tọa độ) + form tuyến chọn cho đón / cho trả; §9 màn Điểm dừng của Admin (ba tab); SCR-PSG-15 / 16 / 18 — tìm theo tỉnh và địa danh, nhãn trung chuyển, trạm dừng nghỉ không chọn được. Giữ trạng thái Review. |
| v0.17     | 05/10/2026 | AI Agent | **Trình soạn sơ đồ ghế dùng chung (Khanh chốt 05/10/2026, Figma `1197:6838`):** §7 thêm bốn chế độ (tạo mới / chỉnh sửa / tạo bản sao / xem chỉ đọc), ô "Loại chỗ ban đầu" có ở mọi chế độ sửa được, mỗi tầng phải có ít nhất một chỗ, số tầng / kích thước chỉ áp dụng khi tạo lại lưới. Giữ trạng thái Review. |
| v0.18     | 05/10/2026 | AI Agent | **Màn Điểm dừng của nhà xe (Khanh chốt 05/10/2026, `TASK-TRN-012`):** §7 — cột "số tuyến đang dùng" chỉ có ở tab Của nhà xe; ghi rõ tab Dùng chung không có nút sửa, cột và lọc trạng thái (API danh mục chỉ trả điểm đang hoạt động); ô tìm gõ không dấu vẫn ra kết quả. Giữ trạng thái Review. |
| v0.19     | 07/10/2026 | AI Agent | **Màn Điểm dừng và màn Tuyến đường của nhà xe (Khanh chốt 07/10/2026 khi duyệt Figma `1305:6710`, `TASK-TRN-013`):** §7 — nút gọi là "Đề xuất điểm dừng"; bản đồ thuộc V1 (tổng quan đóng mở ở màn Điểm dừng, chọn tọa độ trong hộp thoại, lộ trình trong form tuyến — `TASK-TRN-014`); thêm mô tả màn Tuyến đường: danh sách có cột Điểm đầu → Điểm cuối, form có thẻ Tổng quan + bản đồ lộ trình, bảng chọn điểm dừng mở ngay trong form. Giữ trạng thái Review. |
| v0.20     | 07/10/2026 | AI Agent | **Hiện thực ba bản đồ của nhà xe (`TASK-TRN-014`):** §7 — thêm mô tả hành vi đã làm cho bản đồ tổng quan, bản đồ chọn vị trí và bản đồ lộ trình (thiếu khóa / tải lỗi, khung nhìn mặc định, bấm ghim khác bấm dòng, giữ Ctrl để phóng to, chấm xám của bảng chọn — Khanh chốt giữ 07/10/2026). Giữ trạng thái Review. |
| v0.21     | 13/10/2026 | AI Agent | **Màn Chuyến xe của nhà xe (`TASK-TRN-003`):** §7 — thêm mô tả ba màn đã làm theo Figma `1338:9559` (danh sách, tạo / sửa chuyến nháp, chi tiết chuyến) và phần của thiết kế để lại cho `TASK-TRN-005` / `TASK-TRN-006`. Giữ trạng thái Review. |
| v0.22     | 13/10/2026 | AI Agent | **Màn Bảng giá của nhà xe (`TASK-TRN-005`):** §5 thêm mục "Bảng giá" vào thanh bên Operator OS (sau "Tuyến đường"); §7 — mô tả hai màn đã làm theo Figma `1665:24187` / `1665:24475` (danh sách, tạo / chỉnh sửa), giá trên từng chỗ ở trang chi tiết chuyến, và hai điểm làm khác khung Figma (khung giờ là khoảng ngày giờ khởi hành chứ không phải giờ trong ngày; chưa có dải cảnh báo khung giá). Giữ trạng thái Review. |
| v0.23     | 14/10/2026 | AI Agent | **Màn Bảng giá — Khanh chốt 14/10/2026 hai điểm làm khác khung Figma `1665:24475`:** khung giờ của quy tắc là khoảng ngày giờ khởi hành (không làm giá theo giờ trong ngày); dải cảnh báo "giá nằm ngoài khung giá" làm cùng khung trần / sàn ở `TASK-ADM-001`. Cột "Khoảng giá mỗi chỗ" tính cả quy tắc có khung giờ đã qua. Khung Figma chưa vẽ lại theo hai điểm này. Giữ trạng thái Review. |
| v0.24     | 14/10/2026 | AI Agent | **Màn Chuyến xe — vòng đời bán và khóa chỗ (`TASK-TRN-006`):** §7 — mô tả phần đã làm theo Figma khung 03–06: ô "Ngừng bán online" ở form chuyến; nút Mở bán / Tạm dừng bán / Mở bán lại / Thu hồi về nháp / Hủy chuyến theo trạng thái; khối Điều kiện mở bán; chọn chỗ để khóa / mở khóa; hai hộp thoại; thẻ Tình trạng chỗ và Bán online; các điểm làm khác khung Figma. Giữ trạng thái Review. |
| v0.25     | 14/10/2026 | AI Agent | §6.1 — sửa ghi chú về `apps/passenger_mobile`: đã có khung Figma cho luồng đăng nhập và tìm → đặt → thanh toán → vé (trang `Mobile Ve_Xe`, bảng `1160:1854`, Khanh gửi 14/10/2026). Chưa đối chiếu từng khung với danh mục màn hình; việc đó làm cùng task đầu tiên của app (`TASK-TRN-004`). Giữ trạng thái Review. |
| v0.26     | 14/10/2026 | AI Agent | **Màn Nhân viên và màn Tài khoản của nhà xe (phần giao diện của `TASK-IAM-005`):** §7 — mô tả hai màn đã làm theo Figma `1666:25163` … `1666:25910` và `1668:28980`: bảng nhân viên, thêm / sửa / khóa / mở khóa / cấp lại mật khẩu tạm, bước xác nhận lại danh tính, bảng phiên đăng nhập và thu hồi phiên; các điểm làm khác khung Figma. Giữ trạng thái Review. |
| v0.27     | 14/10/2026 | AI Agent | **Khối ảnh của form xe (`TASK-TRN-009`):** §7 — mô tả khối đã làm theo Figma khung 01 / 02 / 04 / 08 và "Ảnh · Lỗi tại tệp" (`1106:5855`): ảnh lưu cùng nút "Lưu phương tiện", ảnh tải lỗi giữ ô với nút "Thử lại" và ảnh khác vẫn được lưu, đổi chỗ bằng kéo thả hoặc phím mũi tên, ảnh nén ở trình duyệt; danh sách xe có ảnh đại diện thu nhỏ. Giữ trạng thái Review. |
| v0.28     | 14/10/2026 | AI Agent | **Trang đăng ký nhà xe (`TASK-OPR-001`):** §7 — mô tả ba trang công khai đã làm theo Figma `1669:29021` … `1669:29595` (đăng ký → kiểm tra email → hoàn thiện hồ sơ / chờ duyệt / cần bổ sung → gửi lại link) và khối "Trở thành đối tác" ở màn đăng nhập (`840:2074`). Figma 07 / 08 (được duyệt / bị từ chối qua link) không tới được vì BR-75 thu hồi link khi có kết quả — chờ Khanh. Giữ trạng thái Review. |
| v0.29     | 15/10/2026 | AI Agent | **Cổng Admin (A1 + A2):** §9 — đăng nhập Admin dùng chung luồng web với Operator OS (màu indigo, thanh bên tối theo Figma `1661:24142`); dòng KYC Operator ghi màn hàng đợi / chi tiết / hộp thoại đã làm theo Figma ADM-02a…02d (`TASK-ADM-001`, chờ duyệt). Giữ trạng thái Review. |
| v0.30     | 15/10/2026 | AI Agent | **Màn Điểm dừng của Admin (`TASK-ADM-004`):** §9 dòng Điểm dừng ghi phần đã làm theo Figma ADM-05a…05e; bản đồ chọn tọa độ / tổng quan dùng chung với Operator OS (`packages/ui`). Giữ trạng thái Review. |
| v0.31     | 16/10/2026 | AI Agent | **Màn Danh mục chuẩn của Admin (`TASK-ADM-001` phần danh mục):** §9 dòng Catalog / policy ghi phần đã làm theo Figma ADM-04a…04c. Chờ Khanh duyệt; giữ trạng thái Review. |
| v0.32     | 16/10/2026 | AI Agent | **A5 Admin:** §9 dòng Content/review moderation (tab Ảnh phương tiện theo Figma ADM-10b/10c) và dòng Audit (Figma ADM-15a/15b) ghi phần đã làm. Chờ Khanh duyệt; giữ trạng thái Review. |
| v0.33     | 17/10/2026 | AI Agent | **Đợt hoàn thiện Admin + Operator OS (Khanh 16/10/2026, chờ duyệt):** §5 Operator OS thêm mục Khuyến mãi (Khanh duyệt trên Figma 13/10/2026); §7 ghi màn Hồ sơ & KYC (Figma 1667:27240 / 27586), Lịch xe (khung 07 / 08 / thẻ khung 02 — `TASK-TRN-015`), dải cảnh báo khung giá ở Bảng giá, khung các màn chờ đặt vé (Đặt vé, Khuyến mãi, Tài chính, Báo cáo, Hỗ trợ); §9 ghi màn Tổng quan (số thật của hàng đợi), Nhà xe (tạm khóa, xác minh đổi tài khoản nhận tiền), Người dùng (ADM-03a…03d), Chính sách (ADM-06a…06d), Bài viết (ADM-13a…13c), Tích hợp & hệ thống chỉ đọc (ADM-16a / 16b) và khung các màn chờ đặt vé. Giữ trạng thái Review. |
| v0.34     | 17/10/2026 | AI Agent       | **Phần không cần đặt vé (Khanh 17/10/2026, chờ duyệt):** §7 ghi màn Lịch chạy lặp lại (`TASK-TRN-007`, chưa có Figma), Phân công chuyến (Figma "05 · Nhân viên / Phân công chuyến", `TASK-EMP-001`); §9 ghi tab Nội dung công khai (Figma ADM-10d) + trang soạn (chưa có Figma, `TASK-ADM-003`). Giữ trạng thái Review. |
| v0.35     | 21/10/2026 | AI Agent | **Phân quyền theo từng tài khoản (`TASK-IAM-007`, chờ duyệt):** §5 Operator OS thêm "Tài khoản quản lý"; menu Admin / Operator OS ẩn theo quyền của phiên; hộp thoại tick quyền dùng chung (`packages/ui`). |
| v0.36     | 26/10/2026 | AI Agent | **Đóng UX-OQ-09 (Khanh 26/10/2026, chờ duyệt):** tra cứu vé Guest bắt buộc OTP qua email — web làm theo Figma 1446:14982 (B1) → 1446:15277 (B2: đếm ngược 5 phút, còn N lần thử, gửi lại sau 60 giây) → kết quả. |
| v0.37     | 26/10/2026 | AI Agent | **Figma thanh toán đổi sang payOS + cổng demo (Khanh 21/10 chọn, 26/10 "chỉnh thiết kế", chờ duyệt + chờ ADR thay ADR-019):** SCR-PSG-20 (Ideal + hết giờ giữ chỗ) bỏ VNPay / MoMo + chip ngân hàng, thay bằng "Chuyển khoản VietQR qua payOS" và "Cổng thanh toán thử (demo)"; nhãn phương thức / mã giao dịch ở SCR-PSG-16, 21, 22, 23, 25, 26 (hoàn qua chuyển khoản), 29, 31. Màn Admin (ADM-01, 07a–d, 09b, 14a, 16a–b) và Operator OS "02 · Đặt vé / Chi tiết đơn" còn VNPay / MoMo — sửa cùng task hiện thực payOS. |
| v0.38     | 27/10/2026 | AI Agent | **Tra cứu vé không cần mã đặt vé (Khanh 27/10/2026, chờ duyệt):** SCR-PSG-27 mã đặt vé không bắt buộc + dòng CSKH khi mất email; SCR-PSG-29 thêm danh sách đơn theo email (12 tháng, gồm đơn đặt bằng tài khoản) và hộp thoại hỏi đăng nhập — chưa có khung Figma cho danh sách. |
| v0.39     | 27/10/2026 | AI Agent | **Hủy vé và khiếu nại sau OTP (Khanh 27/10/2026, chờ duyệt):** SCR-PSG-29 khối "Thao tác với đơn" (Figma 1446:15578) bật "Hủy vé / yêu cầu hoàn tiền", "Gửi khiếu nại về đơn này" và nút "Hủy vé" ở từng vé cho đơn khách vãng lai — bấm thì mở quyền rồi sang trang quản lý vé / khiếu nại sẵn có; không hỏi OTP lần nữa (khác ghi chú Figma "cần xác minh lại bằng OTP"); đơn đặt bằng tài khoản hiện hướng dẫn đăng nhập. |
| v0.40     | 28/10/2026 | AI Agent | **Giờ đến tính theo tuyến (Khanh 27/10/2026, chờ duyệt, chưa có Figma):** §7 màn Tuyến đường thêm ô "Chạy thực tế … phút" ở từng chặng; màn Chuyến xe / Đổi lịch chạy / Lịch chạy lặp lại bỏ ô giờ đến / thời gian chạy, thay bằng dòng chỉ đọc theo tuyến. |
| v0.40     | 27/10/2026 | AI Agent | **Logo nhà xe + trang công khai (FR-OPR-02, TASK-MKT-001; Khanh 27/10/2026, tự thiết kế — chờ duyệt):** §7 Operator OS Hồ sơ & KYC — tải / đổi / gỡ logo, "Mở trang nhà xe" (tab mới tới web khách hàng), "Xem trước trên ứng dụng" (khung điện thoại mô phỏng màn nhà xe); SCR-PSG-17 hiện logo. Web khách hàng: đầu trang nhà xe và thẻ Nhà xe đối tác ở trang chủ dùng logo, chưa có thì chữ viết tắt. |
| v0.41     | 28/10/2026 | AI Agent | **Form tìm chuyến app hành khách (Khanh 27/10/2026, chờ duyệt):** chế độ tìm đổi tên "Theo tuyến" → **"Theo chuyến"** (Trang chủ và Mua vé như nhau); không làm màn "Chọn chuyến" riêng (Figma Mobile 06 trùng tab Mua vé 05) — Trang chủ bấm Tìm thì sang tab Mua vé, danh sách hiện ngay dưới form. Điểm đi / đến gõ để gợi ý tỉnh / thành và bến, địa danh dùng chung (bỏ trạm dừng nghỉ). Chế độ "Theo nhà xe": lần đầu là ô trống "Chọn nhà xe" / "Chọn tuyến", chọn tuyến của nhà xe là chọn cả điểm đi và điểm đến. Lọc tách dạng chỗ / hạng xe (BR-77). |
| v0.42     | 28/10/2026 | AI Agent | **Tab Tài khoản khi chưa đăng nhập (Khanh 27/10/2026, chờ duyệt — Figma chưa có khung):** bấm tab Tài khoản ở chế độ khách (từ mọi tab) mở màn trung gian "Tài khoản": lợi ích đăng nhập (hành khách đã lưu, ví voucher, điểm VXN Plus, đánh giá), nút "Đăng nhập / Đăng ký" mới sang màn đăng nhập, lối "Tra cứu vé đã đặt" (tab Hành trình) và tổng đài. Bỏ các thông báo "sẽ được triển khai": "Xem tất cả" chỉ hiện khi có màn danh sách (Khám phá & cẩm nang → tab Khám phá), thẻ VXN Plus mở Lịch sử điểm, Tra cứu vé nối FAQ + tổng đài. **Tra cứu vé app (như web, chỉ email):** bỏ ô mã đặt vé, ghi chú một dòng "Mã OTP được gửi đến email liên hệ để xác minh"; các bước Tra cứu → OTP → Kết quả đổi màn tức thì, không trượt. Bấm Đăng nhập sau khi đã vào app (hoặc đăng xuất / sửa email) mở thẳng màn đăng nhập, splash chỉ chạy lúc mở app. |

---

## 2. Mục lục

1. Thông tin tài liệu
2. Mục lục
3. Giới thiệu
4. Kênh giao diện
5. Information architecture
6. Flow hành khách (Passenger / Guest)
7. Flow Operator
8. Flow Employee
9. Flow Admin
10. Screen state và validation
11. Open Questions / TBD

---

## 3. Giới thiệu

Tài liệu này mô tả luồng màn hình, trạng thái giao diện, form validation và xử lý lỗi ở mức UX. UI/UX độc lập tech-stack về bản chất; bản rework này chỉ đồng bộ các touchpoint kỹ thuật (auth, payment, kênh) với quyết định đã chốt. Tham chiếu: `01-srs`, `05-api` (v0.2, endpoint), `07-security` (v0.4, auth UX), `context/GLOSSARY` (actor naming). Visual/component/wireframe chi tiết phát triển sau khi flow được duyệt + trên component lib đã chốt (ADR-013 — Shadcn/ui + Tailwind CSS 4). Thiết kế trực quan nằm ở Figma [UI-UX](https://www.figma.com/design/6c81q3DdHVS0anfDw2sVVj/UI-UX); tài liệu này chỉ tham chiếu frame, không mô tả lại bố cục.

---

## 4. Kênh giao diện

Web = Next.js 16 (ADR-013); Mobile = Flutter 2 app tách (ADR-028).

| Kênh                              | Actor              | Mục tiêu                                                                |
| --------------------------------- | ------------------ | ----------------------------------------------------------------------- |
| Marketplace (Web, RSC+SSG/ISR)    | Passenger, Guest   | Search, trip detail, booking, payment, ticket lookup                    |
| Operator OS (Web, CSR sau auth)   | Operator (Owner)   | Quản lý profile, vehicle, route, trip, booking, employee, finance. Employee không vào Operator OS (ADR-017 amend 28/09/2026) |
| Admin (Web, CSR sau auth)         | Admin              | KYC, catalog, policy, payment, payout, dispute, report, audit           |
| `apps/passenger_mobile` (Flutter) | Passenger          | Booking/ticket/notification/support trên mobile                         |
| `apps/employee_mobile` (Flutter)  | Employee           | Check-in, trip status, passenger list, incident report (background geo) |

---

## 5. Information architecture

| Portal                | Nhóm navigation chính                                                                                                                |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Marketplace/Passenger | Nav theo Figma: Khám phá, Trang chủ, Mua vé, Dịch vụ bổ trợ ⚠, Hành trình (vé của tôi), Thành viên (VXN Plus), Tra cứu vé, Khiếu nại, Câu hỏi thường gặp. Menu tài khoản: Hồ sơ, Hành khách đã lưu, Ví voucher, Lịch sử điểm, Bảo mật, Thông báo, Đánh giá của tôi, Hỗ trợ. ⚠ = chờ UX-OQ-07 |
| Operator OS           | Dashboard, Profile/KYC, Vehicles, Seat maps, Stop points, Routes, Fares, Trips (Danh sách / Lịch xe), Bookings, Promotions (Khuyến mãi — thêm 17/10/2026 theo Figma), Employees, Finance (escrow/payout), Reports, Support |
| Employee              | Assigned trips, Passenger list, QR scan, Trip status, Journey log, Incidents, Profile                                                |
| Admin                 | Dashboard, Operators/KYC, Passengers, Catalog, Stop points, Policy, Payments/Refunds, Payouts, Disputes, Promotions, Loyalty, Articles, Reports, Audit, Integrations |

---

## 6. Flow hành khách (Passenger / Guest)

Nguồn thiết kế trực quan: Figma **UI-UX**, section _Giao diện dành cho Khách hàng_ (node `381:2`) — [mở Figma](https://www.figma.com/design/6c81q3DdHVS0anfDw2sVVj/UI-UX?node-id=381-2). Figma hiện chỉ có **Marketplace web, desktop 1920px**. Mục này chỉ liệt kê màn hình và trạng thái, không mô tả bố cục (xem Figma).

Quy ước cột **Thiết kế**:

| Giá trị | Ý nghĩa                                                                       |
| ------- | ----------------------------------------------------------------------------- |
| Review  | Đã có frame Figma, chờ Khanh kiểm tra                                         |
| Draft   | AI bổ sung từ SRS/flow, chưa có frame Figma                                   |
| ⚠       | Frame lệch thiết kế đã chốt hoặc ngoài phạm vi SRS → xem §6.4 và §11         |

### 6.1. Danh mục màn hình

| Mã         | Màn hình                                                          | Figma node  | Thiết kế | Tham chiếu                     |
| ---------- | ----------------------------------------------------------------- | ----------- | -------- | ------------------------------ |
| **Chung**  |                                                                   |             |          |                                |
| SCR-PSG-01 | Trang chủ (form tìm chuyến)                                       | `373:588`   | Review   | FR-MKT-01                      |
| SCR-PSG-02 | Khám phá — cẩm nang & tin tức                                     | `384:3031`  | Review   | FR-MKT-14, UC-38               |
| SCR-PSG-37 | Chi tiết bài viết                                                 | —           | Draft    | FR-MKT-14, UC-38               |
| SCR-PSG-03 | Câu hỏi thường gặp                                                | `385:16931` | Review   | FR-ADM-13                      |
| SCR-PSG-04 | Dịch vụ bổ trợ (frame còn skeleton TODO)                          | `383:598`   | Review ⚠ | UX-OQ-07                       |
| SCR-PSG-05 | Trang lỗi 404 / 403 / 500 / 503                                   | —           | Draft    | §10, ADR-015                   |
| SCR-PSG-06 | Trang pháp lý: điều khoản, bảo mật, hoàn tiền (footer đã có link) | —           | Draft    | NĐ 13/2023                     |
| **Tài khoản & xác thực** |                                                     |             |          |                                |
| SCR-PSG-07 | Đăng nhập                                                         | `385:18278` | Review ⚠ | FR-IAM-02a, ADR-017/020        |
| SCR-PSG-08 | Tạo tài khoản                                                     | `385:18113` | Review ⚠ | FR-IAM-01, ADR-020             |
| SCR-PSG-09 | Nhập OTP email (đăng nhập / đăng ký / xác minh lại)               | —           | Draft    | ADR-020, FR-IAM-10             |
| SCR-PSG-10 | OAuth callback / liên kết tài khoản                               | —           | Draft    | ADR-020                        |
| SCR-PSG-11 | Tài khoản của tôi (hồ sơ, hành khách đã lưu, bảo mật)             | `385:14020` | Review ⚠ | FR-IAM-11, FR-MKT-13           |
| SCR-PSG-12 | Cài đặt thông báo (tab đã có, chưa có frame)                      | —           | Draft    | FR-NSR-14                      |
| SCR-PSG-13 | Phiên đăng nhập / thiết bị                                        | —           | Draft    | FR-IAM-15                      |
| SCR-PSG-14 | Đánh giá của tôi + form đánh giá chuyến                           | —           | Draft    | FR-NSR-10                      |
| **Tìm chuyến → đặt vé** |                                                      |             |          |                                |
| SCR-PSG-15 | Danh sách chuyến (kết quả tìm, lọc, sắp xếp)                      | `385:7387`  | Review   | FR-MKT-01..04                  |
| SCR-PSG-16 | Chi tiết chuyến                                                   | `385:5411`  | Review ⚠ | FR-MKT-05, ADR-027             |
| SCR-PSG-17 | Trang nhà xe (link "Xem trang nhà xe" đã có, chưa có frame)       | —           | Draft    | FR-MKT-06, FR-NSR-15           |
| SCR-PSG-18 | B1 — Chọn điểm đón/trả + ghế                                      | `385:4627`  | Review ⚠ | FR-MKT-07/09, FR-BTP-01..03    |
| SCR-PSG-19 | B2 — Thông tin hành khách                                         | `385:3716`  | Review ⚠ | FR-MKT-08/10/13, FR-PROM-10, UX-OQ-07      |
| SCR-PSG-20 | B3 — Thanh toán                                                   | `385:9097`  | Review ⚠ | FR-BTP-06/07, ADR-019          |
| SCR-PSG-21 | Chờ xác nhận thanh toán (quay về từ cổng)                         | —           | Draft    | FR-BTP-08/09                   |
| SCR-PSG-22 | B4 — Thanh toán thành công                                        | `385:8500`  | Review ⚠ | FR-BTP-10                      |
| SCR-PSG-23 | Thanh toán thất bại / hết hạn                                     | —           | Draft    | FR-BTP-09                      |
| **Vé**     |                                                                   |             |          |                                |
| SCR-PSG-24 | Vé của tôi                                                        | `385:9848`  | Review   | FR-MKT-11                      |
| SCR-PSG-25 | Chi tiết vé (+ QR)                                                | `385:10491` | Review ⚠ | FR-BTP-11, ADR-027             |
| SCR-PSG-26 | Hủy vé (modal xác nhận)                                           | `385:14793` | Review   | FR-BTP-12/13                   |
| **Tra cứu vé Guest** |                                                         |             |          |                                |
| SCR-PSG-27 | Tra cứu — B1 nhập SĐT / email                                     | `385:13572` | Review ⚠ | FR-MKT-12, UX-OQ-09            |
| SCR-PSG-28 | Tra cứu — B2 nhập OTP                                             | `385:13123` | Review   | FR-MKT-12                      |
| SCR-PSG-29 | Kết quả tra cứu                                                   | `385:12492` | Review   | FR-MKT-12                      |
| **Hỗ trợ / khiếu nại** |                                                       |             |          |                                |
| SCR-PSG-30 | Khiếu nại của tôi (danh sách + chi tiết + trao đổi)               | `385:17467` | Review   | FR-NSR-06/09                   |
| SCR-PSG-31 | Gửi khiếu nại (modal)                                             | `410:2`     | Review   | FR-NSR-06                      |
| SCR-PSG-32 | Khiếu nại của Guest (từ kết quả tra cứu)                          | —           | Draft    | FR-NSR-06 (Guest đã xác minh)  |
| **VXN Plus & ví voucher** |                                                     |             |          |                                |
| SCR-PSG-33 | VXN Plus — hạng thành viên                                        | `383:4`     | Review ⚠ | FR-LOY-03..04, UC-36                       |
| SCR-PSG-34 | Lịch sử điểm                                                      | `385:15629` | Review   | FR-LOY-05, UC-36                       |
| SCR-PSG-35 | Đổi điểm lấy mã giảm giá (modal)                                  | `385:16127` | Review   | FR-LOY-06..07, UC-37                       |
| SCR-PSG-36 | Ví voucher                                                        | —           | Draft    | FR-PROM-08..10, UC-37          |

> **Draft — chưa có trong Figma cho cả nhóm:** bản **responsive mobile web** của mọi màn trên (DoD Frontend, `CLAUDE.md §6.3`).
>
> **`apps/passenger_mobile`** (Flutter, ADR-028) — đã có khung ở trang `Mobile Ve_Xe`, bảng `1160:1854` (ghi nhận 14/10/2026): Splash, Đăng nhập, Xác nhận email, Hoàn thiện hồ sơ, Trang chủ (tìm theo tuyến / theo nhà xe), Kết quả tìm kiếm, Lọc chuyến, Chi tiết chuyến, Chọn chỗ, Chọn điểm đón / trả, Thông tin hành khách, Xác nhận booking, Thanh toán, Chọn ngân hàng, Vé của bạn. Chưa có trong bảng này: Vé của tôi, tra cứu vé Guest, chờ xác nhận / thất bại thanh toán, trạng thái rỗng / lỗi. Các khung chưa được đối chiếu với danh mục trên và với quyết định đã chốt.

### 6.2. Luồng chính

| Luồng               | Chuỗi màn hình (SCR-PSG-)                                                  | Ghi chú                                                                                                   |
| ------------------- | -------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| Đăng nhập / đăng ký | 07 hoặc 08 → 09 (OTP) hoặc 10 (OAuth) → quay lại trang trước               | Passenger không có mật khẩu (07 Security §5). Guest không cần đăng nhập để search/hold/book/pay/lookup     |
| Tìm → đặt → vé      | 01 → 15 → 16 → 18 → 19 → 20 → cổng thanh toán (Figma 26/10/2026: payOS VietQR hoặc cổng demo — chờ ADR thay ADR-019) → 21 → 22 hoặc 23 → 25 | Hold 10 phút tính từ 18 (ADR-015, OQ-06); tổng tiền tách dòng vé / phí / giảm giá (CO-12)                  |
| Hủy vé / hoàn tiền  | 24 hoặc 29 → 25 → 26 → 09 (xác minh lại) → 25 (theo dõi refund)            | Chính sách hủy = snapshot lúc đặt (FR-BTP-12)                                                              |
| Tra cứu vé Guest    | 27 → 28 → 29 → 25 → 26 hoặc 32                                             | Guest session sau OTP có thời hạn                                                                         |
| Hỗ trợ / đánh giá   | 25 hoặc 30 → 31 → 30; 24 → 14                                              | Đánh giá chỉ khi trip `COMPLETED` và vé hợp lệ                                                             |
| VXN Plus / ví voucher | 11 → 33 → 35 → 36; 33 → 34; 19 chọn voucher từ ví (36)                   | Chỉ User đăng nhập; tối đa một voucher / mã cho mỗi booking (BR-72); tổng tiền tách dòng giảm (CO-12)     |
| Khám phá            | 02 → 37                                                                    | Không cần đăng nhập; chỉ bài `PUBLISHED`                                                                  |

### 6.3. Trạng thái màn hình (5 Key UI States)

Mỗi màn hình là một bảng đủ 5 trạng thái theo §10.1. Cột **Thiết kế**: `Review` = đã có trong Figma · `Draft` = AI bổ sung, chưa có frame · `⚠ (#n)` = lệch thiết kế đã chốt, xem dòng #n ở §6.4 · `Chờ UX-OQ-NN` = phụ thuộc câu hỏi mở · `—` = không áp dụng. Tên trạng thái nghiệp vụ theo SRS §17.

#### SCR-PSG-01 — Trang chủ (`373:588`)

| Trạng thái     | Nội dung cần có                                                                                                             | Thiết kế       |
| -------------- | --------------------------------------------------------------------------------------------------------------------------- | -------------- |
| Ideal          | Form tìm chuyến (điểm đi, điểm đến, ngày, số khách); tab "Theo nhà xe"; khối ưu đãi, tuyến phổ biến, nhà xe đối tác, tin tức | Review ⚠ (#6) |
| Empty          | Chưa có tuyến phổ biến / nhà xe / bài viết → ẩn khối, form tìm chuyến vẫn dùng được                                          | Draft          |
| Loading        | Skeleton các khối nội dung; gợi ý địa điểm đang tải                                                                          | Draft          |
| Partial / Edge | Số lớn (12.840 đánh giá, 5.400+ chuyến — thống nhất dấu chấm, Figma đang lẫn "5,400+"); tên nhà xe / địa danh dài; chỉ 1–2 nhà xe; header đã đăng nhập | Review + Draft |
| Error          | Form invalid (thiếu điểm đi/đến, trùng điểm, ngày quá khứ); gợi ý địa điểm không có kết quả; lỗi tải khối (ẩn khối, không chặn tìm chuyến); offline | Draft          |

#### SCR-PSG-02 — Khám phá (`384:3031`)

| Trạng thái     | Nội dung cần có                                                         | Thiết kế |
| -------------- | ----------------------------------------------------------------------- | -------- |
| Ideal          | Bài nổi bật + danh sách bài; lọc chuyên mục (đếm số bài); tìm kiếm       | Review   |
| Empty          | Chuyên mục chưa có bài → gợi ý chuyên mục khác / FAQ                     | Draft    |
| Loading        | Skeleton thẻ bài                                                        | Draft    |
| Partial / Edge | Tiêu đề / mô tả dài (cắt chữ); lượt xem lớn; chỉ 1–2 bài                 | Review   |
| Error          | Tìm không có kết quả; lỗi tải (thử lại); bài không tồn tại (404)         | Draft    |

> Chi tiết bài viết: SCR-PSG-37.

#### SCR-PSG-03 — Câu hỏi thường gặp (`385:16931`)

| Trạng thái     | Nội dung cần có                                                            | Thiết kế |
| -------------- | -------------------------------------------------------------------------- | -------- |
| Ideal          | Ô tìm kiếm + gợi ý nhanh; danh mục (đếm số câu); danh sách câu hỏi; khối liên hệ CSKH | Review   |
| Empty          | Danh mục chưa có câu hỏi → CTA liên hệ CSKH                                 | Draft    |
| Loading        | Skeleton danh sách                                                         | Draft    |
| Partial / Edge | Câu hỏi mở rộng, câu trả lời dài; danh mục chỉ 1–2 câu                      | Draft    |
| Error          | Tìm không có kết quả → CTA liên hệ CSKH; lỗi tải (thử lại)                  | Draft    |

#### SCR-PSG-04 — Dịch vụ bổ trợ (`383:598`) · Chờ UX-OQ-07

| Trạng thái     | Nội dung cần có                 | Thiết kế        |
| -------------- | ------------------------------- | --------------- |
| Ideal          | Frame mới là skeleton TODO       | Review ⚠ (#8)   |
| Empty          | —                               | Chờ UX-OQ-07    |
| Loading        | —                               | Chờ UX-OQ-07    |
| Partial / Edge | —                               | Chờ UX-OQ-07    |
| Error          | —                               | Chờ UX-OQ-07    |

#### SCR-PSG-05 — Trang lỗi hệ thống (chưa có frame)

| Trạng thái     | Nội dung cần có                                                                                          | Thiết kế |
| -------------- | -------------------------------------------------------------------------------------------------------- | -------- |
| Ideal          | — (màn này là Error state dùng chung cho mọi màn)                                                        | —        |
| Empty          | —                                                                                                        | —        |
| Loading        | —                                                                                                        | —        |
| Partial / Edge | Bảo trì có giờ dự kiến; nút về trang trước / trang chủ                                                    | Draft    |
| Error          | 404 không tìm thấy; 403 không đủ quyền (không lộ dữ liệu bị chặn); 500; 503 "thử lại sau 30s" (ADR-015); offline | Draft    |

#### SCR-PSG-06 — Trang pháp lý (chưa có frame)

| Trạng thái     | Nội dung cần có                                         | Thiết kế |
| -------------- | ------------------------------------------------------- | -------- |
| Ideal          | Điều khoản / chính sách bảo mật / chính sách hoàn tiền + ngày hiệu lực | Draft    |
| Empty          | — (nội dung bắt buộc phải có)                           | —        |
| Loading        | Skeleton văn bản                                        | Draft    |
| Partial / Edge | Văn bản dài → mục lục neo                               | Draft    |
| Error          | Lỗi tải (thử lại)                                       | Draft    |

#### SCR-PSG-07 — Đăng nhập (`385:18278`)

| Trạng thái     | Nội dung cần có                                                                                                            | Thiết kế       |
| -------------- | -------------------------------------------------------------------------------------------------------------------------- | -------------- |
| Ideal          | Figma: email/SĐT + mật khẩu, ghi nhớ, quên mật khẩu, link tra cứu vé → đổi sang nhập email + gửi OTP + nút Google / Facebook / Apple | Review ⚠ (#1)  |
| Empty          | Form trống → CTA vô hiệu                                                                                                   | Draft          |
| Loading        | Đang gửi OTP / đang chuyển sang OAuth                                                                                      | Draft          |
| Partial / Edge | Email dài; quay lại trang trước sau đăng nhập; tài khoản bị khóa                                                           | Draft          |
| Error          | Email sai định dạng; gửi OTP quá giới hạn; lỗi mạng                                                                         | Draft          |

#### SCR-PSG-08 — Tạo tài khoản (`385:18113`)

| Trạng thái     | Nội dung cần có                                                                                                  | Thiết kế      |
| -------------- | ---------------------------------------------------------------------------------------------------------------- | ------------- |
| Ideal          | Figma: họ tên, email, SĐT, mật khẩu, xác nhận mật khẩu, đồng ý điều khoản → bỏ mật khẩu, xác minh bằng OTP email | Review ⚠ (#1) |
| Empty          | Form trống / chưa đồng ý điều khoản → CTA vô hiệu                                                                 | Draft         |
| Loading        | Đang tạo tài khoản / gửi OTP                                                                                     | Draft         |
| Partial / Edge | Họ tên dài; email đã tồn tại → gợi ý đăng nhập (UC A1)                                                           | Draft         |
| Error          | Lỗi tại field; lỗi mạng                                                                                          | Draft         |

#### SCR-PSG-09 — Nhập OTP email (chưa có frame; dùng lại mẫu SCR-PSG-28)

| Trạng thái     | Nội dung cần có                                   | Thiết kế |
| -------------- | ------------------------------------------------- | -------- |
| Ideal          | 6 ô OTP; đếm ngược hiệu lực; gửi lại; đổi email    | Draft    |
| Empty          | Chưa nhập đủ 6 số → CTA vô hiệu                    | Draft    |
| Loading        | Đang xác thực                                      | Draft    |
| Partial / Edge | Gửi lại có cooldown; dán mã từ clipboard; còn N lần thử | Draft    |
| Error          | Sai OTP; hết hạn; vượt số lần → khóa tạm; lỗi mạng | Draft    |

#### SCR-PSG-10 — OAuth callback / liên kết tài khoản (chưa có frame)

| Trạng thái     | Nội dung cần có                                                                              | Thiết kế |
| -------------- | -------------------------------------------------------------------------------------------- | -------- |
| Ideal          | Callback thành công → quay lại trang trước                                                   | Draft    |
| Empty          | —                                                                                            | —        |
| Loading        | Đang chuyển hướng / đang xác nhận với provider                                                | Draft    |
| Partial / Edge | Email trùng tài khoản Email-OTP → báo đã liên kết; provider không trả email (Apple ẩn email)  | Draft    |
| Error          | Người dùng hủy; provider lỗi; callback không hợp lệ → về SCR-PSG-07                           | Draft    |

#### SCR-PSG-11 — Tài khoản của tôi (`385:14020`)

| Trạng thái     | Nội dung cần có                                                                                                                     | Thiết kế            |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| Ideal          | Hồ sơ (họ tên, ngày sinh, giới tính, CCCD, email, SĐT); tiện ích tài khoản; khối bảo mật. Figma có đổi mật khẩu + 2FA (ngoài v1, #1); hạng thành viên và lối vào VXN Plus / Ví voucher / Lịch sử điểm (trong v1); tab Thanh toán "Sắp ra mắt" (ngoài v1) | Review ⚠ (#1)   |
| Empty          | Hành khách đã lưu 0/5 + CTA thêm; hồ sơ chưa điền hiện "—"                                                                          | Review              |
| Loading        | Skeleton hồ sơ; đang lưu                                                                                                            | Draft               |
| Partial / Edge | Danh sách đầy 5/5 (ẩn nút thêm); tên / email dài; sửa hồ sơ; đổi email cần OTP; thêm / sửa / xóa hành khách đã lưu                   | Draft               |
| Error          | Lỗi tại field khi sửa; lưu thất bại; lỗi tải                                                                                        | Draft               |

#### SCR-PSG-12 — Cài đặt thông báo (chưa có frame)

| Trạng thái     | Nội dung cần có                                                                                               | Thiết kế |
| -------------- | ------------------------------------------------------------------------------------------------------------- | -------- |
| Ideal          | Bảng loại thông báo × kênh đang bật (email, push)                                                              | Draft    |
| Empty          | — (luôn có danh mục loại thông báo)                                                                           | —        |
| Loading        | Đang tải / đang lưu                                                                                           | Draft    |
| Partial / Edge | Thông báo bắt buộc (bảo mật, vé, thanh toán, đổi/hủy chuyến, dispute) khóa, không tắt được (FR-NSR-14)          | Draft    |
| Error          | Lưu thất bại → giữ giá trị cũ                                                                                 | Draft    |

#### SCR-PSG-13 — Phiên đăng nhập / thiết bị (chưa có frame)

| Trạng thái     | Nội dung cần có                                                            | Thiết kế |
| -------------- | -------------------------------------------------------------------------- | -------- |
| Ideal          | Danh sách phiên, đánh dấu phiên hiện tại; thu hồi 1 phiên / tất cả phiên khác | Draft    |
| Empty          | Chỉ có phiên hiện tại                                                      | Draft    |
| Loading        | Đang tải / đang thu hồi                                                    | Draft    |
| Partial / Edge | Đạt giới hạn số phiên (FR-IAM-15); tên thiết bị dài                         | Draft    |
| Error          | Thu hồi thất bại; phiên hiện tại bị force logout → về đăng nhập             | Draft    |

#### SCR-PSG-14 — Đánh giá của tôi + form đánh giá (chưa có frame)

| Trạng thái     | Nội dung cần có                                                                    | Thiết kế |
| -------------- | ---------------------------------------------------------------------------------- | -------- |
| Ideal          | Danh sách đánh giá đã viết + chuyến chờ đánh giá; form đánh giá (sao + nội dung)    | Draft    |
| Empty          | Chưa có đánh giá → CTA về vé đã đi                                                  | Draft    |
| Loading        | Skeleton; đang gửi                                                                  | Draft    |
| Partial / Edge | Nội dung dài; đánh giá bị ẩn do kiểm duyệt; chuyến chưa `COMPLETED` → chưa cho đánh giá | Draft    |
| Error          | Gửi thất bại; lỗi tải                                                               | Draft    |

#### SCR-PSG-15 — Danh sách chuyến (`385:7387`)

| Trạng thái     | Nội dung cần có                                                                                                                                  | Thiết kế |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| Ideal          | Thanh tìm kiếm; lọc giá / giờ / loại xe / nhà xe / tiện ích; sắp xếp; thẻ chuyến (giờ, thời lượng, điểm dừng, giá, số chỗ còn)                    | Review   |
| Empty          | Không có chuyến nào đang mở bán → gợi ý tuyến phổ biến                                                                                           | Draft    |
| Loading        | Skeleton thẻ chuyến                                                                                                                              | Draft    |
| Partial / Edge | 1–2 chuyến; hàng trăm chuyến → phân trang / tải thêm; tên nhà xe / địa danh dài; sắp hết chỗ; chuyến qua đêm (đến ngày hôm sau); lọc điểm đón/trả + đánh giá, sắp xếp theo thời gian di chuyển (FR-MKT-03/04 — Figma thiếu); ảnh đại diện của xe trên thẻ chuyến (tải lười), xe chưa có ảnh hoặc ảnh lỗi tải → hình thay thế (FR-MKT-15 — Figma thiếu); lọc loại xe tách hai nhóm: dạng chỗ (ghế ngồi / giường nằm / cabin) và hạng (limousine) — BR-77, Figma đang gộp một nhóm "Loại xe"; ô điểm đi / điểm đến gợi ý tỉnh / thành và địa danh dùng chung (bến xe, điểm dừng đón trả), thẻ chuyến ghi điểm đón / trả khớp gần nhất — BR-80 | Draft    |
| Error          | Không tìm thấy chuyến theo tiêu chí → gợi ý đổi ngày / xóa lọc; ghế đã đổi khi bấm chọn (stale); lỗi tải; 503                                    | Draft    |

#### SCR-PSG-16 — Chi tiết chuyến (`385:5411`)

| Trạng thái     | Nội dung cần có                                                                                                                  | Thiết kế      |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| Ideal          | Tóm tắt chuyến + giá; nhà xe; lộ trình + điểm dừng; bản đồ; tiện nghi; chính sách; CTA đặt vé                                     | Review ⚠ (#4) |
| Empty          | Chưa có đánh giá                                                                                                                 | Review        |
| Loading        | Skeleton; bản đồ đang tải                                                                                                        | Draft         |
| Partial / Edge | Nhiều điểm dừng; địa chỉ dài; có đánh giá (danh sách + điểm trung bình); ngừng bán (hết giờ bán online / hết ghế / chuyến bị khóa → CTA vô hiệu); bộ ảnh xe trong khối "Thông tin xe" (tối đa 8, bấm để xem lớn), xe chưa có ảnh hoặc ảnh lỗi tải → hình thay thế (FR-MKT-15 — Figma thiếu); lịch trình ghi loại từng điểm dừng, văn phòng kèm nhãn "Trung chuyển miễn phí", trạm dừng nghỉ ghi "Dừng nghỉ" — BR-79 | Draft         |
| Error          | Chuyến không tồn tại / đã hủy (404); bản đồ lỗi tải (vẫn hiện danh sách điểm dừng); lỗi tải                                       | Draft         |

#### SCR-PSG-17 — Trang nhà xe (chưa có frame)

| Trạng thái     | Nội dung cần có                                                                  | Thiết kế |
| -------------- | -------------------------------------------------------------------------------- | -------- |
| Ideal          | Thông tin công khai (logo nhà xe nếu có — 27/10/2026); scorecard; tuyến tiêu biểu; đánh giá; điều khoản dịch vụ | Draft    |
| Empty          | Chưa có đánh giá / chưa có tuyến mở bán                                           | Draft    |
| Loading        | Skeleton                                                                         | Draft    |
| Partial / Edge | Tên nhà xe dài; số đánh giá lớn; scorecard chưa đủ dữ liệu                        | Draft    |
| Error          | Nhà xe không tồn tại / tạm ngừng hoạt động (404); lỗi tải                         | Draft    |

#### SCR-PSG-18 — B1 Chọn điểm đón/trả + ghế (`385:4627`)

| Trạng thái     | Nội dung cần có                                                                                                                    | Thiết kế      |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| Ideal          | Điểm đón/trả; sơ đồ ghế với chú thích Còn trống / Đang chọn / Đang giữ / Đã đặt; giới hạn "x/10 ghế"; tạm tính. Thiếu bộ đếm giữ ghế | Review ⚠ (#3) |
| Empty          | Chưa chọn ghế → CTA vô hiệu                                                                                                         | Draft         |
| Loading        | Đang tải sơ đồ ghế; đang tạo hold                                                                                                   | Draft         |
| Partial / Edge | Chỉ còn 1–2 ghế trống; ghế `BLOCKED`; xe 2 tầng; nhiều điểm đón/trả; đã chọn tối đa → khóa ghế còn lại; chỗ đôi (giường đôi / cabin đôi) vẽ khác chỗ đơn và ghi rõ "2 người" — BR-78, bán nguyên chỗ cho 1–2 hành khách, giá theo chỗ (`OQ-23`); danh sách điểm đón chỉ gồm điểm cho đón, điểm trả chỉ gồm điểm cho trả đứng sau điểm đón, không có trạm dừng nghỉ; văn phòng kèm nhãn trung chuyển (BR-23, BR-79) | Draft         |
| Error          | Ghế vừa bị giữ/bán → từ chối cả nhóm, chọn lại (UC A1); chuyến bị khóa / seat map đổi (A2); hold hết hạn → chọn lại (A4); 503 giữ ghế (A5, ADR-015) | Draft         |

#### SCR-PSG-19 — B2 Thông tin hành khách (`385:3716`)

| Trạng thái     | Nội dung cần có                                                                                                                     | Thiết kế          |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------- | ----------------- |
| Ideal          | Thông tin liên hệ; form hành khách theo ghế; chọn từ hành khách đã lưu; lưu hành khách (≤5); điểm đón/trả chỉ đọc; mã giảm giá; dịch vụ bổ trợ; tóm tắt. Thiếu bộ đếm giữ ghế | Review ⚠ (#3, #8) |
| Empty          | "Chưa có mã ưu đãi phù hợp cho chuyến này"                                                                                           | Review            |
| Loading        | Đang áp mã giảm giá; đang lưu                                                                                                        | Draft             |
| Partial / Edge | n ghế → n form hành khách; Guest (không có hành khách đã lưu); họ tên dài; mã hợp lệ → dòng giảm giá tách riêng (CO-12)               | Draft             |
| Error          | Lỗi tại field (SĐT, email, CCCD, ngày sinh); mã không hợp lệ / hết hạn / hết lượt / không áp cho chuyến; hold hết hạn                  | Draft             |

#### SCR-PSG-20 — B3 Thanh toán (`385:9097`)

| Trạng thái     | Nội dung cần có                                                                                                      | Thiết kế          |
| -------------- | -------------------------------------------------------------------------------------------------------------------- | ----------------- |
| Ideal          | Chọn phương thức (Figma 26/10/2026: chuyển khoản VietQR qua payOS / cổng thanh toán thử chỉ có trên bản demo — chờ ADR thay ADR-019); đồng ý điều khoản; bộ đếm giữ ghế; tóm tắt đơn tách dòng | Review ⚠ (#2, #3, #8) |
| Empty          | Chưa đồng ý điều khoản → CTA vô hiệu                                                                                  | Draft             |
| Loading        | Đang tạo payment + chuyển sang cổng                                                                                   | Draft             |
| Partial / Edge | Phương thức tạm không khả dụng (mẫu "Sắp hỗ trợ" đã có); tổng tiền lớn (nhiều ghế); bộ đếm < 1 phút → cảnh báo        | Review + Draft    |
| Error          | Giá/ghế đổi khi kiểm tra lại (FR-BTP-04) → xác nhận lại; hold hết hạn; cổng không phản hồi; booking đã thanh toán / đã hủy → chặn thanh toán lại (FR-BTP-07) | Draft             |

#### SCR-PSG-21 — Chờ xác nhận thanh toán (chưa có frame)

| Trạng thái     | Nội dung cần có                                                    | Thiết kế |
| -------------- | ------------------------------------------------------------------ | -------- |
| Ideal          | Có kết quả → chuyển SCR-PSG-22 (`SUCCESS`) hoặc SCR-PSG-23          | Draft    |
| Empty          | —                                                                  | —        |
| Loading        | `PROCESSING`: đang chờ cổng xác nhận, tự kiểm tra lại               | Draft    |
| Partial / Edge | `RECONCILING`: "đang đối soát, sẽ báo qua email"                    | Draft    |
| Error          | Quá thời gian chờ → hướng dẫn xem vé / tra cứu; lỗi mạng khi kiểm tra | Draft    |

#### SCR-PSG-22 — B4 Thanh toán thành công (`385:8500`)

| Trạng thái     | Nội dung cần có                                                                                                   | Thiết kế          |
| -------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------- |
| Ideal          | Thành công; mã đặt vé; vé điện tử; chi tiết đơn; xem QR / in vé / gửi lại email. Figma mẫu "Tiền mặt — Chưa thanh toán", có chữ "SMS" | Review ⚠ (#2, #5) |
| Empty          | —                                                                                                                 | —                 |
| Loading        | Đang phát hành vé (payment `SUCCESS`, ticket chưa sẵn sàng)                                                        | Draft             |
| Partial / Edge | Nhiều vé / nhiều hành khách; Guest → hướng dẫn tra cứu vé bằng email; gửi lại email quá giới hạn                   | Draft             |
| Error          | Gửi lại email thất bại; mở trực tiếp khi chưa thanh toán → chuyển SCR-PSG-20 / 23                                  | Draft             |

#### SCR-PSG-23 — Thanh toán thất bại / hết hạn (chưa có frame)

| Trạng thái     | Nội dung cần có                                              | Thiết kế |
| -------------- | ------------------------------------------------------------ | -------- |
| Ideal          | `FAILED` → thử lại (hold còn) / đổi phương thức               | Draft    |
| Empty          | —                                                            | —        |
| Loading        | Đang tạo lại payment                                         | Draft    |
| Partial / Edge | Người dùng hủy trên cổng (`CANCELLED`); hold chỉ còn ít phút  | Draft    |
| Error          | `EXPIRED` → ghế đã nhả, tìm lại chuyến                       | Draft    |

#### SCR-PSG-24 — Vé của tôi (`385:9848`)

| Trạng thái     | Nội dung cần có                                                                                                                      | Thiết kế       |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------ | -------------- |
| Ideal          | Tab Sắp tới / Đã đi / Đã hủy / Tất cả (đếm số); tìm mã vé / tuyến; thẻ chuyến gần nhất; thẻ vé `VALID` đã thanh toán                  | Review         |
| Empty          | Tab không có vé → CTA đặt vé mới / tra cứu vé khách                                                                                  | Draft          |
| Loading        | Skeleton thẻ vé                                                                                                                      | Draft          |
| Partial / Edge | 1–2 vé (Figma: 2 vé); hàng trăm vé → phân trang; nhãn `CHECKED_IN` / `USED` / `NO_SHOW` / `CANCELLED` / `REFUNDED`; chuyến bị nhà xe hủy/đổi → cần hành động (BR-12); booking `PENDING_PAYMENT` còn hold → tiếp tục thanh toán | Review + Draft |
| Error          | Tìm không có kết quả; lỗi tải (thử lại)                                                                                              | Draft          |

#### SCR-PSG-25 — Chi tiết vé (`385:10491`)

| Trạng thái     | Nội dung cần có                                                                                                                                                  | Thiết kế              |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| Ideal          | Vé `VALID` ("Đã xác nhận") + QR; hành trình; hành khách & thanh toán; quy định lên xe; liên hệ nhà xe; bản đồ điểm đón; in / chia sẻ / hủy. Thiếu chính sách hủy snapshot (FR-BTP-12) | Review ⚠ (#2, #4) + Draft |
| Empty          | —                                                                                                                                                                | —                     |
| Loading        | Skeleton vé                                                                                                                                                      | Draft                 |
| Partial / Edge | Vé `CHECKED_IN` / `USED` / `NO_SHOW` / `CANCELLED` / `REFUNDED` (ẩn/khóa QR khi hết hiệu lực); refund `REQUESTED` → `PROCESSING` → `SUCCESS` / `FAILED` / `REJECTED` + lý do; chuyến bị nhà xe hủy/đổi; hết hạn hủy → nút Hủy vô hiệu; booking nhiều vé | Draft                 |
| Error          | Vé không tồn tại hoặc không thuộc người xem → 404, không lộ dữ liệu; lỗi tải                                                                                      | Draft                 |

#### SCR-PSG-26 — Hủy vé (`385:14793`)

| Trạng thái     | Nội dung cần có                                                                                                                      | Thiết kế       |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------ | -------------- |
| Ideal          | Modal xác nhận (mã đặt vé, tuyến, khởi hành); lý do tùy chọn; lưu ý mức hoàn. Thiếu số tiền hoàn dự kiến + phí hủy theo policy snapshot (FR-BTP-12/13) | Review + Draft |
| Empty          | Lý do để trống vẫn cho hủy                                                                                                           | Review         |
| Loading        | Đang tính tiền hoàn; đang hủy                                                                                                        | Draft          |
| Partial / Edge | Hủy một phần vé trong booking nhiều vé (`PARTIALLY_CANCELLED`); xác minh lại OTP (FR-IAM-10); hủy thành công → refund `REQUESTED`     | Draft          |
| Error          | Không đủ điều kiện (quá hạn / đã check-in) + lý do; hủy thất bại                                                                      | Draft          |

#### SCR-PSG-27 — Tra cứu vé B1 (`385:13572`)

| Trạng thái     | Nội dung cần có                                                              | Thiết kế            |
| -------------- | ---------------------------------------------------------------------------- | ------------------- |
| Ideal          | Email (bắt buộc) + mã đặt vé / mã vé (không bắt buộc — chờ duyệt 27/10/2026); gửi OTP; khối giới thiệu tra cứu; dòng "Không còn dùng email đặt vé? Gọi CSKH" | Review ⚠ (#5, UX-OQ-09) |
| Empty          | Chưa nhập → CTA vô hiệu                                                      | Draft               |
| Loading        | Đang gửi OTP                                                                 | Draft               |
| Partial / Edge | Email dài; phản hồi trung tính (không tiết lộ contact có vé hay không)        | Draft               |
| Error          | SĐT / email sai định dạng; gửi quá giới hạn; lỗi mạng                         | Draft               |

#### SCR-PSG-28 — Tra cứu vé B2 — OTP (`385:13123`)

| Trạng thái     | Nội dung cần có                                  | Thiết kế |
| -------------- | ------------------------------------------------ | -------- |
| Ideal          | 6 ô OTP; đếm ngược 5 phút; gửi lại; đổi SĐT        | Review   |
| Empty          | Chưa nhập đủ 6 số → CTA vô hiệu                   | Draft    |
| Loading        | Đang xác thực                                     | Draft    |
| Partial / Edge | Gửi lại có cooldown; còn N lần thử                | Draft    |
| Error          | Sai OTP; hết hạn; vượt số lần → khóa tạm          | Draft    |

#### SCR-PSG-29 — Kết quả tra cứu (`385:12492`)

| Trạng thái     | Nội dung cần có                                                                                                        | Thiết kế       |
| -------------- | ---------------------------------------------------------------------------------------------------------------------- | -------------- |
| Ideal          | Xác thực thành công; có mã đặt vé → thẳng một đơn (Figma 1446:15578); không mã → danh sách đơn của email 12 tháng (tab theo trạng thái có đếm số, tìm mã / tuyến, nhãn "Đặt bằng tài khoản" — chưa có Figma, chờ duyệt 27/10/2026) → chọn đơn; email có tài khoản / đơn đặt bằng tài khoản → hộp thoại "Bạn có muốn đăng nhập không?" một lần mỗi phiên trình duyệt; thẻ vé; xem QR / hủy vé | Review         |
| Empty          | Không có vé gắn với contact → CTA đặt vé                                                                               | Draft          |
| Loading        | Skeleton                                                                                                               | Draft          |
| Partial / Edge | Thiếu dữ liệu (giờ đến "--:--", tên nhà xe mặc định — Figma đã có); nhãn trạng thái vé như SCR-PSG-24; header phải ở trạng thái Guest (Figma đang hiện header đã đăng nhập) | Review + Draft |
| Error          | Phiên tra cứu hết hạn → về B1; tìm không có kết quả                                                                    | Draft          |

#### SCR-PSG-30 — Khiếu nại của tôi (`385:17467`)

| Trạng thái     | Nội dung cần có                                                                                                                    | Thiết kế       |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| Ideal          | Danh sách khiếu nại; chi tiết (danh mục, mức độ, nội dung); dòng thời gian xử lý; ô phản hồi                                        | Review         |
| Empty          | Chưa có khiếu nại → CTA gửi khiếu nại                                                                                              | Draft          |
| Loading        | Skeleton danh sách / chi tiết                                                                                                      | Draft          |
| Partial / Edge | 1 khiếu nại (Figma); nội dung dài; `TRIAGED` / `WAITING_USER` (nổi bật yêu cầu bổ sung) / `WAITING_OPERATOR` / `IN_PROGRESS` / `ESCALATED_TO_DISPUTE` / `RESOLVED` / `CLOSED` (khóa phản hồi); phản hồi kèm tệp | Review + Draft |
| Error          | Gửi phản hồi thất bại; lỗi tải                                                                                                     | Draft          |

#### SCR-PSG-31 — Gửi khiếu nại (`410:2`)

| Trạng thái     | Nội dung cần có                                                                                               | Thiết kế       |
| -------------- | ------------------------------------------------------------------------------------------------------------- | -------------- |
| Ideal          | Danh mục; mức độ; tiêu đề (≤200); mô tả (≤2000); đính kèm (ảnh/PDF/Word ≤5MB). Thiếu chọn booking/vé liên quan (FR-NSR-06) | Review + Draft |
| Empty          | Form trống, bộ đếm 0/200 và 0/2000                                                                            | Review         |
| Loading        | Đang tải tệp; đang gửi                                                                                        | Draft          |
| Partial / Edge | Chạm giới hạn ký tự; nhiều tệp; mức độ do khách chọn chỉ là gợi ý, Admin phân loại (`TRIAGED`)                 | Draft          |
| Error          | Lỗi tại field; tệp quá dung lượng / sai định dạng / tải lỗi; gửi thất bại                                      | Draft          |

#### SCR-PSG-32 — Khiếu nại của Guest (chưa có frame)

| Trạng thái     | Nội dung cần có                                         | Thiết kế |
| -------------- | ------------------------------------------------------- | -------- |
| Ideal          | Như SCR-PSG-30/31, giới hạn trong vé đã tra cứu         | Draft    |
| Empty          | Chưa có khiếu nại → CTA gửi khiếu nại                    | Draft    |
| Loading        | Như SCR-PSG-30                                          | Draft    |
| Partial / Edge | Như SCR-PSG-30                                          | Draft    |
| Error          | Phiên tra cứu hết hạn → xác minh lại OTP                 | Draft    |

#### SCR-PSG-33 — VXN Plus (`383:4`)

| Trạng thái     | Nội dung cần có                                                                                                                                          | Thiết kế      |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| Ideal          | Hạng hiện tại; điểm khả dụng + giá trị quy đổi ước tính; số điểm cần để lên hạng kế tiếp; bảng 4 hạng (mốc điểm 12 tháng, hệ số tích điểm); CTA đổi điểm, xem lịch sử | Review ⚠ (#7) |
| Empty          | User mới: Bronze, 0 điểm → giải thích cách tích điểm (sau mỗi chuyến hoàn thành) + CTA tìm chuyến                                                       | Draft         |
| Loading        | Skeleton thẻ hạng và bảng hạng                                                                                                                           | Draft         |
| Partial / Edge | Hạng cao nhất (ẩn "cần X điểm để lên hạng"); số điểm lớn (1.000.000+); có điểm sắp hết hạn (nhắc số điểm + ngày); vừa đổi hạng                          | Draft         |
| Error          | Lỗi tải (thử lại); chưa đăng nhập / phiên hết hạn → SCR-PSG-07                                                                                          | Draft         |

#### SCR-PSG-34 — Lịch sử điểm (`385:15629`)

| Trạng thái     | Nội dung cần có                                                                                                                                  | Thiết kế |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| Ideal          | 4 thẻ tổng (hiện có / đã tích / đã đổi / hết hạn); tab Tất cả / Tích điểm / Đổi điểm / Hết hạn; mỗi dòng: loại, số điểm (+/−), booking hoặc voucher nguồn, ngày; lọc thời gian | Draft    |
| Empty          | "Bạn chưa có giao dịch điểm nào" + CTA tìm chuyến / về VXN Plus                                                                                  | Review   |
| Loading        | Skeleton danh sách                                                                                                                               | Draft    |
| Partial / Edge | Danh sách dài (phân trang); dòng điều chỉnh / thu hồi hiển thị lý do; tab không có dòng nào                                                     | Draft    |
| Error          | Lỗi tải (thử lại); lọc không có kết quả                                                                                                          | Draft    |

#### SCR-PSG-35 — Đổi điểm lấy mã giảm giá (`385:16127`)

| Trạng thái     | Nội dung cần có                                                                                                                         | Thiết kế |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| Ideal          | Modal: quy đổi và số điểm tối thiểu (theo policy); điểm hiện tại; số điểm muốn đổi (nhập + thanh trượt + chọn nhanh); giảm giá nhận được; điểm còn lại; lưu ý hạn voucher, áp mọi tuyến, không hoàn điểm | Review   |
| Empty          | Điểm dưới mức tối thiểu → nút xác nhận vô hiệu + giải thích số điểm còn thiếu                                                           | Draft    |
| Loading        | Đang đổi điểm: khóa nút, chống bấm lặp (cùng `Idempotency-Key`)                                                                         | Draft    |
| Partial / Edge | Chọn "Tất cả"; nhập vượt số dư hoặc dưới tối thiểu → báo tại field; đổi thành công → thông báo + link sang ví voucher (SCR-PSG-36)       | Draft    |
| Error          | `LOYALTY_INSUFFICIENT_POINTS` / `LOYALTY_BELOW_MIN_REDEEM` / lỗi mạng → giữ modal, không trừ điểm, cho thử lại                         | Draft    |

#### SCR-PSG-36 — Ví voucher (chưa có frame)

| Trạng thái     | Nội dung cần có                                                                                                                  | Thiết kế |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------- | -------- |
| Ideal          | Tab Khả dụng / Đã dùng / Hết hạn; mỗi voucher: nguồn (đổi điểm / mã đã lưu), giá trị, điều kiện, hạn dùng, trạng thái; ô nhập mã để lưu | Draft    |
| Empty          | Chưa có voucher → CTA đổi điểm (SCR-PSG-35) hoặc nhập mã khuyến mãi                                                              | Draft    |
| Loading        | Skeleton thẻ voucher                                                                                                             | Draft    |
| Partial / Edge | Voucher đang giữ cho booking chờ thanh toán (hiện mã booking); sắp hết hạn; promotion gốc đã dừng; mã dài                         | Draft    |
| Error          | `VOUCHER_ALREADY_SAVED`, mã không tồn tại / hết hạn → báo tại field; lỗi tải (thử lại)                                          | Draft    |

> Ở B2 (SCR-PSG-19), User đã đăng nhập chọn voucher từ ví hoặc nhập mã — **tối đa một** (BR-72); Guest chỉ nhập mã. Tổng tiền tách dòng giảm giá (CO-12).

#### SCR-PSG-37 — Chi tiết bài viết (chưa có frame)

| Trạng thái     | Nội dung cần có                                                                 | Thiết kế |
| -------------- | ------------------------------------------------------------------------------- | -------- |
| Ideal          | Tiêu đề, chuyên mục, ngày xuất bản, ảnh bìa, nội dung, bài liên quan cùng chuyên mục | Draft    |
| Empty          | — (bài luôn có nội dung khi `PUBLISHED`)                                        | —        |
| Loading        | Skeleton tiêu đề + nội dung                                                     | Draft    |
| Partial / Edge | Bài rất dài; tiêu đề dài; ảnh lỗi → placeholder; không có bài liên quan (ẩn khối) | Draft    |
| Error          | Slug không tồn tại / bài đã gỡ → 404 (SCR-PSG-05); lỗi tải (thử lại)             | Draft    |

### 6.4. Lệch giữa Figma và thiết kế đã chốt

| #   | Màn hình (SCR-PSG-) | Figma hiện tại                                                                                                              | Nguồn đã chốt                                                                                                     | Đề xuất                                                                                                                                         |
| --- | ------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | 07, 08, 11          | Đăng ký/đăng nhập bằng email/SĐT + mật khẩu; quên / đổi mật khẩu; 2FA                                                       | 07 Security §5 + ADR-017/020: Passenger = Email OTP + OAuth Google/Facebook/Apple, không có mật khẩu; TOTP post-v1 | Sửa Figma theo Email OTP + OAuth, bỏ mật khẩu / 2FA. SRS đã đồng bộ ở v1.25 (`FR-IAM-01..03a`, `UC-01`)                      |
| 2   | 20, 22, 25          | 6 phương thức: MoMo (sắp hỗ trợ), VNPay, ZaloPay (sắp hỗ trợ), Visa/Master, ATM, Tiền mặt; màn thành công mẫu "Tiền mặt — Chưa thanh toán" | ADR-019: v1 chỉ VNPay + MoMo (ZaloPay không có trong ADR; VietQR defer v1.x). OQ-07: v1 thanh toán trước, không mở trả sau cho passenger | Giữ VNPay (QR / ATM / thẻ quốc tế là lựa chọn con trong VNPay) + bật MoMo; bỏ ZaloPay + Tiền mặt; màn thành công dùng mẫu thanh toán online      |
| 3   | 18, 19, 20          | Bộ đếm "Giữ ghế trong 14:56" (~15 phút), chỉ hiện từ bước thanh toán                                                        | ADR-015 / OQ-06: hold 10 phút (`EX 600`); SRS UC giữ ghế: hiện bộ đếm ngay khi giữ ghế                             | Đổi 10:00; hiện bộ đếm từ B1 sau khi hold thành công                                                                                            |
| 4   | 16, 25              | Bản đồ Leaflet + © OpenStreetMap                                                                                            | ADR-027: Goong Maps (hiển thị đúng Hoàng Sa / Trường Sa)                                                           | Thay bằng Goong                                                                                                                                 |
| 5   | 22, 27, 28          | "Vé gửi qua email & SMS"; tra cứu / OTP qua SMS                                                                             | ADR-020: SMS defer v1                                                                                             | Copy chỉ nói email; tra cứu theo UX-OQ-09                                                                                                       |
| 6   | 01, footer          | Copy "Hoàn 90% trước 24h", "Đổi chuyến miễn phí trước 24h", link "Đổi và hủy vé"                                            | FR-BTP-12: hoàn theo chính sách snapshot của từng chuyến; SRS không có đổi vé tự phục vụ (chỉ trong luồng chuyến bị hủy / dispute) | Sửa copy trung tính ("theo chính sách nhà xe"). Muốn có đổi vé tự phục vụ = mở rộng phạm vi, cần Khanh quyết                                     |
| 7   | 33                  | Khối "Ưu đãi hạng": giảm 5 / 10 / 15% mọi chuyến theo hạng, "Hỗ trợ ưu tiên 30 phút"; cột "Giảm giá" trong bảng hạng        | SRS v1.21 `BR-68`: hạng v1 chỉ ảnh hưởng hệ số tích điểm, không giảm giá / ưu tiên CSKH                            | Bỏ khối ưu đãi giảm giá / ưu tiên CSKH và cột "Giảm giá"; giữ hệ số điểm                                                                          |
| 8   | 04, 19, 20          | Dịch vụ bổ trợ (bảo hiểm, hành lý, đưa đón) cộng vào tổng tiền                                                              | Không có trong SRS                                                                                                | UX-OQ-07                                                                                                                                        |
| 9   | 15, 16              | Thẻ chuyến và khối "Thông tin xe" chưa có ảnh xe | SRS v1.32 `FR-MKT-15`, `BR-76` | Thêm ảnh đại diện của xe vào thẻ chuyến và bộ ảnh vào khối "Thông tin xe"; có hình thay thế khi xe chưa có ảnh |
| 10  | 15                  | Bộ lọc "Loại xe" là một nhóm duy nhất, limousine đứng ngang hàng với các dạng xe khác | SRS v1.33 `BR-77` | Tách hai nhóm lọc: dạng chỗ (ghế ngồi / giường nằm / cabin) và hạng xe (limousine) |

---

## 7. Flow Operator

Login `{operatorSlug}/{username}` + password qua `/auth/operator/login` — **chỉ Owner**; Owner bắt buộc TOTP (ADR-017). Employee không đăng nhập Operator OS (ADR-017 amend 28/09/2026). Chỉ render shell Operator OS sau khi `/auth/me` trả scope `operator` và role `OPERATOR_OWNER`; sai scope/role thì logout và về trang login với thông báo chung về phiên, không nhắc app Nhân viên (lớp phòng thủ thứ hai, API đã chặn Employee ở cổng). Trước mọi màn nghiệp vụ, Operator OS chạy state machine: lấy CSRF → bootstrap `/auth/me`; 401 thì refresh single-flight một lần rồi retry; không refresh được thì về login. First login: mật khẩu tạm → đổi bắt buộc → login lại → TOTP enrollment/verify → hiển thị 10 backup code đúng một lần → vào app. Challenge chỉ giữ trong memory; reload giữa flow thì bắt đầu lại từ login.

| Trạng thái auth | UI bắt buộc |
| --------------- | ----------- |
| Loading/bootstrap | Full-page loading, chưa render sidebar/dữ liệu bảo vệ |
| Login | Identifier `{slug}/{username}`, password; lỗi generic không lộ account tồn tại. Username nhân viên (`nv.…`) **không** có xử lý riêng ở FE: gửi lên API như mọi tài khoản và nhận cùng lỗi generic `AUTH_INVALID_CREDENTIALS` ("Tên đăng nhập hoặc mật khẩu không đúng"); không hiển thị hướng dẫn chuyển sang app Nhân viên (Khanh chốt 02/10/2026) |
| Password change | Mật khẩu mới + xác nhận; thành công quay lại login, không tự vào app |
| MFA | QR/secret enrollment khi cần, TOTP hoặc backup code; backup code chỉ hiện một lần |
| Session expired/error | Thử refresh đúng một lần; thất bại clear state và về login; giữ safe return URL nội bộ |

| Flow            | Màn hình chính                                                           | Ghi chú                                                      |
| --------------- | ------------------------------------------------------------------------ | ------------------------------------------------------------ |
| Đăng ký nhà xe (trang công khai, không đăng nhập) | Form bước 1 (tên nhà xe, người liên hệ, email) → màn "Kiểm tra email"; mở link → form hồ sơ, upload KYC (R2 private), tài khoản nhận tiền, gửi duyệt; trang trạng thái qua link; form gửi lại link (email + mã hồ sơ) | Link hết hạn / bị thay → hướng dẫn gửi lại. Duyệt xong nhận email tài khoản Owner `{slug}/{username}` + mật khẩu tạm → đăng nhập, đổi mật khẩu, bật TOTP (BR-75). `TASK-OPR-001`: trang `/register`, `/register/resend`, `/register/application` trong Operator OS (Figma `1669:29021` … `1669:29595`); màn đăng nhập có khối "Trở thành đối tác" dẫn sang `/register`; giấy tờ "chưa lưu" tới khi bấm Lưu nháp / Gửi duyệt; cột Tiến độ hồ sơ tính ngay trên form, còn thiếu thì khóa Gửi duyệt; token của link nằm sau `#` và bị xóa khỏi thanh địa chỉ. Figma 07 / 08 chưa dùng (BR-75 thu hồi link khi có kết quả) |
| Vehicle/SeatMap | Vehicle list (kèm ảnh đại diện), vehicle form (chọn loại xe — mỗi lựa chọn hiện dạng chỗ + hạng xe; khối ảnh xe: tải lên tối đa 8, kéo thả sắp xếp (hoặc phím mũi tên trên nút đổi chỗ), đặt chú thích ngắn, xóa; ảnh đầu là ảnh đại diện; ảnh nén ở trình duyệt trước khi tải lên; ảnh chọn ở form được lưu cùng nút "Lưu phương tiện" — ảnh tải lỗi giữ ô "Tải ảnh thất bại" với nút "Thử lại", ảnh khác vẫn được lưu, kể cả khi vừa tạo xe (Figma 08) — `TASK-TRN-009`), seat map editor (theo tầng, mỗi tầng có số hàng / cột riêng; chỗ đôi là một ô lưới vẽ rộng hơn; mỗi ô chọn loại chỗ: ghế / giường đơn / giường đôi / cabin đơn / cabin đôi; hiện tổng số chỗ và sức chứa) | Không sửa tùy tiện khi đã gắn trip có vé; ảnh sai loại / quá 5 MB / quá 8 ảnh báo lỗi tại chỗ (BR-76); ô chọn sơ đồ khóa sẵn khi `seatMapLocked`, trình soạn chỉ đọc khi sơ đồ `inUse` và gợi ý tạo bản sao (TRN-011) |
| Route/StopPoint | Route list, route form (mỗi điểm dừng chọn cho đón / cho trả theo BR-79), màn **Điểm dừng** (mô tả bên dưới) | Bến xe / điểm dừng đón trả mới cần Admin duyệt; văn phòng trung chuyển và trạm dừng nghỉ dùng ngay; cảnh báo khi hai đầu tuyến không phải bến xe |
| Trip/Fare       | Trip calendar/list, trip form, fare form, open/lock sale                 | Thay đổi trip đã bán vé cần lý do + audit. Bảng giá (chờ duyệt — `ADM-001-policy-todo.md`): dải cảnh báo khung giá (Figma `1665:24475`) + từng khung đang bị vượt; dòng quy tắc ngoài khung có biểu tượng cảnh báo; không chặn lưu |
| Hồ sơ & KYC     | Hồ sơ doanh nghiệp (+ Chỉnh sửa; logo: Tải logo / Đổi logo / Gỡ logo có xác nhận), Giấy tờ KYC (Xem / Tải bản mới), Trạng thái hoạt động, Tài khoản nhận tiền (+ Đổi tài khoản: ngân hàng, số TK, chủ TK viết hoa không dấu, lý do, mật khẩu / mã xác thực), Trang công khai | `TASK-OPR-001b` (chờ duyệt — `OPR-001b-todo.md`): theo Figma `1667:27240`, `1667:27586`; đổi tài khoản thành yêu cầu chờ Admin xác minh, báo đang chờ / bị từ chối; chưa có dải cảnh báo kỳ chi trả. **27/10/2026 (tự thiết kế, chờ duyệt — chưa có frame Figma cho phần này):** logo thu nhỏ còn 512 px (PNG) trước khi tải, chữ viết tắt khi chưa có logo; thẻ Trang công khai: "Mở trang nhà xe" mở tab mới tới `/operators/{id}` của web khách hàng (`NEXT_PUBLIC_MARKETPLACE_URL`), "Xem trước trên ứng dụng" mở khung điện thoại mô phỏng màn nhà xe của app hành khách bằng dữ liệu `public-profile`; nhà xe tạm khóa → hai nút tắt kèm lý do |
| Lịch chạy lặp lại | Nút "Lịch chạy lặp lại" ở đầu trang Chuyến xe → danh sách lịch (tuyến, giờ chạy, thứ chạy, khoảng áp dụng, xe, số chuyến đã sinh, Đang áp dụng / Sắp áp dụng / Đã hết hạn); form quy tắc + thẻ "Ngày có chuyến" + khối "Sinh chuyến" (mở bán ngay chuyến đủ điều kiện; kết quả từng ngày) | `TASK-TRN-007` (chờ duyệt — `TRN-007-todo.md`): **chưa có khung Figma**, dựng theo bộ kit màn Chuyến xe |
| Phân công chuyến | Nút "Phân công chuyến" ở đầu trang Nhân viên → lọc ngày / tuyến / tình trạng; bảng Khởi hành · Tuyến · Xe · Tài xế (chọn là lưu) · Tình trạng (Đã phân công / Chưa phân công / Trùng lịch); lỗi trùng giờ dưới ô; hộp thoại lý do khi chuyến sắp chạy | `TASK-EMP-001` phía Operator OS (chờ duyệt — `EMP-001-todo.md`): theo Figma `1666:26082`; mô tả trang không hứa thông báo (chờ NSR-001) |
| Booking/Ticket  | Booking list, passenger list, export                                     | Mask dữ liệu cá nhân (`0*** *** 789`) theo quyền             |
| Employee        | Employee list, role, assignment                                          | Role: TICKET_STAFF, DRIVER, SUPPORT_STAFF; Owner cấp account. Ô username hiển thị tiền tố cố định `nv.`, Owner nhập phần sau (2–61 ký tự `a-z 0-9 . _ -`) |
| Tài khoản quản lý (chờ duyệt — `TASK-IAM-007`) | Mục "Tài khoản quản lý" (chỉ Owner): danh sách (quyền, 2FA, trạng thái, đăng nhập gần nhất), thêm tài khoản (tên đăng nhập `{mã nhà xe}/…`, email, tick quyền theo nhóm + mẫu Điều hành / Bán vé & CSKH / Kế toán), Phân quyền, cấp lại mật khẩu, đặt lại 2FA, khóa / mở | Mọi thao tác: lý do + xác nhận lại danh tính. Tài khoản quản lý chỉ thấy mục menu được cấp; vào thẳng URL mục khác → "chưa được cấp quyền". Admin: tab Tài khoản quản trị thêm cột Quyền + hộp thoại Phân quyền; menu Admin ẩn theo quyền. Figma chưa có khung |
| Finance         | Escrow balance, commission, payout history, reconciliation               | Dữ liệu chỉ thuộc Operator (tenant + RLS)                    |
| Khung màn chờ đặt vé | Đặt vé, Khuyến mãi, Tài chính, Báo cáo, Hỗ trợ — thẻ số "—", tiêu đề cột + tab theo Figma, trạng thái trống ghi rõ chờ task nào | Khanh 16/10/2026 "Dựng khung giao diện trước" (`ADM-system-shells-todo.md`): **không số liệu mẫu**; dùng chung `PlannedScreen` |

**Trình soạn sơ đồ ghế — lưới tự do** (đóng `UX-OQ-03`, Khanh chốt 04/10/2026; v1 không có mẫu theo loại xe):

- Nhà xe nhập số tầng (1 hoặc 2), số hàng (1–30) và số cột (1–10) cho từng tầng, rồi bấm "Tạo lưới".
- Lưới sinh ra với mọi ô là loại chỗ đang chọn; mã tự đánh theo thứ tự — tầng 1 là `A01`, `A02`…, tầng 2 là `B01`, `B02`…
- Bấm từng ô để đổi loại chỗ (`BR-78`), sửa mã hoặc chuyển thành ô trống làm lối đi. Chỗ đôi là một ô lưới, vẽ rộng hơn chỗ đơn.
- Bấm "Tạo lưới" lần nữa sẽ thay toàn bộ chỉnh sửa chưa lưu, nên phải hỏi xác nhận trước.
- Bố cục không bị ràng buộc theo loại xe; toàn bộ sơ đồ tối đa 100 chỗ. Muốn dùng lại một bố cục thì tạo bản sao từ sơ đồ có sẵn.
- Một trình soạn dùng cho bốn chế độ (Khanh chốt 05/10/2026): tạo mới, chỉnh sửa, tạo bản sao (lưu thành sơ đồ mới, yêu cầu tên mới) và xem chỉ đọc khi sơ đồ đang được chuyến dùng (`inUse`) — chế độ xem khóa mọi ô, chỉ còn "Tạo bản sao".
- "Loại chỗ ban đầu" có ở mọi chế độ sửa được và là loại gán cho mọi ô khi tạo / tạo lại lưới. Danh sách "Loại ô" là lối bấm nhanh để đổi loại cho ô đang chọn, đồng bộ với ô "Loại chỗ" của ô đó; chọn một loại cho ô trống thì tạo chỗ mới với mã còn trống kế tiếp của tầng.
- Số tầng / kích thước vừa đổi chỉ có hiệu lực khi bấm "Tạo lại lưới"; lưu thì gửi đúng lưới đang hiển thị. Mỗi tầng phải có ít nhất một chỗ, nếu không thì nhắc giảm số tầng.
- Lưu từ danh sách thì về danh sách; mở từ form phương tiện thì báo trước rằng thông tin xe chưa lưu sẽ mất, lưu xong quay lại form với sơ đồ mới được chọn sẵn.
- "Bố cục gợi ý" điền sẵn lưới (giường nằm 40, cabin đơn 34, cabin đôi 22…) là phần tùy chọn, để sau v1.

**Màn Điểm dừng của nhà xe** (thiết kế lại, Khanh chốt 04/10/2026; mục riêng trên thanh bên, đứng trước "Tuyến đường"; thiết kế: Figma `1305:6710`, nhóm `Nhà xe · Điểm dừng · TRN-013`; hai khung cũ `386:19771`, `386:18417` không còn dùng):

- Hai tab: **Của nhà xe** (văn phòng trung chuyển, trạm dừng nghỉ — thêm, sửa, ngừng dùng) và **Dùng chung** (bến xe, điểm dừng đón trả khách, trạm dừng nghỉ của Platform — chỉ xem).
- Bảng: tên và địa chỉ, loại điểm, tỉnh / thành, số tuyến đang dùng, trạng thái (Hoạt động / Ngừng dùng / Bị khóa kèm lý do của Admin), nút sửa. Cột "số tuyến đang dùng" chỉ có ở tab Của nhà xe (Khanh chốt 05/10/2026). Tab Dùng chung chỉ xem nên không có nút sửa; API danh mục chỉ trả điểm đang hoạt động nên tab này cũng không có cột và lọc trạng thái. Ô tìm theo tên / địa chỉ, gõ không dấu vẫn ra ("ben xe" ra "Bến xe…"); lọc loại điểm, tỉnh / thành, trạng thái; "Tải thêm" thay cho số trang.
- Hộp thoại thêm / sửa: tên, loại điểm, địa chỉ, tỉnh / thành và phường / xã (ô chọn từ danh mục), vĩ độ, kinh độ, trạng thái đều bắt buộc; ghi chú tùy chọn. Bản đồ Goong để bấm hoặc kéo ghim lấy tọa độ, vẫn cho gõ tay (`TASK-TRN-014`).
- Tab Dùng chung có nút "Đề xuất điểm dừng" (Khanh chốt 07/10/2026; không nhắc việc nhà xe khác dùng được) cho bến xe / điểm dừng đón trả khách còn thiếu: các ô như trên cộng "căn cứ công bố" (bắt buộc). Danh sách đề xuất của nhà xe hiện trạng thái Chờ duyệt / Đã duyệt / Bị từ chối kèm lý do; bản bị từ chối sửa và gửi lại được.
- Bỏ so với Figma cũ: cột mã, khối thống kê, cột lượt / ngày, nút xoá.
- Bản đồ thuộc V1 (Khanh chốt 07/10/2026), làm ở `TASK-TRN-014`: khối "Bản đồ điểm dừng" đóng mở được nằm trên bảng, hiện các điểm đang có trong danh sách với màu ghim theo loại, bấm ghim xem nhanh, bấm một dòng thì bản đồ chuyển tới điểm đó; mặc định thu gọn và nhớ lựa chọn gần nhất (giả định). Khi chưa có bản đồ thì ẩn khối này và nhập tọa độ bằng tay.
- Hiện thực bản đồ (`TASK-TRN-014`, 07/10/2026): bản đồ nền Goong, không có nguồn dự phòng — môi trường chưa đặt khóa Maptiles thì ẩn mọi khối bản đồ; tải lỗi thì hiện "Không tải được bản đồ" kèm nút Thử lại, bảng và form vẫn dùng được. Khung nhìn mặc định là toàn Việt Nam, gồm Hoàng Sa và Trường Sa. Bấm ghim thì giữ mức phóng đang xem; bấm một dòng thì phóng tới gần và tô nền dòng đó; khi bản đồ mở, tên điểm là một nút để dùng được bằng bàn phím. Bản đồ nằm trong trang cuộn phải giữ Ctrl mới phóng to bằng con lăn. Trong hộp thoại: tọa độ lấy từ bản đồ làm tròn 6 chữ số thập phân; gõ tay thì ghim nhảy theo. Hai tab dùng chung một lựa chọn mở / thu gọn.

**Màn Tuyến đường của nhà xe** (Khanh chốt 07/10/2026; Figma `1305:6710`, nhóm `Nhà xe · Tuyến đường · TRN-013`):

- Danh sách: tên tuyến, điểm đầu → điểm cuối, số điểm dừng, quãng đường, thời gian chạy, trạng thái, nút sửa; lọc theo trạng thái; "Tải thêm" thay cho số trang. Không có mã tuyến, giá vé, số chuyến.
- Form Thêm / Chỉnh sửa là một trang riêng, hai cột. Cột trái: danh sách điểm dừng theo thứ tự, mỗi điểm có số thứ tự, tên, địa chỉ, loại và nguồn (dùng chung / của nhà xe), ghi chú tùy chọn, công tắc cho đón / cho trả, nút lên / xuống / bỏ; giữa hai điểm hiện quãng đường và thời gian của chặng. Cột phải: thông tin tuyến (tên, trạng thái, ghi chú), bản đồ lộ trình đóng mở được (ghim đánh số nối bằng đường thẳng — không phải đường đi thực tế), thẻ Tổng quan (số điểm dừng, số điểm cho đón, số điểm cho trả, quãng đường, thời gian chạy, lần cập nhật cuối).
- Công tắc theo `BR-79`: điểm đầu chỉ đón, điểm cuối chỉ trả, trạm dừng nghỉ tắt cả hai — ba trường hợp này khóa công tắc; điểm ở giữa bật ít nhất một. Hai đầu không phải bến xe thì hiện cảnh báo màu vàng, vẫn cho lưu (`OQ-24`).
- Quãng đường và thời gian do hệ thống tính khi lưu; form thêm mới hiện "Tính khi lưu". Thời gian từng chặng có ô "Chạy thực tế … phút" (chờ duyệt 27/10/2026, chưa có Figma): để trống = số hệ thống (hiện làm gợi ý), nhập 1–1440 phút khi xe khách chạy chậm hơn số bản đồ, nút "Dùng số hệ thống" xóa số chỉnh; đổi thứ tự điểm thì chặng mới không mang số chỉnh của chặng cũ. Thẻ Tổng quan tính thời gian chạy theo số đang dùng — giờ đến của chuyến lấy theo tổng này.
- Bấm "Thêm điểm dừng" thì bảng chọn mở ngay dưới danh sách điểm dừng, không che form và không làm mờ nền: hai tab Dùng chung / Của nhà xe, ô tìm, lọc loại và tỉnh / thành, nút "Thêm" từng dòng. Điểm vừa thêm xếp cuối danh sách, bản đồ cập nhật ngay; điểm đã có trong tuyến không chọn lại được; điểm ngừng dùng hoặc bị khóa không hiện.
- Hiện thực bản đồ lộ trình (`TASK-TRN-014`, 07/10/2026): mặc định mở và nhớ lựa chọn riêng; trạm dừng nghỉ màu vàng; khi bảng chọn mở, các điểm trong bảng chưa thuộc tuyến hiện bằng chấm xám (Khanh chốt giữ, 07/10/2026) và khung nhìn bao cả các điểm đó; rê chuột hoặc đưa tiêu điểm vào một dòng thì chấm của dòng đó nổi lên kèm nhãn "Chưa có trong tuyến".

**Màn Chuyến xe của nhà xe** (`TASK-TRN-003`, `TASK-TRN-006`; Figma `1338:9559`, nhóm `Nhà xe · Chuyến xe · TRN-003`, khung 01–06):

- Danh sách (`/trips`): sắp theo giờ khởi hành tăng dần; lọc theo khoảng ngày khởi hành, tuyến, xe, trạng thái; mặc định hiện chuyến từ hôm nay trở đi ("Đến ngày" tính hết ngày đó). Mỗi dòng: giờ và ngày khởi hành, giờ đến (ghi ngày nếu sang hôm khác), tên tuyến và thời lượng, biển số và số chỗ (hoặc "Chưa gắn xe"), trạng thái. Bấm một dòng hoặc nút "Xem" để mở chi tiết; "Tải thêm" 20 dòng mỗi lần. Không có ô tìm theo chữ và không có số chỗ đã bán vì API chưa trả.
- Tạo / sửa chuyến nháp (`/trips/new`, `/trips/{id}/edit`): chỉ chọn được tuyến đang hoạt động và xe đang hoạt động đã có sơ đồ ghế; tuyến / xe đang gắn được giữ dù đã ngừng dùng. Ngày và giờ nhập theo giờ Việt Nam. Giờ đến **không nhập tay** (Khanh 27/10/2026, chờ duyệt): khối "Giờ đến (theo tuyến)" chỉ đọc = giờ khởi hành + thời gian chạy của tuyến, kèm lời nhắc sửa thời gian chặng ở Tuyến đường khi lệch thực tế; form đổi lịch chạy và lịch chạy lặp lại cũng vậy (lịch hiện "Thời gian chạy (theo tuyến)"). Xe để trống được khi còn nháp. Lỗi hiện tại ô sai — xe trùng giờ (`BR-14`) báo tại ô Xe — và dữ liệu đang nhập giữ nguyên. Lưu xong chuyển sang trang chi tiết.
- Giờ tại từng điểm dừng: bật "Tự chia" (mặc định) thì các ô giờ bị khóa và hiện đúng giờ máy chủ sẽ lưu; tắt thì nhập giờ cho các điểm ở giữa, ô nhập chỉ có giờ trên đồng hồ còn ngày do giao diện suy ra (giờ nhỏ hơn điểm liền trước nghĩa là đã sang hôm sau) và ghi ngay dưới ô. Giờ vượt giờ đến (theo tuyến) bị chặn trước khi gửi. Mở lại một chuyến đang dùng giờ tự nhập thì công tắc tắt sẵn.
- Chi tiết (`/trips/{id}`): tên tuyến kèm nhãn trạng thái, sơ đồ ghế theo chuyến (mỗi tầng một khối, mỗi chỗ ghi mã và tình trạng), lịch trình (loại điểm, điểm đầu / cuối, cho đón / cho trả theo `BR-79`) và thẻ thông tin chuyến (có dòng "Ngừng bán online"). Chuyến đang Nháp có nút "Sửa chuyến".
- Giá trên từng chỗ (`TASK-TRN-005`, 13/10/2026): chỗ còn trống ghi giá lấy từ bảng giá của tuyến theo loại xe đang gắn, loại chỗ và giờ khởi hành; chưa có giá thì ghi "Chưa có giá" màu đỏ kèm dòng nhắc mở Bảng giá. Chỗ không còn trống ghi tình trạng.
- Vòng đời bán và khóa chỗ (`TASK-TRN-006`, 14/10/2026; Figma khung 03–06):
  - Form chuyến có ô "Ngừng bán online trước giờ khởi hành (phút)" — bắt buộc, số nguyên 0–1440, gợi ý 60; dòng gợi ý và thẻ Tổng quan ghi mốc ngừng bán tính ra (`AS-20`).
  - Nút ở đầu trang chi tiết theo trạng thái: Nháp — Hủy chuyến, Sửa chuyến, Mở bán; Đang mở bán — Hủy chuyến, Thu hồi về nháp, Tạm dừng bán; Tạm dừng bán — Hủy chuyến, Thu hồi về nháp, Mở bán lại; trạng thái khác không có nút. Chuyến đã có vé (có chỗ Đã bán / Đã lên xe): Hủy chuyến và Thu hồi về nháp mờ đi kèm dòng giải thích. Tạm dừng bán và thu hồi về nháp đổi ngay, không hỏi lý do.
  - Khối "Điều kiện mở bán" (`BR-39`; chuyến Nháp và Tạm dừng bán) gồm tám mục: nhà xe hoạt động, tuyến hoạt động, mọi điểm dừng hoạt động, đã gắn xe đang hoạt động, xe có sơ đồ ghế, tuyến có bảng giá đang áp dụng, mọi chỗ có giá lớn hơn 0, còn trong thời gian bán online. Trước khi bấm Mở bán, mục giao diện tự biết từ dữ liệu chuyến được kết luận ngay, mục còn lại ghi "Kiểm khi bấm Mở bán". Bấm mà chưa đủ điều kiện: dải đỏ "Chưa mở bán được" nêu số mục chưa đạt, từng mục chưa đạt tô đỏ kèm cách sửa, chuyến giữ nguyên trạng thái. Mục máy chủ chưa xét được vì thiếu điều kiện đứng trước (chưa gắn xe thì chưa xét chỗ và giá) ghi rõ là chưa kiểm được, không ghi là đạt.
  - Khóa / mở khóa chỗ (`BR-42`; chuyến Nháp, Đang mở bán, Tạm dừng bán): bấm chỗ Còn trống để chọn nhiều chỗ rồi "Khóa chỗ đã chọn"; bấm chỗ Đã khóa để chọn rồi "Mở khóa chỗ đã chọn". Một lô chỉ gồm một loại — đang chọn chỗ để khóa thì chỗ đã khóa tạm không bấm được và ngược lại. Hộp thoại xác nhận liệt kê mã chỗ, có ô ghi chú tùy chọn (chỉ lưu trong lịch sử thay đổi). Chỗ đang giữ, đã bán, đã lên xe không bấm được. Sơ đồ tải lại mà một chỗ đang chọn không còn chọn được thì chỗ đó tự rời khỏi lô.
  - Hủy chuyến: hộp thoại bắt buộc nhập lý do (tối đa 500 ký tự), nút "Giữ chuyến" / "Hủy chuyến"; hủy xong trang không còn nút thao tác, sơ đồ ghế chỉ xem, thẻ Thông tin chuyến ghi lý do hủy.
  - Cột phải: thẻ "Tình trạng chỗ" (còn trống, đang giữ, đã bán, đã lên xe nếu có, đã khóa, tổng) cho mọi trạng thái trừ Nháp; thẻ "Bán online" (mốc ngừng bán, cài đặt số phút) cho chuyến Đang mở bán.
  - Khác khung Figma, chờ Khanh xem (bảng G1–G7 ở `TRN-006-todo.md`): dòng giải thích chuyến đã có vé không ghi mã task; mở khóa chỗ dùng cùng cách chọn và hộp thoại như khóa (Figma chỉ vẽ khóa); ô "Ngừng bán online" là ô nhập số với nhãn ghi "(phút)"; chuyến Tạm dừng bán và Đã hủy không có khung riêng nên suy từ bảng chuyển trạng thái.
  - Lịch xe (`TASK-TRN-015`, chờ duyệt — `TRN-015-todo.md`): công tắc "Danh sách | Lịch xe" (`/trips?view=schedule`); khung 07 — mỗi xe một hàng trên trục 24 giờ, dải chuyến theo trạng thái, hàng "Chưa gắn xe", cột "Rảnh từ (dự kiến)" + nơi xe dừng (chỉ hiển thị), vạch "Bây giờ", chấm "nối chuyến sát giờ" (≤ 30 phút); bấm khoảng trống → tạo chuyến điền sẵn xe + giờ. Khung 08 — ô Xe chia nhóm Rảnh / Trùng giờ (không chọn được, kèm lý do). Thẻ "Lịch xe trong ngày" (khung 02) ở form chuyến.
- Nhãn trạng thái: Nháp, Đang mở bán, Tạm dừng bán, Hết chỗ, Đang đón khách, Đã khởi hành, Đang chạy, Hoàn thành, Đã hủy, Có sự cố.

**Màn Bảng giá của nhà xe** (`TASK-TRN-005`; Figma nhóm `Nhà xe · Bảng giá`, khung `1665:24187` và `1665:24475`; mục riêng trên thanh bên, đứng sau "Tuyến đường"):

- Danh sách (`/fares`): mỗi tuyến một dòng — tên tuyến kèm điểm đầu → điểm cuối, số quy tắc, khoảng giá mỗi chỗ (ghi "Gồm giá chỗ đôi" khi có quy tắc riêng cho giường đôi / cabin đôi), trạng thái (Đang áp dụng / Ngừng áp dụng / Chưa có bảng giá), ngày giờ cập nhật, nút "Sửa" hoặc "Tạo". Ô tìm theo tên tuyến gõ không dấu vẫn ra; lọc theo trạng thái. Tuyến đã ngừng dùng mà chưa có bảng giá thì không hiện. Danh sách ghép tuyến với bảng giá ở phía giao diện nên tải hết một lần, không có "Tải thêm".
- Tạo / chỉnh sửa (`/fares/new`, `/fares/{id}`): bảng quy tắc (loại xe, loại chỗ, khung giờ khởi hành, giá mỗi chỗ) với nút sửa / xóa từng dòng; khối nhập mở ngay dưới bảng cho "Thêm quy tắc" hoặc "Sửa quy tắc đang chọn", bấm "Áp dụng quy tắc" mới đưa vào bảng và bấm "Lưu bảng giá" mới gửi lên máy chủ (thay toàn bộ quy tắc). Thiếu giá, khung giờ thiếu một đầu hoặc ngược chiều, quy tắc trùng phạm vi với dòng đang có đều báo ngay tại khối nhập. Còn quy tắc đang nhập dở thì chưa cho lưu. Tối đa 200 quy tắc.
- Cột phải: thông tin bảng giá (tuyến — khi tạo là ô chọn chỉ liệt kê tuyến đang hoạt động chưa có bảng giá; trạng thái; ghi chú) và thẻ Lịch sử thay đổi (`BR-40`): mỗi dòng tóm tắt thay đổi từ bản chụp trước / sau — đổi giá một quy tắc thì ghi giá cũ → giá mới, nhiều thay đổi thì đếm số quy tắc thêm / xóa / đổi giá; tải thêm 5 dòng mỗi lần.
- Tiền nhập bằng số nguyên đồng, nhận dấu chấm ngăn hàng nghìn (`300.000`); hiển thị dạng `300.000 ₫`.
- Khoảng giá ở danh sách tính trên mọi quy tắc của bảng giá, kể cả quy tắc có khung giờ đã qua (Khanh chốt 14/10/2026).
- Khác khung Figma `1665:24475` — **Khanh chốt 14/10/2026 giữ như đã làm** (khung Figma chưa vẽ lại): khung giờ của quy tắc là một **khoảng ngày giờ khởi hành** (giá dịp lễ, Tết — hai ô ngày giờ "Khởi hành từ" / "Đến trước"; Q2, Q3 của `TASK-TRN-005`), không phải giờ trong ngày như khung Figma vẽ ("18:00 – 24:00"); quy tắc không có khung giờ ghi "Mọi ngày". Dải cảnh báo "giá nằm ngoài khung giá" làm cùng khung trần / sàn ở `TASK-ADM-001`, chưa có ở màn này.

**Màn Nhân viên và màn Tài khoản của nhà xe** (phần giao diện của `TASK-IAM-005`, 14/10/2026; Figma nhóm `Nhà xe · Nhân viên` và `Nhà xe · Tài khoản chủ nhà xe`):

- Nhân viên (`/employees`): mỗi tài khoản một dòng — tên đăng nhập đầy đủ `{mã nhà xe}/nv.{tên}` kèm email liên hệ, vai trò, trạng thái (Hoạt động / Bị khóa / Vô hiệu hóa), tình trạng mật khẩu và ba nút sửa, cấp lại mật khẩu tạm, khóa / mở khóa. Tìm theo tên đăng nhập hoặc email, lọc theo vai trò và trạng thái; danh sách tải hết một lần rồi lọc ở giao diện.
- Cột "Mật khẩu": "Đã đổi mật khẩu"; "Chờ đổi mật khẩu tạm" kèm hạn (mật khẩu tạm có hiệu lực 24 giờ); "Mật khẩu tạm đã hết hạn"; "Chưa gửi được mật khẩu tạm" kèm lời dặn cấp lại. Tài khoản bị khóa / vô hiệu hóa không ghi tình trạng mật khẩu.
- Thêm nhân viên: tên đăng nhập có tiền tố cố định `{mã nhà xe}/nv.`, chủ nhà xe chỉ nhập phần sau; email liên hệ; vai trò chọn bằng ba thẻ. Mật khẩu tạm do máy chủ sinh và gửi qua email, không hiện trên màn hình. Tạo xong mà gửi email lỗi thì tài khoản vẫn được tạo: hộp thoại dặn cấp lại mật khẩu, không tạo lại.
- Sửa, khóa, mở khóa, cấp lại mật khẩu tạm: bắt buộc lý do (3–500 ký tự, lưu vào nhật ký). Đổi tên đăng nhập hoặc email làm nhân viên bị đăng xuất; đổi email thì phải cấp lại mật khẩu tạm tới email mới. Cấp lại tối đa một lần mỗi giờ cho mỗi nhân viên. Tài khoản đã vô hiệu hóa không còn thao tác.
- Xác nhận lại danh tính (IAM-005 Q8): hộp thoại của thao tác nhạy cảm có ô "Mật khẩu của bạn hoặc mã xác thực" — đúng 6 chữ số là mã của ứng dụng xác thực, còn lại là mật khẩu. Xác nhận xong, khoảng 5 phút không hỏi lại. Sai mật khẩu báo tại ô và không làm mất phiên đăng nhập.
- Tài khoản và bảo mật (`/account`, mở từ khối tài khoản ở cuối thanh bên): bảng phiên đăng nhập — thiết bị, địa chỉ IP đã che, lúc đăng nhập, lần dùng gần nhất; phiên đang dùng ghi "Đang dùng", phiên khác có nút "Thu hồi"; nút "Đăng xuất các phiên khác" hỏi lại trước khi làm (`FR-IAM-15`). Thẻ Xác thực hai lớp và thẻ Mật khẩu chỉ để đọc: chủ nhà xe không tự đổi mật khẩu hay đặt lại xác thực hai lớp ở đây.
- Khác khung Figma, chờ Khanh xem (bảng N1–N8 ở `IAM-005-web-todo.md`): không có ngày đăng nhập gần nhất, ngày khóa, ngày thiết lập xác thực hai lớp và số mã dự phòng còn lại vì API chưa trả; thêm nhân viên có ô xác nhận danh tính; chưa có nút vô hiệu hóa vĩnh viễn; nút "Phân công chuyến" (`TASK-EMP-001`) và tab "Thông báo" (`TASK-NSR-002`) chưa làm.

---

### COUNTER-SALES — Cổng web bán vé riêng (27/10/2026)

`/auth/counter/login` dẫn tới `/counter`, dùng cùng ứng dụng Operator OS nhưng layout/cổng tiếp nhận Owner và `SALES_STAFF` riêng với phần quản trị. Owner tạo/khóa/cấp lại mật khẩu nhân viên bán vé qua quản lý nhân viên như tài xế/soát vé; phân công nhiều văn phòng ở màn văn phòng. Nhân viên bán vé không vào phần quản trị Operator OS.

Luồng quầy: chọn văn phòng được cấp → ngày/chuyến → điểm đón/trả và ghế còn trống → giữ10 phút → thông tin khách (email tùy chọn) → thu đủ tiền mặt hoặc chuyển khoản đã đối chiếu mã giao dịch → vé QR/in/in lại. Hiện rõ người đang bán; lịch sử lưu văn phòng và người bán. Không hiển thị nút xác nhận chuyển khoản bằng ảnh chụp tự động.

Mọi bước có loading/error/empty/permission state. Sau timeout tải lại đơn/khoản thu để tiếp tục an toàn; khoản thu ngoại lệ hiển thị đã nhận tiền cần xử lý, không báo phát vé thành công. Chi tiết chuyến cho người có `trip:dispatch` xác nhận xe thực sự khởi hành bằng hộp xác nhận; giờ lịch trễ không tự đóng quầy. Admin cấu hình kênh hoa hồng và ghi khoản phí đã thu thủ công, tách khỏi payout.

## 8. Flow Employee

App `apps/employee_mobile`; login `{operatorSlug}/nv.{…}` + password qua `/auth/employee/login`, chỉ Bearer (ADR-028/017, amend 28/09/2026). Đây là kênh đăng nhập duy nhất của Employee. App **không** xử lý riêng username thiếu tiền tố `nv.`: gửi lên API như mọi tài khoản và nhận cùng lỗi generic `AUTH_INVALID_CREDENTIALS`; không hiển thị hướng dẫn chuyển sang web Operator OS (Khanh chốt 02/10/2026). Lỗi từ API luôn generic.

| Flow            | Màn hình chính           | Ghi chú                                    |
| --------------- | ------------------------ | ------------------------------------------ |
| Xem nhiệm vụ    | Assigned trips           | Chỉ chuyến được phân công                  |
| Xem khách       | Passenger list           | Search theo tên/mã vé/SĐT được phép        |
| Check-in        | QR scanner / manual code | Xác thực server-side (không tin QR encode) |
| Cập nhật chuyến | Trip status              | Chỉ role/quyền phù hợp                     |
| Báo sự cố       | Incident form            | Loại sự cố, mức độ, mô tả, attachment      |
| Offline/sync    | Pending sync state       | Chính sách conflict TBD (UX-OQ-04)         |

---

## 9. Flow Admin

Login `platform/{username}` + password + **TOTP bắt buộc** (ADR-017). Dùng cùng bootstrap/cookie/CSRF/refresh/logout state machine của §7; Admin không có public enrollment. Chỉ render shell Admin sau khi `/auth/me` trả đúng scope `platform` và role được phép; sai namespace/role thì logout và về đúng cổng đăng nhập.

| Flow                      | Màn hình chính                                                              | Ghi chú                                                                                  |
| ------------------------- | --------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| KYC Operator              | Hàng đợi hồ sơ đăng ký, chi tiết hồ sơ (doc R2 presigned + audit), modal quyết định | Duyệt (nhập slug + username Owner; báo trùng slug) / yêu cầu bổ sung / từ chối (lý do bắt buộc); TOTP + re-auth. `TASK-ADM-001` đã làm theo Figma ADM-02a…02d (chờ duyệt): hàng đợi lọc trạng thái / thời điểm gửi / cảnh báo trùng + tìm; chi tiết hai cột (doanh nghiệp, giấy tờ "Mở tệp" ở tab mới, tài khoản nhận tiền che | trùng định danh, người liên hệ, lịch sử); ô TOTP chỉ hiện khi chưa xác nhận trong 5 phút; yêu cầu bổ sung không hỏi TOTP; sau khi duyệt hiện tài khoản `slug/username` và nút gửi lại mật khẩu tạm nếu chưa gửi được. Chưa có tab "Nhà xe" |
| Catalog/policy            | Catalog list, policy editor, effective date                                 | Thay đổi policy cần audit, không áp ngược (PolicySnapshot). `TASK-ADM-001` danh mục đã làm theo Figma ADM-04a…04c (chờ duyệt): `/catalog` bốn tab Tỉnh / thành · Phường / xã · Loại xe · Tiện ích (tab trên địa chỉ); tỉnh / phường tìm + lọc trạng thái + Tải thêm; thêm / sửa trong hộp thoại (mã sai / trùng báo tại ô Mã; khi sửa không đổi mã / tỉnh / dạng chỗ / hạng xe); ngừng dùng có khối Mức ảnh hưởng + lý do bắt buộc, dùng lại chỉ xác nhận. Chính sách chưa làm |
| Payment/refund            | Transaction list, detail, refund decision                                   | Re-auth/TOTP + audit                                                                     |
| Payout confirm            | Payout batch (T+3), review, **nhập mã giao dịch ngân hàng**                 | Manual confirm tới BankAccount verified → COMPLETED (ADR-022); maker-checker khi team >1 |
| Dispute                   | Dispute queue, evidence view, decision                                      | Admin là arbiter cuối cùng (MQ-03)                                                       |
| Content/review moderation | Review/content list; danh sách ảnh phương tiện (lọc nhà xe)                 | Ẩn/duyệt/từ chối theo policy; gỡ ảnh xe vi phạm bắt buộc lý do + audit (FR-ADM-20). `TASK-ADM-003` phần ảnh xe đã làm theo Figma ADM-10b/10c (chờ duyệt): `/moderation` tab Ảnh phương tiện — lưới thẻ ảnh (nhà xe, biển số · chú thích, thời điểm, nhãn Ảnh đại diện), lọc nhà xe / thời gian tải lên (mặc định 7 ngày), Tải thêm; hộp thoại gỡ ảnh lý do 3–500. Tab Đánh giá hiện nhưng khóa. **Tab Nội dung công khai** (`TASK-ADM-003`, chờ duyệt — `ADM-003-content-todo.md`): theo Figma ADM-10d — lọc loại / tình trạng / tiêu đề, bút = sửa, mắt = xem trước, "Thêm nội dung"; trang soạn `/moderation/content/*` (chưa có Figma) |
| Điểm dừng                 | Ba tab: **Dùng chung** (thêm, sửa, ngừng dùng; bến xe / điểm dừng đón trả bắt buộc căn cứ công bố), **Chờ duyệt** (đề xuất của nhà xe: xem căn cứ, cảnh báo điểm trùng ở gần, chỉnh rồi duyệt hoặc từ chối kèm lý do), **Của nhà xe** (xem toàn hệ thống, khóa / mở khóa) | Khóa và từ chối bắt buộc lý do + audit; không sửa nội dung điểm riêng (FR-ADM-21, BR-81) `TASK-ADM-004` đã làm theo Figma ADM-05a…05e (chờ duyệt): tab trên địa chỉ (`?tab=`), số trên tab, bản đồ tổng quan + hộp thoại thêm / sửa có bản đồ kéo ghim (không có khóa bản đồ thì nhập tay), trang xem xét đề xuất riêng (`/stop-points/proposals/{id}`), hộp thoại khóa có mức ảnh hưởng = số tuyến; chưa có ô lọc theo nhà xe. |
| Loyalty                   | Policy editor (phiên bản + effective date), tra cứu tài khoản User, điều chỉnh điểm, báo cáo | Điều chỉnh bắt buộc lý do + audit; tham số không áp ngược (FR-LOY-10..12, UC-39) |
| Bài viết                  | Danh sách (lọc trạng thái / chuyên mục), editor Markdown + xem trước, upload ảnh, xuất bản / gỡ, chuyên mục (`TASK-CNT-001` đã làm theo Figma ADM-13a…13c, chờ duyệt) | Audit xuất bản; chỉ `PUBLISHED` công khai (FR-ADM-18..19, UC-40) |
| Report                    | Dashboard, filter, export job (async BullMQ)                                | Dữ liệu lớn không chặn luồng chính                                                       |
| Audit                     | Audit search (Mongo), detail, export                                        | Mask dữ liệu nhạy cảm. `TASK-ADM-002` phần audit đã làm theo Figma ADM-15a/15b (chờ duyệt): `/audit-logs` lọc khoảng thời gian (mặc định 7 ngày) / loại người thực hiện / phân hệ / kết quả, tìm tài khoản hoặc mã đối tượng; `/audit-logs/{id}` trước và sau (đã che), lý do, chuỗi bản ghi, tóm tắt IP / thiết bị; lượt xem được ghi. Chưa làm "Xuất nhật ký" |
| Tổng quan                 | Thẻ số, Việc cần xử lý, Tiền đang giữ, Trạng thái tích hợp (Figma ADM-01) | Chờ duyệt (`ADM-system-shells-todo.md`): số thật cho nhà xe đang hoạt động, hồ sơ chờ duyệt, đề xuất điểm dừng, yêu cầu đổi tài khoản nhận tiền, tích hợp; chỉ số giao dịch / escrow / chi trả hiện "—" |
| Nhà xe + người dùng       | Nhà xe (ADM-02e/f), Hành khách / Nhân viên nhà xe (chỉ xem) / Tài khoản quản trị (ADM-03a…03d) | Chờ duyệt (`ADM-001-accounts-todo.md`): thao tác thay đổi cần lý do + mã TOTP; nhà xe có yêu cầu đổi tài khoản nhận tiền hiện "Chờ xác minh TK nhận tiền" → hộp thoại so sánh tài khoản cũ / mới (số đầy đủ, audit) + Từ chối / Xác minh (`OPR-001b-todo.md`; Figma chưa có khung này) |
| Chính sách                | Tab Hủy và hoàn tiền / Giữ chỗ / Hoa hồng / Chi trả / Khung giá vé; trình soạn phiên bản (ADM-06a…06d) | Chờ duyệt (`ADM-001-policy-todo.md`): lưu nháp / kích hoạt (lý do + TOTP), hủy lịch; mức hoa hồng riêng thêm / sửa / ngừng; khung giá thiết lập / hủy |
| Tích hợp & hệ thống       | Tab Tích hợp / Tác vụ nền (ADM-16a / 16b) | Chờ duyệt: **chỉ đọc** (Khanh 16/10/2026) — không tab Bảo trì, không "Chạy lại"; gọi thử thật hạ tầng, dịch vụ gửi đi chỉ kiểm cấu hình |
| Khung màn chờ đặt vé      | Thanh toán & hoàn tiền, Chi trả, Khiếu nại & tranh chấp, Khuyến mãi, VXN Plus, Báo cáo | Thẻ số "—", tiêu đề cột / tab theo Figma, trạng thái trống ghi rõ task chờ; không số liệu mẫu |

---

## 10. Screen state và validation

### 10.1. Quy tắc 5 trạng thái chính (5 Key UI States)

Mỗi màn hình ở §6–§9 được viết thành **một bảng đủ 5 trạng thái** dưới đây để dễ kiểm tra. Trạng thái không áp dụng vẫn giữ dòng, ghi `—` kèm lý do ngắn. §7–§9 chuyển sang dạng này khi đối chiếu Figma phần Operator / Employee / Admin.

| Trạng thái     | Định nghĩa                                                                                                                 | Với màn form / modal                   |
| -------------- | -------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- |
| Ideal          | Đầy đủ dữ liệu, luồng chính thành công (bản vẽ thường làm đầu tiên)                                                        | Form nhập hợp lệ, gửi thành công       |
| Empty          | Người dùng chưa có dữ liệu; bắt buộc có gợi ý hành động tiếp theo (onboarding / CTA)                                        | Form trống ban đầu, CTA vô hiệu        |
| Loading        | Dữ liệu đang tải: skeleton / spinner                                                                                       | Đang gửi / đang xác thực               |
| Partial / Edge | Chỉ 1–2 item thay vì hàng chục; tên / địa chỉ quá dài gây tràn chữ (truncation); số lượng quá lớn (1.000.000+); biến thể trạng thái nghiệp vụ (SRS §17) | Chạm giới hạn nhập, biến thể theo actor |
| Error          | Lỗi mạng (offline), lỗi hệ thống (404, 500, 503), không tìm thấy kết quả tìm kiếm                                          | Lỗi tại field, gửi thất bại            |

### 10.2. Yêu cầu chung theo loại trạng thái

| Loại state          | Bắt buộc xử lý                                                                       |
| ------------------- | ------------------------------------------------------------------------------------ |
| Loading             | Skeleton/spinner phù hợp, không khóa toàn app nếu chỉ refresh một panel              |
| Empty               | Thông báo rõ, có hướng hành động kế tiếp                                             |
| Error               | Message rõ (RFC 7807 `code` map UX), không lộ dữ liệu nhạy cảm, có retry nếu phù hợp |
| Permission denied   | Hiển thị không đủ quyền, không lộ dữ liệu bị chặn                                    |
| Stale data          | Yêu cầu reload/xác nhận lại khi giá/ghế/policy thay đổi                              |
| Form invalid        | Báo lỗi tại field (Zod schema), không chỉ báo lỗi tổng quát                          |
| Service unavailable | Redis down → 503: báo "thử lại sau 30s" cho booking (ADR-015)                        |
| Offline mobile      | Hiển thị pending sync, retry, cảnh báo dữ liệu chưa đồng bộ                          |

---

## 11. Open Questions / TBD

| ID       | Câu hỏi                                                                  | Tác động            | Trạng thái                                                                   |
| -------- | ------------------------------------------------------------------------ | ------------------- | ---------------------------------------------------------------------------- |
| UX-OQ-01 | Guest checkout có trong v1 không?                                        | Public booking flow | **Đóng theo SRS/GLOSSARY**: Guest có guest session cho hold/book/pay/lookup  |
| UX-OQ-02 | Web dùng token storage hay cookie session?                               | Auth UX và Security | **Đóng theo ADR-017**: Web = httpOnly cookie; Mobile = secure-store (Bearer) |
| UX-OQ-03 | Seat map editor dùng grid tự do hay template theo vehicle type?          | Operator UI         | **Đóng 04/10/2026 (Khanh):** lưới tự do, v1 không làm mẫu theo loại xe; chỗ đôi là một ô lưới, vẽ rộng hơn chỗ đơn (BR-78). Quy tắc tạo lưới ở §7 |
| UX-OQ-04 | Offline check-in cho Employee có cho xác nhận khi chưa gọi server không? | Mobile flow và risk | Mở; cần quyết risk (double check-in vs UX offline)                           |
| UX-OQ-05 | Brand positioning marketplace trung lập hay Platform brand nổi bật?      | Public UI           | **Đóng theo OQ-20**: marketplace trung lập; tên Operator là tín hiệu chính   |
| UX-OQ-06 | Chương trình thành viên **VXN Plus** (hạng, tích điểm, đổi điểm lấy mã giảm, Ví voucher, giảm theo hạng) có vào v1 không? Không có trong SRS; đụng money (quy đổi điểm → VND), ai chịu phần giảm (Platform hay Operator — ảnh hưởng commission/escrow), cần module mới | SRS, DB, API, booking total | **Đóng 29/09/2026** (SRS v1.21 §21): vào v1 — Platform chịu phần giảm của voucher đổi điểm; hạng chỉ ảnh hưởng hệ số điểm; ví = voucher đổi điểm + mã công khai đã lưu |
| UX-OQ-07 | **Dịch vụ bổ trợ** (bảo hiểm chuyến đi, hành lý ký gửi, đưa đón — lưu ý trung chuyển giữa văn phòng và bến xe theo luật không thu tiền, `BR-79`) có vào v1 không? Không có trong SRS; đụng price snapshot, tách dòng (CO-12), hoàn tiền, commission; bảo hiểm cần đối tác bên ngoài (vendor mới) | SRS, booking total, refund | Mở. Đề xuất: post-v1; Figma trang này còn skeleton TODO |
| UX-OQ-08 | Trang **Khám phá** (tin tức / cẩm nang): SRS chỉ có banner, FAQ, content page do Admin kiểm duyệt (FR-ADM-13). Bài viết có tính là content page không, ai soạn (Admin CMS)? | Admin CMS, SEO Marketplace | **Đóng 29/09/2026** (SRS v1.21 §21): module bài viết riêng (`Article`), chỉ Admin soạn |
| UX-OQ-09 | **Tra cứu vé Guest bằng SĐT**: SMS defer v1 (ADR-020) thì OTP gửi về đâu? (a) chỉ cho tra cứu bằng email; (b) SĐT chỉ dùng để tìm, OTP gửi về email liên hệ của booking | FR-MKT-12, `/guest/ticket-lookup` | **Đóng 26/10/2026** (Khanh: tra cứu vé khách vãng lai bắt buộc OTP): phương án (a) — B1 nhập mã đặt vé (hoặc mã vé) + email, mã 6 số gửi về email liên hệ của đơn, phiên tra cứu 15 phút; không tra bằng SĐT ở v1 |

---

### Quy ước mã trong UI/UX Flow

- `UX-OQ-NN`: Câu hỏi mở của UI/UX Flow.
- `SCR-PSG-NN`: Màn hình Passenger / Guest (§6.1).
