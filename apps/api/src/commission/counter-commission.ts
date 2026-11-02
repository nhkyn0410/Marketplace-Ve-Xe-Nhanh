import type { DbTransaction } from "../database/prisma.service";
import { commissionOf, commissionRateAt } from "../escrow/escrow-entries";
import { assertCounterBelowOnline } from "./commission-schedule";

export type CounterCommissionSnapshot = { commissionRuleId: string | null; rateBps: number; basis: bigint; amount: bigint };

/** Chốt hoa hồng quầy theo nhà xe tại lúc thu; không cấu hình riêng dùng 0%, không lấy mức online. */
export async function resolveCounterCommission(tx: DbTransaction, operatorId: string, basis: bigint, at: Date): Promise<CounterCommissionSnapshot> {
  if (basis < 0n) throw new Error("Cơ sở tính hoa hồng không được âm.");
  // Admin cấu hình phí lấy FOR UPDATE trên cùng nhà xe: mức chốt thu không bị đổi giữa các truy vấn.
  await tx.$queryRaw`SELECT id FROM operator_profiles WHERE id = ${operatorId} FOR SHARE`;
  const rule = await tx.commissionRule.findFirst({
    where: { operatorId, channel: "COUNTER", status: "ACTIVE", effectiveFrom: { lte: at }, OR: [{ effectiveTo: null }, { effectiveTo: { gt: at } }] },
    orderBy: { effectiveFrom: "desc" },
    select: { id: true, rateBps: true },
  });
  const rateBps = rule?.rateBps ?? 0;
  if (rule) {
    const online = await commissionRateAt(tx, operatorId, at);
    assertCounterBelowOnline([
      { operatorId, channel: "ONLINE", rateBps: online, effectiveFrom: at, effectiveTo: null },
      { operatorId, channel: "COUNTER", rateBps, effectiveFrom: at, effectiveTo: null },
    ], operatorId, at);
  }
  return { commissionRuleId: rule?.id ?? null, rateBps, basis, amount: commissionOf(basis, rateBps) };
}

/** Ghi khoản phí phải thu riêng với snapshot bất biến; không tạo tiền giữ hộ hoặc chi trả cho nhà xe. */
export async function recordCounterCommission(tx: DbTransaction, input: { operatorId: string; receiptId: string; bookingId: string; basis: bigint; at: Date; snapshot?: CounterCommissionSnapshot }): Promise<CounterCommissionSnapshot> {
  const snapshot = input.snapshot ?? await resolveCounterCommission(tx, input.operatorId, input.basis, input.at);
  if (snapshot.basis !== input.basis || snapshot.basis < 0n || snapshot.amount !== commissionOf(snapshot.basis, snapshot.rateBps)) throw new Error("Snapshot hoa hồng không khớp số tiền xác nhận thu.");
  await tx.counterCommissionReceivable.create({ data: {
    operatorId: input.operatorId, receiptId: input.receiptId, bookingId: input.bookingId, ...snapshot, createdAt: input.at,
  } });
  return snapshot;
}
