import { Module } from "@nestjs/common";
import Redis from "ioredis";
import { createRequestRedisClientOptions, getRedisUrl, REDIS_CLIENT } from "./redis.config";
import { RedisHealthService } from "./redis-health.service";

@Module({
  providers: [
    {
      provide: REDIS_CLIENT,
      useFactory: (): Redis =>
        new Redis(
          getRedisUrl(),
          createRequestRedisClientOptions("vexenhanh-api"),
        ),
    },
    RedisHealthService,
  ],
  exports: [REDIS_CLIENT, RedisHealthService],
})
export class RedisModule {}
