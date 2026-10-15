import { randomBytes, randomUUID } from "node:crypto";
import { existsSync } from "node:fs";
import { resolve } from "node:path";
import { PrismaPg } from "@prisma/adapter-pg";
import Redis from "ioredis";
import { PrismaClient } from "../src/generated/prisma/client";
import { CredentialService } from "../src/iam/auth/credential.service";
import { TEMP_EMAIL_GLOBAL_KEY } from "../src/iam/user/temporary-credential-email-limiter";
import { getRedisUrl } from "../src/redis/redis.config";

/**
 * Seed cho E2E web auth (TASK-IAM-006, TC-SEC-008): mỗi lần chạy tạo bộ tài khoản MỚI với mật khẩu
 * ngẫu nhiên — Owner mật khẩu tạm + Employee DRIVER trong một nhà xe mới, và một Platform admin chưa
 * bật TOTP. In JSON ra stdout cho global-setup của Playwright; KHÔNG ghi file, KHÔNG chạy ở production.
 * Kèm dữ liệu nền cho E2E màn Chuyến xe (TASK-TRN-003): một tuyến ba điểm và một xe đã gắn sơ đồ ghế.
 * E2E màn Nhân viên gửi mật khẩu tạm thật qua API nên seed đặt lại ngân sách email toàn hệ thống ở Redis local.
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

function password(): string {
  return `E2e-${randomBytes(12).toString("base64url")}`;
}

async function main(): Promise<void> {
  loadEnv();
  if (process.env.NODE_ENV === "production") {
    throw new Error("Không seed E2E ở production.");
  }
  // Ghi bảng tenant (RLS) → chạy bằng owner như migrate (TASK-IAM-003).
  const connectionString = process.env.MIGRATION_DATABASE_URL ?? process.env.DATABASE_URL;
  if (!connectionString) {
    throw new Error("MIGRATION_DATABASE_URL (hoặc DATABASE_URL) is required to seed.");
  }
  // Script tạo PLATFORM_ADMIN chưa bật TOTP: chỉ cho DB trên máy local, kể cả khi NODE_ENV bị đặt sai.
  const host = new URL(connectionString).hostname;
  if (!["localhost", "127.0.0.1", "[::1]", "::1"].includes(host)) {
    throw new Error(`E2E seed chỉ chạy với DB local — từ chối host "${host}".`);
  }

  const tag = randomUUID().slice(0, 8);
  const operatorSlug = `e2e-${tag}`;
  const accounts = {
    operatorSlug,
    owner: { username: `owner-${tag}`, temporaryPassword: password(), newPassword: password() },
    // Owner thứ hai cho E2E màn nghiệp vụ (xe, sơ đồ ghế): mật khẩu thường, chưa bật TOTP — spec tự
    // enrollment, không phụ thuộc thứ tự chạy với các ca đăng nhập của `owner`.
    fleetOwner: { username: `fleet-${tag}`, password: password() },
    // Owner thứ ba cho E2E màn điểm dừng / tuyến đường: mỗi spec tự enrollment TOTP một lần nên không dùng
    // chung tài khoản với spec khác.
    routeOwner: { username: `route-${tag}`, password: password() },
    // Owner cho E2E màn Nhân viên + Tài khoản: thao tác nhạy cảm cần xác nhận lại bằng mật khẩu của chính Owner.
    staffOwner: { username: `staff-${tag}`, password: password() },
    // Owner cho E2E màn Chuyến xe, ở một nhà xe RIÊNG kèm tuyến + xe dựng sẵn (`tripFixtures`): dữ liệu nền
    // không được lẫn vào nhà xe ở trên, vì spec xe / điểm dừng kiểm cả trạng thái danh sách rỗng.
    tripOperatorSlug: `e2e-trip-${tag}`,
    tripOwner: { username: `trip-${tag}`, password: password() },
    // `null` khi catalog chưa seed (thiếu phường / loại xe) — spec Chuyến xe sẽ báo cần chạy `db:seed:catalog`.
    tripFixtures: null as { routeName: string; plateNumber: string; seatMapName: string } | null,
    employee: { username: `nv.driver-${tag}`, password: password() },
    platform: { username: `e2e-${tag}`, password: password() }
  };

  const credentials = new CredentialService();
  const [ownerHash, fleetOwnerHash, routeOwnerHash, staffOwnerHash, tripOwnerHash, employeeHash, platformHash] =
    await Promise.all([
      credentials.hash(accounts.owner.temporaryPassword),
      credentials.hash(accounts.fleetOwner.password),
      credentials.hash(accounts.routeOwner.password),
      credentials.hash(accounts.staffOwner.password),
      credentials.hash(accounts.tripOwner.password),
      credentials.hash(accounts.employee.password),
      credentials.hash(accounts.platform.password)
    ]);

  const prisma = new PrismaClient({ adapter: new PrismaPg({ connectionString }) });
  try {
    await prisma.$transaction(async (tx) => {
      await tx.$executeRaw`SELECT set_config('app.scope', 'system', true)`;
      const operator = await tx.operatorProfile.create({
        data: { operatorSlug, displayName: `E2E ${tag}`, status: "ACTIVE" }
      });
      await tx.operatorAccount.create({
        data: {
          operatorId: operator.id,
          operatorSlug,
          username: accounts.owner.username,
          contactEmail: `owner-${tag}@example.com`,
          passwordHash: ownerHash,
          passwordChangeRequired: true,
          temporaryPasswordExpiresAt: new Date(Date.now() + 60 * 60_000)
        }
      });
      await tx.operatorAccount.create({
        data: {
          operatorId: operator.id,
          operatorSlug,
          username: accounts.fleetOwner.username,
          contactEmail: `fleet-${tag}@example.com`,
          passwordHash: fleetOwnerHash
        }
      });
      await tx.operatorAccount.create({
        data: {
          operatorId: operator.id,
          operatorSlug,
          username: accounts.routeOwner.username,
          contactEmail: `route-${tag}@example.com`,
          passwordHash: routeOwnerHash
        }
      });
      await tx.operatorAccount.create({
        data: {
          operatorId: operator.id,
          operatorSlug,
          username: accounts.staffOwner.username,
          contactEmail: `staff-${tag}@example.com`,
          passwordHash: staffOwnerHash
        }
      });
      const tripOperator = await tx.operatorProfile.create({
        data: { operatorSlug: accounts.tripOperatorSlug, displayName: `E2E chuyến ${tag}`, status: "ACTIVE" }
      });
      await tx.operatorAccount.create({
        data: {
          operatorId: tripOperator.id,
          operatorSlug: accounts.tripOperatorSlug,
          username: accounts.tripOwner.username,
          contactEmail: `trip-${tag}@example.com`,
          passwordHash: tripOwnerHash
        }
      });
      accounts.tripFixtures = await seedTripFixtures(tx, tripOperator.id);
      await tx.employeeAccount.create({
        data: { operatorId: operator.id, username: accounts.employee.username, passwordHash: employeeHash, role: "DRIVER" }
      });
    });
    await prisma.platformAccount.create({
      data: { username: accounts.platform.username, passwordHash: platformHash, role: "PLATFORM_ADMIN" }
    });
  } finally {
    await prisma.$disconnect();
  }
  await resetTemporaryPasswordEmailBudget();

  process.stdout.write(`${JSON.stringify(accounts)}\n`);
}

/**
 * Ngân sách email mật khẩu tạm toàn hệ thống là 30 / 24 giờ và mọi lần chạy E2E trên máy dev dùng chung một
 * Redis: không đặt lại thì sau vài chục lần chạy, ca tạo nhân viên nhận 429. Ngân sách theo nhà xe / người thao
 * tác không cần đặt lại vì mỗi lần seed là nhà xe mới. Bộ đếm theo IP của luồng đăng ký nhà xe (TASK-OPR-001, 10
 * lần / giờ) cũng vậy: mọi lần chạy đều từ cùng một IP local. Chỉ đụng Redis local; Redis chưa chạy thì bỏ qua — API
 * khi đó tự trả 503 và spec báo rõ.
 */
async function resetTemporaryPasswordEmailBudget(): Promise<void> {
  const url = getRedisUrl();
  if (!["localhost", "127.0.0.1", "[::1]", "::1"].includes(new URL(url).hostname)) {
    return;
  }
  const redis = new Redis(url, { lazyConnect: true, maxRetriesPerRequest: 1, retryStrategy: () => null });
  try {
    await redis.connect();
    await redis.del(TEMP_EMAIL_GLOBAL_KEY);
    const applicationIpKeys = await redis.keys("opr-app:*:ip:*");
    if (applicationIpKeys.length > 0) {
      await redis.del(...applicationIpKeys);
    }
  } catch {
    // Redis local chưa chạy.
  } finally {
    redis.disconnect();
  }
}

/**
 * Tuyến ba điểm (văn phòng → trạm dừng nghỉ → văn phòng, hai chặng 2 giờ 45 phút) và một xe gắn sơ đồ bốn
 * giường, ghi thẳng DB để E2E màn Chuyến xe không phải dựng lại qua giao diện (các luồng đó đã có spec riêng).
 */
async function seedTripFixtures(
  tx: Parameters<Parameters<PrismaClient["$transaction"]>[0]>[0],
  operatorId: string
): Promise<{ routeName: string; plateNumber: string; seatMapName: string } | null> {
  const ward = await tx.ward.findFirst({ select: { id: true, provinceId: true } });
  const vehicleType = await tx.vehicleType.findFirst({ where: { status: "ACTIVE" }, select: { id: true } });
  if (!ward || !vehicleType) {
    return null;
  }
  const fixtures = { routeName: "E2E Sài Gòn – Đà Lạt", plateNumber: "51B28912", seatMapName: "E2E Giường 4 chỗ" };
  const points = [
    { name: "E2E Văn phòng Sài Gòn", type: "OFFICE", latitude: 10.8142, longitude: 106.7109 },
    { name: "E2E Trạm dừng nghỉ Madagui", type: "REST_STOP", latitude: 11.3912, longitude: 107.5345 },
    { name: "E2E Văn phòng Đà Lạt", type: "OFFICE", latitude: 11.9404, longitude: 108.4583 }
  ] as const;
  const stopPoints = [];
  for (const point of points) {
    stopPoints.push(
      await tx.stopPoint.create({
        data: { ...point, operatorId, address: "Địa chỉ E2E", provinceId: ward.provinceId, wardId: ward.id }
      })
    );
  }
  const last = stopPoints.length - 1;
  const route = await tx.route.create({
    data: {
      operatorId,
      name: fixtures.routeName,
      totalDistanceMeters: 300_000,
      totalDurationSeconds: 19_800,
      metricsSource: "ESTIMATE"
    }
  });
  await tx.routeStop.createMany({
    data: stopPoints.map((point, index) => ({
      operatorId,
      routeId: route.id,
      sequence: index + 1,
      role: index === 0 ? ("ORIGIN" as const) : index === last ? ("DESTINATION" as const) : ("INTERMEDIATE" as const),
      stopPointId: point.id,
      // BR-79: điểm đầu chỉ đón, điểm cuối chỉ trả, trạm dừng nghỉ không đón trả.
      allowPickup: index === 0,
      allowDropoff: index === last,
      latitude: point.latitude,
      longitude: point.longitude,
      distanceMetersFromPrevious: index === 0 ? null : 150_000,
      durationSecondsFromPrevious: index === 0 ? null : 9_900
    }))
  });
  const seatMap = await tx.seatMap.create({
    data: {
      operatorId,
      name: fixtures.seatMapName,
      layout: { decks: [{ deck: 1, rows: 2, columns: 2 }] },
      seatCount: 4
    }
  });
  await tx.seat.createMany({
    data: [1, 2, 3, 4].map((order) => ({
      operatorId,
      seatMapId: seatMap.id,
      code: `A0${order}`,
      deck: 1,
      row: Math.ceil(order / 2),
      column: ((order - 1) % 2) + 1,
      type: "BED" as const
    }))
  });
  await tx.vehicle.create({
    data: { operatorId, plateNumber: fixtures.plateNumber, vehicleTypeId: vehicleType.id, seatMapId: seatMap.id }
  });
  return fixtures;
}

main().catch((error: unknown) => {
  console.error(error instanceof Error ? error.message : error);
  process.exit(1);
});
