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
- Khung quét QR, nhập mã vé, đối chiếu và xác nhận lên xe mẫu.
- Vận hành chuyến, ghi và xem nhật trình, biểu mẫu báo sự cố.
- Cá nhân, chế độ sáng/tối, thiết bị đăng nhập, đăng xuất.

Thao tác xác nhận dùng **vuốt sang phải** trên tay kéo màu cam.
Theo yêu cầu giao diện, không hiển thị dòng hướng dẫn vuốt ở chân màn hình hoặc dưới nút; áp dụng cả cho các màn thêm sau.
Dữ liệu chuyến mẫu nằm ở ngày **14/10/2026**; đổi sang ngày khác sẽ hiện trạng thái trống.

## Phạm vi bản minh họa

Đây là giao diện dùng dữ liệu mẫu, **chưa kết nối API hoặc xác thực tài khoản thật**.
Không nhập mật khẩu thật. Mật khẩu mẫu không được lưu hoặc gửi đi.
Thay đổi hành khách, trạng thái chuyến và nhật trình chỉ tồn tại trong phiên;
lịch sử cập nhật trạng thái giới hạn trong lần mở màn Vận hành.
Camera/đèn pin, email, thu hồi phiên và ảnh minh chứng hiện là thao tác minh họa.
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
