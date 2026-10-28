import { randomBytes, randomUUID } from "node:crypto";
import { existsSync } from "node:fs";
import { resolve } from "node:path";
import { PrismaPg } from "@prisma/adapter-pg";
import Redis from "ioredis";
import { PrismaClient } from "../src/generated/prisma/client";
import { LocalStorageProvider } from "../src/external/storage/local-storage-provider";
import { CredentialService } from "../src/iam/auth/credential.service";
import { TEMP_EMAIL_GLOBAL_KEY } from "../src/iam/user/temporary-credential-email-limiter";
import { getRedisUrl } from "../src/redis/redis.config";
import { vehicleImageKey } from "../src/vehicle/vehicle-image-format";

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
    // Owner cho E2E màn Hồ sơ & KYC (TASK-OPR-001b), ở một nhà xe RIÊNG đã có hồ sơ pháp lý + tài khoản nhận tiền.
    kycOperatorSlug: `e2e-kyc-${tag}`,
    kycOwner: { username: `kyc-${tag}`, password: password() },
    // Owner cho E2E màn Chuyến xe, ở một nhà xe RIÊNG kèm tuyến + xe dựng sẵn (`tripFixtures`): dữ liệu nền
    // không được lẫn vào nhà xe ở trên, vì spec xe / điểm dừng kiểm cả trạng thái danh sách rỗng.
    tripOperatorSlug: `e2e-trip-${tag}`,
    tripOwner: { username: `trip-${tag}`, password: password() },
    // `null` khi catalog chưa seed (thiếu phường / loại xe) — spec Chuyến xe sẽ báo cần chạy `db:seed:catalog`.
    tripFixtures: null as { routeName: string; plateNumber: string; seatMapName: string } | null,
    // Owner cho E2E màn Phân công chuyến (TASK-EMP-001), ở một nhà xe RIÊNG có hai tài xế + một nhân viên vé và các chuyến
    // dựng sẵn (`assignmentFixtures`) — không lẫn vào danh sách chuyến của spec Chuyến xe.
    assignOperatorSlug: `e2e-asg-${tag}`,
    assignOwner: { username: `asg-${tag}`, password: password() },
    assignmentFixtures: null as AssignmentFixtures | null,
    // Owner cho E2E màn Đặt vé (TASK-OPR-003), ở một nhà xe RIÊNG có một chuyến mở bán + hai đơn dựng sẵn
    // (`bookingFixtures`): một đơn đã xác nhận có vé, một đơn chờ thanh toán. `null` khi catalog chưa seed.
    bookingOperatorSlug: `e2e-bkg-${tag}`,
    bookingOwner: { username: `bkg-${tag}`, password: password() },
    bookingFixtures: null as BookingFixtures | null,
    // E2E màn Điểm dừng của Admin (TASK-ADM-004): một đề xuất chờ duyệt + một điểm riêng để khóa, ở nhà xe chuyến.
    // `null` khi catalog chưa seed (thiếu phường).
    adminStopPoints: null as AdminStopPointFixtures | null,
    employee: { username: `nv.driver-${tag}`, password: password() },
    platform: { username: `e2e-${tag}`, password: password() },
    // Quản trị viên thứ hai cho E2E duyệt hồ sơ nhà xe (cổng Admin): mỗi spec tự bật TOTP một lần.
    platformReviewer: { username: `e2e-review-${tag}`, password: password() },
    // Quản trị viên thứ ba cho E2E màn Điểm dừng của Admin.
    platformCatalog: { username: `e2e-catalog-${tag}`, password: password() },
    // Quản trị viên thứ tư cho E2E màn Danh mục chuẩn (tỉnh / phường / loại xe / tiện ích).
    platformData: { username: `e2e-data-${tag}`, password: password() },
    // Quản trị viên thứ năm cho E2E màn Kiểm duyệt ảnh phương tiện + Nhật ký audit.
    platformModeration: { username: `e2e-mod-${tag}`, password: password() },
    // Quản trị viên thứ sáu cho E2E màn Bài viết (TASK-CNT-001).
    platformContent: { username: `e2e-cnt-${tag}`, password: password() },
    // Quản trị viên thứ bảy cho E2E quản lý nhà xe + người dùng; kèm một nhà xe để tạm khóa và một hành khách để khóa.
    platformUsers: { username: `e2e-usr-${tag}`, password: password() },
    // Quản trị viên thứ tám cho E2E màn Chính sách (TASK-ADM-001 phần chính sách) + một nhà xe để làm phạm vi riêng /
    // mức hoa hồng riêng (không đụng chính sách mặc định dùng chung giữa các lần chạy).
    platformPolicy: { username: `e2e-pol-${tag}`, password: password() },
    // Quản trị viên thứ chín cho E2E màn Chi trả nhà xe (TASK-BTP-006 / ADM-002) — kỳ chờ rà soát của nhà xe đặt vé.
    platformFinance: { username: `e2e-fin-${tag}`, password: password() },
    // Quản trị viên thứ mười cho E2E màn Thanh toán & hoàn tiền (TASK-ADM-002).
    platformPayments: { username: `e2e-pay-${tag}`, password: password() },
    // Quản trị viên thứ mười một cho E2E Tổng quan + Báo cáo Admin (TASK-RPT-002).
    platformReports: { username: `e2e-rpt-${tag}`, password: password() },
    // Quản trị viên thứ mười hai cho E2E Khiếu nại & tranh chấp + kiểm duyệt đánh giá (TASK-TRUST-001).
    platformTrust: { username: `e2e-trust-${tag}`, password: password() },
    // Quản trị viên thứ mười ba cho E2E Khuyến mãi (TASK-PROM-001).
    platformPromo: { username: `e2e-promo-${tag}`, password: password() },
    // Quản trị viên thứ mười bốn cho E2E VXN Plus (TASK-LOY-001) + một hành khách có sổ điểm (tích 300 + điều chỉnh 50).
    platformLoyalty: { username: `e2e-loy-${tag}`, password: password() },
    loyalty: { passengerEmail: `e2e-member-${tag}@example.com`, passengerName: `Thành viên E2E ${tag}` },
    adminPolicy: { operatorName: `E2E chính sách ${tag}`, operatorSlug: `e2e-pol-${tag}` },
    adminUsers: {
      operatorName: `E2E khóa ${tag}`,
      operatorSlug: `e2e-lock-${tag}`,
      passengerEmail: `e2e-rider-${tag}@example.com`
    },
    // Nhà xe RIÊNG có một xe hai ảnh để gỡ (không đụng xe của spec Chuyến xe / Phương tiện). `null` khi chưa có loại xe.
    moderation: null as ModerationFixtures | null
  };

  const credentials = new CredentialService();
  const [
    ownerHash,
    fleetOwnerHash,
    routeOwnerHash,
    staffOwnerHash,
    tripOwnerHash,
    kycOwnerHash,
    assignOwnerHash,
    bookingOwnerHash,
    employeeHash,
    platformHash,
    reviewerHash,
    catalogHash,
    dataHash,
    moderationHash,
    contentHash,
    usersHash,
    policyHash,
    financeHash,
    paymentsHash,
    reportsHash,
    trustHash,
    promoHash,
    loyaltyHash
  ] = await Promise.all([
    credentials.hash(accounts.owner.temporaryPassword),
    credentials.hash(accounts.fleetOwner.password),
    credentials.hash(accounts.routeOwner.password),
    credentials.hash(accounts.staffOwner.password),
    credentials.hash(accounts.tripOwner.password),
    credentials.hash(accounts.kycOwner.password),
    credentials.hash(accounts.assignOwner.password),
    credentials.hash(accounts.bookingOwner.password),
    credentials.hash(accounts.employee.password),
    credentials.hash(accounts.platform.password),
    credentials.hash(accounts.platformReviewer.password),
    credentials.hash(accounts.platformCatalog.password),
    credentials.hash(accounts.platformData.password),
    credentials.hash(accounts.platformModeration.password),
    credentials.hash(accounts.platformContent.password),
    credentials.hash(accounts.platformUsers.password),
    credentials.hash(accounts.platformPolicy.password),
    credentials.hash(accounts.platformFinance.password),
    credentials.hash(accounts.platformPayments.password),
    credentials.hash(accounts.platformReports.password),
    credentials.hash(accounts.platformTrust.password),
    credentials.hash(accounts.platformPromo.password),
    credentials.hash(accounts.platformLoyalty.password)
  ]);

  const prisma = new PrismaClient({ adapter: new PrismaPg({ connectionString }) });
  let moderationImages: Awaited<ReturnType<typeof seedModerationFixtures>> = null;
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
      const kycOperator = await tx.operatorProfile.create({
        data: {
          operatorSlug: accounts.kycOperatorSlug,
          displayName: `E2E hồ sơ ${tag}`,
          status: "ACTIVE",
          legalName: `Công ty TNHH E2E ${tag}`,
          taxCode: "0312345678",
          hotline: "19006868",
          publicEmail: `lienhe-${tag}@example.com`,
          address: "266 Đồng Đen, TP. Hồ Chí Minh",
          approvedAt: new Date()
        }
      });
      await tx.operatorAccount.create({
        data: {
          operatorId: kycOperator.id,
          operatorSlug: accounts.kycOperatorSlug,
          username: accounts.kycOwner.username,
          contactEmail: `kyc-${tag}@example.com`,
          passwordHash: kycOwnerHash
        }
      });
      await tx.bankAccount.create({
        data: {
          operatorId: kycOperator.id,
          bankName: "Vietcombank",
          accountNumber: "0071000124521",
          accountHolder: "CTY TNHH E2E",
          status: "VERIFIED",
          reviewedAt: new Date()
        }
      });
      accounts.tripFixtures = await seedTripFixtures(tx, tripOperator.id);
      accounts.assignmentFixtures = await seedAssignmentFixtures(tx, accounts.assignOperatorSlug, accounts.assignOwner.username, assignOwnerHash, tag);
      accounts.bookingFixtures = await seedBookingFixtures(tx, accounts.bookingOperatorSlug, accounts.bookingOwner.username, bookingOwnerHash, tag);
      accounts.adminStopPoints = await seedAdminStopPointFixtures(tx, tripOperator.id, tag);
      moderationImages = await seedModerationFixtures(tx, tag);
      const lockable = await tx.operatorProfile.create({
        data: { operatorSlug: accounts.adminUsers.operatorSlug, displayName: accounts.adminUsers.operatorName, status: "ACTIVE" }
      });
      await tx.operatorAccount.create({
        data: {
          operatorId: lockable.id,
          operatorSlug: accounts.adminUsers.operatorSlug,
          username: "owner01",
          contactEmail: `lock-${tag}@example.com`,
          passwordHash: "e2e-not-for-login"
        }
      });
      // Một tài khoản nhận tiền đã xác minh + một yêu cầu đổi đang chờ để E2E Admin xác minh (TASK-OPR-001b).
      await tx.bankAccount.createMany({
        data: [
          {
            operatorId: lockable.id,
            bankName: "Vietcombank",
            accountNumber: "0071000124521",
            accountHolder: "CTY E2E KHOA",
            status: "VERIFIED",
            reviewedAt: new Date(),
            createdAt: new Date(Date.now() - 60_000),
            updatedAt: new Date()
          },
          {
            operatorId: lockable.id,
            bankName: "Techcombank",
            accountNumber: "190366880011",
            accountHolder: "CTY E2E KHOA",
            status: "PENDING",
            changeReason: "Đổi sang tài khoản công ty mới",
            updatedAt: new Date()
          }
        ]
      });
      await tx.operatorProfile.create({
        data: { operatorSlug: accounts.adminPolicy.operatorSlug, displayName: accounts.adminPolicy.operatorName, status: "ACTIVE" }
      });
      await tx.user.create({
        data: { id: `e2erider${tag}`, email: accounts.adminUsers.passengerEmail, name: `Khách E2E ${tag}`, emailVerified: true }
      });
      accounts.moderation = moderationImages?.fixtures ?? null;
      await seedLoyaltyMember(tx, accounts.loyalty, tag);
      await tx.employeeAccount.create({
        data: { operatorId: operator.id, username: accounts.employee.username, passwordHash: employeeHash, role: "DRIVER" }
      });
    });
    await prisma.platformAccount.createMany({
      data: [
        { username: accounts.platform.username, passwordHash: platformHash, role: "PLATFORM_ADMIN" },
        { username: accounts.platformReviewer.username, passwordHash: reviewerHash, role: "PLATFORM_ADMIN" },
        { username: accounts.platformCatalog.username, passwordHash: catalogHash, role: "PLATFORM_ADMIN" },
        { username: accounts.platformData.username, passwordHash: dataHash, role: "PLATFORM_ADMIN" },
        { username: accounts.platformModeration.username, passwordHash: moderationHash, role: "PLATFORM_ADMIN" },
        { username: accounts.platformContent.username, passwordHash: contentHash, role: "PLATFORM_ADMIN" },
        { username: accounts.platformUsers.username, passwordHash: usersHash, role: "PLATFORM_ADMIN" },
        { username: accounts.platformPolicy.username, passwordHash: policyHash, role: "PLATFORM_ADMIN" },
        { username: accounts.platformFinance.username, passwordHash: financeHash, role: "PLATFORM_ADMIN" },
        { username: accounts.platformPayments.username, passwordHash: paymentsHash, role: "PLATFORM_ADMIN" },
        { username: accounts.platformReports.username, passwordHash: reportsHash, role: "PLATFORM_ADMIN" },
        { username: accounts.platformTrust.username, passwordHash: trustHash, role: "PLATFORM_ADMIN" },
        { username: accounts.platformPromo.username, passwordHash: promoHash, role: "PLATFORM_ADMIN" },
        { username: accounts.platformLoyalty.username, passwordHash: loyaltyHash, role: "PLATFORM_ADMIN" }
      ]
    });
  } finally {
    await prisma.$disconnect();
  }
  await writeModerationImages(moderationImages?.objectKeys ?? []);
  await resetTemporaryPasswordEmailBudget();

  process.stdout.write(`${JSON.stringify(accounts)}\n`);
}

/**
 * Ngân sách email mật khẩu tạm toàn hệ thống là 30 / 24 giờ và mọi lần chạy E2E trên máy dev dùng chung một
 * Redis: không đặt lại thì sau vài chục lần chạy, ca tạo nhân viên nhận 429. Ngân sách theo nhà xe / người thao
 * tác không cần đặt lại vì mỗi lần seed là nhà xe mới. Bộ đếm theo IP của luồng đăng ký nhà xe (TASK-OPR-001, 10
 * lần / giờ) cũng vậy: mọi lần chạy đều từ cùng một IP local. Bộ đếm đăng nhập theo IP (`login:ip:*`) cũng thế: mỗi
 * spec đăng nhập vài lần nên chạy lại Admin + Operator OS vài lượt trong một giờ là chạm trần. Chỉ đụng Redis local;
 * Redis chưa chạy thì bỏ qua — API khi đó tự trả 503 và spec báo rõ.
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
    const ipKeys = [...(await redis.keys("opr-app:*:ip:*")), ...(await redis.keys("login:ip:*"))];
    if (ipKeys.length > 0) {
      await redis.del(...ipKeys);
    }
  } catch {
    // Redis local chưa chạy.
  } finally {
    redis.disconnect();
  }
}

type ModerationFixtures = { operatorName: string; plateNumber: string; captions: string[] };

/** PNG 1×1 hợp lệ — đủ để ảnh hiện được trên màn Kiểm duyệt. */
const PIXEL_PNG = Buffer.from(
  "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==",
  "base64"
);

/**
 * Nhà xe riêng với một xe hai ảnh (ảnh đại diện + ảnh thứ hai) cho E2E màn Kiểm duyệt của Admin (TASK-ADM-003 phần
 * ảnh xe). Ghi thẳng dòng `vehicle_images`; file ảnh ghi sau khi commit (`writeModerationImages`).
 */
async function seedModerationFixtures(
  tx: Parameters<Parameters<PrismaClient["$transaction"]>[0]>[0],
  tag: string
): Promise<{ fixtures: ModerationFixtures; objectKeys: string[] } | null> {
  const vehicleType = await tx.vehicleType.findFirst({ where: { status: "ACTIVE" }, select: { id: true } });
  if (!vehicleType) {
    return null;
  }
  const operatorSlug = `e2e-mod-${tag}`;
  const fixtures = {
    operatorName: `E2E kiểm duyệt ${tag}`,
    plateNumber: `51B${10_000 + Math.floor(Math.random() * 90_000)}`,
    captions: [`Ngoại thất E2E ${tag}`, `Khoang E2E ${tag}`]
  };
  const operator = await tx.operatorProfile.create({
    data: { operatorSlug, displayName: fixtures.operatorName, status: "ACTIVE" }
  });
  await tx.operatorAccount.create({
    data: {
      operatorId: operator.id,
      operatorSlug,
      username: "owner01",
      contactEmail: `mod-${tag}@example.com`,
      passwordHash: "e2e-not-for-login"
    }
  });
  const vehicle = await tx.vehicle.create({
    data: { operatorId: operator.id, plateNumber: fixtures.plateNumber, vehicleTypeId: vehicleType.id }
  });
  const objectKeys = fixtures.captions.map(() => vehicleImageKey(operator.id, vehicle.id, randomUUID(), "image/png"));
  await tx.vehicleImage.createMany({
    data: objectKeys.map((objectKey, position) => ({
      operatorId: operator.id,
      vehicleId: vehicle.id,
      objectKey,
      position,
      caption: fixtures.captions[position],
      sizeBytes: PIXEL_PNG.length,
      contentType: "image/png"
    }))
  });
  return { fixtures, objectKeys };
}

/** Kho local của API dev (không cấu hình R2): ghi file ảnh để màn Kiểm duyệt hiển thị được. */
async function writeModerationImages(objectKeys: string[]): Promise<void> {
  if (objectKeys.length === 0 || process.env.R2_PUBLIC_BUCKET) {
    return;
  }
  const storage = new LocalStorageProvider({
    rootDir: resolve(process.env.STORAGE_LOCAL_DIR ?? ".storage/public"),
    apiBaseUrl: "http://localhost"
  });
  for (const key of objectKeys) {
    await storage.write(key, "image/png", PIXEL_PNG);
  }
}

type AdminStopPointFixtures = {
  proposalName: string;
  rejectProposalName: string;
  privatePointName: string;
  operatorName: string;
  provinceName: string;
  wardName: string;
};

/**
 * Hai đề xuất điểm dừng đón trả đang chờ duyệt (một để duyệt, một để từ chối) và một văn phòng riêng chưa dùng ở
 * tuyến nào (Admin khóa / mở khóa). Tọa độ ngẫu nhiên mỗi lần chạy: điểm dùng chung do lần chạy trước duyệt không
 * nằm trong bán kính cảnh báo trùng của lần này.
 */
async function seedAdminStopPointFixtures(
  tx: Parameters<Parameters<PrismaClient["$transaction"]>[0]>[0],
  operatorId: string,
  tag: string
): Promise<AdminStopPointFixtures | null> {
  // Phường / tỉnh còn hiệu lực: duyệt đề xuất kiểm lại vị trí.
  const ward = await tx.ward.findFirst({
    where: { status: "ACTIVE", province: { status: "ACTIVE" } },
    select: { id: true, provinceId: true, name: true, province: { select: { name: true } } }
  });
  if (!ward) {
    return null;
  }
  const fixtures = {
    proposalName: `E2E Đề xuất điểm đón ${tag}`,
    rejectProposalName: `E2E Đề xuất bị từ chối ${tag}`,
    privatePointName: `E2E Văn phòng khóa ${tag}`,
    operatorName: `E2E chuyến ${tag}`,
    provinceName: ward.province.name,
    wardName: ward.name
  };
  const location = { address: "Địa chỉ E2E", provinceId: ward.provinceId, wardId: ward.id, operatorId };
  const randomPoint = () => ({ latitude: 10.5 + Math.random() * 0.5, longitude: 106.4 + Math.random() * 0.5 });
  for (const name of [fixtures.proposalName, fixtures.rejectProposalName]) {
    await tx.stopPointProposal.create({
      data: { ...location, ...randomPoint(), name, type: "PICKUP_POINT", legalBasis: "QĐ E2E/QĐ-SGTVT" }
    });
  }
  await tx.stopPoint.create({
    data: { ...location, ...randomPoint(), name: fixtures.privatePointName, type: "OFFICE" }
  });
  return fixtures;
}

/**
 * Tuyến ba điểm (văn phòng → trạm dừng nghỉ → văn phòng, hai chặng 2 giờ 45 phút) và một xe gắn sơ đồ bốn
 * giường, ghi thẳng DB để E2E màn Chuyến xe không phải dựng lại qua giao diện (các luồng đó đã có spec riêng).
 */
type AssignmentFixtures = { routeName: string; date: string; soonDate: string };

/**
 * Nhà xe riêng cho E2E màn Phân công chuyến: hai tài xế (`nv.tai.minh`, `nv.tai.hung`) + một nhân viên vé; ba chuyến ngày
 * `date` (06:00–11:30, 08:30–14:00 chồng chuyến đầu, 13:00–21:15) chưa phân công; một chuyến còn 1 giờ là khởi hành đã
 * giao `nv.tai.hung` (đổi phải có lý do). Tuyến ghi thẳng, không cần điểm dừng / xe cho màn này.
 */
async function seedAssignmentFixtures(
  tx: Parameters<Parameters<PrismaClient["$transaction"]>[0]>[0],
  operatorSlug: string,
  ownerUsername: string,
  ownerHash: string,
  tag: string
): Promise<AssignmentFixtures> {
  const HOUR = 3_600_000;
  const VN = 7 * HOUR;
  const vnDate = (at: number) => new Date(at + VN).toISOString().slice(0, 10);
  const operator = await tx.operatorProfile.create({
    data: { operatorSlug, displayName: `E2E phân công ${tag}`, status: "ACTIVE" }
  });
  await tx.operatorAccount.create({
    data: { operatorId: operator.id, operatorSlug, username: ownerUsername, contactEmail: `asg-${tag}@example.com`, passwordHash: ownerHash }
  });
  const staff = [
    { username: "nv.tai.minh", role: "DRIVER" as const },
    { username: "nv.tai.hung", role: "DRIVER" as const },
    { username: "nv.ve.lan", role: "TICKET_STAFF" as const }
  ];
  const employees = [];
  for (const member of staff) {
    employees.push(
      await tx.employeeAccount.create({
        data: { operatorId: operator.id, username: member.username, passwordHash: "e2e-not-for-login", role: member.role },
        select: { id: true }
      })
    );
  }
  const routeName = "E2E Sài Gòn – Nha Trang";
  const route = await tx.route.create({
    data: { operatorId: operator.id, name: routeName, totalDistanceMeters: 430_000, totalDurationSeconds: 29_700, metricsSource: "ESTIMATE" }
  });
  const now = Date.now();
  const date = vnDate(now + 45 * 24 * HOUR);
  const midnight = Date.parse(`${date}T00:00:00Z`) - VN;
  const at = (hours: number) => new Date(midnight + hours * HOUR);
  await tx.trip.createMany({
    data: [
      [6, 11.5],
      [8.5, 14],
      [13, 21.25]
    ].map(([start, end]) => ({ operatorId: operator.id, routeId: route.id, departureAt: at(start!), arrivalAt: at(end!) }))
  });
  const soon = await tx.trip.create({
    data: { operatorId: operator.id, routeId: route.id, departureAt: new Date(now + HOUR), arrivalAt: new Date(now + 5 * HOUR) },
    select: { id: true }
  });
  await tx.employeeAssignment.create({
    data: { operatorId: operator.id, tripId: soon.id, employeeId: employees[1]!.id, role: "DRIVER" }
  });
  return { routeName, date, soonDate: vnDate(now + HOUR) };
}

type BookingFixtures = {
  routeName: string;
  date: string;
  confirmedCode: string;
  pendingCode: string;
  operatorName: string;
  /** Đơn của chuyến đã chạy (10 ngày trước) — tiền đã vào kỳ chi trả `payoutCode` (chờ rà soát). */
  pastCode: string;
  payoutCode: string;
  /** Thanh toán trùng của đơn đã xác nhận — cần đối soát, chưa xử lý (TASK-ADM-002). */
  reconcilePaymentCode: string;
  /** Hoàn tiền thất bại của một thanh toán trùng khác — chờ Admin xử lý. */
  failedRefundCode: string;
  /** Chuyến thứ hai (ngày khác) có một đơn đã thanh toán, không đơn chờ — E2E đổi / hủy chuyến đã bán (TASK-TRN-008). */
  changeTripId: string;
  changeBookingCode: string;
  /** Biển số xe dự phòng cùng sơ đồ ghế (đổi xe được). */
  spareVehiclePlate: string;
  /** Khiếu nại mới (chưa phân loại) của đơn đã xác nhận — E2E Admin phân loại / chuyển tranh chấp (TASK-TRUST-001). */
  newTicketCode: string;
  newTicketSubject: string;
  /** Khiếu nại đã chuyển nhà xe phản hồi. */
  forwardedTicketCode: string;
  forwardedTicketSubject: string;
  /** Tranh chấp của đơn chuyến đã chạy, đang chờ nhà xe phản hồi. */
  disputeCode: string;
  disputeTitle: string;
  /** Đánh giá 4 sao của đơn chuyến đã chạy. */
  reviewComment: string;
  /** Khuyến mãi nền tảng đang chạy, nhà xe chưa tham gia (TASK-PROM-001); nhà xe đã được cấp quyền tự tạo (20% hoặc 100.000 ₫, 60 ngày). */
  platformPromotionCode: string;
};

/**
 * Hành khách có tài khoản VXN Plus (TASK-LOY-001): tích 300 điểm của một đơn (2 ngày trước) + điều chỉnh cộng 50 (hôm qua) → còn
 * 350, hạng Đồng. Ghi thẳng sổ điểm như job / Admin đã ghi (luồng thật kiểm ở API).
 */
async function seedLoyaltyMember(
  tx: Parameters<Parameters<PrismaClient["$transaction"]>[0]>[0],
  member: { passengerEmail: string; passengerName: string },
  tag: string
): Promise<void> {
  const DAY = 86_400_000;
  const now = Date.now();
  const user = await tx.user.create({ data: { id: `e2emember${tag}`, email: member.passengerEmail, name: member.passengerName, emailVerified: true } });
  const account = await tx.loyaltyAccount.create({ data: { userId: user.id, availablePoints: 350 } });
  const policy = await tx.policyVersion.findFirst({ where: { type: "LOYALTY", status: "PUBLISHED" }, orderBy: { version: "asc" }, select: { id: true, version: true } });
  await tx.loyaltyPointTransaction.createMany({
    data: [
      {
        accountId: account.id,
        type: "EARN",
        points: 300,
        tier: "BRONZE",
        basisAmount: 3_000_000n,
        sourceLabel: `Đơn E2E${tag.toUpperCase()} · hệ số ×1`,
        policyVersionId: policy?.id ?? null,
        policyVersion: policy?.version ?? null,
        idempotencyKey: `E2E:EARN:${tag}`,
        actor: "system",
        expiresAt: new Date(now + 365 * DAY),
        createdAt: new Date(now - 2 * DAY)
      },
      {
        accountId: account.id,
        type: "ADJUST",
        points: 50,
        tier: "BRONZE",
        sourceLabel: "platform/e2e · Bù do sự cố chuyến",
        policyVersionId: policy?.id ?? null,
        policyVersion: policy?.version ?? null,
        idempotencyKey: `E2E:ADJUST:${tag}`,
        reason: "Bù do sự cố chuyến",
        actor: "platform:e2e",
        expiresAt: new Date(now + 365 * DAY),
        createdAt: new Date(now - DAY)
      }
    ]
  });
}

/**
 * Nhà xe + chuyến 22:30 (giờ VN) ngày `date` mở bán, xe 4 chỗ, và hai đơn: đã xác nhận (A01, A02 — có vé, thanh toán VNPay
 * thành công) và chờ thanh toán của khách vãng lai (A03). Dựng thẳng DB như dữ liệu sau thanh toán (luồng thật kiểm ở API).
 */
async function seedBookingFixtures(
  tx: Parameters<Parameters<PrismaClient["$transaction"]>[0]>[0],
  operatorSlug: string,
  ownerUsername: string,
  ownerHash: string,
  tag: string
): Promise<BookingFixtures | null> {
  const ward = await tx.ward.findFirst({ select: { id: true, provinceId: true } });
  const vehicleType = await tx.vehicleType.findFirst({ where: { status: "ACTIVE" }, select: { id: true, name: true } });
  if (!ward || !vehicleType) {
    return null;
  }
  const HOUR = 3_600_000;
  const VN = 7 * HOUR;
  const operator = await tx.operatorProfile.create({ data: { operatorSlug, displayName: `E2E đặt vé ${tag}`, status: "ACTIVE", hotline: "19006868" } });
  const operatorId = operator.id;
  await tx.operatorAccount.create({
    data: { operatorId, operatorSlug, username: ownerUsername, contactEmail: `bkg-${tag}@example.com`, passwordHash: ownerHash }
  });
  const names = ["E2E Bến xe Miền Đông mới", "E2E Bến xe liên tỉnh Đà Lạt"];
  const points = [];
  for (const [index, name] of names.entries()) {
    points.push(
      await tx.stopPoint.create({
        data: { operatorId, name, type: "OFFICE", address: "Địa chỉ E2E", provinceId: ward.provinceId, wardId: ward.id, latitude: 10.8 + index, longitude: 106.7 + index }
      })
    );
  }
  const routeName = "E2E Sài Gòn – Đà Lạt (đặt vé)";
  const route = await tx.route.create({
    data: { operatorId, name: routeName, totalDistanceMeters: 300_000, totalDurationSeconds: 25_200, metricsSource: "ESTIMATE" }
  });
  const seatMap = await tx.seatMap.create({
    data: { operatorId, name: `E2E đặt vé ${tag}`, layout: { decks: [{ deck: 1, rows: 2, columns: 2 }] }, seatCount: 4 }
  });
  const codes = ["A01", "A02", "A03", "A04"];
  await tx.seat.createMany({
    data: codes.map((code, index) => ({ operatorId, seatMapId: seatMap.id, code, deck: 1, row: Math.floor(index / 2) + 1, column: (index % 2) + 1, type: "BED" as const }))
  });
  const plate = `51B${String(30_000 + Math.floor(Math.random() * 60_000))}`;
  const vehicle = await tx.vehicle.create({ data: { operatorId, plateNumber: plate, vehicleTypeId: vehicleType.id, seatMapId: seatMap.id } });
  const date = new Date(Date.now() + 50 * 24 * HOUR + VN).toISOString().slice(0, 10);
  const departureAt = new Date(Date.parse(`${date}T00:00:00Z`) - VN + 22.5 * HOUR);
  const arrivalAt = new Date(departureAt.getTime() + 7 * HOUR);
  const trip = await tx.trip.create({
    data: { operatorId, routeId: route.id, vehicleId: vehicle.id, departureAt, arrivalAt, status: "OPEN_FOR_SALE" }
  });
  await tx.tripStop.createMany({
    data: points.map((point, index) => ({
      operatorId,
      tripId: trip.id,
      sequence: index + 1,
      role: index === 0 ? ("ORIGIN" as const) : ("DESTINATION" as const),
      stopPointId: point.id,
      allowPickup: index === 0,
      allowDropoff: index === 1,
      plannedAt: index === 0 ? departureAt : arrivalAt
    }))
  });
  await tx.tripSeat.createMany({
    data: codes.map((seatCode, index) => ({ operatorId, tripId: trip.id, seatCode, deck: 1, row: Math.floor(index / 2) + 1, column: (index % 2) + 1, type: "BED" as const }))
  });
  const snapshot = {
    trip: { routeName, operatorName: operator.displayName, operatorHotline: "19006868", vehicleTypeName: vehicleType.name, departureAt: departureAt.toISOString(), arrivalAt: arrivalAt.toISOString() },
    pickup: { sequence: 1, name: names[0], address: "Địa chỉ E2E", plannedAt: departureAt.toISOString() },
    dropoff: { sequence: 2, name: names[1], address: "Địa chỉ E2E", plannedAt: arrivalAt.toISOString() },
    cancellationPolicy: { tiers: [{ minHoursBefore: 24, refundPercent: 90 }, { minHoursBefore: 4, refundPercent: 50 }] }
  };
  const suffix = tag.toUpperCase().replace(/[^A-Z0-9]/g, "0").padEnd(6, "0").slice(0, 6);
  const confirmedCode = `VXN${suffix}`;
  const pendingCode = `VXN${suffix.slice(0, 5)}Z`;
  const created = new Date(Date.now() - 2 * HOUR);
  const hash = () => randomBytes(32).toString("hex");
  const booking = (code: string, status: "CONFIRMED" | "PENDING_PAYMENT", contact: [string, string], seats: string[], at: Date) =>
    tx.booking.create({
      data: {
        bookingCode: code,
        operatorId,
        tripId: trip.id,
        holdId: randomUUID(),
        status,
        contactName: contact[0],
        contactPhone: contact[1],
        contactEmail: `khach-${code.toLowerCase()}@example.com`,
        pickupSequence: 1,
        dropoffSequence: 2,
        subtotal: BigInt(300_000 * seats.length),
        total: BigInt(300_000 * seats.length),
        snapshot,
        accessTokenHash: hash(),
        expiresAt: status === "CONFIRMED" ? at : new Date(Date.now() + 10 * 60_000),
        paidAt: status === "CONFIRMED" ? at : null,
        confirmedAt: status === "CONFIRMED" ? at : null,
        createdAt: at,
        passengers: { create: seats.map((seatCode, index) => ({ tripId: trip.id, seatCode, seatType: "BED" as const, price: 300_000n, fullName: `${contact[0]} ${index + 1}`, phone: null })) }
      },
      select: { id: true, passengers: { select: { id: true, seatCode: true } } }
    });
  const confirmed = await booking(confirmedCode, "CONFIRMED", ["Nguyễn Văn Khách", "0901234567"], ["A01", "A02"], created);
  await tx.bookingStatusHistory.createMany({
    data: [
      { bookingId: confirmed.id, operatorId, toStatus: "PENDING_PAYMENT" as const, actor: "guest", createdAt: created },
      { bookingId: confirmed.id, operatorId, fromStatus: "PENDING_PAYMENT" as const, toStatus: "PAID" as const, reason: "Thanh toán VNPAY.", actor: "provider:VNPAY", createdAt: new Date(created.getTime() + 60_000) },
      { bookingId: confirmed.id, operatorId, fromStatus: "PAID" as const, toStatus: "CONFIRMED" as const, reason: "Đã phát hành vé.", actor: "system", createdAt: new Date(created.getTime() + 60_001) }
    ]
  });
  await tx.payment.create({
    data: { paymentCode: `PAY${suffix}AAAAAA`, operatorId, bookingId: confirmed.id, provider: "VNPAY", status: "SUCCESS", amount: 600_000n, providerTxnId: `E2E${suffix}`, expiresAt: created, paidAt: created }
  });
  await tx.ticket.createMany({
    data: confirmed.passengers
      .sort((a, b) => a.seatCode.localeCompare(b.seatCode))
      .map((passenger, index) => ({ ticketCode: `${confirmedCode}-0${index + 1}`, operatorId, bookingId: confirmed.id, tripId: trip.id, passengerInfoId: passenger.id, seatCode: passenger.seatCode, qrTokenHash: hash(), issuedAt: created }))
  });
  await tx.tripSeat.updateMany({ where: { tripId: trip.id, seatCode: { in: ["A01", "A02"] } }, data: { status: "BOOKED", bookingId: confirmed.id } });
  // Khách trả thêm hai lần cho đơn đã xác nhận (TASK-ADM-002): cổng trừ tiền nhưng không nhận vào đơn → cần đối soát. Không có
  // vé, chưa vào sổ giữ hộ → màn đơn / tài chính của nhà xe không đổi. Khoản thứ hai Admin đã hoàn nhưng cổng từ chối.
  const reconcilePaymentCode = `PAY${suffix}DDDDDD`;
  const duplicates = [];
  for (const [index, code] of [reconcilePaymentCode, `PAY${suffix}EEEEEE`].entries()) {
    const at = new Date(created.getTime() + (index + 2) * 60_000);
    duplicates.push(
      await tx.payment.create({
        data: {
          paymentCode: code,
          operatorId,
          bookingId: confirmed.id,
          provider: "VNPAY",
          status: "RECONCILING",
          reconcileReason: "DUPLICATE_PAYMENT",
          amount: 600_000n,
          providerTxnId: `E2E${index === 0 ? "D" : "E"}${suffix}`,
          expiresAt: new Date(at.getTime() + 10 * 60_000),
          createdAt: at,
          histories: {
            create: [
              { toStatus: "PROCESSING" as const, actor: "guest", createdAt: at },
              { fromStatus: "PROCESSING" as const, toStatus: "RECONCILING" as const, reason: "Cần đối soát: DUPLICATE_PAYMENT.", actor: "provider:VNPAY", createdAt: new Date(at.getTime() + 30_000) }
            ]
          }
        },
        select: { id: true, createdAt: true }
      })
    );
  }
  const failedRefundCode = `RFD${suffix}FFFFFF`;
  const refundAt = new Date(duplicates[1]!.createdAt.getTime() + 60_000);
  await tx.refund.create({
    data: {
      refundCode: failedRefundCode,
      operatorId,
      bookingId: confirmed.id,
      paymentId: duplicates[1]!.id,
      status: "FAILED",
      amount: 600_000n,
      refundPercent: 100,
      reason: "Khách trả hai lần cho cùng đơn",
      failureCode: "91",
      requestedBy: "platform:e2e-seed",
      createdAt: refundAt,
      histories: {
        create: [
          { toStatus: "APPROVED" as const, reason: "Hoàn toàn bộ thanh toán cần đối soát.", actor: "system", createdAt: refundAt },
          { fromStatus: "APPROVED" as const, toStatus: "PROCESSING" as const, reason: "Đã gửi yêu cầu hoàn tới cổng thanh toán.", actor: "system", createdAt: new Date(refundAt.getTime() + 1_000) },
          { fromStatus: "PROCESSING" as const, toStatus: "FAILED" as const, reason: "Giao dịch không đủ điều kiện hoàn.", actor: "system", createdAt: new Date(refundAt.getTime() + 2_000) }
        ]
      }
    }
  });
  const pending = await booking(pendingCode, "PENDING_PAYMENT", ["Lê Thị Hoa", "0987654112"], ["A03"], new Date(Date.now() - HOUR));
  await tx.bookingStatusHistory.create({ data: { bookingId: pending.id, operatorId, toStatus: "PENDING_PAYMENT", actor: "guest" } });
  await tx.tripSeat.updateMany({ where: { tripId: trip.id, seatCode: "A03" }, data: { status: "HOLDING", bookingId: pending.id } });

  // Chuyến thứ hai cho E2E đổi / hủy chuyến đã bán (TRN-008): một đơn 1 chỗ đã thanh toán, không có đơn chờ (đổi chuyến bị
  // chặn khi còn khách đang thanh toán). Không ghi sổ giữ hộ để số liệu màn Tài chính của các E2E khác không đổi.
  const spareVehiclePlate = `51B${String(30_000 + Math.floor(Math.random() * 60_000))}`;
  await tx.vehicle.create({ data: { operatorId, plateNumber: spareVehiclePlate, vehicleTypeId: vehicleType.id, seatMapId: seatMap.id } });
  const changeDate = new Date(Date.now() + 55 * 24 * HOUR + VN).toISOString().slice(0, 10);
  const changeDeparture = new Date(Date.parse(`${changeDate}T00:00:00Z`) - VN + 22.5 * HOUR);
  const changeArrival = new Date(changeDeparture.getTime() + 7 * HOUR);
  const changeTrip = await tx.trip.create({
    data: { operatorId, routeId: route.id, vehicleId: vehicle.id, departureAt: changeDeparture, arrivalAt: changeArrival, status: "OPEN_FOR_SALE" },
    select: { id: true }
  });
  await tx.tripStop.createMany({
    data: points.map((point, index) => ({
      operatorId,
      tripId: changeTrip.id,
      sequence: index + 1,
      role: index === 0 ? ("ORIGIN" as const) : ("DESTINATION" as const),
      stopPointId: point.id,
      allowPickup: index === 0,
      allowDropoff: index === 1,
      plannedAt: index === 0 ? changeDeparture : changeArrival
    }))
  });
  await tx.tripSeat.createMany({
    data: codes.map((seatCode, index) => ({ operatorId, tripId: changeTrip.id, seatCode, deck: 1, row: Math.floor(index / 2) + 1, column: (index % 2) + 1, type: "BED" as const, status: index === 0 ? ("BOOKED" as const) : ("AVAILABLE" as const) }))
  });
  const changeBookingCode = `VXN${suffix.slice(0, 5)}X`;
  const changeSnapshot = { ...snapshot, trip: { ...snapshot.trip, departureAt: changeDeparture.toISOString(), arrivalAt: changeArrival.toISOString() } };
  const changeBooking = await tx.booking.create({
    data: {
      bookingCode: changeBookingCode,
      operatorId,
      tripId: changeTrip.id,
      holdId: randomUUID(),
      status: "CONFIRMED",
      contactName: "Phạm Văn Đổi",
      contactPhone: "0933111222",
      contactEmail: `khach-${changeBookingCode.toLowerCase()}@example.com`,
      pickupSequence: 1,
      dropoffSequence: 2,
      subtotal: 300_000n,
      total: 300_000n,
      snapshot: changeSnapshot,
      accessTokenHash: hash(),
      expiresAt: created,
      paidAt: created,
      confirmedAt: created,
      createdAt: created,
      passengers: { create: [{ tripId: changeTrip.id, seatCode: "A01", seatType: "BED" as const, price: 300_000n, fullName: "Phạm Văn Đổi", phone: null }] }
    },
    select: { id: true, passengers: { select: { id: true } } }
  });
  await tx.tripSeat.updateMany({ where: { tripId: changeTrip.id, seatCode: "A01" }, data: { bookingId: changeBooking.id } });
  await tx.payment.create({
    data: { paymentCode: `PAY${suffix}GGGGGG`, operatorId, bookingId: changeBooking.id, provider: "VNPAY", status: "SUCCESS", amount: 300_000n, providerTxnId: `E2EG${suffix}`, expiresAt: created, paidAt: created }
  });
  await tx.ticket.create({
    data: { ticketCode: `${changeBookingCode}-01`, operatorId, bookingId: changeBooking.id, tripId: changeTrip.id, passengerInfoId: changeBooking.passengers[0]!.id, seatCode: "A01", qrTokenHash: hash(), issuedAt: created }
  });

  // Sổ escrow (BTP-006) của đơn đã xác nhận: chuyến còn ở tương lai → chờ đủ điều kiện.
  const eligibleFuture = new Date(arrivalAt.getTime() + 3 * 24 * HOUR);
  const confirmedPayment = await tx.payment.findFirstOrThrow({ where: { bookingId: confirmed.id }, select: { id: true } });
  await tx.escrowLedger.createMany({
    data: [
      { operatorId, entryType: "PAYMENT_CAPTURED" as const, amount: 600_000n, bookingId: confirmed.id, tripId: trip.id, paymentId: confirmedPayment.id, eligibleAt: eligibleFuture, createdBy: "system", createdAt: created },
      { operatorId, entryType: "COMMISSION" as const, amount: -30_000n, commissionRateBps: 500, bookingId: confirmed.id, tripId: trip.id, paymentId: confirmedPayment.id, eligibleAt: eligibleFuture, createdBy: "system", createdAt: created }
    ]
  });

  // Chuyến đã chạy 10 ngày trước + một đơn đã thanh toán → đã qua T+3 → kỳ chi trả hôm nay đang chờ rà soát; nhà xe có tài
  // khoản nhận tiền đã xác minh.
  await tx.bankAccount.create({
    data: { operatorId, bankName: "Vietcombank", accountNumber: "0071000124521", accountHolder: "CTY TNHH E2E DAT VE", status: "VERIFIED", reviewedAt: new Date() }
  });
  const pastDeparture = new Date(Date.now() - 10 * 24 * HOUR);
  const pastArrival = new Date(pastDeparture.getTime() + 7 * HOUR);
  const pastTrip = await tx.trip.create({ data: { operatorId, routeId: route.id, vehicleId: vehicle.id, departureAt: pastDeparture, arrivalAt: pastArrival, status: "COMPLETED" } });
  await tx.tripStop.createMany({
    data: points.map((point, index) => ({
      operatorId,
      tripId: pastTrip.id,
      sequence: index + 1,
      role: index === 0 ? ("ORIGIN" as const) : ("DESTINATION" as const),
      stopPointId: point.id,
      allowPickup: index === 0,
      allowDropoff: index === 1,
      plannedAt: index === 0 ? pastDeparture : pastArrival
    }))
  });
  await tx.tripSeat.createMany({
    data: codes.map((seatCode, index) => ({ operatorId, tripId: pastTrip.id, seatCode, deck: 1, row: Math.floor(index / 2) + 1, column: (index % 2) + 1, type: "BED" as const, status: index === 0 ? ("BOOKED" as const) : ("AVAILABLE" as const) }))
  });
  const pastCode = `VXN${suffix.slice(0, 5)}P`;
  const pastCreated = new Date(pastDeparture.getTime() - 2 * 24 * HOUR);
  const past = await tx.booking.create({
    data: {
      bookingCode: pastCode,
      operatorId,
      tripId: pastTrip.id,
      holdId: randomUUID(),
      status: "CONFIRMED",
      contactName: "Trần Thị Mai",
      contactPhone: "0912345678",
      contactEmail: `khach-${pastCode.toLowerCase()}@example.com`,
      pickupSequence: 1,
      dropoffSequence: 2,
      subtotal: 450_000n,
      total: 450_000n,
      snapshot: { ...snapshot, trip: { ...snapshot.trip, departureAt: pastDeparture.toISOString(), arrivalAt: pastArrival.toISOString() } },
      accessTokenHash: hash(),
      expiresAt: pastCreated,
      paidAt: pastCreated,
      confirmedAt: pastCreated,
      createdAt: pastCreated,
      passengers: { create: [{ tripId: pastTrip.id, seatCode: "A01", seatType: "BED" as const, price: 450_000n, fullName: "Trần Thị Mai", phone: null }] }
    },
    select: { id: true }
  });
  await tx.tripSeat.updateMany({ where: { tripId: pastTrip.id, seatCode: "A01" }, data: { bookingId: past.id } });
  const pastPayment = await tx.payment.create({
    data: { paymentCode: `PAY${suffix}PPPPPP`, operatorId, bookingId: past.id, provider: "MOMO", status: "SUCCESS", amount: 450_000n, providerTxnId: `E2EP${suffix}`, expiresAt: pastCreated, paidAt: pastCreated },
    select: { id: true }
  });
  const eligiblePast = new Date(pastArrival.getTime() + 3 * 24 * HOUR);
  const capture = await tx.escrowLedger.create({
    data: { operatorId, entryType: "PAYMENT_CAPTURED", amount: 450_000n, bookingId: past.id, tripId: pastTrip.id, paymentId: pastPayment.id, eligibleAt: eligiblePast, createdBy: "system", createdAt: pastCreated },
    select: { id: true }
  });
  const commission = await tx.escrowLedger.create({
    data: { operatorId, entryType: "COMMISSION", amount: -22_500n, commissionRateBps: 500, bookingId: past.id, tripId: pastTrip.id, paymentId: pastPayment.id, eligibleAt: eligiblePast, createdBy: "system", createdAt: pastCreated },
    select: { id: true }
  });
  const period = new Date(Date.now() + 7 * HOUR).toISOString().slice(0, 10);
  const [{ seq }] = await tx.$queryRaw<{ seq: bigint }[]>`SELECT nextval('payout_code_seq') AS seq`;
  const payoutCode = `PO-${period.replace(/-/g, "")}-${String(seq).padStart(3, "0")}`;
  await tx.payout.create({
    data: {
      payoutCode,
      operatorId,
      period: new Date(period),
      status: "PENDING_REVIEW",
      grossAmount: 450_000n,
      commissionAmount: 22_500n,
      refundAmount: 0n,
      adjustmentAmount: 0n,
      amount: 427_500n,
      commissionRateBps: 500,
      bankName: "Vietcombank",
      bankAccountNumber: "0071000124521",
      bankAccountHolder: "CTY TNHH E2E DAT VE",
      items: {
        create: [
          { ledgerEntryId: capture.id, entryType: "PAYMENT_CAPTURED", amount: 450_000n, bookingId: past.id, tripId: pastTrip.id },
          { ledgerEntryId: commission.id, entryType: "COMMISSION", amount: -22_500n, bookingId: past.id, tripId: pastTrip.id }
        ]
      },
      histories: { create: { toStatus: "PENDING_REVIEW", reason: "Tạo kỳ chi trả.", actor: "system" } }
    }
  });

  // Khiếu nại / tranh chấp / đánh giá (TASK-TRUST-001).
  const now = new Date();
  const ticketCode = async () => {
    const [{ seq: next }] = await tx.$queryRaw<{ seq: bigint }[]>`SELECT nextval('support_ticket_code_seq') AS seq`;
    return `KN-${period.replace(/-/g, "")}-${String(next).padStart(3, "0")}`;
  };
  const newTicketSubject = `E2E Bị trừ tiền hai lần ${suffix}`;
  const newTicketCode = await ticketCode();
  await tx.supportTicket.create({
    data: {
      ticketCode: newTicketCode,
      operatorId,
      bookingId: confirmed.id,
      reporterParty: "GUEST",
      reporterName: "Nguyễn Văn K***",
      subject: newTicketSubject,
      category: "PAYMENT_REFUND",
      requestedPriority: "MEDIUM",
      priority: "MEDIUM",
      lastMessageAt: now,
      messages: { create: { party: "GUEST", authorName: "Nguyễn Văn K***", body: "Tài khoản bị trừ tiền hai lần cho một đơn." } }
    }
  });
  const forwardedTicketSubject = `E2E Điều hòa không hoạt động ${suffix}`;
  const forwardedTicketCode = await ticketCode();
  await tx.supportTicket.create({
    data: {
      ticketCode: forwardedTicketCode,
      operatorId,
      bookingId: confirmed.id,
      reporterParty: "GUEST",
      reporterName: "Nguyễn Văn K***",
      subject: forwardedTicketSubject,
      category: "SERVICE_QUALITY",
      requestedPriority: "LOW",
      priority: "MEDIUM",
      handler: "OPERATOR",
      status: "WAITING_OPERATOR",
      sharedWithOperatorAt: now,
      classifiedAt: now,
      lastMessageAt: now,
      messages: {
        create: [
          { party: "GUEST", authorName: "Nguyễn Văn K***", body: "Điều hòa trên xe không hoạt động cả chuyến.", createdAt: new Date(now.getTime() - 60_000) },
          { party: "PLATFORM", authorName: "platform/e2e", body: "Vé Xe Nhanh đã tiếp nhận và chuyển nhà xe phản hồi.", createdAt: now }
        ]
      }
    }
  });
  const disputeTitle = `E2E Hoàn tiền do xe trễ ${suffix}`;
  const escalatedTicket = await tx.supportTicket.create({
    data: {
      ticketCode: await ticketCode(),
      operatorId,
      bookingId: past.id,
      reporterParty: "GUEST",
      reporterName: "Trần Thị M***",
      subject: disputeTitle,
      category: "SCHEDULE",
      requestedPriority: "HIGH",
      priority: "HIGH",
      status: "ESCALATED",
      lastMessageAt: now,
      messages: { create: { party: "GUEST", authorName: "Trần Thị M***", body: "Xe đến điểm đón trễ 45 phút." } }
    },
    select: { id: true }
  });
  const [{ seq: disputeSeq }] = await tx.$queryRaw<{ seq: bigint }[]>`SELECT nextval('dispute_code_seq') AS seq`;
  const disputeCode = `DC-${String(disputeSeq).padStart(6, "0")}`;
  const dispute = await tx.disputeCase.create({
    data: {
      disputeCode,
      operatorId,
      bookingId: past.id,
      supportTicketId: escalatedTicket.id,
      title: disputeTitle,
      customerRequest: "Hoàn một phần tiền vé",
      status: "WAITING_OPERATOR_RESPONSE",
      responseDueAt: new Date(now.getTime() + 48 * HOUR),
      createdBy: "platform:e2e"
    },
    select: { id: true }
  });
  await tx.disputeEvent.createMany({
    data: [
      { disputeId: dispute.id, operatorId, kind: "STATUS" as const, party: "PLATFORM" as const, actor: "platform:e2e", actorName: "platform/e2e", toStatus: "OPEN" as const, body: "Hai bên không thống nhất.", createdAt: new Date(now.getTime() - 60_000) },
      {
        disputeId: dispute.id,
        operatorId,
        kind: "REQUEST" as const,
        party: "PLATFORM" as const,
        actor: "platform:e2e",
        actorName: "platform/e2e",
        fromStatus: "OPEN" as const,
        toStatus: "WAITING_OPERATOR_RESPONSE" as const,
        body: "Cung cấp nhật trình chuyến và giải trình giờ xe tới điểm đón.",
        target: "OPERATOR" as const,
        dueAt: new Date(now.getTime() + 48 * HOUR),
        createdAt: now
      }
    ]
  });
  const reviewComment = `E2E Giường rộng, có cổng sạc ${suffix}.`;
  await tx.review.create({ data: { operatorId, bookingId: past.id, tripId: pastTrip.id, userId: `e2e-reviewer-${suffix}`, authorName: "Trần Thị M***", rating: 4, comment: reviewComment } });

  // Khuyến mãi (TASK-PROM-001).
  await tx.promotionPermission.create({ data: { operatorId, enabled: true, maxPercent: 20, maxAmount: 100_000n, maxDurationDays: 60 } });
  const platformPromotionCode = `E2EVXN${suffix}`;
  await tx.promotion.create({
    data: {
      code: platformPromotionCode,
      name: `E2E Chào bạn mới ${suffix}`,
      scope: "PLATFORM",
      discountType: "AMOUNT",
      discountValue: 30_000n,
      minOrder: 200_000n,
      startsAt: new Date(now.getTime() - HOUR),
      endsAt: new Date(now.getTime() + 30 * 24 * HOUR),
      usageLimit: 100,
      status: "ACTIVE",
      createdBy: "platform:e2e"
    }
  });
  return {
    routeName,
    date,
    confirmedCode,
    pendingCode,
    operatorName: operator.displayName,
    pastCode,
    payoutCode,
    reconcilePaymentCode,
    failedRefundCode,
    changeTripId: changeTrip.id,
    changeBookingCode,
    spareVehiclePlate,
    newTicketCode,
    newTicketSubject,
    forwardedTicketCode,
    forwardedTicketSubject,
    disputeCode,
    disputeTitle,
    reviewComment,
    platformPromotionCode
  };
}

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
      durationSecondsFromPrevious: index === 0 ? null : 9_900,
      measuredDurationSeconds: index === 0 ? null : 9_900
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
