import { Module } from "@nestjs/common";
import { SentryModule } from "@sentry/nestjs/setup";
import { AuditModule } from "./audit/audit.module";
import { AppConfigModule } from "./config/app-config.module";
import { DatabaseModule } from "./database/database.module";
import { SessionCleanupProcessor } from "./iam/session/session-cleanup.processor";
import { FoundationQueueProcessor } from "./queue/processors/foundation.processor";
import { QueueModule } from "./queue/queue.module";

@Module({
  imports: [SentryModule.forRoot(), AppConfigModule, DatabaseModule, AuditModule, QueueModule],
  providers: [FoundationQueueProcessor, SessionCleanupProcessor]
})
export class WorkerModule {}
