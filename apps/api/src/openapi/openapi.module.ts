import { Module } from "@nestjs/common";
import { APP_INTERCEPTOR } from "@nestjs/core";
import { ZodSerializerInterceptor } from "nestjs-zod";
import { AppController } from "../app.controller";
import { APP_CONFIG } from "../config/env.config";
import { DatabaseHealthService } from "../database/database-health.service";
import { MongoHealthService } from "../database/mongo-health.service";
import { AuthController } from "../iam/auth/auth.controller";
import { AuthService } from "../iam/auth/auth.service";
import { QueueHealthService } from "../queue/queue-health.service";
import { RedisHealthService } from "../redis/redis-health.service";

@Module({
  // AuthController phải có mặt ở đây, nếu không 6 endpoint /v1/auth/* biến mất khỏi OpenAPI
  // và `gen:api-client` sinh client thiếu toàn bộ auth mà CI vẫn xanh (ADR-012).
  controllers: [AppController, AuthController],
  providers: [
    { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
    // Scan-only: chỉ cần metadata route, không cần dependency thật (không Postgres/Redis/Mongo).
    { provide: AuthService, useValue: {} },
    { provide: APP_CONFIG, useValue: { NODE_ENV: "test" } },
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
