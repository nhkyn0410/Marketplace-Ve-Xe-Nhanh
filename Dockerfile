# syntax=docker/dockerfile:1.7

FROM node:24-bookworm-slim AS base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN apt-get update \
  && apt-get install -y --no-install-recommends openssl \
  && rm -rf /var/lib/apt/lists/*

RUN corepack enable && corepack prepare pnpm@10.27.0 --activate

WORKDIR /workspace

FROM base AS build

COPY . .

RUN pnpm install --frozen-lockfile --filter @vexenhanh/api...
ARG DATABASE_URL="postgresql://vexenhanh:vexenhanh_dev@localhost:5432/vexenhanh_dev?schema=public"
RUN DATABASE_URL="$DATABASE_URL" pnpm --filter @vexenhanh/api prisma:generate
RUN pnpm --filter @vexenhanh/api... build
RUN pnpm --filter @vexenhanh/api deploy --legacy --prod /runtime/api
RUN cd /runtime/api \
  && DATABASE_URL="$DATABASE_URL" node /workspace/node_modules/.pnpm/prisma@5.22.0/node_modules/prisma/build/index.js generate --schema prisma/schema.prisma --allow-no-models

FROM gcr.io/distroless/nodejs24-debian13:nonroot AS runtime

ENV NODE_ENV="production"
ENV PORT="3000"

WORKDIR /app

# Prisma query engine link động libssl/libcrypto — distroless nodejs KHÔNG kèm → copy từ build stage
COPY --from=build /usr/lib/*-linux-gnu/libssl.so.3 /usr/lib/*-linux-gnu/libcrypto.so.3 /usr/lib/x86_64-linux-gnu/
COPY --from=build /runtime/api ./

EXPOSE 3000

CMD ["dist/main.js"]
