# Hướng dẫn: cấu hình Cloudflare R2 cho production (Access Key / Secret Key)

> **Vì sao cần:** production bắt buộc đủ 5 biến `R2_*` — thiếu thì API **không khởi động** (`env.config.ts`), vì ổ đĩa của máy chủ (Render) mất sau mỗi lần deploy. R2 lưu ảnh xe (Operator OS), banner + ảnh bài viết (Admin); trang công khai đọc ảnh qua tên miền CDN (ADR-018). Từ 20/10/2026 production là **môi trường demo** (OQ-21) → bật thêm bucket riêng tư cho giấy tờ KYC / minh chứng, **chỉ dữ liệu mẫu**.
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
| `R2_PRIVATE_BUCKET` | `vexenhanh-private` | Bước 7 (môi trường demo — chỉ dữ liệu mẫu) |

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
- **Specify bucket(s):** `vexenhanh-public` **và** `vexenhanh-private` (API dùng chung một cặp khóa cho hai bucket) — không cấp toàn tài khoản, lộ khóa cũng không đụng được bucket khác.
- TTL: tùy chọn (để mặc định hoặc đặt hạn rồi xoay vòng).

Bấm **Create** → chép **Access Key ID** và **Secret Access Key** vào trình quản lý mật khẩu. **Secret chỉ hiện một lần.**

## Bước 5 — Nhập vào nơi chạy production

- **Render** (đang dùng): service `vexenhanh-api` → **Environment** → nhập 6 biến ở bảng trên (`render.yaml` đã khai `sync: false`, nên phải nhập tay) → **Save changes** → deploy lại. Khi bật worker (đang tắt trong `render.yaml`), nhập **cùng 6 biến** cho worker — job dọn ảnh / giấy tờ mồ côi chạy ở worker.
- **Vercel** (Operator OS + Admin): thêm `NEXT_PUBLIC_DEMO_MODE=true` → các ô tải giấy tờ / minh chứng hiện cảnh báo "chỉ tải giấy tờ mẫu" → **Redeploy** (biến `NEXT_PUBLIC_*` gắn lúc build).
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

## Bước 7 — Bucket riêng tư cho môi trường demo (KYC, minh chứng khiếu nại / tranh chấp)

> **Khanh chốt OQ-21 ngày 20/10/2026:** production là **môi trường demo, chỉ dữ liệu mẫu** (giấy tờ mẫu, tài khoản thử) — không có người dùng thật nên chưa phát sinh nghĩa vụ chuyển dữ liệu cá nhân xuyên biên giới (Luật Bảo vệ dữ liệu cá nhân 2025, Nghị định 356/2025). **Trước khi nhận dữ liệu thật phải mở lại OQ-21** (lập hồ sơ đánh giá tác động chuyển dữ liệu xuyên biên giới, hoặc chuyển nơi lưu về Việt Nam) — áp cho cả DB / Mongo / Redis / email đang đặt ngoài Việt Nam, không chỉ giấy tờ.

1. R2 → **Create bucket** → `vexenhanh-private`, Location: gợi ý **Asia-Pacific** (`apac` — chỉ là gợi ý, không cam kết đặt ở Singapore). **Không** bật Public access / Custom domain — chỉ đọc qua URL ký 5 phút + audit.
2. **Settings → CORS Policy** (JSON) — trình duyệt tải giấy tờ thẳng lên bucket:

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

   Operator OS: hồ sơ đăng ký nhà xe, Hồ sơ & KYC, đính kèm khiếu nại; Admin: đính kèm khiếu nại / tranh chấp. App di động không cần CORS; web hành khách (khi làm) thì thêm origin của nó.
3. **Settings → Object lifecycle rules** → thêm luật **xóa object sau 30 ngày** cho cả bucket ([Object lifecycles](https://developers.cloudflare.com/r2/buckets/object-lifecycles/)). Giấy tờ mẫu quá 30 ngày sẽ mất (mở lại báo lỗi) — tải lại giấy tờ mẫu trước buổi demo nếu cần.
4. Token ở Bước 4 phải gồm cả bucket này. Nhập `R2_PRIVATE_BUCKET=vexenhanh-private` (Bước 5) → deploy lại.
5. Kiểm tra: Admin → **Tích hợp & hệ thống** → mục kho riêng tư hết báo *Chưa cấu hình*; Operator OS → **Hồ sơ & KYC** → tải một giấy tờ mẫu → **Xem** mở được; hồ sơ đăng ký nhà xe tải được giấy tờ.

**Giấy tờ mẫu:** dùng ảnh / PDF tự tạo (ghi rõ "MẪU — KHÔNG CÓ GIÁ TRỊ"), không chụp CCCD, giấy phép, sao kê thật của bất kỳ ai.

## Chi phí

R2 không tính phí băng thông tải ra (egress); có hạn mức miễn phí hằng tháng cho dung lượng và số thao tác — xem [R2 pricing](https://developers.cloudflare.com/r2/pricing/) trước khi vượt mức demo. Lượng ảnh của giai đoạn môn học nằm xa hạn mức này.

## Khi lộ khóa

Cloudflare → Manage API Tokens → xóa (hoặc **Roll**) token cũ → tạo token mới theo Bước 4 → nhập lại Bước 5 → deploy lại.
