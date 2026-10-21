import type { DbTransaction, PrismaService } from "./prisma.service";

// Ngữ cảnh RLS cho job VXN Plus (TASK-LOY-001): sổ điểm chỉ platform / system đọc ghi, còn số tiền căn cứ nằm ở đơn / vé / hoàn tiền
// của từng nhà xe — job chạy ở scope `system` để đọc cả hai trong một transaction. Đặt ở `database/` vì chỉ ở đây được chọn scope.

/** Đơn của hành khách có tài khoản (BR-65), đã thanh toán, chuyến hoàn thành từ `since`, chưa được cộng điểm (BR-66). */
export async function listEarnCandidates(prisma: Pick<PrismaService, "withSystem">, since: Date, limit: number): Promise<string[]> {
  const rows = await prisma.withSystem((tx) =>
    tx.$queryRaw<{ id: string }[]>`
      SELECT b.id FROM bookings b
      JOIN trips t ON t.id = b.trip_id AND t.operator_id = b.operator_id
      WHERE b.user_id IS NOT NULL AND b.paid_at IS NOT NULL AND t.status = 'COMPLETED'
        AND COALESCE(t.completed_at, t.arrival_at) >= ${since}
        AND NOT EXISTS (SELECT 1 FROM loyalty_point_transactions l WHERE l.idempotency_key = 'EARN:' || b.id)
      ORDER BY COALESCE(t.completed_at, t.arrival_at), b.id
      LIMIT ${limit}`,
  );
  return rows.map((row) => row.id);
}

/**
 * Hoàn tiền thành công SAU khi đơn đã được cộng điểm mà chưa thu hồi (BR-67). Hoàn gắn vé tạo trước lúc tích thì vé đó đã bị loại
 * khỏi số tiền căn cứ nên bỏ qua; hoàn theo số tiền (quyết định tranh chấp, không gắn vé) tính theo thời điểm hoàn xong.
 */
export async function listReversalCandidates(prisma: Pick<PrismaService, "withSystem">, limit: number): Promise<{ refundId: string; bookingId: string }[]> {
  return prisma.withSystem((tx) =>
    tx.$queryRaw<{ refundId: string; bookingId: string }[]>`
      SELECT r.id AS "refundId", r.booking_id AS "bookingId" FROM refunds r
      JOIN loyalty_point_transactions e ON e.idempotency_key = 'EARN:' || r.booking_id
      WHERE r.status = 'SUCCESS' AND COALESCE(r.processed_at, r.updated_at) > e.created_at
        AND (r.created_at > e.created_at OR NOT EXISTS (SELECT 1 FROM tickets k WHERE k.refund_id = r.id))
        AND NOT EXISTS (SELECT 1 FROM loyalty_point_transactions v WHERE v.idempotency_key = 'REVERSAL:' || r.id)
      ORDER BY COALESCE(r.processed_at, r.updated_at), r.id
      LIMIT ${limit}`,
  );
}

/** Tài khoản có lô điểm tới hạn sau lần quét trước (BR-70). */
export async function listExpiryCandidates(prisma: Pick<PrismaService, "withSystem">, now: Date, limit: number): Promise<string[]> {
  const rows = await prisma.withSystem((tx) =>
    tx.$queryRaw<{ id: string }[]>`
      SELECT a.id FROM loyalty_accounts a
      WHERE EXISTS (
        SELECT 1 FROM loyalty_point_transactions l
        WHERE l.account_id = a.id AND l.expires_at <= ${now} AND (a.expired_through IS NULL OR l.expires_at > a.expired_through)
      )
      ORDER BY a.id
      LIMIT ${limit}`,
  );
  return rows.map((row) => row.id);
}

/** Chạy một bước của job VXN Plus (một đơn / một lần hoàn / một tài khoản) trong transaction scope `system`. */
export function withLoyaltySystem<T>(prisma: Pick<PrismaService, "withSystem">, work: (tx: DbTransaction) => Promise<T>): Promise<T> {
  return prisma.withSystem(work);
}
