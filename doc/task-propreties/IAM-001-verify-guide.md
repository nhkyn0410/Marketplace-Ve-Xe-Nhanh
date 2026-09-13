# TASK-IAM-001 — Guide kiểm chứng cùng Docker

> Chạy thật IAM-001 (login 3 namespace + Email OTP + OAuth init) trên máy local.
> Lệnh chạy ở repo root `C:\Code\Ve_Xe_Nhanh` (PowerShell). Trạng thái code: typecheck ✓ · lint ✓ · 67 test ✓ · build ✓.

## 0. Tiền đề
- **Docker Desktop đang chạy** (engine up). Nếu vừa bật, đợi icon Docker hết "starting".
- Đã `pnpm install`.

## 1. Bật hạ tầng local
```powershell
docker compose up -d
docker compose ps      # đợi postgres / mongo / redis = (healthy)
```

## 2. Migration + seed
```powershell
# Migration init_iam đã commit sẵn; xác nhận DB đồng bộ:
pnpm --filter @vexenhanh/api exec prisma migrate status
#   → "Database schema is up to date!". Nếu DB trống/mới: pnpm --filter @vexenhanh/api prisma:migrate:dev

# Seed 3 tài khoản test (refresh hash scrypt mỗi lần chạy):
pnpm --filter @vexenhanh/api db:seed
#   → "Seed IAM done: platform/khanh, phuongtrang/owner01, phuongtrang/driver042"
```

**Tài khoản seed** (đổi mật khẩu qua env `SEED_PLATFORM_PASSWORD` / `SEED_OPERATOR_PASSWORD` / `SEED_EMPLOYEE_PASSWORD`):

| Identifier | Password mặc định | Role |
| --- | --- | --- |
| `platform/khanh` | `ChangeMe!Platform1` | PLATFORM_ADMIN |
| `phuongtrang/owner01` | `ChangeMe!Owner1` | OPERATOR_OWNER |
| `phuongtrang/driver042` | `ChangeMe!Driver1` | DRIVER |

## 3. Chạy API
```powershell
pnpm --filter @vexenhanh/api start
```
Đợi log `Nest application successfully started`. Để terminal này MỞ (sẽ in OTP ở bước OTP).
> Dev không set `JWT_ACCESS_PRIVATE_KEY` → sinh keypair **ephemeral** (token mất hiệu lực sau restart). Bình thường.

## 4A. Kiểm chứng bằng Swagger UI (dễ nhất)
Mở **http://localhost:3000/v1/docs** → nhóm **`auth`**, bấm "Try it out":

1. **POST `/auth/platform/login`** — body `{"identifier":"platform/khanh","password":"ChangeMe!Platform1"}` → **200** + `accessToken`.
2. **POST `/auth/operator/login`** — `{"identifier":"phuongtrang/owner01","password":"ChangeMe!Owner1"}` → **200**, token mang `operatorId`+`operatorSlug`.
3. **POST `/auth/otp/request`** — `{"email":"rider@example.com"}` → **200**. **Nhìn terminal API**: dòng `[DEV] OTP sign-in cho r***@example.com: NNNNNN`.
4. **POST `/auth/otp/verify`** — `{"email":"rider@example.com","otp":"NNNNNN"}` (mã vừa lấy) → **200** + passenger token.

## 4B. Kiểm chứng bằng curl.exe (PowerShell — nháy đơn giữ JSON)
```powershell
$base = "http://localhost:3000/v1"
# Platform login (200 + token)
curl.exe -s -w "`n[%{http_code}]`n" -X POST "$base/auth/platform/login" -H "Content-Type: application/json" -d '{"identifier":"platform/khanh","password":"ChangeMe!Platform1"}'
# Operator login (200 + operatorId/operatorSlug)
curl.exe -s -w "`n[%{http_code}]`n" -X POST "$base/auth/operator/login" -H "Content-Type: application/json" -d '{"identifier":"phuongtrang/owner01","password":"ChangeMe!Owner1"}'
# Sai password (401)
curl.exe -s -w "`n[%{http_code}]`n" -X POST "$base/auth/platform/login" -H "Content-Type: application/json" -d '{"identifier":"platform/khanh","password":"WRONG"}'
# OTP request (200 → xem OTP ở terminal API)
curl.exe -s -w "`n[%{http_code}]`n" -X POST "$base/auth/otp/request" -H "Content-Type: application/json" -d '{"email":"rider@example.com"}'
# OTP verify (thay NNNNNN bằng mã ở log → 200 passenger token)
curl.exe -s -w "`n[%{http_code}]`n" -X POST "$base/auth/otp/verify" -H "Content-Type: application/json" -d '{"email":"rider@example.com","otp":"NNNNNN"}'
# Email rác (400 Zod)
curl.exe -s -w "`n[%{http_code}]`n" -X POST "$base/auth/otp/request" -H "Content-Type: application/json" -d '{"email":"not-an-email"}'
# OAuth provider lạ (400)
curl.exe -s -w "`n[%{http_code}]`n" -X POST "$base/auth/oauth/twitter" -H "Content-Type: application/json" -d '{}'
```

## 5. Bảng kỳ vọng

| Case | HTTP | Ghi chú |
| --- | --- | --- |
| platform login đúng | 200 | JWT `scope=platform`, `role=PLATFORM_ADMIN` |
| operator login đúng | 200 | JWT `scope=operator` + `operatorId` + `operatorSlug` |
| sai password | 401 | `AUTH_INVALID_CREDENTIALS` (RFC 7807) |
| operator id vào endpoint platform | 401 | no-leak (cùng code) |
| otp request | 200 | OTP in ở terminal (console notifier) |
| otp verify đúng | 200 | JWT `scope=passenger`, Better Auth tạo user |
| otp verify sai | 401 | `AUTH_INVALID_CREDENTIALS` |
| email rác | 400 | ZodValidationPipe |
| oauth provider lạ | 400 | `AUTH_OAUTH_PROVIDER_UNSUPPORTED` |

## 6. (Tuỳ chọn) Soi JWT + DB
- Dán `accessToken` vào https://jwt.io → xem claims `sub/scope/role/operatorId/operatorSlug/iss/exp`.
- pgAdmin (http://localhost:5050) → DB `vexenhanh_dev` → bảng `platform_accounts`, `operator_accounts`, `employee_accounts`, `operator_profiles`, `users`, `verifications` (OTP), `user_sessions`.

## 7. Dọn
```powershell
# Ctrl+C dừng API. Dừng hạ tầng:
docker compose stop
```

## Lưu ý phạm vi
- **OAuth** (Google/FB/Apple): chỉ test được bước *init* (trả redirect URL); round-trip đầy đủ cần OAuth credential thật + browser → để khi provision (phần callback của task .6).
- **RLS** (multi-tenant DB policy) chưa bật — đóng đinh ở **IAM-003** (bảng đã có `operator_id`).
- **Hardening defer** (xem `IAM-001-todo.md`): brute-force throttle login/OTP-verify, helmet, trust-proxy, OAuth callbackURL allowlist.
