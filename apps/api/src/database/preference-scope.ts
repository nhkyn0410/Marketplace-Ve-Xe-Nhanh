import type { DbTransaction, PrismaService } from "./prisma.service";

/** Chạy truy vấn tùy chọn cá nhân sau khi service đã xác minh chủ thể từ phiên đăng nhập. */
export function withNotificationSubject<T>(prisma: Pick<PrismaService, "withSystem">, work: (tx: DbTransaction) => Promise<T>): Promise<T> {
  return prisma.withSystem(work);
}
