import {
  Inject,
  Injectable,
  OnModuleDestroy,
  ServiceUnavailableException,
} from "@nestjs/common";
import type { RedisHealthResponse as SharedRedisHealthResponse } from "@vexenhanh/types";
import type Redis from "ioredis";
import { REDIS_CLIENT } from "./redis.constants";

export type RedisHealthResponse = SharedRedisHealthResponse;

@Injectable()
export class RedisHealthService implements OnModuleDestroy {
  constructor(@Inject(REDIS_CLIENT) private readonly redis: Redis) {}

  async onModuleDestroy(): Promise<void> {
    if (this.redis.status === "end") {
      return;
    }

    try {
      await this.redis.quit();
    } catch {
      this.redis.disconnect();
    }
  }

  async check(): Promise<RedisHealthResponse> {
    try {
      const pong = await this.redis.ping();

      if (pong !== "PONG") {
        throw new Error("Redis ping returned an unexpected response.");
      }

      return {
        status: "ok",
        service: "redis",
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      throw new ServiceUnavailableException("Redis is unavailable.", {
        cause: error,
      });
    }
  }
}
