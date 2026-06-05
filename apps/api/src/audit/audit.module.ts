import { Module } from "@nestjs/common";
import { MongooseModule } from "@nestjs/mongoose";
import { MongoAuditModule } from "../database/mongo-audit.module";
import { AUDIT_EVENT_MODEL, AuditEventSchema } from "./audit-event.schema";
import { AuditService } from "./audit.service";
import { SYSTEM_LOG_MODEL, SystemLogSchema } from "./system-log.schema";

@Module({
  imports: [
    MongoAuditModule,
    MongooseModule.forFeature([
      { name: AUDIT_EVENT_MODEL, schema: AuditEventSchema },
      { name: SYSTEM_LOG_MODEL, schema: SystemLogSchema }
    ])
  ],
  providers: [AuditService],
  exports: [AuditService]
})
export class AuditModule {}
