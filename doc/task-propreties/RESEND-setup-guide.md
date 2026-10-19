# Hướng dẫn: cấu hình Resend với tên miền riêng (email thật cho Vé Xe Nhanh)

> **Vì sao cần:** API gửi email qua Resend (ADR-020). Khi chưa xác minh tên miền, Resend chỉ cho gửi tới chính email chủ tài khoản — người dùng / nhà xe thật không nhận được gì. Khanh đã có tên miền (15/10/2026); làm các bước dưới đây một lần.
> **Nguồn:** tài liệu Resend — [Add and verify a domain](https://resend.com/docs/add-a-domain), [Account quotas and limits](https://resend.com/docs/knowledge-base/account-quotas-and-limits), [Pricing](https://resend.com/pricing) (đọc ngày 15/10/2026).

## Những email đang đi qua Resend

| Email | Gửi tới | Từ task |
| ----- | ------- | ------- |
| Mã OTP đăng nhập / xác minh | Hành khách | IAM-001 |
| Mật khẩu tạm (Owner mới, nhân viên mới, cấp lại) | Chủ nhà xe, nhân viên | IAM-005, ADM-001 |
| Link bảo mật hồ sơ đăng ký nhà xe | Người nộp hồ sơ | OPR-001 |
| Kết quả hồ sơ: cần bổ sung / bị từ chối (NTF-15) | Người nộp hồ sơ | ADM-001 |
| Đề xuất điểm dừng được duyệt / bị từ chối; điểm riêng bị khóa / mở khóa | Chủ nhà xe | ADM-004 |

Thiếu cấu hình hoặc Resend lỗi: OTP / mật khẩu tạm báo lỗi để thử lại; các email báo kết quả chỉ ghi log, thao tác vẫn lưu.

## Bước 1 — Thêm tên miền vào Resend

1. Đăng nhập Resend → **Domains** → **Add Domain**.
2. Nên dùng **tên miền con** cho email, ví dụ `mail.<tên-miền>` thay vì tên miền gốc (Resend khuyên vậy; không đụng email đang dùng ở tên miền gốc).
3. **Region:** chọn vùng gần người nhận nhất. Nếu danh sách có Tokyo (`ap-northeast-1`) thì chọn vùng này — gần Việt Nam nhất.

## Bước 2 — Thêm bản ghi DNS ở nơi quản lý tên miền

Mở tab **Records** của tên miền trong Resend. Có ba bản ghi bắt buộc (giá trị do Resend sinh riêng — **chép nguyên văn từ Resend**, bảng dưới chỉ để biết hình dạng):

| Loại | Tên (host) | Giá trị | Ghi chú |
| ---- | ---------- | ------- | ------- |
| MX | `send.mail` (tên miền con `send` của tên miền email) | `feedback-smtp.<vùng>.amazonses.com`, ưu tiên `10` | Dùng cho thư trả về; giá trị phụ thuộc vùng đã chọn |
| TXT | `send.mail` | `v=spf1 include:amazonses.com ~all` | SPF |
| TXT | `resend._domainkey.mail` | Khóa DKIM dài Resend sinh | Phân biệt hoa thường, chép đủ |

Lưu ý khi nhập:

- Đa số nhà cung cấp DNS chỉ cần **phần host** (vd `send.mail`), không gõ kèm tên miền gốc.
- Giữ nguyên dấu chấm cuối nếu Resend chép kèm.
- Nếu đã có bản ghi MX ưu tiên `10` cho cùng host, dùng `20` hoặc `30`.
- Dùng Cloudflare: để các bản ghi này ở chế độ **DNS only** (mây xám), không bật proxy.
- Nên thêm DMARC (không bắt buộc): TXT `_dmarc.mail` = `v=DMARC1; p=none;` — giúp email ít bị vào thư rác.

Lưu xong bấm **Verify** trong Resend. Thường vài phút; có khi tới 72 giờ.

## Bước 3 — Tạo khóa API và khai cho API

1. Resend → **API Keys** → **Create API Key**, quyền **Sending access**, giới hạn đúng tên miền vừa xác minh. Khóa chỉ hiện một lần — lưu vào trình quản lý mật khẩu, không gửi qua chat.
2. **Render** (service `vexenhanh-api`) → Environment:
   - `RESEND_API_KEY` = khóa vừa tạo.
   - `RESEND_FROM_EMAIL` = địa chỉ gửi **thuộc tên miền đã xác minh**, vd `no-reply@mail.<tên-miền>`. Thiếu biến này API dùng mặc định `no-reply@vexenhanh.com` — Resend sẽ từ chối nếu tên miền đó không phải của bạn.
3. Máy dev (`apps/api/.env`): khai hai biến như trên nếu muốn thử gửi thật. **E2E vẫn chạy với `RESEND_API_KEY=''`** (`IAM-006-guide.md` §3) để không gửi email thật tới địa chỉ thử.

## Bước 4 — Thử

- Gửi một hồ sơ đăng ký nhà xe ở `/register` của Operator OS bằng email của bạn → nhận được email link hồ sơ.
- Kiểm hộp thư rác lần đầu; nếu vào rác, kiểm lại DKIM / SPF ở tab Records (phải hiện **Verified**) và thêm DMARC.

## Giới hạn gói miễn phí (15/10/2026)

- **3.000 email / tháng, tối đa 100 email / ngày** (tính theo ngày UTC, reset 7 giờ sáng giờ Việt Nam). Vượt mức API Resend trả lỗi `daily_quota_exceeded` → OTP / mật khẩu tạm báo lỗi cho người dùng.
- Tối đa 3 tên miền đã xác minh, dùng chung hạn mức.
- Đủ cho giai đoạn demo / môn học. Lên vận hành thật thì xem gói Pro (không giới hạn ngày).
