import { randomUUID } from "node:crypto";
import { mkdtemp, rm, utimes } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { parseAppConfig } from "../config/env.config";
import { tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import { LocalStorageProvider } from "../external/storage/local-storage-provider";
import type { StorageProvider } from "../external/storage/storage-provider";
import type { Authorization } from "../iam/role/authorization";
import { VehicleInputSchema } from "./dto/vehicle.dto";
import { VehicleImagesInputSchema } from "./dto/vehicle-image.dto";
import { deleteOrphanVehicleImages, ORPHAN_MIN_AGE_MS } from "./vehicle-image-cleanup";
import { MAX_VEHICLE_IMAGE_BYTES, vehicleImageKey, vehicleImagePrefix } from "./vehicle-image-format";
import { ATTACHABLE_MAX_AGE_MS, UPLOAD_URL_TTL_SECONDS, VehicleImageService } from "./vehicle-image.service";
import type { VehicleImageUploadLimiter } from "./vehicle-image-upload-limiter";
import { VehicleService } from "./vehicle.service";

/**
 * TASK-TRN-009 — bộ ảnh xe trên Postgres THẬT bằng role APP + kho ổ đĩa thật (TC-TRN-008, 009, 010). Test bắt buộc
 * tenant-RLS (ADR-025): vài query dưới đây CỐ Ý không lọc `operator_id` để chứng minh RLS chặn cả khi code quên.
 */
const url = process.env.DATABASE_URL;
const requireDb = process.env.REQUIRE_DB_TESTS === "1";

const JPEG = Uint8Array.from([0xff, 0xd8, 0xff, 0xe0, 0, 0x10, 0x4a, 0x46, 0x49, 0x46, 0, 1, 9, 9]);
const PNG = Uint8Array.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0, 0, 0, 0x0d, 9]);
const WEBP = Uint8Array.from([0x52, 0x49, 0x46, 0x46, 0x24, 0, 0, 0, 0x57, 0x45, 0x42, 0x50, 9]);

async function rejectionOf(promise: Promise<unknown>): Promise<{ status?: number; code?: string; text: string }> {
  try {
    await promise;
    return { text: "" };
  } catch (error) {
    const response = (error as { getResponse?: () => { code?: string } }).getResponse?.();
    return {
      status: (error as { getStatus?: () => number }).getStatus?.(),
      code: response?.code,
      text: JSON.stringify(error, Object.getOwnPropertyNames(error)) + String(error),
    };
  }
}

describe.skipIf(!url && !requireDb)("Ảnh xe — Postgres thật, role app, kho ổ đĩa", () => {
  let prisma: PrismaService;
  let rootDir: string;
  let storage: LocalStorageProvider;
  let images: VehicleImageService;
  let vehicles: VehicleService;
  const limiter = { assertWithinLimit: vi.fn(async () => undefined) };
  const tag = randomUUID().slice(0, 8);
  const tenantA = randomUUID();
  const tenantB = randomUUID();
  const typeId = randomUUID();
  const actor = { sub: randomUUID() };
  const authzA = authz(tenantA);
  const authzB = authz(tenantB);
  const dbA = tenantScope(tenantA);
  const dbB = tenantScope(tenantB);
  let vehicleA: string;
  let vehicleA2: string;
  let vehicleB: string;
  let plate = 10_000;

  function authz(operatorId: string): Authorization {
    return { permission: "vehicle:manage", scope: "tenant", db: tenantScope(operatorId) };
  }

  async function newVehicle(as: Authorization): Promise<string> {
    plate += 1;
    const input = VehicleInputSchema.parse({
      plateNumber: `51B-${plate}`,
      vehicleTypeId: typeId,
      seatMapId: null,
      amenityIds: [],
      status: "ACTIVE",
      description: null,
    });
    return (await vehicles.create(as, input)).id;
  }

  /** Xin URL rồi đặt file vào kho như trình duyệt đã `PUT` xong; trả về khóa object. */
  async function upload(
    as: Authorization,
    vehicleId: string,
    body: Uint8Array = JPEG,
    contentType: "image/jpeg" | "image/png" | "image/webp" = "image/jpeg",
    storedAs: string = contentType,
  ): Promise<string> {
    const granted = await images.createUploadUrl(actor, as, vehicleId, { contentType, sizeBytes: body.length });
    await storage.write(granted.objectKey, storedAs, body);
    return granted.objectKey;
  }

  const body = (items: (string | { objectKey: string; caption: string | null })[]) =>
    VehicleImagesInputSchema.parse({
      images: items.map((item) => (typeof item === "string" ? { objectKey: item, caption: null } : item)),
    });

  const keysOf = async (as: Authorization, vehicleId: string) =>
    (await vehicles.get(as, vehicleId)).images.map((image) => image.objectKey);

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    const [role] = await prisma.$queryRaw<{ rolsuper: boolean; rolbypassrls: boolean }[]>`
      SELECT rolsuper, rolbypassrls FROM pg_roles WHERE rolname = current_user`;
    if (!role || role.rolsuper || role.rolbypassrls) {
      throw new Error("DATABASE_URL đang là superuser/BYPASSRLS — dùng role app (TRN-001-guide.md §0).");
    }
    rootDir = await mkdtemp(join(tmpdir(), "vxn-vehicle-image-"));
    storage = new LocalStorageProvider({ rootDir, apiBaseUrl: "http://storage.test" });
    images = new VehicleImageService(prisma, storage, limiter as unknown as VehicleImageUploadLimiter);
    vehicles = new VehicleService(prisma, storage);
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.createMany({
        data: [
          { id: tenantA, operatorSlug: `img-a-${tag}`, displayName: "Img A" },
          { id: tenantB, operatorSlug: `img-b-${tag}`, displayName: "Img B" },
        ],
      });
      await tx.vehicleType.create({
        data: { id: typeId, code: `IMG-${tag}`, name: "Ghế", form: "SEATER", class: "STANDARD" },
      });
    });
    vehicleA = await newVehicle(authzA);
    vehicleA2 = await newVehicle(authzA);
    vehicleB = await newVehicle(authzB);
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
      await tx.operatorProfile.deleteMany({ where: { id: operatorId } });
    });
    await prisma.$disconnect();
    await rm(rootDir, { recursive: true, force: true });
  });

  beforeEach(() => {
    limiter.assertWithinLimit.mockClear();
  });

  describe("RLS (TC-TRN-009)", () => {
    it("vehicle_images ENABLE + FORCE RLS với policy tenant_isolation; rlsProblems() rỗng", async () => {
      const rows = await prisma.$queryRaw<{ relname: string }[]>`
        SELECT c.relname FROM pg_class c JOIN pg_policies p ON p.tablename = c.relname
        WHERE c.relname = 'vehicle_images'
          AND c.relrowsecurity AND c.relforcerowsecurity AND p.policyname = 'tenant_isolation'
          AND p.cmd = 'ALL' AND p.qual LIKE '%app_rls_allows%' AND p.with_check LIKE '%app_rls_allows%'`;
      expect(rows).toHaveLength(1);
      expect(await prisma.rlsProblems()).toEqual([]);
    });

    it("query CỐ Ý quên lọc operator_id: B không đọc / sửa / xóa / chèn được ảnh của A; không ngữ cảnh → 0 dòng", async () => {
      const vehicleId = await newVehicle(authzA);
      const key = await upload(authzA, vehicleId);
      await images.replace(authzA, vehicleId, body([key]));

      const seenByB = await prisma.withScope(dbB, (tx) => tx.vehicleImage.findMany({ where: { vehicleId } }));
      expect(seenByB).toEqual([]);
      const changed = await prisma.withScope(dbB, async (tx) => ({
        updated: (await tx.vehicleImage.updateMany({ where: { vehicleId }, data: { caption: "bị sửa" } })).count,
        deleted: (await tx.vehicleImage.deleteMany({ where: { vehicleId } })).count,
      }));
      expect(changed).toEqual({ updated: 0, deleted: 0 });
      // B chèn ảnh mang `operator_id` của A: WITH CHECK của policy chặn.
      const inserted = await rejectionOf(
        prisma.withScope(dbB, (tx) =>
          tx.vehicleImage.create({
            data: {
              operatorId: tenantA,
              vehicleId,
              objectKey: vehicleImageKey(tenantA, vehicleId, randomUUID(), "image/jpeg"),
              position: 1,
              sizeBytes: 10,
              contentType: "image/jpeg",
            },
          }),
        ),
      );
      expect(inserted.text).toMatch(/row-level security|42501/i);
      // Không đặt ngữ cảnh RLS: bảng trông như rỗng.
      expect(await prisma.vehicleImage.count({ where: { vehicleId } })).toBe(0);
      expect(await keysOf(authzA, vehicleId)).toEqual([key]);
    });

    it("B không xin được URL và không đổi được bộ ảnh xe của A → 404; khóa của xe / nhà xe khác trong body → 422", async () => {
      const keyA = await upload(authzA, vehicleA2);
      const keyB = await upload(authzB, vehicleB);
      await images.replace(authzA, vehicleA2, body([keyA]));

      const grant = await rejectionOf(
        images.createUploadUrl(actor, authzB, vehicleA2, { contentType: "image/jpeg", sizeBytes: 10 }),
      );
      expect(grant).toMatchObject({ status: 404, code: "VEHICLE_NOT_FOUND" });
      expect(await rejectionOf(images.replace(authzB, vehicleA2, body([])))).toMatchObject({
        status: 404,
        code: "VEHICLE_NOT_FOUND",
      });
      // B gắn ảnh của A (object có thật, hợp lệ) vào xe của mình; A gắn ảnh của xe khác cùng nhà xe.
      for (const [as, vehicleId, key] of [
        [authzB, vehicleB, keyA],
        [authzA, vehicleA, keyA],
        [authzA, vehicleA, keyB],
      ] as const) {
        expect(await rejectionOf(images.replace(as, vehicleId, body([key])))).toMatchObject({
          status: 422,
          code: "VEHICLE_IMAGE_INVALID",
        });
      }
      expect(await keysOf(authzA, vehicleA2)).toEqual([keyA]);
      expect(await storage.head(keyA)).not.toBeNull();
      await images.replace(authzA, vehicleA2, body([]));
    });
  });

  describe("Invariant DB (scope system — chứng minh DB tự chặn, không nhờ service)", () => {
    const row = (overrides: Record<string, unknown> = {}) => ({
      operatorId: tenantA,
      vehicleId: vehicleA,
      objectKey: vehicleImageKey(tenantA, vehicleA, randomUUID(), "image/jpeg"),
      position: 0,
      sizeBytes: 10,
      contentType: "image/jpeg",
      ...overrides,
    });
    const insert = (overrides: Record<string, unknown> = {}) =>
      rejectionOf(prisma.withSystem((tx) => tx.vehicleImage.create({ data: row(overrides) as never })));

    it("CHECK vị trí 0–7, dung lượng 1–5 MB, loại file, chú thích ≤ 60 ký tự và không trống", async () => {
      for (const overrides of [
        { position: 8 },
        { position: -1 },
        { sizeBytes: 0 },
        { sizeBytes: MAX_VEHICLE_IMAGE_BYTES + 1 },
        { contentType: "image/gif" },
        { contentType: "image/svg+xml" },
        { caption: "x".repeat(61) },
        { caption: "   " },
        { caption: "" },
      ]) {
        expect((await insert(overrides)).text, JSON.stringify(overrides)).toMatch(/check constraint|23514/i);
      }
    });

    it("FK ghép chặn ảnh mang operator_id của B gắn vào xe của A; trùng khóa object và trùng vị trí bị unique chặn", async () => {
      expect((await insert({ operatorId: tenantB })).text).toMatch(/foreign key|23503/i);

      const vehicleId = await newVehicle(authzA);
      const first = row({ vehicleId, caption: "Ngoại thất" });
      await prisma.withSystem((tx) => tx.vehicleImage.create({ data: first }));
      expect((await insert({ vehicleId, position: 1, objectKey: first.objectKey })).text).toMatch(/unique|23505/i);
      expect((await insert({ vehicleId, position: 0 })).text).toMatch(/unique|23505/i);
      // Xe còn ảnh thì không xóa được (FK RESTRICT) — service phải tự xóa ảnh trước.
      const removed = await rejectionOf(prisma.withSystem((tx) => tx.vehicle.delete({ where: { id: vehicleId } })));
      expect(removed.text).toMatch(/foreign key|23503|P2003/i);
      await prisma.withSystem((tx) => tx.vehicleImage.deleteMany({ where: { vehicleId } }));
    });
  });

  describe("Xin URL tải lên", () => {
    it("khóa do server sinh dưới tiền tố của đúng xe, đuôi theo loại; URL hạn 5 phút; đếm tần suất theo tài khoản", async () => {
      const before = Date.now();
      const granted = await images.createUploadUrl(actor, authzA, vehicleA, { contentType: "image/webp", sizeBytes: 123 });
      expect(granted.objectKey.startsWith(vehicleImagePrefix(tenantA, vehicleA))).toBe(true);
      expect(granted.objectKey.endsWith(".webp")).toBe(true);
      const expiresAt = new Date(granted.expiresAt).getTime();
      expect(expiresAt).toBeGreaterThanOrEqual(before + UPLOAD_URL_TTL_SECONDS * 1000);
      expect(expiresAt).toBeLessThan(before + UPLOAD_URL_TTL_SECONDS * 1000 + 10_000);
      // Token của URL ràng đúng khóa + loại + dung lượng vừa khai.
      const token = new URL(granted.uploadUrl).searchParams.get("token")!;
      expect(storage.verifyUploadToken(token)).toEqual({
        key: granted.objectKey,
        contentType: "image/webp",
        sizeBytes: 123,
      });
      expect(limiter.assertWithinLimit).toHaveBeenCalledWith(actor.sub);
      // Hai lần xin cho hai khóa khác nhau: không ghi đè ảnh đã có.
      const again = await images.createUploadUrl(actor, authzA, vehicleA, { contentType: "image/webp", sizeBytes: 123 });
      expect(again.objectKey).not.toBe(granted.objectKey);
    });

    it("xe không tồn tại → 404; vượt giới hạn tần suất → lỗi của bộ đếm, không cấp URL", async () => {
      expect(
        await rejectionOf(images.createUploadUrl(actor, authzA, randomUUID(), { contentType: "image/png", sizeBytes: 1 })),
      ).toMatchObject({ status: 404, code: "VEHICLE_NOT_FOUND" });

      limiter.assertWithinLimit.mockRejectedValueOnce(new Error("rate limited"));
      await expect(
        images.createUploadUrl(actor, authzA, vehicleA, { contentType: "image/png", sizeBytes: 1 }),
      ).rejects.toThrow("rate limited");
    });
  });

  describe("Thay bộ ảnh (TC-TRN-008)", () => {
    it("thứ tự gửi lên = thứ tự trả về, phần tử đầu là ảnh đại diện; chú thích theo từng ảnh; xe trả kèm ảnh", async () => {
      const vehicleId = await newVehicle(authzA);
      const jpeg = await upload(authzA, vehicleId, JPEG, "image/jpeg");
      const png = await upload(authzA, vehicleId, PNG, "image/png");
      const webp = await upload(authzA, vehicleId, WEBP, "image/webp");

      const saved = await images.replace(
        authzA,
        vehicleId,
        body([
          { objectKey: png, caption: "  Ngoại thất  " },
          { objectKey: webp, caption: "" },
          { objectKey: jpeg, caption: "Khoang hành khách" },
        ]),
      );
      expect(saved.images.map((image) => [image.objectKey, image.position, image.caption])).toEqual([
        [png, 0, "Ngoại thất"],
        [webp, 1, null],
        [jpeg, 2, "Khoang hành khách"],
      ]);
      expect(saved.images[0]!.url).toBe(storage.publicUrl(png));

      const detail = await vehicles.get(authzA, vehicleId);
      expect(detail.images).toEqual(saved.images);
      const listed = (await vehicles.list(authzA, { limit: 100 })).items.find((item) => item.id === vehicleId);
      expect(listed?.images).toEqual(saved.images);
      // Xe khác của cùng nhà xe và xe của nhà xe khác không dính ảnh này.
      expect((await vehicles.get(authzA, vehicleA)).images).toEqual([]);
      expect((await vehicles.get(authzB, vehicleB)).images).toEqual([]);

      const stored = await prisma.withScope(dbA, (tx) =>
        tx.vehicleImage.findMany({ where: { vehicleId }, orderBy: { position: "asc" } }),
      );
      expect(stored.map((image) => [image.contentType, image.sizeBytes, image.operatorId])).toEqual([
        ["image/png", PNG.length, tenantA],
        ["image/webp", WEBP.length, tenantA],
        ["image/jpeg", JPEG.length, tenantA],
      ]);
    });

    it("sắp xếp lại / sửa chú thích giữ nguyên id; ảnh bị bỏ thì xóa object sau commit; mảng rỗng xóa hết", async () => {
      const vehicleId = await newVehicle(authzA);
      const [a, b, c] = [await upload(authzA, vehicleId), await upload(authzA, vehicleId), await upload(authzA, vehicleId)];
      const first = await images.replace(authzA, vehicleId, body([a!, b!, c!]));
      const idOf = new Map(first.images.map((image) => [image.objectKey, image.id]));

      const second = await images.replace(
        authzA,
        vehicleId,
        body([{ objectKey: c!, caption: "Ảnh đại diện mới" }, a!]),
      );
      expect(second.images.map((image) => [image.objectKey, image.position, image.caption, image.id])).toEqual([
        [c, 0, "Ảnh đại diện mới", idOf.get(c!)],
        [a, 1, null, idOf.get(a!)],
      ]);
      expect(await storage.head(b!)).toBeNull();
      expect(await storage.head(a!)).not.toBeNull();
      expect(await storage.head(c!)).not.toBeNull();

      expect((await images.replace(authzA, vehicleId, body([]))).images).toEqual([]);
      expect(await storage.head(a!)).toBeNull();
      expect(await storage.head(c!)).toBeNull();
      expect((await vehicles.get(authzA, vehicleId)).images).toEqual([]);
    });

    it("8 ảnh được; ảnh thứ 9 → 422 VEHICLE_IMAGE_LIMIT_EXCEEDED, bộ ảnh cũ giữ nguyên", async () => {
      const vehicleId = await newVehicle(authzA);
      const keys: string[] = [];
      for (let index = 0; index < 9; index += 1) {
        keys.push(await upload(authzA, vehicleId));
      }
      expect((await images.replace(authzA, vehicleId, body(keys.slice(0, 8)))).images).toHaveLength(8);
      expect(await rejectionOf(images.replace(authzA, vehicleId, body(keys)))).toMatchObject({
        status: 422,
        code: "VEHICLE_IMAGE_LIMIT_EXCEEDED",
      });
      expect(await keysOf(authzA, vehicleId)).toEqual(keys.slice(0, 8));
    });

    it("object không tồn tại / sai loại / quá 5 MB / file không phải ảnh đổi đuôi / tải lên quá lâu → 422, bộ ảnh cũ giữ nguyên", async () => {
      const vehicleId = await newVehicle(authzA);
      const good = await upload(authzA, vehicleId);
      await images.replace(authzA, vehicleId, body([good]));

      const notUploaded = (
        await images.createUploadUrl(actor, authzA, vehicleId, { contentType: "image/jpeg", sizeBytes: 10 })
      ).objectKey;
      // Khóa `.jpg` nhưng kho ghi nhận loại khác với loại đã khai.
      const wrongType = await upload(authzA, vehicleId, JPEG, "image/jpeg", "image/png");
      const tooBig = await upload(authzA, vehicleId, new Uint8Array(JPEG.length), "image/jpeg");
      const big = new Uint8Array(MAX_VEHICLE_IMAGE_BYTES + 1);
      big.set(JPEG);
      await storage.write(tooBig, "image/jpeg", big);
      const html = await upload(authzA, vehicleId, new TextEncoder().encode("<!doctype html><script>alert(1)</script>"));
      // Nội dung PNG thật nhưng khai và đặt tên là JPEG.
      const mismatched = await upload(authzA, vehicleId, PNG, "image/jpeg");
      const empty = await upload(authzA, vehicleId, new Uint8Array(), "image/jpeg");
      const stale = await upload(authzA, vehicleId);
      const old = new Date(Date.now() - ATTACHABLE_MAX_AGE_MS - 60_000);
      await utimes(join(rootDir, stale), old, old);

      for (const [name, key] of Object.entries({ notUploaded, wrongType, tooBig, html, mismatched, empty, stale })) {
        // Ảnh sai đứng cạnh ảnh đúng: cả lần gọi bị từ chối.
        expect(await rejectionOf(images.replace(authzA, vehicleId, body([good, key]))), name).toMatchObject({
          status: 422,
          code: "VEHICLE_IMAGE_INVALID",
        });
        expect(await keysOf(authzA, vehicleId), name).toEqual([good]);
      }
      expect(await storage.head(good)).not.toBeNull();
    });

    it("ảnh đã gắn vẫn giữ được dù object đã cũ: tuổi object chỉ xét với ảnh mới", async () => {
      const vehicleId = await newVehicle(authzA);
      const kept = await upload(authzA, vehicleId);
      await images.replace(authzA, vehicleId, body([kept]));
      const old = new Date(Date.now() - 30 * 24 * 3_600_000);
      await utimes(join(rootDir, kept), old, old);
      const added = await upload(authzA, vehicleId);
      expect((await images.replace(authzA, vehicleId, body([added, kept]))).images.map((image) => image.objectKey)).toEqual([
        added,
        kept,
      ]);
    });
  });

  describe("Đồng thời và lỗi kho (TC-TRN-010)", () => {
    it("hai lần thay đồng thời trên một xe: kết quả là trọn một trong hai danh sách, object của bên thua bị xóa", async () => {
      const vehicleId = await newVehicle(authzA);
      const original = await upload(authzA, vehicleId);
      await images.replace(authzA, vehicleId, body([original]));
      const listOne = [await upload(authzA, vehicleId), await upload(authzA, vehicleId)];
      const listTwo = [await upload(authzA, vehicleId), await upload(authzA, vehicleId), await upload(authzA, vehicleId)];

      await Promise.all([
        images.replace(authzA, vehicleId, body(listOne)),
        images.replace(authzA, vehicleId, body(listTwo)),
      ]);
      const final = await vehicles.get(authzA, vehicleId);
      const keys = final.images.map((image) => image.objectKey);
      expect([listOne, listTwo]).toContainEqual(keys);
      expect(final.images.map((image) => image.position)).toEqual(keys.map((_, index) => index));

      const loser = keys[0] === listOne[0] ? listTwo : listOne;
      for (const key of [original, ...loser]) {
        expect(await storage.head(key), key).toBeNull();
      }
      for (const key of keys) {
        expect(await storage.head(key), key).not.toBeNull();
      }
    });

    it("ảnh 'đang có' bị lần thay khác gỡ ngay trước khi ghi → 422, không gắn lại dòng trỏ tới object đã xóa", async () => {
      const vehicleId = await newVehicle(authzA);
      const kept = await upload(authzA, vehicleId);
      await images.replace(authzA, vehicleId, body([kept]));
      const added = await upload(authzA, vehicleId);

      // Chen một lần thay khác vào đúng giữa bước đọc trước và transaction của lần thay đang xét.
      let raced = false;
      const racing: StorageProvider = Object.create(storage) as StorageProvider;
      racing.head = async (key) => {
        if (!raced) {
          raced = true;
          await images.replace(authzA, vehicleId, body([]));
        }
        return storage.head(key);
      };
      const slow = new VehicleImageService(prisma, racing, limiter as unknown as VehicleImageUploadLimiter);
      expect(await rejectionOf(slow.replace(authzA, vehicleId, body([kept, added])))).toMatchObject({
        status: 422,
        code: "VEHICLE_IMAGE_INVALID",
      });
      expect(await keysOf(authzA, vehicleId)).toEqual([]);
    });

    it("kho không phản hồi khi kiểm ảnh → 503, bộ ảnh cũ giữ nguyên; lỗi xóa object sau commit không làm hỏng lần lưu", async () => {
      const vehicleId = await newVehicle(authzA);
      const first = await upload(authzA, vehicleId);
      await images.replace(authzA, vehicleId, body([first]));
      const second = await upload(authzA, vehicleId);

      const down: StorageProvider = Object.create(storage) as StorageProvider;
      down.head = async () => {
        throw new Error("ETIMEDOUT");
      };
      const whenDown = new VehicleImageService(prisma, down, limiter as unknown as VehicleImageUploadLimiter);
      expect(await rejectionOf(whenDown.replace(authzA, vehicleId, body([second])))).toMatchObject({
        status: 503,
        code: "SERVICE_UNAVAILABLE",
      });
      expect(await keysOf(authzA, vehicleId)).toEqual([first]);

      const cannotDelete: StorageProvider = Object.create(storage) as StorageProvider;
      cannotDelete.delete = async () => {
        throw new Error("ETIMEDOUT");
      };
      const lenient = new VehicleImageService(prisma, cannotDelete, limiter as unknown as VehicleImageUploadLimiter);
      expect((await lenient.replace(authzA, vehicleId, body([second]))).images.map((image) => image.objectKey)).toEqual([
        second,
      ]);
      // Object của ảnh vừa bỏ còn nằm lại — phần việc của job dọn.
      expect(await storage.head(first)).not.toBeNull();

      const later = new Date(Date.now() + ORPHAN_MIN_AGE_MS + 60_000);
      const deleted = await deleteOrphanVehicleImages(storage, prisma, later);
      expect(deleted).toBeGreaterThanOrEqual(1);
      expect(await storage.head(first)).toBeNull();
      // Ảnh đang gắn — của mọi nhà xe — không bị job đụng tới dù đã "cũ".
      expect(await storage.head(second)).not.toBeNull();
      expect(await keysOf(authzA, vehicleId)).toEqual([second]);
    });
  });
});
