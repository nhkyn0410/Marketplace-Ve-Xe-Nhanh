# Vé Xe Nhanh — giao diện nhân viên / tài xế

Giao diện Flutter theo [thiết kế Figma](https://www.figma.com/design/6c81q3DdHVS0anfDw2sVVj/UI-UX?node-id=1611-981).

## Chạy trong VS Code trên máy này

1. Mở folder `D:\Marketplace-Ve-Xe-Nhanh`.
2. Chọn **Run and Debug → Tài xế - Chrome**, nhấn **F5**.
3. Nhập tên mẫu `mayexpress/nv.minh` và mật khẩu mẫu bất kỳ.
4. Kéo nút màu cam sang phải để đăng nhập, sau đó chọn **Mở bản xem thử**.

VS Code được cấu hình cục bộ dùng Flutter **3.47.2** trong `.tools/flutter`.
SDK và cấu hình máy không được commit. Trên máy khác, cài SDK theo `.fvmrc` của repo.

Hoặc chạy từ PowerShell:

```powershell
cd D:\Marketplace-Ve-Xe-Nhanh\apps\employee_mobile
..\..\.tools\flutter\bin\flutter.bat pub get
..\..\.tools\flutter\bin\flutter.bat run -d chrome
```

Để chạy trên Android/iOS, chọn thiết bị trong VS Code rồi dùng cấu hình
**Tài xế - Android/iOS**. Chưa xác minh bản build Android/iOS trong lượt triển khai này.

## Các màn đã có

- Đăng nhập nhân viên, liên hệ nhà xe.
- Chuyến của tôi, đổi ngày, chi tiết chuyến, ngày không có nhiệm vụ.
- Hành khách: tìm theo tên/mã vé/số đã che, lọc trạng thái, kéo làm mới.
- Quét QR → Đã lên xe → Sơ đồ 36 ghế → Quét vé tiếp; đã bỏ màn nhập mã và bước đối chiếu cũ theo Figma mới.
- Vận hành chuyến, ghi và xem nhật trình, biểu mẫu báo sự cố.
- Cá nhân, chế độ sáng/tối, thiết bị đăng nhập, đăng xuất.

## Bản thiết kế cập nhật

Đối chiếu Figma tại [Giao diện Tài Xế](https://www.figma.com/design/6c81q3DdHVS0anfDw2sVVj/UI-UX?node-id=1484-3742):

- Kết quả vé: không tìm thấy, sai chuyến, đã hủy, hoàn tiền; màn lên xe thành công với tiến độ động.
- Cập nhật khách: chưa lên, vắng mặt sau khi bắt đầu đón, cần xử lý và ghi chú cục bộ.
- Vận hành: chờ cập nhật, lỗi/thử lại, hoàn thành và lịch sử được giữ trong phiên.
- Nhật trình: điểm dừng, kiểm tra xe, lỗi lưu và danh sách chưa đồng bộ. Không báo đã đồng bộ khi chưa có API.
- Chi tiết nhật trình: có trạng thái tải lỗi, thử lại và khóa thao tác trong lúc tải; không tạo bản ghi giả nếu vẫn chưa có dữ liệu.
- Thiết bị: xác nhận trước khi kết thúc phiên mẫu, hủy xác nhận và trạng thái chỉ còn thiết bị hiện tại.
- Chuyến/hành khách: giao diện tải, lỗi, trống, không tìm thấy và ngoài phạm vi phân công.

Mã vé thử trên chuyến MX102: `VX102001` (hợp lệ), `VX10200X` (không tìm thấy), `VX103001` (sai chuyến), `VX102CANCEL` (đã hủy), `VX102REFUND` (hoàn tiền). Đây là dữ liệu kiểm tra giao diện, không phải vé thật.

Trang đối chiếu riêng cho các trạng thái khó gặp:

```powershell
..\..\.tools\flutter\bin\flutter.bat run -d chrome -t lib/preview_gallery.dart
```

Trang này không nằm trong điều hướng ứng dụng chính. Có màn Quét QR tĩnh để đối chiếu thiết kế và sơ đồ ghế với dữ liệu mẫu. Trong app chính, camera đọc QR qua `mobile_scanner`; API, email và thu hồi phiên máy chủ chưa được tích hợp.

Thao tác xác nhận dùng **vuốt sang phải** trên tay kéo màu cam.
Theo yêu cầu giao diện, không hiển thị dòng hướng dẫn vuốt ở chân màn hình hoặc dưới nút; áp dụng cả cho các màn thêm sau.
Dữ liệu chuyến mẫu nằm ở ngày **14/10/2026**; đổi sang ngày khác sẽ hiện trạng thái trống.

## Phạm vi bản minh họa

Đây là giao diện dùng dữ liệu mẫu, **chưa kết nối API hoặc xác thực tài khoản thật**.
Không nhập mật khẩu thật. Mật khẩu mẫu không được lưu hoặc gửi đi.
Thay đổi hành khách, trạng thái chuyến và nhật trình chỉ tồn tại trong phiên;
lịch sử cập nhật trạng thái được giữ khi mở lại màn Vận hành trong cùng phiên.
Camera cần được cấp quyền trên thiết bị hoặc trình duyệt; đèn pin và đổi camera tùy khả năng thiết bị. Chưa xác minh bằng camera điện thoại thật. QR mẫu chỉ chứa mã vé như `VX102001`; kết quả được đối chiếu và cập nhật cục bộ, không xác thực vé thật. Email, thu hồi phiên và ảnh minh chứng hiện là thao tác minh họa.
Số điện thoại hành khách chỉ chứa dữ liệu đã che.

SVG được tải từ Figma vào `assets/figma`; font Inter và giấy phép ở `assets/fonts`.
Ứng dụng không tải ảnh từ URL Figma tạm thời khi chạy.

## Kiểm tra

```powershell
..\..\.tools\flutter\bin\flutter.bat analyze
..\..\.tools\flutter\bin\flutter.bat test
..\..\.tools\flutter\bin\flutter.bat build web --no-web-resources-cdn
```

Chưa thực hiện review độc lập bằng `code-reviewer` / `security-auditor`;
theo `CLAUDE.md`, các bước đó chỉ chạy khi người phụ trách yêu cầu rõ.
