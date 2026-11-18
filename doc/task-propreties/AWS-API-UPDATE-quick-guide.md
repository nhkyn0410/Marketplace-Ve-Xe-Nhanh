# Quy trình cập nhật API trên AWS Lightsail

**Luồng:** Code → GitHub → merge `develop` → CI build/push image lên GHCR → VM pull image → cập nhật env → tạo lại container.

## 1. Sửa code và đưa lên GitHub — máy cá nhân

- Làm trên nhánh tính năng. Nếu thêm biến cấu hình mới, khai báo/validate trong `apps/api/src/config/env.config.ts` và thêm giá trị mẫu vào `.env.example`.
- Kiểm tra thay đổi và chạy kiểm tra liên quan. Chỉ stage phần thuộc lần cập nhật; file mới cần `git add` theo đúng đường dẫn.

```powershell
git status --short --branch
git add -p
git diff --cached
git commit -m "feat(api): update API configuration"
git push -u origin HEAD
```

Tạo Pull Request vào **`develop`**, đợi CI xanh rồi merge. Không commit mật khẩu, token hoặc file env thật.

## 2. Lấy image từ GitHub Actions

Sau khi merge, mở **Actions → CI** của commit trên `develop`. Đợi cả **Verify monorepo** và **Publish API image** thành công, rồi copy image ở **Summary → Published**:

```text
ghcr.io/nhkyn0410/vexenhanh-api:COMMIT_SHA_40_KY_TU
```

Dùng đúng image từ Summary vì SHA sau merge có thể khác SHA nhánh tính năng. CI build image; VM sẽ tải image đó. Workflow hiện tại chưa tự deploy lên VM.

## 3. Sao lưu và sửa env — SSH Lightsail

```bash
cd /opt/vexenhanh-demo
umask 077
releaseBackup="backups/release-$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$releaseBackup"
cp -p .env api.env compose.yaml "$releaseBackup/"
printf 'Backup: %s\n' "$releaseBackup"
nano .env
nano api.env
```

- **`.env`**: đổi `API_IMAGE` thành toàn bộ image vừa copy từ Summary.
- **`api.env`**: thêm/sửa biến runtime, mỗi biến một dòng `TEN_BIEN=gia_tri`. Tránh trùng tên hoặc bị `environment:` trong Compose ghi đè bằng giá trị rỗng.
- Giữ cấu hình Redis nội bộ, chứng chỉ và các khóa hiện tại nếu lần cập nhật không thay đổi chúng.

## 4. Tải image, kiểm tra env và cập nhật API

```bash
sudo docker compose config --quiet
sudo docker compose pull api
sudo docker compose run --rm --no-deps \
  --entrypoint /nodejs/bin/node -- api \
  -e 'require("./dist/config/env.config.js").loadAppConfig(); console.log("Environment OK");'
```

Chỉ tiếp tục khi các lệnh thành công và hiện `Environment OK`. Kiểm tra này xác nhận schema env, chưa kiểm tra kết nối dịch vụ hoặc nội dung khóa.

```bash
sudo docker compose up -d --no-deps --force-recreate api
sudo docker compose ps api
sudo docker compose logs --since=2m --tail=60 api
curl --retry 12 --retry-all-errors --retry-delay 3 \
  --max-time 10 --retry-max-time 60 \
  -i http://127.0.0.1:3000/v1/health/queues
```

Cần thấy health trả `200`. Kiểm tra thêm `https://api.vexenhanh.id.vn/v1/health/queues`, đăng nhập/MFA và chức năng vừa sửa trên web.

## 5. Worker — khi muốn bật/cập nhật cùng phiên bản

API cập nhật không tự cập nhật worker. Chỉ chạy phần này khi muốn worker hoạt động; nếu đang chủ động tắt thì bỏ qua.

```bash
sudo docker compose --profile worker up -d --no-deps --force-recreate worker
sudo docker compose --profile worker ps -a worker
sudo docker compose logs --since=2m --tail=60 worker
```

Worker cần hiện `Up` và log `Worker bootstrap complete. BullMQ processors are registered.` Health queue `200` không chứng minh worker đang chạy.

## 6. Quay lại bản trước nếu lỗi

Trong cùng phiên SSH, dùng thư mục backup đã in ở bước 3; nếu mở phiên mới, gán lại `releaseBackup` bằng đúng đường dẫn đó.

```bash
cp -p "$releaseBackup/.env" .env
cp -p "$releaseBackup/api.env" api.env
sudo docker compose config --quiet
sudo docker compose up -d --no-deps --force-recreate api
```

Nếu đã cập nhật worker, tạo lại worker bằng lệnh bước 5 sau khi khôi phục env. Rollback này không hoàn tác migration DB.

**Chỉ đổi giá trị biến env đã được hỗ trợ:** bỏ qua phần code/CI/pull image, sửa `api.env`, kiểm tra env rồi tạo lại container liên quan. Không cần đổi DNS, Nginx hoặc khởi động lại Redis cho mỗi lần cập nhật API.
