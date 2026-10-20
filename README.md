# Marketplace Ve Xe Nhanh

Language: English | [Tiếng Việt](doc/README.vi.md)

Managed marketplace for intercity bus tickets in Vietnam, serving three sides of the business:

- Passenger marketplace
- Operator OS for bus operators and employees
- Platform admin for marketplace operations

The project is implemented as a TypeScript modular monolith in a pnpm + Turborepo monorepo.

## Current Status

Version 1 is under active development. The instructions below cover local setup for the current API, background worker, web apps, and optional Flutter apps. Feature verification guides live in `doc/task-propreties/`.

Primary design sources live in `doc/SDLC/`. For coding-agent guidance, read `AGENTS.md` first.

## Stack

| Area             | Choice                                 |
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

## Repository Layout

```text
apps/
  api/                  NestJS API and worker entrypoints
  marketplace/          Passenger-facing Next.js app
  operator-os/          Operator and employee Next.js dashboard
  admin/                Platform admin Next.js dashboard
  passenger_mobile/     Passenger Flutter app
  employee_mobile/      Employee Flutter app

packages/
  types/                Zod schemas and shared TypeScript types
  api-client/           Generated OpenAPI types and API client helpers
  ui/                   Shared web UI package
  utils/                Shared utilities, including money helpers
  config/               Shared TypeScript configuration
```

## Prerequisites

- Git
- Node.js `>=24 <25`
- pnpm `10.27.0` (pinned in `package.json`)
- Docker Desktop with Docker Compose, running before starting the local infrastructure
- For mobile only: Flutter `3.47.2` (pinned in `.fvmrc`, preferably managed with FVM), plus an emulator or connected device

If pnpm is not installed, install the pinned version after switching to Node 24:

```bash
npm install --global pnpm@10.27.0
node --version
pnpm --version
docker compose version
```

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/nhkyn0410/Marketplace-Ve-Xe-Nhanh.git
cd Marketplace-Ve-Xe-Nhanh
```

Run the following commands from the repository root unless a step explicitly changes directory.

### 2. Create the local environment files

For a fresh clone, run **one** of these blocks according to your shell. Keep your existing environment files when returning to an already configured checkout.

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

The API uses `.env` to select the environment and `.env.development` for local values. Shell environment variables take precedence. The template's database and Redis URLs already match `docker-compose.yml`. Keep `DATABASE_URL` as the app role and `MIGRATION_DATABASE_URL` as the database owner; migrations and seeds use the owner connection.

Operator OS and Admin default to `http://localhost:3000/v1` when `NEXT_PUBLIC_API_BASE_URL` is empty. Marketplace currently has no environment template. The default local setup can boot without external service keys; email OTP delivery requires `RESEND_API_KEY`, and map display requires `NEXT_PUBLIC_GOONG_MAPTILES_KEY`. Keep local environment files out of Git.

### 3. Install dependencies and start the infrastructure

```bash
pnpm install --frozen-lockfile
docker compose up -d postgres mongo redis
docker compose ps
```

Wait until PostgreSQL, MongoDB, and Redis all report `healthy`. Ports `5432`, `27017`, and `6379` must be available. Installation also generates the Prisma client through the API's `postinstall` script.

### 4. Prepare the database and shared packages

```bash
pnpm --filter @vexenhanh/api prisma:migrate:deploy
pnpm --filter @vexenhanh/api db:app-role
pnpm --filter @vexenhanh/api prisma:generate
pnpm --filter @vexenhanh/types build
pnpm --filter @vexenhanh/api-client build
pnpm --filter @vexenhanh/api db:seed:catalog -- --with-samples
```

Apply the committed migrations **before** creating/granting the app role. `prisma:migrate:deploy` applies existing migrations to your local database; use `prisma:migrate:dev` when developing a new schema change. Run `db:app-role` again after applying new migrations so the app role can access new tables.

The shared package builds prepare their `dist/` exports for development. Catalog seeding loads the tracked administrative-unit CSV, vehicle types, amenities, and sample stop points. It does not create demo trips or bookings.

### 5. Create local login accounts (optional)

To sign in to Operator OS or Admin, fill all three variables in `apps/api/.env.development` with passwords of your choice:

```dotenv
SEED_PLATFORM_PASSWORD="<your-platform-password>"
SEED_OPERATOR_PASSWORD="<your-operator-password>"
SEED_EMPLOYEE_PASSWORD="<your-employee-password>"
```

Then run:

```bash
pnpm --filter @vexenhanh/api db:seed
```

| Account | Login identifier | Password variable |
| ------- | ---------------- | ----------------- |
| Platform admin | `platform/khanh` | `SEED_PLATFORM_PASSWORD` |
| Operator owner | `phuongtrang/owner01` | `SEED_OPERATOR_PASSWORD` |
| Employee (driver) | `phuongtrang/nv.driver042` | `SEED_EMPLOYEE_PASSWORD` |

There are no default passwords. Rerunning this local-only seed resets the seeded account passwords to the supplied values.

### 6. Start the apps

Terminal 1 — API and all three web apps:

```bash
pnpm dev
```

Terminal 2 — background worker for BullMQ jobs:

```bash
pnpm --filter @vexenhanh/api dev:worker
```

`pnpm dev` does not start the worker or Flutter apps. Wait for the API's initial build and startup before calling its endpoints.

| Service | Local URL |
| ------- | --------- |
| API health | [localhost:3000/v1/health](http://localhost:3000/v1/health) |
| Swagger UI | [localhost:3000/v1/docs](http://localhost:3000/v1/docs) |
| OpenAPI JSON | [localhost:3000/v1/openapi.json](http://localhost:3000/v1/openapi.json) |
| Passenger marketplace | [localhost:3001](http://localhost:3001) |
| Operator OS | [localhost:3002](http://localhost:3002) |
| Platform admin | [localhost:3003](http://localhost:3003) |

To run selected apps, use separate terminals for each command you need:

```bash
pnpm --filter @vexenhanh/api dev
pnpm --filter @vexenhanh/marketplace dev
pnpm --filter @vexenhanh/operator-os dev
pnpm --filter @vexenhanh/admin dev
```

### 7. Stop and restart local development

Press `Ctrl+C` in the app and worker terminals. Stop the containers while preserving database volumes:

```bash
docker compose down
```

On later sessions, start Docker Desktop, run `docker compose up -d postgres mongo redis`, then `pnpm dev` and the worker command in separate terminals. After pulling changes, run `pnpm install --frozen-lockfile` and repeat step 4 to apply migrations, refresh permissions, and rebuild shared packages.

## Flutter Apps (Optional)

Mobile apps are outside the pnpm/Turborepo workspace. With FVM installed, install the SDK pinned in `.fvmrc` from the repository root:

```bash
fvm install
fvm flutter doctor
fvm flutter devices
```

Passenger app:

```bash
cd apps/passenger_mobile
fvm flutter pub get
fvm flutter run
```

Employee app (in another terminal, starting from the repository root):

```bash
cd apps/employee_mobile
fvm flutter pub get
fvm flutter run
```

If Flutter `3.47.2` is already on your PATH, you can use `flutter` instead of `fvm flutter`. Android requires the Android SDK; iOS requires macOS and Xcode.

The passenger app defaults to API origin `http://localhost:3000`. For an Android emulator, keep the API running and use:

```bash
fvm flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

Alternatively, run `adb reverse tcp:3000 tcp:3000` for a USB-connected Android device and keep the default URL. Use the computer's reachable LAN address for a device on Wi-Fi. `API_BASE_URL` is an origin, without `/v1`.

## Common Commands

Run these from the repository root. The root checks below cover the JavaScript/TypeScript workspace; run Flutter checks inside each mobile app separately.

| Command | Purpose |
| ------- | ------- |
| `pnpm dev` | Run API and three web apps in parallel |
| `pnpm --filter @vexenhanh/api dev:worker` | Run the background worker |
| `pnpm build` | Build all JavaScript/TypeScript workspaces |
| `pnpm lint` | Lint workspaces |
| `pnpm typecheck` | Typecheck workspaces |
| `pnpm test` | Run Vitest; DB integration tests require their infrastructure/environment |
| `pnpm gen:api-client` | Regenerate the TypeScript API contract after OpenAPI changes |
| `pnpm --filter @vexenhanh/api prisma:studio` | Open Prisma Studio |
| `docker compose logs -f postgres mongo redis` | Follow local infrastructure logs |
| `docker compose up -d pgadmin mongo-express` | Start optional DB viewers on ports 5050 and 8081 |

For a single app build, use `pnpm exec turbo run build --filter=@vexenhanh/api`. See [quality checks](doc/runbook/RB-03-quality-check.md) and [API client generation](doc/runbook/RB-04-api-client.md) for additional checks and Dart contract generation.

## Setup Troubleshooting

| Symptom | What to check |
| ------- | ------------- |
| Unsupported Node engine | Switch to Node 24, then reinstall dependencies. |
| Docker cannot connect | Start Docker Desktop and check `docker compose ps`. |
| Port already in use | Stop the conflicting process, or update the service port and the matching connection URL. |
| Database connection/authentication fails | Wait for healthy containers; compare the local API URLs with `docker-compose.yml` and check for shell environment overrides. |
| Missing tables or permission denied | Run `prisma:migrate:deploy`, then `db:app-role`, in that order. |
| Missing Prisma client or shared package exports | Repeat `prisma:generate` and the shared package builds from step 4. |
| Login fails after API restart | Sign in again; development JWT/CSRF keys are generated per process when not configured. |

More local infrastructure details: [RB-05](doc/runbook/RB-05-local-infra.md). Migration workflow: [RB-02](doc/runbook/RB-02-prisma-migration.md).

## Development Rules

- Code, API, and database identifiers use English.
- SDLC documents are written in Vietnamese.
- Use Zod as the validation and OpenAPI source of truth.
- Do not use `number` or floating point values for money. Store VND as `BIGINT` and use Decimal.js wrappers.
- Do not call vendor SDKs directly from domain services. Go through adapters under `external/<provider>/`.
- Keep controllers thin. Business logic belongs in services.
- Enforce tenant isolation in services/repositories and with PostgreSQL RLS.
- Do not log tokens, OTPs, passwords, card data, or raw sensitive PII.

## Testing Expectations

Mandatory coverage areas from the SDLC include:

- Money math using BIGINT/Decimal
- Payment and seat-hold idempotency
- Tenant isolation and RLS behavior
- Webhook HMAC verification
- Refresh-token reuse detection

Use focused tests for narrow changes and broaden test scope when touching shared contracts, auth, payment, tenant isolation, or generated API surfaces.

## Git Workflow

- Branch from the default branch.
- Do not commit directly to the default branch unless explicitly requested.
- Keep one logical change per commit.
- Commit and push only when requested.
- Commit messages should follow the VS Code Copilot instructions in `.github/instructions/commit-message.instructions.md`.

## Key Documents

| File                                          | Purpose                                                               |
| --------------------------------------------- | --------------------------------------------------------------------- |
| `AGENTS.md`                                   | Cross-tool coding brief: stack, structure, style, testing, boundaries |
| `CLAUDE.md`                                   | Claude Code operational workflow and project state pointers           |
| `doc/context/PROJECT-STATE.md`                | Live project status                                                   |
| `doc/context/DOMAIN-MAP.md`                   | Domain and module naming map                                          |
| `doc/context/GLOSSARY.md`                     | Entity, state, and error-code terminology                             |
| `doc/SDLC/10-architecture-decision-record.md` | Architecture decisions                                                |
| `doc/SDLC/11-project-task-breakdown.md`       | Build task backlog                                                    |

## Production Blockers

Two items remain blockers for production use, but do not block local development or sandbox MVP work:

- KYC storage residency decision
- Vietnam payment intermediary license requirements for real escrow/payment operations
