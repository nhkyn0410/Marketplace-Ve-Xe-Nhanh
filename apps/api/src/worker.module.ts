import { Module } from "@nestjs/common";
import { SentryModule } from "@sentry/nestjs/setup";
import { AuditModule } from "./audit/audit.module";
import { AppConfigModule } from "./config/app-config.module";
import { FoundationQueueProcessor } from "./queue/processors/foundation.processor";
import { QueueModule } from "./queue/queue.module";

@Module({
  imports: [SentryModule.forRoot(), AppConfigModule, AuditModule, QueueModule],
  providers: [FoundationQueueProcessor]
})
export class WorkerModule {}
