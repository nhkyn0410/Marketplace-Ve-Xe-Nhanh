import { Inject, Injectable, Logger } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { searchTextContains } from "../common/search-text";
import { decodeTimeCursor, encodeTimeCursor } from "../common/time-cursor";
import type { DbScope } from "../database/db-scope";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import { CatalogStatus, StopPointProposalStatus, StopPointStatus, type StopPointType } from "../database/prisma.types";
import {
  EMAIL_NOTIFIER,
  type EmailNotifier,
  maskEmail,
  type StopPointDecisionEmailMessage,
} from "../external/notification/email-notifier";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import type {
  AdminOperatorPoint,
  AdminOperatorPointList,
  AdminProposal,
  AdminProposalList,
  OperatorPointListQuery,
  ProposalApprovalInput,
  ProposalListQuery,
  SharedStopPoint,
  SharedStopPointInput,
  SharedStopPointList,
  SharedStopPointListQuery,
} from "./dto/admin-stop-point.dto";
import {
  stopPointAuditUnavailable,
  stopPointNotFound,
  stopPointProposalNotFound,
  stopPointProposalNotPending,
  stopPointStateInvalid,
} from "./stop-point.errors";
import { assertActiveLocation } from "./stop-point.service";

type Actor = Pick<VerifiedAccessToken, "sub" | "role">;

const AUDIT_TIMEOUT_MS = 2_000;
/** Bán kính cảnh báo điểm dùng chung cùng loại ở gần đề xuất (LLD §6.13 bước 3). */
export const NEARBY_RADIUS_METERS = 200;
const MAX_NEARBY = 5;
const EARTH_RADIUS_METERS = 6_371_000;

const LOCATION_SELECT = {
  id: true,
  name: true,
  type: true,
  address: true,
  provinceId: true,
  wardId: true,
  latitude: true,
  longitude: true,
  description: true,
  createdAt: true,
  updatedAt: true,
  ward: { select: { province: { select: { name: true } } } },
} as const;

const SHARED_SELECT = {
  ...LOCATION_SELECT,
  legalBasis: true,
  status: true,
  // Mỗi route dùng một điểm tối đa một lần (unique) nên số dòng route_stops = số route đang dùng.
  _count: { select: { routeStops: true } },
} as const;

const PROPOSAL_SELECT = {
  ...LOCATION_SELECT,
  legalBasis: true,
  status: true,
  rejectionReason: true,
  catalogStopPointId: true,
  operatorId: true,
  operator: { select: { displayName: true } },
} as const;

const OPERATOR_POINT_SELECT = {
  ...LOCATION_SELECT,
  status: true,
  suspensionReason: true,
  operatorId: true,
  operator: { select: { displayName: true } },
  _count: { select: { routeStops: true } },
} as const;

/**
 * Admin quản lý điểm dừng (TASK-ADM-004, UC-24, BR-38, BR-81; LLD §6.13 bước 3 và 6): điểm dùng chung, duyệt
 * đề xuất của nhà xe, khóa / mở khóa điểm riêng. Scope DB `platform` (RLS của ba bảng cho platform ghi). Mọi thay
 * đổi ghi audit TRONG transaction: audit lỗi thì không đổi gì (503). Quyết định về điểm của nhà xe được báo qua
 * email tới chủ nhà xe SAU commit; gửi lỗi chỉ ghi log, không hoàn tác.
 */
@Injectable()
export class AdminStopPointService {
  private readonly logger = new Logger(AdminStopPointService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(EMAIL_NOTIFIER) private readonly email: EmailNotifier,
  ) {}

  // ── Điểm dùng chung ──────────────────────────────────────────────────────────────────────────────────

  /** Danh sách điểm dùng chung (mọi trạng thái), mới tạo trước, kèm số tuyến đang dùng. */
  async listShared(authz: Authorization, query: SharedStopPointListQuery): Promise<SharedStopPointList> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const where = {
        type: query.type,
        provinceId: query.provinceId,
        status: query.status,
        ...(query.q ? { searchText: { contains: await searchTextContains(tx, query.q) } } : {}),
      };
      // Tuần tự: một transaction tương tác chạy trên một kết nối.
      const rows = await tx.stopPointCatalog.findMany({
        where: { ...where, ...afterCursor(query.cursor) },
        orderBy: [{ createdAt: "desc" }, { id: "desc" }],
        take: query.limit + 1,
        select: SHARED_SELECT,
      });
      const total = await tx.stopPointCatalog.count({ where });
      return { ...page(rows, query.limit, toShared), total };
    });
  }

  async getShared(authz: Authorization, id: string): Promise<SharedStopPoint> {
    const row = await this.prisma.withScope(platformDb(authz), (tx) =>
      tx.stopPointCatalog.findUnique({ where: { id }, select: SHARED_SELECT }),
    );
    if (!row) {
      throw stopPointNotFound();
    }
    return toShared(row);
  }

  /** Thêm điểm dùng chung; bến xe / điểm dừng đón trả bắt buộc căn cứ công bố (DTO + CHECK của DB). */
  async createShared(authz: Authorization, actor: Actor, input: SharedStopPointInput): Promise<SharedStopPoint> {
    return this.inTransaction(authz, async (tx, deadline) => {
      await assertActiveLocation(tx, input);
      const row = await tx.stopPointCatalog.create({ data: sharedData(input), select: SHARED_SELECT });
      await this.recordAudit(deadline, actor, {
        action: "stop_point_catalog.create",
        targetType: "stop_point_catalog",
        targetId: row.id,
        before: null,
        after: sharedSnapshot(row),
      });
      return toShared(row);
    });
  }

  /**
   * Thay toàn bộ một điểm dùng chung, kể cả ngừng dùng (không xóa). Route đang dùng điểm giữ số liệu chặng cũ
   * tới lần sửa route kế tiếp; điểm ngừng dùng không gắn mới được (như điểm riêng). Tỉnh / phường chỉ bị kiểm
   * khi đổi.
   */
  async updateShared(
    authz: Authorization,
    actor: Actor,
    id: string,
    input: SharedStopPointInput,
  ): Promise<SharedStopPoint> {
    return this.inTransaction(authz, async (tx, deadline) => {
      const before = await tx.stopPointCatalog.findUnique({ where: { id }, select: SHARED_SELECT });
      if (!before) {
        throw stopPointNotFound();
      }
      if (before.provinceId !== input.provinceId || before.wardId !== input.wardId) {
        await assertActiveLocation(tx, input);
      }
      const row = await tx.stopPointCatalog.update({ where: { id }, data: sharedData(input), select: SHARED_SELECT });
      await this.recordAudit(deadline, actor, {
        action: "stop_point_catalog.update",
        targetType: "stop_point_catalog",
        targetId: id,
        before: sharedSnapshot(before),
        after: sharedSnapshot(row),
      });
      return toShared(row);
    });
  }

  // ── Đề xuất ──────────────────────────────────────────────────────────────────────────────────────────

  /** Đề xuất của mọi nhà xe, mới gửi trước, kèm điểm dùng chung cùng loại ở gần (cảnh báo trùng). */
  async listProposals(authz: Authorization, query: ProposalListQuery): Promise<AdminProposalList> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const where = { status: query.status, type: query.type, operatorId: query.operatorId };
      const rows = await tx.stopPointProposal.findMany({
        where: { ...where, ...afterCursor(query.cursor) },
        orderBy: [{ createdAt: "desc" }, { id: "desc" }],
        take: query.limit + 1,
        select: PROPOSAL_SELECT,
      });
      const total = await tx.stopPointProposal.count({ where });
      const listed = page(rows, query.limit, (row) => row);
      const items: AdminProposal[] = [];
      for (const row of listed.items) {
        items.push(toProposal(row, await nearbyShared(tx, row)));
      }
      return { items, nextCursor: listed.nextCursor, total };
    });
  }

  async getProposal(authz: Authorization, id: string): Promise<AdminProposal> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const row = await tx.stopPointProposal.findUnique({ where: { id }, select: PROPOSAL_SELECT });
      if (!row) {
        throw stopPointProposalNotFound();
      }
      return toProposal(row, await nearbyShared(tx, row));
    });
  }

  /**
   * Duyệt (LLD §6.13 bước 3): một transaction khóa dòng đề xuất, còn `PENDING` mới tạo điểm dùng chung theo
   * thông tin Admin đã chỉnh + đặt đề xuất `APPROVED` + `catalog_stop_point_id`, audit. Hai Admin duyệt cùng
   * lúc: người sau chờ khóa rồi thấy đã duyệt → 409, không tạo điểm thứ hai (TC-TRN-017).
   */
  async approveProposal(
    authz: Authorization,
    actor: Actor,
    id: string,
    input: ProposalApprovalInput,
  ): Promise<AdminProposal> {
    const approved = await this.inTransaction(authz, async (tx, deadline) => {
      const operatorId = await lockPendingProposal(tx, id);
      await assertActiveLocation(tx, input);
      const shared = await tx.stopPointCatalog.create({
        data: sharedData({ ...input, status: CatalogStatus.ACTIVE }),
        select: { id: true },
      });
      const row = await tx.stopPointProposal.update({
        where: { id },
        data: { status: StopPointProposalStatus.APPROVED, catalogStopPointId: shared.id },
        select: PROPOSAL_SELECT,
      });
      await this.recordAudit(deadline, actor, {
        action: "stop_point_proposal.approve",
        targetType: "stop_point_proposal",
        targetId: id,
        operatorId,
        before: { status: StopPointProposalStatus.PENDING },
        after: { status: StopPointProposalStatus.APPROVED, catalogStopPointId: shared.id, name: input.name, type: input.type },
      });
      return toProposal(row, await nearbyShared(tx, row));
    });
    await this.notifyOwners(authz, approved.operatorId, {
      operatorName: approved.operatorName,
      stopPointName: approved.name,
      decision: "PROPOSAL_APPROVED",
      sharedName: input.name,
    });
    return approved;
  }

  /** Từ chối, lý do bắt buộc → `REJECTED`; nhà xe sửa rồi gửi lại được (UC-13). */
  async rejectProposal(authz: Authorization, actor: Actor, id: string, reason: string): Promise<AdminProposal> {
    const rejected = await this.inTransaction(authz, async (tx, deadline) => {
      const operatorId = await lockPendingProposal(tx, id);
      const row = await tx.stopPointProposal.update({
        where: { id },
        data: { status: StopPointProposalStatus.REJECTED, rejectionReason: reason },
        select: PROPOSAL_SELECT,
      });
      await this.recordAudit(deadline, actor, {
        action: "stop_point_proposal.reject",
        targetType: "stop_point_proposal",
        targetId: id,
        operatorId,
        reason,
        before: { status: StopPointProposalStatus.PENDING },
        after: { status: StopPointProposalStatus.REJECTED, rejectionReason: reason },
      });
      return toProposal(row, await nearbyShared(tx, row));
    });
    await this.notifyOwners(authz, rejected.operatorId, {
      operatorName: rejected.operatorName,
      stopPointName: rejected.name,
      decision: "PROPOSAL_REJECTED",
      reason,
    });
    return rejected;
  }

  // ── Điểm riêng của nhà xe ────────────────────────────────────────────────────────────────────────────

  /** Điểm riêng của mọi nhà xe (mọi trạng thái), mới tạo trước. */
  async listOperatorPoints(authz: Authorization, query: OperatorPointListQuery): Promise<AdminOperatorPointList> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const where = {
        operatorId: query.operatorId,
        type: query.type,
        provinceId: query.provinceId,
        status: query.status,
        ...(query.q ? { searchText: { contains: await searchTextContains(tx, query.q) } } : {}),
      };
      const rows = await tx.stopPoint.findMany({
        where: { ...where, ...afterCursor(query.cursor) },
        orderBy: [{ createdAt: "desc" }, { id: "desc" }],
        take: query.limit + 1,
        select: OPERATOR_POINT_SELECT,
      });
      const total = await tx.stopPoint.count({ where });
      return { ...page(rows, query.limit, toOperatorPoint), total };
    });
  }

  /**
   * Khóa điểm riêng (BR-81): lý do bắt buộc → `SUSPENDED`. Điểm bị khóa không gắn mới vào route; chuyến có điểm
   * này không mở bán được; nhà xe không sửa / không tự mở lại (RLS). Đang bị khóa rồi → 409.
   */
  async suspend(authz: Authorization, actor: Actor, id: string, reason: string): Promise<AdminOperatorPoint> {
    return this.changeSuspension(authz, actor, id, {
      from: [StopPointStatus.ACTIVE, StopPointStatus.INACTIVE],
      to: StopPointStatus.SUSPENDED,
      reason,
    });
  }

  /** Mở khóa → `ACTIVE`, xóa lý do. Điểm không bị khóa → 409. */
  async unsuspend(authz: Authorization, actor: Actor, id: string): Promise<AdminOperatorPoint> {
    return this.changeSuspension(authz, actor, id, {
      from: [StopPointStatus.SUSPENDED],
      to: StopPointStatus.ACTIVE,
      reason: null,
    });
  }

  private async changeSuspension(
    authz: Authorization,
    actor: Actor,
    id: string,
    change: { from: StopPointStatus[]; to: StopPointStatus; reason: string | null },
  ): Promise<AdminOperatorPoint> {
    const point = await this.inTransaction(authz, async (tx, deadline) => {
      const [current] = await tx.$queryRaw<{ status: StopPointStatus; operator_id: string }[]>`
        SELECT status, operator_id FROM stop_points WHERE id = ${id} FOR NO KEY UPDATE`;
      if (!current) {
        throw stopPointNotFound();
      }
      if (!change.from.includes(current.status)) {
        throw stopPointStateInvalid();
      }
      const row = await tx.stopPoint.update({
        where: { id },
        data: { status: change.to, suspensionReason: change.reason },
        select: OPERATOR_POINT_SELECT,
      });
      await this.recordAudit(deadline, actor, {
        action: change.to === StopPointStatus.SUSPENDED ? "stop_point.suspend" : "stop_point.unsuspend",
        targetType: "stop_point",
        targetId: id,
        operatorId: current.operator_id,
        ...(change.reason ? { reason: change.reason } : {}),
        before: { status: current.status },
        after: { status: change.to, suspensionReason: change.reason },
      });
      return toOperatorPoint(row);
    });
    await this.notifyOwners(authz, point.operatorId, {
      operatorName: point.operatorName,
      stopPointName: point.name,
      decision: change.to === StopPointStatus.SUSPENDED ? "SUSPENDED" : "UNSUSPENDED",
      ...(change.reason ? { reason: change.reason } : {}),
    });
    return point;
  }

  /**
   * Báo chủ nhà xe (tài khoản Owner đang hoạt động, có email liên hệ) sau khi quyết định đã lưu. Lỗi (kể cả chưa
   * cấu hình Resend) chỉ ghi log — quyết định không hoàn tác; nhà xe vẫn thấy kết quả ở màn Điểm dừng.
   */
  private async notifyOwners(
    authz: Authorization,
    operatorId: string,
    message: Omit<StopPointDecisionEmailMessage, "email">,
  ): Promise<void> {
    try {
      const owners = await this.prisma.withScope(platformDb(authz), (tx) =>
        tx.operatorAccount.findMany({
          where: { operatorId, role: "OPERATOR_OWNER", status: "ACTIVE", contactEmail: { not: null } },
          select: { contactEmail: true },
        }),
      );
      for (const owner of owners) {
        const email = owner.contactEmail!;
        try {
          if (!this.email.sendStopPointDecision) {
            throw new Error("Email adapter does not support stop point decisions.");
          }
          await this.email.sendStopPointDecision({ ...message, email });
        } catch (error) {
          this.logger.warn({ event: "stop_point.decision.delivery_failed", decision: message.decision, email: maskEmail(email), error });
        }
      }
    } catch (error) {
      this.logger.warn({ event: "stop_point.decision.recipients_failed", decision: message.decision, error });
    }
  }

  /** Transaction scope platform; audit lỗi / transaction hết hạn → 503, không lưu gì. */
  private async inTransaction<T>(
    authz: Authorization,
    work: (tx: DbTransaction, deadline: number) => Promise<T>,
  ): Promise<T> {
    try {
      return await this.prisma.withScope(platformDb(authz), (tx) => work(tx, transactionDeadline(Date.now())));
    } catch (error) {
      if (error instanceof AuditWriteError || (error as { code?: unknown } | null)?.code === "P2028") {
        throw stopPointAuditUnavailable();
      }
      throw error;
    }
  }

  private recordAudit(
    deadline: number,
    actor: Actor,
    event: {
      action: string;
      targetType: string;
      targetId: string;
      operatorId?: string;
      reason?: string;
      before: Record<string, unknown> | null;
      after: Record<string, unknown>;
    },
  ): Promise<void> {
    return this.audit.recordAuditEvent(
      { actorId: actor.sub, actorRole: actor.role, ...event },
      { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
    );
  }
}

function platformDb(authz: Authorization): DbScope {
  if (authz.db?.kind !== "platform") {
    // Lỗi lập trình: route Admin thiếu `@Authorize` với quyền phạm vi `any`.
    throw new Error("Route Admin điểm dừng cần ngữ cảnh DB platform.");
  }
  return authz.db;
}

function afterCursor(cursor: string | undefined) {
  if (!cursor) {
    return {};
  }
  const { at, id } = decodeTimeCursor(cursor);
  return { OR: [{ createdAt: { lt: at } }, { createdAt: at, id: { lt: id } }] };
}

function page<Row extends { id: string; createdAt: Date }, Item>(
  rows: Row[],
  limit: number,
  map: (row: Row) => Item,
): { items: Item[]; nextCursor: string | null } {
  const kept = rows.slice(0, limit);
  const last = kept.at(-1);
  return {
    items: kept.map(map),
    nextCursor: rows.length > limit && last ? encodeTimeCursor(last.createdAt, last.id) : null,
  };
}

/** Khóa dòng đề xuất; không có → 404, không còn `PENDING` → 409. Trả nhà xe đề xuất (cho audit). */
async function lockPendingProposal(tx: DbTransaction, id: string): Promise<string> {
  const [row] = await tx.$queryRaw<{ status: StopPointProposalStatus; operator_id: string }[]>`
    SELECT status, operator_id FROM stop_point_proposals WHERE id = ${id} FOR NO KEY UPDATE`;
  if (!row) {
    throw stopPointProposalNotFound();
  }
  if (row.status !== StopPointProposalStatus.PENDING) {
    throw stopPointProposalNotPending();
  }
  return row.operator_id;
}

/** Điểm dùng chung cùng loại, đang hoạt động, trong bán kính cảnh báo — gần nhất trước. */
async function nearbyShared(
  tx: DbTransaction,
  point: { type: StopPointType; latitude: number; longitude: number; catalogStopPointId: string | null },
): Promise<AdminProposal["nearby"]> {
  // Khung vuông bao quanh bán kính để lọc ở DB, sau đó tính khoảng cách thật.
  const latDelta = (NEARBY_RADIUS_METERS / EARTH_RADIUS_METERS) * (180 / Math.PI);
  const lngDelta = latDelta / Math.max(Math.cos((point.latitude * Math.PI) / 180), 0.01);
  const candidates = await tx.stopPointCatalog.findMany({
    where: {
      type: point.type,
      status: CatalogStatus.ACTIVE,
      latitude: { gte: point.latitude - latDelta, lte: point.latitude + latDelta },
      longitude: { gte: point.longitude - lngDelta, lte: point.longitude + lngDelta },
      // Điểm sinh ra từ chính đề xuất này (sau khi duyệt) không phải "điểm trùng".
      ...(point.catalogStopPointId ? { id: { not: point.catalogStopPointId } } : {}),
    },
    select: { id: true, name: true, latitude: true, longitude: true, _count: { select: { routeStops: true } } },
  });
  return candidates
    .map((candidate) => ({
      id: candidate.id,
      name: candidate.name,
      latitude: candidate.latitude,
      longitude: candidate.longitude,
      distanceMeters: Math.round(distanceMeters(point, candidate)),
      routeCount: candidate._count.routeStops,
    }))
    .filter((candidate) => candidate.distanceMeters <= NEARBY_RADIUS_METERS)
    .sort((a, b) => a.distanceMeters - b.distanceMeters)
    .slice(0, MAX_NEARBY);
}

/** Khoảng cách đường tròn lớn (haversine), mét. */
export function distanceMeters(
  a: { latitude: number; longitude: number },
  b: { latitude: number; longitude: number },
): number {
  const rad = Math.PI / 180;
  const dLat = (b.latitude - a.latitude) * rad;
  const dLng = (b.longitude - a.longitude) * rad;
  const h = Math.sin(dLat / 2) ** 2 + Math.cos(a.latitude * rad) * Math.cos(b.latitude * rad) * Math.sin(dLng / 2) ** 2;
  return 2 * EARTH_RADIUS_METERS * Math.asin(Math.min(1, Math.sqrt(h)));
}

// Liệt kê từng trường: không phụ thuộc Zod strip để chặn client chèn `id` / `searchText`.
function sharedData(input: SharedStopPointInput | (ProposalApprovalInput & { status: CatalogStatus })) {
  return {
    name: input.name,
    type: input.type,
    address: input.address,
    provinceId: input.provinceId,
    wardId: input.wardId,
    latitude: input.latitude,
    longitude: input.longitude,
    description: input.description,
    legalBasis: input.legalBasis,
    status: input.status,
  };
}

function sharedSnapshot(row: {
  name: string;
  type: StopPointType;
  address: string;
  provinceId: string;
  wardId: string;
  latitude: number;
  longitude: number;
  legalBasis: string | null;
  status: CatalogStatus;
}): Record<string, unknown> {
  return {
    name: row.name,
    type: row.type,
    address: row.address,
    provinceId: row.provinceId,
    wardId: row.wardId,
    latitude: row.latitude,
    longitude: row.longitude,
    legalBasis: row.legalBasis,
    status: row.status,
  };
}

type LocationRow = {
  id: string;
  name: string;
  type: StopPointType;
  address: string;
  provinceId: string;
  wardId: string;
  latitude: number;
  longitude: number;
  description: string | null;
  createdAt: Date;
  updatedAt: Date;
  ward: { province: { name: string } };
};

function location(row: LocationRow) {
  return {
    id: row.id,
    name: row.name,
    type: row.type,
    address: row.address,
    provinceId: row.provinceId,
    provinceName: row.ward.province.name,
    wardId: row.wardId,
    latitude: row.latitude,
    longitude: row.longitude,
    description: row.description,
    createdAt: row.createdAt.toISOString(),
    updatedAt: row.updatedAt.toISOString(),
  };
}

function toShared(
  row: LocationRow & { legalBasis: string | null; status: CatalogStatus; _count: { routeStops: number } },
): SharedStopPoint {
  return { ...location(row), legalBasis: row.legalBasis, status: row.status, routeCount: row._count.routeStops };
}

function toProposal(
  row: LocationRow & {
    legalBasis: string;
    status: StopPointProposalStatus;
    rejectionReason: string | null;
    catalogStopPointId: string | null;
    operatorId: string;
    operator: { displayName: string };
  },
  nearby: AdminProposal["nearby"],
): AdminProposal {
  return {
    ...location(row),
    legalBasis: row.legalBasis,
    status: row.status,
    rejectionReason: row.rejectionReason,
    catalogStopPointId: row.catalogStopPointId,
    operatorId: row.operatorId,
    operatorName: row.operator.displayName,
    nearby,
  };
}

function toOperatorPoint(
  row: LocationRow & {
    status: StopPointStatus;
    suspensionReason: string | null;
    operatorId: string;
    operator: { displayName: string };
    _count: { routeStops: number };
  },
): AdminOperatorPoint {
  return {
    ...location(row),
    status: row.status,
    suspensionReason: row.suspensionReason,
    operatorId: row.operatorId,
    operatorName: row.operator.displayName,
    routeCount: row._count.routeStops,
  };
}
