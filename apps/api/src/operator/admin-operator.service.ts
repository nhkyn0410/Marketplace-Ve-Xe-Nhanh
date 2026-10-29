import { HttpException, HttpStatus, Inject, Injectable, Logger } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { decodeTimeCursor, encodeTimeCursor } from "../common/time-cursor";
import type { DbScope } from "../database/db-scope";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import { BankAccountStatus, OperatorStatus, SessionRevokeReason, SubjectType, TripStatus } from "../database/prisma.types";
import { EMAIL_NOTIFIER, type EmailNotifier, maskEmail } from "../external/notification/email-notifier";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { SessionService } from "../iam/session/session.service";
import { vndToJson } from "../fare/fare-pricing";
import { can } from "../iam/role/access-policy";
import { maskAccountNumber } from "../operator-kyc/operator-application-format";
import { lastDays, routePerformance, sumPerformance, vnRange } from "../reporting/route-performance";
import type {
  AdminBankChange,
  AdminOperator,
  AdminOperatorDetail,
  AdminOperatorPage,
  AdminOperatorVehicleList,
  OperatorListQuery,
} from "./dto/admin-operator.dto";
import { bankChangeNotFound } from "./operator-profile.errors";

type Actor = Pick<VerifiedAccessToken, "sub" | "role">;
type Viewer = Pick<VerifiedAccessToken, "role" | "perms">;
/** Dòng `ROW_SELECT` (khai tay vì module nghiệp vụ không import kiểu Prisma). */
type OperatorRowShape = {
  id: string;
  displayName: string;
  operatorSlug: string;
  status: OperatorStatus;
  suspendedReason: string | null;
  suspendedAt: Date | null;
  createdAt: Date;
  application: { id: string; reviewedAt: Date | null } | null;
  operatorAccounts: { id: string; username: string; contactEmail: string | null; credentialDeliveryPending: boolean }[];
  bankAccounts: { id: string }[];
};

const AUDIT_TIMEOUT_MS = 2_000;
const OPEN_TRIP_STATUSES = [TripStatus.OPEN_FOR_SALE, TripStatus.SOLD_OUT];
/** Chuyến chưa khởi hành còn giữ xe (đội xe ở chi tiết nhà xe). */
const UPCOMING_TRIP_STATUSES = [TripStatus.OPEN_FOR_SALE, TripStatus.SOLD_OUT, TripStatus.LOCKED, TripStatus.BOARDING];
/** Kỳ thẻ số ở chi tiết nhà xe. */
const STATS_DAYS = 30;

function problem(status: HttpStatus, code: string, detail: string): HttpException {
  return new HttpException({ code, detail, title: "Operator error" }, status);
}
const operatorNotFound = () => problem(HttpStatus.NOT_FOUND, "OPERATOR_NOT_FOUND", "Không tìm thấy nhà xe.");
const operatorStateInvalid = () =>
  problem(HttpStatus.CONFLICT, "OPERATOR_STATE_INVALID", "Trạng thái nhà xe vừa thay đổi. Tải lại danh sách.");
const auditUnavailable = () =>
  problem(HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE", "Chưa ghi được nhật ký nên chưa đổi gì. Vui lòng thử lại sau.");

const ROW_SELECT = {
  id: true,
  displayName: true,
  operatorSlug: true,
  status: true,
  suspendedReason: true,
  suspendedAt: true,
  createdAt: true,
  application: { select: { id: true, reviewedAt: true } },
  operatorAccounts: {
    where: { role: "OPERATOR_OWNER" as const },
    orderBy: { createdAt: "asc" as const },
    take: 1,
    select: { id: true, username: true, contactEmail: true, credentialDeliveryPending: true },
  },
  bankAccounts: { where: { status: BankAccountStatus.PENDING }, take: 1, select: { id: true } },
} as const;

/**
 * Admin xem danh sách nhà xe và tạm khóa / mở lại (FR-ADM-02/03, UC-23 A6; Figma ADM-02e/f). Tạm khóa: nhà xe không
 * đăng nhập được, không tạo / mở bán chuyến mới (kiểm ở login, mỗi request và điều kiện mở bán), mọi phiên của chủ nhà
 * xe + nhân viên bị thu hồi, chủ nhà xe nhận email kèm lý do. Đổi trạng thái + audit trong MỘT transaction.
 */
@Injectable()
export class AdminOperatorService {
  private readonly logger = new Logger(AdminOperatorService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(SessionService) private readonly sessions: SessionService,
    @Inject(EMAIL_NOTIFIER) private readonly email: EmailNotifier,
  ) {}

  async list(authz: Authorization, query: OperatorListQuery): Promise<AdminOperatorPage> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const literal = query.q?.replace(/[\\%_]/g, "\\$&");
      const contains = literal ? { contains: literal, mode: "insensitive" as const } : undefined;
      const where = {
        status: query.status,
        ...(query.bankChange ? { bankAccounts: { some: { status: BankAccountStatus.PENDING } } } : {}),
        ...(contains
          ? {
              OR: [
                { displayName: contains },
                { operatorSlug: contains },
                { operatorAccounts: { some: { OR: [{ username: contains }, { contactEmail: contains }] } } },
              ],
            }
          : {}),
      };
      const after = query.cursor ? decodeTimeCursor(query.cursor) : null;
      const rows = await tx.operatorProfile.findMany({
        where: {
          AND: [where, after ? { OR: [{ createdAt: { lt: after.at } }, { createdAt: after.at, id: { lt: after.id } }] } : {}],
        },
        orderBy: [{ createdAt: "desc" }, { id: "desc" }],
        take: query.limit + 1,
        select: ROW_SELECT,
      });
      const kept = rows.slice(0, query.limit);
      const ids = kept.map((row) => row.id);
      const now = new Date();
      const [routes, trips, total] = await Promise.all([
        tx.route.groupBy({ by: ["operatorId"], where: { operatorId: { in: ids }, status: "ACTIVE" }, _count: { _all: true } }),
        tx.trip.groupBy({
          by: ["operatorId"],
          where: { operatorId: { in: ids }, status: { in: OPEN_TRIP_STATUSES }, departureAt: { gt: now } },
          _count: { _all: true },
        }),
        tx.operatorProfile.count({ where }),
      ]);
      const routeCount = new Map(routes.map((group) => [group.operatorId, group._count._all]));
      const tripCount = new Map(trips.map((group) => [group.operatorId, group._count._all]));
      const last = kept.at(-1);
      return {
        items: kept.map((row) => toAdminOperator(row, routeCount.get(row.id) ?? 0, tripCount.get(row.id) ?? 0)),
        nextCursor: rows.length > query.limit && last ? encodeTimeCursor(last.createdAt, last.id) : null,
        total,
      };
    });
  }

  /**
   * Chi tiết một nhà xe (tự thiết kế 28/10/2026, chờ duyệt): hồ sơ công khai + pháp lý, chủ nhà xe, tài khoản nhận tiền
   * đang dùng (số che), số xe / nhân viên và thẻ số 30 ngày. Tiền chỉ trả khi người xem có `payment:monitor`.
   */
  async detail(authz: Authorization, viewer: Viewer, id: string, now: Date = new Date()): Promise<AdminOperatorDetail> {
    const period = lastDays(now, STATS_DAYS);
    const { from, to } = vnRange(period);
    const showMoney = can(viewer, "payment:monitor").allowed;
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const row = await tx.operatorProfile.findUnique({
        where: { id },
        select: { ...ROW_SELECT, legalName: true, taxCode: true, hotline: true, publicEmail: true, address: true, description: true },
      });
      if (!row) {
        throw operatorNotFound();
      }
      const [routeCount, openTripCount, vehicleCount, employeeCount, bank, performance, refunded, reviews] = await Promise.all([
        tx.route.count({ where: { operatorId: id, status: "ACTIVE" } }),
        tx.trip.count({ where: { operatorId: id, status: { in: OPEN_TRIP_STATUSES }, departureAt: { gt: now } } }),
        tx.vehicle.count({ where: { operatorId: id } }),
        tx.employeeAccount.count({ where: { operatorId: id } }),
        tx.bankAccount.findFirst({
          where: { operatorId: id, status: BankAccountStatus.VERIFIED },
          orderBy: { reviewedAt: "desc" },
          select: { bankName: true, accountNumber: true, accountHolder: true, reviewedAt: true },
        }),
        routePerformance(tx, { from, to, operatorId: id }),
        tx.refund.aggregate({ where: { operatorId: id, status: "SUCCESS", processedAt: { gte: from, lt: to } }, _sum: { amount: true } }),
        tx.review.aggregate({ where: { operatorId: id, status: "VISIBLE" }, _avg: { rating: true }, _count: { _all: true } }),
      ]);
      const total = sumPerformance(performance);
      return {
        ...toAdminOperator(row, routeCount, openTripCount),
        legalName: row.legalName,
        taxCode: row.taxCode,
        hotline: row.hotline,
        publicEmail: row.publicEmail,
        address: row.address,
        description: row.description,
        bankAccount: bank
          ? {
              bankName: bank.bankName,
              accountNumber: maskAccountNumber(bank.accountNumber) ?? "",
              accountHolder: bank.accountHolder,
              verifiedAt: bank.reviewedAt?.toISOString() ?? null,
            }
          : null,
        vehicleCount,
        employeeCount,
        stats: {
          ...period,
          trips: Number(total.trips),
          completedTrips: Number(total.completed),
          cancelledTrips: Number(total.cancelledTrips),
          seats: Number(total.seats),
          ticketsSold: Number(total.sold),
          ticketRevenue: showMoney ? vndToJson(total.revenue) : null,
          refunded: showMoney ? vndToJson(refunded._sum.amount ?? 0n) : null,
          averageRating: reviews._avg.rating === null ? null : Math.round(reviews._avg.rating * 10) / 10,
          reviewCount: reviews._count._all,
        },
      };
    });
  }

  /** Đội xe của một nhà xe (chỉ xem): biển số, loại xe, số chỗ, trạng thái, số chuyến sắp chạy đang dùng xe. */
  async vehicles(authz: Authorization, id: string, now: Date = new Date()): Promise<AdminOperatorVehicleList> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      if (!(await tx.operatorProfile.findUnique({ where: { id }, select: { id: true } }))) {
        throw operatorNotFound();
      }
      const [vehicles, trips] = await Promise.all([
        tx.vehicle.findMany({
          where: { operatorId: id },
          orderBy: [{ status: "asc" }, { plateNumber: "asc" }],
          take: 500,
          select: { id: true, plateNumber: true, status: true, vehicleType: { select: { name: true } }, seatMap: { select: { seatCount: true } } },
        }),
        tx.trip.groupBy({
          by: ["vehicleId"],
          where: { operatorId: id, vehicleId: { not: null }, status: { in: UPCOMING_TRIP_STATUSES }, departureAt: { gt: now } },
          _count: { _all: true },
        }),
      ]);
      const tripCount = new Map(trips.map((group) => [group.vehicleId, group._count._all]));
      return {
        items: vehicles.map((vehicle) => ({
          id: vehicle.id,
          plateNumber: vehicle.plateNumber,
          vehicleTypeName: vehicle.vehicleType.name,
          seatCount: vehicle.seatMap?.seatCount ?? null,
          status: vehicle.status,
          upcomingTripCount: tripCount.get(vehicle.id) ?? 0,
        })),
      };
    });
  }

  /**
   * Yêu cầu đổi tài khoản nhận tiền đang chờ của một nhà xe, kèm tài khoản đang dùng (UC-11 bước 4, BR-37). Trả số
   * tài khoản đầy đủ để Admin đối chiếu với ngân hàng — mỗi lần xem ghi audit (Security §9).
   */
  async getBankChange(authz: Authorization, actor: Actor, id: string): Promise<AdminBankChange> {
    const view = await this.prisma.withScope(platformDb(authz), async (tx) => {
      const operator = await tx.operatorProfile.findUnique({
        where: { id },
        select: {
          displayName: true,
          operatorSlug: true,
          legalName: true,
          taxCode: true,
          bankAccounts: {
            where: { status: { in: [BankAccountStatus.VERIFIED, BankAccountStatus.PENDING] } },
            select: {
              id: true,
              status: true,
              bankName: true,
              accountNumber: true,
              accountHolder: true,
              changeReason: true,
              requestedBy: true,
              reviewedAt: true,
              createdAt: true,
            },
          },
        },
      });
      if (!operator) {
        throw operatorNotFound();
      }
      const pending = operator.bankAccounts.find((account) => account.status === BankAccountStatus.PENDING);
      if (!pending) {
        throw bankChangeNotFound();
      }
      const requester = pending.requestedBy
        ? await tx.operatorAccount.findUnique({ where: { id: pending.requestedBy }, select: { username: true } })
        : null;
      const current = operator.bankAccounts.find((account) => account.status === BankAccountStatus.VERIFIED);
      return { operator, pending, current, requester };
    });
    await this.audit
      .recordAuditEvent(
        {
          actorId: actor.sub,
          actorRole: actor.role,
          action: "operator.bank_account.view",
          targetType: "operator",
          targetId: id,
          operatorId: id,
          before: null,
          after: { changeId: view.pending.id },
        },
        { timeoutMs: AUDIT_TIMEOUT_MS },
      )
      .catch((error: unknown) => {
        throw error instanceof AuditWriteError ? auditUnavailable() : error;
      });
    const { operator, pending, current, requester } = view;
    return {
      changeId: pending.id,
      operatorName: operator.displayName,
      legalName: operator.legalName,
      taxCode: operator.taxCode,
      current: current
        ? {
            bankName: current.bankName,
            accountNumber: current.accountNumber,
            accountHolder: current.accountHolder,
            verifiedAt: current.reviewedAt?.toISOString() ?? null,
          }
        : null,
      requested: {
        bankName: pending.bankName,
        accountNumber: pending.accountNumber,
        accountHolder: pending.accountHolder,
        reason: pending.changeReason,
        requestedAt: pending.createdAt.toISOString(),
        requestedBy: requester ? `${operator.operatorSlug}/${requester.username}` : null,
      },
    };
  }

  /** Xác minh yêu cầu: tài khoản cũ → `REPLACED`, yêu cầu → `VERIFIED` (một transaction + audit), email chủ nhà xe. */
  async approveBankChange(authz: Authorization, actor: Actor, id: string, changeId: string): Promise<void> {
    await this.decideBankChange(authz, actor, id, changeId, null);
  }

  /** Từ chối yêu cầu kèm lý do: tài khoản cũ giữ nguyên (UC-11 A3); audit, email chủ nhà xe. */
  async rejectBankChange(authz: Authorization, actor: Actor, id: string, changeId: string, reason: string): Promise<void> {
    await this.decideBankChange(authz, actor, id, changeId, reason);
  }

  private async decideBankChange(
    authz: Authorization,
    actor: Actor,
    id: string,
    changeId: string,
    rejectReason: string | null,
  ): Promise<void> {
    const approved = rejectReason === null;
    const result = await this.write(authz, async (tx, deadline) => {
      const now = new Date();
      // Khóa dòng yêu cầu: hai Admin quyết cùng lúc thì người sau thấy không còn `PENDING` → 404.
      const locked = await tx.$queryRaw<{ id: string }[]>`
        SELECT id FROM bank_accounts WHERE id = ${changeId} AND operator_id = ${id} AND status = 'PENDING' FOR UPDATE`;
      if (locked.length === 0) {
        throw bankChangeNotFound();
      }
      const previous = await tx.bankAccount.findFirst({
        where: { operatorId: id, status: BankAccountStatus.VERIFIED },
        select: { id: true, bankName: true, accountNumber: true },
      });
      if (approved && previous) {
        // Trước khi đổi yêu cầu sang `VERIFIED`: unique index "một tài khoản đã xác minh mỗi nhà xe".
        await tx.bankAccount.update({ where: { id: previous.id }, data: { status: BankAccountStatus.REPLACED } });
      }
      const change = await tx.bankAccount.update({
        where: { id: changeId },
        data: approved
          ? { status: BankAccountStatus.VERIFIED, reviewedBy: actor.sub, reviewedAt: now }
          : { status: BankAccountStatus.REJECTED, reviewedBy: actor.sub, reviewedAt: now, reviewNote: rejectReason },
        select: { bankName: true, accountNumber: true },
      });
      await this.audit.recordAuditEvent(
        {
          actorId: actor.sub,
          actorRole: actor.role,
          action: approved ? "operator.bank_account.approve" : "operator.bank_account.reject",
          targetType: "operator",
          targetId: id,
          operatorId: id,
          before: previous ? { bankName: previous.bankName, accountNumber: maskAccountNumber(previous.accountNumber) } : null,
          after: {
            changeId,
            status: approved ? BankAccountStatus.VERIFIED : BankAccountStatus.REJECTED,
            bankName: change.bankName,
            accountNumber: maskAccountNumber(change.accountNumber),
          },
          ...(rejectReason ? { reason: rejectReason } : {}),
        },
        { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
      );
      const operator = await tx.operatorProfile.findUniqueOrThrow({
        where: { id },
        select: {
          displayName: true,
          operatorAccounts: { where: { role: "OPERATOR_OWNER", status: "ACTIVE" }, select: { contactEmail: true } },
        },
      });
      return { change, operator };
    });

    for (const owner of result.operator.operatorAccounts) {
      if (!owner.contactEmail) {
        continue;
      }
      try {
        if (!this.email.sendBankAccountChangeDecision) {
          throw new Error("Email adapter does not support bank account decisions.");
        }
        await this.email.sendBankAccountChangeDecision({
          email: owner.contactEmail,
          operatorName: result.operator.displayName,
          approved,
          bankName: result.change.bankName,
          accountNumberMasked: maskAccountNumber(result.change.accountNumber)!,
          ...(rejectReason ? { reason: rejectReason } : {}),
        });
      } catch (error) {
        this.logger.warn({ event: "operator.bank_account.delivery_failed", email: maskEmail(owner.contactEmail), error });
      }
    }
  }

  async suspend(authz: Authorization, actor: Actor, id: string, reason: string): Promise<void> {
    await this.setStatus(authz, actor, id, OperatorStatus.SUSPENDED, reason);
  }

  async unsuspend(authz: Authorization, actor: Actor, id: string): Promise<void> {
    await this.setStatus(authz, actor, id, OperatorStatus.ACTIVE, null);
  }

  private async setStatus(
    authz: Authorization,
    actor: Actor,
    id: string,
    to: OperatorStatus,
    reason: string | null,
  ): Promise<void> {
    const from = to === OperatorStatus.SUSPENDED ? OperatorStatus.ACTIVE : OperatorStatus.SUSPENDED;
    const operator = await this.write(authz, async (tx, deadline) => {
      // So-rồi-đặt: hai Admin bấm cùng lúc thì một người nhận 409.
      const changed = await tx.operatorProfile.updateMany({
        where: { id, status: from },
        data:
          to === OperatorStatus.SUSPENDED
            ? { status: to, suspendedReason: reason, suspendedAt: new Date() }
            : { status: to, suspendedReason: null, suspendedAt: null },
      });
      if (changed.count === 0) {
        const exists = await tx.operatorProfile.count({ where: { id } });
        throw exists ? operatorStateInvalid() : operatorNotFound();
      }
      await this.audit.recordAuditEvent(
        {
          actorId: actor.sub,
          actorRole: actor.role,
          action: to === OperatorStatus.SUSPENDED ? "operator.suspend" : "operator.unsuspend",
          targetType: "operator",
          targetId: id,
          operatorId: id,
          before: { status: from },
          after: { status: to },
          ...(reason ? { reason } : {}),
        },
        { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
      );
      return tx.operatorProfile.findUniqueOrThrow({
        where: { id },
        select: {
          displayName: true,
          operatorAccounts: { select: { id: true, role: true, status: true, contactEmail: true } },
          employeeAccounts: { select: { id: true } },
        },
      });
    });

    if (to === OperatorStatus.SUSPENDED) {
      // Mỗi request đã kiểm trạng thái nhà xe; thu hồi để refresh token cũng chết ngay (UC-23 A6).
      const subjects = [
        ...operator.operatorAccounts.map((account) => [SubjectType.OPERATOR, account.id] as const),
        ...operator.employeeAccounts.map((account) => [SubjectType.EMPLOYEE, account.id] as const),
      ];
      for (const [type, subjectId] of subjects) {
        await this.sessions
          .revokeAllForSubject(type, subjectId, SessionRevokeReason.ACCOUNT_LOCKED)
          .catch((error: unknown) => this.logger.warn({ event: "operator.suspend.revoke_failed", subjectId, error }));
      }
    }
    for (const owner of operator.operatorAccounts) {
      if (owner.role !== "OPERATOR_OWNER" || owner.status !== "ACTIVE" || !owner.contactEmail) {
        continue;
      }
      try {
        if (!this.email.sendOperatorStatusChanged) {
          throw new Error("Email adapter does not support operator status.");
        }
        await this.email.sendOperatorStatusChanged({
          email: owner.contactEmail,
          operatorName: operator.displayName,
          suspended: to === OperatorStatus.SUSPENDED,
          ...(reason ? { reason } : {}),
        });
      } catch (error) {
        this.logger.warn({ event: "operator.status.delivery_failed", email: maskEmail(owner.contactEmail), error });
      }
    }
  }

  private async write<T>(
    authz: Authorization,
    work: (tx: DbTransaction, deadline: number) => Promise<T>,
  ): Promise<T> {
    try {
      return await this.prisma.withScope(platformDb(authz), (tx) => work(tx, transactionDeadline(Date.now())));
    } catch (error) {
      if (error instanceof AuditWriteError || (error as { code?: unknown } | null)?.code === "P2028") {
        throw auditUnavailable();
      }
      throw error;
    }
  }
}

function platformDb(authz: Authorization): DbScope {
  if (authz.db?.kind !== "platform") {
    // Lỗi lập trình: route Admin thiếu `@Authorize` với quyền phạm vi `any`.
    throw new Error("Route Admin nhà xe cần ngữ cảnh DB platform.");
  }
  return authz.db;
}

/** Một dòng nhà xe (danh sách + phần đầu của chi tiết). */
function toAdminOperator(
  row: OperatorRowShape,
  routeCount: number,
  openTripCount: number,
): AdminOperator {
  const owner = row.operatorAccounts[0];
  return {
    id: row.id,
    name: row.displayName,
    slug: row.operatorSlug,
    status: row.status,
    suspendedReason: row.suspendedReason,
    suspendedAt: row.suspendedAt?.toISOString() ?? null,
    approvedAt: (row.application?.reviewedAt ?? row.createdAt).toISOString(),
    applicationId: row.application?.id ?? null,
    owner: owner
      ? {
          id: owner.id,
          username: `${row.operatorSlug}/${owner.username}`,
          email: owner.contactEmail,
          credentialDeliveryPending: owner.credentialDeliveryPending,
        }
      : null,
    routeCount,
    openTripCount,
    bankChangePending: row.bankAccounts.length > 0,
  };
}
