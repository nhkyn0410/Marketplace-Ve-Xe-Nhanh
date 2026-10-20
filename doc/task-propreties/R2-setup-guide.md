# Hướng dẫn: cấu hình Cloudflare R2 cho production (Access Key / Secret Key)

> **Vì sao cần:** production bắt buộc đủ 5 biến `R2_*` — thiếu thì API **không khởi động** (`env.config.ts`), vì ổ đĩa của máy chủ (Render) mất sau mỗi lần deploy. R2 lưu ảnh xe (Operator OS), banner + ảnh bài viết (Admin); trang công khai đọc ảnh qua tên miền CDN (ADR-018).
> **Nguồn:** tài liệu Cloudflare — [S3 API tokens](https://developers.cloudflare.com/r2/api/s3/tokens/), [Public buckets](https://developers.cloudflare.com/r2/buckets/public-buckets/), [CORS](https://developers.cloudflare.com/r2/buckets/cors) (đọc ngày 20/10/2026).
> **Không gửi khóa qua chat / commit vào git.** Khóa bí mật chỉ hiện một lần — lưu vào trình quản lý mật khẩu rồi tự nhập vào nơi chạy production.

## Kết quả cần có

| Biến | Giá trị | Lấy ở đâu |
| ---- | ------- | --------- |
| `R2_ACCOUNT_ID` | Account ID của Cloudflare | R2 → Overview (cột phải) |
| `R2_ACCESS_KEY_ID` | Access Key ID của token | Bước 4 |
| `R2_SECRET_ACCESS_KEY` | Secret Access Key của token | Bước 4 (chỉ hiện một lần) |
| `R2_PUBLIC_BUCKET` | `vexenhanh-public` | Bước 1 |
| `R2_PUBLIC_BASE_URL` | `https://cdn.vexenhanh.id.vn` (không có `/` cuối) | Bước 2 |
| `R2_PRIVATE_BUCKET` | **Để trống** | Xem mục "Bucket riêng tư" |

## Bước 0 — Tên miền phải nằm trên Cloudflare

Tên miền công khai cho bucket (custom domain) chỉ gắn được khi `vexenhanh.id.vn` đã là một **zone trong cùng tài khoản Cloudflare** với bucket. Nếu tên miền đang quản lý DNS ở nơi khác: Cloudflare → **Add a site** → làm theo hướng dẫn đổi nameserver ở nhà đăng ký tên miền (chuyển cả các bản ghi DNS đang có, gồm bản ghi Resend).

Địa chỉ `r2.dev` do Cloudflare cấp chỉ dành cho **thử nghiệm** (không có cache, WAF, kiểm soát truy cập) — không dùng cho production.

## Bước 1 — Tạo bucket công khai

R2 → **Create bucket** → tên `vexenhanh-public`, Location: **Automatic** (hoặc gợi ý *Asia-Pacific*). Không chọn jurisdiction (EU / FedRAMP) — code dùng endpoint mặc định `https://<ACCOUNT_ID>.r2.cloudflarestorage.com`.

## Bước 2 — Gắn tên miền CDN

Bucket `vexenhanh-public` → **Settings** → **Public access** → **Custom Domains** → **Connect Domain** → `cdn.vexenhanh.id.vn`. Cloudflare tự thêm bản ghi CNAME. Chờ trạng thái **Active**.

## Bước 3 — CORS (cho trình duyệt tải ảnh thẳng lên R2)

Operator OS (ảnh xe) và Admin (banner, ảnh bài viết) tải file bằng `PUT` tới URL ký sẵn, kèm header `Content-Type`. Bucket → **Settings** → **CORS Policy** → **Add CORS policy** → tab **JSON**:

```json
[
  {
    "AllowedOrigins": ["https://operator.vexenhanh.id.vn", "https://admin.vexenhanh.id.vn"],
    "AllowedMethods": ["PUT"],
    "AllowedHeaders": ["Content-Type"],
    "ExposeHeaders": ["ETag"],
    "MaxAgeSeconds": 3600
  }
]
```

- Origin phải khớp đúng `OPERATOR_WEB_ORIGINS` / `ADMIN_WEB_ORIGINS` của API (không có `/` cuối). Đổi tên miền web thì sửa lại ở đây.
- Hiển thị ảnh bằng thẻ `<img>` không cần CORS nên không mở `GET`.
- Định dạng trên là của **dashboard**; `wrangler` / API dùng dạng `{ "rules": [...] }` khác.

## Bước 4 — Tạo Access Key / Secret Key

R2 → Overview → **Manage API Tokens** → **Create Account API token** (token tài khoản không mất hiệu lực khi người tạo rời tài khoản):

- **Permission:** `Object Read & Write` (API cần tạo URL tải lên, kiểm `HEAD`, liệt kê + xóa object mồ côi ở job dọn ảnh).
- **Specify bucket(s):** chỉ `vexenhanh-public` — lộ khóa cũng không đụng được bucket khác.
- TTL: tùy chọn (để mặc định hoặc đặt hạn rồi xoay vòng).

Bấm **Create** → chép **Access Key ID** và **Secret Access Key** vào trình quản lý mật khẩu. **Secret chỉ hiện một lần.**

## Bước 5 — Nhập vào nơi chạy production

- **Render** (đang dùng): service `vexenhanh-api` → **Environment** → nhập 5 biến ở bảng trên (`render.yaml` đã khai `sync: false`, nên phải nhập tay) → **Save changes** → deploy lại. Khi bật worker (đang tắt trong `render.yaml`), nhập **cùng 5 biến** cho worker — job dọn ảnh mồ côi chạy ở worker.
- **Nếu chuyển sang Azure Container Apps:** khai thành *secret* của container app rồi tham chiếu bằng `secretref:` trong biến môi trường (làm khi viết cấu hình Azure).
- **File `apps/api/.env.production` trên máy** (đã `.gitignore`): nếu dùng làm bản lưu, lưu ý file đang có **hai dòng** `OPERATOR_WEB_ORIGINS` / `ADMIN_WEB_ORIGINS` — dòng sau để trống sẽ **ghi đè** dòng trước khi nạp bằng dotenv. Xóa hai dòng trống thừa.

## Bước 6 — Kiểm tra

1. Log khởi động API **không** còn dòng `Chưa cấu hình R2 — file công khai lưu trên ổ đĩa local`.
2. Admin → **Tích hợp & hệ thống**: mục kho công khai đổi từ `Kho công khai (ổ đĩa)` sang **`Cloudflare R2 · công khai`** và đang hoạt động.
3. Operator OS → Phương tiện → thêm một ảnh xe → ảnh hiện, địa chỉ ảnh bắt đầu bằng `https://cdn.vexenhanh.id.vn/`.
4. Admin → **Kiểm duyệt** → tab **Nội dung công khai** → tạo banner có ảnh.

Hay gặp:

| Triệu chứng | Nguyên nhân |
| ----------- | ----------- |
| Trình duyệt báo lỗi CORS khi tải ảnh | Origin trong CORS không khớp từng ký tự (http / https, `/` cuối); đổi CORS cần ~30 giây để có hiệu lực |
| API không khởi động: `R2_… is required` | Thiếu một trong 5 biến (khai dở cũng bị từ chối) |
| `403 SignatureDoesNotMatch` / `AccessDenied` | Sai cặp khóa, token không có quyền trên đúng bucket, hoặc `R2_ACCOUNT_ID` sai |
| Ảnh tải lên được nhưng không hiện | `R2_PUBLIC_BASE_URL` sai hoặc tên miền CDN chưa **Active** |

## Bucket riêng tư (KYC, minh chứng khiếu nại / tranh chấp)

**Production để trống `R2_PRIVATE_BUCKET`.** Nơi lưu giấy tờ KYC / minh chứng ở production còn chờ **OQ-21** (dữ liệu cá nhân, Nghị định 13/2023) — CLAUDE.md §4.6 chỉ cho dữ liệu này chạy dev / sandbox. Khi để trống, các API tải / xem giấy tờ KYC và tệp minh chứng trả **503** (có chủ đích). Chỉ tạo `vexenhanh-private` + token riêng khi Khanh chốt OQ-21.

## Chi phí

R2 không tính phí băng thông tải ra (egress); có hạn mức miễn phí hằng tháng cho dung lượng và số thao tác — xem [R2 pricing](https://developers.cloudflare.com/r2/pricing/) trước khi vượt mức demo. Lượng ảnh của giai đoạn môn học nằm xa hạn mức này.

## Khi lộ khóa

Cloudflare → Manage API Tokens → xóa (hoặc **Roll**) token cũ → tạo token mới theo Bước 4 → nhập lại Bước 5 → deploy lại.
