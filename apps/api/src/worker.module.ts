import { Module } from "@nestjs/common";
import { AppConfigModule } from "./config/app-config.module";
import { FoundationQueueProcessor } from "./queue/processors/foundation.processor";
import { QueueModule } from "./queue/queue.module";

@Module({
  imports: [AppConfigModule, QueueModule],
  providers: [FoundationQueueProcessor]
})
export class WorkerModule {}
