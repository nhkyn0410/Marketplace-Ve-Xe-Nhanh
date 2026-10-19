import { listOverduePendingBookings, withBookingOperator } from "../database/marketplace-scope";
import type { DbTransaction, PrismaService } from "../database/prisma.service";
import { BookingStatus } from "../database/prisma.types";
import { releaseRedemption } from "../promotion/promotion-apply";

// Hết hạn thanh toán (TASK-BTP-002, FR-BTP-05, SRS §17.6 `PENDING_PAYMENT → EXPIRED`): job nền mỗi phút quét booking chờ
// thanh toán đã quá hạn, chuyển `EXPIRED` + trả ghế. `GET /bookings/{id}` cũng gọi `expireBooking` khi job chưa kịp quét.

export const BOOKING_EXPIRY_JOB = "booking-expiry";
/** Mỗi phút: hạn thanh toán 10 phút, ghế trả lại chậm nhất ~1 phút sau hạn. */
export const BOOKING_EXPIRY_SCHEDULE = { every: 60_000 } as const;
/** Một lượt quét tối đa bấy nhiêu booking; còn thì lượt sau quét tiếp. */
const BATCH = 200;

/**
 * Chuyển một booking chờ thanh toán đã quá hạn sang `EXPIRED` + trả ghế `HOLDING` về `AVAILABLE` + ghi lịch sử. Có điều
 * kiện (còn `PENDING_PAYMENT`, đã quá hạn) nên chạy lặp / song song an toàn; trả `false` khi không có gì để đổi.
 */
export async function expireBooking(tx: DbTransaction, operatorId: string, bookingId: string, now: Date): Promise<boolean> {
  const updated = await tx.booking.updateMany({
    where: { id: bookingId, operatorId, status: BookingStatus.PENDING_PAYMENT, expiresAt: { lte: now } },
    data: { status: BookingStatus.EXPIRED },
  });
  if (updated.count === 0) {
    return false;
  }
  await tx.tripSeat.updateMany({
    where: { bookingId, operatorId, status: "HOLDING" },
    data: { status: "AVAILABLE", bookingId: null },
  });
  // Mã khuyến mãi đang giữ cho đơn → trả lượt dùng (BR-72).
  await releaseRedemption(tx, operatorId, bookingId);
  // Payment đang mở của booking hết hiệu lực theo (SRS §17.8); callback thành công đến sau → đối soát (BTP-003).
  const open = await tx.payment.findMany({
    where: { bookingId, operatorId, status: { in: ["INITIATED", "PROCESSING"] } },
    select: { id: true, status: true },
  });
  if (open.length > 0) {
    await tx.payment.updateMany({ where: { id: { in: open.map((payment) => payment.id) }, status: { in: ["INITIATED", "PROCESSING"] } }, data: { status: "EXPIRED" } });
    await tx.paymentStatusHistory.createMany({
      data: open.map((payment) => ({ paymentId: payment.id, operatorId, fromStatus: payment.status, toStatus: "EXPIRED" as const, reason: "Booking quá hạn thanh toán.", actor: "system" })),
    });
  }
  await tx.bookingStatusHistory.create({
    data: {
      bookingId,
      operatorId,
      fromStatus: BookingStatus.PENDING_PAYMENT,
      toStatus: BookingStatus.EXPIRED,
      reason: "Quá hạn thanh toán.",
      actor: "system",
    },
  });
  return true;
}

/** Quét + chuyển `EXPIRED` các booking quá hạn của mọi nhà xe; mỗi booking một transaction ở tenant của nhà xe. */
export async function expireOverdueBookings(
  prisma: Pick<PrismaService, "withSystem" | "withTenant">,
  now: Date = new Date(),
): Promise<number> {
  let expired = 0;
  for (const bookingId of await listOverduePendingBookings(prisma, now, BATCH)) {
    if (await withBookingOperator(prisma, bookingId, (tx, operatorId) => expireBooking(tx, operatorId, bookingId, now))) {
      expired++;
    }
  }
  return expired;
}
