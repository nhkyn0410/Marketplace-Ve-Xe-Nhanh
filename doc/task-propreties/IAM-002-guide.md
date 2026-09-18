# TASK-IAM-002 — Guide kiểm chứng: hybrid token, rotation, family invalidation

> Chạy thật IAM-002 (refresh rotation + family invalidation + logout + re-auth) trên máy local bằng Docker.
> Lệnh chạy ở repo root `C:\Code\Ve_Xe_Nhanh` (**PowerShell**). Phạm vi/quyết định: `IAM-002-todo.md`. Nghiệm thu: `IAM-002-verification-checklist.md`.
>
> ⚠️ **Guide này viết TRƯỚC khi code (15/09/2026)** để làm success-criteria cho task. Chạy nó sau khi xong `.7`. Nếu tên field / mã lỗi thực tế lệch guide, **sửa code cho khớp thiết kế** — chỉ sửa guide khi chính thiết kế đổi (và ghi lý do vào `IAM-002-todo.md`).

## 0. Tiền đề

- **Docker Desktop đang chạy** (đợi icon hết "starting").
- Đã `pnpm install`; branch `TASK-IAM-002`; migration `add_auth_sessions` đã có trong repo.

---

## 1. Bật hạ tầng local

```powershell
docker compose up -d
```

```powershell
docker compose ps
```

Đợi `postgres` / `mongo` / `redis` đều `(healthy)`.

---

## 2. Migration + seed

```powershell
pnpm --filter @vexenhanh/api exec prisma migrate status
```

Phải ra `Database schema is up to date!`. DB trống/mới thì chạy `pnpm --filter @vexenhanh/api prisma:migrate:dev`.

```powershell
pnpm --filter @vexenhanh/api db:seed
```

Tài khoản seed (đổi qua env `SEED_PLATFORM_PASSWORD` / `SEED_OPERATOR_PASSWORD` / `SEED_EMPLOYEE_PASSWORD`):

| Identifier              | Password mặc định   | Role           |
| ----------------------- | --------------------- | -------------- |
| `platform/khanh`        | `ChangeMe!Platform1`  | PLATFORM_ADMIN |
| `phuongtrang/owner01`   | `ChangeMe!Owner1`     | OPERATOR_OWNER |
| `phuongtrang/driver042` | `ChangeMe!Driver1`    | DRIVER         |

---

## 3. Chạy API

```powershell
pnpm --filter @vexenhanh/api start
```

Đợi `Nest application successfully started`, để terminal này MỞ.

> Dev không set `JWT_ACCESS_PRIVATE_KEY` → keypair **ephemeral**: restart API là mọi access token cũ chết. Bình thường — nhưng **đừng restart giữa một kịch bản**, không thì sẽ tưởng nhầm là revoke chạy đúng. Refresh token thì sống qua restart (nằm ở Postgres).

Đặt sẵn biến cho các bước sau:

```powershell
$base = "http://localhost:3000/v1"
```

---

## 4. Các kịch bản

Mỗi lệnh dùng `curl.exe` (không phải alias `curl` của PowerShell) và nháy đơn để giữ nguyên JSON.

### 4A. Login trả **cặp** token (access + refresh)

```powershell
$login = curl.exe -s -X POST "$base/auth/platform/login" -H "Content-Type: application/json" -d '{"identifier":"platform/khanh","password":"ChangeMe!Platform1"}' | ConvertFrom-Json
$login | Format-List
```

Phải có: `accessToken`, `tokenType=Bearer`, `expiresIn=900`, **`refreshToken`**, **`refreshExpiresIn=2592000`** (30 ngày), `scope=platform`.

Soi JWT có claim `sid` chưa (dán vào https://jwt.io, hoặc):

```powershell
$payload = $login.accessToken.Split(".")[1].Replace("-","+").Replace("_","/").PadRight([int](([math]::Ceiling($login.accessToken.Split(".")[1].Length / 4)) * 4), "=")
[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($payload)) | ConvertFrom-Json | Format-List
```

Phải thấy `sub`, `scope`, `role`, **`sid`**, `iss`, `exp`.

### 4B. Refresh → rotation (token cũ chết, token mới sống)

```powershell
$r1 = curl.exe -s -X POST "$base/auth/refresh" -H "Content-Type: application/json" -d ('{"refreshToken":"' + $login.refreshToken + '"}') | ConvertFrom-Json
$r1 | Format-List
```

Phải ra **cặp mới**: `accessToken` khác, `refreshToken` khác, `sid` trong JWT khác.

### 4C. ⭐ Reuse detection — TC-SEC-002 (kịch bản quan trọng nhất)

Dùng lại **refresh token cũ** (`$login.refreshToken`, đã rotate ở 4B):

```powershell
curl.exe -s -w "`n[%{http_code}]`n" -X POST "$base/auth/refresh" -H "Content-Type: application/json" -d ('{"refreshToken":"' + $login.refreshToken + '"}')
```

→ **401** `AUTH_SESSION_EXPIRED`.

Rồi kiểm điều thật sự quan trọng: **cả family phải chết**, nghĩa là refresh token *mới* (`$r1.refreshToken`) — thứ đang nằm trong tay người dùng thật — cũng phải hỏng theo:

```powershell
curl.exe -s -w "`n[%{http_code}]`n" -X POST "$base/auth/refresh" -H "Content-Type: application/json" -d ('{"refreshToken":"' + $r1.refreshToken + '"}')
```

→ **401**. Nếu cái này trả 200 thì family invalidation **chưa chạy** — đây đúng là chỗ dễ làm hụt nhất, và test xanh vẫn có thể lọt nếu chỉ kiểm token cũ.

### 4D. Refresh song song (Q5 — strict)

Lấy cặp mới rồi bắn 2 request cùng lúc với **cùng một** refresh token:

```powershell
$fresh = curl.exe -s -X POST "$base/auth/platform/login" -H "Content-Type: application/json" -d '{"identifier":"platform/khanh","password":"ChangeMe!Platform1"}' | ConvertFrom-Json
$body = '{"refreshToken":"' + $fresh.refreshToken + '"}'
$jobs = 1..2 | ForEach-Object { Start-Job { param($b,$u) curl.exe -s -o NUL -w "%{http_code}" -X POST $u -H "Content-Type: application/json" -d $b } -ArgumentList $body, "$base/auth/refresh" }
$jobs | Wait-Job | Receive-Job
$jobs | Remove-Job
```

→ Mong đợi **đúng một `200`** và một `401`. Hai `200` = rotation không atomic (đọc-rồi-ghi hai bước) — phải sửa `.3` ngay, đây là lỗi sinh ra hai refresh token hợp lệ từ một token.

### 4E. Logout giết cả access token còn hạn

```powershell
$s = curl.exe -s -X POST "$base/auth/platform/login" -H "Content-Type: application/json" -d '{"identifier":"platform/khanh","password":"ChangeMe!Platform1"}' | ConvertFrom-Json
curl.exe -s -w "`n[%{http_code}]`n" -X POST "$base/auth/logout" -H ("Authorization: Bearer " + $s.accessToken)
```

→ **200**. Gọi lại lần nữa vẫn **200** (idempotent). Sau đó, dù access token còn ~15 phút:

```powershell
curl.exe -s -w "`n[%{http_code}]`n" -X POST "$base/auth/logout" -H ("Authorization: Bearer " + $s.accessToken)
curl.exe -s -w "`n[%{http_code}]`n" -X POST "$base/auth/refresh" -H "Content-Type: application/json" -d ('{"refreshToken":"' + $s.refreshToken + '"}')
```

Refresh cũ → **401**. Còn access token: chứng minh nó bị chặn bằng `session:revoked:{sid}` ở §5 (khoá Redis phải tồn tại).

### 4F. Re-auth (FR-IAM-10)

```powershell
$s2 = curl.exe -s -X POST "$base/auth/platform/login" -H "Content-Type: application/json" -d '{"identifier":"platform/khanh","password":"ChangeMe!Platform1"}' | ConvertFrom-Json
# Sai mật khẩu → 401
curl.exe -s -w "`n[%{http_code}]`n" -X POST "$base/auth/re-auth" -H ("Authorization: Bearer " + $s2.accessToken) -H "Content-Type: application/json" -d '{"password":"WRONG"}'
# Đúng mật khẩu → 200
curl.exe -s -w "`n[%{http_code}]`n" -X POST "$base/auth/re-auth" -H ("Authorization: Bearer " + $s2.accessToken) -H "Content-Type: application/json" -d '{"password":"ChangeMe!Platform1"}'
```

→ 401 rồi 200; sau khi 200 thì Redis có `reauth:{sid}` TTL ~300s (kiểm ở §5).

### 4G. Redis chết → 503 (ADR-015, KHÔNG bypass)

> ⚠️ Trước bước này, kiểm API có đang nói chuyện với **đúng** Redis của Docker không: trên máy có WSL chạy Redis riêng, `localhost:6379` trỏ vào Redis trong WSL (ghi nhận 17/09/2026). So `redis_version` của `docker compose exec -T redis redis-cli info server` với Redis mà API dùng; lệch thì chạy API với `REDIS_URL=redis://<IP LAN của máy>:6379`, nếu không `stop redis` sẽ chẳng ảnh hưởng gì và bước này đo sai.

```powershell
docker compose stop redis
curl.exe -s -w "`n[%{http_code}]`n" -X POST "$base/auth/refresh" -H "Content-Type: application/json" -d ('{"refreshToken":"' + $r1.refreshToken + '"}')
docker compose start redis
```

→ **503** `SERVICE_UNAVAILABLE`. Nếu ra 200 là đang **fail-open** — sai ADR-015, phải sửa.

### 4H. Passenger (Email OTP) cũng phải có refresh

```powershell
curl.exe -s -w "`n[%{http_code}]`n" -X POST "$base/auth/otp/request" -H "Content-Type: application/json" -d '{"email":"rider@example.com"}'
```

Lấy OTP **từ DB** (dev không gửi được mail — xem §6):

```powershell
docker compose exec -T postgres psql -U vexenhanh -d vexenhanh_dev -t -A -F"|" -c "select identifier, value from verifications order by created_at desc limit 1;"
```

```powershell
curl.exe -s -X POST "$base/auth/otp/verify" -H "Content-Type: application/json" -d '{"email":"rider@example.com","otp":"NNNNNN"}' | ConvertFrom-Json | Format-List
```

→ 200 + `scope=passenger` + **có `refreshToken`** (không được sót đường login nào).

---

## 5. Soi Postgres + Redis (bằng chứng, không đoán)

**Bảng `auth_sessions`** — nhìn một family sau khi rotate + reuse:

```powershell
docker compose exec -T postgres psql -U vexenhanh -d vexenhanh_dev -c "select left(id::text,8) as sid, subject_type, left(family_id::text,8) as fam, left(refresh_token_hash,12) as hash, rotated_at is not null as rotated, revoked_at is not null as revoked, revoked_reason, expires_at from auth_sessions order by issued_at desc limit 10;"
```

Phải thấy: cùng `fam`, row cũ `rotated=t`, sau bước 4C thì **mọi row trong family** `revoked=t` với `revoked_reason=REUSE_DETECTED` (enum Postgres viết hoa).

⚠️ Cột `refresh_token_hash` phải là **hash** (hex/base64 dài đều), **không** phải token đang cầm trên tay. Đối chiếu nhanh: token thô trong `$r1.refreshToken` không được xuất hiện trong bất kỳ cột nào.

**Redis:**

```powershell
docker compose exec -T redis redis-cli --scan --pattern "session:*"
docker compose exec -T redis redis-cli --scan --pattern "reauth:*"
```

```powershell
docker compose exec -T redis redis-cli ttl "session:revoked:<sid>"
```

TTL phải ~900 (bằng TTL access token) — đủ để access token còn hạn bị chặn, rồi tự dọn.

**Audit Mongo (append-only):**

```powershell
docker compose exec -T mongo mongosh --quiet -u vexenhanh -p vexenhanh_dev --authenticationDatabase admin vexenhanh_audit --eval "db.audit_event.find({action:/^auth\./}).sort({createdAt:-1}).limit(10).toArray()"
```

Phải có `auth.session.rotated`, `auth.token.reuse_detected`, `auth.logout`. **Không** được thấy token thô trong bất kỳ field nào.

---

## 6. Gỡ vướng (những chỗ dễ tưởng nhầm là bug)

| Hiện tượng                            | Nguyên nhân thật                                                                                                                                                       |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Login trả **429**                      | Rate limit login: 10/giờ/identifier, 30/giờ/IP. Xoá: `docker compose exec -T redis redis-cli --scan --pattern "login:*" \| ForEach-Object { docker compose exec -T redis redis-cli del $_ }` |
| `otp/request` 200 nhưng không có mail | `ConsoleEmailNotifier` **không in OTP** (cố ý — OTP trong log = chiếm tài khoản bằng quyền đọc log); Resend trả 422 vì domain chưa verify. Lấy mã từ bảng `verifications`. |
| Access token đột nhiên 401 hàng loạt | Đã restart API → keypair ephemeral mới. Login lại.                                                                                                                       |
| Refresh 401 ngay sau login              | Kiểm `expires_at` trong `auth_sessions` và đồng hồ container; hoặc đang gửi nhầm `accessToken` vào body `refreshToken`.                                             |
| Mọi thứ 503                            | Redis đang stop (bước 4G) — `docker compose start redis`.                                                                                                                 |

---

## 7. Bảng kỳ vọng tổng

| Case                                              | HTTP | Ghi chú                                          |
| ------------------------------------------------- | ---- | -------------------------------------------------- |
| Login (4 đường: otp/oauth/operator/platform)     | 200  | Có cả `accessToken` + `refreshToken`, JWT có `sid` |
| Refresh hợp lệ                                   | 200  | Cặp mới, `sid` mới, cùng `family_id`           |
| Refresh token **cũ đã rotate**                  | 401  | `AUTH_SESSION_EXPIRED` + **revoke cả family**     |
| Refresh token mới **sau khi family bị revoke**  | 401  | Bằng chứng family invalidation chạy thật       |
| 2 refresh song song cùng token                   | 200 + 401 | Đúng 1 thắng                                   |
| Refresh không tồn tại / hết hạn / đã revoke  | 401  | Cùng một response — không leak                   |
| Logout                                            | 200  | Idempotent; `session:revoked:{sid}` TTL ~900s       |
| Refresh sau logout                                | 401  | —                                                  |
| Re-auth sai mật khẩu / đúng mật khẩu           | 401 / 200 | 200 → `reauth:{sid}` TTL ~300s                    |
| Redis stop                                        | 503  | `SERVICE_UNAVAILABLE`, fail-closed (ADR-015)       |
| Gọi `/auth/logout` không có Bearer               | 401  | Guard authn-only chặn                             |

---

## 8. Dọn

```powershell
docker compose stop
```

(Ctrl+C để dừng API trước.)

## Lưu ý phạm vi (đừng chặn nghiệm thu vì mấy mục này)

- **RBAC / TenantGuard / RLS** → IAM-003. Guard ở IAM-002 chỉ trả lời "đã đăng nhập hay chưa".
- **TOTP** ở `/auth/mfa/verify` và nhánh TOTP của re-auth → IAM-004.
- **Danh sách phiên + thu hồi từng thiết bị** (FR-IAM-15) → theo quyết định Q4 trong `IAM-002-todo.md`.
- **Nối refresh vào FE/Mobile** (single-flight) → task FE/Mobile, không làm ở đây.
