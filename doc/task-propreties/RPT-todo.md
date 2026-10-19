# Báo cáo nhà xe + Admin, hai trang Tổng quan (TASK-RPT-001 / 002) — Todo

> Khanh 19/10/2026: "Báo cáo nhà xe và Admin (RPT-001/002), kèm hai trang Tổng quan". Thiết kế API / số liệu AI tự đề xuất, **chờ Khanh duyệt**. Nhánh `TASK-TRN-008`, chưa commit; chưa qua `code-reviewer` / `security-auditor`.

## Đã làm

- API module `reporting/` — tính trực tiếp từ Postgres theo kỳ (ngày giờ VN, gồm hai đầu, tối đa 366 ngày), không bảng tổng hợp riêng:
  - `GET /operator/overview`, `GET /operator/reports/summary`, `GET /operator/reports/export` (CSV) — Owner, quyền `finance:read` (tenant + RLS).
  - `GET /admin/overview`, `GET /admin/reports/summary`, `GET /admin/reports/export` (CSV) — PlatformAdmin + PlatformSupport, quyền `payment:monitor` (không dùng `finance:read` vì Owner cũng có quyền đó).
  - Xuất CSV ghi audit `report.export` (BR-56); ghi audit lỗi → 503, không trả tệp. CSV UTF-8 có BOM, chặn công thức.
- Định nghĩa số liệu:
  - Chỉ số theo chuyến: chuyến **khởi hành** trong kỳ, trừ nháp; chuyến hủy chỉ góp vé hủy. Vé bán = vé `VALID` / `CHECKED_IN` / `NO_SHOW` / `USED`. Doanh thu gộp nhà xe = tổng giá vé của vé bán. Lấp đầy = vé bán / số chỗ. Tỷ lệ hủy = vé hủy (gồm đã hoàn) / (vé bán + vé hủy).
  - Nhân viên: chuyến được phân công khởi hành trong kỳ; vé đã soát = lịch sử vé → `CHECKED_IN` do nhân viên đó trong kỳ.
  - Admin: giá trị giao dịch (GMV) = thanh toán thành công theo **giờ trả**; doanh thu sau hoàn = GMV − hoàn tiền thành công trong kỳ ("tạm tính" khi còn thanh toán cần đối soát). Chuyến bị nhà xe hủy = chuyến hủy đã có vé / chuyến đã có vé.
  - Tổng quan Admin: so với kỳ liền trước cùng độ dài; tiền đang giữ = số dư sổ giữ hộ, đủ điều kiện / chưa tới mốc (BR-32, theo giờ hoàn thành thực tế nếu có) / đang có yêu cầu hoàn; hoa hồng ghi nhận trong kỳ; GMV theo ngày (tối đa 31 ngày cuối của khoảng).
- Operator OS: trang **Tổng quan** (thẻ chỉ số, chuyến sắp chạy, việc cần chú ý — chuyến 48 giờ tới chưa có tài xế, chuyến nháp 7 ngày tới, đơn chờ hoàn) và **Báo cáo** (Figma 1667:26847: lọc ngày / tuyến / xe / trạng thái, 4 thẻ, theo tuyến, nhân viên, xuất CSV).
- Admin: **Tổng quan** (ADM-01: lọc ngày / nhà xe / cổng, GMV so kỳ trước, đơn, vé, việc cần xử lý có số thật cho chi trả chờ rà soát / hoàn tiền lỗi / thanh toán cần đối soát, escrow, biểu đồ GMV theo ngày, tích hợp, thao tác gần đây của tài khoản nền tảng) và **Báo cáo** (ADM-14a: 4 thẻ, theo nhà xe, phương thức thanh toán, xuất CSV).

## Chờ Khanh

| # | Điểm | Đã làm theo |
|---|------|-------------|
| G1 | Thẻ "Đánh giá của hành khách" (nhà xe), cột "Đánh giá" (Admin) | Chưa hiện — chưa có chức năng đánh giá chuyến đi |
| G2 | Cột "Sự cố đã báo" (nhân viên) | Chưa hiện — chưa có module sự cố (`incident/`) |
| G3 | "Yêu cầu xuất báo cáo" chạy nền + danh sách tệp | v1 tải CSV trực tiếp theo bộ lọc (một bảng theo tuyến / theo nhà xe), có audit |
| G4 | Lọc "Khu vực" (Admin), lọc "Tuyến" ở báo cáo Admin | Chưa làm — chưa có dữ liệu vùng chuẩn hóa; tuyến là của từng nhà xe |
| G5 | Thẻ "Khiếu nại và tranh chấp" (Admin), hàng đợi "Tranh chấp đang mở" | Hiện "—" tới khi làm TRUST-001 |
| G6 | Trang Tổng quan nhà xe | Figma chưa có khung — AI tự bố cục theo thẻ chỉ số + bảng của màn Báo cáo |
| G7 | Kỳ mặc định | Nhà xe: đầu tháng tới hôm nay; Admin: 7 ngày gần nhất |
| G8 | Hiệu năng | Truy vấn trực tiếp (subquery theo chuyến) — đủ cho dữ liệu v1; cần bảng tổng hợp / materialized view khi dữ liệu lớn |

## Kiểm tra

- `reporting.int.spec.ts` 4 ca (Postgres + Redis thật): tổng / theo tuyến / nhân viên soát vé, lọc xe, kỳ trống, tenant khác không thấy, Admin gọi route nhà xe → 403; CSV (BOM, chặn công thức, audit, audit lỗi → 503); tổng quan nhà xe; báo cáo + tổng quan Admin lọc nhà xe / cổng, GMV theo ngày, escrow.
- `reporting.http.spec.ts` 2 ca: guard thật, tenant lấy từ token, khoảng ngày sai / quá 366 ngày → 400, header tệp CSV, Admin + Hỗ trợ xem báo cáo hệ thống, Owner bị chặn.
- Unit: `report-format` (Operator 3, Admin 3).
- E2E: `operator-os/e2e/reports.e2e.ts` (2), `admin/e2e/reports.e2e.ts` (2, tài khoản E2E riêng `platformReports`); sửa E2E cũ bị ảnh hưởng (`auth`, `payouts`, `policies` — chọn link chính xác, bỏ kiểm "Chưa có dữ liệu" đã lỗi thời từ khi màn Thanh toán / Chi trả có dữ liệu thật).
