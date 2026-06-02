# syntax=docker/dockerfile:1.7

FROM node:24-bookworm-slim AS base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN corepack enable && corepack prepare pnpm@10.27.0 --activate

WORKDIR /workspace

FROM base AS build

COPY . .

RUN pnpm install --frozen-lockfile --filter @vexenhanh/api...
RUN pnpm --filter @vexenhanh/api... build
RUN pnpm --filter @vexenhanh/api deploy --legacy --prod /runtime/api

FROM base AS runtime

ENV NODE_ENV="production"
ENV PORT="3000"

WORKDIR /app

COPY --from=build /runtime/api ./

EXPOSE 3000

CMD ["pnpm", "--filter", "@vexenhanh/api", "start"]
