# Marketplace Ve Xe Nhanh

Language: English | [Tiếng Việt](doc/README.vi.md)

Managed marketplace for intercity bus tickets in Vietnam, serving three sides of the business:

- Passenger marketplace
- Operator OS for bus operators and employees
- Platform admin for marketplace operations

The project is implemented as a TypeScript modular monolith in a pnpm + Turborepo monorepo.

## Current Status

Foundation scaffolding has started. `TASK-FND-001` created the monorepo workspace, root tooling, and initial app/package shells. Business modules, database schema, auth, payment, queue jobs, and production integrations are still built through later foundation and feature tasks.

Primary design sources live in `doc/SDLC/`. For coding-agent guidance, read `AGENTS.md` first.

## Stack

| Area | Choice |
| --- | --- |
| Runtime | Node.js 24 LTS, TypeScript strict |
| Package manager | pnpm 10 |
| Monorepo | Turborepo |
| Backend | NestJS 11, nestjs-zod |
| Web | Next.js 16 App Router |
| Mobile | Expo SDK 55+ |
| Operational DB | PostgreSQL 16, Prisma 5 |
| Audit/log DB | MongoDB 7, Mongoose 8 |
| Cache/lock/queue | Redis 7, ioredis, BullMQ |
| Tests | Vitest, Supertest, Playwright, Maestro |
| Observability | Pino, Sentry, OpenTelemetry |

## Repository Layout

```text
apps/
  api/                  NestJS API and worker entrypoints
  marketplace/          Passenger-facing Next.js app
  operator-os/          Operator and employee Next.js dashboard
  admin/                Platform admin Next.js dashboard
  passenger-mobile/     Passenger Expo app
  employee-mobile/      Employee Expo app

packages/
  types/                Zod schemas and shared TypeScript types
  api-client/           Generated API client placeholder
  ui/                   Shared web UI package
  ui-mobile-shared/     Shared mobile UI helpers
  utils/                Shared utilities, including money helpers
  config/               Shared TypeScript configuration
```

## Prerequisites

- Node.js `>=24 <25`
- pnpm `>=10 <11`

The Node version policy is declared through `engines.node` in `package.json` (`>=24 <25`). If pnpm prints an unsupported engine warning, switch the local shell to Node 24 (for example, `nvm use 24`) before running project commands.

## Getting Started

```bash
pnpm install
pnpm typecheck
pnpm lint
pnpm test
pnpm build
```

Run all apps in development mode:

```bash
pnpm dev
```

Run one workspace through Turbo filters when needed:

```bash
pnpm turbo run build --filter=@vexenhanh/api
pnpm turbo run dev --filter=@vexenhanh/marketplace
```

## Root Commands

| Command | Purpose |
| --- | --- |
| `pnpm dev` | Run workspace dev tasks in parallel |
| `pnpm build` | Build all workspaces |
| `pnpm lint` | Lint all workspaces |
| `pnpm typecheck` | Typecheck all workspaces |
| `pnpm test` | Run Vitest across workspaces |
| `pnpm gen:api-client` | Generate the API client package after OpenAPI changes |

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

| File | Purpose |
| --- | --- |
| `AGENTS.md` | Cross-tool coding brief: stack, structure, style, testing, boundaries |
| `CLAUDE.md` | Claude Code operational workflow and project state pointers |
| `doc/context/PROJECT-STATE.md` | Live project status |
| `doc/context/DOMAIN-MAP.md` | Domain and module naming map |
| `doc/context/GLOSSARY.md` | Entity, state, and error-code terminology |
| `doc/SDLC/10-architecture-decision-record.md` | Architecture decisions |
| `doc/SDLC/11-project-task-breakdown.md` | Build task backlog |

## Production Blockers

Two items remain blockers for production use, but do not block local development or sandbox MVP work:

- KYC storage residency decision
- Vietnam payment intermediary license requirements for real escrow/payment operations
