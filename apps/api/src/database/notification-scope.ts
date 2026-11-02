import type { DbTransaction, PrismaService } from "./prisma.service";
import { NotificationDeliveryStatus } from "./prisma.types";

// Ngữ cảnh RLS cho worker gửi thông báo (TASK-NSR-001): job chỉ mang id bản gửi, tenant lấy từ chính bản ghi ở server. Đặt ở
// `database/` vì chỉ ở đây được chọn scope; thao tác sau đó chạy ở tenant của nhà xe sở hữu thông báo.

type ScopedPrisma = Pick<PrismaService, "withSystem" | "withTenant">;

/** Chạy `work` ở tenant của nhà xe sở hữu bản gửi; không có → `null`. */
export async function withDeliveryOperator<T>(
  prisma: ScopedPrisma,
  deliveryId: string,
  work: (tx: DbTransaction, operatorId: string | null) => Promise<T>,
): Promise<T | null> {
  const delivery = await prisma.withSystem((tx) => tx.notificationDelivery.findUnique({ where: { id: deliveryId }, select: { operatorId: true } }));
  if (!delivery) return null;
  return delivery.operatorId ? prisma.withTenant(delivery.operatorId, (tx) => work(tx, delivery.operatorId)) : prisma.withSystem((tx) => work(tx, null));
}

/** Bản gửi còn `PENDING` của các thông báo theo khoá chống trùng (gửi ngay sau commit). */
export async function pendingDeliveryIds(prisma: ScopedPrisma, dedupKeys: string[]): Promise<string[]> {
  if (dedupKeys.length === 0) {
    return [];
  }
  const rows = await prisma.withSystem((tx) =>
    tx.notificationDelivery.findMany({
      where: { status: NotificationDeliveryStatus.PENDING, notification: { dedupKey: { in: dedupKeys }, channelsPreparedAt: { not: null } } },
      select: { id: true },
    }),
  );
  return rows.map((row) => row.id);
}

/** Bản gửi `PENDING` quá `before` mà chưa gửi được (xếp hàng lỗi / mất job) — job quét gửi lại. */
export async function stalePendingDeliveryIds(prisma: ScopedPrisma, before: Date, limit: number): Promise<string[]> {
  const rows = await prisma.withSystem((tx) =>
    tx.notificationDelivery.findMany({
      where: { status: NotificationDeliveryStatus.PENDING, createdAt: { lt: before }, notification: { channelsPreparedAt: { not: null } } },
      orderBy: { createdAt: "asc" },
      take: limit,
      select: { id: true },
    }),
  );
  return rows.map((row) => row.id);
}
