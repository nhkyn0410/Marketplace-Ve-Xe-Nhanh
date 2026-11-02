import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { StorageModule } from "../external/storage/storage.module";
import { IamModule } from "../iam/iam.module";
import { NotificationDispatchModule } from "../notification/notification-dispatch.module";
import { AdminSupportController } from "./admin-support.controller";
import { CustomerSupportController } from "./customer-support.controller";
import { OperatorSupportController } from "./operator-support.controller";
import { SupportAttachmentService } from "./support-attachments";
import { SupportService } from "./support.service";

/** Support & Trust (DOMAIN-MAP `support/`) — TASK-TRUST-001: khiếu nại / hỗ trợ của khách, nhà xe phản hồi, Admin xử lý; tệp minh chứng. */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule, StorageModule, NotificationDispatchModule],
  controllers: [CustomerSupportController, OperatorSupportController, AdminSupportController],
  providers: [SupportService, SupportAttachmentService],
  exports: [SupportService, SupportAttachmentService],
})
export class SupportModule {}
