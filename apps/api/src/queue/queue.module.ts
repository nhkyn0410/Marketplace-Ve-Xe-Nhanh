import { BullModule } from "@nestjs/bullmq";
import { Module } from "@nestjs/common";
import { createBullMqConnectionOptions, getBullMqPrefix } from "../redis/redis.config";
import { RedisModule } from "../redis/redis.module";
import { BullBoardService } from "./bull-board.service";
import { QUEUE_NAMES } from "./queue.constants";
import { QueueHealthService } from "./queue-health.service";

@Module({
  imports: [
    RedisModule,
    BullModule.forRootAsync({
      useFactory: () => ({
        connection: createBullMqConnectionOptions("vexenhanh-bullmq"),
        defaultJobOptions: {
          attempts: 3,
          backoff: {
            type: "exponential",
            delay: 30_000
          },
          removeOnComplete: {
            age: 86_400,
            count: 1_000
          },
          removeOnFail: {
            age: 604_800,
            count: 5_000
          }
        },
        prefix: getBullMqPrefix(),
        skipWaitingForReady: true
      })
    }),
    BullModule.registerQueue({
      name: QUEUE_NAMES.foundation
    })
  ],
  providers: [BullBoardService, QueueHealthService],
  exports: [RedisModule, BullModule, BullBoardService, QueueHealthService]
})
export class QueueModule {}
