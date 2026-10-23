import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { NotificationModule } from "../external/notification/notification.module";
import { IamModule } from "../iam/iam.module";
import {
  AdminOperatorStopPointController,
  AdminSharedStopPointController,
  AdminStopPointProposalController,
} from "./admin-stop-point.controller";
import { AdminStopPointService } from "./admin-stop-point.service";
import { StopPointProposalController } from "./stop-point-proposal.controller";
import { StopPointProposalService } from "./stop-point-proposal.service";
import { StopPointController } from "./stop-point.controller";
import { StopPointService } from "./stop-point.service";

/**
 * TASK-TRN-002 — điểm đón/trả riêng + đề xuất catalog của nhà xe (DOMAIN-MAP `stop-point/`). TASK-ADM-004 — Admin
 * quản lý điểm dùng chung, duyệt đề xuất, khóa điểm riêng (ghi audit qua `AuditModule`, báo chủ nhà xe qua email).
 */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule, NotificationModule],
  controllers: [
    StopPointController,
    StopPointProposalController,
    AdminSharedStopPointController,
    AdminStopPointProposalController,
    AdminOperatorStopPointController,
  ],
  providers: [StopPointService, StopPointProposalService, AdminStopPointService],
})
export class StopPointModule {}
