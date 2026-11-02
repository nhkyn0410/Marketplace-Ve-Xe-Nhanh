import type { PrismaService } from "./prisma.service";

/**
 * Cộng một lượt xem cho bài đang xuất bản (TASK-CNT-001, LLD §6.10 bước 4). Đặt ở `database/` vì route công khai
 * không có scope ghi mà bảng `articles` chỉ cho platform / system ghi (RLS). Chỉ đổi đúng cột `view_count`.
 */
export async function incrementArticleViews(prisma: Pick<PrismaService, "withSystem">, articleId: string): Promise<void> {
  await prisma.withSystem((tx) =>
    tx.article.updateMany({ where: { id: articleId, status: "PUBLISHED" }, data: { viewCount: { increment: 1 } } }),
  );
}
