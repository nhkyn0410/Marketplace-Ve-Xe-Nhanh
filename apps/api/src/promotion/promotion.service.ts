import { Inject, Injectable } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import type { DbScope } from "../database/db-scope";
import { withTripOperator } from "../database/marketplace-scope";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import { DiscountType, PromotionScope, PromotionStatus, RedemptionStatus } from "../database/prisma.types";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { requireTenant } from "../iam/role/require-tenant";
import { platformDb } from "../support/support.service";
import type {
  Permission,
  PermissionInput,
  PermissionPage,
  Promotion,
  PromotionCheck,
  PromotionCheckInput,
  PromotionInput,
  PromotionPage,
  PromotionStats,
  PromotionStatusInput,
  PROMOTION_DISPLAY,
} from "./dto/promotion.dto";
import { evaluatePromotion } from "./promotion-apply";
import { evaluateVoucher } from "./voucher-apply";
import { promotionCodeTaken, promotionGuardrail, promotionInvalid, promotionNotFound, promotionStateInvalid, promotionUnavailable } from "./promotion.errors";

const AUDIT_TIMEOUT_MS = 2_000;
const DAY_MS = 86_400_000;
const STATS_DAYS = 30;

type Display = (typeof PROMOTION_DISPLAY)[number];
type Actor = Pick<VerifiedAccessToken, "sub" | "role">;
type View = { kind: "admin" } | { kind: "operator"; operatorId: string };
type PromotionWhere = NonNullable<NonNullable<Parameters<DbTransaction["promotion"]["findMany"]>[0]>["where"]>;

const SELECT = {
  id: true,
  code: true,
  name: true,
  scope: true,
  operatorId: true,
  discountType: true,
  discountValue: true,
  maxDiscount: true,
  minOrder: true,
  routeId: true,
  routeIds: true,
  tripId: true,
  startsAt: true,
  endsAt: true,
  usageLimit: true,
  usedCount: true,
  status: true,
  createdAt: true,
  operator: { select: { displayName: true } },
  _count: { select: { participations: true, redemptions: true } },
} as const;
type Row = Awaited<ReturnType<typeof findRows>>[number];

function findRows(tx: DbTransaction, where: PromotionWhere) {
  return tx.promotion.findMany({ where, select: SELECT });
}

/** Điều kiện SQL của trạng thái hiển thị tại `now`. */
function displayWhere(display: Display, now: Date): PromotionWhere {
  switch (display) {
    case "DRAFT":
      return { status: PromotionStatus.DRAFT };
    case "PAUSED":
      return { status: PromotionStatus.PAUSED, endsAt: { gt: now } };
    case "SCHEDULED":
      return { status: PromotionStatus.ACTIVE, startsAt: { gt: now } };
    case "RUNNING":
      return { status: PromotionStatus.ACTIVE, startsAt: { lte: now }, endsAt: { gt: now } };
    case "ENDED":
      return { OR: [{ status: PromotionStatus.ENDED }, { status: { in: [PromotionStatus.ACTIVE, PromotionStatus.PAUSED] }, endsAt: { lte: now } }] };
  }
}

export function displayOf(row: { status: PromotionStatus; startsAt: Date; endsAt: Date }, now: Date): Display {
  if (row.status === PromotionStatus.DRAFT) {
    return "DRAFT";
  }
  if (row.status === PromotionStatus.ENDED || row.endsAt <= now) {
    return "ENDED";
  }
  if (row.status === PromotionStatus.PAUSED) {
    return "PAUSED";
  }
  return row.startsAt > now ? "SCHEDULED" : "RUNNING";
}

/**
 * Khuyến mãi (TASK-PROM-001, FR-PROM-01..07, BR-46/47): Admin quản lý khuyến mãi cấp nền tảng + quyền / giới hạn cho nhà xe tự tạo,
 * xem và tạm dừng / kết thúc khuyến mãi của nhà xe; nhà xe tạo khuyến mãi trong giới hạn được cấp, tham gia khuyến mãi nền tảng (Khanh
 * 18/10/2026: nhà xe chịu phần giảm). Mã đã có đơn dùng thì không sửa điều kiện (BR-47). Mọi thao tác ghi audit trong transaction.
 */
@Injectable()
export class PromotionService {
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  // ------------------------------------------------------------------ Danh sách / chi tiết

  /** Các tuyến đang hoạt động để Admin chọn phạm vi chiến dịch giữa nhiều nhà xe. */
  async routeOptions(authz: Authorization) {
    return this.prisma.withScope(platformDb(authz), async (tx) => ({ items: (await tx.route.findMany({ where: { status: "ACTIVE", parentRouteId: null, operator: { status: "ACTIVE" } }, orderBy: [{ operatorId: "asc" }, { name: "asc" }], select: { id: true, name: true, operator: { select: { displayName: true } } } })).map((route) => ({ routeId: route.id, routeName: route.name, operatorName: route.operator.displayName })) }));
  }

  /** Admin: `scope` PLATFORM = khuyến mãi nền tảng, OPERATOR = khuyến mãi của các nhà xe. */
  async adminList(authz: Authorization, scope: PromotionScope, query: ListQuery, now: Date = new Date()): Promise<PromotionPage> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const base: PromotionWhere = { scope, ...(query.operatorId && scope === PromotionScope.OPERATOR ? { operatorId: query.operatorId } : {}) };
      return page(tx, base, query, { kind: "admin" }, now);
    });
  }

  /** Nhà xe: `scope` OPERATOR = khuyến mãi của mình, PLATFORM = khuyến mãi nền tảng để tham gia. */
  async operatorList(authz: Authorization, scope: PromotionScope, query: ListQuery, now: Date = new Date()): Promise<PromotionPage> {
    const { db, operatorId } = requireTenant(authz);
    return this.prisma.withScope(db, async (tx) => {
      const base: PromotionWhere = scope === PromotionScope.OPERATOR ? { scope, operatorId } : { scope, status: { not: PromotionStatus.DRAFT } };
      return page(tx, base, query, { kind: "operator", operatorId }, now);
    });
  }

  async get(authz: Authorization, promotionId: string, now: Date = new Date()): Promise<Promotion> {
    const view = viewOf(authz);
    const promotion = await this.prisma.withScope(scopeOf(authz), async (tx) => {
      const row = (await findRows(tx, { id: promotionId, ...(view.kind === "operator" ? { OR: [{ operatorId: view.operatorId }, { operatorId: null, status: { not: PromotionStatus.DRAFT } }] } : {}) }))[0];
      return row ? (await present(tx, [row], view, now))[0]! : null;
    });
    if (!promotion) {
      throw promotionNotFound();
    }
    return promotion;
  }

  // ------------------------------------------------------------------ Tạo / sửa / trạng thái

  async create(authz: Authorization, actor: Actor, input: PromotionInput): Promise<Promotion> {
    const view = viewOf(authz);
    return this.write(scopeOf(authz), async (tx, deadline) => {
      if (view.kind === "admin" && (input.routeId || input.tripId)) {
        throw promotionGuardrail("Khuyến mãi nền tảng áp dụng toàn hệ thống — không chọn tuyến / chuyến.");
      }
      if (view.kind === "operator") {
        if (input.routeIds.length > 0) throw promotionGuardrail("Danh sách tuyến này dành cho khuyến mãi nền tảng.");
        await guardrail(tx, view.operatorId, input);
      }
      if (view.kind === "admin") await validatePlatformRoutes(tx, input.routeIds);
      if (await tx.promotion.findUnique({ where: { code: input.code }, select: { id: true } })) {
        throw promotionCodeTaken();
      }
      const created = await tx.promotion
        .create({
          data: {
            ...fields(input),
            scope: view.kind === "admin" ? PromotionScope.PLATFORM : PromotionScope.OPERATOR,
            operatorId: view.kind === "admin" ? null : view.operatorId,
            createdBy: `${view.kind === "admin" ? "platform" : "operator"}:${actor.sub}`,
          },
          select: { id: true },
        })
        .catch((error: unknown) => {
          // Đồng thời tạo cùng mã → unique `code` (mã có thể thuộc nhà xe khác mà tenant không thấy).
          throw (error as { code?: string } | null)?.code === "P2002" ? promotionCodeTaken() : error;
        });
      await this.record(actor, "promotion.create", created.id, view, null, { ...input }, deadline);
      return (await present(tx, await findRows(tx, { id: created.id }), view, new Date()))[0]!;
    });
  }

  async update(authz: Authorization, actor: Actor, promotionId: string, input: PromotionInput): Promise<Promotion> {
    const view = viewOf(authz);
    return this.write(scopeOf(authz), async (tx, deadline) => {
      const current = await lockOwn(tx, promotionId, view);
      if (current.status === PromotionStatus.ENDED || current.redemptions > 0) {
        // BR-47: mã đã dùng trong đơn thì không sửa điều kiện — kết thúc và tạo chương trình mới.
        throw promotionStateInvalid("Khuyến mãi đã có đơn dùng mã hoặc đã kết thúc — không sửa điều kiện; hãy kết thúc và tạo chương trình mới.");
      }
      if (view.kind === "admin" && (input.routeId || input.tripId)) {
        throw promotionGuardrail("Khuyến mãi nền tảng áp dụng toàn hệ thống — không chọn tuyến / chuyến.");
      }
      if (view.kind === "operator") {
        if (input.routeIds.length > 0) throw promotionGuardrail("Danh sách tuyến này dành cho khuyến mãi nền tảng.");
        await guardrail(tx, view.operatorId, input);
      }
      if (view.kind === "admin") await validatePlatformRoutes(tx, input.routeIds);
      if (input.code !== current.code && (await tx.promotion.findUnique({ where: { code: input.code }, select: { id: true } }))) {
        throw promotionCodeTaken();
      }
      await tx.promotion.update({ where: { id: promotionId }, data: fields(input) }).catch((error: unknown) => {
        throw (error as { code?: string } | null)?.code === "P2002" ? promotionCodeTaken() : error;
      });
      await this.record(actor, "promotion.update", promotionId, view, { code: current.code }, { ...input }, deadline);
      return (await present(tx, await findRows(tx, { id: promotionId }), view, new Date()))[0]!;
    });
  }

  /**
   * Kích hoạt (nháp / tạm dừng → chạy), tạm dừng, kết thúc. Admin đổi được trạng thái khuyến mãi của nhà xe (tạm dừng / kết thúc khi
   * vi phạm); nhà xe chỉ khuyến mãi của mình.
   */
  async setStatus(authz: Authorization, actor: Actor, promotionId: string, input: PromotionStatusInput, now: Date = new Date()): Promise<Promotion> {
    const view = viewOf(authz);
    return this.write(scopeOf(authz), async (tx, deadline) => {
      const current = await lockOwn(tx, promotionId, view);
      const allowed =
        input.status === PromotionStatus.ACTIVE
          ? current.status === PromotionStatus.DRAFT || current.status === PromotionStatus.PAUSED
          : input.status === PromotionStatus.PAUSED
            ? current.status === PromotionStatus.ACTIVE
            : current.status !== PromotionStatus.ENDED;
      if (!allowed) {
        throw promotionStateInvalid("Không đổi được sang trạng thái này.");
      }
      if (input.status === PromotionStatus.ACTIVE && current.endsAt <= now) {
        throw promotionStateInvalid("Khuyến mãi đã hết hiệu lực — sửa thời gian hoặc tạo chương trình mới.");
      }
      if (view.kind === "admin" && current.scope === PromotionScope.OPERATOR && input.status === PromotionStatus.ACTIVE) {
        throw promotionStateInvalid("Chỉ nhà xe kích hoạt khuyến mãi của nhà xe.");
      }
      if (input.status === PromotionStatus.ACTIVE && current.scope === PromotionScope.OPERATOR) {
        // Giới hạn có thể đã đổi từ lúc tạo nháp — kiểm lại khi kích hoạt (BR-46).
        await guardrail(tx, current.operatorId!, {
          discountType: current.discountType,
          discountValue: Number(current.discountValue),
          maxDiscount: current.maxDiscount === null ? null : Number(current.maxDiscount),
          routeId: current.routeId,
          tripId: current.tripId,
          startsAt: current.startsAt.toISOString(),
          endsAt: current.endsAt.toISOString(),
        });
      }
      await tx.promotion.update({ where: { id: promotionId }, data: { status: input.status } });
      await this.record(actor, "promotion.status", promotionId, view, { status: current.status }, { status: input.status }, deadline);
      return (await present(tx, await findRows(tx, { id: promotionId }), view, now))[0]!;
    });
  }

  /** Nhà xe tham gia / rời một khuyến mãi nền tảng (Khanh 18/10/2026: nhà xe chịu phần giảm cho chuyến của mình). */
  async setParticipation(authz: Authorization, actor: Actor, promotionId: string, join: boolean, now: Date = new Date()): Promise<Promotion> {
    const { db, operatorId } = requireTenant(authz);
    const view: View = { kind: "operator", operatorId };
    return this.write(db, async (tx, deadline) => {
      const promotion = await tx.promotion.findFirst({ where: { id: promotionId, scope: PromotionScope.PLATFORM, status: { not: PromotionStatus.DRAFT } }, select: { id: true, status: true, endsAt: true } });
      if (!promotion) {
        throw promotionNotFound();
      }
      const key = { promotionId_operatorId: { promotionId, operatorId } };
      const existing = await tx.promotionParticipation.findUnique({ where: key, select: { operatorId: true } });
      if (join && !existing) {
        if (promotion.status === PromotionStatus.ENDED || promotion.endsAt <= now) {
          throw promotionStateInvalid("Khuyến mãi đã kết thúc.");
        }
        await tx.promotionParticipation.create({ data: { promotionId, operatorId, joinedBy: actor.sub } });
      } else if (!join && existing) {
        await tx.promotionParticipation.delete({ where: key });
      }
      await this.record(actor, join ? "promotion.join" : "promotion.leave", promotionId, view, { joined: Boolean(existing) }, { joined: join }, deadline);
      return (await present(tx, await findRows(tx, { id: promotionId }), view, now))[0]!;
    });
  }

  // ------------------------------------------------------------------ Quyền của nhà xe

  async listPermissions(authz: Authorization, query: { q?: string; enabled?: "yes" | "no"; cursor?: string; limit: number }): Promise<PermissionPage> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const where = {
        ...(query.q ? { OR: [{ displayName: { contains: query.q, mode: "insensitive" as const } }, { operatorSlug: { contains: query.q.toLowerCase() } }] } : {}),
        ...(query.enabled === "yes" ? { promotionPermission: { is: { enabled: true } } } : query.enabled === "no" ? { OR: [{ promotionPermission: { is: null } }, { promotionPermission: { is: { enabled: false } } }] } : {}),
      };
      const rows = await tx.operatorProfile.findMany({
        where,
        orderBy: [{ displayName: "asc" }, { id: "asc" }],
        take: query.limit + 1,
        ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
        select: { id: true, displayName: true, operatorSlug: true, promotionPermission: true },
      });
      const more = rows.length > query.limit;
      const items = rows.slice(0, query.limit);
      const routeNames = await routeNameMap(tx, items.flatMap((row) => row.promotionPermission?.routeIds ?? []));
      return {
        items: items.map((row) => toPermission(row, routeNames)),
        nextCursor: more ? items.at(-1)!.id : null,
        total: await tx.operatorProfile.count({ where }),
      };
    });
  }

  async operatorPermission(authz: Authorization): Promise<Permission> {
    const { db, operatorId } = requireTenant(authz);
    return this.prisma.withScope(db, async (tx) => {
      const row = await tx.operatorProfile.findUniqueOrThrow({ where: { id: operatorId }, select: { id: true, displayName: true, operatorSlug: true, promotionPermission: true } });
      return toPermission(row, await routeNameMap(tx, row.promotionPermission?.routeIds ?? []));
    });
  }

  /** Admin cấp / đổi giới hạn (chỉ áp cho khuyến mãi tạo / kích hoạt sau thời điểm lưu — chương trình đang chạy giữ nguyên). */
  async upsertPermission(authz: Authorization, actor: Actor, operatorId: string, input: PermissionInput): Promise<Permission> {
    return this.write(platformDb(authz), async (tx, deadline) => {
      const operator = await tx.operatorProfile.findUnique({ where: { id: operatorId }, select: { id: true, displayName: true, operatorSlug: true, promotionPermission: true } });
      if (!operator) {
        throw promotionNotFound();
      }
      if (input.routeIds.length > 0 && (await tx.route.count({ where: { id: { in: input.routeIds }, operatorId, parentRouteId: null } })) !== new Set(input.routeIds).size) {
        throw promotionGuardrail("Tuyến được chọn phải thuộc nhà xe này.");
      }
      const data = {
        enabled: input.enabled,
        maxPercent: input.maxPercent,
        maxAmount: input.maxAmount === null ? null : BigInt(input.maxAmount),
        routeIds: [...new Set(input.routeIds)],
        maxDurationDays: input.maxDurationDays,
        monthlyBudget: input.monthlyBudget === null ? null : BigInt(input.monthlyBudget),
        updatedBy: actor.sub,
      };
      await tx.promotionPermission.upsert({ where: { operatorId }, create: { operatorId, ...data }, update: data });
      await this.audit.recordAuditEvent(
        {
          actorId: actor.sub,
          actorRole: actor.role,
          action: "promotion.permission",
          targetType: "operator",
          targetId: operatorId,
          operatorId,
          before: operator.promotionPermission ? { enabled: operator.promotionPermission.enabled } : null,
          after: { ...input },
        },
        { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
      );
      const row = await tx.operatorProfile.findUniqueOrThrow({ where: { id: operatorId }, select: { id: true, displayName: true, operatorSlug: true, promotionPermission: true } });
      return toPermission(row, await routeNameMap(tx, row.promotionPermission?.routeIds ?? []));
    });
  }

  // ------------------------------------------------------------------ Kiểm mã (khách)

  /** Báo trước số tiền giảm của một mã cho chuyến (FR-MKT-10) — không giữ lượt dùng; lượt giữ khi tạo đơn. */
  /** `userId`: hành khách đang đăng nhập (bắt buộc khi báo giá voucher trong ví, khách vãng lai chỉ dùng được `code`). */
  async check(input: PromotionCheckInput, userId: string | null = null, now: Date = new Date()): Promise<PromotionCheck> {
    const result = await withTripOperator(this.prisma, input.tripId, async (tx, operatorId) => {
      const trip = await tx.trip.findFirst({ where: { id: input.tripId, operatorId }, select: { routeId: true } });
      if (!trip) {
        return null;
      }
      const context = { operatorId, routeId: trip.routeId, tripId: input.tripId, subtotal: BigInt(input.subtotal), now };
      return input.userVoucherId
        ? evaluateVoucher(tx, userId, input.userVoucherId, context, { claim: false })
        : evaluatePromotion(tx, { ...context, code: input.code! });
    });
    if (!result) {
      throw promotionInvalid("Không tìm thấy chuyến.");
    }
    return { code: result.code, name: result.name, discount: Number(result.discount), total: input.subtotal - Number(result.discount) };
  }

  // ------------------------------------------------------------------ Nội bộ

  private async write<T>(db: DbScope, work: (tx: DbTransaction, deadline: number) => Promise<T>): Promise<T> {
    try {
      return await this.prisma.withScope(db, (tx) => work(tx, transactionDeadline(Date.now())));
    } catch (error) {
      if (error instanceof AuditWriteError || (error as { code?: unknown } | null)?.code === "P2028") {
        throw promotionUnavailable();
      }
      throw error;
    }
  }

  private record(actor: Actor, action: string, promotionId: string, view: View, before: Record<string, unknown> | null, after: Record<string, unknown>, deadline: number): Promise<void> {
    return this.audit.recordAuditEvent(
      { actorId: actor.sub, actorRole: actor.role, action, targetType: "promotion", targetId: promotionId, ...(view.kind === "operator" ? { operatorId: view.operatorId } : {}), before, after },
      { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
    );
  }
}

type ListQuery = { display?: Display; q?: string; routeId?: string; operatorId?: string; cursor?: string; limit: number };

function viewOf(authz: Authorization): View {
  return authz.db?.kind === "platform" ? { kind: "admin" } : { kind: "operator", operatorId: requireTenant(authz).operatorId };
}

function scopeOf(authz: Authorization): DbScope {
  return authz.db?.kind === "platform" ? platformDb(authz) : requireTenant(authz).db;
}

function fields(input: PromotionInput) {
  return {
    code: input.code,
    name: input.name,
    discountType: input.discountType,
    discountValue: BigInt(input.discountValue),
    maxDiscount: input.maxDiscount === null ? null : BigInt(input.maxDiscount),
    minOrder: BigInt(input.minOrder),
    routeId: input.routeId,
    routeIds: [...new Set(input.routeIds)],
    tripId: input.tripId,
    startsAt: new Date(input.startsAt),
    endsAt: new Date(input.endsAt),
    usageLimit: input.usageLimit,
  };
}

/** Khoá khuyến mãi bên gọi được sửa: Admin mọi khuyến mãi; nhà xe chỉ của mình. */
async function lockOwn(tx: DbTransaction, promotionId: string, view: View) {
  const [row] = await tx.$queryRaw<{ id: string }[]>`SELECT id FROM promotions WHERE id = ${promotionId} FOR UPDATE`;
  const promotion = row
    ? await tx.promotion.findFirst({
        where: { id: promotionId, ...(view.kind === "operator" ? { operatorId: view.operatorId } : {}) },
        select: {
          code: true,
          scope: true,
          operatorId: true,
          status: true,
          discountType: true,
          discountValue: true,
          maxDiscount: true,
          routeId: true,
          tripId: true,
          startsAt: true,
          endsAt: true,
          _count: { select: { redemptions: true } },
        },
      })
    : null;
  if (!promotion) {
    throw promotionNotFound();
  }
  return { ...promotion, redemptions: promotion._count.redemptions };
}

/** BR-46: nhà xe chỉ tạo / kích hoạt khuyến mãi khi được cấp quyền và trong giới hạn; tuyến / chuyến phải của chính nhà xe. */
async function guardrail(
  tx: DbTransaction,
  operatorId: string,
  input: Pick<PromotionInput, "discountType" | "discountValue" | "maxDiscount" | "routeId" | "tripId" | "startsAt" | "endsAt">,
): Promise<void> {
  const permission = await tx.promotionPermission.findUnique({ where: { operatorId } });
  if (!permission?.enabled) {
    throw promotionGuardrail("Nhà xe chưa được Vé Xe Nhanh cấp quyền tạo khuyến mãi.");
  }
  const maxAmount = permission.maxAmount === null ? null : Number(permission.maxAmount);
  if (input.discountType === DiscountType.PERCENT) {
    if (permission.maxPercent === null) {
      throw promotionGuardrail("Giới hạn được cấp chỉ cho phép giảm số tiền cố định.");
    }
    if (input.discountValue > permission.maxPercent) {
      throw promotionGuardrail(`Mức giảm vượt giới hạn ${permission.maxPercent}%.`);
    }
    if (maxAmount !== null && (input.maxDiscount === null || input.maxDiscount > maxAmount)) {
      throw promotionGuardrail(`Giảm tối đa mỗi đơn phải có và không vượt ${new Intl.NumberFormat("vi-VN").format(maxAmount)} ₫.`);
    }
  } else if (maxAmount === null || input.discountValue > maxAmount) {
    throw promotionGuardrail(maxAmount === null ? "Giới hạn được cấp chỉ cho phép giảm theo phần trăm." : `Mức giảm vượt giới hạn ${new Intl.NumberFormat("vi-VN").format(maxAmount)} ₫.`);
  }
  if (permission.routeIds.length > 0 && (!input.routeId || !permission.routeIds.includes(input.routeId))) {
    throw promotionGuardrail("Chỉ được tạo khuyến mãi cho tuyến Vé Xe Nhanh đã chọn.");
  }
  if (input.routeId && !(await tx.route.findFirst({ where: { id: input.routeId, operatorId }, select: { id: true } }))) {
    throw promotionGuardrail("Tuyến không thuộc nhà xe.");
  }
  if (input.tripId) {
    const trip = await tx.trip.findFirst({ where: { id: input.tripId, operatorId }, select: { routeId: true } });
    if (!trip || (input.routeId && trip.routeId !== input.routeId)) {
      throw promotionGuardrail("Chuyến không thuộc nhà xe / tuyến đã chọn.");
    }
  }
  if (Date.parse(input.endsAt) - Date.parse(input.startsAt) > permission.maxDurationDays * DAY_MS) {
    throw promotionGuardrail(`Thời gian hiệu lực tối đa ${permission.maxDurationDays} ngày.`);
  }
}

async function routeNameMap(tx: DbTransaction, ids: (string | null)[]): Promise<Map<string, string>> {
  const unique = [...new Set(ids.filter((id): id is string => Boolean(id)))];
  if (unique.length === 0) {
    return new Map();
  }
  const rows = await tx.route.findMany({ where: { id: { in: unique } }, select: { id: true, name: true } });
  return new Map(rows.map((row) => [row.id, row.name]));
}

async function validatePlatformRoutes(tx: DbTransaction, routeIds: string[]): Promise<void> {
  const unique = [...new Set(routeIds)];
  if (unique.length > 0 && await tx.route.count({ where: { id: { in: unique }, status: "ACTIVE", parentRouteId: null, operator: { status: "ACTIVE" } } }) !== unique.length) {
    throw promotionGuardrail("Danh sách có tuyến không còn hoạt động.");
  }
}

function toPermission(
  row: { id: string; displayName: string; operatorSlug: string; promotionPermission: { enabled: boolean; maxPercent: number | null; maxAmount: bigint | null; routeIds: string[]; maxDurationDays: number; monthlyBudget: bigint | null } | null },
  routeNames: Map<string, string>,
): Permission {
  const permission = row.promotionPermission;
  return {
    operatorId: row.id,
    operatorName: row.displayName,
    operatorSlug: row.operatorSlug,
    enabled: permission?.enabled ?? false,
    maxPercent: permission?.maxPercent ?? null,
    maxAmount: permission?.maxAmount === null || permission?.maxAmount === undefined ? null : Number(permission.maxAmount),
    routeIds: permission?.routeIds ?? [],
    routeNames: (permission?.routeIds ?? []).map((id) => routeNames.get(id) ?? "Tuyến không còn"),
    maxDurationDays: permission?.maxDurationDays ?? 30,
    monthlyBudget: permission?.monthlyBudget === null || permission?.monthlyBudget === undefined ? null : Number(permission.monthlyBudget),
  };
}

async function present(tx: DbTransaction, rows: Row[], view: View, now: Date): Promise<Promotion[]> {
  const routeNames = await routeNameMap(tx, rows.flatMap((row) => [row.routeId, ...row.routeIds]));
  const joined =
    view.kind === "operator"
      ? new Set(
          (await tx.promotionParticipation.findMany({ where: { operatorId: view.operatorId, promotionId: { in: rows.map((row) => row.id) } }, select: { promotionId: true } })).map(
            (row) => row.promotionId,
          ),
        )
      : null;
  return rows.map((row) => ({
    promotionId: row.id,
    code: row.code,
    name: row.name,
    scope: row.scope,
    operatorId: row.operatorId,
    operatorName: row.operator?.displayName ?? null,
    discountType: row.discountType,
    discountValue: Number(row.discountValue),
    maxDiscount: row.maxDiscount === null ? null : Number(row.maxDiscount),
    minOrder: Number(row.minOrder),
    routeId: row.routeId,
    routeIds: row.routeIds,
    routeNames: row.routeIds.map((id) => routeNames.get(id) ?? "Tuyến khác nhà xe"),
    routeName: row.routeId ? (routeNames.get(row.routeId) ?? null) : null,
    tripId: row.tripId,
    startsAt: row.startsAt.toISOString(),
    endsAt: row.endsAt.toISOString(),
    usageLimit: row.usageLimit,
    usedCount: row.usedCount,
    status: row.status,
    display: displayOf(row, now),
    editable: row.status !== PromotionStatus.ENDED && row._count.redemptions === 0 && (view.kind === "admin" ? row.scope === PromotionScope.PLATFORM : row.scope === PromotionScope.OPERATOR),
    joined: joined && row.scope === PromotionScope.PLATFORM ? joined.has(row.id) : null,
    participants: view.kind === "admin" && row.scope === PromotionScope.PLATFORM ? row._count.participations : null,
    createdAt: row.createdAt.toISOString(),
  }));
}

async function page(tx: DbTransaction, base: PromotionWhere, query: ListQuery, view: View, now: Date): Promise<PromotionPage> {
  const q = query.q?.trim();
  const where: PromotionWhere = {
    AND: [
      base,
      ...(query.display ? [displayWhere(query.display, now)] : []),
      ...(q ? [{ OR: [{ code: { contains: q.toUpperCase() } }, { name: { contains: q, mode: "insensitive" as const } }] }] : []),
      ...(query.routeId ? [{ OR: [{ routeId: query.routeId }, { routeIds: { has: query.routeId } }] }] : []),
    ],
  };
  const rows = await tx.promotion.findMany({
    where,
    orderBy: [{ createdAt: "desc" }, { id: "desc" }],
    take: query.limit + 1,
    ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
    select: SELECT,
  });
  const more = rows.length > query.limit;
  const items = rows.slice(0, query.limit);
  return {
    items: await present(tx, items, view, now),
    nextCursor: more ? items.at(-1)!.id : null,
    total: await tx.promotion.count({ where }),
    stats: await stats(tx, base, view, now),
  };
}

/** Thẻ số liệu (Figma ADM-11a / nhà xe 01): đang chạy, lên lịch, nháp, tạm dừng; 30 ngày: lượt áp dụng, tổng giảm, doanh thu có mã. */
async function stats(tx: DbTransaction, base: PromotionWhere, view: View, now: Date): Promise<PromotionStats> {
  const count = (display: Display) => tx.promotion.count({ where: { AND: [base, displayWhere(display, now)] } });
  const running = await count("RUNNING");
  const scheduled = await count("SCHEDULED");
  const drafts = await count("DRAFT");
  const paused = await count("PAUSED");
  const since = new Date(now.getTime() - STATS_DAYS * DAY_MS);
  // Nhà xe xem khuyến mãi nền tảng: chỉ lượt áp dụng trên đơn của chính mình (RLS); Admin: toàn hệ thống.
  const redemptionWhere = {
    status: RedemptionStatus.USED,
    createdAt: { gte: since },
    promotion: base,
    ...(view.kind === "operator" ? { operatorId: view.operatorId } : {}),
  };
  const used = await tx.promotionRedemption.aggregate({ where: redemptionWhere, _count: { _all: true }, _sum: { discount: true } });
  const revenue = await tx.booking.aggregate({ where: { promotionRedemptions: { some: redemptionWhere } }, _sum: { total: true } });
  return {
    running,
    scheduled,
    drafts,
    paused,
    redemptions: used._count._all,
    discount: Number(used._sum.discount ?? 0n),
    revenue: Number(revenue._sum.total ?? 0n),
  };
}
