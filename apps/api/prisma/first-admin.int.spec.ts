import { randomUUID } from "node:crypto";
import { PrismaPg } from "@prisma/adapter-pg";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { connectAudit } from "../src/audit/audit-connect";
import type { AuditService } from "../src/audit/audit.service";
import { PrismaClient } from "../src/generated/prisma/client";
import { createFirstPlatformAdmin, FirstAdminRefusedError } from "./first-admin";

/**
 * Script tạo quản trị viên đầu tiên trên Postgres + Mongo THẬT: suite tự tạo một quản trị viên đã kích hoạt (mật khẩu tạm
 * `NULL` — kiểm điều kiện "quản trị viên dùng được" xử lý đúng giá trị `NULL` trên SQL thật) → script phải từ chối. Ca tạo mới /
 * cấp lại kiểm ở `first-admin.spec.ts`: ở đây không khóa / sửa dữ liệu của suite khác đang chạy song song.
 */
const url = process.env.MIGRATION_DATABASE_URL || process.env.DATABASE_URL;
const mongo = process.env.MONGODB_AUDIT_URI;
const ready = Boolean(url && mongo);
const requireDb = process.env.REQUIRE_DB_TESTS === "1";

describe.skipIf(!ready && !requireDb)("Tạo quản trị viên đầu tiên — Postgres + Mongo thật", () => {
  let prisma: PrismaClient;
  let audit: AuditService;
  let close: () => Promise<void>;
  const tag = randomUUID().slice(0, 8);

  beforeAll(async () => {
    prisma = new PrismaClient({ adapter: new PrismaPg({ connectionString: url! }) });
    ({ audit, close } = await connectAudit(mongo!));
    await prisma.platformAccount.create({ data: { username: `usable-${tag}`, passwordHash: "x", role: "PLATFORM_ADMIN" } });
  });

  afterAll(async () => {
    await prisma?.platformAccount.deleteMany({ where: { username: { in: [`usable-${tag}`, `refused-${tag}`] } } });
    await prisma?.$disconnect();
    await close?.();
  });

  it("đã có quản trị viên đang hoạt động → từ chối, không thêm dòng nào", async () => {
    await expect(createFirstPlatformAdmin(prisma, audit, { username: `refused-${tag}`, email: `refused-${tag}@example.com` })).rejects.toBeInstanceOf(FirstAdminRefusedError);
    expect(await prisma.platformAccount.count({ where: { username: `refused-${tag}` } })).toBe(0);
  }, 30_000);
});
