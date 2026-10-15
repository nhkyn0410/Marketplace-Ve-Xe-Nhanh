import { Module } from "@nestjs/common";
import { SentryModule } from "@sentry/nestjs/setup";
import { AuditModule } from "./audit/audit.module";
import { AppConfigModule } from "./config/app-config.module";
import { APP_CONFIG } from "./config/env.config";
import { DatabaseModule } from "./database/database.module";
import { createPrivateStorage, createPublicStorage } from "./external/storage/storage.module";
import { PRIVATE_STORAGE, PUBLIC_STORAGE } from "./external/storage/storage-provider";
import { ApplicationDocumentCleanupProcessor } from "./operator-kyc/application-document-cleanup.processor";
import { SessionCleanupProcessor } from "./iam/session/session-cleanup.processor";
import { FoundationQueueProcessor } from "./queue/processors/foundation.processor";
import { QueueModule } from "./queue/queue.module";
import { VehicleImageCleanupProcessor } from "./vehicle/vehicle-image-cleanup.processor";

@Module({
  imports: [SentryModule.forRoot(), AppConfigModule, DatabaseModule, AuditModule, QueueModule],
  providers: [
    FoundationQueueProcessor,
    SessionCleanupProcessor,
    // Chỉ lấy adapter kho, không import `StorageModule`: worker không phục vụ HTTP nên không cần route dev của nó.
    { provide: PUBLIC_STORAGE, inject: [APP_CONFIG], useFactory: createPublicStorage },
    VehicleImageCleanupProcessor,
    { provide: PRIVATE_STORAGE, inject: [APP_CONFIG], useFactory: createPrivateStorage },
    ApplicationDocumentCleanupProcessor
  ]
})
export class WorkerModule {}
