# TASK-TRN-014 — Todo: Bản đồ Goong trên web (Operator OS)

> **Nguồn task:** `doc/SDLC/11-project-task-breakdown.md` §7.3 — thư viện bản đồ + khóa Maptiles, bấm / kéo ghim lấy tọa độ trong hộp thoại điểm dừng, bản đồ tổng quan đóng mở ở màn Điểm dừng, bản đồ lộ trình trong form tuyến; hiển thị đúng Hoàng Sa / Trường Sa. Nguồn chi tiết: ADR-027, UI §7.
> **Thiết kế:** Figma `Section 4` ([node 1305:6710](https://www.figma.com/design/6c81q3DdHVS0anfDw2sVVj/UI-UX?node-id=1305-6710)) — khung `1311:6903`, `1312:7194`, `1313:7460`, `1313:7611`, `1321:8486`, `1330:9560`; thành phần `VXN / Map marker`, `VXN / Map stop marker`.
> **Dependency:** `TASK-TRN-013` (hai màn đã merge, PR #28).
> **Mở khóa:** `TASK-ADM-004` (hộp thoại điểm dừng của Admin dùng lại bản đồ chọn tọa độ).
> **Cách dùng:** lệnh kiểm chứng ở `TRN-014-guide.md`; nghiệm thu ở `TRN-014-verification-checklist.md`.

## Trạng thái (07/10/2026) — 🔨 **CODE XONG, ĐÃ KIỂM VỚI BẢN ĐỒ GOONG THẬT**

- ✅ Nhánh `TASK-TRN-014` tạo từ `develop` (`02bfb93`) ngày 07/10/2026.
- ✅ Ba bản đồ trên Operator OS: code, test đơn vị, E2E xong; số đo ở checklist.
- ✅ **Đã kiểm với bản đồ Goong thật** (07/10/2026, khóa Maptiles của Khanh): bản đồ lên ở cả ba chỗ, mọi yêu cầu chỉ tới `tiles.goong.io`, vùng Hoàng Sa / Trường Sa mang nhãn tiếng Việt — chi tiết ở checklist PHẦN A. E2E vẫn dùng bản đồ nền trống thay chỗ để không gọi ra ngoài.
- ✅ Khanh xác nhận dùng MapLibre (07/10/2026).
- ⏳ Chờ Khanh: xem ảnh Hoàng Sa / Trường Sa, review diff (chưa commit).

---

## Quyết định của Khanh (07/10/2026)

1. **Thư viện vẽ bản đồ:** được hỏi chọn `maplibre-gl` hay `@goongmaps/goong-js` (theo ADR-027), Khanh trả lời _"Sử dụng lựa chọn tôn trọng chủ quyền"_. AI áp dụng thành: dùng **MapLibre GL JS với bản đồ nền Goong**, vì cả hai thư viện cùng tải một bản đồ nền từ máy chủ Goong (cùng địa chỉ, cùng khóa) nên phần chủ quyền không phụ thuộc thư viện vẽ; chọn bên còn được bảo trì và có kiểu TypeScript. **Khanh xác nhận dùng MapLibre ngày 07/10/2026**, sau khi kiểm với bản đồ Goong thật. Hệ quả kèm theo: không bao giờ dùng nguồn bản đồ nền khác thay Goong; việc nhìn tận mắt Hoàng Sa / Trường Sa là một mục nghiệm thu bắt buộc.
2. **Chấm xám trên bản đồ lộ trình:** giữ. Khi bảng chọn điểm dừng mở, các điểm trong bảng hiện bằng chấm xám; rê chuột vào một dòng thì chấm đó nổi lên kèm nhãn.

## Phạm vi

### Đã làm

- **Bản đồ dùng chung** trong `packages/ui`: `MapView` (bản đồ nền Goong), `MapMarker` (ghim, kéo được), `MapPopup` (thẻ nổi, tự chọn phía để không bị mép bản đồ cắt), `MapLine` (đường nối) và các hàm thuần ở `lib/map.ts`. App khác dùng lại được.
- **Bản đồ tổng quan** ở màn Điểm dừng, cả hai tab: khối đóng mở nằm trên bảng, ghim tô màu theo loại điểm, bấm ghim xem nhanh, bấm một dòng thì bản đồ chuyển tới điểm đó.
- **Bản đồ chọn vị trí** trong hộp thoại Thêm / Sửa điểm dừng và Đề xuất điểm dừng: bấm bản đồ để đặt ghim, kéo ghim để chỉnh, hai ô vĩ độ / kinh độ vẫn gõ tay được.
- **Bản đồ lộ trình** trong form tuyến: ghim đánh số theo thứ tự, đường thẳng nét đứt nối các điểm, chấm xám cho điểm đang nằm trong bảng chọn.
- File mẫu biến môi trường `apps/operator-os/.env.example`.

### Không làm ở task này

- Hộp thoại điểm dừng của Admin → `TASK-ADM-004` (màn Admin chưa có). Thành phần bản đồ đã đặt ở chỗ dùng lại được.
- Tìm địa chỉ để bản đồ nhảy tới (Goong Geocoding / Autocomplete) — không nằm trong mô tả task.
- Vẽ đường đi thực tế giữa các điểm: hệ thống chỉ lưu quãng đường và thời gian từng chặng, không lưu hình dạng đường.
- Bản đồ ở Marketplace và app mobile.

---

## Giả định hiện thực (AI đặt — Khanh phản đối thì sửa)

- **C1 — Khóa bản đồ:** biến `NEXT_PUBLIC_GOONG_MAPTILES_KEY` (khóa hiển thị, công khai phía trình duyệt; khác `GOONG_API_KEY` của API), đặt ở `apps/operator-os/.env.local` hoặc `.env` — cả hai đều không được commit. Bỏ trống thì mọi khối bản đồ ẩn đi, hộp thoại một cột và tọa độ nhập tay như trước task này.
- **C2 — Không có nguồn bản đồ dự phòng:** tải bản đồ nền lỗi thì hiện "Không tải được bản đồ" kèm nút Thử lại; không vẽ ghim trên nền trống và không chuyển sang nguồn khác. Phần còn lại của trang vẫn dùng được.
- **C3 — Thư viện chỉ tải khi mở bản đồ lần đầu** (khoảng 1 MB), nên trang không mở bản đồ không bị nặng thêm.
- **C4 — Mở / thu gọn:** bản đồ tổng quan mặc định thu gọn; bản đồ lộ trình mặc định mở (như Figma). Lựa chọn được nhớ theo trình duyệt, mỗi bản đồ nhớ riêng; hai tab của màn Điểm dừng dùng chung một lựa chọn.
- **C5 — Khung nhìn mặc định** là toàn lãnh thổ Việt Nam, gồm cả Hoàng Sa và Trường Sa.
- **C6 — Cuộn chuột:** bản đồ nằm trong trang cuộn (tổng quan, lộ trình) phải giữ Ctrl mới phóng to bằng con lăn, để cuộn trang không bị bản đồ giữ lại. Bản đồ trong hộp thoại phóng tự do.
- **C7 — Bấm ghim và bấm dòng khác nhau:** bấm ghim giữ mức phóng đang xem và đưa điểm về giữa; bấm một dòng của bảng thì phóng tới gần, tô nền dòng đó và cuộn bản đồ vào tầm nhìn. Khi bản đồ mở, tên điểm trong bảng là một nút để dùng bàn phím cũng làm được.
- **C8 — Tọa độ lấy từ bản đồ làm tròn 6 chữ số thập phân** (khoảng 0,1 m).
- **C9 — Gõ tọa độ bằng tay** thì ghim nhảy theo và bản đồ chuyển tới đó.
- **C10 — Bản đồ lộ trình:** trạm dừng nghỉ màu vàng; khi bảng chọn đang mở, khung nhìn bao cả các điểm trong bảng để chấm xám không nằm ngoài bản đồ.
- **C11 — Bản đồ luôn hướng bắc**, không xoay và không nghiêng.
- **C12 — E2E không gọi ra Goong:** bản đồ nền được thay bằng nền trống, Playwright tự đặt một khóa giả khi bật máy chủ dev.

## Khác với Figma (có chủ đích)

- **Số trên ghim trạm dừng nghỉ dùng chữ đậm màu tối**, Figma dùng chữ trắng trên nền vàng — chữ trắng quá khó đọc.
- **Dòng gợi ý "Bấm hoặc kéo ghim để chọn vị trí" nằm góc dưới trái**, Figma đặt giữa cạnh dưới — ở giữa thì đè lên dòng ghi nguồn bản đồ.
- **Nút phóng to / thu nhỏ là của thư viện, dòng "© Goong Maps" lấy từ bản đồ nền của Goong**; hình dáng hơi khác bản vẽ.

## Sửa ngoài ba bản đồ

- **`apps/operator-os/lib/auth/api-client.ts`:** biến `NEXT_PUBLIC_API_BASE_URL` để trống giờ được coi như chưa đặt. Trước đó giá trị trống làm web gọi API vào chính nó (không đăng nhập được) — lộ ra khi Khanh chép `.env.example` của task này thành `.env`.

## Bàn giao cho task sau

- **`TASK-ADM-004`:** dùng `MapView` / `MapMarker` / `MapPopup` của `packages/ui`; bản đồ chọn vị trí (`apps/operator-os/components/map/location-picker-map.tsx`) chuyển lên `packages/ui` khi Admin cần.
- **Security §11 (CSP đầy đủ):** bản đồ cần `worker-src 'self'`, `connect-src` tới `tiles.goong.io` (và các tên miền con Goong mà bản đồ nền tham chiếu), `img-src data: blob:`.
- **Giới hạn khóa theo tên miền:** Operator OS đang gửi `Referrer-Policy: no-referrer`. Nếu Goong kiểm tên miền bằng referrer thì bật giới hạn sẽ làm bản đồ bị chặn — phải thử trước khi bật ở production.
- **Khóa API của Goong chưa đặt** (`GOONG_API_KEY` ở `apps/api/.env`): quãng đường tuyến vẫn là ước lượng đường chim bay. Khóa này khác khóa Maptiles.
- **Kích thước bản build:** bundler chép toàn bộ file của thư viện vào thư mục tĩnh (khoảng 5 MB trên đĩa). Trình duyệt chỉ tải phần cần dùng.
