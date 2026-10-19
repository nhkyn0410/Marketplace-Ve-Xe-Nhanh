import type { DbTransaction, PrismaService } from "./prisma.service";
import { DisputeStatus } from "./prisma.types";

// Ngữ cảnh RLS cho job tranh chấp (TASK-TRUST-001, FR-DSP-05): quét mọi nhà xe ở scope system, mỗi tranh chấp xử lý ở tenant của
// chính nó. Đặt ở `database/` vì chỉ ở đây được chọn scope.

/** Tranh chấp đang chờ một bên phản hồi đã quá hạn. */
export async function listOverdueDisputes(prisma: Pick<PrismaService, "withSystem">, now: Date, limit: number): Promise<{ id: string; operatorId: string }[]> {
  return prisma.withSystem((tx) =>
    tx.disputeCase.findMany({
      where: { status: { in: [DisputeStatus.WAITING_USER_EVIDENCE, DisputeStatus.WAITING_OPERATOR_RESPONSE] }, responseDueAt: { lt: now } },
      orderBy: { responseDueAt: "asc" },
      take: limit,
      select: { id: true, operatorId: true },
    }),
  );
}

/** Chạy `work` ở tenant của nhà xe sở hữu tranh chấp. */
export function withDisputeTenant<T>(prisma: Pick<PrismaService, "withTenant">, operatorId: string, work: (tx: DbTransaction) => Promise<T>): Promise<T> {
  return prisma.withTenant(operatorId, work);
}
