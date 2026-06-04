import { Controller, Get } from "@nestjs/common";
import {
  DatabaseHealthService,
  type DatabaseHealthResponse
} from "./database/database-health.service";
import { MongoHealthService, type MongoHealthResponse } from "./database/mongo-health.service";
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
    private readonly queueHealth: QueueHealthService,
    private readonly databaseHealth: DatabaseHealthService,
    private readonly mongoHealth: MongoHealthService
  ) {}

  @Get()
  health(): HealthResponse {
    return {
      status: "ok",
      service: "api",
      timestamp: new Date().toISOString()
    };
  }

  @Get("postgres")
  postgres(): Promise<DatabaseHealthResponse> {
    return this.databaseHealth.check();
  }

  @Get("mongo")
  mongo(): Promise<MongoHealthResponse> {
    return this.mongoHealth.check();
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
