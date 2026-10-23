import type { DbTransaction, PrismaService } from "./prisma.service";

/** Chạy sổ điểm / ví của hành khách ở scope hệ thống; service luôn lọc userId lấy từ token. */
export function withPassengerLoyalty<T>(prisma: Pick<PrismaService, "withSystem">, work: (tx: DbTransaction) => Promise<T>): Promise<T> {
  return prisma.withSystem(work);
}
