import { existsSync } from "node:fs";
import { resolve } from "node:path";
import { parseArgs } from "node:util";
import { PrismaPg } from "@prisma/adapter-pg";
import { connectAudit } from "../src/audit/audit-connect";
import { PrismaClient } from "../src/generated/prisma/client";
import { createFirstPlatformAdmin, FirstAdminRefusedError } from "./first-admin";

/**
 * Tạo quản trị viên nền tảng đầu tiên (xem `first-admin.ts`). Chạy từ máy vận hành, trỏ DB + Mongo audit của môi trường
 * cần tạo:
 *   pnpm --filter @vexenhanh/api db:create-first-admin --env-file .env.production --username khanh --email ten@mien.vn
 * Mật khẩu tạm chỉ in ra màn hình một lần — không ghi file / log.
 */
function loadEnv(envFile: string | undefined): void {
  if (envFile) {
    const path = resolve(process.cwd(), envFile);
    if (!existsSync(path)) {
      throw new FirstAdminRefusedError(`Không thấy tệp ${envFile}.`);
    }
    process.loadEnvFile(path);
    return;
  }
  const nodeEnv = process.env.NODE_ENV?.trim() || "development";
  for (const file of [".env", `.env.${nodeEnv}`]) {
    const path = resolve(process.cwd(), file);
    if (existsSync(path)) {
      process.loadEnvFile(path);
    }
  }
}

async function main(): Promise<void> {
  const { values } = parseArgs({
    // pnpm có thể chuyển nguyên dấu `--` ngăn tham số.
    args: process.argv.slice(2).filter((arg) => arg !== "--"),
    options: { "env-file": { type: "string" }, username: { type: "string" }, email: { type: "string" } },
  });
  if (!values.username || !values.email) {
    throw new FirstAdminRefusedError("Cần --username và --email (vd --username khanh --email ten@mien.vn).");
  }
  loadEnv(values["env-file"]);
  // Bảng tài khoản ghi bằng owner như migrate / seed.
  const connectionString = process.env.MIGRATION_DATABASE_URL || process.env.DATABASE_URL;
  const auditUri = process.env.MONGODB_AUDIT_URI;
  if (!connectionString || !auditUri) {
    throw new FirstAdminRefusedError("Cần MIGRATION_DATABASE_URL (hoặc DATABASE_URL) và MONGODB_AUDIT_URI — tạo tài khoản quản trị bắt buộc có audit.");
  }

  const prisma = new PrismaClient({ adapter: new PrismaPg({ connectionString }) });
  const { audit, close } = await connectAudit(auditUri);
  try {
    const result = await createFirstPlatformAdmin(prisma, audit, { username: values.username, email: values.email });
    console.log(
      [
        result.reissued ? "Đã cấp lại mật khẩu tạm (mật khẩu tạm cũ đã hết hạn, tài khoản chưa kích hoạt)." : "Đã tạo quản trị viên đầu tiên.",
        `  Tên đăng nhập : platform/${result.username}`,
        `  Mật khẩu tạm  : ${result.temporaryPassword}`,
        `  Hết hạn lúc   : ${result.expiresAt.toISOString()} (24 giờ)`,
        "Đăng nhập trang Admin → đổi mật khẩu → bật xác thực hai lớp (TOTP). Mật khẩu tạm chỉ hiện một lần.",
      ].join("\n"),
    );
  } finally {
    await Promise.allSettled([prisma.$disconnect(), close()]);
  }
}

main().catch((error: unknown) => {
  console.error(error instanceof FirstAdminRefusedError ? `Không tạo: ${error.message}` : error);
  process.exit(1);
});
