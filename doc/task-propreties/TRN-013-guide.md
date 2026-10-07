# TASK-TRN-013 — Guide kiểm chứng: Màn Điểm dừng và màn Tuyến đường (Operator OS)

> Mục tiêu: chứng minh chủ nhà xe quản lý được điểm riêng, tra cứu danh mục dùng chung, gửi / theo dõi đề xuất, rồi lập tuyến từ các điểm đó ngay trên Operator OS.
> Phạm vi / giả định: `TRN-013-todo.md`. Checklist nghiệm thu: `TRN-013-verification-checklist.md`.

## 0. Gate trước khi chạy

- [ ] `pnpm install` xong; đang ở nhánh `TASK-TRN-013`.
- [ ] Postgres 16 + Redis 7 + Mongo 7 chạy ([RB-05](../runbook/RB-05-local-infra.md)); database đã `prisma:migrate:deploy` + `db:app-role`.
- [ ] Catalog đã seed để có tỉnh / phường: `pnpm --filter @vexenhanh/api run db:seed:catalog -- --with-samples` (thêm `--with-samples` để tab Dùng chung có vài bến xe mẫu; chỉ dùng ở máy dev).
- [ ] API chạy ở `http://localhost:3000`, Operator OS ở `http://localhost:3002` (xem `IAM-006-guide.md` §3).

## 1. Test đơn vị

```powershell
pnpm --filter @vexenhanh/operator-os test
pnpm --filter @vexenhanh/operator-os run typecheck
pnpm --filter @vexenhanh/operator-os run lint
```

Phần của task: `lib/stop-point/*.test.ts` và `lib/route/*.test.ts`.

Phần API (danh sách tuyến trả tên điểm đầu / điểm cuối), cần database thật:

```powershell
$env:REQUIRE_DB_TESTS = "1"
pnpm --filter @vexenhanh/api exec vitest run src/route
```

## 2. E2E

```powershell
$env:PLAYWRIGHT_CHANNEL = "chrome"
pnpm --filter @vexenhanh/operator-os exec playwright test e2e/stop-points.e2e.ts
```

File này chạy cả luồng điểm dừng lẫn luồng lập tuyến trong một phiên đăng nhập. Cần `MIGRATION_DATABASE_URL` trỏ database local để script seed tài khoản E2E chạy được.

Hai tình huống của máy chủ dev, không phải lỗi của màn hình:

- Lần đầu mở một trang, Next phải biên dịch trang đó nên có thể chậm; ca của màn phương tiện có thể quá thời gian chờ ở lần chạy đầu — chạy lại.
- Mọi trang (trừ trang chủ) báo "không tìm thấy trang": bộ nhớ đệm dev của Next bị hỏng sau một lần tắt đột ngột. Tắt máy chủ dev, xóa thư mục `apps/operator-os/.next/dev`, bật lại.

## 3. Kiểm tay trên trình duyệt

Đăng nhập bằng tài khoản chủ nhà xe, mở mục **Điểm dừng**.

| Thao tác | Kết quả |
| --- | --- |
| Bấm "Thêm điểm dừng", bấm Lưu khi còn trống | Lỗi hiện ngay dưới từng ô, không có request ghi |
| Mở ô "Loại điểm" | Chỉ có Văn phòng trung chuyển, Trạm dừng nghỉ |
| Lưu điểm hợp lệ | Hộp thoại đóng, dòng báo xanh, điểm hiện trong bảng với "Chưa dùng" |
| Gõ không dấu vào ô tìm (vd `van phong`) | Vẫn ra điểm có dấu |
| Thêm điểm trùng tên | Báo "Tên điểm dừng đã tồn tại trong nhà xe." tại ô tên, dữ liệu đã nhập còn nguyên |
| Bấm Sửa, đổi trạng thái sang Ngừng dùng | Nhãn trên dòng đổi theo |
| Tab Dùng chung | URL thành `?tab=shared`; bảng danh mục không có nút sửa |
| "Đề xuất điểm dừng", thiếu căn cứ công bố | Báo "Nhập căn cứ công bố." |
| Gửi đề xuất hợp lệ | Dòng mới ở bảng đề xuất, nhãn "Chờ duyệt", không có nút sửa |

Hai trạng thái do Admin tạo ra chưa có giao diện (`TASK-ADM-004`), thử bằng SQL với tài khoản chủ database, chạy cả khối một lần:

```sql
BEGIN;
SELECT set_config('app.scope', 'platform', true);
-- Khóa một điểm riêng
UPDATE stop_points SET status = 'SUSPENDED', suspension_reason = 'Tọa độ lệch khỏi vị trí thực tế.' WHERE name = '<tên điểm>';
-- Từ chối một đề xuất
UPDATE stop_point_proposals SET status = 'REJECTED', rejection_reason = 'Chưa có văn bản công bố.' WHERE name = '<tên đề xuất>';
COMMIT;
```

Tải lại trang: điểm bị khóa hiện nhãn "Bị khóa" kèm lý do và không có nút Sửa; đề xuất bị từ chối hiện lý do và nút "Sửa và gửi lại", gửi lại xong về "Chờ duyệt".

## 4. Kiểm tay màn Tuyến đường

Cần ít nhất hai điểm dừng đang hoạt động (điểm riêng hoặc bến xe mẫu trong danh mục). Mở mục **Tuyến đường**.

| Thao tác | Kết quả |
| --- | --- |
| "Thêm tuyến", bấm Lưu khi còn trống | Báo "Nhập tên tuyến." tại ô tên và "Tuyến cần ít nhất 2 điểm dừng." ở danh sách điểm |
| Bấm "Thêm điểm dừng" | Bảng chọn mở ngay dưới danh sách, không có nền mờ; form bên cạnh vẫn dùng được |
| Bấm "Thêm" ở vài điểm | Điểm vào cuối danh sách; dòng trong bảng chọn chuyển sang "Đã thêm" |
| Xem công tắc | Điểm đầu: chỉ đón, khóa. Điểm cuối: chỉ trả, khóa. Trạm dừng nghỉ: tắt cả hai, khóa. Điểm giữa: bật / tắt được |
| Để trạm dừng nghỉ đứng đầu hoặc cuối rồi Lưu | Báo lỗi, không gửi request; đổi thứ tự bằng nút mũi tên thì lưu được |
| Tắt cả hai công tắc của một điểm giữa rồi Lưu | Báo đích danh điểm đó |
| Hai đầu không phải bến xe | Có cảnh báo màu vàng, vẫn lưu được |
| Lưu tuyến hợp lệ | Chuyển sang trang Chỉnh sửa, có dòng "Đã lưu tuyến"; giữa các điểm hiện quãng đường và thời gian; thẻ Tổng quan có tổng |
| Đổi thứ tự hai điểm ở trang Chỉnh sửa | Chặng liên quan và tổng hiện "Tính khi lưu"; bấm Hủy thì được hỏi lại |
| Tạo tuyến trùng tên | Báo "Tên tuyến đã tồn tại trong nhà xe." tại ô tên, danh sách điểm còn nguyên |
| Về danh sách tuyến | Dòng tuyến có điểm đầu, điểm cuối, số điểm, quãng đường, thời gian |
| Về mục Điểm dừng | Điểm vừa dùng hiện "1 tuyến" |

Máy chưa đặt `GOONG_API_KEY` thì quãng đường là ước lượng đường chim bay; danh sách ghi "Ước lượng" dưới con số.

## Lưu ý phạm vi

- Không tick checklist nếu chưa có evidence.
- Không tự promote tài liệu SDLC sang Approved.
- Bản đồ chưa có ở task này; đừng báo thiếu bản đồ là lỗi cho tới khi làm `TASK-TRN-014`.
