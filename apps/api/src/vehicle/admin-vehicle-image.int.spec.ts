import { randomUUID } from "node:crypto";
import { mkdtemp, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { AuditWriteError, type AuditEventInput, type AuditService } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { platformScope, tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { EmailNotifier, VehicleImageRemovedEmailMessage } from "../external/notification/email-notifier";
import { LocalStorageProvider } from "../external/storage/local-storage-provider";
import type { Authorization } from "../iam/role/authorization";
import { AdminVehicleImageService } from "./admin-vehicle-image.service";
import { AdminVehicleImageListQuerySchema } from "./dto/admin-vehicle-image.dto";
import { VehicleImagesInputSchema } from "./dto/vehicle-image.dto";
import { vehicleImageKey } from "./vehicle-image-format";
import { VehicleImageService } from "./vehicle-image.service";
import type { VehicleImageUploadLimiter } from "./vehicle-image-upload-limiter";

/**
 * TASK-ADM-003 (phần ảnh xe) — Admin rà soát / gỡ ảnh phương tiện trên Postgres THẬT bằng role APP + kho ổ đĩa thật
 * (FR-ADM-20, BR-76, LLD §6.12 bước 7).
 */
const url = process.env.DATABASE_URL;
const requireDb = process.env.REQUIRE_DB_TESTS === "1";

const JPEG = Uint8Array.from([0xff, 0xd8, 0xff, 0xe0, 0, 0x10, 0x4a, 0x46, 0x49, 0x46, 0, 1, 9, 9]);

async function rejectionOf(promise: Promise<unknown>): Promise<{ status?: number; code?: string }> {
  try {
    await promise;
    return {};
  } catch (error) {
    const response = (error as { getResponse?: () => { code?: string } }).getResponse?.();
    return { status: (error as { getStatus?: () => number }).getStatus?.(), code: response?.code };
  }
}

describe.skipIf(!url && !requireDb)("Admin ảnh phương tiện — Postgres thật, role app, kho ổ đĩa", () => {
  let prisma: PrismaService;
  let rootDir: string;
  let storage: LocalStorageProvider;
  let admin: AdminVehicleImageService;
  let operatorImages: VehicleImageService;
  const tag = randomUUID().slice(0, 8);
  const tenantA = randomUUID();
  const tenantB = randomUUID();
  const typeId = randomUUID();
  const vehicleA = randomUUID();
  const vehicleB = randomUUID();
  const plateA = `51B${10_000 + Math.floor(Math.random() * 90_000)}`;
  const plateB = `29B${10_000 + Math.floor(Math.random() * 90_000)}`;
  const actor = { sub: randomUUID(), role: "PLATFORM_ADMIN" };
  const authz: Authorization = { permission: "content:moderate", scope: "any", db: platformScope() };
  const authzA: Authorization = { permission: "vehicle:manage", scope: "tenant", db: tenantScope(tenantA) };
  const ownerEmail = `owner-a@${tag}.test`;
  const sendVehicleImageRemoved = vi.fn(async (_message: VehicleImageRemovedEmailMessage) => undefined);
  const notifier = { sendOtp: async () => undefined, sendVehicleImageRemoved } as EmailNotifier;
  const recordAuditEvent = vi.fn(async (_event: AuditEventInput, _options?: unknown) => undefined);

  /** Một ảnh đã gắn vào xe: object có trong kho + dòng `vehicle_images` với thời điểm tải lên cho trước. */
  async function seedImage(operatorId: string, vehicleId: string, position: number, createdAt: Date, caption: string | null = null) {
    const id = randomUUID();
    const objectKey = vehicleImageKey(operatorId, vehicleId, randomUUID(), "image/jpeg");
    await storage.write(objectKey, "image/jpeg", JPEG);
    await prisma.withSystem((tx) =>
      tx.vehicleImage.create({
        data: { id, operatorId, vehicleId, objectKey, position, caption, sizeBytes: JPEG.length, contentType: "image/jpeg", createdAt },
      }),
    );
    return { id, objectKey };
  }

  const list = (query: Record<string, unknown> = {}) =>
    admin.list(authz, AdminVehicleImageListQuerySchema.parse({ operatorId: query.operatorId ?? tenantA, ...query }));

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    const [role] = await prisma.$queryRaw<{ rolsuper: boolean; rolbypassrls: boolean }[]>`
      SELECT rolsuper, rolbypassrls FROM pg_roles WHERE rolname = current_user`;
    if (!role || role.rolsuper || role.rolbypassrls) {
      throw new Error("DATABASE_URL đang là superuser/BYPASSRLS — dùng role app (TRN-001-guide.md §0).");
    }
    rootDir = await mkdtemp(join(tmpdir(), "vxn-admin-vehicle-image-"));
    storage = new LocalStorageProvider({ rootDir, apiBaseUrl: "http://storage.test" });
    admin = new AdminVehicleImageService(prisma, { recordAuditEvent } as unknown as AuditService, storage, notifier);
    operatorImages = new VehicleImageService(prisma, storage, {
      assertWithinLimit: async () => undefined,
    } as unknown as VehicleImageUploadLimiter);
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.createMany({
        data: [
          { id: tenantA, operatorSlug: `adm003-a-${tag}`, displayName: `Nhà xe A ${tag}` },
          { id: tenantB, operatorSlug: `adm003-b-${tag}`, displayName: `Nhà xe B ${tag}` },
        ],
      });
      await tx.operatorAccount.createMany({
        data: [
          { operatorId: tenantA, operatorSlug: `adm003-a-${tag}`, username: "owner01", passwordHash: "x", contactEmail: ownerEmail },
          { operatorId: tenantB, operatorSlug: `adm003-b-${tag}`, username: "owner01", passwordHash: "x" },
        ],
      });
      await tx.vehicleType.create({ data: { id: typeId, code: `ADM3_${tag}`, name: "Ghế", form: "SEATER", class: "STANDARD" } });
      await tx.vehicle.createMany({
        data: [
          { id: vehicleA, operatorId: tenantA, plateNumber: plateA, vehicleTypeId: typeId },
          { id: vehicleB, operatorId: tenantB, plateNumber: plateB, vehicleTypeId: typeId },
        ],
      });
    });
  }, 30_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      const operatorId = { in: [tenantA, tenantB] };
      await tx.vehicleImage.deleteMany({ where: { operatorId } });
      await tx.vehicle.deleteMany({ where: { operatorId } });
      await tx.vehicleType.deleteMany({ where: { id: typeId } });
      await tx.operatorAccount.deleteMany({ where: { operatorId } });
      await tx.operatorProfile.deleteMany({ where: { id: operatorId } });
    });
    await prisma.$disconnect();
    await rm(rootDir, { recursive: true, force: true });
  });

  beforeEach(async () => {
    sendVehicleImageRemoved.mockReset();
    sendVehicleImageRemoved.mockResolvedValue(undefined);
    recordAuditEvent.mockReset();
    recordAuditEvent.mockResolvedValue(undefined);
    await prisma.withSystem((tx) => tx.vehicleImage.deleteMany({ where: { operatorId: { in: [tenantA, tenantB] } } }));
  });

  it("danh sách mọi nhà xe: mới tải lên trước, lọc nhà xe / thời gian, cursor, tổng, ảnh đại diện, ô lọc nhà xe", async () => {
    const day = (n: number) => new Date(Date.UTC(2026, 9, n, 1));
    const oldA = await seedImage(tenantA, vehicleA, 0, day(1), "Ngoại thất");
    const newA = await seedImage(tenantA, vehicleA, 1, day(10), null);
    const newestA = await seedImage(tenantA, vehicleA, 2, day(12), "Khoang");
    const imageB = await seedImage(tenantB, vehicleB, 3, day(11));

    const first = await list({ limit: 2 });
    expect(first.total).toBe(3);
    expect(first.items.map((item) => item.id)).toEqual([newestA.id, newA.id]);
    expect(first.items[0]).toMatchObject({
      operatorName: `Nhà xe A ${tag}`,
      plateNumber: plateA,
      caption: "Khoang",
      isCover: false,
      url: storage.publicUrl(newestA.objectKey),
    });
    const second = await list({ limit: 2, cursor: first.nextCursor });
    expect(second.items.map((item) => item.id)).toEqual([oldA.id]);
    expect(second.items[0]!.isCover).toBe(true);
    expect(second.nextCursor).toBeNull();

    const since = await list({ uploadedSince: day(10).toISOString() });
    expect(since.items.map((item) => item.id)).toEqual([newestA.id, newA.id]);
    // Ảnh đại diện là ảnh có vị trí nhỏ nhất của xe, kể cả khi vị trí không bắt đầu từ 0.
    expect((await list({ operatorId: tenantB })).items).toEqual([expect.objectContaining({ id: imageB.id, isCover: true })]);
    expect(first.operators).toEqual(
      expect.arrayContaining([
        { id: tenantA, name: `Nhà xe A ${tag}` },
        { id: tenantB, name: `Nhà xe B ${tag}` },
      ]),
    );
  });

  it("gỡ ảnh: xóa dòng + object, audit trong transaction kèm lý do, email chủ nhà xe; gỡ lần nữa → 404", async () => {
    const cover = await seedImage(tenantA, vehicleA, 0, new Date(), "Ngoại thất");
    const other = await seedImage(tenantA, vehicleA, 1, new Date());

    await admin.remove(authz, actor, cover.id, "Ảnh có giấy tờ xe");

    const left = await prisma.withScope(tenantScope(tenantA), (tx) => tx.vehicleImage.findMany({ where: { vehicleId: vehicleA } }));
    expect(left.map((row) => row.id)).toEqual([other.id]);
    expect(await storage.head(cover.objectKey)).toBeNull();
    expect(await storage.head(other.objectKey)).not.toBeNull();
    expect(recordAuditEvent).toHaveBeenCalledWith(
      expect.objectContaining({
        action: "vehicle_image.remove",
        actorId: actor.sub,
        targetType: "vehicle_image",
        targetId: cover.id,
        operatorId: tenantA,
        reason: "Ảnh có giấy tờ xe",
        before: expect.objectContaining({ vehicleId: vehicleA, objectKey: cover.objectKey, caption: "Ngoại thất" }),
      }),
      expect.objectContaining({ timeoutMs: 2_000, deadline: expect.any(Number) }),
    );
    expect(sendVehicleImageRemoved).toHaveBeenCalledWith({
      email: ownerEmail,
      operatorName: `Nhà xe A ${tag}`,
      plateNumber: plateA,
      caption: "Ngoại thất",
      reason: "Ảnh có giấy tờ xe",
    });
    // Ảnh còn lại thành ảnh đại diện.
    expect((await list()).items).toEqual([expect.objectContaining({ id: other.id, isCover: true })]);

    expect(await rejectionOf(admin.remove(authz, actor, cover.id, "lần nữa"))).toEqual({
      status: 404,
      code: "VEHICLE_IMAGE_NOT_FOUND",
    });
  });

  it("nhà xe đang giữ ảnh vừa bị gỡ trong danh sách gửi lên → 422, không gắn lại ảnh đã gỡ", async () => {
    const removed = await seedImage(tenantA, vehicleA, 0, new Date());
    await admin.remove(authz, actor, removed.id, "Ảnh vi phạm");

    const replay = VehicleImagesInputSchema.parse({ images: [{ objectKey: removed.objectKey, caption: null }] });
    expect(await rejectionOf(operatorImages.replace(authzA, vehicleA, replay))).toMatchObject({
      status: 422,
      code: "VEHICLE_IMAGE_INVALID",
    });
  });

  it("audit lỗi → 503, ảnh và object còn nguyên, không gửi email; email lỗi không làm hỏng việc gỡ", async () => {
    const image = await seedImage(tenantA, vehicleA, 0, new Date());
    recordAuditEvent.mockRejectedValueOnce(new AuditWriteError(new Error("mongo down")));
    expect(await rejectionOf(admin.remove(authz, actor, image.id, "Ảnh vi phạm"))).toEqual({
      status: 503,
      code: "SERVICE_UNAVAILABLE",
    });
    expect(await prisma.withSystem((tx) => tx.vehicleImage.count({ where: { id: image.id } }))).toBe(1);
    expect(await storage.head(image.objectKey)).not.toBeNull();
    expect(sendVehicleImageRemoved).not.toHaveBeenCalled();

    sendVehicleImageRemoved.mockRejectedValueOnce(new Error("domain not verified"));
    await admin.remove(authz, actor, image.id, "Ảnh vi phạm");
    expect(await prisma.withSystem((tx) => tx.vehicleImage.count({ where: { id: image.id } }))).toBe(0);
  });
});
