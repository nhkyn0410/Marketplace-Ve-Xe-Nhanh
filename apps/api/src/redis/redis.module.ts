import { Module } from "@nestjs/common";
import Redis from "ioredis";
import { createRedisClientOptions, getRedisUrl } from "./redis.config";
import { REDIS_CLIENT } from "./redis.constants";
import { RedisHealthService } from "./redis-health.service";

@Module({
  providers: [
    {
      provide: REDIS_CLIENT,
      useFactory: (): Redis => new Redis(getRedisUrl(), createRedisClientOptions("vexenhanh-api"))
    },
    RedisHealthService
  ],
  exports: [REDIS_CLIENT, RedisHealthService]
})
export class RedisModule {}

