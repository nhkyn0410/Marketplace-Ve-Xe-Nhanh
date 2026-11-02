import { Inject, Injectable } from "@nestjs/common";
import type { NotificationInboxPage, NotificationInboxQuery } from "@vexenhanh/types";
import { withNotificationSubject } from "../database/preference-scope";
import { PrismaService } from "../database/prisma.service";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { notificationSubject } from "./preference.service";

/** Hộp thư của chính tài khoản đang đăng nhập; mọi truy vấn lọc theo chủ thể lấy từ phiên. */
@Injectable()
export class InboxService {
  constructor(@Inject(PrismaService) private readonly prisma: PrismaService) {}

  private owner(user: VerifiedAccessToken) {
    const { subjectType, subjectId } = notificationSubject(user);
    return { subjectType, subjectId };
  }

  /** Tin mới nhất trước, kèm số tin chưa đọc. */
  list(user: VerifiedAccessToken, query: NotificationInboxQuery): Promise<NotificationInboxPage> {
    const owner = this.owner(user);
    return withNotificationSubject(this.prisma, async (tx) => {
      const cursor = query.cursor ? await tx.notificationInboxMessage.findFirst({ where: { id: query.cursor, ...owner }, select: { id: true, createdAt: true } }) : null;
      const rows = await tx.notificationInboxMessage.findMany({
        where: {
          ...owner,
          ...(cursor ? { OR: [{ createdAt: { lt: cursor.createdAt } }, { createdAt: cursor.createdAt, id: { lt: cursor.id } }] } : {}),
        },
        orderBy: [{ createdAt: "desc" }, { id: "desc" }],
        take: query.limit + 1,
      });
      const page = rows.slice(0, query.limit);
      return {
        items: page.map((row) => ({
          id: row.id,
          kind: row.kind,
          title: row.title,
          body: row.body,
          linkType: row.linkType,
          linkTarget: row.linkTarget,
          createdAt: row.createdAt.toISOString(),
          readAt: row.readAt?.toISOString() ?? null,
        })),
        nextCursor: rows.length > query.limit ? page.at(-1)!.id : null,
        unreadCount: await tx.notificationInboxMessage.count({ where: { ...owner, readAt: null } }),
      };
    });
  }

  /** Số tin chưa đọc cho chuông ở Trang chủ. */
  async unreadCount(user: VerifiedAccessToken): Promise<{ unreadCount: number }> {
    const owner = this.owner(user);
    return { unreadCount: await withNotificationSubject(this.prisma, (tx) => tx.notificationInboxMessage.count({ where: { ...owner, readAt: null } })) };
  }

  /** Đánh dấu đã đọc; tin của người khác không bị ảnh hưởng và không lộ việc tồn tại. */
  async markRead(user: VerifiedAccessToken, id: string, now: Date = new Date()): Promise<void> {
    const owner = this.owner(user);
    await withNotificationSubject(this.prisma, (tx) => tx.notificationInboxMessage.updateMany({ where: { id, ...owner, readAt: null }, data: { readAt: now } }));
  }

  async markAllRead(user: VerifiedAccessToken, now: Date = new Date()): Promise<void> {
    const owner = this.owner(user);
    await withNotificationSubject(this.prisma, (tx) => tx.notificationInboxMessage.updateMany({ where: { ...owner, readAt: null }, data: { readAt: now } }));
  }
}
