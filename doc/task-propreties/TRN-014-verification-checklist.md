# TASK-TRN-014 — Checklist nghiệm thu: Bản đồ Goong trên web (Operator OS)

> Mục tiêu: ba bản đồ của màn Điểm dừng và màn Tuyến đường chạy đúng trên bản đồ nền Goong, hiển thị đủ Hoàng Sa / Trường Sa.
> Chỉ tick `[x]` khi có evidence. Lệnh: `TRN-014-guide.md`. Phạm vi: `TRN-014-todo.md`.

## Snapshot trạng thái (07/10/2026)

- [x] Nhánh `TASK-TRN-014` từ `develop`; tạo bộ ba todo / guide / checklist.
- [x] Code, test đơn vị, E2E xong; đo trên máy dev với Postgres 16, Redis 7, Mongo 7 chạy bằng container tạm.
- [x] **Kiểm với bản đồ Goong thật** — 07/10/2026, bằng khóa Maptiles Khanh đặt ở `apps/operator-os/.env` (PHẦN A). Các mục ở PHẦN B–E ghi "E2E" vẫn đo trên bản đồ nền trống thay chỗ.
- [x] Khanh xác nhận thư viện vẽ bản đồ: MapLibre GL JS + bản đồ nền Goong (07/10/2026).
- [ ] Khanh xem ảnh Hoàng Sa / Trường Sa và chấp nhận (việc đánh giá đúng luật là của Khanh).
- [ ] Khanh review diff → commit → CI xanh.

## PHẦN A — Bản đồ thật và chủ quyền (đo bằng khóa Goong thật, 07/10/2026)

- [x] Bản đồ Goong hiện đúng ở cả ba chỗ: đường phố, nhãn địa danh tiếng Việt, ghim nằm đúng vị trí (Sài Gòn, Bảo Lộc, Đà Lạt) — ảnh chụp.
- [x] Vùng Hoàng Sa và Trường Sa: nhãn "Quần đảo Hoàng Sa", "Quần đảo Trường Sa", "Biển Đông" bằng tiếng Việt; các đảo mang tên tiếng Việt (Đảo Phú Lâm, Đảo Linh Côn, Đảo Đá Tây…). Trong các khung đã chụp (mức phóng 5 → 11) không thấy tên nước khác hay tên tiếng nước ngoài gắn với hai quần đảo — ảnh chụp.
- [x] Mọi yêu cầu ra ngoài của ba bản đồ chỉ tới `tiles.goong.io` (244 phản hồi, tất cả 200): bản đồ nền, ô bản đồ, phông chữ, biểu tượng.
- [x] Dòng ghi nguồn bản đồ không bị lặp: lần đo đầu hiện "© Goong | © Goong Maps" (code tự thêm một lần) → đã bỏ phần tự thêm, còn "© Goong Maps" của Goong.
- [x] Cuộn chuột trên bản đồ tổng quan: trang cuộn bình thường và hiện lời nhắc "Giữ Ctrl và cuộn để phóng to bản đồ"; giữ Ctrl thì bản đồ phóng to.
- [x] Khung nhìn mặc định bao cả Hoàng Sa và Trường Sa (test đơn vị trên tọa độ khung nhìn).
- [x] Code chỉ có một địa chỉ bản đồ nền, trỏ tới `tiles.goong.io`; không có nguồn dự phòng (test đơn vị + kiểm request trên trình duyệt).

Lỗi lộ ra khi dùng khóa thật, đã sửa: file `.env` chép từ `.env.example` có dòng `NEXT_PUBLIC_API_BASE_URL=` để trống, code coi đó là một địa chỉ thật nên web gọi API vào chính nó và không đăng nhập được. Giờ giá trị trống được coi như chưa đặt.

## PHẦN B — Bản đồ tổng quan ở màn Điểm dừng

- [x] Mặc định thu gọn; khi thu gọn không tải thư viện và không gọi bản đồ nền (kiểm request trên trình duyệt).
- [x] Mở ra: mỗi dòng của bảng một ghim; đổi từ khoá thì số ghim đổi theo (E2E).
- [x] Bấm ghim: thẻ xem nhanh có tên, địa chỉ, loại điểm; điểm ngừng dùng ghi rõ trạng thái (E2E).
- [x] Bấm một dòng: thẻ của đúng điểm đó, dòng được tô nền; bấm nút Sửa trong dòng không đổi điểm đang chọn (E2E).
- [x] Dùng bàn phím: tên điểm là nút khi bản đồ mở (E2E).
- [x] Nhớ lựa chọn mở / thu gọn sau khi tải lại trang (E2E).
- [x] Tab Dùng chung có cùng khối bản đồ với chú giải riêng (ảnh chụp).

## PHẦN C — Bản đồ chọn vị trí trong hộp thoại

- [x] Bấm bản đồ điền hai ô tọa độ, tối đa 6 chữ số thập phân; bấm chỗ khác thì đổi theo (E2E).
- [x] Kéo ghim đổi tọa độ (kiểm trên trình duyệt).
- [x] Gõ tay tọa độ, kể cả dấu phẩy thập phân: ghim và bản đồ chuyển theo (kiểm trên trình duyệt + test đơn vị).
- [x] Lưu được điểm với tọa độ chọn trên bản đồ; mở lại để sửa thì tọa độ đúng như đã chọn (E2E).
- [x] Hộp thoại Đề xuất điểm dừng có cùng bản đồ (ảnh chụp).

## PHẦN D — Bản đồ lộ trình trong form tuyến

- [x] Ghim đánh số theo thứ tự điểm dừng, tên ghim khớp tên điểm (E2E).
- [x] Thêm, đổi chỗ, bỏ điểm: ghim đổi ngay (E2E).
- [x] Bảng chọn mở: điểm chưa thuộc tuyến hiện trên bản đồ, chú giải thêm "Điểm trong bảng chọn"; rê vào dòng thì có nhãn "Chưa có trong tuyến" (E2E).
- [x] Trạm dừng nghỉ màu vàng; đường nối nét đứt (ảnh chụp + test đơn vị).
- [x] Ẩn / hiện thẻ bản đồ (E2E).
- [x] Tọa độ trong form chỉ để vẽ bản đồ, không gửi lên API (test đơn vị).

## PHẦN E — Trạng thái lỗi và không có khóa

- [x] Không có khóa: không có khối bản đồ nào, hộp thoại một cột; 5 ca E2E của `TASK-TRN-013` vẫn đạt, 3 ca bản đồ tự bỏ qua kèm lý do.
- [x] Khóa sai: Goong thật trả 403 → "Không tải được bản đồ", không vẽ ghim trên nền trống, bảng vẫn dùng được; Thử lại tải được khi bản đồ nền sẵn sàng (kiểm trên trình duyệt — đây là lần duy nhất gọi tới Goong thật, bằng khóa giả).
- [x] Mất mạng tới Goong: cùng thông báo (chặn request trên trình duyệt).
- [x] Trình duyệt không có WebGL: "Trình duyệt này không hiển thị được bản đồ", trang không văng lỗi, tọa độ vẫn nhập tay được (Chrome tắt WebGL).

## PHẦN F — Chất lượng

- [x] Test đơn vị `packages/ui`: **2 file, 10 test pass** (7 test mới của bản đồ).
- [x] Test đơn vị Operator OS: **10 file, 172 test pass** (11 test mới).
- [x] E2E Operator OS: **16/16 pass** (3 ca mới), bản đồ nền trống thay chỗ; chạy cả khi máy chủ dev dùng khóa giả lẫn khóa thật.
- [x] `pnpm turbo run typecheck lint test`: 29/29 task pass. Test API cần database bị bỏ qua ở lượt này (162 test) — task không sửa API.
- [x] Bản build production: build đạt, có file `maplibre-gl-worker.*.mjs`; chạy thử `next start` thì bản đồ lên, thư viện chỉ tải khi mở bản đồ, không có lỗi do bản đồ trong console.
- [x] So với Figma `Section 4` ở độ rộng 1440 và 1024: bố cục, chữ, màu ghim khớp. Khác có chủ đích ghi ở todo.
- [ ] `code-reviewer` trước khi đóng task (DoD §6.3) — chưa chạy.

## Bàn giao cho task sau

- `TASK-ADM-004`: hộp thoại điểm dừng của Admin dùng lại bản đồ chọn vị trí.
- Security §11: thêm nguồn của bản đồ vào CSP khi viết CSP đầy đủ (todo, mục Bàn giao).
