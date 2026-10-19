import type { DbTransaction } from "../database/prisma.service";
import { AccountStatus, NotificationKind, OperatorRole } from "../database/prisma.types";
import { queueNotification } from "../notification/notification-outbox";

export type CaseNotice = {
  audience: "CUSTOMER" | "OPERATOR";
  bookingId: string;
  /** Khoá chống trùng theo sự kiện (vd `CASE_UPDATED:{messageId}:CUSTOMER`). */
  dedupKey: string;
  caseCode: string;
  title: string;
  message: string;
};

/**
 * Ghi thông báo cập nhật khiếu nại / tranh chấp (FR-DSP-07) CÙNG transaction nghiệp vụ; người gọi xếp hàng gửi sau commit theo
 * `dedupKey`. Khách nhận qua email liên hệ của đơn, nhà xe qua email chủ nhà xe. Không có email → bỏ qua. Trả `dedupKey` đã ghi.
 */
export async function queueCaseNotice(tx: DbTransaction, operatorId: string, notice: CaseNotice): Promise<string | null> {
  const recipientEmail =
    notice.audience === "CUSTOMER"
      ? (await tx.booking.findFirst({ where: { id: notice.bookingId, operatorId }, select: { contactEmail: true } }))?.contactEmail
      : (
          await tx.operatorAccount.findFirst({
            where: { operatorId, role: OperatorRole.OPERATOR_OWNER, status: AccountStatus.ACTIVE, contactEmail: { not: null } },
            orderBy: { createdAt: "asc" },
            select: { contactEmail: true },
          })
        )?.contactEmail;
  const queued = await queueNotification(tx, operatorId, {
    kind: NotificationKind.CASE_UPDATED,
    dedupKey: notice.dedupKey,
    recipientEmail: recipientEmail ?? null,
    bookingId: notice.bookingId,
    payload: { audience: notice.audience, caseCode: notice.caseCode, title: notice.title, message: notice.message },
  });
  return queued ? notice.dedupKey : null;
}
