import { Inject, Injectable } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import type { DbScope } from "../database/db-scope";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import { CatalogStatus } from "../database/prisma.types";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { isPrismaUniqueConflict } from "../iam/user/account.errors";
import {
  catalogAuditUnavailable,
  catalogCodeConflict,
  catalogItemNotFound,
  catalogStateInvalid,
} from "./catalog.errors";
import type {
  AmenityInput,
  AmenityItem,
  AmenityList,
  CatalogKind,
  ProvinceInput,
  ProvinceItem,
  ProvinceListQuery,
  ProvincePage,
  RenameInput,
  StatusQuery,
  VehicleTypeInput,
  VehicleTypeItem,
  VehicleTypeList,
  VehicleTypeUpdate,
  WardInput,
  WardItem,
  WardListQuery,
  WardPage,
} from "./dto/admin-catalog.dto";

type Actor = Pick<VerifiedAccessToken, "sub" | "role">;

const AUDIT_TIMEOUT_MS = 2_000;
/** Tên đối tượng trong audit theo loại danh mục. */
const AUDIT_TARGET: Record<CatalogKind, string> = {
  provinces: "province",
  wards: "ward",
  "vehicle-types": "vehicle_type",
  amenities: "amenity",
};

const BASE_SELECT = { id: true, code: true, name: true, status: true, createdAt: true, updatedAt: true } as const;
const PROVINCE_SELECT = { ...BASE_SELECT, _count: { select: { wards: true } } } as const;
const WARD_SELECT = {
  ...BASE_SELECT,
  provinceId: true,
  province: { select: { name: true } },
  _count: { select: { stopPoints: true } },
} as const;
const VEHICLE_TYPE_SELECT = {
  ...BASE_SELECT,
  description: true,
  form: true,
  class: true,
  _count: { select: { vehicles: true, fareRules: true } },
} as const;
const AMENITY_SELECT = { ...BASE_SELECT, _count: { select: { vehicleAmenities: true } } } as const;

/**
 * Admin quản lý danh mục chuẩn (TASK-ADM-001 phần catalog, UC-24, FR-ADM-04): tỉnh / thành, phường / xã, loại xe,
 * tiện ích. Không xóa — chỉ ngừng dùng (UC-24 A1); mục ngừng dùng ẩn khỏi API danh mục công khai và không chọn được
 * cho dữ liệu mới, dữ liệu đang dùng giữ nguyên. Mã không đổi được sau khi tạo. Mọi thay đổi ghi audit trong
 * transaction (lỗi → 503, không đổi gì).
 */
@Injectable()
export class AdminCatalogService {
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  // ── Tỉnh / thành ─────────────────────────────────────────────────────────────────────────────────────

  async listProvinces(authz: Authorization, query: ProvinceListQuery): Promise<ProvincePage> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const where = {
        status: query.status,
        ...searchWhere(query.q),
      };
      const rows = await tx.province.findMany({
        where: { ...where, ...(query.cursor ? { code: { gt: query.cursor } } : {}) },
        orderBy: { code: "asc" },
        take: query.limit + 1,
        select: PROVINCE_SELECT,
      });
      const total = await tx.province.count({ where });
      const kept = rows.slice(0, query.limit);
      const stopPoints = await countStopPointsByProvince(tx, kept.map((row) => row.id));
      return {
        items: kept.map((row) => toProvince(row, stopPoints.get(row.id) ?? 0)),
        nextCursor: rows.length > query.limit ? kept.at(-1)!.code : null,
        total,
      };
    });
  }

  async createProvince(authz: Authorization, actor: Actor, input: ProvinceInput): Promise<ProvinceItem> {
    return this.write(authz, async (tx, deadline) => {
      const row = await tx.province.create({ data: { code: input.code, name: input.name }, select: PROVINCE_SELECT });
      await this.recordAudit(deadline, actor, "provinces", "create", row.id, null, snapshot(row));
      return toProvince(row, 0);
    });
  }

  async renameProvince(authz: Authorization, actor: Actor, id: string, input: RenameInput): Promise<ProvinceItem> {
    return this.write(authz, async (tx, deadline) => {
      const before = await tx.province.findUnique({ where: { id }, select: PROVINCE_SELECT });
      if (!before) {
        throw catalogItemNotFound();
      }
      const row = await tx.province.update({ where: { id }, data: { name: input.name }, select: PROVINCE_SELECT });
      await this.recordAudit(deadline, actor, "provinces", "update", id, snapshot(before), snapshot(row));
      return toProvince(row, (await countStopPointsByProvince(tx, [id])).get(id) ?? 0);
    });
  }

  // ── Phường / xã ──────────────────────────────────────────────────────────────────────────────────────

  async listWards(authz: Authorization, query: WardListQuery): Promise<WardPage> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const where = {
        provinceId: query.provinceId,
        status: query.status,
        ...searchWhere(query.q),
      };
      const rows = await tx.ward.findMany({
        where: { ...where, ...(query.cursor ? { code: { gt: query.cursor } } : {}) },
        orderBy: { code: "asc" },
        take: query.limit + 1,
        select: WARD_SELECT,
      });
      const total = await tx.ward.count({ where });
      const kept = rows.slice(0, query.limit);
      return {
        items: kept.map(toWard),
        nextCursor: rows.length > query.limit ? kept.at(-1)!.code : null,
        total,
      };
    });
  }

  async createWard(authz: Authorization, actor: Actor, input: WardInput): Promise<WardItem> {
    return this.write(authz, async (tx, deadline) => {
      const province = await tx.province.findUnique({ where: { id: input.provinceId }, select: { id: true } });
      if (!province) {
        throw catalogItemNotFound();
      }
      const row = await tx.ward.create({
        data: { provinceId: input.provinceId, code: input.code, name: input.name },
        select: WARD_SELECT,
      });
      await this.recordAudit(deadline, actor, "wards", "create", row.id, null, { ...snapshot(row), provinceId: row.provinceId });
      return toWard(row);
    });
  }

  async renameWard(authz: Authorization, actor: Actor, id: string, input: RenameInput): Promise<WardItem> {
    return this.write(authz, async (tx, deadline) => {
      const before = await tx.ward.findUnique({ where: { id }, select: WARD_SELECT });
      if (!before) {
        throw catalogItemNotFound();
      }
      const row = await tx.ward.update({ where: { id }, data: { name: input.name }, select: WARD_SELECT });
      await this.recordAudit(deadline, actor, "wards", "update", id, snapshot(before), snapshot(row));
      return toWard(row);
    });
  }

  // ── Loại xe ──────────────────────────────────────────────────────────────────────────────────────────

  async listVehicleTypes(authz: Authorization, query: StatusQuery): Promise<VehicleTypeList> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const rows = await tx.vehicleType.findMany({
        where: { status: query.status },
        orderBy: { code: "asc" },
        select: VEHICLE_TYPE_SELECT,
      });
      const operators = await countOperatorsByVehicleType(tx, rows.map((row) => row.id));
      return { items: rows.map((row) => toVehicleType(row, operators.get(row.id) ?? 0)) };
    });
  }

  async createVehicleType(authz: Authorization, actor: Actor, input: VehicleTypeInput): Promise<VehicleTypeItem> {
    return this.write(authz, async (tx, deadline) => {
      const row = await tx.vehicleType.create({
        data: { code: input.code, name: input.name, description: input.description, form: input.form, class: input.class },
        select: VEHICLE_TYPE_SELECT,
      });
      await this.recordAudit(deadline, actor, "vehicle-types", "create", row.id, null, {
        ...snapshot(row),
        form: row.form,
        class: row.class,
      });
      return toVehicleType(row, 0);
    });
  }

  async updateVehicleType(
    authz: Authorization,
    actor: Actor,
    id: string,
    input: VehicleTypeUpdate,
  ): Promise<VehicleTypeItem> {
    return this.write(authz, async (tx, deadline) => {
      const before = await tx.vehicleType.findUnique({ where: { id }, select: VEHICLE_TYPE_SELECT });
      if (!before) {
        throw catalogItemNotFound();
      }
      const row = await tx.vehicleType.update({
        where: { id },
        data: { name: input.name, description: input.description },
        select: VEHICLE_TYPE_SELECT,
      });
      await this.recordAudit(
        deadline,
        actor,
        "vehicle-types",
        "update",
        id,
        { ...snapshot(before), description: before.description },
        { ...snapshot(row), description: row.description },
      );
      return toVehicleType(row, (await countOperatorsByVehicleType(tx, [id])).get(id) ?? 0);
    });
  }

  // ── Tiện ích ─────────────────────────────────────────────────────────────────────────────────────────

  async listAmenities(authz: Authorization, query: StatusQuery): Promise<AmenityList> {
    const rows = await this.prisma.withScope(platformDb(authz), (tx) =>
      tx.amenity.findMany({ where: { status: query.status }, orderBy: { code: "asc" }, select: AMENITY_SELECT }),
    );
    return { items: rows.map(toAmenity) };
  }

  async createAmenity(authz: Authorization, actor: Actor, input: AmenityInput): Promise<AmenityItem> {
    return this.write(authz, async (tx, deadline) => {
      const row = await tx.amenity.create({ data: { code: input.code, name: input.name }, select: AMENITY_SELECT });
      await this.recordAudit(deadline, actor, "amenities", "create", row.id, null, snapshot(row));
      return toAmenity(row);
    });
  }

  async renameAmenity(authz: Authorization, actor: Actor, id: string, input: RenameInput): Promise<AmenityItem> {
    return this.write(authz, async (tx, deadline) => {
      const before = await tx.amenity.findUnique({ where: { id }, select: AMENITY_SELECT });
      if (!before) {
        throw catalogItemNotFound();
      }
      const row = await tx.amenity.update({ where: { id }, data: { name: input.name }, select: AMENITY_SELECT });
      await this.recordAudit(deadline, actor, "amenities", "update", id, snapshot(before), snapshot(row));
      return toAmenity(row);
    });
  }

  // ── Ngừng dùng / dùng lại ────────────────────────────────────────────────────────────────────────────

  /**
   * Đổi trạng thái một mục (UC-24 bước 6, A1): `INACTIVE` cần lý do (lưu audit); đang ở đúng trạng thái đích →
   * 409. Chỉ đổi khi trạng thái hiện tại khớp (compare-and-set), không ghi đè lần đổi đồng thời.
   */
  async setStatus(
    authz: Authorization,
    actor: Actor,
    kind: CatalogKind,
    id: string,
    to: CatalogStatus,
    reason: string | null,
  ): Promise<void> {
    const from = to === CatalogStatus.ACTIVE ? CatalogStatus.INACTIVE : CatalogStatus.ACTIVE;
    await this.write(authz, async (tx, deadline) => {
      const where = { id, status: from };
      const data = { status: to };
      const changed =
        kind === "provinces"
          ? await tx.province.updateMany({ where, data })
          : kind === "wards"
            ? await tx.ward.updateMany({ where, data })
            : kind === "vehicle-types"
              ? await tx.vehicleType.updateMany({ where, data })
              : await tx.amenity.updateMany({ where, data });
      if (changed.count === 0) {
        throw (await exists(tx, kind, id)) ? catalogStateInvalid() : catalogItemNotFound();
      }
      await this.recordAudit(
        deadline,
        actor,
        kind,
        to === CatalogStatus.ACTIVE ? "activate" : "deactivate",
        id,
        { status: from },
        { status: to },
        reason ?? undefined,
      );
    });
  }

  /** Transaction scope platform; trùng mã → 409; audit lỗi / transaction hết hạn → 503, không lưu gì. */
  private async write<T>(authz: Authorization, work: (tx: DbTransaction, deadline: number) => Promise<T>): Promise<T> {
    try {
      return await this.prisma.withScope(platformDb(authz), (tx) => work(tx, transactionDeadline(Date.now())));
    } catch (error) {
      if (isPrismaUniqueConflict(error)) {
        throw catalogCodeConflict();
      }
      if (error instanceof AuditWriteError || (error as { code?: unknown } | null)?.code === "P2028") {
        throw catalogAuditUnavailable();
      }
      throw error;
    }
  }

  private recordAudit(
    deadline: number,
    actor: Actor,
    kind: CatalogKind,
    action: "create" | "update" | "activate" | "deactivate",
    targetId: string,
    before: Record<string, unknown> | null,
    after: Record<string, unknown>,
    reason?: string,
  ): Promise<void> {
    return this.audit.recordAuditEvent(
      {
        actorId: actor.sub,
        actorRole: actor.role,
        action: `catalog.${AUDIT_TARGET[kind]}.${action}`,
        targetType: AUDIT_TARGET[kind],
        targetId,
        before,
        after,
        ...(reason ? { reason } : {}),
      },
      { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
    );
  }
}

/** Tìm theo mã (bắt đầu bằng) hoặc tên (chứa, không phân biệt hoa thường); `%`, `_`, `\` được tìm đúng ký tự. */
function searchWhere(q: string | undefined) {
  if (!q) {
    return {};
  }
  const literal = q.replace(/[\\%_]/g, "\\$&");
  return { OR: [{ code: { startsWith: literal } }, { name: { contains: literal, mode: "insensitive" as const } }] };
}

function platformDb(authz: Authorization): DbScope {
  if (authz.db?.kind !== "platform") {
    // Lỗi lập trình: route Admin thiếu `@Authorize` với quyền phạm vi `any`.
    throw new Error("Route Admin danh mục cần ngữ cảnh DB platform.");
  }
  return authz.db;
}

async function exists(tx: DbTransaction, kind: CatalogKind, id: string): Promise<boolean> {
  const where = { id };
  const count =
    kind === "provinces"
      ? await tx.province.count({ where })
      : kind === "wards"
        ? await tx.ward.count({ where })
        : kind === "vehicle-types"
          ? await tx.vehicleType.count({ where })
          : await tx.amenity.count({ where });
  return count > 0;
}

/** Số điểm dừng dùng chung theo tỉnh (điểm thuộc tỉnh qua cặp phường–tỉnh). */
async function countStopPointsByProvince(tx: DbTransaction, provinceIds: string[]): Promise<Map<string, number>> {
  if (provinceIds.length === 0) {
    return new Map();
  }
  const groups = await tx.stopPointCatalog.groupBy({
    by: ["provinceId"],
    where: { provinceId: { in: provinceIds } },
    _count: { _all: true },
  });
  return new Map(groups.map((group) => [group.provinceId, group._count._all]));
}

/** Số nhà xe khác nhau có xe thuộc từng loại. */
async function countOperatorsByVehicleType(tx: DbTransaction, typeIds: string[]): Promise<Map<string, number>> {
  if (typeIds.length === 0) {
    return new Map();
  }
  const pairs = await tx.vehicle.groupBy({ by: ["vehicleTypeId", "operatorId"], where: { vehicleTypeId: { in: typeIds } } });
  const counts = new Map<string, number>();
  for (const pair of pairs) {
    counts.set(pair.vehicleTypeId, (counts.get(pair.vehicleTypeId) ?? 0) + 1);
  }
  return counts;
}

type BaseRow = { id: string; code: string; name: string; status: CatalogStatus; createdAt: Date; updatedAt: Date };

function base(row: BaseRow) {
  return {
    id: row.id,
    code: row.code,
    name: row.name,
    status: row.status,
    createdAt: row.createdAt.toISOString(),
    updatedAt: row.updatedAt.toISOString(),
  };
}

function snapshot(row: BaseRow): Record<string, unknown> {
  return { code: row.code, name: row.name, status: row.status };
}

function toProvince(row: BaseRow & { _count: { wards: number } }, stopPointCount: number): ProvinceItem {
  return { ...base(row), wardCount: row._count.wards, stopPointCount };
}

function toWard(
  row: BaseRow & { provinceId: string; province: { name: string }; _count: { stopPoints: number } },
): WardItem {
  return { ...base(row), provinceId: row.provinceId, provinceName: row.province.name, stopPointCount: row._count.stopPoints };
}

function toVehicleType(
  row: BaseRow & {
    description: string | null;
    form: VehicleTypeItem["form"];
    class: VehicleTypeItem["class"];
    _count: { vehicles: number; fareRules: number };
  },
  operatorCount: number,
): VehicleTypeItem {
  return {
    ...base(row),
    description: row.description,
    form: row.form,
    class: row.class,
    vehicleCount: row._count.vehicles,
    operatorCount,
    fareRuleCount: row._count.fareRules,
  };
}

function toAmenity(row: BaseRow & { _count: { vehicleAmenities: number } }): AmenityItem {
  return { ...base(row), vehicleCount: row._count.vehicleAmenities };
}
