import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { AuditWriteError, type AuditEventInput, type AuditService } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { platformScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { Authorization } from "../iam/role/authorization";
import { AdminCatalogService } from "./admin-catalog.service";
import { CatalogService } from "./catalog.service";
import {
  AmenityInputSchema,
  ProvinceInputSchema,
  ProvinceListQuerySchema,
  VehicleTypeInputSchema,
  WardInputSchema,
  WardListQuerySchema,
} from "./dto/admin-catalog.dto";

/**
 * TASK-ADM-001 phần catalog — Admin quản lý danh mục chuẩn trên Postgres THẬT bằng role APP (UC-24): thêm, đổi
 * tên, ngừng dùng / dùng lại; mục ngừng dùng biến khỏi API danh mục công khai. Audit là bản giả.
 */
const url = process.env.DATABASE_URL;
const requireDb = process.env.REQUIRE_DB_TESTS === "1";

async function rejectionOf(promise: Promise<unknown>): Promise<{ status?: number; code?: string }> {
  try {
    await promise;
    return {};
  } catch (error) {
    const response = (error as { getResponse?: () => { code?: string } }).getResponse?.();
    return { status: (error as { getStatus?: () => number }).getStatus?.(), code: response?.code };
  }
}

describe.skipIf(!url && !requireDb)("Admin danh mục chuẩn — Postgres thật, role app", () => {
  let prisma: PrismaService;
  let admin: AdminCatalogService;
  let publicCatalog: CatalogService;
  const tag = randomUUID().slice(0, 6).toUpperCase();
  const actor = { sub: randomUUID(), role: "PLATFORM_ADMIN" };
  const authz = { db: platformScope() } as Authorization;
  const recordAuditEvent = vi.fn(async (_event: AuditEventInput) => undefined);
  const created = { provinces: [] as string[], wards: [] as string[], vehicleTypes: [] as string[], amenities: [] as string[] };
  let freeProvinceCodes: string[] = [];
  let freeWardCode = "";

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    const [role] = await prisma.$queryRaw<{ rolsuper: boolean; rolbypassrls: boolean }[]>`
      SELECT rolsuper, rolbypassrls FROM pg_roles WHERE rolname = current_user`;
    if (!role || role.rolsuper || role.rolbypassrls) {
      throw new Error("DATABASE_URL đang là superuser/BYPASSRLS — dùng role app (TRN-001-guide.md §0).");
    }
    admin = new AdminCatalogService(prisma, { recordAuditEvent } as unknown as AuditService);
    publicCatalog = new CatalogService(prisma, { publicUrl: (key) => `https://cdn.test/${key}` });
    // Mã tỉnh chỉ có 2 chữ số: lấy mã chưa dùng trong DB test.
    const used = new Set((await prisma.province.findMany({ select: { code: true } })).map((row) => row.code));
    freeProvinceCodes = Array.from({ length: 100 }, (_, index) => String(index).padStart(2, "0")).filter((code) => !used.has(code));
    const usedWards = new Set((await prisma.ward.findMany({ select: { code: true } })).map((row) => row.code));
    do {
      freeWardCode = String(Math.floor(Math.random() * 100_000)).padStart(5, "0");
    } while (usedWards.has(freeWardCode));
  }, 30_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      await tx.ward.deleteMany({ where: { id: { in: created.wards } } });
      await tx.province.deleteMany({ where: { id: { in: created.provinces } } });
      await tx.vehicleType.deleteMany({ where: { id: { in: created.vehicleTypes } } });
      await tx.amenity.deleteMany({ where: { id: { in: created.amenities } } });
    });
    await prisma.$disconnect();
  });

  beforeEach(() => {
    recordAuditEvent.mockClear();
    recordAuditEvent.mockResolvedValue(undefined);
  });

  it("tỉnh / thành + phường / xã: thêm, trùng mã → 409, đổi tên (audit trước–sau), đếm phường, lọc / tìm (có dấu & không dấu)", async () => {
    const [code] = freeProvinceCodes;
    const province = await admin.createProvince(authz, actor, ProvinceInputSchema.parse({ code, name: `Tỉnh thử ${tag}` }));
    created.provinces.push(province.id);
    expect(province).toMatchObject({ code, status: "ACTIVE", wardCount: 0, stopPointCount: 0 });
    expect(recordAuditEvent).toHaveBeenCalledWith(
      expect.objectContaining({ action: "catalog.province.create", targetId: province.id, actorId: actor.sub }),
      expect.objectContaining({ timeoutMs: 2_000 }),
    );
    expect(await rejectionOf(admin.createProvince(authz, actor, { code: code!, name: "Trùng" }))).toMatchObject({
      status: 409,
      code: "CATALOG_CODE_CONFLICT",
    });

    const ward = await admin.createWard(
      authz,
      actor,
      WardInputSchema.parse({ provinceId: province.id, code: freeWardCode, name: `Phường thử ${tag}` }),
    );
    created.wards.push(ward.id);
    expect(ward).toMatchObject({ provinceId: province.id, provinceName: `Tỉnh thử ${tag}`, stopPointCount: 0 });

    const renamed = await admin.renameProvince(authz, actor, province.id, { name: `Tỉnh đổi tên ${tag}` });
    expect(renamed).toMatchObject({ name: `Tỉnh đổi tên ${tag}`, wardCount: 1 });
    expect(recordAuditEvent).toHaveBeenLastCalledWith(
      expect.objectContaining({
        action: "catalog.province.update",
        before: expect.objectContaining({ name: `Tỉnh thử ${tag}` }),
        after: expect.objectContaining({ name: `Tỉnh đổi tên ${tag}` }),
      }),
      expect.anything(),
    );

    const byName = await admin.listProvinces(authz, ProvinceListQuerySchema.parse({ q: `đổi tên ${tag}`.toLowerCase() }));
    expect(byName.items.map((item) => item.id)).toEqual([province.id]);
    const byUnaccentedName = await admin.listProvinces(authz, ProvinceListQuerySchema.parse({ q: `doi ten ${tag}`.toLowerCase() }));
    expect(byUnaccentedName.items.map((item) => item.id)).toEqual([province.id]);
    const byCode = await admin.listProvinces(authz, ProvinceListQuerySchema.parse({ q: code }));
    expect(byCode.items.map((item) => item.id)).toContain(province.id);
    // `%` / `_` là ký tự thường, không phải ký tự đại diện của LIKE.
    expect((await admin.listProvinces(authz, ProvinceListQuerySchema.parse({ q: "%" }))).total).toBe(0);
    expect((await admin.listWards(authz, WardListQuerySchema.parse({ q: "_" }))).total).toBe(0);
    const wards = await admin.listWards(authz, WardListQuerySchema.parse({ provinceId: province.id, q: `phuong thu ${tag}`.toLowerCase() }));
    expect(wards).toMatchObject({ total: 1, items: [expect.objectContaining({ id: ward.id })] });

    expect(await rejectionOf(admin.createWard(authz, actor, { provinceId: randomUUID(), code: "99999", name: "x" }))).toMatchObject({
      status: 404,
      code: "CATALOG_ITEM_NOT_FOUND",
    });
  });

  it("ngừng dùng kèm lý do → ẩn khỏi API danh mục công khai; ngừng lần nữa → 409; dùng lại → hiện lại; id lạ → 404", async () => {
    const province = await admin.createProvince(authz, actor, { code: freeProvinceCodes[1]!, name: `Tỉnh ngừng ${tag}` });
    created.provinces.push(province.id);
    await admin.setStatus(authz, actor, "provinces", province.id, "INACTIVE", "Sáp nhập địa giới");
    expect(recordAuditEvent).toHaveBeenLastCalledWith(
      expect.objectContaining({
        action: "catalog.province.deactivate",
        reason: "Sáp nhập địa giới",
        before: { status: "ACTIVE" },
        after: { status: "INACTIVE" },
      }),
      expect.anything(),
    );
    expect((await publicCatalog.listProvinces()).items.map((item) => item.id)).not.toContain(province.id);
    expect(await rejectionOf(admin.setStatus(authz, actor, "provinces", province.id, "INACTIVE", "lần nữa"))).toMatchObject({
      status: 409,
      code: "CATALOG_STATE_INVALID",
    });
    await admin.setStatus(authz, actor, "provinces", province.id, "ACTIVE", null);
    expect((await publicCatalog.listProvinces()).items.map((item) => item.id)).toContain(province.id);
    expect(await rejectionOf(admin.setStatus(authz, actor, "wards", randomUUID(), "ACTIVE", null))).toMatchObject({
      status: 404,
    });
  });

  it("loại xe + tiện ích: thêm (mã chữ hoa), sửa tên / mô tả, ngừng dùng → API công khai không còn", async () => {
    const vehicleType = await admin.createVehicleType(
      authz,
      actor,
      VehicleTypeInputSchema.parse({ code: `test_${tag}`, name: "Ghế ngồi thử", description: "", form: "SEATER", class: "STANDARD" }),
    );
    created.vehicleTypes.push(vehicleType.id);
    expect(vehicleType).toMatchObject({
      code: `TEST_${tag}`,
      description: null,
      vehicleCount: 0,
      operatorCount: 0,
      fareRuleCount: 0,
    });
    const updated = await admin.updateVehicleType(authz, actor, vehicleType.id, { name: "Ghế ngồi đổi tên", description: "Mô tả" });
    expect(updated).toMatchObject({ name: "Ghế ngồi đổi tên", description: "Mô tả", form: "SEATER" });
    expect((await admin.listVehicleTypes(authz, {})).items.map((item) => item.id)).toContain(vehicleType.id);

    const amenity = await admin.createAmenity(authz, actor, AmenityInputSchema.parse({ code: `wifi_${tag}`, name: "Wi-Fi thử" }));
    created.amenities.push(amenity.id);
    expect(amenity).toMatchObject({ code: `WIFI_${tag}`, vehicleCount: 0 });
    await admin.renameAmenity(authz, actor, amenity.id, { name: "Wi-Fi đổi tên" });

    await admin.setStatus(authz, actor, "vehicle-types", vehicleType.id, "INACTIVE", "Gộp loại");
    await admin.setStatus(authz, actor, "amenities", amenity.id, "INACTIVE", "Không còn dùng");
    expect((await publicCatalog.listVehicleTypes()).items.map((item) => item.id)).not.toContain(vehicleType.id);
    expect((await publicCatalog.listAmenities()).items.map((item) => item.id)).not.toContain(amenity.id);
    expect((await admin.listAmenities(authz, { status: "INACTIVE" })).items.map((item) => item.id)).toContain(amenity.id);
  });

  it("audit lỗi → 503, không lưu gì", async () => {
    recordAuditEvent.mockRejectedValueOnce(new AuditWriteError(new Error("mongo down")));
    const code = freeProvinceCodes[2]!;
    expect(await rejectionOf(admin.createProvince(authz, actor, { code, name: "Không lưu" }))).toMatchObject({ status: 503 });
    expect(await prisma.province.count({ where: { code } })).toBe(0);
  });
});
