# Hướng dẫn: tạo tài khoản quản trị đầu tiên trên production

> **Vì sao cần:** tài khoản quản trị chỉ tạo được bởi một quản trị viên khác (Admin → Người dùng → Tài khoản quản trị), còn `pnpm db:seed` bị chặn ở production vì nó đặt lại mật khẩu. Production mới dựng chưa có ai → dùng lệnh `db:create-first-admin` **một lần**.
> **An toàn:** lệnh tự từ chối khi DB đã có quản trị viên dùng được, không sửa tài khoản đã có, mật khẩu tạm ngẫu nhiên chỉ hiện một lần, ghi audit `iam.platform_account.bootstrap` (Mongo lỗi thì không tạo gì).

## Cần có trước

1. DB production đã migrate (`prisma migrate deploy` + `db:app-role`, [RB-02](../runbook/RB-02-prisma-migration.md)).
2. Tệp `apps/api/.env.production` (đã `.gitignore`) có **`MIGRATION_DATABASE_URL`** (role owner) và **`MONGODB_AUDIT_URI`**.
3. Máy đang chạy lệnh kết nối được tới DB production (Supabase) và Mongo Atlas — nếu Atlas giới hạn IP: Atlas → **Network Access** → thêm IP hiện tại (xóa lại sau khi xong).
4. Một email nội bộ của anh (dùng khi cần cấp lại mật khẩu / đặt lại xác thực hai lớp).

## Chạy

Từ thư mục gốc repo:

```powershell
pnpm --filter @vexenhanh/api db:create-first-admin --env-file .env.production --username khanh --email <email-cua-anh>
```

- `--env-file` tính từ `apps/api`. Tên đăng nhập: 3–40 ký tự chữ thường, số, `.`, `_`, `-` (đăng nhập bằng `platform/<tên>`).
- Kết quả in ra **tên đăng nhập, mật khẩu tạm, giờ hết hạn (24 giờ)**. Chép mật khẩu tạm vào trình quản lý mật khẩu rồi xóa màn hình terminal (`Clear-Host`). Không gửi qua chat.

## Đăng nhập lần đầu

1. Mở trang Admin production → đăng nhập `platform/<tên>` + mật khẩu tạm.
2. Đặt mật khẩu mới (bắt buộc).
3. Bật xác thực hai lớp (TOTP — bắt buộc với quản trị viên) và **lưu mã dự phòng**.
4. Thêm ngay **một quản trị viên thứ hai** qua Admin → Người dùng → Tài khoản quản trị: nếu người duy nhất quên mật khẩu / mất thiết bị TOTP thì không còn ai cấp lại.

## Hay gặp

| Thông báo | Ý nghĩa / cách làm |
| --------- | ------------------ |
| `Không tạo: Đã có quản trị viên dùng được…` | Đúng như thiết kế — thêm người qua giao diện Admin |
| Quá 24 giờ chưa đăng nhập, mật khẩu tạm hết hạn | Chạy lại **đúng** `--username` và `--email` cũ → in `Đã cấp lại mật khẩu tạm…` (chỉ áp cho tài khoản chưa từng đổi mật khẩu) |
| `Không tạo: Tên đăng nhập hoặc email đã thuộc một tài khoản quản trị khác…` | Tên / email trùng tài khoản khác — chọn tên / email khác |
| `Không tạo: username: …` / `email: …` | Sai định dạng |
| `Cần MIGRATION_DATABASE_URL … và MONGODB_AUDIT_URI` | Tệp env thiếu biến hoặc sai đường dẫn `--env-file` |
| Treo rồi lỗi kết nối Mongo / Postgres | Atlas chưa cho IP của máy, hoặc chuỗi kết nối sai |
