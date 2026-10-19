import type { DbTransaction, PrismaService } from "./prisma.service";
import type { PaymentProvider, PaymentStatus } from "./prisma.types";

// Ngữ cảnh RLS cho luồng khách đặt vé / thanh toán (TASK-BTP-002+): token của khách vãng lai / hành khách KHÔNG mang tenant,
// nên tenant lấy từ chính chuyến / booking ở server (không bao giờ từ body). Đặt ở `database/` vì chỉ ở đây được chọn scope.
// Mọi thao tác ghi sau đó chạy ở tenant của nhà xe sở hữu — RLS vẫn chặn đụng dữ liệu nhà xe khác.

type ScopedPrisma = Pick<PrismaService, "withSystem" | "withTenant">;

/** Chạy `work` ở tenant của nhà xe sở hữu chuyến; chuyến không có → `null`. */
export async function withTripOperator<T>(
  prisma: ScopedPrisma,
  tripId: string,
  work: (tx: DbTransaction, operatorId: string) => Promise<T>,
): Promise<T | null> {
  const trip = await prisma.withSystem((tx) => tx.trip.findUnique({ where: { id: tripId }, select: { operatorId: true } }));
  return trip ? prisma.withTenant(trip.operatorId, (tx) => work(tx, trip.operatorId)) : null;
}

/** Chạy `work` ở tenant của nhà xe sở hữu booking; booking không có → `null`. */
export async function withBookingOperator<T>(
  prisma: ScopedPrisma,
  bookingId: string,
  work: (tx: DbTransaction, operatorId: string) => Promise<T>,
): Promise<T | null> {
  const booking = await prisma.withSystem((tx) => tx.booking.findUnique({ where: { id: bookingId }, select: { operatorId: true } }));
  return booking ? prisma.withTenant(booking.operatorId, (tx) => work(tx, booking.operatorId)) : null;
}

/** Có booking nào đã dùng phiên giữ chỗ này chưa (mọi nhà xe) — phân biệt gửi lặp với trùng mã booking. */
export async function bookingIdOfHold(prisma: Pick<PrismaService, "withSystem">, holdId: string): Promise<string | null> {
  const booking = await prisma.withSystem((tx) => tx.booking.findUnique({ where: { holdId }, select: { id: true } }));
  return booking?.id ?? null;
}

/** Booking chờ thanh toán đã quá hạn (mọi nhà xe) — job nền chuyển `EXPIRED` + trả chỗ. */
export async function listOverduePendingBookings(
  prisma: Pick<PrismaService, "withSystem">,
  now: Date,
  limit: number,
): Promise<string[]> {
  const rows = await prisma.withSystem((tx) =>
    tx.booking.findMany({
      where: { status: "PENDING_PAYMENT", expiresAt: { lte: now } },
      orderBy: { expiresAt: "asc" },
      take: limit,
      select: { id: true },
    }),
  );
  return rows.map((row) => row.id);
}

/** Payment theo mã gửi cổng (mọi nhà xe) — webhook kiểm nhanh trước khi xếp hàng xử lý (mã IPN VNPay). */
export async function findPaymentByCode(
  prisma: Pick<PrismaService, "withSystem">,
  paymentCode: string,
): Promise<{ provider: PaymentProvider; status: PaymentStatus; amount: bigint } | null> {
  return prisma.withSystem((tx) =>
    tx.payment.findUnique({ where: { paymentCode }, select: { provider: true, status: true, amount: true } }),
  );
}

/** Chạy `work` ở tenant của nhà xe sở hữu payment (theo mã gửi cổng); không có → `null`. */
export async function withPaymentOperator<T>(
  prisma: ScopedPrisma,
  paymentCode: string,
  work: (tx: DbTransaction, operatorId: string) => Promise<T>,
): Promise<T | null> {
  const payment = await prisma.withSystem((tx) => tx.payment.findUnique({ where: { paymentCode }, select: { operatorId: true } }));
  return payment ? prisma.withTenant(payment.operatorId, (tx) => work(tx, payment.operatorId)) : null;
}

/** Chạy `work` ở tenant của nhà xe sở hữu vé; không có → `null`. */
export async function withTicketOperator<T>(
  prisma: ScopedPrisma,
  ticketId: string,
  work: (tx: DbTransaction, operatorId: string) => Promise<T>,
): Promise<T | null> {
  const ticket = await prisma.withSystem((tx) => tx.ticket.findUnique({ where: { id: ticketId }, select: { operatorId: true } }));
  return ticket ? prisma.withTenant(ticket.operatorId, (tx) => work(tx, ticket.operatorId)) : null;
}

/** Booking theo mã (mọi nhà xe) — tra cứu vé của khách vãng lai. */
export async function bookingIdOfCode(prisma: Pick<PrismaService, "withSystem">, bookingCode: string): Promise<string | null> {
  const booking = await prisma.withSystem((tx) => tx.booking.findUnique({ where: { bookingCode }, select: { id: true } }));
  return booking?.id ?? null;
}

/** Chạy `work` ở tenant của nhà xe sở hữu refund (job hoàn tiền ở worker); không có → `null`. */
export async function withRefundOperator<T>(
  prisma: ScopedPrisma,
  refundId: string,
  work: (tx: DbTransaction, operatorId: string) => Promise<T>,
): Promise<T | null> {
  const refund = await prisma.withSystem((tx) => tx.refund.findUnique({ where: { id: refundId }, select: { operatorId: true } }));
  return refund ? prisma.withTenant(refund.operatorId, (tx) => work(tx, refund.operatorId)) : null;
}

/** Thanh toán cần tra cứu cổng (job đối soát — FR-BTP-17): chưa có kết quả cuối, đã quá hạn, tạo trong `since`, chưa tra gần đây. */
export async function listPaymentsToReconcile(
  prisma: Pick<PrismaService, "withSystem">,
  filter: { expiredBefore: Date; createdAfter: Date; checkedBefore: Date; limit: number },
): Promise<{ id: string; operatorId: string; paymentCode: string; provider: PaymentProvider; status: PaymentStatus; amount: bigint; createdAt: Date }[]> {
  return prisma.withSystem((tx) =>
    tx.payment.findMany({
      where: {
        status: { in: ["INITIATED", "PROCESSING", "EXPIRED", "CANCELLED"] },
        expiresAt: { lt: filter.expiredBefore },
        createdAt: { gt: filter.createdAfter },
        OR: [{ providerCheckedAt: null }, { providerCheckedAt: { lt: filter.checkedBefore } }],
      },
      orderBy: { createdAt: "asc" },
      take: filter.limit,
      select: { id: true, operatorId: true, paymentCode: true, provider: true, status: true, amount: true, createdAt: true },
    }),
  );
}

/** Refund `APPROVED` quá lâu chưa được worker nhận (xếp hàng lỗi / mất job) — job đối soát xếp hàng lại. */
export async function listStuckRefunds(prisma: Pick<PrismaService, "withSystem">, updatedBefore: Date, limit: number): Promise<{ id: string; attempt: number }[]> {
  return prisma.withSystem((tx) =>
    tx.refund.findMany({ where: { status: "APPROVED", updatedAt: { lt: updatedBefore } }, orderBy: { updatedAt: "asc" }, take: limit, select: { id: true, attempt: true } }),
  );
}
