import type { AuditService } from "../audit/audit.service";
import type { PrismaService } from "../database/prisma.service";
import { CaseParty, DisputeEventKind, DisputeStatus } from "../database/prisma.types";
import { listOverdueDisputes, withDisputeTenant } from "../database/support-scope";

export const DISPUTE_OVERDUE_JOB = "dispute-overdue";
/** Mỗi 15 phút (FR-DSP-05) — hạn phản hồi tính theo giờ, không cần chính xác tới phút. */
export const DISPUTE_OVERDUE_SCHEDULE = { every: 15 * 60_000 } as const;
const BATCH = 100;
const WAITING: DisputeStatus[] = [DisputeStatus.WAITING_USER_EVIDENCE, DisputeStatus.WAITING_OPERATOR_RESPONSE];

/**
 * FR-DSP-05: tranh chấp đang chờ một bên mà quá hạn phản hồi → leo thang, ghi sự kiện hệ thống (bên quá hạn) — Admin xử lý theo
 * minh chứng đang có. Đổi trạng thái có điều kiện (thao tác khác vừa đổi thì bỏ qua). Audit sau commit, best-effort. Trả số đã
 * leo thang.
 */
export async function escalateOverdueDisputes(prisma: Pick<PrismaService, "withSystem" | "withTenant">, audit: Pick<AuditService, "recordAuditEvent">, now: Date = new Date()): Promise<number> {
  let count = 0;
  for (const { id, operatorId } of await listOverdueDisputes(prisma, now, BATCH)) {
    const from = await withDisputeTenant(prisma, operatorId, async (tx) => {
      const current = await tx.disputeCase.findFirst({ where: { id, operatorId }, select: { status: true } });
      const updated = await tx.disputeCase.updateMany({ where: { id, operatorId, status: { in: WAITING }, responseDueAt: { lt: now } }, data: { status: DisputeStatus.ESCALATED } });
      if (updated.count === 0 || !current) {
        return null;
      }
      await tx.disputeEvent.create({
        data: {
          disputeId: id,
          operatorId,
          kind: DisputeEventKind.STATUS,
          party: CaseParty.SYSTEM,
          actor: "system",
          actorName: "Hệ thống",
          fromStatus: current.status,
          toStatus: DisputeStatus.ESCALATED,
          body: `Quá hạn phản hồi của ${current.status === DisputeStatus.WAITING_OPERATOR_RESPONSE ? "nhà xe" : "khách"} — xử lý theo minh chứng đang có.`,
          createdAt: now,
        },
      });
      return current.status;
    });
    if (from) {
      count++;
      await audit
        .recordAuditEvent({ actorRole: "SYSTEM", action: "dispute.overdue_escalate", targetType: "dispute_case", targetId: id, operatorId, before: { status: from }, after: { status: DisputeStatus.ESCALATED } })
        .catch(() => undefined);
    }
  }
  return count;
}
