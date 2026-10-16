import { Module } from "@nestjs/common";
import { DatabaseModule } from "../database/database.module";
import { MongoAuditModule } from "../database/mongo-audit.module";
import { StorageModule } from "../external/storage/storage.module";
import { IamModule } from "../iam/iam.module";
import { QueueModule } from "../queue/queue.module";
import { SystemStatusController } from "./system-status.controller";
import { SystemStatusService } from "./system-status.service";

/** Trang Tích hợp & hệ thống của Admin (DOMAIN-MAP `admin/`), chỉ đọc. */
@Module({
  imports: [DatabaseModule, MongoAuditModule, QueueModule, StorageModule, IamModule],
  controllers: [SystemStatusController],
  providers: [SystemStatusService],
})
export class AdminSystemModule {}
