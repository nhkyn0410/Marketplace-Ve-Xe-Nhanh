import { InjectQueue } from "@nestjs/bullmq";
import { Inject, Injectable, Logger } from "@nestjs/common";
import type { Queue } from "bullmq";
import type { DirectDisputeInput } from "@vexenhanh/types";
import { AuthException } from "../iam/auth/auth.errors";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { canAccessBooking } from "../booking/booking-access";
import type { DbScope } from "../database/db-scope";
import { withBookingOperator } from "../database/marketplace-scope";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import { CaseParty, DisputeDecision, DisputeEventKind, DisputeStatus, PaymentStatus, RefundStatus, SupportStatus, TicketStatus } from "../database/prisma.types";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { requireTenant } from "../iam/role/require-tenant";
import { NotificationDispatcher } from "../notification/notification-dispatcher";
import { maskName } from "../payment/admin-payment.service";
import { QUEUE_NAMES } from "../queue/queue.constants";
import { settleBookingStatus } from "../refund/booking-settlement";
import { newRefundCode } from "../refund/cancellation.service";
import { REFUND_JOB, REFUND_JOB_OPTIONS } from "../refund/refund-processing";
import type { EscalateInput } from "../support/dto/support.dto";
import { SupportAttachmentService } from "../support/support-attachments";
import { queueCaseNotice, type CaseNotice } from "../support/support-notices";
import { clip, PLATFORM_DISPLAY_NAME, platformDb } from "../support/support.service";
import { disputeNotFound, disputeRefundInvalid, disputeStateInvalid, supportStateInvalid, supportTicketNotFound, trustAuditUnavailable } from "../support/support.errors";
import {
  OPEN_DISPUTE_STATUSES,
  type DecisionInput,
  type DisputeDetail,
  type DisputePage,
  type DisputeStatusInput,
  type DisputeSummary,
  type EvidenceInput,
  type RequestEvidenceInput,
} from "./dto/dispute.dto";

const AUDIT_TIMEOUT_MS = 2_000;
const MAX_DUE_MS = 30 * 86_400_000;
const OPEN: DisputeStatus[] = [...OPEN_DISPUTE_STATUSES];
const WAITING: DisputeStatus[] = [DisputeStatus.WAITING_USER_EVIDENCE, DisputeStatus.WAITING_OPERATOR_RESPONSE];
/** Refund còn tính vào phần đã hoàn của thanh toán. */
const COUNTED_REFUNDS: RefundStatus[] = [RefundStatus.REQUESTED, RefundStatus.APPROVED, RefundStatus.PROCESSING, RefundStatus.SUCCESS];

type View = "ADMIN" | "OPERATOR" | "CUSTOMER";
type Actor = Pick<VerifiedAccessToken, "sub" | "role">;
type DisputeWhere = NonNullable<NonNullable<Parameters<DbTransaction["disputeCase"]["findMany"]>[0]>["where"]>;

const SUMMARY_SELECT = {
  id: true,
  disputeCode: true,
  title: true,
  bookingId: true,
  operatorId: true,
  status: true,
  responseDueAt: true,
  assigneeId: true,
  supportTicketId: true,
  createdAt: true,
  updatedAt: true,
  booking: { select: { bookingCode: true, payments: { where: { status: PaymentStatus.SUCCESS }, select: { amount: true } } } },
  operator: { select: { displayName: true } },
} as const;
type SummaryRow = Awaited<ReturnType<typeof findSummaries>>[number];

/** Tranh chấp theo điều kiện, mới tạo trước. */
function findSummaries(tx: DbTransaction, where: DisputeWhere) {
  return tx.disputeCase.findMany({ where, orderBy: { createdAt: "desc" }, select: SUMMARY_SELECT });
}

/**
 * Tranh chấp (TASK-TRUST-001, FR-DSP-01..08, BR-50/51, MQ-03): Admin mở từ khiếu nại, yêu cầu minh chứng có hạn, xem xét / leo
 * thang, ra quyết định (hoàn tiền qua cổng — trừ vào sổ giữ hộ của nhà xe — / không hoàn / phương án khác) rồi đóng; nhà xe và
 * khách gửi phản hồi + minh chứng trong phạm vi tranh chấp của mình. Mọi lần đổi trạng thái lưu một sự kiện (bên, người, trước /
 * sau, lý do, hạn) + audit; các bên nhận email (FR-DSP-07). Quá hạn → job leo thang (`dispute-overdue.ts`, FR-DSP-05).
 */
@Injectable()
export class DisputeService {
  private readonly logger = new Logger(DisputeService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(SupportAttachmentService) private readonly attachments: SupportAttachmentService,
    @Inject(NotificationDispatcher) private readonly notifications: NotificationDispatcher,
    @InjectQueue(QUEUE_NAMES.refundProcessing) private readonly refunds: Pick<Queue, "add">,
  ) {}

  // ------------------------------------------------------------------ Admin

  /** Mở tranh chấp từ đơn hoặc thanh toán; khóa đơn để gửi lặp không tạo hai vụ đang mở. */
  async openFromBooking(authz: Authorization, actor: Actor, input: DirectDisputeInput): Promise<DisputeDetail> {
    const { disputeId, keys } = await this.write(platformDb(authz), async (tx, deadline) => {
      const [booking] = await tx.$queryRaw<{ id: string; operatorId: string; bookingCode: string }[]>`SELECT id, operator_id AS "operatorId", booking_code AS "bookingCode" FROM bookings WHERE id = ${input.bookingId} FOR UPDATE`;
      if (!booking) throw new AuthException(404, "BOOKING_NOT_FOUND", "Không tìm thấy đơn đặt vé.");
      if (await tx.disputeCase.findFirst({ where: { bookingId: booking.id, operatorId: booking.operatorId, supportTicketId: null, status: { in: OPEN } }, select: { id: true } })) {
        throw disputeStateInvalid("Đơn đã có tranh chấp trực tiếp đang mở.");
      }
      const now = new Date();
      const [{ seq }] = await tx.$queryRaw<{ seq: bigint }[]>`SELECT nextval('dispute_code_seq') AS seq`;
      const dispute = await tx.disputeCase.create({ data: {
        disputeCode: `DC-${String(seq).padStart(6, "0")}`, operatorId: booking.operatorId, bookingId: booking.id,
        title: input.title, customerRequest: input.customerRequest, assigneeId: actor.sub,
        createdBy: `platform:${actor.sub}`, createdAt: now,
      }, select: { id: true, disputeCode: true } });
      await tx.disputeEvent.create({ data: {
        disputeId: dispute.id, operatorId: booking.operatorId, kind: DisputeEventKind.STATUS, party: CaseParty.PLATFORM,
        actor: `platform:${actor.sub}`, actorName: await platformName(tx, actor.sub), toStatus: DisputeStatus.OPEN,
        body: `Từ đơn ${booking.bookingCode}. ${input.reason}`, createdAt: now,
      } });
      await this.record(actor, "dispute.open", dispute.id, booking.operatorId, {}, { disputeCode: dispute.disputeCode, bookingId: booking.id }, deadline, input.reason);
      const keys = await notices(tx, booking.operatorId, [
        { audience: "OPERATOR", bookingId: booking.id, dedupKey: `CASE_UPDATED:${dispute.id}:open:OPERATOR`, caseCode: dispute.disputeCode, title: "Vé Xe Nhanh mở tranh chấp", message: `Đơn ${booking.bookingCode} phát sinh tranh chấp "${input.title}".` },
        { audience: "CUSTOMER", bookingId: booking.id, dedupKey: `CASE_UPDATED:${dispute.id}:open:CUSTOMER`, caseCode: dispute.disputeCode, title: "Đơn của bạn được mở tranh chấp", message: "Vé Xe Nhanh sẽ xem xét minh chứng của các bên và ra quyết định cuối cùng." },
      ]);
      return { disputeId: dispute.id, keys };
    });
    await this.notifications.dispatch(keys);
    return this.adminGet(authz, disputeId);
  }

  /** Chuyển khiếu nại thành tranh chấp (FR-DSP-01): khiếu nại → "Đã chuyển tranh chấp"; nhà xe + khách nhận email. */
  async escalate(authz: Authorization, actor: Actor, ticketId: string, input: EscalateInput): Promise<DisputeDetail> {
    const { disputeId, keys } = await this.write(platformDb(authz), async (tx, deadline) => {
      const [locked] = await tx.$queryRaw<{ id: string }[]>`SELECT id FROM support_tickets WHERE id = ${ticketId} FOR UPDATE`;
      const ticket = locked
        ? await tx.supportTicket.findUnique({ where: { id: ticketId }, select: { operatorId: true, bookingId: true, ticketCode: true, subject: true, status: true, assigneeId: true } })
        : null;
      if (!ticket) {
        throw supportTicketNotFound();
      }
      if (ticket.status === SupportStatus.ESCALATED || ticket.status === SupportStatus.CLOSED) {
        throw supportStateInvalid("Khiếu nại đã chuyển tranh chấp hoặc đã đóng.");
      }
      const now = new Date();
      const [{ seq }] = await tx.$queryRaw<{ seq: bigint }[]>`SELECT nextval('dispute_code_seq') AS seq`;
      const name = await platformName(tx, actor.sub);
      const dispute = await tx.disputeCase.create({
        data: {
          disputeCode: `DC-${String(seq).padStart(6, "0")}`,
          operatorId: ticket.operatorId,
          bookingId: ticket.bookingId,
          supportTicketId: ticketId,
          title: input.title ?? ticket.subject,
          customerRequest: input.customerRequest,
          assigneeId: ticket.assigneeId ?? actor.sub,
          createdBy: `platform:${actor.sub}`,
          createdAt: now,
        },
        select: { id: true, disputeCode: true },
      });
      await tx.disputeEvent.create({
        data: {
          disputeId: dispute.id,
          operatorId: ticket.operatorId,
          kind: DisputeEventKind.STATUS,
          party: CaseParty.PLATFORM,
          actor: `platform:${actor.sub}`,
          actorName: name,
          toStatus: DisputeStatus.OPEN,
          body: `Từ khiếu nại ${ticket.ticketCode}. ${input.reason}`,
          createdAt: now,
        },
      });
      await tx.supportTicket.update({ where: { id: ticketId }, data: { status: SupportStatus.ESCALATED, lastMessageAt: now } });
      await this.record(actor, "dispute.open", dispute.id, ticket.operatorId, { ticketStatus: ticket.status }, { disputeCode: dispute.disputeCode, ticketId }, deadline, input.reason);
      const keys = await notices(tx, ticket.operatorId, [
        { audience: "OPERATOR", bookingId: ticket.bookingId, dedupKey: `CASE_UPDATED:${dispute.id}:open:OPERATOR`, caseCode: dispute.disputeCode, title: "Vé Xe Nhanh mở tranh chấp", message: `Khiếu nại ${ticket.ticketCode} đã được chuyển thành tranh chấp "${input.title ?? ticket.subject}".` },
        { audience: "CUSTOMER", bookingId: ticket.bookingId, dedupKey: `CASE_UPDATED:${dispute.id}:open:CUSTOMER`, caseCode: dispute.disputeCode, title: "Khiếu nại của bạn được chuyển thành tranh chấp", message: "Vé Xe Nhanh sẽ xem xét minh chứng của các bên và ra quyết định cuối cùng." },
      ]);
      return { disputeId: dispute.id, keys };
    });
    await this.notifications.dispatch(keys);
    return this.adminGet(authz, disputeId);
  }

  async adminList(
    authz: Authorization,
    query: { status?: DisputeStatus | "open"; operatorId?: string; due?: "overdue" | "upcoming"; assigneeId?: string; q?: string; cursor?: string; limit: number },
    now: Date = new Date(),
  ): Promise<DisputePage> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const q = query.q?.toUpperCase();
      const where: DisputeWhere = {
        ...(query.status === "open" ? { status: { in: OPEN } } : query.status ? { status: query.status } : {}),
        ...(query.operatorId ? { operatorId: query.operatorId } : {}),
        ...(query.due === "overdue" ? { status: { in: WAITING }, responseDueAt: { lt: now } } : query.due === "upcoming" ? { status: { in: WAITING }, responseDueAt: { gte: now } } : {}),
        ...(query.assigneeId ? { assigneeId: query.assigneeId === "none" ? null : query.assigneeId } : {}),
        ...(q ? { OR: [{ disputeCode: { contains: q } }, { booking: { bookingCode: { contains: q.replace(/-/g, "") } } }] } : {}),
      };
      return page(tx, where, query, await assigneeNames(tx), {}, now);
    });
  }

  async adminGet(authz: Authorization, disputeId: string): Promise<DisputeDetail> {
    const detail = await this.prisma.withScope(platformDb(authz), async (tx) => loadDetail(tx, { id: disputeId }, "ADMIN", await assigneeNames(tx), new Date()));
    if (!detail) {
      throw disputeNotFound();
    }
    return detail;
  }

  /** Yêu cầu minh chứng (FR-DSP-03): chờ khách / chờ nhà xe, hạn phản hồi; bên được yêu cầu nhận email. */
  async requestEvidence(authz: Authorization, actor: Actor, disputeId: string, input: RequestEvidenceInput): Promise<DisputeDetail> {
    const now = new Date();
    const dueAt = new Date(input.dueAt);
    if (dueAt.getTime() <= now.getTime() || dueAt.getTime() - now.getTime() > MAX_DUE_MS) {
      throw disputeStateInvalid("Hạn phản hồi phải sau hiện tại và trong vòng 30 ngày.");
    }
    const keys = await this.write(platformDb(authz), async (tx, deadline) => {
      const dispute = await lockDispute(tx, disputeId);
      if (!OPEN.includes(dispute.status)) {
        throw disputeStateInvalid("Tranh chấp đã có quyết định.");
      }
      const toStatus = input.party === CaseParty.OPERATOR ? DisputeStatus.WAITING_OPERATOR_RESPONSE : DisputeStatus.WAITING_USER_EVIDENCE;
      await tx.disputeCase.update({ where: { id: disputeId }, data: { status: toStatus, responseDueAt: dueAt } });
      await tx.disputeEvent.create({
        data: {
          disputeId,
          operatorId: dispute.operatorId,
          kind: DisputeEventKind.REQUEST,
          party: CaseParty.PLATFORM,
          actor: `platform:${actor.sub}`,
          actorName: await platformName(tx, actor.sub),
          fromStatus: dispute.status,
          toStatus,
          body: input.message,
          target: input.party,
          dueAt,
          createdAt: now,
        },
      });
      await this.record(actor, "dispute.request_evidence", disputeId, dispute.operatorId, { status: dispute.status }, { status: toStatus, party: input.party, dueAt: dueAt.toISOString() }, deadline, input.message);
      return notices(tx, dispute.operatorId, [
        {
          audience: input.party === CaseParty.OPERATOR ? "OPERATOR" : "CUSTOMER",
          bookingId: dispute.bookingId,
          dedupKey: `CASE_UPDATED:${disputeId}:request:${now.getTime()}`,
          caseCode: dispute.disputeCode,
          title: "Vé Xe Nhanh cần bạn cung cấp minh chứng",
          message: `${clip(input.message)} Hạn phản hồi: ${vnMoment(dueAt)}.`,
        },
      ]);
    });
    await this.notifications.dispatch(keys);
    return this.adminGet(authz, disputeId);
  }

  /** Đang xem xét / leo thang (khi còn mở) / đóng (sau quyết định). */
  async setStatus(authz: Authorization, actor: Actor, disputeId: string, input: DisputeStatusInput): Promise<DisputeDetail> {
    await this.write(platformDb(authz), async (tx, deadline) => {
      const dispute = await lockDispute(tx, disputeId);
      const allowed =
        input.status === DisputeStatus.CLOSED
          ? dispute.status === DisputeStatus.RESOLVED_REFUND || dispute.status === DisputeStatus.RESOLVED_NO_REFUND
          : OPEN.includes(dispute.status) && dispute.status !== input.status;
      if (!allowed) {
        throw disputeStateInvalid(input.status === DisputeStatus.CLOSED ? "Chỉ đóng được tranh chấp đã có quyết định." : "Tranh chấp đã có quyết định hoặc đã ở trạng thái này.");
      }
      await this.transition(tx, actor, dispute, input.status, input.reason, input.status === DisputeStatus.CLOSED ? {} : { responseDueAt: null });
      if (input.status === DisputeStatus.CLOSED && dispute.supportTicketId) {
        await tx.supportTicket.update({ where: { id: dispute.supportTicketId }, data: { status: SupportStatus.CLOSED, lastMessageAt: new Date() } });
      }
      await this.record(actor, "dispute.status", disputeId, dispute.operatorId, { status: dispute.status }, { status: input.status }, deadline, input.reason);
    });
    return this.adminGet(authz, disputeId);
  }

  /**
   * Quyết định (FR-DSP-06, BR-51): hoàn tiền tạo refund `APPROVED` trên thanh toán thành công của đơn (worker hoàn qua cổng; khi
   * xong trừ vào sổ giữ hộ của nhà xe + trả lại phần hoa hồng tương ứng — MQ-03 "hoàn qua đầu nhà xe"), tối đa phần khách đã trả
   * còn lại. Khiếu nại gốc → đã giải quyết. Khách + nhà xe nhận email.
   */
  async decide(authz: Authorization, actor: Actor, disputeId: string, input: DecisionInput): Promise<DisputeDetail> {
    const { keys, refundId } = await this.write(platformDb(authz), async (tx, deadline) => {
      const dispute = await lockDispute(tx, disputeId);
      if (!OPEN.includes(dispute.status)) {
        throw disputeStateInvalid("Tranh chấp đã có quyết định.");
      }
      const now = new Date();
      let refundId: string | null = null;
      let refundCode: string | null = null;
      if (input.decision === DisputeDecision.REFUND) {
        const payment = await tx.payment.findFirst({
          where: { bookingId: dispute.bookingId, operatorId: dispute.operatorId, status: PaymentStatus.SUCCESS },
          orderBy: { paidAt: "asc" },
          select: { id: true, amount: true, providerTxnId: true, refunds: { where: { status: { in: COUNTED_REFUNDS } }, select: { amount: true } } },
        });
        if (!payment?.providerTxnId) {
          throw disputeRefundInvalid("Đơn không có thanh toán thành công qua cổng để hoàn.");
        }
        const refundable = payment.amount - payment.refunds.reduce((sum, refund) => sum + refund.amount, 0n);
        const amount = BigInt(input.amount!);
        if (amount > refundable) {
          throw disputeRefundInvalid(`Số tiền hoàn tối đa ${refundable.toString()} ₫ (phần khách đã trả còn lại).`);
        }
        const by = `platform:${actor.sub}`;
        const reason = `Tranh chấp ${dispute.disputeCode}: ${input.reason}`.slice(0, 500);
        const refund = await tx.refund.create({
          data: {
            refundCode: newRefundCode(),
            operatorId: dispute.operatorId,
            bookingId: dispute.bookingId,
            paymentId: payment.id,
            status: RefundStatus.APPROVED,
            amount,
            refundPercent: Math.min(100, Math.max(1, Math.round(Number((amount * 100n) / payment.amount)))),
            reason,
            requestedBy: by,
            histories: {
              create: [
                { toStatus: RefundStatus.REQUESTED, reason, actor: by, createdAt: now },
                { fromStatus: RefundStatus.REQUESTED, toStatus: RefundStatus.APPROVED, reason: "Quyết định tranh chấp của Vé Xe Nhanh.", actor: by, createdAt: new Date(now.getTime() + 1) },
              ],
            },
          },
          select: { id: true, refundCode: true },
        });
        refundId = refund.id;
        refundCode = refund.refundCode;
        await settleBookingStatus(tx, dispute.operatorId, dispute.bookingId, by, "Hoàn tiền theo quyết định tranh chấp.", new Date(now.getTime() + 2));
      }
      const toStatus = input.decision === DisputeDecision.REFUND ? DisputeStatus.RESOLVED_REFUND : DisputeStatus.RESOLVED_NO_REFUND;
      await this.transition(tx, actor, dispute, toStatus, input.reason, {
        responseDueAt: null,
        decision: input.decision,
        decisionAmount: input.amount === null ? null : BigInt(input.amount),
        decisionReason: input.reason,
        decidedBy: `platform:${actor.sub}`,
        decidedAt: now,
        refundId,
      });
      if (dispute.supportTicketId) {
        await tx.supportTicket.update({ where: { id: dispute.supportTicketId }, data: { status: SupportStatus.RESOLVED, resolvedAt: now, lastMessageAt: now } });
      }
      await this.record(
        actor,
        "dispute.decide",
        disputeId,
        dispute.operatorId,
        { status: dispute.status },
        { status: toStatus, decision: input.decision, amount: input.amount, refundCode },
        deadline,
        input.reason,
      );
      const outcome =
        input.decision === DisputeDecision.REFUND
          ? `Hoàn ${new Intl.NumberFormat("vi-VN").format(input.amount!)} ₫ cho khách (mã hoàn ${refundCode}).`
          : input.decision === DisputeDecision.NO_REFUND
            ? "Không hoàn tiền."
            : "Phương án khác theo chính sách.";
      const keys = await notices(tx, dispute.operatorId, [
        { audience: "CUSTOMER", bookingId: dispute.bookingId, dedupKey: `CASE_UPDATED:${disputeId}:decision:CUSTOMER`, caseCode: dispute.disputeCode, title: "Vé Xe Nhanh đã ra quyết định tranh chấp", message: `${outcome} Lý do: ${clip(input.reason)}` },
        {
          audience: "OPERATOR",
          bookingId: dispute.bookingId,
          dedupKey: `CASE_UPDATED:${disputeId}:decision:OPERATOR`,
          caseCode: dispute.disputeCode,
          title: "Vé Xe Nhanh đã ra quyết định tranh chấp",
          message: `${outcome}${input.decision === DisputeDecision.REFUND ? " Khoản hoàn được trừ khỏi số tiền chi trả cho nhà xe." : ""} Lý do: ${clip(input.reason)}`,
        },
      ]);
      return { keys, refundId };
    });
    if (refundId) {
      await this.refunds.add(REFUND_JOB, { refundId }, { ...REFUND_JOB_OPTIONS, jobId: refundId }).catch((error: unknown) => {
        // Refund vẫn `APPROVED`; job đối soát xếp hàng lại refund đứng yên (RECON-todo).
        this.logger.error({ event: "dispute.refund_enqueue_failed", refundId, error });
      });
    }
    await this.notifications.dispatch(keys);
    return this.adminGet(authz, disputeId);
  }

  // ------------------------------------------------------------------ Nhà xe

  async operatorList(authz: Authorization, query: { cursor?: string; limit: number }, now: Date = new Date()): Promise<DisputePage> {
    const { db, operatorId } = requireTenant(authz);
    return this.prisma.withScope(db, (tx) => page(tx, { operatorId }, query, new Map(), { operatorId }, now));
  }

  async operatorGet(authz: Authorization, disputeId: string): Promise<DisputeDetail> {
    const { db, operatorId } = requireTenant(authz);
    const detail = await this.prisma.withScope(db, (tx) => loadDetail(tx, { id: disputeId, operatorId }, "OPERATOR", new Map(), new Date()));
    if (!detail) {
      throw disputeNotFound();
    }
    return detail;
  }

  /** Nhà xe gửi giải trình + minh chứng (FR-DSP-04): đang chờ nhà xe → đang xem xét. */
  async operatorRespond(authz: Authorization, actor: Actor, disputeId: string, input: EvidenceInput): Promise<DisputeDetail> {
    const { db, operatorId } = requireTenant(authz);
    const files = await this.attachments.inspectAll({ operatorId, kind: "operator" }, input.attachments);
    await this.write(db, async (tx, deadline) => {
      const dispute = await lockDispute(tx, disputeId, operatorId);
      const name = (await tx.operatorProfile.findUniqueOrThrow({ where: { id: operatorId }, select: { displayName: true } })).displayName;
      const next = await this.addEvidence(tx, dispute, { party: CaseParty.OPERATOR, actor: `operator:${actor.sub}`, actorName: name }, input, files, DisputeStatus.WAITING_OPERATOR_RESPONSE);
      await this.record(actor, "dispute.operator_response", disputeId, operatorId, { status: dispute.status }, { status: next, attachments: files.length }, deadline);
    });
    return this.operatorGet(authz, disputeId);
  }

  // ------------------------------------------------------------------ Khách

  async customerList(user: VerifiedAccessToken | null, bookingId: string, token: string | undefined): Promise<DisputeSummary[]> {
    return this.asCustomer(user, bookingId, token, async (tx, operatorId) => {
      return (await findSummaries(tx, { bookingId, operatorId })).map((row) => toSummary(row, null, new Date()));
    });
  }

  async customerGet(user: VerifiedAccessToken | null, bookingId: string, token: string | undefined, disputeId: string): Promise<DisputeDetail> {
    return this.asCustomer(user, bookingId, token, async (tx, operatorId) => {
      const detail = await loadDetail(tx, { id: disputeId, operatorId, bookingId }, "CUSTOMER", new Map(), new Date());
      if (!detail) {
        throw disputeNotFound();
      }
      return detail;
    });
  }

  /** Khách gửi phản hồi + minh chứng (FR-DSP-04): đang chờ khách → đang xem xét. */
  async customerRespond(user: VerifiedAccessToken | null, bookingId: string, token: string | undefined, disputeId: string, input: EvidenceInput): Promise<DisputeDetail> {
    const operatorId = await this.asCustomer(user, bookingId, token, async (_tx, id) => id);
    const files = await this.attachments.inspectAll({ operatorId, kind: "booking", bookingId }, input.attachments);
    await this.asCustomer(user, bookingId, token, async (tx) => {
      const dispute = await lockDispute(tx, disputeId, operatorId);
      if (dispute.bookingId !== bookingId) {
        throw disputeNotFound();
      }
      const booking = await tx.booking.findFirstOrThrow({ where: { id: bookingId, operatorId }, select: { contactName: true, userId: true } });
      await this.addEvidence(
        tx,
        dispute,
        { party: booking.userId ? CaseParty.PASSENGER : CaseParty.GUEST, actor: booking.userId ? `user:${booking.userId}` : "guest", actorName: maskName(booking.contactName) },
        input,
        files,
        DisputeStatus.WAITING_USER_EVIDENCE,
      );
    });
    return this.customerGet(user, bookingId, token, disputeId);
  }

  // ------------------------------------------------------------------ Nội bộ

  private async addEvidence(
    tx: DbTransaction,
    dispute: Locked,
    author: { party: CaseParty; actor: string; actorName: string },
    input: EvidenceInput,
    files: { objectKey: string; fileName: string; contentType: string; sizeBytes: number }[],
    waitingFor: DisputeStatus,
  ): Promise<DisputeStatus> {
    if (!OPEN.includes(dispute.status)) {
      throw disputeStateInvalid("Tranh chấp đã có quyết định — không gửi thêm minh chứng.");
    }
    const now = new Date();
    const next = dispute.status === waitingFor ? DisputeStatus.UNDER_REVIEW : dispute.status;
    const event = await tx.disputeEvent.create({
      data: {
        disputeId: dispute.id,
        operatorId: dispute.operatorId,
        kind: DisputeEventKind.EVIDENCE,
        ...author,
        ...(next !== dispute.status ? { fromStatus: dispute.status, toStatus: next } : {}),
        body: input.body,
        createdAt: now,
      },
      select: { id: true },
    });
    await this.attachments.save(tx, dispute.operatorId, { disputeEventId: event.id }, files);
    await tx.disputeCase.update({ where: { id: dispute.id }, data: next !== dispute.status ? { status: next, responseDueAt: null } : { updatedAt: now } });
    return next;
  }

  private async transition(tx: DbTransaction, actor: Actor, dispute: Locked, toStatus: DisputeStatus, reason: string, data: Record<string, unknown>): Promise<void> {
    const now = new Date();
    await tx.disputeCase.update({ where: { id: dispute.id }, data: { status: toStatus, ...data } });
    await tx.disputeEvent.create({
      data: {
        disputeId: dispute.id,
        operatorId: dispute.operatorId,
        kind: DisputeEventKind.STATUS,
        party: CaseParty.PLATFORM,
        actor: `platform:${actor.sub}`,
        actorName: await platformName(tx, actor.sub),
        fromStatus: dispute.status,
        toStatus,
        body: reason,
        createdAt: now,
      },
    });
  }

  private async asCustomer<T>(user: VerifiedAccessToken | null, bookingId: string, token: string | undefined, work: (tx: DbTransaction, operatorId: string) => Promise<T>): Promise<T> {
    const result = await withBookingOperator(this.prisma, bookingId, async (tx, operatorId) => {
      const booking = await tx.booking.findFirst({ where: { id: bookingId, operatorId }, select: { userId: true, accessTokenHash: true } });
      if (!booking || !canAccessBooking(booking, user, token)) {
        return { found: false as const };
      }
      return { found: true as const, value: await work(tx, operatorId) };
    });
    if (!result?.found) {
      throw disputeNotFound();
    }
    return result.value;
  }

  private async write<T>(db: DbScope, work: (tx: DbTransaction, deadline: number) => Promise<T>): Promise<T> {
    try {
      return await this.prisma.withScope(db, (tx) => work(tx, transactionDeadline(Date.now())));
    } catch (error) {
      if (error instanceof AuditWriteError || (error as { code?: unknown } | null)?.code === "P2028") {
        throw trustAuditUnavailable();
      }
      throw error;
    }
  }

  private record(actor: Actor, action: string, disputeId: string, operatorId: string, before: Record<string, unknown>, after: Record<string, unknown>, deadline: number, reason?: string): Promise<void> {
    return this.audit.recordAuditEvent(
      { actorId: actor.sub, actorRole: actor.role, action, targetType: "dispute_case", targetId: disputeId, operatorId, before, after, ...(reason ? { reason } : {}) },
      { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
    );
  }
}

type Locked = { id: string; disputeCode: string; operatorId: string; bookingId: string; status: DisputeStatus; supportTicketId: string | null };

async function lockDispute(tx: DbTransaction, disputeId: string, operatorId?: string): Promise<Locked> {
  const [row] = await tx.$queryRaw<{ id: string }[]>`SELECT id FROM dispute_cases WHERE id = ${disputeId} FOR UPDATE`;
  const dispute = row
    ? await tx.disputeCase.findFirst({
        where: { id: disputeId, ...(operatorId ? { operatorId } : {}) },
        select: { id: true, disputeCode: true, operatorId: true, bookingId: true, status: true, supportTicketId: true },
      })
    : null;
  if (!dispute) {
    throw disputeNotFound();
  }
  return dispute;
}

async function notices(tx: DbTransaction, operatorId: string, list: CaseNotice[]): Promise<string[]> {
  const keys: string[] = [];
  for (const notice of list) {
    const key = await queueCaseNotice(tx, operatorId, notice);
    if (key) {
      keys.push(key);
    }
  }
  return keys;
}

async function platformName(tx: DbTransaction, accountId: string): Promise<string> {
  const account = await tx.platformAccount.findUnique({ where: { id: accountId }, select: { username: true } });
  return `platform/${account?.username ?? accountId}`;
}

async function assigneeNames(tx: DbTransaction): Promise<Map<string, string>> {
  const rows = await tx.platformAccount.findMany({ select: { id: true, username: true } });
  return new Map(rows.map((row) => [row.id, `platform/${row.username}`]));
}

async function page(
  tx: DbTransaction,
  where: DisputeWhere,
  query: { cursor?: string; limit: number },
  names: Map<string, string>,
  countScope: DisputeWhere,
  now: Date,
): Promise<DisputePage> {
  const rows = await tx.disputeCase.findMany({
    where,
    orderBy: [{ updatedAt: "desc" }, { id: "desc" }],
    take: query.limit + 1,
    ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
    select: SUMMARY_SELECT,
  });
  const more = rows.length > query.limit;
  const items = rows.slice(0, query.limit);
  return {
    items: items.map((row) => toSummary(row, names, now)),
    nextCursor: more ? items.at(-1)!.id : null,
    total: await tx.disputeCase.count({ where }),
    open: await tx.disputeCase.count({ where: { ...countScope, status: { in: OPEN } } }),
  };
}

function toSummary(row: SummaryRow, names: Map<string, string> | null, now: Date): DisputeSummary {
  return {
    disputeId: row.id,
    disputeCode: row.disputeCode,
    title: row.title,
    bookingId: row.bookingId,
    bookingCode: row.booking.bookingCode,
    operatorId: row.operatorId,
    operatorName: row.operator.displayName,
    paidAmount: Number(row.booking.payments.reduce((sum, payment) => sum + payment.amount, 0n)),
    status: row.status,
    responseDueAt: row.responseDueAt?.toISOString() ?? null,
    overdue: WAITING.includes(row.status) && row.responseDueAt !== null && row.responseDueAt < now,
    assignee: names && row.assigneeId ? { id: row.assigneeId, username: names.get(row.assigneeId) ?? "Tài khoản không còn" } : null,
    supportTicketId: row.supportTicketId,
    createdAt: row.createdAt.toISOString(),
    updatedAt: row.updatedAt.toISOString(),
  };
}

/** Sự kiện bên gọi được xem: Admin xem hết; nhà xe / khách chỉ thấy đổi trạng thái, yêu cầu gửi mình và minh chứng của chính mình. */
function visible(view: View, event: { kind: DisputeEventKind; party: CaseParty; target: CaseParty | null }): boolean {
  if (view === "ADMIN" || event.kind === DisputeEventKind.STATUS) {
    return true;
  }
  const own = view === "OPERATOR" ? event.party === CaseParty.OPERATOR : event.party === CaseParty.PASSENGER || event.party === CaseParty.GUEST;
  const forMe = view === "OPERATOR" ? event.target === CaseParty.OPERATOR : event.target === CaseParty.PASSENGER;
  return event.kind === DisputeEventKind.REQUEST ? forMe : own;
}

async function loadDetail(tx: DbTransaction, where: DisputeWhere, view: View, names: Map<string, string>, now: Date): Promise<DisputeDetail | null> {
  const row = await tx.disputeCase.findFirst({
    where,
    select: {
      ...SUMMARY_SELECT,
      customerRequest: true,
      decision: true,
      decisionAmount: true,
      decisionReason: true,
      decidedAt: true,
      supportTicket: { select: { ticketCode: true } },
      refund: { select: { id: true, refundCode: true, status: true } },
      booking: {
        select: {
          bookingCode: true,
          total: true,
          contactName: true,
          snapshot: true,
          payments: { where: { status: PaymentStatus.SUCCESS }, select: { amount: true, refunds: { where: { status: { in: COUNTED_REFUNDS } }, select: { amount: true } } } },
          tickets: { where: { checkedInAt: { not: null } }, orderBy: { checkedInAt: "asc" }, take: 1, select: { checkedInAt: true, status: true } },
          trip: {
            select: {
              id: true,
              departureAt: true,
              departedAt: true,
              route: { select: { name: true } },
              vehicle: { select: { plateNumber: true } },
              changes: { take: 1, select: { id: true } },
            },
          },
        },
      },
      events: {
        orderBy: { createdAt: "asc" },
        select: {
          id: true,
          kind: true,
          party: true,
          actorName: true,
          fromStatus: true,
          toStatus: true,
          body: true,
          target: true,
          dueAt: true,
          createdAt: true,
          attachments: { orderBy: { createdAt: "asc" }, select: { id: true, fileName: true, contentType: true, sizeBytes: true } },
        },
      },
    },
  });
  if (!row) {
    return null;
  }
  const paid = row.booking.payments.reduce((sum, payment) => sum + payment.amount, 0n);
  const refunded = row.booking.payments.flatMap((payment) => payment.refunds).reduce((sum, refund) => sum + refund.amount, 0n);
  const snapshot = row.booking.snapshot as { cancellationPolicy?: { tiers?: { minHoursBefore: number; refundPercent: number }[] } } | null;
  const firstCheckIn = row.booking.tickets.find((ticket) => ticket.status !== TicketStatus.CANCELLED) ?? row.booking.tickets[0];
  return {
    ...toSummary(row, view === "ADMIN" ? names : null, now),
    customerRequest: row.customerRequest,
    supportTicketCode: row.supportTicket?.ticketCode ?? null,
    bookingTotal: Number(row.booking.total),
    refundableAmount: Number(paid - refunded > 0n ? paid - refunded : 0n),
    customerName: maskName(row.booking.contactName),
    trip: {
      tripId: row.booking.trip.id,
      routeName: row.booking.trip.route.name,
      departureAt: row.booking.trip.departureAt.toISOString(),
      departedAt: row.booking.trip.departedAt?.toISOString() ?? null,
      vehiclePlateNumber: row.booking.trip.vehicle?.plateNumber ?? null,
    },
    firstCheckInAt: firstCheckIn?.checkedInAt?.toISOString() ?? null,
    tripChangeNotified: row.booking.trip.changes.length > 0,
    cancellationTiers: snapshot?.cancellationPolicy?.tiers ?? [],
    events: row.events.filter((event) => visible(view, event)).map((event) => ({
      eventId: event.id,
      kind: event.kind,
      party: event.party,
      actorName: event.party === CaseParty.PLATFORM && view !== "ADMIN" ? PLATFORM_DISPLAY_NAME : event.actorName,
      fromStatus: event.fromStatus,
      toStatus: event.toStatus,
      body: event.body,
      target: event.target,
      dueAt: event.dueAt?.toISOString() ?? null,
      createdAt: event.createdAt.toISOString(),
      attachments: event.attachments.map((file) => ({ attachmentId: file.id, fileName: file.fileName, contentType: file.contentType, sizeBytes: file.sizeBytes })),
    })),
    decision:
      row.decision && row.decidedAt
        ? {
            decision: row.decision,
            amount: row.decisionAmount === null ? null : Number(row.decisionAmount),
            reason: row.decisionReason ?? "",
            decidedAt: row.decidedAt.toISOString(),
            refund: row.refund ? { refundId: row.refund.id, refundCode: row.refund.refundCode, status: row.refund.status } : null,
          }
        : null,
  };
}

function vnMoment(at: Date): string {
  const [date, time] = new Date(at.getTime() + 7 * 3_600_000).toISOString().split("T");
  return `${time!.slice(0, 5)} ngày ${date!.slice(8, 10)}/${date!.slice(5, 7)}/${date!.slice(0, 4)}`;
}

