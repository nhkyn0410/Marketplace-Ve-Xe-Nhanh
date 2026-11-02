import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { NotificationDispatchModule } from "../notification/notification-dispatch.module";
import { QueueModule } from "../queue/queue.module";
import { SupportModule } from "../support/support.module";
import { AdminDisputeController, CustomerDisputeController, OperatorDisputeController } from "./dispute.controller";
import { DisputeService } from "./dispute.service";

/** Support & Trust (DOMAIN-MAP `dispute/`) — TASK-TRUST-001: tranh chấp, Vé Xe Nhanh phân xử cuối (MQ-03); hoàn tiền qua hàng đợi refund. */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule, QueueModule, NotificationDispatchModule, SupportModule],
  controllers: [AdminDisputeController, OperatorDisputeController, CustomerDisputeController],
  providers: [DisputeService],
})
export class DisputeModule {}
