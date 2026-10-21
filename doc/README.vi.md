# Marketplace Ve Xe Nhanh

Ngôn ngữ: [English](../README.md) | Tiếng Việt

Marketplace quản lý bán vé xe khách liên tỉnh tại Việt Nam, phục vụ ba phía của hệ thống:

- Marketplace cho hành khách
- Operator OS cho nhà xe và nhân viên vận hành
- Platform admin cho đội ngũ quản trị nền tảng

Dự án được triển khai theo hướng modular monolith bằng TypeScript trong monorepo pnpm + Turborepo.

## Trạng Thái Hiện Tại

Phiên bản v1 đang được phát triển. Hướng dẫn dưới đây dành cho việc thiết lập API, background worker, các web app và Flutter app hiện có trên máy local. Hướng dẫn nghiệm thu từng tính năng nằm trong `doc/task-propreties/`.

Nguồn thiết kế chính nằm trong `doc/SDLC/`. Khi bắt đầu code, đọc `AGENTS.md` trước để nắm stack, cấu trúc, code style, testing, và boundary của dự án.

## Stack

| Khu vực          | Lựa chọn                               |
| ---------------- | -------------------------------------- |
| Runtime          | Node.js 24 LTS, TypeScript strict      |
| Package manager  | pnpm 10                                |
| Monorepo         | Turborepo                              |
| Backend          | NestJS 11, nestjs-zod                  |
| Web              | Next.js 16 App Router                  |
| Mobile           | Flutter 3.x + Dart 3.x                 |
| Operational DB   | PostgreSQL 16, Prisma 7.8.0            |
| Audit/log DB     | MongoDB 7, Mongoose 8                  |
| Cache/lock/queue | Redis 7, ioredis, BullMQ               |
| Tests            | Vitest, Supertest, Playwright, Maestro |
| Observability    | Pino, Sentry, OpenTelemetry            |

## Cấu Trúc Repository

```text
apps/
  api/                  NestJS API và worker entrypoints
  marketplace/          Next.js app cho hành khách
  operator-os/          Next.js dashboard cho nhà xe và nhân viên
  admin/                Next.js dashboard cho platform admin
  passenger_mobile/     Flutter app cho hành khách
  employee_mobile/      Flutter app cho nhân viên

packages/
  types/                Zod schemas và shared TypeScript types
  api-client/           Kiểu dữ liệu sinh từ OpenAPI và API client helpers
  ui/                   Shared web UI package
  utils/                Shared utilities, gồm money helpers
  config/               Shared TypeScript configuration
```

## Yêu Cầu Môi Trường

- Git
- Node.js `>=24 <25`
- pnpm `10.27.0` (được ghim trong `package.json`)
- Docker Desktop có Docker Compose; cần bật trước khi chạy hạ tầng local
- Chỉ khi chạy mobile: Flutter `3.47.2` (được ghim trong `.fvmrc`, nên quản lý bằng FVM), cùng máy ảo hoặc thiết bị kết nối

Nếu chưa có pnpm, cài đúng phiên bản sau khi chuyển sang Node 24:

```bash
npm install --global pnpm@10.27.0
node --version
pnpm --version
docker compose version
```

## Bắt Đầu Nhanh

### 1. Clone repository

```bash
git clone https://github.com/nhkyn0410/Marketplace-Ve-Xe-Nhanh.git
cd Marketplace-Ve-Xe-Nhanh
```

Chạy các lệnh tiếp theo tại thư mục gốc repository, trừ khi bước đó có lệnh chuyển thư mục.

### 2. Tạo các file môi trường local

Với lần clone mới, chạy **một** trong hai nhóm lệnh dưới đây theo shell đang dùng. Giữ lại file môi trường hiện có nếu checkout đã được cấu hình trước đó.

Windows PowerShell:

```powershell
Set-Content -Path apps/api/.env -Value 'NODE_ENV=development' -Encoding ascii
Copy-Item apps/api/.env.example apps/api/.env.development
Copy-Item apps/operator-os/.env.example apps/operator-os/.env.local
Copy-Item apps/admin/.env.example apps/admin/.env.local
```

macOS / Linux / Git Bash:

```bash
printf 'NODE_ENV=development\n' > apps/api/.env
cp apps/api/.env.example apps/api/.env.development
cp apps/operator-os/.env.example apps/operator-os/.env.local
cp apps/admin/.env.example apps/admin/.env.local
```

API dùng `.env` để chọn môi trường và `.env.development` để lưu giá trị local. Biến đã đặt trong shell được ưu tiên hơn file. URL database và Redis trong template đã khớp với `docker-compose.yml`. Giữ `DATABASE_URL` là role app và `MIGRATION_DATABASE_URL` là owner database; migration và seed dùng kết nối owner.

Operator OS và Admin mặc định gọi `http://localhost:3000/v1` khi để trống `NEXT_PUBLIC_API_BASE_URL`. Marketplace hiện chưa có template môi trường. Cấu hình local mặc định có thể khởi động khi chưa có khóa dịch vụ ngoài; gửi email OTP cần `RESEND_API_KEY`, hiển thị bản đồ cần `NEXT_PUBLIC_GOONG_MAPTILES_KEY`. Không đưa các file môi trường local vào Git.

### 3. Cài dependency và bật hạ tầng

```bash
pnpm install --frozen-lockfile
docker compose up -d postgres mongo redis
docker compose ps
```

Chờ PostgreSQL, MongoDB và Redis đều báo `healthy`. Các cổng `5432`, `27017` và `6379` phải còn trống. Bước cài dependency cũng sinh Prisma client qua script `postinstall` của API.

### 4. Chuẩn bị database và package dùng chung

```bash
pnpm --filter @vexenhanh/api prisma:migrate:deploy
pnpm --filter @vexenhanh/api db:app-role
pnpm --filter @vexenhanh/api prisma:generate
pnpm --filter @vexenhanh/types build
pnpm --filter @vexenhanh/api-client build
pnpm --filter @vexenhanh/api db:seed:catalog -- --with-samples
```

Phải áp dụng migration đã commit **trước khi** tạo/cấp quyền role app. `prisma:migrate:deploy` áp dụng các migration hiện có vào database local; dùng `prisma:migrate:dev` khi phát triển thay đổi schema mới. Chạy lại `db:app-role` sau khi áp dụng migration mới để role app có quyền truy cập bảng mới.

Build các package dùng chung để chuẩn bị phần export trong `dist/` cho chế độ development. Seed catalog nạp file CSV đơn vị hành chính có sẵn trong repo, loại xe, tiện ích và bến xe mẫu. Bước này chưa tạo chuyến xe hoặc booking mẫu.

### 5. Tạo tài khoản đăng nhập local (tùy chọn)

Để đăng nhập Operator OS hoặc Admin, điền đủ ba biến trong `apps/api/.env.development` bằng mật khẩu tự chọn:

```dotenv
SEED_PLATFORM_PASSWORD="<your-platform-password>"
SEED_OPERATOR_PASSWORD="<your-operator-password>"
SEED_EMPLOYEE_PASSWORD="<your-employee-password>"
```

Sau đó chạy:

```bash
pnpm --filter @vexenhanh/api db:seed
```

| Tài khoản | Định danh đăng nhập | Biến mật khẩu |
| --------- | ------------------- | ------------- |
| Platform admin | `platform/khanh` | `SEED_PLATFORM_PASSWORD` |
| Chủ nhà xe | `phuongtrang/owner01` | `SEED_OPERATOR_PASSWORD` |
| Nhân viên (tài xế) | `phuongtrang/nv.driver042` | `SEED_EMPLOYEE_PASSWORD` |

Không có mật khẩu mặc định. Chạy lại seed chỉ dành cho local này sẽ đặt lại mật khẩu các tài khoản mẫu theo giá trị đã cung cấp.

### 6. Chạy các ứng dụng

Terminal 1 — API và cả ba web app:

```bash
pnpm dev
```

Terminal 2 — background worker xử lý BullMQ job:

```bash
pnpm --filter @vexenhanh/api dev:worker
```

`pnpm dev` chưa khởi động worker hoặc Flutter app. Chờ API build lần đầu và khởi động xong trước khi gọi endpoint.

| Dịch vụ | Địa chỉ local |
| ------- | ------------- |
| API health | [localhost:3000/v1/health](http://localhost:3000/v1/health) |
| Swagger UI | [localhost:3000/v1/docs](http://localhost:3000/v1/docs) |
| OpenAPI JSON | [localhost:3000/v1/openapi.json](http://localhost:3000/v1/openapi.json) |
| Marketplace hành khách | [localhost:3001](http://localhost:3001) |
| Operator OS | [localhost:3002](http://localhost:3002) |
| Platform admin | [localhost:3003](http://localhost:3003) |

Nếu chỉ cần một số app, chạy mỗi lệnh cần dùng trong một terminal riêng:

```bash
pnpm --filter @vexenhanh/api dev
pnpm --filter @vexenhanh/marketplace dev
pnpm --filter @vexenhanh/operator-os dev
pnpm --filter @vexenhanh/admin dev
```

### 7. Dừng và chạy lại ở lần sau

Nhấn `Ctrl+C` trong các terminal chạy app và worker. Tắt container nhưng giữ dữ liệu trong volume:

```bash
docker compose down
```

Ở lần làm việc sau, bật Docker Desktop, chạy `docker compose up -d postgres mongo redis`, rồi chạy `pnpm dev` và lệnh worker trong hai terminal riêng. Sau khi pull thay đổi, chạy `pnpm install --frozen-lockfile` và lặp lại bước 4 để áp dụng migration, cập nhật quyền và build lại package dùng chung.

## Chạy Flutter App (Tùy Chọn)

Các mobile app nằm ngoài workspace pnpm/Turborepo. Sau khi cài FVM, cài SDK được ghim trong `.fvmrc` từ thư mục gốc repository:

```bash
fvm install
fvm flutter doctor
fvm flutter devices
```

App hành khách:

```bash
cd apps/passenger_mobile
fvm flutter pub get
fvm flutter run
```

App nhân viên (ở terminal khác, bắt đầu từ thư mục gốc repository):

```bash
cd apps/employee_mobile
fvm flutter pub get
fvm flutter run
```

Nếu Flutter `3.47.2` đã có trong PATH, có thể dùng `flutter` thay cho `fvm flutter`. Android cần Android SDK; iOS cần macOS và Xcode.

App hành khách mặc định dùng API origin `http://localhost:3000`. Với máy ảo Android, giữ API đang chạy và dùng:

```bash
fvm flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

Hoặc chạy `adb reverse tcp:3000 tcp:3000` cho thiết bị Android nối USB để giữ URL mặc định. Thiết bị qua Wi-Fi dùng địa chỉ LAN có thể truy cập của máy tính. `API_BASE_URL` là origin, không thêm `/v1`.

## Lệnh Thường Dùng

Chạy các lệnh này tại thư mục gốc repository. Các lệnh kiểm tra gốc bên dưới dành cho workspace JavaScript/TypeScript; kiểm tra Flutter cần chạy riêng trong từng mobile app.

| Lệnh | Mục đích |
| ---- | -------- |
| `pnpm dev` | Chạy song song API và ba web app |
| `pnpm --filter @vexenhanh/api dev:worker` | Chạy background worker |
| `pnpm build` | Build tất cả workspace JavaScript/TypeScript |
| `pnpm lint` | Lint các workspace |
| `pnpm typecheck` | Typecheck các workspace |
| `pnpm test` | Chạy Vitest; test tích hợp DB cần hạ tầng/biến môi trường tương ứng |
| `pnpm gen:api-client` | Sinh lại hợp đồng API TypeScript sau khi OpenAPI thay đổi |
| `pnpm --filter @vexenhanh/api prisma:studio` | Mở Prisma Studio |
| `docker compose logs -f postgres mongo redis` | Theo dõi log hạ tầng local |
| `docker compose up -d pgadmin mongo-express` | Bật công cụ xem DB tùy chọn ở cổng 5050 và 8081 |

Để build riêng một app, dùng `pnpm exec turbo run build --filter=@vexenhanh/api`. Xem [kiểm tra chất lượng](runbook/RB-03-quality-check.md) và [sinh API client](runbook/RB-04-api-client.md) để biết các bước kiểm tra bổ sung và sinh hợp đồng Dart.

## Lỗi Thiết Lập Thường Gặp

| Biểu hiện | Cách kiểm tra |
| --------- | ------------- |
| Unsupported Node engine | Chuyển sang Node 24 rồi cài lại dependency. |
| Không kết nối được Docker | Bật Docker Desktop và kiểm tra `docker compose ps`. |
| Cổng đang được sử dụng | Dừng tiến trình chiếm cổng, hoặc đổi cổng dịch vụ và URL kết nối tương ứng. |
| Lỗi kết nối/xác thực database | Chờ container healthy; đối chiếu URL API local với `docker-compose.yml` và kiểm tra biến shell đang ghi đè. |
| Thiếu bảng hoặc permission denied | Chạy lần lượt `prisma:migrate:deploy`, rồi `db:app-role`. |
| Thiếu Prisma client hoặc export package dùng chung | Chạy lại `prisma:generate` và các lệnh build package ở bước 4. |
| Đăng nhập lỗi sau khi restart API | Đăng nhập lại; khóa JWT/CSRF development được sinh theo tiến trình khi chưa cấu hình cố định. |

Chi tiết hạ tầng local: [RB-05](runbook/RB-05-local-infra.md). Quy trình migration: [RB-02](runbook/RB-02-prisma-migration.md).

## Quy Tắc Phát Triển

- Code, API, và database identifiers dùng English.
- Tài liệu SDLC viết bằng tiếng Việt.
- Dùng Zod làm nguồn validation và OpenAPI duy nhất.
- Không dùng `number` hoặc floating point cho tiền. Lưu VND bằng `BIGINT` và dùng Decimal.js wrappers.
- Không gọi vendor SDK trực tiếp từ domain services. Đi qua adapters dưới `external/<provider>/`.
- Controller phải mỏng. Business logic nằm trong service.
- Enforce tenant isolation ở services/repositories và PostgreSQL RLS.
- Không log tokens, OTPs, passwords, card data, hoặc raw sensitive PII.

## Kỳ Vọng Testing

Các vùng bắt buộc phải có coverage theo SDLC:

- Money math bằng BIGINT/Decimal
- Idempotency cho payment và seat-hold
- Tenant isolation và RLS behavior
- Webhook HMAC verification
- Refresh-token reuse detection

Với thay đổi nhỏ, viết test tập trung. Khi chạm shared contracts, auth, payment, tenant isolation, hoặc generated API surfaces, mở rộng phạm vi test tương ứng.

## Git Workflow

- Branch từ default branch.
- Không commit trực tiếp lên default branch trừ khi được yêu cầu rõ.
- Một commit cho một thay đổi logic.
- Chỉ commit/push khi được yêu cầu.
- Commit message theo hướng dẫn Copilot trong `.github/instructions/commit-message.instructions.md`.

## Tài Liệu Quan Trọng

| File                                          | Vai trò                                                               |
| --------------------------------------------- | --------------------------------------------------------------------- |
| `AGENTS.md`                                   | Coding brief cross-tool: stack, structure, style, testing, boundaries |
| `CLAUDE.md`                                   | Claude Code operational workflow và project state pointers            |
| `doc/context/PROJECT-STATE.md`                | Trạng thái sống của dự án                                             |
| `doc/context/DOMAIN-MAP.md`                   | Map domain và tên module                                              |
| `doc/context/GLOSSARY.md`                     | Thuật ngữ entity, state, error-code                                   |
| `doc/SDLC/10-architecture-decision-record.md` | Architecture decisions                                                |
| `doc/SDLC/11-project-task-breakdown.md`       | Build task backlog                                                    |

## Production Blockers

Hai điểm sau còn là blocker cho production, nhưng không chặn local development hoặc sandbox MVP:

- Quyết định về KYC storage residency
- Yêu cầu giấy phép trung gian thanh toán tại Việt Nam cho vận hành escrow/payment thật
