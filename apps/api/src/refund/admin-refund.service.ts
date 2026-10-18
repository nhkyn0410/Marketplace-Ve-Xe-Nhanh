import { InjectQueue } from "@nestjs/bullmq";
import { Inject, Injectable, Logger } from "@nestjs/common";
import type { Queue } from "bullmq";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import type { DbScope } from "../database/db-scope";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import { PaymentStatus, RefundStatus } from "../database/prisma.types";
import { vndToJson } from "../fare/fare-pricing";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { paymentNotFound } from "../payment/payment.errors";
import { QUEUE_NAMES } from "../queue/queue.constants";
import { settleBookingStatus } from "./booking-settlement";
import { newRefundCode } from "./cancellation.service";
import type { AdminRefundDetail, AdminRefundPage, AdminRefundSummary, RefundResolveInput } from "./dto/admin-refund.dto";
import { completeRefund, REFUND_JOB, REFUND_JOB_OPTIONS, transition } from "./refund-processing";
import { refundNotFound, refundServiceUnavailable, refundStatusInvalid } from "./refund.errors";

const AUDIT_TIMEOUT_MS = 2_000;
const DAY_MS = 86_400_000;
/** Refund đã / đang hoàn → thanh toán cần đối soát coi như đã có hướng xử lý. */
const RECONCILE_HANDLED: RefundStatus[] = [RefundStatus.REQUESTED, RefundStatus.APPROVED, RefundStatus.PROCESSING, RefundStatus.SUCCESS];

type Actor = Pick<VerifiedAccessToken, "sub" | "role">;
type ListQuery = {
  from?: string;
  to?: string;
  operatorId?: string;
  source?: "CUSTOMER" | "PLATFORM";
  status?: RefundStatus;
  q?: string;
  cursor?: string;
  limit: number;
};

const SUMMARY_SELECT = {
  id: true,
  refundCode: true,
  bookingId: true,
  paymentId: true,
  operatorId: true,
  amount: true,
  refundPercent: true,
  status: true,
  failureCode: true,
  reason: true,
  requestedBy: true,
  createdAt: true,
  updatedAt: true,
  booking: { select: { bookingCode: true, operator: { select: { displayName: true } } } },
  payment: { select: { paymentCode: true, provider: true } },
} as const;

type SummaryRow = {
  id: string;
  refundCode: string;
  bookingId: string;
  paymentId: string;
  operatorId: string;
  amount: bigint;
  refundPercent: number;
  status: RefundStatus;
  failureCode: string | null;
  reason: string;
  requestedBy: string;
  createdAt: Date;
  updatedAt: Date;
  booking: { bookingCode: string; operator: { displayName: string } };
  payment: { paymentCode: string; provider: AdminRefundSummary["provider"] };
};

/**
 * Hoàn tiền phía Admin (TASK-ADM-002, FR-ADM-10, UC-27 A4, UC-32 bước 8, Security §8 "Refund thủ công"; Figma ADM-07c–d):
 * danh sách + chi tiết; xử lý refund THẤT BẠI — gửi lại cổng (lần gửi mới, mã yêu cầu mới) hoặc ghi nhận đã hoàn ngoài luồng
 * tự động (chuyển khoản tay / đã hoàn trên trang quản trị cổng, kèm mã tham chiếu); hoàn toàn bộ cho thanh toán cần đối soát
 * (khách trả muộn / trùng — tiền bị trừ nhưng không nhận vào booking). Mỗi thao tác: khoá dòng, lý do, lịch sử, audit (lệnh
 * cuối trong transaction — Mongo lỗi → 503, không đổi gì). Xếp hàng job hoàn qua cổng SAU commit.
 */
@Injectable()
export class AdminRefundService {
  private readonly logger = new Logger(AdminRefundService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
    @InjectQueue(QUEUE_NAMES.refundProcessing) private readonly queue: Queue,
  ) {}

  async list(authz: Authorization, query: ListQuery): Promise<AdminRefundPage> {
    const code = query.q?.toUpperCase();
    const where = {
      operatorId: query.operatorId,
      status: query.status,
      ...(query.source === "PLATFORM" ? { requestedBy: { startsWith: "platform:" } } : query.source === "CUSTOMER" ? { NOT: { requestedBy: { startsWith: "platform:" } } } : {}),
      createdAt: {
        ...(query.from ? { gte: vnDayStart(query.from) } : {}),
        ...(query.to ? { lt: new Date(vnDayStart(query.to).getTime() + DAY_MS) } : {}),
      },
      ...(query.q ? { OR: [{ refundCode: { contains: code } }, { booking: { bookingCode: { contains: code } } }] } : {}),
    };
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      let after = {};
      if (query.cursor) {
        const cursor = await tx.refund.findUnique({ where: { id: query.cursor }, select: { id: true, createdAt: true } });
        if (cursor) {
          after = { OR: [{ createdAt: { lt: cursor.createdAt } }, { createdAt: cursor.createdAt, id: { lt: cursor.id } }] };
        }
      }
      const rows = await tx.refund.findMany({ where: { AND: [where, after] }, orderBy: [{ createdAt: "desc" }, { id: "desc" }], take: query.limit + 1, select: SUMMARY_SELECT });
      const total = await tx.refund.count({ where });
      const page = rows.slice(0, query.limit);
      return { items: page.map(toSummary), nextCursor: rows.length > query.limit ? page[page.length - 1]!.id : null, total };
    });
  }

  async get(authz: Authorization, refundId: string): Promise<AdminRefundDetail> {
    const detail = await this.prisma.withScope(platformDb(authz), (tx) => loadDetail(tx, refundId));
    if (!detail) {
      throw refundNotFound();
    }
    return detail;
  }

  /** Gửi lại cổng: `FAILED → APPROVED`, lần gửi + 1 (mã yêu cầu gửi cổng mới), booking quay về chờ hoàn tiền. */
  async retry(authz: Authorization, actor: Actor, refundId: string, reason: string): Promise<AdminRefundDetail> {
    const result = await this.write(authz, async (tx, deadline) => {
      const now = new Date();
      const locked = await lockFailed(tx, refundId);
      if (!locked.providerTxnId) {
        throw refundStatusInvalid("Thanh toán gốc chưa có mã giao dịch cổng — không gửi lại được, hãy ghi nhận đã hoàn ngoài cổng.");
      }
      const attempt = locked.attempt + 1;
      await transition(tx, locked.operatorId, refundId, RefundStatus.FAILED, RefundStatus.APPROVED, { failureCode: null, attempt }, reason, `platform:${actor.sub}`, now);
      if (locked.paymentStatus !== PaymentStatus.RECONCILING) {
        await settleBookingStatus(tx, locked.operatorId, locked.bookingId, `platform:${actor.sub}`, "Admin gửi lại yêu cầu hoàn tiền.", new Date(now.getTime() + 1));
      }
      const detail = (await loadDetail(tx, refundId))!;
      await this.record(actor, "refund.retry", refundId, locked.operatorId, { status: RefundStatus.FAILED, attempt: locked.attempt }, { status: RefundStatus.APPROVED, attempt }, deadline, reason);
      return { detail, jobId: `${refundId}-${attempt}` };
    });
    await this.enqueue(refundId, result.jobId);
    return result.detail;
  }

  /**
   * Ghi nhận đã hoàn ngoài luồng tự động (UC-27 bước 8 "refund thủ công"): `FAILED → SUCCESS` với mã tham chiếu — vé
   * `REFUNDED`, ghi sổ giữ hộ, suy lại booking như khi cổng xác nhận.
   */
  async resolve(authz: Authorization, actor: Actor, refundId: string, input: RefundResolveInput): Promise<AdminRefundDetail> {
    return this.write(authz, async (tx, deadline) => {
      const locked = await lockFailed(tx, refundId);
      await completeRefund(tx, locked.operatorId, refundId, {
        from: RefundStatus.FAILED,
        data: { bankReference: input.reference },
        reason: input.reason,
        actor: `platform:${actor.sub}`,
        at: new Date(),
      });
      const detail = (await loadDetail(tx, refundId))!;
      await this.record(actor, "refund.resolve_manual", refundId, locked.operatorId, { status: RefundStatus.FAILED }, { status: RefundStatus.SUCCESS, bankReference: input.reference }, deadline, input.reason);
      return detail;
    });
  }

  /**
   * Hoàn toàn bộ cho thanh toán cần đối soát (UC-32 bước 8): khách bị trừ tiền nhưng thanh toán không nhận vào booking (đơn hết
   * hạn / ghế đã nhả / trả trùng). Tạo refund `APPROVED` 100% số tiền thanh toán; worker hoàn qua cổng. Không có vé, không
   * đụng sổ giữ hộ (tiền chưa vào sổ). Lệch số tiền (`AMOUNT_MISMATCH`) không hoàn tự động được.
   */
  async refundPayment(authz: Authorization, actor: Actor, paymentId: string, reason: string): Promise<AdminRefundDetail> {
    const result = await this.write(authz, async (tx, deadline) => {
      const now = new Date();
      const [payment] = await tx.$queryRaw<{ status: PaymentStatus; operatorId: string; bookingId: string; amount: bigint; reconcileReason: string | null; providerTxnId: string | null }[]>`
        SELECT status::text AS "status", operator_id AS "operatorId", booking_id AS "bookingId", amount, reconcile_reason AS "reconcileReason",
          provider_txn_id AS "providerTxnId"
        FROM payments WHERE id = ${paymentId} FOR UPDATE`;
      if (!payment) {
        throw paymentNotFound();
      }
      if (payment.status !== PaymentStatus.RECONCILING) {
        throw refundStatusInvalid("Chỉ hoàn được thanh toán đang cần đối soát.");
      }
      if (payment.reconcileReason === "AMOUNT_MISMATCH" || !payment.providerTxnId) {
        throw refundStatusInvalid("Thanh toán lệch số tiền / thiếu mã giao dịch cổng — đối chiếu với cổng rồi xử lý ngoài hệ thống.");
      }
      if ((await tx.refund.count({ where: { paymentId, status: { in: RECONCILE_HANDLED } } })) > 0) {
        throw refundStatusInvalid("Thanh toán này đã có yêu cầu hoàn tiền.");
      }
      const by = `platform:${actor.sub}`;
      const refund = await tx.refund.create({
        data: {
          refundCode: newRefundCode(),
          operatorId: payment.operatorId,
          bookingId: payment.bookingId,
          paymentId,
          status: RefundStatus.APPROVED,
          amount: payment.amount,
          refundPercent: 100,
          reason,
          requestedBy: by,
          histories: {
            create: [
              { toStatus: RefundStatus.REQUESTED, reason, actor: by, createdAt: now },
              { fromStatus: RefundStatus.REQUESTED, toStatus: RefundStatus.APPROVED, reason: "Hoàn toàn bộ thanh toán cần đối soát.", actor: by, createdAt: new Date(now.getTime() + 1) },
            ],
          },
        },
        select: { id: true },
      });
      const detail = (await loadDetail(tx, refund.id))!;
      await this.record(actor, "payment.reconcile_refund", refund.id, payment.operatorId, { paymentId, status: PaymentStatus.RECONCILING }, { refundCode: detail.refundCode, amount: detail.amount }, deadline, reason);
      return { detail, jobId: refund.id };
    });
    await this.enqueue(result.detail.refundId, result.jobId);
    return result.detail;
  }

  private async enqueue(refundId: string, jobId: string): Promise<void> {
    await this.queue.add(REFUND_JOB, { refundId }, { ...REFUND_JOB_OPTIONS, jobId }).catch((error: unknown) => {
      // Refund vẫn `APPROVED` trong DB; worker không nhận được thì Admin thấy refund đứng yên (xem `ADM-002-payments-refunds-todo.md`).
      this.logger.error({ event: "refund.enqueue_failed", refundId, error });
    });
  }

  private record(
    actor: Actor,
    action: string,
    refundId: string,
    operatorId: string,
    before: Record<string, unknown>,
    after: Record<string, unknown>,
    deadline: number,
    reason: string,
  ): Promise<void> {
    return this.audit.recordAuditEvent(
      { actorId: actor.sub, actorRole: actor.role, action, targetType: "refund", targetId: refundId, operatorId, before, after, reason },
      { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
    );
  }

  private async write<T>(authz: Authorization, work: (tx: DbTransaction, deadline: number) => Promise<T>): Promise<T> {
    try {
      return await this.prisma.withScope(platformDb(authz), (tx) => work(tx, transactionDeadline(Date.now())));
    } catch (error) {
      if (error instanceof AuditWriteError || (error as { code?: unknown } | null)?.code === "P2028") {
        throw refundServiceUnavailable();
      }
      throw error;
    }
  }
}

/** Khoá refund + bắt buộc đang `FAILED` (chỉ refund thất bại mới cần Admin xử lý). */
async function lockFailed(tx: DbTransaction, refundId: string) {
  const [locked] = await tx.$queryRaw<
    { status: RefundStatus; operatorId: string; bookingId: string; attempt: number; paymentStatus: PaymentStatus; providerTxnId: string | null }[]
  >`
    SELECT r.status::text AS "status", r.operator_id AS "operatorId", r.booking_id AS "bookingId", r.attempt,
      p.status::text AS "paymentStatus", p.provider_txn_id AS "providerTxnId"
    FROM refunds r JOIN payments p ON p.id = r.payment_id AND p.operator_id = r.operator_id
    WHERE r.id = ${refundId} FOR UPDATE OF r`;
  if (!locked) {
    throw refundNotFound();
  }
  if (locked.status !== RefundStatus.FAILED) {
    throw refundStatusInvalid(`Yêu cầu hoàn tiền đang ở trạng thái ${locked.status}, chỉ xử lý được yêu cầu thất bại.`);
  }
  return locked;
}

async function loadDetail(tx: DbTransaction, refundId: string): Promise<AdminRefundDetail | null> {
  const row = await tx.refund.findUnique({
    where: { id: refundId },
    select: {
      ...SUMMARY_SELECT,
      attempt: true,
      providerRefundId: true,
      bankReference: true,
      processedAt: true,
      payment: { select: { paymentCode: true, provider: true, amount: true, status: true, providerTxnId: true } },
      tickets: { orderBy: { ticketCode: "asc" }, select: { ticketCode: true, seatCode: true, status: true } },
      histories: { orderBy: [{ createdAt: "asc" }, { id: "asc" }], select: { fromStatus: true, toStatus: true, reason: true, actor: true, createdAt: true } },
    },
  });
  if (!row) {
    return null;
  }
  const histories = [];
  for (const history of row.histories) {
    histories.push({ ...history, actor: await actorLabel(tx, history.actor), createdAt: history.createdAt.toISOString() });
  }
  return {
    ...toSummary(row),
    paidAmount: vndToJson(row.payment.amount),
    paymentStatus: row.payment.status,
    attempt: row.attempt,
    providerRefundId: row.providerRefundId,
    bankReference: row.bankReference,
    processedAt: row.processedAt?.toISOString() ?? null,
    tickets: row.tickets,
    histories,
    canRetry: row.status === RefundStatus.FAILED && row.payment.providerTxnId !== null,
    canResolve: row.status === RefundStatus.FAILED,
  };
}

function toSummary(row: SummaryRow): AdminRefundSummary {
  return {
    refundId: row.id,
    refundCode: row.refundCode,
    bookingId: row.bookingId,
    bookingCode: row.booking.bookingCode,
    paymentId: row.paymentId,
    paymentCode: row.payment.paymentCode,
    provider: row.payment.provider,
    operatorId: row.operatorId,
    operatorName: row.booking.operator.displayName,
    source: row.requestedBy.startsWith("platform:") ? "PLATFORM" : "CUSTOMER",
    amount: vndToJson(row.amount),
    refundPercent: row.refundPercent,
    status: row.status,
    failureCode: row.failureCode,
    reason: row.reason,
    createdAt: row.createdAt.toISOString(),
    updatedAt: row.updatedAt.toISOString(),
  };
}

/** Người thao tác trong lịch sử hoàn tiền: Admin (`platform/{tên}`) / khách / hệ thống (`null`). */
async function actorLabel(tx: DbTransaction, actor: string | null): Promise<string | null> {
  if (!actor || actor === "system") {
    return null;
  }
  if (actor.startsWith("platform:")) {
    const account = await tx.platformAccount.findUnique({ where: { id: actor.slice("platform:".length) }, select: { username: true } });
    return account ? `platform/${account.username}` : "Vé Xe Nhanh";
  }
  return actor === "guest" || actor.startsWith("user:") ? "Khách hàng" : actor;
}

/** `2026-10-13` → 00:00 giờ VN ngày đó. */
function vnDayStart(date: string): Date {
  return new Date(`${date}T00:00:00+07:00`);
}

function platformDb(authz: Authorization): DbScope {
  if (authz.db?.kind !== "platform") {
    // Lỗi lập trình: route Admin thiếu `@Authorize` với quyền phạm vi `any`.
    throw new Error("Route Admin hoàn tiền cần ngữ cảnh DB platform.");
  }
  return authz.db;
}
