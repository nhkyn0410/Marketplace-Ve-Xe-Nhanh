# TASK-TRN-013 — Checklist nghiệm thu: Màn Điểm dừng và màn Tuyến đường (Operator OS)

> Mục tiêu: chủ nhà xe quản lý điểm riêng, tra cứu danh mục dùng chung, gửi và theo dõi đề xuất; sau đó lập tuyến từ các điểm đó (phần 2).
> Chỉ tick `[x]` khi có evidence. Lệnh: `TRN-013-guide.md`. Phạm vi: `TRN-013-todo.md`.

## Snapshot trạng thái (07/10/2026)

- [x] Nhánh `TASK-TRN-013` từ `develop`; tạo bộ ba todo / guide / checklist.
- [x] Thiết kế Figma `Section 4` đã có và được Khanh duyệt qua 5 quyết định ngày 07/10/2026.
- [x] Phần 1 (màn Điểm dừng): code, test đơn vị, E2E xong; đo trên máy dev với Postgres 16, Redis 7, Mongo 7 chạy bằng container tạm.
- [x] Phần 2 (màn Tuyến đường + bổ sung API danh sách tuyến): code, test, E2E, client TS + Dart xong.
- [ ] Khanh review diff → commit → CI xanh.

## PHẦN A — Khung trang và tab

- [x] Thanh bên có mục "Điểm dừng" đứng trước "Tuyến đường"; đang ở trang thì mục được tô.
- [x] Hai tab Của nhà xe / Dùng chung; tab đang mở nằm trên URL, tải lại trang vẫn đúng tab (E2E).
- [x] Nút đầu trang đổi theo tab: "Thêm điểm dừng" ở tab Của nhà xe, "Đề xuất điểm dừng" ở tab Dùng chung.

## PHẦN B — Tab Của nhà xe

- [x] Bảng hiện tên, địa chỉ, loại điểm, tỉnh / thành, số tuyến đang dùng ("Chưa dùng" khi bằng 0), trạng thái (E2E + ảnh chụp).
- [x] Ô tìm gõ không dấu vẫn ra; không có kết quả thì có nút "Bỏ lọc" (E2E).
- [x] Lọc theo loại điểm, tỉnh / thành, trạng thái và từ khoá gửi đúng tham số `type`, `provinceId`, `status`, `q` cho API (kiểm request trên trình duyệt).
- [x] Điểm bị khóa: nhãn "Bị khóa", dòng lý do màu đỏ, không có nút Sửa (ảnh chụp với dữ liệu khóa bằng SQL).
- [x] Điểm ngừng dùng: tên màu xám, nhãn "Ngừng dùng", vẫn sửa được.
- [x] Chưa có điểm nào: khối "Thêm điểm dừng đầu tiên" kèm nút (E2E).
- [x] Trạng thái đang tải (khung xương), lỗi kết nối ("Thử lại" tải lại được), lỗi khi tải thêm (giữ các dòng đã tải) — kiểm bằng cách chặn request trên trình duyệt.

## PHẦN C — Hộp thoại Thêm / Sửa điểm dừng

- [x] Bấm lưu khi trống: lỗi dưới từng ô bắt buộc, không gửi request (E2E).
- [x] Ô loại điểm chỉ có Văn phòng trung chuyển và Trạm dừng nghỉ (E2E; `BR-38`).
- [x] Chọn tỉnh mới thì ô phường / xã bị xóa và nạp lại theo tỉnh.
- [x] Tọa độ nhận dấu phẩy thập phân; ngoài khoảng cho phép thì báo tại ô (test đơn vị).
- [x] Lưu xong: hộp thoại đóng, có dòng báo, bảng có điểm mới (E2E).
- [x] Trùng tên: báo tại ô tên, dữ liệu đã nhập còn nguyên (E2E).
- [x] Sửa: mở với dữ liệu sẵn có, đổi trạng thái được (E2E).
- [x] Mã lỗi API khác (bị khóa, không còn tồn tại, danh mục đã ngừng) có thông báo riêng (test đơn vị).

## PHẦN D — Tab Dùng chung và đề xuất

- [x] Danh mục dùng chung chỉ xem: không có nút sửa, không có cột trạng thái và số tuyến (E2E + ảnh chụp).
- [x] Hộp thoại đề xuất: ô loại điểm chỉ có Bến xe và Điểm dừng đón trả khách; thiếu căn cứ công bố thì báo tại ô (E2E; `BR-38`).
- [x] Gửi xong: dòng mới ở bảng đề xuất với nhãn "Chờ duyệt", không có nút sửa (E2E).
- [x] Đề xuất bị từ chối: hiện lý do, nút "Sửa và gửi lại" mở hộp thoại kèm lý do và dữ liệu cũ (ảnh chụp với dữ liệu từ chối bằng SQL).
- [x] Đề xuất đã duyệt: nhãn "Đã duyệt", ghi chú "Đã vào danh mục".
- [x] Gửi lại một đề xuất bị từ chối: dòng về "Chờ duyệt", hết nút sửa, căn cứ công bố mới hiện trên bảng, có dòng báo đã gửi lại (kiểm trên trình duyệt).

## PHẦN E — API danh sách tuyến

- [x] `GET /operator/routes` trả `originName`, `destinationName` theo thứ tự hiện tại của tuyến, cả điểm dùng chung lẫn điểm riêng; đảo hai đầu thì tên đổi theo (test trên Postgres thật, role app).
- [x] Tenant khác không thấy tuyến trong danh sách của mình (cùng test).
- [x] Response danh sách không kèm danh sách điểm dừng (test route HTTP).
- [x] Client TS: chỉ thêm hai trường của danh sách tuyến. Client Dart (`openapi-generator-cli:v7.25.0`): 3 file đổi nội dung, đều thuộc danh sách tuyến; `dart analyze` 0 lỗi; `dart test` 431 pass.

## PHẦN F — Màn Tuyến đường

- [x] Danh sách: tên tuyến, điểm đầu → điểm cuối, số điểm dừng, quãng đường, thời gian chạy, trạng thái, nút Sửa (E2E + ảnh chụp).
- [x] Chưa có tuyến: khối "Lập tuyến đầu tiên" kèm nút (E2E).
- [x] Form trống bấm Lưu: lỗi ở ô tên và ở danh sách điểm dừng cùng lúc, không gửi request (E2E).
- [x] Bảng chọn điểm dừng mở trong form, không phải hộp thoại; điểm ngừng dùng không hiện; điểm đã thêm hiện "Đã thêm" (E2E).
- [x] Công tắc theo `BR-79`: điểm đầu chỉ đón, điểm cuối chỉ trả, trạm dừng nghỉ tắt cả hai — đều khóa; điểm giữa bật / tắt được (E2E + kiểm trên trình duyệt + test đơn vị).
- [x] Trạm dừng nghỉ đứng đầu / cuối, hoặc điểm giữa tắt cả hai công tắc: báo lỗi trước khi gửi (E2E + kiểm trên trình duyệt).
- [x] Đổi thứ tự bằng nút lên / xuống; chặng bị ảnh hưởng và tổng hiện "Tính khi lưu" (kiểm trên trình duyệt + test đơn vị).
- [x] Lưu xong: sang trang Chỉnh sửa, có dòng "Đã lưu tuyến", có số liệu từng chặng và tổng (E2E).
- [x] Hai đầu không phải bến xe: cảnh báo vàng, vẫn lưu được; hai đầu là bến xe thì không cảnh báo (E2E + kiểm trên trình duyệt).
- [x] Trùng tên: báo tại ô tên, danh sách điểm còn nguyên (kiểm trên trình duyệt).
- [x] Enter trong ô ghi chú của điểm dừng không gửi form; rời form khi có thay đổi thì được hỏi lại (kiểm trên trình duyệt).
- [x] Sau khi lưu tuyến, màn Điểm dừng báo "1 tuyến" cho điểm vừa dùng (E2E).
- [x] Dịch vụ bản đồ lỗi (503): báo ở đầu form, nói rõ tuyến chưa được lưu, dữ liệu đang nhập còn nguyên. Điểm dừng không còn dùng được (422): báo ở đầu danh sách điểm. Kiểm bằng cách giả lập phản hồi lỗi trên trình duyệt — chưa thử với Goong lỗi thật.
- [x] Danh sách tuyến và form: đang tải (khung xương), lỗi kết nối ("Thử lại" tải lại được), tuyến không tồn tại (báo không tìm thấy, có lối về danh sách) — kiểm bằng cách chặn request trên trình duyệt.

## PHẦN G — Chất lượng

- [x] Test API toàn bộ với `REQUIRE_DB_TESTS=1`: **66 file, 818 test pass, 0 skip**.
- [x] Test đơn vị Operator OS: **9 file, 161 test pass** (87 test mới: 45 của điểm dừng, 42 của tuyến).
- [x] E2E Operator OS: **13/13 pass** (5 ca mới). Ở phần 1, lần chạy đầu có 1 ca của màn phương tiện quá thời gian chờ khi Next biên dịch trang lần đầu; chạy lại thì đạt.
- [x] `pnpm turbo run typecheck lint test`: 29/29 task pass.
- [x] So với Figma `Section 4`: bố cục, cột, nhãn, màu trạng thái khớp ở độ rộng 1440; ở 1024 bộ lọc xuống dòng và bảng cuộn ngang. Khác có chủ đích: chưa có khối bản đồ (`TASK-TRN-014`); bảng chọn điểm dừng xếp loại điểm và tỉnh chồng một cột.
- [ ] `code-reviewer` trước khi đóng task (DoD §6.3) — chưa chạy.

## Bàn giao cho task sau

- `TASK-TRN-014`: gắn bản đồ Goong vào ba chỗ đã chừa — khối tổng quan trên bảng Của nhà xe / Dùng chung, cột phải của hộp thoại điểm dừng, thẻ lộ trình trong form tuyến.
- `TASK-ADM-004`: khi Admin khóa điểm hoặc từ chối đề xuất, màn này đã hiện đúng lý do; không cần sửa thêm phía nhà xe.
