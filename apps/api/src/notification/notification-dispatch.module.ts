import { Module } from "@nestjs/common";
import { DatabaseModule } from "../database/database.module";
import { QueueModule } from "../queue/queue.module";
import { NotificationDispatcher } from "./notification-dispatcher";

/** Notification (DOMAIN-MAP `notification/`) — TASK-NSR-001: xếp hàng gửi thông báo đã ghi; gửi ở worker. */
@Module({
  imports: [DatabaseModule, QueueModule],
  providers: [NotificationDispatcher],
  exports: [NotificationDispatcher],
})
export class NotificationDispatchModule {}
