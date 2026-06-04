import { existsSync } from "node:fs";
import { resolve } from "node:path";
import { defineConfig } from "prisma/config";

// Env 2-part (giống loadAppConfig): `.env` (selector NODE_ENV) → `.env.{NODE_ENV}` (values).
// Thay cho dotenv-cli — Prisma CLI (migrate/studio/validate) dùng chung cơ chế env với app.
// Trên Render/Docker không có file `.env*` → đọc env thật từ env group.
const nodeEnv = process.env.NODE_ENV?.trim() || "development";
for (const file of [".env", `.env.${nodeEnv}`]) {
  const path = resolve(process.cwd(), file);
  if (existsSync(path)) {
    process.loadEnvFile(path);
  }
}

export default defineConfig({
  schema: "prisma/schema.prisma",
  migrations: {
    path: "prisma/migrations"
  },
  // Prisma 7: Migrate/Introspect lấy connection URL từ đây (KHÔNG còn `adapter` ở config).
  // Driver adapter (PrismaPg) chỉ truyền vào `PrismaClient` ở runtime (prisma.service.ts).
  datasource: {
    url: process.env.DATABASE_URL ?? ""
  }
});
