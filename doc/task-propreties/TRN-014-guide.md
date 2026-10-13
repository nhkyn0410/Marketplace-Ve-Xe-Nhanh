# TASK-TRN-014 — Guide kiểm chứng: Bản đồ Goong trên web (Operator OS)

> Mục tiêu: chứng minh ba bản đồ (tổng quan điểm dừng, chọn vị trí trong hộp thoại, lộ trình trong form tuyến) chạy đúng, và bản đồ nền là của Goong, hiển thị đủ Hoàng Sa / Trường Sa.
> Phạm vi / giả định: `TRN-014-todo.md`. Checklist nghiệm thu: `TRN-014-verification-checklist.md`.

## 0. Gate trước khi chạy

- [ ] `pnpm install` xong; đang ở nhánh `TASK-TRN-014`.
- [ ] Hạ tầng và dữ liệu như `TRN-013-guide.md` §0 (Postgres, Redis, Mongo, catalog đã seed, API ở cổng 3000).
- [ ] Có khóa **Goong Maptiles** (loại khóa hiển thị bản đồ, khác khóa API). Chép `apps/operator-os/.env.example` thành `apps/operator-os/.env.local` (hoặc `.env`), điền `NEXT_PUBLIC_GOONG_MAPTILES_KEY`, rồi **bật lại** máy chủ dev — biến `NEXT_PUBLIC_` chỉ được đọc lúc khởi động. Dòng `NEXT_PUBLIC_API_BASE_URL=` cứ để trống khi chạy ở máy.

Chưa có khóa thì vẫn chạy được §1 và §2; §3 và §4 cần khóa thật.

## 1. Test đơn vị

```powershell
pnpm --filter @vexenhanh/ui test
pnpm --filter @vexenhanh/operator-os test
pnpm --filter @vexenhanh/ui run typecheck
pnpm --filter @vexenhanh/operator-os run typecheck
pnpm --filter @vexenhanh/operator-os run lint
```

Phần của task: `packages/ui/src/lib/map.test.ts`, `apps/operator-os/lib/map/stop-map.test.ts`, và phần tọa độ trong `lib/route/route-form.test.ts`.

## 2. E2E

```powershell
$env:PLAYWRIGHT_CHANNEL = "chrome"
pnpm --filter @vexenhanh/operator-os exec playwright test e2e/stop-points.e2e.ts
```

Ba ca cuối file là của bản đồ. Các ca này **không gọi ra Goong**: bản đồ nền được thay bằng một nền trống, nên chỉ kiểm ghim, đường nối và thao tác.

- Playwright tự bật máy chủ dev thì nó đặt sẵn một khóa giả, ba ca bản đồ chạy.
- Đang có máy chủ dev chạy sẵn **không có khóa** thì ba ca bản đồ báo `skipped` kèm lý do. Kết quả đúng phải là `8 passed`; thấy `3 skipped` nghĩa là bản đồ chưa được kiểm.

## 3. Kiểm tay với bản đồ thật

Cần khóa thật. Đăng nhập bằng tài khoản chủ nhà xe.

### Màn Điểm dừng

| Thao tác | Kết quả |
| --- | --- |
| Mở mục Điểm dừng lần đầu | Khối "Bản đồ điểm dừng" thu gọn, có nút "Hiện bản đồ" |
| Bấm "Hiện bản đồ" | Bản đồ Goong hiện ra, mỗi dòng của bảng một ghim; màu ghim khớp chú giải |
| Bấm một ghim | Thẻ xem nhanh: tên, địa chỉ, loại điểm và số tuyến đang dùng; mức phóng giữ nguyên |
| Bấm một dòng của bảng | Bản đồ phóng tới điểm đó, dòng được tô nền |
| Gõ từ khoá hoặc đổi bộ lọc | Số ghim đổi theo đúng số dòng của bảng |
| Cuộn chuột khi con trỏ nằm trên bản đồ | Trang cuộn bình thường; giữ Ctrl mới phóng to bản đồ |
| Tải lại trang | Bản đồ vẫn mở (nhớ lựa chọn); bấm "Ẩn bản đồ" rồi tải lại thì vẫn thu gọn |
| Tab Dùng chung | Cùng khối bản đồ, ghim là bến xe / điểm dừng đón trả khách / trạm dừng nghỉ của danh mục |

### Hộp thoại điểm dừng

| Thao tác | Kết quả |
| --- | --- |
| Bấm "Thêm điểm dừng" | Hộp thoại hai cột; cột phải là bản đồ, dưới bản đồ là hai ô vĩ độ / kinh độ |
| Bấm một chỗ trên bản đồ | Ghim hiện tại đó, hai ô tọa độ được điền (tối đa 6 chữ số thập phân) |
| Kéo ghim sang chỗ khác | Hai ô tọa độ đổi theo |
| Gõ tọa độ bằng tay (vd `10,7626` và `106.6602`) | Ghim nhảy tới đó, bản đồ chuyển theo |
| Lưu rồi bấm Sửa điểm vừa tạo | Ghim nằm đúng vị trí đã lưu |
| "Đề xuất điểm dừng" ở tab Dùng chung | Cùng bản đồ chọn vị trí |

### Form tuyến

| Thao tác | Kết quả |
| --- | --- |
| Mở Thêm tuyến hoặc Chỉnh sửa tuyến | Thẻ "Lộ trình trên bản đồ" nằm giữa thẻ Thông tin tuyến và thẻ Tổng quan |
| Thêm điểm dừng | Ghim đánh số theo thứ tự, nối bằng đường nét đứt; trạm dừng nghỉ màu vàng |
| Đổi thứ tự hoặc bỏ một điểm | Số trên ghim và đường nối đổi ngay |
| Mở bảng chọn điểm dừng | Điểm trong bảng chưa thuộc tuyến hiện bằng chấm xám; chú giải có thêm "Điểm trong bảng chọn" |
| Rê chuột vào một dòng của bảng chọn | Chấm của điểm đó nổi lên kèm nhãn "Chưa có trong tuyến" |
| Bấm "Ẩn bản đồ" | Thẻ thu lại; tải lại trang vẫn thu gọn |

## 4. Kiểm chủ quyền (bắt buộc trước khi đóng task)

ADR-027 yêu cầu bản đồ hiển thị Hoàng Sa và Trường Sa thuộc Việt Nam.

1. Mở bản đồ tổng quan khi bảng chưa có điểm nào (hoặc lọc ra kết quả rỗng): khung nhìn mặc định là toàn Việt Nam.
2. Kéo ra Biển Đông, phóng to tới khi thấy nhãn. Kiểm: có **quần đảo Hoàng Sa** và **quần đảo Trường Sa**, tên bằng tiếng Việt, không gắn với tên nước khác; không có đường ranh giới nào tách hai quần đảo khỏi Việt Nam.
3. Chụp màn hình cả hai vị trí, đính vào PR.
4. Mở công cụ của trình duyệt, tab Network, lọc theo "goong": mọi yêu cầu bản đồ nền đều tới `tiles.goong.io` (hoặc tên miền con khác của Goong); không có yêu cầu tới nhà cung cấp bản đồ khác.

Thấy sai ở bước 2 hoặc 4 thì **không merge** — báo Khanh.

## 5. Tình huống lỗi

| Tình huống | Cách tạo | Kết quả |
| --- | --- | --- |
| Không có khóa | Xóa dòng khóa khỏi `.env.local`, bật lại máy chủ dev | Không còn khối bản đồ nào; hộp thoại một cột, tọa độ nhập tay |
| Khóa sai | Đặt khóa bất kỳ | "Không tải được bản đồ" kèm nút Thử lại; bảng và form vẫn dùng được |
| Mất mạng tới Goong | Chặn `tiles.goong.io` trong công cụ của trình duyệt | Như trên; bỏ chặn rồi bấm Thử lại thì bản đồ lên |
| Trình duyệt không có WebGL | Chạy Chrome với `--disable-gpu --disable-webgl --disable-webgl2` | "Trình duyệt này không hiển thị được bản đồ"; tọa độ vẫn nhập tay được |

## 6. Bản build production

```powershell
pnpm --filter @vexenhanh/operator-os build
```

Trong `apps/operator-os/.next/static/media/` phải có file `maplibre-gl-worker.*.mjs`. Chạy thử bản build ở máy cần thêm `NEXT_PUBLIC_API_BASE_URL=http://localhost:3000/v1` vào `.env.local` trước khi build, vì bản production mặc định gọi API cùng tên miền.

## Lưu ý phạm vi

- Không tick mục "bản đồ thật" trong checklist nếu chỉ mới chạy E2E — E2E dùng nền trống.
- Không tự promote tài liệu SDLC sang Approved.
- Hộp thoại điểm dừng của Admin chưa có bản đồ vì màn đó thuộc `TASK-ADM-004`.
