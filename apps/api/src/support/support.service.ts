import { Inject, Injectable } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { ACCESS_GRANT_SELECT, canAccessBooking } from "../booking/booking-access";
import type { DbScope } from "../database/db-scope";
import { withBookingOperator } from "../database/marketplace-scope";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import { AccountStatus, CaseParty, PaymentStatus, SupportHandler, SupportStatus, TicketStatus } from "../database/prisma.types";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { requireTenant } from "../iam/role/require-tenant";
import { NotificationDispatcher } from "../notification/notification-dispatcher";
import { maskName } from "../payment/admin-payment.service";
import { maskEmail } from "../booking/operator-booking.service";
import type {
  AdminMessageInput,
  AssigneeList,
  AttachmentUploadInput,
  AttachmentUploadResponse,
  ClassifyInput,
  CustomerTicketInput,
  CustomerTicketList,
  DownloadUrlResponse,
  MessageInput,
  TicketDetail,
  TicketPage,
  TicketStatusInput,
  TicketSummary,
} from "./dto/support.dto";
import { SupportAttachmentService, type AttachmentOwner } from "./support-attachments";
import { queueCaseNotice } from "./support-notices";
import { supportAssigneeInvalid, supportStateInvalid, supportTicketNotFound, trustAuditUnavailable } from "./support.errors";

const AUDIT_TIMEOUT_MS = 2_000;
const VN_OFFSET_MS = 7 * 3_600_000;
const SOLD: TicketStatus[] = [TicketStatus.VALID, TicketStatus.CHECKED_IN, TicketStatus.NO_SHOW, TicketStatus.USED];
/** Tên Vé Xe Nhanh hiện cho nhà xe / khách thay tên tài khoản nền tảng (Figma "CSKH Vé Xe Nhanh"). */
export const PLATFORM_DISPLAY_NAME = "CSKH Vé Xe Nhanh";

type View = "ADMIN" | "OPERATOR" | "CUSTOMER";
type Actor = Pick<VerifiedAccessToken, "sub" | "role">;

const SUMMARY_SELECT = {
  id: true,
  ticketCode: true,
  subject: true,
  bookingId: true,
  operatorId: true,
  reporterParty: true,
  reporterName: true,
  category: true,
  priority: true,
  requestedPriority: true,
  handler: true,
  status: true,
  assigneeId: true,
  createdAt: true,
  lastMessageAt: true,
  booking: { select: { bookingCode: true } },
  operator: { select: { displayName: true } },
  disputes: { select: { id: true, disputeCode: true, status: true } },
} as const;
type TicketWhere = NonNullable<NonNullable<Parameters<DbTransaction["supportTicket"]["findMany"]>[0]>["where"]>;
type SummaryRow = Awaited<ReturnType<typeof findSummaries>>[number];

/** Khiếu nại theo điều kiện, mới tạo trước. */
function findSummaries(tx: DbTransaction, where: TicketWhere) {
  return tx.supportTicket.findMany({ where, orderBy: { createdAt: "desc" }, select: SUMMARY_SELECT });
}

/**
 * Khiếu nại / hỗ trợ (TASK-TRUST-001, FR-NSR-06..09, BR-49, UC-09): khách (hành khách hoặc khách vãng lai đã xác minh bằng mã truy
 * cập đơn) gửi và trao đổi; Admin phân loại, phân công, trả lời, yêu cầu bổ sung, chuyển nhà xe phản hồi, đóng; nhà xe chỉ thấy
 * khiếu nại đã được chuyển cho mình và phản hồi khách. Mọi thao tác của Admin / nhà xe ghi audit trong transaction.
 */
@Injectable()
export class SupportService {
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(SupportAttachmentService) private readonly attachments: SupportAttachmentService,
    @Inject(NotificationDispatcher) private readonly notifications: NotificationDispatcher,
  ) {}

  // ------------------------------------------------------------------ Khách

  async customerList(user: VerifiedAccessToken | null, bookingId: string, token: string | undefined): Promise<CustomerTicketList> {
    const items = await this.asCustomer(user, bookingId, token, async (tx, operatorId) => {
      return (await findSummaries(tx, { bookingId, operatorId })).map((row) => toSummary(row, null));
    });
    return { items };
  }

  async customerGet(user: VerifiedAccessToken | null, bookingId: string, token: string | undefined, ticketId: string): Promise<TicketDetail> {
    return this.asCustomer(user, bookingId, token, async (tx, operatorId) => {
      const detail = await loadDetail(tx, { id: ticketId, operatorId, bookingId }, "CUSTOMER", new Map());
      if (!detail) {
        throw supportTicketNotFound();
      }
      return detail;
    });
  }

  async customerCreate(user: VerifiedAccessToken | null, bookingId: string, token: string | undefined, input: CustomerTicketInput): Promise<TicketDetail> {
    const operatorId = await this.asCustomer(user, bookingId, token, async (_tx, id) => id);
    const files = await this.attachments.inspectAll({ operatorId, kind: "booking", bookingId }, input.attachments);
    return this.asCustomer(user, bookingId, token, async (tx) => {
      const booking = await tx.booking.findFirstOrThrow({ where: { id: bookingId, operatorId }, select: { contactName: true, userId: true } });
      const now = new Date();
      const [{ seq }] = await tx.$queryRaw<{ seq: bigint }[]>`SELECT nextval('support_ticket_code_seq') AS seq`;
      const reporterName = maskName(booking.contactName);
      const party = booking.userId ? CaseParty.PASSENGER : CaseParty.GUEST;
      const ticket = await tx.supportTicket.create({
        data: {
          ticketCode: `KN-${vnDay(now)}-${String(seq).padStart(3, "0")}`,
          operatorId,
          bookingId,
          userId: booking.userId,
          reporterParty: party,
          reporterName,
          subject: input.subject,
          category: input.category,
          requestedPriority: input.priority,
          priority: input.priority,
          lastMessageAt: now,
          createdAt: now,
          messages: { create: { party, authorId: booking.userId, authorName: reporterName, body: input.body, createdAt: now } },
        },
        select: { id: true, messages: { select: { id: true } } },
      });
      await this.attachments.save(tx, operatorId, { messageId: ticket.messages[0]!.id }, files);
      return (await loadDetail(tx, { id: ticket.id, operatorId }, "CUSTOMER", new Map()))!;
    });
  }

  async customerReply(user: VerifiedAccessToken | null, bookingId: string, token: string | undefined, ticketId: string, input: MessageInput): Promise<TicketDetail> {
    const operatorId = await this.asCustomer(user, bookingId, token, async (_tx, id) => id);
    const files = await this.attachments.inspectAll({ operatorId, kind: "booking", bookingId }, input.attachments);
    return this.asCustomer(user, bookingId, token, async (tx) => {
      const ticket = await lockTicket(tx, ticketId, operatorId);
      if (!ticket || ticket.bookingId !== bookingId) {
        throw supportTicketNotFound();
      }
      if (ticket.status === SupportStatus.CLOSED) {
        throw supportStateInvalid("Khiếu nại đã đóng — gửi khiếu nại mới nếu cần.");
      }
      const now = new Date();
      const message = await tx.supportMessage.create({
        data: { ticketId, operatorId, party: ticket.reporterParty, authorId: ticket.userId, authorName: ticket.reporterName, body: input.body, createdAt: now },
        select: { id: true },
      });
      await this.attachments.save(tx, operatorId, { messageId: message.id }, files);
      // Khách trả lời khi đang chờ khách / đã giải quyết → Vé Xe Nhanh xử lý tiếp.
      const reopen = ticket.status === SupportStatus.WAITING_CUSTOMER || ticket.status === SupportStatus.RESOLVED;
      await tx.supportTicket.update({ where: { id: ticketId }, data: { lastMessageAt: now, ...(reopen ? { status: SupportStatus.IN_PROGRESS, resolvedAt: null } : {}) } });
      return (await loadDetail(tx, { id: ticketId, operatorId }, "CUSTOMER", new Map()))!;
    });
  }

  async customerUpload(user: VerifiedAccessToken | null, bookingId: string, token: string | undefined, input: AttachmentUploadInput): Promise<AttachmentUploadResponse> {
    const operatorId = await this.asCustomer(user, bookingId, token, async (_tx, id) => id);
    return this.attachments.createUpload({ operatorId, kind: "booking", bookingId }, input);
  }

  async customerDownload(user: VerifiedAccessToken | null, bookingId: string, token: string | undefined, attachmentId: string): Promise<DownloadUrlResponse> {
    const attachment = await this.asCustomer(user, bookingId, token, (tx, operatorId) =>
      tx.supportAttachment.findFirst({
        where: { id: attachmentId, operatorId, OR: [{ message: { ticket: { bookingId } } }, { disputeEvent: { dispute: { bookingId }, party: { in: [CaseParty.PASSENGER, CaseParty.GUEST] } } }] },
        select: { id: true, objectKey: true, fileName: true, operatorId: true },
      }),
    );
    return this.attachments.createDownload(attachment, { id: user?.sub ?? null, role: user?.role ?? "GUEST" });
  }

  // ------------------------------------------------------------------ Nhà xe

  async operatorList(authz: Authorization, query: { status?: SupportStatus; cursor?: string; limit: number }): Promise<TicketPage> {
    const { db, operatorId } = requireTenant(authz);
    return this.prisma.withScope(db, async (tx) => {
      const where: TicketWhere = { operatorId, sharedWithOperatorAt: { not: null }, ...(query.status ? { status: query.status } : {}) };
      return page(tx, where, query, new Map(), { operatorId, sharedWithOperatorAt: { not: null } });
    });
  }

  async operatorGet(authz: Authorization, ticketId: string): Promise<TicketDetail> {
    const { db, operatorId } = requireTenant(authz);
    const detail = await this.prisma.withScope(db, (tx) => loadDetail(tx, { id: ticketId, operatorId, sharedWithOperatorAt: { not: null } }, "OPERATOR", new Map()));
    if (!detail) {
      throw supportTicketNotFound();
    }
    return detail;
  }

  /** Nhà xe phản hồi khách (FR-NSR-07): khiếu nại đang chờ nhà xe → Vé Xe Nhanh xử lý tiếp; khách nhận email. */
  async operatorReply(authz: Authorization, actor: Actor, ticketId: string, input: MessageInput): Promise<TicketDetail> {
    const { db, operatorId } = requireTenant(authz);
    const files = await this.attachments.inspectAll({ operatorId, kind: "operator" }, input.attachments);
    const { detail, keys } = await this.write(db, async (tx, deadline) => {
      const ticket = await lockTicket(tx, ticketId, operatorId);
      if (!ticket || !ticket.sharedWithOperatorAt) {
        throw supportTicketNotFound();
      }
      if (ticket.status === SupportStatus.CLOSED) {
        throw supportStateInvalid("Khiếu nại đã đóng.");
      }
      const operator = await tx.operatorProfile.findUniqueOrThrow({ where: { id: operatorId }, select: { displayName: true } });
      const now = new Date();
      const message = await tx.supportMessage.create({
        data: { ticketId, operatorId, party: CaseParty.OPERATOR, authorId: actor.sub, authorName: operator.displayName, body: input.body, createdAt: now },
        select: { id: true },
      });
      await this.attachments.save(tx, operatorId, { messageId: message.id }, files);
      const next = ticket.status === SupportStatus.WAITING_OPERATOR ? SupportStatus.IN_PROGRESS : ticket.status;
      await tx.supportTicket.update({ where: { id: ticketId }, data: { lastMessageAt: now, status: next } });
      await this.record(actor, "support.ticket.operator_reply", ticketId, operatorId, { status: ticket.status }, { status: next, messageId: message.id, attachments: files.length }, deadline);
      const key = await queueCaseNotice(tx, operatorId, {
        audience: "CUSTOMER",
        bookingId: ticket.bookingId,
        dedupKey: `CASE_UPDATED:${message.id}:CUSTOMER`,
        caseCode: ticket.ticketCode,
        title: "Nhà xe đã phản hồi khiếu nại của bạn",
        message: `${operator.displayName}: ${clip(input.body)}`,
      });
      return { detail: (await loadDetail(tx, { id: ticketId, operatorId }, "OPERATOR", new Map()))!, keys: key ? [key] : [] };
    });
    await this.notifications.dispatch(keys);
    return detail;
  }

  async operatorUpload(authz: Authorization, input: AttachmentUploadInput): Promise<AttachmentUploadResponse> {
    return this.attachments.createUpload({ operatorId: requireTenant(authz).operatorId, kind: "operator" }, input);
  }

  /** Nhà xe xem tệp của khiếu nại đã chuyển cho mình, hoặc minh chứng chính nhà xe gửi trong tranh chấp (không thấy tệp của khách). */
  async operatorDownload(authz: Authorization, actor: Actor, attachmentId: string): Promise<DownloadUrlResponse> {
    const { db, operatorId } = requireTenant(authz);
    const attachment = await this.prisma.withScope(db, (tx) =>
      tx.supportAttachment.findFirst({
        where: { id: attachmentId, operatorId, OR: [{ message: { ticket: { sharedWithOperatorAt: { not: null } } } }, { disputeEvent: { party: CaseParty.OPERATOR } }] },
        select: { id: true, objectKey: true, fileName: true, operatorId: true },
      }),
    );
    return this.attachments.createDownload(attachment, { id: actor.sub, role: actor.role });
  }

  // ------------------------------------------------------------------ Admin

  async adminList(
    authz: Authorization,
    query: { status?: SupportStatus; category?: TicketSummary["category"]; operatorId?: string; assigneeId?: string; q?: string; cursor?: string; limit: number },
  ): Promise<TicketPage> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const q = query.q?.toUpperCase();
      const where: TicketWhere = {
        ...(query.status ? { status: query.status } : {}),
        ...(query.category ? { category: query.category } : {}),
        ...(query.operatorId ? { operatorId: query.operatorId } : {}),
        ...(query.assigneeId ? { assigneeId: query.assigneeId === "none" ? null : query.assigneeId } : {}),
        ...(q ? { OR: [{ ticketCode: { contains: q } }, { booking: { bookingCode: { contains: q.replace(/-/g, "") } } }] } : {}),
      };
      return page(tx, where, query, await assigneeNames(tx), {});
    });
  }

  async adminGet(authz: Authorization, ticketId: string): Promise<TicketDetail> {
    const detail = await this.prisma.withScope(platformDb(authz), async (tx) => loadDetail(tx, { id: ticketId }, "ADMIN", await assigneeNames(tx)));
    if (!detail) {
      throw supportTicketNotFound();
    }
    return detail;
  }

  async assignees(authz: Authorization): Promise<AssigneeList> {
    return this.prisma.withScope(platformDb(authz), async (tx) => ({
      items: (await tx.platformAccount.findMany({ where: { status: AccountStatus.ACTIVE }, orderBy: { username: "asc" }, select: { id: true, username: true, role: true } })).map(
        (row) => ({ id: row.id, username: `platform/${row.username}`, role: row.role }),
      ),
    }));
  }

  /**
   * Lưu phân loại (Figma ADM-09b): khiếu nại mới → đang xử lý (Vé Xe Nhanh) hoặc chờ nhà xe (bên xử lý chính = nhà xe). Chuyển
   * nhà xe lần đầu → nhà xe thấy khiếu nại + nhận email.
   */
  async classify(authz: Authorization, actor: Actor, ticketId: string, input: ClassifyInput): Promise<TicketDetail> {
    const db = platformDb(authz);
    const { detail, keys } = await this.write(db, async (tx, deadline) => {
      const ticket = await lockTicket(tx, ticketId);
      if (!ticket) {
        throw supportTicketNotFound();
      }
      if (ticket.status === SupportStatus.CLOSED || ticket.status === SupportStatus.ESCALATED) {
        throw supportStateInvalid("Khiếu nại đã đóng hoặc đã chuyển tranh chấp — không phân loại lại.");
      }
      if (input.assigneeId && !(await tx.platformAccount.findFirst({ where: { id: input.assigneeId, status: AccountStatus.ACTIVE }, select: { id: true } }))) {
        throw supportAssigneeInvalid();
      }
      const now = new Date();
      const toOperator = input.handler === SupportHandler.OPERATOR && (ticket.handler !== SupportHandler.OPERATOR || ticket.status === SupportStatus.NEW);
      const status = toOperator
        ? SupportStatus.WAITING_OPERATOR
        : ticket.status === SupportStatus.NEW || (ticket.status === SupportStatus.WAITING_OPERATOR && input.handler === SupportHandler.PLATFORM)
          ? SupportStatus.IN_PROGRESS
          : ticket.status;
      await tx.supportTicket.update({
        where: { id: ticketId },
        data: {
          category: input.category,
          priority: input.priority,
          handler: input.handler,
          assigneeId: input.assigneeId,
          status,
          classifiedAt: ticket.classifiedAt ?? now,
          ...(toOperator && !ticket.sharedWithOperatorAt ? { sharedWithOperatorAt: now } : {}),
          ...(status !== ticket.status ? { lastMessageAt: now } : {}),
        },
      });
      await this.record(
        actor,
        "support.ticket.classify",
        ticketId,
        ticket.operatorId,
        { category: ticket.category, priority: ticket.priority, handler: ticket.handler, assigneeId: ticket.assigneeId, status: ticket.status },
        { ...input, status },
        deadline,
      );
      const key = toOperator
        ? await queueCaseNotice(tx, ticket.operatorId, {
            audience: "OPERATOR",
            bookingId: ticket.bookingId,
            dedupKey: `CASE_UPDATED:${ticketId}:forward:${now.getTime()}`,
            caseCode: ticket.ticketCode,
            title: "Khiếu nại cần nhà xe phản hồi",
            message: `Vé Xe Nhanh chuyển khiếu nại "${ticket.subject}" để nhà xe phản hồi khách.`,
          })
        : null;
      return { detail: (await loadDetail(tx, { id: ticketId }, "ADMIN", await assigneeNames(tx)))!, keys: key ? [key] : [] };
    });
    await this.notifications.dispatch(keys);
    return detail;
  }

  /** Vé Xe Nhanh trả lời khách; `requestInfo` → chờ khách bổ sung. Khách nhận email. */
  async adminReply(authz: Authorization, actor: Actor, ticketId: string, input: AdminMessageInput): Promise<TicketDetail> {
    const db = platformDb(authz);
    const operatorId = await this.prisma.withScope(db, async (tx) => (await tx.supportTicket.findUnique({ where: { id: ticketId }, select: { operatorId: true } }))?.operatorId);
    if (!operatorId) {
      throw supportTicketNotFound();
    }
    const files = await this.attachments.inspectAll({ operatorId, kind: "platform" }, input.attachments);
    const { detail, keys } = await this.write(db, async (tx, deadline) => {
      const ticket = await lockTicket(tx, ticketId);
      if (!ticket) {
        throw supportTicketNotFound();
      }
      if (ticket.status === SupportStatus.CLOSED) {
        throw supportStateInvalid("Khiếu nại đã đóng.");
      }
      const account = await tx.platformAccount.findUnique({ where: { id: actor.sub }, select: { username: true } });
      const now = new Date();
      const message = await tx.supportMessage.create({
        data: { ticketId, operatorId, party: CaseParty.PLATFORM, authorId: actor.sub, authorName: `platform/${account?.username ?? actor.sub}`, body: input.body, createdAt: now },
        select: { id: true },
      });
      await this.attachments.save(tx, operatorId, { messageId: message.id }, files);
      const status = input.requestInfo ? SupportStatus.WAITING_CUSTOMER : ticket.status === SupportStatus.NEW ? SupportStatus.IN_PROGRESS : ticket.status;
      await tx.supportTicket.update({ where: { id: ticketId }, data: { lastMessageAt: now, status } });
      await this.record(actor, input.requestInfo ? "support.ticket.request_info" : "support.ticket.reply", ticketId, operatorId, { status: ticket.status }, { status, messageId: message.id }, deadline);
      const key = await queueCaseNotice(tx, operatorId, {
        audience: "CUSTOMER",
        bookingId: ticket.bookingId,
        dedupKey: `CASE_UPDATED:${message.id}:CUSTOMER`,
        caseCode: ticket.ticketCode,
        title: input.requestInfo ? "Vé Xe Nhanh cần bạn bổ sung thông tin" : "Vé Xe Nhanh đã phản hồi khiếu nại của bạn",
        message: clip(input.body),
      });
      return { detail: (await loadDetail(tx, { id: ticketId }, "ADMIN", await assigneeNames(tx)))!, keys: key ? [key] : [] };
    });
    await this.notifications.dispatch(keys);
    return detail;
  }

  /** Đã giải quyết / đóng (FR-NSR-08). Khiếu nại đã chuyển tranh chấp đóng theo tranh chấp. */
  async setStatus(authz: Authorization, actor: Actor, ticketId: string, input: TicketStatusInput): Promise<TicketDetail> {
    const db = platformDb(authz);
    const { detail, keys } = await this.write(db, async (tx, deadline) => {
      const ticket = await lockTicket(tx, ticketId);
      if (!ticket) {
        throw supportTicketNotFound();
      }
      if (ticket.status === SupportStatus.CLOSED || ticket.status === SupportStatus.ESCALATED || ticket.status === input.status) {
        throw supportStateInvalid("Khiếu nại đã đóng, đã chuyển tranh chấp hoặc đã ở trạng thái này.");
      }
      const now = new Date();
      await tx.supportTicket.update({ where: { id: ticketId }, data: { status: input.status, resolvedAt: ticket.resolvedAt ?? now, lastMessageAt: now } });
      await this.record(actor, "support.ticket.status", ticketId, ticket.operatorId, { status: ticket.status }, { status: input.status }, deadline, input.note ?? undefined);
      const key = await queueCaseNotice(tx, ticket.operatorId, {
        audience: "CUSTOMER",
        bookingId: ticket.bookingId,
        dedupKey: `CASE_UPDATED:${ticketId}:${input.status}:${now.getTime()}`,
        caseCode: ticket.ticketCode,
        title: input.status === SupportStatus.RESOLVED ? "Khiếu nại đã được giải quyết" : "Khiếu nại đã đóng",
        message: input.note ?? `Khiếu nại "${ticket.subject}" ${input.status === SupportStatus.RESOLVED ? "đã được giải quyết" : "đã đóng"}.`,
      });
      return { detail: (await loadDetail(tx, { id: ticketId }, "ADMIN", await assigneeNames(tx)))!, keys: key ? [key] : [] };
    });
    await this.notifications.dispatch(keys);
    return detail;
  }

  /** Admin xin URL tải tệp cho khiếu nại / tranh chấp — khóa đặt dưới nhà xe của hồ sơ. */
  async adminUploadFor(authz: Authorization, target: { ticketId?: string; disputeId?: string }, input: AttachmentUploadInput): Promise<AttachmentUploadResponse> {
    const db = platformDb(authz);
    const operatorId = await this.prisma.withScope(db, async (tx) =>
      target.ticketId
        ? (await tx.supportTicket.findUnique({ where: { id: target.ticketId }, select: { operatorId: true } }))?.operatorId
        : (await tx.disputeCase.findUnique({ where: { id: target.disputeId }, select: { operatorId: true } }))?.operatorId,
    );
    if (!operatorId) {
      throw supportTicketNotFound();
    }
    return this.attachments.createUpload({ operatorId, kind: "platform" } satisfies AttachmentOwner, input);
  }

  async adminDownload(authz: Authorization, actor: Actor, attachmentId: string): Promise<DownloadUrlResponse> {
    const attachment = await this.prisma.withScope(platformDb(authz), (tx) =>
      tx.supportAttachment.findUnique({ where: { id: attachmentId }, select: { id: true, objectKey: true, fileName: true, operatorId: true } }),
    );
    return this.attachments.createDownload(attachment, { id: actor.sub, role: actor.role });
  }

  // ------------------------------------------------------------------ Nội bộ

  /** Chạy ở tenant của đơn nếu người gọi có quyền với đơn (hành khách sở hữu / khách vãng lai có mã truy cập); không → 404. */
  private async asCustomer<T>(user: VerifiedAccessToken | null, bookingId: string, token: string | undefined, work: (tx: DbTransaction, operatorId: string) => Promise<T>): Promise<T> {
    const result = await withBookingOperator(this.prisma, bookingId, async (tx, operatorId) => {
      const booking = await tx.booking.findFirst({ where: { id: bookingId, operatorId }, select: { userId: true, accessTokenHash: true, accessGrants: ACCESS_GRANT_SELECT } });
      if (!booking || !canAccessBooking(booking, user, token)) {
        return { found: false as const };
      }
      return { found: true as const, value: await work(tx, operatorId) };
    });
    if (!result?.found) {
      throw supportTicketNotFound();
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

  private record(actor: Actor, action: string, ticketId: string, operatorId: string, before: Record<string, unknown>, after: Record<string, unknown>, deadline: number, reason?: string): Promise<void> {
    return this.audit.recordAuditEvent(
      { actorId: actor.sub, actorRole: actor.role, action, targetType: "support_ticket", targetId: ticketId, operatorId, before, after, ...(reason ? { reason } : {}) },
      { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
    );
  }
}

/** Khoá dòng khiếu nại (thao tác đồng thời trên cùng khiếu nại chạy lần lượt). */
async function lockTicket(tx: DbTransaction, ticketId: string, operatorId?: string) {
  const [row] = await tx.$queryRaw<{ id: string }[]>`SELECT id FROM support_tickets WHERE id = ${ticketId} FOR UPDATE`;
  if (!row) {
    return null;
  }
  return tx.supportTicket.findFirst({
    where: { id: ticketId, ...(operatorId ? { operatorId } : {}) },
    select: {
      ticketCode: true,
      operatorId: true,
      bookingId: true,
      userId: true,
      reporterParty: true,
      reporterName: true,
      subject: true,
      category: true,
      priority: true,
      handler: true,
      assigneeId: true,
      status: true,
      sharedWithOperatorAt: true,
      classifiedAt: true,
      resolvedAt: true,
    },
  });
}

async function page(
  tx: DbTransaction,
  where: TicketWhere,
  query: { cursor?: string; limit: number },
  names: Map<string, string>,
  countScope: TicketWhere,
): Promise<TicketPage> {
  const rows = await tx.supportTicket.findMany({
    where,
    orderBy: [{ lastMessageAt: "desc" }, { id: "desc" }],
    take: query.limit + 1,
    ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
    select: SUMMARY_SELECT,
  });
  const more = rows.length > query.limit;
  const items = rows.slice(0, query.limit);
  return {
    items: items.map((row) => toSummary(row, names)),
    nextCursor: more ? items.at(-1)!.id : null,
    total: await tx.supportTicket.count({ where }),
    unclassified: await tx.supportTicket.count({ where: { ...countScope, status: SupportStatus.NEW } }),
  };
}

async function assigneeNames(tx: DbTransaction): Promise<Map<string, string>> {
  const rows = await tx.platformAccount.findMany({ select: { id: true, username: true } });
  return new Map(rows.map((row) => [row.id, `platform/${row.username}`]));
}

/** `names` = tên người phụ trách (chỉ Admin); `null` → không lộ người phụ trách. */
function toSummary(row: SummaryRow, names: Map<string, string> | null): TicketSummary {
  const dispute = row.disputes[0] ?? null;
  return {
    ticketId: row.id,
    ticketCode: row.ticketCode,
    subject: row.subject,
    bookingId: row.bookingId,
    bookingCode: row.booking.bookingCode,
    operatorId: row.operatorId,
    operatorName: row.operator.displayName,
    reporterParty: row.reporterParty,
    reporterName: row.reporterName,
    category: row.category,
    priority: row.priority,
    handler: row.handler,
    status: row.status,
    assignee: names && row.assigneeId ? { id: row.assigneeId, username: names.get(row.assigneeId) ?? "Tài khoản không còn" } : null,
    disputeId: dispute?.id ?? null,
    createdAt: row.createdAt.toISOString(),
    lastMessageAt: row.lastMessageAt.toISOString(),
  };
}

async function loadDetail(tx: DbTransaction, where: TicketWhere, view: View, names: Map<string, string>): Promise<TicketDetail | null> {
  const row = await tx.supportTicket.findFirst({
    where,
    select: {
      ...SUMMARY_SELECT,
      booking: {
        select: {
          bookingCode: true,
          contactEmail: true,
          trip: { select: { id: true, departureAt: true, route: { select: { name: true } }, vehicle: { select: { plateNumber: true } } } },
          payments: { orderBy: { createdAt: "asc" }, select: { id: true, paymentCode: true, provider: true, status: true, amount: true } },
          tickets: { where: { status: { in: SOLD } }, select: { id: true } },
        },
      },
      messages: {
        orderBy: { createdAt: "asc" },
        select: {
          id: true,
          party: true,
          authorName: true,
          body: true,
          createdAt: true,
          attachments: { orderBy: { createdAt: "asc" }, select: { id: true, fileName: true, contentType: true, sizeBytes: true } },
        },
      },
    },
  });
  if (!row) {
    return null;
  }
  const dispute = row.disputes[0] ?? null;
  return {
    ...toSummary(row, view === "ADMIN" ? names : null),
    requestedPriority: row.requestedPriority,
    contactEmailMasked: view === "ADMIN" ? maskEmail(row.booking.contactEmail) : null,
    trip: {
      tripId: row.booking.trip.id,
      routeName: row.booking.trip.route.name,
      departureAt: row.booking.trip.departureAt.toISOString(),
      vehiclePlateNumber: row.booking.trip.vehicle?.plateNumber ?? null,
    },
    messages: row.messages.map((message) => ({
      messageId: message.id,
      party: message.party,
      authorName: message.party === CaseParty.PLATFORM && view !== "ADMIN" ? PLATFORM_DISPLAY_NAME : message.authorName,
      body: message.body,
      createdAt: message.createdAt.toISOString(),
      attachments: message.attachments.map((file) => ({ attachmentId: file.id, fileName: file.fileName, contentType: file.contentType, sizeBytes: file.sizeBytes })),
    })),
    payments: row.booking.payments
      .filter((payment) => view === "ADMIN" || payment.status === PaymentStatus.SUCCESS)
      .map((payment) => ({ paymentId: payment.id, paymentCode: payment.paymentCode, provider: payment.provider, status: payment.status, amount: Number(payment.amount) })),
    validTickets: row.booking.tickets.length,
    dispute: dispute ? { disputeId: dispute.id, disputeCode: dispute.disputeCode, status: dispute.status } : null,
  };
}

function vnDay(at: Date): string {
  return new Date(at.getTime() + VN_OFFSET_MS).toISOString().slice(0, 10).replace(/-/g, "");
}

/** Đoạn trích ngắn cho email (nội dung đầy đủ xem trên ứng dụng). */
export function clip(text: string, max = 300): string {
  const flat = text.replace(/\s+/g, " ").trim();
  return flat.length > max ? `${flat.slice(0, max - 1)}…` : flat;
}

export function platformDb(authz: Authorization): DbScope {
  if (authz.db?.kind !== "platform") {
    // Lỗi lập trình: route Admin thiếu `@Authorize` với quyền chỉ role Platform có.
    throw new Error("Route Admin khiếu nại / tranh chấp cần ngữ cảnh DB platform.");
  }
  return authz.db;
}
