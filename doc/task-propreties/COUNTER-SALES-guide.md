# COUNTER-SALES — Hướng dẫn chạy và kiểm tra

> Cập nhật28/10/2026. Worktree `C:\Code\vexenhanh_OPUPDATE`, nhánh `feat/selling_tickets`. Kế hoạch/trạng thái kiểm tra: [COUNTER-SALES-todo.md](COUNTER-SALES-todo.md).

## 1. Chuẩn bị môi trường phát triển

Chạy lệnh tại worktree này. Dùng PostgreSQL/Redis/MongoDB audit của môi trường phát triển; API và web phải trỏ cùng môi trường. `MIGRATION_DATABASE_URL` dùng owner, `DATABASE_URL` dùng role app không có BYPASSRLS. Không dùng KYC/payment thật khi các production-blocker của dự án chưa được giải quyết.

```powershell
pnpm install --frozen-lockfile
pnpm --filter @vexenhanh/api exec prisma migrate deploy
pnpm --filter @vexenhanh/api db:app-role
pnpm --filter @vexenhanh/api prisma:generate
pnpm --filter @vexenhanh/types build
pnpm --filter @vexenhanh/api dev
```

Ở terminal khác chạy `pnpm --filter @vexenhanh/operator-os dev`. Mặc định API3000, web3002; nếu worktree khác đang dùng các cổng này thì chọn cổng riêng và cập nhật `NEXT_PUBLIC_API_BASE_URL`/`OPERATOR_WEB_ORIGINS` tương ứng. Chỉ chạy một server dùng cùng thư mục `.next`.

Các migration mới: văn phòng/role bán vé, booking/receipt/sổ phí, và RLS giới hạn ghi xác nhận thu hoa hồng cho Platform. Trong lượt triển khai, migration chỉ được áp trên database kiểm thử tạm riêng; chưa áp lên database dùng chung của dự án.

## 2. Thiết lập văn phòng và người bán

1. Chủ nhà xe đăng nhập Operator OS, mở **Văn phòng**, tạo mã/tên/địa chỉ của từng văn phòng. Mã duy nhất trong nhà xe.
2. Trong **Nhân viên**, tạo tài khoản vai trò **Nhân viên bán vé** (`SALES_STAFF`). Dùng luồng mật khẩu tạm, khóa/mở khóa/cấp lại mật khẩu như các nhân viên khác.
3. Tại văn phòng, phân công một hoặc nhiều nhân viên bán vé đang hoạt động. Nhân viên chỉ dùng văn phòng được cấp; chủ nhà xe dùng mọi văn phòng. Ngừng hoạt động văn phòng thay vì xóa lịch sử.
4. Mở `/auth/counter/login`. Nhân viên dùng `{slug}/nv.{username}`; chủ nhà xe dùng tài khoản Owner và giữ bước MFA. Cổng này dẫn tới `/counter`, riêng với phần quản trị.

## 3. Bán và thu tiền

Chọn văn phòng/ngày/chuyến, điểm đón/trả và ghế → giữ chỗ10 phút → nhập khách liên hệ/hành khách (email tùy chọn) → tạo đơn. Ghế dùng chung với online và các văn phòng. Trễ giờ lịch vẫn bán được nếu xe chưa được xác nhận khởi hành; chuyến khóa/hủy/đã khởi hành không bán.

Chỉ bấm xác nhận sau khi thực sự kiểm đếm tiền mặt hoặc đối chiếu chuyển khoản vào nhà xe. Nhập số đồng thực nhận; chuyển khoản cần mã giao dịch đã đối chiếu. Thu đủ và còn điều kiện phát vé thì hệ thống phát QR. In lại/mở lại dùng vé đã có.

Nếu timeout, thử lại cùng khoản thu hoặc mở lại đơn trong danh sách; không thu thêm tiền khách chỉ vì màn hình chưa nhận phản hồi. Khóa chống lặp giữ nguyên cho lần thử lại. Mã chuyển khoản đã dùng không được dùng cho đơn khác.

Khoản thiếu/thừa, hết hạn, xe đã khởi hành hoặc lỗi phát vé được ghi **ngoại lệ**, chưa phát vé; chủ nhà xe cần xử lý khoản tiền thực nhận. Luồng tự hoàn/đổi/chuyển ngoại lệ sang chuyến khác chưa được thiết kế; không hủy trực tiếp qua gateway online. Chuyến có vé quầy đã thu bị chặn hủy tự động cho tới khi có quy trình hoàn quầy phù hợp.

## 4. Khởi hành và đối soát

Tài xế được phân công hoặc điều phối có quyền **Xác nhận xe khởi hành** ghi mốc thực tế trên máy chủ. Điều phối dùng trang chi tiết chuyến và hộp xác nhận. Gửi lại không thay mốc đã ghi. Sau mốc này không giữ mới hoặc chốt vé quầy; không tự đóng theo giờ lịch.

Báo cáo quầy tách tiền mặt, chuyển khoản, ngoại lệ và hoa hồng theo văn phòng/ngày/người xác nhận thu. Tiền nhà xe tự thu không tăng escrow hay số payout.

Admin chọn kênh **Quầy** khi cấu hình hoa hồng theo nhà xe/hiệu lực. Chưa có cấu hình quầy thì áp0%; mức cấu hình phải thấp hơn online trong mọi khoảng hiệu lực. Mỗi khoản thành công chụp mức phí, không tính lại vé cũ khi đổi cấu hình.

Admin xem khoản phí phải thu và xác nhận tiền hoa hồng đã thu thủ công bằng tham chiếu/lý do và bước xác thực lại. Hệ thống không tự trừ vào tiền online hoặc tự đặt kỳ hạn thu. Ca/quỹ đầu ca/bàn giao, hoàn từng phần và ưu đãi quầy còn chờ quy tắc nghiệp vụ.

## 5. Kiểm tra

```powershell
pnpm gen:api-client
pnpm lint
pnpm typecheck
pnpm --filter @vexenhanh/api exec vitest run --maxWorkers=1 --no-file-parallelism --testTimeout=20000 --hookTimeout=60000
pnpm --filter @vexenhanh/operator-os test
pnpm --filter @vexenhanh/operator-os test:e2e:counter
pnpm build
```

Integration API cần biến môi trường thật của database kiểm thử riêng và `REQUIRE_DB_TESTS=1` để không âm thầm bỏ qua. Browser test quầy dùng API giả có chủ đích trên cổng riêng, kiểm giao diện/retry/in lại; kiểm transaction, RLS, tiền và cạnh tranh do các integration test PostgreSQL/Redis đảm nhiệm. Kết quả thực tế và giới hạn kiểm tra được ghi trong todo.
