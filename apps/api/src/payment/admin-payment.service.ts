import { Inject, Injectable } from "@nestjs/common";
import type { DbScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import { EscrowEntryType, PaymentStatus, RefundStatus, type PaymentProvider } from "../database/prisma.types";
import { vndToJson } from "../fare/fare-pricing";
import type { Authorization } from "../iam/role/authorization";
import type { AdminPaymentDetail, AdminPaymentPage, AdminPaymentSummary } from "./dto/admin-payment.dto";
import { paymentNotFound } from "./payment.errors";

const DAY_MS = 86_400_000;
/** Refund đã / đang hoàn cho thanh toán cần đối soát → coi là đã có hướng xử lý (refund `FAILED` / `REJECTED` thì chưa). */
const RECONCILE_HANDLED: RefundStatus[] = [RefundStatus.REQUESTED, RefundStatus.APPROVED, RefundStatus.PROCESSING, RefundStatus.SUCCESS];
const RECONCILE_OPEN = { status: PaymentStatus.RECONCILING, refunds: { none: { status: { in: RECONCILE_HANDLED } } } };

type ListQuery = {
  from?: string;
  to?: string;
  operatorId?: string;
  provider?: PaymentProvider;
  status?: PaymentStatus;
  reconcile?: "open";
  q?: string;
  cursor?: string;
  limit: number;
};

const SUMMARY_SELECT = {
  id: true,
  paymentCode: true,
  bookingId: true,
  operatorId: true,
  provider: true,
  amount: true,
  status: true,
  reconcileReason: true,
  failureCode: true,
  createdAt: true,
  paidAt: true,
  booking: { select: { bookingCode: true, operator: { select: { displayName: true } } } },
  refunds: { select: { status: true } },
} as const;

type SummaryRow = {
  id: string;
  paymentCode: string;
  bookingId: string;
  operatorId: string;
  provider: PaymentProvider;
  amount: bigint;
  status: PaymentStatus;
  reconcileReason: string | null;
  failureCode: string | null;
  createdAt: Date;
  paidAt: Date | null;
  booking: { bookingCode: string; operator: { displayName: string } };
  refunds: { status: RefundStatus }[];
};

/**
 * Giám sát thanh toán toàn hệ thống phía Admin (TASK-ADM-002, FR-ADM-10, FR-BTP-17, UC-32; Figma ADM-07a–b): danh sách lọc
 * theo ngày / nhà xe / cổng / trạng thái, tab "Cần đối soát" (thanh toán `RECONCILING` chưa có hướng xử lý), chi tiết truy
 * vết booking → thanh toán → vé → sổ giữ hộ → hoàn tiền. Chỉ đọc; thao tác hoàn tiền ở `refund/admin-refund.service.ts`.
 */
@Injectable()
export class AdminPaymentService {
  constructor(@Inject(PrismaService) private readonly prisma: PrismaService) {}

  async list(authz: Authorization, query: ListQuery): Promise<AdminPaymentPage> {
    const code = query.q?.toUpperCase();
    const where = {
      operatorId: query.operatorId,
      provider: query.provider,
      status: query.status,
      createdAt: {
        ...(query.from ? { gte: vnDayStart(query.from) } : {}),
        ...(query.to ? { lt: new Date(vnDayStart(query.to).getTime() + DAY_MS) } : {}),
      },
      ...(query.reconcile === "open" ? RECONCILE_OPEN : {}),
      ...(query.q
        ? {
            OR: [
              { paymentCode: { contains: code } },
              { providerTxnId: { contains: query.q } },
              { booking: { bookingCode: { contains: code } } },
              // SĐT / email người đặt — tra được cả đơn khách vãng lai (không có tài khoản; chờ duyệt 28/10/2026).
              { booking: { contactPhone: { contains: query.q.replace(/[\s.-]/g, "") } } },
              { booking: { contactEmail: { contains: query.q, mode: "insensitive" as const } } },
            ],
          }
        : {}),
    };
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      let after = {};
      if (query.cursor) {
        const cursor = await tx.payment.findUnique({ where: { id: query.cursor }, select: { id: true, createdAt: true } });
        if (cursor) {
          after = { OR: [{ createdAt: { lt: cursor.createdAt } }, { createdAt: cursor.createdAt, id: { lt: cursor.id } }] };
        }
      }
      // Tuần tự: một transaction là một kết nối.
      const rows = await tx.payment.findMany({
        where: { AND: [where, after] },
        orderBy: [{ createdAt: "desc" }, { id: "desc" }],
        take: query.limit + 1,
        select: SUMMARY_SELECT,
      });
      const total = await tx.payment.count({ where });
      const reconcileOpen = await tx.payment.count({ where: RECONCILE_OPEN });
      const page = rows.slice(0, query.limit);
      return { items: page.map(toSummary), nextCursor: rows.length > query.limit ? page[page.length - 1]!.id : null, total, reconcileOpen };
    });
  }

  async get(authz: Authorization, paymentId: string): Promise<AdminPaymentDetail> {
    const row = await this.prisma.withScope(platformDb(authz), (tx) =>
      tx.payment.findUnique({
        where: { id: paymentId },
        select: {
          ...SUMMARY_SELECT,
          providerTxnId: true,
          expiresAt: true,
          booking: {
            select: {
              bookingCode: true,
              status: true,
              contactName: true,
              subtotal: true,
              serviceFee: true,
              discount: true,
              total: true,
              snapshot: true,
              createdAt: true,
              operator: { select: { displayName: true } },
              passengers: { orderBy: { seatCode: "asc" }, select: { seatCode: true } },
              tickets: { orderBy: { ticketCode: "asc" }, select: { ticketCode: true, seatCode: true, status: true, issuedAt: true } },
            },
          },
          histories: { orderBy: [{ createdAt: "asc" }, { id: "asc" }], select: { fromStatus: true, toStatus: true, reason: true, actor: true, createdAt: true } },
          refunds: { orderBy: { createdAt: "asc" }, select: { id: true, refundCode: true, status: true, amount: true, createdAt: true } },
          ledger: { orderBy: [{ createdAt: "asc" }, { entryType: "asc" }], select: { entryType: true, amount: true, commissionRateBps: true, eligibleAt: true, createdAt: true } },
        },
      }),
    );
    if (!row) {
      throw paymentNotFound();
    }
    const trip = (row.booking.snapshot as { trip: { routeName: string; departureAt: string } }).trip;
    const capture = row.ledger.filter((entry) => entry.entryType === EscrowEntryType.PAYMENT_CAPTURED).reduce((sum, entry) => sum + entry.amount, 0n);
    const commissionEntries = row.ledger.filter((entry) => entry.entryType === EscrowEntryType.COMMISSION);
    const commission = -commissionEntries.reduce((sum, entry) => sum + entry.amount, 0n);
    const callbacks = row.histories.filter((history) => history.actor?.startsWith("provider:"));
    const summary = toSummary(row);
    return {
      ...summary,
      providerTxnId: row.providerTxnId,
      expiresAt: row.expiresAt.toISOString(),
      lastCallbackAt: callbacks.length > 0 ? callbacks[callbacks.length - 1]!.createdAt.toISOString() : null,
      amountMatches: row.status === PaymentStatus.SUCCESS ? true : row.status === PaymentStatus.RECONCILING ? row.reconcileReason !== "AMOUNT_MISMATCH" : null,
      booking: {
        status: row.booking.status,
        routeName: trip.routeName,
        departureAt: trip.departureAt,
        contactName: maskName(row.booking.contactName),
        seatCodes: row.booking.passengers.map((passenger) => passenger.seatCode),
        subtotal: vndToJson(row.booking.subtotal),
        serviceFee: vndToJson(row.booking.serviceFee),
        discount: vndToJson(row.booking.discount),
        total: vndToJson(row.booking.total),
        createdAt: row.booking.createdAt.toISOString(),
      },
      allocation:
        capture > 0n
          ? { commissionAmount: vndToJson(commission), commissionRateBps: commissionEntries[0]?.commissionRateBps ?? null, operatorNet: vndToJson(capture - commission) }
          : null,
      histories: row.histories.map((history) => ({ ...history, actor: actorLabel(history.actor), createdAt: history.createdAt.toISOString() })),
      // Vé phát hành khi thanh toán này được nhận vào booking (thanh toán cần đối soát / thất bại không phát hành vé).
      tickets:
        row.status === PaymentStatus.SUCCESS
          ? row.booking.tickets.map((ticket) => ({ ticketCode: ticket.ticketCode, seatCode: ticket.seatCode, status: ticket.status, issuedAt: ticket.issuedAt.toISOString() }))
          : [],
      ledger: row.ledger.map((entry) => ({ entryType: entry.entryType, amount: signedJson(entry.amount), eligibleAt: entry.eligibleAt.toISOString(), createdAt: entry.createdAt.toISOString() })),
      refunds: row.refunds.map((refund) => ({ refundId: refund.id, refundCode: refund.refundCode, status: refund.status, amount: vndToJson(refund.amount), createdAt: refund.createdAt.toISOString() })),
      canRefund: row.status === PaymentStatus.RECONCILING && !summary.reconcileResolved && row.reconcileReason !== "AMOUNT_MISMATCH" && row.providerTxnId !== null,
    };
  }
}

function toSummary(row: SummaryRow): AdminPaymentSummary {
  return {
    paymentId: row.id,
    paymentCode: row.paymentCode,
    bookingId: row.bookingId,
    bookingCode: row.booking.bookingCode,
    operatorId: row.operatorId,
    operatorName: row.booking.operator.displayName,
    provider: row.provider,
    amount: vndToJson(row.amount),
    status: row.status,
    reconcileReason: row.reconcileReason,
    failureCode: row.failureCode,
    reconcileResolved: row.status === PaymentStatus.RECONCILING && row.refunds.some((refund) => RECONCILE_HANDLED.includes(refund.status)),
    createdAt: row.createdAt.toISOString(),
    paidAt: row.paidAt?.toISOString() ?? null,
  };
}

/** Bút toán sổ giữ hộ có dấu (− hoa hồng / hoàn tiền). */
function signedJson(value: bigint): number {
  return value < 0n ? -vndToJson(-value) : vndToJson(value);
}

/** `2026-10-13` → 00:00 giờ VN ngày đó. */
function vnDayStart(date: string): Date {
  return new Date(`${date}T00:00:00+07:00`);
}

/** Che tên người liên hệ: giữ các chữ trước, chữ cuối còn ký tự đầu (`Nguyễn Văn Khánh` → `Nguyễn Văn K***`). */
export function maskName(name: string): string {
  const words = name.trim().split(/\s+/);
  const last = words.pop() ?? "";
  return [...words, `${[...last][0] ?? ""}***`].join(" ");
}

/** Người thao tác trong lịch sử thanh toán: cổng / khách / hệ thống (`null`). */
function actorLabel(actor: string | null): string | null {
  if (!actor || actor === "system") {
    return null;
  }
  if (actor.startsWith("provider:")) {
    return actor === "provider:VNPAY" ? "Cổng VNPay" : actor === "provider:MOMO" ? "Cổng MoMo" : "Cổng thanh toán";
  }
  return actor === "guest" || actor.startsWith("user:") ? "Khách hàng" : "Vé Xe Nhanh";
}

function platformDb(authz: Authorization): DbScope {
  if (authz.db?.kind !== "platform") {
    // Lỗi lập trình: route Admin thiếu `@Authorize` với quyền phạm vi `any`.
    throw new Error("Route Admin thanh toán cần ngữ cảnh DB platform.");
  }
  return authz.db;
}
