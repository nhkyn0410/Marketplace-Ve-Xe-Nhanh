import type { PrismaService } from "../../database/prisma.service";

/**
 * Giữ row thêm 30 ngày SAU khi hết hạn rồi mới xoá. Row đã rotate/revoke là bằng chứng điều tra
 * reuse (ai, IP nào, lúc nào) — xoá ngay lúc hết hạn là xoá đúng dấu vết cần khi có sự cố.
 */
export const SESSION_RETENTION_AFTER_EXPIRY_DAYS = 30;

export const SESSION_CLEANUP_JOB = "session-cleanup";

/** 03:00 giờ VN mỗi ngày — khung ít người dùng nhất (IAM-002.9, ADR-016). */
export const SESSION_CLEANUP_SCHEDULE = { pattern: "0 3 * * *", tz: "Asia/Ho_Chi_Minh" } as const;

/** Chạy ở ngữ cảnh `system`: cron dọn xuyên mọi tenant (bảng có RLS, TASK-IAM-003). */
export async function deleteExpiredSessions(
  prisma: Pick<PrismaService, "withSystem">,
  now: Date = new Date(),
): Promise<number> {
  const cutoff = new Date(
    now.getTime() - SESSION_RETENTION_AFTER_EXPIRY_DAYS * 24 * 60 * 60 * 1000,
  );
  const { count } = await prisma.withSystem((tx) =>
    tx.authSession.deleteMany({ where: { expiresAt: { lt: cutoff } } }),
  );
  return count;
}
