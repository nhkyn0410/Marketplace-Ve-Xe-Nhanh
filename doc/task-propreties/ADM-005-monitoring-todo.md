# TASK-ADM-005 — Todo: Admin giám sát nhà xe, hành khách, tuyến, chuyến

> Khanh 28/10/2026: "phần quản lý nhà xe chỉ có thể xem (danh sách) · hành khách không xem được chi tiết · không thấy khác
> biệt Hành khách / Tài khoản thành viên · Admin không xem được tuyến (hiệu suất, tuyến phổ biến) và tất cả chuyến · điểm
> dừng không có bản đồ · Thanh toán và hoàn tiền nên đổi thành Giao dịch" → đề xuất → "Ok làm theo đề xuất". Căn cứ: SRS
> FR-ADM-02 (giám sát), FR-NSR-13 ("theo … tuyến, khu vực"), ma trận quyền SRS (Admin "Xem / giám sát toàn hệ thống" chi
> tiết chuyến, profile nhà xe, xe, booking / vé, báo cáo nhà xe).

## Trạng thái (28/10/2026) — 🔨 **Code xong, chưa commit — chờ Khanh review + CI**

Nhánh `feat/admin-improvements` (từ `develop`). Chưa qua `code-reviewer` / `security-auditor` (chỉ chạy khi Khanh yêu cầu).

## Đã làm

### Backend (`apps/api`) — không đổi DB, không thêm quyền

- `GET /admin/operators/{id}`, `/admin/operators/{id}/vehicles` (`operator/admin-operator.*`).
- `GET /admin/passengers/{id}` (audit `passenger.view`), `/admin/passengers/{id}/bookings` (`iam/user/admin-account.service.ts`).
- `GET /admin/routes`, `/admin/routes/{id}` (`route/admin-route.*`) — số liệu chung ở `reporting/route-performance.ts`.
- `GET /admin/trips`, `/admin/trips/{id}` (audit `trip.manifest.view`) (`trip/admin-trip.*`).
- `/admin/reports/summary` thêm `byRoute`, `byRegion`; `/admin/reports/export` thêm `group=operator|route|region`.
- `/admin/payments` `q` tìm thêm SĐT / email người đặt.
- `OpenApiModule` khai hai controller mới; sinh lại client TS (`packages/api-client`) + Dart (`packages/api_client_dart`).

### Admin (`apps/admin`)

- Menu **Tuyến & chuyến** (`/routes`, tab Tuyến đường / Chuyến xe), chi tiết tuyến `/routes/{id}` (bản đồ lộ trình), chi tiết
  chuyến `/routes/trips/{id}` (danh sách người đi).
- Chi tiết nhà xe `/operators/{id}` (thẻ 30 ngày, tab Thông tin / Tuyến / Chuyến / Đội xe / Nhân viên); bấm tên ở danh sách.
- Chi tiết tài khoản hành khách `/users/passengers/{id}`; tab **Tài khoản hành khách**; VXN Plus tab **Điểm thành viên**
  (`?email=`, liên kết "Xem hồ sơ hành khách").
- Báo cáo: khối Theo tuyến / Theo khu vực, ô "Kiểu tệp xuất".
- Điểm dừng: bản đồ tab Của nhà xe; dòng nhắc khi thiếu `NEXT_PUBLIC_GOONG_MAPTILES_KEY`.
- "Thanh toán & hoàn tiền" → **Giao dịch** (menu, tiêu đề, câu nhắc ở chi tiết tranh chấp, E2E).

## Chờ Khanh (G1–G10)

| # | Chủ đề | Đã chọn | Cần Khanh |
| --- | --- | --- | --- |
| G1 | Quyền | Mọi màn giám sát dùng `user:manage` (như mục Nhà xe); số tiền chỉ trả khi có thêm `payment:monitor`, thiếu thì `null` — không thêm quyền mới | Duyệt |
| G2 | Khách vãng lai | Không đưa vào danh sách tài khoản (không có tài khoản, không khóa được, gộp theo SĐT dễ nhầm); tra theo đơn: Giao dịch tìm SĐT / email người đặt, chi tiết chuyến có danh sách người đi | Duyệt |
| G3 | "Một vé = một hành khách" | **Khanh 28/10/2026: cần người thứ 2** → đã làm: chỗ đôi khai thêm họ tên người đi cùng (không bắt buộc, không SĐT), chung 1 vé / 1 QR (`BR-78` bổ sung, `TC-BOOK-004`) | Đã chốt |
| G4 | Dữ liệu cá nhân | SĐT che; mỗi lượt mở chi tiết hành khách / chuyến ghi audit, lỗi audit → 503; trang không giữ bộ nhớ đệm | Duyệt |
| G5 | Kỳ số liệu | Chi tiết nhà xe: 30 ngày gần nhất, chuyến đã khởi hành trong kỳ; tuyến: chọn kỳ, mặc định 30 ngày; chuyến: mặc định hôm nay + 6 ngày, tối đa 92 ngày | Duyệt |
| G6 | Doanh thu tuyến | = tổng giá vé đã bán của chuyến khởi hành trong kỳ (khác GMV theo giờ thanh toán ở báo cáo) | Duyệt |
| G7 | Tuyến phổ biến | = xếp theo vé bán; "khu vực" = cặp tỉnh điểm đầu → điểm cuối gộp mọi nhà xe (như trang chủ) | Duyệt |
| G8 | Phân trang tuyến | Theo vị trí, tính trên tối đa 2.000 tuyến khớp bộ lọc (xếp theo số liệu) — đủ cho v1 | Duyệt |
| G9 | Đổi tên | Giao dịch (giữ URL `/payments`), Tài khoản hành khách, Điểm thành viên — lệch tên Figma ADM-03a / ADM-07 / ADM-12b | Duyệt / cập nhật Figma |
| G10 | Phạm vi | Chỉ xem; chưa làm "khóa chuyến vi phạm" (ma trận quyền SRS có nhắc) | Có cần làm |

## Kiểm tra (28/10/2026)

- API: `admin-monitoring.int.spec.ts` 5/5 (Postgres + Redis thật, role app); toàn bộ test API 1784 pass — 3 test hết giờ
  khi chạy song song, chạy riêng pass.
- Admin: typecheck + lint sạch, Vitest 65/65; E2E `monitoring.e2e.ts` 4/4; E2E ảnh hưởng (payments, loyalty, stop-points,
  reports, operator-applications, users trừ một ca) pass.
- E2E lỗi **có sẵn, không do task này**: `users.e2e.ts` "tài khoản quản trị" (không tick quyền nào — IAM-007 bắt buộc ≥ 1),
  `policies.e2e.ts` "hoa hồng" (chữ "Hoa hồng mặc định" đã đổi từ commit bán vé tại quầy).
- Dart client: `dart analyze` 0 lỗi.

## Việc tiếp theo

- Production: đặt `NEXT_PUBLIC_GOONG_MAPTILES_KEY` cho Admin ở nơi deploy rồi build lại (biến đọc lúc build); khóa Goong có
  giới hạn domain thì thêm domain Admin.
- Figma: vẽ các màn mới nếu Khanh muốn giữ Figma là nguồn.
