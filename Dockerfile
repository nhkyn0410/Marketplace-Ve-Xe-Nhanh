# syntax=docker/dockerfile:1.7

FROM node:24-bookworm-slim AS base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN corepack enable && corepack prepare pnpm@10.27.0 --activate

WORKDIR /workspace

FROM base AS build

COPY . .

RUN pnpm install --frozen-lockfile --filter @vexenhanh/api...
# Prisma 7: generate KHÔNG cần DATABASE_URL (driver adapter, không tải engine binary)
RUN pnpm --filter @vexenhanh/api prisma:generate
RUN pnpm --filter @vexenhanh/api... build
RUN pnpm --filter @vexenhanh/api deploy --legacy --prod /runtime/api

FROM gcr.io/distroless/nodejs24-debian13:nonroot AS runtime

ENV NODE_ENV="production"
ENV PORT="3000"

WORKDIR /app

# Prisma 7 dùng driver adapter (pg) → KHÔNG còn query-engine binary → KHÔNG cần copy libssl.
COPY --from=build /runtime/api ./

EXPOSE 3000

CMD ["dist/main.js"]
