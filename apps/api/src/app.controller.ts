import { Controller, Get } from "@nestjs/common";
import { ApiExtraModels, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import type { HealthResponse } from "@vexenhanh/types";
import { ZodResponse } from "nestjs-zod";
import {
  DatabaseHealthService,
  type DatabaseHealthResponse
} from "./database/database-health.service";
import { MongoHealthService, type MongoHealthResponse } from "./database/mongo-health.service";
import {
  HealthResponseDto,
  MongoHealthResponseDto,
  PostgresHealthResponseDto,
  ProblemDetailsDto,
  QueueHealthResponseDto,
  RedisHealthResponseDto
} from "./openapi/openapi.dto";
import { QueueHealthService, type QueueHealthResponse } from "./queue/queue-health.service";
import { RedisHealthService, type RedisHealthResponse } from "./redis/redis-health.service";

const problemDetailsContent = {
  "application/problem+json": {
    schema: { $ref: getSchemaPath(ProblemDetailsDto) }
  }
};

@ApiTags("health")
@ApiExtraModels(ProblemDetailsDto)
@ApiResponse({
  status: 500,
  description: "Unexpected server error.",
  content: problemDetailsContent
})
@Controller("health")
export class AppController {
  constructor(
    private readonly redisHealth: RedisHealthService,
    private readonly queueHealth: QueueHealthService,
    private readonly databaseHealth: DatabaseHealthService,
    private readonly mongoHealth: MongoHealthService
  ) {}

  @Get()
  @ZodResponse({ status: 200, description: "API liveness health check.", type: HealthResponseDto })
  health(): HealthResponse {
    return {
      status: "ok",
      service: "api",
      timestamp: new Date().toISOString()
    };
  }

  @Get("postgres")
  @ZodResponse({ status: 200, description: "PostgreSQL health check.", type: PostgresHealthResponseDto })
  @ApiResponse({
    status: 503,
    description: "PostgreSQL is unavailable.",
    content: problemDetailsContent
  })
  postgres(): Promise<DatabaseHealthResponse> {
    return this.databaseHealth.check();
  }

  @Get("mongo")
  @ZodResponse({ status: 200, description: "MongoDB audit cluster health check.", type: MongoHealthResponseDto })
  @ApiResponse({
    status: 503,
    description: "MongoDB audit cluster is unavailable.",
    content: problemDetailsContent
  })
  mongo(): Promise<MongoHealthResponse> {
    return this.mongoHealth.check();
  }

  @Get("redis")
  @ZodResponse({ status: 200, description: "Redis health check.", type: RedisHealthResponseDto })
  @ApiResponse({
    status: 503,
    description: "Redis is unavailable.",
    content: problemDetailsContent
  })
  redis(): Promise<RedisHealthResponse> {
    return this.redisHealth.check();
  }

  @Get("queues")
  @ZodResponse({ status: 200, description: "BullMQ queue health check.", type: QueueHealthResponseDto })
  @ApiResponse({
    status: 503,
    description: "BullMQ queues are unavailable.",
    content: problemDetailsContent
  })
  queues(): Promise<QueueHealthResponse> {
    return this.queueHealth.check();
  }
}
