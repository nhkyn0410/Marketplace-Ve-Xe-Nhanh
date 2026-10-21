import type { DbTransaction, PrismaService } from "./prisma.service";

// Ngữ cảnh RLS cho job tài chính chạy nền (TASK-BTP-006): job không có người gọi / tenant trong token, nên tìm nhà xe cần xử lý
// ở ngữ cảnh `system` rồi chạy phần ghi ở tenant của từng nhà xe — RLS vẫn chặn đụng dữ liệu nhà xe khác. Đặt ở `database/`
// vì chỉ ở đây được chọn scope.

/** Nhà xe có bút toán escrow đã đủ điều kiện chi trả mà chưa thuộc kỳ chi trả nào (job tạo kỳ chi trả). */
export async function listOperatorsWithEligibleEntries(prisma: Pick<PrismaService, "withSystem">, now: Date): Promise<string[]> {
  const rows = await prisma.withSystem((tx) =>
    tx.$queryRaw<{ operatorId: string }[]>`
      SELECT DISTINCT e.operator_id AS "operatorId" FROM escrow_ledgers e
      LEFT JOIN trips t ON t.id = e.trip_id AND t.operator_id = e.operator_id
      WHERE COALESCE(t.payout_eligible_at, e.eligible_at) <= ${now} AND e.entry_type <> 'PAYOUT'
        AND NOT EXISTS (SELECT 1 FROM payout_items i WHERE i.ledger_entry_id = e.id)
      ORDER BY 1`,
  );
  return rows.map((row) => row.operatorId);
}

/** Chạy `work` ở tenant của một nhà xe (job nền đã biết `operatorId` từ truy vấn hệ thống ở trên). */
export async function withOperatorTenant<T>(
  prisma: Pick<PrismaService, "withTenant">,
  operatorId: string,
  work: (tx: DbTransaction) => Promise<T>,
): Promise<T> {
  return prisma.withTenant(operatorId, work);
}
