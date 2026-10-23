import { existsSync, readFileSync } from "node:fs";
import { resolve } from "node:path";
import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "../src/generated/prisma/client";
import {
  catalogSeedData,
  parseAdministrativeUnitsCsv,
  parseLegacyAdministrativeMappingsCsv,
  parseStopPointsCatalogCsv,
  seedCatalog,
} from "../src/catalog/catalog-seed";

/**
 * Seed catalog TASK-CAT-001 (DB-MIG-04). Khác `seed.ts`: KHÔNG động vào tài khoản, chỉ create-only
 * dữ liệu chuẩn → chạy được ở production.
 * Các file dữ liệu chuẩn:
 * - `prisma/seed-data/administrative-units.csv`
 * - `prisma/seed-data/legacy-administrative-mappings.csv`
 * - `prisma/seed-data/stop-points-catalog.csv`
 * Chạy: pnpm --filter @vexenhanh/api db:seed:catalog [-- --with-samples]
 */
const CSV_PATH = "prisma/seed-data/administrative-units.csv";
const LEGACY_CSV_PATH = "prisma/seed-data/legacy-administrative-mappings.csv";
const STOP_POINTS_CSV_PATH = "prisma/seed-data/stop-points-catalog.csv";

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

  const csvPath = resolve(process.cwd(), CSV_PATH);
  if (!existsSync(csvPath)) {
    throw new Error(
      `Thiếu ${CSV_PATH} — xem doc/task-propreties/CAT-001-guide.md §2A.`,
    );
  }
  const legacyCsvPath = resolve(process.cwd(), LEGACY_CSV_PATH);
  const stopPointsCsvPath = resolve(process.cwd(), STOP_POINTS_CSV_PATH);

  const legacyMappings = existsSync(legacyCsvPath)
    ? parseLegacyAdministrativeMappingsCsv(readFileSync(legacyCsvPath, "utf8"))
    : undefined;
  const catalogStopPoints = existsSync(stopPointsCsvPath)
    ? parseStopPointsCatalogCsv(readFileSync(stopPointsCsvPath, "utf8"))
    : undefined;

  const withSamples = process.argv.includes("--with-samples");

  // Kiểm toàn bộ file TRƯỚC khi mở kết nối: sai định dạng thì không ghi dòng nào.
  const data = catalogSeedData(
    parseAdministrativeUnitsCsv(readFileSync(csvPath, "utf8")),
    {
      nodeEnv: process.env.NODE_ENV,
      withSamples,
      ...(legacyMappings !== undefined ? { legacyMappings } : {}),
      ...(catalogStopPoints !== undefined ? { catalogStopPoints } : {}),
    },
  );

  // Catalog bật FORCE RLS → ghi bằng owner như migrate, trong ngữ cảnh system (giống seed.ts).
  const connectionString =
    process.env.MIGRATION_DATABASE_URL ?? process.env.DATABASE_URL;
  if (!connectionString) {
    throw new Error(
      "MIGRATION_DATABASE_URL (hoặc DATABASE_URL) is required to seed.",
    );
  }
  // Chỉ in host/DB (không user/mật khẩu) để người chạy thấy ngay nếu đang trỏ nhầm môi trường.
  const target = new URL(connectionString);
  console.log(
    `Seed catalog → ${target.host}${target.pathname} (ánh xạ hành chính cũ: ${data.legacyMappings?.length ?? 0}, điểm dừng chuẩn: ${data.sampleStopPoints.length})`,
  );

  const prisma = new PrismaClient({
    adapter: new PrismaPg({ connectionString }),
  });
  try {
    const result = await prisma.$transaction(
      async (tx) => {
        await tx.$executeRaw`SELECT set_config('app.scope', 'system', true)`;
        return seedCatalog(tx, data);
      },
      { timeout: 60_000 },
    );
    console.log(
      `Đọc file: ${data.provinces.length} tỉnh, ${data.wards.length} xã, ${data.legacyMappings?.length ?? 0} ánh xạ cũ, ${data.sampleStopPoints.length} điểm dừng. ` +
        `Tạo mới: ${result.provinces} tỉnh, ${result.wards} xã, ${result.legacyMappings ?? 0} ánh xạ cũ, ` +
        `${result.vehicleTypes} loại xe, ${result.amenities} tiện ích, ${result.stopPoints} điểm dừng chuẩn.`,
    );
    if (result.skippedStopPoints.length > 0) {
      console.warn(
        `Bỏ qua điểm dừng (không tìm thấy phường): ${result.skippedStopPoints.join(", ")}`,
      );
    }
  } finally {
    await prisma.$disconnect();
  }
}

main().catch((error: unknown) => {
  console.error(error);
  process.exit(1);
});
