import { randomUUID } from "node:crypto";
import type { EscrowReconciliation } from "./escrow-reconciliation";
import type { PrismaService } from "./prisma.service";

/** Tạo hoặc tiếp tục bản ghi đối soát bền vững cho tác vụ nền, kể cả khi BullMQ đã xóa kết quả cũ. */
export async function startReconciliationRecord(prisma: Pick<PrismaService, "withSystem">, runId?: string): Promise<string> {
  const id = runId ?? randomUUID();
  await prisma.withSystem((tx) => tx.reconciliationRecord.upsert({
    where: { id }, create: { id, source: "SCHEDULED", status: "RUNNING", checkpoint: "PAYMENTS", startedAt: new Date() },
    update: { status: "RUNNING", checkpoint: "PAYMENTS", startedAt: new Date(), finishedAt: null, error: null },
  }));
  return id;
}

/** Ghi mốc thanh toán đã đối chiếu trước khi kiểm tra sổ giữ hộ và kỳ chi trả. */
export async function checkpointReconciliation(prisma: Pick<PrismaService, "withSystem">, id: string, paymentResult: Record<string, number>): Promise<void> {
  await prisma.withSystem((tx) => tx.reconciliationRecord.update({ where: { id }, data: { checkpoint: "ESCROW_PAYOUT", paymentResult } }));
}

/** Lưu kết quả đối chiếu sổ giữ hộ, số kỳ chi trả và tối đa 100 sai lệch đầu tiên. */
export async function finishReconciliationRecord(prisma: Pick<PrismaService, "withSystem">, id: string, result: EscrowReconciliation): Promise<void> {
  await prisma.withSystem((tx) => tx.reconciliationRecord.update({ where: { id }, data: { ...result, status: "COMPLETED", checkpoint: "DONE", finishedAt: new Date() } }));
}

/** Ghi nhận tác vụ thất bại, không trả lỗi nội bộ hoặc dữ liệu cổng ra giao diện. */
export async function failReconciliationRecord(prisma: Pick<PrismaService, "withSystem">, id: string): Promise<void> {
  await prisma.withSystem((tx) => tx.reconciliationRecord.update({ where: { id }, data: { status: "FAILED", error: "Đối soát chưa hoàn tất; kiểm tra nhật ký vận hành rồi chạy lại.", finishedAt: new Date() } }));
}
