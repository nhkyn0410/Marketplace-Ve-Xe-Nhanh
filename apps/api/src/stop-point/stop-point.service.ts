import { Inject, Injectable } from "@nestjs/common";
import { catalogItemUnavailable } from "../catalog/catalog.errors";
import { searchTextContains } from "../common/search-text";
import { PrismaService, type DbTransaction } from "../database/prisma.service";
import { CatalogStatus, StopPointStatus } from "../database/prisma.types";
import type { Authorization } from "../iam/role/authorization";
import { requireTenant } from "../iam/role/require-tenant";
import { isPrismaUniqueConflict } from "../iam/user/account.errors";
import {
  PRIVATE_STOP_POINT_TYPES,
  type OperatorStopPointListQuery,
  type StopPointInput,
  type StopPointListResponse,
  type StopPointResponse,
} from "./dto/stop-point.dto";
import {
  stopPointNameConflict,
  stopPointNotFound,
  stopPointSuspended,
  stopPointTypeNotAllowed,
} from "./stop-point.errors";

const STOP_POINT_SELECT = {
  id: true,
  name: true,
  type: true,
  address: true,
  provinceId: true,
  wardId: true,
  latitude: true,
  longitude: true,
  description: true,
  status: true,
  suspensionReason: true,
  createdAt: true,
  updatedAt: true,
  // Mỗi route dùng một điểm tối đa một lần (unique) nên số dòng route_stops = số route đang dùng.
  _count: { select: { routeStops: true } },
} as const;

/**
 * Phường phải `ACTIVE`, thuộc đúng tỉnh và tỉnh cũng `ACTIVE` (UC-13 A3). FK ghép phường–tỉnh cũng chặn
 * lệch tỉnh, nhưng kiểm trước để trả 422 rõ ràng thay vì lỗi FK. Dùng chung cho điểm riêng và đề xuất.
 */
export async function assertActiveLocation(
  tx: DbTransaction,
  location: { provinceId: string; wardId: string },
): Promise<void> {
  const ward = await tx.ward.findFirst({
    where: {
      id: location.wardId,
      provinceId: location.provinceId,
      status: CatalogStatus.ACTIVE,
      province: { status: CatalogStatus.ACTIVE },
    },
    select: { id: true },
  });
  if (!ward) {
    throw catalogItemUnavailable();
  }
}

/** Chuyển Date sang chuỗi ISO cho response. */
export function withIsoDates<T extends { createdAt: Date; updatedAt: Date }>(row: T) {
  return { ...row, createdAt: row.createdAt.toISOString(), updatedAt: row.updatedAt.toISOString() };
}

function toResponse<T extends { createdAt: Date; updatedAt: Date; _count: { routeStops: number } }>(row: T) {
  const { _count, ...point } = row;
  return { ...withIsoDates(point), routeCount: _count.routeStops };
}

/**
 * Điểm dừng riêng của nhà xe (TASK-TRN-002 Q1, thiết kế lại ở TASK-TRN-012): chỉ văn phòng / điểm trung
 * chuyển và trạm dừng nghỉ, dùng ngay trong route của tenant, không qua duyệt (BR-38). Điểm bị Admin khóa
 * (`SUSPENDED`, BR-81) nhà xe không sửa và không tự mở lại được. Mọi truy vấn lọc `operatorId` tường minh +
 * chạy trong scope tenant (RLS).
 */
@Injectable()
export class StopPointService {
  constructor(@Inject(PrismaService) private readonly prisma: PrismaService) {}

  /** Liệt kê điểm riêng: lọc trạng thái / loại / tỉnh, tìm không dấu theo tên hoặc địa chỉ, phân trang theo `id`. */
  async list(authz: Authorization, query: OperatorStopPointListQuery): Promise<StopPointListResponse> {
    const { db, operatorId } = requireTenant(authz);
    const rows = await this.prisma.withScope(db, async (tx) =>
      tx.stopPoint.findMany({
        where: {
          operatorId,
          status: query.status,
          type: query.type,
          provinceId: query.provinceId,
          ...(query.q ? { searchText: { contains: await searchTextContains(tx, query.q) } } : {}),
          ...(query.cursor ? { id: { gt: query.cursor } } : {}),
        },
        orderBy: { id: "asc" },
        take: query.limit + 1,
        select: STOP_POINT_SELECT,
      }),
    );
    const page = rows.slice(0, query.limit);
    return {
      items: page.map(toResponse),
      nextCursor: rows.length > query.limit ? page[page.length - 1]!.id : null,
    };
  }

  /** Chi tiết một điểm riêng; khác tenant trả 404 như không tồn tại. */
  async get(authz: Authorization, stopPointId: string): Promise<StopPointResponse> {
    const { db, operatorId } = requireTenant(authz);
    const row = await this.prisma.withScope(db, (tx) =>
      tx.stopPoint.findFirst({ where: { id: stopPointId, operatorId }, select: STOP_POINT_SELECT }),
    );
    if (!row) {
      throw stopPointNotFound();
    }
    return toResponse(row);
  }

  /** Tạo điểm riêng (chỉ văn phòng / trạm dừng nghỉ) sau khi kiểm tỉnh/phường còn hiệu lực. */
  async create(authz: Authorization, input: StopPointInput): Promise<StopPointResponse> {
    const { db, operatorId } = requireTenant(authz);
    assertPrivateType(input);
    const row = await this.withNameConflict(() =>
      this.prisma.withScope(db, async (tx) => {
        await assertActiveLocation(tx, input);
        return tx.stopPoint.create({ data: { ...toData(input), operatorId }, select: STOP_POINT_SELECT });
      }),
    );
    return toResponse(row);
  }

  /**
   * Thay toàn bộ điểm riêng. Route đang dùng điểm này giữ số liệu chặng cũ tới lần sửa route kế tiếp
   * (khi đó toạ độ khác → tính lại); điểm chuyển INACTIVE không gắn mới được nhưng route cũ vẫn giữ.
   * Tỉnh/phường chỉ bị kiểm khi ĐỔI: phường cũ đã bị vô hiệu hoá không khoá việc sửa tên/tạm ngưng điểm.
   * Điểm đang bị Admin khóa → 409; RLS cũng không cho scope tenant ghi dòng `SUSPENDED`.
   */
  async update(authz: Authorization, stopPointId: string, input: StopPointInput): Promise<StopPointResponse> {
    const { db, operatorId } = requireTenant(authz);
    assertPrivateType(input);
    const row = await this.withNameConflict(() =>
      this.prisma.withScope(db, async (tx) => {
        const current = await tx.stopPoint.findFirst({
          where: { id: stopPointId, operatorId },
          select: { provinceId: true, wardId: true, status: true },
        });
        if (!current) {
          throw stopPointNotFound();
        }
        if (current.status === StopPointStatus.SUSPENDED) {
          throw stopPointSuspended();
        }
        if (current.provinceId !== input.provinceId || current.wardId !== input.wardId) {
          await assertActiveLocation(tx, input);
        }
        // Điều kiện "chưa bị khóa" nằm trong chính câu UPDATE: Admin khóa xen giữa lần đọc trên và lệnh ghi
        // thì lệnh ghi khớp 0 dòng (RLS cũng chặn), không ghi đè lên điểm vừa bị khóa.
        const updated = await tx.stopPoint.updateMany({
          where: { id: stopPointId, operatorId, status: { not: StopPointStatus.SUSPENDED } },
          data: toData(input),
        });
        if (updated.count === 0) {
          throw stopPointSuspended();
        }
        return tx.stopPoint.findFirstOrThrow({ where: { id: stopPointId, operatorId }, select: STOP_POINT_SELECT });
      }),
    );
    return toResponse(row);
  }

  private async withNameConflict<T>(work: () => Promise<T>): Promise<T> {
    try {
      return await work();
    } catch (error) {
      // Unique duy nhất do client điều khiển được là `(operator_id, name)`.
      if (isPrismaUniqueConflict(error)) {
        throw stopPointNameConflict();
      }
      throw error;
    }
  }
}

/** Bến xe và điểm dừng đón trả khách chỉ có ở danh mục dùng chung (BR-38); CHECK của DB cũng chặn. */
function assertPrivateType(input: StopPointInput): void {
  if (!PRIVATE_STOP_POINT_TYPES.includes(input.type)) {
    throw stopPointTypeNotAllowed();
  }
}

// Liệt kê từng field: không phụ thuộc Zod strip để chặn client chèn `id`/`operatorId`/`suspensionReason`.
function toData(input: StopPointInput) {
  return {
    name: input.name,
    type: input.type,
    address: input.address,
    provinceId: input.provinceId,
    wardId: input.wardId,
    latitude: input.latitude,
    longitude: input.longitude,
    description: input.description,
    status: input.status,
  };
}
