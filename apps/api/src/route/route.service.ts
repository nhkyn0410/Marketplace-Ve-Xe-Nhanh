import { Inject, Injectable } from "@nestjs/common";
import { PrismaService, type DbTransaction } from "../database/prisma.service";
import {
  CatalogStatus,
  RouteNameSource,
  RouteStopRole,
  StopPointStatus,
  StopPointType,
  type RouteStatus,
  type RoutingMetricsSource,
} from "../database/prisma.types";
import { loadWardLocalities } from "../database/stop-localities";
import {
  ROUTING_PROVIDER,
  type RouteLeg,
  type RoutingProvider,
  RoutingProviderError,
} from "../external/routing/routing-provider";
import type { Authorization } from "../iam/role/authorization";
import { requireTenant } from "../iam/role/require-tenant";
import { isPrismaUniqueConflict } from "../iam/user/account.errors";
import { stopPointUnavailable } from "../stop-point/stop-point.errors";
import type { RouteInput, RouteListResponse, RouteNamePreview, RouteNamePreviewInput, RouteResponse } from "./dto/route.dto";
import { composeRouteName, nameCandidates } from "./route-name";
import {
  routeDurationTooLong,
  routeNameConflict,
  routeNotFound,
  routeStopPickupDropoffInvalid,
  routingProviderUnavailable,
} from "./route.errors";

/** Một điểm đã kiểm còn hiệu lực + loại, toạ độ hiện tại, phường + tên (ghép tên tuyến) và quyền đón / trả nhà xe khai. */
type ResolvedStop = {
  catalogStopPointId: string | null;
  stopPointId: string | null;
  note: string | null;
  type: StopPointType;
  allowPickup: boolean;
  allowDropoff: boolean;
  latitude: number;
  longitude: number;
  wardId: string;
  name: string;
};

type Scope = ReturnType<typeof requireTenant>["db"];

type Measured = { source: RoutingMetricsSource; legs: RouteLeg[] };

const POINT_SELECT = { name: true, address: true, type: true, wardId: true } as const;
/** Trần một chặng: 5.000 km / 7 ngày — quá mức là provider trả sai; 25 điểm × trần vẫn nằm trong INT4. */
const MAX_LEG_METERS = 5_000_000;
const MAX_LEG_SECONDS = 7 * 24 * 3_600;
/** Tổng thời gian chạy của tuyến tối đa 7 ngày — bằng độ dài tối đa của một chuyến (giờ đến tính theo tuyến). */
const MAX_ROUTE_SECONDS = 7 * 24 * 3_600;
const ACTIVE_WARD = { status: CatalogStatus.ACTIVE, province: { status: CatalogStatus.ACTIVE } } as const;

/**
 * Tuyến của nhà xe (TASK-TRN-002, FR-OPS-04, UC-13). Khoảng cách/thời gian tính lúc tạo hoặc khi chuỗi
 * toạ độ đổi rồi lưu DB (ADR-027 cache-once) — GET không bao giờ gọi provider. Provider được gọi NGOÀI
 * transaction; lỗi provider → 503 và không ghi gì (Q5).
 */
@Injectable()
export class RouteService {
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(ROUTING_PROVIDER) private readonly routing: RoutingProvider,
  ) {}

  /** Liệt kê route của nhà xe kèm số điểm và tên điểm đầu / điểm cuối, lọc trạng thái, phân trang theo `id`. */
  async list(
    authz: Authorization,
    query: { status?: RouteStatus; cursor?: string; limit: number },
  ): Promise<RouteListResponse> {
    const { db, operatorId } = requireTenant(authz);
    const rows = await this.prisma.withScope(db, (tx) =>
      tx.route.findMany({
        where: { operatorId, status: query.status, ...(query.cursor ? { id: { gt: query.cursor } } : {}) },
        orderBy: { id: "asc" },
        take: query.limit + 1,
        select: {
          id: true,
          name: true,
          nameSource: true,
          status: true,
          totalDistanceMeters: true,
          totalDurationSeconds: true,
          metricsSource: true,
          createdAt: true,
          updatedAt: true,
          _count: { select: { stops: true } },
          // Chỉ hai đầu route, không kéo cả danh sách điểm.
          stops: {
            where: { role: { in: [RouteStopRole.ORIGIN, RouteStopRole.DESTINATION] } },
            select: {
              role: true,
              catalogStopPoint: { select: { name: true } },
              stopPoint: { select: { name: true } },
            },
          },
        },
      }),
    );
    const page = rows.slice(0, query.limit);
    const endpointName = (stops: (typeof rows)[number]["stops"], role: RouteStopRole) => {
      const stop = stops.find((candidate) => candidate.role === role);
      return (stop?.catalogStopPoint ?? stop?.stopPoint)?.name ?? "";
    };
    return {
      items: page.map(({ _count, stops, ...route }) => ({
        ...route,
        stopCount: _count.stops,
        originName: endpointName(stops, RouteStopRole.ORIGIN),
        destinationName: endpointName(stops, RouteStopRole.DESTINATION),
        createdAt: route.createdAt.toISOString(),
        updatedAt: route.updatedAt.toISOString(),
      })),
      nextCursor: rows.length > query.limit ? page[page.length - 1]!.id : null,
    };
  }

  /** Chi tiết một route kèm điểm dừng; khác tenant trả 404 như không tồn tại. */
  async get(authz: Authorization, routeId: string): Promise<RouteResponse> {
    const { db, operatorId } = requireTenant(authz);
    const row = await this.prisma.withScope(db, (tx) => findDetail(tx, operatorId, routeId));
    if (!row) {
      throw routeNotFound();
    }
    return this.respond(db, operatorId, row);
  }

  /**
   * Tên tuyến tự động cho danh sách điểm đang sửa (chưa lưu) để form xem trước — không gọi provider, không kiểm quyền đón /
   * trả (form đang sửa dở). Điểm đã có trên tuyến `routeId` được dùng dù đã ngừng, như lúc lưu.
   */
  async previewName(authz: Authorization, input: RouteNamePreviewInput): Promise<RouteNamePreview> {
    const { db, operatorId } = requireTenant(authz);
    const routeId = input.routeId ?? undefined;
    const stops = await this.prisma.withScope(db, async (tx) => {
      const current = routeId ? await findDetail(tx, operatorId, routeId) : null;
      const kept = current?.stops.map((stop) => stop.catalogStopPointId ?? stop.stopPointId!) ?? [];
      return loadStops(tx, operatorId, input.stops, kept);
    });
    return { name: await this.autoName(db, operatorId, stops, routeId) };
  }

  /** Tạo route: kiểm điểm + tên → đo chặng (ngoài transaction) → ghi route + điểm trong một transaction. */
  async create(authz: Authorization, input: RouteInput): Promise<RouteResponse> {
    const { db, operatorId } = requireTenant(authz);
    const stops = await this.prisma.withScope(db, (tx) => resolveStops(tx, operatorId, input.stops));
    const name = await this.resolveName(db, operatorId, input, stops);
    const measured = await this.measure(stops);
    const legs = effectiveLegs(input, measured.legs);
    const row = await this.withNameConflict(() =>
      this.prisma.withScope(db, async (tx) => {
        const route = await tx.route.create({
          data: { operatorId, ...routeData(input, name, measured, legs) },
          select: { id: true },
        });
        await tx.routeStop.createMany({ data: stopRows(operatorId, route.id, stops, measured.legs, legs) });
        return findDetail(tx, operatorId, route.id);
      }),
    );
    return this.respond(db, operatorId, row!);
  }

  /**
   * Thay toàn bộ route. Chỉ gọi provider khi chuỗi toạ độ đổi so với toạ độ ĐÃ DÙNG để tính (hoặc nguồn
   * số liệu đổi, vd. vừa có key Goong) — đổi tên/ghi chú/trạng thái không tốn quota. Ghi dòng route trước
   * (khoá dòng) rồi mới thay điểm → hai PUT đồng thời không trộn điểm/số liệu.
   */
  async update(authz: Authorization, routeId: string, input: RouteInput): Promise<RouteResponse> {
    const { db, operatorId } = requireTenant(authz);
    const { current, stops } = await this.prisma.withScope(db, async (tx) => {
      const current = await findDetail(tx, operatorId, routeId);
      if (!current) {
        throw routeNotFound();
      }
      // Điểm đã có trong route được giữ dù đã bị vô hiệu hoá — để Owner vẫn đổi tên/tạm ngưng route
      // (mẫu TRN-001); chỉ điểm MỚI thêm mới phải ACTIVE. Mở bán (TRN-006) kiểm lại toàn bộ điểm.
      const kept = current.stops.map((stop) => stop.catalogStopPointId ?? stop.stopPointId!);
      return { current, stops: await resolveStops(tx, operatorId, input.stops, kept) };
    });
    const name = await this.resolveName(db, operatorId, input, stops, routeId);
    const measured =
      current.metricsSource === this.routing.source && sameCoordinates(current.stops, stops)
        ? {
            source: current.metricsSource,
            // Số HỆ THỐNG đã lưu (không phải số nhà xe chỉnh) — bỏ chỉnh tay thì quay về đúng số này.
            legs: current.stops.slice(1).map((stop) => ({
              distanceMeters: stop.distanceMetersFromPrevious!,
              durationSeconds: stop.measuredDurationSeconds!,
            })),
          }
        : await this.measure(stops);
    const legs = effectiveLegs(input, measured.legs);
    const row = await this.withNameConflict(() =>
      this.prisma.withScope(db, async (tx) => {
        const updated = await tx.route.updateMany({
          where: { id: routeId, operatorId },
          data: routeData(input, name, measured, legs),
        });
        if (updated.count === 0) {
          throw routeNotFound();
        }
        await tx.routeStop.deleteMany({ where: { routeId, operatorId } });
        await tx.routeStop.createMany({ data: stopRows(operatorId, routeId, stops, measured.legs, legs) });
        return findDetail(tx, operatorId, routeId);
      }),
    );
    return this.respond(db, operatorId, row!);
  }

  /** Tên sẽ lưu: `AUTO` thì ghép từ điểm dừng; `MANUAL` thì tên nhà xe gõ, chặn trùng TRƯỚC khi gọi provider (security M2). */
  private async resolveName(db: Scope, operatorId: string, input: RouteInput, stops: ResolvedStop[], routeId?: string): Promise<string> {
    if (input.nameSource === RouteNameSource.AUTO) {
      return this.autoName(db, operatorId, stops, routeId);
    }
    await this.prisma.withScope(db, (tx) => assertNameFree(tx, operatorId, input.name, routeId));
    return input.name;
  }

  /**
   * Tên tự động của danh sách điểm (giai đoạn 3.1, chờ duyệt): nơi của từng điểm theo phường → `composeRouteName`, rồi lấy
   * biến thể đầu tiên chưa có ở tuyến khác của nhà xe (bỏ qua `exceptRouteId`).
   */
  private async autoName(
    db: Scope,
    operatorId: string,
    stops: Pick<ResolvedStop, "wardId" | "name" | "allowPickup" | "allowDropoff">[],
    exceptRouteId?: string,
  ): Promise<string> {
    const localities = await loadWardLocalities(this.prisma, stops.map((stop) => stop.wardId));
    const base = composeRouteName(stops.map((stop) => ({ ...stop, locality: localities.get(stop.wardId) ?? stop.name })));
    const candidates = nameCandidates(base, stops[0]?.name ?? "");
    const taken = await this.prisma.withScope(db, (tx) =>
      tx.route.findMany({
        where: { operatorId, name: { in: candidates }, ...(exceptRouteId ? { id: { not: exceptRouteId } } : {}) },
        select: { name: true },
      }),
    );
    const free = candidates.find((name) => !taken.some((route) => route.name === name));
    if (!free) {
      throw routeNameConflict();
    }
    return free;
  }

  /** Response kèm tên gợi ý: tuyến đặt tên tay mà tên tự động khác tên đang dùng. */
  private async respond(db: Scope, operatorId: string, row: NonNullable<Awaited<ReturnType<typeof findDetail>>>): Promise<RouteResponse> {
    let suggestedName: string | null = null;
    if (row.nameSource === RouteNameSource.MANUAL) {
      const stops = row.stops.map((stop) => {
        const point = stop.catalogStopPoint ?? stop.stopPoint!;
        return { wardId: point.wardId, name: point.name, allowPickup: stop.allowPickup, allowDropoff: stop.allowDropoff };
      });
      const auto = await this.autoName(db, operatorId, stops, row.id).catch(() => null);
      suggestedName = auto && auto !== row.name ? auto : null;
    }
    return toResponse(row, suggestedName);
  }

  private async measure(stops: ResolvedStop[]): Promise<Measured> {
    let legs: RouteLeg[];
    try {
      legs = await this.routing.measureLegs(stops.map(({ latitude, longitude }) => ({ latitude, longitude })));
    } catch (error) {
      if (error instanceof RoutingProviderError) {
        throw routingProviderUnavailable();
      }
      throw error;
    }
    // Không tin provider: thiếu/thừa chặng, số âm/không nguyên hoặc lớn phi lý (vượt INT4 khi cộng) thì coi
    // như lỗi, không lưu (Q5).
    const valid =
      legs.length === stops.length - 1 &&
      legs.every(
        (leg) =>
          Number.isInteger(leg.distanceMeters) &&
          Number.isInteger(leg.durationSeconds) &&
          leg.distanceMeters >= 0 &&
          leg.durationSeconds >= 0 &&
          leg.distanceMeters <= MAX_LEG_METERS &&
          leg.durationSeconds <= MAX_LEG_SECONDS,
      );
    if (!valid) {
      throw routingProviderUnavailable();
    }
    return { source: this.routing.source, legs };
  }

  private async withNameConflict<T>(work: () => Promise<T>): Promise<T> {
    try {
      return await work();
    } catch (error) {
      // Điểm lặp đã bị Zod chặn → unique còn lại chỉ có thể là tên route trong tenant.
      if (isPrismaUniqueConflict(error)) {
        throw routeNameConflict();
      }
      throw error;
    }
  }
}

/**
 * Chặn trùng tên TRƯỚC khi gọi provider: POST/PUT lặp lại với tên đã có không được tốn quota Goong
 * (security M2). Unique DB vẫn là chốt chặn cuối cho trường hợp đua.
 */
async function assertNameFree(tx: DbTransaction, operatorId: string, name: string, exceptRouteId?: string) {
  const taken = await tx.route.findFirst({
    where: { operatorId, name, ...(exceptRouteId ? { id: { not: exceptRouteId } } : {}) },
    select: { id: true },
  });
  if (taken) {
    throw routeNameConflict();
  }
}

/**
 * Kiểm điểm dùng được (BR-38, UC-13 A1): điểm MỚI phải là catalog `ACTIVE`, hoặc điểm riêng `ACTIVE` CỦA
 * TENANT NÀY (điểm bị Admin khóa không gắn mới được — BR-81), với phường/tỉnh `ACTIVE`; điểm trong `kept`
 * (đã có trên route) được giữ dù đã vô hiệu hoá. Điểm riêng luôn lọc theo tenant. Không phân biệt lý do để
 * không lộ điểm của tenant khác. Sau đó kiểm quyền đón / trả theo vị trí và loại điểm (BR-79).
 */
async function resolveStops(
  tx: DbTransaction,
  operatorId: string,
  stops: RouteInput["stops"],
  kept: string[] = [],
): Promise<ResolvedStop[]> {
  const resolved = await loadStops(tx, operatorId, stops, kept);
  assertPickupDropoff(resolved);
  return resolved;
}

/** Như `resolveStops` nhưng chưa kiểm quyền đón / trả — dùng cho xem trước tên khi form đang sửa dở. */
async function loadStops(
  tx: DbTransaction,
  operatorId: string,
  stops: RouteInput["stops"],
  kept: string[] = [],
): Promise<ResolvedStop[]> {
  const catalogIds = stops.flatMap((stop) => (stop.catalogStopPointId ? [stop.catalogStopPointId] : []));
  const privateIds = stops.flatMap((stop) => (stop.stopPointId ? [stop.stopPointId] : []));
  const coordinates = { id: true, type: true, latitude: true, longitude: true, wardId: true, name: true } as const;
  const [catalog, own] = await Promise.all([
    tx.stopPointCatalog.findMany({
      where: {
        id: { in: catalogIds },
        OR: [{ id: { in: kept } }, { status: CatalogStatus.ACTIVE, ward: ACTIVE_WARD }],
      },
      select: coordinates,
    }),
    tx.stopPoint.findMany({
      where: {
        id: { in: privateIds },
        operatorId,
        OR: [{ id: { in: kept } }, { status: StopPointStatus.ACTIVE, ward: ACTIVE_WARD }],
      },
      select: coordinates,
    }),
  ]);
  const catalogById = new Map(catalog.map((point) => [point.id, point]));
  const ownById = new Map(own.map((point) => [point.id, point]));
  return stops.map((stop) => {
    const point = stop.catalogStopPointId
      ? catalogById.get(stop.catalogStopPointId)
      : ownById.get(stop.stopPointId!);
    if (!point) {
      throw stopPointUnavailable();
    }
    return {
      catalogStopPointId: stop.catalogStopPointId,
      stopPointId: stop.stopPointId,
      note: stop.note,
      type: point.type,
      allowPickup: stop.allowPickup,
      allowDropoff: stop.allowDropoff,
      latitude: point.latitude,
      longitude: point.longitude,
      wardId: point.wardId,
      name: point.name,
    };
  });
}

/**
 * BR-79: điểm đầu chỉ đón, điểm cuối chỉ trả, điểm giữa có ít nhất một quyền; trạm dừng nghỉ không đón,
 * không trả và không đứng đầu / cuối. Hai đầu không phải bến xe KHÔNG bị chặn ở v1 (OQ-24) — giao diện tự
 * cảnh báo từ `type`.
 */
function assertPickupDropoff(stops: ResolvedStop[]): void {
  const last = stops.length - 1;
  const valid = stops.every((stop, index) => {
    if (stop.type === StopPointType.REST_STOP) {
      return index !== 0 && index !== last && !stop.allowPickup && !stop.allowDropoff;
    }
    if (index === 0) {
      return stop.allowPickup && !stop.allowDropoff;
    }
    if (index === last) {
      return !stop.allowPickup && stop.allowDropoff;
    }
    return stop.allowPickup || stop.allowDropoff;
  });
  if (!valid) {
    throw routeStopPickupDropoffInvalid();
  }
}

function sameCoordinates(
  current: { latitude: number; longitude: number }[],
  next: { latitude: number; longitude: number }[],
): boolean {
  return (
    current.length === next.length &&
    current.every((stop, index) => stop.latitude === next[index]!.latitude && stop.longitude === next[index]!.longitude)
  );
}

/**
 * Chặng dùng thật: chặng nào nhà xe nhập số phút thì lấy số đó, còn lại giữ số hệ thống (chờ duyệt 27/10/2026). Tổng quá
 * 7 ngày thì từ chối — giờ đến của chuyến = giờ đi + tổng này.
 */
function effectiveLegs(input: RouteInput, measured: RouteLeg[]): RouteLeg[] {
  const legs = measured.map((leg, index) => {
    const minutes = input.stops[index + 1]?.durationMinutesFromPrevious;
    return minutes ? { ...leg, durationSeconds: minutes * 60 } : leg;
  });
  if (legs.reduce((sum, leg) => sum + leg.durationSeconds, 0) > MAX_ROUTE_SECONDS) {
    throw routeDurationTooLong();
  }
  return legs;
}

function routeData(input: RouteInput, name: string, measured: Measured, legs: RouteLeg[]) {
  return {
    name,
    nameSource: input.nameSource,
    status: input.status,
    note: input.note,
    totalDistanceMeters: legs.reduce((sum, leg) => sum + leg.distanceMeters, 0),
    totalDurationSeconds: legs.reduce((sum, leg) => sum + leg.durationSeconds, 0),
    metricsSource: measured.source,
  };
}

function stopRows(operatorId: string, routeId: string, stops: ResolvedStop[], measured: RouteLeg[], legs: RouteLeg[]) {
  const last = stops.length - 1;
  return stops.map((stop, index) => ({
    operatorId,
    routeId,
    sequence: index + 1,
    role: index === 0 ? RouteStopRole.ORIGIN : index === last ? RouteStopRole.DESTINATION : RouteStopRole.INTERMEDIATE,
    catalogStopPointId: stop.catalogStopPointId,
    stopPointId: stop.stopPointId,
    note: stop.note,
    allowPickup: stop.allowPickup,
    allowDropoff: stop.allowDropoff,
    latitude: stop.latitude,
    longitude: stop.longitude,
    distanceMetersFromPrevious: index === 0 ? null : legs[index - 1]!.distanceMeters,
    durationSecondsFromPrevious: index === 0 ? null : legs[index - 1]!.durationSeconds,
    measuredDurationSeconds: index === 0 ? null : measured[index - 1]!.durationSeconds,
  }));
}

function findDetail(tx: DbTransaction, operatorId: string, routeId: string) {
  return tx.route.findFirst({
    where: { id: routeId, operatorId },
    select: {
      id: true,
      name: true,
      nameSource: true,
      status: true,
      note: true,
      totalDistanceMeters: true,
      totalDurationSeconds: true,
      metricsSource: true,
      createdAt: true,
      updatedAt: true,
      stops: {
        orderBy: { sequence: "asc" },
        select: {
          sequence: true,
          role: true,
          catalogStopPointId: true,
          stopPointId: true,
          note: true,
          allowPickup: true,
          allowDropoff: true,
          latitude: true,
          longitude: true,
          distanceMetersFromPrevious: true,
          durationSecondsFromPrevious: true,
          measuredDurationSeconds: true,
          catalogStopPoint: { select: POINT_SELECT },
          stopPoint: { select: POINT_SELECT },
        },
      },
    },
  });
}

function toResponse(row: NonNullable<Awaited<ReturnType<typeof findDetail>>>, suggestedName: string | null): RouteResponse {
  return {
    ...row,
    suggestedName,
    createdAt: row.createdAt.toISOString(),
    updatedAt: row.updatedAt.toISOString(),
    stops: row.stops.map(({ catalogStopPoint, stopPoint, measuredDurationSeconds, ...stop }) => {
      const point = catalogStopPoint ?? stopPoint!;
      return { ...stop, measuredDurationSecondsFromPrevious: measuredDurationSeconds, name: point.name, type: point.type, address: point.address };
    }),
  };
}
