import { Controller, Get } from "@nestjs/common";
import { QueueHealthService, type QueueHealthResponse } from "./queue/queue-health.service";
import { RedisHealthService, type RedisHealthResponse } from "./redis/redis-health.service";

type HealthResponse = {
  status: "ok";
  service: string;
  timestamp: string;
};

@Controller("health")
export class AppController {
  constructor(
    private readonly redisHealth: RedisHealthService,
    private readonly queueHealth: QueueHealthService
  ) {}

  @Get()
  health(): HealthResponse {
    return {
      status: "ok",
      service: "api",
      timestamp: new Date().toISOString()
    };
  }

  @Get("redis")
  redis(): Promise<RedisHealthResponse> {
    return this.redisHealth.check();
  }

  @Get("queues")
  queues(): Promise<QueueHealthResponse> {
    return this.queueHealth.check();
  }
}
