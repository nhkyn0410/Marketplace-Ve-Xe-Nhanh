# Hướng dẫn đưa API demo lên AWS Lightsail

Ngày: **29/10/2026**. Trạng thái: **Hướng dẫn chuẩn bị; chưa triển khai cloud**.

Làm [hướng dẫn tài khoản và credit](AWS-ACCOUNT-CREDITS-guide.md) trước. Phương án
đang dùng: một VM Singapore, API thường trực, worker bật thủ công khi cần demo;
giữ PostgreSQL, MongoDB, Redis và R2. Đây chưa phải cơ chế tự bật worker khi có request.

## 1. Điều kiện và chi phí

- AWS đã kích hoạt, xác minh Free account plan, số dư/hạn và dịch vụ được credit áp dụng.
- Có quyền quản lý DNS/Cloudflare của domain API và cấu hình Render đang dùng.
- Chuẩn bị VM Linux x86_64: thử 1 GB nếu muốn đo mức thấp nhất, hoặc khởi điểm
  2 GB để có thêm dư địa khi bật worker. Hai GB chưa phải mức tối thiểu đã đo.
- Giá Lightsail Linux có IPv4 đang công bố: 1 GB = 7 USD/tháng, 2 GB = 12 USD/tháng.
  Kiểm giá cuối trên Console; snapshot và các khoản ngoài gói tính riêng.
  [Giá AWS](https://aws.amazon.com/lightsail/pricing/).

Nếu Console yêu cầu nâng Paid plan để dùng dịch vụ, kiểm lại điều kiện và chi phí
trước khi nâng. Free plan có thời hạn theo tài khoản. Stop Lightsail vẫn tính phí;
chỉ xóa tài nguyên không giữ lại sau khi đã chuyển traffic/giữ bản cần phục hồi.

## 2. Tạo VM và địa chỉ cố định

Trong [Lightsail](https://lightsail.aws.amazon.com/):

1. **Create instance** → location **Singapore / ap-southeast-1**.
2. Linux/Unix → **OS Only → Ubuntu LTS x86_64** đang được cung cấp.
3. Chọn gói có IPv4/dual-stack và RAM như §1, đặt tên `vexenhanh-api-demo`.
4. Tạo máy rồi vào **Networking → Create static IP**, gắn vào máy cùng region.
5. Firewall: SSH 22 giới hạn IP quản trị; HTTPS 443 cho tuyến Cloudflare. Nếu bật
   IPv6, áp dụng giới hạn tương ứng cho IPv6. Không mở port 3000 ra internet.
   Có thể dùng **Connect using SSH** của Lightsail khi cần; kiểm firewall cho cách kết nối đó.
6. Thêm static IP vào allowlist PostgreSQL/MongoDB/vendor nếu nhà cung cấp yêu cầu.
7. Tải SSH key của đúng region từ tài khoản Lightsail để dùng SSH/SCP trên máy cá nhân.

Nguồn: [Tạo Lightsail instance](https://docs.aws.amazon.com/lightsail/latest/userguide/getting-started-with-amazon-lightsail.html),
[gắn static IP](https://docs.aws.amazon.com/lightsail/latest/userguide/lightsail-create-static-ip.html).

## 3. Cài Docker và Nginx trên VM

Các lệnh Bash sau chạy **trong SSH của VM Ubuntu mới**. Cài Docker Engine cùng
Compose plugin theo [tài liệu Docker cho Ubuntu](https://docs.docker.com/engine/install/ubuntu/),
phần **Install using the apt repository**, rồi kiểm:

```bash
sudo docker version
sudo docker compose version
sudo docker run --rm hello-world
sudo apt update
sudo apt install -y nginx
sudo install -d -m 0700 -o ubuntu -g ubuntu /opt/vexenhanh-demo
```

Hướng dẫn này giả sử SSH user là `ubuntu`; đổi đúng user nếu blueprint khác.
Compose cần bản hỗ trợ `env_file.format: raw` (2.30 trở lên). Không mở Docker TCP socket.
Không chỉ dựa vào UFW để chặn port Docker đã publish; API sẽ bind loopback ở §5.

## 4. Build image ngoài VM rồi chuyển lên

Chạy trên **PowerShell máy phát triển**, trong root repo. Bật Docker Desktop và đợi
`docker version` có phần Server. Trước khi build, dùng bản code đã qua CI/kiểm tra
theo [RB-03](../runbook/RB-03-quality-check.md). Không build từ folder `apps/api`.

```powershell
Set-Location C:\Code\Ve_Xe_Nhanh
$apiDemoTag = 'vexenhanh-api:aws-demo-20261029'
$apiDemoArchive = Join-Path $env:TEMP 'vexenhanh-api-aws-demo-20261029.tar'
docker build --platform linux/amd64 -t $apiDemoTag .
docker image save --output $apiDemoArchive $apiDemoTag
$awsDemoIp = Read-Host 'Static IPv4 Lightsail'
$awsDemoKey = Read-Host 'Duong dan day du SSH private key tren may cua ban'
scp -i $awsDemoKey $apiDemoArchive "ubuntu@${awsDemoIp}:/home/ubuntu/vexenhanh-api-demo.tar"
```

Chỉ chạy lệnh tiếp theo khi lệnh trước thành công. Đổi tag cho mỗi bản phát hành,
giữ tag/image cũ để rollback. Archive ở thư mục tạm, không đưa vào repo.
Lần kết nối SSH đầu tiên, đối chiếu host fingerprint qua Console trước khi chấp nhận.

Trên **SSH VM**:

```bash
sudo docker image load --input /home/ubuntu/vexenhanh-api-demo.tar
cd /opt/vexenhanh-demo
nano .env
```

Nội dung `.env` ở VM chỉ chọn image, không chứa secret ứng dụng:

```dotenv
API_IMAGE=vexenhanh-api:aws-demo-20261029
```

Image hiện có dùng Node 24 distroless, không có shell/pnpm. Default command API là
`["dist/main.js"]`; worker đổi thành `["dist/worker.js"]`. Xem [Dockerfile](../../Dockerfile).

## 5. Chuẩn bị cấu hình ứng dụng trên VM

Tạo `api.env` trong `/opt/vexenhanh-demo` bằng editor, nhập trực tiếp cấu hình từ
môi trường đang chạy. Không dán secret vào chat, lệnh shell, screenshot hay git.
File là `TEN_BIEN=gia_tri` mỗi dòng; với raw env-file, không bọc giá trị trong dấu nháy.

Giữ nguyên các giá trị đang hoạt động, đặc biệt:

| Nhóm | Tên biến cần đối chiếu |
| --- | --- |
| Runtime/data | `NODE_ENV=production`, `PORT=3000`, `DATABASE_URL`, `MONGODB_AUDIT_URI`, `REDIS_URL`, `BULLMQ_PREFIX` |
| Auth | `BETTER_AUTH_URL`, `BETTER_AUTH_SECRET`, `JWT_ACCESS_PRIVATE_KEY`, `JWT_ISSUER`, `MFA_ENCRYPTION_KEY`, `WEB_CSRF_SECRET`, `TICKET_QR_SECRET` |
| Web | `OPERATOR_WEB_ORIGINS`, `ADMIN_WEB_ORIGINS`, `AUTH_ALLOWED_CALLBACK_ORIGINS` |
| Email/routing | `RESEND_API_KEY`, `RESEND_FROM_EMAIL`, `GOONG_API_KEY` |
| Storage | `R2_ACCOUNT_ID`, `R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY`, `R2_PUBLIC_BUCKET`, `R2_PUBLIC_BASE_URL`, `R2_PRIVATE_BUCKET` nếu đã dùng |
| Khác đang bật | Payment vendor, OAuth, push, Sentry, `PAYMENT_RETURN_BASE_URL`, `BULL_BOARD_TOKEN` theo môi trường hiện tại |

Đây là manifest để đối chiếu, không thay thế [schema runtime](../../apps/api/src/config/env.config.ts).
Worker hiện dùng chung loader nên cũng cần các biến production bắt buộc của schema.
PostgreSQL dùng **app role**, không đưa `MIGRATION_DATABASE_URL`/owner vào runtime.
Giữ schema/data hiện tại, không chạy migrate hoặc seed trong đợt chuyển này.

`JWT_ACCESS_PRIVATE_KEY`: dùng **base64 một dòng của toàn bộ PEM hiện có**. Decoder
chấp nhận cách này; chuỗi chứa ký tự literal `\n` không được tự đổi thành newline.
Không tạo keypair mới trong lần migration. MFA/CSRF/ticket QR key giữ đúng dạng
base64 chuẩn của 32 byte đang dùng, không base64 thêm lần nữa.

Đặt `TRUST_PROXY_HOPS=2` là giá trị để kiểm chứng cho đường **Cloudflare → Nginx → API**
ở §6; chỉ nhận traffic khi kiểm IP thật/header giả đã đạt. Không copy giá trị Render 3.
Nếu topology khác, xác định lại trước khi dùng.

Tạo `/opt/vexenhanh-demo/compose.yaml` bằng editor, với nội dung sau:

```yaml
name: vexenhanh-demo
services:
  api:
    image: ${API_IMAGE:?Set API_IMAGE in .env}
    env_file:
      - path: ./api.env
        format: raw
    ports:
      - "127.0.0.1:3000:3000"
    restart: unless-stopped
    init: true
    stop_grace_period: 60s
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
  worker:
    image: ${API_IMAGE:?Set API_IMAGE in .env}
    command: ["dist/worker.js"]
    env_file:
      - path: ./api.env
        format: raw
    profiles: [worker]
    restart: "no"
    init: true
    stop_grace_period: 120s
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
```

```bash
chmod 600 .env api.env compose.yaml
sudo docker compose config --quiet
sudo docker compose up -d api
sudo docker compose ps
curl --fail --silent --show-error http://127.0.0.1:3000/v1/health
curl --fail --silent --show-error http://127.0.0.1:3000/v1/health/postgres
curl --fail --silent --show-error http://127.0.0.1:3000/v1/health/mongo
curl --fail --silent --show-error http://127.0.0.1:3000/v1/health/redis
```

Không chạy `docker compose config` thiếu `--quiet` khi có secret: cấu hình render
có thể chứa giá trị env. Nếu kiểm tra lỗi, xem log cục bộ và chỉ chia sẻ thông báo đã che secret.
Compose profile giữ worker ngoài lần khởi động mặc định; `restart: "no"` cũng tránh
worker tự bật lại sau reboot. [Docker profiles](https://docs.docker.com/compose/how-tos/profiles/),
[raw env-file](https://docs.docker.com/reference/compose-file/services/#env_file).

## 6. HTTPS và proxy giữ IP người dùng

Giữ Cloudflare proxied cho hostname API. Tạo **Origin Certificate** cho
`api.vexenhanh.vn` trong Cloudflare → SSL/TLS → Origin Server; lưu certificate và
private key trực tiếp trên VM tại `/etc/nginx/ssl/vxn-origin.crt` và `vxn-origin.key`.
Tạo folder bằng `sudo install -d -m 0700 /etc/nginx/ssl`; dùng editor `sudo nano`
và `sudo chmod 600 /etc/nginx/ssl/vxn-origin.key` cho private key.
Chọn Full (strict) cho hostname sau khi origin sẵn sàng; giữ chế độ TLS hợp lệ cho
các hostname khác trong zone. Origin CA dùng cho kết nối Cloudflare→VM, không dùng
để truy cập trực tiếp origin bằng trình duyệt. [Hướng dẫn Cloudflare](https://developers.cloudflare.com/ssl/origin-configuration/origin-ca/).

Trước khi public, chỉ cho phép dải Cloudflare vào origin. Tải danh sách từ
[IPv4](https://www.cloudflare.com/ips-v4) và [IPv6](https://www.cloudflare.com/ips-v6),
ghi mỗi CIDR thành `allow CIDR;` trong `/etc/nginx/vxn-cloudflare-allow.conf`.
Cập nhật file này khi Cloudflare đổi dải. Đây là điều kiện để tin header nguồn.
Không cấu hình thêm Nginx real_ip rewrite khi dùng mẫu bên dưới.

Tạo `/etc/nginx/sites-available/vexenhanh-api` bằng `sudo nano`:

```nginx
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name api.vexenhanh.vn;
    ssl_certificate /etc/nginx/ssl/vxn-origin.crt;
    ssl_certificate_key /etc/nginx/ssl/vxn-origin.key;
    allow 127.0.0.1;
    allow ::1;
    include /etc/nginx/vxn-cloudflare-allow.conf;
    deny all;
    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header CF-Connecting-IP $http_cf_connecting_ip;
    }
}
```

Mẫu chuyển **mọi path**, gồm `/v1/*` và `/api/auth/*` (OAuth). Chỉ mở public 443
cho API HTTPS trong phương án này; không tạo redirect HTTP hoặc mở port 80 khi chưa cần.
Trước cutover, xác nhận các ứng dụng/client đang dùng URL HTTPS hiện hành.

```bash
sudo ln -s /etc/nginx/sites-available/vexenhanh-api /etc/nginx/sites-enabled/vexenhanh-api
sudo nginx -t
sudo systemctl reload nginx
```

Chỉ tạo symlink một lần; nếu đã tồn tại thì chỉnh file gốc và chạy test/reload.
Nếu `nginx -t` lỗi, sửa trước khi reload. Mẫu này chưa được chạy trên VM thật.

## 7. Chuyển traffic và bật worker khi demo

Trước khi đổi DNS: kiểm image/version, đủ env, DB app role, health dependencies,
backup và bản Render có thể nhận lại traffic. Ghi lại DNS origin cũ.
Giữ Render cùng phiên bản và secrets trong khoảng 24–48 giờ quan sát.

1. Đổi DNS record **hostname API đang dùng** sang static IPv4 Lightsail, bật Cloudflare
   proxy. Xử lý record AAAA cũ nếu có để traffic không đi nhầm origin.
2. Kiểm HTTPS, login/refresh/logout/MFA, cookie/CSRF/CORS, upload và OAuth đang bật.
3. Kiểm hai mạng client và header giả theo [hướng dẫn proxy](PROXY-IP-rollout-guide.md),
   áp dụng tuyến Nginx mới. Production chỉ tin IP khi `req.ip` bằng `CF-Connecting-IP`.
4. Đo RAM cả VM bằng `free -h`, RAM container bằng `sudo docker stats --no-stream`.
   Kiểm reboot/restart và không có OOM; tăng RAM nếu luồng demo không đủ tài nguyên.
5. Đăng nhập/OTP có thể chạy khi worker tắt. Bật worker **trước** demo booking/payment;
   callback thanh toán và việc sweep booking hết hạn phụ thuộc worker.

Lệnh trên VM, tại `/opt/vexenhanh-demo`:

```bash
sudo docker compose --profile worker up -d worker
sudo docker compose --profile worker ps
```

Không bật worker VM khi worker local đang consume cùng Redis/prefix ngoài chủ đích.
Dừng/drain local trước. Xác minh job/scheduler và kết quả nghiệp vụ thật bằng dữ liệu
mẫu; health queue foundation không chứng minh worker đang xử lý các queue nghiệp vụ.
Sau demo, đợi callback/refund/notification và booking quá hạn của buổi demo được
xử lý; không đòi tất cả delayed maintenance job bằng 0. Rồi dừng worker:

```bash
sudo docker compose stop -t 120 worker
```

120 giây là thời gian chờ để drain, không bảo đảm mọi job dài đều hoàn tất; kiểm
trước khi dừng. Nếu worker tắt giữa giao dịch, trạng thái async có thể chờ tới lần bật sau.
Tắt container worker trên cùng VM không giảm tiền thuê VM, chỉ giảm tài nguyên sử dụng.

## 8. Cập nhật, rollback và nghiệm thu

- Bản mới: build/tag/archive ngoài VM → load trên VM → sửa `API_IMAGE` trong `.env`
  → `sudo docker compose up -d api` → smoke. Worker chỉ cập nhật khi có kế hoạch chạy.
- Rollback image: chọn lại tag cũ trong `.env`, recreate API và kiểm health/auth.
- Rollback hạ tầng: đưa origin DNS về Render, kiểm HTTPS/auth/proxy sau khi cache hội tụ.
  Worker AWS có thể giữ hoặc bàn giao lại theo thứ tự drain/dừng rồi mới bật worker cũ.
- Giữ DB/Redis chung: không restore DB hay flush Redis chỉ để đổi nơi chạy API.
- VM một máy có thể gián đoạn ngắn khi deploy. API hiện chưa bật
  `enableShutdownHooks()`; phải bổ sung/kiểm chứng nếu triển khai cơ chế drain hoàn chỉnh,
  không coi mẫu này là rolling deploy zero downtime.
- Chỉ nghiệm thu khi đã kiểm TLS, IP limiter, auth, tenant RLS, các luồng đang demo,
  worker/retry, restart/OOM, khả năng rollback và credit được billing áp dụng.
- Trước hết credit/hạn Free plan: quyết định giữ trả phí hay chuyển dịch vụ; xóa VM,
  IP rời/snapshot không giữ lại sau khi traffic đã chuyển và bản phục hồi đã được lưu.

Hướng dẫn này chưa thực hiện signup, tạo VM, đọc/chuyển secret, build image hay đổi DNS.
