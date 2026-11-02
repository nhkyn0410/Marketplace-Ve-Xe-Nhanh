import { Module } from "@nestjs/common";
import { AuditModule } from "../../audit/audit.module";
import { DatabaseModule } from "../../database/database.module";
import { IamModule } from "../../iam/iam.module";
import { NotificationDispatchModule } from "../notification-dispatch.module";
import { AdminNotificationCampaignController } from "./notification-campaign.controller";
import { NotificationCampaignService } from "./notification-campaign.service";

/** Chiến dịch thông báo của Admin (TASK-NSR-003); phát tán theo lô chạy ở worker. */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule, NotificationDispatchModule],
  controllers: [AdminNotificationCampaignController],
  providers: [NotificationCampaignService],
})
export class NotificationCampaignModule {}
