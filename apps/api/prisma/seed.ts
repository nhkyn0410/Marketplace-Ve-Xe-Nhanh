import { randomBytes, scrypt } from "node:crypto";
import { existsSync } from "node:fs";
import { resolve } from "node:path";
import { promisify } from "node:util";
import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "../src/generated/prisma/client";

/**
 * Seed IAM-001 — tài khoản tối thiểu để test login 3 namespace (provisioning đầy đủ = IAM-005).
 * Idempotent (upsert). Password hash = cùng format CredentialService (`scrypt$salt$hash`).
 * Đổi mật khẩu mặc định qua SEED_*_PASSWORD env. Chạy: pnpm --filter @vexenhanh/api db:seed
 */
const scryptAsync = promisify(scrypt);

async function hashPassword(password: string): Promise<string> {
  const salt = randomBytes(16);
  const derived = (await scryptAsync(password, salt, 64)) as Buffer;
  return `scrypt$${salt.toString("base64")}$${derived.toString("base64")}`;
}

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
  const connectionString = process.env.DATABASE_URL;
  if (!connectionString) {
    throw new Error("DATABASE_URL is required to seed.");
  }

  const prisma = new PrismaClient({ adapter: new PrismaPg({ connectionString }) });
  try {
    // Platform admin: platform/khanh
    await prisma.platformAccount.upsert({
      where: { username: "khanh" },
      update: {},
      create: {
        username: "khanh",
        passwordHash: await hashPassword(process.env.SEED_PLATFORM_PASSWORD ?? "ChangeMe!Platform1"),
        role: "PLATFORM_ADMIN",
        status: "ACTIVE"
      }
    });

    // Operator tenant + owner: phuongtrang/owner01
    const operator = await prisma.operatorProfile.upsert({
      where: { operatorSlug: "phuongtrang" },
      update: {},
      create: { operatorSlug: "phuongtrang", displayName: "Phương Trang", status: "ACTIVE" }
    });

    await prisma.operatorAccount.upsert({
      where: { operatorSlug_username: { operatorSlug: "phuongtrang", username: "owner01" } },
      update: {},
      create: {
        operatorId: operator.id,
        operatorSlug: "phuongtrang",
        username: "owner01",
        passwordHash: await hashPassword(process.env.SEED_OPERATOR_PASSWORD ?? "ChangeMe!Owner1"),
        role: "OPERATOR_OWNER",
        status: "ACTIVE"
      }
    });

    // Employee (driver): phuongtrang/driver042
    await prisma.employeeAccount.upsert({
      where: { operatorId_username: { operatorId: operator.id, username: "driver042" } },
      update: {},
      create: {
        operatorId: operator.id,
        username: "driver042",
        passwordHash: await hashPassword(process.env.SEED_EMPLOYEE_PASSWORD ?? "ChangeMe!Driver1"),
        role: "DRIVER",
        status: "ACTIVE"
      }
    });

    console.log("Seed IAM done: platform/khanh, phuongtrang/owner01, phuongtrang/driver042");
    await prisma.$disconnect();
  } catch (error) {
    await prisma.$disconnect();
    throw error;
  }
}

main().catch((error: unknown) => {
  console.error(error);
  process.exit(1);
});
