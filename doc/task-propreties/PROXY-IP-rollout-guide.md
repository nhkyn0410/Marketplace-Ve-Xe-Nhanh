# Kiểm thử và rollout client IP qua Render proxy

Phạm vi: API login dùng `TRUST_PROXY_HOPS=3`; chỉ dùng IP khi `req.ip` và
`CF-Connecting-IP` trùng nhau. Nếu không xác nhận được IP, credential login
giữ limiter theo identifier; không tạo bucket IP. Tài liệu này không thay đổi
chính sách fallback đó.

## 1. Trước deploy

1. Chạy `pnpm --filter @vexenhanh/api test`, `typecheck`, `lint`, `build`.
   Test `proxy-auth.integration.spec.ts` gọi **route Nest thật** qua HTTP, kiểm
   tra ba hop proxy, chống XFF giả, bucket Redis và audit bằng test doubles.
   Nó **không** kết nối Redis/Mongo/Cloudflare thật.
2. Kiểm tra `TRUST_PROXY_HOPS=3` trong Render service và thực tế ingress vẫn là
   client → Cloudflare → Render → app. Nếu thay CDN/proxy hoặc có đường truy cập
   ngắn hơn, phải đánh giá lại cấu hình trước khi deploy.
3. Xác nhận staging/dev/prod **không dùng chung `REDIS_URL`/database**: các key
   `login:id:*` và `login:ip:*` chưa có prefix theo môi trường. `BULLMQ_PREFIX`
   không tách được các key auth này. Không ghi URL hoặc secret vào log/tài liệu.
4. Xác nhận ai có quyền xem Render logs và chính sách lưu giữ/xuất log: request
   log hiện chứa IP trong header và trường `clientIp`/`cfConnectingIp`.

## 2. Smoke test sau deploy

1. Đợi Render báo deploy thành công; gọi `GET /v1/health`, kỳ vọng 200. Log
   health check từ `Render/1.0` không đại diện IP người dùng.
2. Từ Wi-Fi và một thiết bị dùng 4G độc lập, gửi đúng **một**
   `POST /v1/auth/platform/login` với cùng một identifier thử nghiệm chưa tồn tại
   (`platform/proxy-smoke-<mã-ngẫu-nhiên>`) và mật khẩu giả, không dùng tài khoản
   hoặc mật khẩu thật. Kỳ vọng mỗi request trả 401. Có thể dùng Swagger tại
   `/v1/docs`; xác nhận tab Network có request **POST login**, không chỉ GET
   `/v1/health`. Ghi lại `x-request-id` của hai phản hồi. Không dùng
   `POST /v1/auth/register` để kết luận về bucket IP: luồng đó giới hạn theo
   email/OTP, còn bucket IP đang áp dụng cho credential login.
3. Từ Wi-Fi, gửi thêm **một** login thử nghiệm với header tự đặt
   `X-Forwarded-For: 192.0.2.99` và `CF-Connecting-IP: 192.0.2.99` (IP
   TEST-NET), identifier thử nghiệm khác, mật khẩu giả. Kỳ vọng 401; trên
   đường public Cloudflare/Render phải ghi đè/xử lý header để IP giả **không**
   thành `trustedClientIp`, không xuất hiện trong `login:ip:*` hay audit. Nếu
   khác kỳ vọng, dừng rollout: local test không chứng minh được cách ingress
   production xử lý header đầu vào. Ghi lại `x-request-id` của phản hồi này.
4. Trong Render Logs, tra ba request ID. Kỳ vọng `trustedClientIp` bằng
   `cfConnectingIp`, `clientIpMatchesCf: true`, hai client có `trustedClientIp` khác nhau;
   `remoteAddress: "::1"` là socket nội bộ, không phải IP của người dùng.
   Tuyệt đối không dán IP thật hoặc toàn bộ header vào issue công khai.
5. Nếu có quyền kiểm tra Upstash, xác nhận hai key `login:ip:<IP đã xác nhận>`
   riêng biệt, không có key `login:ip:192.0.2.99`, và một key
   `login:id:<identifier thử nghiệm>` chung cho hai request đầu; các key có TTL
   khoảng 1 giờ. Không dùng `KEYS *` trên Redis production; dùng `SCAN` có
   giới hạn hoặc giao diện Upstash. Trong Mongo audit, ba sự kiện login thất
   bại phải có `after.ip` ứng với client thật. Việc này xác minh backend thật,
   ngoài phạm vi test double tại local.

## 3. Giám sát và quyết định rollout

- Trong lúc smoke test và sau deploy, dùng **text search** trong Render
  application logs với `auth.proxy_ip_untrusted` và `auth.login.rate_limited`.
  Mở dòng log để đọc `data.event` và `data.dimension` (`ip` hoặc `identifier`)
  cho 429 credential login. Logger của Nest đặt các trường này trong `data`,
  không ở top-level; Render không có bộ lọc riêng cho `data.event`. Không dùng
  bộ lọc `status_code` nếu workspace chưa có HTTP request logs (Pro trở lên).
- `auth.proxy_ip_untrusted` báo IP không xác nhận được ở những luồng auth cần
  context IP; **không** khẳng định mọi luồng đó đang dùng limiter theo identifier.
  Với credential login, fallback identifier-only được giữ theo quyết định hiện
  tại. Theo dõi cảnh báo kéo dài vì người tấn công đổi identifier có thể tránh
  bucket IP khi proxy sai.
- Đối chiếu số 429 credential login, lỗi 5xx/Sentry và log `clientIpMatchesCf`
  với trước deploy. Một cảnh báo đơn lẻ có thể do request không đi qua luồng
  Cloudflare mong đợi; cảnh báo lặp lại trên traffic hợp lệ hoặc hai client
  cùng rơi vào IP proxy là điều kiện **dừng rollout để điều tra**.
- Nếu smoke test cho IP sai/bucket trộn, hoặc tăng 429 ngoài dự kiến, dùng
  Render Dashboard → service → Deploys → rollback về deploy thành công trước.
  Rollback dùng env vars của deploy đích **cho lần rollback**, nhưng không ghi
  đè cấu hình service hiện tại; env group có quy tắc riêng và deploy kế tiếp sẽ
  dùng cấu hình hiện tại. Vì vậy kiểm tra lại `TRUST_PROXY_HOPS` trước lần
  deploy kế tiếp. Rollback qua Dashboard tạm tắt auto-deploy; chỉ bật lại sau
  khi xử lý nguyên nhân. Sau rollback gọi lại `/v1/health` và kiểm tra
  log/Sentry. Không tự thay `TRUST_PROXY_HOPS` theo cảm tính hoặc tắt rate limiter.

Tham khảo Render: [Logs](https://render.com/docs/logging),
[Rollbacks](https://render.com/docs/rollbacks).
