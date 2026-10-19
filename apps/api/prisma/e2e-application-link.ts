import { existsSync } from "node:fs";
import { resolve } from "node:path";
import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "../src/generated/prisma/client";
import { newApplicationToken } from "../src/iam/role/application-access";

/**
 * E2E đăng ký nhà xe (TASK-OPR-001): giả lập việc mở email — cấp link bảo mật mới cho hồ sơ mới nhất của một email
 * liên hệ và in token ra stdout. E2E chạy không gửi email thật (`RESEND_API_KEY=''`) nên không có link nào khác.
 * Dùng: `tsx prisma/e2e-application-link.ts <email>`.
 */
function loadEnv(): void {
  const nodeEnv = process.env.NODE_ENV?.trim() || "development";
  for (const file of [".env", `.env.${nodeEnv}`]) {
    const path = resolve(process.cwd(), file);
    if (existsSync(path)) {
      process.loadEnvFile(path);
    }
  }
}

async function main(): Promise<void> {
  loadEnv();
  if (process.env.NODE_ENV === "production") {
    throw new Error("Không cấp link E2E ở production.");
  }
  const email = process.argv[2]?.trim().toLowerCase();
  if (!email) {
    throw new Error("Cần email liên hệ của hồ sơ.");
  }
  const connectionString = process.env.MIGRATION_DATABASE_URL ?? process.env.DATABASE_URL;
  if (!connectionString) {
    throw new Error("MIGRATION_DATABASE_URL (hoặc DATABASE_URL) is required.");
  }
  const prisma = new PrismaClient({ adapter: new PrismaPg({ connectionString }) });
  try {
    const token = await prisma.$transaction(async (tx) => {
      await tx.$executeRaw`SELECT set_config('app.scope', 'system', true)`;
      const application = await tx.operatorApplication.findFirstOrThrow({
        where: { contactEmail: email },
        orderBy: { createdAt: "desc" },
        select: { id: true },
      });
      const now = new Date();
      await tx.operatorApplicationAccessToken.updateMany({
        where: { applicationId: application.id, revokedAt: null },
        data: { revokedAt: now },
      });
      const issued = newApplicationToken();
      await tx.operatorApplicationAccessToken.create({
        data: { applicationId: application.id, tokenHash: issued.tokenHash, expiresAt: new Date(now.getTime() + 3_600_000) },
      });
      return issued.token;
    });
    process.stdout.write(`${token}\n`);
  } finally {
    await prisma.$disconnect();
  }
}

main().catch((error: unknown) => {
  console.error(error);
  process.exit(1);
});
