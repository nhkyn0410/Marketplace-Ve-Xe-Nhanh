import { Module } from "@nestjs/common";
import { APP_INTERCEPTOR } from "@nestjs/core";
import { ZodSerializerInterceptor } from "nestjs-zod";
import { AppController } from "../app.controller";
import { DatabaseHealthService } from "../database/database-health.service";
import { MongoHealthService } from "../database/mongo-health.service";
import { QueueHealthService } from "../queue/queue-health.service";
import { RedisHealthService } from "../redis/redis-health.service";

@Module({
  controllers: [AppController],
  providers: [
    { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
    {
      provide: DatabaseHealthService,
      useValue: { check: () => Promise.resolve({ status: "ok", service: "postgres", timestamp: timestamp() }) }
    },
    {
      provide: MongoHealthService,
      useValue: { check: () => Promise.resolve({ status: "ok", service: "mongo", timestamp: timestamp() }) }
    },
    {
      provide: RedisHealthService,
      useValue: { check: () => Promise.resolve({ status: "ok", service: "redis", timestamp: timestamp() }) }
    },
    {
      provide: QueueHealthService,
      useValue: {
        check: () =>
          Promise.resolve({
            status: "ok",
            queues: [{ name: "foundation", counts: {} }],
            timestamp: timestamp()
          })
      }
    }
  ]
})
export class OpenApiModule {}

function timestamp(): string {
  return new Date(0).toISOString();
}
