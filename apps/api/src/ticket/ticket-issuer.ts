import { randomUUID } from "node:crypto";
import type { DbTransaction } from "../database/prisma.service";
import { TicketQrSigner } from "./ticket-qr";

/**
 * Phát hành vé cho mọi chỗ của booking (TASK-BTP-004, FR-BTP-10/11, BR-04/25): mỗi chỗ một vé `VALID`, mã = mã booking +
 * số thứ tự chỗ (theo mã chỗ), QR hash. Gọi TRONG transaction ghi nhận thanh toán thành công (LLD §6.3 bước 3).
 * Idempotent: chỗ đã có vé thì bỏ qua (unique `passenger_info_id`). Trả số vé mới tạo.
 */
export async function issueTickets(
  tx: DbTransaction,
  operatorId: string,
  bookingId: string,
  qr: TicketQrSigner,
  now: Date,
  actor: string,
): Promise<number> {
  const booking = await tx.booking.findFirstOrThrow({
    where: { id: bookingId, operatorId },
    select: { bookingCode: true, tripId: true, passengers: { orderBy: { seatCode: "asc" }, select: { id: true, seatCode: true } } },
  });
  const tickets = booking.passengers.map((passenger, index) => {
    const id = randomUUID();
    return {
      id,
      ticketCode: `${booking.bookingCode}-${String(index + 1).padStart(2, "0")}`,
      operatorId,
      bookingId,
      tripId: booking.tripId,
      passengerInfoId: passenger.id,
      seatCode: passenger.seatCode,
      qrTokenHash: TicketQrSigner.hash(qr.token(id)),
      issuedAt: now,
    };
  });
  const created = await tx.ticket.createMany({ data: tickets, skipDuplicates: true });
  if (created.count > 0) {
    const issued = await tx.ticket.findMany({ where: { id: { in: tickets.map((ticket) => ticket.id) }, operatorId }, select: { id: true } });
    await tx.ticketStatusHistory.createMany({
      data: issued.map((ticket) => ({ ticketId: ticket.id, operatorId, fromStatus: null, toStatus: "VALID" as const, reason: "Phát hành vé.", actor })),
    });
  }
  return created.count;
}
