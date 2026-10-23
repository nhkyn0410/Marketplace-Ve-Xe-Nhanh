import type { DbTransaction, PrismaService } from "./prisma.service";

/** Đọc dữ liệu qua nhiều nhà xe cho tài khoản hành khách đã xác thực; callback luôn lọc userId này. */
export function withPassengerData<T>(prisma: Pick<PrismaService, "withSystem">, userId: string, work: (tx: DbTransaction, userId: string) => Promise<T>): Promise<T> {
  if (!userId) throw new Error("Thiếu tài khoản hành khách.");
  return prisma.withSystem((tx) => work(tx, userId));
}
