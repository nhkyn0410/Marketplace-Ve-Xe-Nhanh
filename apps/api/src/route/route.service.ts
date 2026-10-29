import { Inject, Injectable } from "@nestjs/common";
import { PrismaService, type DbTransaction } from "../database/prisma.service";
import {
  CatalogStatus,
  FareStatus,
  RouteNameSource,
  RouteStatus,
  RouteStopRole,
  StopPointStatus,
  StopPointType,
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
import { vndToJson } from "../fare/fare-pricing";
import { stopPointUnavailable } from "../stop-point/stop-point.errors";
import type {
  RouteInput,
  RouteListResponse,
  RouteNamePreview,
  RouteNamePreviewInput,
  RouteResponse,
  SubRouteInput,
  SubRouteSuggestionList,
} from "./dto/route.dto";
import { composeRouteName, nameCandidates } from "./route-name";
import {
  routeDurationTooLong,
  routeIsSubRoute,
  routeNameConflict,
  routeNotFound,
  routeStopPickupDropoffInvalid,
  routingProviderUnavailable,
  subRouteBoundsInvalid,
  subRouteConflict,
  subRouteNotReady,
} from "./route.errors";
import {
  locateSpan,
  type ParentStop,
  type PointRef,
  samePoint,
  scaleRules,
  sliceStopRows,
  type Span,
  spanTotals,
  suggestSpans,
} from "./sub-route";

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
/** Hai đầu của tuyến con (điểm đã chép) — so với điểm của tuyến chính theo mã điểm. */
const END_SELECT = { role: true, catalogStopPointId: true, stopPointId: true } as const;
/** Dòng điểm của tuyến chính đủ để tìm đoạn và chép đoạn cho tuyến con. */
const PARENT_STOP_SELECT = {
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
} as const;
const RULE_SELECT = { vehicleTypeId: true, seatType: true, validFrom: true, validTo: true, price: true } as const;
/** Các cột của một dòng danh sách tuyến (dùng cho cả tuyến con lồng bên dưới). */
const LIST_SELECT = {
  id: true,
  name: true,
  nameSource: true,
  status: true,
  totalDistanceMeters: true,
  totalDurationSeconds: true,
  metricsSource: true,
  parentRouteId: true,
  createdAt: true,
  updatedAt: true,
  _count: { select: { stops: true } },
  // Chỉ hai đầu route, không kéo cả danh sách điểm.
  stops: {
    where: { role: { in: [RouteStopRole.ORIGIN, RouteStopRole.DESTINATION] as RouteStopRole[] } },
    select: { role: true, catalogStopPoint: { select: { name: true } }, stopPoint: { select: { name: true } } },
  },
} as const;

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

  /**
   * Liệt kê route của nhà xe kèm số điểm và tên điểm đầu / điểm cuối, lọc trạng thái, phân trang theo `id`. Mặc định chỉ
   * tuyến chính, mỗi dòng kèm tuyến con (3.2); `includeSubRoutes` thì tuyến con cũng là một dòng.
   */
  async list(
    authz: Authorization,
    query: { status?: RouteStatus; cursor?: string; limit: number; includeSubRoutes?: boolean },
  ): Promise<RouteListResponse> {
    const { db, operatorId } = requireTenant(authz);
    const rows = await this.prisma.withScope(db, (tx) =>
      tx.route.findMany({
        where: {
          operatorId,
          status: query.status,
          ...(query.includeSubRoutes ? {} : { parentRouteId: null }),
          ...(query.cursor ? { id: { gt: query.cursor } } : {}),
        },
        orderBy: { id: "asc" },
        take: query.limit + 1,
        select: { ...LIST_SELECT, subRoutes: { orderBy: { name: "asc" }, select: LIST_SELECT } },
      }),
    );
    const page = rows.slice(0, query.limit);
    return {
      items: page.map(({ subRoutes, ...route }) => ({ ...toListItem(route), subRoutes: subRoutes.map(toListItem) })),
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
      if (current.parentRouteId) {
        throw routeIsSubRoute();
      }
      // Điểm đã có trong route được giữ dù đã bị vô hiệu hoá — để Owner vẫn đổi tên/tạm ngưng route
      // (mẫu TRN-001); chỉ điểm MỚI thêm mới phải ACTIVE. Mở bán (TRN-006) kiểm lại toàn bộ điểm.
      const kept = current.stops.map((stop) => stop.catalogStopPointId ?? stop.stopPointId!);
      return { current, stops: await resolveStops(tx, operatorId, input.stops, kept) };
    });
    const name = await this.resolveName(db, operatorId, input, stops, routeId);
    // Nơi của từng điểm để ghép lại tên tuyến con tự đặt tên khi đoạn của nó đổi (3.2).
    const localities =
      current.subRoutes.length > 0 ? await loadWardLocalities(this.prisma, stops.map((stop) => stop.wardId)) : new Map<string, string>();
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
        const rows = stopRows(operatorId, routeId, stops, measured.legs, legs);
        await tx.routeStop.createMany({ data: rows });
        await syncSubRoutes(tx, operatorId, routeId, rows, stops, localities, measured.source);
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
    return this.prisma.withScope(db, (tx) => pickFreeName(tx, operatorId, base, stops[0]?.name ?? "", exceptRouteId));
  }

  /**
   * Response kèm tên gợi ý (tuyến đặt tên tay mà tên tự động khác tên đang dùng), tuyến con kèm bảng giá, và cờ "cần xem
   * lại" của tuyến con có hai đầu không còn hợp lệ trên tuyến chính (3.2).
   */
  private async respond(db: Scope, operatorId: string, row: DetailRow): Promise<RouteResponse> {
    let suggestedName: string | null = null;
    if (row.nameSource === RouteNameSource.MANUAL) {
      const stops = row.stops.map((stop) => {
        const point = stop.catalogStopPoint ?? stop.stopPoint!;
        return { wardId: point.wardId, name: point.name, allowPickup: stop.allowPickup, allowDropoff: stop.allowDropoff };
      });
      const auto = await this.autoName(db, operatorId, stops, row.id).catch(() => null);
      suggestedName = auto && auto !== row.name ? auto : null;
    }
    let needsReview = false;
    if (row.parentRouteId) {
      const parentStops = await this.prisma.withScope(db, (tx) => loadParentStops(tx, operatorId, row.parentRouteId!));
      needsReview = !spanOf(parentStops, row.stops);
    }
    return toResponse(row, suggestedName, needsReview);
  }

  /**
   * Đoạn gợi ý thành tuyến con của một tuyến chính (3.2): theo nhóm nơi (`suggestSpans`), bỏ đoạn đã có tuyến con; mỗi gợi
   * ý có tên tự động (đã tránh trùng), quãng đường, thời gian và bảng giá gợi ý theo tỉ lệ quãng đường.
   */
  async subRouteSuggestions(authz: Authorization, routeId: string): Promise<SubRouteSuggestionList> {
    const { db, operatorId } = requireTenant(authz);
    const [row, fare] = await this.prisma.withScope(db, async (tx) => [
      await findDetail(tx, operatorId, routeId),
      await tx.fare.findFirst({ where: { routeId, operatorId }, select: { rules: { select: RULE_SELECT } } }),
    ] as const);
    if (!row) {
      throw routeNotFound();
    }
    if (row.parentRouteId) {
      throw routeIsSubRoute();
    }
    const points = row.stops.map((stop) => stop.catalogStopPoint ?? stop.stopPoint!);
    const localities = await loadWardLocalities(this.prisma, points.map((point) => point.wardId));
    const located = row.stops.map((stop, index) => ({
      ...stop,
      name: points[index]!.name,
      locality: localities.get(points[index]!.wardId) ?? points[index]!.name,
    }));
    const drafts = suggestSpans(located)
      .filter((span) => !row.subRoutes.some((child) => sameSpan(located, span, child.stops)))
      .map((span) => ({
        span,
        candidates: nameCandidates(composeRouteName(located.slice(span.from, span.to + 1)), located[span.from]!.name),
      }));
    const taken = new Set(
      (
        await this.prisma.withScope(db, (tx) =>
          tx.route.findMany({ where: { operatorId, name: { in: drafts.flatMap((draft) => draft.candidates) } }, select: { name: true } }),
        )
      ).map((route) => route.name),
    );
    const items: SubRouteSuggestionList["items"] = [];
    for (const { span, candidates } of drafts) {
      // Hai gợi ý không lấy cùng một tên; hết biến thể thì bỏ gợi ý đó (nhà xe vẫn tự tạo được, đặt tên tay).
      const name = candidates.find((candidate) => !taken.has(candidate));
      if (!name) {
        continue;
      }
      taken.add(name);
      const totals = spanTotals(row.stops, span);
      const rules = fare ? scaleRules(fare.rules, totals.distanceMeters, row.totalDistanceMeters) : null;
      items.push({
        from: endOf(row.stops[span.from]!),
        to: endOf(row.stops[span.to]!),
        name,
        totalDistanceMeters: totals.distanceMeters,
        totalDurationSeconds: totals.durationSeconds,
        suggestedRules:
          rules?.map((rule) => ({
            vehicleTypeId: rule.vehicleTypeId,
            seatType: rule.seatType,
            validFrom: rule.validFrom?.toISOString() ?? null,
            validTo: rule.validTo?.toISOString() ?? null,
            price: vndToJson(rule.price),
          })) ?? null,
      });
    }
    return { items };
  }

  /** Tạo tuyến con của tuyến `parentId` (3.2) — chưa có bảng giá nên chỉ ở Nháp hoặc Ngừng. */
  async createSubRoute(authz: Authorization, parentId: string, input: SubRouteInput): Promise<RouteResponse> {
    const { db, operatorId } = requireTenant(authz);
    return this.writeSubRoute(db, operatorId, parentId, null, input);
  }

  /** Thay toàn bộ một tuyến con: đổi hai đầu thì chép lại đoạn của tuyến chính; bật cần bảng giá đang áp dụng. */
  async updateSubRoute(authz: Authorization, parentId: string, subRouteId: string, input: SubRouteInput): Promise<RouteResponse> {
    const { db, operatorId } = requireTenant(authz);
    return this.writeSubRoute(db, operatorId, parentId, subRouteId, input);
  }

  private async writeSubRoute(
    db: Scope,
    operatorId: string,
    parentId: string,
    subRouteId: string | null,
    input: SubRouteInput,
  ): Promise<RouteResponse> {
    // Đọc trước tuyến chính để ghép / kiểm tên ngoài transaction (như tạo tuyến); trong transaction khoá dòng tuyến chính
    // rồi kiểm lại hai đầu — sửa tuyến chính cùng lúc không làm lệch đoạn đã chép.
    const parent = await this.prisma.withScope(db, (tx) => findDetail(tx, operatorId, parentId));
    if (!parent) {
      throw routeNotFound();
    }
    if (parent.parentRouteId) {
      throw routeIsSubRoute();
    }
    const span = locateSpan(parent.stops, input.from, input.to);
    if (!span) {
      throw subRouteBoundsInvalid();
    }
    let name = input.name;
    if (input.nameSource === RouteNameSource.AUTO) {
      name = await this.autoName(db, operatorId, namingStops(parent.stops, span), subRouteId ?? undefined);
    } else {
      await this.prisma.withScope(db, (tx) => assertNameFree(tx, operatorId, input.name, subRouteId ?? undefined));
    }
    const row = await this.withNameConflict(() =>
      this.prisma.withScope(db, async (tx) => {
        await tx.$queryRaw`SELECT id FROM routes WHERE id = ${parentId} AND operator_id = ${operatorId} FOR UPDATE`;
        const stops = await loadParentStops(tx, operatorId, parentId);
        const fresh = locateSpan(stops, input.from, input.to);
        if (!fresh) {
          throw subRouteBoundsInvalid();
        }
        if (subRouteId && !(await tx.route.findFirst({ where: { id: subRouteId, operatorId, parentRouteId: parentId }, select: { id: true } }))) {
          throw routeNotFound();
        }
        const siblings = await tx.route.findMany({
          where: { parentRouteId: parentId, operatorId, ...(subRouteId ? { id: { not: subRouteId } } : {}) },
          select: { stops: { where: { role: { in: [RouteStopRole.ORIGIN, RouteStopRole.DESTINATION] } }, select: END_SELECT } },
        });
        if (siblings.some((sibling) => sameSpan(stops, fresh, sibling.stops))) {
          throw subRouteConflict();
        }
        if (input.status === RouteStatus.ACTIVE && !(subRouteId && (await hasActiveFare(tx, operatorId, subRouteId)))) {
          throw subRouteNotReady();
        }
        const totals = spanTotals(stops, fresh);
        const data = {
          name,
          nameSource: input.nameSource,
          status: input.status,
          note: input.note,
          totalDistanceMeters: totals.distanceMeters,
          totalDurationSeconds: totals.durationSeconds,
          metricsSource: parent.metricsSource,
        };
        let id = subRouteId;
        if (id) {
          await tx.route.updateMany({ where: { id, operatorId }, data });
          await tx.routeStop.deleteMany({ where: { routeId: id, operatorId } });
        } else {
          id = (await tx.route.create({ data: { operatorId, parentRouteId: parentId, ...data }, select: { id: true } })).id;
        }
        await tx.routeStop.createMany({ data: sliceStopRows(operatorId, id, stops, fresh) });
        return findDetail(tx, operatorId, id);
      }),
    );
    return this.respond(db, operatorId, row!);
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
      parentRouteId: true,
      createdAt: true,
      updatedAt: true,
      parent: { select: { name: true } },
      // Tuyến con (3.2): hai đầu đã chép + bảng giá để hiện ở mục Tuyến con của tuyến chính.
      subRoutes: {
        orderBy: { name: "asc" },
        select: {
          id: true,
          name: true,
          nameSource: true,
          status: true,
          totalDistanceMeters: true,
          totalDurationSeconds: true,
          stops: {
            where: { role: { in: [RouteStopRole.ORIGIN, RouteStopRole.DESTINATION] } },
            select: { ...END_SELECT, catalogStopPoint: { select: { name: true } }, stopPoint: { select: { name: true } } },
          },
          fare: { select: { id: true, status: true, rules: { select: { price: true } } } },
        },
      },
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

type DetailRow = NonNullable<Awaited<ReturnType<typeof findDetail>>>;
type EndRow = PointRef & { role: RouteStopRole };


function toResponse(row: DetailRow, suggestedName: string | null, needsReview: boolean): RouteResponse {
  const { parent, subRoutes, ...route } = row;
  return {
    ...route,
    suggestedName,
    parentRouteName: parent?.name ?? null,
    needsReview,
    createdAt: row.createdAt.toISOString(),
    updatedAt: row.updatedAt.toISOString(),
    subRoutes: subRoutes.map(({ stops, fare, ...child }) => ({
      ...child,
      from: endName(stops.find((stop) => stop.role === RouteStopRole.ORIGIN)),
      to: endName(stops.find((stop) => stop.role === RouteStopRole.DESTINATION)),
      needsReview: !spanOf(row.stops, stops),
      fare: fare ? { id: fare.id, status: fare.status, ...priceRange(fare.rules) } : null,
    })),
    stops: row.stops.map(({ catalogStopPoint, stopPoint, measuredDurationSeconds, ...stop }) => {
      const point = catalogStopPoint ?? stopPoint!;
      return { ...stop, measuredDurationSecondsFromPrevious: measuredDurationSeconds, name: point.name, type: point.type, address: point.address };
    }),
  };
}

type ListRow = Omit<RouteListResponse["items"][number], "stopCount" | "originName" | "destinationName" | "subRoutes" | "createdAt" | "updatedAt"> & {
  createdAt: Date;
  updatedAt: Date;
  _count: { stops: number };
  stops: { role: RouteStopRole; catalogStopPoint: { name: string } | null; stopPoint: { name: string } | null }[];
};

function toListItem({ _count, stops, ...route }: ListRow) {
  const endpointName = (role: RouteStopRole) => {
    const stop = stops.find((candidate) => candidate.role === role);
    return (stop?.catalogStopPoint ?? stop?.stopPoint)?.name ?? "";
  };
  return {
    ...route,
    stopCount: _count.stops,
    originName: endpointName(RouteStopRole.ORIGIN),
    destinationName: endpointName(RouteStopRole.DESTINATION),
    createdAt: route.createdAt.toISOString(),
    updatedAt: route.updatedAt.toISOString(),
  };
}

function loadParentStops(tx: DbTransaction, operatorId: string, routeId: string): Promise<ParentStop[]> {
  return tx.routeStop.findMany({ where: { routeId, operatorId }, orderBy: { sequence: "asc" }, select: PARENT_STOP_SELECT });
}

/** Đoạn của tuyến chính mà tuyến con đang phủ (theo hai đầu đã chép); `null` = hai đầu không còn hợp lệ → cần xem lại. */
function spanOf(parentStops: readonly ParentStop[], childEnds: readonly EndRow[]): Span | null {
  const from = childEnds.find((stop) => stop.role === RouteStopRole.ORIGIN);
  const to = childEnds.find((stop) => stop.role === RouteStopRole.DESTINATION);
  return from && to ? locateSpan(parentStops, from, to) : null;
}

/** Tuyến con có đúng hai đầu của đoạn `span` không. */
function sameSpan(parentStops: readonly ParentStop[], span: Span, childEnds: readonly EndRow[]): boolean {
  const from = childEnds.find((stop) => stop.role === RouteStopRole.ORIGIN);
  const to = childEnds.find((stop) => stop.role === RouteStopRole.DESTINATION);
  return Boolean(from && to && samePoint(parentStops[span.from]!, from) && samePoint(parentStops[span.to]!, to));
}

function endName(stop: (PointRef & { catalogStopPoint: { name: string } | null; stopPoint: { name: string } | null }) | undefined) {
  return {
    catalogStopPointId: stop?.catalogStopPointId ?? null,
    stopPointId: stop?.stopPointId ?? null,
    name: (stop?.catalogStopPoint ?? stop?.stopPoint)?.name ?? "",
  };
}

function endOf(stop: DetailRow["stops"][number]) {
  return { catalogStopPointId: stop.catalogStopPointId, stopPointId: stop.stopPointId, name: (stop.catalogStopPoint ?? stop.stopPoint)!.name };
}

/** Điểm của đoạn để ghép tên tuyến con (phường + tên + quyền đón / trả). */
function namingStops(stops: DetailRow["stops"], span: Span) {
  return stops.slice(span.from, span.to + 1).map((stop) => {
    const point = stop.catalogStopPoint ?? stop.stopPoint!;
    return { wardId: point.wardId, name: point.name, allowPickup: stop.allowPickup, allowDropoff: stop.allowDropoff };
  });
}

/** Giá thấp / cao nhất của bảng giá (so bằng `bigint`, không qua số thực). */
function priceRange(rules: { price: bigint }[]) {
  let min: bigint | null = null;
  let max: bigint | null = null;
  for (const { price } of rules) {
    min = min === null || price < min ? price : min;
    max = max === null || price > max ? price : max;
  }
  return { minPrice: min === null ? null : vndToJson(min), maxPrice: max === null ? null : vndToJson(max) };
}

/** Tuyến con có bảng giá đang áp dụng với ít nhất một giá — điều kiện để bật (3.2). */
async function hasActiveFare(tx: DbTransaction, operatorId: string, routeId: string): Promise<boolean> {
  const fare = await tx.fare.findFirst({ where: { routeId, operatorId, status: FareStatus.ACTIVE, rules: { some: {} } }, select: { id: true } });
  return fare !== null;
}

/** Biến thể tên đầu tiên chưa có ở tuyến khác của nhà xe (bỏ qua `exceptRouteId`); hết biến thể → 409. */
async function pickFreeName(tx: DbTransaction, operatorId: string, base: string, firstStopName: string, exceptRouteId?: string): Promise<string> {
  const candidates = nameCandidates(base, firstStopName);
  const taken = await tx.route.findMany({
    where: { operatorId, name: { in: candidates }, ...(exceptRouteId ? { id: { not: exceptRouteId } } : {}) },
    select: { name: true },
  });
  const free = candidates.find((name) => !taken.some((route) => route.name === name));
  if (!free) {
    throw routeNameConflict();
  }
  return free;
}

/**
 * Sau khi thay điểm của tuyến chính (3.2): tuyến con còn đủ hai đầu hợp lệ thì chép lại đoạn (số liệu, tên tự động theo đoạn
 * mới); mất điểm đầu / cuối hoặc sai quyền đón / trả thì tự về Nháp, giữ bản chép cũ để nhà xe xem lại và chọn lại hai đầu.
 */
async function syncSubRoutes(
  tx: DbTransaction,
  operatorId: string,
  parentId: string,
  rows: ParentStop[],
  stops: ResolvedStop[],
  localities: Map<string, string>,
  metricsSource: RoutingMetricsSource,
): Promise<void> {
  const children = await tx.route.findMany({
    where: { parentRouteId: parentId, operatorId },
    orderBy: { id: "asc" },
    select: { id: true, nameSource: true, stops: { where: { role: { in: [RouteStopRole.ORIGIN, RouteStopRole.DESTINATION] } }, select: END_SELECT } },
  });
  for (const child of children) {
    const span = spanOf(rows, child.stops);
    if (!span) {
      await tx.route.updateMany({ where: { id: child.id, operatorId }, data: { status: RouteStatus.DRAFT } });
      continue;
    }
    const totals = spanTotals(rows, span);
    let name: string | undefined;
    if (child.nameSource === RouteNameSource.AUTO) {
      const slice = stops.slice(span.from, span.to + 1);
      const base = composeRouteName(slice.map((stop) => ({ ...stop, locality: localities.get(stop.wardId) ?? stop.name })));
      name = await pickFreeName(tx, operatorId, base, slice[0]!.name, child.id);
    }
    await tx.route.updateMany({
      where: { id: child.id, operatorId },
      data: { totalDistanceMeters: totals.distanceMeters, totalDurationSeconds: totals.durationSeconds, metricsSource, ...(name ? { name } : {}) },
    });
    await tx.routeStop.deleteMany({ where: { routeId: child.id, operatorId } });
    await tx.routeStop.createMany({ data: sliceStopRows(operatorId, child.id, rows, span) });
  }
}
