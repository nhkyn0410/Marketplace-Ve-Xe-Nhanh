import { Module } from "@nestjs/common";
import { FoundationQueueProcessor } from "./queue/processors/foundation.processor";
import { QueueModule } from "./queue/queue.module";

@Module({
  imports: [QueueModule],
  providers: [FoundationQueueProcessor]
})
export class WorkerModule {}

